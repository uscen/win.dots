# Windows Disable Running Scripts:

> This happens because Windows blocks script execution by default for security reasons.

## Fix For Current User Only. (RECOMMENDED).

`Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

## Fix For Temporary Bypass (Single Session Only).

`Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process`
