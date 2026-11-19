# Windows Disable Running Scripts

This happens because Windows blocks script execution by default for security reasons. Follow the steps below to enable script execution for your user account.

## Current User Only. (RECOMMENDED).

`Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

## Temporary Bypass (Single Session Only).

`Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process`
