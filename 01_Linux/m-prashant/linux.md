## Instructor
- M Prashant

### Environment (Online Virtual machine)
- bellrad.org -> JSLinux -> Console(User Interface)
- WSL (windows subsystem linux)

##### Install WSL In Windows
- Open PowserShell Run as Administrator
- wsl --install


### Commands
#### (1) Check your current location
- pwd :- /home/userAnkit 


#### (2) Display name of current logged-in user
- whoami :- root@Ankit-Pc:/home/userAnkit# 

#### root@Ankit-Pc:/home/userAnkit# 
- root :- username
- @Ankit-Pc:- hostname
- /home/userAnkit:- folder


#### (3) Check system date or time
- date :- Thu Mar  5 10:19:11 UTC 2026  
- date +%D :-  03/05/26 
- date +%T :- 15:22:08
- date +%H:%M :- 15:58 


#### (4) Display files & directory present in current location
1️⃣ Lists files and directories in the current folder
- ls 

2️⃣ Shows all files including hidden files (files starting with .)
- ls -a 

3️⃣ Lists files sorted by modification time (latest first)
- ls -lt

4️⃣ Lists files in long format with human-readable sizes.
- ls -lh
- ls -lah


#### (5) Clear linux terminal
- clear


### Creating, Editing, Deleting file.
#### (6) Display Content of a file on terminal
- cat <fileName.txt>

#### (7) Display Content of a file with line numbers
- cat -n <fileName.txt>


#### (8) How to read for a file & Search for a word
- less <fileName.txt>
- /DevOps :- search word (from top to bottom)
- :n :- next
- Shift + G :- move to bottom
- p :- move to top

- ?Devops :- search word (from bottom to top)


#### (9) View content of a file page by page
- more <fileName.txt>  (press down key)


#### (10) Create File in Linux
1️⃣ Create an Empty New File
- touch <fileName.txt>
- touch .<fileName.txt>

where  
. For hidden file

2️⃣ Create & Edit File
- nano <fileName.txt>
```
Steps:
Press CTRL + O → Save.
Press Enter.
Press CTRL + X → Exit.
```

3️⃣ Create & Edit File
- vim <fileName.txt>
```
Steps:
Press:- i (insert)
Press:- ESC
Press:- : wq
Press:- Enter
```

4️⃣ Create New File With Content or Replace Existing File 
- echo "Hello World" > <demo.txt>

5️⃣ Add more Content to the existing file
- echo "add this hello dosto" >> <demo.txt>
press Ctrl + D to save

6️⃣ Create & Display File With Content 
- echo "hello" | tee  <demo.txt> 


#### (11) Edit Existing File 
1️⃣ nano <fileName.txt>
2️⃣ vim <fileName.txt>


#### (12) delete a file in Linux
1️⃣ remove single file
- rm <fileName.txt>

2️⃣ remove hidden file
- rm .<fileName.txt>

3️⃣ remove multiple file
- rm <file1.txt> <file2.txt>


#### (13) create a directory/folder in Linux
1️⃣ create single dir/folder
- mkdir <dir_name>

2️⃣ create hidden dir/folder
- mkdir .<dir_name>

3️⃣ create multiple dir/folder
- mkdir <dir1_name> <dir2_name>


#### (14) delete a directory/folder in Linux
1️⃣ rm -rf  <dir_name>

where 
- -r(flag r): recursivily
- -f: force 

2️⃣ rm -rv <dir_name>

where
- v (verbose) :– show what is being deleted

3️⃣ rmdir  <dir_name>
- delete only empty folder

4️⃣ rmdir <dir1_name> <dir2_name>
- delete multiple folder at a time


#### (15) change path or move to another folder in Linux
1️⃣ Change directory
- cd /path/

2️⃣ Change/move multiple folder at a time
- cd /userAnkit/devops/cloud: 

3️⃣ Move One Step Back
- cd ..

4️⃣ Move multiple Step Back
- cd ../..


#### (16) Absolute Path vs Relative Path
1️⃣ Absolute Path
- complete path from the root directory / to the file or folder.
- It always starts with /
- It does not depend on your current 
```
cd /home/userAnkit/devops/Documents
```
This command will go to Documents no matter where you currently are.


