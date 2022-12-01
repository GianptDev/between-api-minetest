
Commands
===================================

<<<<<<< HEAD
/between
--------

.. code-block:: batch

	/between [queue]
=======

Commands are used for debug porpouse in this api.


.. code-block:: batch

	/between [functions | tweens]
>>>>>>> 6764d96dd732f700025594b0e4594dad9e22125f

.. note::
	This command require **debug** privileges.

<<<<<<< HEAD
This command will simply print the current version of the api.

If the *queue* string is given it will print a list of currently running tweens.


-------
=======
If no argouments are given this command will print the current version of the api to the calling client.

The functions argoument will show a debug interface that display all build-in interpolations, used to give a review of each of them.

The tweens argoument will display the list of all currently running tweens, can be used to detect performance problems.

>>>>>>> 6764d96dd732f700025594b0e4594dad9e22125f
