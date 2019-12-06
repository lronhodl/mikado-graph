### Generate a Mikado Graph from GitHub Issues dependencies

Use the [GitHub API](https://developer.github.com/v3/) to extract GitHub Issues dependencies from a repository and create a [Mikado Graph](https://pragprog.com/magazines/2010-06/the-mikado-method) from that data.

### Usage

 - [Create a GitHub personal access token.](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) This should be made by a member of the organization who can see private repositories.
 - Place the access token in the file `~/.github.yml`:

``` yaml
token: 1234567890feedfacedeadbeefcafe0987654321
```

 - Bundle, and run the script:

```
$ bundle install --path vendor/bundler
$ bundle exec script/mikado-graph.rb ...

Usage:

  script/mikado-graph.rb <owner/repository>
```

Example session:

```
# TODO
```

You can also set the environment variable `$DEBUG` if you want more verbose output during the fetch process.
