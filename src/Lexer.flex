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

Identificador = {Letra}({Letra}|{Digito})*

/* Número */
Numero = 0 | [1-9][0-9]*

%%

/* Comentarios o espacios en blanco */
{Comentario}|{EspacioEnBlanco} { /*Ignorar*/ }

/* Identificador y Palabras Reservadas de Java */
\{Identificador}|"if"|"else"|"while"|"for"|"switch"|"case"|"break"|"continue"|"return"|"do"|"try"|"catch"|"finally"|"throw"|"throws"|"class"|"interface"|"extends"|"implements"|"super"|"this"|"new"|"instanceof"|"true"|"false"|"null" { return token(yytext(), "IDENTIFICADOR", yyline, yycolumn); }



. { return token(yytext(), "ERROR", yyline, yycolumn); }
