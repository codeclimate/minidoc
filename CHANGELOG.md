# Change log

## master (unreleased)

### New features

### Bug fixes

### Changes

## 3.0.0 (2023-04-06)

## Changes
* Upgrade `mongo` dependency to support version `2.14.1`
## v2.1.0 (2019-05-10)

### Changes

* Allow support in a Rails 5 context ([@maxjacobson][])

## v2.0.1 (2017-10-24)

### Bug fixes

* `Minidoc::ReadOnly` should support per-class `connection` and `database`
  overrides, same as normal classes. ([@wfleming][])

## v2.0.0 (2017-05-02)

### New features

* Association methods that raise when the document is not found ([@pbrisbin][])

### Changes

* Removed transaction support. ([@wfleming][])

## v1.0.1 (2016-10-31)

### Bug fixes

* Updated `updated_at` when enabled from all setter methods. ([@wfleming][])

## v1.0.0 (2016-10-27)

No changes! Same as v1.0.0.rc2

:tada:

## v1.0.0.rc2 (2016-10-26)

### New features

* Allow omitting selectors to finder methods. ([@maxjacobson][])

### Bug fixes

* Minidoc#reload will raise Minidoc::DocumentNotFoundError when the document no longer exists, rather than a nil error. ([@maxjacobson][])

### Changes

* Make Minidoc.wrap and Minidoc.from_db private. ([@maxjacobson][])

## v1.0.0.rc1 (2016-09-29)

### New features

* [#24](https://github.com/codeclimate/minidoc/pull/24): Add `Minidoc.all`. ([@pbrisbin][])
* [#24](https://github.com/codeclimate/minidoc/pull/24): Add `Minidoc.find_one!`. ([@pbrisbin][])
* [#28](https://github.com/codeclimate/minidoc/pull/28): Add `Minidoc.find_one_or_initialize`. ([@nporteschaikin][])
* [#32](https://github.com/codeclimate/minidoc/pull/32): Infer class names for associations when not provided. ([@wfleming][])

### Bug fixes

* [#26](https://github.com/codeclimate/minidoc/pull/26): Improve performance of `Minidoc.exists?`. ([@wfleming][])
* [#31](https://github.com/codeclimate/minidoc/pull/31): Fix `save` dropping some attributes. ([@nporteschaikin][])
* Improve errors when the user has forgotten to provide database connection information. ([@maxjacobson][])

### Changes

* [#23](https://github.com/codeclimate/minidoc/pull/23): Remove `ensure_index`. ([@pbrisbin][])

## v0.0.1 (2016-09-28)

Minidoc was originally created by [@brynary][] and has been used in production extensively at Code Climate.
This is the first version released to rubygems.

[@brynary]: https://github.com/brynary
[@maxjacobson]: https://github.com/maxjacobson
[@nporteschaikin]: https://github.com/nporteschaikin
[@pbrisbin]: https://github.com/pbrisbin
[@wfleming]: https://github.com/wfleming
