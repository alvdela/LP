/**
 * @Author: Dušan Kolář
 * @Year:   2023
 * Copyright (c) 2023
 * Licence: GLP 3.0
 */

%{
#include <stdio.h>
#include <string.h>

#include "tokens.h"

#define KWLEN  12
char *keywords[KWLEN] = {
    "off",
    "on",
    "print",
    "procedure",
    "run",
    "set",
    "signal",
    "start",
    "stop",
    "until",
    "wait",
    "while",
};

unsigned keycodes[KWLEN] = {
    OFF,
    ON,
    PRINT,
    PROCEDURE,
    RUN,
    SET,
    SIGNAL,
    START,
    STOP,
    UNTIL,
    WAIT,
    WHILE,
};

int yywrap(void) { return 1; }
%}

LETTER    ([_a-zA-Z])

DIGIT     ([0-9])
NUMBER    ({DIGIT}+)

IDENTIFIER     ({LETTER}({LETTER}|{DIGIT})*)
STRING          (["].*["])

COMMA     ([,])
SEMICOLON     ([;])
DOT       ([\.])

SPACE      ([ \t\f\r])
SPACES     ({SPACE}+)

LINESEP   ([\n])

%%

{STRING}            return STRING;
{SPACES}            ; /* nothing to do, white space */

{IDENTIFIER}             {
                        unsigned i = 0;
                        int r=-1;

                        while (i<KWLEN && r<0) {
                            
                            if ((r=strcmp(keywords[i],yytext))==0) {
                                return keycodes[i];
                            }
                            ++i;
                        }

                        return IDENTIFIER;
                    }

{LINESEP}           {
                        ++yylineno;
                    }

{NUMBER}            {
                        return NUMBER;
                    }

{COMMA}             return yytext[0];

{SEMICOLON}         return yytext[0];

{DOT}               return yytext[0];

.                   {
                        printf ("Carácter inesperado: %s\nLinea: %i\n", yytext, yylineno);
		                return ERROR;
                    }

%%

// no code here

/* -- EOF -- */
