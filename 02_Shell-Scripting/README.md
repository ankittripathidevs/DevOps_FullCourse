# Shell Scripting --- Quick Revision

## 1. Bash Script Basics

``` bash
#!/bin/bash
set -e
```

-   `#!/bin/bash` → runs script with Bash.
-   `set -e` → stops script when a command fails.

Run:

``` bash
chmod +x script.sh
./script.sh
```

------------------------------------------------------------------------

## 2. Arguments

``` bash
$0   # script name
$1   # first argument
$2   # second argument
$#   # number of arguments
```

Check exactly 2 arguments:

``` bash
if [ $# -ne 2 ]; then
    echo "Usage: $0 <source> <backup>"
    exit 1
fi
```

-   `-ne` → not equal.

------------------------------------------------------------------------

## 3. Variables

``` bash
SOURCE_DIR="$1"
BACKUP_DIR="$2"
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
```

Use quotes around variables, especially paths.

IST timestamp:

``` bash
TIMESTAMP=$(TZ=Asia/Kolkata date "+%Y-%m-%d_%H-%M-%S")
```

------------------------------------------------------------------------

## 4. Functions

``` bash
create_backup() {
    echo "Creating backup..."
}

create_backup
```

Functions help organize reusable logic.

------------------------------------------------------------------------

## 5. Conditions

``` bash
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Directory does not exist"
    exit 1
fi
```

Common tests:

``` text
-d   directory exists
-f   file exists
-e   file/directory exists
-ne  numbers are not equal
-eq  numbers are equal
```

------------------------------------------------------------------------

## 6. Check Commands

``` bash
if ! command -v zip >/dev/null 2>&1; then
    echo "zip is not installed"
    exit 1
fi
```

-   `command -v zip` → checks whether `zip` is available.
-   `!` → NOT.
-   `>/dev/null` → hide normal output.
-   `2>&1` → hide error output.

Install:

``` bash
sudo apt install zip -y
```

------------------------------------------------------------------------

## 7. Backup with ZIP

``` bash
mkdir -p "$BACKUP_DIR"

BACKUP_FILE="${BACKUP_DIR}/backup-completed_${TIMESTAMP}.zip"

zip -rq "$BACKUP_FILE" "$SOURCE_DIR"
```

-   `mkdir -p` → creates directory if it doesn't exist.
-   `zip -r` → recursively includes directories.
-   `-q` → quiet output.

------------------------------------------------------------------------

## 8. Backup Rotation --- Latest 5

``` bash
MAX_BACKUPS=5

ls -1t "$BACKUP_DIR"/backup-completed_*.zip |
    tail -n +$((MAX_BACKUPS + 1)) |
    xargs -r rm --
```

Meaning:

``` text
ls -1t       → newest backups first
tail -n +6   → select backup #6 onward
xargs rm     → delete them
```

Result:

``` text
Latest 5     → KEEP
Older files  → DELETE
```

`$((...))` → Bash arithmetic.

------------------------------------------------------------------------

## 9. Pipes

``` bash
command1 | command2
```

`|` sends the output of one command to another.

Example:

``` bash
ls -1t backups/*.zip | tail -n +6
```

------------------------------------------------------------------------

## 10. Useful Commands

``` bash
pwd                 # current directory
ls                  # list files
ls -lt              # list by modification time
cd directory        # change directory
mkdir -p backups    # create directory
cat file.sh         # display file
chmod +x file.sh    # make executable
```

------------------------------------------------------------------------

## 11. Cron Jobs

Open your user's cron:

``` bash
crontab -e
```

Check:

``` bash
crontab -l
```

### Every minute

``` cron
* * * * * /path/to/script.sh
```

### Every 2 minutes

``` cron
*/2 * * * * /path/to/script.sh
```

### Every 10 minutes

``` cron
*/10 * * * * /path/to/script.sh
```

### Once every day at 11 PM

``` cron
0 23 * * * /path/to/script.sh
```

Cron format:

``` text
minute hour day month weekday
```

Important: cron is calendar-based. `0 23 * * *` means every day at 11
PM, not exactly 24 hours after the previous run.

------------------------------------------------------------------------

## 12. Backup Script Flow

``` text
Arguments
   ↓
Validate arguments
   ↓
Validate source
   ↓
Check required command
   ↓
Create backup directory
   ↓
Create ZIP backup
   ↓
Rotate backups
   ↓
Keep latest 5
```

## Quick Rules to Remember

``` text
$1, $2       → script arguments
$#           → number of arguments
$0           → script name
$(( ))       → arithmetic
$(command)   → command substitution
"$VAR"       → safely use variable
|            → pipe
!            → NOT
mkdir -p     → create directory if needed
chmod +x     → make script executable
crontab -e   → edit cron jobs
crontab -l   → list cron jobs
```

