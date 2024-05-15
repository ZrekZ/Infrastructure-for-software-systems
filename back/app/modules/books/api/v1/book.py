from datetime import date
from fastapi import APIRouter, Depends, Query, Path, Query, Body
from sqlalchemy.orm import Session
from starlette.responses import JSONResponse
from sqlalchemy import select, insert
from app.common.db import get_db
from app.modules.books.models import Language, Author, Book, ReadBooks, PlannedBooks, book_authors, author_languages
from typing import Union
router = APIRouter()

@router.get("/books")
def get_all_books(session: Session = Depends(get_db)):
    try:
        statement = select(Book).join(Language).outerjoin(book_authors).outerjoin(Author).distinct()
        return [
            {
                "id": x.id,
                "name": x.name,
                "author": [y.name for y in x.authors],
                "published": x.published,
                "lang": x.language.name
            } for x in session.execute(statement).scalars().all()
        ]
    except Exception as e: return JSONResponse({"err": str(e)}, status_code=500)

#поиск всех прочитанных книг
@router.get("/readBooks")
def get_read_books(session: Session = Depends(get_db)):
    try:
        statement = select(ReadBooks).join(Book).join(Language).outerjoin(book_authors).outerjoin(Author).distinct()
        return [
            {
                "id": x.book.id,
                "name": x.book.name,
                "author": [y.name for y in x.book.authors],
                "published": x.book.published,
                "lang": x.book.language.name
            } for x in session.execute(statement).scalars().all()
        ]
    except Exception as e: return JSONResponse({"err": str(e)}, status_code=500)

#получение информации об авторе по его имени
@router.get("/authors/{author_name}")
def get_author_by_name(author_name: str, session: Session = Depends(get_db)):
    author_name = set_upper_author_name(author_name)
    try:
        author_name = str.upper(author_name)
        statement = select(Author).where(Author.name == author_name).outerjoin(author_languages).outerjoin(Language)
        return [
            {
                "id": author.id,
                "name": author.name,
                "bio": author.bio,
                "birthday": author.birthday,
                "langs": [y.name for y in author.languages]
            } for author in session.execute(statement).scalars().all()
        ]
    except Exception as e:
        return JSONResponse({"err": str(e)}, status_code=500)

#получение информации об авторе по его имени
@router.get("/authors")
def get_authors(session: Session = Depends(get_db)):
    try:
        statement = select(Author).outerjoin(author_languages).outerjoin(Language)
        return [
            {
                "id": author.id,
                "name": author.name,
                "bio": author.bio,
                "birthday": author.birthday,
                "langs": [y.name for y in author.languages]
            } for author in session.execute(statement).scalars().all()
        ]
    except Exception as e:
        return JSONResponse({"err": str(e)}, status_code=500)

#поиск книги по названию
@router.get("/books/{book_name}")
def get_books_by_name(book_name: str, session: Session = Depends(get_db)):
    try:
        statement = select(Book).where(Book.name==book_name).join(Language).outerjoin(book_authors).outerjoin(Author).distinct()
        return [
            {
                "id": x.id,
                "name": x.name,
                "author": [y.name for y in x.authors],
                "published": x.published,
                "lang": x.language.name
            } for x in session.execute(statement).scalars().all()
        ]
    except Exception as e: return JSONResponse({"err": str(e)}, status_code=500)

#поиск всех планируемых к прочтению книг (на любом языке или конкретном)
@router.get("/plannedBooks")
def get_planned_books(language_name: Union[str, None] = Query(default=None), session: Session = Depends(get_db)):
    try:
        statement = select(PlannedBooks).join(Book).join(Language).outerjoin(book_authors).outerjoin(Author).distinct()
        if language_name is not None:
            statement = statement.where(Language.name==language_name)
        return [
            {
                "id": x.book.id,
                "name": x.book.name,
                "author": [y.name for y in x.book.authors],
                "published": x.book.published,
                "lang": x.book.language.name
            } for x in session.execute(statement).scalars().all()
        ]
    except Exception as e: return JSONResponse({"err": str(e)}, status_code=500)

