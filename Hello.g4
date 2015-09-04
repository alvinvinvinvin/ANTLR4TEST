/**
 * Define a grammar called Hello
 */
grammar Hello;
r  : test+ ;         // match keyword hello followed by an identifier

test: STRING (NEWLINE)*;


vrhs: WHITESPACES? vrhs_content ( WHITESPACES vrhs_content )*? WHITESPACES? ;
vrhs_content: funclet_without_parameter
					| multi_command_line
					| refrence
					| STRING
					| STRING_WITH_UNDERSCORES ;

refrence: AT (STRING|STRING_WITH_UNDERSCORES) AT ;

multi_command_line: command_line+ ;

command_line: MINUS STRING ;

funclet_without_parameter: funclet_name LEFTPARENTHESE WHITESPACES? RIGHTPARENTHESE ;

funclet_name: CONJUNCTION (STRING|STRING_WITH_UNDERSCORES)
					| CONJUNCTION string_with_colon
					;
string_with_colon: (STRING|STRING_WITH_UNDERSCORES) (COLONS (STRING|STRING_WITH_UNDERSCORES))+;


STRING: (WORDS)+;
STRING_WITH_UNDERSCORES: (WORDS|UNDERSCORES)+;
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
UNDERSCORES: [_]+;
WHITESPACES: [ ]+;
COLONS: [:]+;

NEWLINE: ('\r' ? '\n')+ ;
WS : [\t\s\w]+ -> skip ; // skip spaces, tabs, newlines
COMMENT: '#' ~[\r\n]* (EOF|'\r'? '\n')  -> skip;
EMPTY: NEWLINE -> skip;
EMPTYLINE: '\r\n' -> skip;

