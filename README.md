# Reverse Polish Notation (RPN) Calculator (Ada)

Ada interactive reverse polish notation (RPN) calculator that uses signed bignums and stacks to perform addition, subtraction, and multiplication on large numbers (up to 50 digits).

# Available operation commands:
- Addition (+)
- Subtraction (-)
- Multiplication (*)
- Print (p), prints top of the stack.
- Pop (P), pops stack without output.
- Quit (q), ends program.

Sample input that would be processed:
- 2 6 * p
- P 4 4 + p

**Note** Negative numbers must be entered with an underscore: _1 for example.

# Instructions for use from command line
- gnatmake rpn_calc.adb
- rpn_calc
- OR rpn_calc < filename (to use input from appropriate text file).

# Input/Output
By supplying the respective input, the program will output the following:
```
2 6 * p
12
P 4 4 + p
8
q
*Program exits
```

**Ada compiler can be found here**
[GNAT Community Edition](https://www.adacore.com/download)
