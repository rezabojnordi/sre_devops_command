# You are given a string  consisting only of digits 0-9, commas ,, and dots .

# Your task is to complete the regex_pattern defined below, which will be used to re.split() all of the , and . symbols in .

# It’s guaranteed that every comma and every dot in  is preceeded and followed by a digit.

# Sample Input 0

# 100,000,000.000

import re
def run(txt):
    text_reg = r'[,.]'
    result = re.split(text_reg,txt)
    return result



tmp = "100,000,000.000"
print("\n".join(run(tmp)))

