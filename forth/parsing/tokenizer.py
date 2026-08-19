from .tokens import *
import semantics
from error import MissingClosingCommentError

class Tokenizer:


    def __init__(self, file):
        self.symbols = []
        self.file = file
        self.line = 0
        self.column = 0
        self.buf_len = 0
        self.buf_lines = 0

    def _parse_asm(self, buf):
        return buf.split(sep=']', maxsplit=1)


    def update_pos(self, buf):
        if (l := buf.count('\n')) < self.buf_lines:
            self.column = 0
            self.line += self.buf_lines - l
            self.buf_lines = l
            self.buf_len = len(buf)
        else:
            self.column += self.buf_len - len(buf)
            self.buf_len = len(buf)

    def next(self, buf, tokens = []):

        if len(buf.lstrip()) == 0:
            return (None, '')

        buf = buf.lstrip()
        self.update_pos(buf)

        if buf[0] == '\\':
            # line comment
            if (pos:=buf.find('\n')) > 0:
                return self.next(buf[pos:],tokens)
            else:
                return (None, '')
        elif buf[0] == '(':
            # inline comment
            if (pos:=buf.find(')')) > 0:
                return self.next(buf[pos+1:],tokens)

            else:
                raise MissingClosingCommentError(self.file, self.line, self.column)

        elif buf[0] == '[':

            if buf.startswith("[ASM "):
                (tok, rest) = self._parse_asm(buf[5:])
                return (AsmToken(tok, self.file, self.line, self.column), rest)
            elif buf.startswith("[CHAR] "):
                (tok, rest) = buf.split(maxsplit=2)[1:]
                return (LiteralToken(ord(tok[0]), self.file, self.line, self.column, repr = LiteralRepresentation.CHAR), rest)

        elif buf[0] == '"':
            pass # string parsing

        else:
            res = buf.split(maxsplit=1)
            tok = res[0]
            rest = ''

            if len(res) != 1:
                rest = res[1]

            return (self.parse_token(tok, tokens), rest)



    def parse_code(self, code):
        tokens = []

        self.buf_len = len(code)
        self.buf_lines = code.count('\n')
        while True:
            (tok, code) = self.next(code, tokens)
            self.update_pos(code)
            if tok is None:
                break
            tokens.append(tok)


        return tokens


    def parse_literal(self, token, tokens):
        if token.isdigit() or (token.startswith('-') and token[1:].isdigit()):
            return LiteralToken(int(token), self.file, self.line, self.column)
        elif token.upper().startswith("0X"):
            return LiteralToken( int(token,base=16), self.file, self.line, self.column, repr=LiteralRepresentation.HEX)
        return None


    def parse_parsing_token(self, token, tokens):
        if token.upper() == "VARIABLE":
            return VariableToken(self.file, self.line, self.column)
        elif token.upper() == "CONSTANT":
            return ConstantToken(self.file, self.line, self.column)
        elif token.upper() == "CREATE":
            return CreateToken(self.file, self.line, self.column)
        elif token.upper() == "REQUIRE":
            return RequireToken(self.file, self.line, self.column)
        elif token.upper() == ":":
            return ColonToken(self.file, self.line, self.column)
        elif token.upper() == ";":
            return SemicolonToken(self.file, self.line, self.column)
        elif token in self.symbols:
            return SymbolToken(token)
        return None


    def parse_control_flow_token(self, token, tokens):
        match token.upper():
            case 'IF': return IfToken(self.file, self.line, self.column)
            case 'ELSE': return ElseToken(self.file, self.line, self.column)
            case 'THEN': return ThenToken(self.file, self.line, self.column)
            case 'BEGIN': return BeginToken(self.file, self.line, self.column)
            case 'UNTIL': return UntilToken(self.file, self.line, self.column)
            case _: return None



    def parse_core_word(self, token, tokens):
        if token.upper() in semantics.words.CORE:
            return CoreWordToken(token.upper(), self.file, self.line, self.column)


    def parse_token(self, token, tokens):

        rules = [self.parse_literal, self.parse_parsing_token, self.parse_control_flow_token, self.parse_core_word]

        for r in rules:

            if ret := r(token, tokens):

                return ret

        return SymbolToken(token, self.file, self.line, self.column)


