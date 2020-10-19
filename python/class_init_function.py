class Rectangle:
    def __init__(self,width,height):
        self.width = width
        self.height = height
    def area(self):
        return self.width * self.height
    
    def perimeter(self):
        return 2 * (self.width + self.height)


r1 = Rectangle(10,20)
print(r1.area())
print(r1.perimeter())

print(str(r1))
print(hex(id(r1)))