let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
  AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
  dbo_DimEmployee = AdventureWorksDW2017{[Schema = "dbo", Item = "DimEmployee"]}[Data],
  LastNameFilter = List.Select(
    List.Distinct(dbo_DimEmployee[LastName]), 
    each not List.Contains({"A".."E"}, Text.At(_, 0))
  ),
  Filtered = Table.SelectRows(dbo_DimEmployee, each List.Contains(LastNameFilter, [LastName])),
  #"Removed Other Columns" = Table.SelectColumns(
    Filtered, 
    {"EmployeeKey", "FirstName", "MiddleName", "LastName"}
  )
in
  #"Removed Other Columns"
