import strutils, httpclient
import ../transport

type
    catIndices* = object
        Target*: seq[string]
        #query
        Bytes*: string
        Format*: string
        H*: seq[string]
        Health*: string
        Help*: bool
        IncludeUnloadedSegments*: bool
        Local*: bool
        MasterTimeout*: string
        Pri*: bool
        S*: seq[string]
        Time*: string
        V*: bool
        ExpandWildcards*: seq[string]

const ValidExpandWildcards: seq[string] = @["all","open","closed","hidden","none"]

proc checkValidExpandWildcards(expands: seq[string]): bool =

    var valid: bool
    block checkExpand:
        for i, val in expands.pairs:
            
            var match: bool = false

            block checkColumn:
                for j, k in ValidExpandWildcards.pairs:
                    if val == k :
                        match = true
                        break checkColumn

            if match :
                valid = true
            else :
                echo "column " & val & " not valid"
                valid = false
                break checkExpand

    return valid

method Do* (this: catIndices, c: var elClient): Response {.base.} =

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
            echo this.Bytes & " not found in bytes"    

    if len(this.H) > 0:
        let hStr = join(this.H,",")
        q.add("&h=" & hStr)

    if this.Health != "":
        case this.Health:
        of "green": q.add("&health=green")
        of "yellow": q.add("&health=yellow")
        of "req": q.add("&health=red")
        else:
            echo this.Health & " not valid in health"

    if this.Help :
        q.add("&help")

    if this.IncludeUnloadedSegments:
        q.add("&include_unloaded_segments")

    if this.Local:
        q.add("&local")

    if this.MasterTimeout != "" :
        q.add("&master_timeout=" & this.MasterTimeout)

    if this.Pri:
        q.add("&pri")

    if len(this.S) > 0 :
        let sStr = join(this.S, ",")
        q.add("&s=" & sStr)

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

    if this.V:
        q.add("&v")

    if len(this.ExpandWildcards) > 0 :
        let valid = checkValidExpandWildcards(this.ExpandWildcards)
        if valid:
            let expands = join(this.ExpandWildcards,",")
            q.add("&expand_wildcards=" & expands)

    c.Query = q
    c.Method = HttpGet
    c.Endpoint = "/_cat/indices"

    if len(this.Target) > 0:
        let targetStr = join(this.Target, ",")
        c.Endpoint.add("/" & targetStr)

    return c.estransport()
    

    