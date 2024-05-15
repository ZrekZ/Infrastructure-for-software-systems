from fastapi import APIRouter

from .books.api import router as book_router


router = APIRouter()

router.include_router(book_router, prefix="/v1")