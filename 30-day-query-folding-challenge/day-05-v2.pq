let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
  WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
  Fact_Order
    = WideWorldImportersDW{[Schema = "Dimension", Item = "Employee"]}[Data],
  Filter1 = Table.SelectRows(
    Fact_Order, 
    each [Is Salesperson] = true and Date.Year([Valid To]) <> 9999
      and (Number.From([Valid To]) - Number.From([Valid From])) > 365
  ),
  Filter2 = Table.SelectRows(
    Fact_Order, 
    each [Is Salesperson] = false and Date.Year([Valid To]) = 9999
  ),
  Union = Table.Combine({Filter1, Filter2}),
  #"Removed Other Columns" = Table.SelectColumns(
    Union, 
    {"Employee Key", "Employee", "Is Salesperson", "Valid From", "Valid To"}
  )
in
  #"Removed Other Columns"
