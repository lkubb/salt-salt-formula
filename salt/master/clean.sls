# vim: ft=sls

{#-
    Stops/disables the Salt master service,
    removes master configuration and the Salt master package.
#}

include:
  - .service.clean
  - .config.clean
  - .package.clean
