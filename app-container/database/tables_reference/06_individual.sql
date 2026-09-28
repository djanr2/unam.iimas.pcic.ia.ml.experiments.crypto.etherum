-- Table: public.individual

-- DROP TABLE IF EXISTS public.individual;

CREATE TABLE IF NOT EXISTS public.individual
(
    id_individual bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    id_test bigint NOT NULL,
    parent_x bigint DEFAULT 0,
    parent_y bigint DEFAULT 0,
    seed bigint,
    epoch integer,
    generation integer,
    model text COLLATE pg_catalog."default",
    attributes text COLLATE pg_catalog."default",
    high_limits text COLLATE pg_catalog."default",
    low_limits text COLLATE pg_catalog."default",
    epsilon_theta numeric(20,9),
    epsilon_phi numeric(20,9),
    fitness numeric(20,9),
    is_mutated smallint DEFAULT 0,
    is_converged smallint DEFAULT 0,
    CONSTRAINT pk_individual PRIMARY KEY (id_individual),
    CONSTRAINT fk_test_individual FOREIGN KEY (id_test)
        REFERENCES public.test (id_test) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.individual
    OWNER to postgres;