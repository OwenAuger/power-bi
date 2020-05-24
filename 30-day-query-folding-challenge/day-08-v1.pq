let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
  WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
  Fact_Sale = WideWorldImportersDW{[Schema = "Fact", Item = "Sale"]}[Data],
  // Choose an arbitrary Year & Month
  DummyYear = 2012,
  DummyMonth = 12,
  // Create a DummyDate that just needs to be a month-end date
  DummyDate = Date.EndOfMonth(#date(DummyYear, DummyMonth, 1)),
  FilterInvoiceDate = Table.SelectRows(
    Fact_Sale, 
    each [Invoice Date Key] = Date.AddMonths(
      DummyDate, 
      12 * (Date.Year([Invoice Date Key]) - DummyYear) + Date.Month([Invoice Date Key]) - DummyMonth
    )
  ),
  SelectColumns = Table.SelectColumns(
    FilterInvoiceDate, 
    {
      "Sale Key", 
      "Customer Key", 
      "Invoice Date Key", 
      "Total Excluding Tax", 
      "Tax Amount", 
      "Profit"
    }
  )
in
  SelectColumns
