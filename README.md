# Postex

[![Build Status](https://github.com/alanvardy/postex/workflows/Unit%20Tests/badge.svg)](https://github.com/alanvardy/postex)[![Build Status](https://github.com/alanvardy/postex/workflows/Dialyzer/badge.svg)](https://github.com/alanvardy/postex) [![hex.pm](http://img.shields.io/hexpm/v/postex.svg?style=flat)](https://hex.pm/packages/postex)

Postex is a simple static blog generator using markdown files that is inspired/shamelessly copied from [Dashbit's blog post](https://dashbit.co/blog/welcome-to-our-blog-how-it-was-made).

The posts are generated at compile time, and syntax highlighting works well. Earmark is used 
for markdown parsing and makeup_elixir / stolen ex_doc code for syntax highlighting. Phoenix_html is pulled in for a single protocol implementation.

This library just provides the context. The routes, views, controllers and templates are still in your hands.

Most of this work is not my own, all credit to Dashbit and José Valim.

Documentation can be found at [https://hexdocs.pm/postex](https://hexdocs.pm/postex).

## Usage

Assuming that you `use Postex` in a module named `Blog`, your API is:

####  `Blog.list_posts/0`

Lists all the posts

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
    {:postex, "~> 0.1.0"}
  ]
end
```

Create a module and `use Postex` within it

```elixir
defmodule YourApp.Blog do
  @moduledoc "The blog context"
  use Postex
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

  ==footer==
  sometemplatepartial.html

  ==description==
  More text and stuff

  ==tags==
  separate,your tags, with, commas

  ==body==

  # This is a title

  ![alt text](picture.jpg "Awesome picture")

  This is a paragraph

```

Store your images in the path `/assets/static/images/blog/{year}/{picture.jpg}` and reference them by the filename only (as seen in the example above).

## Contributing

I welcome contributions, but please check with me before starting on a pull request - I would hate to have your efforts be in vain.
