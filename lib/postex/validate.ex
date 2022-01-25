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
        |> Enum.map_join(", ", fn post -> post.filename end)

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
          Enum.map_join(posts, "\n\n", fn post -> url_error_message(post, prefix) end)

        raise """
        The following posts have addresses that are greater than 60 characters, which negatively impacts SEO.
        Reference: https://neilpatel.com/blog/seo-urls/

        #{posts_message}
        """
    end
  end

  @spec same_data_fields([Post.t()]) :: [Post.t()]
  def same_data_fields(posts) do
    sorted_posts =
      Enum.sort(posts, fn one, two -> Enum.count(one.data) >= Enum.count(two.data) end)

    first = List.first(sorted_posts)
    last = List.last(sorted_posts)

    if Enum.count(first.data) == Enum.count(last.data) do
      posts
    else
      first_keys = first |> Map.get(:data) |> Map.keys()
      last_keys = last |> Map.get(:data) |> Map.keys()

      raise """
        Your data fields are inconsistent across posts

        #{first.filename} has the following keys under data: #{inspect(first_keys)}
        #{last.filename} has the following keys under data: #{inspect(last_keys)}
      """
    end
  end

  defp to_slugs(posts), do: Enum.map(posts, fn post -> post.id end)

  defp url_error_message(post, prefix) do
    "#{post.filename}:\n#{prefix <> post.id}\n#{String.length(prefix <> post.id)} characters"
  end
end
