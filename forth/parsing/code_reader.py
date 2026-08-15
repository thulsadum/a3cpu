import sys


class CodeReader:

    def __init__(self, args, file=None):
        self.args = args
        self.file = file if file else args.input_file

    def get_code(self):
        if self.file == '-':
            return sys.stdin.read()
        else:
            with open(self.file, 'r', encoding='utf-8') as file:
                return file.read()
