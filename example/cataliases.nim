import nimastic, httpclient

var client = elasticBasicClient()

let req = elasticsearch.CatAliases(
        Format: "json",
        V: true,
        ExpandWildcards:"all"
    )

let resMaster = req.Do(client)

echo resMaster.body