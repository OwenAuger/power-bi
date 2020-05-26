let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
  WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
  #"Dimension_Transaction Type" = WideWorldImportersDW{[Schema = "Dimension", Item
    = "Transaction Type"]}[Data],
  TransactionTypeList = List.Select(
    #"Dimension_Transaction Type"[Transaction Type], 
    each List.Contains({"a", "e", "i", "o", "u", "y", "w"}, Text.Range(_, 1, 1))
  ),
  FilterTransactionType = Table.SelectRows(
    #"Dimension_Transaction Type", 
    each List.Contains(TransactionTypeList, [Transaction Type])
  ),
  SelectColumns = Table.SelectColumns(
    FilterTransactionType, 
    {"Transaction Type Key", "Transaction Type"}
  )
in
  SelectColumns
