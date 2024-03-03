import compilerTools.Token;

%%
%class Lexer
%type Token
%line
%column
%{
    private Token token(String lexeme, String lexicalComp, int line, int column){
        return new Token(lexeme, lexicalComp, line+1, column+1);
    }
%}
/* Variables básicas de comentarios y espacios */
TerminadorDeLinea = \r|\n|\r\n
EntradaDeCaracter = [^\r\n]
EspacioEnBlanco = {TerminadorDeLinea} | [ \t\f]
ComentarioTradicional = "/*" [^*] ~"*/" | "/*" "*"+ "/"
FinDeLineaComentario = "//" {EntradaDeCaracter}* {TerminadorDeLinea}?
ContenidoComentario = ( [^*] | \*+ [^/*] )*
ComentarioDeDocumentacion = "/**" {ContenidoComentario} "*"+ "/"

/* Comentario */
Comentario = {ComentarioTradicional} | {FinDeLineaComentario} | {ComentarioDeDocumentacion}

/* Identificador y Palabras Reservadas de Java */
Letra = [A-Za-zÑñ_]
Digito = [0-9] 

/* Cadena de caracteres */
Cadena = "\"" [^\"]* "\""

Identificador = {Letra}({Letra}|{Digito})*

/* Número */
Numero = 0 | [1-9][0-9]*

/* Tipo de Dato */
TipoDato = byte|short|int|long|float|double|char|boolean


%%

/* Comentarios o espacios en blanco */
{Comentario}|{EspacioEnBlanco} { /*Ignorar*/ }

/* Identificador y Palabras Reservadas de Java */
\{PALABRA_RESERVADA}|"if"|"else"|"while"|"for"|"switch"|"case"|"break"|"continue"|"return"|"do"|"try"|"catch"|"finally"|"throw"|"throws"|
"class"|"interface"|"extends"|"implements"|"super"|"this"|"new"|"instanceof"|"true"|"false"|"null"
|"public"|"main"|"class"|"static"|"void"|"args"|"BufferedReader"|"InputStreamReader"|"System"
|"input"|"out"|"println"|"Matcher"|"print"|"IOException"|"find" { return token(yytext(), "IDENTIFICADOR", yyline, yycolumn); }

/* Tipo de Dato */
byte|short|int|long|float|double|char|boolean|String {return token(yytext(), "TIPO_DATO", yyline, yycolumn);}

/* Número */
{Numero} { return token(yytext(), "NUMERO", yyline, yycolumn); }

/* Operadores de Agrupación */
"(" {return token(yytext(), "PARENTESIS_ABRE", yyline, yycolumn);}
")" {return token(yytext(), "PARENTESIS_CIERRA", yyline, yycolumn);}
"{" {return token(yytext(), "LLAVE_ABRE", yyline, yycolumn);}
"}" {return token(yytext(), "LAVVE_CIERRA", yyline, yycolumn);}
"[" {return token(yytext(), "CORCHETE_CIERRA", yyline, yycolumn);}
"]" {return token(yytext(), "CORCHETE_CIERRA", yyline, yycolumn);}

/* Signos Puntuación */
"," {return token(yytext(), "COMA", yyline, yycolumn);}
";" {return token(yytext(), "PUNTO_COMA", yyline, yycolumn);}
"." {return token(yytext(), "PUNTO", yyline, yycolumn);}

/* Operadores */
"+"|"-"|"*"|"/" {return token(yytext(), "OPERADOR_ARIT", yyline, yycolumn);}

/* Nombre de la Clase */
 "class" {EspacioEnBlanco}+ {Identificador} {
    return token(yytext().substring(6).trim(), "NOMBRE_CLASE", yyline, yycolumn);
}

/* Construcción de Objetos */
{Identificador} {EspacioEnBlanco}* "=" {EspacioEnBlanco}* "new" {EspacioEnBlanco} + {Identificador} {
    return token(yytext(), "CONSTRUCCION_OBJETO", yyline, yycolumn);
}

/* Construcción de Objetos 1 */
{Identificador} {EspacioEnBlanco}* "=" {EspacioEnBlanco}*{EspacioEnBlanco} + {Identificador} {
    return token(yytext(), "CONSTRUCCION_OBJETO", yyline, yycolumn);
}
/* Ignorar cadenas dentro de comillas */
{Cadena} { /*Ignorar*/ }

/* Capturar lo que está después del '=' en una asignación */
{Identificador} {EspacioEnBlanco}* "=" {EspacioEnBlanco}* {EntradaDeCaracter}+ {
    return token(yytext().substring(yytext().indexOf("=") + 1).trim(), "ASIGNACION_DER", yyline, yycolumn);
}

/* Funciones de Impresión */
"System.out.println" {EspacioEnBlanco}* "(" {EntradaDeCaracter}* ")" {
    return token("System.out.println", "FUNCION_IMPRIMIR", yyline, yycolumn);
}




. { return token(yytext(), "ERROR", yyline, yycolumn); }
