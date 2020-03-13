defmodule Blog do
  @moduledoc "For testing only"
  use Postex,
    prefix: "https://postex.com/posts/",
    per_page: 1
end
