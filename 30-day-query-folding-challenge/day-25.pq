let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
  WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
  // Dimension.Supplier
  Dimension_Supplier = WideWorldImportersDW{[Schema = "Dimension", Item = "Supplier"]}[Data],
  Dimension_Supplier_Filtered = Table.SelectRows(Dimension_Supplier, each ([Supplier] <> "Unknown")),
  Dimension_Supplier_SupplierKeyReference = Table.AddColumn(
    Dimension_Supplier_Filtered, 
    "Supplier Key Reference", 
    each Text.From([Supplier Key]) & "-" & [Supplier Reference], 
    type text
  ),
  // Fact.Transaction
  Fact_Transaction = WideWorldImportersDW{[Schema = "Fact", Item = "Transaction"]}[Data],
  Fact_Transaction_Filtered = Table.SelectRows(Fact_Transaction, each [Is Finalized] = false),
  Fact_Transaction_Columns = Fact_Transaction_Filtered[[Supplier Key]],
  // Join
  Join = Table.Join(
    Dimension_Supplier_SupplierKeyReference, 
    "Supplier Key", 
    Fact_Transaction_Columns, 
    "Supplier Key", 
    JoinKind.Inner
  ),
  SelectColumns = Table.SelectColumns(
    Join, 
    {"Supplier Key Reference", "Supplier", "Category", "Primary Contact"}
  )
in
  SelectColumns
