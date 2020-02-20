TEXNAME=main
PDFNAME=main

all: clean figures latexmk

svg_to_eps: figures-aad/accaas.eps figures-aad/accaad-short.eps figures-aad/accaad-tall.eps figures-aad/lower-frontier.eps figures-aad/AT.eps figures-aad/forest.eps figures-aad/model.eps

svg_to_pdf: figures-aad/accaas.pdf figures-aad/accaad-short.pdf figures-aad/accaad-tall.pdf figures-aad/lower-frontier.pdf figures-aad/AT.pdf figures-aad/forest.pdf figures-aad/model.pdf

figures: svg_to_eps svg_to_pdf

figures-aad/%.eps: figures-aad/%.svg
	inkscape -D -z --file=$(realpath $<) --export-eps=$(realpath .)/$@

figures-aad/%.pdf: figures-aad/%.svg
	inkscape -D -z --file=$(realpath $<) --export-dpi=300 --export-pdf=$(realpath .)/$@ 

latexmk: latexmk_clean
	# For some reason using -auxdir=build/ will result in failed builds
	latexmk -pdf ${TEXNAME}

texi2pdf: texi2pdf_clean
	texi2pdf --build-dir=build/ ${TEXNAME}.tex -o ${PDFNAME}.pdf

clean: texi2pdf_clean latexmk_clean
	rm -f *.pdf

latexmk_clean:
	rm -f *.fls *.fdb_latexmk *.dvi *.synctex.gz

texi2pdf_clean:
	rm -rf build/
	rm -f *.aux *.blg *.lof *.lot *.log *.bbl *.blg *.toc *.out

