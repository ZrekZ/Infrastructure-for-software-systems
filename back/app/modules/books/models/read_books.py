from sqlalchemy import Column, Integer, ForeignKey
from app.common.db import Base
from sqlalchemy.orm import relationship, backref

class ReadBooks(Base):
    __tablename__ = 'read_books'
    id = Column(Integer, primary_key=True)
    book_id = Column(Integer, ForeignKey("book.id", ondelete="RESTRICT", onupdate="RESTRICT"), unique=True)
    book = relationship("Book", backref="read_books")