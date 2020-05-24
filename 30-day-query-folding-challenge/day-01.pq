let
    Source = Sql.Databases(".\SQLEXPRESS"),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_DimEmployee = AdventureWorksDW2017{[Schema="dbo",Item="DimEmployee"]}[Data],
    #"Birthdate 1974" = Table.SelectRows(dbo_DimEmployee, each Date.Year([BirthDate])=1974),
    FullName = Table.AddColumn(#"Birthdate 1974", "FullName", each [FirstName] & ( if [MiddleName] = null then "" else " " & [MiddleName]  ) & " " & [LastName], type text ),
    #"Removed Other Columns" = Table.SelectColumns(FullName,{"EmployeeKey", "BirthDate", "Gender", "FullName"})
in
    #"Removed Other Columns"
