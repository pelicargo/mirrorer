# Mirrorer
*A program written to be touched as little as possible*

### Intro
This small program simply proxies websites while also rewriting the urls to be a passed in through itself (e.g. `https://example.com/` ->  `https://pelicargo.com/mirror/example/`). This probably wouldn't catch every case - especially not for actual web usage, but it works just fine for NPM repos.

Unlike everything else in this company, this is written in [nim](https://nim-lang.org/), for two reasons: low overhead and minimal daemons. This is accomplished by time-traveling to 1993 and using the ancient technique known as CGI.

Also it's not a mirror, it's a proxy. ¯\\_(ツ)_/¯

### Building
The binary on `util-2` was built using nim 1.6.14, however it shouldn't be too version dependent. The following command will build the binary:

`nim c --gc:orc -d:release -d:ssl --opt:speed mirrorer.nim`

### Using
For some reason unknown to me, NGINX doesn't support a 30 year old spec that's been largely surpassed [by](https://en.wikipedia.org/wiki/FastCGI) [numerous](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/) [technologies](https://en.wikipedia.org/wiki/Simple_Common_Gateway_Interface). Install `fcgiwrap` from the repos (they all have it and under the same name), then add the following to your NGINX server directive:
```nginx
location /mirror {
    gzip off;
    fastcgi_pass unix:/var/run/fcgiwrap.socket;
    include /etc/nginx/fastcgi_params;
    fastcgi_param SCRIPT_FILENAME /path/to/mirrorer/binary;
    fastcgi_param DOCUMENT_ROOT /path/to/mirrorer/directory;
}
```

Then adjust the configuration:
```ini
protocol="https"

[examplerepo]
url="https://npm.example.dev/"
auth="password in however the server accepts it"
```

* `protocol` - Set to `https` if your server is configured for HTTPS, otherwise `http`
* `[examplerepo]` - Set this to something to identify what you're proxying, as this is part of the url that clients will connect to
* `url` - Site to proxy. Needs a slash at the end
* `auth` - Auth headers to include. This would be the same value as `_auth` in your `.npmrc` file

Repeat the last three lines as many times as you'd like for different websites.

The examples would be accessible at: `https://testcargo.com/mirror/examplerepo`
