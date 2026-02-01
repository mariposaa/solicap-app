/**
 * SOLICAP Cloud Functions
 * Challenge tamamlandığında ödül dağıtımı (istatistik, liderlik puanı, elmas)
 * Client'tan başka kullanıcıya yazma izni olmadığı için bu işlem sunucuda yapılıyor.
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

// Sabitler (lib/services/challenge_service.dart ile aynı)
const WINNER_REWARD = 15;      // Kazanan elmas
const DRAW_REWARD = 5;         // Beraberlik elmas
const WIN_POINTS = 10;        // Challenge puanı (kazanan)
const LOSE_POINTS = 10;       // Challenge puanı kaybı (kaybeden)
const WINNER_APP_POINTS = 20; // Uygulama puanı (kazanan)
const LOSER_APP_POINTS = 10;  // Uygulama puanı (kaybeden)

/**
 * user_dna'dan gradeLevel, targetExam, level ile gradeGroup string hesapla
 * (elementary | highSchool | university)
 */
function getGradeGroup(gradeLevel, targetExam, level) {
  if (level && String(level).toLowerCase() === "university") return "university";
  if (targetExam) {
    const e = String(targetExam).toLowerCase();
    if (e.includes("ilkokul") || e.includes("ortaokul")) return "elementary";
    if (e.includes("kpss") || e.includes("ales") || e.includes("dgs") ||
        e.includes("tus") || e.includes("dus") || e.includes("lisansüstü") ||
        e.includes("üniversite düzeyi")) return "university";
    if (e.includes("lise düzeyi") || e.includes("lise") || e.includes("yks")) return "highSchool";
    if (e.includes("lgs")) return "elementary";
  }
  if (gradeLevel) {
    const g = String(gradeLevel).toLowerCase();
    const m = g.match(/(\d+)/);
    if (m) {
      const grade = parseInt(m[1], 10) || 9;
      return grade <= 8 ? "elementary" : "highSchool";
    }
    if (g.includes("üniversite") || g.includes("lisans") || g.includes("yüksek lisans") || g.includes("doktora")) return "university";
    if (g.includes("mezun")) return "highSchool";
  }
  return "highSchool";
}

/** Pazartesi başlangıçlı hafta string (YYYY-MM-DD) */
function getWeekStart() {
  const now = new Date();
  const day = now.getDay();
  const diff = now.getDate() - day + (day === 0 ? -6 : 1);
  const monday = new Date(now);
  monday.setDate(diff);
  const y = monday.getFullYear();
  const mo = String(monday.getMonth() + 1).padStart(2, "0");
  const da = String(monday.getDate()).padStart(2, "0");
  return `${y}-${mo}-${da}`;
}

/**
 * Challenge dokümanı status=completed olduğunda tetiklenir.
 * Ödülleri dağıtır: user_challenge_stats, leaderboard entries, user_points (elmas).
 */
exports.onChallengeCompleted = functions.firestore
  .document("challenges/{challengeId}")
  .onUpdate(async (change, context) => {
    const after = change.after.data();
    const before = change.before.data();
    if (after.status !== "completed" || before.status === "completed") return;

    const challengeId = context.params.challengeId;
    const p1 = after.player1 || {};
    const p2 = after.player2 || {};
    const winnerId = after.winnerId || null;
    const isDraw = after.isDraw === true;
    const p1Id = p1.userId;
    const p2Id = p2.userId;
    if (!p1Id || !p2Id) {
      functions.logger.warn("onChallengeCompleted: missing player ids", { challengeId });
      return;
    }

    try {
      if (isDraw) {
        await addDiamonds(p1Id, DRAW_REWARD);
        await addDiamonds(p2Id, DRAW_REWARD);
        await updateStats(p1Id, { isDraw: true });
        await updateStats(p2Id, { isDraw: true });
      } else {
        const loserId = winnerId === p1Id ? p2Id : p1Id;
        await addDiamonds(winnerId, WINNER_REWARD);
        await updateStats(winnerId, { isWin: true });
        await updateStats(loserId, { isLoss: true });
        await updateLeaderboardForUser(winnerId, WINNER_APP_POINTS);
        await updateLeaderboardForUser(loserId, LOSER_APP_POINTS);
      }
      functions.logger.info("Challenge ödülleri dağıtıldı", { challengeId, winnerId: winnerId || "draw" });
    } catch (err) {
      functions.logger.error("onChallengeCompleted hata", { challengeId, error: err.message });
      throw err;
    }
  });

async function addDiamonds(userId, amount) {
  const ref = db.collection("user_points").doc(userId);
  await db.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    const current = snap.exists ? (snap.data().balance || 0) : 0;
    const totalEarned = snap.exists ? (snap.data().totalEarned || 0) : 0;
    if (snap.exists) {
      tx.update(ref, { balance: current + amount, totalEarned: totalEarned + amount });
    } else {
      tx.set(ref, { balance: amount, totalEarned: amount });
    }
  });
}

