import catmaster, cataliases, catallocation

type
    elasticsearch* = object
        CatMaster* : catMaster
        Cataliases*: catAliases
        CatAllocation*: catAllocation
        