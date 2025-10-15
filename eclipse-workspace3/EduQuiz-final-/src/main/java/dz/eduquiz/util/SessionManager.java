package dz.eduquiz.util;

import dz.eduquiz.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class SessionManager {

	private static final int SESSION_TIMEOUT = 30 * 60;

	public static void login(HttpServletRequest request, User user) {
		HttpSession session = request.getSession();
		session.setAttribute("user", user);
		session.setMaxInactiveInterval(SESSION_TIMEOUT);
	}

	public static User getCurrentUser(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session != null) {
			return (User) session.getAttribute("user"); 
		}
		return null;
	}

	public static boolean isLoggedIn(HttpServletRequest request) {
		return getCurrentUser(request) != null;
	}

	public static boolean isAdmin(HttpServletRequest request) {
		User user = getCurrentUser(request);
		return user != null && "admin".equals(user.getRole());
	}

	public static void logout(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session != null) {
			session.invalidate();
		}
	}

	public static void updateSessionUser(HttpServletRequest request, User user) {
		HttpSession session = request.getSession();
		session.setAttribute("user", user);
	}
}