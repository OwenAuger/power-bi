let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
  WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
  Fact_Order = WideWorldImportersDW{[Schema = "Fact", Item = "Order"]}[Data],
  Category = Table.AddColumn(
    Fact_Order, 
    "Category", 
    each if [Quantity] < 100 then "Less than 100" else 
      if [Quantity] > 250
      then "More than 250"
      else "Between 100 and 250", 
    type text
  ),
  SelectColumns = Table.SelectColumns(
    Category, 
    {"Order Key", "Description", "Quantity", "Category"}
  )
in
  SelectColumns
