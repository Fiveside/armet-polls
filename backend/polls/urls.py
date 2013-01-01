from django.conf.urls import patterns, include, url

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

from polls import api

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'polls.views.home', name='home'),
    # url(r'^polls/', include('polls.foo.urls')),
    url(r'^api/', include(api.Poll.urls)),
    url(r'^api/', include(api.Choice.urls)),

    # Uncomment the admin/doc line below to enable admin documentation:
    url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    url(r'^admin/', include(admin.site.urls)),
)
