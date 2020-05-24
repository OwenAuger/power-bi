let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
  AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
  dbo_DimEmployee = AdventureWorksDW2017{[Schema = "dbo", Item = "DimEmployee"]}[Data],
  #"Filtered Rows" = Table.SelectRows(
    dbo_DimEmployee, 
    each [BirthDate] >= #date(1990, 1, 1) and [BirthDate] <= #date(1990, 12, 31)
  ),
  #"Removed Other Columns" = Table.SelectColumns(
    #"Filtered Rows", 
    {"EmailAddress", "Gender", "BirthDate"}
  )
in
  #"Removed Other Columns"
