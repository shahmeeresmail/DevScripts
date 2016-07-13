# DevScripts
A collection of scripts to make a developer's life easier.

zipChanges.bat : Generates a zip containing files/directories changed/added between two branches and replicates the associated directory structures as well. If only one branch is specified, it will use the current branch as one of the branches.

zipLocalChanges.bat : Similar to zipChanges except that the zip contains locally changed files


# Prerequesites
- Software Packages: Windows OS, GIT, 7zip
- Environment variables: %PATH% environment variable must be updated to provide access to GIT, 7zip and DevScripts from any directory

# Example usage
Example1: "zipChanges develop master" will generate a zip file with all files that have changed between develop and master branches

Example2: "zipChanges develop" will generate a zip file with all files that have changed between develop and the current branch
