let
  Source = Sql.Databases(".\SQLEXPRESS"),
  WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
  Fact_Order = WideWorldImportersDW{[Schema = "Fact", Item = "Order"]}[Data],
  Fact_Order_City = Table.ExpandRecordColumn(Fact_Order, "Dimension.City", {"City"}, {"City"}),
  Fact_Order_Columns = Table.SelectColumns(
    Fact_Order_City, 
    {"Order Key", "City Key", "City", "Order Date Key"}
  ),
  Fact_Sale = WideWorldImportersDW{[Schema = "Fact", Item = "Sale"]}[Data],
  Fact_Sale_Columns = Table.SelectColumns(Fact_Sale, {"Sale Key", "Delivery Date Key"}),
  Join_Order_sale = Table.Join(Fact_Order_Columns, "Order Key", Fact_Sale_Columns, "Sale Key"),
  Add_Delivery_Days = Table.AddColumn(
    Join_Order_sale, 
    "Delivery Days", 
    each 
      if [Delivery Date Key] <> null and [Order Date Key] <> null
      then Duration.TotalDays([Delivery Date Key] - [Order Date Key])
      else null, 
    type number
  ),
  Delivery_Days_Not_Null = Table.SelectRows(Add_Delivery_Days, each ([Delivery Days] <> null)),
  Average_Per_City = Table.Group(
    Delivery_Days_Not_Null, 
    {"City Key", "City"}, 
    {{"Average Delivery Days", each List.Average([Delivery Days]), type number}}
  ),
  Round = Table.TransformColumns(
    Average_Per_City, 
    {{"Average Delivery Days", Number.RoundDown, Int64.Type}}
  ),
  Top10Values = List.MaxN(List.Distinct(Round[Average Delivery Days]), 10),
  Select_Rows_Top10Values = Table.SelectRows(
    Round, 
    each List.Contains(Top10Values, [Average Delivery Days])
  ),
  #"Sorted Rows" = Table.Sort(
    Select_Rows_Top10Values, 
    {{"Average Delivery Days", Order.Descending}}
  )
in
  #"Sorted Rows"
