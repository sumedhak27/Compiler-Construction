%option noyywrap
%{
    #include <stdio.h>
    #include <string.h>
    enum type { UNKNOWN = 0, NOUN, VERB, ADV, ADJ, PRON, CONJ, PREP};
	enum type state = UNKNOWN;
    void add_word(char*, int);
    int find_word_type(char*);
    void print_list();
%}


%%
\n  		{state = UNKNOWN;}
^noun		{state = NOUN;}
^verb		{state = VERB;}
^adv		{state = ADV;}
^adj		{state = ADJ;}
^pro		{state = PRON;}
^conj		{state = CONJ;}
^prep       {state = PREP;}
[a-zA-Z]+   {
                if(state != UNKNOWN) {
                    add_word(yytext, state);
                }
                else {
                    switch(find_word_type(yytext)) {
                        case NOUN : printf("%s\t -> NOUN\n", yytext); break;
                        case VERB : printf("%s\t -> VERB\n", yytext); break;
                        case ADV : printf("%s\t -> ADVERB\n", yytext); break;
                        case ADJ : printf("%s\t -> ADJECTIVE\n", yytext); break;
                        case PRON : printf("%s\t -> PRONOUN\n", yytext); break;
                        case CONJ : printf("%s\t -> CONJUNCTION\n", yytext); break;
                        case PREP : printf("%s\t -> PREPOSITION\n", yytext); break;
                        default : printf("%s\t -> NOT IN DICTIONARY\n", yytext);
                    }
                }
}
.			;
%%

void main() {
    yylex();
}

struct word {
    char* name;
    int type;
    struct word * next;
};

struct word *word_list;

extern void *malloc();

void add_word(char* word, int state) {
    if(word_list && find_word_type(word) != UNKNOWN) {
        printf("WARNING : The word '%s' is already defined.\n", word);
        return;
    }
    struct word * wp = (struct word *) malloc(sizeof(struct word));
    wp->name = (char * ) malloc(strlen(word) + 1);
    strcpy(wp->name, word);
    wp->type = state;
    wp->next = word_list;
    word_list = wp;
    
    //print_list();
}

int find_word_type(char* word) {
	struct word *wp = word_list;
	for(; wp; wp=wp->next) {
		if(strcmp(wp->name, word) == 0)
			return wp->type;
	}
	return UNKNOWN;
}

void print_list() {
	struct word *tmp = word_list;
    for(;tmp; tmp=tmp->next)
    	printf("(%s -> %d) -> ", tmp->name, tmp->type);
    printf("NULL\n");
}

