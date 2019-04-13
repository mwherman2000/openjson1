  DROP PROCEDURE IF EXISTS #MergeJSONWithEmbeddedArraywithCountingTable;
  GO
  CREATE PROCEDURE #MergeJSONWithEmbeddedArraywithCountingTable @json NVARCHAR(MAX)
  /**
  Summary: >
    This inserts, or updates, into a table (dbo.SheepCountingWords) a JSON collection 
    consisting of documents with an embedded array containing sheep-counting words for
    numbers between one and twenty used traditionally by sheep farmers in Gt Britain and 
    Brittany. it allows records to be inserted or updated in any order or quantity.
    
  Author: PhilFactor
  Date: 20/04/2018
  Database: CountingSheep
  Examples:
     - EXECUTE #MergeJSONWithEmbeddedArraywithCountingTable @json=@AllTheRegions, 
     - EXECUTE #MergeJSONWithEmbeddedArraywithCountingTable @json='
      [{"region":"Wilts","sequence":[{"number":1,"word":"Ain"},{"number":2,"word":"Tain"}]},
       {"region":"Scots","sequence":[{"number":1,"word":"Yan"},{"number":2,"word":"Tyan"}]}]'
  Returns: >
    nothing
  **/
  AS
  MERGE dbo.SheepCountingWords AS target
  USING
    (
    SELECT DISTINCT Number, Word, Region
    FROM OpenJson(@json) 
    WITH (Region NVARCHAR(30) N'$.region', sequence NVARCHAR(MAX) N'$.sequence' AS JSON)
      OUTER APPLY
    OpenJson(sequence)
    WITH (Number INT N'$.number', Word NVARCHAR(30) N'$.word')
    ) AS source (Number, Word, Region)
  ON target.Number = source.Number AND target.Region = source.Region
  WHEN MATCHED AND (source.Word <> target.Word) THEN
    UPDATE SET target.Word = source.Word
  WHEN NOT MATCHED THEN INSERT (Number, Word, Region)
                        VALUES
                          (source.Number, source.Word, source.Region);
  GO
    
  DECLARE @JSON nvarchar(max)
  SELECT @json = BulkColumn
   FROM OPENROWSET (BULK 'D:\raw data\YanTanTethera.json', SINGLE_BLOB) as jsonFile
   EXECUTE #MergeJSONWithEmbeddedArraywithCountingTable @JSON
  --The file must be UTF-16 Little Endian