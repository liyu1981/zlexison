%{
int section = 0; // 0 - before rules, 1 - rules, 2 - user code
int last_sc = 0;
%}

%option reject
%option yymore
%option unput
%option stack

%x rule
%x user_block
%x code_block

%%

<*>^\%\%$    {
      // section
      // replace me
      section += 1;
      if (section == 1) {
        BEGIN(rule);
      } else if (section == 2) {
        BEGIN(user_block);
      } else {
        BEGIN(INITIAL);
      }
      printf("now section: %d\n", section);
  }

<INITIAL>^[ \t]+.*$ {
    // code block inline
    // replace me
    printf("code block (inline)");
    ECHO;
    printf("\n");
  }

<INITIAL>^\%\{[ \t]*$ {
        // code block start
      // replace me
      printf("code block start:");
      ECHO;
      printf("\n");
      input(yyg);
      BEGIN(code_block);
      last_sc = INITIAL;
  }

<INITIAL,code_block>^\%\}[ \t]*$ {
    // code block stop
    // replace me
    printf("code block stop:");
    ECHO;
    printf("\n");
    input(yyg);
    BEGIN(last_sc);
  }

<INITIAL>^%(s|x) {
    // start condition
    // replace me
    printf("start condition:");
    ECHO;
    printf("\n");
  }

<code_block>.* {
    // code block content
    // replace me
    printf("code block content:");
    ECHO;
  }

<code_block>\n {
    // code block newline
    // replace me
    printf("code block newline");
    ECHO;
  }

<rule>^\%\{[ \t]*$ {
        // code block start
      // replace me
      printf("code block start(rule):");
      ECHO;
      printf("\n");
      input(yyg);
      BEGIN(code_block);
      last_sc = rule;
  }

<rule>.* {
    // rule line
    // replace me
    printf("rule line:");
    ECHO;
    printf("\n");
  }


<rule>\n {
    // rule new line
    // replace me
  }

<user_block>(.|\n)* {
    // user code block
      // replace me
    printf("user code block:");
    ECHO;
    printf("\n");
  }

<*>.|\n {
      // replace me
  }

%%

int zyywrap(yyscan_t yyscanner) {
    return 1;
}

int main() {
  yyscan_t scanner;
  yylex_init(&scanner);
  int r = yylex(scanner);
  yylex_destroy(scanner);
  return r;
}
