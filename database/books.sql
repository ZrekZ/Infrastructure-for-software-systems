--
-- PostgreSQL database dump
--

-- Dumped from database version 10.22
-- Dumped by pg_dump version 10.22

-- Started on 2022-12-12 20:13:41

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

CREATE DATABASE books;
\connect books;

--
-- TOC entry 196 (class 1259 OID 16404)
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 16411)
-- Name: author; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.author (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    bio character varying(200),
    birthday date NOT NULL
);


ALTER TABLE public.author OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 16409)
-- Name: author_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.author_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.author_id_seq OWNER TO postgres;

--
-- TOC entry 2880 (class 0 OID 0)
-- Dependencies: 197
-- Name: author_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.author_id_seq OWNED BY public.author.id;


--
-- TOC entry 201 (class 1259 OID 16427)
-- Name: author_languages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.author_languages (
    author_id integer NOT NULL,
    language_id integer NOT NULL
);


ALTER TABLE public.author_languages OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 16444)
-- Name: book; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.book (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    lang_id integer,
    published integer NOT NULL
);


ALTER TABLE public.book OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 16455)
-- Name: book_authors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.book_authors (
    author_id integer NOT NULL,
    book_id integer NOT NULL
);


ALTER TABLE public.book_authors OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 16442)
-- Name: book_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.book_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.book_id_seq OWNER TO postgres;

--
-- TOC entry 2881 (class 0 OID 0)
-- Dependencies: 202
-- Name: book_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.book_id_seq OWNED BY public.book.id;


--
-- TOC entry 200 (class 1259 OID 16419)
-- Name: language; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language (
    id integer NOT NULL,
    name character varying(300) NOT NULL
);


ALTER TABLE public.language OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 16417)
-- Name: language_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.language_id_seq OWNER TO postgres;

--
-- TOC entry 2882 (class 0 OID 0)
-- Dependencies: 199
-- Name: language_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_id_seq OWNED BY public.language.id;


--
-- TOC entry 206 (class 1259 OID 16472)
-- Name: planned_books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.planned_books (
    id integer NOT NULL,
    book_id integer
);


ALTER TABLE public.planned_books OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 16470)
-- Name: planned_books_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.planned_books_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.planned_books_id_seq OWNER TO postgres;

--
-- TOC entry 2883 (class 0 OID 0)
-- Dependencies: 205
-- Name: planned_books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.planned_books_id_seq OWNED BY public.planned_books.id;


--
-- TOC entry 208 (class 1259 OID 16487)
-- Name: read_books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.read_books (
    id integer NOT NULL,
    book_id integer
);


ALTER TABLE public.read_books OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 16485)
-- Name: read_books_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.read_books_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.read_books_id_seq OWNER TO postgres;

--
-- TOC entry 2884 (class 0 OID 0)
-- Dependencies: 207
-- Name: read_books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.read_books_id_seq OWNED BY public.read_books.id;


--
-- TOC entry 2706 (class 2604 OID 16414)
-- Name: author id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.author ALTER COLUMN id SET DEFAULT nextval('public.author_id_seq'::regclass);


--
-- TOC entry 2708 (class 2604 OID 16447)
-- Name: book id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book ALTER COLUMN id SET DEFAULT nextval('public.book_id_seq'::regclass);


--
-- TOC entry 2707 (class 2604 OID 16422)
-- Name: language id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language ALTER COLUMN id SET DEFAULT nextval('public.language_id_seq'::regclass);


--
-- TOC entry 2709 (class 2604 OID 16475)
-- Name: planned_books id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planned_books ALTER COLUMN id SET DEFAULT nextval('public.planned_books_id_seq'::regclass);


--
-- TOC entry 2710 (class 2604 OID 16490)
-- Name: read_books id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.read_books ALTER COLUMN id SET DEFAULT nextval('public.read_books_id_seq'::regclass);


--
-- TOC entry 2861 (class 0 OID 16404)
-- Dependencies: 196
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.alembic_version VALUES ('4ef208774058');


--
-- TOC entry 2863 (class 0 OID 16411)
-- Dependencies: 198
-- Data for Name: author; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.author VALUES (5, 'ЛЕВ НИКОЛАЕВИЧ ТОЛСТОЙ', 'new bio', '1945-05-20');
INSERT INTO public.author VALUES (8, 'АЛЕКСАНДР ИВАНОВИЧ КУПРИН', 'био', '1800-05-05');
INSERT INTO public.author VALUES (9, 'АЛЕКСАНДР СЕРГЕЕВИЧ ПУШКИН', NULL, '1800-05-05');
INSERT INTO public.author VALUES (10, 'МИХАИЛ ЮРЬЕВИЧ ЛЕРМОНТОВ', NULL, '1800-05-05');
INSERT INTO public.author VALUES (11, 'МИХАИЛ АФАНАСЬЕВИЧ БУЛГАКОВ', 'bio', '1900-08-09');
INSERT INTO public.author VALUES (1, 'АНТОН ПАВЛОВИЧ ЧЕХОВ', 'https://ru.wikipedia.org/wiki/Чехов,_Антон_Павлович', '1860-01-29');


--
-- TOC entry 2866 (class 0 OID 16427)
-- Dependencies: 201
-- Data for Name: author_languages; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.author_languages VALUES (1, 1);
INSERT INTO public.author_languages VALUES (8, 1);
INSERT INTO public.author_languages VALUES (9, 1);
INSERT INTO public.author_languages VALUES (11, 3);


