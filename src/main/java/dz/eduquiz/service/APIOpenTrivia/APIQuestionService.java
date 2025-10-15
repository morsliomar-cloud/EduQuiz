package dz.eduquiz.service.APIOpenTrivia;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

import org.json.JSONArray;
import org.json.JSONObject;

import dz.eduquiz.dao.QuestionDAO;
import dz.eduquiz.dao.QuizDAO;
import dz.eduquiz.model.Question;
import dz.eduquiz.model.Quiz;
import dz.eduquiz.model.APIOpenTrivia.APIQuestion;


public class APIQuestionService {

	private static final String BASE_URL = "https://opentdb.com/api.php";

	private static final String CATEGORIES_URL = "https://opentdb.com/api_category.php";


	private static final Map<String, String> categoriesCache = new ConcurrentHashMap<>();

	private static long categoriesCacheTime = 0;

	private static final long CACHE_DURATION = 24 * 60 * 60 * 1000; 

	private QuestionDAO questionDAO;

	private QuizDAO quizDAO;


	private static final String[] FALLBACK_CATEGORIES = { "9|General Knowledge", "10|Entertainment: Books",

			"11|Entertainment: Film", "12|Entertainment: Music", "13|Entertainment: Musicals & Theatres",

			"14|Entertainment: Television", "15|Entertainment: Video Games", "16|Entertainment: Board Games",

			"17|Science & Nature", "18|Science: Computers", "19|Science: Mathematics", "20|Mythology", "21|Sports",

			"22|Geography", "23|History", "24|Politics", "25|Art", "26|Celebrities", "27|Animals", "28|Vehicles",

			"29|Entertainment: Comics", "30|Science: Gadgets", "31|Entertainment: Japanese Anime & Manga",

			"32|Entertainment: Cartoon & Animations" };

	public APIQuestionService() {

		this.questionDAO = new QuestionDAO();

		this.quizDAO = new QuizDAO();

	}


	public List<String> getAPICategories() {


		long currentTime = System.currentTimeMillis();

		if (!categoriesCache.isEmpty() && (currentTime - categoriesCacheTime) < CACHE_DURATION) {

			return new ArrayList<>(categoriesCache.values());

		}


		List<String> apiCategories = fetchCategoriesFromAPI();

		if (!apiCategories.isEmpty()) {


			categoriesCache.clear();

			for (String category : apiCategories) {

				String[] parts = category.split("\\|", 2);

				if (parts.length == 2) {

					categoriesCache.put(parts[0], category);

				}

			}

			categoriesCacheTime = currentTime;

			return apiCategories;

		} else {


			System.out.println("Using fallback categories due to API unavailability");

			List<String> fallbackList = new ArrayList<>();

			for (String category : FALLBACK_CATEGORIES) {

				fallbackList.add(category);

			}

			return fallbackList;

		}

	}


	private List<String> fetchCategoriesFromAPI() {

		List<String> categories = new ArrayList<>();

		try {

			@SuppressWarnings("deprecation")

			URL url = new URL(CATEGORIES_URL);

			HttpURLConnection connection = (HttpURLConnection) url.openConnection();

			connection.setRequestMethod("GET");

			connection.setConnectTimeout(5000);

			connection.setReadTimeout(10000);


			int responseCode = connection.getResponseCode();

			if (responseCode != 200) {

				System.err.println("Categories API returned status code: " + responseCode);

				return categories;

			}


			BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));

			StringBuilder response = new StringBuilder();

			String line;

			while ((line = reader.readLine()) != null) {

				response.append(line);

			}

			reader.close();


			JSONObject jsonObject = new JSONObject(response.toString());

			JSONArray triviaCategories = jsonObject.getJSONArray("trivia_categories");

			for (int i = 0; i < triviaCategories.length(); i++) {

				JSONObject category = triviaCategories.getJSONObject(i);

				int id = category.getInt("id");

				String name = category.getString("name");

				categories.add(id + "|" + name);

			}

