package dz.eduquiz.util;

import java.util.regex.Pattern;

public class ValidationUtil {

	private static final Pattern EMAIL_PATTERN = Pattern
			.compile("^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$");

	private static final Pattern USERNAME_PATTERN = Pattern.compile("^[a-zA-Z0-9_]{4,20}$");

	public static boolean isValidEmail(String email) {
		if (email == null || email.trim().isEmpty()) {
			return false;
		}
		return EMAIL_PATTERN.matcher(email).matches();
	}

	public static boolean isValidUsername(String username) {
		if (username == null || username.trim().isEmpty()) {
			return false;
		}
		return USERNAME_PATTERN.matcher(username).matches();
	}

	public static boolean isValidPassword(String password) {
		if (password == null || password.length() < 8) {
			return false;
		}

		boolean hasDigit = false;
		boolean hasLetter = false;

		for (char c : password.toCharArray()) {
			if (Character.isDigit(c)) {
				hasDigit = true;
			} else if (Character.isLetter(c)) {
				hasLetter = true;
			}

			if (hasDigit && hasLetter) {
				return true;
			}
		}

		return false;
	}

	public static boolean isValidQuizTitle(String title) {
		return title != null && !title.trim().isEmpty() && title.length() <= 100;
	}

	public static boolean isNotEmpty(String value) {
		return value != null && !value.trim().isEmpty();
	}

	public static boolean isPositiveInteger(int value) {
		return value > 0;
	}

	public static boolean isIntegerInRange(int value, int min, int max) {
		return value >= min && value <= max;
	}
}