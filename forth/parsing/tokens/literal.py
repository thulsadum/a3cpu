from enum import Enum, auto

from .base import Token


class LiteralRepresentation(Enum):
    DECIMAL = auto()
    HEX = auto()
    CHAR = auto()


class LiteralToken(Token):
    __match_args__ = ('value',)

    def __init__(self, value, repr  = LiteralRepresentation.DECIMAL):
        super().__init__()
        self.value = value
        self.repr = repr


