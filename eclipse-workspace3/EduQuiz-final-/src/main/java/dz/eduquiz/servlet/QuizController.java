package dz.eduquiz.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import dz.eduquiz.model.Category;
import dz.eduquiz.model.Question;
import dz.eduquiz.model.Quiz;
import dz.eduquiz.model.Score;
import dz.eduquiz.model.User;
import dz.eduquiz.service.CategoryService;
import dz.eduquiz.service.QuestionService;
import dz.eduquiz.service.QuizService;
import dz.eduquiz.service.ScoreService;
import dz.eduquiz.service.APIOpenTrivia.APIQuestionService;
import dz.eduquiz.util.SessionManager;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = { "/quizzes", "/quiz/*", "/take-quiz/*", "/submit-quiz", "/quiz-result", "/quiz/api-quiz",

		"/quiz/take-api" })

public class QuizController extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private QuizService quizService;

	private QuestionService questionService;

	private CategoryService categoryService;

	private ScoreService scoreService;

	private APIQuestionService apiQuestionService;

	public QuizController() {

		super();

		quizService = new QuizService();

		questionService = new QuestionService();

		categoryService = new CategoryService();

		scoreService = new ScoreService();

		apiQuestionService = new APIQuestionService();

	}

	@Override

	protected void doGet(HttpServletRequest request, HttpServletResponse response)

			throws ServletException, IOException {

		String path = request.getServletPath();

		String pathInfo = request.getPathInfo();

		if (path.equals("/quizzes")) {

			listQuizzes(request, response);

		} else if (path.equals("/quiz") && pathInfo != null) {

			showQuizDetails(request, response, getIdFromPath(pathInfo));

		} else if (path.equals("/take-quiz") && pathInfo != null) {

			showTakeQuiz(request, response, getIdFromPath(pathInfo));

		} else if (path.equals("/quiz-result")) {

			showQuizResult(request, response);

		} else if (path.equals("/quiz/api-quiz")) {

			showApiQuizSelection(request, response);

		} else if (path.equals("/quiz/take-api")) {

			showTakeApiQuiz(request, response);

		} else {

			response.sendRedirect(request.getContextPath() + "/quizzes");

		}

	}

	@Override

	protected void doPost(HttpServletRequest request, HttpServletResponse response)

			throws ServletException, IOException {

		String path = request.getServletPath();

		if (path.equals("/submit-quiz")) {

			submitQuiz(request, response);

		} else if (path.equals("/quiz/take-api")) {

			showTakeApiQuiz(request, response);

		} else {

			response.sendRedirect(request.getContextPath() + "/quizzes");

		}

	}

	private void listQuizzes(HttpServletRequest request, HttpServletResponse response)

			throws ServletException, IOException {

		String categoryParam = request.getParameter("category");

		String difficultyParam = request.getParameter("difficulty");

		String searchParam = request.getParameter("search");

		List<Quiz> quizzes;

		if (categoryParam != null && !categoryParam.isEmpty()) {

			try {

				int categoryId = Integer.parseInt(categoryParam);

				quizzes = quizService.getQuizzesByCategory(categoryId);

			} catch (NumberFormatException e) {

				quizzes = quizService.getAllQuizzes();

			}

		} else if (difficultyParam != null && !difficultyParam.isEmpty()) {

			quizzes = quizService.getQuizzesByDifficulty(difficultyParam);

		} else if (searchParam != null && !searchParam.isEmpty()) {

			quizzes = quizService.searchQuizzesByTitle(searchParam);

		} else {

			quizzes = quizService.getAllQuizzes();

		}

		List<Category> categories = categoryService.getAllCategories();

		request.setAttribute("quizzes", quizzes);

		request.setAttribute("categories", categories);

		request.setAttribute("selectedCategory", categoryParam);

		request.setAttribute("selectedDifficulty", difficultyParam);

		request.setAttribute("searchTerm", searchParam);

		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/quizzes.jsp");

		dispatcher.forward(request, response);

	}

	private void showQuizDetails(HttpServletRequest request, HttpServletResponse response, int quizId)

			throws ServletException, IOException {

		Quiz quiz = quizService.getQuizById(quizId);

		if (quiz == null) {

			request.setAttribute("errorMessage", "Quiz not found");

			response.sendRedirect(request.getContextPath() + "/quizzes");

			return;

		}

		Category category = categoryService.getCategoryById(quiz.getCategoryId());

		int questionCount = questionService.countQuestionsByQuizId(quizId);

		List<Score> topScores = scoreService.getTopScoresByQuizId(quizId, 5);

		if (SessionManager.isLoggedIn(request)) {

			User currentUser = SessionManager.getCurrentUser(request);

			Score userBestScore = scoreService.getBestScoreByUserAndQuiz(currentUser.getId(), quizId);

			request.setAttribute("userBestScore", userBestScore);

		}

		request.setAttribute("quiz", quiz);

		request.setAttribute("category", category);

		request.setAttribute("questionCount", questionCount);

		request.setAttribute("topScores", topScores);

		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/quizdetails.jsp");

		dispatcher.forward(request, response);

	}

	private void showTakeQuiz(HttpServletRequest request, HttpServletResponse response, int quizId)

			throws ServletException, IOException {

		if (!SessionManager.isLoggedIn(request)) {

			request.setAttribute("errorMessage", "You must be logged in to take a quiz");

			response.sendRedirect(request.getContextPath() + "/login");

			return;

		}

		Quiz quiz = quizService.getQuizById(quizId);

		if (quiz == null) {

			request.setAttribute("errorMessage", "Quiz not found");

			response.sendRedirect(request.getContextPath() + "/quizzes");

			return;

		}

		List<Question> questions = questionService.getQuestionsByQuizId(quizId);

		if (questions == null || questions.isEmpty()) {

			request.setAttribute("errorMessage", "This quiz has no questions");

			response.sendRedirect(request.getContextPath() + "/quiz/" + quizId);

			return;

		}

		request.setAttribute("quiz", quiz);

		request.setAttribute("questions", questions);

		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/takequiz.jsp");

		dispatcher.forward(request, response);

	}

	private void showApiQuizSelection(HttpServletRequest request, HttpServletResponse response)

			throws ServletException, IOException {

		List<String> apiCategories = apiQuestionService.getAPICategories();

		String[] difficulties = apiQuestionService.getDifficulties();

		request.setAttribute("apiCategories", apiCategories);

		request.setAttribute("difficulties", difficulties);

		RequestDispatcher dispatcher = request

				.getRequestDispatcher("/WEB-INF/admin/APIOpenTrivia/api-quiz-selection.jsp");

		dispatcher.forward(request, response);

	}

	private void showTakeApiQuiz(HttpServletRequest request, HttpServletResponse response)

			throws ServletException, IOException {

		if (!SessionManager.isLoggedIn(request)) {

			request.setAttribute("errorMessage", "You must be logged in to take a quiz");

			response.sendRedirect(request.getContextPath() + "/login");

			return;

		}

		String category = request.getParameter("category");

		String difficulty = request.getParameter("difficulty");

		String amountParam = request.getParameter("amount");

		String timePerQuestionParam = request.getParameter("timePerQuestion");

		boolean showCorrectAnswers = "on".equals(request.getParameter("showCorrectAnswers"));

		boolean shuffleQuestions = "on".equals(request.getParameter("shuffleQuestions"));

		int amount;

		try {

			amount = Integer.parseInt(amountParam);

			if (amount < 5 || amount > 50) {

				throw new NumberFormatException("Invalid question amount");

			}

		} catch (NumberFormatException e) {

			request.setAttribute("errorMessage", "Invalid number of questions");

			response.sendRedirect(request.getContextPath() + "/quiz/api-quiz");

			return;

		}

		int timePerQuestion;

		try {

			timePerQuestion = Integer.parseInt(timePerQuestionParam);

			if (timePerQuestion < 0 || timePerQuestion > 120) {

				throw new NumberFormatException("Invalid time per question");

			}

		} catch (NumberFormatException e) {

			request.setAttribute("errorMessage", "Invalid time per question");

			response.sendRedirect(request.getContextPath() + "/quiz/api-quiz");

			return;

		}


		if (difficulty != null && !difficulty.isEmpty() && !isValidDifficulty(difficulty)) {

			request.setAttribute("errorMessage", "Invalid difficulty level");

			response.sendRedirect(request.getContextPath() + "/quiz/api-quiz");

			return;

		}


		List<Question> questions = apiQuestionService.createTemporaryAPIQuiz(amount, category, difficulty);

		if (questions == null || questions.isEmpty()) {

			request.setAttribute("errorMessage", "Failed to fetch questions from API");

			response.sendRedirect(request.getContextPath() + "/quiz/api-quiz");

			return;

		}


		if (shuffleQuestions) {

			Collections.shuffle(questions);

		}


		Quiz tempQuiz = new Quiz();

		tempQuiz.setId(-1); 

		tempQuiz.setTitle(getQuizTitle(category, difficulty, amount));

		tempQuiz.setDescription("A randomly generated quiz from OpenTDB API");

		tempQuiz.setDifficulty(difficulty != null && !difficulty.isEmpty() ? difficulty : "mixed");

		tempQuiz.setTimeLimit(timePerQuestion * amount); 


		Map<String, Object> apiQuizSettings = new HashMap<>();

		apiQuizSettings.put("questions", questions);

		apiQuizSettings.put("showCorrectAnswers", showCorrectAnswers);

		apiQuizSettings.put("timePerQuestion", timePerQuestion);

		apiQuizSettings.put("category", category);

		apiQuizSettings.put("difficulty", difficulty);

		apiQuizSettings.put("amount", amount);

		apiQuizSettings.put("quizTitle", tempQuiz.getTitle());

		request.getSession().setAttribute("apiQuizSettings", apiQuizSettings);

		request.setAttribute("quiz", tempQuiz);

		request.setAttribute("questions", questions);

		request.setAttribute("showCorrectAnswers", showCorrectAnswers);

		request.setAttribute("timePerQuestion", timePerQuestion);

		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/takequiz.jsp");

		dispatcher.forward(request, response);

	}

	private void submitQuiz(HttpServletRequest request, HttpServletResponse response)

			throws ServletException, IOException {

		if (!SessionManager.isLoggedIn(request)) {

			response.sendRedirect(request.getContextPath() + "/login");

			return;

		}

		User currentUser = SessionManager.getCurrentUser(request);

		try {

			int quizId = Integer.parseInt(request.getParameter("quizId"));

			int completionTime = Integer.parseInt(request.getParameter("completionTime"));

			List<Question> questions;

			Quiz quiz;

			boolean isApiQuiz = (quizId == -1); 

			if (isApiQuiz) {


				@SuppressWarnings("unchecked")

				Map<String, Object> apiQuizSettings = (Map<String, Object>) request.getSession()

						.getAttribute("apiQuizSettings");

				if (apiQuizSettings == null || apiQuizSettings.get("questions") == null) {

					request.setAttribute("errorMessage", "API quiz session expired");

					response.sendRedirect(request.getContextPath() + "/quiz/api-quiz");

					return;

				}

				questions = (List<Question>) apiQuizSettings.get("questions");

				quiz = new Quiz();

				quiz.setId(-1);

				quiz.setTitle((String) apiQuizSettings.get("quizTitle"));

				quiz.setDescription("A randomly generated quiz from OpenTDB API");

				quiz.setDifficulty((String) apiQuizSettings.get("difficulty"));

				quiz.setTimeLimit((Integer) apiQuizSettings.get("timePerQuestion") * questions.size());

			} else {

				quiz = quizService.getQuizById(quizId);

				if (quiz == null) {

					request.setAttribute("errorMessage", "Quiz not found");

					response.sendRedirect(request.getContextPath() + "/quizzes");

					return;

				}

				questions = questionService.getQuestionsByQuizId(quizId);

			}

			if (questions == null || questions.isEmpty()) {

				request.setAttribute("errorMessage", "This quiz has no questions");

				response.sendRedirect(isApiQuiz ? request.getContextPath() + "/quiz/api-quiz"

						: request.getContextPath() + "/quiz/" + quizId);

				return;

			}

			int correctAnswers = 0;

			List<Map<String, Object>> reviewQuestions = new ArrayList<>();

			for (Question question : questions) {

				String userAnswer = request.getParameter("answer_" + question.getId());

				boolean isCorrect = false;

				Map<String, Object> reviewQuestion = new HashMap<>();

				reviewQuestion.put("questionText", question.getQuestionText());

				reviewQuestion.put("optionA", question.getOptionA());

				reviewQuestion.put("optionB", question.getOptionB());

				reviewQuestion.put("optionC", question.getOptionC());

				reviewQuestion.put("optionD", question.getOptionD());

				reviewQuestion.put("correctAnswer", String.valueOf(question.getCorrectAnswer()));

				reviewQuestion.put("userAnswer", userAnswer);

				reviewQuestion.put("explanation", question.getExplanation());

				if (userAnswer != null && userAnswer.length() == 1) {

					char answer = userAnswer.charAt(0);

					if (question.getCorrectAnswer() == answer) {

						correctAnswers++;

						isCorrect = true;

					}

				}

				reviewQuestion.put("correct", isCorrect);

				reviewQuestions.add(reviewQuestion);

			}

			float scoreValue = (float) correctAnswers / questions.size() * 100;

			int scoreId = -1;


			if (isApiQuiz) {


				scoreId = scoreService.recordApiQuizScore(currentUser.getId(), quiz.getTitle(), quiz.getDifficulty(),

						scoreValue, completionTime, questions.size());

			} else {


				scoreId = scoreService.recordScore(currentUser.getId(), quizId, scoreValue, completionTime);

			}

			Map<String, Object> scoreResult = new HashMap<>();

			scoreResult.put("score", correctAnswers);

			scoreResult.put("totalQuestions", questions.size());

			scoreResult.put("percentage", Math.round(scoreValue));

			scoreResult.put("completionTime", completionTime);

			request.setAttribute("quiz", quiz);

			request.setAttribute("score", scoreResult);

			request.setAttribute("reviewQuestions", reviewQuestions);


			if (isApiQuiz) {

				request.getSession().removeAttribute("apiQuizSettings");

			}

			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/quizresult.jsp");

			dispatcher.forward(request, response);

		} catch (NumberFormatException e) {

			request.setAttribute("errorMessage", "Invalid quiz information");

			response.sendRedirect(request.getContextPath() + "/quizzes");

		}

	}

	private void showQuizResult(HttpServletRequest request, HttpServletResponse response)

			throws ServletException, IOException {

		if (!SessionManager.isLoggedIn(request)) {

			response.sendRedirect(request.getContextPath() + "/login");

			return;

		}

		String scoreIdParam = request.getParameter("scoreId");

		try {

			int scoreId = Integer.parseInt(scoreIdParam);

			Score score = scoreService.getScoreById(scoreId);

			if (score == null) {

				request.setAttribute("errorMessage", "Score not found");

				response.sendRedirect(request.getContextPath() + "/quizzes");

				return;

			}

			User currentUser = SessionManager.getCurrentUser(request);

			if (score.getUserId() != currentUser.getId()) {

				request.setAttribute("errorMessage", "You don't have permission to view this result");

				response.sendRedirect(request.getContextPath() + "/quizzes");

				return;

			}

			Quiz quiz = quizService.getQuizById(score.getQuizId());

			if (quiz == null) {

				request.setAttribute("errorMessage", "Quiz not found");

				response.sendRedirect(request.getContextPath() + "/quizzes");

				return;

			}

			List<Question> questions = questionService.getQuestionsByQuizId(quiz.getId());

			int totalQuestions = questions.size();

			Map<String, Object> scoreResult = new HashMap<>();

			scoreResult.put("score", Math.round(score.getScore() * totalQuestions / 100));

			scoreResult.put("totalQuestions", totalQuestions);

			scoreResult.put("percentage", Math.round(score.getScore()));

			scoreResult.put("completionTime", score.getCompletionTime());

			request.setAttribute("quiz", quiz);

			request.setAttribute("score", scoreResult);

			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/quizresult.jsp");

			dispatcher.forward(request, response);

		} catch (NumberFormatException e) {

			request.setAttribute("errorMessage", "Invalid score ID");

			response.sendRedirect(request.getContextPath() + "/quizzes");

		}

	}

	private int getIdFromPath(String pathInfo) {

		try {

			return Integer.parseInt(pathInfo.substring(1));

		} catch (NumberFormatException | StringIndexOutOfBoundsException e) {

			return -1;

		}

	}

	private boolean isValidDifficulty(String difficulty) {

		return difficulty != null

				&& (difficulty.equals("easy") || difficulty.equals("medium") || difficulty.equals("hard"));

	}

	private String getQuizTitle(String categoryId, String difficulty, int amount) {

		String categoryName = "Mixed Topics";

		if (categoryId != null && !categoryId.isEmpty()) {

			List<String> categories = apiQuestionService.getAPICategories();

			for (String cat : categories) {

				if (cat.startsWith(categoryId + "|")) {

					String[] parts = cat.split("\\|");

					if (parts.length >= 2) {

						categoryName = parts[1];

					}

					break;

				}

			}

		}

		String difficultyName = difficulty != null && !difficulty.isEmpty()

				? difficulty.substring(0, 1).toUpperCase() + difficulty.substring(1)

				: "Mixed";

		return String.format("%s Quiz (%d Questions, %s Difficulty)", categoryName, amount, difficultyName);

	}

}