# Adding CSS to your post

Here is a part of my SASS file to get you started. I initially used Bootstrap 4; if you use a different framework or vanilla CSS, you need to replace the `@extend`s with something else.

```css
// I wrap the HTML output in .blog-body
.blog-body {
  @extend .bg-white;
  @extend .text-black;
  @extend .my-4;
  @extend .rounded;
  @extend .p-5;
  @extend .shadow;
}

// Headings

.blog-body > h3 {
  margin-top: 2rem;
  @extend .text-primary;
}

// Pictures

.blog-body > p > img {
  @extend .w-50;
  @extend .d-block;
  @extend .mx-auto;
  @extend .rounded;
  @extend .shadow;
  @extend .my-4;
}

// Syntax Highlighting

pre {
  background-color: rgb(36, 40, 46);
  @extend .p-3;
  @extend .rounded;
  @extend .shadow;
  @extend .m-3
}

.kd, .k {color: rgb(219, 112, 219);}
.nc, .p {color: rgb(241, 224, 63);}
.sr, .se, .nf, .kn{color: rgb(146, 195, 235)}
.s, .c {color: rgb(128, 128, 128)}
.na, .ni {color: rgb(194, 62, 62);}
.n, .o, .no {color: rgb(231, 231, 231)}
.ss {color: rgb(59, 212, 205)}
```
