
![img](https://c.wallhere.com/photos/9d/e5/Neon_Genesis_Evangelion_Seele_flag-1220722.jpg!d)

# Seele

This file is part of the Personal Site Engine. It contains the implementation of various functions used in the engine, mainly for processing routes and exporting content to HTML files ( SSG ).

## Library Used

The following libraries are used in this file:

- [Dream](https://aantron.github.io/dream/): A web framework for OCaml with a focus on developer productivity and ease of use.
- [Cohttp](https://github.com/mirage/ocaml-cohttp): An OCaml library for HTTP client and server communication. Used to fetch content from URLs.
- [Lwt](https://github.com/ocsigen/lwt): A cooperative threading library for OCaml. Used for handling asynchronous operations.
- [Omd](https://github.com/ocaml/omd): An OCaml library for parsing and rendering Markdown. Used for converting Markdown to HTML.

## Functions

### `fetch_url`

This function is used to fetch the content of a given URL using the Cohttp library. It returns a promise that resolves to a tuple containing the HTTP response code and the response body.

### `process_route`

This function processes a list of routes and their corresponding types. It maps each route to a Dream handler based on its type. The resulting list of handlers is returned.

### `mkdir_p`

This function recursively creates directories for a given path. It checks if the path already exists and creates the directories if they don't exist.

### `export_to_html`

This function exports routes to HTML files. It creates a directory structure based on the routes and saves the corresponding content as HTML files. Static routes are saved as HTML files directly, while dynamic routes fetch content from a specified URL and save it as HTML files.

### `markdown_to_html`

This function converts a Markdown string to HTML using the Omd library.

### `list_markdown_files`

This function lists all Markdown files in a directory.

### `load_markdown_file`

This function loads the content of a Markdown file.

### Types

#### `route_type`

This type represents the different types of routes:

- `Static of Dream_html.node`: Represents a static route with an HTML node.
- `Dynamic of Dream.handler * string list`: Represents a dynamic route with a Dream handler and a list of blog names.
- `Exclude of Dream.route`: Represents an excluded route.

#### `env`

This type represents the environment configuration:

- `Dev`: Represents the development environment.
- `Prod`: Represents the production environment.

## TODO:
- [x] Add more functions for processing routes and content, especially for dynamic routes like fetching markdown content and converting it to HTML.
- [ ] export static folder to the output directory.
- [ ] Integrate Tailwind CSS minified.
