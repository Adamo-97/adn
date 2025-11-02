import json
import os
import re
from pathlib import Path
from typing import Dict, List, Any

def has_arabic(text: str) -> bool:
    """Check if text contains Arabic characters."""
    return bool(re.search(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]', text))

def is_quran_verse(text: str) -> bool:
    """Check if text is a Quranic verse (contains ﴿ and ﴾ brackets)."""
    return '﴿' in text and '﴾' in text

def extract_quran_segments(text: str) -> List[Dict[str, Any]]:
    """
    Extract all Quranic verses and surrounding text from a string.
    Returns a list of segments with type and content.
    """
    segments = []
    last_end = 0
    
    # Find all Quran verses with brackets
    for match in re.finditer(r'﴿([^﴾]+)﴾', text):
        start, end = match.span()
        
        # Add text before the verse
        if start > last_end:
            before_text = text[last_end:start].strip()
            if before_text:
                # Check if this text contains non-Quranic Arabic
                if has_arabic(before_text):
                    segments.append({"type": "arabic_text", "text": before_text, "font": "Noto Kufi Arabic"})
                else:
                    segments.append({"type": "english_text", "text": before_text})
        
        # Add the Quran verse
        verse_arabic = match.group(1).strip()
        segments.append({"type": "quran_verse", "text": verse_arabic, "font": "Amiri Quran"})
        
        last_end = end
    
    # Add remaining text after last verse
    if last_end < len(text):
        after_text = text[last_end:].strip()
        if after_text:
            # Check if this text contains non-Quranic Arabic
            if has_arabic(after_text):
                segments.append({"type": "arabic_text", "text": after_text, "font": "Noto Kufi Arabic"})
            else:
                # This is likely the English translation
                segments.append({"type": "english_text", "text": after_text})
    
    return segments

def split_arabic_english(text: str) -> List[Dict[str, Any]]:
    """
    Split text with mixed Arabic and English into segments.
    This handles cases where Arabic text (non-Quranic) is mixed with English.
    """
    segments = []
    current_segment = ""
    current_type = None
    
    for char in text:
        is_arabic_char = bool(re.match(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]', char))
        
        if is_arabic_char:
            # Switch to Arabic segment
            if current_type != "arabic":
                if current_segment:
                    segments.append({"type": "english_text", "text": current_segment})
                current_segment = char
                current_type = "arabic"
            else:
                current_segment += char
        else:
            # Switch to English segment
            if current_type == "arabic":
                if current_segment:
                    segments.append({"type": "arabic_text", "text": current_segment, "font": "Noto Kufi Arabic"})
                current_segment = char
                current_type = "english"
            else:
                current_segment += char
                if current_type is None:
                    current_type = "english"
    
    # Add last segment
    if current_segment:
        if current_type == "arabic":
            segments.append({"type": "arabic_text", "text": current_segment, "font": "Noto Kufi Arabic"})
        else:
            segments.append({"type": "english_text", "text": current_segment})
    
    return segments

def format_text_segments(text: str) -> Dict[str, Any]:
    """
    Process text and return formatted structure with proper font assignment.
    """
    if not has_arabic(text):
        return {"type": "plain", "text": text}
    
    # If it contains Quran verses
    if is_quran_verse(text):
        segments = extract_quran_segments(text)
        return {"type": "formatted", "segments": segments}
    
    # If it contains Arabic but not Quran verses (hadith, duas, etc.)
    if has_arabic(text):
        segments = split_arabic_english(text)
        # Only return formatted if we actually have multiple segments
        if len(segments) > 1 or (len(segments) == 1 and segments[0]["type"] == "arabic_text"):
            return {"type": "formatted", "segments": segments}
    
    return {"type": "plain", "text": text}

def fix_unsupported_chars(text: str) -> str:
    """
    Replace unsupported characters that don't render well.
    Focus on special characters in English text.
    """
    replacements = {
        'Fātiḥah': 'Fatihah',
        'Fāti ḥah': 'Fatihah',
        'ḥ': 'h',
        'Ḥ': 'H',
        'ṣ': 's',
        'Ṣ': 'S',
        'ṭ': 't',
        'Ṭ': 'T',
        'ḍ': 'd',
        'Ḍ': 'D',
        'ẓ': 'z',
        'Ẓ': 'Z',
        'ā': 'a',
        'Ā': 'A',
        'ī': 'i',
        'Ī': 'I',
        'ū': 'u',
        'Ū': 'U',
        'ʿ': "'",
        'ʾ': "'",
        'Muḥammad': 'Muhammad',
        'Qurʾān': 'Quran',
        'Sūrat': 'Surat',
        'Sūrah': 'Surah',
        'rakʿah': 'rakah',
        'Ḥajj': 'Hajj',
        'Janāba': 'Janaba',
        'Janāzah': 'Janazah',
        'Ṣalāh': 'Salah',
        'ṣalāh': 'salah',
        'Ṣalah': 'Salah',
        'takbīr': 'takbir',
        'Takbīr': 'Takbir',
        'Kaʿbah': 'Kabah',
        'Baitullāh': 'Baitullah',
        'tawāf': 'tawaf',
        'Kāfirūn': 'Kafirun',
        'Ikhlāṣ': 'Ikhlas',
        'Aḥmad': 'Ahmad',
        'Dāwūd': 'Dawud',
        'Tirmidhī': 'Tirmidhi',
    }
    
    for old, new in replacements.items():
        text = text.replace(old, new)
    
    return text

def process_json_file(filepath: Path, dry_run: bool = False) -> bool:
    """Process a single JSON file and update it with proper formatting."""
    print(f"\nProcessing: {filepath.name}")
    
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    changes_made = False
    
    # Process each section
    for section in data.get('sections', []):
        # Process paragraph text
        if section.get('type') == 'paragraph' and 'text' in section:
            original_text = section['text']
            
            # Fix unsupported characters in English text
            fixed_text = fix_unsupported_chars(original_text)
            
            # Format with proper font assignment
            formatted = format_text_segments(fixed_text)
            
            if formatted['type'] == 'formatted':
                section['formatted_text'] = formatted['segments']
                section['text'] = fixed_text  # Keep original for backwards compatibility
                changes_made = True
                print(f"  ✓ Formatted paragraph")
            elif fixed_text != original_text:
                section['text'] = fixed_text
                changes_made = True
                print(f"  ✓ Fixed special characters")
        
        # Process list items
        if section.get('type') == 'list' and 'items' in section:
            new_items = []
            for item in section['items']:
                original_item = item
                
                # Fix unsupported characters
                fixed_item = fix_unsupported_chars(item)
                
                # Format with proper font assignment
                formatted = format_text_segments(fixed_item)
                
                if formatted['type'] == 'formatted':
                    new_items.append({
                        "text": fixed_item,
                        "formatted_text": formatted['segments']
                    })
                    changes_made = True
                    print(f"  ✓ Formatted list item")
                elif fixed_item != original_item:
                    new_items.append(fixed_item)
                    changes_made = True
                    print(f"  ✓ Fixed list item characters")
                else:
                    new_items.append(item)
            
            section['items'] = new_items
    
    if changes_made and not dry_run:
        # Save the updated file
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"  ✓ Saved changes to {filepath.name}")
    elif not changes_made:
        print(f"  - No changes needed")
    
    return changes_made

# Main execution
if __name__ == "__main__":
    import sys
    
    dry_run = '--dry-run' in sys.argv
    
    json_dir = Path(r'd:\2-Athan app\code\app\assets\data\info_pages\en')
    json_files = list(json_dir.glob('*.json'))
    
    print(f"Found {len(json_files)} JSON files to process")
    if dry_run:
        print("*** DRY RUN MODE - No files will be modified ***")
    print("=" * 80)
    
    files_modified = []
    for json_file in sorted(json_files):
        if process_json_file(json_file, dry_run=dry_run):
            files_modified.append(json_file.name)
    
    print("\n" + "=" * 80)
    print(f"\nSummary: {len(files_modified)} files modified:")
    for filename in files_modified:
        print(f"  - {filename}")
    
    if dry_run:
        print("\n*** DRY RUN COMPLETE - Run without --dry-run to apply changes ***")
