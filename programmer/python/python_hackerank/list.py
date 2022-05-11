# if __name__ == '__main__':
#     x,y,z,n = int(input()),int(input()),int(input()),int(input())
#     print ([[a,b,c] for a in range(0,x+1) for b in range(0,y+1) for c in range(0,z+1) if a + b + c != n ])
if __name__ == '__main__':
    ans=[]
    x=int(input())
    y=int(input())
    z=int(input())
    n=int(input())
    for i in range(0,x+1):
        for j in range(0,y+1):
            for k in range(0,z+1):
                if(i+j+k !=n):
                    ans.append([i,j,k])
    print(ans)
