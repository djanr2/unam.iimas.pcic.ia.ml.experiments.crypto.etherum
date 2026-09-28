-- Table: public.forecast

-- DROP TABLE IF EXISTS public.forecast;

CREATE TABLE IF NOT EXISTS public.forecast
(
    id_forecast bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    id_individual bigint NOT NULL,
    date_forecast timestamp without time zone,
    forecast numeric(20,9),
    date_target timestamp without time zone,
    input text COLLATE pg_catalog."default",
    target numeric(20,9),
    high_limit_target numeric(20,9),
    low_limit_target numeric(20,9),
    CONSTRAINT forecast_pkey PRIMARY KEY (id_forecast),
    CONSTRAINT fk_individual_forecast FOREIGN KEY (id_individual)
        REFERENCES public.individual (id_individual) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.forecast
    OWNER to postgres;