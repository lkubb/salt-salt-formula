# vim: ft=sls

{#-
    Ensures all configured pillars are present in the
    target destination and up to date, if configured.
    This allows you to avoid the ``git`` external pillar for
    performance reasons.

    You can import the list of pillar roots to include in your config
    from ``salt.pillars.present``. This is done by default.

    Optionally, clears pillar cache on the master and instructs
    selected minions to update their in-memory pillar data on changes.
#}

include:
  - .present
