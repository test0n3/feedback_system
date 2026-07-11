Copilot instructions for feedback_system (Sinatra + ActiveRecord)

Purpose

- Short, actionable guidance for Copilot sessions working on this repository.

Build / run / dev

- Install gems: `bundle install`
- Start app (Rack): `bundle exec rackup -p 9292` (uses config.ru)
- Alternate run: `bundle exec puma` or `bundle exec ruby app.rb` for quick runs
- Styles: `config.ru` compiles stylesheets/style.scss -> public/style.css at startup using sass-embedded. Restart server after SCSS edits.
- DB migrations and tasks (via sinatra-activerecord tasks exposed to rake):
  - `bundle exec rake db:migrate`
  - `bundle exec rake db:rollback`
  - `bundle exec rake db:create` (if needed)
- Console: `bundle exec rake console` (starts Pry)

Tests / single test

- Full suite: `bundle exec rake spec` (Rakefile wires RSpec)
- Run a single spec file: `bundle exec rspec spec/path/to/file_spec.rb`
- Run a single example by line number: `bundle exec rspec spec/path/to/file_spec.rb:LINE`
- Alternate via Rake: `bundle exec rake spec SPEC=spec/path/to/file_spec.rb`

Lint / security

- RuboCop: `bundle exec rubocop` or `bundle exec rake rubocop` (Rakefile task)
- CI uses `bin/rubocop -f github` in the workflow
- Dawnscanner: used in CI (`dawn .`); CI installs/updates KB before scanning.

High-level architecture

- Sinatra-based web app. Primary components:
  - config.ru: Rack entrypoint; compiles SCSS with sass-embedded and launches the app via Rack::Unreloader.
  - app.rb: `App < Sinatra::Base` defines routes, CORS headers, and simple form handling.
  - config/application.rb: configures ActiveRecord using `config/database.yml` and auto-requires models.
  - models/: ActiveRecord models (e.g., feedback.rb) and validations.
  - db/migrate/: ActiveRecord migrations (sqlite3 development DB by default).
  - views/: ERB templates (layout.erb, index.erb, admin/).
  - stylesheets/: SCSS source compiled to public/style.css; layout currently loads Tailwind via CDN.

Key conventions & repo-specific notes

- Param → model mapping: Forms post `feedback[qualifications]` (plural) while model attribute is `qualification` (singular). Normalize param keys and cast to Integer before saving.
- Validation rules: Feedback model enforces presence of `qualification` and description max length 250 — keep view/server messages aligned.
- Asset compilation: SCSS is compiled at rack startup (config.ru). For faster dev or production, add a separate asset build pipeline (npm + tailwind/postcss + sass) and replace the runtime compilation.
- Server restart required to pick up compiled CSS changes unless a watcher/build is added.
- Committed DB: `db/development/app.sqlite3` is present in repo; be aware when sharing or CI setup.
- Tests: RSpec + rack-test are available in the :test group.

AI assistant configs checked

- No CLAUDE.md, AGENTS.md, .cursorrules, .windsurfrules, CONVENTIONS.md, AIDER_CONVENTIONS.md, or .clinerules found.

Interaction preference

- Prefer instructional responses. Provide step‑by‑step commands, explanations, and rationale. Do not modify files or run commands unless explicitly asked. If a change is needed, show a clear patch/diff and ask for confirmation before applying. Ask clarifying questions when unsure.

Devcontainer support

- Open and run Copilot CLI inside the repository devcontainer (VS Code/Codespaces).
- Recommended devcontainer postCreate: "bundle install && npm install" and forward port 9292.
- When asked to change files, show diffs and request confirmation.

Maintaining this file

- Update when build/start/test/lint commands or asset pipeline change.
