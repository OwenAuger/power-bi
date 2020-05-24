let
  Source = Sql.Databases(".\SQLEXPRESS", [CreateNavigationProperties = false]),
  WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
  Dimension_Employee = WideWorldImportersDW{[Schema = "Dimension", Item
    = "Employee"]}[Data],
  GroupByEmployee = Table.Group(Dimension_Employee, {"Employee"}, {}),
  RemoveUnknown = Table.SelectRows(
    GroupByEmployee, 
    each [Employee] <> "Unknown"
  ),
  AddDummyColForJoin = Table.AddColumn( RemoveUnknown, "Dummy", each 1, Int64.Type ),
  CrossjoinWithSelf = Table.NestedJoin(
    AddDummyColForJoin, 
    {"Dummy"}, 
    AddDummyColForJoin, 
    {"Dummy"}, 
    "Crossjoin", 
    JoinKind.LeftOuter
  ),
  ExpandEmployee2 = Table.ExpandTableColumn(
    CrossjoinWithSelf, "Crossjoin", {"Employee"}, {"Employee2"} ),
  #"Filter Employee2 <= Employee" = Table.SelectRows(
    ExpandEmployee2, 
    each [Employee2] <= [Employee]
  ),
  CreateIndex = Table.Group(
    #"Filter Employee2 <= Employee", 
    {"Employee"}, 
    {{"Index", each Table.RowCount(_), type number}}
  ),
  AddTeamMateIndex = Table.AddColumn(
    CreateIndex, 
    "TeamMate Index", 
    each [Index] + Number.Mod([Index], 2) * 2 - 1, 
    Int64.Type
  ),
  JoinTeamMate = Table.NestedJoin(
    AddTeamMateIndex, 
    {"TeamMate Index"}, 
    AddTeamMateIndex, 
    {"Index"}, 
    "TeamMate", 
    JoinKind.LeftOuter
  ),
  ExpandTeamMate = Table.ExpandTableColumn( JoinTeamMate, "TeamMate", {"Employee"}, {"TeamMate"} ),
  SelectRequiredColumns = Table.SelectColumns(
    ExpandTeamMate, 
    {"Employee", "TeamMate"}
  )
in
  SelectRequiredColumns
