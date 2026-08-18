

class Token:

    def __init__(self):
        self.has_arg = False



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



class WordToken(Token):
    __match_args__ = ('word',)

    def __init__(self, word):
        super().__init__()
        self.word = word

    def __str__(self):
        return f'{self.word}'

    def __repr__(self):
        return f'WordToken("{self.word}")'


