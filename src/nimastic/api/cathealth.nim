import strutils, httpclient
import ../transport

type
    catHealth* = object
        #query params
        Format*:            string
        H*:                 seq[string]
        Help*:              bool
        S*:                 seq[string]
        V*:                 bool
        Ts*:                bool

        Pretty*:    bool
        Human:      bool
        ErrorTrace: bool
        FilterPath: seq[string]

method Do*(this: catHealth, c: var elClient): Response {.base.} =

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

    #h (Optional, string) Comma-separated list of column names to display.    
    if len(this.H) > 0 :
        let hStr = join(this.H, ",")
        q.add("&h=" & hStr)

    if len(this.S) > 0 :
        let sStr = join(this.S, ",")
        q.add("&s=" & sStr)

    #help  If true, the response includes help information. Defaults to false.
    if this.Help :
        q.add("&help")

    if this.V :
        q.add("&v")

    if this.Ts:
        q.add("&ts")

    c.Query = q
    c.Method = HttpGet
    c.Endpoint = "/_cat/health"

    return c.estransport()