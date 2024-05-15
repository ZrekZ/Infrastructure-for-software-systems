from fastapi import APIRouter

from .v1.book import router as book_router


router = APIRouter()

router.include_router(book_router, prefix="/book")