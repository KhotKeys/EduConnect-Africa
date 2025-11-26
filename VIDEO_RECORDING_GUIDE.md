# 🎬 VIDEO RECORDING GUIDE (10-15 Minutes)

## ✅ README Status: PERFECT
- Live URL: http://16.171.136.183 ✅
- Architecture: Referenced ✅
- All requirements documented ✅

## 🎥 Video Script & Recording Guide

### Equipment Needed:
- Screen recording software (OBS Studio, Loom, or Windows Game Bar: Win+G)
- Microphone (built-in is fine)
- Browser with GitHub open

### Recording Structure:

---

## PART 1: Introduction (2 minutes)

**What to say:**
"Hello, I'm presenting EduConnect Africa, a comprehensive educational platform for African students. This is our summative project demonstrating a complete Git-to-Production workflow with Infrastructure as Code, CI/CD pipelines, and automated deployment to AWS."

**What to show:**
1. Open README.md in browser
2. Show live URL: http://16.171.136.183
3. Click the link - show the site is working
4. Scroll through README showing:
   - Technology stack
   - DevOps pipeline section
   - Architecture reference

**Script:**
"Our application is live at http://16.171.136.183, deployed on AWS EC2 using Docker containers. We've implemented a complete DevOps pipeline with Terraform for infrastructure, Ansible for configuration management, and GitHub Actions for CI/CD."

---

## PART 2: Show Infrastructure (2 minutes)

**What to show:**
1. Open `terraform/` directory in VS Code
   - Show main.tf, variables.tf, outputs.tf
   - Show modules: network, compute, database, ecr, security

2. Open `ansible/` directory
   - Show deploy.yml playbook
   - Show requirements.yml

**What to say:**
"Here's our Infrastructure as Code using Terraform. We have modular configuration with 5 modules: network for VPC, compute for EC2 instances, database for RDS, ECR for container registry, and security for security groups."

"Our Ansible playbook automates the deployment process, installing Docker and deploying our containerized application."

---

## PART 3: Git-to-Production Demo (7-8 minutes) **MOST IMPORTANT**

### Step 1: Make a Code Change (1 min)

**What to do:**
1. Open `frontend/index.html` in VS Code
2. Find line with "Welcome to EduLearn"
3. Change to: "Welcome to EduLearn - Live Demo!"

**What to say:**
"Now I'll demonstrate our Git-to-Production workflow. I'm making a simple change to the welcome message to show how code changes automatically deploy to production."

### Step 2: Create Branch and Push (1 min)

**Commands to run:**
```bash
git checkout -b demo-video-change
git add frontend/index.html
git commit -m "demo: update welcome message for video"
git push origin demo-video-change
```

**What to say:**
"I'm creating a feature branch, committing my change, and pushing to GitHub. This will trigger our CI pipeline."

### Step 3: Create Pull Request (2 min)

**What to do:**
1. Go to GitHub: https://github.com/KhotKeys/EduConnect-Africa
2. Click "Compare & pull request"
3. Title: "Demo: Update welcome message"
4. Click "Create pull request"

**What to show:**
1. Wait for CI checks to start
2. Click on "Details" for each check:
   - ✅ Lint & Test
   - ✅ Security Scanning
   - ✅ Docker Image Security
   - ✅ Terraform Security Scan

**What to say:**
"Our CI pipeline is now running four security checks: linting and testing, filesystem security scanning with Trivy, Docker image security scanning, and Terraform infrastructure scanning with tfsec. All checks must pass before we can merge."

### Step 4: Show CI Passing (1 min)

**What to show:**
- All 4 green checkmarks
- Click into one check to show the logs briefly

**What to say:**
"All our CI checks have passed. The code has been linted, tested, and scanned for security vulnerabilities. We're now safe to merge to production."

### Step 5: Merge PR (30 seconds)

**What to do:**
1. Click "Merge pull request"
2. Click "Confirm merge"

**What to say:**
"I'm now merging this pull request to main, which will automatically trigger our CD pipeline to deploy to production."

### Step 6: Show CD Pipeline (2 min)

**What to do:**
1. Go to Actions tab
2. Click on the running "CD - Deploy to Production" workflow
3. Show the jobs:
   - ✅ Check File Encoding
   - ✅ Security Validation
   - ✅ Build & Push to ECR
   - ✅ Deploy with Ansible

**What to say:**
"The CD pipeline is now running. It's building our Docker image, pushing it to our private ECR registry on AWS, and deploying it to our EC2 instance. This entire process is automated - from code commit to production deployment."

### Step 7: Verify Live Change (30 seconds)

**What to do:**
1. Open http://16.171.136.183 in browser
2. Refresh the page
3. Show the updated welcome message: "Welcome to EduLearn - Live Demo!"

**What to say:**
"And here's our change live in production! The welcome message has been updated. This demonstrates our complete Git-to-Production workflow - from code change to automated testing, security scanning, and deployment."

---

## PART 4: Summary & Architecture (2 minutes)

**What to show:**
1. Go back to GitHub Actions - show successful deployments
2. Open ARCHITECTURE.md or show architecture diagram if you have one
3. Show the repository structure

**What to say:**
"To summarize, our project includes:
- Complete Infrastructure as Code with Terraform
- Configuration management with Ansible
- Comprehensive CI pipeline with 4 security checks
- Automated CD pipeline that deploys to AWS
- Live application running on EC2 with Docker
- Private container registry on ECR
- All code changes go through automated testing and security scanning before deployment

This demonstrates a production-ready DevSecOps pipeline with security scanning at every stage, automated deployment, and zero-downtime updates."

---

## PART 5: Closing (30 seconds)

**What to say:**
"Thank you for watching. Our complete codebase is available on GitHub at github.com/KhotKeys/EduConnect-Africa, and the live application is accessible at http://16.171.136.183. All documentation, including setup instructions and architecture diagrams, is in the README."

---

## 📝 Recording Checklist

Before you start recording:
- [ ] Close unnecessary browser tabs
- [ ] Clear notifications
- [ ] Test your microphone
- [ ] Have GitHub open and logged in
- [ ] Have VS Code open with the project
- [ ] Have http://16.171.136.183 bookmarked
- [ ] Practice the git commands
- [ ] Make sure you're on main branch: `git checkout main && git pull`

## 🎬 Recording Tips

1. **Speak clearly and not too fast**
2. **Pause briefly between sections**
3. **If you make a mistake, just pause and continue - you can edit later**
4. **Show your face in a small webcam window (optional but nice)**
5. **Keep it under 15 minutes**
6. **End with a smile!**

## 📤 After Recording

1. **Upload to YouTube** (unlisted or public)
   - Title: "EduConnect Africa - Git-to-Production DevOps Pipeline"
   - Description: Include GitHub repo link and live URL

2. **Or upload to Google Drive/Loom**
   - Make sure link is accessible

3. **Get the shareable link**

4. **Submit on Canvas:**
   - GitHub Repository URL: https://github.com/KhotKeys/EduConnect-Africa
   - Live Application URL: http://16.171.136.183
   - Video Link: [Your video link]

## 🎉 YOU'RE READY TO RECORD!

Everything is working. Just follow this script and you'll have a perfect demo video!

Good luck! 🚀
