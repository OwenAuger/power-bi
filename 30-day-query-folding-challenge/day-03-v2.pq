let
  Source = Sql.Database(".\SQLEXPRESS", "AdventureWorksDW2017"),
  FactResellerSales = Source{[Schema = "dbo", Name = "FactResellerSales"]}[Data],
  #"Expanded EnglishProductName" = Table.ExpandRecordColumn(
    FactResellerSales, 
    "DimProduct", 
    {"EnglishProductName"}, 
    {"EnglishProductName"}
  ),
  #"Added TotalRevenue" = Table.AddColumn(
    #"Expanded EnglishProductName", 
    "TotalRevenue", 
    each [OrderQuantity] * [UnitPrice], 
    type number
  ),
  #"Grouped by ProductKey" = Table.Group(#"Added TotalRevenue", {
    "ProductKey", 
    "EnglishProductName"
  }, {
    {"TotalRevenue", each List.Sum([TotalRevenue]), type number}
  }),
  #"TotalRevenue > 1m" = Table.SelectRows(
    #"Grouped by ProductKey", 
    each [TotalRevenue] > 1000000
  )
in
  #"TotalRevenue > 1m"
