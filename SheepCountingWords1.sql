  DROP TABLE IF EXISTS SheepCountingWords 
  CREATE TABLE SheepCountingWords
    (
    Number INT NOT NULL,
    Word VARCHAR(40) NOT NULL,
    Region VARCHAR(40) NOT NULL,
    CONSTRAINT NumberRegionKey PRIMARY KEY  (Number,Region)
    );
  GO