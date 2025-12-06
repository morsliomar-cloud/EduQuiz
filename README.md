# EduQuiz 📚

**An Interactive Quiz Platform for Learning & Assessment**

A comprehensive Java EE web application designed for creating, managing, and taking quizzes with real-time scoring, user authentication, and detailed performance analytics.

---

## 🌟 Features

### For Users
- ✅ Browse and take interactive quizzes
- ✅ Real-time score calculation
- ✅ Detailed quiz results and performance history
- ✅ Leaderboard system for gamification
- ✅ User profile and statistics dashboard

### For Administrators
- ✅ Dashboard with platform analytics
- ✅ User management (create, edit, delete)
- ✅ Quiz creation and management
- ✅ Question management (CRUD operations)
- ✅ Category management for quiz organization
- ✅ Import questions from OpenTrivia API
- ✅ User score tracking and reporting

### Core Technologies
- 📝 **Backend**: Java EE (Servlets, JSP)
- 💾 **Database**: MySQL with JDBC
- 🔐 **Security**: BCrypt password hashing
- 📊 **Frontend**: HTML5, CSS3, JavaScript
- 🎨 **UI Components**: Bootstrap + Custom CSS
- 📡 **API Integration**: OpenTrivia DB API for question import

---

## 📋 Project Structure

```
EduQuiz-final/
├── src/main/java/dz/eduquiz/
│   ├── dao/               # Data Access Objects
│   ├── model/             # Entity classes
│   ├── service/           # Business logic layer
│   ├── servlet/           # HTTP request handlers
│   └── util/              # Helper utilities
├── src/main/webapp/
│   ├── WEB-INF/
│   │   ├── admin/         # Admin JSP pages
│   │   ├── *.jsp          # User-facing pages
│   │   └── lib/           # JAR dependencies
│   └── resources/
│       ├── css/           # Stylesheets
│       └── js/            # JavaScript files
└── build/                 # Compiled output
```

---

## 🚀 Quick Start

### Prerequisites
- **Java**: JDK 11 or higher
- **Server**: Apache Tomcat 10+ or compatible Java EE app server
- **Database**: MySQL 8.0+
- **IDE**: Eclipse IDE for Enterprise Java (recommended) or IntelliJ IDEA
- **Build Tool**: Maven or Gradle (optional, project uses Eclipse)

### Local Development Setup

#### 1. Clone the Repository
```bash
git clone https://github.com/YourUsername/EduQuiz.git
cd EduQuiz-final
```

#### 2. Database Configuration
```sql
-- Create database
CREATE DATABASE eduquiz;
USE eduquiz;

-- Create tables (execute schema.sql if available, or use your existing DB)
-- Configure your database credentials in DBConnection.java
```

**Update Database Connection** (src/main/java/dz/eduquiz/dao/DBConnection.java):
```java
String url = "jdbc:mysql://localhost:3306/eduquiz";
String user = "root";        // Your MySQL username
String password = "your_password"; // Your MySQL password
```

#### 3. Deploy to Local Tomcat
- Open project in Eclipse IDE
- Configure Tomcat server
- Right-click project → Run on Server
- Access at `http://localhost:8080/EduQuiz-final`

#### 4. Default Credentials
- **Admin Login**: 
  - Username: `Admin`
  - Password: `DnG@6RQ,*:Bp@2D`
- Create additional user accounts via registration page

---

## 📖 Usage Guide

### For Users
1. **Register**: Click "Sign Up" and create your account
2. **Browse Quizzes**: Explore available quizzes by category
3. **Take Quiz**: Select a quiz and answer all questions
4. **View Results**: See your score and review answers
5. **Track Progress**: Check your history and leaderboard ranking

### For Administrators
1. **Access Admin Panel**: Login with admin credentials → Dashboard
2. **Manage Users**: View, edit, or delete user accounts
3. **Manage Quizzes**: Create new quizzes, edit existing ones
4. **Manage Questions**: Add/edit/delete questions
5. **Import Questions**: Use OpenTrivia API integration to bulk import questions
6. **View Analytics**: Dashboard shows user count, quiz statistics

---

## 🛠️ Installation & Deployment

### Option 1: Local Development (Recommended for Testing)

```bash
# 1. Clone repository
git clone https://github.com/YourUsername/EduQuiz.git

# 2. Import into Eclipse
File → Import → General → Existing Projects into Workspace

# 3. Configure Tomcat in Eclipse
Window → Preferences → Server → Runtime Environments → Add

# 4. Run on Server
Right-click Project → Run on Server → Select Tomcat
```

## 🔧 Configuration

### Database Configuration
Edit `src/main/java/dz/eduquiz/dao/DBConnection.java`:
```java
public class DBConnection {
    private static final String URL = "jdbc:mysql://hostname:3306/dbname";
    private static final String USER = "username";
    private static final String PASSWORD = "password";
}
```

### Application Settings
- **Session Timeout**: Configure in `web.xml`
- **File Upload Path**: Modify `FileUtil.java`
- **API Settings**: Update OpenTrivia API URL if needed

---

## 📚 API Integrations

### OpenTrivia Database API
The application integrates with OpenTrivia DB for question importing.

**Endpoint**: `https://opentdb.com/api.php`
- Import questions by category
- Support for multiple difficulty levels
- JSON response parsing with custom models

---

## 🔐 Security Features

✅ **Password Hashing**: BCrypt algorithm (industry standard)
✅ **SQL Injection Prevention**: Parameterized queries in DAO layer
✅ **Session Management**: Server-side session tracking
✅ **Authentication**: Role-based access control (User/Admin)
✅ **Input Validation**: Both client and server-side validation
✅ **HTTPS Ready**: Deploy with SSL/TLS certificates

---

## 🧪 Testing

### Manual Testing
1. Register multiple user accounts
2. Create quizzes with various question types
3. Take quizzes and verify scoring logic
4. Test admin functions (CRUD operations)
5. Verify session management and logout

### Unit Testing (Future Enhancement)
- Implement JUnit for DAO layer
- Test service logic with mock objects
- Use Mockito for servlet testing

---

## 📊 Database Schema Overview

### Main Tables
- **users**: User accounts and authentication
- **categories**: Quiz categories
- **quizzes**: Quiz metadata
- **questions**: Quiz questions
- **scores**: User performance tracking

---

## 🐛 Known Issues & Limitations

- **PDF Export**: Not yet implemented for quiz results
- **Email Notifications**: Currently not available
- **Mobile Optimization**: UI needs responsive improvements
- **Real-time Updates**: No WebSocket support yet

---

## 🚧 Roadmap

- [ ] Email notifications for quiz results
- [ ] Mobile app (React Native)
- [ ] Quiz difficulty levels
- [ ] Question explanations and comments
- [ ] Certificate generation
- [ ] Advanced analytics dashboard
- [ ] Social sharing features
- [ ] API endpoints (REST)

---

## 🙏 Acknowledgments

- **OpenTrivia DB**: For providing free trivia data API
- **Apache Tomcat**: Application server
- **BCrypt**: Secure password hashing library
- **Jakarta JSTL**: Server-side templating

---

## 🎓 Educational Value

This project demonstrates:
- MVC (Model-View-Controller) architecture
- Object-Oriented Programming principles
- Database design and SQL optimization
- Web development best practices
- Security implementation in Java EE
- RESTful API integration
- Session management

---

**Last Updated**: December 2, 2025  
**Version**: 1.0.0  
**Author**: Morsli Omar
**Status**: ✅ Production Ready

---
