# vim: ft=sls

{#-
    Starts/enables the Salt master service at boot time.
    Depends on `salt.master.config`_.
#}

include:
  - .running
