
package dz.eduquiz.model;

public class UserStats {
	private int quizzesTaken;
	private double averageScore;
	private double highestScore;
	private String favoriteCategory;

	public UserStats() {
	}

	public int getQuizzesTaken() {
		return quizzesTaken;
	}

	public void setQuizzesTaken(int quizzesTaken) {
		this.quizzesTaken = quizzesTaken;
	}

	public double getAverageScore() {
		return averageScore;
	}

	public void setAverageScore(double averageScore) {
		this.averageScore = averageScore;
	}

	public double getHighestScore() {
		return highestScore;
	}

	public void setHighestScore(double highestScore) {
		this.highestScore = highestScore;
	}

	public String getFavoriteCategory() {
		return favoriteCategory;
	}

	public void setFavoriteCategory(String favoriteCategory) {
		this.favoriteCategory = favoriteCategory;
	}
}