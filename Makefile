lexer:
	cd src && alex Lexer.x

parser:
	cd src && happy Parser.y

build: lexer parser
	cd src && ghc Main.hs -o ../build/imp -hidir ../tmp -odir ../tmp

clean:
	rm build/* tmp/*
