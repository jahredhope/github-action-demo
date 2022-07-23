# GitHub Action Example

An example project for setting up a GitHub action.

- Automated versioning and release notes with [Changesets](https://github.com/changesets/changesets)
- Bundling with [@vercel/ncc](https://github.com/vercel/ncc)
- Compiling and committing to alternative branches to avoid committing assets in history

```yaml
name: "example-workflow"

on:
  push:

jobs:
  example-job:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      # By branch
      - name: Example action
        uses: jahredhope/github-action-demo@v1
      # By tag
      - name: Example action
        uses: jahredhope/github-action-demo@v1.0.3
      # By commit
      - name: Example action
        uses: jahredhope/github-action-demo@va84c1b7edd8162daf28f75ce56fd533465daa741
```
