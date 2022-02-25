%{
    #define YYDEBUG 1

    #include <stdio.h>
    #include "tree.h"

    extern int yylex();
    extern int yyerror(char *s);
%}

%union {
   struct tree *treeptr;
}


%token <treeptr> '{' '}' '=' '+' '-' '*' '/' '%' '!' '(' ')' ',' ';' ':' '.' '[' ']'
%token <treeptr> '>' '<'

%token <treeptr> END_OF_FILE
%token <treeptr> UNRECOGNIZED_CHARACTER UNSUPPORTED_JAVA_RESERVED_WORD ILLEGAL_PUNCTUATION
%token <treeptr> WHITESPACE NEWLINE
%token <treeptr> COMMENT_SINGLE COMMENT_MULTI PREPROCESSOR_DIRECTIVE
%token <treeptr> CASE DEFAULT
%token <treeptr> CLASS
%token <treeptr> ELSE IF SWITCH
%token <treeptr> FLOAT INT LONG DOUBLE CHAR STRING ARRAY BOOLEAN
%token <treeptr> NEW INSTANCEOF
%token <treeptr> PUBLIC STATIC VOID
%token <treeptr> BREAK CONTINUE RETURN
%token <treeptr> FOR WHILE
%token <treeptr> INCREMENT DECREMENT
%token <treeptr> EQUAL NOT_EQUAL GREATER_EQUAL LESS_EQUAL
%token <treeptr> AND OR
%token <treeptr> IDENTIFIER
%token <treeptr> STRING_LITERAL STRING_LITERAL_ILLEGAL_ESCAPE
%token <treeptr> INT_LITERAL INT_LITERAL_OUT_OF_RANGE
%token <treeptr> CHAR_LITERAL EMPTY_CHARACTER_LITERAL
%token <treeptr> CHAR_LITERAL_ILLEGAL_ESCAPE UNCLOSED_CHARACTER_LITERAL
%token <treeptr> BOOL_LITERAL
%token <treeptr> REAL_LITERAL REAL_LITERAL_OUT_OF_RANGE
%token <treeptr> NULLVAL

%type <treeptr> ClassDecl
%type <treeptr> ClassBody
%type <treeptr> ClassBodyDecls
%type <treeptr> ClassBodyDecl
%type <treeptr> FieldDecl
%type <treeptr> Type
%type <treeptr> Name
%type <treeptr> QualifiedName
%type <treeptr> VarDecls
%type <treeptr> VarDeclarator
%type <treeptr> MethodReturnVal
%type <treeptr> MethodDecl
%type <treeptr> MethodHeader
%type <treeptr> MethodDeclarator
%type <treeptr> FormalParmListOpt
%type <treeptr> FormalParmList
%type <treeptr> FormalParm
%type <treeptr> ConstructorDecl
%type <treeptr> ConstructorDeclarator
%type <treeptr> ArgListOpt
%type <treeptr> Block
%type <treeptr> BlockStmtsOpt
%type <treeptr> BlockStmts
%type <treeptr> BlockStmt
%type <treeptr> LocalVarDeclStmt
%type <treeptr> LocalVarDecl
%type <treeptr> Stmt
%type <treeptr> ExprStmt
%type <treeptr> StmtExpr
%type <treeptr> IfThenStmt
%type <treeptr> IfThenElseStmt
%type <treeptr> IfThenElseIfStmt
%type <treeptr> ElseIfSequence
%type <treeptr> ElseIfStmt
%type <treeptr> WhileStmt
%type <treeptr> ForStmt
%type <treeptr> ForInit
%type <treeptr> ExprOpt
%type <treeptr> ForUpdate
%type <treeptr> StmtExprList
%type <treeptr> BreakStmt
%type <treeptr> ReturnStmt
%type <treeptr> Primary
%type <treeptr> Literal
%type <treeptr> InstantiationExpr
%type <treeptr> ArgList
%type <treeptr> FieldAccess
%type <treeptr> MethodCall
%type <treeptr> PostFixExpr
%type <treeptr> UnaryExpr
%type <treeptr> MulExpr
%type <treeptr> AddExpr
%type <treeptr> RelOp
%type <treeptr> RelExpr
%type <treeptr> EqExpr
%type <treeptr> CondAndExpr
%type <treeptr> CondOrExpr
%type <treeptr> Expr
%type <treeptr> Assignment
%type <treeptr> LeftHandSide
%type <treeptr> AssignOp

