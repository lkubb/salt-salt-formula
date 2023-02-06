# vim: ft=sls

{#-
    Stops/disables the Salt API service,
    removes TLS certificate/key and the Salt API package.
#}

include:
  - .service.clean
  - .cert.clean
  - .package.clean
