# vim: ft=sls

{#-
    Ensures all configured formulae are present in the
    target destination and up to date, if configured.

    This allows you to avoid the ``git`` fileserver backend,
    which can become unbearably slow with growing number of files
    and repositories.

    You can import the list of file roots to include in your config
    from ``salt.formulae.present``. This is done by default.
#}

include:
  - .present
