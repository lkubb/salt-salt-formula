# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed by states of this formula.
    Will remove all managed Salt packages, configuration, formulae and pillars.
    Libs are untouched.
#}

include:
  - .api.clean
  - .ssh.clean
  - .syndic.clean
  - .master.clean
  - .formulae.clean
  - .pillars.clean
  - .repo.clean
  - .minion.clean
