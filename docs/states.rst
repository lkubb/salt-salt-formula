Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``salt``
^^^^^^^^
*Meta-state*.

This includes `salt.minion`_ only.


``salt.minion``
^^^^^^^^^^^^^^^



``salt.minion.config``
^^^^^^^^^^^^^^^^^^^^^^
Manages the Salt minion configuration.
Depends on `salt.minion.package`_.


``salt.minion.package``
^^^^^^^^^^^^^^^^^^^^^^^
Installs the Salt minion package only.
Depends on `salt.repo`_.


``salt.minion.service``
^^^^^^^^^^^^^^^^^^^^^^^
Starts/enables the Salt minion service at boot time.
Depends on `salt.minion.config`_.


``salt.api``
^^^^^^^^^^^^
Installs, configures and starts/enables the Salt API.
Also generates a TLS certificate.
Includes `salt.master`_ states.


``salt.api.cert``
^^^^^^^^^^^^^^^^^
Generates a TLS certificate + key for the Salt API.
Depends on `salt.api.package`_.


``salt.api.package``
^^^^^^^^^^^^^^^^^^^^
Installs Salt API only.
Depends on `salt.repo`_.


``salt.api.service``
^^^^^^^^^^^^^^^^^^^^
Enables and (re)starts the Salt API service.
Depends on `salt.api.cert`_ and `salt.master.service`_.


``salt.formulae``
^^^^^^^^^^^^^^^^^
Ensures all configured formulae are present in the
target destination and up to date, if configured.

This allows you to avoid the ``git`` fileserver backend,
which can become unbearably slow with growing number of files
and repositories.

You can import the list of file roots to include in your config
from ``salt.formulae.present``. This is done by default.


``salt.libs``
^^^^^^^^^^^^^
Ensures the current (!) Python environment Salt runs in
contains/does not contain specified modules.

Included by `salt.master`_ and `salt.minion`_.


``salt.master``
^^^^^^^^^^^^^^^
Installs, configures and starts/enables the Salt master.


``salt.master.config``
^^^^^^^^^^^^^^^^^^^^^^
Manages the Salt master configuration.
Depends on `salt.master.package`_.


``salt.master.package``
^^^^^^^^^^^^^^^^^^^^^^^
Installs the Salt master package only.
Depends on `salt.repo`_.


``salt.master.service``
^^^^^^^^^^^^^^^^^^^^^^^
Starts/enables the Salt master service at boot time.
Depends on `salt.master.config`_.


``salt.pillars``
^^^^^^^^^^^^^^^^
Ensures all configured pillars are present in the
target destination and up to date, if configured.
This allows you to avoid the ``git`` external pillar for
performance reasons.

You can import the list of pillar roots to include in your config
from ``salt.pillars.present``. This is done by default.

Optionally, clears pillar cache on the master and instructs
selected minions to update their in-memory pillar data on changes.


``salt.repo``
^^^^^^^^^^^^^
Ensures the official SaltStack repository is present.


``salt.ssh``
^^^^^^^^^^^^
Installs Salt SSH and manages the roster.


``salt.ssh.config``
^^^^^^^^^^^^^^^^^^^
Manages Salt SSH roster configuration.


``salt.ssh.package``
^^^^^^^^^^^^^^^^^^^^
Installs Salt SSH only.


``salt.syndic``
^^^^^^^^^^^^^^^
Installs and starts/enables Salt syndic.


``salt.syndic.package``
^^^^^^^^^^^^^^^^^^^^^^^
Installs Salt syndic only.
Depends on `salt.repo`_.


``salt.syndic.service``
^^^^^^^^^^^^^^^^^^^^^^^
Starts/enables Salt syndic.
Depends on `salt.master.service`_.


``salt.clean``
^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed by states of this formula.
Will remove all managed Salt packages, configuration, formulae and pillars.
Libs are untouched.


``salt.minion.clean``
^^^^^^^^^^^^^^^^^^^^^
Stops/disables the Salt minion service,
removes minion configuration and the Salt minion package.


``salt.minion.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``salt.minion.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``salt.minion.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``salt.api.clean``
^^^^^^^^^^^^^^^^^^
Stops/disables the Salt API service,
removes TLS certificate/key and the Salt API package.


``salt.api.cert.clean``
^^^^^^^^^^^^^^^^^^^^^^^



``salt.api.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^



``salt.api.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^



``salt.formulae.clean``
^^^^^^^^^^^^^^^^^^^^^^^
Removes all cloned formula repositories.


``salt.libs.clean``
^^^^^^^^^^^^^^^^^^^



``salt.master.clean``
^^^^^^^^^^^^^^^^^^^^^
Stops/disables the Salt master service,
removes master configuration and the Salt master package.


``salt.master.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``salt.master.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``salt.master.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``salt.pillars.clean``
^^^^^^^^^^^^^^^^^^^^^^
Removes all cloned pillar repositories.


``salt.repo.clean``
^^^^^^^^^^^^^^^^^^^
Ensures the Salt repository is not configured.


``salt.ssh.clean``
^^^^^^^^^^^^^^^^^^
Removes Salt SSH and the roster.


``salt.ssh.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the roster.


``salt.ssh.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes Salt SSH.
Depends on `salt.ssh.config.clean`_.


``salt.syndic.clean``
^^^^^^^^^^^^^^^^^^^^^
Disables/stops and removes Salt syndic.


``salt.syndic.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes Salt syndic.
Depends on `salt.syndic.service.clean`_.


``salt.syndic.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Stops/disables Salt syndic.


