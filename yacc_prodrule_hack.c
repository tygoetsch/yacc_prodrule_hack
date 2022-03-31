#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

extern int yylex();
extern char* yytext;
extern FILE* yyin;
extern int yylex_destroy(void);
char* string_to_upper(char* src);

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

            yyin = fopen(*argv, "r");

    		if (yyin == NULL) {
            	printf("can't open %s\n", *argv);
                fclose(yyin);
				exit(1);
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
                fclose(yyin);
				exit(1);
			}

			/* construct an enum in the output file */
			fprintf(opfile, "typedef enum {\n");
            char* prod_rule = NULL;

            int h = 0;
        	while (yylex() == 42) {
                int i = 0;
                prod_rule = string_to_upper(yytext);

                fprintf(opfile, "\t");

                while (prod_rule[i] != ':') {
                    printf("%c", prod_rule[i]);
                    fprintf(opfile, "%c", prod_rule[i]);
                    i++;
                }
                if (h == 0) { 
                    fprintf(opfile, " = 1000"); 
                    h++;
                }
                printf("\n");
                fprintf(opfile, ",\n");
                free(prod_rule);
			}

			fprintf(opfile, "} prodrule;\n");

			/* close files */
			fclose(opfile);
			fclose(yyin);
    	}
	}

    yylex_destroy();
    return 0;
}


char* string_to_upper(char* src) {
    size_t len = strlen(src);
    char* dest = calloc(1, len+1);
    if (!dest) { return NULL; }

    for (int i = 0; i < len; i++) {
        dest[i] = toupper((unsigned char)src[i]);
    }

    return dest;
}
