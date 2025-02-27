# Docusaurus Documentation Project

Welcome to the Docusaurus Documentation Project! This repository contains the source code and configuration for generating static documentation using Docusaurus.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Scripts](#scripts)
- [Contributing](#contributing)
- [License](#license)

## Introduction

This project aims to provide a comprehensive and easy-to-navigate documentation site for the Rasenmaeher project. The documentation is built using Docusaurus, a modern static site generator.

## Features

- **Automated Documentation Fetching**: Automatically fetches and updates documentation from the main repository and its submodules.
- **Dynamic Sidebar Generation**: Automatically generates the sidebar based on the directory structure.
- **Custom Styling**: Custom CSS for a unique look and feel.
- **GitHub Actions Integration**: Automated workflows for building, testing, and deploying the documentation.

## Getting Started

To get started with this project, follow these steps:

1. **Clone the Repository**:
    ```sh
    git clone https://github.com/Lonimokio/docs.git
    cd docs
    ```

2. **Install Dependencies**:
    ```sh
    npm install
    ```

3. **Build the Documentation**:
    ```sh
    npm run build
    ```

4. **Start the Development Server**:
    ```sh
    npm start
    ```

## Project Structure

```plaintext
.github/
    workflows/          # GitHub Actions workflows
        docs.yml
        release-please.yml
MainDocs/
    docs/               # Documentation source files
        home/
        keycloak/
        takserver/
        tests/
        ui/
    docusaurus.config.js # Docusaurus configuration
    sidebar.js          # Sidebar configuration
    src/
        css/            # Custom CSS
            custom.css
scripts/
    fetch_docs.sh       # Script to fetch documentation
package.json            # Project dependencies and scripts
README.md               # Project overview and instructions
```

## Scripts

- **`npm run build`**: Builds the static documentation site.
- **`npm start`**: Starts the development server.
- **`scripts/fetch_docs.sh`**: Fetches and updates documentation from the main repository and its submodules.

## Contributing

We welcome contributions! Please read our contributing guide to learn how you can help.

## License

This project is licensed under the MIT License. See the LICENSE file for details.