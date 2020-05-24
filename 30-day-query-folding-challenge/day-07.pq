let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_DimEmployee = AdventureWorksDW2017{[Schema="dbo",Item="DimEmployee"]}[Data],
    #"Select Columns without Key" =
      Table.SelectColumns( 
        dbo_DimEmployee,
        List.Select(
            Table.ColumnNames(dbo_DimEmployee),
            each not Text.Contains(_,"Key")
        )
    )
in
    #"Select Columns without Key"
