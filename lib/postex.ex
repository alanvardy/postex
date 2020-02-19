defmodule Postex do
  @moduledoc """
  Postex is a simple static blog generator using markdown files that is inspired/copied from
  [Dashbit's blog post](https://dashbit.co/blog/welcome-to-our-blog-how-it-was-made).

  See the README for more details!
  """
  defmacro __using__(_opts) do
    quote do
      alias Postex.Post

      for app <- [:earmark, :makeup_elixir] do
        Application.ensure_all_started(app)
      end

      # POSTS

      posts_paths =
        "posts/**/*.md"
        |> Path.wildcard()
        |> Enum.reject(fn post -> String.contains?(post, "draft") end)
        |> Enum.sort()

      posts =
        for post_path <- posts_paths do
          @external_resource Path.relative_to_cwd(post_path)
          Post.parse!(post_path)
        end

      @posts Enum.sort_by(posts, & &1.date, {:desc, Date})

      @doc "Returns a list of all the posts"
      @spec list_posts :: [Post.t()]
      def list_posts do
        @posts
      end

      @doc "Returns a list of all the posts with a tag"
      @spec posts_tagged_with(binary) :: [Post.t()]
      def posts_tagged_with(tag) do
        Enum.filter(@posts, fn post -> Enum.member?(post.tags, tag) end)
      end

      @doc "Gets a specific post by the id (slug)"
      @spec get_post(binary) :: Post.t() | nil
      def get_post(id) do
        Enum.find(@posts, fn post -> post.id == id end)
      end

      @spec fetch_post(binary) :: {:ok, Post.t()} | {:error, :not_found}
      def fetch_post(id) do
        case get_post(id) do
          nil -> {:error, :not_found}
          post -> {:ok, post}
        end
      end

      # TAGS

      @tags_with_count posts
                       |> Enum.map(fn post -> post.tags end)
                       |> List.flatten()
                       |> Enum.frequencies()

      @doc "Gets a list of all the tags"
      @spec list_tags :: [binary]
      def list_tags do
        Map.keys(@tags_with_count)
      end

      @doc "Returns a map with the tags as keys and the frequency as a value"
      @spec tags_with_count :: map
      def tags_with_count do
        @tags_with_count
      end
    end
  end
end
