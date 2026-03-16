## **Introduction to GitHub Actions**

**GitHub Actions** is a **powerful CI/CD platform** integrated directly into GitHub that allows you to **automate workflows** for building, testing, and deploying your code. With Actions, developers can define custom workflows that run automatically on **specific events** such as code pushes, pull requests, releases, or even scheduled times.

Key features include:

1. **Automation of tasks** – You can automate repetitive tasks like code linting, testing, and deployments.
2. **Event-driven workflows** – Workflows can be triggered by GitHub events, webhooks, or manual triggers.
3. **Custom and reusable actions** – Developers can create **custom actions** in JavaScript/TypeScript, Docker, or shell scripts to perform specific tasks.
4. **Integration with GitHub ecosystem** – Actions have seamless access to repository secrets, pull requests, issues, and GitHub API.
5. **Scalable CI/CD pipelines** – Supports matrix builds, parallel jobs, and environment-specific deployments.

**Why use GitHub Actions?**

* Native GitHub integration, no extra CI/CD server required.
* Easy to set up with `.github/workflows` YAML files.
* Supports cross-platform workflows (Linux, macOS, Windows).
* Encourages DevOps best practices with reproducible pipelines.

**Example:** A workflow can automatically build your application, run unit tests, and deploy to production every time code is pushed to the `main` branch.

---
## Key terms:

| Term         | Description                                                                                                             |
| ------------ | ----------------------------------------------------------------------------------------------------------------------- |
| **Workflow** | A configurable automated process defined in a YAML file that runs one or more jobs. Example: `.github/workflows/ci.yml` |
| **Job**      | A set of steps that execute on the same runner. Jobs can run **sequentially** or **in parallel**.                       |
| **Step**     | A single task in a job. It can be a shell command, script, or action.                                                   |
| **Action**   | A reusable unit of code that performs a specific task, e.g., checking out code, running a build, sending notifications. |
| **Runner**   | A server (hosted by GitHub or self-hosted) that executes jobs.                                                          |
| **Event**    | A trigger that starts a workflow. Examples: `push`, `pull_request`, `schedule`.                                         |
| **Secrets**  | Secure environment variables (like tokens, passwords) used inside workflows.                                            |
| **Matrix**   | A strategy to run a job with multiple combinations of variables (e.g., Node versions, OS).                              |
| **Artifact** | Files generated during a workflow that can be uploaded, shared, or downloaded.                                          |

## Structure of Yaml
``` yaml
name: CI Workflow

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install Dependencies
        run: npm install
      - name: Run Tests
        run: npm test
```

## **1️⃣ Workflow**

**Definition:**
A **workflow** is an automated process defined in a YAML file that runs on GitHub Actions when certain events happen (push, pull_request, schedule, etc.).

**Key Points:**

* Stored in `.github/workflows/`
* Can contain one or more **jobs**
* Each job can have multiple **steps**

**Example of a workflow (`ci.yml`):**

```yaml id="l1yzk8"
name: CI Workflow

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install Dependencies
        run: npm install
      - name: Run Tests
        run: npm test
```

* `on:` → defines events that trigger the workflow
* `jobs:` → defines what tasks to run
* `steps:` → individual tasks, can use an **action** or run a command

---

## **2️⃣ Action**

**Definition:**
An **action** is a **reusable unit of code** that performs a single task in a workflow.

**Types:**

1. **JavaScript / TypeScript Action** → Runs JS/TS code
2. **Docker Action** → Runs tasks inside a Docker container
3. **Composite Action** → Combines multiple steps into one reusable YAML action
4. **Shell Script Action** → Runs shell commands or scripts

**Example of an action usage in a workflow:**

```yaml id="x1pm2n"
- uses: actions/checkout@v3    # This is an action
- uses: docker/login-action@v2 # Another action
  with:
    username: ${{ secrets.DOCKER_USER }}
    password: ${{ secrets.DOCKER_PASSWORD }}
```

---

## **3️⃣ Template**

**Definition:**

* GitHub **workflow templates** are pre-configured YAML workflows you can **copy and customize** for common tasks (CI, CD, Docker, testing, deployment).
* These templates are often provided by **GitHub or the community**, e.g., Node.js CI template, Docker build template.
* Helps **speed up development** and ensures best practices.

**Example template in action:**

* `.github/workflows/node.js.yml` → prebuilt Node.js CI template
* You can modify triggers, jobs, and steps as needed

---

## **4️⃣ Folder Structure**

Here’s the **typical folder structure** for a repository using GitHub Actions with custom actions:

```
my-repo/
├── .github/
│   ├── workflows/           # All workflow YAML files
│   │   ├── ci.yml
│   │   ├── cd.yml
│   │   └── sonar.yml
│   └── actions/             # Custom actions you create
│       ├── sonar-action/    # Example custom action
│       │   ├── action.yml   # Metadata for the action
│       │   ├── src/
│       │   │   └── main.ts  # TypeScript source code
│       │   └── dist/
│       │       └── main.js  # Compiled JavaScript
│       └── docker-action/
│           ├── action.yml
│           └── Dockerfile
├── src/                     # Your application code
├── package.json
└── README.md
```

