# vim: ft=sls

{#-
    Disables/stops and removes Salt syndic.
#}

include:
  - .service.clean
  - .package.clean
