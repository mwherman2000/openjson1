    SELECT number, word, region
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
    WITH (region NVARCHAR(30), sequence NVARCHAR(MAX)  AS JSON)
      OUTER APPLY
    OpenJson(sequence) --to get the number and word within each array element 
    WITH (number INT, word NVARCHAR(30));