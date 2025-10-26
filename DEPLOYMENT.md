# EduLearn Deployment Guide

This guide will help you deploy the EduLearn platform to Firebase Hosting.

## Prerequisites

1. **Node.js** (version 14 or higher)
2. **Firebase CLI** installed globally
3. **Firebase project** created
4. **Git** for version control

## Step 1: Install Dependencies

```bash
# Install Firebase CLI globally
npm install -g firebase-tools

# Install project dependencies
npm install
```

## Step 2: Firebase Setup

### 2.1 Login to Firebase
```bash
firebase login
```

### 2.2 Initialize Firebase Project
```bash
firebase init
```

Select the following options:
- ✅ **Hosting**: Configure files for Firebase Hosting
- ✅ **Firestore**: Configure security rules and indexes files
- ✅ **Storage**: Configure a security rules file for Cloud Storage

### 2.3 Configure Firebase Services

#### Hosting Configuration
- **Public directory**: `frontend`
- **Single-page app**: `Yes`
- **Overwrite index.html**: `No`

#### Firestore Configuration
- **Firestore rules file**: `backend/firestore.rules`
- **Firestore indexes file**: `backend/firestore.indexes.json`

#### Storage Configuration
- **Storage rules file**: `backend/storage.rules`

## Step 3: Configure Firebase Project

### 3.1 Update Firebase Configuration
Run the setup script to configure Firebase:
```bash
npm run setup
```

Or manually update `frontend/js/firebase-config.js` with your Firebase credentials.

### 3.2 Enable Firebase Services

In the Firebase Console:

1. **Authentication**
   - Go to Authentication > Sign-in method
   - Enable Email/Password
   - Configure authorized domains

2. **Firestore Database**
   - Go to Firestore Database
   - Create database in production mode
   - Deploy security rules: `firebase deploy --only firestore:rules`

3. **Storage**
   - Go to Storage
   - Get started with default security rules
   - Deploy storage rules: `firebase deploy --only storage`

## Step 4: Deploy to Firebase

### 4.1 Deploy Everything
```bash
npm run deploy
```

### 4.2 Deploy Individual Services
```bash
# Deploy only hosting
npm run deploy:hosting

# Deploy only Firestore rules
npm run deploy:firestore

# Deploy only Storage rules
npm run deploy:storage
```

## Step 5: Verify Deployment

1. **Check Hosting URL**: Your site will be available at `https://your-project-id.web.app`
2. **Test Authentication**: Try signing up and logging in
3. **Test Responsiveness**: Check on different devices
4. **Test PWA Features**: Install as app on mobile devices

## Step 6: Custom Domain (Optional)

### 6.1 Add Custom Domain
1. Go to Firebase Console > Hosting
2. Click "Add custom domain"
3. Follow the verification steps
4. Update DNS records as instructed

### 6.2 SSL Certificate
Firebase automatically provides SSL certificates for custom domains.

## Environment-Specific Deployments

### Development Environment
```bash
# Start local development server
npm run dev

# Start Firebase emulators
npm run emulators
```

### Staging Environment
```bash
# Deploy to staging project
firebase use staging
firebase deploy
```

### Production Environment
```bash
# Deploy to production project
firebase use production
firebase deploy
```

## Monitoring and Analytics

### 1. Firebase Analytics
- Automatically enabled with Firebase
- View user engagement in Firebase Console

### 2. Performance Monitoring
- Enable in Firebase Console
- Monitor app performance and crashes

### 3. Error Reporting
- Automatically enabled
- View errors in Firebase Console

## Security Considerations

### 1. Security Rules
- Review and test Firestore rules
- Review and test Storage rules
- Use Firebase Security Rules Simulator

### 2. Authentication
- Enable email verification
- Configure password requirements
- Set up admin users

### 3. CORS Configuration
- Configure CORS for your domain
- Restrict API access

## Troubleshooting

### Common Issues

#### 1. Build Errors
```bash
# Clear Firebase cache
firebase logout
firebase login
```

#### 2. Permission Errors
```bash
# Check Firebase project permissions
firebase projects:list
firebase use your-project-id
```

#### 3. Hosting Issues
```bash
# Check hosting configuration
firebase hosting:channel:list
```

#### 4. Authentication Issues
- Verify Firebase configuration
- Check authorized domains
- Verify email templates

### Debug Mode
```bash
# Enable debug logging
firebase --debug deploy
```

## Performance Optimization

### 1. Caching
- Configure cache headers in `firebase.json`
- Use service worker for offline caching

### 2. CDN
- Firebase Hosting uses global CDN
- Optimize images and assets

### 3. Bundle Size
- Minimize JavaScript and CSS
- Use code splitting if needed

## Backup and Recovery

### 1. Database Backup
```bash
# Export Firestore data
gcloud firestore export gs://your-backup-bucket
```

### 2. Code Backup
- Use Git for version control
- Tag releases for easy rollback

### 3. Configuration Backup
- Backup Firebase configuration
- Document environment variables

## Scaling Considerations

### 1. Firestore Scaling
- Use composite indexes
- Optimize queries
- Consider sharding for large datasets

### 2. Storage Scaling
- Implement file compression
- Use appropriate file formats
- Consider CDN for large files

### 3. Hosting Scaling
- Firebase Hosting scales automatically
- Monitor usage and costs

## Cost Optimization

### 1. Firestore
- Optimize read/write operations
- Use offline persistence
- Implement proper indexing

### 2. Storage
- Compress files before upload
- Delete unused files
- Use appropriate storage classes

### 3. Hosting
- Optimize asset sizes
- Use efficient caching strategies

## Maintenance

### 1. Regular Updates
- Update dependencies regularly
- Monitor security advisories
- Test updates in staging

### 2. Monitoring
- Set up alerts for errors
- Monitor performance metrics
- Track user engagement

### 3. Backup Strategy
- Regular database backups
- Code repository backups
- Configuration backups

## Support

For deployment issues:
1. Check Firebase Console for errors
2. Review Firebase documentation
3. Check GitHub issues
4. Contact Firebase support

---

**Note**: This deployment guide assumes you have basic knowledge of Firebase and web development. For more detailed information, refer to the [Firebase Documentation](https://firebase.google.com/docs).
