defmodule Postex.MetaData do
  @moduledoc "A tickle trunk full of all the extra little things"
  alias Postex.Post

  @doc "Add the top three related posts, scored based on how many of the same tags they have."
  @spec add_related_posts([Post.t()]) :: [Post.t()]
  def add_related_posts(posts) do
    Enum.map(posts, fn post -> add_related_posts(post, posts) end)
  end

  @spec add_related_posts(Post.t(), [Post.t()]) :: Post.t()
  def add_related_posts(post, posts) do
    tags = post.tags
    id = post.id

    related_posts =
      posts
      |> Stream.reject(fn post -> post.id == id end)
      |> Stream.map(fn post -> {count_related_tags(post, tags), post} end)
      |> Enum.sort(&(elem(&1, 0) >= elem(&2, 0)))
      |> Enum.take(5)
      |> Enum.map(fn {_count, post} -> post end)

    %Post{post | related_posts: related_posts}
  end

  defp count_related_tags(post, tags) do
    post
    |> Map.get(:tags)
    |> Enum.filter(fn tag -> tag in tags end)
    |> Enum.count()
  end
end
