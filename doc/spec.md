# Feedback system > Specs

**What is the Feedback system's core purpose?**
Collect user's feedback and present them

## System use

### Use case: User wants to leave feedback

```mermaid
flowchart TD
    subgraph Terminal UI
        A(Begin) --> B[user approaches terminal]
        B --> C[enters rating of experience]
        C --> D[optional: leave a comment]
        D --> E[optional: leave email address]
        E --> |Submit feedback| F[Save feedback]
        F --> G[Show 'Thank you' screen]
        G --> |timer 10s| A
    end
    F[Save feedback] --> DB[(database)]
```

### Use case: Admin wants to view user's feedback

```mermaid
flowchart TD
    subgraph Admin Dashboard
        A(Begin) --> B[Admin Login]
        B --> C{Correct?}
        C -->|No| B
        C -->|Yes| D[View Feedback List]
        
        D --> E{Action?}
        E -->|Select Entry| F[Read Details]
        E -->|Logout| H[End]
        
        F --> G{Mark Reviewed?}
        G -->|Yes| DB[(Database)]
        G -->|No| D
        DB --> D
    end
```

## Component map

How the backend interacts with the frontend and database.

```mermaid
graph TD
    User((User/Admin)) -->|Interacts| FE[Frontend: JS/HTML]
    FE -->|API Calls| BE[Backend: Ruby/Java]
    BE -->|Query/Save| DB[(Database: PostgreSQL)]
    BE -->|Manage| Env[Infrastructure: Docker]
```

## Backend logic

What happens when a feedback is submitted.

```mermaid
sequenceDiagram
    participant U as User
    participant FE as Frontend (JS)
    participant BE as Backend (Ruby/Java)
    participant DB as Database

    U->>FE: Fills out form & clicks "Submit"
    FE->>BE: POST /api/v1/feedback (JSON)
    BE->>BE: Validate Data (Presence, Length)
    BE->>DB: INSERT INTO feedback_entries
    DB-->>BE: Success (ID: 101)
    BE-->>FE: 201 Created (Confirmation)
    FE->>U: Show Success Message
```

## Frontend UI

```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Submitting: User clicks Submit
    Submitting --> Success: 201 Response
    Submitting --> Error: 400/500 Response
    Success --> Idle: Clear Form
    Error --> Idle: Retry
```
