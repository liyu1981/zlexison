%{
const Context = struct {
%}

%x rule
%x user_block
%x code_block

%%

<*>^\%\%$    {
    parser.action.ECHO();
  }

<INITIAL>^[ \t]+.*$ {
    parser.action.ECHO();
  }

<INITIAL>^\%\{[ \t]*$ {
    parser.action.ECHO();
  }

<INITIAL,code_block>^\%\}[ \t]*$ {
    parser.action.ECHO();
  }

<INITIAL>^%(s|x) {
    parser.action.ECHO();
  }

<code_block>.* {
    parser.action.ECHO();
  }

<code_block>\n {
    parser.action.ECHO();
  }

<rule>^\%\{[ \t]*$ {
    parser.action.ECHO();
  }

<rule>.* {
    parser.action.ECHO();
  }


<rule>\n {
    parser.action.ECHO();
  }

<user_block>(.|\n)* {
    parser.action.ECHO();
  }

<*>.|\n {
    parser.action.ECHO();
  }

%%
