#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern char* yytext;
extern FILE* yyin;

/**
 * scans the input file for uppercase tokens prefixed by "_PR_"
 * prints found tokens to output file and stdout prints
 *
 * output file will use the same name as the input file: <somefile>.y ---> <somefile>_pr.h
 *
 * @param  argc		number of command line arguments
 * @param  argv		array of command line arguments
 * @return      	program return code
 */
int main(int argc, char *argv[]) {

	if (argc == 1) {

   	  printf("no file provided\n");

   	} else {

    	while (--argc > 0) {
			++argv;

    		if ((yyin = fopen(*argv, "r")) == NULL) {
            	printf("can't open %s\n", *argv);
				continue;
            }

			yytext = NULL;

			/* create output filename */
			char buf[255];
			strncpy(buf, *argv, 250);
			char *b = buf + strlen(buf) - 2;
			strcpy(b, "_pr.h");
			printf("opfile name: %s\n", buf);

			/* open output file */
			FILE *opfile = NULL;
			if ((opfile = fopen(buf, "wx")) == NULL) {
				printf("file %s already exists.\n", buf);
				exit(1);
			}

			/* construct an enum in the output file */
			fprintf(opfile, "typedef enum {\n");

        	while (yylex() == 42) {
				printf("%s\n", yytext);
				fprintf(opfile, "\t%s,\n", yytext);
			}

			fprintf(opfile, "} prodrule;\n");

			/* close files */
			fclose(opfile);
			fclose(yyin);

    	}

	}

    return 0;
}
