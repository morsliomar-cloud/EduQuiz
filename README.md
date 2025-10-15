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

## 🧪 GitHub Pages Demo (Static)

A **static interactive demo** is shipped in `/docs`. It simulates a short quiz, scores your answers client-side, and links to your live backend if you deploy it. To publish:
1. Commit and push this repo to GitHub.
2. Go to **Settings → Pages**: Source = “Deploy from a branch”, Branch = `main`, Folder = `/docs`.
3. Open `https://<your-user>.github.io/<repo>/`.

If you later deploy a real backend, set `window.EDUQUIZ_API_BASE` inside `docs/demo.js` to point to your API (e.g. Render).

---

## ☁️ Deployment Options (Live Backend)

### Option A — **Render** (Docker)
1. Fork/Push this repo.
2. Add a new **Web Service** in Render → “From GitHub”.
3. Set:
   - **Dockerfile** in root
   - **Environment**: `JAVA_OPTS=-Xmx512m`
   - **Env Vars**: `DB_URL`, `DB_USER`, `DB_PASS`, `JPA_DIALECT`, `APP_CONTEXT=/` (as needed)
4. Add a **Render PostgreSQL/MySQL** add-on or point to your DB. Migrate with your SQL export.
5. The service URL will look like `https://eduquiz.onrender.com/`. Put that into the Pages demo config.

### Option B — **Railway / Koyeb**
Very similar to Render. Create a service from the repo, set environment variables, and deploy. Both support Docker out of the box.

### Option C — **Your Tomcat**
- Build the WAR with Ant and drop it into your remote Tomcat `webapps/`.- Reverse proxy with Nginx/Apache if needed.- Secure with HTTPS (Let’s Encrypt).

---

## 🔁 CI with GitHub Actions
- `.github/workflows/ci.yml` checks Java build via Ant (compiles sources) and, if desired, builds a Docker image on each push to `main`.
- Add registry secrets (e.g. GHCR) if you want to publish the image.

---

## 🧩 Suggested Ways to Present the Project

- **GitHub README** (this file): include feature bullets, stack badges, screenshots/GIFs of the app, architecture diagram, and a link to the demo.
- **GitHub Pages microsite**: the `/docs` demo doubles as a landing page with a “Play Demo” button, API docs, and screenshots.
- **Personal Portfolio**: deploy a simple static site (Hugo, Astro, Next.js static export) with a “Projects → EduQuiz” section embedding screenshots, a short story of what you built, and links to code/demo.
- **External dashboard**: Publish anonymized quiz analytics via **Metabase**/**Superset**/**Looker Studio** reading from a read-only replica or CSV export. Embed screenshots in README/Pages.
- **Short video walkthrough**: record a 60–120s Loom/YT demo and link it.

---

## 📦 Repository Layout (this starter)

```
EduQuiz/
├─ src/main/java/com/eduquiz/…       # controllers, models, daos, services, utils
├─ src/main/resources/               # application.properties & META-INF/persistence.xml
├─ src/main/webapp/                  # JSPs, static assets, WEB-INF/lib
├─ sql/                              # MySQL schema & seeds (for phpMyAdmin import)
├─ docs/                             # GitHub Pages demo (static)
├─ .github/workflows/ci.yml          # CI (Ant + optional Docker build)
├─ build.xml                         # Ant build (no Maven)
├─ Dockerfile                        # Containerized Tomcat
├─ docker-compose.yml                # Local dev (Tomcat + MySQL + phpMyAdmin)
└─ README.md
```

---

## 📚 License
MIT (or your preferred license).

---

### Troubleshooting

- **JARs not found**: Ensure libs are in `WEB-INF/lib` or on classpath. The Servlet API is provided by Tomcat at runtime.
- **JPA issues**: Confirm `persistence.xml` is in `src/main/resources/META-INF/` and the unit name matches your code.
- **Blank page / 404**: Check the context path and servlet `urlPatterns`. In Tomcat, the WAR name becomes the context by default.
- **DB connection fails**: Verify host, port, user, password, and that MySQL accepts connections. Try `127.0.0.1` and `serverTimezone=UTC`.
