
all: compile

dino:
	Rscript -e "source('scripts/dino.R')"


download_files:
	mkdir -p rpkg
	wget -N -O rpkg/gqlr.pdf https://cloud.r-project.org/web/packages/gqlr/gqlr.pdf
	wget -N -O rpkg/GGally.pdf https://cloud.r-project.org/web/packages/GGally/GGally.pdf


compile:
	make clean
	# make dino
	make compile_knitr
	make clean
	make copy_compile
	make spelling


compile_knitr:
	mkdir -p figure
	Rscript -e "knitr::knit(\"schloerke_b_thesis.Rnw\"); warnings(); invisible();"
	Rscript -e "Sys.setenv(PDFLATEX = \"pdflatex --shell-escape --halt-on-error\"); tools::texi2pdf(\"schloerke_b_thesis.tex\");"
	Rscript -e "Sys.setenv(PDFLATEX = \"pdflatex --shell-escape\"); tools::texi2pdf(\"schloerke_b_thesis.tex\");"


copy_compile:
	cp schloerke_b_thesis.tex _build/schloerke_b_thesis.tex
	cp schloerke_b_thesis.pdf _build/schloerke_b_thesis.pdf


clean:
	Rscript -e "unlink(file.path(c(\".\", \"parts\"), rep(c(\"*.aux\", \"*.bbl\", \"*.blg\", \"*.fdb_latexmk\", \"*.fls\", \"*.lof\", \"*.log\", \"*.lot\", \"*.out\", \"*.pyg\", \"*.toc\"), each = 2)))"
	Rscript -e "unlink(file.path(\"parts\", \"*.c\"))"
	Rscript -e "unlink(file.path(\"graphqllexer\", \"*.pyc\"))"


dotbuild:
	VALS=`ls dot | grep .dot | sed s/\.dot$$//` ; \
	for FILE in $$VALS; do \
		if [ ! -f "dot/$$FILE.png" ]; then \
			dot "dot/$$FILE.dot" -Tpng -o "dot/$$FILE.png" ; \
		fi; \
	done
	# if [ ! -f "dot/$$FILE.pdf" ]; then \
	# 	dot "dot/$$FILE.dot" -Tpdf -o "dot/$$FILE.pdf" ; \
	# fi; \

spelling:
	Rscript -e "source(file.path('scripts', 'spelling.R'));"

reset:
	make clean
	Rscript -e "unlink(\"cache\", recursive = TRUE)"
	Rscript -e "unlink(\"figure\", recursive = TRUE)"

everything:
	make reset
	make compile

test:
	echo "test!"
