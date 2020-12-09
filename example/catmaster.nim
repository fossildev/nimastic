import nimastic, httpclient

var client = elasticBasicClient()

let req = elasticsearch.CatMaster(Format:"json")

let resMaster = req.Do(client)

echo resMaster.body