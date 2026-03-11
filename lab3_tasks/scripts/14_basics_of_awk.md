======================================
         AWK BASICS SUMMARY
======================================

1. What is awk?
   - A text processing tool for scanning and processing patterns in text.
   - Reads input line by line, splits lines into fields, and performs actions.

2. Basic syntax:
   awk 'pattern { action }' filename
   - pattern: condition to match lines (optional).
   - action: commands to execute on matched lines (optional).

3. Fields and Records:
   - Each line = record.
   - Fields separated by whitespace by default.
   - Access fields by $1, $2, ..., $0 for the whole line.

4. Printing fields:
   Example file "data.txt":
     Alice 25 Developer
     Bob 30 Designer
     Charlie 28 Manager

   Print first field (names):
     awk '{ print $1 }' data.txt

   Print first and third fields:
     awk '{ print $1, $3 }' data.txt

5. Pattern matching:
   Print lines where second field > 28:
     awk '$2 > 28 { print $0 }' data.txt

6. Using field separators:
   For comma separated values:
     Alice,25,Developer
     Bob,30,Designer
     Charlie,28,Manager

   Specify separator as comma:
     awk -F, '{ print $1, $3 }' data.txt

--------------------------------------
Summary Table:

| Concept         | Example               | Description                |
|-----------------|-----------------------|----------------------------|
| Print full line | { print $0 }           | Print entire line           |
| Print fields    | { print $1, $3 }       | Print specific fields       |
| Pattern match   | $2 > 28 { print $0 }   | Print lines with condition  |
| Field separator | awk -F, ...            | Set field delimiter         |

======================================
