#!/bin/python3

import math
import os
import random
import re
import sys



if __name__ == '__main__':
    n = int(input().strip())
    check = {True: "Not Weird", False: "Weird"}
    print(check[n%2==0 and (
        n in range(2,6) or n > 20
    )])

