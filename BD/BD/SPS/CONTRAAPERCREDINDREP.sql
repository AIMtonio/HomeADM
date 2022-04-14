-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTRAAPERCREDINDREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTRAAPERCREDINDREP`;DELIMITER $$

CREATE PROCEDURE `CONTRAAPERCREDINDREP`(

    Par_CreditoID           BIGINT(12),
    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)

        )
TerminaStore: BEGIN


DECLARE Cadena_Vacia        VARCHAR(2);
DECLARE Entero_Cero         INT;
DECLARE Decimal_Cero        DECIMAL(12,2);
DECLARE Con_Principal       INT;
DECLARE esOficial           CHAR(1);
DECLARE identificaIFE       INT;
DECLARE frecuenciaS         CHAR(1);
DECLARE frecuenciaC         CHAR(1);
DECLARE frecuenciaQ         CHAR(1);
DECLARE frecuenciaM         CHAR(1);
DECLARE frecuenciaP         CHAR(1);
DECLARE frecuenciaR         CHAR(1);
DECLARE frecuenciaE         CHAR(1);
DECLARE frecuenciaA         CHAR(1);
DECLARE frecuenciaL         CHAR(1);
DECLARE frecuenciaB         CHAR(1);
DECLARE frecuenciaT         CHAR(1);
DECLARE mes1                CHAR(1);
DECLARE mes2                CHAR(1);
DECLARE mes3                CHAR(1);
DECLARE mes4                CHAR(1);
DECLARE mes5                CHAR(1);
DECLARE mes6                CHAR(1);
DECLARE mes7                CHAR(1);
DECLARE mes8                CHAR(1);
DECLARE mes9                CHAR(1);
DECLARE mes10               CHAR(2);
DECLARE mes11               CHAR(2);
DECLARE mes12               CHAR(2);




DECLARE Var_NombreInstitu       VARCHAR(100);
DECLARE Var_TasFija             DECIMAL(12,4);
DECLARE Var_EstadoSuc           VARCHAR(100);
DECLARE Var_MuniSuc             VARCHAR(100);
DECLARE Var_FrecuenciaInt       VARCHAR(25);
DECLARE Var_NumAmortizacion     INT (11);
DECLARE Var_DiasPasoVencim      INT;
DECLARE Var_MontoCredLetra      VARCHAR(100);
DECLARE Var_MontoCredTotLetra   VARCHAR(100);
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
DECLARE Var_NombreCliente       VARCHAR(150);
DECLARE Var_InstitucionID       INT;
DECLARE Var_PresidenteConsejo   VARCHAR(45);
DECLARE Var_ClienteID           INT(11);
DECLARE Var_IdentIFE            VARCHAR(30);
DECLARE Var_DireccionCliente    VARCHAR(250);
DECLARE Var_MontoTotalCredito   DECIMAL(12,2);
DECLARE Var_MontoCredito        DECIMAL(12,2);
DECLARE Var_FechaVencimien      DATE;
DECLARE Var_aval                INT;
DECLARE Var_avalCliente         INT;
DECLARE Var_avalPros            INT;
DECLARE Var_NombreAval          VARCHAR(45);
DECLARE Var_DirAval             VARCHAR(250);
DECLARE Var_TasaMensual         DECIMAL(12,4);
DECLARE Var_FactorMora          DECIMAL(12,4);
DECLARE Var_FactorMoraMens      DECIMAL(12,4);
DECLARE Var_AmortizacionLetra   VARCHAR(45);
DECLARE Var_ValorCAT            DECIMAL(12,4);
DECLARE Var_Plazo               VARCHAR(45);
DECLARE Var_TasaFlat            DECIMAL(12,4);
DECLARE Var_TotInteres          DECIMAL(14,2);
DECLARE Var_Periodo             INT;
DECLARE Var_AnioActual          CHAR(4);
DECLARE Var_MesActual           VARCHAR(15);
DECLARE Var_DiaActual           INT;
DECLARE Var_AnioVencimien       CHAR(4);
DECLARE Var_MesVencimien        VARCHAR(15);
DECLARE Var_DiaVencimien        INT;
DECLARE Var_FechaInicio         DATE;
DECLARE Var_FechaVencimiento    DATE;
DECLARE Var_MesesCred           INT;
DECLARE Var_MesesCredLetra      VARCHAR(45);
DECLARE Var_Frecuencias         VARCHAR(45);
DECLARE Var_DirecCliente        VARCHAR(250);


SET Cadena_Vacia        :='';
SET Entero_Cero         := 0;
SET Decimal_Cero        := 0.00;
SET Con_Principal       := 1;
SET esOficial           :='S';
SET identificaIFE       := 1;
SET frecuenciaS         :='S';
SET frecuenciaC         :='C';
SET frecuenciaQ         :='Q';
SET frecuenciaM         :='M';
SET frecuenciaP         :='P';
SET frecuenciaR         :='R';
SET frecuenciaE         :='E';
SET frecuenciaA         :='A';
SET frecuenciaL         :='L';
SET frecuenciaB         :='B';
SET frecuenciaT         :='T';
SET mes1                :=1;
SET mes2                :=2;
SET mes3                :=3;
SET mes4                :=4;
SET mes5                :=5;
SET mes6                :=6;
SET mes7                :=7;
SET mes8                :=8;
SET mes9                :=9;
SET mes10               :=10;
SET mes11               :=11;
SET mes12               :=12;


SELECT  YEAR(FechaActual),
CASE MONTH(FechaActual) WHEN mes1 THEN 'Enero'
                        WHEN mes2 THEN 'Febrero'
                        WHEN mes3 THEN 'Marzo'
                        WHEN mes4 THEN 'Abril'
                        WHEN mes5 THEN 'Mayo'
                        WHEN mes6 THEN 'Junio'
                        WHEN mes7 THEN 'Julio'
                        WHEN mes8 THEN 'Agosto'
                        WHEN mes9 THEN 'Septiembre.'
                        WHEN mes10 THEN'Octubre'
                        WHEN mes11 THEN'Noviembre'
                        WHEN mes12 THEN'Diciembre'
                        ELSE '---'  END,
 DAY(FechaActual), InstitucionID, PresidenteConsejo
     INTO Var_AnioActual, Var_MesActual, Var_DiaActual, Var_InstitucionID, Var_PresidenteConsejo
     FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;

SELECT inst.Nombre
            INTO Var_NombreInstitu
            FROM INSTITUCIONES AS inst
           WHERE inst.InstitucionID = Var_InstitucionID;


    SELECT     cred.TasaFija,   cred.NumAmortizacion, CASE  cred.FrecuenciaInt
                                                                WHEN frecuenciaS THEN 'Semanal'
                                                                WHEN frecuenciaC THEN 'Catorcenal'
                                                                WHEN frecuenciaQ THEN 'Quincenal'
                                                                WHEN frecuenciaM THEN 'Mensual'
                                                                WHEN frecuenciaP THEN 'Periodico'
                                                                WHEN frecuenciaB THEN 'Bimestral'
                                                                WHEN frecuenciaT THEN 'Trimestral'
                                                                WHEN frecuenciaR THEN 'TetraMestral'
                                                                WHEN frecuenciaE THEN 'Semestral'
                                                                WHEN frecuenciaA THEN 'Anual'
                                                                WHEN frecuenciaL THEN 'Libre'
                                                                ELSE Cadena_Vacia   END AS tipoFrecuenciaInt,

                        prod.FactorMora,    cred.ValorCAT,      UPPER(pla.Descripcion) AS Plazo
                INTO    Var_TasFija,  Var_NumAmortizacion, Var_FrecuenciaInt, Var_FactorMora, Var_ValorCAT, Var_Plazo
                FROM    PRODUCTOSCREDITO prod, CREDITOS cred, CREDITOSPLAZOS pla
               WHERE    CreditoID = Par_CreditoID
                 AND     prod.ProducCreditoID=cred.ProductoCreditoID
                 AND     cred.PlazoID= pla.PlazoID;


    SET Var_TasaMensual := Var_TasFija / 12;
    SET Var_FactorMoraMens := Var_FactorMora / 12;
    SET Var_AmortizacionLetra := FUNCIONNUMEROSLETRAS(Var_NumAmortizacion);

    SET Var_TasFija    := ROUND(Var_TasFija, 2);
    SET Var_TasaMensual    := ROUND(Var_TasaMensual, 2);
    SET Var_FactorMora    := ROUND(Var_FactorMora, 2);
    SET Var_FactorMoraMens    := ROUND(Var_FactorMoraMens, 2);
    SET Var_ValorCAT    := ROUND(Var_ValorCAT, 2);

SET Var_Frecuencias :=  CASE Var_FrecuenciaInt
                                                                WHEN 'Semanal' THEN 'Semanales'
                                                                WHEN 'Catorcenal' THEN 'Catorcenales'
                                                                WHEN 'Quincenal' THEN 'Quincenales'
                                                                WHEN 'Mensual' THEN 'Mensuales'
                                                                WHEN 'Periodico' THEN 'Periodicos'
                                                                WHEN 'Bimestral' THEN 'Bimestrales'
                                                                WHEN 'Trimestral' THEN 'Trimestrales'
                                                                WHEN 'TetraMestral' THEN 'TetraMestrales'
                                                                WHEN 'Semestral' THEN 'Semestrales'
                                                                WHEN 'Anual' THEN 'Anuales'
                                                                WHEN 'Libre' THEN 'Libres'
                                                                ELSE Cadena_Vacia    END;

    SELECT Cre.MontoCredito,    SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres),  Cre.PeriodicidadInt,  SUM(Amo.Interes)
            INTO Var_MontoCredito, Var_MontoTotalCredito, Var_Periodo, Var_TotInteres
            FROM CREDITOS Cre, AMORTICREDITO Amo
           WHERE Cre.CreditoID = Par_CreditoID
             AND Amo.CreditoID = Cre.CreditoID;

    SET Var_NumAmortizacion   := IFNULL(Var_NumAmortizacion, Entero_Cero);
    SET Var_TotInteres  := IFNULL(Var_TotInteres, Entero_Cero);
    SET Var_MontoTotalCredito := IFNULL(Var_MontoTotalCredito, Decimal_Cero);
    SET Var_MontoCredito := IFNULL(Var_MontoCredito, Decimal_Cero);

    SELECT FUNCIONNUMLETRAS(Var_MontoTotalCredito)  INTO Var_MontoCredTotLetra;
    SELECT FUNCIONNUMLETRAS(Var_MontoCredito)  INTO Var_MontoCredLetra;
    SET Var_MontoCredLetra:= CONCAT(Var_MontoCredLetra, ' M.N.');
    SET Var_MontoCredTotLetra:= CONCAT(Var_MontoCredTotLetra, ' M.N.');



    SET Var_TasaFlat    := ( ( (Var_TotInteres / Var_NumAmortizacion) / Var_MontoCredito ) / Var_Periodo ) * 30 * 100;
    SET Var_TasaFlat    := ROUND(Var_TasaFlat, 2);



    SELECT  CONCAT(dc.Calle,', No.',dc.NumeroCasa,', ', dc.colonia,', ',mun.Nombre),
        CONCAT(c.PrimerNombre,' ', c.SegundoNombre,' ', c.TercerNombre,' ', c.ApellidoPaterno,' ',c.ApellidoMaterno), c.ClienteID,
        YEAR(cr.FechaVencimien),CASE MONTH(cr.FechaVencimien)
                                    WHEN 1 THEN 'Enero'
                                    WHEN 2 THEN 'Febrero'
                                    WHEN 3 THEN 'Marzo'
                                    WHEN 4 THEN 'Abril'
                                    WHEN 5 THEN 'Mayo'
                                    WHEN 6 THEN 'Junio'
                                    WHEN 7 THEN 'Julio'
                                    WHEN 8 THEN 'Agosto'
                                    WHEN 9 THEN 'Septiembre.'
                                    WHEN 10 THEN'Ooctubre'
                                    WHEN 11 THEN'Noviembre'
                                    WHEN 12 THEN'Diciembre'
                                        ELSE '---'  END,
    DAY(cr.FechaVencimien), cr.FechaInicio, cr.FechaVencimien
              INTO Var_DireccionCliente, Var_NombreCliente, Var_ClienteID, Var_AnioVencimien, Var_MesVencimien,
                   Var_DiaVencimien, Var_FechaInicio, Var_FechaVencimiento
              FROM CREDITOS AS cr INNER JOIN CLIENTES AS c ON cr.ClienteID = c.ClienteID
        INNER JOIN DIRECCLIENTE AS dc ON c.ClienteID=dc.ClienteID AND dc.Oficial = esOficial
        INNER JOIN ESTADOSREPUB edo ON dc.EstadoID=edo.EstadoID
        INNER JOIN MUNICIPIOSREPUB mun ON dc.MunicipioID=mun.MunicipioID AND dc.estadoID=mun.EstadoID
             WHERE cr.CreditoID = Par_CreditoID ;


SET Var_MesesCred := TIMESTAMPDIFF(MONTH,Var_FechaInicio,Var_FechaVencimiento);
SET Var_MesesCredLetra := FUNCIONNUMEROSLETRAS(Var_MesesCred);


    SELECT NumIdentific
         INTO Var_IdentIFE
         FROM IDENTIFICLIENTE
        WHERE TipoIdentiID = identificaIFE
          AND ClienteID = Var_ClienteID;


SELECT avs.AvalID, avs.ClienteID, avs.ProspectoID
      INTO Var_aval, Var_avalCliente, Var_avalPros
      FROM AVALESPORSOLICI avs
INNER JOIN CREDITOS cre ON avs.SolicitudCreditoID = cre.SolicitudCreditoID
     WHERE cre.CreditoID = Par_CreditoID;

SET Var_aval :=IFNULL(Var_aval,Entero_Cero);
SET Var_avalCliente :=IFNULL(Var_avalCliente,Entero_Cero);
SET Var_avalPros :=IFNULL(Var_avalPros,Entero_Cero);

IF(Var_aval != Entero_Cero) THEN

            SELECT avl.NombreCompleto, CONCAT(avl.Calle,', No.',avl.NumExterior,', ', avl.colonia,', ',mun.Nombre)
            INTO Var_NombreAval, Var_DirAval
            FROM AVALES avl
            INNER JOIN AVALESPORSOLICI avs ON avl.AvalID = avs.AvalID
            INNER JOIN CREDITOS cre ON avs.SolicitudCreditoID = cre.SolicitudCreditoID
            INNER JOIN MUNICIPIOSREPUB mun ON avl.MunicipioID=mun.MunicipioID
            WHERE cre.CreditoID = Par_CreditoID
            LIMIT 1;
        END IF;

IF(Var_avalCliente != Entero_Cero) THEN

            SELECT cli.NombreCompleto, CONCAT(dc.Calle,', No.',dc.NumeroCasa,', ', dc.colonia,', ',mun.Nombre)
            INTO Var_NombreAval, Var_DirAval
            FROM CLIENTES cli
            LEFT JOIN DIRECCLIENTE AS dc ON cli.ClienteID=dc.ClienteID AND dc.Oficial = esOficial
            INNER JOIN AVALESPORSOLICI avs ON cli.ClienteID = avs.ClienteID
            INNER JOIN CREDITOS cre ON avs.SolicitudCreditoID = cre.SolicitudCreditoID
            LEFT JOIN MUNICIPIOSREPUB mun ON dc.MunicipioID=mun.MunicipioID
            WHERE cre.CreditoID = Par_CreditoID
            LIMIT 1;
        END IF;


IF(Var_avalPros != Entero_Cero) THEN

            SELECT NombreCompleto, CONCAT(pro.Calle,', No.',pro.NumExterior,', ',pro.Colonia,', ',mun.Nombre)
            INTO Var_NombreAval, Var_DirAval
            FROM PROSPECTOS pro
            INNER JOIN MUNICIPIOSREPUB mun ON pro.MunicipioID = mun.MunicipioID AND pro.EstadoID = mun.EstadoID
            INNER JOIN AVALESPORSOLICI avs ON pro.ProspectoID = avs.ProspectoID
            INNER JOIN CREDITOS cre ON avs.SolicitudCreditoID = cre.SolicitudCreditoID
            WHERE cre.CreditoID = Par_CreditoID
            LIMIT 1;
        END IF;

SET Var_NombreAval  := IFNULL(Var_NombreAval, Cadena_Vacia);
SET Var_DirAval  := IFNULL(Var_DirAval, Cadena_Vacia);


    SELECT
        Var_MontoTotalCredito,  Var_MontoCredito,       Var_MontoCredTotLetra,  Var_MontoCredLetra,     Var_NombreCliente,
        Var_NombreInstitu,      Var_NumAmortizacion,    Var_FrecuenciaInt,      Var_TasFija,            Var_InstitucionID,
        Var_PresidenteConsejo,  Var_IdentIFE,           Var_DireccionCliente,   Var_FechaVencimien,     Var_NombreAval,
        Var_DirAval,            Var_TasaMensual,        Var_FactorMora,         Var_FactorMoraMens,     Var_AmortizacionLetra,
        Var_ValorCAT,           Var_Plazo,              Var_TasaFlat,           Var_AnioActual,         Var_MesActual,
        Var_DiaActual,          Var_AnioVencimien,      Var_MesVencimien,       Var_DiaVencimien,       Var_MesesCred,
        Var_MesesCredLetra,     Var_Frecuencias;


END TerminaStore$$