/* char.vala
 *
 * Copyright (C) 2009-2010  Jürg Billeter
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Author:
 * 	Jürg Billeter <j@bitron.ch>
 */

// enum values must match ICU UCharCategory enum
public enum Dova.UnicodeCategory {
	UNASSIGNED,
	UPPERCASE_LETTER,
	LOWERCASE_LETTER,
	TITLECASE_LETTER,
	MODIFIER_LETTER,
	OTHER_LETTER,
	NON_SPACING_MARK,
	ENCLOSING_MARK,
	SPACING_MARK,
	DECIMAL_NUMBER,
	LETTER_NUMBER,
	OTHER_NUMBER,
	SPACE_SEPARATOR,
	LINE_SEPARATOR,
	PARAGRAPH_SEPARATOR,
	CONTROL,
	FORMAT,
	PRIVATE_USE,
	SURROGATE,
	DASH_PUNCTUATION,
	OPEN_PUNCTUATION,
	CLOSE_PUNCTUATION,
	CONNECTOR_PUNCTUATION,
	OTHER_PUNCTUATION,
	MATH_SYMBOL,
	CURRENCY_SYMBOL,
	MODIFIER_SYMBOL,
	OTHER_SYMBOL,
	INITIAL_PUNCTUATION,
	FINAL_PUNCTUATION
}

public enum Dova.UnicodeBidiClass {
	ARABIC_LETTER,
	ARABIC_NUMBER,
	PARAGRAPH_SEPARATOR,
	BOUNDARY_NEUTRAL,
	COMMON_SEPARATOR,
	EUROPEAN_NUMBER,
	EUROPEAN_SEPARATOR,
	EUROPEAN_TERMINATOR,
	LEFT_TO_RIGHT,
	LEFT_TO_RIGHT_EMBEDDING,
	LEFT_TO_RIGHT_OVERRIDE,
	NONSPACING_MARK,
	OTHER_NEUTRAL,
	POP_DIRECTIONAL_FORMAT,
	RIGHT_TO_LEFT,
	RIGHT_TO_LEFT_EMBEDDING,
	RIGHT_TO_LEFT_OVERRIDE,
	SEGMENT_SEPARATOR,
	WHITE_SPACE
}

public enum Dova.UnicodeScript {
	ARABAIC,
	IMPERIAL_ARAMAIC,
	ARMENIAN,
	AVESTAN,
	BALINESE,
	BAMUM,
	BENGALI,
	BOPOMOFO,
	BRAILLE,
	BUGINESE,
	BUHID,
	CANADIAN_ABORIGINAL,
	CARIAN,
	CHAM,
	CHEROKEE,
	COPTIC,
	CYPRIOT,
	CYRILLIC,
	DEVANAGARI,
	DESERET,
	EGYPTIAN_HIEROGLYPHS,
	ETHIOPIC,
	GEORGIAN,
	GLAGOLITIC,
	GOTHIC,
	GREEK,
	GUJARATI,
	GURMUKHI,
	HANGUL,
	HAN,
	HANUNOO,
	HEBREW,
	HIRAGANA,
	KATAKANA_OR_HIRAGANA,
	OLD_ITALIC,
	JAVANESE,
	KAYAH_LI,
	KATAKANA,
	KHAROSHTHI,
	KHMER,
	KANNADA,
	KAITHI,
	TAI_THAM,
	LAO,
	LATIN,
	LEPCHA,
	LIMBU,
	LINEAR_B,
	LISU,
	LYCIAN,
	LYDIAN,
	MALAYALAM,
	MONGOLIAN,
	MEETEI_MAYEK,
	MYANMAR,
	NKO,
	OGHAM,
	OL_CHIKI,
	OLD_TURKIC,
	ORIYA,
	OSMANYA,
	PHAGS_PA,
	INSCRIPTIONAL_PAHLAVI,
	PHOENICIAN,
	INSCCRIPTIONAL_PARTHIAN,
	REJANG,
	RUNIC,
	SAMARITAN,
	OLD_SOUTH_ARABIAN,
	SAURASHTRA,
	SHAVIAN,
	SINHALA,
	SUNDANESE,
	SYLOTI_NAGRI,
	SYRIAC,
	TAGBANWA,
	TAI_LE,
	NEW_TAI_LUE,
	TAMIL,
	TAI_VIET,
	TELUGU,
	TIFINAGH,
	TAGALOG,
	THAANA,
	THAI,
	TIBETAN,
	UGARITIC,
	VAI,
	OLD_PERSAN,
	CUNEIFORM,
	YI,
	INHERITED,
	COMMON,
	UNKNOWN
}

