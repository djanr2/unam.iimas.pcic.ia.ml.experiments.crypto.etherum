ALTER TABLE public.test
ADD CONSTRAINT fk_individual_test
FOREIGN KEY (best_individual)
REFERENCES public.individual (id_individual)
ON UPDATE NO ACTION
ON DELETE NO ACTION
NOT VALID;