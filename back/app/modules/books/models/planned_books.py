from sqlalchemy import Column, Integer, ForeignKey
from app.common.db import Base
from sqlalchemy.orm import relationship, backref

class PlannedBooks(Base):
    __tablename__ = 'planned_books'
    id = Column(Integer, primary_key=True)
    book_id = Column(Integer, ForeignKey("book.id", ondelete="RESTRICT", onupdate="RESTRICT"), unique=True)
    book = relationship("Book", backref="planned_books")