# vim: ft=sls

{#-
    Generates a TLS certificate + key for the Salt API.
    Depends on `salt.api.package`_.
#}

include:
  - .managed