2️⃣ Relative Path: 
- The path relative to your current working directory.
- It does NOT start with /
- It depends on where you currently are

Example: /home/userAnkit/devops/Documents
- If your current directory is:
 /home/userAnkit/devops/

- Then you can go to Documents like this:
  cd Documents


#### Special Relative Symbols
| Symbol | Meaning           |
| ------ | ----------------- |
| `.`    | Current directory |
| `..`   | Parent directory  |
| `~`    | Home directory    |


#### (17) Copy & Paste a file from one folder to another in Linux.
1️⃣  cp <file.txt> /dest/path

2️⃣ cp <demo.txt> devops/docker/
- copy demo.txt file Inside docker folder

3️⃣ cp <demo.txt> devops
- copy demo.txt file in current devops folder 

4️⃣ cp ../<demo.txt> .
- copy demo.txt file from parent directory to present/current directory

5️⃣ cp <note1.txt> <note2.txt> devops 
- copy multiple file in devops folder


#### (18) Copy folder from one folder to another in Linux.
1️⃣ cp -r folderA /dest/path

| Part         | Meaning                                                      |
| ------------ | ------------------------------------------------------------ |
| `cp`         | Copy files or directories                                    |
| `-r`         | **Recursive** – copy the folder and everything inside it     |
| `folderA`    | The **source folder** you want to copy                       |
| `/dest/path` | The **destination location** where the folder will be copied |


2️⃣ cp -r devops/docker/ankit.txt  ..

| Part                      | Meaning                                         |
| ------------------------- | ----------------------------------------------- |
| `cp`                      | Copy command                                    |
| `-r`                      | Recursive option (usually used for directories) |
| `devops/docker/ankit.txt` | Source file path                                |
| `..`                      | Parent directory (one level up)                 |

3️⃣ cp -r folder1 folder2 userAnkit/devops
- copy multiple dir in devops folder


#### (19) Copy content of a file to another (duplicate file) in Linux.
- cp <demo.txt> <demo_copy.txt>
- cp <demo.txt> <demo1.txt>


#### (20) Copy duplicate folder
- cp -r cloud cloud_copy
- cp -r devops ../devops_copy


#### (21) Cut-paste a file/folder from one folder to another in Linux
- mv <file_name> /dest/path/

1️⃣ mv <demo.txt> cloud
- move demo.txt in cloud folder

2️⃣ mv <demo.txt> devops/docker
- move demo.txt file in docker folder

3️⃣ mv cloud/  devops/docker
- move cloud folder in docker folder

4️⃣ mv <demo1.txt> <demo2.txt> cloud
- move multiple file (demo1.txt & demo2.txt) in cloud folder


#### (22) rename file/folder in Linux
- mv demo.txt notes.txt
- mv cloud/ devops


#### (23) read or display top 5 lines from a file in Linux.
- head -5 <file_name>
- head -10 <file_name>


#### (24) read or display bottom 5 lines from a file in Linux.
- tail -5 <file_name>


#### (25) SORT the content from a file in Linux
- sort <file_name>
- sort -r <file_name>
Where -r:- reverse order shorting


#### (26) display UNIQUE content from a file in Linux
- sort <file_name> | uniq
- remove duplicate lines from a file


#### (27) A file has 9 lines. How to split this file in 3 different files in Linux
- split -l 3 <file_name>


#### (28) How to search a word and display matching content from a file in Linux.
1️⃣ Basic:- It prints the lines that match a specific word or pattern
- grep "hello" <file.txt>

2️⃣ Search in Multiple Files
- grep "hello" <file1.txt> <file2.txt>

3️⃣ Case-Insensitive Search (-i)
- grep -i "hello" <file.txt>

4️⃣ Show Line Numbers (-n)
- grep -n "hello" <file.txt>

5️⃣ list all the txt Extension
- ls | grep txt

Where
- grep:- Global Regular Expression Print


#### (29) How to search multiple words and display matching content from a file in Linux
- egrep "hello|namaste" <file.txt>

where 
- egrep:- Extended Global Regular Expression Print


#### (30) How to use WILDCARDS in Linux? * [] {}
1️⃣ ls demo*
- list all file with name demo

