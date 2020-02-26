defmodule Postex.Validate do
  @moduledoc "For validating at compile time"
  alias Postex.Post

  @doc "Raises if there are any duplicate slugs"
  @spec no_duplicate_slugs([Post.t()]) :: [Post.t()]
  def no_duplicate_slugs(posts) do
    unique_slugs =
      posts
      |> to_slugs()
      |> Enum.uniq()

    if Enum.count(posts) == Enum.count(unique_slugs) do
      posts
    else
      bad_slug =
        posts
        |> to_slugs
        |> Kernel.--(unique_slugs)
        |> List.first()

      bad_files =
        posts
        |> Enum.filter(fn post -> post.id == bad_slug end)
        |> Enum.map(fn post -> post.filename end)
        |> Enum.join(", ")

      raise """
      Duplicate slug #{bad_slug} detected in files:

      #{bad_files}

      Please correct and recompile.
      """
    end
  end

  @doc """
  Raises unless the prefix is set for the use Macro, i.e.

  ```
  use Postex, prefix: "https://www.yoursite.com/posts/"
  ```

  or is explicitly disabled, i.e.

  ```
  use Postex, prefix: false
  ```
  """
  @spec prefix_defined(binary | nil) :: :ok
  def prefix_defined(nil) do
    raise """
    Please define your post prefix, i.e.

    use Postex, prefix: "https://www.yoursite.com/posts/"

    or explicitly disable with:

    use Postex, prefix: false
    """
  end

  def prefix_defined(prefix), do: prefix

  @max_length 60

  @doc """
    Raises unless all urls (prefix + slug) are less than 60 characters (for SEO) as per [Neil Patel](https://neilpatel.com/blog/seo-urls/).

    Feature can be disabled by setting prefix to `false`
  """
  @spec url_length([Post.t()], false | binary) :: [Post.t()]
  def url_length(posts, false) do
    posts
  end

  def url_length(posts, prefix) do
    too_long = Enum.filter(posts, fn post -> String.length(prefix <> post.id) > @max_length end)

    case too_long do
      [] ->
        posts

      posts ->
        posts_message =
          posts
          |> Enum.map(fn post -> url_error_message(post, prefix) end)
          |> Enum.join("\n\n")

        raise """
        The following posts have addresses that are greater than 60 characters, which negatively impacts SEO.
        Reference: https://neilpatel.com/blog/seo-urls/

        #{posts_message}
        """
    end
  end

  defp to_slugs(posts), do: Enum.map(posts, fn post -> post.id end)

  defp url_error_message(post, prefix) do
    "#{post.filename}:\n#{prefix <> post.id}\n#{String.length(prefix <> post.id)} characters"
  end
end
