ALTER TABLE public.test
ADD CONSTRAINT fk_individual_simplified_test
FOREIGN KEY (best_individual_simplified)
REFERENCES public.individual (id_individual)
ON UPDATE NO ACTION
ON DELETE NO ACTION
NOT VALID;