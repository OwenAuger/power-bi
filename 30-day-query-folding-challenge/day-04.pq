let
  Source = Sql.Databases(".\SQLEXPRESS"),
  WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
  Fact_Order = WideWorldImportersDW{[Schema = "Fact", Item = "Order"]}[Data],
  #"Select Columns" = Table.SelectColumns(Fact_Order, {
    "Order Key", 
    "Description"
  }),
  #"Description Length Mod 10 = 1" = Table.SelectRows(
    #"Select Columns", 
    each Number.Mod(Text.Length([Description]), 10) = 1
  )
in
  #"Description Length Mod 10 = 1"
