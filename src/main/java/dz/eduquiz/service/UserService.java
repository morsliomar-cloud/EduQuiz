package dz.eduquiz.service;

import java.util.List;

import dz.eduquiz.dao.UserDAO;
import dz.eduquiz.model.User;
import dz.eduquiz.util.PasswordHasher;
import dz.eduquiz.util.ValidationUtil;

public class UserService {
	private UserDAO userDAO;

	public UserService() {
		this.userDAO = new UserDAO();
	}

	public boolean registerUser(String username, String email, String password) {
		if (!ValidationUtil.isValidUsername(username)) {
			System.out.println("Invalid username format");
			return false;
		}

		if (!ValidationUtil.isValidEmail(email)) {
			System.out.println("Invalid email format");
			return false;
		}

		if (!ValidationUtil.isValidPassword(password)) {
			System.out.println("Invalid password format");
			return false;
		}

		try {
			User existingUser = userDAO.getUserByUsername(username);
			if (existingUser != null) {
				System.out.println("Username already exists: " + username);
				return false;
			}

			existingUser = userDAO.getUserByEmail(email);
			if (existingUser != null) {
				System.out.println("Email already exists: " + email);
				return false;
			}

			String hashedPassword = PasswordHasher.hashPassword(password);
			User user = new User(username, email, hashedPassword);
			user.setRole("user");
			user.setCreatedAt(new java.util.Date());
			int userId = userDAO.createUser(user);
			System.out.println("User registration result: " + (userId > 0 ? "Success" : "Failed"));
			return userId > 0;
		} catch (Exception e) {
			System.out.println("Exception in registerUser: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	public boolean registerUser(String username, String email, String password, String role, boolean active) {
		if (!ValidationUtil.isValidUsername(username)) {
			System.out.println("Invalid username format");
			return false;
		}

		if (!ValidationUtil.isValidEmail(email)) {
			System.out.println("Invalid email format");
			return false;
		}

		if (!ValidationUtil.isValidPassword(password)) {
			System.out.println("Invalid password format");
			return false;
		}

		if (role == null || (!role.equalsIgnoreCase("user") && !role.equalsIgnoreCase("admin"))) {
			System.out.println("Invalid role: " + role);
			return false;
		}

		try {
			User existingUser = userDAO.getUserByUsername(username);
			if (existingUser != null) {
				System.out.println("Username already exists: " + username);
				return false;
			}

			existingUser = userDAO.getUserByEmail(email);
			if (existingUser != null) {
				System.out.println("Email already exists: " + email);
				return false;
			}

			String hashedPassword = PasswordHasher.hashPassword(password);
			User user = new User(username, email, hashedPassword);
			user.setRole(role.toLowerCase());
			user.setActive(active);
			user.setCreatedAt(new java.util.Date());
			int userId = userDAO.createUser(user);
			System.out.println("Admin user creation result: " + (userId > 0 ? "Success" : "Failed"));
			return userId > 0;
		} catch (Exception e) {
			System.out.println("Exception in registerUser (admin): " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	public User authenticate(String usernameOrEmail, String password) {
		try {
			User user = null;

			user = userDAO.getUserByUsername(usernameOrEmail);

			if (user != null) {
				boolean passwordMatch = PasswordHasher.checkPassword(password, user.getPassword());
				System.out.println("User found, password match: " + passwordMatch);
				if (passwordMatch) {
					return user;
				}
			}
		} catch (Exception e) {
			System.out.println("Exception in authenticate: " + e.getMessage());
			e.printStackTrace();
		}

		return null;
	}

	public User getUserById(int id) {
		return userDAO.getUserById(id);
	}

	public List<User> getAllUsers() {
		return userDAO.getAllUsers();
	}

	public boolean updateUser(int userId, String username, String email, String password, String role, boolean active) {
		try {
			User user = userDAO.getUserById(userId);
			if (user == null) {
				System.out.println("User not found with ID: " + userId);
				return false;
			}

			if (!ValidationUtil.isValidUsername(username)) {
				System.out.println("Invalid username format: " + username);
				return false;
			}

			if (!ValidationUtil.isValidEmail(email)) {
				System.out.println("Invalid email format: " + email);
				return false;
			}

			if (password != null && !password.trim().isEmpty() && !ValidationUtil.isValidPassword(password)) {
				System.out.println("Invalid password format");
				return false;
			}

			if (role == null || (!role.equalsIgnoreCase("user") && !role.equalsIgnoreCase("admin"))) {
				System.out.println("Invalid role: " + role);
				return false;
			}

			User existingUser = userDAO.getUserByUsername(username);
			if (existingUser != null && existingUser.getId() != userId) {
				System.out.println("Username already exists: " + username);
				return false;
			}

			existingUser = userDAO.getUserByEmail(email);
			if (existingUser != null && existingUser.getId() != userId) {
				System.out.println("Email already exists: " + email);
				return false;
			}

			user.setUsername(username);
			user.setEmail(email);
			if (password != null && !password.trim().isEmpty()) {
				user.setPassword(PasswordHasher.hashPassword(password));
			}
			user.setRole(role.toLowerCase());
			user.setActive(active);

			return userDAO.updateUser(user);
		} catch (Exception e) {
			System.out.println("Exception in updateUser: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	public boolean updateUserWithoutPassword(int userId, String username, String email, String role, boolean active) {
		try {
			User user = userDAO.getUserById(userId);
			if (user == null) {
				System.out.println("User not found with ID: " + userId);
				return false;
			}

			if (!ValidationUtil.isValidUsername(username)) {
				System.out.println("Invalid username format: " + username);
				return false;
			}

			if (!ValidationUtil.isValidEmail(email)) {
				System.out.println("Invalid email format: " + email);
				return false;
			}

			if (role == null || (!role.equalsIgnoreCase("user") && !role.equalsIgnoreCase("admin"))) {
				System.out.println("Invalid role: " + role);
				return false;
			}

			User existingUser = userDAO.getUserByUsername(username);
			if (existingUser != null && existingUser.getId() != userId) {
				System.out.println("Username already exists: " + username);
				return false;
			}

			existingUser = userDAO.getUserByEmail(email);
			if (existingUser != null && existingUser.getId() != userId) {
				System.out.println("Email already exists: " + email);
				return false;
			}

			user.setUsername(username);
			user.setEmail(email);
			user.setRole(role.toLowerCase());
			user.setActive(active);

			return userDAO.updateUser(user);
		} catch (Exception e) {
			System.out.println("Exception in updateUserWithoutPassword: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	public boolean updateUserStatus(int userId, boolean active) {
		try {
			User user = userDAO.getUserById(userId);
			if (user == null) {
				System.out.println("User not found with ID: " + userId);
				return false;
			}

			user.setActive(active);
			return userDAO.updateUser(user);
		} catch (Exception e) {
			System.out.println("Exception in updateUserStatus: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	public boolean updateUserProfile(int userId, String username, String email, String currentPassword,
			String newPassword, String profileImage) {
		try {
			User user = userDAO.getUserById(userId);
			if (user == null) {
				System.out.println("ERROR: User not found with ID: " + userId);
				return false;
			}
			System.out.println("Current user data - Username: " + user.getUsername() + ", Email: " + user.getEmail());

			boolean passwordMatch = PasswordHasher.checkPassword(currentPassword, user.getPassword());
			System.out.println("Current password verification: " + (passwordMatch ? "SUCCESS" : "FAILED"));
			if (!passwordMatch) {
				return false;
			}

			boolean hasChanges = false;

			if (username != null && !username.trim().isEmpty() && !username.equals(user.getUsername())) {
				if (!ValidationUtil.isValidUsername(username)) {
					System.out.println("ERROR: Invalid username format: " + username);
					return false;
				}

				User existingUser = userDAO.getUserByUsername(username);
				if (existingUser != null && existingUser.getId() != userId) {
					System.out.println("ERROR: Username already in use by another user: " + username);
					return false;
				}

				System.out.println("Updating username from '" + user.getUsername() + "' to '" + username + "'");
				user.setUsername(username);
				hasChanges = true;
			}

			if (email != null && !email.trim().isEmpty() && !email.equals(user.getEmail())) {
				if (!ValidationUtil.isValidEmail(email)) {
					System.out.println("ERROR: Invalid email format: " + email);
					return false;
				}

				User existingUser = userDAO.getUserByEmail(email);
				if (existingUser != null && existingUser.getId() != userId) {
					System.out.println("ERROR: Email already in use by another user: " + email);
					return false;
				}

				System.out.println("Updating email from '" + user.getEmail() + "' to '" + email + "'");
				user.setEmail(email);
				hasChanges = true;
			}

			if (newPassword != null && !newPassword.trim().isEmpty()) {
				if (!ValidationUtil.isValidPassword(newPassword)) {
					System.out.println("ERROR: Invalid new password format");
					return false;
				}

				System.out.println("Updating password...");
				user.setPassword(PasswordHasher.hashPassword(newPassword));
				hasChanges = true;
			}

			if (profileImage != null && !profileImage.trim().isEmpty()) {
				System.out.println(
						"Updating profile image from '" + user.getProfileImage() + "' to '" + profileImage + "'");
				user.setProfileImage(profileImage);
				hasChanges = true;
			}

			if (!hasChanges) {
				System.out.println("No changes to update");
				return true;
			}

			boolean updateResult = userDAO.updateUser(user);
			System.out.println("Database update result: " + (updateResult ? "SUCCESS" : "FAILED"));
			return updateResult;
		} catch (Exception e) {
			System.out.println("EXCEPTION in updateUserProfile: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	public boolean deleteUser(int userId) {
		return userDAO.deleteUser(userId);
	}

	public boolean updateUserRole(int userId, String role) {
		if (role == null || (!role.equalsIgnoreCase("user") && !role.equalsIgnoreCase("admin"))) {
			return false;
		}

		try {
			User user = userDAO.getUserById(userId);
			if (user == null) {
				return false;
			}

			user.setRole(role.toLowerCase());
			return userDAO.updateUser(user);
		} catch (Exception e) {
			System.out.println("Exception in updateUserRole: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}
}