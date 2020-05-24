let
  Source = Sql.Database(".\SQLEXPRESS", "WideWorldImportersDW"),
  Employee = Source{[Schema = "Dimension", Item = "Employee"]}[Data][[Employee]],
  Employee_Renamed = Table.RenameColumns(Employee, {{"Employee", "Full Name"}}),
  Customer = Source{[Schema = "Dimension", Item = "Customer"]}[Data][[Primary Contact]],
  Customer_Renamed = Table.RenameColumns(
    Customer, 
    {{"Primary Contact", "Full Name"}}
  ),
  Union = Table.Combine({Employee_Renamed, Customer_Renamed}),
  RemoveDuplicates = Table.Distinct(Union),
  Sort = Table.Sort(RemoveDuplicates, {{"Full Name", Order.Ascending}})
in
  Sort