--
-- TOC entry 2868 (class 0 OID 16444)
-- Dependencies: 203
-- Data for Name: book; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.book VALUES (2, 'book1', 2, 2010);
INSERT INTO public.book VALUES (5, 'new_book', 2, 2015);
INSERT INTO public.book VALUES (4, 'Вишн', 1, 2015);
INSERT INTO public.book VALUES (9, 'Дама с собачкой', 1, 1870);
INSERT INTO public.book VALUES (12, 'Название книги', 1, 2019);
INSERT INTO public.book VALUES (14, 'Ещё одна книга', 2, 1564);
INSERT INTO public.book VALUES (8, 'Человек', 1, 1870);


--
-- TOC entry 2869 (class 0 OID 16455)
-- Dependencies: 204
-- Data for Name: book_authors; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.book_authors VALUES (1, 2);
INSERT INTO public.book_authors VALUES (1, 9);


--
-- TOC entry 2865 (class 0 OID 16419)
-- Dependencies: 200
-- Data for Name: language; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.language VALUES (1, 'Русский');
INSERT INTO public.language VALUES (2, 'Английский');
INSERT INTO public.language VALUES (3, 'English');
INSERT INTO public.language VALUES (4, 'Без разницы');
INSERT INTO public.language VALUES (5, 'rrr');
INSERT INTO public.language VALUES (6, 'Буп-буп');
INSERT INTO public.language VALUES (7, '-');


--
-- TOC entry 2871 (class 0 OID 16472)
-- Dependencies: 206
-- Data for Name: planned_books; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.planned_books VALUES (9, 4);


--
-- TOC entry 2873 (class 0 OID 16487)
-- Dependencies: 208
-- Data for Name: read_books; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.read_books VALUES (7, 5);
INSERT INTO public.read_books VALUES (9, 2);


--
-- TOC entry 2885 (class 0 OID 0)
-- Dependencies: 197
-- Name: author_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.author_id_seq', 12, true);


--
-- TOC entry 2886 (class 0 OID 0)
-- Dependencies: 202
-- Name: book_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.book_id_seq', 16, true);


--
-- TOC entry 2887 (class 0 OID 0)
-- Dependencies: 199
-- Name: language_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.language_id_seq', 7, true);


--
-- TOC entry 2888 (class 0 OID 0)
-- Dependencies: 205
-- Name: planned_books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.planned_books_id_seq', 9, true);


--
-- TOC entry 2889 (class 0 OID 0)
-- Dependencies: 207
-- Name: read_books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.read_books_id_seq', 9, true);


--
-- TOC entry 2712 (class 2606 OID 16408)
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- TOC entry 2720 (class 2606 OID 16431)
-- Name: author_languages author_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.author_languages
    ADD CONSTRAINT author_languages_pkey PRIMARY KEY (author_id, language_id);


--
-- TOC entry 2714 (class 2606 OID 16416)
-- Name: author author_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.author
    ADD CONSTRAINT author_pkey PRIMARY KEY (id);


--
-- TOC entry 2724 (class 2606 OID 16459)
-- Name: book_authors book_authors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_authors
    ADD CONSTRAINT book_authors_pkey PRIMARY KEY (author_id, book_id);


--
-- TOC entry 2722 (class 2606 OID 16449)
-- Name: book book_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT book_pkey PRIMARY KEY (id);


--
-- TOC entry 2716 (class 2606 OID 16426)
-- Name: language language_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language
    ADD CONSTRAINT language_name_key UNIQUE (name);


--
-- TOC entry 2718 (class 2606 OID 16424)
-- Name: language language_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language
    ADD CONSTRAINT language_pkey PRIMARY KEY (id);


--
-- TOC entry 2726 (class 2606 OID 16479)
-- Name: planned_books planned_books_book_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planned_books
    ADD CONSTRAINT planned_books_book_id_key UNIQUE (book_id);


--
-- TOC entry 2728 (class 2606 OID 16477)
-- Name: planned_books planned_books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planned_books
    ADD CONSTRAINT planned_books_pkey PRIMARY KEY (id);


--
-- TOC entry 2730 (class 2606 OID 16494)
-- Name: read_books read_books_book_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.read_books
    ADD CONSTRAINT read_books_book_id_key UNIQUE (book_id);


--
-- TOC entry 2732 (class 2606 OID 16492)
-- Name: read_books read_books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.read_books
    ADD CONSTRAINT read_books_pkey PRIMARY KEY (id);


--
-- TOC entry 2733 (class 2606 OID 16432)
-- Name: author_languages author_languages_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.author_languages
    ADD CONSTRAINT author_languages_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.author(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 2734 (class 2606 OID 16437)
-- Name: author_languages author_languages_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.author_languages
    ADD CONSTRAINT author_languages_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.language(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 2736 (class 2606 OID 16460)
-- Name: book_authors book_authors_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_authors
    ADD CONSTRAINT book_authors_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.author(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 2737 (class 2606 OID 16465)
-- Name: book_authors book_authors_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_authors
    ADD CONSTRAINT book_authors_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 2735 (class 2606 OID 16450)
-- Name: book book_lang_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT book_lang_id_fkey FOREIGN KEY (lang_id) REFERENCES public.language(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 2738 (class 2606 OID 16480)
-- Name: planned_books planned_books_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planned_books
    ADD CONSTRAINT planned_books_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 2739 (class 2606 OID 16495)
-- Name: read_books read_books_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.read_books
    ADD CONSTRAINT read_books_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


-- Completed on 2022-12-12 20:13:42

--
-- PostgreSQL database dump complete
--

