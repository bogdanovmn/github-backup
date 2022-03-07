# About
This is a tool for making a backup of your GitHub repositories

# Installation
Just specify the GHT environment variable. The value is your personal access token (you can make one here https://github.com/settings/tokens)

## For example
Put it in your ~/.bash_profile (in case of bash is your shell)
```bash
export GHT=<...>
```
# Usage information
```bash
$ ./github-clone.sh <your-github-username> <path-where-you-want-to-store-your-repositories>
```
## For example
```bash
$ ./github-clone.sh bogdanovmn /home/backups/github
```

