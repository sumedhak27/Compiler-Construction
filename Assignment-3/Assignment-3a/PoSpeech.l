%option noyywrap
%{
%}

%%
[\t ]+        ;

is |
are |
was | 
am |
done | 
sing | 
dances |
plays |
was |
were |
be | 
been |
should |
could |
would |
holds |
proved |
say             {printf("%s -> VERB\n", yytext);}

good |
great |
bad |
worst |
very |
shrply |
gently |
quietly |
calmly |
angrily         {printf("%s -> ADVERB\n", yytext);}

to |
from |
behind |
below |
between |
below  |
above         {printf("%s -> PREPOSITION\n", yytext);}

and |
or |
but | 
since |
hence |
then |
if              {printf("%s -> CONJUNCTION\n", yytext);}

I |
he | 
she |
it |
they |
me |
we              {printf("%s -> PRONOUN\n", yytext);}

their |
my |
Your |
his |
her |
its             {printf("%s -> ADJECTIVE\n", yytext);}

a |
an |
The 			{printf("%s -> ARTICLE\n", yytext);}

[a-zA-Z]+       {printf("%s -> can be a NOUN\n", yytext);}

.|\n            {ECHO;}
%%

void main(){
    yylex();
}
