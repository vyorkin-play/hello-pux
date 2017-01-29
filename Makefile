serve:
	pulp server --main Play.Main

build:
	pulp build --main Play.Main --to output/bundle.js

.PHONY: build serve
