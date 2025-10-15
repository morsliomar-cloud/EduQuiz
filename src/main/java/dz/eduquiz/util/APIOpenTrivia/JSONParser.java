package dz.eduquiz.util.APIOpenTrivia;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

import org.json.JSONArray;
import org.json.JSONObject;

public class JSONParser {

	public static JSONObject parseJSONObject(String jsonString) {
		try {
			return new JSONObject(jsonString);
		} catch (Exception e) {
			System.err.println("Error parsing JSON object: " + e.getMessage());
			return null;
		}
	}


	public static JSONArray parseJSONArray(String jsonString) {
		try {
			return new JSONArray(jsonString);
		} catch (Exception e) {
			System.err.println("Error parsing JSON array: " + e.getMessage());
			return null;
		}
	}


	public static String safeGetString(JSONObject jsonObject, String key) {
		try {
			return jsonObject.has(key) ? jsonObject.getString(key) : "";
		} catch (Exception e) {
			System.err.println("Error getting string for key '" + key + "': " + e.getMessage());
			return "";
		}
	}


	public static int safeGetInt(JSONObject jsonObject, String key) {
		try {
			return jsonObject.has(key) ? jsonObject.getInt(key) : 0;
		} catch (Exception e) {
			System.err.println("Error getting integer for key '" + key + "': " + e.getMessage());
			return 0;
		}
	}


	public static JSONArray safeGetArray(JSONObject jsonObject, String key) {
		try {
			return jsonObject.has(key) ? jsonObject.getJSONArray(key) : null;
		} catch (Exception e) {
			System.err.println("Error getting array for key '" + key + "': " + e.getMessage());
			return null;
		}
	}


	public static String decodeHtmlEntities(String text) {
		if (text == null || text.isEmpty()) {
			return text;
		}

		try {
			String decoded = URLDecoder.decode(text, "UTF-8");

			decoded = decoded.replace("&amp;", "&").replace("&lt;", "<").replace("&gt;", ">").replace("&quot;", "\"")
					.replace("&#039;", "'").replace("&apos;", "'").replace("&nbsp;", " ").replace("&ldquo;", "\u201C")
					.replace("&rdquo;", "\u201D").replace("&lsquo;", "\u2018").replace("&rsquo;", "\u2019")
					.replace("&mdash;", "\u2014").replace("&ndash;", "\u2013").replace("&hellip;", "\u2026")
					.replace("&deg;", "\u00B0").replace("&copy;", "\u00A9").replace("&reg;", "\u00AE")
					.replace("&trade;", "\u2122").replace("&frac12;", "\u00BD").replace("&frac14;", "\u00BC")
					.replace("&frac34;", "\u00BE");

			return decoded;

		} catch (UnsupportedEncodingException e) {
			System.err.println("Error decoding HTML entities: " + e.getMessage());
			return text;
		}
	}


	public static String[] decodeHtmlEntitiesArray(String[] textArray) {
		if (textArray == null) {
			return null;
		}

		String[] decodedArray = new String[textArray.length];
		for (int i = 0; i < textArray.length; i++) {
			decodedArray[i] = decodeHtmlEntities(textArray[i]);
		}

		return decodedArray;
	}


	public static String[] jsonArrayToStringArray(JSONArray jsonArray) {
		if (jsonArray == null) {
			return new String[0];
		}

		String[] stringArray = new String[jsonArray.length()];
		for (int i = 0; i < jsonArray.length(); i++) {
			try {
				stringArray[i] = jsonArray.getString(i);
			} catch (Exception e) {
				stringArray[i] = "";
			}
		}

		return stringArray;
	}


	public static boolean isValidJSON(String jsonString) {
		if (jsonString == null || jsonString.trim().isEmpty()) {
			return false;
		}

		try {
			new JSONObject(jsonString);
			return true;
		} catch (Exception e1) {
			try {
				new JSONArray(jsonString);
				return true;
			} catch (Exception e2) {
				return false;
			}
		}
	}


	public static String prettyPrintJSON(JSONObject jsonObject, int indent) {
		try {
			return jsonObject.toString(indent);
		} catch (Exception e) {
			System.err.println("Error pretty printing JSON: " + e.getMessage());
			return jsonObject.toString();
		}
	}


	public static int getAPIResponseCode(String jsonResponse) {
		try {
			JSONObject jsonObject = parseJSONObject(jsonResponse);
			return jsonObject != null ? safeGetInt(jsonObject, "response_code") : -1;
		} catch (Exception e) {
			System.err.println("Error getting API response code: " + e.getMessage());
			return -1;
		}
	}


	public static String getAPIErrorMessage(int responseCode) {
		switch (responseCode) {
		case 0:
			return "Success";
		case 1:
			return "No Results - Could not return results. The API doesn't have enough questions for your query.";
		case 2:
			return "Invalid Parameter - Contains an invalid parameter. Arguments passed in aren't valid.";
		case 3:
			return "Token Not Found - Session Token does not exist.";
		case 4:
			return "Token Empty - Session Token has returned all possible questions for the specified query.";
		case 5:
			return "Rate Limit - Too many requests have been made. Each IP can only access the API once every 5 seconds.";
		default:
			return "Unknown Error - Response Code: " + responseCode;
		}
	}
}