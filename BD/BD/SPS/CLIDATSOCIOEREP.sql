-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIDATSOCIOEREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIDATSOCIOEREP`;DELIMITER $$

CREATE PROCEDURE `CLIDATSOCIOEREP`(
    Par_ClienteID   int,
    Par_TipoRep     int,

    Par_EmpresaID			INT(11),
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			    INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore: BEGIN

DECLARE Var_LinNeg  int;

DECLARE TipoRepIn   	int;
DECLARE TipoRepEg  	 	int;
DECLARE TipoRepSum		int;
DECLARE Decimal_Cero    decimal(12,2);
DECLARE Ingresos    	char(1);
DECLARE Egresos     	char(1);
DECLARE Var_MontoE		varchar(100);
DECLARE Var_MontoI		varchar(100);

Set Decimal_Cero	:= 0.0;
Set TipoRepIn   	:= 1;
Set TipoRepEg   	:= 2;
set TipoRepSum		:= 3;
Set Ingresos    	:= 'I';
Set Egresos     	:= 'E';

IF(Par_TipoRep = TipoRepIn ) THEN
    SELECT LinNegID
        INTO
            Var_LinNeg
        FROM CLIDATSOCIOE
            WHERE ClienteID= Par_ClienteID
                ORDER BY LinNegID LIMIT 1;

    SELECT Descripcion, Monto
        FROM CLIDATSOCIOE Dat
            INNER JOIN CATDATSOCIOE Cat ON Dat.CatSocioEID = Cat.CatSocioEID
                WHERE ClienteID= Par_ClienteID
                AND Cat.Tipo = Ingresos
                AND LinNegID = Var_LinNeg;
END IF;

IF(Par_TipoRep = TipoRepEg ) THEN

       SELECT LinNegID
        INTO
            Var_LinNeg
        FROM CLIDATSOCIOE
            WHERE ClienteID= Par_ClienteID
                ORDER BY LinNegID LIMIT 1;

    SELECT Descripcion, Monto
        FROM CLIDATSOCIOE Dat
           INNER JOIN CATDATSOCIOE Cat ON Dat.CatSocioEID = Cat.CatSocioEID
           WHERE ClienteID= Par_ClienteID
           AND Cat.Tipo = Egresos
           AND LinNegID = Var_LinNeg;
END IF;

IF(Par_TipoRep = TipoRepEg ) THEN

       SELECT LinNegID
        INTO
            Var_LinNeg
        FROM CLIDATSOCIOE
            WHERE ClienteID= Par_ClienteID
                ORDER BY LinNegID LIMIT 1;

    SELECT Descripcion, Monto
        FROM CLIDATSOCIOE Dat
           INNER JOIN CATDATSOCIOE Cat ON Dat.CatSocioEID = Cat.CatSocioEID
           WHERE ClienteID= Par_ClienteID
           AND Cat.Tipo = Egresos
           AND LinNegID = Var_LinNeg;
END IF;



IF(Par_TipoRep = TipoRepSum) THEN

       SELECT LinNegID
        INTO
            Var_LinNeg
        FROM CLIDATSOCIOE
            WHERE ClienteID= Par_ClienteID
                ORDER BY LinNegID LIMIT 1;

  SELECT SUM(Monto)
			into Var_MontoI
        FROM CLIDATSOCIOE Dat
            INNER JOIN CATDATSOCIOE Cat ON Dat.CatSocioEID = Cat.CatSocioEID
                WHERE ClienteID= Par_ClienteID
                AND Cat.Tipo = Ingresos
                AND LinNegID = Var_LinNeg;
	set Var_MontoI   := ifnull(Var_MontoI, Decimal_Cero);

    SELECT SUM(Monto)
		into Var_MontoE
        FROM CLIDATSOCIOE Dat
           INNER JOIN CATDATSOCIOE Cat ON Dat.CatSocioEID = Cat.CatSocioEID
           WHERE ClienteID= Par_ClienteID
           AND Cat.Tipo = Egresos
           AND LinNegID = Var_LinNeg;
	set Var_MontoE   := ifnull(Var_MontoE, Decimal_Cero);
	select Var_MontoI,Var_MontoE;

END IF;
END TerminaStore$$