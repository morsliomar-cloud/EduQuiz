package dz.eduquiz.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import dz.eduquiz.dao.CategoryDAO;
import dz.eduquiz.dao.QuizDAO;
import dz.eduquiz.dao.ScoreDAO;
import dz.eduquiz.dao.UserDAO;
import dz.eduquiz.model.Category;
import dz.eduquiz.model.Score;
import dz.eduquiz.model.UserStats;
import dz.eduquiz.util.ValidationUtil;

public class ScoreService {

	private ScoreDAO scoreDAO;

	private QuizDAO quizDAO;

	private UserDAO userDAO;

	private CategoryDAO categoryDAO;

	public ScoreService() {

		this.scoreDAO = new ScoreDAO();

		this.quizDAO = new QuizDAO();

		this.userDAO = new UserDAO();

		this.categoryDAO = new CategoryDAO();

	}

	public int recordScore(int userId, int quizId, float score, int completionTime) {

		if (!ValidationUtil.isPositiveInteger(userId) || !ValidationUtil.isPositiveInteger(quizId) || score < 0

				|| score > 100) {

			return -1;

		}

		if ((completionTime <= 0) || (userDAO.getUserById(userId) == null) || (quizDAO.getQuizById(quizId) == null)) {

			return -1;

		}

		Score scoreObj = new Score();

		scoreObj.setUserId(userId);

		scoreObj.setQuizId(quizId);

		scoreObj.setScore(score);

		scoreObj.setCompletionTime(completionTime);

		return scoreDAO.createScore(scoreObj);

	}



	public int recordApiQuizScore(int userId, String quizTitle, String difficulty, float score, int completionTime,

			int questionCount) {

		if (!ValidationUtil.isPositiveInteger(userId) || score < 0 || score > 100) {

			return -1;

		}


		if ((completionTime <= 0) || (userDAO.getUserById(userId) == null) || quizTitle == null

				|| quizTitle.trim().isEmpty()) {

			return -1;

		}

		Score scoreObj = new Score();

		scoreObj.setUserId(userId);

		scoreObj.setQuizId(-1); 

		scoreObj.setScore(score);

		scoreObj.setCompletionTime(completionTime);

		return scoreDAO.createScore(scoreObj);

	}

	public Score getScoreById(int id) {

		return scoreDAO.getScoreById(id);

	}

	public List<Score> getScoresByUserId(int userId) {

		if (!ValidationUtil.isPositiveInteger(userId)) {

			return null;

		}

		return scoreDAO.getScoresByUserId(userId);

	}


	public List<Score> getFilteredScoresByUserId(int userId, String category, String difficulty, String dateRange,

			int page, int pageSize) {

		if (!ValidationUtil.isPositiveInteger(userId)) {

			return null;

		}

		int offset = (page - 1) * pageSize;

		return scoreDAO.getFilteredScoresByUserId(userId, category, difficulty, dateRange, offset, pageSize);

	}


	public int countFilteredScoresByUserId(int userId, String category, String difficulty, String dateRange) {

		if (!ValidationUtil.isPositiveInteger(userId)) {

			return 0;

		}

		return scoreDAO.countFilteredScoresByUserId(userId, category, difficulty, dateRange);

	}


	public int getTotalQuizzesByUserId(int userId) {

		if (!ValidationUtil.isPositiveInteger(userId)) {

			return 0;

		}

		return scoreDAO.getTotalQuizzesByUserId(userId);

	}

	public float getAverageScoreByUserId(int userId) {

		if (!ValidationUtil.isPositiveInteger(userId)) {

			return 0;

		}

		return scoreDAO.getAverageScoreByUserId(userId);

	}

	public float getBestScoreByUserId(int userId) {

		if (!ValidationUtil.isPositiveInteger(userId)) {

			return 0;

		}

		return scoreDAO.getBestScoreByUserId(userId);

	}

	public float getScoreTrendByUserId(int userId) {

		if (!ValidationUtil.isPositiveInteger(userId)) {

			return 0;

		}

		return scoreDAO.getScoreTrendByUserId(userId);

	}


	public List<Category> getAllCategories() {

		return categoryDAO.getAllCategories();

	}

	public List<Score> getScoresByQuizId(int quizId) {

		if (!ValidationUtil.isPositiveInteger(quizId)) {

			return null;

		}

		return scoreDAO.getScoresByQuizId(quizId);

	}