2️⃣ ls *.txt
- list all file with .txt entension

3️⃣ touch demo{A..D}.txt
- create multiple file at a time with name demoA.txt demoB.txt, demoC.txt, demoD.txt.

4️⃣ mkdir test{1..5}
- create a multiple folder at a time with name test1, test2, test3, test4, test5.


#### (31) SHUFFLE Content of file in Linux
- Shuf <filename.txt>


#### (32) Count number of line in a file in Linux
- wc  <filename.txt>
- wc -l <filename.txt>

where
wc --> word count
Output:- 1 4 26 <file.txt>
     1:- line
     4:- words
     26:- bits
 

#### (33) Check if two file are identical or not in Linux
- cmp <fileA.txt> <fileB.txt> 


#### (34) Compare and display difference between two files in Linux
- diff <fileA.txt>  <fileB.txt> 
- diff -u <fileA.txt>  <fileB.txt>


#### (35) Find a file in Linux
- find /path/ -name <fileName.txt>
- find ./ -name <fileName.txt>


#### (36) Find a file in Linux
- updatedb
- locate <fileName.txt>


#### (37) Display previously used commands in past
- history
- history | grep sort 
 
where
- sort:- any command


#### (38) Check syntax and options available for a command
- help
- ls --help | more


#### (39) How to read or get more info about a command
- man ls


#### (40) Use Calculator in Linux
- bc 
- ctrl+Z : To stopped


#### (41) Check Calendar of last year in Linux
- cal
- cal 2025
- cal JAN 2022


#### (42) Check How Long Server has been running in Linux
- uptime


#### (43) Record your activity on terminal in a file
- script
Where :- ctrl+D to exit after running some command


#### (44) Create a short-cut of a long command in Linux
- alias l="ls -ltr"
- alias -p 
Where:- After logout whis shorcut will vanish(disseapear)


### Zip & UnZip of files & Folders

#### (45) Compress a file in Linux
##### (1) Compress a Single file
1️⃣ gzip <file.txt>
where
- Creates file.txt.gz and deletes <file.txt>

2️⃣ gzip -k <file.txt>
where
- Creates file.txt.gz and keeps file.txt
- k:- keep the original file


##### (2) Compress multiple file
1️⃣ gzip <file1.txt> <file2.txt>


#### (46) Decompress a file in Linux
1️⃣ gzip -d <file_name>
where:
- d = decompress (It converts the .gz file back to the original file)
 
2️⃣ gunzip <file_name> 


#### (47) Compress a folder in Linux
1️⃣ Compress a Folder (Most Common)
- tar -czvf my-archive.tar.gz <folder_name>

| Option | Meaning                               |
| ------ | ------------------------------------- |
| `-c`   | Create archive                        |
| `-z`   | Compress using gzip                   |
| `-v`   | Verbose (show files being compressed) |
| `-f`   | File name of archive                  |


2️⃣ Compress Multiple Folders / Files
- tar -czvf mybackup.tar.gz <folder1> <folder2> <file1.txt>


#### (48) Decompose /Extract a Folder in Linux
- tar -xzvf archive-name.tar.gz

| Option | Meaning      |
| ------ | ------------ |
| `-x`   | Extract      |
| `-z`   | Use gzip     |
| `-v`   | Show files   |
| `-f`   | Archive file |


#### (49) Compress/ decompress multiple files in one Zipped file in Linux
1️⃣ Compress
- zip myfiles.zip <file1.txt> <file2.txt>

2️⃣ decompress
- unzip myfilez.zip


#### (50) List files in Zipped file
- unzip -l myfiles.zip


#### (51) Download a file from Internet
1️⃣ Using wget
- wget <URL_of_File>

Example
- wget "https://example.com/file.zip"

Where 
- wget:- World Wide Web Get

2️⃣ Download and Save with Custom Name
- wget -O custom_filename.txt <URL_of_File>

Where
-O → specify output fileName

Example
- wget -O mahi.jpg "<copy_image_address>"


| Command            | Purpose               |
| ------------------ | --------------------- |
| `wget URL`         | Download file         |
| `wget -O name URL` | Save with custom name |



#### (52) View Images in Ubantu
- eog <image_name>
- xdg-open <image_name>

