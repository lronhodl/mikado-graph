### Generate a Mikado Graph from GitHub Issues dependencies

Use the [GitHub API](https://developer.github.com/v3/) to extract GitHub Issues dependencies from a repository and create a [Mikado Graph](https://pragprog.com/magazines/2010-06/the-mikado-method) from that data.

### Usage

 - [Create a GitHub personal access token.](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) This should be made by a member of the organization who can see private repositories.
 - Place the access token in the file `~/.github.yml`:

``` yaml
token: 1234567890feedfacedeadbeefcafe0987654321
```
 - Install graphviz

Mac OS X:

```
$ brew install graphviz
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
$ bundle exec script/mikado-graph.rb lronhodl/provisioning
https://github.com/lronhodl/provisioning/issues/26 ("Implement a Mikado graph tool to visualize work-to-be-done for GitHub issues"):

https://github.com/lronhodl/provisioning/issues/25 ("Improve etc-files to expose collapsible diff for no-op deployments"):

https://github.com/lronhodl/provisioning/issues/24 ("Make provisioning resources in a cluster self-service"):

https://github.com/lronhodl/provisioning/issues/23 ("Automate testing properties of the installed openBSD systems (network properties, etc.)"):

https://github.com/lronhodl/provisioning/issues/21 ("Define a spec for terraform provisioning (SCROATs, etc.)"):

https://github.com/lronhodl/provisioning/issues/12 ("Implement terraform deployments for ESX, by hand (likely on laptop)"):

https://github.com/lronhodl/provisioning/issues/9 ("Make a whiskey_diff for computing etc-files diffs for a node."):

https://github.com/lronhodl/provisioning/issues/10 ("Modify whiskey_disk (or extract the basic algorithm) for use in applying etc-files to a node."):

https://github.com/lronhodl/provisioning/issues/8 ("Handle SSH credentials for CI automation of cluster management"):

https://github.com/lronhodl/provisioning/issues/11 ("CI-ification of etc-files"):
	https://github.com/lronhodl/provisioning/issues/9 ("Make a whiskey_diff for computing etc-files diffs for a node.")
	https://github.com/lronhodl/provisioning/issues/10 ("Modify whiskey_disk (or extract the basic algorithm) for use in applying etc-files to a node.")
	https://github.com/lronhodl/provisioning/issues/8 ("Handle SSH credentials for CI automation of cluster management")

https://github.com/lronhodl/provisioning/issues/13 ("Automated (CI-ified) terraform deployments to cluster"):
	https://github.com/lronhodl/provisioning/issues/12 ("Implement terraform deployments for ESX, by hand (likely on laptop)")
	https://github.com/lronhodl/provisioning/issues/11 ("CI-ification of etc-files")

https://github.com/lronhodl/provisioning/issues/22 ("Implement an algorithm to provision via terraform from a spec"):
	https://github.com/lronhodl/provisioning/issues/21 ("Define a spec for terraform provisioning (SCROATs, etc.)")
	https://github.com/lronhodl/provisioning/issues/13 ("Automated (CI-ified) terraform deployments to cluster")

https://github.com/lronhodl/provisioning/issues/20 ("Smart terraform provisioning"):
	https://github.com/lronhodl/provisioning/issues/21 ("Define a spec for terraform provisioning (SCROATs, etc.)")
	https://github.com/lronhodl/provisioning/issues/22 ("Implement an algorithm to provision via terraform from a spec")
	https://github.com/lronhodl/provisioning/issues/13 ("Automated (CI-ified) terraform deployments to cluster")

https://github.com/lronhodl/provisioning/issues/14 ("Build a plex node"):
	https://github.com/lronhodl/provisioning/issues/13 ("Automated (CI-ified) terraform deployments to cluster")
	https://github.com/lronhodl/provisioning/issues/13 ("Automated (CI-ified) terraform deployments to cluster")

https://github.com/lronhodl/provisioning/issues/18 ("Make it possible to copy content"):
	https://github.com/lronhodl/provisioning/issues/14 ("Build a plex node")

https://github.com/lronhodl/provisioning/issues/19 ("Add a chatop to sync content from one cluster to another"):
	https://github.com/lronhodl/provisioning/issues/18 ("Make it possible to copy content")

https://github.com/lronhodl/provisioning/issues/16 ("Build an rtorrent "seed box" node"):
	https://github.com/lronhodl/provisioning/issues/13 ("Automated (CI-ified) terraform deployments to cluster")

https://github.com/lronhodl/provisioning/issues/15 ("Build a mover-encoder ("move-coder") node"):
	https://github.com/lronhodl/provisioning/issues/13 ("Automated (CI-ified) terraform deployments to cluster")

https://github.com/lronhodl/provisioning/issues/17 ("Make it possible to get new content to put into the media store"):
	https://github.com/lronhodl/provisioning/issues/16 ("Build an rtorrent "seed box" node")
	https://github.com/lronhodl/provisioning/issues/15 ("Build a mover-encoder ("move-coder") node")

https://github.com/lronhodl/provisioning/issues/7 ("Set up GH Actions CI for `apply-ldap` repository"):

https://github.com/lronhodl/provisioning/issues/6 ("`apply-ldap` CI should use a simulated (example) LDAP config repository"):

https://github.com/lronhodl/provisioning/issues/5 ("CI for `apply-ldap` should run against the configuration docker container's LDAP server"):

https://github.com/lronhodl/provisioning/issues/4 ("`apply-ldap` should define a docker container which spins up a basic LDAP server"):

https://github.com/lronhodl/provisioning/issues/2 ("apply-ldap should have a docker container definition for CI"):


```

You can also set the environment variable `$DEBUG` if you want more verbose output during the fetch process.
