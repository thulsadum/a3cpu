
from .tokens import *

class TokenStreamParser:

    def __init__(self):
        self.symbols = {}
        self.offset = 0

    def add_symbol(self, symbol, size = 1):
        self.symbols[symbol] = self.offset
        self.offset += size

    def has_symbol(self, symbol):
        return symbol in self.symbols

    def parse(self, tokens):
        max_passes = 5
        result = []
        unresolved_symbols = False

        for i in range(max_passes):

            for token in tokens:

                result.append(token)

                match result[-2:]:
                    case [VariableToken(), SymbolToken(symbol)]:
                        self.add_symbol(symbol)
                        result[-2:] = []
                    case [CreateToken(), SymbolToken(symbol)]:
                        self.add_symbol(symbol, size = 0)
                        result[-2:] = []
                    case [LiteralToken(size) as lt, WordToken("CELLS")]:
                        result[-2:] = [lt]
                    case [LiteralToken(size), WordToken("ALLOT")]:
                        self.offset += size
                        result[-2:] = []

                match result[-1:]:
                    case [SymbolToken(symbol)]:
                        if self.has_symbol(symbol):
                            result[-1:] = [ SymbolReferenceToken(symbol, self.symbols[symbol]) ]
                        else:
                            unresolved_symbols = True

            if not unresolved_symbols or i == max_passes-1:
                break

            tokens = result
            result = []


        result.insert(0, SymbolTableToken(len(self.symbols)))

        return result
