```bash
# build latex
# pdflatex -shell-escape -output-directory=temp coursework.tex
# pdflatex -shell-escape coursework.tex

latexmk -pdf -pvc -shell-escape -silent coursework.tex
```