# WebDAV backend for "server folder" sync: the web app container proxies
# /webdav/ to this server, which stores the sync file in /data (bind-mount a
# host folder there). Apache mod_dav, unlike hacdias/webdav, enforces If-Match
# on PUT, so concurrent writes from two devices are rejected instead of lost.
# Debian, not alpine: alpine's gdbm lock database fails concurrent opens.
FROM httpd:2.4
RUN mkdir -p /data /dav-lock && chown daemon:daemon /data /dav-lock
COPY httpd.conf /usr/local/apache2/conf/httpd.conf
COPY entrypoint.sh /usr/local/bin/webdav-entrypoint.sh
RUN chmod +x /usr/local/bin/webdav-entrypoint.sh
EXPOSE 2345
ENTRYPOINT ["/usr/local/bin/webdav-entrypoint.sh"]
CMD ["httpd-foreground"]