#поиск книг данного автора (на любом языке или на конкретном, среди прочитанных, среди
#планируемых к прочтению);
@router.get("/books/searchByAuthor/{author_name}")
def get_books_by_author(author_name: str, language_name: Union[str, None] = Query(default=None),
                        source: int = Query(description="1 - поиск книг по планируемым книгам, 2 - поиск по прочитанным книгам, 3 - поиск по всем книгам"), session: Session = Depends(get_db)):
    author_name = set_upper_author_name(author_name)
    if source < 1 or source > 3:
        return JSONResponse({"err": "invalid source for searching books"}, status_code=422)
    try:
        statement = select(Book, Author, Language, book_authors)
        if source == 1:
            statement=select(PlannedBooks, Book, Author, Language, book_authors).where(Book.id == PlannedBooks.book_id)
        elif source == 2:
            statement=select(ReadBooks, Book, Author, Language, book_authors).where(Book.id == ReadBooks.book_id)
        statement = statement.where(book_authors.c.book_id == Book.id).where(book_authors.c.author_id == Author.id).where(Language.id == Book.lang_id)
        statement = statement.where(Author.name == author_name)
        if language_name is not None: statement = statement.where(Language.name == language_name)

        return [
            {
                "id": x.id if source == 3 else x.book.id,
                "name": x.name if source == 3 else x.book.name,
                "author": [y.name for y in x.authors] if source == 3 else [y.name for y in x.book.authors],
                "published": x.published if source == 3 else x.book.published,
                "lang": x.language.name if source == 3 else x.book.language.name
            } for x in session.execute(statement).scalars().all()
        ]
    except Exception as e:
        return JSONResponse({"err": str(e)}, status_code=500)

#перемещение книги из планирование в чтение
@router.post("/plannedBooks/moveToReadBooks/{book_id}")
def move_book_to_read(book_id: int, session: Session = Depends(get_db)):
    book = session.execute(select(PlannedBooks).where(PlannedBooks.book_id==book_id)).scalars().first()
    if not book:
        return JSONResponse({"err" : "book doesn't exist at planned list"}, status_code=404)
    if session.execute(select(ReadBooks).where(ReadBooks.book_id==book.id)).first():
        return JSONResponse({"err" : "book is already in read list"}, status_code=403)

    read_book = ReadBooks(book_id=book.book_id)
    try:
        session.add(read_book)
        session.commit()
        session.delete(book)
        session.commit()
    except Exception as e: return JSONResponse({"err": str(e)}, status_code=500)
    return {"status": "success"}

#перемещаем книги из чтения в планирование
@router.post("/readBooks/moveToPlannedBooks/{book_id}")
def move_book_to_planned(book_id: int, session: Session = Depends(get_db)):
    book = session.execute(select(ReadBooks).where(ReadBooks.book_id==book_id)).scalars().first()
    if not book:
        return JSONResponse({"err" : "book doesn't exist"}, status_code=404)
    if session.execute(select(PlannedBooks).where(PlannedBooks.book_id==book.id)).first():
        return JSONResponse({"err" : "book is already in planned list"}, status_code=403)

    planned_book = PlannedBooks(book_id=book.book_id)
    try:
        session.add(planned_book)
        session.commit()
        session.delete(book)
        session.commit()
    except Exception as e:
        return JSONResponse({"err": str(e)}, status_code=500)
    return {"status": "success"}

