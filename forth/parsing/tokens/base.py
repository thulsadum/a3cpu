

class Token:

    def __init__(self, file, line, column):
        self.has_arg = False
        self.file = file
        self.line = line
        self.column = column



class SymbolToken(Token):

    __match_args__ = ('symbol',)

    def __init__(self, symbol, file, line, column):
        super().__init__(file, line, column)
        self.symbol = symbol

    def __repr__(self):
        base = super().__repr__()
        base = base[:-1] + f" {self.symbol}>"
        return base



class AsmToken(Token):
    __match_args__ = ('asm',)
    def __init__(self, asm, file, line, column):
        super().__init__(file, line, column)
        self.asm = asm



class CoreWordToken(Token):
    __match_args__ = ('word',)

    def __init__(self, word, file, line, column):
        super().__init__(file, line, column)
        self.word = word

    def __str__(self):
        return f'{self.word}'

    def __repr__(self):
        return f'WordToken("{self.word}")'


