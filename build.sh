#!/bin/bash

# loop over ever markdown file
for i in *.md; do
	filename=${i%.*}
	pandoc -f markdown -t html "$i" -o "$filename.html"
done;
