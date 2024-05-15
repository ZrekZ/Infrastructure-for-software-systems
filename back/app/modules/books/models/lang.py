from enum import unique
from sqlalchemy import Column, Integer, String

from app.common.db import Base


class Language(Base):
    __tablename__ = 'language'
    id = Column(Integer, primary_key=True)
    name = Column(String(300), nullable=False, unique=True)