**Explanation:**

* **`.github/workflows/`** → workflow YAMLs
* **`.github/actions/`** → your custom reusable actions (TS, JS, Docker)
* **`src/`** → application source code
* **`dist/`** → compiled JS from TypeScript
* **`action.yml`** → metadata for GitHub to recognize the action
---

## **1️⃣ Types of GitHub Actions You Can Create**

### **A. JavaScript/TypeScript Actions** (Recommended for production)

* **Language:** TypeScript (or JavaScript)
* **How it works:** You write JS/TS code, compile TS → JS, and GitHub Actions runs JS using Node.js (`using: "node16"`).
* **Best for:**

  * Complex logic (API calls, conditionals, loops)
  * Integrations with other services (AWS, SonarQube, Docker, GitHub API)
  * Actions that need inputs, outputs, error handling
* **Files needed:**

  * `action.yml` (metadata)
  * `src/main.ts` → compiled to `dist/main.js`
  * `package.json`, dependencies, devDependencies
* **Real-time examples:**

  * `docker/login-action`
  * `actions/checkout`
  * Custom SonarQube scan + quality gate check

**Pros:** Type safety, maintainable, scalable
**Cons:** Slightly more setup (TS config, compilation)

---

### **B. Docker Container Actions**

* **Language:** Any language supported in Docker (Python, Bash, Node, Java, etc.)
* **How it works:** You create a Dockerfile, put your scripts or binaries inside, and GitHub Actions runs your container.
* **Best for:**

  * Cross-platform consistency (Linux, Windows, etc.)
  * Actions that need special OS tools or dependencies
  * When you want to bundle your entire environment
* **Files needed:**

  * `action.yml` (metadata, with `runs.using: docker`)
  * `Dockerfile` (defines environment)
  * Scripts or binaries inside container
* **Real-time examples:**

  * Some custom scanning tools
  * Build tools not installed on runner

**Pros:** Full environment control, language agnostic
**Cons:** Larger images, slower startup

---

### **C. Composite Actions** (Recommended for simple workflows)

* **Language:** YAML only (no compiled code required)
* **How it works:** Combines multiple existing actions or shell commands in a single `action.yml`.
* **Best for:**

  * Simple workflows
  * Reusing multiple steps
  * Lightweight automation without writing code
* **Files needed:**

  * `action.yml` only, defining `runs.steps`
* **Real-time examples:**

  * Code formatting + linting
  * Multi-step deploys using existing actions

**Pros:** Easy to maintain, no compilation needed
**Cons:** Limited to what GitHub Actions YAML can do

---

### **D. Shell Script Actions** (Bash, PowerShell, etc.)

* **Language:** Bash, PowerShell, Python, etc.
* **How it works:** The action just runs a shell script. Typically used with `composite` actions or `run` steps.
* **Best for:**

  * Simple tasks
  * File manipulation, environment setup, CLI commands
* **Real-time examples:**

  * Deploy scripts
  * Cleanup scripts
  * Custom notifications

**Pros:** Simple, quick to implement
**Cons:** Hard to scale, no type safety, less maintainable

---

## **2️⃣ Recommended Ways for Production Use**

| Type                        | When to Use                            | Pros                                | Cons                             |
| --------------------------- | -------------------------------------- | ----------------------------------- | -------------------------------- |
| **TypeScript / JavaScript** | Complex logic, API calls, integrations | Type safety, maintainable, scalable | Slightly more setup              |
| **Docker Container**        | Needs custom environment, OS tools     | Full control, language agnostic     | Bigger images, slower startup    |
| **Composite Action (YAML)** | Combining steps, simple tasks          | Easy, no compilation needed         | Limited functionality            |
| **Shell Script Action**     | Simple scripts or CLI tasks            | Quick and simple                    | Hard to maintain, no type safety |

✅ **Production recommendation:**

1. **Default choice:** **TypeScript/JavaScript**

   * Easier to maintain, test, and debug
   * Works seamlessly with inputs, outputs, secrets
2. **Use Docker only if:**

   * You need tools/libraries not on GitHub runners
   * You want a reproducible OS-level environment
3. **Composite or shell scripts:**

   * Good for small tasks or quick automation
   * Avoid for core production logic

---

### **3️⃣ Real-Time Use Cases Examples**

1. **TypeScript Action:** SonarQube scan + quality gate + PR comment
2. **Docker Action:** Run custom build tool or security scan
3. **Composite Action:** Run `lint`, `format`, `test` sequentially
4. **Shell Script Action:** Clean workspace, copy files, send notifications

---

If you want, I can **draw a visual diagram showing all these action types, when to use them, and recommended production choices** — it makes it super clear to decide which type to use for your project.

Do you want me to do that?
