-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CHEQUESBCREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CHEQUESBCREP`;DELIMITER $$

CREATE PROCEDURE `CHEQUESBCREP`(
Par_FechaCobro      DATE,
Par_FechaFinCobro   DATE,
Par_BancoEmisor     INT(11),
Par_CuentaEmisor    VARCHAR(20),
Par_NumCheque       INT(11),
Par_Estatus         CHAR(1),
Par_ClienteID       INT(11),
Par_SucursalID      INT(11),

Aud_EmpresaID       INT(11),
Aud_Usuario         INT(11),
Aud_FechaActual     DATETIME,
Aud_DireccionIP     VARCHAR(15),
Aud_ProgramaID      VARCHAR(50),
Aud_Sucursal        INT(11),
Aud_NumTransaccion  BIGINT(20)

        )
TerminaStore:BEGIN



DECLARE  Entero_Cero        INT;
DECLARE  Cadena_Vacia       CHAR(1);
DECLARE  Fecha_Vacia        DATE;
DECLARE  TipoExterno        CHAR(1);
DECLARE  TipoInterno        CHAR(1);
DECLARE  Var_EstatusRec     CHAR(1);
DECLARE  Var_EstatusApl     CHAR(1);
DECLARE  Var_EstatusCan     CHAR(1);
DECLARE  Var_EstatusRecD    VARCHAR(30);
DECLARE  Var_EstatusAplD    VARCHAR(30);
DECLARE  Var_EstatusCanD    VARCHAR(30);
DECLARE  DescInterno        CHAR(15);
DECLARE  DescExterno        CHAR(15);
DECLARE  Todas              CHAR(1);
DECLARE  Var_Sentencia      TEXT(90000);


SET Entero_Cero             := 0;
SET Cadena_Vacia            := '';
SET Fecha_Vacia             := '1900-01-01';
SET TipoExterno             := 'E';
SET TipoInterno             := 'I';
SET DescExterno             := 'Externo';
SET DescInterno             := 'Interno';
SET Todas                   := 'T';
SET Var_EstatusRec          := 'R';
SET Var_EstatusApl          := 'A';
SET Var_EstatusCan          := 'C';
SET Var_EstatusRecD         := 'Recibido';
SET Var_EstatusAplD         := 'Aplicado';
SET Var_EstatusCanD         := 'Cancelado';

SET Par_FechaCobro          :=  IFNULL(Par_FechaCobro,Fecha_Vacia);
SET Par_FechaFinCobro       :=  IFNULL(Par_FechaFinCobro,Fecha_Vacia);
SET Par_BancoEmisor         :=  IFNULL(Par_BancoEmisor,Entero_Cero);
SET Par_CuentaEmisor        :=  IFNULL(Par_CuentaEmisor,Cadena_Vacia);
SET Par_NumCheque           :=  IFNULL(Par_NumCheque,Entero_Cero);
SET Par_Estatus             :=  IFNULL(Par_Estatus,Cadena_Vacia);
SET Par_ClienteID           :=  IFNULL(Par_ClienteID,Entero_Cero);
SET Par_SucursalID          :=  IFNULL(Par_SucursalID,Entero_Cero);


SET Var_Sentencia   := ' SELECT AB.SucursalID,S.NombreSucurs,CASE AB.TipoCtaCheque ';
SET Var_Sentencia   := CONCAT(Var_sentencia,' WHEN ','"',TipoInterno,'"',' THEN ','"',DescInterno,'"');
SET Var_Sentencia   := CONCAT(Var_sentencia,' WHEN ','"',TipoExterno,'"',' THEN ','"',DescExterno,'"');
SET Var_Sentencia   := CONCAT(Var_sentencia,' END AS TipoCheque, AB.BancoEmisor,INS.NombreCorto,');
SET Var_Sentencia   := CONCAT(Var_sentencia,' AB.CuentaEmisor,AB.NumCheque,AB.ClienteID,AB.NombreReceptor,AB.Monto,AB.FechaCobro AS FechaRecepcion,');
SET Var_Sentencia   := CONCAT(Var_sentencia,' CASE AB.Estatus ');
SET Var_Sentencia   := CONCAT(Var_sentencia,' WHEN ','"',Var_EstatusRec,'"',' THEN ','"',Var_EstatusRecD,'"');
SET Var_Sentencia   := CONCAT(Var_sentencia,' WHEN ','"',Var_EstatusApl,'"',' THEN ','"',Var_EstatusAplD,'"');
SET Var_Sentencia   := CONCAT(Var_sentencia,' WHEN ','"',Var_EstatusCan,'"',' THEN ','"',Var_EstatusCanD,'"');
SET Var_Sentencia   := CONCAT(Var_sentencia,' END AS EstatusCheque ');
SET Var_Sentencia   := CONCAT(Var_sentencia,' FROM INSTITUCIONES INS');
SET Var_Sentencia   := CONCAT(Var_Sentencia,' INNER JOIN ABONOCHEQUESBC AB ');
SET Var_Sentencia   := CONCAT(Var_Sentencia,' ON INS.InstitucionID = AB.BancoEmisor');
SET Var_Sentencia   := CONCAT(Var_Sentencia,' INNER JOIN SUCURSALES S ON AB.SucursalID = S.SucursalID');
SET Var_Sentencia   := CONCAT(Var_Sentencia,' where AB.FechaCobro >="', Par_FechaCobro,'"');
SET Var_Sentencia   := CONCAT(Var_Sentencia,' and AB.FechaCobro <="',Par_FechaFinCobro,'"');

IF(Par_BancoEmisor != Entero_Cero)THEN
        SET Var_Sentencia := CONCAT(Var_Sentencia,' and AB.BancoEmisor=',Par_BancoEmisor);
END IF;

IF(Par_CuentaEmisor != Entero_Cero)THEN
        SET Var_Sentencia := CONCAT(Var_Sentencia,' and AB.CuentaEmisor="',Par_CuentaEmisor,'"');
END IF;

IF(Par_NumCheque != Entero_Cero)THEN
        SET Var_Sentencia := CONCAT(Var_Sentencia,' and AB.NumCheque=',Par_NumCheque);
END IF;

IF(Par_Estatus != Todas)THEN
        SET Var_Sentencia := CONCAT(Var_Sentencia,' and AB.Estatus="',Par_Estatus,'"');
END IF;

IF(Par_ClienteID != Entero_Cero)THEN
        SET Var_Sentencia := CONCAT(Var_Sentencia,' and AB.ClienteID=',Par_ClienteID);
END IF;

IF(Par_SucursalID != Entero_Cero)THEN
        SET Var_Sentencia := CONCAT(Var_Sentencia,' and AB.SucursalID=',Par_SucursalID);
END IF;

SET Var_Sentencia := CONCAT(Var_Sentencia,' order by AB.FechaCobro;');

SET @Sentencia  = (Var_Sentencia);
PREPARE STCRECASTIGOSREP FROM @Sentencia;
EXECUTE STCRECASTIGOSREP;
DEALLOCATE PREPARE STCRECASTIGOSREP;

END TerminaStore$$