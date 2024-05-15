import unittest
from app.modules.books.api.v1.book import set_upper_author_name, create_not_empty_bio


class TestBook(unittest.TestCase):
    # Тест для проверки функции set_upper_author_name
    def test_upper_author_name(self):
        lower_author_name = "`К0нечный_Nтог 0чевиден`"
        result = set_upper_author_name(lower_author_name)
        upper_author_name = "`К0НЕЧНЫЙ_NТОГ 0ЧЕВИДЕН`"
        self.assertEqual(result, upper_author_name)
    
    # Тест для проверки test_fill_empty_bio
    def test_fill_empty_bio(self):
        empty_bio = ""
        result = create_not_empty_bio(empty_bio)
        expected_result = "sorry, the biography will come later"
        self.assertEqual(result, expected_result)