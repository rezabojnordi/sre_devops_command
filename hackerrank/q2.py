# Task
# Given an integer, , perform the following conditional actions:

# If  is odd, print Weird
# If  is even and in the inclusive range of 2  to 5, print Not Weird
# If  is even and in the inclusive range of  6 to 20 , print Weird
# If  is even and greater than 20, print Not Weird
# Input Format

# A single line containing a positive integer, n

# Constraints

# 1 =< n =<100

def check_number(n):
    if n % 2 != 0:
        print("weird")
    else:
        if n in range(2,6):
            print("Not weird")
        elif n in range(6,21):
            print("weird")
        else:
            print("Not Weird")

n = int(input())

check_number(n)



    
