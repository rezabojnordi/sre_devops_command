class Rectangle:
    def __init__(self,width,height):
        self._width = width  #private variable not change
        self._height = height

    def get_width(slef):
        return slef._width
    
    def set_width(self,width):
        if width <= 0:
            raise ValueError('width must be positive')
        else:
            self._width = width

    # def to_string(self):
    #     return "width={0},height={1}".format(self.width,self.height)
    def __str__(self):
        return "width={0},height={1}".format(self._width,self._height)

    def __repr__(self):
        return "width={0},height={1}".format(self._width,self._height)

    def __eq__(slef,other):
        if isinstance(other,Rectangle):
            return slef._width == other._width and slef._height == other._height
        else:
            return False

r1 = Rectangle(10,20)

print(r1.get_width())
r1.set_width(100)

print(r1)



