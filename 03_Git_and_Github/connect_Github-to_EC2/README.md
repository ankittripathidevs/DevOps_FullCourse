# 🔐 Connect GitHub to AWS EC2 Using SSH

> **Topic:** GitHub SSH Authentication  
> **Purpose:** Connect an EC2 instance to GitHub so the EC2 server can clone, pull, and push repositories without repeatedly entering GitHub credentials.

---

## 📌 1. Basic Concept

```text
                         SSH Authentication
                                
        AWS EC2  ───────────────────────────►  GitHub
           │                                      │
           │                                      │
     Private Key 🔐                         Public Key 🔑
     id_ed25519                            id_ed25519.pub
```

### SSH Key Pair

When we create an SSH key, two files are generated:

```text
~/.ssh/
├── id_ed25519       🔐 Private Key
└── id_ed25519.pub   🔑 Public Key
```

| Key | Location | Purpose | Share? |
|---|---|---|---|
| Private Key | `~/.ssh/id_ed25519` | Used by EC2 for authentication | ❌ NEVER |
| Public Key | `~/.ssh/id_ed25519.pub` | Added to GitHub | ✅ Yes |
| `known_hosts` | `~/.ssh/known_hosts` | Stores trusted SSH hosts | 🔒 Keep on EC2 |
| `authorized_keys` | `~/.ssh/authorized_keys` | Allows SSH access to EC2 | 🔒 Keep on EC2 |

### 🔐 Golden Rule

```text
Private Key  → stays on EC2

Public Key   → goes to GitHub
```

**Never share or upload the private key.**

---

# 🚀 2. New EC2 → GitHub Setup

Whenever a **new EC2 instance** is created, follow these steps.

---

## Step 1 — Check Git

```bash
git --version
```

### What does it mean?

```text
git
 ↓
Git program

--version
 ↓
Show installed Git version
```

Example:

```text
git version 2.43.0
```

### If Git is not installed

```bash
sudo apt update
sudo apt install git -y
```

Then verify:

```bash
git --version
```

---

# 🔑 3. Check Existing SSH Key

Before creating a new SSH key, check whether one already exists.

```bash
ls -la ~/.ssh
```

Look for:

```text
id_ed25519
id_ed25519.pub
```

Example:

```text
~/.ssh/
├── authorized_keys
├── id_ed25519
├── id_ed25519.pub
└── known_hosts
```

### If the keys already exist

If you already have:

```text
id_ed25519
id_ed25519.pub
```

**Do NOT create another key unnecessarily.**

Use the existing key.

---

# 🆕 4. Create SSH Key If It Does Not Exist

If `id_ed25519` and `id_ed25519.pub` do not exist:

```bash
ssh-keygen -t ed25519 -C "ec2-github"
```

### Meaning

```text
ssh-keygen
    ↓
Generate SSH key

-t ed25519
    ↓
Use Ed25519 key type

-C "ec2-github"
    ↓
Add a recognizable comment
```

When asked:

```text
Enter file in which to save the key (/home/ubuntu/.ssh/id_ed25519):
```

Press:

```text
Enter
```

For the passphrase:

```text
Enter passphrase (empty for no passphrase):
```

Press:

```text
Enter
```

Then:

```text
Enter same passphrase again:
```

Press:

```text
Enter
```

The following files will be created:

```text
~/.ssh/
├── id_ed25519
└── id_ed25519.pub
```

---

# 🔍 5. Get the Public SSH Key

Run:

```bash
cat ~/.ssh/id_ed25519.pub
```

Example:

```text
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI...... ec2-github
```

Copy the **entire line**.

### ⚠️ DO NOT run:

```bash
cat ~/.ssh/id_ed25519
```

That displays the **private key**.

Never share the private key.

---

# 🌐 6. Add Public Key to GitHub

Go to:

```text
GitHub
  ↓
Settings
  ↓
SSH and GPG keys
  ↓
New SSH key
```

Enter:

