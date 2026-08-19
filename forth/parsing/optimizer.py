from .tokens import *

class Optimizer:

    def __init__(self, args):
        self.passes = args.optimize

    def optimize(self, tokens):

        result = tokens

        for i in range(self.passes):

            result = []

            for token in tokens:

                result.append(token)

                match result[-3:]:
                    case [LiteralToken(a), LiteralToken(b, file=f, line=l, column=c), CoreWordToken("+")]:
                        result[-3:] = [LiteralToken(a+b, f, l, c)]
                    case [LiteralToken(a), LiteralToken(b, file=f, line=l, column=c), CoreWordToken("-")]:
                        result[-3:] = [LiteralToken(a-b, f, l, c)]
                    case [LiteralToken(a), LiteralToken(b, file=f, line=l, column=c), CoreWordToken("SHL")]:
                        result[-3:] = [LiteralToken(a<<b, f, l, c)]
                    case [LiteralToken(a), LiteralToken(b, file=f, line=l, column=c), CoreWordToken("SHR")]:
                        result[-3:] = [LiteralToken(a>>b, f, l, c)]
                    case [LiteralToken(a), LiteralToken(b, file=f, line=l, column=c), CoreWordToken("AND")]:
                        result[-3:] = [LiteralToken(a & b, f, l, c)]
                    case [LiteralToken(a), LiteralToken(b, file=f, line=l, column=c), CoreWordToken("OR")]:
                        result[-3:] = [LiteralToken(a | b, f, l, c)]
                    case [LiteralToken(a), LiteralToken(b, file=f, line=l, column=c), CoreWordToken("XOR")]:
                        result[-3:] = [LiteralToken(a ^ b, f, l, c)]

            tokens = result

        return result

