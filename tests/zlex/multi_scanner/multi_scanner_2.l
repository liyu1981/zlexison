%{
    // scanner-2
%}

%x OFF
%x ON

%%
<INITIAL>{
on    try yy_push_state(ON, yyg); return 3;
off   try yy_push_state(OFF, yyg); return 4;
.|\n  return 5;
}
<ON>.|\n  yy_pop_state(yyg); return 6;

<OFF>.|\n yy_pop_state(yyg); return 7;
%%

