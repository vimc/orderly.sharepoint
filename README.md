## orderly.sharepoint

<!-- badges: start -->
[![Project Status: Concept – Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
[![Build Status](https://travis-ci.com/vimc/orderly.sharepoint.svg?branch=master)](https://travis-ci.com/vimc/orderly.sharepoint)
[![codecov.io](https://codecov.io/github/vimc/orderly.sharepoint/coverage.svg?branch=master)](https://codecov.io/github/vimc/orderly.sharepoint?branch=master)
<!-- badges: end -->

An [`orderly`](https://github.com/vimc/orderly) remote hosted on sharepoint, using [`pointr`](https://github.com/reside-ic/pointr).  This is experimental!

### Usage

Configure your `orderly_config.yml` as, for example:

```
remote:
  real:
    driver: orderly.sharepoint::orderly_remote_sharepoint
    args:
      url: https://example.com
      site: mysite
      path: Shared Documents/orderly/real
  testing:
    driver: orderly.sharepoint::orderly_remote_sharepoint
    args:
      url: https://example.com
      site: mysite
      path: Shared Documents/orderly/testing
```

Where

* `url` is the base url of your Office365/sharepoint site, such as `myorg.sharepoint.com`
* `site` is your sitename on sharepoint
* `path` is the path within your site name where documents will be stored

The configuration above lists two remotes, one "real" and one "testing", which we have found a useful pairing.  You might configure sharepoint to allow anyone in your group to read from both, but only certain people to push to `real`.

`orderly.sharepoint` will store files as `archive/<name>/<id>` where `<name>` is the report name and `<id>` is a zip archive of the report contents.  These must be treated as read-only and must not be modified (they do not have a file extension to help this).

With this set up, then `orderly::pull_dependencies`, `orderly::pull_archive` and `orderly::push_archive` will work, and you can use your sharepoint site to distribute orderly results within your group.

## License

MIT © Imperial College of Science, Technology and Medicine
