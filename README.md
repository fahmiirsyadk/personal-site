<h1 align="center">Personal Site</h1>
<p align="center">
<q><i>Personal website to unify my fragmented thoughts</i></q>
</p>

<br>

<p align="center">
  <img src="https://static.wikia.nocookie.net/houkai-star-rail/images/5/5c/Stelle_Sticker_02.png/revision/latest?cb=20230420195524" alt="logo" width="150" height="auto" />
</p>
<p align="center"><strong>Built with OCaml 5.1</strong></p>

<br>

### Architecture of this site
- [Dream](https://github.com/aantron/dream) OCaml Web Framework
- [Dream-HTML](https://github.com/yawaramin/dream-html) Template Engine for Dream
- [TailwindCSS](https://tailwindcss.com/) you already know this XD

and etc, mostly used to run the static site generator engine.

### Folder structures

- **.github/workflows** -- run action to compile the site
- **engine/** -- SSG engine
- **pages/** -- all pages goes there
- **static/** -- static files
- **data/** -- Markdowns & blog articles source
- **templates/** -- Layout templates

### How to run it ?
You need to install Ocaml

#### [ 01 ] **Installation**
1. Install using Make
```bash
make deps
```

#### [ 02 ] **Running**
1. Create .env file
```.env
DEV=true
```
```bash
make watch
```
4. Open **localhost:8080**

### [ 03 ] **Build Production**
1. Make dev mode disabled
```.env
DEV=false
```
2. Run build command
```bash
make prod
```