
all: compile

compile:
	Rscript -e "knitr::knit2pdf(\"schloerke_b_thesis.Rnw\", clean = TRUE, compiler = \"pdflatex --shell-escape\"); unlink(file.path(c(\".\", \"parts\"), rep(c(\"*.aux\", \"*.bbl\", \"*.blg\", \"*.fdb_latexmk\", \"*.fls\", \"*.lof\", \"*.log\", \"*.lot\", \"*.out\", \"*.toc\"), each = 2)))"
	cp schloerke_b_thesis.tex _build/schloerke_b_thesis.tex
	cp schloerke_b_thesis.pdf _build/schloerke_b_thesis.pdf

test:
	echo "test!"
