# yacc_prodrule_hack

This C program uses Flex to scan your Bison/YACC file for production rule identifiers beginning with `_PR_`.

An `enum` is created in a header file with the name `<inputfilename>_pr.h`.

Every production rule identifier prefixed with `_PR_` will appear in the `enum`.

The program will not overwrite any existing files (by design), so you'll have to delete your old `_pr.h` file to generate a new one.

Input file must have the extension `.y`.

You can input as many `.y` files as you want in the command line arguments. The program will generate a separate header file for each.

## How to Use

1. Clone the repository:
	`git clone https://github.com/Noah-Schoonover/yacc_prodrule_hack.git`

2. Run `make` in the root directory of the project.
(You must have Flex installed...see the `makefile` for more information.)

If the tool compiles successfully, there will be an executable named `pr_hack`.

3. Run `./pr_hack <inputfile>.y` (you must rename your product rules with prefix `_PR_`, or the `enum` will be barren).

![demo gif](https://github.com/Noah-Schoonover/yacc_prodrule_hack/blob/main/demo/demo.gif)

- You could also copy the `pr_hack` executable to another directory for ease of use, and
- call the tool from your makefile and include the `_pr.h` file in your project.

## Bugs

No known bugs (yet)

Please inform me if you find any.

The lex is meant to ignore everything inside of comments, but I haven't done extensive testing on that yet.
