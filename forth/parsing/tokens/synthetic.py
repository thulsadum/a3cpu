from .base import Token

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


class SymbolTableToken(SyntheticToken):

    def __init__(self, size):
        super().__init__()
        self.size = size


class SymbolReferenceToken(SyntheticToken):

    def __init__(self, symbol, offset):
        super().__init__()
        self.symbol = symbol
        self.offset = offset


class CustomWordToken(SyntheticToken):
    __match_args__ = ('word',)

    def __init__(self, word, token=None):
        self.word = word
        self.token = token if token else word

    def __repr__(self):
        return f'CustomWordToken("{self.word}")'


class CommentToken(SyntheticToken):
    __match_args__ = ('comment',)
    def __init__(self, comment):
        self.comment = comment

