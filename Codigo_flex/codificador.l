%option noyywrap

%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>

// Contadores para estadísticas
int contador_mayusculas = 0;
int contador_minusculas = 0;
int contador_digitos = 0;
int contador_espacios = 0;
int contador_palabras = 1;
int contador_vocales = 0;
int contador_noalfanum = 0;
int total_caracteres = 0;



char* codificar_morse(char c) {
    static char* morse[] = {
        ".-", "-...", "-.-.", "-..", ".", "..-.", "--.", "....", "..", ".---", "-.-", ".-..",
         "--", "-.", "---", ".--.", "--.-", ".-.", "...", "-", "..-", "...-", ".--", "-..-", "-.--", "--..",
        "-----", ".----", "..---", "...--", "....-", ".....", "-....", "--...", "---..", "----.",
        ".-.-.-", "--..--", "..--..", "---...", "-.-.-.", ".-..-.", ".----.", "-....-", "-..-.", "-.--.-",
        ".--.-.","...-..-","..--.-",".-.-.","-...-",".-...","-.-.--",
        "" // Fin
    };
    static char caracteres[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,?:;\"'-/()@$_+=&!";

    char* ptr = strchr(caracteres, toupper(c));
    if (ptr) {
        return morse[ptr - caracteres];
    }
    return "";  // Caracter no soportado
}


// Verificar si es una vocal
int verificar_vocal(char c) {
    char minusc = tolower(c);
    return minusc == 'a' || minusc == 'e' || minusc == 'i' || minusc == 'o' || minusc == 'u';
}
%}

%%

[a-zA-Z0-9.,?] {
    printf("%s ", codificar_morse(yytext[0]));
    char c = yytext[0];

    // Aqui se da la actualizacion de los contadores
    if (isupper(c)) contador_mayusculas++;
    if (islower(c)) contador_minusculas++;
    if (isdigit(c)) contador_digitos++;
    if (verificar_vocal(c)) contador_vocales++;
    if (!isalnum(c)) contador_noalfanum++;
    total_caracteres++;
}

" " { 
    printf("/ "); 
    contador_espacios++;
    contador_palabras++;  // Incrementar cuenta de palabras por cada espacio
}

\n { 
    printf("\n"); 
    contador_palabras++;  // Incrementar cuenta de palabras al final de la línea
}

.|\n { 
    if (!isalnum(yytext[0]) && yytext[0] != ' ') contador_noalfanum++; 
}

%%

int main(int argc, char** argv) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <texto para codificar>\n", argv[0]);
        return 1;
    }
    char input[1024] = ""; 
    for (int i = 1; i < argc; i++) {
        strcat(input, argv[i]);
        if (i < argc - 1) strcat(input, " ");
    }
    printf("======================================================\n");
    printf("Codigo morse: ");
    YY_BUFFER_STATE buffer = yy_scan_string(input);
    yylex();
    yy_delete_buffer(buffer);

    printf("\n======================================================");
    // Mostrar estadísticas
    printf("\n\t\t--- Estadisticas ---\n");
    printf("Letras mayusculas: %d\n", contador_mayusculas);
    printf("Letras minusculas: %d\n", contador_minusculas);
    printf("Digitos: %d\n", contador_digitos);
    printf("Espacios: %d\n", contador_espacios);
    printf("Palabras: %d\n", contador_palabras);
    printf("Vocales: %d\n", contador_vocales);
    printf("Caracteres no alfanumericos: %d\n", contador_noalfanum);
    printf("Total de caracteres: %d\n" ,total_caracteres);
    printf("======================================================");
    printf("\n\tOperacion terminada con exito");
    return 0;
}
