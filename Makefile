LATEX_BUILDER_IMAGE_NAME ?= azamatbayramov/latex-builder
LATEX_BUILDER_IMAGE_TAG ?= latest
FILE ?= main.tex

.PHONY: build push pdf clean

# Build Docker image for LaTeX compilation
build:
	docker buildx use multiarch-builder || docker buildx create --use --name multiarch-builder
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		-t $(LATEX_BUILDER_IMAGE_NAME):$(LATEX_BUILDER_IMAGE_TAG) \
		--push .

# Push Docker image to Docker Hub
push:
	docker push $(LATEX_BUILDER_IMAGE_NAME):$(LATEX_BUILDER_IMAGE_TAG)

# Compile LaTeX file to PDF using the Docker image
pdf:
	docker run --rm -v $(PWD):/workdir $(LATEX_BUILDER_IMAGE_NAME):$(LATEX_BUILDER_IMAGE_TAG) $(FILE)

# Remove auxiliary files generated during LaTeX compilation
clean:
	find . -type f \( -name "*.aux" -o -name "*.bbl" -o -name "*.blg" -o \
		-name "*.brf" -o -name "*.fls" -o -name "*.fdb_latexmk" -o \
		-name "*.log" -o -name "*.out" -o -name "*.toc" -o -name "*.lof" -o \
		-name "*.lot" -o -name "*.synctex.gz" \) -delete
