package dz.eduquiz.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import dz.eduquiz.model.Category;

public class CategoryDAO {

	public int createCategory(Category category) {
		String sql = "INSERT INTO categories (name, description) VALUES (?, ?)";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

			pstmt.setString(1, category.getName());
			pstmt.setString(2, category.getDescription());

			int affectedRows = pstmt.executeUpdate();

			if (affectedRows == 0) {
				throw new SQLException("Creating category failed, no rows affected.");
			}

			try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
				if (generatedKeys.next()) {
					category.setId(generatedKeys.getInt(1));
					return category.getId();
				} else {
					throw new SQLException("Creating category failed, no ID obtained.");
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return -1;
		}
	}

	public Category getCategoryById(int id) {
		Category category = null;
		String sql = "SELECT * FROM categories WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setInt(1, id);

			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					category = new Category();
					category.setId(rs.getInt("id"));
					category.setName(rs.getString("name"));
					category.setDescription(rs.getString("description"));
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return category;
	}

	public List<Category> getAllCategories() {
		List<Category> categories = new ArrayList<>();
		String sql = "SELECT * FROM categories";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql);
				ResultSet rs = stmt.executeQuery()) {

			while (rs.next()) {
				Category category = new Category();
				category.setId(rs.getInt("id"));
				category.setName(rs.getString("name"));
				category.setDescription(rs.getString("description"));
				categories.add(category);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return categories;
	}

	public boolean updateCategory(Category category) {
		String sql = "UPDATE categories SET name = ?, description = ? WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, category.getName());
			pstmt.setString(2, category.getDescription());
			pstmt.setInt(3, category.getId());

			int affectedRows = pstmt.executeUpdate();
			return affectedRows > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean deleteCategory(int id) {
		String sql = "DELETE FROM categories WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, id);

			int affectedRows = pstmt.executeUpdate();
			return affectedRows > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}
}
