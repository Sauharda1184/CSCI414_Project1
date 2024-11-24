-- Database: financial_db

-- DROP DATABASE IF EXISTS financial_db;

CREATE DATABASE financial_db
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- Table: public.budgets

-- DROP TABLE IF EXISTS public.budgets;

CREATE TABLE IF NOT EXISTS public.budgets
(
    budget_id integer NOT NULL DEFAULT nextval('budgets_budget_id_seq'::regclass),
    user_id integer NOT NULL,
    budget_name character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT budgets_pkey PRIMARY KEY (budget_id),
    CONSTRAINT budgets_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES public.users (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.budgets
    OWNER to postgres;


-- Table: public.categories

-- DROP TABLE IF EXISTS public.categories;

CREATE TABLE IF NOT EXISTS public.categories
(
    category_id integer NOT NULL DEFAULT nextval('categories_category_id_seq'::regclass),
    name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT categories_pkey PRIMARY KEY (category_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.categories
    OWNER to postgres;

-- Table: public.expenses

-- DROP TABLE IF EXISTS public.expenses;

CREATE TABLE IF NOT EXISTS public.expenses
(
    expense_id integer NOT NULL DEFAULT nextval('expenses_expense_id_seq'::regclass),
    budget_id integer NOT NULL,
    category_id integer NOT NULL,
    name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    dollar_amount double precision NOT NULL,
    CONSTRAINT expenses_pkey PRIMARY KEY (expense_id),
    CONSTRAINT expenses_budget_id_fkey FOREIGN KEY (budget_id)
        REFERENCES public.budgets (budget_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT expenses_category_id_fkey FOREIGN KEY (category_id)
        REFERENCES public.categories (category_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.expenses
    OWNER to postgres;

-- Table: public.users

-- DROP TABLE IF EXISTS public.users;

CREATE TABLE IF NOT EXISTS public.users
(
    user_id integer NOT NULL DEFAULT nextval('users_user_id_seq'::regclass),
    name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    email character varying(50) COLLATE pg_catalog."default" NOT NULL,
    password character varying(100) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT users_pkey PRIMARY KEY (user_id),
    CONSTRAINT users_email_key UNIQUE (email)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.users
    OWNER to postgres;

-- Table: public.incomes

-- DROP TABLE IF EXISTS public.incomes;

CREATE TABLE IF NOT EXISTS public.incomes
(
    income_id integer NOT NULL DEFAULT nextval('incomes_income_id_seq'::regclass),
    budget_id integer NOT NULL,
    category_id integer NOT NULL,
    name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    dollar_amount double precision NOT NULL,
    CONSTRAINT incomes_pkey PRIMARY KEY (income_id),
    CONSTRAINT incomes_budget_id_fkey FOREIGN KEY (budget_id)
        REFERENCES public.budgets (budget_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT incomes_category_id_fkey FOREIGN KEY (category_id)
        REFERENCES public.categories (category_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.incomes
    OWNER to postgres;