
Api
=========


Everything below is defined under the **BeTweenApi** namespace, wich is a table.


Classes
-------


* `Tween <./Tween.html>`_


Attributes
----------


.. py:attribute:: BeTweenApi.interpolation

	see `interpolations <./interpolations.html>`_

	:type: table<string, function>


Functions
---------


.. py:function:: BeTweenApi.version_name ()

	return the current version as a string.

	:return: This is the syntax used in version names "1.0" or "1.0.1" .
	:rtype: string


.. py:function:: BeTweenApi.clamp (value, min, max)

	keep a number value in between of min and max, if the value is already in between is directly returned.

	:param value: the value to clamp.
	:type value: number
	:param min: the minimun this function can return.
	:type min: number
	:param max: the maximum this function can return.
	:type max: number
	:rtype: number


.. py:function:: BeTweenApi.wrap (value, min, max)

	make the value flow around the range of min and max.

	:param value: the value to wrap.
	:type value: number
	:param min: start point when the value wrap after being over max.
	:type min: number
	:param max: final point before the value wrap and start to min again.
	:type max: number
	:rtype: number


.. note::
	If min and max are the same value is directly returned.


.. py:function:: BeTweenApi.snap (value, snap)

	round the value to the nearest point of snap.

	:param value: the value to snap.
	:type value: number
	:param snap: the size of the snap, should be positive and more than 0 .
	:type snap: number
	:rtype: number

.. note::
	If *0.0* is given to the snap amount the function will always return *0.0* .


.. py:function:: BeTweenApi.get_active_tweens ()

	return a copy the list of currenlty running tweens.

	:rtype: table<Tween>[]

	.. note::
		this will be a copy of the list, it will not be updated and changing it will not interfeer with the orinal list because is used in the api loop.
