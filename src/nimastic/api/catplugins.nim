import strutils, httpclient
import ../transport

type
    catPlugins* = object
        #query
        Format*: string
        H*: seq[string]
        Help*: bool
        Local*: bool
        MasterTimeout*: string
        S*: seq[string]
        V*: bool

method Do*(this: catPlugins, c: var elClient): Response {.base.} =

    var q = ""

    # format 
    if this.Format == "text":
        q.add("format=text")
    elif this.Format == "json" :
        q.add("format=json")
    elif this.Format == "smile":
        q.add("format=smile")
    elif this.Format == "yaml":
        q.add("format=yaml")
    elif this.Format == "cbor":
        q.add("format=cbor")

    if len(this.H) > 0 :
        q.add("&h=" & join(this.H, ","))

    if this.Help :
        q.add("&help")

    if this.Local :
        q.add("&local")

    if this.MasterTimeout != "":
        q.add("&master_timeout=" & this.MasterTimeout)

    if len(this.S) > 0:
        q.add("&s=" & join(this.S,""))

    if this.V :
        q.add("&v")

    c.Query = q
    c.Method = HttpGet
    c.Endpoint = "/_cat/plugins"

    return c.estransport()