target = JED_whitepaper

latex_cmd = pdflatex

references = ../bibtex/consolidated_bibtex_file.bib

all: $(target).pdf

$(target).bbl: $(references) $(target).tex

$(target).pdf: $(target).tex $(graphics) Makefile $(references)
	-$(latex_cmd) $(target).tex
	bibtex $(target)
	$(latex_cmd) $(target).tex
	@while grep "Rerun to get" $(target).log ; do \
		$(latex_cmd) $(target) ; \
	done
	@if (grep "Warning" $(target).blg > /dev/null ) then false; fi
	make check_for_warnings

.PHONY: clean vi touch check_for_warnings spell notes quotes bib changes

check_for_warnings:
	grep -i warn $(target).log

vi:
	vi $(target).tex

clean::
	rm -fv *.log *.blg *.aux *.out *.bbl *.bak

allclean: clean
	rm -rf $(target).pdf

spell:
	aspell --lang=en -t check $(target).tex

wc:
	detex $(target).tex | wc -w

notes:
	(cd ~/thesis/github/notes.new && make notes)

quotes:
	(cd ~/thesis/github/notes.new && make quotes)

bib:
	vi $(references)

changes:
	git diff

commit:
	git add *
	git commit
	git pull
	git push

