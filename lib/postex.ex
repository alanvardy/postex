defmodule Postex do
  @moduledoc """
  Postex is a simple static blog generator using markdown files that is inspired/copied from
  [Dashbit's blog post](https://dashbit.co/blog/welcome-to-our-blog-how-it-was-made).

  See the README for more details!
  """
  defmacro __using__(opts) do
    prefix = Keyword.get(opts, :prefix)
    per_page = Keyword.get(opts, :per_page, 10)

    quote do
      alias Postex.{MetaData, Post, Validate}

      for app <- [:earmark, :makeup_elixir] do
        Application.ensure_all_started(app)
      end

      prefix =
        unquote(prefix)
        |> Validate.prefix_defined()

      # Generating posts

      posts_paths =
        "posts/**/*.md"
        |> Path.wildcard()
        |> Enum.reject(fn post -> String.contains?(post, "draft") end)
        |> Enum.sort()

      for post_path <- posts_paths do
        @external_resource Path.relative_to_cwd(post_path)
      end

      posts =
        posts_paths
        |> Enum.map(fn post -> Post.parse!(post, unquote(opts)) end)
        |> Validate.no_duplicate_slugs()
        |> Validate.url_length(prefix)
        |> Validate.same_data_fields()
        |> MetaData.add_related_posts()

      @posts Enum.sort_by(posts, & &1.date, {:desc, Date})

      # Posts API

      @doc "Returns a list of all the posts"
      @spec list_posts :: [Post.t()]
      def list_posts do
        @posts
      end

      @doc "Returns a list of posts for the page, accepts page as integer or string"
      @spec list_posts(pos_integer | String.t()) :: [Post.t()]
      def list_posts(page) when is_binary(page) do
        page
        |> String.to_integer()
        |> list_posts()
      end

      def list_posts(page) do
        per_page = unquote(per_page)
        start_index = (page - 1) * per_page
        end_index = page * per_page - 1

        Enum.slice(@posts, start_index..end_index)
      end

      @doc "Number of pages of posts"
      @spec pages :: non_neg_integer
      def pages do
        count = Enum.count(@posts)
        per_page = unquote(per_page)

        if rem(count, per_page) > 0 do
          div(count, per_page) + 1
        else
          div(count, per_page)
        end
      end

      @doc "Returns a list of all the posts with a tag"
      @spec posts_tagged_with(binary) :: [Post.t()]
      def posts_tagged_with(tag) do
        Enum.filter(@posts, fn %{tags: tags} -> Enum.member?(tags, tag) end)
      end

      @doc "Gets a specific post by the id (slug)"
      @spec get_post(binary) :: Post.t() | nil
      def get_post(id) do
        Enum.find(@posts, &(&1.id == id))
      end

      @spec fetch_post(binary) :: {:ok, Post.t()} | {:error, :not_found}
      def fetch_post(id) do
        case get_post(id) do
          nil -> {:error, :not_found}
          post -> {:ok, post}
        end
      end

      # Generating Tags

      @tags_with_count posts
                       |> Enum.map(fn post -> post.tags end)
                       |> List.flatten()
                       |> Enum.frequencies()

      # Tags API

      @doc "Gets a list of all the tags"
      @spec list_tags :: [binary]
      def list_tags do
        Map.keys(@tags_with_count)
      end

      @doc "Returns a map with the tags as keys and the frequency as a value"
      @spec tags_with_count :: %{String.t() => pos_integer}
      def tags_with_count do
        @tags_with_count
      end
    end
  end
end
