import nimastic, httpclient

var client = elasticBasicClient()

let req = elasticsearch.CatAllocation(
        Format: "json",
        V: true,
        Bytes: "mb",
        MasterTimeout: "15s"
    )

let res = client.Do(req)

echo res.body