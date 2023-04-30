%{
// Lenguajes de Programacion
// Practica 1 - Curso 2022-2023
// Autores: Sara Aparicio Fernandez, Alvaro de la Rosa Zarzuelo, Gonzalo Ovejero Alonso


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <stdbool.h>
%}

 struct Componente {
	char* operandoG;		// Operando almacenado a comparar
	struct Componente *siguiente;	// Puntero al siguiente componente de la l. enlazada
 };

 struct Componente *identificadores;	// Primer componente de la lista de identificadores
 struct Componente *constantes;		// Primer componente de la lista de constantes

 // Array que almacena la lista de palabras reservadas a comparar
 char comprPalabRes[50][15] = {"abstract","assert","boolean","break","byte","case","catch","char","class","const","continue","default","do","double","else","enum","extends","final","finally","float","for","goto","if","implements","import","instanceof","int","interface","long","native","new","package","private","protected","public","return","short","static","strictfp","super","switch","synchronized","this","throw","throws","transient","try","void","volatile","while"};
 // Array de enteros que almacena las apariciones de nuevas palabras reservadas
 int listaPalabRes[50];
 
 // Array de strings que almacena la lista de operadores permitidos a comparar
 char comprOperadores[37][3] = {{"++"},{"--"},{"+"},{"-"},{"!"},{"~"},{"*"},{"/"},{"%"},{"<"},{">"},{"<="},{">="},{"=="},{"!="},{"&"},{"^"},{"|"},{"&&"},{"||"},{"?"},{":"},{"="},{"+="},{"-="},{"*="},{"/="},{"%="},{"&="},{"^="},{"|="},{","},{"."},{";"},{"("},{"{"},{"["}};
 
 // Array de enteros que almacena las apariciones de nuevos operadores
 int listaOperadores[37];

 // Declaracion de las funciones
 int cuentaOperadores(char *operador, int esPalabRes);
 int cuentaOperandos(char *operando, int esIdentificador);

 int linProg = 0; 			// Variable que sirve como contador de lineas de programa
 int linComS = 0;			// Variable que sirve como contador de comentarios simples
 int linComM = 0;			// Variable que sirve como contador de comentarios multilinea
 int linBlanc = 0;			// Variable que sirve como contador de lineas en blanco
 int comentarioAct = 0;		// Variable que nos permite conocer si estamos en un coment. multilinea
 bool primeraVez = true;	// Variable que nos permite saber si es la primera vez que se encuentra " "
 int n1 = 0;				// Numero de operadores diferentes ej ++, + , <
 int n2 = 0;				// Numero de operandos diferentes ej num, true, false, int 
 int N1 = 0; 				// Numero total de operadores
 int N2 = 0;				// Numero total de operandos


palabrasRes abstract|assert|boolean|break|byte|case|catch|char|class|const|continue|default|do|double|else|enum|extends|final|finally|float|for|goto|if|implements|import|instanceof|int|interface|long|native|new|package|private|protected|public|return|short|static|strictfp|super|switch|synchronized|this|throw|throws|transient|try|void|volatile|while

operadores [++]|[--]|[+]|[-]|[!]|[~]|[*]|[/]|[%]|[<]|[>]|[<=]|[>=]|[==]|[!=]|[&]|[^]|[|]|[&&]|[||]|[?]|[:]|[=]|[+=]|[-=]|[*=]|[/=]|[%=]|[&=]|[^=]|[|=]|[,]|[.]|[;]|["("]|["{"]|["["]

letra [a-zA-Z]
dig [0-9]
digs {dig}+
decimal [.]{digs}
exponente [eE][-]?{digs}
tipo [f|F|d|D|L|l]
identificadores {letra}({letra}|{dig})*
consts {digs}{decimal}?{exponente}?{tipo}?

%%
^[" "|"\t"]*\n				{linBlanc++;}
^[" "|"\t"]*"//".*\n		{linComS++;}
^[" "|"\t"]*"/*".*\n		{comentarioAct = 1;linComM++;}
.*"*/"[" "|"\t"]*\n			{comentarioAct = 0;linComM++;}
"*".*\n						{if(comentarioAct == 1){linComM++;}else{linComM++;linProg++;}}
"/*".*\n              		{comentarioAct=1;linComM++;linProg++;} //Implican que antes ha habido codigo
"//".*\n					{linComS++;linProg++;} //Implican que antes ha habido codigo
.*"*/"						{comentarioAct = 0;linComM++;linProg++;} //Implican que despues ha habido codigo
\n							{linProg++;}
["].*["]					{cuentaOperandos(yytext, 0);}
{consts}					{cuentaOperandos(yytext, 0);}
{operadores}				{cuentaOperadores(yytext, 0);}  
{palabrasRes}				{cuentaOperadores(yytext, 1);}
{identificadores}			{cuentaOperandos(yytext, 1);}

