let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
  AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
  dbo_FactResellerSales = AdventureWorksDW2017{[Schema = "dbo", Item = "FactResellerSales"]}[Data],
  Previous_7_Years = Table.SelectRows(
    dbo_FactResellerSales, 
    each Date.IsInPreviousNYears([ShipDate], 7)
  ),
  Select_Columns = Table.SelectColumns(
    Previous_7_Years, 
    {"ProductKey", "SalesOrderNumber", "ShipDate", "SalesAmount"}
  ),
  ShipDate_Date_Only = Table.TransformColumnTypes(Select_Columns, {{"ShipDate", type date}})
in
  ShipDate_Date_Only
