-- Table: public.test

-- DROP TABLE IF EXISTS public.test;

CREATE TABLE IF NOT EXISTS public.test
(
    id_test bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    id_dataset bigint NOT NULL,
    date_creation timestamp without time zone,
    seed_ega bigint,
    seed_faa bigint,
    seed_dataset bigint,
    quasi_minmax numeric(10,9),
    training_rate integer,
    num_term integer,
    power_l integer,
    num_generation integer,
    num_individual integer,
    cross_rate numeric(10,9),
    mutation_rate numeric(10,9),
    regularization_factor numeric(10,9),
    best_individual bigint,
    best_individual_simplified bigint,
    CONSTRAINT pk_test PRIMARY KEY (id_test),
    CONSTRAINT fk_dataset_test FOREIGN KEY (id_dataset)
        REFERENCES public.dataset (id_dataset) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.test
    OWNER to postgres;