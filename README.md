## orderly.sharepoint

<!-- badges: start -->
[![Project Status: Concept – Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
[![codecov.io](https://codecov.io/github/vimc/orderly.sharepoint/coverage.svg?branch=master)](https://codecov.io/github/vimc/orderly.sharepoint?branch=master)
[![R-CMD-check](https://github.com/vimc/orderly.sharepoint/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/vimc/orderly.sharepoint/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

An [`orderly1`](https://github.com/vimc/orderly1) remote hosted on Sharepoint, using [`spud`](https://github.com/reside-ic/spud).  This is experimental!

### Usage

Configure your `orderly_config.yml` as, for example:

```
remote:
  real:
    driver: orderly.sharepoint::orderly_remote_sharepoint
    args:
      url: https://example.sharepoint.com
      site: mysite
      path: Shared Documents/orderly/real
  testing:
    driver: orderly.sharepoint::orderly_remote_sharepoint
    args:
      url: https://example.sharepoint.com
      site: mysite
      path: Shared Documents/orderly/testing
```

Where

* `url` is the base url of your Office365/Sharepoint site, such as `myorg.sharepoint.com`
* `site` is your site name on Sharepoint
* `path` is the path within your site name where documents will be stored

The configuration above lists two remotes, one "real" and one "testing", which we have found a useful pairing.  You might configure Sharepoint to allow anyone in your group to read from both, but only certain people to push to `real`.

`orderly.sharepoint` will store files as `archive/<name>/<id>` where `<name>` is the report name and `<id>` is a zip archive of the report contents.  These must be treated as read-only and must not be modified (they do not have a file extension to help this).

With this set up, then `orderly1::pull_dependencies`, `orderly1::pull_archive` and `orderly1::push_archive` will work, and you can use your Sharepoint site to distribute orderly results within your group.

## License

MIT © Imperial College of Science, Technology and Medicine
