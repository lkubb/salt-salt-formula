# vim: ft=sls

{#-
    Ensures the current (!) Python environment Salt runs in
    contains/does not contain specified modules.

    Included by `salt.master`_ and `salt.minion`_.
#}

include:
  - .installed
