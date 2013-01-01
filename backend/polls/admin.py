# -*- coding: utf-8 -*-
from __future__ import print_function, unicode_literals
from __future__ import absolute_import, division
from polls import models
from django.contrib import admin

for model in (models.Poll, models.Choice):
    admin.site.register(model)
