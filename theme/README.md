This directory contains our WordPress theme, really just a very light child
theme of [Astra](https://wpastra.com). It is built with the
[Bazel](https://bazel.build) build system.

Minimum survival commands:

```shell
$ bazel build //theme
$ gzip -c < bazel-bin/theme/astra-smt.tar |             \
    ssh -l root HOST                                    \
    tar xzf - -C /wordpress/wp-content/themes/astra-smt
```

There is no need to download NodeJS or any of the other related tools; Bazel
will do all the work.
