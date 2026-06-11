# CivicFlow

**A Rails MVP for citizen service requests and public sector issue triage.**

CivicFlow helps residents report local service issues and gives an internal team a lightweight workflow to triage, assign, update and resolve them. It is built as a portfolio-ready Ruby on Rails full-stack application with PostgreSQL, Hotwire, Tailwind, Devise, Pundit, Action Mailer, Active Storage, RSpec, Docker and GitHub Actions.

The project was designed to mirror the kind of bespoke, impact-driven public sector software a Rails consultancy might build: small enough to understand quickly, but complete enough to demonstrate real workflow thinking.

## Screenshots

### Citizen Request Form

![Citizen submit page](docs/screenshots/citizen-submit.png)

### Admin Triage Dashboard

![Admin dashboard](docs/screenshots/admin-dashboard.png)

## 60-Second Demo Path

1. Submit a public service request from the citizen-facing form.
2. Sign in as an admin.
3. Find the request on the Kanban dashboard.
4. Review the AI-generated summary, category and priority.
5. Assign an owner, add an internal note and move the request to `In Progress`.
6. Confirm a status update email is generated for the submitter.

Demo admin account:

```text
admin@example.com
password123
```

## Why This Project Stands Out

- **Real civic workflow, not a generic CRUD app**: public submission, internal triage, assignment, notes, status updates and email notifications.
- **Rails-native full-stack delivery**: ERB views, Hotwire, Tailwind and Rails conventions keep the app simple, fast and maintainable.
- **Public sector fit**: the domain is service delivery, accessibility, transparency and practical operational tooling.
- **AI used where it helps the workflow**: a deterministic AI triage service summarizes requests and suggests category/priority without making the MVP dependent on an API key.
- **Interview-ready engineering signals**: role-based authorization, image uploads, mailers, tests, CI, Docker and a written acceptance checklist.

## Features

### Citizen-Facing Flow

- Submit a service issue with title, description, category, location and contact email
- Upload an optional photo through Active Storage
- Receive a confirmation page after submission
- New requests start in the `New` workflow state

### Admin Workflow

- Secure admin login with Devise
- Pundit authorization for admin-only workflows
- Kanban-style dashboard grouped by:
  - `New`
  - `Triage`
  - `In Progress`
  - `Resolved`
- Search by title or description
- Filter by status and category
- Update status, category, priority and assignee
- Add internal notes that are hidden from citizens
- View uploaded request images

### Notifications And AI

- Action Mailer sends a status update email when the request status changes
- AI triage generates:
  - summary
  - suggested category
  - priority
- AI triage has a safe fallback so issue creation still succeeds if the service fails

## Tech Stack

| Area | Technology |
| --- | --- |
| Framework | Ruby on Rails 7.2 |
| Language | Ruby 3.3 |
| Database | PostgreSQL |
| Frontend | ERB, Hotwire, Turbo, Stimulus |
| Styling | Tailwind CSS |
| Authentication | Devise |
| Authorization | Pundit |
| File Uploads | Active Storage |
| Email | Action Mailer |
| Testing | RSpec |
| CI | GitHub Actions |
| Local Infra | Docker / Docker Compose |

## Architecture

```mermaid
flowchart TD
    Citizen["Citizen Browser"] --> Rails["Rails Full-stack App"]
    Admin["Admin Browser"] --> Rails

    Rails --> Controllers["Rails Controllers"]
    Controllers --> Views["ERB Views + Hotwire"]
    Controllers --> Policies["Pundit Policies"]
    Controllers --> Models["Active Record Models"]

    Models --> Postgres["PostgreSQL"]
    Models --> ActiveStorage["Active Storage"]
    Models --> AiTriage["Mock AI Triage Service"]

    Controllers --> Mailer["Action Mailer"]
    Mailer --> Email["Status Update Email"]

    Rails --> Tailwind["Tailwind CSS"]
```

## Data Model

```mermaid
erDiagram
    USER ||--o{ ISSUE : assigned
    USER ||--o{ COMMENT : writes
    ISSUE ||--o{ COMMENT : has
    ISSUE ||--o| ACTIVE_STORAGE_ATTACHMENT : image

    USER {
        string email
        integer role
    }

    ISSUE {
        string title
        text description
        integer category
        integer status
        integer priority
        string location
        string contact_email
        text ai_summary
        string ai_suggested_category
        bigint assigned_to_id
    }

    COMMENT {
        bigint issue_id
        bigint user_id
        text body
        boolean internal
    }
```

## Local Setup

Prerequisites:

- Ruby 3.3
- PostgreSQL
- Bundler

Install dependencies:

```bash
bundle install
```

Create and seed the database:

```bash
bin/rails db:setup
```

Run the app:

```bash
bin/dev
```

Open:

- Citizen form: http://localhost:3000
- Admin sign in: http://localhost:3000/users/sign_in
- Admin dashboard: http://localhost:3000/admin

## Docker

```bash
docker compose up --build
```

Then open:

```text
http://localhost:3000
```

## Tests

```bash
bundle exec rspec
```

Current coverage includes:

- User role defaults
- Issue validations
- AI triage generation
- Admin authorization
- Dashboard filtering/search
- Status update email behavior
- Internal note creation
- Mailer content

Latest local result:

```text
14 examples, 0 failures
```

## CI

GitHub Actions runs:

- PostgreSQL service
- `bin/rails db:prepare`
- `bundle exec rspec`
- `bin/brakeman --no-pager --no-exit-on-warn`

## AI Triage

The MVP currently uses a deterministic mock service:

```text
app/services/ai_triage_service.rb
```

This keeps the AI workflow visible and testable without requiring an API key. A production version could replace this with an OpenAI-backed service for summarization, categorization and priority scoring.

## Project Structure Highlights

```text
app/controllers/admin        Admin dashboard, issue updates and internal notes
app/models                   User, Issue and Comment domain models
app/policies                 Pundit authorization policies
app/services                 AI triage service
app/mailers                  Status update email
spec                         RSpec model, request, mailer and service tests
docs/screenshots             README screenshots
MVP_ACCEPTANCE_CRITERIA.md   Feature acceptance checklist
```

## Acceptance Criteria

The MVP is backed by a dedicated feature acceptance checklist:

[MVP_ACCEPTANCE_CRITERIA.md](MVP_ACCEPTANCE_CRITERIA.md)

## Future Improvements

- Replace mock AI triage with a real OpenAI integration
- Add public request tracking links
- Add map-based location selection
- Add SLA / overdue indicators
- Add CSV export for admin reporting
- Add Sidekiq for background email delivery
- Deploy to Render, Fly.io or AWS
