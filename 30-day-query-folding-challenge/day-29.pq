let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
  WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
  Fact_Sale = WideWorldImportersDW{[Schema = "Fact", Item = "Sale"]}[Data],
  MinYear = Date.Year(List.Min(Fact_Sale[Invoice Date Key])),
  MaxYear = Date.Year(List.Max(Fact_Sale[Invoice Date Key])),
  NumPartitions = MaxYear - MinYear + 1,
  ListOfPartitions = Table.Partition(Fact_Sale, "Invoice Date Key", NumPartitions, Date.Year),
  CombinePartitions = Table.Combine(ListOfPartitions)
in
  CombinePartitions
