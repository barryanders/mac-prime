# Use Touch ID with sudo

## Edit sudo
`subl /etc/pam.d/sudo`

## Add this line
`auth       sufficient     pam_tid.so`
