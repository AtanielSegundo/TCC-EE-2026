# Como Compilar o TCC para PDF

## Instalando o Typst

Projeto Typst: https://github.com/typst/typst

* **Linux:** verifique o pacote da sua distribuição em https://repology.org/project/typst/versions, ou instale via Cargo:
  ```sh
  cargo install --locked typst-cli
  ```
* **macOS:**
  ```sh
  brew install typst
  ```
* **Windows:**
  ```sh
  winget install --id Typst.Typst
  ```

## [Opcional] Visualizando o PDF em tempo real

### SumatraPDF

O SumatraPDF recarrega o arquivo automaticamente sempre que ele é recompilado.

```sh
winget install --id SumatraPDF.SumatraPDF --exact --version 3.6.1
```

```sh
SumatraPDF.exe tcc_ee_ataniel.pdf
```

### VS Code + Tinymist

1. Instale a extensão [Tinymist Typst](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist).
2. Abra o arquivo `main.typ`, pressione `Ctrl+Shift+P` e execute:
   ```
   Typst Preview: Preview Opened File in Browser
   ```

## Formas de compilar o projeto

Compilação direta (cerca de 70 ms):
```sh
typst compile main.typ tcc_ee_ataniel.pdf
```

Modo *watch*, recompila a cada alteração (cerca de 5 ms por caractere):
```sh
typst watch main.typ tcc_ee_ataniel.pdf
```