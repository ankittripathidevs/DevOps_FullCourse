============================================
## Day-6: Role-Based Access Control (RBAC)
============================================

### Topic: Role-Based Authorization Strategy

RBAC allows Jenkins administrators to control what different users can access and perform.

---

### Step 1 — Create a New User

Login with Jenkins Admin.

Go to:

```text
Manage Jenkins
    ↓
Users
    ↓
Create User
```

Example:

```text
Username: dhoni
Password: ********
Name: Dhoni
Email: dhoni@yopmail.com
```

Click **Create User**.

---


## Step 2 — Test the Newly Created User
Logout from Jenkins.

Login with:

Username: dhoni
Password: ********

You may see:

dhoni is having all Overall/Read permission.

Reason
The user has been created, but no role has been assigned to the user yet.

---


### Step 3 — Install Role-Based Authorization Strategy Plugin

Go to:

```text
Manage Jenkins
    ↓
Plugins
    ↓
Available plugins
```

Search:

```text
Role-Based Authorization Strategy
```

Install the plugin.

---


### Step 4 — Enable Role-Based Strategy

Go to:

```text
Manage Jenkins
    ↓
Security
    ↓
Authorization
```

Select:

```text
Role-Based Strategy
```

Click:

```text
Save
```

---

### Step 5 — Test Again the Newly Created User

Logout from Jenkins.

Login with:

```text
Username: dhoni
Password: ********
```

You may see:

```text
Access Denied

dhoni is missing the Overall/Read permission.
```

### Reason

The user has been created, but no role has been assigned to the user yet.

---

### Step 6 — Login Back with Admin

Logout from `dhoni`.

Login with:

```text
Username: admin
```

Go to:

```text
Manage Jenkins
    ↓
Role Management
```

---

### Step 7 — Manage Roles

Go to:

```text
Manage Jenkins
    ↓
Role Management
    ↓
Manage Roles
```

Click:

```text
Add Role
```

Example role names:

```text
Trainee
Developer
Intern
Read-Only
```

For this example:

```text
Role Name: Trainee
```

---

### Step 8 — Give Permissions

Select permissions according to the requirement.

Example:

```text
Overall:
    ☑ Read

Job:
    ☑ Read
    ☑ Build

View:
    ☑ Read
```

Do not give unnecessary permissions.

Example:

```text
Overall/Administer    ❌
Job/Delete            ❌
Job/Configure         ❌
```

---

### Step 9 — Assign Role to User

Go to:

```text
Manage Jenkins
    ↓
Role Management
    ↓
Assign Roles
```

Select:

```text
Global roles
```

Click:

```text
Add User or Group
```

Enter:

```text
User ID: dhoni
```

Assign:

```text
dhoni → Trainee
```

Click:

```text
Save
```

---

### Step 10 — Test User Permissions

Logout from Admin.

Login with:

```text
Username: dhoni
Password: ********
```

Now `dhoni` will have the custom permissions defined in the `Trainee` role.

Example:

```text
Login Jenkins       ✓
Read Jenkins        ✓
Read Job            ✓
Build Job           ✓

Manage Jenkins      ✗
Delete Job           ✗
Configure Job        ✗
Administer Jenkins  ✗
```

---

### RBAC Concept

```text
User
  ↓
Role
  ↓
Permissions
```

Example:

```text
dhoni
  ↓
Trainee
  ↓
Overall/Read
Job/Read
Job/Build
View/Read
```

---

### Day-6 Learning Flow

```text
Create User
    ↓
Install Role-Based Authorization Strategy
    ↓
Enable Role-Based Strategy
    ↓
Create Role
    ↓
Give Permissions
    ↓
Assign Role to User
    ↓
Login with User
    ↓
User gets Custom Permissions
```

---

### Important

Creating a user does **not** automatically give the user Jenkins permissions.

Permissions are controlled through roles.

---
