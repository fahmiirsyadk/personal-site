# Personal Site Engine

This file is part of the Personal Site Engine. It contains the implementation of various functions used in the engine, mainly for processing routes and exporting content to HTML files ( SSG ).

## Library Used

The following library is used in this file:

- [Dream](https://aantron.github.io/dream/): A web framework for OCaml with a focus on developer productivity and ease of use.
- [Cohttp](https://github.com/mirage/ocaml-cohttp): An OCaml library for HTTP client and server communication. Used to fetch content from URLs.
- [Lwt](https://github.com/ocsigen/lwt): A cooperative threading library for OCaml. Used for handling asynchronous operations.

## Functions

### `fetch_url`

This function is used to fetch the content of a given URL using the Cohttp library. It returns a promise that resolves to a tuple containing the HTTP response code and the response body.

### `process_route`

This function processes a list of routes and their corresponding types. It maps each route to a Dream handler based on its type. The resulting list of handlers is returned.

### `mkdir_p`

This function recursively creates directories for a given path. It checks if the path already exists and creates the directories if they don't exist.

### `export_to_html`

This function exports routes to HTML files. It creates a directory structure based on the routes and saves the corresponding content as HTML files. Static routes are saved as HTML files directly, while dynamic routes fetch content from a specified URL and save it as html files.

if route is of type `Static`, the function saves the HTML node to a file with the same name as the route. If the route is of type `Dynamic`, the function fetches the content from the URL specified in the route and saves it as an HTML file.

### `read_env_file`

This function reads the contents of a `.env` file and returns a list of non-empty lines, excluding comments.

### `is_env_dev`

This function checks if the environment variable `DEV` is set to `true` in the `.env` file. It returns `true` if the variable is set, `false` otherwise.

### Types

#### `route_type`

This type represents the different types of routes:

- `Static of Dream_html.node`: Represents a static route with an HTML node.
- `Dynamic of Dream.handler`: Represents a dynamic route with a Dream handler.
- `Exclude of Dream.route`: Represents an excluded route.

## TODO:
- [ ] Add more functions for processing routes and content especially for dynamic routes like fetching markdown content and converting it to HTML.
- [ ] Tailwindcss minified integration