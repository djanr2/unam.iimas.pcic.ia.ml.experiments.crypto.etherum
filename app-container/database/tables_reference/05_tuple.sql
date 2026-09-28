-- Table: public.tuple

-- DROP TABLE IF EXISTS public.tuple;

CREATE TABLE IF NOT EXISTS public.tuple
(
    id_tuple bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    id_dataset_record bigint NOT NULL,
    id_test bigint NOT NULL,
    is_training smallint DEFAULT 0,
    value_sample numeric(20,9),
    value_test numeric(20,9),
    CONSTRAINT pk_tuple PRIMARY KEY (id_tuple),
    CONSTRAINT fk_dataset_record_tuple FOREIGN KEY (id_dataset_record)
        REFERENCES public.dataset_record (id_dataset_record) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_test_tuple FOREIGN KEY (id_test)
        REFERENCES public.test (id_test) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tuple
    OWNER to postgres;