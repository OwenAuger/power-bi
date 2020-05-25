let
  Source = Sql.Databases(".\SQLEXPRESS"),
  WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
  Fact_Sale = WideWorldImportersDW{[Schema = "Fact", Item = "Sale"]}[Data],
  SelectColumns = Table.SelectColumns(
    Fact_Sale, 
    {"Sale Key", "Salesperson Key", "Description", "Dimension.Customer(Bill To Customer Key)"}
  ),
  Expand_BillToCustomer = Table.ExpandRecordColumn(
    SelectColumns, 
    "Dimension.Customer(Bill To Customer Key)", 
    {"Bill To Customer"}, 
    {"Bill To Customer"}
  ),
  DummyMaxCustomer = List.Max(Expand_BillToCustomer[Bill To Customer]) & "_",
  Sorted = Table.Sort(
    Expand_BillToCustomer, 
    each if [Bill To Customer] = "N/A" then DummyMaxCustomer else [Bill To Customer]
  )
in
  Sorted
