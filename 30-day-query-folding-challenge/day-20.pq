let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
  WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
  #"Dimension_Stock Item" = WideWorldImportersDW{[Schema = "Dimension", Item = "Stock Item"]}[Data],
  TextColumnsList = Table.ColumnsOfType(#"Dimension_Stock Item", {type text}),
  SelectTextColumns = Table.SelectColumns(#"Dimension_Stock Item", TextColumnsList)
in
  SelectTextColumns
