markdown
# mygrep.sh - Mini Grep Tool

## ✅ Task Requirements Met
- Case-insensitive search (`hello` matches "HELLO")
- `-n` shows line numbers
- `-v` inverts matches
- Handles `-vn`/`-nv` combinations
- Validates input (missing file/arguments)

## 🛠️ Usage
```bash
./mygrep.sh [options] search_term filename
Options:
Short	Long	Description
-n	--numbers	Show line numbers
-v	--invert	Invert match results
🧪 Test Proof
1. Basic Search
bash
./mygrep.sh hello testfile.txt
Hello world
HELLO AGAIN
2. With Line Numbers
bash
./mygrep.sh -n hello testfile.txt
1: Hello world
4: HELLO AGAIN
3. Inverted Match
bash
./mygrep.sh -vn hello testfile.txt
2: This is a test
3: another test line
5: Don't match this line
6: Testing one two three
4. Error Handling
bash
./mygrep.sh -v testfile.txt
Error: Missing search string
Usage: ./mygrep.sh [options] search_string filename
🔧 Implementation Notes
Uses getopts for option parsing (-n, -v, -vn)

Case-insensitive by default

Error messages show usage help

📂 Files
project/
├── mygrep.sh        # Main script
├── testfile.txt     # Test data
└── README.md        # This file
Screenshots
See /screenshots folder for test proofs:

basic_search.png

line_numbers.png

inverted_match.png

error_handling.png




