package dz.eduquiz.model;

import java.sql.Timestamp;

public class Score {
	private int id;
	private int userId;
	private int quizId;
	private float score;
	private int completionTime;
	private Timestamp dateTaken;
	private String userName;
	private float percentage; 


	private Quiz quiz;

	public Score() {
	}

	public Score(int userId, int quizId, float score, int completionTime) {
		this.userId = userId;
		this.quizId = quizId;
		this.score = score;
		this.completionTime = completionTime;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public int getQuizId() {
		return quizId;
	}

	public void setQuizId(int quizId) {
		this.quizId = quizId;
	}

	public float getScore() {
		return score;
	}

	public void setScore(float score) {
		this.score = score;
	}

	public int getCompletionTime() {
		return completionTime;
	}

	public void setCompletionTime(int completionTime) {
		this.completionTime = completionTime;
	}

	public Timestamp getDateTaken() {
		return dateTaken;
	}

	public void setDateTaken(Timestamp dateTaken) {
		this.dateTaken = dateTaken;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public Quiz getQuiz() {
		return quiz;
	}

	public void setQuiz(Quiz quiz) {
		this.quiz = quiz;
	}

	public float getPercentage() {
		return percentage;
	}

	public void setPercentage(float percentage) {
		this.percentage = percentage;
	}

	@Override
	public String toString() {
		return "Score [id=" + id + ", userId=" + userId + ", quizId=" + quizId + ", score=" + score
				+ ", completionTime=" + completionTime + ", dateTaken=" + dateTaken + ", userName=" + userName
				+ ", percentage=" + percentage + "]";
	}
}