[IntegerType (rank = 7, width = 32)]
public struct char {
	public UnicodeCategory category {
		get {
			ushort props = props_trie.get16 (this);
			result = (UnicodeCategory) (props & 0x1f);
		}
	}

	public bool is_number {
		get {
			switch (category) {
			case UnicodeCategory.DECIMAL_NUMBER:
			case UnicodeCategory.LETTER_NUMBER:
			case UnicodeCategory.OTHER_NUMBER:
				return true;
			default:
				return false;
			}
		}
	}

	public bool is_alpha {
		get {
			switch (category) {
			case UnicodeCategory.UPPERCASE_LETTER:
			case UnicodeCategory.LOWERCASE_LETTER:
			case UnicodeCategory.TITLECASE_LETTER:
			case UnicodeCategory.MODIFIER_LETTER:
			case UnicodeCategory.OTHER_LETTER:
			case UnicodeCategory.LETTER_NUMBER:
				return true;
			default:
				return false;
			}
		}
	}

	public bool is_alnum {
		get {
			switch (category) {
			case UnicodeCategory.UPPERCASE_LETTER:
			case UnicodeCategory.LOWERCASE_LETTER:
			case UnicodeCategory.TITLECASE_LETTER:
			case UnicodeCategory.MODIFIER_LETTER:
			case UnicodeCategory.OTHER_LETTER:
			case UnicodeCategory.DECIMAL_NUMBER:
			case UnicodeCategory.LETTER_NUMBER:
				return true;
			default:
				return false;
			}
		}
	}

	public bool is_punct {
		get {
			switch (category) {
			case UnicodeCategory.DASH_PUNCTUATION:
			case UnicodeCategory.OPEN_PUNCTUATION:
			case UnicodeCategory.CLOSE_PUNCTUATION:
			case UnicodeCategory.CONNECTOR_PUNCTUATION:
			case UnicodeCategory.OTHER_PUNCTUATION:
				return true;
			default:
				return false;
			}
		}
	}

	public bool is_space {
		get {
			switch ((char) this) {
			case '\t':
			case '\n':
			case '\x0b':
			case '\f':
			case '\r':
			case '\x85':
				return true;
			default:
				switch (category) {
				case UnicodeCategory.SPACE_SEPARATOR:
				case UnicodeCategory.LINE_SEPARATOR:
				case UnicodeCategory.PARAGRAPH_SEPARATOR:
					return true;
				default:
					return false;
				}
			}
		}
	}

	// horizontal whitespace
	public bool is_blank {
		get {
			return (this == '\t' || category == UnicodeCategory.SPACE_SEPARATOR);
		}
	}

	public bool is_xdigit {
		get {
			if ((this >= '0' && this <= '9') ||
			    (this >= 'A' && this <= 'F') ||
			    (this >= 'a' && this <= 'f')) {
				return true;
			} else {
				return false;
			}
		}
	}

	public bool is_digit { get { return category == UnicodeCategory.DECIMAL_NUMBER; } }
	public bool is_lower { get { return category == UnicodeCategory.LOWERCASE_LETTER; } }
	public bool is_upper { get { return category == UnicodeCategory.UPPERCASE_LETTER; } }
	public bool is_control { get { return category == UnicodeCategory.CONTROL; } }

