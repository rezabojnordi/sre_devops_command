class Rectangle:
    def __init__(self,width,height):
        self.width = width
        self.height = height
    def area(self):
        return self.width * self.height
    
    def perimeter(self):
        return 2 * (self.width + self.height)
    
    # def to_string(self):
    #     return "width={0},height={1}".format(self.width,self.height)
    def __str__(self):
        return "width={0},height={1}".format(self.width,self.height)

    def __repr__(self):
        return "width={0},height={1}".format(self.width,self.height)

    def __eq__(slef,other):
        if isinstance(other,Rectangle):
            return slef.width == other.width and slef.height == other.height
        else:
            return False
    def __lt__(self,other):
        if isinstance(other,Rectangle):
            return self.area() < other.area()
        else:
            return NotImplemented



r1 = Rectangle(10,20)
r2 = Rectangle(10,20)

# print(r1.to_string())

print(str(r1))
print(r1)


is_not = r1 is not r2
print(is_not)

equal = r1 == r2
print(equal)

equal1 = r1 ==100
print(equal1)


#------------------lt--------------------
r1 = Rectangle(10,20)
r2 = Rectangle(100,20)

tr = r1 < r2
print("lt",tr)