from enum import Enum, auto

class LiteralRepresentation(Enum):
    DECIMAL = auto()
    HEX = auto()
    CHAR = auto()


class Token:
    pass



class ParsingToken(Token):
    pass



class VariableToken(ParsingToken):

    def __str__(self):
        return f'; VARIABLE'


class CreateToken(ParsingToken):

    def __str__(self):
        return '; CREATE'



class SyntheticToken(Token):
    pass



class ControlFlowToken(Token):
    def __init__(self):
        self.symbol = None


class IfToken(ControlFlowToken):
    def __str__(self):
        return f'stia DSP\nlda DSP\ndec\nsta DSP\ninc\nlia\nbeq {self.symbol} ; IF'

class ElseToken(ControlFlowToken):

    def __init__(self):
        super().__init__()
        self.symbol2 = None

    def __str__(self):
        return f'bra {self.symbol2}\n{self.symbol}: ; ELSE'


class ThenToken(ControlFlowToken):

    def __str__(self):
        return f'{self.symbol}: ; THEN'

class SymbolTableToken(SyntheticToken):

    def __init__(self, size):
        self.size = size

    def __str__(self):
        return f'DICT: #res {self.size}\n.end:'


class SymbolReferenceToken(SyntheticToken):

    def __init__(self, symbol, offset):
        self.symbol = symbol
        self.offset = offset

    def __str__(self):
        return f'push({self.offset})\nadd DBP ; symbol: {self.symbol}'



class SymbolToken(Token):

    __match_args__ = ('symbol',)

    def __init__(self, symbol):
        self.symbol = symbol
        self.addr = None

    def __str__(self):
        return f'{self.addr:#04x}' if self.addr else f'; {self.symbol}'



class AsmToken(Token):
    def __init__(self, asm):
        self.asm = asm

    def __str__(self):
        return self.asm


class LiteralToken(Token):
    __match_args__ = ('value',)

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
                return f'push("{chr(self.value)}")'



class WordToken(Token):
    __match_args__ = ('word',)

    def __init__(self, word):
        self.word = word

    def __str__(self):
        return f'{self.word}'

    def __repr__(self):
        return f'WordToken("{self.word}")'
