from semantics import words
from parsing.tokens import *

class Ac3puGenerator:

    def __init__(self):
        self.definitions = {}

    def gen_definition(self, dt : DefinitionToken) -> str:
        # TO DO add function pro-/epilogue
        return f""";; definition of `{dt.symbol}`
  {dt.token}: #res 1
{self.generate(dt.tokens, emit_definitions=False)}
  ret {dt.token}
  ;; end of definition of `{dt.symbol}`
                """

    def gen_if(self, tok : IfToken) -> str:
        return f"""; IF
beq {tok.symbol}_goto_false
drop
bra {tok.symbol}_true_branch
{tok.symbol}_goto_false:
drop
bra {tok.symbol}
{tok.symbol}_true_branch:"""


    def gen_else(self, tok : ElseToken) -> str:
        return f"""; ELSE
bra {tok.symbol2}
{tok.symbol}:"""


    def gen_then(self, tok : ThenToken) -> str:
        return f"""; THEN
{tok.symbol}:"""


    def gen_begin(self, tok : BeginToken) -> str:
        return f"""; BEGIN
{tok.symbol}:"""


    def gen_until(self, tok : UntilToken) -> str:
        return f"""; UNTIL
beq {tok.symbol}_again
drop
bra {tok.symbol}_leave
{tok.symbol}_again:
drop
bra {tok.symbol}
{tok.symbol}_leave:"""


    def gen_symbol_table(self, tok : SymbolTableToken) -> str:
        return f""" ;; dictionary
DICT: #res {tok.size}
.end:"""


    def gen_symbol_reference(self, tok : SymbolReferenceToken) -> str:
        return f'''; calculating reference of {tok.symbol}
push({tok.offset})
add DBP'''


    def gen_literal(self, tok : LiteralToken) -> str:
        match tok.repr:
            case LiteralRepresentation.DECIMAL:
                return f'''; DECIMAL
push({tok.value})'''
            case LiteralRepresentation.HEX:
                return f'''; HEX
push({tok.value:#04x})'''
            case LiteralRepresentation.CHAR:
                return f'''; CHAR
push("{chr(tok.value)}")'''


    def gen_constant_reference(self, tok : ConstantReferenceToken) -> str:
        return f'''; CONSTANT {tok.symbol} = {tok.value}
push({tok.value})'''


    def gen_tok(self, token):
        match token:
            case CommentToken(comment):
                return f'; {comment}'
            case AsmToken(asm):
                return f'; [ASM\n{asm}\n; ]'

            case LiteralToken() as tok:
                return self.gen_literal(tok)

            case WordToken(word):
                word = words.CORE[str(word).upper()]
                return f"; {word.word}\n{word.asm}"

            case CustomWordToken(word) as tok:
                return f"; {word}\njal {tok.token}"

            case IfToken() as tok:
                return self.gen_if(tok)
            case ElseToken() as tok:
                return self.gen_else(tok)
            case ThenToken() as tok:
                return self.gen_then(tok)

            case BeginToken() as tok:
                return self.gen_begin(tok)
            case UntilToken() as tok:
                return self.gen_until(tok)

            case DefinitionToken(symbol) as dt:
                self.definitions[symbol] = self.gen_definition(dt)
                return ''
            case SymbolTableToken() as stt:
                return self.gen_symbol_table(stt)
            case SymbolReferenceToken() as srt:
                return self.gen_symbol_reference(srt)
            case ConstantReferenceToken() as crt:
                return self.gen_constant_reference(crt)

            case token:
                # TO DO emit error
                return f'ERROR_{token}'

    def generate(self, tokens, emit_definitions=True):
        asm = [ self.gen_tok(tok) for tok in tokens ]
        if emit_definitions:
            asm.extend(self.definitions.values())
        return "\n".join(asm)

