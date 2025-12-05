package dz.eduquiz.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Local MySQL settings (for development)
    private static final String URL = "jdbc:mysql://localhost:3306/eduquiz_db?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    static {
        try {
            // Only load MySQL driver (needed locally)
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("JDBC Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            System.out.println("Error loading JDBC driver: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to load JDBC driver", e);
        }
    }

    public static Connection getConnection() {
        try {
            Connection conn = null;
            
            // Check if running on Render (DATABASE_URL environment variable exists)
            String renderDatabaseUrl = System.getenv("DATABASE_URL");
            
            if (renderDatabaseUrl != null && !renderDatabaseUrl.isEmpty()) {
                // Running on Render - use PostgreSQL
                System.out.println("Detected Render environment - using PostgreSQL");
                
                // Load PostgreSQL driver only when needed
                try {
                    Class.forName("org.postgresql.Driver");
                } catch (ClassNotFoundException e) {
                    System.out.println("PostgreSQL driver not found - this is OK for local development");
                }
                
                // Convert PostgreSQL URL to JDBC format
                if (renderDatabaseUrl.startsWith("postgres://")) {
                    renderDatabaseUrl = renderDatabaseUrl.replace("postgres://", "jdbc:postgresql://");
                } else if (renderDatabaseUrl.startsWith("postgresql://")) {
                    renderDatabaseUrl = "jdbc:" + renderDatabaseUrl;
                }
                
                conn = DriverManager.getConnection(renderDatabaseUrl);
                
            } else {
                // Running locally - use MySQL
                System.out.println("Using local MySQL connection");
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
