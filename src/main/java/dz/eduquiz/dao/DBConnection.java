package dz.eduquiz.dao;

import java.net.URI;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	// Local MySQL settings (for development)
	private static final String URL = "jdbc:mysql://localhost:3306/eduquiz_db?useSSL=false&allowPublicKeyRetrieval=true";
	private static final String USER = "root";
	private static final String PASSWORD = "";

	public static Connection getConnection() {
	    try {
	        Connection conn = null;

	        String renderDatabaseUrl = System.getenv("DATABASE_URL");

	        if (renderDatabaseUrl != null && !renderDatabaseUrl.isEmpty()) {
	            // Running on Render - PostgreSQL
	            System.out.println("Detected Render environment - using PostgreSQL");
	            System.out.println("DATABASE_URL raw: " + renderDatabaseUrl);

	            // Load PostgreSQL driver
	            Class.forName("org.postgresql.Driver");

	            // Expected (your case):
	            // postgresql://user:password@host/db   (NO port)
	            if (!renderDatabaseUrl.startsWith("postgresql://")) {
	                throw new RuntimeException("Unexpected DATABASE_URL format: " + renderDatabaseUrl);
	            }

	            String withoutScheme = renderDatabaseUrl.substring("postgresql://".length());
	            String[] parts = withoutScheme.split("@");
	            if (parts.length != 2) {
	                throw new RuntimeException("Invalid DATABASE_URL (no @): " + renderDatabaseUrl);
	            }

	            String userInfo = parts[0];      // user:password
	            String hostAndDb = parts[1];     // host/db   (no port)

	            String[] userParts = userInfo.split(":", 2);
	            String username = userParts[0];
	            String password = userParts.length > 1 ? userParts[1] : "";

	            String[] hostDbParts = hostAndDb.split("/", 2);
	            String host = hostDbParts[0];                // dpg-d4osj78gjchc73ebmjj0-a
	            String dbName = hostDbParts.length > 1 ? hostDbParts[1] : "";

	            int port = 5432; // default PostgreSQL port

	            String jdbcUrl = "jdbc:postgresql://" + host + ":" + port + "/" + dbName;
	            System.out.println("Connecting to: " + jdbcUrl + " as " + username);

	            conn = DriverManager.getConnection(jdbcUrl, username, password);
	        } else {
	            // Local MySQL fallback
	            System.out.println("Using local MySQL connection");
	            Class.forName("com.mysql.cj.jdbc.Driver");
	            conn = DriverManager.getConnection(URL, USER, PASSWORD);
	        }

	        if (conn != null) {
	            System.out.println("Database connection established successfully");
	        }
	        return conn;

	    } catch (Exception e) {
	        System.out.println("Database connection error: " + e.getMessage());
	        e.printStackTrace();
	        return null;
	    }
	}


	public static boolean testConnection() {
		try (Connection conn = getConnection()) {
			return (conn != null);
		} catch (SQLException e) {
			System.out.println("Test connection error: " + e.getMessage());
			return false;
		}
	}
}
