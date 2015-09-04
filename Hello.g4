/**
 * Define a grammar called Hello
 */
grammar Hello;
r  : test+ ;         // match keyword hello followed by an identifier

test: STRING (NEWLINE)*;


vrhs: ;
vrhs_content: ;

command_line: MINUS STRING ;

funclet_without_parameter: funclet_name LEFTPARENTHESE WHITESPACES? RIGHTPARENTHESE ;

funclet_name: CONJUNCTION STRING
					| CONJUNCTION string_with_colon
					;
string_with_colon: STRING (COLONS STRING)+;


STRING: (WORDS)+;
STRING_WITH_REGULARSYMBOLS: (WORDS|REGULARSYMBOLS)+ ;
WORDS: (CHARS|NUMBERS)+;
NUMBERS: (DIGITS|FLOATS)+;
//ID : [a-z]+ ;             // match lower-case identifiers

CHARS: [a-zA-Z]+;
DIGITS:[0-9]+;
FLOATS: [-+]?[0-9]*.?[0-9]+;

REGULARSYMBOLS: ['|.|#|/|<|>|$|%|+|^]+;
MINUS: '-'|'--';
CONJUNCTION: '&';
AT: '@';
DOUBLEQUOTATION: '"';
LEFTPARENTHESE: '(';
RIGHTPARENTHESE: ')';
UNDERSCORE: '_';
WHITESPACES: [ ]+;
COLONS: [:]+;

NEWLINE: ('\r' ? '\n')+ ;
WS : [\t\s\w]+ -> skip ; // skip spaces, tabs, newlines
COMMENT: '#' ~[\r\n]* (EOF|'\r'? '\n')  -> skip;
EMPTY: NEWLINE -> skip;
EMPTYLINE: '\r\n' -> skip;

