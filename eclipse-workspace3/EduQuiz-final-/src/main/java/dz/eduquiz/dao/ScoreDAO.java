package dz.eduquiz.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import dz.eduquiz.model.Category;
import dz.eduquiz.model.Quiz;
import dz.eduquiz.model.Score;

public class ScoreDAO {

	public int createScore(Score score) {

		String sql = "INSERT INTO scores (user_id, quiz_id, score, completion_time) VALUES (?, ?, ?, ?)";

		try (Connection conn = DBConnection.getConnection();

				PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

			pstmt.setInt(1, score.getUserId());

			pstmt.setInt(2, score.getQuizId());

			pstmt.setFloat(3, score.getScore());

			pstmt.setInt(4, score.getCompletionTime());

			int affectedRows = pstmt.executeUpdate();

			if (affectedRows == 0) {

				throw new SQLException("Creating score failed, no rows affected.");

			}

			try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {

				if (generatedKeys.next()) {

					score.setId(generatedKeys.getInt(1));

					return score.getId();

				} else {

					throw new SQLException("Creating score failed, no ID obtained.");

				}

			}

		} catch (SQLException e) {

			e.printStackTrace();

			return -1;

		}

	}

	public List<Score> getApiQuizScoresByUserId(int userId) {

		List<Score> scores = new ArrayList<>();

		String sql = "SELECT s.*, u.username FROM scores s JOIN users u ON s.user_id = u.id WHERE s.user_id = ? AND s.quiz_id = -1 ORDER BY s.date_taken DESC";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);

			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {

				Score score = new Score();

				score.setId(rs.getInt("id"));

				score.setUserId(rs.getInt("user_id"));

				score.setQuizId(rs.getInt("quiz_id"));

				score.setScore(rs.getFloat("score"));

				score.setCompletionTime(rs.getInt("completion_time"));

				score.setDateTaken(rs.getTimestamp("date_taken"));

				score.setUserName(rs.getString("username"));

				scores.add(score);

			}

		} catch (SQLException e) {

			e.printStackTrace();

		}

		return scores;

	}

	public Score getScoreById(int id) {

		String sql = "SELECT s.*, u.username, q.title as quiz_title, q.description as quiz_description, "

				+ "q.difficulty, q.time_limit, c.id as category_id, c.name as category_name, c.description as category_description "

				+ "FROM scores s " + "JOIN users u ON s.user_id = u.id " + "LEFT JOIN quizzes q ON s.quiz_id = q.id "

				+ "LEFT JOIN categories c ON q.category_id = c.id " + "WHERE s.id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, id);

			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {

				Score score = createScoreFromResultSet(rs);

				return score;

			}

		} catch (SQLException e) {

			e.printStackTrace();

		}

		return null;

	}

	public List<Score> getScoresByUserId(int userId) {

		List<Score> scores = new ArrayList<>();

		String sql = "SELECT s.*, u.username, q.title as quiz_title, q.description as quiz_description, "

				+ "q.difficulty, q.time_limit, c.id as category_id, c.name as category_name, c.description as category_description "

				+ "FROM scores s " + "JOIN users u ON s.user_id = u.id " + "LEFT JOIN quizzes q ON s.quiz_id = q.id "

				+ "LEFT JOIN categories c ON q.category_id = c.id " + "WHERE s.user_id = ? "

				+ "ORDER BY s.date_taken DESC";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);

			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {

				Score score = createScoreFromResultSet(rs);

				scores.add(score);

			}

		} catch (SQLException e) {

			e.printStackTrace();

		}

		return scores;

	}


	public List<Score> getFilteredScoresByUserId(int userId, String category, String difficulty, String dateRange,

			int offset, int limit) {

		List<Score> scores = new ArrayList<>();

		StringBuilder sql = new StringBuilder();

		sql.append("SELECT s.*, u.username, q.title as quiz_title, q.description as quiz_description, ");

		sql.append(

				"q.difficulty, q.time_limit, c.id as category_id, c.name as category_name, c.description as category_description ");

		sql.append("FROM scores s ");

		sql.append("JOIN users u ON s.user_id = u.id ");

		sql.append("LEFT JOIN quizzes q ON s.quiz_id = q.id ");

		sql.append("LEFT JOIN categories c ON q.category_id = c.id ");

		sql.append("WHERE s.user_id = ? AND s.quiz_id != -1 "); 


		if (category != null && !category.isEmpty()) {

			sql.append("AND c.id = ? ");

		}

		if (difficulty != null && !difficulty.isEmpty()) {

			sql.append("AND q.difficulty = ? ");

		}

		if (dateRange != null && !dateRange.isEmpty()) {

			sql.append("AND s.date_taken >= DATE_SUB(NOW(), INTERVAL ? DAY) ");

		}

		sql.append("ORDER BY s.date_taken DESC LIMIT ? OFFSET ?");

		try (Connection conn = DBConnection.getConnection();

				PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

			int paramIndex = 1;

			pstmt.setInt(paramIndex++, userId);

			if (category != null && !category.isEmpty()) {

				pstmt.setInt(paramIndex++, Integer.parseInt(category));

			}

			if (difficulty != null && !difficulty.isEmpty()) {

				pstmt.setString(paramIndex++, difficulty);

			}

			if (dateRange != null && !dateRange.isEmpty()) {

				pstmt.setInt(paramIndex++, Integer.parseInt(dateRange));

			}

			pstmt.setInt(paramIndex++, limit);

			pstmt.setInt(paramIndex, offset);

			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {

				Score score = createScoreFromResultSet(rs);

				scores.add(score);

			}

		} catch (SQLException e) {

			e.printStackTrace();

		}

		return scores;

	}


	public int countFilteredScoresByUserId(int userId, String category, String difficulty, String dateRange) {

		StringBuilder sql = new StringBuilder();

		sql.append("SELECT COUNT(*) FROM scores s ");

		sql.append("LEFT JOIN quizzes q ON s.quiz_id = q.id ");

		sql.append("LEFT JOIN categories c ON q.category_id = c.id ");

		sql.append("WHERE s.user_id = ? AND s.quiz_id != -1 "); 


		if (category != null && !category.isEmpty()) {

			sql.append("AND c.id = ? ");

		}

		if (difficulty != null && !difficulty.isEmpty()) {

			sql.append("AND q.difficulty = ? ");

		}

		if (dateRange != null && !dateRange.isEmpty()) {

			sql.append("AND s.date_taken >= DATE_SUB(NOW(), INTERVAL ? DAY) ");

		}

		try (Connection conn = DBConnection.getConnection();

				PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

			int paramIndex = 1;

			pstmt.setInt(paramIndex++, userId);

			if (category != null && !category.isEmpty()) {

				pstmt.setInt(paramIndex++, Integer.parseInt(category));

			}

			if (difficulty != null && !difficulty.isEmpty()) {

				pstmt.setString(paramIndex++, difficulty);

			}

			if (dateRange != null && !dateRange.isEmpty()) {

				pstmt.setInt(paramIndex++, Integer.parseInt(dateRange));

			}

			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {

				return rs.getInt(1);

			}

		} catch (SQLException e) {

			e.printStackTrace();

		}

		return 0;

	}


	public int getTotalQuizzesByUserId(int userId) {

		String sql = "SELECT COUNT(*) FROM scores WHERE user_id = ? AND quiz_id != -1";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);

			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {

				return rs.getInt(1);

			}

		} catch (SQLException e) {

			e.printStackTrace();

		}

		return 0;

	}

	public float getAverageScoreByUserId(int userId) {

		String sql = "SELECT AVG(score) FROM scores WHERE user_id = ? AND quiz_id != -1";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);

			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {

				return rs.getFloat(1);

			}

		} catch (SQLException e) {

			e.printStackTrace();

		}

		return 0;

	}

	public float getBestScoreByUserId(int userId) {

		String sql = "SELECT MAX(score) FROM scores WHERE user_id = ? AND quiz_id != -1";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);

			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {

				return rs.getFloat(1);

			}

		} catch (SQLException e) {

			e.printStackTrace();

		}

		return 0;

	}

	public float getScoreTrendByUserId(int userId) {

		String sql = "SELECT "

				+ "(SELECT AVG(score) FROM scores WHERE user_id = ? AND quiz_id != -1 AND date_taken >= DATE_SUB(NOW(), INTERVAL 30 DAY)) - "

				+ "(SELECT AVG(score) FROM scores WHERE user_id = ? AND quiz_id != -1 AND date_taken < DATE_SUB(NOW(), INTERVAL 30 DAY))";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);

			pstmt.setInt(2, userId);

			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {

				return rs.getFloat(1);

			}

		} catch (SQLException e) {

			e.printStackTrace();

		}

		return 0;

	}


	private Score createScoreFromResultSet(ResultSet rs) throws SQLException {

		Score score = new Score();

		score.setId(rs.getInt("id"));

		score.setUserId(rs.getInt("user_id"));

		score.setQuizId(rs.getInt("quiz_id"));

		score.setScore(rs.getFloat("score"));

		score.setCompletionTime(rs.getInt("completion_time"));

		score.setDateTaken(rs.getTimestamp("date_taken"));

		score.setUserName(rs.getString("username"));


		if (rs.getString("quiz_title") != null) {

			Quiz quiz = new Quiz();

			quiz.setId(rs.getInt("quiz_id"));

			quiz.setTitle(rs.getString("quiz_title"));

			quiz.setDescription(rs.getString("quiz_description"));

			quiz.setDifficulty(rs.getString("difficulty"));

			quiz.setTimeLimit(rs.getInt("time_limit"));


			if (rs.getString("category_name") != null) {

				Category category = new Category();

				category.setId(rs.getInt("category_id"));

				category.setName(rs.getString("category_name"));

				category.setDescription(rs.getString("category_description"));

				quiz.setCategory(category);

			}

			score.setQuiz(quiz);

		}

		return score;

	}


	public List<Score> getScoresByQuizId(int quizId) {

		List<Score> scores = new ArrayList<>();

		String sql = "SELECT s.*, u.username FROM scores s JOIN users u ON s.user_id = u.id WHERE s.quiz_id = ? ORDER BY s.score DESC, s.completion_time ASC";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, quizId);

			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {

				Score score = new Score();

				score.setId(rs.getInt("id"));

				score.setUserId(rs.getInt("user_id"));

				score.setQuizId(rs.getInt("quiz_id"));

				score.setScore(rs.getFloat("score"));

				score.setCompletionTime(rs.getInt("completion_time"));

				score.setDateTaken(rs.getTimestamp("date_taken"));

				score.setUserName(rs.getString("username"));

				scores.add(score);

			}

		} catch (SQLException e) {

			e.printStackTrace();

		}

		return scores;

	}

	public List<Score> getTopScoresByQuizId(int quizId, int limit) {

		List<Score> scores = new ArrayList<>();

		String sql = "SELECT s.*, u.username FROM scores s JOIN users u ON s.user_id = u.id WHERE s.quiz_id = ? ORDER BY s.score DESC, s.completion_time ASC LIMIT ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, quizId);

			pstmt.setInt(2, limit);

			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {

				Score score = new Score();

				score.setId(rs.getInt("id"));

				score.setUserId(rs.getInt("user_id"));

				score.setQuizId(rs.getInt("quiz_id"));

				score.setScore(rs.getFloat("score"));

				score.setCompletionTime(rs.getInt("completion_time"));

				score.setDateTaken(rs.getTimestamp("date_taken"));

				score.setUserName(rs.getString("username"));

				scores.add(score);

			}

		} catch (SQLException e) {

			e.printStackTrace();

		}

		return scores;

	}

	public Score getBestScoreByUserAndQuiz(int userId, int quizId) {

		String sql = "SELECT s.*, u.username FROM scores s JOIN users u ON s.user_id = u.id WHERE s.user_id = ? AND s.quiz_id = ? ORDER BY s.score DESC, s.completion_time ASC LIMIT 1";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);

			pstmt.setInt(2, quizId);

			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {

				Score score = new Score();

				score.setId(rs.getInt("id"));

				score.setUserId(rs.getInt("user_id"));

				score.setQuizId(rs.getInt("quiz_id"));

				score.setScore(rs.getFloat("score"));

				score.setCompletionTime(rs.getInt("completion_time"));

				score.setDateTaken(rs.getTimestamp("date_taken"));

				score.setUserName(rs.getString("username"));

				return score;

			}

		} catch (SQLException e) {

			e.printStackTrace();

		}

		return null;

	}

	public boolean deleteScore(int id) {

		String sql = "DELETE FROM scores WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, id);

			int affectedRows = pstmt.executeUpdate();

			return affectedRows > 0;

		} catch (SQLException e) {

			e.printStackTrace();

			return false;

		}

	}

	public boolean deleteScoresByUserId(int userId) {

		String sql = "DELETE FROM scores WHERE user_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);

			int affectedRows = pstmt.executeUpdate();

			return affectedRows > 0;

		} catch (SQLException e) {

			e.printStackTrace();

			return false;

		}

	}

	public boolean deleteScoresByQuizId(int quizId) {

		String sql = "DELETE FROM scores WHERE quiz_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, quizId);

			int affectedRows = pstmt.executeUpdate();

			return affectedRows > 0;

		} catch (SQLException e) {

			e.printStackTrace();

			return false;

		}

	}



	public List<Score> getTopScoresWithFilters(String categoryId, String timeFilter, int limit) {

		List<Score> scores = new ArrayList<>();

		StringBuilder sql = new StringBuilder();

		sql.append("SELECT s.*, u.username, q.title as quiz_title, q.description as quiz_description, ");

		sql.append("q.difficulty, q.time_limit, c.id as category_id, c.name as category_name, ");

		sql.append("c.description as category_description ");

		sql.append("FROM scores s ");

		sql.append("JOIN users u ON s.user_id = u.id ");

		sql.append("JOIN quizzes q ON s.quiz_id = q.id ");

		sql.append("JOIN categories c ON q.category_id = c.id ");

		sql.append("WHERE s.quiz_id != -1 ");


		if (categoryId != null && !categoryId.isEmpty()) {

			sql.append("AND c.id = ? ");

		}


		if (timeFilter != null && !timeFilter.isEmpty()) {

			switch (timeFilter) {

			case "day":

				sql.append("AND s.date_taken >= DATE_SUB(NOW(), INTERVAL 1 DAY) ");

				break;

			case "week":

				sql.append("AND s.date_taken >= DATE_SUB(NOW(), INTERVAL 1 WEEK) ");

				break;

			case "month":

				sql.append("AND s.date_taken >= DATE_SUB(NOW(), INTERVAL 1 MONTH) ");

				break;

			}

		}

		sql.append("ORDER BY s.score DESC, s.completion_time ASC LIMIT ?");

		try (Connection conn = DBConnection.getConnection();

				PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

			int paramIndex = 1;

			if (categoryId != null && !categoryId.isEmpty()) {

				pstmt.setInt(paramIndex++, Integer.parseInt(categoryId));

			}

			pstmt.setInt(paramIndex, limit);

			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {

				Score score = createScoreFromResultSet(rs);

				scores.add(score);

			}

		} catch (SQLException e) {

			e.printStackTrace();

		}

		return scores;

	}

	/**
	 *
	 * Get user rank based on total score and average performance
	 *
	 */

	public UserRank getUserRank(int userId) {

		String sql = "SELECT " + "  (SELECT COUNT(*) + 1 FROM (" + "    SELECT user_id, SUM(score) as total_score "

				+ "    FROM scores " + "    WHERE quiz_id != -1 " + "    GROUP BY user_id "

				+ "    HAVING total_score > (SELECT SUM(score) FROM scores WHERE user_id = ? AND quiz_id != -1)"

				+ "  ) as ranked_users) as rank, " + "  COALESCE(SUM(s.score), 0) as total_score, "

				+ "  COUNT(s.id) as quizzes_taken, " + "  COALESCE(AVG(s.score), 0) as average_score "

				+ "FROM scores s " + "WHERE s.user_id = ? AND s.quiz_id != -1";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);

			pstmt.setInt(2, userId);

			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {

				int rank = rs.getInt("rank");

				int totalScore = rs.getInt("total_score");

				int quizzesTaken = rs.getInt("quizzes_taken");

				float averageScore = rs.getFloat("average_score");

				return new UserRank(rank, totalScore, quizzesTaken, Math.round(averageScore * 100.0f) / 100.0f);

			}

		} catch (SQLException e) {

			e.printStackTrace();

		}

		return null;

	}

	/**
	 *
	 * Get total number of questions for a quiz
	 *
	 */

	public int getTotalQuestionsByQuizId(int quizId) {

		String sql = "SELECT COUNT(*) FROM questions WHERE quiz_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, quizId);

			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {

				return rs.getInt(1);

			}

		} catch (SQLException e) {

			e.printStackTrace();

		}

		return 0;

	}


	public static class UserRank {

		private int rank;

		private int totalScore;

		private int quizzesTaken;

		private float averageScore;

		public UserRank(int rank, int totalScore, int quizzesTaken, float averageScore) {

			this.rank = rank;

			this.totalScore = totalScore;

			this.quizzesTaken = quizzesTaken;

			this.averageScore = averageScore;

		}


		public int getRank() {

			return rank;

		}

		public void setRank(int rank) {

			this.rank = rank;

		}

		public int getTotalScore() {

			return totalScore;

		}

		public void setTotalScore(int totalScore) {

			this.totalScore = totalScore;

		}

		public int getQuizzesTaken() {

			return quizzesTaken;

		}

		public void setQuizzesTaken(int quizzesTaken) {

			this.quizzesTaken = quizzesTaken;

		}

		public float getAverageScore() {

			return averageScore;

		}

		public void setAverageScore(float averageScore) {

			this.averageScore = averageScore;

		}

	}


	public int getQuizzesTakenByUser(int userId) throws SQLException {

		String sql = "SELECT COUNT(*) FROM scores WHERE user_id = ? AND quiz_id != -1";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setInt(1, userId);

			ResultSet rs = stmt.executeQuery();

			return rs.next() ? rs.getInt(1) : 0;

		}

	}

	public double getAverageScoreByUser(int userId) throws SQLException {

		String sql = "SELECT AVG(score) FROM scores WHERE user_id = ? AND quiz_id != -1";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setInt(1, userId);

			ResultSet rs = stmt.executeQuery();

			return rs.next() ? rs.getDouble(1) : 0.0;

		}

	}

	public double getHighestScoreByUser(int userId) throws SQLException {

		String sql = "SELECT MAX(score) FROM scores WHERE user_id = ? AND quiz_id != -1";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setInt(1, userId);

			ResultSet rs = stmt.executeQuery();

			return rs.next() ? rs.getDouble(1) : 0.0;

		}

	}

	public String getFavoriteCategoryByUser(int userId) throws SQLException {

		String sql = "SELECT c.name FROM categories c " + "JOIN quizzes q ON c.id = q.category_id "

				+ "JOIN scores s ON q.id = s.quiz_id " + "WHERE s.user_id = ? AND s.quiz_id != -1 " + "GROUP BY c.name "

				+ "ORDER BY COUNT(*) DESC " + "LIMIT 1";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setInt(1, userId);

			ResultSet rs = stmt.executeQuery();

			return rs.next() ? rs.getString(1) : "None";

		}

	}

	public List<Score> getScoresByUserId(int userId, int limit) {

		List<Score> scores = new ArrayList<>();

		String sql = "SELECT s.*, u.username, q.title as quiz_title, q.description as quiz_description, "

				+ "q.difficulty, q.time_limit, c.id as category_id, c.name as category_name, c.description as category_description "

				+ "FROM scores s " + "JOIN users u ON s.user_id = u.id " + "LEFT JOIN quizzes q ON s.quiz_id = q.id "

				+ "LEFT JOIN categories c ON q.category_id = c.id " + "WHERE s.user_id = ? "

				+ "ORDER BY s.date_taken DESC LIMIT ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);

			pstmt.setInt(2, limit);

			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {

				Score score = createScoreFromResultSet(rs);

				scores.add(score);

			}

		} catch (SQLException e) {

			e.printStackTrace();

		}

		return scores;

	}

}