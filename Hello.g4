/**
 * Define a grammar called Hello
 */
grammar Hello;
r  : test+ EOF;         // match keyword hello followed by an identifier

test: STRING (NEWLINE)*
	| vrhs
	;


vrhs: WHITESPACES? vrhs_content ( WHITESPACES vrhs_content )* NEWLINE ;
vrhs_content: funclet_without_parameter
				|funclet_regular 
				| multi_command_line
				| refrence
				| STRING
				;

refrence: AT refrence_name AT ;
refrence_name: STRING;

multi_command_line: command_line+ ;

command_line: MINUS command (WHITESPACES (command_following_parameters|command_splited_by_comma))*;
		
command_splited_by_comma: command_following_parameters (COMMA command_following_parameters)+;
command:STRING;
command_following_parameters: STRING;

//funclet section
funclet_regular:CONJUNCTION funclet_name LEFTPARENTHESE WHITESPACES? funclet_parameters (WHITESPACES? COMMA WHITESPACES? funclet_parameters)*? RIGHTPARENTHESE;
funclet_without_parameter:CONJUNCTION funclet_name LEFTPARENTHESE WHITESPACES? RIGHTPARENTHESE ;

funclet_name: string_with_colon
			| STRING
			;
funclet_parameters: WHITESPACES? DOUBLEQUOTATION WHITESPACES? parameter_content WHITESPACES? DOUBLEQUOTATION WHITESPACES?
					|WHITESPACES? DOUBLEQUOTATION WHITESPACES? DOUBLEQUOTATION WHITESPACES?
					|WHITESPACES? funclet_without_parameter WHITESPACES?
					|WHITESPACES? STRING WHITESPACES?
					;
parameter_content: command_line
					| funclet_without_parameter
					| STRING;
string_with_colon: STRING (COLONS STRING)+;


STRING: (WORDS)+;
//STRING_WITH_UNDERSCORES: (WORDS|UNDERSCORES)+;
STRING_WITH_REGULARSYMBOLS: (WORDS|REGULARSYMBOLS)+ ;
WORDS: (CHARS|NUMBERS|UNDERSCORES)+;
NUMBERS: (DIGITS|FLOATS)+;
//ID : [a-z]+ ;             // match lower-case identifiers

CHARS: [a-zA-Z]+;
DIGITS:[0-9]+;
FLOATS: [-+]?[0-9]*.?[0-9]+;

REGULARSYMBOLS: ['|.|#|/|<|>|$|%|+|^]+;
MINUS: '-'|'--';
CONJUNCTION: '&';
AT: '@';
DOUBLEQUOTATION: '\"';
LEFTPARENTHESE: '(';
RIGHTPARENTHESE: ')';
UNDERSCORES: [_]+;
WHITESPACES: [ ]+;
COLONS: [:]+;
EQUALMARK: '=';
COMMA:',';


NEWLINE: ('\r' ? '\n')+ ;
WS : [\t\s\w]+ -> skip ; // skip spaces, tabs, newlines
COMMENT: '#' ~[\r\n]* (EOF|'\r'? '\n')  -> skip;
EMPTY: NEWLINE -> skip;
EMPTYLINE: ('\r'?'\n') -> skip;
FORWARDSLASH:('\\')+ (EMPTYLINE)*-> skip;

