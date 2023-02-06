# vim: ft=sls

{#-
    Enables and (re)starts the Salt API service.
    Depends on `salt.api.cert`_ and `salt.master.service`_.
#}

include:
  - .running
