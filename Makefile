
all: compile

compile:
	Rscript -e "knitr::knit(\"schloerke_b_thesis.Rnw\"); Sys.setenv(PDFLATEX = \"pdflatex --shell-escape\"); tools::texi2pdf(\"schloerke_b_thesis.tex\"); tools::texi2pdf(\"schloerke_b_thesis.tex\"); unlink(file.path(c(\".\", \"parts\"), rep(c(\"*.aux\", \"*.bbl\", \"*.blg\", \"*.fdb_latexmk\", \"*.fls\", \"*.lof\", \"*.log\", \"*.lot\", \"*.out\", \"*.toc\"), each = 2))); unlink(file.path(\"parts\", \"*.c\"));"
	cp schloerke_b_thesis.tex _build/schloerke_b_thesis.tex
	cp schloerke_b_thesis.pdf _build/schloerke_b_thesis.pdf

test:
	echo "test!"
