let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
  AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
  dbo_DimCustomer = AdventureWorksDW2017{[Schema = "dbo", Item = "DimCustomer"]}[Data],
  MondayToFriday = Table.SelectRows(
    dbo_DimCustomer, 
    each Date.DayOfWeek([BirthDate]) >= 2 and Date.DayOfWeek([BirthDate]) <= 6
  ),
  SelectColumns = Table.SelectColumns(
    MondayToFriday, 
    {"CustomerKey", "EmailAddress", "EnglishOccupation", "YearlyIncome"}
  )
in
  SelectColumns
