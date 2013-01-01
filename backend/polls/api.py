# -*- coding: utf-8 -*-
from __future__ import print_function, unicode_literals
from __future__ import absolute_import, division

from armet import resources
from polls import models


class Base(resources.Model):
    """A base resource class with some common stuff
    """

    # This is the main resource that others will reverse to
    canonical = True

    authentication = ('armet.authentication.Basic',)


class Poll(Base):
    """A poll REST resource
    """

    model = models.Poll


class Choice(Base):
    """A choice REST resource"""

    model = models.Choice
