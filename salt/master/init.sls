# vim: ft=sls

{#-
    Installs, configures and starts/enables the Salt master.
#}

include:
  - .package
  - .config
  - .service
