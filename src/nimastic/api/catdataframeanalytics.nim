import strutils, httpclient
import ../transport

type
    catDataFrameAnalytics* = object
        DataFrameAnalyticsId*: string
        #query
        Format*: string
        H*: seq[string]
        Help*: bool
        S*: seq[string]
        Time*: string
        V*: bool

const ValidCollumn: seq[string] = @["assignment_explanation", "ae",
                        "create_time", "ct", "createTime",
                        "description", "d",
                        "dest_index", "di", "destIndex",
                        "failure_reason", "fr", "failureReason",
                        "id",
                        "model_memory_limit", "mml", "modelMemoryLimit",
                        "node.address", "na", "nodeAddress",
                        "node.ephemeral_id", "ne", "nodeEphemeralId",
                        "node.id", "ni", "nodeId",
                        "node.name", "nn", "nodeName",
                        "progress", "p",
                        "source_index", "si", "sourceIndex",
                        "state", "s",
                        "type", "t",
                        "version", "v"]

# check value in column valid or not
proc checkValidColumn(h: seq[string]): bool =
    
    var valid: bool

    block checkH:
        for i, val in h.pairs:
            
            var match: bool = false

            block checkColumn:
                for j, k in ValidCollumn.pairs:
                    if val == k :
                        match = true
                        break checkColumn

            if match :
                valid = true
            else :
                valid = false
                break checkH

    return valid

method Do*(this: catDataFrameAnalytics, c: var elClient): Response {.base.} = 

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

        let valid = checkValidColumn(this.H)
        if valid :
            let hStr = join(this.H, ",")
            q.add("&h=" & hStr)

    if this.Help :
        q.add("&help")

    if len(this.S) > 0 : 
        let sStr = join(this.S, ",")
        q.add("&s=" & sStr)

    if this.V :
        q.add("&v")

    if this.Time != "":
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

    # add query to elasticsearch.Query
    c.Query = q
    # add method to elasticsearch.Method
    c.Method = HttpGet
    c.Endpoint = "/_cat/ml/data_frame/analytics"

    if this.DataFrameAnalyticsId != "" :
        c.Endpoint.add("/" & this.DataFrameAnalyticsId)

    return c.estransport()