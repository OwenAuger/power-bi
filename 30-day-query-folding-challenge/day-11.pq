let
  Source = Sql.Databases(".\SQLEXPRESS"),
  AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
  dbo_DimGeography = AdventureWorksDW2017{[
    Schema = "dbo", 
    Item = "DimGeography"
  ]}[Data],
  #"Expanded DimCustomer" = Table.ExpandTableColumn(
    dbo_DimGeography, 
    "DimCustomer", 
    {"FactInternetSales"}, 
    {"FactInternetSales"}
  ),
  #"Expanded FactInternetSales" = Table.ExpandTableColumn(
    #"Expanded DimCustomer", 
    "FactInternetSales", 
    {"SalesAmount"}, 
    {"SalesAmount"}
  ),
  #"GroupBy Geography Columns" = Table.Group(
    #"Expanded FactInternetSales", 
    {"City", "CountryRegionCode", "EnglishCountryRegionName"}, 
    {{"SalesAmount", each List.Sum([SalesAmount]), type number}}
  ),
  #"Filter SalesAmount Zero or Null" = Table.SelectRows(
    #"GroupBy Geography Columns", 
    each [SalesAmount] = 0.0 or [SalesAmount] = null
  ),
  #"Select Columns" = Table.SelectColumns(
    #"Filter SalesAmount Zero or Null", 
    {"City", "CountryRegionCode", "EnglishCountryRegionName"}
  ),
  Sort = Table.Sort(
    #"Select Columns", 
    {{"CountryRegionCode", Order.Ascending}, {"City", Order.Ascending}}
  )
in
  Sort
