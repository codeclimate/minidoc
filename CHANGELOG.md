# Change log

## master (unreleased)

### New features

* [#24](https://github.com/codeclimate/minidoc/pull/24): Add `Minidoc.all`. ([@pbrisbin][])
* [#24](https://github.com/codeclimate/minidoc/pull/24): Add `Minidoc.find_one!`. ([@pbrisbin][])
* [#28](https://github.com/codeclimate/minidoc/pull/28): Add `Minidoc.find_one_or_initialize`. ([@nporteschaikin][])
* [#32](https://github.com/codeclimate/minidoc/pull/32): Infer class names for associations when not provided. ([@wfleming][])

### Bug fixes

* [#26](https://github.com/codeclimate/minidoc/pull/26): Improve performance of `Minidoc.exists?`. ([@wfleming][])
* [#31](https://github.com/codeclimate/minidoc/pull/31): Fix `save` dropping some attributes. ([@nporteschaikin][])

### Changes

* [#23](https://github.com/codeclimate/minidoc/pull/23): Remove `ensure_index`. ([@pbrisbin][])

## v0.0.1 (2016-09-28)

Minidoc was originally created by [@brynary][] and has been used in production extensively at Code Climate.
This is the first version released to rubygems.

[@brynary]: https://github.com/brynary
[@nporteschaikin]: https://github.com/nporteschaikin
[@pbrisbin]: https://github.com/pbrisbin
[@wfleming]: https://github.com/wfleming
