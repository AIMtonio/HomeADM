-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAREP`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAREP`(
	-- SP para obtener los datos para la generación de la carátula para tarjeta de debito.
	Par_NumRep			TINYINT UNSIGNED,				-- Parametro numero de reporte

	Par_ClienteID		INT(11),						-- Identificador del cliente
	Par_FechaIni		DATETIME,						-- Fecha de inicio
	Par_FechaFin		DATETIME,						-- Fecha de fin

	Par_EmpresaID		INT(11),						-- Parametros de auditorial
	Aud_Usuario			INT(11),						-- Parametros de auditorial
	Aud_FechaActual		DATETIME,						-- Parametros de auditorial
	Aud_DireccionIP		VARCHAR(15), 					-- Parametros de auditorial
	Aud_ProgramaID		VARCHAR(50),					-- Parametros de auditorial
	Aud_Sucursal		INT(11),						-- Parametros de auditorial
	Aud_NumTransaccion	BIGINT							-- Parametros de auditorial
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Entero_Cero				INT(11);  			-- constante 0
	DECLARE Cadena_Vacia			VARCHAR(1);			-- Cadena vacía
	DECLARE Decimal_Cero			DECIMAL(12,2);		-- constante 0.0
	DECLARE ConstS					CHAR(1);			-- Constante S
    DECLARE Cons_Mensual			CHAR(1);			-- Frecuencia Mensual
    DECLARE Cons_Semestral			CHAR(1);			-- Frecuencia Semestral
	DECLARE ValorTres				INT(1);				-- Constante 3
    DECLARE Var_AMes				INT(8);

	DECLARE	Rep_DatosInstitucion	INT(1);				-- constante para el reporte de DatosInstitucion
	DECLARE Rep_Clientes			INT(1);				-- Constante para el reporte del cliente
	DECLARE Rep_DatosUEAU			INT(1);				-- Constante para Datos UEAU

	DECLARE Rep_DatosCFDIIngreso	INT(2);				-- Constante para Rep_DatosCFDIIngreso
	DECLARE Rep_ResumenCreditos		INT(2);				-- Constante para Resumen Creditos
	DECLARE Rep_ResumenInversion	INT(2);				-- Constante para Resumen de Inversiones

	-- Declaracion de variables
	DECLARE Var_ClienteID			INT(11);

	DECLARE Var_AnioMes				INT(11);
	DECLARE Var_SucursalID			VARCHAR(45);
	DECLARE Var_PeriodoID			INT(11);
	DECLARE Var_Cantidad			DECIMAL(14,2);

	DECLARE Var_MontoIDE			DECIMAL(14,2);
	DECLARE Var_CantidadCob			DECIMAL(14,2);
	DECLARE Var_CantidadPen			DECIMAL(14,2);
	DECLARE	Var_CFDIFechaTimbrado	VARCHAR(50);

	DECLARE Var_Estatus				INT(11);
	DECLARE Var_NombreInstitucion	VARCHAR(100);
	DECLARE Var_TelefonoUEAU		VARCHAR(45);

	DECLARE Var_DireccionUEAU		VARCHAR(250);
	DECLARE Var_CorreoUEAU			VARCHAR(45);
	DECLARE Var_CFDINoCertSATRet	VARCHAR(45);
	DECLARE Var_CFDIUUIDRet			VARCHAR(50);
	DECLARE Var_CFDIFechaTimRet		VARCHAR(50);

	DECLARE Var_CFDISelloCFDRet		VARCHAR(1000);
	DECLARE Var_CFDISelloSATRet		VARCHAR(1000);
	DECLARE Var_CFDICadenaOrigRet	VARCHAR(2000);
	DECLARE Var_CFDIFechaCertRet	VARCHAR(45);
	DECLARE Var_CFDINoCertEmiRet	VARCHAR(80);

	DECLARE Var_CFDILugExpediRet	VARCHAR(50);
	DECLARE Var_RutaCBBRet			VARCHAR(2000);

	DECLARE	Var_CFDILugExpedicion	VARCHAR(50);

	DECLARE Var_TipoPersona			CHAR(1);
	DECLARE Var_Mensaje1			VARCHAR(250);
	DECLARE Var_Mensaje2			VARCHAR(500);

	DECLARE Var_Mensaje3			VARCHAR(500);
	DECLARE Var_Mensaje4			VARCHAR(500);
	DECLARE Var_Mensaje5			VARCHAR(250);

    DECLARE Var_ProductoCreditoID	INT(11);
    DECLARE Var_SuperTasa			varchar(100);
    DECLARE Var_RutaLogo			VARCHAR(90);
    DECLARE Var_TasaFija			DECIMAL(12,4);
    DECLARE Var_UDIS				VARCHAR(45);
    DECLARE Var_OrdenDos			INT(11);
	DECLARE Var_CreditoID			BIGINT(12);
	DECLARE Var_TotalComCob			DECIMAL(12,4);
	DECLARE Var_IVACom				DECIMAL(12,4);
    DECLARE Var_AnioIni		INT(4);
	DECLARE Var_MesIni	    INT(2);
	DECLARE Var_AnioFin		INT(4);
	DECLARE Var_MesFin	    INT(2);
	DECLARE Var_Periodo	    INT(8);

	DECLARE Var_BanderaInversiones	INT(11);

	-- Asignacion de constantes
	SET Cadena_Vacia				:= '';					-- Cadena vacia
	SET Entero_Cero					:= 0;					-- Entero 0
	SET Decimal_Cero				:= 0.00;				-- Decimal 0.00
	SET ConstS						:='S';					-- Constante S
    SET Cons_Mensual				:= 'M';
	SET Cons_Semestral				:= 'E';

  
	SET ValorTres					:= 3;					-- Constante 3
	SET Rep_DatosInstitucion		:= 2;					-- Tipo de Reporte: Rep_DatosInstitucion
	SET Rep_Clientes				:= 3;					-- Tipo de Reporde: Clientes
	SET Rep_DatosUEAU				:= 7;					-- Tipo de Reporte: Datos UEAU

	SET Rep_DatosCFDIIngreso		:= 12;					-- Tipo de Reporte: DatosCFDIIngreso
	SET Rep_ResumenCreditos			:= 13;					-- Tipo de Reporte: Resumen Creditos

	SET Var_SuperTasa				:= 'CREDITO SUPERTASAS';-- Valor superTasa
    SET Var_OrdenDos				:= 2;					-- Valor del orden
    SET Rep_ResumenInversion		:= 14;					-- Tipo de Reporte: Resumen de Inversiones

	-- Seccion para el apartado de Cedes en el estado de cuenta
	IF(Par_NumRep = Rep_DatosInstitucion) THEN
			-- Seccion para verificar si tiene creditos y pertenece a captacion
			SELECT CreditoID
			INTO Var_CreditoID
			FROM EDOCTARESUMCREDITOS
			WHERE ClienteID = Par_ClienteID LIMIT 1;

			SET Var_CreditoID	:= IFNULL(Var_CreditoID,Entero_Cero);

			SELECT
				Nombre, DirFiscal AS Direccion, TelefonoEmpresa, RFC, PaginaWeb,
				Var_CreditoID	AS	CreditoID
			FROM INSTITUCIONES AS INS
			INNER JOIN EDOCTAPARAMS AS EDO ON EDO.InstitucionID = INS.InstitucionID;
	END IF;

	-- Seccion para el apartado de clientes
	IF(Par_NumRep = Rep_Clientes) THEN

		SELECT	DAT.NombreComple,		DAT.RFC,		COM.CuentaAhoID,	COM.EsPrincipal,	COM.Clabe,
				COM.FechaProxPago,		COM.ClienteID,	COM.MonedaID
		FROM EDOCTADATOSCTE DAT
		INNER JOIN EDOCTADATOSCTECOM COM
			ON	DAT.ClienteID = COM.ClienteID
		WHERE COM.ClienteID		= Par_ClienteID
		LIMIT 1;
	END IF;

	-- Seccion para Datos UEAU
	IF(Par_NumRep = Rep_DatosUEAU)THEN
		SET Var_ClienteID := Par_ClienteID;

		SELECT Estatus
		INTO Var_Estatus
		FROM EDOCTADATOSCTE
		WHERE ClienteID = Var_ClienteID limit 1;

		SELECT
			TasaFija
			INTO Var_TasaFija
		FROM EDOCTARESUMCREDITOS
		WHERE ClienteID = Var_ClienteID
			AND Orden = Var_OrdenDos
		ORDER BY ClienteID, CreditoID, Orden
		limit 1;

		SELECT FORMAT((25000 * TipCamDof),2) INTO Var_UDIS
		FROM `HIS-MONEDAS`
		WHERE Simbolo = 'UDIS'
		  AND FechaRegistro = Par_FechaFin;

		SELECT	INS.Nombre AS RazonSocial,		PARMS.TelefonoUEAU,		PARMS.DireccionUEAU,		PARMS.CorreoUEAU,
				Var_Estatus AS Estatus,
				ROUND(Var_TasaFija,2) AS TasaFija,
				IFNULL(Var_UDIS, Entero_Cero) AS TotalPesoUDIS,
				LPAD(CONVERT(Var_ClienteID, CHAR), 11, 0) AS ClienteID
		FROM EDOCTAPARAMS PARMS
		INNER JOIN INSTITUCIONES INS ON INS.InstitucionID = PARMS.InstitucionID;
	END IF;

	-- Seccion para DatosCFDIIngreso
	IF(Par_NumRep = Rep_DatosCFDIIngreso)THEN
    

    SELECT  SUBSTR(Par_FechaIni, 6, 2) INTO Var_MesIni;
    SELECT  SUBSTR(Par_FechaFin, 6, 2) INTO Var_MesFin;
    IF(Var_MesIni != Var_MesFin) THEN
    SET Var_AMes = (SELECT CONCAT(YEAR(Par_FechaIni),CASE WHEN MONTH(Par_FechaIni) >= 10 THEN MONTH(Par_FechaIni)
	ELSE CONCAT(0,MONTH(Par_FechaIni))END, CASE WHEN MONTH(Par_FechaFin) >= 10 THEN MONTH(Par_FechaFin)
	ELSE CONCAT(0,MONTH(Par_FechaFin))END) AS AnioMes);
    ELSE
    SET Var_AMes = (SELECT CONCAT(YEAR(Par_FechaIni),CASE WHEN MONTH(Par_FechaIni) >= 10 
    THEN MONTH(Par_FechaIni) ELSE CONCAT(0,MONTH(Par_FechaIni)) END) AS AnioMes);
    END IF;
      
    SELECT EDO.CFDINoCertSAT,		EDO.CFDIUUID,				EDO.CFDIFechaTimbrado,		EDO.CFDISelloCFD,		EDO.CFDISelloSAT,
	EDO.CFDICadenaOrig,		EDO.CFDIFechaCertifica,		EDO.CFDINoCertEmisor,		EDO.CFDILugExpedicion,
	CONCAT(PAR.RutaCBB, EDO.AnioMes,'/', LPAD(CONVERT(EDO.SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(EDO.ClienteID,CHAR), 10, 0),'-',EDO.AnioMes, '.png') AS RutaCBB,
	P.Descripcion
	FROM EDOCTADATOSCTE EDO 
	INNER JOIN PRODUCTOSCREDITO P ON EDO.ProductoCredID=P.ProducCreditoID
	, EDOCTAPARAMS AS PAR 
	WHERE EDO.ClienteID = Par_ClienteID
	AND   EDO.AnioMes = Var_AMes;
    END IF;

	-- Seccion para ResumenCreditos
	IF(Par_NumRep = Rep_ResumenCreditos)THEN

	SELECT DISTINCT CreditoID FROM EDOCTARESUMCREDITOS WHERE ClienteID = Par_ClienteID;

    END IF;

	-- Seccion de Resumen de Inversiones
	IF(Par_NumRep = Rep_ResumenInversion ) THEN
		SELECT COUNT(ClienteID)
		INTO Var_BanderaInversiones
		FROM EDOCTARESUM024INV
		WHERE ClienteID = Par_ClienteID;

		SET Var_BanderaInversiones := IFNULL(Var_BanderaInversiones,Entero_Cero);

		IF(Var_BanderaInversiones > Entero_Cero)THEN
			-- OBTENEMOS EL TOTAL DE COMISIONES
			SELECT IFNULL(SUM(HIS.CantidadMov),Decimal_Cero)
			INTO Var_TotalComCob
			FROM `HIS-CUENAHOMOV` HIS
			INNER JOIN TIPOSMOVSAHO TIP ON HIS.TipoMovAhoID = TIP.TipoMovAhoID
			INNER JOIN CUENTASAHO CUE ON CUE.CuentaAhoID = HIS.CuentaAhoID
			WHERE TIP.Descripcion like '%COMISION%'
			  AND  TIP.Descripcion like '%INVERSION%'
			  AND NatMovimiento = 'C'
			  AND CUE.ClienteID = Par_ClienteID;

			-- OBTENEMOS LOS IVAS
			SELECT IFNULL(SUM(HIS.CantidadMov),Decimal_Cero)
			INTO Var_IVACom
			FROM `HIS-CUENAHOMOV` HIS
			INNER JOIN TIPOSMOVSAHO TIP ON HIS.TipoMovAhoID = TIP.TipoMovAhoID
			INNER JOIN CUENTASAHO CUE ON CUE.CuentaAhoID = HIS.CuentaAhoID
			WHERE TIP.Descripcion like '%COMISION%'
			  AND  TIP.Descripcion like '%INVERSION%'
			  AND TIP.Descripcion like '%IVA%'
			  AND NatMovimiento = 'C'
			  AND CUE.ClienteID = Par_ClienteID;

			SELECT
			Capital AS MontoInversion, Plazo,	FechaInicio AS FechaInversion,		FechaVence AS FechaVencimiento,			Interes AS InteresBruto,
			ISR AS RetencionISR,			InteresNeto,			Cadena_Vacia AS CapitalEstimado,				Tasa AS TasaAnualBruta,		GATNominal,
			GATReal,					Var_TotalComCob AS TotalComCob,		Var_IVACom AS IVACom,					Var_BanderaInversiones AS Bandera
			FROM EDOCTARESUM024INV
			WHERE ClienteID = Par_ClienteID;
		END IF;

		IF(Var_BanderaInversiones = Entero_Cero)THEN
			SELECT Var_BanderaInversiones AS Bandera;
		END IF;

	END IF;

END TerminaStore$$
