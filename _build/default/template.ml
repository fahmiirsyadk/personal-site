#1 "template.eml.html"
let render param =
let ___eml_buffer = Buffer.create 4096 in
(Buffer.add_string ___eml_buffer "<html>\n  <script src=\"https://cdn.tailwindcss.com\"></script>\n</html>\n<body class=\"bg-black text-white\">\n  <h1>The URL PARAMETERS WAS ");
(Printf.bprintf ___eml_buffer "%s" (Dream_pure.Formats.html_escape (
#6 "template.eml.html"
                                   param 
)));
(Buffer.add_string ___eml_buffer "!</h1>\n</body>");
(Buffer.contents ___eml_buffer)
