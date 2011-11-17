.PHONY : FORCE_MAKE

report.pdf: report_compiled.tex FORCE_MAKE
	latexmk -pdf report_compiled
	rubber-info --check report_compiled
	rubber-info --boxes report_compiled
	rm report_compiled.tex
	cp report_compiled.pdf report.pdf

report_compiled.tex: report.ltx
	cp report.ltx report_compiled.tex

report.ltx: report.tex
	java -jar rascal.jar -latex report.tex

ci-tex:
	git add report.tex
	git commit

clean:
	rm -f *.log *.pdf *.ltx report_compiled.*
