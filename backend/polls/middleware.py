# -*- coding: utf-8 -*-
""" Defines middleware to allow CORS requests to be used.
"""
from __future__ import print_function, unicode_literals
from __future__ import absolute_import, division
import time
from django.http import HttpResponse
from django.conf import settings


class AllowOriginMiddleware(object):
    """
    Allows initiation of CORS requests if a request is coming from localhost
    or an IP inside INTERNAL_IPS.
    """

    def process_request(self, request):
        """Filter requests we don't care about."""
        if request.method != 'OPTIONS':
            # OPTIONS method is the only method that can initiate a CORS
            # request.
            return None

        if not settings.DEBUG:
            if request.META.get('REMOTE_ADDR') not in settings.INTERNAL_IPS:
                # IP isn't coming from the inside.. don't process
                return None

        # We're good; tell django we want to process this request.
        return HttpResponse()

    def process_response(self, request, response):
        """We made it this far; process the CORS request."""
        origin = request.META.get('HTTP_ORIGIN')
        if origin:
            response['Access-Control-Allow-Credentials'] = 'true'
            response['Access-Control-Allow-Origin'] = origin
            response['Access-Control-Allow-Methods'] = (
                'POST, GET, OPTIONS, DELETE, PUT, PATCH')

            response['Access-Control-Allow-Headers'] = (
                'Content-Type, Authorization, Range')

            response['Access-Control-Expose-Headers'] = (
                'Content-Range')

        return response
