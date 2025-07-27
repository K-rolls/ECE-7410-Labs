#!/bin/bash

# Watch for changes and run pandoc to generate PDF
while inotifywait -e modify ./L4.md; do
    pandoc L4.md \
        -o G10.pdf \
        --pdf-engine=pdflatex \
        --filter pandoc-plot \
        --filter pandoc-include \
        --highlight-style tango.theme \
        --mathjax \
        --template=theme.tex \
        2>pandoc_warnings.log

    echo "PDF generated: ECE7600_A2.pdf"
done 

