let ocamlVersion =
  (* show ocaml version as string *)
  Sys.ocaml_version |> Printf.sprintf "OCaml %s"

let render =
  <html lang="id">
  <head>
    <title>fahmiirsyadk</title>
    <meta name="generator" content="Dust 0.2.9">
    <meta name="author" content="fahmi irsyad khairi">
    <meta name="description" content="FAHMIIRSYADK is a personal/blog website authored by fahmi irsyad khairi">
    <meta name="title" content="fahmiirsyadk">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
    <link rel="stylesheet" href="/static/style.css">
    <link rel="icon" type="image/png" sizes="16x16" href="/assets/images/16x16.png">
    <link rel="icon" type="image/png" sizes="32x32" href="/assets/images/32x32.png">
    <style>
      #terminal::-webkit-scrollbar {
        width: 0;
      }
    </style>
  </head>
  
  <body class="bg-neutral-100">
    <main class="flex items-start justify-center min-h-screen">
      <section class="p-10 max-w-2xl w-full">
        <div class="flex w-full justify-center items-center">
          <div>
            <svg width="60" height="30" viewBox="0 0 125 57" fill="black" xmlns="http://www.w3.org/2000/svg">
              <path
                d="M0.896283 29.1184C0.322916 29.6824 0 30.4529 0 31.2572V53.5C0 55.1569 1.34315 56.5 3 56.5H29.2406C30.0461 56.5 30.8179 56.176 31.382 55.601L44.8586 41.8653C46.74 39.9476 50 41.2798 50 43.9663V53.5C50 55.1569 51.3431 56.5 53 56.5H97.2406C98.0461 56.5 98.8179 56.176 99.382 55.601L123.641 30.8751C124.192 30.3142 124.5 29.5598 124.5 28.7741V3C124.5 1.34315 123.157 0 121.5 0H111.743C110.947 0 110.184 0.316071 109.621 0.87868L101.621 8.87868C99.7314 10.7686 96.5 9.43007 96.5 6.75736V3C96.5 1.34315 95.1569 0 93.5 0H81.7281C80.9411 0 80.1855 0.309303 79.6244 0.861221L61.6037 18.5865C59.7068 20.4523 56.5 19.1085 56.5 16.4477V3C56.5 1.34315 55.1569 0 53.5 0H31.7281C30.9411 0 30.1855 0.309303 29.6244 0.861222L0.896283 29.1184Z"
                fill="black" />
            </svg>
          </div>
        </div>
        <div class="relative my-4 oveflow-hidden">
          <div class="w-full h-[200px] sm:h-[160px] flex justify-center relative overflow-hidden cursor-pointer group">
          </div>
        </div>
        <h4 class="text-sm sm:text-xs italic text-center">Personal journal as place for thoughts.</h4>
        <h4 class="text-sm sm:text-xs text-center my-4">~~*~~</h4>
        <section>
          <article>
            <h2
              class="relative flex justify-between w-full before:absolute before:bottom-[0.4rem] before:w-full before:leading-[0px] before:border-black before:border-b-2 before:border-dotted text-neutral">
              <span class="bg-neutral-100 pr-1 relative z-10">[01] <b
                  class="italic text-neutral-700">About</b></span><span
                class="bg-neutral-100 space-x-2 relative z-10 flex items-center"><span>[</span><a href="#"
                  class="hover:text-orange-600">More</a><span>]</span></span></h2>
            <div class="my-4 sm:my-8">
              <h1 class="text-base sm:text-sm">I'm <strong>fah</strong>, a front-end developer who <i>kinda</i> like
                experiment with things. Through this site, I write journals, portfolios, or showcases some of my
                experiments.</h1>
            </div>
          </article>
          <article>
            <h2
              class="relative flex justify-between w-full before:absolute before:bottom-[0.4rem] before:w-full before:leading-[0px] before:border-black before:border-b-2 before:border-dotted text-neutral">
              <span class="bg-neutral-100 pr-1 relative z-10">[02] <b
                  class="italic text-neutral-700">Writings</b></span><span
                class="bg-neutral-100 space-x-2 relative z-10 flex items-center"><span>[</span><a href="#"
                  class="hover:text-orange-600">More</a><span>]</span></span></h2>
            <div class="my-4 sm:my-8"><a href="/writings/deconstruct-site"
                class="flex justify-between group items-center">
                <div class="flex space-x-2 font-bold sm:-ml-2"><span class="sm:hidden sm:invisible">↪</span>
                  <h3
                    class="flex-1 underline decoration-wavy decoration-neutral-400 underline-offset-2 group-hover:decoration-orange-600">
                    Deconstruct the site</h3><span class="text-transparent group-hover:text-orange-600">⁕</span>
                </div><span class="flex-none italic text-neutral-600 text-xs">--- Sat, Aug 20 2022</span>
              </a></div>
          </article>
          <article>
            <h2
              class="relative flex justify-between w-full before:absolute before:bottom-[0.4rem] before:w-full before:leading-[0px] before:border-black before:border-b-2 before:border-dotted text-neutral">
              <span class="bg-neutral-100 pr-1 relative z-10">[03] <b
                  class="italic text-neutral-700">Projects</b></span><span
                class="bg-neutral-100 space-x-2 relative z-10 flex items-center"><span>[</span><a href="#"
                  class="hover:text-orange-600">More</a><span>]</span></span></h2>
            <div class="my-4 sm:my-8"></div>
          </article>
        </section>
      </section>
    </main>
    <footer class="bg-neutral-100" style="position: fixed; width: 100%; bottom: 0; z-index: 0;">
      <div class="text-sm font-semibold absolute z-0 bottom-2 text-neutral-600 w-full text-center">
        fa-h 2023 | <%s ocamlVersion %>
      </div>
      <pre
        class="text-sm absolute bottom-0 right-14"><code class="block font-sans"> </code><code class="block font-sans"> </code><code class="block font-sans text-orange-600 font-bold">@</code><code class="block font-sans">|</code></pre>
      <pre
        class="text-sm absolute bottom-0 right-56"><code class="block font-sans text-orange-600 font-bold">***</code><code class="block font-sans text-orange-600 font-bold">***</code><code class="block font-sans"> |</code><code class="block font-sans"> |</code></pre>
      <pre
        class="text-sm absolute bottom-0 right-64"><code class="block font-sans"> </code><code class="block font-sans"> </code><code class="block font-sans text-orange-600 font-bold">@</code><code class="block font-sans">|</code></pre>
      <pre
        class="text-sm absolute bottom-0 left-14"><code class="block font-sans text-orange-600 font-bold">***</code><code class="block font-sans text-orange-600 font-bold">***</code><code class="block font-sans"> |</code><code class="block font-sans"> |</code></pre>
      <pre
        class="text-sm absolute bottom-0 right-32"><code class="block font-sans"> </code><code class="block font-sans"> </code><code class="block font-sans text-orange-600 font-bold">@</code><code class="block font-sans">|</code></pre>
      <pre
        class="text-sm absolute bottom-0 right-20"><code class="block font-sans text-orange-600 font-bold">***</code><code class="block font-sans text-orange-600 font-bold">***</code><code class="block font-sans"> |</code><code class="block font-sans"> |</code></pre>
      <pre
        class="text-sm absolute bottom-0 left-56"><code class="block font-sans"> </code><code class="block font-sans"> </code><code class="block font-sans text-orange-600 font-bold">@</code><code class="block font-sans">|</code></pre>
    </footer>
  </body>
  </html>