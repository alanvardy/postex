# Changelog

## v0.1.3 (2019-3-12)

* All external links (identified by beginning with `http`) open in a new tab

## v0.1.2 (2019-2-26)

* Added `:related_posts` association to posts, listing the top 5 related posts based on tags.
* Custom fields can be added to the markdown file, they will appear under the `:data` key as a map.
* Validates that the fields under data are consistent across posts.

## v0.1.1 (2019-2-26)

* Breaking change: Need to define prefix in use statement, or explicitly set to false
* Verify url with slug does not exceed 60 characters
* Check for duplicate slugs and raise error if found.

## v0.1.0 (2019-2-18)

* Initial release
