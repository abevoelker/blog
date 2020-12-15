---
title: rtorrent XMLRPC over nginx SCGI
date: 2011-06-20
header:
  og_image: rtorrent_xmlrpc_over_nginx_scgi/rtorrent_screenshot.png
---

{% asset "rtorrent_xmlrpc_over_nginx_scgi/rtorrent_screenshot.png" alt="Screenshot of rtorrent running in a terminal" %}

So I've just started coding a new Rails project - a frontend for the awesome
<a href="http://libtorrent.rakshasa.no/">rtorrent</a> BitTorrent client - and
already wasted a bit of time getting started due to outdated instructions for
setting up XMLRPC/SCGI on nginx from the
<a href="http://libtorrent.rakshasa.no/wiki/RTorrentXMLRPCGuide">rtorrent guide</a>.
Here's what I did, current as of nginx 1.0.4 and rtorrent 0.8.6:

1. Download / compile latest
    <a href="http://libtorrent.rakshasa.no/wiki/Download">rtorrent</a>
    and <a href="http://nginx.org/en/download.html">nginx</a> from source. You
    <strong>do not need</strong> any third-party SCGI module for nginx, as it now comes
    <a href="http://wiki.nginx.org/HttpScgiModule">integrated</a>.  Therefore,
    if you are installing nginx for Ruby on Rails usage using
    <a href="http://www.modrails.com/">Passenger</a>, you don't need to do the
    advanced setup if you don't have any extra settings / modules to pass to the
    <code>configure</code> script (although you probably won't pull in the latest
    nginx version using the easy method; it currently grabs 1.0.0 while latest
    stable is 1.0.4).

2. Add these lines to your <code>.rtorrent.rc</code> file:

    ```
    encoding_list = UTF-8
    scgi_local = /home/rtorrent/scgi.socket
    execute = chmod,ug=rw\,o=,/home/rtorrent/scgi.socket
    execute = chgrp,rtorrent-nginx,/home/rtorrent/scgi.socket
    ```

    The execute lines are for setting permissions on the
    <a href="http://en.wikipedia.org/wiki/Unix_file_types#Socket">Unix domain socket</a>
    file that rtorrent and nginx will use to communicate. These will be dependent
    on how you want to set up your permissions. This is a very important security
    step to take if you are doing this on a shared server, as any user that has
    read/write access on the socket file could execute arbitrary code by sending
    commands to rtorrent!

    In my case, I set up a separate user for running rtorrent (named
    <code>rtorrent</code>) and a separate user for running nginx (named
    <code>nginx</code>). I then created a group called
    <code>rtorrent-nginx</code>, and only have my <code>rtorrent</code> and
    <code>nginx</code> users added to it.

3. Add this block to <code>nginx.conf</code> inside of the <code>server</code>
    block you are using:

    ```
    location ^~ /scgi {
        include scgi_params;
        scgi_pass  unix:/home/rtorrent/scgi.socket;
    }
    ```

    It should end up looking something like this afterwards:

    ```
    http {
        server {
            listen      80;
            server_name localhost;
            root        /home/rtorrent/my_site/public;
            location ^~ /scgi {
                include scgi_params;
                scgi_pass  unix:/home/rtorrent/scgi.socket;
            }
        }
    }
    ```

4. Done configuring! Start up nginx and rtorrent; you should now be able to
    test your setup. Here's an example, using the xmlrpc utility from the
    <a href="http://xmlrpc-c.sourceforge.net/">xmlprc-c library</a>
    (<code>sudo apt-get install libxmlrpc-c3-dev</code> on Ubuntu):

    ```
    $ xmlrpc localhost/scgi system.client_version
    Result:

    String: '0.8.6'
    ```

    or using Ruby (irb):

    ```ruby
    require 'xmlrpc/client'
    server = XMLRPC::Client.new2("http://localhost/scgi")
    server.call("system.client_version")
    #=> "0.8.6"
    ```

And that's it.  Also, you should be aware that **anyone with access to your
nginx server will be able to send commands to rtorrent** unless you set up
at least some <a href="http://wiki.nginx.org/HttpAuthBasicModule">basic HTTP</a>
authentication!

Hopefully, my next posting will be with some Rails code that takes advantage
of this process. :-)
