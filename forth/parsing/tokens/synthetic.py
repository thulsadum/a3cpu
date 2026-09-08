from .base import Token

class SyntheticToken(Token):
    pass


class DefinitionToken(SyntheticToken):
    __match_args__ = ('symbol',)

    def __init__(self, symbol, file, line, column, token=None):
        self.symbol = symbol
        self.token = token if token else f'xt_{symbol}'
        self.tokens = []

    def add_token(self, token):
        self.tokens.append(token)

    def __repr__(self):
        return f'DefinitionToken({self.symbol}, token={self.token})'


class SymbolTableToken(SyntheticToken):

    def __init__(self, size, file, line, column):
        super().__init__(file, line, column)
        self.size = size


class SymbolReferenceToken(SyntheticToken):

    def __init__(self, symbol, offset, file, line, column):
        super().__init__(file, line, column)
        self.symbol = symbol
        self.offset = offset


class ConstantReferenceToken(SyntheticToken):
    __match_args__ = ('symbol',)

    def __init__(self, symbol, value, file, line, column):
        super().__init__(file, line, column)
        self.symbol = symbol
        self.value= value


class RuntimeConstantDefinitionToken(ConstantReferenceToken):
    __match_args__ = ('symbol',)

    def __init__(self, symbol, addr, file, line, column):
        super().__init__(symbol, addr, file, line, column)


class RuntimeConstantReferenceToken(ConstantReferenceToken):
    __match_args__ = ('symbol',)

    def __init__(self, symbol, addr, file, line, column):
        super().__init__(symbol, addr, file, line, column)


class CustomWordToken(SyntheticToken):
    __match_args__ = ('word',)

    def __init__(self, word, file, line, column, token=None):
        self.word = word
        self.token = token if token else word

    def __repr__(self):
        return f'CustomWordToken("{self.word}")'


class CommentToken(SyntheticToken):
    __match_args__ = ('comment',)
    def __init__(self, comment, file, line, column):
        self.comment = comment

