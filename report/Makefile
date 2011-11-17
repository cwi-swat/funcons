report.pdf: report_compiled.tex
	latexmk -pdf report_compiled
	rubber-info --check report_compiled
	rubber-info --boxes report_compiled
	rm report_compiled.tex
	mv report_compiled.pdf report.pdf

report_compiled.tex: report.ltx
	cp report.ltx report_compiled.tex

report.ltx: report.tex
	java -jar rascal.jar -latex report.tex

ci-tex:
	git add report.tex
	git commit
