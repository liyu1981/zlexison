%{
    // scanner-1
%}

%x ON
%x OFF

%%
<INITIAL>{
on    try yy_push_state(ON, yyg); return 10;
off   try yy_push_state(OFF, yyg); return 11;
.|\n  return 12;
}
<ON>.|\n  yy_pop_state(yyg); return 13;

<OFF>.|\n yy_pop_state(yyg); return 14;

%%

