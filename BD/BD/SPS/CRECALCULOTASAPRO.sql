-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECALCULOTASAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECALCULOTASAPRO`;DELIMITER $$

CREATE PROCEDURE `CRECALCULOTASAPRO`(

    Par_CreditoID       BIGINT(12),
    Par_FormulaID       INT(11) ,
    Par_TasaFija        DECIMAL(12,4),
    Par_Fecha           DATE,
    Par_FecIniAmo       DATE,
    Par_EmpresaID       INT(11),
    out Par_TasaOut     DECIMAL(12,4),

    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
        )
TerminaStore: BEGIN


DECLARE Var_PisoTasa        DECIMAL(12,4);
DECLARE Var_TechoTasa       DECIMAL(12,4);
DECLARE Var_TasaBase        INT;
DECLARE Var_SobreTasa       DECIMAL(12,4);
DECLARE Var_FecTas          DATETIME;


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Entero_Cero         INT;
DECLARE For_TasaFija        INT;
DECLARE For_BasePuntos      INT;
DECLARE For_BaPunPisTecho   INT;
DECLARE For_TBUltDiaMesPunt INT;
DECLARE Var_FecFinMesAnt    DATE;
DECLARE Var_FecIniMesAnt    DATE;
DECLARE Var_numTra          BIGINT;


SET Cadena_Vacia            := '';
SET Fecha_Vacia             := '1900-01-01';
SET Entero_Cero             := 0;
SET For_TasaFija            := 1;
SET For_BasePuntos          := 2;
SET For_BaPunPisTecho       := 3;
SET For_TBUltDiaMesPunt     := 4;

IF (Par_FormulaID = For_TasaFija) then
    SET Par_TasaOut = Par_TasaFija ;

ELSEIF (Par_FormulaID = For_BasePuntos) then

	SELECT TasaBase, SobreTasa INTO Var_TasaBase, Var_SobreTasa
		FROM CREDITOS
			WHERE CreditoID = Par_CreditoID;

	SET Var_numTra:= (SELECT MAX(NumTransaccion)
						FROM TASASBASE
							WHERE TasaBaseID = Var_TasaBase);

	SELECT  Valor INTO Par_TasaOut
		FROM TASASBASE
			WHERE TasaBaseID = Var_TasaBase
                AND NumTransaccion=Var_numTra;


    SET Par_TasaOut = IFNULL(Par_TasaOut, Entero_Cero);
    SET Par_TasaOut = Par_TasaOut + Var_SobreTasa;

ELSEIF (Par_FormulaID = For_BaPunPisTecho) then

    SELECT TasaBase, SobreTasa, PisoTasa, TechoTasa
        INTO Var_TasaBase, Var_SobreTasa, Var_PisoTasa, Var_TechoTasa
            FROM CREDITOS
                WHERE CreditoID = Par_CreditoID;

    SELECT  MAX(Fecha) INTO Var_FecTas
        FROM `HIS-TASASBASE`
            WHERE TasaBaseID = Var_TasaBase;

    SET Var_FecTas = IFNULL(Var_FecTas, Fecha_Vacia);

    SET Var_numTra:= (
                    SELECT MAX(NumTransaccion)
                        FROM `HIS-TASASBASE`
                            WHERE TasaBaseID = Var_TasaBase
                                AND Fecha= Var_FecTas );
    SELECT  Valor INTO Par_TasaOut
        FROM `HIS-TASASBASE`
            WHERE TasaBaseID = Var_TasaBase
                AND Fecha       = Var_FecTas
                AND NumTransaccion=Var_numTra;

    SET Par_TasaOut = IFNULL(Par_TasaOut, Entero_Cero);
    SET Par_TasaOut = Par_TasaOut + Var_SobreTasa;

    IF (Par_TasaOut > Var_TechoTasa) then
        SET Par_TasaOut = Var_TechoTasa;
    END IF;

    IF (Par_TasaOut < Var_PisoTasa) then
        SET Par_TasaOut = Var_PisoTasa;
    END IF;

 ELSEIF (Par_FormulaID = For_TBUltDiaMesPunt) then

    SET Var_FecFinMesAnt    := last_day(date_sub(Par_Fecha, Interval 1 month));
    SET Var_FecIniMesAnt := date_sub(Var_FecFinMesAnt, Interval DAYOFMONTH(Var_FecFinMesAnt)-1 day);


    SELECT  Cre.TasaBase, Cre.SobreTasa
        INTO Var_TasaBase, Var_SobreTasa
            FROM CREDITOS Cre
                WHERE Cre.CreditoID = Par_CreditoID;

    SELECT  MAX(Fecha) INTO Var_FecTas
        FROM `HIS-TASASBASE`
            WHERE   TasaBaseID  = Var_TasaBase
              AND   Fecha       >= Var_FecIniMesAnt
              AND   Fecha       <= Var_FecFinMesAnt;

    SET Var_FecTas = IFNULL(Var_FecTas, Fecha_Vacia);


    SET Var_numTra:= (
                    SELECT MAX(NumTransaccion)
                            FROM `HIS-TASASBASE`
                            WHERE TasaBaseID = Var_TasaBase
                              AND Fecha= Var_FecTas );

    SELECT  Valor INTO Par_TasaOut
        FROM `HIS-TASASBASE`
            WHERE TasaBaseID = Var_TasaBase
                AND Fecha        = Var_FecTas
                AND NumTransaccion=Var_numTra;

    SET Par_TasaOut:= IFNULL(Par_TasaOut, Entero_Cero)+ IFNULL(Var_SobreTasa, Entero_Cero);
ELSE
    SET Par_TasaOut = Entero_Cero;
END IF;

END TerminaStore$$