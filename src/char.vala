/* char.vala
 *
 * Copyright (C) 2009  Jürg Billeter
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

public enum Dova.UnicodeCategory {
	CONTROL,
	FORMAT,
	UNASSIGNED,
	PRIVATE_USE,
	SURROGATE,
	LOWERCASE_LETTER,
	MODIFIER_LETTER,
	OTHER_LETTER,
	TITLECASE_LETTER,
	UPPERCASE_LETTER,
	SPACING_MARK,
	ENCLOSING_MARK,
	NONSPACING_MARK,
	DECIMAL_NUMBER,
	LETTER_NUMBER,
	OTHER_NUMBER,
	CONNECTOR_PUNCTUATION,
	DASH_PUNCTUATION,
	CLOSE_PUNCTUATION,
	FINAL_PUNCTUATION,
	INITIAL_PUNCTUATION,
	OTHER_PUNCTUATION,
	OPEN_PUNCTUATION,
	CURRENCY_SYMBOL,
	MODIFIER_SYMBOL,
	MATH_SYMBOL,
	OTHER_SYMBOL,
	LINE_SEPARATOR,
	PARAGRAPH_SEPARATOR,
	SPACE_SEPARATOR
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
			result = UnicodeCategory.UNASSIGNED;
		}
	}

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
}

