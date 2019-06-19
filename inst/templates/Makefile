.PHONY: drake clean

drake:
	Rscript --vanilla -e "drake::r_make(); cli::cat_rule('Makefile finished', col = 'yellow')"

clean:
	Rscript --vanilla -e "drake::clean(); cli::cat_rule('Makefile finished', col = 'yellow')"