async function updateStats(userId, { isWin, isLoss, isDraw }) {
  const ref = db.collection("user_challenge_stats").doc(userId);
  const pointsDelta = isWin ? WIN_POINTS : (isLoss ? -LOSE_POINTS : 0);
  await db.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    if (!snap.exists) {
      tx.set(ref, {
        challengePoints: pointsDelta,
        totalMatches: 1,
        wins: isWin ? 1 : 0,
        losses: isLoss ? 1 : 0,
        draws: isDraw ? 1 : 0,
        currentWinStreak: isWin ? 1 : 0,
        bestWinStreak: isWin ? 1 : 0,
        lastMatchAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      return;
    }
    const d = snap.data();
    const currentStreak = d.currentWinStreak || 0;
    const bestStreak = d.bestWinStreak || 0;
    const newStreak = isWin ? currentStreak + 1 : 0;
    const newBest = Math.max(newStreak, bestStreak);
    tx.update(ref, {
      challengePoints: admin.firestore.FieldValue.increment(pointsDelta),
      totalMatches: admin.firestore.FieldValue.increment(1),
      wins: admin.firestore.FieldValue.increment(isWin ? 1 : 0),
      losses: admin.firestore.FieldValue.increment(isLoss ? 1 : 0),
      draws: admin.firestore.FieldValue.increment(isDraw ? 1 : 0),
      currentWinStreak: newStreak,
      bestWinStreak: newBest,
      lastMatchAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  });
}

async function updateLeaderboardForUser(targetUserId, points) {
  const dnaSnap = await db.collection("user_dna").doc(targetUserId).get();
  const data = dnaSnap.exists ? dnaSnap.data() : {};
  const displayName = data.userName || "Öğrenci";
  const gradeGroup = getGradeGroup(data.gradeLevel, data.targetExam, data.level);
  const weekStart = getWeekStart();

  const allTimeRef = db.collection("leaderboard/allTime/entries").doc(targetUserId);
  const weeklyRef = db.collection("leaderboard/weekly/entries").doc(targetUserId);

  await db.runTransaction(async (tx) => {
    const allSnap = await tx.get(allTimeRef);
    const weekSnap = await tx.get(weeklyRef);
    const currentAll = allSnap.exists ? (allSnap.data().points || 0) : 0;
    const currentWeek = weekSnap.exists ? (weekSnap.data().points || 0) : 0;
    const existingWeekStart = weekSnap.exists ? weekSnap.data().weekStart : null;
    const newAll = currentAll + points;
    let newWeek = currentWeek + points;
    if (existingWeekStart !== weekStart) newWeek = points;

    if (allSnap.exists) {
      tx.update(allTimeRef, {
        displayName,
        gradeGroup,
        points: newAll,
        lastUpdate: admin.firestore.FieldValue.serverTimestamp(),
      });
    } else {
      tx.set(allTimeRef, {
        displayName,
        gradeGroup,
        points: newAll,
        lastUpdate: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
    if (weekSnap.exists && existingWeekStart === weekStart) {
      tx.update(weeklyRef, {
        displayName,
        gradeGroup,
        points: newWeek,
        weekStart,
        lastUpdate: admin.firestore.FieldValue.serverTimestamp(),
      });
    } else {
      tx.set(weeklyRef, {
        displayName,
        gradeGroup,
        points: newWeek,
        weekStart,
        lastUpdate: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
  });
}

// ─── Kütüphane Arkadaşın Olacak: havuz girişinde sunucu tarafında eşleşme ───
const POOL_COLLECTION = "library_buddy_pool";
const MATCHES_COLLECTION = "library_buddy_matches";

/** Ortak kriteri olan diğer kullanıcılarla eşleşme oluştur (create/update ortak mantık). */
async function runLibraryBuddyMatching(userId, data) {
  const displayName = data.displayName || "Anonim";
  const criteria = Array.isArray(data.criteria) ? data.criteria : [];
  if (criteria.length === 0) return;

  const criteriaQuery = criteria.slice(0, 10);
  const poolSnap = await db.collection(POOL_COLLECTION)
    .where("criteria", "array-contains-any", criteriaQuery)
    .get();

  const others = poolSnap.docs.filter((d) => d.id !== userId);
  if (others.length === 0) return;

  const [asUser1, asUser2] = await Promise.all([
    db.collection(MATCHES_COLLECTION).where("user1Id", "==", userId).get(),
    db.collection(MATCHES_COLLECTION).where("user2Id", "==", userId).get(),
  ]);
  const existingPartnerIds = new Set();
  asUser1.docs.forEach((d) => existingPartnerIds.add(d.data().user2Id));
  asUser2.docs.forEach((d) => existingPartnerIds.add(d.data().user1Id));

  const now = new Date();
  const nowTs = admin.firestore.Timestamp.fromDate(now);
  let created = 0;

  for (const doc of others) {
    const otherId = doc.id;
    if (existingPartnerIds.has(otherId)) continue;

    const otherData = doc.data();
    const otherCriteria = Array.isArray(otherData.criteria) ? otherData.criteria : [];
    const common = criteria.filter((c) => otherCriteria.includes(c));
    if (common.length === 0) continue;

    const otherName = otherData.displayName || "Anonim";
    await db.collection(MATCHES_COLLECTION).add({
      user1Id: userId,
      user2Id: otherId,
      user1Name: displayName,
      user2Name: otherName,
      criteria: common,
      createdAt: nowTs,
      user1LastSeenAt: nowTs,
      user2LastSeenAt: nowTs,
    });
    existingPartnerIds.add(otherId);
    created++;
  }

  if (created > 0) {
    functions.logger.info("Library buddy eşleşmeler oluşturuldu", { userId, created });
  }
}

exports.onLibraryBuddyPoolCreated = functions.firestore
  .document(`${POOL_COLLECTION}/{userId}`)
  .onCreate(async (snap, context) => {
    const userId = context.params.userId;
    const data = snap.data();
    try {
      await runLibraryBuddyMatching(userId, data);
    } catch (err) {
      functions.logger.error("onLibraryBuddyPoolCreated hata", { userId, error: err.message });
      throw err;
    }
  });

exports.onLibraryBuddyPoolUpdated = functions.firestore
  .document(`${POOL_COLLECTION}/{userId}`)
  .onUpdate(async (change, context) => {
    const userId = context.params.userId;
    const data = change.after.data();
    try {
      await runLibraryBuddyMatching(userId, data);
    } catch (err) {
      functions.logger.error("onLibraryBuddyPoolUpdated hata", { userId, error: err.message });
      throw err;
    }
  });
