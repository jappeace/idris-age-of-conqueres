IDRIS = idris

all: install test app


install:
	$(IDRIS) --install app.ipkg

app:
	$(IDRIS) -i src -p contrib  app/app.idr -o a.out
	@echo "App executables @ a.out"


test: install
	$(IDRIS) -i src -p contrib  test/test.idr -o test.out
	@echo "Test executables @ test.out"
	./test.out

clean:
	$(IDRIS) --clean app.ipkg
	rm -f test.out a.out
	find . -name *~ -delete
	find . -name *.o -delete
	find . -name *.ibc -delete


.PHONY: app test clean
