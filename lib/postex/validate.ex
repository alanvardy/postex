defmodule Postex.Validate do
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

  defp to_slugs(posts), do: Enum.map(posts, fn post -> post.id end)
end
