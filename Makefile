pdf:
	@pdflatex -synctex=1 -interaction=nonstopmode "main".tex
	@bibtex "main".aux
	@pdflatex -synctex=1 -interaction=nonstopmode "main".tex

clean:
	-@rm main.aux
	-@rm main.log
	-@rm main.synctex.gz
	-@rm main.bcf
	-@rm main.run.xml
	-@rm main.out
	-@rm main.bbl
	-@rm main.blg
	-@rm main.fdb_latexmk
	-@rm main.fls
	-@rm Appendix_I.aux

pictures:
	@python3 codes/lattice.py -pt lattice -op images
	@python3 codes/lattice.py -pt lattice-neighbors -op images
	@python3 codes/reciprocal_lattice.py -op images
	@python3 codes/dispersion.py -op images