# EduLearn - Empowering African Students Through Digital Learning

## 🎓 Project Overview

**EduLearn** is a comprehensive educational platform designed specifically for African students, providing access to world-class learning resources, exam preparation tools, and collaborative learning environments.

### 🎯 Tagline
*"Empowering African Students Through Digital Learning"*

## 📋 Problem Statement

African students face significant challenges in accessing quality educational resources and exam preparation materials. Many students lack access to:
- Comprehensive quiz systems for self-assessment
- Qualified tutors for personalized learning
- Progress tracking tools to monitor academic growth
- Collaborative study groups for peer learning
- Exam preparation resources for major African examinations (WAEC, JAMB, SAT)

EduLearn addresses these gaps by providing a unified platform that democratizes access to quality education across Africa.

## 👥 Target Users

- **Primary**: African high school and university students
- **Secondary**: Teachers and educators seeking to enhance their teaching tools
- **Tertiary**: Parents supporting their children's education

## 🚀 Core Features

### 1. Interactive Quizzes
- Comprehensive quiz system across 8+ subjects
- Adaptive difficulty levels (Easy, Medium, Hard)
- Real-time scoring and detailed feedback
- PDF report generation for quiz results
- Progress tracking per subject

### 2. Virtual Tutoring
- Qualified tutor profiles with ratings and specialties
- Session booking system with time slot management
- Subject-specific tutoring (Mathematics, Physics, Chemistry, Biology, English, History)
- Integrated video call capabilities
- Booking confirmation and management

### 3. Progress Tracking
- Detailed analytics dashboard with interactive charts
- Subject-wise performance tracking
- Study time analytics and insights
- Achievement system and learning goals
- Recent activity timeline

### 4. Study Groups
- Create and join subject-specific study groups
- Group management with member roles
- Collaborative learning environment
- Group creation and moderation tools
- Member invitation and management system

### 5. Exam Preparation
- WAEC, JAMB, and SAT preparation modules
- Past questions database
- Mock examinations with time limits
- Performance analytics and improvement suggestions
- Study timetables and schedules

## 🛠 Technology Stack

### Frontend
- **HTML5** - Semantic markup and structure
- **CSS3** - Modern styling with Flexbox/Grid layouts
- **JavaScript (ES6+)** - Interactive functionality and DOM manipulation
- **Chart.js** - Data visualization for progress tracking
- **Font Awesome** - Icon library for UI elements

### Backend & Database
- **Firebase Authentication** - User management and security
- **Firestore** - NoSQL database for user data and quiz results
- **Firebase Storage** - File storage for resources and documents

### Development Tools
- **Git** - Version control
- **VS Code** - Development environment
- **Python HTTP Server** - Local development server

### DevOps & Deployment
- **GitHub** - Repository hosting and project management
- **GitHub Projects** - Kanban board for task management
- **GitHub Actions** - CI/CD pipeline (planned)
- **Docker** - Containerization (planned)
- **Cloud Deployment** - AWS/Azure deployment (planned)

## 🏃‍♂️ Getting Started

### Prerequisites
- Modern web browser (Chrome, Firefox, Safari, Edge)
- Python 3.x (for local development server)
- Git (for version control)

### Installation & Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/Formative-Edu.git
   cd Formative-Edu
   ```

2. **Navigate to frontend directory**
   ```bash
   cd frontend
   ```

3. **Start the local development server**
   ```bash
   # Using Python 3
   python -m http.server 8000
   
   # Or using Python 2
   python -m SimpleHTTPServer 8000
   ```

4. **Access the application**
   - Open your web browser
   - Navigate to `http://localhost:8000`
   - For the landing page: `http://localhost:8000/landing.html`
   - For the student platform: `http://localhost:8000/student-platform.html`

### Alternative Setup (Using Node.js)
```bash
# Install serve globally
npm install -g serve

# Navigate to frontend directory
cd frontend

# Start the server
serve -p 3000
```

## 📁 Project Structure

