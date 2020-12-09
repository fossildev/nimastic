import catmaster, cataliases, catallocation, catanomalydetectors

type
    elasticsearch* = object
        CatMaster* : catMaster
        Cataliases*: catAliases
        CatAllocation*: catAllocation
        CatAnomalyDirectors*: catAnomalyDirectors
        