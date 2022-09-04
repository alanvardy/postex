# Postex

[![Build Status](https://github.com/alanvardy/postex/workflows/Unit%20Tests/badge.svg)](https://github.com/alanvardy/postex)
[![Build Status](https://github.com/alanvardy/postex/workflows/Dialyzer/badge.svg)](https://github.com/alanvardy/postex)
[![hex.pm](http://img.shields.io/hexpm/v/postex.svg?style=flat)](https://hex.pm/packages/postex)
[![codecov](https://codecov.io/gh/alanvardy/exzeitable/branch/master/graph/badge.svg?token=P3O42SF7VJ)](https://codecov.io/gh/alanvardy/exzeitable)

Postex is a simple static blog generator using markdown files that was inspired/shamelessly copied from [Dashbit's blog post](https://dashbit.co/blog/welcome-to-our-blog-how-it-was-made).

The posts are generated at compile time, and syntax highlighting works well. Earmark is used
for markdown parsing and makeup_elixir / stolen ex_doc code for syntax highlighting. Phoenix_html is pulled in for a single protocol implementation.

This library just provides the context. The routes, views, controllers and templates are still in your hands.

Most of this work is not my own, all credit to Dashbit and José Valim.

Documentation can be found at [https://hexdocs.pm/postex](https://hexdocs.pm/postex).

This library is in use at [alanvardy.com](https://www.alanvardy.com/) ([GitHub](https://github.com/alanvardy/alan_vardy))

## Features

* Posts are generated at compile time (fast access, no database required)
* Posts live update as you edit them.
* Posts have tags
* Elixir syntax highlighting
* You can add as many additional fields as you want, they can be found under `:data` and are represented as a map.
* Includes 5 related posts (determined based on how many tags they share) as an association for each post
* Easy image handling (see below)

## Compile Time Checks

* Post url does not exceed 60 characters (for SEO - can be disabled)
* No duplicate slugs (post ids)
* All field keys are consistent across all posts (including within the data field)

## Usage

Assuming that you `use Postex` in a module named `Blog`, your API is:

#### `Blog.list_posts/0`

Lists all the posts

#### `Blog.list_posts/1`

With a given page, lists the posts for that page (default posts per page is 10)

#### `Blog.posts_tagged_with/1`

Pass it a single tag and it will return a list of the posts with that tag

#### `Blog.get_post/1`

Get a post by id (slug), returns `nil` if not found,

#### `Blog.fetch_post/1`

Get a post by id (slug), returns `{:ok, post}` or `{:error, :not_found}`
  
#### `Blog.list_tags/0`

Lists all the tags

#### `Blog.tags_with_count/0`

Returns a map where the string keys are the tags, and values are integers representing the frequency of their appearance.

## Installation

This library requires `Elixir >= 1.10`

Add `postex` to your list of dependencies in `mix.exs`:

```elixir
# mix.exs

def deps do
  [
    {:postex, "~> 0.1.8"}
  ]
end
```

Create a module and `use Postex` within it.

```elixir
defmodule YourApp.Blog do
  @moduledoc "The blog context"
  use Postex, 
    prefix: "https://exampleblog.com/posts/", # required
    external_links_new_tab: true, # default
    per_page: 10 # default
end
```

Add markdown file patterns to your Endpoint config in `config/dev.exs` for live reloading.

```elixir
# dev.exs

config :your_app, YourAppWeb.Endpoint,
  live_reload: [
    patterns: [
      ... the other patterns ...
      ~r"posts/*/.*(md)$"
    ]
  ]
```

And add some routes

```elixir
# router.ex

get "/blog", YourAppWeb.PostController, :index
resources "/post", YourAppWeb.PostController, only: [:show]
resources "/tag", YourAppWeb.TagController, only: [:index, :show]
```

And build out your controllers, views, and templates.

Check `CSS.md` for an example on styling the HTML output.

## Adding Templates and Pictures

Store markdown files with the path `/blog/{year}/{month}-{day}-{slug}.md`

For example `/blog/2020/03-17-this-is-a-blog-slug.md`

Format your markdown file like so

```markdown
==title==
Your Title Goes Here

==author==
Your name probably

==description==
More text and stuff

==tags==
separate,your_tags,with,commas

==body==

# This is a title

![alt text](picture.jpg "Awesome picture")

This is a paragraph

```

## External links

External links (identified by beginning with `http`) are automatically appended with `target: "_blank"` to make the link open in a new tab.

You can disable this functionality with

```elixir
defmodule YourApp.Blog do
  @moduledoc "The blog context"
  use Postex, 
    prefix: "https://exampleblog.com/posts/",
    external_links_new_tab: false
end
```

## Storing images

Store your images in the path `/priv/static/images/blog/{year}/{picture.jpg}` and reference them by the filename only (as seen in the example above).

## Pagination

If you wish to implement pagination, check out the [GitHub repository for alanvardy.com](https://github.com/alanvardy/alan_vardy) for examples of how I put it together.

## Recompiling

You may have occasional issues getting a markdown file recognized after being added or renamed, in this case run `mix compile --force`.

## Contributing

I welcome contributions, but please check with me before starting on a pull request - I would hate to have your efforts be in vain.
