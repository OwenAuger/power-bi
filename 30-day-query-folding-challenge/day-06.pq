let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
  WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
  Dimension_StockItem = WideWorldImportersDW{[Schema = "Dimension", Item = "Stock Item"]}[Data],
  #"Filtered Rows" = Table.SelectRows(
    Dimension_StockItem, 
    each [Color] <> "N/A" and Number.Mod([Stock Item Key], 2) = 0
  ),
  #"Removed Other Columns" = Table.SelectColumns(
    #"Filtered Rows", 
    {"Stock Item Key", "Stock Item", "Color"}
  )
in
  #"Removed Other Columns"
