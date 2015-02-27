INSERT INTO dbo.ZipCodeData
        ( ZipCode ,
          StateCode ,
          Latitude ,
          Longitude
        )
VALUES  ( 71481 , -- ZipCode - int
          'LA' , -- StateCode - varchar(2)
          31.699860 , -- Latitude - numeric
          -92.772852  -- Longitude - numeric
        )
GO

INSERT INTO dbo.ZipCodeCityData
        ( ZipCode, City )
VALUES  ( 71481, -- ZipCode - int
          'Verda'  -- City - varchar(255)
          )
GO

INSERT INTO dbo.ZipCodeCountyData
        ( ZipCode, County )
VALUES  ( 71481, -- ZipCode - int
          'Grant'  -- County - varchar(255)
          )
GO