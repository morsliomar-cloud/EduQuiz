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

---

## 🚀 Quick Start (Local)

### 0) Requirements
- **JDK 11** (8+ ok) and **Apache Tomcat 9/10+**
- **MySQL 8** and **phpMyAdmin**
- **Git**
- (Optional) **Ant** for packaging a WAR without Maven

### 1) Database Setup (phpMyAdmin)
1. Create a database, e.g. `eduquiz` with `utf8mb4` collation.
2. Create a DB user, e.g. `eduquiz` with a strong password and **grant** privileges on `eduquiz`.
3. **Import** `sql/eduquiz_schema_mysql.sql`. Replace the placeholder in that file with your exported tables if you already have them.
4. (Optional but recommended) Insert seed data (couple of users/quizzes) via phpMyAdmin or the provided seed section in the SQL file.

### 2) Configure the App
Copy `src/main/resources/application.properties.example` to `src/main/resources/application.properties` and set your values:

```properties
db.url=jdbc:mysql://localhost:3306/eduquiz?useSSL=false&serverTimezone=UTC
db.username=eduquiz
db.password=change_me
db.driver=com.mysql.cj.jdbc.Driver

# Hibernate/JPA
jpa.show-sql=true
jpa.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
jpa.hibernate.hbm2ddl.auto=validate
```

If you use **JPA/Hibernate**, check `src/main/resources/META-INF/persistence.xml` as well (see below). If you use **plain JDBC**, the properties above are sufficient.

### 3) Libraries (No Maven)
Place the following JARs in `src/main/webapp/WEB-INF/lib/` (commit them or document where to download them):
- `javax.servlet-api` (matching your Tomcat version — **provided** scope at runtime by Tomcat)
- `javax.persistence-api` (or `jakarta.persistence-api` if using Jakarta EE 9+)
- `hibernate-core`
- `mysql-connector-j`
- (Optional) `javax.json`, JAX-RS or Jersey/RESTEasy if exposing REST endpoints
- (Optional) `bcprov`/`bcrypt` libs if not shading them elsewhere

> Tip: In Eclipse Dynamic Web Project, mark these as Web App Libraries; Tomcat provides the Servlet API.

### 4) Run in Tomcat (Dev)
- **IDE**: Import as “Existing Projects into Workspace” (Eclipse) or “New Project from Existing Sources” (IntelliJ).
- Configure a **Tomcat** run configuration pointing at this project’s `src/main/webapp` as the Web Content root and add `WEB-INF/lib` jars.
- Start Tomcat and open `http://localhost:8080/EduQuiz/` (context path may vary; see Ant below for WAR name).

### 5) Package a WAR with Ant (No Maven)
Ant script: `build.xml` packages `EduQuiz.war` into `build/`. Run:
```bash
ant clean war
```
Then deploy by copying `build/EduQuiz.war` into your Tomcat `webapps/` directory (Tomcat will auto-expand).

---

## 🔧 Configuration Files

### `src/main/resources/application.properties`
See the example file. Used by your DAO layer / utility to open JDBC connections or configure JPA.

### `src/main/resources/META-INF/persistence.xml`
Minimal JPA unit (no `web.xml` needed):
```xml
<persistence xmlns="http://xmlns.jcp.org/xml/ns/persistence"
             version="2.2">
  <persistence-unit name="eduquizPU">
    <provider>org.hibernate.jpa.HibernatePersistenceProvider</provider>
    <class>com.eduquiz.model.User</class>
    <properties>
      <property name="javax.persistence.jdbc.driver" value="com.mysql.cj.jdbc.Driver"/>
      <property name="javax.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/eduquiz?useSSL=false&amp;serverTimezone=UTC"/>
      <property name="javax.persistence.jdbc.user" value="eduquiz"/>
      <property name="javax.persistence.jdbc.password" value="change_me"/>
      <property name="hibernate.dialect" value="org.hibernate.dialect.MySQL8Dialect"/>
      <property name="hibernate.hbm2ddl.auto" value="validate"/>
      <property name="hibernate.show_sql" value="true"/>
    </properties>
  </persistence-unit>
</persistence>
```

### `src/main/java/.../controller/HomeServlet.java`
Example of annotation-based servlet (no `web.xml`):

```java
@WebServlet(name="HomeServlet", urlPatterns=/)
public class HomeServlet extends HttpServlet Ellipsis
```

### `src/main/webapp/WEB-INF/jsp/*.jsp`
Your JSP views (Bootstrap, JSTL). Public pages can live at project root too (e.g. `index.jsp`).

---

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
