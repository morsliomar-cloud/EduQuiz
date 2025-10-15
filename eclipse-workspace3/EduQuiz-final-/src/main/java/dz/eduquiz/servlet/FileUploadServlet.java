package dz.eduquiz.servlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

import dz.eduquiz.util.FileUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/fileUpload")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, 
		maxFileSize = 1024 * 1024 * 5, 
		maxRequestSize = 1024 * 1024 * 10 
)
public class FileUploadServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static final String UPLOAD_DIRECTORY = "uploads";

	public FileUploadServlet() {
		super();
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String applicationPath = request.getServletContext().getRealPath("");
		String uploadPath = applicationPath + File.separator + UPLOAD_DIRECTORY;

		File uploadDir = new File(uploadPath);
		if (!uploadDir.exists()) {
			uploadDir.mkdirs();
		}

		String fileName = null;

		try {
			Part filePart = request.getPart("file"); 

			String submittedFileName = filePart.getSubmittedFileName();

			if (!FileUtil.isValidImageFile(submittedFileName)) {
				response.setContentType("application/json");
				response.getWriter().write("{\"error\": \"Invalid file type. Only JPG, PNG, and GIF are allowed.\"}");
				return;
			}

			String fileExtension = submittedFileName.substring(submittedFileName.lastIndexOf("."));
			fileName = UUID.randomUUID().toString() + fileExtension;

			Path filePath = Paths.get(uploadPath + File.separator + fileName);
			Files.copy(filePart.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

			response.setContentType("application/json");
			response.getWriter().write("{\"fileName\": \"" + fileName + "\"}");
		} catch (Exception e) {
			response.setContentType("application/json");
			response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
			e.printStackTrace();
		}
	}
}