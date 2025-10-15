package dz.eduquiz.util;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.List;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

public class JsonUtil {
    private static final Gson gson = new GsonBuilder().create();
    
    public static String toJson(Object object) {
        return gson.toJson(object);
    }
    
    public static <T> T fromJson(String json, Class<T> classOfT) {
        return gson.fromJson(json, classOfT);
    }
    
    public static <T> List<T> fromJsonList(String json, Class<T> classOfT) throws IOException {
        Type listType = TypeToken.getParameterized(List.class, classOfT).getType();
        return gson.fromJson(json, listType);
    }
}