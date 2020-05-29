let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
  AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
  dbo_DimCurrency = AdventureWorksDW2017{[Schema = "dbo", Item = "DimCurrency"]}[Data],
  CurrencyNamesFilter = List.Select(
    dbo_DimCurrency[CurrencyName], 
    each Text.Length(Text.Select(_, "e")) >= 2
  ),
  FilterTable = Table.SelectRows(
    dbo_DimCurrency, 
    each List.Contains(CurrencyNamesFilter, [CurrencyName])
  )
in
  FilterTable
