# charm-native

Shared native extension for Charm Ruby ports.
## Development
This gem exists to ensure only one Go runtime is loaded into a Ruby process.

### Local development (forks + monorepo)

The Charm Ruby gems are portable by default (no `path:` gems in Gemfiles). For local development against sibling checkouts, use Bundler's local override feature.

Example (inside any repo that depends on `bubbles`):

	bundle config set local.bubbles ../bubbles-ruby

Bundler writes this into the app-local config (typically `.bundle/config`) for that repo.

#### Quick setup (recommended)

This repo provides helper tasks to clone sibling repos and configure the appropriate Bundler local overrides.

1) Clone your fork of charm-native:

	git clone https://github.com/esmarkowski/charm-native.git
	cd charm-native
	bundle install

2) Clone the other charm-ruby repos next to this directory and configure local overrides:

	# OWNER controls where repos are cloned from.
	# Use your GitHub username/owner that has the forks.
	bundle exec rake workspace:setup OWNER=esmarkowski

This will create sibling folders like `../bubbles-ruby`, `../bubbletea-ruby`, etc.

3) Build and install charm-native locally:

	bundle exec rake build
	gem install pkg/charm-native-*.gem --no-document

#### Using charm-native from sibling gems

When developing another gem in this workspace (e.g. `bubbletea-ruby`), point it at your local checkout:

	cd ../bubbletea-ruby
	bundle config set local.charm-native ../charm-native
	bundle install

If you want all sibling gems wired up for local development, run:

	cd ../charm-native
	bundle exec rake workspace:bundle_local

#### Sanity check: run a demo

Once the workspace is set up, this should run using your local checkouts:

	cd ../demo
	bundle install
	bundle exec ruby ../bubbletea-ruby/demo/list_fancy

#### Reset local overrides

To undo an override in a repo:

	bundle config unset local.bubbles
