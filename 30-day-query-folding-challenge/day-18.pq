let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
  WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
  Dimension_City = WideWorldImportersDW{[Schema = "Dimension", Item = "City"]}[Data],
    CityList = List.Distinct(
    List.Select(
      Dimension_City[City], 
      each Text.Contains(_, "A", Comparer.Ordinal) and Text.Contains(_, "d", Comparer.Ordinal)
        and Text.Contains(_, "C", Comparer.Ordinal)
    )
  ),
  FilterCity = Table.SelectRows(Dimension_City, each List.Contains(CityList, [City])),
  SelectColumns = Table.SelectColumns(
    FilterCity, 
    {"City Key", "City", "State Province", "Sales Territory"}
  )
in
  SelectColumns
