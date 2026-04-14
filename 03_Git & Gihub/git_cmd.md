# Git
- Version Control System
- It helps developers,
  Track changes in source code,
  Manage versions,
  And collaborate efficiently


***************************************************************************************
# Install git on Linux/Ubuntu
- apt-get install git
- sudo apt-get install git


***************************************************************************************
# Check Version
- git -v


***************************************************************************************
# (1) git init
- Initializes an empty git repository (untracked file)

##### 📌 State after git init:
- All files = Untracked


***************************************************************************************
## (2) git add fileName
- Moves files from the Working Directory → Staging Area


## git add . (for all files)



##### 📌 State after git add:

- Become (Staged file)
- Git is ready to commit them

***************************************************************************************
## 📝 Unstage File
## ✅ (i) Unstage a specific file
#### git rm --cached <app.js>

- Removes file from staging only
- Keeps file in working directory (not deleted)

## ✅ (ii) Unstage ALL files (method 1)
#### git rm --cached .

- Unstages all files
- ⚠ If your project has folders, Git may warn — use recursive option below.

## ✅ (iii) Unstage ALL files including folders (recursive)
#### git rm -r --cached .

- Unstages everything (files + folders)
- Safe & commonly used

## ✅ (iv) Easiest & recommended: reset staging
#### git reset

- Removes all staged files
- Keeps your changes
- Most used command for unstaging

## 📌 Summary (Best Practice)
|      Action                  |      Command              |    Use Case           |
|------------------------------|---------------------------|-----------------------|
|   Unstage 1 file             |   git rm --cached file.py |   Only one file       |
|   Unstage all                |   git rm -r --cached .    |   All files & folders |
|   Unstage all (recommended)  |   git reset               |   Fastest & simplest  |


***************************************************************************************
# (3) git commit -m "message"

- Takes everything from the Staging Area and saves a snapshot in the repository.

##### 📌 State after git commit:

- Files become Tracked + Committed
- Git now starts version control history

## ✔ Full Flow Summary

| Command                 | Moves File   | To File State After |
| ----------------------- | ------------ | ------------------- |
| git init                | —            | Untracked           |
| git add fileName        | Staging Area | Staged              |
| git commit -m "message" | Repository   | Tracked / Committed |

# (4) git status

- What Branch you are in.
- How many Commits you have made.
- How many Track/ Untrack files are there.

# (5) Create a new branch & switch

```bash
git switch -c <branchName>        # recommended
# OR
git checkout -b <branchName>      # old method
```

## Switch Branch

```bash
git switch <branchName>           # recommended
# OR
git checkout <branchName>         # old method
```

## Check all branches

- git branch

## Quick Revision Sheet (Table Format)

| Command                | Action                              |
| ---------------------- | ----------------------------------- |
| git switch -c <name>   | Create + switch branch (new method) |
| git checkout -b <name> | Create + switch branch (old method) |
| git switch <name>      | Switch branch (new method)          |
| git checkout <name>    | Switch branch (old method)          |
| git switch main/master | Go back to main/master              |
| git branch             | List branches                       |

# To unstaged / untracked

# git restore fileName

- restore deleted file

---

🔹 𝗗𝗮𝗶𝗹𝘆 𝗕𝗮𝘀𝗶𝗰𝘀
👉 git status – Check current changes
👉 git diff – See what changed
👉 git add <file> – Stage changes
👉 git commit -a -m "message" – Commit updates
👉 git log --stat – Review commit history

🔹 𝗕𝗿𝗮𝗻𝗰𝗵𝗶𝗻𝗴 & 𝗖𝗼𝗹𝗹𝗮𝗯𝗼𝗿𝗮𝘁𝗶𝗼𝗻
👉 git checkout -b <branch> – Create new branch
👉 git checkout <branch> – Switch branch
👉 git branch – List branches
👉 git merge – Merge branches
👉 git push origin <branch> – Push changes
👉 git pull – Sync latest changes

🔹 𝗙𝗶𝘅𝗶𝗻𝗴 𝗠𝗶𝘀𝘁𝗮𝗸𝗲𝘀 (𝗛𝗮𝗽𝗽𝗲𝗻𝘀 𝘁𝗼 𝗘𝘃𝗲𝗿𝘆𝗼𝗻𝗲 😅)
👉 git commit --amend – Edit last commit
👉 git reset HEAD~1 – Undo last commit (keep changes)
👉 git reset --hard – Reset completely (careful ⚠️)
👉 git revert – Safely undo via new commit
👉 git rebase -i – Clean up commit history

🔹 𝗔𝗱𝘃𝗮𝗻𝗰𝗲𝗱 𝗯𝘂𝘁 𝗨𝘀𝗲𝗳𝘂𝗹
👉 git stash / git stash pop – Temporarily save changes
👉 git cherry-pick <commit> – Apply specific commit
👉 git show <commit> – Inspect commit details
👉 git branch -D <branch> – Delete branch
👉 git format-patch / git apply – Share patches
👉 git clone – Copy a repository
