-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ABONOCHEQUESBCLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ABONOCHEQUESBCLIS`;DELIMITER $$

CREATE PROCEDURE `ABONOCHEQUESBCLIS`(

    Par_ChequeSBCID         INT(11),
    Par_CuentaAhoID         BIGINT(12),
    Par_ClienteID           INT(11),
    Par_InstitucionID       INT(11),
    Par_CuentaEmisor        VARCHAR(20),
    Par_NombreReceptor      VARCHAR(200),

    Par_SucursalID          INT(11),
    Par_TipoCheque          CHAR(1),
    Par_FechaCobro          DATETIME,
    Par_NumLis              TINYINT UNSIGNED,
    Par_EmpresaID           INT,

    Aud_Usuario             INT,
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)


        )
TerminaStore:BEGIN


DECLARE List_Cuenta         INT;
DECLARE List_NumCheque      INT;
DECLARE List_NumChequeSBC   INT;
DECLARE EnteroCero          INT;
DECLARE Recibido            CHAR;
DECLARE CadenaVacia         CHAR(1);
DECLARE Var_Sentencia       VARCHAR(60000);


SET List_Cuenta             :=1;
SET List_NumCheque          :=2;
SET List_NumChequeSBC       :=3;
SET EnteroCero              :=0;
SET Recibido                :='R';
SET CadenaVacia             :='';

IF (List_Cuenta= Par_NumLis) THEN
    SELECT  ChequeSBCID,    CONCAT('Cta.: ',CONVERT(CuentaEmisor,CHAR)," - ",' Cheque: ',CONVERT(NumCheque,CHAR)," - ",' Monto: ',CONVERT(format(Monto,2),CHAR)) AS NumCheque
        FROM    ABONOCHEQUESBC
        WHERE   CuentaAhoID = Par_CuentaAhoID
         AND    Estatus = Recibido;
END IF;

IF(List_NumCheque=Par_NumLis) THEN

    SET Var_Sentencia   :=' SELECT csbc.NumCheque,csbc.NombreReceptor';
    SET Var_Sentencia   := CONCAT(Var_sentencia,' from ABONOCHEQUESBC csbc');
    SET Var_Sentencia   := CONCAT(Var_sentencia,' where csbc.NombreReceptor like concat(','"%","',Par_NombreReceptor,'","%"',')');
    SET Var_Sentencia   := CONCAT(Var_sentencia,' and csbc.SucursalID=',Par_SucursalID);
    SET Var_Sentencia   := CONCAT(Var_sentencia,' and csbc.FechaCobro=','"',Par_FechaCobro,'"');


    IF(Par_InstitucionID != EnteroCero)THEN
            SET Var_Sentencia := CONCAT(Var_Sentencia,' and csbc.BancoEmisor=',Par_InstitucionID);
    END IF;

    IF(Par_TipoCheque='I' OR Par_TipoCheque='E') THEN
        SET Var_Sentencia := CONCAT(Var_Sentencia,' and csbc.TipoCtaCheque=','"',Par_TipoCheque,'"');
        ELSE
            SET Var_Sentencia := CONCAT(Var_Sentencia,' and csbc.TipoCtaCheque!=','"',CadenaVacia,'"');
    END IF;
    SET Var_Sentencia := CONCAT(Var_Sentencia,' limit 15;');

   SET @Sentencia   = (Var_Sentencia);

   PREPARE STCRECASTIGOSREP FROM @Sentencia;
   EXECUTE STCRECASTIGOSREP  ;
   DEALLOCATE PREPARE STCRECASTIGOSREP;

END IF;

IF(List_NumChequeSBC = Par_NumLis) THEN

    SET Var_Sentencia   :=' SELECT csbc.NumCheque,csbc.NombreReceptor';
    SET Var_Sentencia   := CONCAT(Var_sentencia,' from ABONOCHEQUESBC csbc');
    SET Var_Sentencia   := CONCAT(Var_sentencia,' where csbc.NombreReceptor like concat(','"%","',Par_NombreReceptor,'","%"',')');

    IF(Par_InstitucionID != EnteroCero)THEN
            SET Var_Sentencia := CONCAT(Var_Sentencia,' and csbc.BancoEmisor=',Par_InstitucionID);
    END IF;

    IF(Par_InstitucionID != EnteroCero)THEN
            SET Var_Sentencia := CONCAT(Var_Sentencia,' and csbc.CuentaEmisor=',Par_CuentaEmisor);
    END IF;

    SET Var_Sentencia := CONCAT(Var_Sentencia,' limit 15;');

   SET @Sentencia   = (Var_Sentencia);

   PREPARE NUMCHEQUESBC FROM @Sentencia;
   EXECUTE NUMCHEQUESBC ;
   DEALLOCATE PREPARE NUMCHEQUESBC;

END IF;

END TerminaStore$$