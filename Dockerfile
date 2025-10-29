FROM debian:bookworm-slim

# Install dependencies and LaTex
RUN apt-get update && apt-get install -y --no-install-recommends \
    make \
    latexmk \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-latex-extra \
    texlive-pictures \
    texlive-fonts-recommended \
    texlive-lang-cyrillic \
    texlive-lang-english \
    texlive-bibtex-extra \
    texlive-fonts-extra \
    biber \
    ghostscript \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    texlive-lang-greek \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Work directory
WORKDIR /workdir

# Start latexmk by default (automatically build PDF file)
# Example: docker run --rm -v $(pwd):/workdir latex-builder main.tex
ENTRYPOINT ["latexmk", "-pdf", "-interaction=nonstopmode", "-halt-on-error"]
