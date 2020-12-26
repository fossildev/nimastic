import nimastic, httpclient

var client = elasticBasicClient()

let req = elasticsearch.CatAliases(
        Format: "json",
        V: true,
        ExpandWildcards:"all"
    )

let res = client.Do(req)

echo res.body