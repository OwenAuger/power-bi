let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
  AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
  dbo_DimProduct = AdventureWorksDW2017{[Schema = "dbo", Item = "DimProduct"]}[Data],
  DealerPriceNotNull = Table.SelectRows(dbo_DimProduct, each ([DealerPrice] <> null)),
  TotalDealerPrice = List.Sum(DealerPriceNotNull[DealerPrice]),
  OverallPercentageCalc = Table.AddColumn(
    DealerPriceNotNull, 
    "OverallPercentage", 
    each [DealerPrice] / TotalDealerPrice, 
    type number
  ),
  SelectColumns = Table.SelectColumns(
    OverallPercentageCalc, 
    {"ProductKey", "ProductAlternateKey", "EnglishProductName", "DealerPrice", "OverallPercentage"}
  )
in
  SelectColumns
