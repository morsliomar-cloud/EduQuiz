package dz.eduquiz.servlet;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import dz.eduquiz.model.Category;
import dz.eduquiz.model.Score;
import dz.eduquiz.model.User;
import dz.eduquiz.model.UserStats;
import dz.eduquiz.service.ScoreService;
import dz.eduquiz.service.UserService;
import dz.eduquiz.util.FileUtil;
import dz.eduquiz.util.SessionManager;
import dz.eduquiz.util.ValidationUtil;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet(urlPatterns = { "/register", "/login", "/logout", "/profile", "/updateProfile", "/home", "/history" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024, 
		maxFileSize = 1024 * 1024 * 2, 
		maxRequestSize = 1024 * 1024 * 10 
)
public class UserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final int PAGE_SIZE = 10; 

	private UserService userService;
	private ScoreService scoreService;

	public UserServlet() {
		super();
		userService = new UserService();
		scoreService = new ScoreService();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getServletPath();

		switch (action) {
		case "/register":
			showRegisterForm(request, response);
			break;
		case "/login":
			showLoginForm(request, response);
			break;
		case "/logout":
			logout(request, response);
			break;
		case "/profile":
			showProfile(request, response);
			break;
		case "/home":
			showHomePage(request, response);
			break;
		case "/history":
			showHistory(request, response);
			break;
		default:
			response.sendRedirect(request.getContextPath() + "/home");
			break;
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getServletPath();

		switch (action) {
		case "/register":
			registerUser(request, response);
			break;
		case "/login":
			loginUser(request, response);
			break;
		case "/updateProfile":
			updateProfile(request, response);
			break;
		case "/history":
			showHistory(request, response);
			break;
		default:
			response.sendRedirect(request.getContextPath() + "/home");
			break;
		}
	}

	private void showRegisterForm(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if (SessionManager.isLoggedIn(request)) {
			response.sendRedirect(request.getContextPath() + "/profile");
			return;
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/register.jsp");
		dispatcher.forward(request, response);
	}

	private void registerUser(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if (SessionManager.isLoggedIn(request)) {
			response.sendRedirect(request.getContextPath() + "/home");
			return;
		}

		String username = request.getParameter("username");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String confirmPassword = request.getParameter("confirmPassword");

		boolean hasError = false;

		if (!ValidationUtil.isValidUsername(username)) {
			request.setAttribute("usernameError",
					"Username must be 4-20 characters and contain only letters, numbers, or underscores");
			hasError = true;
		}

		if (!ValidationUtil.isValidEmail(email)) {
			request.setAttribute("emailError", "Please enter a valid email address");
			hasError = true;
		}

		if (!ValidationUtil.isValidPassword(password)) {
			request.setAttribute("passwordError",
					"Password must be at least 8 characters and contain at least one letter and one number");
			hasError = true;
		}

		if (!password.equals(confirmPassword)) {
			request.setAttribute("confirmPasswordError", "Passwords do not match");
			hasError = true;
		}

		if (hasError) {
			request.setAttribute("username", username);
			request.setAttribute("email", email);
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/register.jsp");
			dispatcher.forward(request, response);
			return;
		}

		boolean success = userService.registerUser(username, email, password);

		if (success) {
			request.setAttribute("successMessage", "Registration successful! Please log in.");
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/login.jsp");
			dispatcher.forward(request, response);
		} else {
			request.setAttribute("errorMessage", "Username or email already exists");
			request.setAttribute("username", username);
			request.setAttribute("email", email);
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/register.jsp");
			dispatcher.forward(request, response);
		}
	}

	private void showLoginForm(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if (SessionManager.isLoggedIn(request)) {
			response.sendRedirect(request.getContextPath() + "/home");
			return;
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/login.jsp");
		dispatcher.forward(request, response);
	}

	private void loginUser(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if (SessionManager.isLoggedIn(request)) {
			response.sendRedirect(request.getContextPath() + "/home");
			return;
		}

		String usernameOrEmail = request.getParameter("usernameOrEmail");
		String password = request.getParameter("password");

		User user = userService.authenticate(usernameOrEmail, password);

		if (user != null) {
			SessionManager.login(request, user);

			if ("admin".equals(user.getRole())) {
				response.sendRedirect(request.getContextPath() + "/admin/dashboard");
			} else {
				response.sendRedirect(request.getContextPath() + "/home"); 
			}
		} else {
			request.setAttribute("usernameOrEmail", usernameOrEmail);
			request.setAttribute("errorMessage", "Invalid username/email or password");
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/login.jsp");
			dispatcher.forward(request, response);
		}
	}

	private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
		SessionManager.logout(request);
		response.sendRedirect(request.getContextPath() + "/login");
	}

	private void showProfile(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if (!SessionManager.isLoggedIn(request)) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		User currentUser = SessionManager.getCurrentUser(request);

		List<Score> recentResults = scoreService.getScoresByUserId(currentUser.getId());

		UserStats userStats = scoreService.getUserStats(currentUser.getId());

		Map<String, Object> performanceData = getPerformanceChartData(currentUser.getId(), 10);

		Map<String, Object> categoryData = getCategoryPerformanceData(currentUser.getId());

		request.setAttribute("recentResults", recentResults);
		request.setAttribute("userStats", userStats);
		request.setAttribute("performanceLabels", performanceData.get("labels"));
		request.setAttribute("performanceData", performanceData.get("data"));
		request.setAttribute("categoryLabels", categoryData.get("labels"));
		request.setAttribute("categoryData", categoryData.get("data"));

		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/profile.jsp");
		dispatcher.forward(request, response);
	}

	private Map<String, Object> getPerformanceChartData(int userId, int limit) {
		Map<String, Object> result = new HashMap<>();

		List<Score> scores = scoreService.getScoresByUserId(userId);
		if (scores.size() > limit) {
			scores = scores.subList(0, limit);
		}

		List<String> labels = new ArrayList<>();
		List<Double> data = new ArrayList<>();

		for (Score score : scores) {
			labels.add("\"Quiz " + score.getQuiz().getId() + "\""); 
			data.add((double) score.getScore());
		}

		Collections.reverse(labels);
		Collections.reverse(data);

		result.put("labels", "[" + String.join(",", labels) + "]");
		result.put("data", "[" + data.stream().map(String::valueOf).collect(Collectors.joining(",")) + "]");
		return result;
	}

	private Map<String, Object> getCategoryPerformanceData(int userId) {
		Map<String, Object> result = new HashMap<>();

		List<Score> scores = scoreService.getScoresByUserId(userId);
		Map<String, List<Double>> categoryScores = new HashMap<>();

		for (Score score : scores) {
			if (score.getQuiz() != null && score.getQuiz().getCategory() != null) {
				String categoryName = score.getQuiz().getCategory().getName();
				categoryScores.computeIfAbsent(categoryName, k -> new ArrayList<>()).add((double) score.getScore());
			}
		}

		List<String> labels = new ArrayList<>();
		List<Double> data = new ArrayList<>();

		for (Map.Entry<String, List<Double>> entry : categoryScores.entrySet()) {
			double average = entry.getValue().stream().mapToDouble(Double::doubleValue).average().orElse(0);
			labels.add("\"" + entry.getKey() + "\""); 
			data.add(average);
		}

		result.put("labels", "[" + String.join(",", labels) + "]");
		result.put("data", "[" + data.stream().map(String::valueOf).collect(Collectors.joining(",")) + "]");
		return result;
	}

	private void updateProfile(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("------ Update Profile Request Received ------");

		if (!SessionManager.isLoggedIn(request)) {
			System.out.println("User not logged in - redirecting to login");
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		User currentUser = SessionManager.getCurrentUser(request);
		System.out.println("Current user: " + currentUser.getUsername() + " (ID: " + currentUser.getId() + ")");

		String username = request.getParameter("username");
		String email = request.getParameter("email");
		String currentPassword = request.getParameter("currentPassword");
		String newPassword = request.getParameter("newPassword");
		String confirmPassword = request.getParameter("confirmPassword");

		System.out.println("Form data received:");
		System.out.println("- Username: " + username);
		System.out.println("- Email: " + email);
		System.out.println("- Current password provided: " + (currentPassword != null && !currentPassword.isEmpty()));
		System.out.println("- New password provided: " + (newPassword != null && !newPassword.isEmpty()));

		boolean hasError = false;

		if (username != null && !username.trim().isEmpty() && !username.equals(currentUser.getUsername())) {
			if (!ValidationUtil.isValidUsername(username)) {
				request.setAttribute("usernameError",
						"Username must be 4-20 characters and contain only letters, numbers, or underscores");
				hasError = true;
				System.out.println("Username validation failed");
			}
		}

		if (email != null && !email.trim().isEmpty() && !email.equals(currentUser.getEmail())) {
			if (!ValidationUtil.isValidEmail(email)) {
				request.setAttribute("emailError", "Please enter a valid email address");
				hasError = true;
				System.out.println("Email validation failed");
			}
		}

		if (newPassword != null && !newPassword.trim().isEmpty()) {
			if (!ValidationUtil.isValidPassword(newPassword)) {
				request.setAttribute("newPasswordError",
						"Password must be at least 8 characters and contain at least one letter and one number");
				hasError = true;
				System.out.println("New password validation failed");
			}

			if (!newPassword.equals(confirmPassword)) {
				request.setAttribute("confirmPasswordError", "Passwords do not match");
				hasError = true;
				System.out.println("Confirm password validation failed");
			}
		}

		if (currentPassword == null || currentPassword.trim().isEmpty()) {
			request.setAttribute("currentPasswordError", "Current password is required to make changes");
			hasError = true;
			System.out.println("Current password not provided");
		}

		if (hasError) {
			System.out.println("Validation errors found - returning to profile page");
			request.setAttribute("formUsername", username);
			request.setAttribute("formEmail", email);

			request.setAttribute("showProfileModal", true); 
			request.setAttribute("quizHistory", scoreService.getScoresByUserId(currentUser.getId()));
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/profile.jsp");
			dispatcher.forward(request, response);
			return;
		}

		String profileImageName = null;
		Part filePart = null;

		try {
			filePart = request.getPart("profileImage");
			if (filePart != null && filePart.getSize() > 0) {
				String uploadDir = request.getServletContext().getRealPath("") + File.separator + "uploads";

				profileImageName = FileUtil.processProfileImage(filePart, uploadDir);
				System.out.println("Processed profile image: " + profileImageName);

				if (profileImageName != null && currentUser.getProfileImage() != null
						&& !currentUser.getProfileImage().isEmpty()) {
					boolean deleted = FileUtil.deleteFile(currentUser.getProfileImage(), uploadDir);
					System.out.println("Deleted old profile image: " + deleted);
				}
			}
		} catch (Exception e) {
			System.out.println("Error processing profile image: " + e.getMessage());
			e.printStackTrace();
			request.setAttribute("imageError", "Error processing image: " + e.getMessage());

			request.setAttribute("showProfileModal", true);
			request.setAttribute("quizHistory", scoreService.getScoresByUserId(currentUser.getId()));
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/profile.jsp");
			dispatcher.forward(request, response);
			return;
		}

		System.out.println("Calling userService.updateUserProfile");
		boolean success = userService.updateUserProfile(currentUser.getId(), username, email, currentPassword,
				newPassword, profileImageName 
		);
		System.out.println("Update result: " + (success ? "SUCCESS" : "FAILED"));

		if (success) {
			System.out.println("Update successful - updating session data");
			if (username != null && !username.trim().isEmpty()) {
				currentUser.setUsername(username);
			}
			if (email != null && !email.trim().isEmpty()) {
				currentUser.setEmail(email);
			}
			if (profileImageName != null) {
				currentUser.setProfileImage(profileImageName);
			}

			request.getSession().setAttribute("user", currentUser); 
			request.setAttribute("successMessage", "Profile updated successfully");
		} else {
			System.out.println("Update failed - setting error message");
			request.setAttribute("errorMessage", "Failed to update profile. Please check your current password.");
			request.setAttribute("showProfileModal", true); 

			request.setAttribute("formUsername", username);
			request.setAttribute("formEmail", email);
		}

		request.setAttribute("quizHistory", scoreService.getScoresByUserId(currentUser.getId()));
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/profile.jsp");
		dispatcher.forward(request, response);
	}

	private void showHomePage(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/index.jsp");
		dispatcher.forward(request, response);
	}

	private void showHistory(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if (!SessionManager.isLoggedIn(request)) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		User currentUser = SessionManager.getCurrentUser(request);
		int userId = currentUser.getId();

		String category = request.getParameter("category");
		String difficulty = request.getParameter("difficulty");
		String dateRange = request.getParameter("dateRange");

		int currentPage = 1;
		String pageParam = request.getParameter("page");
		if (pageParam != null && !pageParam.isEmpty()) {
			try {
				currentPage = Integer.parseInt(pageParam);
				if (currentPage < 1) {
					currentPage = 1;
				}
			} catch (NumberFormatException e) {
				currentPage = 1;
			}
		}

		List<Score> quizHistory = scoreService.getFilteredScoresByUserId(userId, category, difficulty, dateRange,
				currentPage, PAGE_SIZE);

		int totalRecords = scoreService.countFilteredScoresByUserId(userId, category, difficulty, dateRange);
		int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

		int totalQuizzes = scoreService.getTotalQuizzesByUserId(userId);
		float averageScore = scoreService.getAverageScoreByUserId(userId);
		float bestScore = scoreService.getBestScoreByUserId(userId);
		float scoreTrend = scoreService.getScoreTrendByUserId(userId);

		List<Category> categories = scoreService.getAllCategories();

		StringBuilder filterParams = new StringBuilder();
		if (category != null && !category.isEmpty()) {
			filterParams.append("&category=").append(category);
		}
		if (difficulty != null && !difficulty.isEmpty()) {
			filterParams.append("&difficulty=").append(difficulty);
		}
		if (dateRange != null && !dateRange.isEmpty()) {
			filterParams.append("&dateRange=").append(dateRange);
		}

		request.setAttribute("quizHistory", quizHistory);
		request.setAttribute("categories", categories);
		request.setAttribute("currentPage", currentPage);
		request.setAttribute("totalPages", totalPages);
		request.setAttribute("totalRecords", totalRecords);
		request.setAttribute("filterParams", filterParams.toString());

		request.setAttribute("totalQuizzes", totalQuizzes);
		request.setAttribute("averageScore", Math.round(averageScore));
		request.setAttribute("bestScore", Math.round(bestScore));
		request.setAttribute("scoreTrend", Math.round(scoreTrend));

		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/history.jsp");
		dispatcher.forward(request, response);
	}
}