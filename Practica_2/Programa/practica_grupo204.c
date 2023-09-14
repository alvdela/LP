#include "lex.yy.c"
#include <stdlib.h>

int preanalisis;

void parea(int);
void comando();
void programa();
void lista_procedimientos();
void procedimiento();
void lista_comandos();
void lista_comandos2();
void comando();
void comando_SET();
void comando_WAIT();
void evento();

void parea(int token)
{
    if (preanalisis == token)
    {
        preanalisis = yylex();
    }
    else if (preanalisis == ERROR)
    {
        printf("Error léxico en: %s\n Linea: %i\n", yytext, yylineno);
        printf("Se esperaba un: %c\n", token);
        preanalisis = yylex();
        parea(token);
    }
    else if (preanalisis == 0)
    {
        printf("Error: no se pudo encontrar elemento: %c\n", token);
        exit(1);
    }
    else
    {
        printf("Error inesperado en: %s\n Linea: %i\n", yytext, yylineno);
        printf("Se esperaba un: %c\n", token);
        preanalisis = yylex();
        parea(token);
    }
}

void comando()
{
    if (preanalisis == START)
    {
        printf("comando -> START IDENTIFIER NUMBER\n");
        parea(START);
        parea(IDENTIFIER);
        parea(NUMBER);
    }
    else if (preanalisis == STOP)
    {
        printf("comando -> STOP IDENTIFIER\n");
        parea(STOP);
        parea(IDENTIFIER);
    }
    else if (preanalisis == SET)
    {
        printf("comando -> SET comando_SET\n");
        parea(SET);
        comando_SET();
    }
    else if (preanalisis == WAIT)
    {
        printf("comando-> WAIT comando_WAIT\n");
        parea(WAIT);
        comando_WAIT();
    }
    else if (preanalisis == RUN)
    {
        printf("comando -> RUN IDENTIFIER\n");
        parea(RUN);
        parea(IDENTIFIER);
    }
    else if (preanalisis == PRINT)
    {
        printf("comando -> PRINT STRING\n");
        parea(PRINT);
        parea(STRING);
    }
    else if (preanalisis == ERROR)
    {
        printf("Error léxico en: %s\n Linea: %i\n", yytext, yylineno);
        printf("Se esperaba un comienzo de comando\n");
        preanalisis = yylex();
        comando();
    }
    else if (preanalisis == PROCEDURE || preanalisis == ON || preanalisis == OFF || preanalisis == WHILE || preanalisis == UNTIL || preanalisis == IDENTIFIER ||
             preanalisis == SIGNAL || preanalisis == ',' || preanalisis == ';' || preanalisis == NUMBER)
    {
        printf("Error inesperado en: %s\n Linea: %i\n", yytext, yylineno);
        printf("Se esperaba un comienzo de comando\n");
        preanalisis = yylex();
        comando();
    }
    else if (preanalisis == 0)
    {
        printf("Error: no se pudo encontrar el comienzo de comando\n");
        exit(1);
    }
}

void programa()
{
    printf("programa -> lista_procedimientos lista_comandos .\n");
    lista_procedimientos();
    printf("lista_procedimientos -> Ɛ\n");
    lista_comandos();
    parea('.');
}

void lista_procedimientos()
{
    if (preanalisis == PROCEDURE)
    {
        printf("lista_procedimientos -> procedimiento lista_procedimientos\n");
        printf("Se esperaba un comienzo de procedimiento\n");
        procedimiento();
        lista_procedimientos();
    }
    else if (preanalisis == ERROR)
    {
        printf("Error léxico en: %s\n Linea: %i\n", yytext, yylineno);
        preanalisis = yylex();
        lista_procedimientos();
    }
    else if (preanalisis == ON || preanalisis == OFF || preanalisis == WHILE || preanalisis == UNTIL || preanalisis == IDENTIFIER ||
             preanalisis == SIGNAL || preanalisis == ',' || preanalisis == ';' || preanalisis == NUMBER)
    {
        printf("Error inesperado en: %s\n Linea: %i\n", yytext, yylineno);
        printf("Se esperaba un comienzo de procedimiento\n");
        preanalisis = yylex();
        lista_procedimientos();
    }
    else if (preanalisis == 0)
    {
        printf("Error: no se pudo encontrar el comienzo de comando\n");
        exit(1);
    }
}

void procedimiento()
{
    printf("procedimiento -> PROCEDURE IDENTIFIER lista_comandos ; \n");
    parea(PROCEDURE);
    parea(IDENTIFIER);
    lista_comandos();
    parea(';');
}

void lista_comandos()
{
    printf("lista_comandos -> comando lista_comandos' \n");
    comando();
    lista_comandos2();
}

