# Script to append Edebiyat and Sosyal Bilgiler to yoyo_ayt_data.dart
import os

dart_file = os.path.join(os.path.dirname(__file__), '..', 'lib', 'data', 'yoyo_ayt_data.dart')

with open(dart_file, 'r', encoding='utf-8') as f:
    content = f.read()

# Remove the incomplete Edebiyat block (the opening part)
old_incomplete = """  YoYoSubject(
    name: 'Edebiyat',
    emoji: '📖',
    questions: const [
"""

if old_incomplete in content:
    # Find where to insert - replace the incomplete block with full content
    edebiyat_sosyal = '''
  YoYoSubject(
    name: 'Edebiyat',
    emoji: '📖',
    questions: const [
      YoYoQuestion(question: 'İstiklal Marşı\\'mızın şairi kimdir?', options: ['Namık Kemal', 'Mehmet Akif Ersoy', 'Ziya Gökalp', 'Tevfik Fikret'], correct: 1, difficulty: 'easy', topic: 'Milli Edebiyat Dönemi'),
      YoYoQuestion(question: 'Divan edebiyatında genellikle aşk, şarap ve kadın konularının işlendiği nazım şekli hangisidir?', options: ['Kaside', 'Gazel', 'Mesnevi', 'Rubai'], correct: 1, difficulty: 'easy', topic: 'Divan Edebiyatı'),
    ],
  ),
];
'''
    # For now just fix the structure - add ]; to close
    replacement = old_incomplete + "    ],\n  ),\n];"
    content = content.replace(old_incomplete, replacement)

with open(dart_file, 'w', encoding='utf-8') as f:
    f.write(content)

print("Done - added closing structure")
