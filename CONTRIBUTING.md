# Contributing to Google Home YAML Editor

Thank you for your interest in contributing to the Google Home YAML Editor! We welcome contributions from the community.

## Branching Strategy

We use a structured branching model to ensure stability:

- **`main`**: This is the stable production branch. It contains the latest deployed version of the application. Do not commit directly to `main`.
- **`develop`**: This is the active development branch. All new features and fixes are merged here first for testing and verification.

## Contribution Workflow

To contribute code, please follow these steps:

1.  **Fork the repository** (if you are an external contributor) or clone it.
2.  **Checkout the `develop` branch**:
    ```bash
    git checkout develop
    git pull origin develop
    ```
3.  **Create a new branch** from `develop` for your feature or fix. Use a descriptive name:
    ```bash
    git checkout -b feature/my-awesome-feature
    # or
    git checkout -b fix/bug-description
    ```
4.  **Make your changes**. Please ensure your code follows the existing style and conventions.
5.  **Commit your changes** with a clear and concise commit message.
6.  **Push your branch** to the repository (or your fork).
7.  **Open a Pull Request (PR)** targeting the **`develop`** branch.
    -   Do **not** open PRs against `main`.
    -   Describe your changes and link to any relevant issues.

## Release Process

Once changes in `develop` are verified and tested, they will be merged into `main` by the maintainers for the next release.

## Development Setup

See the [README.md](README.md) for instructions on how to run the project locally.
