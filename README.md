# nimastic

Elasticsearch client for nim-lang

for spec endpoint, please check [elasticsearch documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/rest-apis.html)


## install [develop]

``` bash
git clone https://github.com/fossildev/nimastic.git

cd nimastic

nimble develop
```

## example


check connection with elasticsearch

``` nim
import nimastic, httpclient

#create connection
let client = elasticBasicClient()

let res = client.check()

echo res.body
```

 response 

``` json
{
  "name" : "chan",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "WTHS1qV4RUS7RC61H1Y5Yw",
  "version" : {
    "number" : "7.10.0",
    "build_flavor" : "default",
    "build_type" : "deb",
    "build_hash" : "51e9d6f22758d0374a0f3f5c6e8f3a7997850f96",
    "build_date" : "2020-11-09T21:30:33.964949Z",
    "build_snapshot" : false,
    "lucene_version" : "8.7.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```


example cat master

``` nim
import nimastic, httpclient

let client = elasticBasicClient()

let req = elasticsearch.CatMaster(Format:"json")

let resMaster = req.Do(client)

echo resMaster.body
```


response

``` json
[
    {
        "id": "D5TAWTIORlCWVCToEZvMKw",
        "host": "localhost",
        "ip": "127.0.0.1",
        "node": "chan"
    }
]
```





## TODO

- [x] basic client
- [ ] auth
- [ ] round robin connection

API

- [x] check
- [x] cat aliases
- [x] cat allocation
- [x] cat anomaly detectors
- [ ] cat count
- [ ] cat data frame analytics
- [ ] cat datafeeds
- [ ] cat health
- [ ] cat indices
- [x] cat master
- [ ] cat nodeattrs
- [ ] cat nodes
- [ ] cat pending tasks
- [ ] cat plugins
- [ ] cat recovery
- [ ] cat repositories
- [ ] cat shards
- [ ] cat segments
- [ ] cat snapshots
- [ ] cat task management
- [ ] cat templates
- [ ] cat thread pool
- [ ] cat trained model
- [ ] cat transforms
- [ ] cluster allocation explain
- [ ] cluster get settings
- [ ] cluster health
- [ ] cluster reroute
- [ ] cluster state
- [ ] cluster stats
- [ ] cluster update settings
- [ ] nodes feature usage
- [ ] nodes hot threads
- [ ] nodes info
- [ ] nodes reload secure settings
- [ ] nodes stats
- [ ] pending cluster task
- [ ] remote cluster info
- [ ] task management
- [ ] voting configuration exclusions
- [ ] get CCR stats
- [ ] create follower
- [ ] pause follower
- [ ] resume follower
- [ ] unfolow
- [ ] forget follower
- [ ] get follower stats
- [ ] get follower info
- [ ] ...

