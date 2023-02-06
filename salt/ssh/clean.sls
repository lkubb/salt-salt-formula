# vim: ft=sls

{#-
    Removes Salt SSH and the roster.
#}

include:
  - .config.clean
  - .package.clean
