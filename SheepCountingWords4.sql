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