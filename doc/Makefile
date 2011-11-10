
infile = readme.asciidoc

all: clean html README

html:
	@echo ">README Generating HTML"
	asciidoc -b xhtml11 -o README.html ${infile}

README:
	@echo "> Generating README"
	lynx -dump README.html > README 
	#a2x -f text --lynx ${infile}
								
clean:
	@echo "> Cleaning up"
	@rm -f *html README* 
