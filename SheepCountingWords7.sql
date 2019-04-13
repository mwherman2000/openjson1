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
  
  DECLARE @OneToTen NVARCHAR(MAX) =
  	(
  	SELECT LincolnshireCounting.number, LincolnshireCounting.word
  	FROM
  		(
  		VALUES (1, 'Yan'), (2, 'Tan'), (3, 'Tethera'), (4, 'Pethera'),
  		(5, 'Pimp'), (6, 'Sethera'), (7, 'Lethera'), (8, 'Hovera'),
  		(9, 'Covera'), (10, 'Dik')
  		) AS LincolnshireCounting (number, word)
  	FOR JSON AUTO
  	)

  DECLARE @ElevenToTwenty NVARCHAR(MAX) =
      (
      SELECT LincolnshireCounting.number, LincolnshireCounting.word
      FROM
  		(
  		VALUES (11, 'Yan-a-dik'), (12, 'Tan-a-dik'), (13, 'Tethera-dik'),
  		(14, 'Pethera-dik'), (15, 'Bumfit'), (16, 'Yan-a-bumtit'),
  		(17, 'Tan-a-bumfit'), (18, 'Tethera-bumfit'),
  		(19, 'Pethera-bumfit'), (20, 'Figgot')
  		) AS LincolnshireCounting (number, word)
      FOR JSON AUTO
      )
	  
EXECUTE #MergeJSONwithCountingTable @json=@ElevenToTwenty, @Source='Lincolnshire'

EXECUTE #MergeJSONwithCountingTable @json=@OneToTen, @Source='Lincolnshire'

  --and make sure that we are protected against duplicate inserts
EXECUTE #MergeJSONwithCountingTable @Source='Lincolnshire', @json='[{"number": 11, "word": "Yan-a-dik"}, {"number": 12, "word": "Tan-a-dik"}]'
