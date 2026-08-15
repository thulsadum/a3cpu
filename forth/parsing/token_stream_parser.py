
from .tokens import *

class TokenStreamParser:

    def __init__(self):
        self.symbols = {}
        self.offset = 0
        self.cf_count = 0
        self.cf = []


    def add_symbol(self, symbol, size = 1):
        self.symbols[symbol] = self.offset
        self.offset += size


    def has_symbol(self, symbol):
        return symbol in self.symbols


    def generate_control_flow_label(self,prefix="_",push=False):
        label = f'{prefix}{self.cf_count}'
        self.cf_count += 1
        if push:
            self.push_cf(label)
        return label


    def push_cf(self, label):
        self.cf.append(label)


    def pop_cf(self):
        return self.cf.pop()


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

                    case [IfToken() as tok]:
                        tok.symbol = self.generate_control_flow_label(prefix="__if_",push=True)

                    case [ElseToken() as tok]:
                        tok.symbol = self.pop_cf()
                        tok.symbol2 = self.generate_control_flow_label(prefix="__else_",push=True)

                    case [ThenToken() as tok]:
                        tok.symbol = self.pop_cf()

                    case [BeginToken() as tok]:
                        tok.symbol = self.generate_control_flow_label(prefix="__begin_",push=True)

                    case [UntilToken() as tok]:
                        tok.symbol = self.pop_cf()


            if not unresolved_symbols or i == max_passes-1:
                break

            tokens = result
            result = []


        result.insert(0, SymbolTableToken(len(self.symbols)))

        return result
