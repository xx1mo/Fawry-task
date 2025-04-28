markdown
# mygrep.sh - Grep Clone

##  Task Completion Proof

###  Basic Functionality
- Case-insensitive search → Works (`hello` matches "HELLO")
- Prints matching lines → See Test 1 output below

###  Command Options
| Option | Tested? | Example Command               |
|--------|---------|--------------------------------|
| `-n`   |  Yes   | `./mygrep.sh -n hello testfile.txt` |
| `-v`   |  Yes   | `./mygrep.sh -v hello testfile.txt` |
| `-vn`  |  Yes   | `./mygrep.sh -vn hello testfile.txt` |

### Test Proof
```bash
# Test 1: Basic search
./mygrep.sh hello testfile.txt
# Output:
Hello world
HELLO AGAIN

# Test 2: Line numbers
./mygrep.sh -n hello testfile.txt
# Output:
1: Hello world
4: HELLO AGAIN

# Test 3: Inverted match
./mygrep.sh -vn hello testfile.txt
# Output:
2: This is a test
3: another test line
5: Don't match this line
6: Testing one two three

# Test 4: Error handling
./mygrep.sh -v testfile.txt
# Output:
Error: Missing search string
Usage: ./mygrep.sh [options] search_string filename
 How It Works
Option Handling:

Uses getopts for -n/-v

-vn works because getopts splits it automatically

Hardest Part:

Error messages needed 5 rewrites to be clear but simple

Future Improvements:

-bash
# Could add:
grep -E # for regex
grep -c # for counts
 Bonus Done
--help flag added

Uses getopts properly

- Files
mygrep.sh     # Script
testfile.txt  # Test data
screenshots/  # Proof imags

