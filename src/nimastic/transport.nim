import  httpclient

type
    elClient* = object
        #basic
        Url*: seq[string]
        Username*: string
        Password*: string
        Apikey*: string
        Endpoint*: string

        # http
        Method*: HttpMethod
        Query*: string
        Body*: string
        Timeout*: int
        

proc elasticBasicClient*() : elClient = 
    var conf = elClient(Url: @["http://localhost:9200"])

    conf.Timeout = 30
    return conf

method check*(this: elClient): Response  =

    # http client
    let client = newHttpClient(timeout = this.Timeout)
    client.headers = newHttpHeaders({ "Content-Type": "application/json" })

    return client.request(this.Url[0], httpMethod = HttpGet) 

method estransport*(this: elClient): Response = 

    let client = newHttpClient(timeout = this.Timeout)

    # concat url in elasticsearch.Url with query in elasticsearch.Query
    let uri = this.Url[0] & this.Endpoint & "?" & this.Query

    return client.request(uri, httpMethod = this.Method, body = this.Body)

