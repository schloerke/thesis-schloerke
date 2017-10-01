
all: compile

compile:
	Rscript -e "knitr::knit(\"schloerke_b_thesis.Rnw\")"
	Rscript -e "Sys.setenv(PDFLATEX = \"pdflatex --shell-escape\"); tools::texi2pdf(\"schloerke_b_thesis.tex\");"
	Rscript -e "Sys.setenv(PDFLATEX = \"pdflatex --shell-escape\"); tools::texi2pdf(\"schloerke_b_thesis.tex\");"
	cp schloerke_b_thesis.tex _build/schloerke_b_thesis.tex
	cp schloerke_b_thesis.pdf _build/schloerke_b_thesis.pdf

clean:
	Rscript -e "unlink(file.path(c(\".\", \"parts\"), rep(c(\"*.aux\", \"*.bbl\", \"*.blg\", \"*.fdb_latexmk\", \"*.fls\", \"*.lof\", \"*.log\", \"*.lot\", \"*.out\", \"*.toc\"), each = 2)))"
	Rscript -e "unlink(file.path(\"parts\", \"*.c\"))"
	Rscript -e "unlink(file.path(\"graphqllexer\", \"*.pyc\"))"

test:
	echo "test!"
