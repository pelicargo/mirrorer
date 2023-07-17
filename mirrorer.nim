import httpclient
import cgi
import parsecfg
import strutils
import strformat

var config = loadConfig("mirrorer.ini")

var uri = split(getRequestURI(), '/', 3)
if uri.len != 4:
    writeContentType()
    echo "Malformed URL"
    quit(1)
var target = uri[2]
var url = uri[3]

var site = config.getSectionValue(target, "url", "")
var rSite = &"""{config.getSectionValue("", "protocol", "http")}://{getHttpHost()}/{uri[1]}/{uri[2]}"""
var auth = config.getSectionValue(target, "auth", "")

if site.len == 0:
    writeContentType()
    echo &"Site '{target}' not found in config"
    quit(1)


var headers = newHttpHeaders({"User-Agent": getHttpUserAgent(), "Authorization": &"Basic {auth}"})
var client = newHttpClient(headers=headers)

var get = client.get(site & url)
var contentType = get.headers["Content-Type"]
write(stdout, &"Content-type: {contentType}\n\n")

write(stdout, get.body.replace(site.strip(chars={'/'}), rSite))
