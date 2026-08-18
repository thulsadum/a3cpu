import sys
from pathlib import Path

class CodeReader:

    def __init__(self, args, file=None):
        self.args = args
        self.file = file if file else args.input_file


    def resolve(self, file : str) -> Path:
        if (f := Path(file)).is_absolute():
            return f

        paths = []
        if self.args.input_file != '-':
            paths.append(Path(self.args.input_file).parent)
        paths.append(Path())

        for path in paths:
            candidate = path / file
            if candidate.exists():
                return candidate


    def get_code(self):
        if self.file == '-':
            return sys.stdin.read()
        else:
            return self.resolve(self.file).read_text(encoding='utf-8')