%%

ClassDecl:
	PUBLIC CLASS IDENTIFIER ClassBody
		{
			root = makeBranch(_PR_CLASSDECL, "ClassDecl", 3, $1, $3, $4);
			$$ = root;
		}
;

ClassBody:
	'{' ClassBodyDecls '}'
		{ $$ = $2; }
	| '{' '}'
		{}
;

ClassBodyDecls:
	ClassBodyDecl
		{}
	| ClassBodyDecls ClassBodyDecl
		{ $$ = makeBranch(CLASSBODYDECLS, "ClassBodyDecls", 2, $1, $2); }
;

ClassBodyDecl:
	FieldDecl
		{}
	| MethodDecl
		{}
	| ConstructorDecl
		{}
;

FieldDecl:
	Type VarDecls ';'
		{ $$ = makeBranch(FIELDDECL, "FieldDecl", 2, $1, $2); }
;

Type:
	INT
		{}
	| DOUBLE
		{}
	| BOOLEAN
		{}
	| STRING
		{}
	| Name
		{}
;

Name:
	IDENTIFIER
		{}
	| QualifiedName
		{}
;

QualifiedName:
	Name '.' IDENTIFIER
		{ $$ = makeBranch(QUALIFIEDNAME, "QualifiedName", 2, $1, $3); }
;

VarDecls:
	VarDeclarator
		{}
	| VarDecls ',' VarDeclarator
		{ $$ = makeBranch(VARDECLS, "VarDecls", 2, $1, $3); }
;

VarDeclarator:
	IDENTIFIER
		{}
	| VarDeclarator '[' ']'
		{}
;

MethodReturnVal:
	Type
		{}
	| VOID
		{}
;

MethodDecl:
	MethodHeader Block
		{ $$ = makeBranch(METHODDECL, "MethodDecl", 2, $1, $2); }
;

MethodHeader:
	PUBLIC STATIC MethodReturnVal MethodDeclarator
		{ $$ = makeBranch(METHODHEADER, "MethodHeader", 4, $1, $2, $3, $4); }
;

MethodDeclarator:
	IDENTIFIER '(' FormalParmListOpt ')'
		{ $$ = makeBranch(METHODDECLARATOR, "MethodDeclarator", 2, $1, $3); }
;

FormalParmListOpt:
	FormalParmList
		{}
	| %empty
		{ $$ = NULL; }
;

FormalParmList:
	FormalParm
		{}
	| FormalParmList ',' FormalParm
		{ $$ = makeBranch(FORMALPARMLIST, "FormalParmList", 2, $1, $3); }
;

FormalParm:
	Type VarDeclarator
		{ $$ = makeBranch(FORMALPARM, "FormalParm", 2, $1, $2); }
;

ConstructorDecl:
	ConstructorDeclarator Block
		{ $$ = makeBranch(CONSTRUCTORDECL, "ConstructorDecl", 2, $1, $2); }
;

ConstructorDeclarator:
	IDENTIFIER '(' FormalParmListOpt ')'
		{ $$ = makeBranch(CONSTRUCTORDECLARATOR, "ConstructorDeclarator", 2, $1, $3); }
;

ArgListOpt:
	ArgList
		{}
	| %empty
		{ $$ = NULL; }
;

Block:
	'{' BlockStmtsOpt '}'
		{ $$ = $2; }
;

BlockStmtsOpt:
	BlockStmts
		{}
	| %empty
		{ $$ = NULL; }
;

