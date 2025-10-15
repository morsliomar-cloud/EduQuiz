package dz.eduquiz.servlet;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import dz.eduquiz.model.Category;
import dz.eduquiz.model.Question;
import dz.eduquiz.model.Quiz;
import dz.eduquiz.model.Score;
import dz.eduquiz.model.User;
import dz.eduquiz.model.APIOpenTrivia.APIQuestion;
import dz.eduquiz.service.CategoryService;
import dz.eduquiz.service.QuestionService;
import dz.eduquiz.service.QuizService;
import dz.eduquiz.service.ScoreService;
import dz.eduquiz.service.UserService;
import dz.eduquiz.service.APIOpenTrivia.APIQuestionService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private UserService userService;
	private QuizService quizService;
	private QuestionService questionService;
	private CategoryService categoryService;
	private ScoreService scoreService;
	private APIQuestionService apiQuestionService;

	@Override
	public void init() throws ServletException {
		userService = new UserService();
		quizService = new QuizService();
		questionService = new QuestionService();
		categoryService = new CategoryService();
		scoreService = new ScoreService();
		apiQuestionService = new APIQuestionService();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		if (!isAdmin(request)) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		String pathInfo = request.getPathInfo();
		if (pathInfo == null) {
			pathInfo = "/dashboard";
		}

		switch (pathInfo) {
		case "/dashboard":
			showDashboard(request, response);
			break;
		case "/manage-users":
			showManageUsers(request, response);
			break;
		case "/manage-quizzes":
			showManageQuizzes(request, response);
			break;
		case "/manage-questions":
			showManageQuestions(request, response);
			break;
		case "/manage-categories":
			showManageCategories(request, response);
			break;
		case "/reports":
			showReports(request, response);
			break;
		case "/import-questions":
			showImportQuestionsForm(request, response);
			break;
		default:
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		if (!isAdmin(request)) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		String pathInfo = request.getPathInfo();
		String action = request.getParameter("action");

		switch (pathInfo) {
		case "/add-user":
			handleAddUser(request, response);
			break;
		case "/update-user":
			handleUpdateUser(request, response);
			break;
		case "/delete-user":
			handleDeleteUser(request, response);
			break;
		case "/toggle-user-status":
			handleToggleUserStatus(request, response);
			break;
		case "/manage-users":
			handleUserActions(request, response, action);
			break;
		case "/manage-quizzes":
			handleQuizActions(request, response, action);
			break;
		case "/manage-questions":
			handleQuestionActions(request, response, action);
			break;
		case "/manage-categories":
			handleCategoryActions(request, response, action);
			break;
		case "/process-import":
			handleProcessImport(request, response);
			break;
		case "/preview-import":
			handlePreviewImport(request, response);
			break;
		case "/refresh-categories": 
			handleRefreshCategories(request, response);
			break;
		default:
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	private void showImportQuestionsForm(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		
		List<Category> categories = categoryService.getAllCategories();

		List<String> apiCategories = apiQuestionService.getAPICategories();

		request.setAttribute("categories", categories);
		request.setAttribute("apiCategories", apiCategories);

		Map<String, Object> cacheStatus = apiQuestionService.getCacheStatus();
		request.setAttribute("cacheStatus", cacheStatus);

		request.getRequestDispatcher("/WEB-INF/admin/APIOpenTrivia/import-questions.jsp").forward(request, response);
	}

	private void handleProcessImport(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String quizTitle = request.getParameter("title");
		String description = request.getParameter("description");
		String categoryId = request.getParameter("categoryId");
		String amount = request.getParameter("amount");
		String difficulty = request.getParameter("difficulty");
		String apiCategory = request.getParameter("apiCategory");
		String timeLimit = request.getParameter("timeLimit");

		try {
			if (quizTitle == null || quizTitle.trim().isEmpty() || categoryId == null || categoryId.trim().isEmpty()
					|| amount == null || amount.trim().isEmpty() || timeLimit == null || timeLimit.trim().isEmpty()) {

				request.getSession().setAttribute("errorMessage", "Missing required fields");
				response.sendRedirect(request.getContextPath() + "/admin/import-questions");
				return;
			}

			int categoryIdInt = Integer.parseInt(categoryId);
			int amountInt = Integer.parseInt(amount);
			int timeLimitInt = Integer.parseInt(timeLimit);

			if (categoryIdInt <= 0 || amountInt < 5 || amountInt > 50 || timeLimitInt < 1 || timeLimitInt > 120) {

				request.getSession().setAttribute("errorMessage", "Invalid input parameters");
				response.sendRedirect(request.getContextPath() + "/admin/import-questions");
				return;
			}

			boolean success = apiQuestionService.importQuestionsToDatabase(amountInt,
					apiCategory != null && !apiCategory.isEmpty() ? apiCategory : null,
					difficulty != null && !difficulty.isEmpty() ? difficulty : null, quizTitle, description,
					categoryIdInt, timeLimitInt);

			if (success) {
				request.getSession().setAttribute("successMessage", "Questions imported successfully");
			} else {
				request.getSession().setAttribute("errorMessage", "Failed to import questions");
			}
		} catch (NumberFormatException e) {
			request.getSession().setAttribute("errorMessage", "Invalid number format in input: " + e.getMessage());
		} catch (Exception e) {
			request.getSession().setAttribute("errorMessage", "Error importing questions: " + e.getMessage());
		}

		response.sendRedirect(request.getContextPath() + "/admin/manage-questions");
	}

	private void handlePreviewImport(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String amount = request.getParameter("amount");
		String difficulty = request.getParameter("difficulty");
		String apiCategory = request.getParameter("apiCategory");

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		try {
			int amountInt = Integer.parseInt(amount);

			if (amountInt < 5 || amountInt > 50) {
				response.getWriter().write("{\"success\":false,\"message\":\"Invalid number of questions\"}");
				return;
			}

			List<APIQuestion> apiQuestions = apiQuestionService.fetchQuestionsFromAPI(amountInt,
					apiCategory != null && !apiCategory.isEmpty() ? apiCategory : null,
					difficulty != null && !difficulty.isEmpty() ? difficulty : null);

			if (apiQuestions.isEmpty()) {
				response.getWriter().write("{\"success\":false,\"message\":\"No questions found\"}");
				return;
			}

			JSONArray questionsJson = new JSONArray();
			for (APIQuestion question : apiQuestions) {
				JSONObject questionJson = new JSONObject();
				questionJson.put("question", question.getQuestion());
				questionJson.put("optionA", question.getShuffledAnswers()[0]);
				questionJson.put("optionB", question.getShuffledAnswers()[1]);
				questionJson.put("optionC", question.getShuffledAnswers()[2]);
				questionJson.put("optionD", question.getShuffledAnswers()[3]);
				questionJson.put("correctAnswer", question.getCorrectAnswer());
				questionJson.put("difficulty", question.getDifficulty());
				questionsJson.put(questionJson);
			}

			JSONObject responseJson = new JSONObject();
			responseJson.put("success", true);
			responseJson.put("questions", questionsJson);

			response.getWriter().write(responseJson.toString());

		} catch (NumberFormatException e) {
			response.getWriter().write("{\"success\":false,\"message\":\"Invalid number format\"}");
		} catch (Exception e) {
			response.getWriter()
					.write("{\"success\":false,\"message\":\"Error fetching preview: " + e.getMessage() + "\"}");
		}
	}

	private boolean isAdmin(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session == null) {
			return false;
		}

		User user = (User) session.getAttribute("user");
		return user != null && "admin".equals(user.getRole());
	}

	private void showDashboard(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		Map<String, Object> stats = new HashMap<>();

		List<User> allUsers = userService.getAllUsers();
		List<Quiz> allQuizzes = quizService.getAllQuizzes();
		List<Category> allCategories = categoryService.getAllCategories();

				int totalQuestions = 0;
		for (Quiz quiz : allQuizzes) {
			totalQuestions += questionService.countQuestionsByQuizId(quiz.getId());
		}

		stats.put("totalUsers", allUsers.size());
		stats.put("totalQuizzes", allQuizzes.size());
		stats.put("totalQuestions", totalQuestions);
		stats.put("totalCategories", allCategories.size());

		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.MONTH, -1);
		Date lastMonth = cal.getTime();

		int newUsers = 0, newQuizzes = 0, newQuestions = 0;
		int quizzesTaken = 0, quizzesTakenThisMonth = 0;

		for (User user : allUsers) {
			if (user.getCreatedAt() != null && user.getCreatedAt().after(lastMonth)) {
				newUsers++;
			}
		}

		newQuizzes = (int) (allQuizzes.size() * 0.1); 
		newQuestions = (int) (totalQuestions * 0.15); 

		for (Quiz quiz : allQuizzes) {
			List<Score> quizScores = scoreService.getScoresByQuizId(quiz.getId());
			quizzesTaken += quizScores.size();

			for (Score score : quizScores) {
				if (score.getDateTaken() != null && score.getDateTaken().after(lastMonth)) {
					quizzesTakenThisMonth++;
				}
			}
		}

		stats.put("newUsers", newUsers);
		stats.put("newQuizzes", newQuizzes);
		stats.put("newQuestions", newQuestions);
		stats.put("quizzesTaken", quizzesTaken);
		stats.put("quizzesTakenThisMonth", quizzesTakenThisMonth);

		List<User> recentUsers = new ArrayList<>();
		int userCount = 0;
		for (int i = allUsers.size() - 1; i >= 0 && userCount < 5; i--) {
			recentUsers.add(allUsers.get(i));
			userCount++;
		}

		List<Quiz> recentQuizzes = new ArrayList<>();
		int quizCount = 0;
		for (int i = allQuizzes.size() - 1; i >= 0 && quizCount < 5; i--) {
			recentQuizzes.add(allQuizzes.get(i));
			quizCount++;
		}

		List<String> activityLabels = new ArrayList<>();
		List<Integer> activityData = new ArrayList<>();
		List<String> categoryLabels = new ArrayList<>();
		List<Integer> categoryData = new ArrayList<>();

		Calendar activityCal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("MMM dd");

		for (int i = 6; i >= 0; i--) {
			activityCal.add(Calendar.DAY_OF_MONTH, -1);
			activityLabels.add(sdf.format(activityCal.getTime()));
			activityData.add((int) (Math.random() * 20 + 5));
		}

		Map<String, Integer> categoryCount = new HashMap<>();
		for (Quiz quiz : allQuizzes) {
			if (quiz.getCategory() != null) {
				String catName = quiz.getCategory().getName();
				categoryCount.put(catName, categoryCount.getOrDefault(catName, 0) + 1);
			}
		}

		for (Map.Entry<String, Integer> entry : categoryCount.entrySet()) {
			categoryLabels.add(entry.getKey());
			categoryData.add(entry.getValue());
		}

		StringBuilder activityLabelsJson = new StringBuilder("[");
		for (int i = 0; i < activityLabels.size(); i++) {
			if (i > 0) {
				activityLabelsJson.append(",");
			}
			activityLabelsJson.append("\"").append(activityLabels.get(i)).append("\"");
		}
		activityLabelsJson.append("]");

		StringBuilder activityDataJson = new StringBuilder("[");
		for (int i = 0; i < activityData.size(); i++) {
			if (i > 0) {
				activityDataJson.append(",");
			}
			activityDataJson.append(activityData.get(i));
		}
		activityDataJson.append("]");

		StringBuilder categoryLabelsJson = new StringBuilder("[");
		for (int i = 0; i < categoryLabels.size(); i++) {
			if (i > 0) {
				categoryLabelsJson.append(",");
			}
			categoryLabelsJson.append("\"").append(categoryLabels.get(i).replace("\"", "\\\"")).append("\"");
		}
		categoryLabelsJson.append("]");

		StringBuilder categoryDataJson = new StringBuilder("[");
		for (int i = 0; i < categoryData.size(); i++) {
			if (i > 0) {
				categoryDataJson.append(",");
			}
			categoryDataJson.append(categoryData.get(i));
		}
		categoryDataJson.append("]");

		request.setAttribute("stats", stats);
		request.setAttribute("recentUsers", recentUsers);
		request.setAttribute("recentQuizzes", recentQuizzes);
		request.setAttribute("activityLabels", activityLabelsJson.toString());
		request.setAttribute("activityData", activityDataJson.toString());
		request.setAttribute("categoryLabels", categoryLabelsJson.toString());
		request.setAttribute("categoryData", categoryDataJson.toString());

		request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
	}

	private void showManageUsers(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String search = request.getParameter("search");
		String roleFilter = request.getParameter("role");
		int page = 1;
		int pageSize = 10;

		try {
			String pageParam = request.getParameter("page");
			if (pageParam != null && !pageParam.isEmpty()) {
				page = Integer.parseInt(pageParam);
			}
		} catch (NumberFormatException e) {
			page = 1;
		}

		List<User> users = userService.getAllUsers();
		List<User> filteredUsers = new ArrayList<>();

		for (User user : users) {
			boolean matchesSearch = search == null || search.trim().isEmpty()
					|| user.getUsername().toLowerCase().contains(search.toLowerCase())
					|| user.getEmail().toLowerCase().contains(search.toLowerCase());

			boolean matchesRole = roleFilter == null || roleFilter.isEmpty()
					|| user.getRole().equalsIgnoreCase(roleFilter);

			if (matchesSearch && matchesRole) {
				filteredUsers.add(user);
			}
		}

		int totalUsers = filteredUsers.size();
		int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
		int startIndex = (page - 1) * pageSize;
		int endIndex = Math.min(startIndex + pageSize, totalUsers);

		List<User> paginatedUsers = new ArrayList<>();
		if (startIndex < totalUsers) {
			paginatedUsers = filteredUsers.subList(startIndex, endIndex);
		}

		Map<String, Integer> userStats = new HashMap<>();
		int activeUsers = 0;
		int adminUsers = 0;

		for (User user : users) {
			if (user.isActive()) {
				activeUsers++;
			}
			if ("ADMIN".equalsIgnoreCase(user.getRole())) {
				adminUsers++;
			}
		}

		userStats.put("totalUsers", users.size());
		userStats.put("activeUsers", activeUsers);
		userStats.put("adminUsers", adminUsers);

		request.setAttribute("users", paginatedUsers);
		request.setAttribute("userStats", userStats);
		request.setAttribute("currentPage", page);
		request.setAttribute("totalPages", totalPages);
		request.setAttribute("searchTerm", search);
		request.setAttribute("selectedRole", roleFilter);

		request.getRequestDispatcher("/WEB-INF/admin/manage-users.jsp").forward(request, response);
	}

	private void handleAddUser(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String username = request.getParameter("username");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String confirmPassword = request.getParameter("confirmPassword");
		String role = request.getParameter("role");
		boolean active = request.getParameter("active") != null;

		if (!password.equals(confirmPassword)) {
			request.getSession().setAttribute("errorMessage", "Passwords do not match");
			response.sendRedirect(request.getContextPath() + "/admin/manage-users");
			return;
		}

		try {
			String hashedPassword = hashPassword(password);

			boolean created = userService.registerUser(username, email, hashedPassword, role, active);

			if (created) {
				request.getSession().setAttribute("successMessage", "User created successfully");
			} else {
				request.getSession().setAttribute("errorMessage", "Failed to create user");
			}
		} catch (Exception e) {
			request.getSession().setAttribute("errorMessage", "Error creating user: " + e.getMessage());
		}

		response.sendRedirect(request.getContextPath() + "/admin/manage-users");
	}

	private void handleUpdateUser(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int userId = Integer.parseInt(request.getParameter("id"));
		String username = request.getParameter("username");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String role = request.getParameter("role");
		boolean active = request.getParameter("active") != null;

		try {
			boolean updated;
			if (password != null && !password.trim().isEmpty()) {
				String hashedPassword = hashPassword(password);
				updated = userService.updateUser(userId, username, email, hashedPassword, role, active);
			} else {
				updated = userService.updateUserWithoutPassword(userId, username, email, role, active);
			}

			if (updated) {
				request.getSession().setAttribute("successMessage", "User updated successfully");
			} else {
				request.getSession().setAttribute("errorMessage", "Failed to update user");
			}
		} catch (Exception e) {
			request.getSession().setAttribute("errorMessage", "Error updating user: " + e.getMessage());
		}

		response.sendRedirect(request.getContextPath() + "/admin/manage-users");
	}

	private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int userId = Integer.parseInt(request.getParameter("id"));

		try {
			scoreService.deleteScoresByUserId(userId);

			boolean deleted = userService.deleteUser(userId);

			if (deleted) {
				request.getSession().setAttribute("successMessage", "User deleted successfully");
			} else {
				request.getSession().setAttribute("errorMessage", "Failed to delete user");
			}
		} catch (Exception e) {
			request.getSession().setAttribute("errorMessage", "Error deleting user: " + e.getMessage());
		}

		response.sendRedirect(request.getContextPath() + "/admin/manage-users");
	}

	private void handleToggleUserStatus(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int userId = Integer.parseInt(request.getParameter("id"));
		boolean active = Boolean.parseBoolean(request.getParameter("active"));

		try {
			boolean updated = userService.updateUserStatus(userId, active);

			if (updated) {
				String status = active ? "activated" : "deactivated";
				request.getSession().setAttribute("successMessage", "User " + status + " successfully");
			} else {
				request.getSession().setAttribute("errorMessage", "Failed to update user status");
			}
		} catch (Exception e) {
			request.getSession().setAttribute("errorMessage", "Error updating user status: " + e.getMessage());
		}

		response.sendRedirect(request.getContextPath() + "/admin/manage-users");
	}

	private String hashPassword(String password) {
		try {
			MessageDigest md = MessageDigest.getInstance("SHA-256");
			byte[] hashedBytes = md.digest(password.getBytes());
			StringBuilder sb = new StringBuilder();
			for (byte b : hashedBytes) {
				sb.append(String.format("%02x", b));
			}
			return sb.toString();
		} catch (NoSuchAlgorithmException e) {
			throw new RuntimeException("Error hashing password", e);
		}
	}

	private void showManageQuizzes(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String search = request.getParameter("search");
		String categoryFilter = request.getParameter("category");
		String difficultyFilter = request.getParameter("difficulty");

		List<Quiz> quizzes = quizService.getAllQuizzes();
		List<Category> categories = categoryService.getAllCategories();
		List<Quiz> filteredQuizzes = new ArrayList<>();

		for (Quiz quiz : quizzes) {
			boolean matchesSearch = search == null || search.trim().isEmpty()
					|| quiz.getTitle().toLowerCase().contains(search.toLowerCase()) || (quiz.getDescription() != null
							&& quiz.getDescription().toLowerCase().contains(search.toLowerCase()));

			boolean matchesCategory = categoryFilter == null || categoryFilter.isEmpty() || "all".equals(categoryFilter)
					|| (quiz.getCategory() != null && quiz.getCategory().getId() == Integer.parseInt(categoryFilter));

			boolean matchesDifficulty = difficultyFilter == null || difficultyFilter.isEmpty()
					|| "all".equals(difficultyFilter) || quiz.getDifficulty().equalsIgnoreCase(difficultyFilter);

			if (matchesSearch && matchesCategory && matchesDifficulty) {
				filteredQuizzes.add(quiz);
			}
		}

		request.setAttribute("quizzes", filteredQuizzes);
		request.setAttribute("categories", categories);
		request.setAttribute("searchTerm", search);
		request.setAttribute("selectedCategory", categoryFilter);
		request.setAttribute("selectedDifficulty", difficultyFilter);
		request.getRequestDispatcher("/WEB-INF/admin/manage-quizzes.jsp").forward(request, response);
	}

	private void showManageQuestions(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String quizFilter = request.getParameter("quiz");
		String search = request.getParameter("search");

		List<Question> questions = new ArrayList<>();
		List<Quiz> quizzes = quizService.getAllQuizzes();

		List<Category> categories = categoryService.getAllCategories();
		List<String> apiCategories = apiQuestionService.getAPICategories();

		if (quizFilter != null && !quizFilter.isEmpty() && !"all".equals(quizFilter)) {
			try {
				int quizId = Integer.parseInt(quizFilter);
				questions = questionService.getQuestionsByQuizId(quizId);
			} catch (NumberFormatException e) {
				
			}
		} else {
			for (Quiz quiz : quizzes) {
				questions.addAll(questionService.getQuestionsByQuizId(quiz.getId()));
			}
		}

		if (search != null && !search.trim().isEmpty()) {
			List<Question> filteredQuestions = new ArrayList<>();
			for (Question question : questions) {
				if (question.getQuestionText().toLowerCase().contains(search.toLowerCase())) {
					filteredQuestions.add(question);
				}
			}
			questions = filteredQuestions;
		}

		request.setAttribute("questions", questions);
		request.setAttribute("quizzes", quizzes);
		request.setAttribute("categories", categories);
		request.setAttribute("apiCategories", apiCategories);
		request.setAttribute("searchTerm", search);
		request.setAttribute("selectedQuiz", quizFilter);
		request.getRequestDispatcher("/WEB-INF/admin/manage-questions.jsp").forward(request, response);
	}

	private void showManageCategories(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		List<Category> categories = categoryService.getAllCategories();

		request.setAttribute("categories", categories);
		request.getRequestDispatcher("/WEB-INF/admin/manage-categories.jsp").forward(request, response);
	}

	private void showReports(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		Map<String, Object> reportData = new HashMap<>();

		List<Quiz> quizzes = quizService.getAllQuizzes();
		for (Quiz quiz : quizzes) {
			float avgScore = scoreService.calculateAverageScoreForQuiz(quiz.getId());
			float passRate = scoreService.calculatePassRateForQuiz(quiz.getId());
		}

		reportData.put("quizzes", quizzes);
		reportData.put("totalUsers", userService.getAllUsers().size());

		request.setAttribute("reportData", reportData);
		request.getRequestDispatcher("/WEB-INF/admin/reports.jsp").forward(request, response);
	}

	private void handleUserActions(HttpServletRequest request, HttpServletResponse response, String action)
			throws ServletException, IOException {

		switch (action) {
		case "delete":
			int userId = Integer.parseInt(request.getParameter("userId"));
			boolean deleted = userService.deleteUser(userId);
			if (deleted) {
				scoreService.deleteScoresByUserId(userId);
			}
			break;
		case "updateRole":
			int updateUserId = Integer.parseInt(request.getParameter("userId"));
			String newRole = request.getParameter("role");
			userService.updateUserRole(updateUserId, newRole);
			break;
		}

		response.sendRedirect(request.getContextPath() + "/admin/manage-users");
	}

	private void handleQuizActions(HttpServletRequest request, HttpServletResponse response, String action)
			throws ServletException, IOException {

		switch (action) {
		case "create":
			String title = request.getParameter("title");
			String description = request.getParameter("description");
			int categoryId = Integer.parseInt(request.getParameter("categoryId"));
			String difficulty = request.getParameter("difficulty");
			int timeLimit = Integer.parseInt(request.getParameter("timeLimit"));

			quizService.createQuiz(title, description, categoryId, difficulty, timeLimit);
			break;
		case "update":
			int quizId = Integer.parseInt(request.getParameter("quizId"));
			String updateTitle = request.getParameter("title");
			String updateDescription = request.getParameter("description");
			int updateCategoryId = Integer.parseInt(request.getParameter("categoryId"));
			String updateDifficulty = request.getParameter("difficulty");
			int updateTimeLimit = Integer.parseInt(request.getParameter("timeLimit"));

			quizService.updateQuiz(quizId, updateTitle, updateDescription, updateCategoryId, updateDifficulty,
					updateTimeLimit);
			break;
		case "delete":
			int deleteQuizId = Integer.parseInt(request.getParameter("quizId"));

			scoreService.deleteScoresByQuizId(deleteQuizId);
			questionService.deleteQuestionsByQuizId(deleteQuizId);

			quizService.deleteQuiz(deleteQuizId);
			break;
		}

		response.sendRedirect(request.getContextPath() + "/admin/manage-quizzes");
	}

	private void handleQuestionActions(HttpServletRequest request, HttpServletResponse response, String action)
			throws ServletException, IOException {

		switch (action) {
		case "create":
			String questionText = request.getParameter("questionText");
			int quizId = Integer.parseInt(request.getParameter("quizId"));
			String optionA = request.getParameter("optionA");
			String optionB = request.getParameter("optionB");
			String optionC = request.getParameter("optionC");
			String optionD = request.getParameter("optionD");
			char correctAnswer = request.getParameter("correctAnswer").charAt(0);

			questionService.addQuestion(quizId, questionText, optionA, optionB, optionC, optionD, correctAnswer);
			break;
		case "update":
			int questionId = Integer.parseInt(request.getParameter("questionId"));
			int updateQuizId = Integer.parseInt(request.getParameter("quizId"));
			String updateQuestionText = request.getParameter("questionText");
			String updateOptionA = request.getParameter("optionA");
			String updateOptionB = request.getParameter("optionB");
			String updateOptionC = request.getParameter("optionC");
			String updateOptionD = request.getParameter("optionD");
			char updateCorrectAnswer = request.getParameter("correctAnswer").charAt(0);

			questionService.updateQuestion(questionId, updateQuizId, updateQuestionText, updateOptionA, updateOptionB,
					updateOptionC, updateOptionD, updateCorrectAnswer);
			break;
		case "delete":
			int deleteQuestionId = Integer.parseInt(request.getParameter("questionId"));
			questionService.deleteQuestion(deleteQuestionId);
			break;
		}

		response.sendRedirect(request.getContextPath() + "/admin/manage-questions");
	}

	private void handleCategoryActions(HttpServletRequest request, HttpServletResponse response, String action)
			throws ServletException, IOException {

		switch (action) {
		case "create":
			String categoryName = request.getParameter("name");
			String categoryDescription = request.getParameter("description");
			categoryService.createCategory(categoryName, categoryDescription);
			break;
		case "update":
			int categoryId = Integer.parseInt(request.getParameter("categoryId"));
			String updateName = request.getParameter("name");
			String updateDescription = request.getParameter("description");
			categoryService.updateCategory(categoryId, updateName, updateDescription);
			break;
		case "delete":
			int deleteCategoryId = Integer.parseInt(request.getParameter("categoryId"));
			List<Quiz> categoryQuizzes = quizService.getQuizzesByCategory(deleteCategoryId);
			if (categoryQuizzes.isEmpty()) {
				categoryService.deleteCategory(deleteCategoryId);
			}
			break;
		}

		response.sendRedirect(request.getContextPath() + "/admin/manage-categories");
	}

	private void handleRefreshCategories(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		try {
			apiQuestionService.refreshCategoriesCache();

			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");

			Map<String, Object> cacheStatus = apiQuestionService.getCacheStatus();
			JSONObject responseJson = new JSONObject();
			responseJson.put("success", true);
			responseJson.put("message", "Categories cache refreshed successfully");
			responseJson.put("cacheStatus", cacheStatus);

			response.getWriter().write(responseJson.toString());

		} catch (Exception e) {
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");

			JSONObject errorJson = new JSONObject();
			errorJson.put("success", false);
			errorJson.put("message", "Error refreshing categories: " + e.getMessage());

			response.getWriter().write(errorJson.toString());
		}
	}
}