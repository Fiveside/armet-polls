# -*- coding: utf-8 -*-
""" All the models your poll needs!
"""
from __future__ import print_function, unicode_literals
from __future__ import absolute_import, division
from django.db import models
import datetime
from django.utils import timezone


class Poll(models.Model):
    question = models.CharField(max_length=200)
    pub_date = models.DateTimeField('date published')

    def was_published_recently(self):
        return self.pub_date >= timezone.now() - datetime.timedelta(days=1)

    def __str__(self):
        return self.question


class Choice(models.Model):
    poll = models.ForeignKey(Poll)
    choice = models.CharField(max_length=200)
    votes = models.IntegerField()

    def __str__(self):
        return self.choice
