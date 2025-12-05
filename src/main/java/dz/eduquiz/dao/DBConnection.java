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

			// Check if running on Render (DATABASE_URL environment variable exists)
			String renderDatabaseUrl = System.getenv("DATABASE_URL");

			if (renderDatabaseUrl != null && !renderDatabaseUrl.isEmpty()) {
				// Running on Render - use PostgreSQL
				System.out.println("Detected Render environment - using PostgreSQL");

				// Load PostgreSQL driver
				try {
					Class.forName("org.postgresql.Driver");
					System.out.println("PostgreSQL driver loaded successfully");
				} catch (ClassNotFoundException e) {
					System.out.println("ERROR: PostgreSQL driver not found!");
					e.printStackTrace();
					throw new RuntimeException("PostgreSQL driver not available", e);
				}

				// Parse the DATABASE_URL properly
				// Format: postgresql://user:password@host:port/database
				try {
					URI dbUri = new URI(renderDatabaseUrl);
					String username = null;
					String password = null;

					// Extract username and password from userInfo
					if (dbUri.getUserInfo() != null) {
						String[] credentials = dbUri.getUserInfo().split(":");
						username = credentials[0];
						password = credentials[1];
					}

					// Build proper JDBC URL
					String jdbcUrl = "jdbc:postgresql://" + dbUri.getHost() + ":" + dbUri.getPort() + dbUri.getPath();

					System.out.println("Connecting to: " + jdbcUrl);

					// Connect with credentials
					if (username != null && password != null) {
						conn = DriverManager.getConnection(jdbcUrl, username, password);
					} else {
						conn = DriverManager.getConnection(jdbcUrl);
					}

				} catch (Exception e) {
					System.out.println("Error parsing DATABASE_URL: " + e.getMessage());
					e.printStackTrace();
					return null;
				}

			} else {
				// Running locally - use MySQL
				System.out.println("Using local MySQL connection");

				// Load MySQL driver
				try {
					Class.forName("com.mysql.cj.jdbc.Driver");
					System.out.println("MySQL driver loaded successfully");
				} catch (ClassNotFoundException e) {
					System.out.println("ERROR: MySQL driver not found!");
					e.printStackTrace();
					throw new RuntimeException("MySQL driver not available", e);
				}

				conn = DriverManager.getConnection(URL, USER, PASSWORD);
			}

			if (conn != null) {
				System.out.println("Database connection established successfully");
			}
			return conn;

		} catch (SQLException e) {
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
