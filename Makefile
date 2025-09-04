SPEC = p4spectec

# Compile

.PHONY: build build-spec

EXEMAIN = p4/_build/default/bin/main.exe
EXESPEC = p4spec/_build/default/bin/main.exe
EXESPECBC = p4spec/_build/default/bin/main.bc

build: build-spec

build-spec:
	rm -f ./$(SPEC)
	opam switch 5.1.1
	cd p4spec && opam exec -- dune build bin/main.exe && echo
	ln -f $(EXESPEC) ./$(SPEC)
	ln -f $(EXESPECBC) ./$(SPEC).bc

debug:
	cd p4spec && rlwrap ocamldebug _build/default/bin/main.bc run-sl ../spec/*.watsup -i ../p4c/p4include -p ../p4c/testdata/p4_16_samples/strength5.p4

# Format

.PHONY: fmt

fmt:
	opam switch 5.1.0
	cd p4spec && opam exec dune fmt

# Tests

.PHONY: test-spec promote-spec

test-spec:
	echo "#### Running (dune runtest)"
	opam switch 5.1.0
	cd p4spec && opam exec -- dune runtest --profile=release && echo OK || (echo "####>" Failure running dune test. && echo "####>" Run \`make promote-spec\` to accept changes in test expectations. && false)

promote-spec:
	opam switch 5.1.0
	cd p4spec && opam exec -- dune promote

# Cleanup

.PHONY: clean

clean:
	rm -f ./$(SPEC)
	cd p4spec && dune clean
