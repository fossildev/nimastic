import strutils, httpclient
import ../transport

type
    catNodeattrs* = object
        #query
        Format*:        string
        H*:             seq[string]
        Help*:          bool
        Local*:         bool
        MasterTimeout*: string
        S*:             seq[string]
        V*:             bool

        Pretty*:    bool
        Human:      bool
        ErrorTrace: bool

const ValidColumn: seq[string] = @["node","name","host","h","ip","i","attr","attr.name",
                    "value","attr.value","id","nodeId","pid","p","port","po"]

# check value in column valid or not
proc checkValidColumn(h: seq[string]): bool =
    
    var valid: bool

    block checkH:
        for i, val in h.pairs:
            
            var match: bool = false

            block checkColumn:
                for j, k in ValidColumn.pairs:
                    if val == k :
                        match = true
                        break checkColumn

            if match :
                valid = true
            else :
                valid = false
                break checkH

    return valid

method Do*(this: catNodeattrs, c: var elClient): Response {.base.} = 

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
        let valid = checkValidColumn(this.H)
        if valid:
            q.add("&h" & join(this.H,","))
    
    if this.Help :
        q.add("&help")

    if this.Local:
        q.add("&local")

    if this.MasterTimeout != "":
        q.add("&master_timeout=" & this.MasterTimeout)

    if len(this.S) > 0 :
        q.add("&s=" & join(this.S , ","))

    if this.V:
        q.add("&v")

    if this.Pretty :
        q.add("&pretty")

    # add query to elasticsearch.Query
    c.Query = q
    # add method to elasticsearch.Method
    c.Method = HttpGet
    c.Endpoint = "/_cat/nodeattrs"

    return c.estransport()