%%



// Funcion que nos permite contar las apariciones de los operadores, asi como
// diferenciar los nuevos con los previamente almacenados
int cuentaOperadores(char *operador, int esPalabraRes) {
    
    int i;
    
    // Comprobamos si el operador detectado es una palabra reservada o no
    if(esPalabraRes == 1) {
        
		// Recorremos la lista de palabras reservadas
		for(i = 0; i < 50; i++) {
				
			// Si se encuentra en la lista, se aumenta el contador de operadores totales
			if(strcmp(comprPalabRes[i], operador) == 0){
				N1++;
					
				// Si el operador es nuevo, se aumenta el contador de operadores distintos
				if(listaPalabRes[i] == 0){
					listaPalabRes[i] = 1;
					n1++;
				}
			}
        }
    } else {
        
		// Recorremos la lista de operadores
        for(i = 0; i < 37; i++) {
            
			// Si se encuentra en la lista, se aumenta el contador de operadores totales
			if(strcmp(comprOperadores[i], operador) == 0){
				N1++;
					
				// Si el operador es nuevo, se aumenta el contador de operadores distintos
				if(listaOperadores[i] == 0){
					listaOperadores[i] = 1;
					n1++;
				}
			}
        }
    }
    return 0;
}


/// Funcion que nos permite contar las apariciones de los operandos, asi como
// diferenciar los nuevos con los previamente almacenados
int cuentaOperandos(char* operando, int esIdentificador) {

	int nuevo = 0;		  // Flag que nos permitira saber si el operando es nuevo o no
	struct Componente *nodoR; // Nodo que nos servira para recorrer la lista enlazada
	
	N2++;				// Aumentamos el contador de operandos totales	
		
	// En funcion de lo que detectemos, hacemos que el nodo se situe en la cabeza
	// de la lista a recorrer	
	if(esIdentificador == 1) {
		nodoR = identificadores;
	} else {
		nodoR = constantes;
	}

	// Recorremos la lista enlazada para comprobar si el componente lexico
	// es nuevo o ya ha aparecido
	for(; nodoR; nodoR = nodoR->siguiente) {
		if(strcmp(nodoR->operandoG,operando) == 0) {
			nuevo = 1;
		} 
	}

	// Si el componente lexico es nuevo, lo añadimos a su lista enlazada correspondiente
	if(nuevo == 0) {
			
		// Reservamos memoria para el nuevo elemento
		nodoR = (struct Componente *) malloc(sizeof(struct Componente));

		// Introducimos el componente lex. en la lista
		nodoR -> operandoG = (char *) malloc (strlen(operando)+1);
		strcpy(nodoR -> operandoG, operando);
			
		// Incrementamos el contador de operandos diferentes
		n2++;			
			
		// Enlazamos con el siguiente nodo, en funcion de la lista que corresponda
		if(esIdentificador == 1) {
			nodoR -> siguiente = identificadores;
			identificadores = nodoR;
		} else {
			nodoR -> siguiente = constantes;
			constantes = nodoR;
		}
	}
	return 0;
}


int main(int argc, char* argv) {
	
	// Inicializamos las posiciones de ambas listas a 0
	for(int i = 0; i < 50; i++){
		listaPalabRes[i] = 0;
	}

	for(int i = 0; i < 37; i++){
        listaOperadores[i] = 0;
	}

	// Funcion principal que realiza el analisis lexico
	yylex();

	// Salida por pantalla donde mostramos los valores requeridos
	printf("Lineas de programa (LOCP): %d\n", linProg);
	printf("Lineas de comentarios (LOCC): %d\n", (linComS + linComM));
	printf("Lineas en blanco (LOCW): %d\n", linBlanc);
	printf("n1: %d\n", n1);
	printf("N1: %d\n", N1);
   	printf("n2: %d\n", n2);
	printf("N2: %d\n", N2);
	
	// Calculo para el esfuerzo de halstead	
	double N = N1+N2;
	double n = n1+n2;
	double V = N*(log(n)/log(2));
	double D = (n1/2)*(N2/n2);
	double E = V*D;
	printf("Esfuerzo de Halstead(E): %f\n", E);

}
