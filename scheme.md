# Scheme

O MIT-Scheme é um dialeto de LISP.

## Instalação

### OS X

Neste guia, usamos o brew para instalação do MIT-Scheme, portanto você já deve ter o brew instalado no seu sistema. Adicionalmente, vamos instalar o rlwrap, que intercepta o input e permite que as teclas de seta funcionem com o mit-scheme.

* Execute `brew install rlwrap`
* Execute `brew install mit-scheme --without-x11`

Após a instalação, para utilizar o REPL, basta executar: `rlwrap mit-scheme`.
