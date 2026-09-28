-- Table: public.ppmz

-- DROP TABLE IF EXISTS public.ppmz;

CREATE TABLE IF NOT EXISTS public.ppmz
(
    id_ppmz bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    id_test bigint,
    original_size integer,
    original_compressed integer,
    train_size integer,
    train_compressed integer,
    test_size integer,
    test_compressed integer,
    CONSTRAINT pk_ppmz PRIMARY KEY (id_ppmz),
    CONSTRAINT fk_test_ppmz FOREIGN KEY (id_test)
        REFERENCES public.test (id_test) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.ppmz
    OWNER to postgres;