void lista_comandos2()
{
    if (preanalisis == ',')
    {
        printf("lista_comandos' -> , comando lista_comandos'\n");
        parea(',');
        comando();
        lista_comandos2();
    }
    else if (preanalisis == ';' || preanalisis == '.')
    {
        printf("lista_comandos' -> Ɛ\n");
    }
    else if (preanalisis == ERROR)
    {
        printf("Error léxico en: %s\n Linea: %i\n", yytext, yylineno);
        printf("Se esperaba: ',', ';' o '.'\n");
        preanalisis = yylex();
        lista_comandos2();
    }
    else if (preanalisis == PROCEDURE || preanalisis == START || preanalisis == STOP || preanalisis == ON || preanalisis == OFF ||
             preanalisis == WHILE || preanalisis == UNTIL || preanalisis == IDENTIFIER || preanalisis == RUN ||
             preanalisis == SIGNAL || preanalisis == SET || preanalisis == WAIT || preanalisis == PRINT || preanalisis == NUMBER)
    {
        printf("Error inesperado en: %s\n Linea: %i\n", yytext, yylineno);
        printf("Se esperaba: ',', ';' o '.'\n");
        preanalisis = yylex();
        lista_comandos2();
    }
    else if (preanalisis == 0)
    {
        printf("Error: no se pudo encontrar el final de lista de comandos\n");
        exit(1);
    }
}

void comando_SET()
{
    if (preanalisis == OFF)
    {
        printf("comando_SET -> OFF IDENTIFIER\n");
        parea(OFF);
        parea(IDENTIFIER);
    }
    else if (preanalisis == ON)
    {
        printf("comando_SET -> ON IDENTIFIER\n");
        parea(ON);
        parea(IDENTIFIER);
    }
    else if (preanalisis == ERROR)
    {
        printf("Error léxico en: %s\n Linea: %i\n", yytext, yylineno);
        printf("Se esperaba comando ON o OFF\n");
        preanalisis = yylex();
        comando_SET();
    }
    else if (preanalisis == PROCEDURE || preanalisis == SET || preanalisis == WAIT || preanalisis == WHILE || preanalisis == UNTIL || 
             preanalisis == IDENTIFIER || preanalisis == START || preanalisis == STOP || preanalisis == RUN || preanalisis == PRINT ||
             preanalisis == SIGNAL || preanalisis == ',' || preanalisis == ';'|| preanalisis == NUMBER)
    {
        printf("Error inesperado en: %s\n Linea: %i\n", yytext, yylineno);
        printf("Se esperaba comando ON o OFF\n");
        preanalisis = yylex();
        comando_SET();
    }
    else if (preanalisis == 0)
    {
        printf("Error: no se pudo encontrar continuación del comando SET\n");
        exit(1);
    }
}

void comando_WAIT()
{
    if (preanalisis == WHILE)
    {
        printf("comando_WAIT -> WHILE evento\n");
        parea(WHILE);
        evento();
    }
    else if (preanalisis == UNTIL)
    {
        printf("comando_WAIT -> UNTIL evento\n");
        parea(UNTIL);
        evento();
    }
    else if (preanalisis == ERROR)
    {
        printf("Error léxico en: %s\n Linea: %i\n", yytext, yylineno);
        printf("Se esperaba comando ON o OFF\n");
        preanalisis = yylex();
        comando_WAIT();
    }
    else if (preanalisis == PROCEDURE || preanalisis == SET || preanalisis == WAIT || preanalisis == ON || preanalisis == OFF || 
             preanalisis == IDENTIFIER || preanalisis == START || preanalisis == STOP || preanalisis == RUN || preanalisis == PRINT ||
             preanalisis == SIGNAL || preanalisis == ',' || preanalisis == ';'|| preanalisis == NUMBER)
    {
        printf("Error inesperado en: %s\n Linea: %i\n", yytext, yylineno);
        printf("Se esperaba comando WHILE o UNTIL\n");
        preanalisis = yylex();
        comando_WAIT();
    }
    else if (preanalisis == 0)
    {
        printf("Error: no se pudo encontrar continuación del comando WAIT\n");
        exit(1);
    }
}

void evento()
{
    if (preanalisis == IDENTIFIER)
    {
        printf("evento -> IDENTIFIER\n");
        parea(IDENTIFIER);
    }
    else if (preanalisis == SIGNAL)
    {
        printf("evento -> SIGNAL IDENTIFIER\n");
        parea(SIGNAL);
        parea(IDENTIFIER);
    }
    else if (preanalisis == ERROR)
    {
        printf("Error léxico en: %s\n Linea: %i\n", yytext, yylineno);
        printf("Se esperaba un IDENTIFIER o SIGNAL\n");
        preanalisis = yylex();
        evento();
    }
    else if (preanalisis == PROCEDURE || preanalisis == SET || preanalisis == WAIT || preanalisis == ON || preanalisis == OFF || 
             preanalisis == UNTIL || preanalisis == START || preanalisis == STOP || preanalisis == RUN || preanalisis == PRINT ||
             preanalisis == WHILE || preanalisis == ',' || preanalisis == ';'|| preanalisis == NUMBER)
    {
        printf("Error inesperado en: %s\n Linea: %i\n", yytext, yylineno);
        printf("Se esperaba un IDENTIFIER o SIGNAL\n");
        preanalisis = yylex();
        evento();
    }
    else if (preanalisis == 0)
    {
        printf("Error: no se pudo encontrar un evento\n");
        exit(1);
    }
}

void main()
{
    preanalisis = yylex();
    programa();
    if (preanalisis == 0) // yylex() devuelve 0 en el fin de fichero
        printf("OK\n");
    else
        printf("Sobra algo\n");
}