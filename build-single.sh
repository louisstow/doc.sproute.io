#!/bin/bash

cat /dev/null > single.html

cat template/header.html >> single.html
cat introduction.html >> single.html

files="pages.md;models.md;routes.md;rest.md;permissions.md;users.md;config.md;static.md"

# loop over ever markdown file
for i in $(echo $files | tr ";" "\n"); do
	pandoc -f markdown -t html "$i" >> single.html
done;

cat template/footer.html >> single.html
