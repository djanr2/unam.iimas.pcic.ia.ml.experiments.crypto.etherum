-- Table: public.term

-- DROP TABLE IF EXISTS public.term;

CREATE TABLE IF NOT EXISTS public.term
(
    id_term bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    id_individual bigint NOT NULL,
    coefficient numeric(20,9),
    powers text COLLATE pg_catalog."default",
    CONSTRAINT pk_term PRIMARY KEY (id_term),
    CONSTRAINT fk_individual_term FOREIGN KEY (id_individual)
        REFERENCES public.individual (id_individual) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.term
    OWNER to postgres;