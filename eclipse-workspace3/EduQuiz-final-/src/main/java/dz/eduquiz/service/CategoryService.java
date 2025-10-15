package dz.eduquiz.service;

import java.util.List;

import dz.eduquiz.dao.CategoryDAO;
import dz.eduquiz.model.Category;
import dz.eduquiz.util.ValidationUtil;

public class CategoryService {
	private CategoryDAO categoryDAO;

	public CategoryService() {
		this.categoryDAO = new CategoryDAO();
	}

	public int createCategory(String name, String description) {
		if (!ValidationUtil.isNotEmpty(name)) {
			return -1;
		}

		Category category = new Category();
		category.setName(name);
		category.setDescription(description);

		return categoryDAO.createCategory(category);
	}

	public Category getCategoryById(int id) {
		if (!ValidationUtil.isPositiveInteger(id)) {
			return null;
		}

		return categoryDAO.getCategoryById(id);
	}

	public List<Category> getAllCategories() {
		return categoryDAO.getAllCategories();
	}

	public boolean updateCategory(int id, String name, String description) {
		if (!ValidationUtil.isPositiveInteger(id) || !ValidationUtil.isNotEmpty(name)) {
			return false;
		}

		Category category = categoryDAO.getCategoryById(id);
		if (category == null) {
			return false;
		}

		category.setName(name);
		category.setDescription(description);

		return categoryDAO.updateCategory(category);
	}

	public boolean deleteCategory(int id) {
		if (!ValidationUtil.isPositiveInteger(id)) {
			return false;
		}

		return categoryDAO.deleteCategory(id);
	}

	public boolean categoryExistsByName(String name) {
		if (!ValidationUtil.isNotEmpty(name)) {
			return false;
		}

		List<Category> categories = categoryDAO.getAllCategories();
		for (Category category : categories) {
			if (category.getName().equalsIgnoreCase(name)) {
				return true;
			}
		}

		return false;
	}
}