```
Formative-Edu/
├── README.md
├── .gitignore
├── frontend/
│   ├── index.html                 # Main learning platform
│   ├── landing.html              # Public landing page
│   ├── student-platform.html     # Student dashboard
│   ├── interactive-quizzes.html  # Quiz platform
│   ├── virtual-tutoring.html     # Tutoring platform
│   ├── progress-tracking.html    # Analytics dashboard
│   ├── study-groups.html         # Study groups platform
│   ├── styles/
│   │   ├── main.css              # Main stylesheet
│   │   ├── quiz.css              # Quiz-specific styles
│   │   ├── tutoring.css          # Tutoring-specific styles
│   │   ├── progress.css          # Progress tracking styles
│   │   └── study-groups.css      # Study groups styles
│   └── js/
│       ├── firebase-config.js    # Firebase configuration
│       ├── auth.js               # Authentication logic
│       ├── main.js               # Main application logic
│       ├── quiz.js               # Quiz functionality
│       ├── tutoring.js           # Tutoring functionality
│       ├── progress.js           # Progress tracking
│       ├── study-groups.js       # Study groups functionality
│       └── landing.js            # Landing page logic
└── backend/                      # Future backend implementation
```

## 🔧 Configuration

### Firebase Setup
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Enable Authentication and Firestore Database
3. Update `frontend/js/firebase-config.js` with your Firebase configuration
4. Configure Firestore security rules for your project

### Environment Variables
Create a `.env` file in the root directory (not included in version control):
```
FIREBASE_API_KEY=your_api_key
FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
FIREBASE_PROJECT_ID=your_project_id
```

## 🧪 Testing

### Manual Testing
1. **Authentication Flow**
   - Test user registration
   - Test user login/logout
   - Test password reset functionality

2. **Quiz System**
   - Take quizzes in different subjects
   - Verify scoring and feedback
   - Test PDF report generation

3. **Tutoring System**
   - Browse available tutors
   - Book tutoring sessions
   - Test booking confirmation

4. **Progress Tracking**
   - Verify data visualization
   - Test progress calculations
   - Check achievement system

5. **Study Groups**
   - Create new study groups
   - Join existing groups
   - Test group management features

## 🚀 Deployment

### Local Development
- Use Python HTTP server for local testing
- All features work offline except Firebase-dependent functionality

### Production Deployment (Planned)
- Docker containerization
- Cloud deployment on AWS/Azure
- CI/CD pipeline with GitHub Actions
- Automated testing and deployment

## 📊 Project Status

### ✅ Completed Features
- [x] User authentication system
- [x] Interactive quiz platform
- [x] Virtual tutoring system
- [x] Progress tracking dashboard
- [x] Study groups management
- [x] Responsive design for all devices
- [x] Firebase integration
- [x] PDF report generation

### 🚧 In Progress
- [ ] Enhanced quiz question database
- [ ] Video call integration for tutoring
- [ ] Advanced analytics features
- [ ] Mobile app development

### 📋 Planned Features
- [ ] Offline quiz capabilities
- [ ] AI-powered learning recommendations
- [ ] Multi-language support
- [ ] Advanced reporting system
- [ ] Integration with African educational boards

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Project Lead**: Gabriel Pawuoi
- **Frontend Developer**: Lina IRATWE
- **Backend Developer**: Gabriel Pawuoi
- **DevOps Engineer**: Lenine NGENZI

## 📞 Support

For support and questions:
- Email: support@edulearn.africa
- GitHub Issues: [Create an issue](https://github.com/yourusername/Formative-Edu/issues)
- Documentation: [Wiki](https://github.com/yourusername/Formative-Edu/wiki)

## 🙏 Acknowledgments

- Firebase for providing the backend infrastructure
- Chart.js for data visualization capabilities
- Font Awesome for the icon library
- African educational boards for inspiration and requirements

---

**EduLearn** - Empowering the next generation of African leaders through quality education. 🌍📚
