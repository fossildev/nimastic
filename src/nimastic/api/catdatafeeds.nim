import strutils, httpclient
import ../transport

type
    catDatafeeds* = object
        FeedId*: string
        #query
        AllowNoMatch*: bool
        Format*: string
        H*: seq[string]
        Help*: bool
        S*: seq[string]
        Time*: string
        V*: bool

const ValidCollumn: seq[string] = @["assignment_explanation", "ae",
                        "buckets.count", "bc", "bucketsCount",
                        "id",
                        "node.address", "na", "nodeAddress",
                        "node.ephemeral_id", "ne", "nodeEphemeralId",
                        "node.id", "ni", "nodeId",
                        "node.name", "nn", "nodeName",
                        "search.bucket_avg", "sba", "searchBucketAvg",
                        "search.bucket_avg", "sba", "searchBucketAvg",
                        "search.exp_avg_hour", "seah", "searchExpAvgHour",
                        "search.time", "st", "searchTime",
                        "state", "s"]

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


method Do*(this: catDatafeeds, c: var elClient ) : Response {.base.} =
    
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

    if this.AllowNoMatch :
        q.add("&allow_no_match")

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
    c.Endpoint = "/_cat/ml/datafeeds"

    if this.FeedId != "" :
        c.Endpoint.add("/" & this.FeedId)

    return c.estransport()