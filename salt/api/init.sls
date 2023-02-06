# vim: ft=sls

{#-
    Installs, configures and starts/enables the Salt API.
    Also generates a TLS certificate.
    Includes `salt.master`_ states.
#}

include:
  - .package
  - .cert
  - .service
