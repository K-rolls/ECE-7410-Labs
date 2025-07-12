#!/bin/bash

# Watch for changes and run pandoc to generate PDF
while inotifywait -e modify ./L4.md; do
    pandoc L4.md \
        -o G10.pdf \
        --pdf-engine=pdflatex \
        --filter pandoc-plot \
        --highlight-style tango.theme \
        --template=theme.tex

    echo "PDF generated: G10.pdf"
done
