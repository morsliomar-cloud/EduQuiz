# EduQuiz — Java EE MVC Online Quiz Platform

**EduQuiz** is a Java EE learning project that demonstrates a clean MVC architecture for an online quiz platform. Users can take quizzes, see scores immediately, and track progress over time. The code showcases **Servlets**, **JSP (+Bootstrap/AJAX)**, **JPA/Hibernate (or plain JDBC)**, and a **MySQL** database.

---

## ✨ Features

- Quiz play: single and multi-choice questions, instant scoring
- Leaderboard and personal score history
- Categories and difficulty levels
- Optional REST endpoints (e.g. `/api/quizzes`) to power SPAs or mobile apps
- Authentication (username/password with BCrypt) and simple Admin panel
- Open Trivia API Integration (browsing quizzes not already set in the local data base and for the admin add quizzes permentally to the local db)
## 🧱 Tech Stack

- **Backend:** Java EE (Servlet w/ `@WebServlet`), JSP, JPA/Hibernate (or DAO + JDBC)
- **Database:** MySQL
- **Server:** Apache Tomcat
- **Frontend:** JSP, Bootstrap, vanilla JS/AJAX
- **Build:** IDE (Eclipse)
- **CI:** GitHub Actions
- **Demo:** GitHub Pages
  
## 📦 Repository Layout (this starter)

```
EduQuiz/
├─ src/main/java/dz/eduquiz/…       # controllers, models, daos, services, utils
├─ src/main/webapp/                  # JSPs, static assets, WEB-INF/lib
├─ sql/                              # MySQL schema
├─ docs/                             # GitHub Pages demo (static)
├─ .github/workflows/ci.yml          # CI (Ant + optional Docker build)
├─ build.xml                         # Ant build
├─ Dockerfile                        # Containerized Tomcat
├─ docker-compose.yml                # Local dev (Tomcat + MySQL + phpMyAdmin)
└─ README.md
```

### Troubleshooting

- **JARs not found**: Ensure libs are in `WEB-INF/lib` or on classpath. The Servlet API is provided by Tomcat at runtime.
- **JPA issues**: Confirm `persistence.xml` is in `src/main/resources/META-INF/` and the unit name matches your code.
- **Blank page / 404**: Check the context path and servlet `urlPatterns`. In Tomcat, the WAR name becomes the context by default.
- **DB connection fails**: Verify host, port, user, password, and that MySQL accepts connections. Try `127.0.0.1` and `serverTimezone=UTC`.
