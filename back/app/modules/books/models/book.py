from sqlalchemy import Column, Integer, String, Date, ForeignKey
from sqlalchemy.schema import Table
from sqlalchemy.orm import relationship, backref
from app.common.db import Base

book_authors = Table('book_authors', Base.metadata,
Column('author_id', Integer, ForeignKey('author.id', ondelete="RESTRICT", onupdate="RESTRICT"), nullable=False, primary_key=True),
Column('book_id', Integer, ForeignKey('book.id', ondelete="RESTRICT", onupdate="RESTRICT"), nullable=False, primary_key=True)
)

class Book(Base):
    __tablename__ = 'book'
    id = Column(Integer, primary_key=True)
    name = Column(String(200), nullable=False)
    lang_id = Column(Integer, ForeignKey("language.id", ondelete="RESTRICT", onupdate="RESTRICT"))
    language = relationship("Language", backref=backref("books"))
    published = Column(Integer, nullable = False)
    authors = relationship("Author", secondary=book_authors, backref="books")