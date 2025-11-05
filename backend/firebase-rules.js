// Firebase Security Rules for EduLearn Platform

// Firestore Database Rules
const firestoreRules = `
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      allow read: if request.auth != null && 
        (resource.data.userType == 'teacher' || 
         request.auth.uid in resource.data.parents);
    }
    
    // Resources collection
    match /resources/{resourceId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
        (get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType in ['teacher', 'admin']);
      allow update, delete: if request.auth != null && 
        (resource.data.uploadedBy == request.auth.uid || 
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType == 'admin');
    }
    
    // Study groups collection
    match /studyGroups/{groupId} {
      allow read: if request.auth != null && 
        (request.auth.uid in resource.data.members || 
         resource.data.isPublic == true);
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        (resource.data.createdBy == request.auth.uid || 
         request.auth.uid in resource.data.admins);
    }
    
    // Progress tracking collection
    match /progress/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      allow read: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType in ['teacher', 'parent'] &&
        request.auth.uid in get(/databases/$(database)/documents/users/$(userId)).data.parents;
    }
    
    // Quiz results collection
    match /quizResults/{resultId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      allow read: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType in ['teacher', 'admin'];
    }
    
    // Discussion forums collection
    match /forums/{forumId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        (resource.data.authorId == request.auth.uid || 
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType == 'admin');
    }
    
    // Comments on forum posts
    match /forums/{forumId}/comments/{commentId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        (resource.data.authorId == request.auth.uid || 
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType == 'admin');
    }
    
    // Notifications collection
    match /notifications/{notificationId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
    
    // Admin settings collection
    match /adminSettings/{settingId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType == 'admin';
    }
  }
}
`;

// Firebase Storage Rules
const storageRules = `
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // User profile images
    match /users/{userId}/profile/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId &&
        request.resource.size < 5 * 1024 * 1024 && // 5MB limit
        request.resource.contentType.matches('image/.*');
    }
    
    // Educational resources
    match /resources/{resourceId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType in ['teacher', 'admin'] &&
        request.resource.size < 50 * 1024 * 1024 && // 50MB limit
        request.resource.contentType.matches('(application/pdf|image/.*|video/.*|audio/.*)');
    }
    
    // Study group files
    match /studyGroups/{groupId}/{fileName} {
      allow read: if request.auth != null && 
        (request.auth.uid in get(/databases/$(database)/documents/studyGroups/$(groupId)).data.members);
      allow write: if request.auth != null && 
        request.auth.uid in get(/databases/$(database)/documents/studyGroups/$(groupId)).data.members &&
        request.resource.size < 25 * 1024 * 1024; // 25MB limit
    }
    
    // Quiz attachments
    match /quizzes/{quizId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType in ['teacher', 'admin'] &&
        request.resource.size < 10 * 1024 * 1024; // 10MB limit
    }
  }
}
`;

// Firebase Authentication Configuration
const authConfig = {
  // Email/Password authentication
  emailPassword: {
    enabled: true,
    requireEmailVerification: true,
    allowPasswordReset: true
  },
  
  // Google Sign-In (optional)
  google: {
    enabled: false, // Set to true if you want to enable Google sign-in
    clientId: "your-google-client-id"
  },
  
  // Phone authentication (optional)
  phone: {
    enabled: false, // Set to true if you want to enable phone authentication
    testPhoneNumbers: ["+1234567890"] // For testing only
  }
};

// Database Indexes for Firestore
const firestoreIndexes = `
{
  "indexes": [
    {
      "collectionGroup": "resources",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "subject",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "gradeLevel",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "createdAt",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "studyGroups",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "subject",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "isPublic",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "createdAt",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "quizResults",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "userId",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "quizId",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "completedAt",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "forums",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "subject",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "createdAt",
          "order": "DESCENDING"
        }
      ]
    }
  ],
  "fieldOverrides": []
}
`;

// Export configurations
module.exports = {
  firestoreRules,
  storageRules,
  authConfig,
  firestoreIndexes
};

// Instructions for deploying rules:
// 1. Save firestore.rules file with the firestoreRules content
// 2. Save storage.rules file with the storageRules content
// 3. Save firestore.indexes.json file with the firestoreIndexes content
// 4. Deploy using Firebase CLI:
//    firebase deploy --only firestore:rules
//    firebase deploy --only storage
//    firebase deploy --only firestore:indexes