BlockStmts:
	BlockStmt
		{}
	| BlockStmts BlockStmt
		{ $$ = makeBranch(BLOCKSTMTS, "BlockStmts", 2, $1, $2); }
;

BlockStmt:
	LocalVarDeclStmt
		{}
	| Stmt
		{}
;

LocalVarDeclStmt:
	LocalVarDecl ';'
		{}
;

LocalVarDecl:
	Type VarDecls
		{ $$ = makeBranch(LOCALVARDECL, "LocalVarDecl", 2, $1, $2); }
;

Stmt:
	Block
		{}
	| ';'
		{}
	| ExprStmt
		{}
	| BreakStmt
		{}
	| ReturnStmt
		{}
	| %empty
		{ $$ = NULL; }
	| IfThenStmt
		{}
	| IfThenElseStmt
		{}
	| IfThenElseIfStmt
		{}
	| WhileStmt
		{}
	| ForStmt
		{}
;

ExprStmt:
	StmtExpr ';'
		{}
;

StmtExpr:
	Assignment
		{}
	| MethodCall
		{}
	| InstantiationExpr
		{}
;

IfThenStmt:
	IF '(' Expr ')' Block
		{ $$ = makeBranch(IFTHENSTMT, "IfThenStmt", 2, $3, $5); }
;

IfThenElseStmt:
	IF '(' Expr ')' Block ELSE Block
		{ $$ = makeBranch(IFTHENELSESTMT, "IfThenElseStmt", 3, $3, $5, $7); }
;

IfThenElseIfStmt:
	IF '(' Expr ')' Block ElseIfSequence
		{ $$ = makeBranch(IFTHENELSEIFSTMT, "IfThenElseIfStmt", 3, $3, $5, $6); }
    |  IF '(' Expr ')' Block ElseIfSequence ELSE Block
		{ $$ = makeBranch(IFTHENELSEIFSTMT, "IfThenElseIfStmt", 4, $3, $5, $6, $8); }
;

ElseIfSequence:
	ElseIfStmt
		{}
	| ElseIfSequence ElseIfStmt
		{ $$ = makeBranch(ELSEIFSEQUENCE, "ElseIfSequence", 2, $1, $2); }
;

ElseIfStmt:
	ELSE IfThenStmt
		{ $$ = $2; }
;

WhileStmt:
	WHILE '(' Expr ')' Stmt
		{ $$ = makeBranch(WHILESTMT, "WhileStmt", 2, $3, $5); }
;

ForStmt:
	FOR '(' ForInit ';' ExprOpt ';' ForUpdate ')' Block
		{ $$ = makeBranch(FORSTMT, "ForStmt", 4, $3, $5, $7, $9); }
;

ForInit:
	StmtExprList
		{}
	| LocalVarDecl
		{}
	| %empty
		{ $$ = NULL; }
;

ExprOpt:
	Expr
		{}
	| %empty
		{ $$ = NULL; }
;

ForUpdate:
	StmtExprList
		{}
	| %empty
		{ $$ = NULL; }
;

StmtExprList:
	StmtExpr
		{}
	| StmtExprList ',' StmtExpr
		{ $$ = makeBranch(STMTEXPRLIST, "StmtExprList", 2, $1, $3); }
;

BreakStmt:
	BREAK ';'
		{}
	| BREAK IDENTIFIER ';'
		{ $$ = makeBranch(BREAKSTMT, "BreakStmt", 2, $1, $2); }
;

ReturnStmt:
	RETURN ExprOpt ';'
		{ $$ = $2; }
;

Primary:
	Literal
		{}
	| '(' Expr ')'
		{ $$ = $2; }
	| FieldAccess
		{}
	| MethodCall
		{}
;

Literal:
	INT_LITERAL
		{}
	| REAL_LITERAL
		{}
	| BOOL_LITERAL
		{}
	| STRING_LITERAL
		{}
	| NULLVAL
		{}
;

