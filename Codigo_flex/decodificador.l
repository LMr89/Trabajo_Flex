%option noyywrap

%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>

// Tabla inversa de Morse a texto
typedef struct {
    char* morse;
    char character;
} MorseMap;

MorseMap tabla_codigos_morse[] = {
    {".-", 'A'},   {"-...", 'B'}, {"-.-.", 'C'}, {"-..", 'D'},  {".", 'E'},
    {"..-.", 'F'}, {"--.", 'G'},  {"....", 'H'}, {"..", 'I'},   {".---", 'J'},
    {"-.-", 'K'},  {".-..", 'L'}, {"--", 'M'},   {"-.", 'N'},   {"---", 'O'},
    {".--.", 'P'}, {"--.-", 'Q'}, {".-.", 'R'},  {"...", 'S'},  {"-", 'T'},
    {"..-", 'U'},  {"...-", 'V'}, {".--", 'W'},  {"-..-", 'X'}, {"-.--", 'Y'},
    {"--..", 'Z'}, {"-----", '0'}, {".----", '1'}, {"..---", '2'}, {"...--", '3'},
    {"....-", '4'}, {".....", '5'}, {"-....", '6'}, {"--...", '7'}, {"---..", '8'},
    {"----.", '9'}, {".-.-.-", '.'}, {"--..--", ','}, {"..--..", '?'}, {"---...", ':'},
    {"-.-.-.", ';'}, {".-..-.", '\"'}, {".----.", '\''}, {"-....-", '-'}, {"-..-.", '/'},
    {".--.-.", '@'}, {"...-..-", '$'},{"..--.-", '_'},{".-.-.", '+'},{"-...-", '='},
    {".-...", '&'},{"-.-.--", '!'},
    {"-.--.-", ')'}, {"-.--.-", '('}, 
    {"", 0}  // Fin de la tabla
};

// Variables para estadísticas
int longitud = 0;
int cantidad_mayusculas = 0;
int cantidad_digitos = 0;
int cantidad_noalfa = 0;
int cantidad_espacios = 0;
int total_vocales = 0;
int total_palabras = 1;

// Función para buscar un código Morse en la tabla y devolver el carácter correspondiente
char decodificar_morse(const char* code) {
    for (int i = 0; tabla_codigos_morse[i].character != 0; i++) {
        if (strcmp(tabla_codigos_morse[i].morse, code) == 0) {
            return tabla_codigos_morse[i].character;
        }
    }
    return '?';
}

int verificar_vocal(char c) {
    char minusc = tolower(c);
    return minusc == 'a' || minusc == 'e' || minusc == 'i' || minusc == 'o' || minusc == 'u';
}

void monitorear_estadisticas(char caracter_decodificado) {
    longitud++;
    if (isupper(caracter_decodificado)) {
        cantidad_mayusculas++;
    } else if (isdigit(caracter_decodificado)) {
        cantidad_digitos++;
    } else if (!isalnum(caracter_decodificado) && caracter_decodificado != ' ') {
        cantidad_noalfa++;
    }
    if (verificar_vocal(caracter_decodificado) == 1){
        total_vocales++;
    }

}


%}

%%

[.-]+ {
    char caracter_decodificado = decodificar_morse(yytext);
    printf("%c", caracter_decodificado);
    monitorear_estadisticas(caracter_decodificado);  // Actualizar estadísticas
}

"/" { 
    printf(" "); 
    cantidad_espacios++;
    total_palabras++;
}

" " { /* No h*/}

\n { printf("\n"); }

%%

int main(int argc, char** argv) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <código Morse>\n", argv[0]);
        return 1;
    }

    // Construir el texto completo a partir de los argumentos
    char input[4096] = ""; // Límite de 4096 caracteres
    for (int i = 1; i < argc; i++) {
        strcat(input, argv[i]);
        if (i < argc - 1) strcat(input, " "); // Añadir espacios entre argumentos
    }

    printf("======================================================\n");
    printf("Texto decodificado: ");
    // Pasar el texto completo al analizador léxico
    YY_BUFFER_STATE buffer = yy_scan_string(input);
    yylex();
    yy_delete_buffer(buffer);

    printf("\n======================================================");
    // Mostrar estadísticas
    printf("\n\t--- Estadisticas del texto codificado ---\n");
    printf("Longitud total del texto: %d caracteres\n", longitud);
    printf("Mayusculas: %d\n", cantidad_mayusculas);
    printf("Digitos: %d\n", cantidad_digitos);
    printf("Espacios: %d\n", cantidad_espacios);
    printf("Vocales: %d\n", total_vocales);
    printf("Palabras: %d\n", total_palabras);
    printf("Caracteres no alfanumericos: %d\n", cantidad_noalfa);

    return 0;
}
