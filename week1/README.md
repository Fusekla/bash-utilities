# Script for directory cleanup
![Version 1.1](https://img.shields.io/badge/version-1.1-blue)

## Description
This folder contains script [var-cleanup.sh](./var-cleanup.sh) that deletes files in user specified directory older than specified retention period in days. It can be also run in `dry-run` mode.

## Usage
```bash
./var-cleanup.sh [-h] [-r <days>] [-d] [-p <path>] [-e]
```
-h → Print help message

-r <days> → Set retention period (default: 7 days)

-d → Dry run (no files will be deleted)

-p <path> → Target directory for cleanup (default: /var/log)

-e → Exclude subdirectories (-maxdepth 1)

## Examples
1. Execute `dry-run`
    ```bash
    var-cleanup.sh -d
    ```
2. Delete files older than 31 days in default `/var/log` directory
    ```bash
    var-cleanup.sh -r 31
    ```
3. Delete files older than 3 days in custom `/var/log/tmp` directory, exclude all subdirectories
    ```bash
    var-cleanup.sh -p /var/log/tmp -e
    ```

## Known limitations
If user specified ridiculously high retention period (eg 999999), user is not notified.

## Contact me
- Open an issue at this repository
- [Email Me](mailto:email%40domain.com?subject=Var%20Cleanup%20Script%20Issue)
