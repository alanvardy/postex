defmodule PostexTest do
  use ExUnit.Case

  @post %Postex.Post{
    author: "Alan Vardy",
    body:
      "<h1>This is a title</h1>\n<p><img src=\"/images/blog/2020/picture.jpg\" alt=\"alt text\" title=\"Awesome picture\" /></p>\n<p>This is text</p>\n",
    date: ~D[2020-03-17],
    description: "It is a description",
    footer: "_some_footer",
    id: "test-one",
    tags: ["tag one", "three", "two"],
    title: "Test of the testiest variety"
  }

  test "Can get post" do
    assert Blog.get_post("test-one") == @post
  end

  test "Can fetch post" do
    assert Blog.fetch_post("test-one") == {:ok, @post}
  end

  test "Can list posts" do
    assert Blog.list_posts() == [@post]
  end

  test "Can get tags" do
    assert Blog.list_tags() == @post.tags
  end

  test "Can get posts associated with tag" do
    assert Blog.posts_tagged_with("three") == [@post]
  end

  test "Can get count of tags" do
    assert Blog.tags_with_count() == %{"tag one" => 1, "three" => 1, "two" => 1}
  end
end
