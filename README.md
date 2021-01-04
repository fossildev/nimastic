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

let res = client.Do(req)

echo res.body
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

example cat allocation

``` nim
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
```

response 

``` json
[
  {
    "shards":"0",
    "disk.indices":"0",
    "disk.used":"36261",
    "disk.avail":"202574",
    "disk.total":"238836",
    "disk.percent":"15",
    "host":"localhost",
    "ip":"127.0.0.1",
    "node":"chan"
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
- [x] cat count
- [x] cat data frame analytics
- [x] cat datafeeds
- [x] cat health
- [x] cat indices
- [x] cat master
- [x] cat nodeattrs
- [x] cat nodes
- [x] cat pending tasks
- [x] cat plugins
- [x] cat recovery
- [x] cat repositories
- [x] cat shards
- [x] cat segments
- [X] cat snapshots
- [x] cat task management
- [x] cat templates
- [x] cat thread pool
- [x] cat trained model
- [x] cat transforms
- [x] cluster allocation explain
- [x] cluster get settings
- [x] cluster health
- [ ] cluster reroute
- [x] cluster state
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

