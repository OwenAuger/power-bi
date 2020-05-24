let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties=false]),
  WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
  Fact_Order = WideWorldImportersDW{[Schema = "Dimension", Item = "Employee"]}[Data],
    #"Removed Other Columns" = Table.SelectColumns(Fact_Order,{"Employee Key", "Employee", "Is Salesperson", "Valid From", "Valid To"}),
    #"Filtered Rows" = Table.SelectRows(#"Removed Other Columns", each ([Is Salesperson] = true and Date.Year([Valid To]) <> 9999 and (Number.From([Valid To]) - Number.From([Valid From]) > 365))
    or ([Is Salesperson] = false and Date.Year([Valid To]) = 9999 )
)
in
    #"Filtered Rows"
