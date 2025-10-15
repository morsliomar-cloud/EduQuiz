package dz.eduquiz.service;

import java.util.List;

import dz.eduquiz.dao.QuestionDAO;
import dz.eduquiz.model.Question;
import dz.eduquiz.model.APIOpenTrivia.APIQuestion;
import dz.eduquiz.service.APIOpenTrivia.APIQuestionService;
import dz.eduquiz.util.ValidationUtil;

public class QuestionService {
	private QuestionDAO questionDAO;
	private APIQuestionService apiQuestionService;

	public QuestionService() {
		this.questionDAO = new QuestionDAO();
		this.apiQuestionService = new APIQuestionService();
	}

	public int addQuestion(int quizId, String questionText, String optionA, String optionB, String optionC,
			String optionD, char correctAnswer) {
		if (!ValidationUtil.isPositiveInteger(quizId) || !ValidationUtil.isNotEmpty(questionText)) {
			return -1;
		}

		if (!ValidationUtil.isNotEmpty(optionA) || !ValidationUtil.isNotEmpty(optionB)
				|| !ValidationUtil.isNotEmpty(optionC) || !ValidationUtil.isNotEmpty(optionD)) {
			return -1;
		}

		if (!isValidAnswer(correctAnswer)) {
			return -1;
		}

		Question question = new Question();
		question.setQuizId(quizId);
		question.setQuestionText(questionText);
		question.setOptionA(optionA);
		question.setOptionB(optionB);
		question.setOptionC(optionC);
		question.setOptionD(optionD);
		question.setCorrectAnswer(correctAnswer);

		return questionDAO.createQuestion(question);
	}

	public Question getQuestionById(int id) {
		return questionDAO.getQuestionById(id);
	}

	public List<Question> getQuestionsByQuizId(int quizId) {
		if (!ValidationUtil.isPositiveInteger(quizId)) {
			return null;
		}

		return questionDAO.getQuestionsByQuizId(quizId);
	}

	public boolean updateQuestion(int id, int quizId, String questionText, String optionA, String optionB,
			String optionC, String optionD, char correctAnswer) {
		if (!ValidationUtil.isPositiveInteger(quizId) || !ValidationUtil.isNotEmpty(questionText)) {
			return false;
		}

		if (!ValidationUtil.isNotEmpty(optionA) || !ValidationUtil.isNotEmpty(optionB)
				|| !ValidationUtil.isNotEmpty(optionC) || !ValidationUtil.isNotEmpty(optionD)) {
			return false;
		}

		if (!isValidAnswer(correctAnswer)) {
			return false;
		}

		Question question = questionDAO.getQuestionById(id);
		if (question == null) {
			return false;
		}

		question.setQuizId(quizId);
		question.setQuestionText(questionText);
		question.setOptionA(optionA);
		question.setOptionB(optionB);
		question.setOptionC(optionC);
		question.setOptionD(optionD);
		question.setCorrectAnswer(correctAnswer);

		return questionDAO.updateQuestion(question);
	}

	public boolean deleteQuestion(int id) {
		return questionDAO.deleteQuestion(id);
	}

	public boolean deleteQuestionsByQuizId(int quizId) {
		if (!ValidationUtil.isPositiveInteger(quizId)) {
			return false;
		}

		return questionDAO.deleteQuestionsByQuizId(quizId);
	}

	public int countQuestionsByQuizId(int quizId) {
		if (!ValidationUtil.isPositiveInteger(quizId)) {
			return 0;
		}

		return questionDAO.countQuestionsByQuizId(quizId);
	}

	private boolean isValidAnswer(char answer) {
		return answer == 'A' || answer == 'B' || answer == 'C' || answer == 'D';
	}

	public boolean isCorrectAnswer(int questionId, char answer) {
		Question question = questionDAO.getQuestionById(questionId);
		if (question == null) {
			return false;
		}

		return question.getCorrectAnswer() == answer;
	}


	public int convertAndSaveAPIQuestion(APIQuestion apiQuestion, int quizId) {
		if (apiQuestion == null || !apiQuestion.isValid() || !ValidationUtil.isPositiveInteger(quizId)) {
			return -1;
		}

		Question question = apiQuestionService.convertToLocalQuestion(apiQuestion, quizId);
		if (question == null) {
			return -1;
		}

		if (!ValidationUtil.isNotEmpty(question.getQuestionText()) || !ValidationUtil.isNotEmpty(question.getOptionA())
				|| !ValidationUtil.isNotEmpty(question.getOptionB())
				|| !ValidationUtil.isNotEmpty(question.getOptionC())
				|| !ValidationUtil.isNotEmpty(question.getOptionD()) || !isValidAnswer(question.getCorrectAnswer())) {
			return -1;
		}

		return questionDAO.createQuestion(question);
	}
}