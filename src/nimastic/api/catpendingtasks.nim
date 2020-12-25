import strutils, httpclient
import ../transport

type
    catPendingTasks* = object
        #query
        Format*: string
        H*: seq[string]
        Help*: bool
        Local*: bool
        MasterTimeout*: string
        S*: seq[string]
        Time*: string
        V*: bool

method Do*(this: catPendingTasks, c: var elClient): Response {.base.} =

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

    #time
    if this.Time != "" :
        case this.Time:
        of "d": q.add("&time=d")
        of "h": q.add("&time=h")
        of "m": q.add("&time=m")
        of "s": q.add("&time=s")
        of "ms": q.add("&time=ms")
        of "micros": q.add("&time=micros")
        of "nanos": q.add("&time=nanos")
        else: 
            echo "not found time " & this.Time

    if this.V :
        q.add("&v")

    c.Query = q
    c.Method = HttpGet
    c.Endpoint = "/_cat/pending_tasks"

    return c.estransport() 

    