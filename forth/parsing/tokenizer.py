from enum import Enum, auto


class TokenizerState(Enum):
    REGULAR = auto()
    ASSEMBLER = auto()
    CHARACTER = auto()

class Tokenizer:

    def __init__(self):
        self.state = TokenizerState.REGULAR

    def parse_code(self, code):
        tokens = code.split()
        return [ ltok for tok in tokens if (ltok := self.parse_token(tok)) ]

    def parse_token(self, token):
        if self.state is TokenizerState.REGULAR:
            if token.isdigit() or (token.startswith('-') and token[1:].isdigit()):
                return f'const({token})'
            elif token.upper().startswith("0X"):
                return f'const({token})'
            elif token.upper() == '[CHAR]':
                self.state = TokenizerState.CHARACTER
                return ''
            elif token.upper() == '[ASM':
                self.state = TokenizerState.ASSEMBLER
                return '[ASM'
            return token
        elif self.state is TokenizerState.ASSEMBLER:
            if token == ']':
                self.state = TokenizerState.REGULAR
            return token
        elif self.state is TokenizerState.CHARACTER:
            self.state = TokenizerState.REGULAR
            return f'const("{token}")'