#создаём новую книгу
@router.post("/books/new")
def add_book(name: str = Body(...), lang_name: str = Body(...),
             year: int = Body(...) , author_spec: Union[str, None] = Body(...),
             session: Session = Depends(get_db)):
    lang = session.execute(select(Language).where(Language.name == lang_name)).scalars().first()
    if not lang:
        lang = Language(name=lang_name)
        try:
            session.add(lang)
            session.commit()
        except Exception as e:
            return JSONResponse({"err": str(e)}, status_code=500)

    new_book = Book(name=name, lang_id=lang.id, published=year)
    try:
        session.add(new_book)
        session.commit()
    except Exception as e:
        return JSONResponse({"err": str(e)}, status_code=500)

    all_authors = True
    if author_spec is not None:
        author_names = author_spec.split(",")

        for author_name in author_names:
            author = session.execute(select(Author).where(Author.name == author_name)).scalars().first()
            if not author:
                all_authors = False
                continue
            book_author_conn = insert(book_authors).values(author_id=author.id, book_id=new_book.id)
            try:
                session.execute(book_author_conn)
                session.commit()
            except Exception as e:
                return JSONResponse({"err": str(e)}, status_code=500)
    return {"book added": "success", "all authors added": "success" if all_authors else "fail"}

@router.post("/authors/new")
def add_author(name: str = Body(...), bio: Union[str, None] = Body(),
               birthday: date = Body(...),
               lang_spec: str = Body(...),
               session: Session = Depends(get_db)):
    bio = create_not_empty_bio(bio)
    new_author = Author(name=name, bio=bio, birthday=birthday)
    if session.execute(select(Author).where(Author.name == new_author.name)).first():
        return JSONResponse({"err": "author already exists"}, status_code=403)
    try:
        session.add(new_author)
        session.commit()
    except Exception as e:
        return JSONResponse({"err": str(e)}, status_code=500)

    lang_names = lang_spec.split(",")
    all_langs = True
    for lang_name in lang_names:
        lang = session.execute(select(Language).where(Language.name == lang_name)).scalars().first()
        if not lang:
            new_lang = insert(Language).values(name = lang_name)
            session.execute(new_lang)
        lang = session.execute(select(Language).where(Language.name == lang_name)).scalars().first()
        author_lang_conn = insert(author_languages).values(author_id=new_author.id, language_id=lang.id)
        try:
            session.execute(author_lang_conn)
            session.commit()
        except Exception as e:
            return JSONResponse({"err": str(e)}, status_code=500)
    return {"author added": "success", "all langs added": "success" if all_langs else "fail"}


@router.delete("/authors/{author_id}/delete")
def remove_author(author_id: int, session: Session = Depends(get_db)):
    author = session.execute(select(Author).where(Author.id == author_id)).scalars().first()
    if not author: return JSONResponse({"err": "author doesn't exist"}, status_code=404)
    try:
        session.query(book_authors).filter(book_authors.c.author_id == author.id).delete()
        session.query(author_languages).filter(author_languages.c.author_id == author.id).delete()
        session.delete(author)
        session.commit()
        return {"status": "success"}
    except Exception as e:
        return JSONResponse({"err": str(e)}, status_code=500)


@router.delete("/books/{book_id}/delete")
def remove_book(book_id: int, session: Session = Depends(get_db)):
    book = session.execute(select(Book).where(Book.id == book_id)).scalars().first()
    if not book: return JSONResponse({"err": "book doesn't exist"}, status_code=404)
    try:
        if session.execute(select(PlannedBooks).where(PlannedBooks.book_id == book_id)).scalars().first():
            session.delete(session.execute(select(PlannedBooks).where(PlannedBooks.book_id == book_id)).scalars().first())
        if session.execute(select(ReadBooks).where(ReadBooks.book_id == book_id)).scalars().first():
            session.delete(session.execute(select(ReadBooks).where(ReadBooks.book_id == book_id)).scalars().first())
        session.query(book_authors).filter(book_authors.c.book_id == book.id).delete()
        session.delete(book)
        session.commit()
        return {"status": "success"}
    except Exception as e:
        return JSONResponse({"err": str(e)}, status_code=500)


