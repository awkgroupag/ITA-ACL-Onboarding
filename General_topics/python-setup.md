# Python Setup

## Installing Python

Python can be found [here](https://www.python.org/downloads/)

## Extentensions

Install the Python Extension for VS Code: https://marketplace.visualstudio.com/items?itemName=ms-python.python

## Style

Many style rules are contained in official PEPs. These should always be followed (See [Linting](#linting-formatting-and-type-checking) below). In addition, the [Google Python Style Guide](https://github.com/google/styleguide/blob/gh-pages/pyguide.md) has many additional good recommendations. We recommend following it wherever possible. There are some rules that we have decided not to follow at AWK:

- Line length can be up to 120 not 80
- 4 spaces instead of 2

## Linting, Formatting and Type Checking

You should use a linter to automatically check whether your code adheres to PEP guidelines. We recommend [pylint](https://pylint.pycqa.org/en/latest/). In addition to checking PEP rules, the Google Style Guide contains a link to a settings file, which will check many of the rules from the style guide.

Many of the rules can be applied automatically to code by an auto-formater. We recommend [yapf](https://pypi.org/project/yapf/), which not only follows strict rules but tries to make the code look good using the power of AI or something. Any of the pre-defined styles are fine, we use the Google style.

Python is an untyped language, but supports typing via so-called type hints. For larger projects, we strongly recommend enforcing typing. This can by achieved using [mypy](http://mypy-lang.org/). Using the flag `--strict` will enforce typing everywhere and is a good idea for new projects. For smaller or existing projects, custom flags can be chosen to check for.

All of these tools can be installed using pip and run on the command line. Adding the following lines to `.vscode/settings.json` will make them run automatically in VSCode.

```
{
    "python.linting.pylintEnabled": true,
    "python.linting.enabled": true,
    "python.linting.pylintArgs": [
        "--max-line-length=120"
    ],
    "editor.formatOnSave": true,
    "python.formatting.provider": "yapf",
    "python.formatting.yapfArgs": [
        "--style={based_on_style: google, column_limit: 120, indent_width: 4}",
    ],
    "python.linting.mypyEnabled": true,
    "python.linting.mypyArgs": [
        "--strict"
    ]
}
```

## Running Python in VSCode

You can easily run and debug Python in VSCode using launch configurations. Create a file `.vscode/launch.json` with the following content:  

```
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python: Current File",
            "type": "python",
            "request": "launch",
            "program": "${file}",
            "console": "integratedTerminal",
            "justMyCode": true
        },
        {
            "name": "Main",
            "type": "python",
            "request": "launch",
            "program": "${workspaceFolder}/main.py",
            "console": "integratedTerminal",
            "justMyCode": true,
            "envFile": "${workspaceFolder}/dev.env"
        }
    ]
}
```
This creates two launch configurations. The first will run the currently open file. The second will run the file `main.py` with the variables in `dev.env` as environment variables. 

## Other tools

Here are some further recommendations for useful Python tools:

- Databases can be managed with [SQLAlchemy](https://www.sqlalchemy.org/), database migrations additionally require the use of [alembic](https://alembic.sqlalchemy.org/en/latest/)
- Logging can be done with [structlog](https://www.structlog.org/en/stable/getting-started.html)

