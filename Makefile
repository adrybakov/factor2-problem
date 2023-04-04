pdf:
	@pdflatex -synctex=1 -interaction=nonstopmode "main".tex
	@bibtex "main".aux
	@pdflatex -synctex=1 -interaction=nonstopmode "main".tex

clean:
	@rm main.aux
	@rm main.log
	@rm main.synctex.gz
	@rm main.bcf
	@rm main.run.xml
	@rm main.out