			System.out.println("Successfully fetched " + categories.size() + " categories from API");

		} catch (Exception e) {

			System.err.println("Error fetching categories from API: " + e.getMessage());

		}

		return categories;

	}


	public String getCategoryNameById(String categoryId) {


		getAPICategories();

		String cached = categoriesCache.get(categoryId);

		if (cached != null) {

			String[] parts = cached.split("\\|", 2);

			return parts.length == 2 ? parts[1] : null;

		}


		for (String category : FALLBACK_CATEGORIES) {

			String[] parts = category.split("\\|", 2);

			if (parts.length == 2 && parts[0].equals(categoryId)) {

				return parts[1];

			}

		}

		return null;

	}


	public void refreshCategoriesCache() {

		categoriesCache.clear();

		categoriesCacheTime = 0;

		getAPICategories(); 

	}



	public boolean isCategoriesCacheValid() {

		long currentTime = System.currentTimeMillis();

		return !categoriesCache.isEmpty() && (currentTime - categoriesCacheTime) < CACHE_DURATION;

	}



	public Map<String, Object> getCacheStatus() {

		Map<String, Object> status = new HashMap<>();

		status.put("cacheSize", categoriesCache.size());

		status.put("cacheAge", System.currentTimeMillis() - categoriesCacheTime);

		status.put("isValid", isCategoriesCacheValid());

		status.put("lastUpdated", new java.util.Date(categoriesCacheTime));

		return status;

	}


	public List<APIQuestion> fetchQuestionsFromAPI(int amount, String category, String difficulty) {

		List<APIQuestion> questions = new ArrayList<>();

		try {


			StringBuilder urlBuilder = new StringBuilder(BASE_URL);

			urlBuilder.append("?amount=").append(amount);

			urlBuilder.append("&type=multiple"); 

			if (category != null && !category.isEmpty()) {

				urlBuilder.append("&category=").append(category);

			}

			if (difficulty != null && !difficulty.isEmpty()) {

				urlBuilder.append("&difficulty=").append(difficulty);

			}


			@SuppressWarnings("deprecation")

			URL url = new URL(urlBuilder.toString());

			HttpURLConnection connection = (HttpURLConnection) url.openConnection();

			connection.setRequestMethod("GET");

			connection.setConnectTimeout(5000);

			connection.setReadTimeout(10000);

			

			BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));

			StringBuilder response = new StringBuilder();

			String line;

			while ((line = reader.readLine()) != null) {

				response.append(line);

			}

			reader.close();


			questions = parseAPIResponse(response.toString());

		} catch (Exception e) {

			System.err.println("Error fetching questions from API: " + e.getMessage());

			e.printStackTrace();

		}

		return questions;

	}



	private List<APIQuestion> parseAPIResponse(String jsonResponse) {

		List<APIQuestion> questions = new ArrayList<>();

		try {

			JSONObject jsonObject = new JSONObject(jsonResponse);

			int responseCode = jsonObject.getInt("response_code");

			if (responseCode == 0) { 

				JSONArray results = jsonObject.getJSONArray("results");

				for (int i = 0; i < results.length(); i++) {

					JSONObject questionObj = results.getJSONObject(i);

					APIQuestion apiQuestion = new APIQuestion();

					apiQuestion.setCategory(questionObj.getString("category"));

					apiQuestion.setType(questionObj.getString("type"));

					apiQuestion.setDifficulty(questionObj.getString("difficulty"));

					apiQuestion.setQuestion(questionObj.getString("question"));

					apiQuestion.setCorrectAnswer(questionObj.getString("correct_answer"));


					JSONArray incorrectArray = questionObj.getJSONArray("incorrect_answers");

					String[] incorrectAnswers = new String[incorrectArray.length()];

					for (int j = 0; j < incorrectArray.length(); j++) {

						incorrectAnswers[j] = incorrectArray.getString(j);

					}

					apiQuestion.setIncorrectAnswers(incorrectAnswers);


					apiQuestion.decodeHtmlEntities();

					questions.add(apiQuestion);

				}

			} else {

				System.err.println("API Error - Response Code: " + responseCode);

			}

		} catch (Exception e) {

			System.err.println("Error parsing API response: " + e.getMessage());

			e.printStackTrace();

		}

		return questions;

	}



	public Question convertToLocalQuestion(APIQuestion apiQuestion, int quizId) {

		Question question = new Question();

		question.setQuizId(quizId);

		question.setQuestionText(apiQuestion.getQuestion());


		String[] allAnswers = apiQuestion.getAllAnswers();

		List<String> answerList = new ArrayList<>();

		for (String answer : allAnswers) {

			answerList.add(answer);

		}

		Collections.shuffle(answerList);


		question.setOptionA(answerList.get(0));

		question.setOptionB(answerList.get(1));

		question.setOptionC(answerList.get(2));

		question.setOptionD(answerList.get(3));


		String correctAnswerText = apiQuestion.getCorrectAnswer();

		char correctAnswer = 'A';

		if (correctAnswerText.equals(question.getOptionA())) {

			correctAnswer = 'A';

		} else if (correctAnswerText.equals(question.getOptionB())) {

			correctAnswer = 'B';

		} else if (correctAnswerText.equals(question.getOptionC())) {

			correctAnswer = 'C';

		} else if (correctAnswerText.equals(question.getOptionD())) {

			correctAnswer = 'D';

		}

		question.setCorrectAnswer(correctAnswer);

		return question;

	}



	public boolean importQuestionsToDatabase(int amount, String category, String difficulty, String quizTitle,

			String description, int categoryId, int timeLimit) {

		try {


			List<APIQuestion> apiQuestions = fetchQuestionsFromAPI(amount, category, difficulty);

			if (apiQuestions.isEmpty()) {

				return false;

			}


			Quiz quiz = new Quiz();

			quiz.setTitle(quizTitle);

			quiz.setDescription(description);

			quiz.setCategoryId(categoryId);

			quiz.setDifficulty(difficulty != null ? difficulty : "medium");

			quiz.setTimeLimit(timeLimit);


			int quizId = quizDAO.createQuiz(quiz);

			if (quizId > 0) {


				for (APIQuestion apiQuestion : apiQuestions) {

					Question question = convertToLocalQuestion(apiQuestion, quizId);

					questionDAO.createQuestion(question);

				}

				return true;

			}

		} catch (Exception e) {

			System.err.println("Error importing questions to database: " + e.getMessage());

			e.printStackTrace();

		}

		return false;

	}


	public List<Question> createTemporaryAPIQuiz(int amount, String category, String difficulty) {

		List<Question> questions = new ArrayList<>();

		try {

			List<APIQuestion> apiQuestions = fetchQuestionsFromAPI(amount, category, difficulty);

			for (APIQuestion apiQuestion : apiQuestions) {

				Question question = convertToLocalQuestion(apiQuestion, 0); 

				questions.add(question);

			}

		} catch (Exception e) {

			System.err.println("Error creating temporary API quiz: " + e.getMessage());

		}

		for (Question question : questions) {

			question.setId(generateTemporaryId());

		}

		return questions;

	}



	public String[] getDifficulties() {

		return new String[] { "easy", "medium", "hard" };

	}

	private static final AtomicInteger idCounter = new AtomicInteger(1000); 

	public static int generateTemporaryId() {

		return idCounter.getAndIncrement();

	}

}
