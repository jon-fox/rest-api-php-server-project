---
marp: true
---

# Stage 2 Grading and Submission

Total Points: 100

## Grading Policy & Rule

- No points may be given if students do not check the checklist and grade correctly.
- The professor will grade again to add or deduct points.
- Check Canvas or ask the professor for any questions or details.

---

**!Check this to earn points**
**If you did not finish any of the tasks, do not check the item.**

[ ] I understand the policy & Rule.
[ ] I uploaded all my project results (module2) to GitHub.
[ ] I uploaded all my project document (module3) to GitHub.io.
[ ] I zipped all of my project results (module2) in the submission.
[ ] I zipped all of my project document (module3) in the submission.

---

**The links to your GitHub repository and Zip file names**

- Your CSC 640 Project GitHub Repository: ___
  - GitHub Link to your code (module 2): ___
  - The Zip file name: ___ and size: ____
  - GitHub.io Link (module 3): ___
  - The Zip file name: ___ and size: ____

---

### FAQ

Q: For code link, what should I do?
A: You can give the link to your code in GitHub. For example, the first PHP server code can be found in <https://github.com/nkuase/ase230/tree/main/module1/code/1_First_PHP_Server>, you share the link similarly.

Q: Why do I need to check the zipped file size?
A: Some students copy all the GitHub files, not just code or document to make huge sized zip files. So, students need to check the zip file does not include any .git or similar hidden directories/files in it.

Q: Do I need to make two zipped files for code and document?
A: Yes, the code directory should contain the Laravel code and scripts (module 2), and the presentation directory should contain the GitHub.io files (module 3).

---

## 🔹 Laravel Implementation (20 pts)

- [ /7.5] Re-implemented Project 1 APIs using **Laravel framework** (must have same functionality as Project 1)
  - List your Laravel API endpoints:
  - [T/F] Uses Laravel routing and controllers properly
- [ /7.5] Used **Eloquent ORM** for database operations (no raw SQL queries)
  - List your Eloquent models:
  - [T/F] Proper model relationships implemented
- [ /5] Implemented authentication using **Laravel Sanctum** or similar
  - Authentication method used:
  - [T/F] Bearer token authentication working

---

### Grading Rule

- If you finished the task, give full points & select T.
- If you finished only partially, give partial points & select T.
- If you did not finish the task, select F.

The professor will regrade to add or subtract points.

---

| Task                                      | Points | Earned  |
|-------------------------------------------|--------|---------|
| Laravel API endpoints (same as Project 1) | 7.5     | [ /7.5]  |
| ↳ Uses Laravel routing/controllers        | T/F    | [ T/F ] |
| Eloquent ORM usage (no raw SQL)           | 7.5     | [ /7.5]  |
| ↳ Proper model relationships              | T/F    | [ T/F ] |
| Laravel authentication implementation     | 5     | [ /5]  |
| ↳ Bearer token authentication working     | T/F    | [ T/F ] |
| **Total**                                 | **20** | [ /20]  |

---

## 🔹 Deploy with a shell script (20 pts)

- [ /7.5] Understand **existing shell script examples** from course materials as reference
  - Reference materials used:
  - [T/F] Properly adapted existing scripts for Laravel
- [ /7.5] Created **automated deployment script** (`run.sh`) for one-command Laravel deployment
  - Script file name:
  - [T/F] Script successfully deploys Laravel application
- [ /5] Created a screen capture to show the script can start the Laravel REST API project
  - GitHub Link or Filename of the screen capture:
  - [T/F] Screen capture included

---

| Task                                  | Points | Earned  |
|---------------------------------------|--------|---------|
| Automated deployment script (run.sh)  | 7.5     | [ /7.5]  |
| ↳ Script successfully deploys Laravel | T/F    | [ T/F ] |
| Used existing shell script examples   | 7.5     | [ /7.5]  |
| ↳ Properly adapted for Laravel        | T/F    | [ T/F ] |
| Created a screen capture              | 5     | [ /5]  |
| ↳ Clear success/failure messages      | T/F    | [ T/F ] |
| **Total**                             | **20** | [ /20]  |

---

## FAQ

Q: For screen capture, what should I do?
A: You should prove that your code (or script) works by screen capture your output. After the screen capture, you can include that in your document, upload to GitHub, or copy the screen capture as part of your submission, and share the link or file name.

---

## 🔹 Deploy with Docker (20 pts)

- [ /7.5] **Containerized Laravel application** using Docker and Docker Compose
  - Docker files created:
  - [T/F] Dockerfile properly configured for Laravel
- [ /7.5] Created **setup script** (`setup.sh`) for one-command Docker deployment
  - Setup script file name:
  - [T/F] Script successfully builds and runs Docker containers
- [ /5] Created a screen capture to show the script can setup and run Docker
  - GitHub Link or Filename of the screen capture:
  - [T/F] Screen capture included

