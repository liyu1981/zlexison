/* comments in definition section */
%{
// code block
%}

/* Definitions Section */

%x STATE_X

%%
  /* Rules Section */
  /* multi line comments
     will work too. */
ruleA /* after regex */ { /* code block */ } /* after code block */
      /* Rules Section (indented) */
<STATE_X>{
        ruleC { 
                try ECHO(yyg);
                // quotes with comments should work
                //' "
            }
        ruleD try ECHO(yyg);
        %{
            /* code block */
        %}
    }

%%

// User Code Section use zig style comments

pub fn main() !u8 {
    return 0;
}
