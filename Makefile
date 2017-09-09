
all: compile

compile:
	Rscript -e "knitr::knit2pdf(\"schloerke_b_thesis.Rnw\", clean = TRUE); unlink(c(\"parts/*.aux\", \"bib/*.aux\"))"
	cp schloerke_b_thesis.pdf _build/schloerke_b_thesis.pdf
