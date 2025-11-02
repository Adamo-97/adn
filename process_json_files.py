import json
import os
import re
from pathlib import Path

def has_arabic(text):
    """Check if text contains Arabic characters."""
    return bool(re.search(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]', text))

def is_quran_verse(text):
    """Check if text is a Quranic verse (contains ﴿ and ﴾ brackets)."""
    return '﴿' in text and '﴾' in text

def extract_quran_verse(text):
    """Extract Quranic verse from text with brackets."""
    match = re.search(r'﴿([^﴾]+)﴾', text)
    if match:
        return match.group(1)
    return None

def format_text_with_arabic(text):
    """
    Format text containing both Arabic and English.
    Returns a dict with formatting instructions.
    """
    if not has_arabic(text):
        return {"type": "plain", "text": text}
    
    # Check if it's a Quranic verse
    if is_quran_verse(text):
        verse = extract_quran_verse(text)
        if verse:
            # Split into verse and translation
            parts = text.split('﴾')
            if len(parts) > 1:
                arabic_part = '﴿' + verse + '﴾'
                translation = parts[1].strip()
                return {
                    "type": "quran_with_translation",
                    "arabic": verse,  # Just the verse without brackets
                    "translation": translation
                }
            else:
                return {
                    "type": "quran_only",
                    "arabic": verse
                }
    
    # Check for other Arabic text (duas, hadith, etc.)
    # This is more complex - we need to separate Arabic from English
    # For now, if it contains Arabic but not Quran brackets, treat as Arabic text
    if has_arabic(text) and not is_quran_verse(text):
        # Try to separate Arabic and English parts
        # This is a simplified approach
        return {
            "type": "mixed_arabic",
            "text": text
        }
    
    return {"type": "plain", "text": text}

def process_json_file(filepath):
    """Process a single JSON file and add formatting metadata."""
    print(f"\nProcessing: {filepath.name}")
    
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    changes_made = False
    
    # Process each section
    for section in data.get('sections', []):
        # Process paragraph text
        if section.get('type') == 'paragraph' and 'text' in section:
            text = section['text']
            formatted = format_text_with_arabic(text)
            
            if formatted['type'] != 'plain':
                print(f"  Found formatted text: {formatted['type']}")
                print(f"    Preview: {text[:100]}...")
                changes_made = True
        
        # Process list items
        if section.get('type') == 'list' and 'items' in section:
            for item in section['items']:
                formatted = format_text_with_arabic(item)
                if formatted['type'] != 'plain':
                    print(f"  Found formatted list item: {formatted['type']}")
                    print(f"    Preview: {item[:100]}...")
                    changes_made = True
    
    if not changes_made:
        print(f"  No Arabic text found")
    
    return changes_made

# Main execution
json_dir = Path(r'd:\2-Athan app\code\app\assets\data\info_pages\en')
json_files = list(json_dir.glob('*.json'))

print(f"Found {len(json_files)} JSON files to process\n")
print("=" * 80)

files_with_arabic = []
for json_file in sorted(json_files):
    if process_json_file(json_file):
        files_with_arabic.append(json_file.name)

print("\n" + "=" * 80)
print(f"\nSummary: {len(files_with_arabic)} files contain Arabic text:")
for filename in files_with_arabic:
    print(f"  - {filename}")
