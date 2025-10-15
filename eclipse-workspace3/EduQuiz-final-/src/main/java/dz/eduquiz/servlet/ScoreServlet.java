package dz.eduquiz.servlet;

import java.io.IOException;
import java.util.List;

import dz.eduquiz.dao.ScoreDAO.UserRank; // Import the correct UserRank class
import dz.eduquiz.model.Category;
import dz.eduquiz.model.Score;
import dz.eduquiz.model.User;
import dz.eduquiz.service.ScoreService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/leaderboard")
public class ScoreServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ScoreService scoreService;

	@Override
	public void init() throws ServletException {
		scoreService = new ScoreService();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");

		if (action == null) {
			action = "leaderboard";
		}

		switch (action) {
		case "leaderboard":
			showLeaderboard(request, response);
			break;
		case "history":
			showUserHistory(request, response);
			break;
		case "quiz-scores":
			showQuizScores(request, response);
			break;
		default:
			showLeaderboard(request, response);
			break;
		}
	}

	private void showLeaderboard(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String categoryParam = request.getParameter("category");
		String timeFilter = request.getParameter("time");

		List<Category> categories = scoreService.getAllCategories();
		request.setAttribute("categories", categories);

		List<Score> topScores = scoreService.getTopScoresWithFilters(categoryParam, timeFilter, 50);
		request.setAttribute("topScores", topScores);

		for (Score score : topScores) {
			if (score.getQuiz() != null) {
				int totalQuestions = scoreService.getTotalQuestionsByQuizId(score.getQuizId());
				score.getQuiz().setTotalQuestions(totalQuestions);

				float percentage = totalQuestions > 0 ? (score.getScore() / totalQuestions) * 100 : 0;
				score.setPercentage(Math.round(percentage * 100.0f) / 100.0f);
			}
		}

		HttpSession session = request.getSession(false);
		if (session != null && session.getAttribute("user") != null) {
			User user = (User) session.getAttribute("user");
			UserRank userRank = scoreService.getUserRank(user.getId()); 
			if (userRank != null) {
				request.setAttribute("userRank", userRank);
			}
		}

		request.getRequestDispatcher("/WEB-INF/leaderboard.jsp").forward(request, response);
	}

	private void showUserHistory(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user") == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		User user = (User) session.getAttribute("user");

		String categoryParam = request.getParameter("category");
		String difficulty = request.getParameter("difficulty");
		String dateRange = request.getParameter("dateRange");

		int page = 1;
		try {
			page = Integer.parseInt(request.getParameter("page"));
		} catch (NumberFormatException e) {
			page = 1;
		}
		int pageSize = 10;

		List<Score> userScores = scoreService.getFilteredScoresByUserId(user.getId(), categoryParam, difficulty,
				dateRange, page, pageSize);

		int totalScores = scoreService.countFilteredScoresByUserId(user.getId(), categoryParam, difficulty, dateRange);

		int totalPages = (int) Math.ceil((double) totalScores / pageSize);

		List<Category> categories = scoreService.getAllCategories();

		request.setAttribute("userScores", userScores);
		request.setAttribute("categories", categories);
		request.setAttribute("currentPage", page);
		request.setAttribute("totalPages", totalPages);
		request.setAttribute("totalScores", totalScores);

		request.getRequestDispatcher("/WEB-INF/history.jsp").forward(request, response);
	}

	private void showQuizScores(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String quizIdParam = request.getParameter("quizId");
		if (quizIdParam == null) {
			response.sendRedirect(request.getContextPath() + "/quizzes");
			return;
		}

		try {
			int quizId = Integer.parseInt(quizIdParam);
			List<Score> quizScores = scoreService.getScoresByQuizId(quizId);

			request.setAttribute("quizScores", quizScores);
			request.setAttribute("quizId", quizId);

			request.getRequestDispatcher("/pages/quiz-scores.jsp").forward(request, response);

		} catch (NumberFormatException e) {
			response.sendRedirect(request.getContextPath() + "/quizzes");
		}
	}
}