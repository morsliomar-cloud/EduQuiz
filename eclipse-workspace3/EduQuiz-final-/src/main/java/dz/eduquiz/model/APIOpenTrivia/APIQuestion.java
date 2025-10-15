package dz.eduquiz.model.APIOpenTrivia;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import dz.eduquiz.util.APIOpenTrivia.JSONParser;



public class APIQuestion {

	private String category;

	private String type;

	private String difficulty;

	private String question;

	private String correctAnswer;

	private String[] incorrectAnswers;


	public APIQuestion() {

	}

	public APIQuestion(String category, String type, String difficulty, String question, String correctAnswer,

			String[] incorrectAnswers) {

		this.category = category;

		this.type = type;

		this.difficulty = difficulty;

		this.question = question;

		this.correctAnswer = correctAnswer;

		this.incorrectAnswers = incorrectAnswers;

	}


	public String getCategory() {

		return category;

	}

	public void setCategory(String category) {

		this.category = category;

	}

	public String getType() {

		return type;

	}

	public void setType(String type) {

		this.type = type;

	}

	public String getDifficulty() {

		return difficulty;

	}

	public void setDifficulty(String difficulty) {

		this.difficulty = difficulty;

	}

	public String getQuestion() {

		return question;

	}

	public void setQuestion(String question) {

		this.question = question;

	}

	public String getCorrectAnswer() {

		return correctAnswer;

	}

	public void setCorrectAnswer(String correctAnswer) {

		this.correctAnswer = correctAnswer;

	}

	public String[] getIncorrectAnswers() {

		return incorrectAnswers;

	}

	public void setIncorrectAnswers(String[] incorrectAnswers) {

		this.incorrectAnswers = incorrectAnswers;

	}



	public String[] getAllAnswers() {

		if (incorrectAnswers == null || correctAnswer == null) {

			return new String[0];

		}

		List<String> allAnswers = new ArrayList<>();

		allAnswers.add(correctAnswer);

		for (String incorrect : incorrectAnswers) {

			allAnswers.add(incorrect);

		}


		return allAnswers.toArray(new String[0]);

	}


	public String[] getShuffledAnswers() {

		String[] allAnswers = getAllAnswers();

		List<String> answerList = new ArrayList<>();

		for (String answer : allAnswers) {

			answerList.add(answer);

		}

		Collections.shuffle(answerList);

		return answerList.toArray(new String[0]);

	}



	public void decodeHtmlEntities() {

		this.category = JSONParser.decodeHtmlEntities(this.category);

		this.question = JSONParser.decodeHtmlEntities(this.question);

		this.correctAnswer = JSONParser.decodeHtmlEntities(this.correctAnswer);

		if (this.incorrectAnswers != null) {

			this.incorrectAnswers = JSONParser.decodeHtmlEntitiesArray(this.incorrectAnswers);

		}

	}


	public boolean isMultipleChoice() {

		return "multiple".equals(this.type);

	}



	public boolean isTrueFalse() {

		return "boolean".equals(this.type);

	}


	public int getDifficultyLevel() {

		if (difficulty == null) {

			return 0;

		}

		switch (difficulty.toLowerCase()) {

		case "easy":

			return 1;

		case "medium":

			return 2;

		case "hard":

			return 3;

		default:

			return 0;

		}

	}


	public int getCategoryIdEstimate() {

		if (category == null) {

			return 1; 

		}

		String categoryLower = category.toLowerCase();

		if (categoryLower.contains("general knowledge")) {

			return 1;

		} else if (categoryLower.contains("science") || categoryLower.contains("nature")) {

			return 2;

		} else if (categoryLower.contains("history")) {

			return 3;

		} else if (categoryLower.contains("geography")) {

			return 4;

		} else if (categoryLower.contains("sports")) {

			return 5;

		} else if (categoryLower.contains("entertainment") || categoryLower.contains("film")

				|| categoryLower.contains("music") || categoryLower.contains("television")) {

			return 6;

		} else if (categoryLower.contains("art")) {

			return 7;

		} else if (categoryLower.contains("politics")) {

			return 8;

		} else {

			return 1;  

		}

	}


	public boolean isValid() {

		return question != null && !question.trim().isEmpty() && correctAnswer != null

				&& !correctAnswer.trim().isEmpty() && incorrectAnswers != null && incorrectAnswers.length > 0

				&& difficulty != null && !difficulty.trim().isEmpty() && type != null && !type.trim().isEmpty();

	}



	public int getAnswerCount() {

		return 1 + (incorrectAnswers != null ? incorrectAnswers.length : 0);

	}

	

	@Override

	public String toString() {

		StringBuilder sb = new StringBuilder();

		sb.append("APIQuestion{\n");

		sb.append("  category='").append(category).append("',\n");

		sb.append("  type='").append(type).append("',\n");

		sb.append("  difficulty='").append(difficulty).append("',\n");

		sb.append("  question='").append(question).append("',\n");

		sb.append("  correctAnswer='").append(correctAnswer).append("',\n");

		sb.append("  incorrectAnswers=[");

		if (incorrectAnswers != null) {

			for (int i = 0; i < incorrectAnswers.length; i++) {

				sb.append("'").append(incorrectAnswers[i]).append("'");

				if (i < incorrectAnswers.length - 1) {

					sb.append(", ");

				}

			}

		}

		sb.append("]\n}");

		return sb.toString();

	}



	public APIQuestion copy() {

		APIQuestion copy = new APIQuestion();

		copy.setCategory(this.category);

		copy.setType(this.type);

		copy.setDifficulty(this.difficulty);

		copy.setQuestion(this.question);

		copy.setCorrectAnswer(this.correctAnswer);

		if (this.incorrectAnswers != null) {

			String[] incorrectCopy = new String[this.incorrectAnswers.length];

			System.arraycopy(this.incorrectAnswers, 0, incorrectCopy, 0, this.incorrectAnswers.length);

			copy.setIncorrectAnswers(incorrectCopy);

		}

		return copy;

	}

}