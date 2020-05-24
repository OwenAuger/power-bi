let
    Source = Sql.Database(".\SQLEXPRESS", "AdventureWorksDW2017"),
    dbo_DimReseller = Source{[Schema="dbo",Name="DimReseller"]}[Data],
    #"Expanded DimGeography" =
        Table.ExpandRecordColumn(dbo_DimReseller, "DimGeography", {"CountryRegionCode", "EnglishCountryRegionName"}, {"CountryRegionCode", "EnglishCountryRegionName"}),
    #"Not DE or GB & Bike or Bicycle" =
        Table.SelectRows(
            #"Expanded DimGeography",
            each ( not List.Contains({"DE","GB"},[CountryRegionCode]) )
            and ( Text.Contains([ResellerName], "Bike") or Text.Contains([ResellerName], "Bicycle") )
        ),
    #"Removed Other Columns" =
        Table.SelectColumns(
            #"Not DE or GB & Bike or Bicycle",
            {"ResellerKey", "BusinessType", "ResellerName", "NumberEmployees", "ProductLine", "AnnualRevenue", "EnglishCountryRegionName"}
        )
in
    #"Removed Other Columns"
