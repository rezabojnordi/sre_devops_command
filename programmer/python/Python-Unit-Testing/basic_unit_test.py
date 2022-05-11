import unittest

## python3 basic_unit_test.py -v
class TestStringMethod(unittest.TestCase):
    def test_upper(self):
        self.assertEqual('foo'.upper(),'FOO')

    
    def test_isupper(self):
        self.assertTrue('FOO'.isupper())
        self.assertFalse('foo'.isupper())

    
    def test_split(self):
        s = 'hello world'
        self.assertEqual(s.split(),['hello','world'])
        # check that s.split fails when the separator is not a string
        with self.assertRaises(TypeError):
            s.split(2)
    

if __name__ == '__main__':
    unittest.main()

