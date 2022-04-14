-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGARECREDITOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGARECREDITOREP`;DELIMITER $$

CREATE PROCEDURE `PAGARECREDITOREP`(

    Par_CreditoID           BIGINT(12),
    Par_NumCon              TINYINT UNSIGNED,
    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)

        )
TerminaStore: BEGIN


DECLARE Entero_Cero         INT;
DECLARE Decimal_Cero        DECIMAL(12,2);
DECLARE Con_Principal       INT;
DECLARE esOficial           CHAR(1);



DECLARE Var_NombreInstitu       VARCHAR(100);
DECLARE Var_TasFija             DECIMAL(12,2);
DECLARE Var_EstadoSuc           VARCHAR(100);
DECLARE Var_MuniSuc             VARCHAR(100);
DECLARE Var_FrecuenciaInt       CHAR(1);
DECLARE Var_NumAmortizacion     INT (11);
DECLARE Var_DiasPasoVencim      INT;
DECLARE Var_CiudadInstitu       VARCHAR(50);
DECLARE Var_EdoInstitu          VARCHAR(50);
DECLARE Var_TotPagar            DECIMAL(14,2);
DECLARE Var_MontoCredLetra      VARCHAR(100);
DECLARE Var_MontoTotPagar       VARCHAR(150);
DECLARE Var_TotPagarCapital     DECIMAL(14,2);
DECLARE Var_MontoCuoLetra       VARCHAR(100);
DECLARE Var_MontoCuota          DECIMAL(12,2);
DECLARE Var_calle               VARCHAR(100);
DECLARE Var_NumCasa             VARCHAR(100);
DECLARE Var_Colonia             VARCHAR(100);
DECLARE Var_CodigoPostal        VARCHAR(100);
DECLARE Var_Estado              VARCHAR(100);
DECLARE Var_Municipio           VARCHAR(100);
DECLARE Oficial                 VARCHAR(100);
DECLARE Var_reca                VARCHAR(100);
DECLARE Var_NombreCliente       VARCHAR(150);
DECLARE Var_NombreInstituComillas VARCHAR (150);
DECLARE Var_ProductoCredito       INT;
DECLARE Var_InstitucionID         INT;
DECLARE Var_FechaSistema          VARCHAR(100);
DECLARE Var_DirFecha              VARCHAR(250);
DECLARE Var_EstSucMin             VARCHAR(100);
DECLARE Var_MunSucMin             VARCHAR(100);

DECLARE Var_MontoCredito        DECIMAL(12,2);



SET Entero_Cero         := 0;
SET Decimal_Cero        := 0.00;
SET Con_Principal       := 1;
SET esOficial           :='S';




IF(Par_NumCon = Con_Principal) THEN


  SELECT  FUNCIONLETRASFECHA(FechaSistema), InstitucionID
     INTO Var_FechaSistema, Var_InstitucionID
     FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;

        SELECT mun.Nombre, est.Nombre, inst.Nombre
            INTO Var_CiudadInstitu, Var_EdoInstitu, Var_NombreInstitu
            FROM INSTITUCIONES AS inst
      LEFT JOIN MUNICIPIOSREPUB AS mun ON inst.MunicipioEmpresa  = mun.MunicipioID
      LEFT JOIN ESTADOSREPUB AS est ON mun.EstadoID = est.EstadoID
           WHERE inst.InstitucionID = Var_InstitucionID
             AND mun.MunicipioID =  inst.MunicipioEmpresa
             AND est.EstadoID  = inst.EstadoEmpresa;

         SELECT     TasaFija,   NumAmortizacion, FrecuenciaInt,  ProductoCreditoID
            INTO    Var_TasFija,  Var_NumAmortizacion, Var_FrecuenciaInt, Var_ProductoCredito
            FROM    CREDITOS
            WHERE   CreditoID = Par_CreditoID;

    SELECT SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres)
        INTO Var_MontoCredito
        FROM CREDITOS Cre, AMORTICREDITO Amo
        WHERE Cre.CreditoID   = Par_CreditoID
          AND Amo.CreditoID = Cre.CreditoID;

    SET Var_MontoCredito := IFNULL(Var_MontoCredito, Decimal_Cero);
    SELECT FUNCIONNUMLETRAS(Var_MontoCredito)  INTO Var_MontoCredLetra;

    SELECT
        CONCAT(UPPER(LEFT(Edo.Nombre, 1)), LOWER(MID(Edo.Nombre,2))) AS Estado,
        CONCAT(UPPER(LEFT(Mun.Nombre, 1)), LOWER(MID(Mun.Nombre,2))) AS Municipio
        INTO Var_EstadoSuc, Var_MuniSuc
        FROM    SUCURSALES Suc
        INNER JOIN ESTADOSREPUB Edo ON Suc.EstadoID = Edo.EstadoID
        INNER JOIN MUNICIPIOSREPUB Mun ON Suc.EstadoID = Mun.EstadoID AND Suc.MunicipioID = Mun.MunicipioID
        WHERE Suc.SucursalID = Aud_Sucursal;

    SELECT DiasPasoVencido
        INTO Var_DiasPasoVencim
        FROM DIASPASOVENCIDO
        WHERE ProducCreditoID = Var_ProductoCredito
        AND Frecuencia = Var_FrecuenciaInt;

    SELECT (Amo.Capital + Amo.Interes + Amo.IVAInteres)
        INTO Var_MontoCuota
        FROM CREDITOS Cre, AMORTICREDITO Amo
        WHERE Cre.CreditoID   = Par_CreditoID
          AND Amo.CreditoID = Cre.CreditoID
        LIMIT 1;

    SET Var_MontoCuota := IFNULL(Var_MontoCuota, Decimal_Cero);
    SELECT FUNCIONNUMLETRAS(Var_MontoCuota) INTO Var_MontoCuoLetra;

    SELECT  dc.Calle ,dc.NumeroCasa, dc.colonia, dc.CP , dc.Oficial, edo.Nombre, mun.Nombre,
        CONCAT(IFNULL(c.PrimerNombre,''),' ', IFNULL(c.SegundoNombre,''),' ', IFNULL(c.TercerNombre,''),' ', IFNULL(c.ApellidoPaterno,''),' ',IFNULL(c.ApellidoMaterno,''))
              INTO Var_calle, Var_NumCasa, Var_Colonia, Var_CodigoPostal, Oficial, Var_Estado, Var_Municipio, Var_NombreCliente
              FROM CREDITOS AS cr INNER JOIN CLIENTES AS c ON cr.ClienteID = c.ClienteID
        INNER JOIN DIRECCLIENTE AS dc ON c.ClienteID=dc.ClienteID AND dc.Oficial = 'S'
        INNER JOIN ESTADOSREPUB edo ON dc.EstadoID=edo.EstadoID
        INNER JOIN MUNICIPIOSREPUB mun ON dc.MunicipioID=mun.MunicipioID AND dc.estadoID=mun.EstadoID
             WHERE cr.CreditoID = Par_CreditoID ;


    SELECT prod.RegistroRECA INTO Var_reca
        FROM PRODUCTOSCREDITO prod, CREDITOS cr
        WHERE cr.CreditoID = Par_CreditoID
        AND prod.ProducCreditoID=cr.ProductoCreditoID;


    SET Var_NombreInstituComillas := CONCAT('"',Var_NombreInstitu,'"');


    SET Var_DirFecha := CONCAT(Var_MuniSuc,', ',Var_EstadoSuc,', ', Var_FechaSistema);
    SET Var_MontoCuoLetra := CONCAT(Var_MontoCuoLetra, ' M.N.');
    SET Var_MontoCredLetra:= CONCAT(Var_MontoCredLetra, ' M.N.');

    SELECT
        Var_MontoCredito, Var_MontoCuota, Var_MontoCredLetra, Var_MontoCuoLetra,
        Var_NombreCliente,  Var_NombreInstitu,  Var_NombreInstituComillas,  Var_MontoTotPagar,
        Var_DiasPasoVencim, Var_CiudadInstitu,  Var_EdoInstitu,             Var_Calle,
        Var_NumCasa,        Var_Colonia,        Var_Municipio,              Var_Estado,
        Var_CodigoPostal,   Var_reca,           Var_NumAmortizacion,        Var_FrecuenciaInt,
        Var_TotPagar,       Var_TasFija,        Var_FechaSistema,
        Var_InstitucionID,  Var_EstSucMin,      Var_MunSucMin,              Var_DirFecha;

END IF;

END TerminaStore$$