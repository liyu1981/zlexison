%{
int section = 0; // 0 - before rules, 1 - rules, 2 - user code
%}

nl [\r\n]

%x rule
%x rule_action
%x user_block

%%

<*>^\%\%$    {
      // section
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

<INITIAL,rule>\%\{([^\%]|\n)*\%\} {
      // code block
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

<rule>{nl} {
    // rule new line
  }

<rule_action>[^\r\n]+ {
    // action inline
    printf("action:");
    ECHO;
    printf("\n");
  }

<rule_action>{nl} {
    // rule action new line
    BEGIN(rule);
  }

<user_block>(.|\n)* {
    // user code block
    printf("user code block:");
    ECHO;
    printf("\n");
  }

<*>.|\n {}

%%
