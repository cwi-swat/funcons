pdf:
	latexmk -pdf report
	rubber-info --check report
	rubber-info --boxes report

ci-tex:
	git add report.tex
	git commit