	public UnicodeScript script {
		get {
			result = UnicodeScript.COMMON;
		}
	}

	public UnicodeBidiClass bidi_class {
		get {
			result = UnicodeBidiClass.LEFT_TO_RIGHT;
		}
	}

	public string to_string () {
		return string.create_from_char (this);
	}
}

// based on code from ICU
struct UTrie2 {
	ushort* index;
	uint* data32;
	int index_length;
	int data_length;
	ushort index_2_null_offset;
	ushort data_null_offset;
	uint initial_value;
	uint error_value;
	char high_start;
	int high_value_index;

	public UTrie2 (ushort* index, uint* data32, int index_length, int data_length, ushort index_2_null_offset, ushort data_null_offset, uint initial_value, uint error_value, char high_start, int high_value_index) {
		this.index = index;
		this.data32 = data32;
		this.index_length = index_length;
		this.data_length = data_length;
		this.index_2_null_offset = index_2_null_offset;
		this.data_null_offset = data_null_offset;
		this.initial_value = initial_value;
		this.error_value = error_value;
		this.high_start = high_start;
		this.high_value_index = high_value_index;
	}

	const int SHIFT_1 = 6 + 5;
	const int SHIFT_2 = 5;
	const int SHIFT_1_2 = SHIFT_1 - SHIFT_2;
	const int OMITTED_BMP_INDEX_1_LENGTH = 0x10000 >> SHIFT_1;
	const int INDEX_2_BLOCK_LENGTH = 1 << SHIFT_1_2;
	const int INDEX_2_MASK = INDEX_2_BLOCK_LENGTH - 1;
	const int DATA_BLOCK_LENGTH = 1 << SHIFT_2;
	const int DATA_MASK = DATA_BLOCK_LENGTH - 1;
	const int INDEX_SHIFT = 2;
	const int LSCP_INDEX_2_OFFSET = 0x10000 >> SHIFT_2;
	const int LSCP_INDEX_2_LENGTH = 0x400 >> SHIFT_2;
	const int INDEX_2_BMP_LENGTH = LSCP_INDEX_2_OFFSET + LSCP_INDEX_2_LENGTH;
	const int UTF8_2B_INDEX_2_OFFSET = INDEX_2_BMP_LENGTH;
	const int UTF8_2B_INDEX_2_LENGTH = 0x800 >> 6;
	const int INDEX_1_OFFSET = UTF8_2B_INDEX_2_OFFSET + UTF8_2B_INDEX_2_LENGTH;
	const int BAD_UTF8_DATA_OFFSET = 0x80;

	int index_raw (int offset, ushort* trie_index, char c) {
		return (int) ((trie_index[offset + c >> SHIFT_2] << INDEX_SHIFT) + (c & DATA_MASK));
	}

	int index_from_supp (ushort* trie_index, char c) {
		return (int) ((trie_index[trie_index[INDEX_1_OFFSET - OMITTED_BMP_INDEX_1_LENGTH + (c >> SHIFT_1)] + ((c >> SHIFT_2) & INDEX_2_MASK)] << INDEX_SHIFT) + (c & DATA_MASK));
	}

	int index_from_cp (int ascii_offset, char c) {
		if (c < 0xd800) {
			return index_raw (0, index, c);
		} else if (c <= 0xffff) {
			return index_raw (c <= 0xdbff ? LSCP_INDEX_2_OFFSET - (0xd800 >> SHIFT_2) : 0, index, c);
		} else if (c > 0x10ffff) {
			return ascii_offset + BAD_UTF8_DATA_OFFSET;
		} else if (c >= high_start) {
			return high_value_index;
		} else {
			return index_from_supp (index, c);
		}
	}

	public ushort get16 (char c) {
		return index[index_from_cp (index_length, c)];
	}

	public uint get32 (char c) {
		return data32[index_from_cp (0, c)];
	}
}