Exapmle
- eog mahi.jpg

Where 
- eog:- Eye of GNOME
- xdg-open:- X Desktop Group Open

#### (53) Open Video in Ubnatu
- vlc <video.mp4>
- mpv <video.mp4>
- xdg-open <video.mp4>


#### (54) Call an API on Linux
- curl 'http://numbersapi.com/random'
- curl 'https://dummyjson.com/quotes'
- curl -o customName "<copy_image_address>"


| Tool | Option         | Meaning                  | Example                |
| ---- | -------------- | ------------------------ | ---------------------- |
| wget | `-O` (Big O)   | Custom filename          | `wget -O file.jpg URL` |
| curl | `-o` (small o) | Custom filename          | `curl -o file.jpg URL` |
| curl | `-O` (Big O)   | Remote/original filename | `curl -O URL`          |



#### (55) Install an Application on Linux?
1️⃣ Debian / Ubuntu Based Systems :- Use (apt)
- sudo apt update
- sudo apt install <package_name>

Exmaple
- sudo apt install git


##### Remember Before installing packages on Ubuntu always Run
```
sudo apt update
```

#### (56) Check if an application is installed or not on Linux

👉 Show all installed packages and display only the packages related to Git.
- apt list --installed | grep appName


1️⃣ Ubuntu / Debian
- dpkg -l | grep appName

Example 
- dpkg -l | grep git

Where 
- dpkg --> Debian Package

1️⃣ Alternative Command (Ubuntu)
- apt list --installed | grep appName

| Part       | Meaning                                     |
| ---------- | ------------------------------------------- |
| `dpkg`     | Package manager used in **Ubuntu / Debian** |
| `-l`       | List installed packages                     |
| `|`        | Pipe → send output to next command          | 
| `grep git` | Show only lines containing **git**          |


| Task                        | Ubuntu / Debian        |
| --------------------------- | ---------------------- |
| List all installed packages | `dpkg -l`              |
| Search installed package    | `dpkg -l \| grep git`  |
| Install package             | `sudo apt install git` |
| Remove package              | `sudo apt remove git`  |
| Update packages             | `sudo apt update`      |


| OS Family                | Package Manager     |
| ------------------------ | ------------------- |
| Ubuntu / Debian          | `apt`, `dpkg`       |
| RedHat / CentOS / Fedora | `yum`, `dnf`, `rpm` |

3️⃣ List installed packages
- dpkg -l
- apt list --installed



#### (57) List available packages to Install On Linux
- apt search <package_name>


#### (58) Start/Stop a service on Linux
1️⃣ Install a Service
- sudo apt install <service_name>
Example
- sudo apt install nginx

2️⃣ Start a Service
- systemctl start <service_name>
Example:
- systemctl start nginx

3️⃣ Stop a Service
- systemctl stop <service_name>
Example:
- systemctl stop nginx

4️⃣ Check status
- systemctl status service_name
Example:
- systemctl status nginx


##### ⚡ Nginx Service Commands Summary
| Command                        | Purpose                             |
| ------------------------------ | ----------------------------------- |
| `sudo apt install nginx`       | Install Nginx                       |
| `sudo systemctl start nginx`   | Start Nginx service                 |
| `sudo systemctl stop nginx`    | Stop Nginx service                  |
| `sudo systemctl restart nginx` | Restart Nginx service               |
| `sudo systemctl status nginx`  | Check Nginx service status          |
| `sudo systemctl enable nginx`  | Start Nginx automatically at boot   |
| `sudo systemctl disable nginx` | Disable Nginx from starting at boot |
| `systemctl`                    | Control and manage system services  |


#### (59) List all services on Linux
- systemctl list-units --type=service --all
- systemctl list-units --type=service --state=running


#### (60) List all the existing Environment Variables on Linux.
- printenv


#### (61) Java installation directory or JVM directory in Linux/Ubuntu.
- It stores all installed Java versions (JDK/JRE).

📂 What /usr/lib/jvm Means
- /usr → user system programs
- /usr/lib → libraries and system packages
- /usr/lib/jvm → Java Virtual Machine installations
This directory contains all Java versions installed on the system.


#### (62) Add a new Environment Variables on Linux
- export JAVA_HOME="/usr/lib/jvm/java_v"
- export PATH=$JAVA_HOME/bin:$PATH


