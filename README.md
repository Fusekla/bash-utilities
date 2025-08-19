# Bash Utilities

A collection of small Bash scripts created to refresh core shell skills and build a personal toolkit.  
Each script is written with portability and reusability in mind, and grouped in a clean folder structure for long-term maintainability.

## 📂 Repository Layout
```
bin/        # Executable scripts (main entry points)
lib/        # Shared helper libraries (sourced by scripts)
examples/   # Sample input/output files
docs/       # Notes, learning logs, design ideas
```

## 🚀 Quick Start
1. Clone the repository:
   ```bash
   git clone https://github.com/Fusekla/bash-utilities.git
   cd bash-utilities
   ```

2. Make scripts executable (if needed):
   ```bash
   chmod +x bin/*
   ```

3. Run a script:
   ```bash
   ./bin/syscheck.sh -a
   ./bin/log-parser.sh examples/sample.log
   ```

## 🛠 Current Scripts
| Script            | Description                                           |
|-------------------|-------------------------------------------------------|
| `syscheck.sh`     | Checks CPU, memory, and disk usage                    |
| `log-parser.sh`   | Extracts and summarizes error messages from a log file|
| `word-count.sh`   | Counts words in a file                                 |
| `folder-cleanup.sh`  | Deletes old files in specified folder                 |
| `log-processor.sh`| Processes log files with custom rules                  |
| `topN.sh`          | Prints out the most common words in file               |
| `pods-by-ns.sh`   | Prints pods count grouped by namespace                 |
| `extract-iamges.sh` | Prints images used in all deployments               |

## 📝 Development Notes
- Scripts are POSIX-ish but may use GNU extensions for convenience.
- Common functions are stored in `lib/logging.sh` and sourced where needed.
- Logs and temporary files are excluded via `.gitignore`.

## Usage
- [topN.sh](./docs/usage/topN.md)
- [pods-by-ns.sh](./docs/usage/pods-by-ns.md)
- [extract-images.sh](./docs/usage/extract-images.md)

## 📅 Progress Log (Optional)
See [`docs/progress.md`](docs/progress.md) for development notes and lessons learned.

## 📜 License
MIT License — feel free to use and adapt these scripts.