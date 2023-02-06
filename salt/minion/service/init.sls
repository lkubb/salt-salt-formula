# vim: ft=sls

{#-
    Starts/enables the Salt minion service at boot time.
    Depends on `salt.minion.config`_.
#}

include:
  - .running
