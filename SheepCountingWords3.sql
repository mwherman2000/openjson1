DROP PROCEDURE IF EXISTS #MergeJSONwithCountingTable;
   GO
  CREATE PROCEDURE #MergeJSONwithCountingTable @json NVARCHAR(MAX),
    @source NVARCHAR(MAX)
  /**
  Summary: >
    This inserts, or updates, into a table (dbo.SheepCountingWords) a JSON string consisting 
    of sheep-counting words for numbers between one and twenty used traditionally by sheep
    farmers in Gt Britain and Brittany. it allows records to be inserted or updated in any
    order or quantity.
    
  Author: PhilFactor
  Date: 20/04/2018
  Database: CountingSheep
  Examples:
     - EXECUTE #MergeJSONwithCountingTable @json=@OneToTen, @Source='Lincolnshire'
     - EXECUTE #MergeJSONwithCountingTable @Source='Lincolnshire', @json='[{
       "number": 11, "word": "Yan-a-dik"}, {"number": 12, "word": "Tan-a-dik"}]'
  Returns: >
    nothing
  **/
  AS
  MERGE dbo.SheepCountingWords AS target
  USING
    (
    SELECT DISTINCT Number, Word, @source
      FROM
      OpenJson(@json)
      WITH (Number INT '$.number', Word VARCHAR(20) '$.word')
    ) AS source (Number, Word, Region)
  ON target.Number = source.Number AND target.Region = source.Region
  WHEN MATCHED AND (source.Word <> target.Word) THEN
    UPDATE SET target.Word = source.Word
  WHEN NOT MATCHED THEN 
    INSERT (Number, Word, Region)
      VALUES
        (source.Number, source.Word, source.Region);
  GO