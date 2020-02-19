defmodule Postex.Post do
  @moduledoc "An individual blog post"

  alias Postex.Highlighter
  @enforce_keys [:id, :author, :title, :body, :description, :tags, :date, :footer]
  defstruct [:id, :author, :title, :body, :description, :tags, :date, :footer]

  @type t :: %__MODULE__{
          id: binary,
          author: binary,
          title: binary,
          body: binary,
          description: binary,
          tags: [binary],
          date: Date.t()
        }

  defimpl String.Chars, for: __MODULE__ do
    @spec to_string(binary) :: binary
    def to_string(item), do: item
  end

  defimpl Phoenix.HTML.Safe, for: __MODULE__ do
    @spec to_iodata(%{title: binary}) :: binary
    def to_iodata(%{title: title}), do: to_string(title)
  end

  @spec parse!(binary) :: t()
  def parse!(filename) do
    # Get the last two path segments from the filename
    [year, month_day_id] = filename |> Path.split() |> Enum.take(-2)

    # Then extract the month, day and id from the filename itself
    [month, day, id_with_md] = String.split(month_day_id, "-", parts: 3)

    # Remove .md extension from id
    id = Path.rootname(id_with_md)

    # Build a Date struct from the path information
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")

    # Get all attributes from the contents
    contents = filename |> File.read!() |> parse_contents(year)
    # And finally build the post struct
    struct!(__MODULE__, [id: id, date: date] ++ contents)
  end

  defp parse_contents(contents, year) do
    # Split contents into  ["==title==\n", "this title", "==tags==\n", "this, tags", ...]
    parts = Regex.split(~r/^==(\w+)==\n/m, contents, include_captures: true, trim: true)

    # Now chunk each attr and value into pairs and parse them
    for [attr_with_equals, value] <- Enum.chunk_every(parts, 2) do
      [_, attr, _] = String.split(attr_with_equals, "==")
      attr = String.to_atom(attr)
      {attr, parse_attr(attr, value, year)}
    end
  end

  @attributes [:title, :description, :author, :footer]
  defp parse_attr(attribute, value, _year) when attribute in @attributes do
    String.trim(value)
  end

  defp parse_attr(:body, value, year) do
    value
    |> Earmark.as_html!()
    |> prepend_images(year)
    |> Highlighter.highlight_code_blocks()
  end

  defp parse_attr(:tags, value, _year) do
    value
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.sort()
  end

  defp prepend_images(content, year) do
    new_url = "<img src=\"" <> "/images/blog/#{year}/"
    Regex.replace(~r/<img src=\"/, content, new_url)
  end
end