@router.put("/books/{book_id}")
def edit_book(book_id: int, name: Union[str, None] = Body(...),
              lang_name: Union[str, None] = Body(...), year: Union[int, None] = Body(...),
              author_spec: Union[str, None] = Body(),
              session: Session = Depends(get_db)):
    book = session.execute(select(Book).where(Book.id == book_id)).scalars().first()
    if not book: return JSONResponse({"err": "book doesn't exist"}, status_code=410)

    lang = None
    if lang_name is not None:
        lang = session.execute(select(Language).where(Language.name == lang_name)).scalars().first()
        if not lang:
            lang = Language(name=lang_name)
            try:
                session.add(lang)
                session.commit()
            except Exception as e:
                return JSONResponse({"err": str(e)}, status_code=500)

    if name is not None: book.name = name
    if year is not None: book.published = year
    if lang is not None: book.lang_id = lang.id
    try:
        session.commit()
    except Exception as e:
        return JSONResponse({"err": str(e)}, status_code=500)

    all_authors = True
    if author_spec is not None:
        author_names = author_spec.split(";")

        for code in author_names:
            op = code[0]
            author_name = code[1:]
            author = session.execute(select(Author).where(Author.name == author_name)).scalars().first()
            if not author or (op != '+' and op != '-'):
                all_authors = False
                continue

            try:
                if op == '+':
                    book_author_conn = insert(book_authors).values(author_id=author.id, book_id=book.id)
                    session.execute(book_author_conn)
                else:
                    session.query(book_authors).filter(book_authors.c.book_id
                                                       == book.id).filter(
                        book_authors.c.author_id == author.id).delete()
                session.commit()
            except Exception as e:
                return JSONResponse({"err": str(e)}, status_code=500)
    return {"book updated": "success", "all authors changes applied": "success" if all_authors else "fail"}


@router.put("/authors/{author_id}")
def edit_author(author_id: int, name: Union[str, None] = Body(...),
                bio: Union[str, None] = Body(),
                birthday: Union[date, None] = Body(...),
                lang_spec: Union[str, None] = Body(...),
                session: Session = Depends(get_db)):
    author = session.execute(select(Author).where(Author.id == author_id)).scalars().first()
    if not author: return JSONResponse({"err": "author doesn't exist"}, status_code=410)

    if name is not None: author.name = name
    if bio is not None: author.bio = bio
    if birthday is not None: author.birthday = birthday
    try:
        session.commit()
    except Exception as e:
        return JSONResponse({"err": str(e)}, status_code=500)

    all_langs = True
    if lang_spec is not None:
        lang_names = lang_spec.split(";")

        for code in lang_names:
            op = code[0]
            lang_name = code[1:]
            lang = session.execute(select(Language).where(Language.name == lang_name)).scalars().first()
            if op != '+' and op != '-':
                all_langs = False
                continue
            if not lang:
                lang = Language(name=lang_name)
                try:
                    session.add(lang)
                    session.commit()
                except Exception as e:
                    return JSONResponse({"err": str(e)}, status_code=500)

            try:
                if op == '+':
                    lang_author_conn = insert(author_languages).values(author_id=author.id, lang_id=lang.id)
                    session.execute(lang_author_conn)
                else:
                    session.query(author_languages).filter(author_languages.c.lang_id
                                                       == lang.id).filter(
                        author_languages.c.author_id == author.id).delete()
                session.commit()
            except Exception as e:
                return JSONResponse({"err": str(e)}, status_code=500)
    return {"book updated": "success", "all authors changes appip install uvicornplied": "success" if all_langs else "fail"}

# Функция для приведения ФИО автора к upper case
def set_upper_author_name(author_name):
    if not author_name.isupper():
        return author_name.upper()
    return author_name

# Функция для подмены пустой биографии на сообщение
def create_not_empty_bio(bio):
    if not bio:
        return "sorry, the biography will come later"
    return bio