```text
Title:
AWS EC2
```

Select:

```text
Key type:
Authentication Key
```

Paste the output of:

```bash
cat ~/.ssh/id_ed25519.pub
```

Then click:

```text
Add SSH key
```

---

# 🧪 7. Test EC2 → GitHub SSH Connection

Run:

```bash
ssh -T git@github.com
```

The first time, you may see:

```text
Are you sure you want to continue connecting
(yes/no/[fingerprint])?
```

Type:

```text
yes
```

### Successful result

You should see:

```text
Hi YOUR_GITHUB_USERNAME! You've successfully authenticated,
but GitHub does not provide shell access.
```

### ✅ This is NOT an error.

The important part is:

```text
You've successfully authenticated
```

This means:

```text
EC2 ───── SSH ─────► GitHub
          ✅
```

---

# 📥 8. Clone GitHub Repository

Go to your GitHub repository:

```text
Repository
   ↓
Code
   ↓
SSH
```

GitHub will give you an SSH URL:

```text
git@github.com:USERNAME/REPOSITORY.git
```

Example:

```text
git@github.com:ankittripathidevs/DevOps_FullCourse.git
```

Clone:

```bash
git clone git@github.com:ankittripathidevs/DevOps_FullCourse.git
```

Then:

```bash
ls
```

Example:

```text
DevOps_FullCourse
```

Enter the repository:

```bash
cd DevOps_FullCourse
```

Check:

```bash
git status
```

---

# ⚠️ 9. SSH URL Is NOT a Command

This:

```text
git@github.com:ankittripathidevs/DevOps_FullCourse.git
```

is an **SSH Repository URL**.

❌ Don't run it directly:

```bash
git@github.com:ankittripathidevs/DevOps_FullCourse.git
```

Use it with Git:

```bash
git clone git@github.com:ankittripathidevs/DevOps_FullCourse.git
```

---

# 🔗 10. Check Existing GitHub Remote

If the repository is already cloned:

```bash
git remote -v
```

Example HTTPS remote:

```text
origin  https://github.com/ankittripathidevs/DevOps_FullCourse.git (fetch)
origin  https://github.com/ankittripathidevs/DevOps_FullCourse.git (push)
```

This means the repository is using **HTTPS**.

---

# 🔀 11. Change HTTPS → SSH

Change the existing GitHub remote:

```bash
git remote set-url origin git@github.com:ankittripathidevs/DevOps_FullCourse.git
```

Verify:

```bash
git remote -v
```

Expected:

```text
origin  git@github.com:ankittripathidevs/DevOps_FullCourse.git (fetch)
origin  git@github.com:ankittripathidevs/DevOps_FullCourse.git (push)
```

Now the repository uses:

```text
SSH
```

instead of:

```text
HTTPS
```

---

# 📤 12. Push Code to GitHub

After making changes:

```bash
git add .
```

Create a commit:

```bash
git commit -m "CI/CD"
```

Push:

```bash
git push
```

Because SSH authentication is configured, GitHub should not ask:

```text
Username for 'https://github.com':
```

---

# 📥 13. Pull Latest Code

To download the latest changes from GitHub:

```bash
git pull
```

---

# 🧠 14. Complete Workflow

```text
                  NEW EC2 INSTANCE
                         │
                         ▼
                  Install Git
                         │
                         ▼
                 Check SSH keys
                         │
                         ▼
                ls -la ~/.ssh
                         │
               ┌─────────┴─────────┐
               │                   │
          Key exists          No key exists
               │                   │
               │             ssh-keygen
               │                   │
               └─────────┬─────────┘
                         ▼
                  Get Public Key
                         │
                         ▼
            cat ~/.ssh/id_ed25519.pub
                         │
                         ▼
               Add Public Key
                  to GitHub
                         │
                         ▼
              ssh -T git@github.com
                         │
                         ▼
                Authentication ✅
                         │
                         ▼
              git clone SSH_URL
                         │
                         ▼
                  Work on Code
                         │
              ┌──────────┴──────────┐
              │                     │
              ▼                     ▼
           git pull              git push
              │                     │
              └──────────┬──────────┘
                         ▼
                       GitHub
```

