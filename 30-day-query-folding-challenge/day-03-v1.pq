let
  Source = Sql.Database(".\SQLEXPRESS", "AdventureWorksDW2017"),
  dbo_DimProduct = Source{[Schema = "dbo", Item = "DimProduct"]}[Data],
  #"Required Columns Only" = Table.SelectColumns(dbo_DimProduct, {
    "ProductKey", 
    "EnglishProductName", 
    "FactResellerSales"
  }),
  #"Expanded FactResellerSales" = Table.ExpandTableColumn(
    #"Required Columns Only", 
    "FactResellerSales", 
    {"OrderQuantity", "UnitPrice"}, 
    {"OrderQuantity", "UnitPrice"}
  ),
  #"Added Revenue" = Table.AddColumn(
    #"Expanded FactResellerSales", 
    "Revenue", 
    each [OrderQuantity] * [UnitPrice], 
    type number
  ),
  #"Grouped with TotalRevenue" = Table.Group(
    #"Added Revenue", 
    {"ProductKey", "EnglishProductName"}, 
    {{"TotalRevenue", each List.Sum([Revenue]), type number}}
  ),
  #"TotalRevenue > 1m" = Table.SelectRows(#"Grouped with TotalRevenue", each [TotalRevenue]
    > 1000000)
in
  #"TotalRevenue > 1m"