---

| Task                                  | Points | Earned  |
|---------------------------------------|--------|---------|
| Docker containerization (Laravel app) | 7.5     | [ /7.5]  |
| ↳ Dockerfile properly configured      | T/F    | [ T/F ] |
| Setup script for Docker deployment    | 7.5     | [ /7.5]  |
| ↳ Script builds and runs containers   | T/F    | [ T/F ] |
| Created a screen capture              | 5     | [ /5]  |
| ↳ Clear success/failure messages      | T/F    | [ T/F ] |
| **Total**                             | **20** | [ /20]  |

---

## 🔹 Re-implement Stage 1 Documentation (20 pts)

- [ /7.5] **Re-implemented Stage 1 documentation** using Hugo (transformed from Marp)
  - Hugo site structure created:
  - [T/F] Successfully converted Marp to Hugo markdown
- [ /7.5] **Added portfolio pages** to Hugo site
  - Portfolio pages added:
  - [T/F] Portfolio showcases CSC 640 project effectively
- [ /5] Created a screen capture to show you can use Hugo to build web site for your portfolio
  - GitHub Link or Filename of the screen capture:
  - [T/F] Screen capture included

---

| Task                             | Points | Earned  |
|----------------------------------|--------|---------|
| Hugo documentation (from Marp)   | 7.5     | [ /7.5]  |
| ↳ Successfully converted to Hugo | T/F    | [ T/F ] |
| Portfolio pages added to Hugo    | 7.5     | [ /7.5]  |
| ↳ Effective project showcase     | T/F    | [ T/F ] |
| Created a screen capture         | 5     | [ /5]  |
| ↳ Clear success/failure messages | T/F    | [ T/F ] |
| **Total**                        | **20** | [ /20]  |

---

## FAQ

Q1: What information do I upload for my GitHub.io?
A1: For REST API, you upload your project 1 document. For your portfolio page, it's up to you; upload your projects so far.

Q2: I don't know what information do I upload to Hugo about my portfolio. What should I do?
A2: As a starter, you can add your CSC 640 projects (PHP/Laravel REST API implementation, documentation using Hugo/Marp, and deployment using Docker & GitHub action); you can add more projects in the future.

---

## 🔹 Automatic Deploy to GitHub.io (20 pts)

- [ /7.5] **Published documentation to GitHub.io** using GitHub Actions
  - GitHub.io site URL:
  - [T/F] Site is publicly accessible and functional
- [ /7.5] **Uploaded complete source to GitHub** for automatic transformation
  - GitHub repository URL:
  - [T/F] GitHub Actions successfully builds and deploys
- [ /5] Created a screen capture to show you can run GitHub.io to deploy Hugo project
  - GitHub Link or Filename of the screen capture:
  - [T/F] Screen capture included

---

### Grading Rule

- If you finished the task, give full points & select T.
- If you finished only partially, give partial points & select T.
- If you did not finish the task, select F.

Professor will regrade to add or subtract points.

---

| Task                                  | Points | Earned  |
|---------------------------------------|--------|---------|
| GitHub.io publication                 | 7.5     | [ /7.5]  |
| ↳ Site publicly accessible            | T/F    | [ T/F ] |
| Complete source uploaded to GitHub    | 7.5     | [ /7.5]  |
| ↳ GitHub Actions builds and deploys   | T/F    | [ T/F ] |
| GitHub Actions workflow configuration | 10     | [ /10]  |
| ↳ Automatic deployment on push        | T/F    | [ T/F ] |
| **Total**                             | **20** | [ /20]  |

---

## 🏁 Final Checks

- [ ] I understand that I may deduct points if the results are of poor quality.
- [ ] I understand that I may be reported as plagiarism if I used other work (including AI) without proper reference.
- [ ] Pushed to GitHub
- [ ] Zipped the code/document.
- [ ] Checked there is no .git directory or any hidden directories included from the zipped file size (______). <- write the file sizes
- [ ] Copy zipped files in correct directory: `code/`, `presentation/`, `plan/`  
- [ ] Project ready for **professional portfolio showcase**  
- [ ] Hugo site deployed to GitHub.io and accessible  

---

## 📊 Project 2 Total Points

| Task                                    | Points  | Earned  |
|-----------------------------------------|---------|---------|
| 🔹 Laravel Implementation               | 20      | [ /2å0]  |
| 🔹 Deploy with a shell script           | 20      | [ /20]  |
| 🔹 Deploy with Docker                   | 20      | [ /20]  |
| 🔹 Re-implement Project 1 Documentation | 20      | [ /20]  |
| 🔹 Automatic Deploy to GitHub.io        | 20      | [ /20]  |
| **Total**                               | **100** | [ /100] |

---

Ask any questions when you need help!
