from sqlalchemy import Column, Integer, String, Date, ForeignKey
from sqlalchemy.schema import Table
from sqlalchemy.orm import relationship, backref
from app.common.db import Base

author_languages = Table('author_languages', Base.metadata,
Column('author_id', Integer, ForeignKey('author.id', ondelete="RESTRICT", onupdate="RESTRICT"), nullable=False, primary_key=True),
Column('language_id', Integer, ForeignKey('language.id', ondelete="RESTRICT", onupdate="RESTRICT"), nullable=False, primary_key=True)
)

class Author(Base):
    __tablename__ = 'author'
    id = Column(Integer, primary_key=True)
    name = Column(String(50), nullable=False)
    bio = Column(String(200), nullable = True)
    birthday = Column(Date, nullable = False)
    languages = relationship("Language", secondary=author_languages, backref="authors")