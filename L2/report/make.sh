pandoc L2.md \
    -o G10.pdf \
    --pdf-engine=pdflatex \
    --filter pandoc-plot \
    --highlight-style tango.theme \
    --template=theme.tex
