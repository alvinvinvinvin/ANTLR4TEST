/**
 * Define a grammar called Hello
 */
grammar Hello;
r  : file EOF;         // match keyword hello followed by an identifier

file: section_body
	;

/**
 * Section rules
 * 
 * Sections are the basic elements of INI file. 
 * It contains section name and section body.
 */

/**
 * Section name
 */

/**
 * Section body
 * 
 * Basically section body is consisted by Key-Value pairs
 */

section_body: kv_pair*;

/**
 * Key-Value pair
 */

kv_pair: WHITESPACES? key WHITESPACES? EQUALSIGN WHITESPACES? vrhs WHITESPACES?;
doublequotation_kv_pair:DOUBLEQUOTATION kv_pair DOUBLEQUOTATION;

/**
 * Key
 * 
 * The left hand side element of Key-Value pair
 */
key:key_head WHITESPACES? COLON WHITESPACES? key_parameter
	|key_head
	;
key_head:(STRING|NUMBERS);
key_parameter:(STRING|NUMBERS);
/**
 * Value
 * 
 * The right hand side element of Key-Value pair
 */
vrhs: vrhs_content ( WHITESPACES vrhs_content )*;
vrhs_content: kv_pair
			|doublequotation_kv_pair
			|funclet_without_parameter
			|funclet_regular 
			|http_link
			| command_line
			| multi_command_line
			| quotation
			|STRING_WITH_REGULARSYMBOLS
			| (STRING|NUMBERS)
			;

/**
 * http link
 */

http_link:HTTP_LINK;

/**
 * Quotation
 */
quotation: AT quotation_name AT ;
quotation_name: (STRING|NUMBERS);

/**
 * Command line
 */
multi_command_line: command_line+ ;

command_line: MINUS_OR_DOUBLEMINUS command (WHITESPACES (command_following_parameters|command_splited_by_comma))*;
		
command_splited_by_comma: command_following_parameters (COMMA command_following_parameters)+;
command:(STRING|NUMBERS);
command_following_parameters: (STRING|NUMBERS);


/**
 * Funclet
 * 
 * Funclet is the most special feature of MTT configuration file comparing to
 * regular INI file we see in common. It basically looks like function with parameters.
 * However it includes more special syntax elements than structure of regular
 * functions we see in JAVA.
 * 
 */
funclet_regular:CONJUNCTION funclet_name LEFTPARENTHESE WHITESPACES? funclet_parameters (WHITESPACES? COMMA WHITESPACES? funclet_parameters)* WHITESPACES? RIGHTPARENTHESE;
funclet_without_parameter:CONJUNCTION funclet_name LEFTPARENTHESE WHITESPACES? RIGHTPARENTHESE ;

funclet_name: string_with_colon
			| (STRING|NUMBERS)
			;
funclet_parameters: funclet_regular math_formula*
					|funclet_without_parameter math_formula*
					|parameter_doublequotation
					|(STRING|NUMBERS)
					;
parameter_doublequotation: DOUBLEQUOTATION WHITESPACES? parameter_content? (WHITESPACES parameter_content)* WHITESPACES? DOUBLEQUOTATION;

parameter_content: command_line
					| funclet_without_parameter
					| (STRING|NUMBERS)
					;
/**
 * Useful parser rules
 */
string_with_colon: (STRING|NUMBERS) (DOUBLECOLONS (STRING|NUMBERS))+;
math_formula:WHITESPACES? MATH_OPERATORS WHITESPACES? NUMBERS;
test_number:STRING;
test_digit:NUMBERS;

/**
 * Lexer rules
 * */
/**
 * Character rules
 * 
 */
STRING: (CHAR|UNDERSCORES)+;
STRING_WITH_REGULARSYMBOLS: (CHAR|REGULARSYMBOLS)+ ;
//WORDS: (CHAR|NUMBERS)+;
NUMBERS: (DIGIT|FLOAT)+;
HTTP_LINK:HTTP_HEAD ~[\r\n]* (EOF|'\r'? '\n');

fragment HTTP_HEAD:'http://';
fragment CHAR: [a-zA-Z];
DIGIT:[0-9];
FLOAT: [-+]?[0-9]*'.'?[0-9]+;


/**
 * Symbol rules
 */
REGULARSYMBOLS: ['|<|>|$|^]+;
fragment PLUS:'+';
fragment STAR:'*';
fragment PERCENTAGE:'%';
fragment BACKWARD_SLASH:'/';
fragment DOT:'.';
fragment UNDERSCORES: [_]+;
fragment SLASH_DOUBLEQUOTATION:'\"';
fragment ESCAPED_DOUBLEQUOTATION:'\\"';

/**
 * Mathematical operators
 */
MATH_OPERATORS:PLUS|MINUS|STAR|PERCENTAGE;

MINUS_OR_DOUBLEMINUS: MINUS|DOUBLE_MINUS;
MINUS: '-';
DOUBLE_MINUS:'--';
CONJUNCTION: '&';
AT: '@';
DOUBLEQUOTATION: '"';
LEFTPARENTHESE: '(';
RIGHTPARENTHESE: ')';
WHITESPACES: [ |\t]+;
COLON: ':';
DOUBLECOLONS:'::';
EQUALSIGN: '=';
COMMA:',';


/**
 * New line symbol
 */
NEWLINE: ('\r' ? '\n')+ ;


/**
 * Skips
 */
COMMENT: '#' ~[\r\n]* (EOF|'\r'? '\n')  -> skip;
FORWARDSLASH:'\\' WHITESPACES? NEWLINE WHITESPACES?-> skip;

