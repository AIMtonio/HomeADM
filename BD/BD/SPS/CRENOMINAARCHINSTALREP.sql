-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRENOMINAARCHINSTALREP
DELIMITER  ;
DROP PROCEDURE IF EXISTS `CRENOMINAARCHINSTALREP`;

DELIMITER  $$
CREATE PROCEDURE `CRENOMINAARCHINSTALREP`(
    -- STORE PARA CONSULTAR LA INFORMACION DE LOS CREDITOS DESEMBOLSADOS HASTA LA FECHA ACTUAL.
    Par_FolioID                     INT(11),    -- Folio del archivo de instalacion
    Par_TipoRep                     INT(1),     -- Tipo de Lista

    /* Parametros de Auditoria */
    Par_EmpresaID   	            INT(11),        -- Parametro de auditoria
	Aud_Usuario			            INT(11),        -- Parametro de auditoria
	Aud_FechaActual		            DATETIME,       -- Parametro de auditoria
	Aud_DireccionIP		            VARCHAR(15),    -- Parametro de auditoria
	Aud_ProgramaID		            VARCHAR(50),    -- Parametro de auditoria
	Aud_Sucursal		            INT(11),        -- Parametro de auditoria
	Aud_NumTransaccion	            BIGINT(20)      -- Parametro de auditoria
)
TerminaStore: BEGIN

    /* Declatacion de Constantes */
    DECLARE Cadena_Vacia            CHAR(1);
    DECLARE Entero_Cero             INT(1);
    DECLARE Lis_Principal           INT(1);
    DECLARE Lis_xFolio              INT(1);
    DECLARE LIS_Archivos            INT(1);
    DECLARE Var_EstatusVigente      CHAR(1);
    DECLARE EstatusNomina_N          CHAR(1);
    -- Delcaración Variables
    DECLARE Var_InstitucionNomina   INT(11);
    DECLARE Var_ConvenioNomina      INT(11);

    /* Asignacion de Constantes */
    SET Cadena_Vacia        :=  '';
    SET Entero_Cero         :=  0;
    SET Lis_Principal       :=  1;
    SET Lis_xFolio          :=  2;
    SET LIS_Archivos        :=  3;
    SET Var_EstatusVigente  := 'V';
    SET EstatusNomina_N     := 'N';

    -- Asignacion Variables
    SET Var_InstitucionNomina := Entero_Cero;
    SET Var_ConvenioNomina    := Entero_Cero;

    -- Creacion de la tabla temporal que servira para almacenar los datos por secciones.
    DROP TABLE IF EXISTS TEMPCRENOMARCHINSTREP;
	CREATE TEMPORARY TABLE TEMPCRENOMARCHINSTREP(
		  `SolicitudCreditoID` 		BIGINT(20),
		  `CreditoID` 			    BIGINT(20),
          `ClienteID` 			    BIGINT(20),
          `InstitNominaID` 			BIGINT(20),
          `ConvenioNominaID` 		BIGINT(20),
          `PlazoID` 		        INT(11),
		  `NombreInstit` 		    VARCHAR(200),
		  `NombreCompleto` 			VARCHAR(250),
		  `EstatusNomina` 			CHAR(1),
		  `Estatus` 				CHAR(1),
		  `RFC`			            VARCHAR(13),
		  `CURP` 			        VARCHAR(18),
		  `MontoCredito` 		    DECIMAL(12,2),
		  `TasaAnual` 		        DECIMAL(8,4),
		  `Plazo` 		            VARCHAR(50),
		  `NumAmortizacion` 		INT(11),
		  `FechaInicioAmor` 		DATE,
		  `FechaVencimiento` 		DATE,
          `Capital` 			    DECIMAL(14,2),
          `MontoPagare` 			DECIMAL(14,2),
          `MontoDescuento` 			DECIMAL(14,2),
		  `NumeroEmpleado` 	        VARCHAR(30),
          INDEX (SolicitudCreditoID, CreditoID)
	);

    /* Lista Principal */
    IF(Par_TipoRep = Lis_Principal) THEN


        SET Var_InstitucionNomina   := (SELECT InstitucionID FROM CRENOMINAARCHINSTAL WHERE FolioID = Par_FolioID);
        SET Var_ConvenioNomina      := (SELECT ConvenioID FROM CRENOMINAARCHINSTAL WHERE FolioID = Par_FolioID);

        -- Insertamos la informacion del credito perteneciente de la tabla CREDITOS.
        INSERT INTO TEMPCRENOMARCHINSTREP(
            SolicitudCreditoID,     CreditoID,          MontoCredito,       FechaInicioAmor,        FechaVencimiento,
            ClienteID,              ConvenioNominaID,   InstitNominaID,		EstatusNomina,			Estatus
        )
        SELECT
            c.SolicitudCreditoID,   c.CreditoID,        c.MontoCredito,     c.FechaInicioAmor,      c.FechaVencimien,
            c.ClienteID,            c.ConvenioNominaID, c.InstitNominaID,	c.EstatusNomina,		c.Estatus
        FROM CREDITOS c
        WHERE c.InstitNominaID = Var_InstitucionNomina
        AND c.ConvenioNominaID = Var_ConvenioNomina
        AND c.EstatusNomina = EstatusNomina_N
        AND c.Estatus = Var_EstatusVigente;

        -- Insertamos la informacion del cliente al que le pertenece el credito..
        UPDATE TEMPCRENOMARCHINSTREP CR
        INNER JOIN CLIENTES CL
        ON CL.ClienteID = CR.ClienteID
        SET
            CR.NombreCompleto   =   IF(CL.TipoPersona = 'M',IFNULL(CL.RazonSocial,''),CONCAT(IFNULL(CL.ApellidoPaterno, ''), ' ' , IFNULL(CL.ApellidoMaterno,''), ' ',
                                    IFNULL(CL.PrimerNombre, ''), ' ' , IFNULL(CL.SegundoNombre, ''), ' ' , IFNULL(CL.TercerNombre, ''))),
            CR.RFC              =   CL.RFC,
            CR.CURP             =   CL.CURP;

        -- Insertamos la informacion de la institucion de nomina.
        UPDATE TEMPCRENOMARCHINSTREP CR
        INNER JOIN INSTITNOMINA INS
        ON INS.InstitNominaID = Var_InstitucionNomina
        SET
            CR.NombreInstit = INS.NombreInstit;

        -- Insertamos la informacion del numero de cuotas y de la tasa fija.
        UPDATE TEMPCRENOMARCHINSTREP CR
        INNER JOIN SOLICITUDCREDITO SOL
        ON SOL.CreditoID = CR.CreditoID
        SET
            CR.NumAmortizacion  = SOL.NumAmortizacion,
            CR.TasaAnual        = SOL.TasaFija,
            CR.PlazoID          = SOL.PlazoID;

        -- Insertamos la informacion de la descripcion del plazo del credito.
        UPDATE TEMPCRENOMARCHINSTREP CR
        INNER JOIN CREDITOSPLAZOS CP
        ON CP.PlazoID = CR.PlazoID
        SET
            CR.Plazo  = CP.descripcion;

        -- Insertamos la informacion de los intereses y su correspondiente IVA.
        UPDATE TEMPCRENOMARCHINSTREP CR
        SET
            CR.MontoPagare    = IFNULL((SELECT (SUM(a.Interes) + SUM(a.IVAInteres) + SUM(a.MontoOtrasComisiones) + SUM(a.MontoIVAOtrasComisiones) + SUM(a.MontoIntOtrasComis) + SUM(a.MontoIVAIntComisi))  FROM AMORTICREDITO a WHERE a.CreditoID = CR.CreditoID),Entero_Cero),
            CR.MontoDescuento = IFNULL((SELECT (a.Capital + a.Interes + a.IVAInteres + a.MontoOtrasComisiones + a.MontoIVAOtrasComisiones + a.MontoIntOtrasComis + a.MontoIVAIntComisi)  FROM AMORTICREDITO a WHERE a.CreditoID = CR.CreditoID LIMIT 1),Entero_Cero),
            CR.NumeroEmpleado = IFNULL((SELECT NoEmpleado FROM NOMINAEMPLEADOS n WHERE InstitNominaID = CR.InstitNominaID AND ConvenioNominaID = CR.ConvenioNominaID  AND ClienteID = CR.ClienteID), Entero_Cero);
        SELECT  SolicitudCreditoID,     CreditoID,                  NumeroEmpleado,     NombreInstit,               NombreCompleto,
                RFC,                    CURP,                       MontoCredito,       MontoPagare,                TasaAnual,
                Plazo,                  NumAmortizacion,            MontoDescuento,     FechaInicioAmor,            FechaVencimiento
        FROM TEMPCRENOMARCHINSTREP;

        DROP TABLE IF EXISTS TEMPCRENOMARCHINSTREP;

    END IF;

END TerminaStore$$
