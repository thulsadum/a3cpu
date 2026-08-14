
from .tokens import *

class TokenStreamParser:

    def __init__(self):
        self.symbols = {}

    def add_symbol(self, symbol):
        self.symbols[symbol] = len(self.symbols)

    def has_symbol(self, symbol):
        return symbol in self.symbols

    def parse(self, tokens):

        result = []
        unresolved_symbols = False

        for i in range(2):

            for token in tokens:

                result.append(token)

                match result[-2:]:
                    case [VariableToken(), SymbolToken(symbol)]:
                        self.add_symbol(symbol)
                        result[-2:] = []

                match result[-1:]:
                    case [SymbolToken(symbol)]:
                        if self.has_symbol(symbol):
                            result[-1:] = [ SymbolReferenceToken(symbol, self.symbols[symbol]) ]
                        else:
                            unresolved_symbols = True

            if not unresolved_symbols:
                break

            tokens = result
            result = []


        result.insert(0, SymbolTableToken(len(self.symbols)))

        return result
