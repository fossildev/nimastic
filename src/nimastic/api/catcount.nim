import strutils, httpclient
import ../transport

type
    catCount* = object
        Target*: seq[string]
        #query
        Format*: string
        H*: seq[string]
        Help: bool
        S*: seq[string]
        V*: bool

method Do*(this: catCount, c: var elClient ): Response {.base.} = 
    var q = ""

    if this.Format != "":
        case this.Format:
        of "text": q.add("format=text")
        of "json": q.add("format=json")
        of "smile":  q.add("format=smile")
        of "yaml":  q.add("format=yaml")
        of "cbor": q.add("format=cbor")
        else:
            echo "not found format " & this.Format

    if len(this.H) > 0 :
        let hStr = join(this.H, ",")
        q.add("&h=" & hStr)

    if this.Help :
        q.add("&help")

    if len(this.S) > 0 : 
        let sStr = join(this.S, ",")
        q.add("&s=" & sStr)

    if this.V :
        q.add("&v")

     # add query to elasticsearch.Query
    c.Query = q
    # add method to elasticsearch.Method
    c.Method = HttpGet
    c.Endpoint = "/_cat/count"

    if len(this.Target) > 0 :
        let tStr = join(this.Target,",")
        c.Endpoint.add("/" & tStr)

    return c.estransport()