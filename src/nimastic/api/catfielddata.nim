import strutils, httpclient
import ../transport

type
    catFieldData* = object
        Field*: string
        #query
        Format*: string
        Bytes*: string
        H*: seq[string]
        Help*: bool
        S*: seq[string]
        V*: bool


method Do*(this: catFieldData, c: var elClient): Response {.base.} =
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

    if this.Bytes != "":
        case this.Bytes:
        of "b": q.add("&bytes=b")
        of "kb": q.add("&bytes=kb")
        of "mb": q.add("&bytes=mb")
        of "gb": q.add("&bytes=gb")
        of "tb": q.add("&bytes=tb")
        of "pb": q.add("&bytes=pb")
        else: 
            echo "not found"
            #add exeption in logger

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
    c.Endpoint = "/_cat/fielddata"

    if this.Field != "" :
        c.Endpoint.add("/" & this.Field)

    return c.estransport()