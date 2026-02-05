# ucldw26-interactive-data-viz
Interactive data visualization

## GitHub Pages Deployment

This repository contains a Quarto website located in the `d2d-interactive` directory. The website is automatically rendered and deployed to GitHub Pages whenever changes are pushed to the `main` branch.

The workflow:
1. Renders the Quarto project in `d2d-interactive/`
2. Deploys the rendered site (from `d2d-interactive/docs/`) to the `gh-pages` branch
3. Makes the site available at the GitHub Pages URL

The deployment is handled by the GitHub Actions workflow in `.github/workflows/quarto-publish.yml`.