---

# 📋 15. Quick Command Cheat Sheet

### Check Git

```bash
git --version
```

### Install Git

```bash
sudo apt update
sudo apt install git -y
```

### Check SSH keys

```bash
ls -la ~/.ssh
```

### Create SSH key

```bash
ssh-keygen -t ed25519 -C "ec2-github"
```

### Show public key

```bash
cat ~/.ssh/id_ed25519.pub
```

### Test GitHub SSH

```bash
ssh -T git@github.com
```

### Clone repository

```bash
git clone git@github.com:USERNAME/REPOSITORY.git
```

### Check remote

```bash
git remote -v
```

### Change HTTPS → SSH

```bash
git remote set-url origin git@github.com:USERNAME/REPOSITORY.git
```

### Pull

```bash
git pull
```

### Push

```bash
git push
```

---

# ⚠️ 16. Common Problems

## Problem 1 — `Permission denied (publickey)`

Error:

```text
git@github.com: Permission denied (publickey).
```

Test:

```bash
ssh -T git@github.com
```

If authentication fails:

1. Check SSH key:

```bash
ls -la ~/.ssh
```

2. Get public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

3. Add that public key to GitHub.

4. Test again:

```bash
ssh -T git@github.com
```

---

## Problem 2 — Git asks for GitHub username

Error:

```text
Username for 'https://github.com':
```

Check:

```bash
git remote -v
```

If you see:

```text
https://github.com/...
```

change it to SSH:

```bash
git remote set-url origin git@github.com:USERNAME/REPOSITORY.git
```

---

## Problem 3 — SSH URL typed directly

Wrong:

```bash
git@github.com:USERNAME/REPOSITORY.git
```

Correct:

```bash
git clone git@github.com:USERNAME/REPOSITORY.git
```

---

# 🔐 17. EC2 SSH Key vs GitHub SSH Key

Do not confuse these two.

### AWS EC2 Login

Used to connect **your computer → EC2**.

Example:

```text
my-laptop
    │
    │ .pem key
    ▼
   EC2
```

### GitHub SSH Authentication

Used to connect **EC2 → GitHub**.

```text
EC2
 │
 │ id_ed25519
 ▼
GitHub
```

They are separate authentication setups.

---

# ⭐ 18. New EC2 Checklist

Use this checklist whenever you create a new EC2:

```text
[ ] Connect to EC2

[ ] Check Git
    git --version

[ ] Install Git if required
    sudo apt update
    sudo apt install git -y

[ ] Check SSH key
    ls -la ~/.ssh

[ ] If key doesn't exist, create it
    ssh-keygen -t ed25519 -C "ec2-github"

[ ] Get public key
    cat ~/.ssh/id_ed25519.pub

[ ] Add public key to GitHub
    GitHub → Settings → SSH and GPG keys

[ ] Test connection
    ssh -T git@github.com

[ ] Clone repository
    git clone git@github.com:USERNAME/REPOSITORY.git

[ ] Enter project
    cd REPOSITORY

[ ] Verify
    git status
```

---

# 🎯 Final Concept

Remember these **4 things**:

```text
1️⃣ SSH Key
   ↓
   Allows secure authentication

2️⃣ Public Key
   ↓
   Add to GitHub

3️⃣ ssh -T git@github.com
   ↓
   Test authentication

4️⃣ git clone git@github.com:USER/REPO.git
   ↓
   Clone repository using SSH
```

### Most important commands:

```bash
ls -la ~/.ssh

cat ~/.ssh/id_ed25519.pub

ssh -T git@github.com

git clone git@github.com:USERNAME/REPOSITORY.git
```

> **Remember:** On every new EC2, first check `~/.ssh`. If an SSH key already exists, use it instead of blindly generating another one.
