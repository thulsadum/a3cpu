from .base import Token


class ParsingToken(Token):
    def __init__(self, file, line, column):
        super().__init__(file,line,column)
        self.has_arg = True



class VariableToken(ParsingToken):
    pass


class ConstantToken(ParsingToken):
    pass


class CreateToken(ParsingToken):
    pass


class RequireToken(ParsingToken):
    pass


class ColonToken(ParsingToken):

    def __init__(self,file,line,column):
        super().__init__(file,line,column)
        self.symbol = None
        self.program = []



class SemicolonToken(ParsingToken):

    def __init__(self,file,line,column):
        super().__init__(file,line,column)
        self.has_arg = False

