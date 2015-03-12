# Makefile driven Markdown parser suitable for documentation,
# websites, etc.
#
# Point of Contact: Schuyler Eldridge <schuyler.eldridge@gmail.com>

#--------------------------------------- Configuration that _should_ be static
DIR_BUILD   = build
DIR_SRC     = src
DIR_SCRIPTS = scripts

# The sources are anything inside the src directory that match *.md
SOURCES_MD  = $(shell ls $(DIR_SRC)/*.md | sed 's/$(DIR_SRC)\///')

# The targets are all the sources with an
TARGETS_HTML= $(SOURCES_MD:%.md=$(DIR_BUILD)/%.html)

SPACE       = $(EMPTY) $(EMPTY)

vpath %.md $(DIR_SRC)


#--------------------------------------- Build rules
.PHONY: all clean refresh-conkeror

# Default target. This should either be set to build all targets with
# LaTeX formatting cleanup (format-build) OR to just build without
# cleanup (noformat-build)
all: $(TARGETS_HTML) refresh-conkeror
	echo $(SOURCES_MD)

# HTML build rule
$(DIR_BUILD)/%.html: %.md Makefile
	$(DIR_SCRIPTS)/markdown-chooser $< > $@

# This will send key "r" to all instances of `conkeror` using the
# `xdotool`. I like to keep `conkeror` running beside my `emacs`. This
# will then cause the webpage to be forcibly updated at the end of the
# build.
refresh-conkeror:
	if [[ `pidof -x conkeror` ]]; then \
	xdotool search "conkeror" | xargs -I WIN xdotool key --window WIN r; fi

clean:
	rm -f $(DIR_BUILD)/*