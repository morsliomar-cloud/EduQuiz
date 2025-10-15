package dz.eduquiz.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import dz.eduquiz.model.User;

public class UserDAO {
	public int createUser(User user) {
		String sql = "INSERT INTO users (username, email, password, role, profile_image, active, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

			pstmt.setString(1, user.getUsername());
			pstmt.setString(2, user.getEmail());
			pstmt.setString(3, user.getPassword());
			pstmt.setString(4, user.getRole());
			pstmt.setString(5, user.getProfileImage());
			pstmt.setBoolean(6, user.isActive());
			pstmt.setTimestamp(7, user.getCreatedAt() != null ? new java.sql.Timestamp(user.getCreatedAt().getTime())
					: new java.sql.Timestamp(System.currentTimeMillis()));

			int affectedRows = pstmt.executeUpdate();

			if (affectedRows == 0) {
				throw new SQLException("Creating user failed, no rows affected.");
			}

			try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
				if (generatedKeys.next()) {
					user.setId(generatedKeys.getInt(1));
					return user.getId();
				} else {
					throw new SQLException("Creating user failed, no ID obtained.");
				}
			}
		} catch (SQLException e) {
			System.out.println("SQL Error in createUser: " + e.getMessage());
			e.printStackTrace();
			return -1;
		}
	}

	public User getUserById(int id) {
		String sql = "SELECT * FROM users WHERE id = ?";

		try (Connection conn = DBConnection.getConnection()) {
			if (conn == null) {
				System.out.println("Error: Database connection failed in getUserById");
				return null;
			}

			try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
				pstmt.setInt(1, id);

				try (ResultSet rs = pstmt.executeQuery()) {
					if (rs.next()) {
						User user = new User();
						user.setId(rs.getInt("id"));
						user.setUsername(rs.getString("username"));
						user.setEmail(rs.getString("email"));
						user.setPassword(rs.getString("password"));
						user.setRole(rs.getString("role"));
						user.setProfileImage(rs.getString("profile_image"));
						user.setActive(rs.getBoolean("active")); 
						user.setCreatedAt(rs.getTimestamp("created_at"));
						return user;
					}
				}
			}
		} catch (SQLException e) {
			System.out.println("SQL Error in getUserById: " + e.getMessage());
			e.printStackTrace();
		}

		return null;
	}

	public User getUserByUsername(String username) {
		String sql = "SELECT * FROM users WHERE username = ?";

		try (Connection conn = DBConnection.getConnection()) {
			if (conn == null) {
				System.out.println("Error: Database connection failed in getUserByUsername");
				return null;
			}

			try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
				pstmt.setString(1, username);

				try (ResultSet rs = pstmt.executeQuery()) {
					if (rs.next()) {
						User user = new User();
						user.setId(rs.getInt("id"));
						user.setUsername(rs.getString("username"));
						user.setEmail(rs.getString("email"));
						user.setPassword(rs.getString("password"));
						user.setRole(rs.getString("role"));
						user.setProfileImage(rs.getString("profile_image"));
						user.setActive(rs.getBoolean("active")); 
						user.setCreatedAt(rs.getTimestamp("created_at"));
						return user;
					}
				}
			}
		} catch (SQLException e) {
			System.out.println("SQL Error in getUserByUsername: " + e.getMessage());
			e.printStackTrace();
		}

		return null;
	}

	public User getUserByEmail(String email) {
		String sql = "SELECT * FROM users WHERE email = ?";

		try (Connection conn = DBConnection.getConnection()) {
			if (conn == null) {
				System.out.println("Error: Database connection failed in getUserByEmail");
				System.out.println("Executing SQL: " + sql + " with parameter: " + email);
				return null;
			}

			try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
				pstmt.setString(1, email);

				try (ResultSet rs = pstmt.executeQuery()) {
					if (rs.next()) {
						User user = new User();
						user.setId(rs.getInt("id"));
						user.setUsername(rs.getString("username"));
						user.setEmail(rs.getString("email"));
						user.setPassword(rs.getString("password"));
						user.setRole(rs.getString("role"));
						user.setProfileImage(rs.getString("profile_image"));
						user.setActive(rs.getBoolean("active"));  
						user.setCreatedAt(rs.getTimestamp("created_at"));
						return user;
					}
				}
			}
		} catch (SQLException e) {
			System.out.println("SQL Error in getUserByEmail: " + e.getMessage());
			System.out.println("Executing SQL: " + sql + " with parameter: " + email);
			e.printStackTrace();
			return null;
		}

		return null;
	}

	public List<User> getAllUsers() {
		List<User> users = new ArrayList<>();
		String sql = "SELECT * FROM users";

		try (Connection conn = DBConnection.getConnection()) {
			if (conn == null) {
				System.out.println("Error: Database connection failed in getAllUsers");
				return users;
			}

			try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {

				while (rs.next()) {
					User user = new User();
					user.setId(rs.getInt("id"));
					user.setUsername(rs.getString("username"));
					user.setEmail(rs.getString("email"));
					user.setPassword(rs.getString("password"));
					user.setRole(rs.getString("role"));
					user.setProfileImage(rs.getString("profile_image"));
					user.setActive(rs.getBoolean("active")); 
					user.setCreatedAt(rs.getTimestamp("created_at"));
					users.add(user);
				}
			}
		} catch (SQLException e) {
			System.out.println("SQL Error in getAllUsers: " + e.getMessage());
			e.printStackTrace();
		}

		return users;
	}

	public boolean updateUser(User user) {
		String sql = "UPDATE users SET username = ?, email = ?, password = ?, role = ?, profile_image = ?, active = ? WHERE id = ?";

		try (Connection conn = DBConnection.getConnection()) {
			if (conn == null) {
				System.out.println("Error: Database connection failed in updateUser");
				return false;
			}

			try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
				pstmt.setString(1, user.getUsername());
				pstmt.setString(2, user.getEmail());
				pstmt.setString(3, user.getPassword());
				pstmt.setString(4, user.getRole());
				pstmt.setString(5, user.getProfileImage());
				pstmt.setBoolean(6, user.isActive());  
				pstmt.setInt(7, user.getId());

				int affectedRows = pstmt.executeUpdate();
				return affectedRows > 0;
			}
		} catch (SQLException e) {
			System.out.println("SQL Error in updateUser: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	public boolean deleteUser(int id) {
		String sql = "DELETE FROM users WHERE id = ?";

		try (Connection conn = DBConnection.getConnection()) {
			if (conn == null) {
				System.out.println("Error: Database connection failed in deleteUser");
				return false;
			}

			try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
				pstmt.setInt(1, id);

				int affectedRows = pstmt.executeUpdate();
				return affectedRows > 0;
			}
		} catch (SQLException e) {
			System.out.println("SQL Error in deleteUser: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}
}