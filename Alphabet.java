import java.util.ArrayList;
import java.util.HashSet;
import java.net.URLEncoder;

public class Alphabet {

	private ArrayList<Alphabet.Letter> letters = null;

	public static void main(String[] args) {

		try {
			Alphabet alphabet = new Alphabet();

			System.out.println("# This alphabet is generated automatically");
			System.out.println("# Changes need to be made in Alphabet.java");
			System.out.println(alphabet);
		} catch (Letter.NonLowerCaseLetterException e) {
			// Using System.*.println for logging, out of a reason... ;-)
			System.err.println("[ERROR] Make sure the alphabet class only contains a lower case alphabet.");
			System.exit(1);
		}

	}

	public Alphabet() throws Letter.NonLowerCaseLetterException {
		this.letters = new ArrayList<>();

		// Adding spicial characters to the alphabet
		this.letters.add(new Letter("dollar", '$'));
		this.letters.add(new Letter("curly_open", '{'));
		this.letters.add(new Letter("colon", ':'));
		this.letters.add(new Letter("slash", '/'));

		// Adding all literals to the alphabet
		char[] literals = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
				's', 't', 'u', 'v', 'w', 'x', 'y', 'z' };
		for (int i = 0; i < literals.length; ++i) {
			Letter letter = new Letter(literals[i], literals[i]);
			this.letters.add(letter);
		}
	}

	public String toString() {
		StringBuilder sb = null;

		for (Letter letter : this.letters) {
			if (sb != null) {
				sb.append(System.lineSeparator());
			} else {
				sb = new StringBuilder();
			}

			sb.append(letter.toString());

		}

		if (sb != null) {
			return sb.toString();
		} else {
			return "";
		}
	}

	private class Letter {

		private String myName;
		private char myChar;
		private ArrayList<Integer> codePoints = null;

		public Letter(char name, char c) throws NonLowerCaseLetterException {
			this(String.valueOf(name), c);
		}

		public Letter(String name, char c) throws NonLowerCaseLetterException {
			if (c == Character.toLowerCase(c)) {
				myName = name;
				myChar = c;

				initCodePoints();
			} else {
				throw new NonLowerCaseLetterException();
			}
		}

		public String toString() {
			StringBuilder sb = new StringBuilder();

			sb.append(this.myName + "='(?:");
			sb.append(regExPlainLetter());
			sb.append("|");
			sb.append(regExUrlEncoded());
			sb.append("|");
			sb.append(regExUnicodeOctal());
			sb.append(")'");

			return sb.toString();
		}

		private String regExPlainLetter() {
			StringBuilder sb = null;
			for (Integer codePoint : this.codePoints) {
				if (sb == null) {
					sb = new StringBuilder();
				}

				String hex = Integer.toHexString(codePoint);
				String str = String.valueOf((char) (int) codePoint);
				if (str.matches("[a-z0-9]")) {
					sb.append(str);
				} else if (str.matches("[A-Z]")) {
					// We only add the lower case version and make the RegEx case insensitive (?i)
				} else if (hex.length() == 2) {
					sb.append("\\x" + hex);
				} else {
					sb.append("\\x{" + hex + "}");
				}
			}

			if (sb != null) {
				String str = sb.toString();
				if (str.length() > 1) {
					return "[" + str + "]";
				} else {
					return str;
				}
			} else {
				return "";
			}
		}

		private String regExUrlEncoded() {
			StringBuilder sb = null;

			for (Integer codePoint : this.codePoints) {
				if (sb != null) {
					sb.append("|");
				} else {
					sb = new StringBuilder();
				}

				String encoded;

				if (codePoint <= 255) {
					// For UTF-8 just encode as hex
					encoded = Integer.toHexString(codePoint);
				} else {
					// Handle UTF-16
					char ch = (char) (int) codePoint;
					String st = String.valueOf(ch);
					try {
						encoded = URLEncoder.encode(st, "UTF-8").substring(1);
						encoded = encoded.replace("%", "%(?:25%?)*");
					} catch (java.io.UnsupportedEncodingException e) {
						throw new AssertionError("UTF-8 is unknown");
					}
				}

				sb.append(encoded);
			}

			if (sb != null) {
				String str = sb.toString();
				if (str.split("\\|", 2).length == 1) {
					return "%(?:25%?)*" + str;
				} else {
					return "%(?:25%?)*(?:" + str + ")";
				}
			} else {
				return "";
			}
		}

		private String regExUnicodeOctal() {
			HashSet<String> list = new HashSet<>();

			for (int codePoint : this.codePoints) {
				String hex = Integer.toOctalString(codePoint);
				list.add(hex);
			}

			StringBuilder sb = new StringBuilder();
			sb.append("\\\\u?0*(?:");
			sb.append(String.join("|", list));
			sb.append(")");

			return sb.toString();
		}

		private void initCodePoints() {
			this.codePoints = new ArrayList<>();

			// Iterate over all Unicode code points from 0000 ... ffff
			for (int codePoint = 0; codePoint <= 65535; ++codePoint) {
				char literal = Character.toChars(codePoint)[0];
				char literalUpper = Character.toUpperCase(literal);

				if (Character.toLowerCase(literal) == this.myChar
						|| Character.toLowerCase(literalUpper) == this.myChar) {
					this.codePoints.add(codePoint);
				}
			}
		}

		public static class NonLowerCaseLetterException extends Exception {

		}
	}

}
