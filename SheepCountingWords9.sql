SELECT Number, Word, Region
    FROM
    OpenJson('[{
     "region": "Wilts",
     "sequence": [{
        "number": 1,
        "word": "Ain"
     }, {
        "number": 2,
        "word": "Tain"
     }]
  }, {
     "region": "Scots",
     "sequence": [{
        "number": 1,
        "word": "Yan"
     }, {
        "number": 2,
        "word": "Tyan"
     }]
  }]'       )
    WITH (Region NVARCHAR(30) N'$.region', sequence NVARCHAR(MAX) N'$.sequence' AS JSON)
      OUTER APPLY
    OpenJson(sequence) --to get the number and word within each array element 
    WITH (Number INT N'$.number', Word NVARCHAR(30) N'$.word');