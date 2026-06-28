.PHONY: all swipl install

SWIPL := $(shell command -v swipl 2>/dev/null)
UNAME_S := $(shell uname -s)

all: install

install: swipl
	@swipl -q -s install.pl -g main -t halt

swipl:
	@if command -v swipl >/dev/null 2>&1; then \
		echo "ok swipl installed $$(command -v swipl)"; \
	elif command -v mise >/dev/null 2>&1 && mise plugins ls-remote | grep -qi '^swi-prolog\|^swipl'; then \
		echo "run swipl install mise"; \
		mise use -g swipl@latest || mise use -g swi-prolog@latest; \
		command -v swipl >/dev/null 2>&1; \
	elif [ "$(UNAME_S)" = "Darwin" ] && command -v brew >/dev/null 2>&1; then \
		echo "run swipl install brew"; \
		brew install swi-prolog; \
		command -v swipl >/dev/null 2>&1; \
	else \
		echo "fail swipl install no-supported-installer"; \
		exit 1; \
	fi
