# vim: ft=sls

{#-
    Stops/disables the Salt minion service,
    removes minion configuration and the Salt minion package.
#}

include:
  - .service.clean
  - .config.clean
  - .package.clean
