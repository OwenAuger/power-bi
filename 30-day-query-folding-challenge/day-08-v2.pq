let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
  WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
  Fact_Sale = WideWorldImportersDW{[Schema = "Fact", Item = "Sale"]}[Data],
    Filtered = Table.SelectRows(
    Fact_Sale, 
    each 
      if List.Contains(
        {1, 3, 5, 7, 8, 10, 12}, 
        Date.Month([Invoice Date Key])
      )
      then Date.Day([Invoice Date Key]) = 31
      else if List.Contains({4, 6, 9, 11}, Date.Month([Invoice Date Key])) then Date.Day(
        [Invoice Date Key]
      )
        = 30 else 
        if Number.Mod(
          Date.Year([Invoice Date Key]), 
          400
        )
          = 0
        then Date.Day([Invoice Date Key]) = 29
        else 
        if Number.Mod(Date.Year([Invoice Date Key]), 100) = 0 then Date.Day(
          [Invoice Date Key]
        )
          = 28 else 
          if Number.Mod(
            Date.Year([Invoice Date Key]), 
            4
          )
            = 0
          then Date.Day([Invoice Date Key]) = 29
          else Date.Day([Invoice Date Key]) = 28
  ),
    #"Removed Other Columns" = Table.SelectColumns(Filtered,{"Sale Key", "Customer Key", "Invoice Date Key", "Total Excluding Tax", "Tax Amount", "Profit"})
in
    #"Removed Other Columns"
