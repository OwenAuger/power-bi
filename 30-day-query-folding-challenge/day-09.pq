let
  Source = Sql.Databases(".\SQLEXPRESS"),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_DimEmployee = AdventureWorksDW2017{[Schema="dbo",Item="FactInternetSales"]}[Data],
    #"Expanded DimCustomer" = Table.ExpandRecordColumn(dbo_DimEmployee, "DimCustomer", {"Gender", "EnglishEducation", "CommuteDistance"}, {"Gender", "EnglishEducation", "CommuteDistance"}),
    #"Removed Other Columns" = Table.SelectColumns(#"Expanded DimCustomer",{"Gender", "EnglishEducation", "CommuteDistance", "OrderQuantity"}),
    #"Grouped Rows" = Table.Group(#"Removed Other Columns", {"Gender", "EnglishEducation", "CommuteDistance"}, {{"OrderQuantity", each List.Sum([OrderQuantity]), type number}}),
    #"Pivoted Column" = Table.Pivot(#"Grouped Rows", List.Distinct(#"Grouped Rows"[CommuteDistance]), "CommuteDistance", "OrderQuantity", List.Sum),
    #"Sorted Rows" = Table.Sort(#"Pivoted Column",{{"EnglishEducation", Order.Ascending}})
in
    #"Sorted Rows"
