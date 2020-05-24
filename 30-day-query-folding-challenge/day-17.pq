let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
  AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
  dbo_FactCallCenter = AdventureWorksDW2017{[Schema = "dbo", Item = "FactCallCenter"]}[Data],
  #"Removed Other Columns" = Table.SelectColumns(
    dbo_FactCallCenter, 
    {"DateKey", "Shift", "Calls", "AverageTimePerIssue"}
  ),
  #"Filtered Rows" = Table.SelectRows(#"Removed Other Columns", each Text.Contains([Shift], "PM")),
  TotalTime = Table.AddColumn(
    #"Filtered Rows", 
    "TotalTime", 
    each [Calls] * [AverageTimePerIssue], 
    type number
  ),
  FilterList = List.MaxN(TotalTime[TotalTime], 10) & List.MinN(TotalTime[TotalTime], 10),
  Filter = Table.SelectRows(TotalTime, each List.Contains(FilterList, [TotalTime])),
  Sort = Table.Sort(Filter, {{"TotalTime", Order.Ascending}})
in
    Sort
