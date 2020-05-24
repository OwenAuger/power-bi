let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
  AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
  dbo_FactResellerSales = AdventureWorksDW2017{[Schema = "dbo", Item = "FactResellerSales"]}[Data],
  UnixTimestamp = Table.AddColumn(
    dbo_FactResellerSales, 
    "UnixTimestamp", 
    each Duration.TotalSeconds([OrderDate] - #datetime(1970, 1, 1, 0, 0, 0)), 
    type number
  ),
  SelectColumns = Table.SelectColumns(
    UnixTimestamp, 
    {"SalesOrderNumber", "OrderDate", "ResellerKey", "EmployeeKey", "UnixTimestamp"}
  )
in
  SelectColumns
