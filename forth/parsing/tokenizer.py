from .tokens import *


class Tokenizer:



    def __init__(self):
        pass


    def _parse_asm(self, buf):
        return buf.split(sep=']', maxsplit=1)



    def next(self, buf):

        if len(buf.lstrip()) == 0:
            return (None, '')

        buf = buf.lstrip()

        if buf[0] == '[':

            if buf.startswith("[ASM "):
                (tok, rest) = self._parse_asm(buf[5:])
                return (AsmToken(tok), rest)

        elif buf[0] == '"':
            pass # string parsing

        else:
            res = buf.split(maxsplit=1)
            tok = res[0]
            rest = ''

            if len(res) != 1:
                rest = res[1]

            return (self.parse_token(tok), rest)



    def parse_code(self, code):
        tokens = []

        while True:
            (tok, code) = self.next(code)
            if tok is None:
                break
            tokens.append(tok)


        return tokens

    def parse_token(self, token):
        if token.isdigit() or (token.startswith('-') and token[1:].isdigit()):
            return LiteralToken(int(token))
        elif token.upper().startswith("0X"):
            return LiteralToken( int(token,base=16), repr=LiteralRepresentation.HEX)
        else:
            return WordToken(token)


