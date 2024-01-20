%{
int section = 0; // 0 - before rules, 1 - rules, 2 - user code
int wanted_section = 1;
int scope = 0;
int now_print = 0;
int can_activate = 0;
%}

nl [\r\n]

%x rule
%x rule_action

%%

<*>^\%\%$    {
    section += 1;
    if (section == 1) {
      BEGIN(rule);
    } else {
      BEGIN(INITIAL);
    }
    printf("now section: %d\n", section);
}

<INITIAL,rule>\%\{(.|\n)*\%\} {
    printf("code block:");
    ECHO;
    printf("\n");
}

<rule>^[^[:space:]]*(\\\ [^[:space:]]*)* {
  // pattern
  printf("rule:");
  ECHO;
  printf("\n");
  BEGIN(rule_action);
}

<rule>[ \t]+[^\r\n]+ {
  // action in newline
  printf("action:");
  ECHO;
  printf("\n");
}

<rule>{nl} {}

<rule_action>[^\r\n]+ {
  // action inline
  printf("action:");
  ECHO;
  printf("\n");
}

<rule_action>{nl} {
  BEGIN(rule);
}

<*>.|\n {}

%%

/*


\%\{z   { if (can_activate != 0) now_print = 0; }

\%z\}   { if (can_activate != 0) now_print = 0; }

\{z    { if (can_activate != 0) now_print = 0;  }

z\}    { if (can_activate != 0) now_print = 0; can_activate = 0; }

<*>{ws}+    {
    if (section == wanted_section && now_print != 0) {
        ECHO;
    }
}

<*>{nl}     {
    if (section == wanted_section && now_print != 0) {
        ECHO;
    }
}

<rule>\%\%   {
    section += 1;
    if (section == 1) {
      BEGIN(rule);
    } else {
      BEGIN(INITIAL);
    }
    printf("now section 2: %d\n", section);
}

<rule>^[^ ]+ {
  //printf("found rule: ");
  //printf("%s,%d", yytext, yyleng);
  //printf("\n");
  //printf("\n");
  //now_print = 1;
  ECHO;
  //printf("\n====== RULE =======\n");
  //BEGIN(rule_action);
}

<*>.     {
    if (section == wanted_section && now_print != 0) {
        ECHO;
    }
}

*/
