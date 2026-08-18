from enum import Enum, auto

class LiteralRepresentation(Enum):
    DECIMAL = auto()
    HEX = auto()
    CHAR = auto()


class Token:

    def __init__(self):
        self.has_arg = False


class ParsingToken(Token):
    def __init__(self):
        self.has_arg = True



class VariableToken(ParsingToken):
    pass


class CreateToken(ParsingToken):
    pass


class RequireToken(ParsingToken):
    pass


class ColonToken(ParsingToken):

    def __init__(self):
        super().__init__()
        self.symbol = None
        self.program = []



class SemicolonToken(ParsingToken):

    def __init(self):
        self.has_arg = False



class SyntheticToken(Token):
    pass


class DefinitionToken(SyntheticToken):
    __match_args__ = ('symbol',)

    def __init__(self, symbol, token=None):
        self.symbol = symbol
        self.token = token if token else f'xt_{symbol}'
        self.tokens = []

    def add_token(self, token):
        self.tokens.append(token)

    def __repr__(self):
        return f'DefinitionToken({self.symbol}, token={self.token})'



class ControlFlowToken(Token):
    def __init__(self):
        super().__init__()
        self.symbol = None


class IfToken(ControlFlowToken):
    pass


class ElseToken(ControlFlowToken):

    def __init__(self):
        super().__init__()
        self.symbol2 = None


class ThenToken(ControlFlowToken):
    pass


class BeginToken(ControlFlowToken):
    pass


class UntilToken(ControlFlowToken):
    pass


class SymbolTableToken(SyntheticToken):

    def __init__(self, size):
        super().__init__()
        self.size = size


class SymbolReferenceToken(SyntheticToken):

    def __init__(self, symbol, offset):
        super().__init__()
        self.symbol = symbol
        self.offset = offset



class SymbolToken(Token):

    __match_args__ = ('symbol',)

    def __init__(self, symbol):
        super().__init__()
        self.symbol = symbol

    def __repr__(self):
        base = super().__repr__()
        base = base[:-1] + f" {self.symbol}>"
        return base


class AsmToken(Token):
    __match_args__ = ('asm',)
    def __init__(self, asm):
        super().__init__()
        self.asm = asm



class LiteralToken(Token):
    __match_args__ = ('value',)

    def __init__(self, value, repr  = LiteralRepresentation.DECIMAL):
        super().__init__()
        self.value = value
        self.repr = repr



class WordToken(Token):
    __match_args__ = ('word',)

    def __init__(self, word):
        super().__init__()
        self.word = word

    def __str__(self):
        return f'{self.word}'

    def __repr__(self):
        return f'WordToken("{self.word}")'


class CustomWordToken(SyntheticToken):
    __match_args__ = ('word',)

    def __init__(self, word, token=None):
        self.word = word
        self.token = token if token else word

    def __repr__(self):
        return f'CustomWordToken("{self.word}")'

