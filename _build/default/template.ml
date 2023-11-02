#1 "template.eml.html"
let render param =
let ___eml_buffer = Buffer.create 4096 in
(Buffer.add_string ___eml_buffer "<html>\n<body>\n  <h1>The URL parameter was ");
(Printf.bprintf ___eml_buffer "%s" (Dream_pure.Formats.html_escape (
#4 "template.eml.html"
                                  param 
)));
(Buffer.add_string ___eml_buffer "!</h1>\n</body>\n</html>");
(Buffer.contents ___eml_buffer)