	public List<Score> getApiQuizScoresByUserId(int userId) {

		if (!ValidationUtil.isPositiveInteger(userId)) {

			return null;

		}

		return scoreDAO.getApiQuizScoresByUserId(userId);

	}

	public List<Score> getTopScoresByQuizId(int quizId, int limit) {

		if (!ValidationUtil.isPositiveInteger(quizId) || !ValidationUtil.isPositiveInteger(limit)) {

			return null;

		}

		return scoreDAO.getTopScoresByQuizId(quizId, limit);

	}

	public Score getBestScoreByUserAndQuiz(int userId, int quizId) {

		if (!ValidationUtil.isPositiveInteger(userId) || !ValidationUtil.isPositiveInteger(quizId)) {

			return null;

		}

		return scoreDAO.getBestScoreByUserAndQuiz(userId, quizId);

	}

	public boolean deleteScore(int id) {

		return scoreDAO.deleteScore(id);

	}

	public boolean deleteScoresByUserId(int userId) {

		if (!ValidationUtil.isPositiveInteger(userId)) {

			return false;

		}

		return scoreDAO.deleteScoresByUserId(userId);

	}

	public boolean deleteScoresByQuizId(int quizId) {

		if (!ValidationUtil.isPositiveInteger(quizId)) {

			return false;

		}

		return scoreDAO.deleteScoresByQuizId(quizId);

	}

	public float calculateAverageScoreForQuiz(int quizId) {

		List<Score> scores = getScoresByQuizId(quizId);

		if (scores == null || scores.isEmpty()) {

			return 0;

		}

		float sum = 0;

		for (Score score : scores) {

			sum += score.getScore();

		}

		return sum / scores.size();

	}

	public float calculatePassRateForQuiz(int quizId) {

		List<Score> scores = getScoresByQuizId(quizId);

		if (scores == null || scores.isEmpty()) {

			return 0;

		}

		int passCount = 0;

		for (Score score : scores) {

			if (score.getScore() >= 60) {

				passCount++;

			}

		}

		return (float) passCount / scores.size() * 100;

	}


	public List<Score> getTopScoresWithFilters(String categoryId, String timeFilter, int limit) {

		return scoreDAO.getTopScoresWithFilters(categoryId, timeFilter, limit);

	}


	public ScoreDAO.UserRank getUserRank(int userId) {

		if (!ValidationUtil.isPositiveInteger(userId)) {

			return null;

		}

		return scoreDAO.getUserRank(userId);

	}


	public int getTotalQuestionsByQuizId(int quizId) {

		if (!ValidationUtil.isPositiveInteger(quizId)) {

			return 0;

		}

		return scoreDAO.getTotalQuestionsByQuizId(quizId);

	}


	public UserStats getUserStats(int userId) {

		UserStats stats = new UserStats();

		try {

			stats.setQuizzesTaken(scoreDAO.getQuizzesTakenByUser(userId));

			stats.setAverageScore(scoreDAO.getAverageScoreByUser(userId));

			stats.setHighestScore(scoreDAO.getHighestScoreByUser(userId));

			stats.setFavoriteCategory(scoreDAO.getFavoriteCategoryByUser(userId));

		} catch (SQLException e) {

			e.printStackTrace();

		}

		return stats;

	}

	public Map<String, Object> getPerformanceChartData(int userId, int limit) {

		Map<String, Object> result = new HashMap<>();

		List<Score> scores = getScoresByUserId(userId);

		if (scores.size() > limit) {

			scores = scores.subList(0, limit);

		}

		List<String> labels = new ArrayList<>();

		List<Double> data = new ArrayList<>();

		for (Score score : scores) {

			labels.add("Quiz " + score.getQuiz().getId());

			data.add((double) score.getScore());

		}


		Collections.reverse(labels);

		Collections.reverse(data);

		result.put("labels", labels);

		result.put("data", data);

		return result;

	}

	public Map<String, Object> getCategoryPerformanceData(int userId) {

		Map<String, Object> result = new HashMap<>();

		List<Score> scores = getScoresByUserId(userId);

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

			labels.add(entry.getKey());

			data.add(average);

		}

		result.put("labels", labels);

		result.put("data", data);

		return result;

	}

}