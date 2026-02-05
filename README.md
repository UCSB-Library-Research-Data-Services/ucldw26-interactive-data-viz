# ucldw26-interactive-data-viz

Interactive data visualization workshop materials presented as a Quarto website.

## Overview

This repository contains a Quarto website showcasing interactive data visualization techniques and examples. The site includes tutorials, examples, and resources for learning data visualization.

## Prerequisites

- [Quarto](https://quarto.org/docs/get-started/) (version 1.3 or higher)
- Python 3.7+ (for running Python examples)
- Required Python packages:
  ```bash
  pip install matplotlib numpy pandas plotly
  ```

## Building the Website

To render the website locally:

```bash
quarto render
```

To preview the website with live reload:

```bash
quarto preview
```

The rendered website will be available in the `_site` directory.

## Project Structure

```
.
├── _quarto.yml       # Quarto configuration
├── index.qmd         # Home page
├── about.qmd         # About page
├── examples.qmd      # Examples page
├── styles.css        # Custom CSS styles
└── README.md         # This file
```

## Publishing

To publish to GitHub Pages:

```bash
quarto publish gh-pages
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

See LICENSE file for details.
