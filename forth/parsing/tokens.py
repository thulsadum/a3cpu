from enum import Enum, auto


class LiteralRepresentation(Enum):
    DECIMAL = auto()
    HEX = auto()
    CHAR = auto()


class Token:
    pass



class AsmToken(Token):
    def __init__(self, asm):
        self.asm = asm

    def __str__(self):
        return self.asm


class LiteralToken(Token):
    def __init__(self, value, repr  = LiteralRepresentation.DECIMAL):
        self.value = value
        self.repr = repr

    def __str__(self):
        match self.repr:
            case LiteralRepresentation.DECIMAL:
                return f'push({self.value})'
            case LiteralRepresentation.HEX:
                return f'push({self.value:#04x})'
            case LiteralRepresentation.CHAR:
                return f'push("{ord(self.value)}")'



class WordToken(Token):
    def __init__(self, word):
        self.word = word

    def __str__(self):
        return f'{self.word}'


