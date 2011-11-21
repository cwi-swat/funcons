.PHONY : FORCE_MAKE

report.pdf: FORCE_MAKE
	latexmk -pdf report
	rubber-info --check report
	rubber-info --boxes report

final: report-final.pdf
	open report-final.pdf

report-final.pdf: report_compiled.pdf
	mv report_compiled.pdf report-final.pdf

report_compiled.pdf: report_compiled.tex FORCE_MAKE
	latexmk -pdf -gg report_compiled
	rubber-info --check report_compiled
	rubber-info --boxes report_compiled
	rm report_compiled.tex

report_compiled.tex: report.ltx
	mv report.ltx report_compiled.tex

report.ltx: report.tex
	java -jar rascal.jar -latex report.tex

ci-tex:
	git add report.tex
	git commit

clean:
	rm -f *.log *.pdf *.ltx report_compiled.* *_latexmk
