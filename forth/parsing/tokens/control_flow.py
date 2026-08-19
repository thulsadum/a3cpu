from .base import Token


class ControlFlowToken(Token):
    def __init__(self, file, line, column):
        super().__init__(file, line, column)
        self.symbol = None


class IfToken(ControlFlowToken):
    pass


class ElseToken(ControlFlowToken):

    def __init__(self, file, line, column):
        super().__init__(file, line, column)
        self.symbol2 = None


class ThenToken(ControlFlowToken):
    pass


class BeginToken(ControlFlowToken):
    pass


class UntilToken(ControlFlowToken):
    pass