InstantiationExpr:
	NEW Name '(' ArgListOpt ')'
		{ $$ = makeBranch(INSTANTIATIONEXPR, "InstantiationExpr", 2, $2, $4); }
;

ArgList:
	Expr
		{}
	| ArgList ',' Expr
		{ $$ = makeBranch(ARGLIST, "ArgList", 2, $1, $3); }
;

FieldAccess:
	Primary '.' IDENTIFIER
		{ $$ = makeBranch(FIELDACCESS, "FieldAccess", 2, $1, $3); }
;

MethodCall:
	Name '(' ArgListOpt ')'
		{ $$ = makeBranch(METHODCALL, "MethodCall", 2, $1, $3); }
	| Name '{' ArgListOpt '}'
		{ $$ = makeBranch(METHODCALL, "MethodCall", 2, $1, $3); }
	| Primary '.' IDENTIFIER '(' ArgListOpt ')'
		{ $$ = makeBranch(METHODCALL, "MethodCall", 3, $1, $3, $5); }
	| Primary '.' IDENTIFIER '{' ArgListOpt '}'
		{ $$ = makeBranch(METHODCALL, "MethodCall", 3, $1, $3, $5); }
;

PostFixExpr:
	Primary
		{}
	| Name
		{}
;

UnaryExpr:
	'-' UnaryExpr
		{ $$ = makeBranch(UNARYEXPR, "UnaryExpr", 2, $1, $2); }
	| '!' UnaryExpr
		{ $$ = makeBranch(UNARYEXPR, "UnaryExpr", 2, $1, $2); }
	| PostFixExpr
		{}
;

MulExpr:
	UnaryExpr
		{}
	| MulExpr '*' UnaryExpr
		{ $$ = makeBranch(MULEXPR, "MulExpr", 2, $1, $3); }
    | MulExpr '/' UnaryExpr
		{ $$ = makeBranch(MULEXPR, "MulExpr", 2, $1, $3); }
	| MulExpr '%' UnaryExpr
		{ $$ = makeBranch(MULEXPR, "MulExpr", 2, $1, $3); }
;

AddExpr:
	MulExpr
		{}
	| AddExpr '+' MulExpr
		{ $$ = makeBranch(ADDEXPR, "AddExpr", 2, $1, $3); }
	| AddExpr '-' MulExpr
		{ $$ = makeBranch(ADDEXPR, "AddExpr", 2, $1, $3); }
;

RelOp:
	LESS_EQUAL
		{}
	| GREATER_EQUAL
		{}
	| '<'
		{}
	| '>'
		{}
;

RelExpr:
	AddExpr
		{}
	| RelExpr RelOp AddExpr
		{ $$ = makeBranch(RELEXPR, "RelExpr", 3, $1, $2, $3); }
;

EqExpr:
	RelExpr
		{}
	| EqExpr EQUAL RelExpr
		{ $$ = makeBranch(EQEXPR, "EqExpr", 3, $1, $2, $3); }
	| EqExpr NOT_EQUAL RelExpr
		{ $$ = makeBranch(EQEXPR, "EqExpr", 3, $1, $2, $3); }
;

CondAndExpr:
	EqExpr
		{}
	| CondAndExpr AND EqExpr
		{ $$ = makeBranch(CONDANDEXPR, "CondAndExpr", 2, $1, $3); }
;

CondOrExpr:
	CondAndExpr
		{}
	| CondOrExpr OR CondAndExpr
		{ $$ = makeBranch(CONDOREXPR, "CondOrExpr", 2, $1, $3); }
;

Expr:
	CondOrExpr
		{}
	| Assignment
		{}
;

Assignment:
	LeftHandSide AssignOp Expr
		{ $$ = makeBranch(ASSIGNMENT, "Assignment", 3, $1, $2, $3); }
;

LeftHandSide:
	Name
		{}
	| FieldAccess
		{}
;

AssignOp:
	'='
		{}
	| INCREMENT
		{}
	| DECREMENT
		{}
;
