# yacc_prodrule_hack

This C program uses Flex to scan your Bison/YACC file for production rule identifiers beginning with `_PR_`.

An `enum` is created in a header file with the name `<inputfilename>_pr.h`.

Every production rule identifier prefixed with `_PR_` will appear in the `enum`.

The program will not overwrite any existing files, so you'll have to delete your `_pr.h` file to generate a new one.

Input file must have the extension `.y`.

You can input as many `.y` files as you want in the command line arguments. The program will generate a separate header file for each.

## How to Use

Clone the repository and run `make` in the root directory of the project.
(You must have Flex installed...see the `makefile` for more information.)

If the tool compiles successfully, there will be an executable named `pr_hack`.

Run `./pr_hack <inputfile>.y` (you must rename your product rules with prefix `_PR_`, or the `enum` will be barren).

## Bugs

No known bugs (yet)

Please inform me if you find any.