cd /usr/lib/jvm


#### (63) Print a specific column from a CSV file
1️⃣ Print specific column
- awk -F ',' '{print $2}' file.csv
- Prints 2nd column

2️⃣ Print multiple columns
- awk -F ',' '{print $2, $4}' test.csv
- print 2nd & 4th column

3️⃣ Skip header
- awk -F ',' 'NR>1 {print $2}' test.csv
- NR = line number

4️⃣ Filter data (condition)
- awk -F ',' '$5=="Developer" {print $2}' test.csv


##### 💡 Important Terms
| Term     | Meaning          |
| -------- | ---------------- |
| `$1, $2` | Columns          |
| `NR`     | Line number      |
| `-F`     | Delimiter        |


#### (64) Display Starting two characters of all line
1️⃣ cut -c1-2 file.txt
where
- first 2 characters of each line

2️⃣ cut -c2-3 file.txt
- 2nd & 3rd characters of each line


#### (65) Display a specific line from a file
- sed -n '5p' file.txt

| Part       | Meaning                                                 |
| ---------- | ------------------------------------------------------- |
| `sed`      | Stream editor (used to process text line by line)       |
| `-n`       | Suppresses default output (prevents printing all lines) |
| `'5p'`     | Print (`p`) only the **5th line**                       |
| `dost.txt` | Input file from which data is read                      |


#### (66) Replace a specific word within a file
1️⃣ Basic (replace first match per line)
- sed 's/old_word/new_word/' file.txt

2️⃣ Replace all occurrences (global)
- sed 's/old_word/new_word/g' file.txt
where 
g -global

3️⃣  Replace directly in the file (permanent change)
- sed -i 's/old_word/new_word/g' file.txt

4️⃣ Case-insensitive replace
- sed -i 's/old_word/new_word/gi' file.txt

5️⃣ Create a backup before replacing (recommended)
- sed -i.bak 's/old_word/new_word/g' file.txt


#### (67) Convert the content to UpperCase or LowerCase within a file
1️⃣ Convert to UPPERCASE
- tr '[:lower:]' '[:upper:]' <  file.txt

###### Save changes back to file
- tr '[:lower:]' '[:upper:]' <  file.txt > newfile.txt
- tr never modify original file directly.


2️⃣ Convert to lowercase
- tr '[:upper:]' '[:lower:]' <  file.txt


3️⃣ Remove characters & Save output to a new file
- tr -d '@' < file.txt  > newfile.txt
- deletes the exact character @ from file

4️⃣ Remove mutliple characters
- tr -d '@123%' <  file.txt  > newfile.txt 


5️⃣ Replace character from file
- tr '%' '&' < file.txt  > newfile.txt
- replce % with & in the file

#### (68) Extend or Shrink size of a file
- truncate -s 20M <file.txt>

where 
- -s → sets the size of the file
- 20M → size = 20 Megabytes

This command will:
- Extend the file if it is smaller than 20MB
- Shrink (cut) the file if it is larger than 20MB


🔥 Quick Summary
| Command                | Result           |
| ---------------------- | ---------------- |
| `truncate -s 20M file` | Set size to 20MB |
| `truncate -s +5M file` | Increase size    |
| `truncate -s -2M file` | Decrease size    |
| `truncate -s 0 file`   | Empty file       |


#### (69) Display following line in Vertical Line? ABCDE
- echo "ABCDE" | fold -w1


#### (70) Change User or login as different User in Linux
- su <user_name>


#### (71) Exit as current user or close terminal in Linux
- exit


#### (72) If you are not root user, how to execute admin commands like installing new apps?
- sudo apt install <app_name>

## Access, Remote, Servers

#### (73) Acess Remote Linux Server
- ssh user@hostname


#### (74) Copy a file yo a remote Linux server
- scp file user@hotname:/tmp/


### Working With Permissions

##### (75) Check Permission of a file
- ls -ltr 
where
rwx
rw-
r--

 7️⃣ 8️⃣


✅ Short Interview Answer
1️⃣ Difference between apt and yum?
- apt → used in Debian-based systems
- yum/dnf → used in RedHat-based systems
