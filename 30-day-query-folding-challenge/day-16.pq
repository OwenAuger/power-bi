let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
  WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
  Fact_Order = WideWorldImportersDW{[Schema = "Fact", Item = "Order"]}[Data],
  Fact_Sale = WideWorldImportersDW{[Schema = "Fact", Item = "Sale"]}[Data],
  #"Added YYYYMM" = Table.AddColumn(
    Fact_Sale, 
    "YYYYMM", 
    each Date.Year([Invoice Date Key]) * 100 + Date.Month([Invoice Date Key]), 
    Int64.Type
  ),
  #"Added YYYYMM Previous" = Table.AddColumn(
    #"Added YYYYMM", 
    "YYYYMM Previous", 
    each Date.Year(Date.AddMonths([Invoice Date Key], - 1)) * 100 + Date.Month(
      Date.AddMonths([Invoice Date Key], - 1)
    ), 
    Int64.Type
  ),
  #"Grouped Rows" = Table.Group(
    #"Added YYYYMM Previous", 
    {"YYYYMM", "YYYYMM Previous"}, 
    {{"TotalProfit", each List.Sum([Profit]), type number}}
  ),
  #"Merged Queries" = Table.Join(
    #"Grouped Rows", 
    "YYYYMM Previous", 
    Table.RenameColumns(
      #"Grouped Rows"[[YYYYMM],[TotalProfit]], 
      {{"YYYYMM", "YYYYMM_Pre"}, {"TotalProfit", "TotalProfit_Pre"}}
    ), 
    "YYYYMM_Pre", 
    JoinKind.LeftOuter
  ),
  #"Added Change Percentage" = Table.AddColumn(
    #"Merged Queries", 
    "Change Percentage", 
    each [TotalProfit] / [TotalProfit_Pre] - 1, 
    Percentage.Type
  ),
  #"Select Columns" = #"Added Change Percentage"[[YYYYMM], [TotalProfit], [Change Percentage]],
  #"YYYYMM Text" = Table.TransformColumnTypes(
    #"Select Columns", 
    {{"YYYYMM", type text}}
  )
in
  #"YYYYMM Text"
