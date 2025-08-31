![Panda CMS](https://github.com/pandacms/.github/blob/main/images/panda-transparent-small.png?raw=true)

# Panda CMS Generators

This repository contains our generators and template files used for a basic setup of Panda CMS.

## Installation Files

* `.railsrc` defaults to using Propshaft for assets, Tailwind CSS as a CSS framework, and PostgreSQL as a database. This is our standard (and most-tested) approach for running Panda CMS.
* `template.rb` adds Panda CMS and a basic theme (`plain24`) using Tailwind CSS.

# Usage

To use the generator, call (where **demo** is the name of your new application):

```
rails new demo $(curl -fsSL https://raw.githubusercontent.com/tastybamboo/generator/main/.railsrc) -m https://raw.githubusercontent.com/tastybamboo/generator/main/template.rb
```