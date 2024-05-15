import unittest
from app.tests.test_book import TestBook

if __name__ == "__main__":
    suite = unittest.defaultTestLoader.loadTestsFromTestCase(TestBook)
    unittest.TextTestRunner().run(suite)