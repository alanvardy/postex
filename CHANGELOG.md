# Changelog

## Unreleased

## v0.1.8 (2022-09-04)

- Enforce no spaces in tags with clear error message
- Update GitHub cache action to v2
- Update asset path in instructions
- Update Elixir and OTP versions

## v0.1.7 (2021-01-24)

- Update Elixir and Erlang versions
- Use new GitHub action for building Elixir/Erlang
- Update dependencies

## v0.1.6 (2020-10-14)

- Update dependencies.

## v0.1.5 (2020-8-13)

- Update dependencies.

## v0.1.4 (2020-8-11)

- Update dependencies.
- Fix tests to match slightly different output.

## v0.1.3 (2020-3-12)

- All external links (identified by beginning with `http`) open in a new tab
- Added `:external_links_new_tab` option when using postex, defaults to `true`
- Added `list_posts/1` and `pages/0` for paginating posts
- Added `:per_pages` option when using postex, defaults to `10`

## v0.1.2 (2020-2-26)

- Added `:related_posts` association to posts, listing the top 5 related posts based on tags.
- Custom fields can be added to the markdown file, they will appear under the `:data` key as a map.
- Validates that the fields under data are consistent across posts.

## v0.1.1 (2020-2-26)

- Breaking change: Need to define prefix in use statement, or explicitly set to false
- Verify url with slug does not exceed 60 characters
- Check for duplicate slugs and raise error if found.

## v0.1.0 (2020-2-18)

- Initial release
