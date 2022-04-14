-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTRATCREDINDGRUPREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTRATCREDINDGRUPREP`;
DELIMITER $$

CREATE PROCEDURE `CONTRATCREDINDGRUPREP`(
# ========================================================================
# --- INFORMACION PARA CONTRATOS INDIVIDUALES Y GRUPALES PARA SANTA FE ---
# ========================================================================
	Par_CreditoID         	BIGINT(12),         -- Numero de Credito
	Par_GrupoID				INT(11),			-- Numero de Grupo
	Par_TipoReporte     	TINYINT UNSIGNED,   -- Tipo de Reporte

	Par_EmpresaID			INT(11),            -- Parametro de Auditoria
	Aud_Usuario           	INT(11),            -- Parametro de Auditoria
	Aud_FechaActual       	DATETIME,           -- Parametro de Auditoria
	Aud_DireccionIP       	VARCHAR(15),        -- Parametro de Auditoria
	Aud_ProgramaID        	VARCHAR(50),        -- Parametro de Auditoria
	Aud_Sucursal          	INT(11),            -- Parametro de Auditoria
	Aud_NumTransaccion    	BIGINT(20)          -- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_GrupoID				INT(11);
	DECLARE Var_CicloGrupo			INT(11);
	DECLARE Var_NombreGrupo			VARCHAR(200);
	DECLARE Var_RepresentanteLegal	VARCHAR(200);
	DECLARE Var_NombreInstitucion	VARCHAR(100);
	DECLARE Var_DirccionInstitucion	VARCHAR(300);
	DECLARE Var_FechaInicio			DATE;
	DECLARE Var_FechaInicioCred			DATE;
	DECLARE Var_FechaSistema		DATE;
	DECLARE Var_DiaMes				CHAR(2);
	DECLARE Var_Mes					VARCHAR(20);
	DECLARE Var_Anio				INT(11);
	DECLARE Var_MunEstSucursal      VARCHAR(200);
	DECLARE Var_FechaAutoriza		DATE;
	DECLARE Var_FechaVencimien		DATE;
	DECLARE Var_Descripcion			VARCHAR(100);
	DECLARE Var_EsGrupal			CHAR(1);
	DECLARE Var_DestinoCreID		INT(11);
	DECLARE Var_DestinoCredDesc		VARCHAR(300);
	DECLARE Var_ValorCAT			DECIMAL(16,4);
	DECLARE Var_PlazoID				VARCHAR(20);
	DECLARE Var_TasaFija			DECIMAL(14,4);
	DECLARE Var_TasaBase			DECIMAL(14,4);
	DECLARE Var_FactorMora			DECIMAL(12,4);
	DECLARE Var_ProductoCreditoID	INT(11);
	DECLARE Var_MontoCredito		DECIMAL(14,2);
	DECLARE Var_MontoCuota			DECIMAL(14,2);
	DECLARE Var_MontoComApert		DECIMAL(14,2);
	DECLARE Var_AporteCliente		DECIMAL(14,2);
	DECLARE Var_PlazoDescripcion	VARCHAR(50);
	DECLARE Var_NumAmortizacion		INT(11);
	DECLARE Var_PeriodicidadCap		INT(11);
	DECLARE Var_GarantiaID			INT(11);
	DECLARE Var_NombreGarante		VARCHAR(200);
	DECLARE Var_TiposGarantias		VARCHAR(1000);
	DECLARE Var_GarantiasObserv		VARCHAR(1000);
	DECLARE Var_SeguroVidaID		INT(11);
	DECLARE Var_CATI 				DECIMAL(14,2);
	DECLARE Var_CAP 				DECIMAL(14,2);
	DECLARE Var_AT  				DECIMAL(14,2);
    DECLARE Var_SEG  				DECIMAL(14,2);
    DECLARE Var_Comision  			DECIMAL(14,2);
  	DECLARE SucursalBBVA			VARCHAR(50);
  	DECLARE SucursalBajio			VARCHAR(50);
  	DECLARE SucursalBana			VARCHAR(50);
  	DECLARE CuentaBBVA				VARCHAR(20);
  	DECLARE CuentaBajio				VARCHAR(20);
  	DECLARE CuentaBana				VARCHAR(20);
  	DECLARE CreRef					VARCHAR(20);
  	DECLARE RefPayCash				VARCHAR(20);
  	DECLARE Var_Direc				VARCHAR(500);
  	DECLARE Var_MunicipioSucID		INT(11);
  	DECLARE Var_RutaImagenPaycash	VARCHAR(200);
    DECLARE TesoreroID				BIGINT(12);
    DECLARE Var_Interes				DECIMAL(14,4);
    DECLARE Var_CuotaComisiones		DECIMAL(14,4);
    DECLARE Var_NumConvenio			VARCHAR(30);	-- Numero de convenio
  	DECLARE Var_DescConvenio		VARCHAR(100);	-- Descripcion del convenio
    -- VARIABLES PARA RECAM033 SANTA FE (GRUPALES)
    DECLARE Var_NombreMun			VARCHAR(150);	-- Nombre del municipio del presidente de grupo
    DECLARE Var_NombreEst			VARCHAR(150);	-- Nombre del estado del presidente de grupo
    DECLARE Var_FechaDesemb			DATE;			-- Fecha de desembolso
    DECLARE Var_TotalInteg			INT(11);		-- Total de integrantes del grupo
    DECLARE Var_TotalMontoGru		DECIMAL(14,2);	-- Monto total del grupo(suma del monto de cada integrante)
    DECLARE Var_NombrePromo			VARCHAR(200);	-- Nombre del promotor del grupo
    DECLARE Var_NombreSuper			VARCHAR(200);	-- Nombre del supervisor del grupo
    DECLARE Var_SolCreditoMin		INT(11);		-- Solicitud de credito minima.
	DECLARE Var_NomInstitucionFar	VARCHAR(100);	-- Nombre de la farmacia
	DECLARE Var_RutaLogoFarmacia	VARCHAR(100);	-- Ruta del logo de la farmacia
	DECLARE Var_CliEsp				INT(11);		-- Variable para obtener el cliente especifico
	DECLARE Var_CliEspSFG			INT(11);		-- Cliente especifico santa fe


	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);
	DECLARE Decimal_Cero			DECIMAL(14,2);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Cons_No					CHAR(1);
	DECLARE Cons_SI					CHAR(1);
	DECLARE Int_Presiden        	INT(11);
	DECLARE Est_Activo          	CHAR(1);
	DECLARE Entero_Diez         	INT(11);
	DECLARE Tipo_EncContrato   		INT(11);
	DECLARE Tipo_Anexo1				INT(11);
	DECLARE Tipo_Anexo2Acred		INT(11);
	DECLARE Tipo_Anexo2ObSol		INT(11);
	DECLARE Tipo_Anexo2GaranPren	INT(11);
	DECLARE Tipo_Anexo2GaranHipo	INT(11);
	DECLARE EstatusAutU				CHAR(1);
	DECLARE EstatusVig				CHAR(1);
	DECLARE EstatusAut				CHAR(1);
	DECLARE TipoGarantiaPrend		INT(11);
	DECLARE TipoGarantiaHipo		INT(11);
	DECLARE TipoGarantiaGuber		INT(11);
	DECLARE FormaPagoCheque			INT(11);
	DECLARE ChequeDesembolsoCred	INT(11);
	DECLARE Bancomer				INT(11);
	DECLARE Bajio					INT(11);
	DECLARE Banamex					INT(11);
	DECLARE PayCash					INT(11);
	DECLARE CanalCredito			INT(11);
	DECLARE TipoFormatoDeposito		TINYINT;
	DECLARE TipoTesorero			TINYINT;
    DECLARE OrdenDesembolsoCred		INT(11);
    DECLARE OrdenDesemCred			INT(11);
    DECLARE Con_RecaM033			INT(11); 		-- Constante para tipo reporte RECAM033 SANTA FE (GRUPALES)
    DECLARE Con_GruRecaM033			INT(11); 		-- Constante para integrantes de grupo RECAM033 SANTA FE (GRUPALES)
    DECLARE Con_IntegranteCuatro	INT(11); 		-- Constante para identificar al integrante numero cuatro del grupo
    DECLARE Con_TipoSecretario		INT(11); 		-- Constante para identificar al secretario del grupo
    DECLARE Con_DescPresidente		VARCHAR(50);	-- Descripcion para el cargo presidente
    DECLARE Con_DescTesorero		VARCHAR(50);	-- Descripcion para el cargo tesorero
    DECLARE Con_DescSecretario		VARCHAR(50);	-- Descripcion para el cargo secretario
    DECLARE Con_DescSupervisor		VARCHAR(50);	-- Descripcion para el cargo supervisor
	DECLARE Con_FarmaciasIsseg		INT(11);		-- Variable para almacenar la institucion de la farmacia isseg
    DECLARE Var_Dirreccion			VARCHAR (100);

	-- Asignacion de Constantes
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET Decimal_Cero			:= 0.0;				-- DECIMAL Cero
	SET Cadena_Vacia			:= '';				-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET Cons_No					:= 'N';				-- Constantes No
	SET Cons_SI					:= 'S';				-- Constantes Si
	SET Int_Presiden        	:= 1; 				-- Integrante Grupo: Presidente
	SET Est_Activo          	:= 'A'; 			-- Estatus Activo
	SET Entero_Diez				:= 10;				-- Entero Diez
	SET Tipo_EncContrato        := 1;       		-- Tipo de Contrato: Encabezado de Contrato (Datos Generales)
	SET Tipo_Anexo1				:= 2;				-- Tipo de Contrato: Anexo 1 Caratula de Contrato
	SET Tipo_Anexo2Acred		:= 3;				-- Tipo de Contrato: Anexo 2 Datos de los acreditados
	SET Tipo_Anexo2ObSol		:= 4;				-- Tipo de Contrato: Anexo 2 Datos de los obligados solidarios (avales)
	SET Tipo_Anexo2GaranPren	:= 5;				-- Tipo de Contrato: Anexo 2 Datos de los garantes prendarios.
	SET Tipo_Anexo2GaranHipo	:= 6;				-- Tipo de Contrato: Anexo 2 Datos de los garantes hipotecarios.
	SET EstatusAutU				:= 'U';				-- Estatus de la garantía o de los avales: autorizado(a).
	SET EstatusVig				:= 'V';				-- Estatus Vigente.
	SET EstatusAut				:= 'A';				-- Estatus Autorizado.
	SET TipoGarantiaPrend		:= 2;				-- Tipo de garantía Mobiliaria.
	SET TipoGarantiaHipo		:= 3;				-- Tipo de garantía Inmobiliaria.
	SET TipoGarantiaGuber		:= 4;				-- Tipo de garantía Gubernamental.
	SET FormaPagoCheque			:= 2;				-- Tipo de Forma de Pago por Cheque.
	SET ChequeDesembolsoCred	:= 12;				-- Tipo de movimiento CHEQUE POR DESEMBOLSO DE CREDITO (TIPOSMOVTESO).
	SET TipoFormatoDeposito		:= 7;				-- Tipo de Contrato: Formato Grupal
	SET TipoTesorero			:= 2; 				-- Representa el Tipo de cargo = tesorero del grupo
    SET Var_Interes				:= 0.0;
    SET OrdenDesembolsoCred		:= 700;
    SET OrdenDesemCred			:= 5;
    SET	Con_IntegranteCuatro	:= 4;				-- Constante para identificar al integrante numero cuatro del grupo
    SET	Con_TipoSecretario		:= 3;				-- Constante para identificar al secretario del grupo
    SET Con_DescPresidente		:= 'Presidente(a)';	-- Descripcion para el cargo presidente
    SET Con_DescTesorero		:= 'Tesorero(a)';	-- Descripcion para el cargo tesorero
    SET Con_DescSecretario		:= 'Secretario(a)';	-- Descripcion para el cargo secretario
    SET Con_DescSupervisor		:= 'Supervisor(a)';	-- Descripcion para el cargo supervisor
	SET Con_FarmaciasIsseg		:= 63;

	SET Par_CreditoID	:= IFNULL(Par_CreditoID,Entero_Cero);
	SET Par_GrupoID		:= IFNULL(Par_GrupoID,Entero_Cero);

	SET Bancomer	:= 37;
    SET Bajio	:= 18;
    SET Banamex	:= 9;
    SET PayCash := 61;
    SET CanalCredito := 1;

    SET Con_RecaM033		:= 29;
    SET Con_GruRecaM033		:= 30;
    SET Var_Dirreccion		:='';
	SELECT ValorParametro INTO Var_CliEsp FROM PARAMGENERALES WHERE LlaveParametro = 'CliProcEspecifico';
	SET Var_CliEspSFG			:= 29;

	-- DATOS DE LA INSTITUCION FINANCIERA
	SELECT
		UPPER(Par.NombreRepresentante),	CONCAT(Mun.Nombre,', ', Est.Nombre),
		UPPER(Inst.Nombre),				Par.FechaSistema
	INTO
		Var_RepresentanteLegal,			Var_MunEstSucursal,
		Var_NombreInstitucion,			Var_FechaSistema
	FROM PARAMETROSSIS Par
		INNER JOIN INSTITUCIONES Inst ON Par.InstitucionID = Inst.InstitucionID
		INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Par.SucursalMatrizID
		INNER JOIN ESTADOSREPUB Est ON Est.EstadoID = Suc.EstadoID
		INNER JOIN MUNICIPIOSREPUB  Mun ON Mun.MunicipioID = Suc.MunicipioID AND Mun.EstadoID = Suc.EstadoID;




	SELECT
		G.GrupoID,		G.NombreGrupo
	INTO
		Var_GrupoID,	Var_NombreGrupo
		FROM CREDITOS C
			INNER JOIN GRUPOSCREDITO G ON(C.GrupoID=G.GrupoID)
		WHERE CreditoID = Par_CreditoID;

    SELECT	MAX(G.Ciclo)
	INTO Var_CicloGrupo
		FROM CREDITOS C
			INNER JOIN INTEGRAGRUPOSCRE G ON(C.GrupoID=G.GrupoID)
		WHERE CreditoID = Par_CreditoID;

	SET Var_GrupoID		:= IFNULL(Var_GrupoID, Entero_Cero);
	SET Var_CicloGrupo	:= IFNULL(Var_CicloGrupo, Entero_Cero);
    
    SELECT DirFiscal 
    INTO Var_DirccionInstitucion 
	FROM INSTITUCIONES
    WHERE InstitucionID = 60;

    IF (Var_CliEsp=Var_CliEspSFG) THEN
		SELECT DirFiscal
		INTO Var_DirccionInstitucion
		FROM INSTITUCIONES
		WHERE InstitucionID = 60 LIMIT 1;

	END IF;
    -- Se obtiene ID del tesorero
    SELECT	C.CreditoID
	INTO TesoreroID
		FROM CREDITOS C
			INNER JOIN INTEGRAGRUPOSCRE G ON(C.ClienteID=G.ClienteID) AND C.SolicitudCreditoID = G.SolicitudCreditoID
		WHERE C.GrupoID =  Par_GrupoID
        AND G.Ciclo = Var_CicloGrupo
        AND G.Estatus = Est_Activo
        AND G.Cargo = TipoTesorero; -- Tesorero PayCash

	-- Obtenemos el nombre y la ruta del logo de la farmcia isseg
	SELECT	UPPER(Nombre),				RutaLogo
	INTO	Var_NomInstitucionFar,		Var_RutaLogoFarmacia
	FROM INSTITUCIONES
	WHERE InstitucionID = Con_FarmaciasIsseg;

	-- Validacion de datos nulos
	SET Var_NomInstitucionFar	:= IFNULL(Var_NomInstitucionFar, Cadena_Vacia);
	SET Var_RutaLogoFarmacia	:= IFNULL(Var_RutaLogoFarmacia, Cadena_Vacia);

	-- 1.- Tipo de Contrato: Encabezado de Contrato (Datos Generales)
	IF(Par_TipoReporte = Tipo_EncContrato) THEN

        DROP TABLE IF EXISTS TMPACREDSTAFE;
	CREATE TABLE IF NOT EXISTS TMPACREDSTAFE(
		ConsecutivoID		BIGINT(12),
		ClienteID			INT(11),
		SolicitudCreditoID	INT(11),
		ProductoCreditoID	INT(11),
		NombreProducto		VARCHAR(100),
		NombreCompleto		VARCHAR(500) DEFAULT '',
		Domicilio			VARCHAR(500) DEFAULT '',
		Telefono			VARCHAR(500) DEFAULT '',
		RFC					VARCHAR(20) DEFAULT '',
		CorreoElect			VARCHAR(100) DEFAULT '',
		CURP				VARCHAR(20) DEFAULT '',
		DocIdentificacion	VARCHAR(100) DEFAULT '',
		CreditoIDInt		BIGINT(12),
		FechaMinistrado		DATE,
		FechaExigible		DATE,
		NumAmortizacion		INT(11),
		PeriodicidadCap		INT(11),
		MontoCredito		DECIMAL(18,2) DEFAULT 0.00,
        MontoCreditoTot		DECIMAL(18,2) DEFAULT 0.00,
		MontoComApert		DECIMAL(18,2) DEFAULT 0.00,
		MontoCATI			DECIMAL(18,2) DEFAULT 0.00,
		MontoCAP			DECIMAL(18,2) DEFAULT 0.00,
		MontoAT				DECIMAL(18,2) DEFAULT 0.00,
		AporteCliente		DECIMAL(18,2) DEFAULT 0.00,
		FechaVencimien		DATE,
		EsGrupal			CHAR(1),
		DestinoCreID		INT(11),
		NombreDestinoCred	VARCHAR(500) DEFAULT '',
		ClasificacionID		INT(11),
		DescripClasifica	VARCHAR(300) DEFAULT '',
		MontoCuota			DECIMAL(18,2),
		ValorCAT			DECIMAL(18,4),
		PlazoID				VARCHAR(20),
		PlazoDescripcion	VARCHAR(50),
		TasaFija			DECIMAL(18,4),
		FactorMora			DECIMAL(18,4),
		LineaCreditoID		BIGINT(20),
		MontoLinea			DECIMAL(18,2),
		SeguroVidaID		INT(11),
		CobraSeguroCuota	CHAR(1),
		GarantiaID1er		INT(11),
		NombreGarante1er	VARCHAR(200),
		TipoGarantia		VARCHAR(1000),
		ObservacionesGar	VARCHAR(1000),
		NoChequeTransf		BIGINT(20),
		CreditoID			BIGINT(12),
		INDEX(ConsecutivoID),
		INDEX(ClienteID),
		INDEX(SolicitudCreditoID),
		INDEX(ProductoCreditoID),
		INDEX(CreditoIDInt),
		INDEX(GarantiaID1er),
		INDEX(PlazoID),
		INDEX(LineaCreditoID),
		INDEX(DestinoCreID),
		INDEX(CreditoID)
	);

    DROP TABLE IF EXISTS TMPGARPRENDSTAFE;
	CREATE TABLE IF NOT EXISTS TMPGARPRENDSTAFE(
		GarantiaID			INT(11),
		ClienteID			INT(11),
		ProspectoID			INT(11),
		SolicitudCreditoID	INT(11),
		ProductoCreditoID	INT(11),
		NombreCompleto		VARCHAR(500) DEFAULT '',
		Domicilio			VARCHAR(500) DEFAULT '',
		Telefono			VARCHAR(500) DEFAULT '',
		RFC					VARCHAR(20) DEFAULT '',
		CorreoElect			VARCHAR(100) DEFAULT '',
		CURP				VARCHAR(20) DEFAULT '',
		DocIdentificacion	VARCHAR(100) DEFAULT '',
		MontoCredito		DECIMAL(18,2) DEFAULT 0.00,
		CreditoID			BIGINT(12),
		TipoGarantiaID		INT(11),
		TipoDocumentoID		INT(11),
		TipoDocumento		VARCHAR(100) DEFAULT '',
		Folio				VARCHAR(100) DEFAULT '',
		FechaRegistro		DATE DEFAULT '1900-01-01',
		ObservacionesGar	VARCHAR(1300) DEFAULT '',
		INDEX(ClienteID),
		INDEX(GarantiaID),
		INDEX(ProspectoID),
		INDEX(SolicitudCreditoID),
		INDEX(ProductoCreditoID),
		INDEX(CreditoID)
	);
		-- Creditos Individuales
		IF(Par_CreditoID > Entero_Cero AND Var_GrupoID = Entero_Cero) THEN
			-- Datos Genenales del Crédito
			INSERT INTO TMPACREDSTAFE (
				ConsecutivoID,
				ClienteID,				NombreCompleto,			Telefono,				RFC,					CorreoElect,
				CURP,					CreditoID,				CreditoIDInt,			SolicitudCreditoID,		LineaCreditoID,
				FechaMinistrado,		NumAmortizacion,		PeriodicidadCap,		MontoComApert,			AporteCliente,
				FechaVencimien,			EsGrupal,				DestinoCreID,			MontoCuota,				CobraSeguroCuota,
				ValorCAT,				MontoCredito,			MontoCreditoTot,		PlazoID,				TasaFija,
                FactorMora,				ProductoCreditoID,		NombreProducto
				)
			SELECT
				1,
				CTE.ClienteID,			CTE.NombreCompleto,		CTE.Telefono,			CTE.RFCOficial,			CTE.Correo,
				CTE.CURP,				Par_CreditoID,			C.CreditoID,			C.SolicitudCreditoID,	C.LineaCreditoID,
				C.FechaMinistrado,		C.NumAmortizacion,		C.PeriodicidadCap,		C.MontoComApert,		C.AporteCliente,
				C.FechaVencimien,		P.EsGrupal,				C.DestinoCreID,			C.MontoCuota,			C.CobraSeguroCuota,
				C.ValorCAT,				C.MontoCredito,			C.MontoCredito,		C.PlazoID,				C.TasaFija,
                C.FactorMora,			C.ProductoCreditoID,	P.Descripcion
			FROM CREDITOS C
				INNER JOIN CLIENTES CTE ON C.ClienteID = CTE.ClienteID
				INNER JOIN PRODUCTOSCREDITO P ON C.ProductoCreditoID=P.ProducCreditoID
			WHERE C.CreditoID = Par_CreditoID;

            SET CreRef	:=	Par_CreditoID;

		ELSE
			-- Datos Generales De Los Integrantes Del Grupo
			SET @Var_Consecutivo := Entero_Cero;

			INSERT INTO TMPACREDSTAFE(
				ConsecutivoID,
				ClienteID,				NombreCompleto,			Telefono,				RFC,					CorreoElect,
				CURP,					CreditoID,				CreditoIDInt,			SolicitudCreditoID,		LineaCreditoID,
				FechaMinistrado,		NumAmortizacion,		PeriodicidadCap,		MontoComApert,			AporteCliente,
				FechaVencimien,			EsGrupal,				DestinoCreID,			MontoCuota,				CobraSeguroCuota,
				ValorCAT,				MontoCredito,			MontoCreditoTot,		PlazoID,				TasaFija,
                FactorMora,				ProductoCreditoID,		NombreProducto)
			SELECT
				(@Var_Consecutivo := @Var_Consecutivo +1),
				CTE.ClienteID,			CTE.NombreCompleto,		CTE.Telefono,			CTE.RFCOficial,			CTE.Correo,
				CTE.CURP,				Par_CreditoID,			C.CreditoID,			C.SolicitudCreditoID,	C.LineaCreditoID,
				C.FechaMinistrado,		C.NumAmortizacion,		C.PeriodicidadCap,		C.MontoComApert,		C.AporteCliente,
				C.FechaVencimien,		P.EsGrupal,				C.DestinoCreID,			C.MontoCuota,			C.CobraSeguroCuota,
				C.ValorCAT,				C.MontoCredito,			C.MontoCredito,			C.PlazoID,				C.TasaFija,
                C.TasaFija,				C.ProductoCreditoID,	P.Descripcion
			FROM CREDITOS C
				INNER JOIN PRODUCTOSCREDITO P ON C.ProductoCreditoID=P.ProducCreditoID
				INNER JOIN INTEGRAGRUPOSCRE G ON C.SolicitudCreditoID = G.SolicitudCreditoID
				INNER JOIN CLIENTES CTE ON G.ClienteID = CTE.ClienteID
			WHERE G.GrupoID = Var_GrupoID
					AND G.Estatus = EstatusAut
				ORDER BY G.Cargo;

            SET CreRef	:=	(SELECT 	C.CreditoID
			FROM CREDITOS C
				INNER JOIN PRODUCTOSCREDITO P ON C.ProductoCreditoID=P.ProducCreditoID
				INNER JOIN INTEGRAGRUPOSCRE G ON C.SolicitudCreditoID = G.SolicitudCreditoID
				INNER JOIN CLIENTES CTE ON G.ClienteID = CTE.ClienteID
			WHERE G.GrupoID = Var_GrupoID
					AND G.Estatus = EstatusAut
                    AND G.Cargo = 2);
		END IF;

        -- Se obtiene el saldo de CATI.
		UPDATE TMPACREDSTAFE T
			INNER JOIN DETALLEACCESORIOS D ON T.CreditoIDInt = D.CreditoID
		SET T.MontoCATI = D.MontoAccesorio + D.MontoIVAAccesorio,
			T.MontoCuota = T.MontoCuota + (D.MontoCuota + D.MontoIVACuota),
			T.MontoCreditoTot = T.MontoCreditoTot + D.MontoAccesorio
        WHERE D.AccesorioID = 1;

        -- Se obtiene el saldo de CAP.
		UPDATE TMPACREDSTAFE T
			INNER JOIN DETALLEACCESORIOS D ON T.CreditoIDInt = D.CreditoID
		SET T.MontoCAP = D.MontoAccesorio + D.MontoIVAAccesorio,
			T.MontoCuota = T.MontoCuota + (D.MontoCuota + D.MontoIVACuota),
			T.MontoCreditoTot = T.MontoCreditoTot + D.MontoAccesorio
        WHERE D.AccesorioID = 2;

		-- Se obtiene el saldo de AT.
		UPDATE TMPACREDSTAFE T
			INNER JOIN DETALLEACCESORIOS D ON T.CreditoIDInt = D.CreditoID
		SET T.MontoAT = D.MontoAccesorio + D.MontoIVAAccesorio,
			T.MontoCuota = T.MontoCuota + (D.MontoCuota + D.MontoIVACuota),
			T.MontoCreditoTot = T.MontoCreditoTot + D.MontoAccesorio
        WHERE D.AccesorioID = 3;

        -- Se obtiene el saldo de SEG.
		UPDATE TMPACREDSTAFE T
			INNER JOIN DETALLEACCESORIOS D ON T.CreditoIDInt = D.CreditoID
		SET T.MontoCreditoTot = T.MontoCreditoTot + D.MontoAccesorio,
			T.MontoCuota = T.MontoCuota + (D.MontoCuota + D.MontoIVACuota)
        WHERE D.AccesorioID = 4;

            SELECT ProductoCreditoID INTO Var_ProductoCreditoID FROM TMPACREDSTAFE WHERE CreditoID = Par_CreditoID LIMIT 1;

            SELECT  esq.Comision
            INTO	Var_Comision
            FROM ESQUEMACOMISCRE esq LEFT OUTER JOIN TMPACREDSTAFE tmp ON esq.ProducCreditoID = tmp.ProductoCreditoID
            WHERE esq.ProducCreditoID= Var_ProductoCreditoID AND MontoCredito BETWEEN MontoInicial AND MontoFinal LIMIT 1;

        -- Se obtiene Canal de Pago
        SELECT SucursalInstit, NumCtaInstit INTO SucursalBBVA, CuentaBBVA FROM CUENTASAHOTESO WHERE InstitucionID = Bancomer AND Principal = Cons_SI LIMIT 1;
		SELECT SucursalInstit, NumCtaInstit INTO SucursalBajio, CuentaBajio FROM CUENTASAHOTESO WHERE InstitucionID = Bajio AND Principal = Cons_SI  LIMIT 1;
		SELECT SucursalInstit, NumCtaInstit INTO SucursalBana, CuentaBana FROM CUENTASAHOTESO WHERE InstitucionID = Banamex AND Principal = Cons_SI  LIMIT 1;

		SELECT 	Referencia INTO RefPayCash
		  FROM REFPAGOSXINST
			WHERE TipoCanalID = CanalCredito
				AND InstitucionID = PayCash
				AND CASE WHEN Var_GrupoID > 0
						THEN InstrumentoID = TesoreroID
					ELSE
						InstrumentoID = Par_CreditoID END;

        -- CONSULTAS PARA OBTENER EL NUM. CONVENIO Y LA DESCRIPCION DEL CONVENIO DE LA CUENTA PRINCIPAL BANCOMER
        SELECT NumConvenio, DescConvenio
		INTO Var_NumConvenio, Var_DescConvenio
        FROM CUENTASAHOTESO
        WHERE InstitucionID=37
        AND Principal=Cons_SI LIMIT 1;


		SELECT DirecCompleta INTO Var_Direc FROM SUCURSALES WHERE SucursalID = 100 LIMIT 1;


		IF (Var_CliEsp=Var_CliEspSFG) THEN -- CTOMAS TKT 15716
			-- Valores quemados en solicitud del cliente Santa Fe TKT 15449
			SET Var_NumConvenio  := '01596837';
			SET Var_DescConvenio := 'PROYECTOPRODUCTIVO';
			-- Direccion fiscal
			SELECT DirFiscal INTO Var_Direc FROM INSTITUCIONES WHERE InstitucionID = 60 LIMIT 1;

		END IF;

		-- Se obtiene la descripción del destino de crédito.
		UPDATE TMPACREDSTAFE T
			INNER JOIN DESTINOSCREDITO D ON T.DestinoCreID = D.DestinoCreID
			INNER JOIN CLASIFICCREDITO C ON D.SubClasifID = C.ClasificacionID
		SET
			T.ClasificacionID = C.ClasificacionID,
			T.DescripClasifica = C.DescripClasifica
		WHERE T.CreditoID = Par_CreditoID;

        -- Se obtiene el nombre del proyecto del Credito
        UPDATE TMPACREDSTAFE T
			INNER JOIN SOLICITUDCREDITO Sol ON T.SolicitudCreditoID = Sol.SolicitudCreditoID
		SET
			T.NombreDestinoCred = Sol.Proyecto;

		-- Se obtiene el plazo del crédito.
		UPDATE TMPACREDSTAFE T
			INNER JOIN CREDITOSPLAZOS C ON T.PlazoID = C.PlazoID
		SET T.PlazoDescripcion = C.Descripcion
		WHERE T.CreditoID = Par_CreditoID;

		-- Datos de la Primer Garantía
		UPDATE TMPACREDSTAFE T
			INNER JOIN ASIGNAGARANTIAS A ON T.CreditoIDInt = A.CreditoID
		SET T.GarantiaID1er = A.GarantiaID
		WHERE T.CreditoID = Par_CreditoID
			AND A.Estatus = EstatusAutU;

		UPDATE TMPACREDSTAFE T
			INNER JOIN GARANTIAS G ON T.GarantiaID1er = G.GarantiaID
			INNER JOIN TIPOGARANTIAS TG ON G.TipoGarantiaID=TG.TipoGarantiasID
			LEFT JOIN CLIENTES C ON (G.ClienteID=C.ClienteID)
			LEFT JOIN PROSPECTOS P ON G.ProspectoID=P.ProspectoID
		SET T.NombreGarante1er = COALESCE(C.NombreCompleto, P.NombreCompleto, G.GaranteNombre),
			T.TipoGarantia = TG.Descripcion,
			T.ObservacionesGar = G.Observaciones
		WHERE T.CreditoID = Par_CreditoID;

		-- Datos del Seguro de Vida.
		UPDATE TMPACREDSTAFE T
			INNER JOIN SEGUROVIDA S ON T.CreditoIDInt = S.CreditoID
		SET T.SeguroVidaID = S.SeguroVidaID
		WHERE T.CreditoID = Par_CreditoID
			AND S.Estatus = EstatusVig;

		-- Datos de la fecha de corte.
		UPDATE TMPACREDSTAFE T
			INNER JOIN AMORTICREDITO A ON T.CreditoIDInt = A.CreditoID
		SET T.FechaExigible = A.FechaExigible
		WHERE T.CreditoID = Par_CreditoID
			AND A.AmortizacionID = 1;

		-- Datos de la línea de crédito.
		UPDATE TMPACREDSTAFE T
			INNER JOIN LINEASCREDITO L ON T.LineaCreditoID = L.LineaCreditoID
		SET T.MontoLinea = L.Autorizado
		WHERE T.CreditoID = Par_CreditoID;

        -- Se obtiene el monto total a pagar
        UPDATE TMPACREDSTAFE T
		SET T.MontoCreditoTot = T.MontoCuota * T.NumAmortizacion;
        
		UPDATE TMPACREDSTAFE T 
		SET T.DescripClasifica = CASE 
									WHEN T.ProductoCreditoID IN (1000,1001,1002) 
										THEN 'Habilitación o avío, crédito simple'
									WHEN T.ProductoCreditoID IN (2000,2001,2004,2005)
										THEN 'Habilitación o avío, cuenta corriente con garantía'
									WHEN T.ProductoCreditoID IN (2002,2003,2006,2007,3000)
										THEN 'Refaccionario, crédito simple con garantía'
									WHEN T.ProductoCreditoID IN (4000,40001)
										THEN 'Habilitación o avío, cuenta corriente'
								END;

		SELECT
			T.CreditoIDInt AS CreditoID,
			DATE_FORMAT(T.FechaMinistrado, '%d-%m-%Y') AS FechaEntrega,
			T.NombreProducto AS ProductoCredito,
			IF(Var_GrupoID > Entero_Cero, 'GRUPAL', 'INDIVIDUAL') AS TipoCredito,
			UPPER(T.NombreDestinoCred) AS DestinoCreID,
			UPPER(T.DescripClasifica) AS TipoContrato,
			T.ValorCAT,
			T.TasaFija,
			(T.FactorMora * 2) AS FactorMora ,
			FORMAT(IF(T.LineaCreditoID > Entero_Cero,T.MontoLinea,T.MontoCredito),2) AS MontoCredito,
			FORMAT(T.MontoCuota,2) AS MontoCuota,
            FORMAT((T.MontoCreditoTot),2) AS MontoCuotaTot,
			FORMAT(T.MontoComApert,2) AS MontoComApert,
			FORMAT(T.MontoCATI,2) AS MontoCATI,
			FORMAT(T.MontoCAP,2) AS MontoCAP,
			FORMAT(T.MontoAT,2) AS MontoAT,
			FORMAT(T.AporteCliente,2) AS MontoGarLiq,
			IFNULL(FORMAT((Var_Comision * 1.16),2), Decimal_Cero) AS Comision,
			UPPER(T.PlazoDescripcion) AS PlazoID,
			T.NumAmortizacion AS NumAmortizacion,
			DATE_FORMAT(T.FechaVencimien, '%d-%m-%Y') AS FechaVencimien,
			T.PeriodicidadCap AS Periodicidad,
			IFNULL((UPPER(T.TipoGarantia)),'N/A') AS TipoGarantia,
			IFNULL((UPPER(T.ObservacionesGar)),'N/A') AS ObservacionesGar,
			IFNULL((UPPER(T.NombreGarante1er)),'N/A') AS NombreGarante,
			IF(T.SeguroVidaID > Entero_Cero, Cons_SI, T.CobraSeguroCuota) AS SeguroVida,
			UPPER(FNFECHACOMPLETA(T.FechaExigible,7)) AS FechaCorte,
			Var_NombreInstitucion AS NombreInstitucion,
			Var_RepresentanteLegal AS RepresentanteLegal,
			Var_DirccionInstitucion,
			Var_MunEstSucursal,
			DATE_FORMAT(T.FechaMinistrado, '%d') AS Var_DiaMes,
			FNFECHACOMPLETA(T.FechaMinistrado, 8) AS Var_Mes,
			DATE_FORMAT(T.FechaMinistrado, '%Y') AS Var_Anio,
            SucursalBBVA,
            SucursalBajio,
            SucursalBana,
            CuentaBBVA,
            CuentaBajio,
            CuentaBana,
            CreRef,
            RefPayCash,
            Var_Direc,
            FUNCIONNUMLETRAS(REPLACE(FORMAT(IF(T.LineaCreditoID > Entero_Cero,T.MontoLinea,T.MontoCredito),2),',','')) AS MontoLetras,
            T.NombreCompleto,
            Var_NumConvenio,
            REPLACE(CONCAT(Var_DescConvenio,T.CreditoIDInt),' ','') AS Concepto
		FROM TMPACREDSTAFE T
			WHERE T.CreditoID = Par_CreditoID;
	END IF;

	-- 2.- TIPO DE CONTRATO: ANEXO 1 CARATULA DE CONTRATO
	IF(Par_TipoReporte = Tipo_Anexo1) THEN
		SELECT
			T.CreditoIDInt AS CreditoID,
			UPPER(T.DescripClasifica) AS TipoContrato,
			DATE_FORMAT(T.FechaMinistrado, '%d-%m-%Y') AS FechaEntrega,
			UPPER(CONCAT('GARANTÍA: ',T.TipoGarantia)) AS TipoGarantia,
			UPPER(Var_NombreInstitucion) AS NombreInstitucion,
			UPPER(Var_RepresentanteLegal) AS RepresentanteLegal,
			UPPER(Var_DirccionInstitucion) AS DireccInstitucion
		FROM TMPACREDSTAFE T
			WHERE T.CreditoID = Par_CreditoID
			ORDER BY T.ConsecutivoID LIMIT 1;
	END IF;

	-- INFORMACIÓN DE LOS ACREDITADOS
	IF(Par_TipoReporte = Tipo_Anexo2Acred) THEN
		-- Actualización del domicilio.
		UPDATE TMPACREDSTAFE T
			LEFT OUTER JOIN DIRECCLIENTE D ON (T.ClienteID=D.ClienteID AND D.Oficial = Cons_SI)
		SET T.Domicilio = UPPER(D.DireccionCompleta)
			WHERE T.ClienteID != Entero_Cero
				AND T.CreditoID = Par_CreditoID;

		-- Actualización de las Identificaciones.
		UPDATE TMPACREDSTAFE T
			INNER JOIN IDENTIFICLIENTE I ON (T.ClienteID=I.ClienteID)
		SET T.DocIdentificacion = I.Descripcion
			WHERE T.ClienteID != Entero_Cero
				AND T.CreditoID = Par_CreditoID;

			-- Actualización del número de cheque.
		UPDATE TMPACREDSTAFE T
			INNER JOIN DISPERSIONMOV D ON (T.CreditoIDInt=D.CreditoID)
		SET T.NoChequeTransf = D.CuentaDestino
		WHERE D.FormaPago IN (FormaPagoCheque,OrdenDesemCred)
			AND D.TipoMovDIspID IN (ChequeDesembolsoCred,OrdenDesembolsoCred)
			AND D.Estatus = EstatusAut
			AND T.CreditoID = Par_CreditoID;

		-- T_15716 LUCAN INICIO
		UPDATE TMPACREDSTAFE T SET
			T.NoChequeTransf = IF(IFNULL(T.NoChequeTransf,Cadena_Vacia) = Cadena_Vacia, T.CreditoIDInt, T.NoChequeTransf);
		-- T_15716 LUCAN FIN

		SELECT
			T.ConsecutivoID,	T.ClienteID,	T.NombreCompleto,	LEFT(T.Domicilio,100) AS Domicilio,
			FNMASCARA(T.Telefono,'(###) ###-####') AS Telefono,		IF(Var_GrupoID > 0,Var_CicloGrupo, Cadena_Vacia) AS CicloGrupo,
			T.RFC,				T.CorreoElect,	T.CURP,				T.DocIdentificacion,
			T.NoChequeTransf AS ChequeT,
			FORMAT(T.MontoCredito,2) AS MontoCredito,				IF(Var_GrupoID > 0,Var_NombreGrupo, Cadena_Vacia) AS NombreGrupo,
			Var_GrupoID AS GrupoID
		FROM TMPACREDSTAFE T
		WHERE T.CreditoID = Par_CreditoID;
	END IF;

	-- INFORMACIÓN DE LOS OBLIGADOS SOLIDARIOS (AVALES)
	IF(Par_TipoReporte = Tipo_Anexo2ObSol) THEN
		-- SECCION DE AVALES
		DROP TABLE IF EXISTS TMPAVALSTAFE;
		CREATE TABLE IF NOT EXISTS TMPAVALSTAFE(
		ConsecutivoID		BIGINT(12),
		ClienteID			INT(11),
		AvalID				INT(11),
		ProspectoID			INT(11),
		SolicitudCreditoID	INT(11),
		NombreCompleto		VARCHAR(200) DEFAULT '',
		Domicilio			VARCHAR(200) DEFAULT '',
		Telefono			VARCHAR(20) DEFAULT '',
		RFC					VARCHAR(20) DEFAULT '',
		CorreoElect			VARCHAR(100) DEFAULT '',
		CURP				VARCHAR(20) DEFAULT '',
		DocIdentificacion	VARCHAR(100) DEFAULT '',
		MontoCredito		DECIMAL(18,2) DEFAULT 0.00,
		CreditoID			BIGINT(12),
		INDEX(ConsecutivoID),
		INDEX(ClienteID),
		INDEX(AvalID),
		INDEX(ProspectoID),
		INDEX(SolicitudCreditoID),
		INDEX(CreditoID)
	);

		SET @Var_Consecutivo := Entero_Cero;

		-- Datos de los Avales de los Integrantes del Grupo.
		INSERT INTO TMPAVALSTAFE(
			ConsecutivoID,
			ClienteID,			AvalID,				ProspectoID,
			CreditoID)
		SELECT DISTINCT
			Entero_Cero,
			IFNULL(ASOL.ClienteID, Entero_Cero),	IFNULL(ASOL.AvalID, Entero_Cero),	IFNULL(ASOL.ProspectoID, Entero_Cero),
			Par_CreditoID
			FROM TMPACREDSTAFE TMP
				INNER JOIN AVALESPORSOLICI ASOL ON TMP.SolicitudCreditoID=ASOL.SolicitudCreditoID
			WHERE ASOL.Estatus = EstatusAutU
				AND TMP.CreditoID = Par_CreditoID;

		-- Avales que son clientes
		UPDATE TMPAVALSTAFE T
			INNER JOIN CLIENTES C ON T.ClienteID=C.ClienteID
			LEFT OUTER JOIN DIRECCLIENTE D ON (T.ClienteID=D.ClienteID AND D.Oficial = Cons_SI)
		SET T.Domicilio = UPPER(IFNULL(D.DireccionCompleta, Cadena_Vacia)),
			T.NombreCompleto = C.NombreCompleto,
			T.RFC = C.RFCOficial,
			T.CURP = C.CURP,
			T.Telefono = C.Telefono,
			T.CorreoElect = C.Correo
			WHERE T.ClienteID != Entero_Cero
				AND T.CreditoID = Par_CreditoID;

		-- Avales que no son clientes ni prospectos
		UPDATE TMPAVALSTAFE T
			INNER JOIN AVALES A ON (T.AvalID=A.AvalID)
		SET T.Domicilio = UPPER(A.DireccionCompleta),
			T.NombreCompleto = A.NombreCompleto,
			T.RFC = A.RFC,
			T.CURP = Cadena_Vacia,
			T.Telefono = A.Telefono,
			T.CorreoElect = Cadena_Vacia
			WHERE T.AvalID != Entero_Cero
				AND T.CreditoID = Par_CreditoID
				AND T.ClienteID = Entero_Cero
				AND T.ProspectoID = Entero_Cero;

		-- Avales que son sólo prospectos
		UPDATE TMPAVALSTAFE T
			INNER JOIN PROSPECTOS P ON (T.ProspectoID=P.ProspectoID)
		SET T.Domicilio = UPPER(FNGENDIRECCION(1, P.EstadoID, P.MunicipioID, P.LocalidadID, P.ColoniaID,
									P.Calle, P.NumExterior, P.NumInterior, Cadena_Vacia, Cadena_Vacia,
									Cadena_Vacia, P.CP,Cadena_Vacia, P.Lote, P.Manzana)),
			T.NombreCompleto = P.NombreCompleto,
			T.RFC = P.RFC,
			T.CURP = Cadena_Vacia,
			T.Telefono = P.Telefono,
			T.CorreoElect = Cadena_Vacia
			WHERE T.ClienteID = Entero_Cero
				AND T.CreditoID = Par_CreditoID
				AND T.ProspectoID != Entero_Cero
				AND T.AvalID = Entero_Cero;

		UPDATE TMPAVALSTAFE T
			INNER JOIN IDENTIFICLIENTE I ON (T.ClienteID=I.ClienteID)
		SET T.DocIdentificacion = I.Descripcion
			WHERE T.ClienteID != Entero_Cero
				AND T.CreditoID = Par_CreditoID;

        -- SECCION DE OBLIGADOS SOLIDARIOS
        DROP TABLE IF EXISTS TMPOBLISTAFE;
		CREATE TABLE IF NOT EXISTS TMPOBLISTAFE(
		ConsecutivoID		BIGINT(12),
		ClienteID			INT(11),
		ObligadoID				INT(11),
		ProspectoID			INT(11),
		SolicitudCreditoID	INT(11),
		NombreCompleto		VARCHAR(200) DEFAULT '',
		Domicilio			VARCHAR(200) DEFAULT '',
		Telefono			VARCHAR(20) DEFAULT '',
		RFC					VARCHAR(20) DEFAULT '',
		CorreoElect			VARCHAR(100) DEFAULT '',
		CURP				VARCHAR(20) DEFAULT '',
		DocIdentificacion	VARCHAR(100) DEFAULT '',
		MontoCredito		DECIMAL(18,2) DEFAULT 0.00,
		CreditoID			BIGINT(12),
		INDEX(ConsecutivoID),
		INDEX(ClienteID),
		INDEX(ObligadoID),
		INDEX(ProspectoID),
		INDEX(SolicitudCreditoID),
		INDEX(CreditoID)
	);

		SET @Var_Consecutivo := Entero_Cero;

		-- Datos de los Obligados de los Integrantes del Grupo.
		INSERT INTO TMPOBLISTAFE(
			ConsecutivoID,
			ClienteID,			ObligadoID,				ProspectoID,
			CreditoID)
		SELECT DISTINCT
			Entero_Cero,
			IFNULL(OSOL.ClienteID, Entero_Cero),	IFNULL(OSOL.OblSolidID, Entero_Cero),	IFNULL(OSOL.ProspectoID, Entero_Cero),
			Par_CreditoID
			FROM TMPACREDSTAFE TMP
				INNER JOIN OBLSOLIDARIOSPORSOLI OSOL ON TMP.SolicitudCreditoID=OSOL.SolicitudCreditoID
			WHERE OSOL.Estatus = EstatusAutU
				AND TMP.CreditoID = Par_CreditoID;

		-- 	Obligados que son clientes
		UPDATE TMPOBLISTAFE T
			INNER JOIN CLIENTES C ON T.ClienteID=C.ClienteID
			LEFT OUTER JOIN DIRECCLIENTE D ON (T.ClienteID=D.ClienteID AND D.Oficial = Cons_SI)
		SET T.Domicilio = UPPER(IFNULL(D.DireccionCompleta, Cadena_Vacia)),
			T.NombreCompleto = C.NombreCompleto,
			T.RFC = C.RFCOficial,
			T.CURP = C.CURP,
			T.Telefono = C.Telefono,
			T.CorreoElect = C.Correo
			WHERE T.ClienteID != Entero_Cero
				AND T.CreditoID = Par_CreditoID;

		-- Obligados que no son clientes ni prospectos
		UPDATE TMPOBLISTAFE T
			INNER JOIN OBLIGADOSSOLIDARIOS A ON (T.ObligadoID=A.OblSolidID)
		SET T.Domicilio = UPPER(A.DireccionCompleta),
			T.NombreCompleto = A.NombreCompleto,
			T.RFC = A.RFC,
			T.CURP = Cadena_Vacia,
			T.Telefono = A.Telefono,
			T.CorreoElect = Cadena_Vacia
			WHERE T.ObligadoID != Entero_Cero
				AND T.CreditoID = Par_CreditoID
				AND T.ClienteID = Entero_Cero
				AND T.ProspectoID = Entero_Cero;

		-- Obligados que son sólo prospectos
		UPDATE TMPOBLISTAFE T
			INNER JOIN PROSPECTOS P ON (T.ProspectoID=P.ProspectoID)
		SET T.Domicilio = UPPER(FNGENDIRECCION(1, P.EstadoID, P.MunicipioID, P.LocalidadID, P.ColoniaID,
									P.Calle, P.NumExterior, P.NumInterior, Cadena_Vacia, Cadena_Vacia,
									Cadena_Vacia, P.CP,Cadena_Vacia, P.Lote, P.Manzana)),
			T.NombreCompleto = P.NombreCompleto,
			T.RFC = P.RFC,
			T.CURP = Cadena_Vacia,
			T.Telefono = P.Telefono,
			T.CorreoElect = Cadena_Vacia
			WHERE T.ClienteID = Entero_Cero
				AND T.CreditoID = Par_CreditoID
				AND T.ProspectoID != Entero_Cero
				AND T.ObligadoID = Entero_Cero;

		UPDATE TMPOBLISTAFE T
			INNER JOIN IDENTIFICLIENTE I ON (T.ClienteID=I.ClienteID)
		SET T.DocIdentificacion = I.Descripcion
			WHERE T.ClienteID != Entero_Cero
				AND T.CreditoID = Par_CreditoID;

        -- SECCION DE AVALES Y OBLIGADOS
		DROP TABLE IF EXISTS TMPAVALYOBLI;
		CREATE TABLE IF NOT EXISTS TMPAVALYOBLI(
			ConsecutivoID		INT(11),
			SolicitudCreditoID	INT(11),
			NombreCompleto		VARCHAR(200) DEFAULT '',
			Domicilio			VARCHAR(200) DEFAULT '',
			Telefono			VARCHAR(20) DEFAULT '',
			RFC					VARCHAR(20) DEFAULT '',
   			CorreoElect			VARCHAR(100) DEFAULT '',
			CURP				VARCHAR(20) DEFAULT '',
			DocIdentificacion	VARCHAR(100) DEFAULT '',
            CreditoID			BIGINT(12),
			INDEX(SolicitudCreditoID),
			INDEX(CreditoID)
		);

        SET @Var_Consecutivo := Entero_Cero;


		INSERT INTO TMPAVALYOBLI
		SELECT (@Var_Consecutivo + 1), SolicitudCreditoID, NombreCompleto, Domicilio, Telefono, RFC, CorreoElect, CURP, DocIdentificacion, CreditoID
                FROM TMPAVALSTAFE
				WHERE ClienteID NOT IN (SELECT ClienteID FROM TMPACREDSTAFE WHERE ClienteID <> Entero_Cero);

        INSERT INTO TMPAVALYOBLI
		SELECT (@Var_Consecutivo + 1), SolicitudCreditoID, NombreCompleto, Domicilio, Telefono, RFC, CorreoElect, CURP, DocIdentificacion, CreditoID
                FROM TMPOBLISTAFE;


		SELECT
			ConsecutivoID,	T.NombreCompleto,	LEFT(T.Domicilio,70) AS Domicilio,
			FNMASCARA(T.Telefono,'(###) ###-####') AS Telefono,
			T.RFC,				T.CorreoElect,	T.CURP,				T.DocIdentificacion
		FROM TMPAVALYOBLI T
		WHERE T.CreditoID = Par_CreditoID
			ORDER BY T.ConsecutivoID;
	END IF;

	-- INFORMACIÓN DE LOS GARANTES PRENDARIOS
	IF(Par_TipoReporte = Tipo_Anexo2GaranPren) THEN
		DELETE FROM TMPGARPRENDSTAFE WHERE CreditoID=Par_CreditoID;

		SET @Var_Consecutivo := Entero_Cero;

		INSERT INTO TMPGARPRENDSTAFE (
			GarantiaID,			ClienteID,		ProspectoID,			CreditoID,			ObservacionesGar,
			TipoDocumentoID,	Folio,			FechaRegistro,			NombreCompleto,		TipoGarantiaID,
			ProductoCreditoID)
		SELECT
			G.GarantiaID,		IFNULL(G.ClienteID, Entero_Cero),	IFNULL(G.ProspectoID, Entero_Cero),	Par_CreditoID,
			G.Observaciones,	G.TipoDocumentoID,	COALESCE(G.ReferenFactura,G.FolioRegistro,G.NumAvaluo,Cadena_Vacia),
			COALESCE(G.FechaCompFactura,G.FechaRegistro,Fecha_Vacia),	G.GaranteNombre,	G.TipoGarantiaID,
			T.ProductoCreditoID
		FROM GARANTIAS G
			INNER JOIN ASIGNAGARANTIAS A ON G.GarantiaID=A.GarantiaID
			INNER JOIN TMPACREDSTAFE T ON A.SolicitudCreditoID=T.SolicitudCreditoID
			WHERE A.Estatus = EstatusAutU
				AND T.CreditoID = Par_CreditoID;

		-- Garantes que son clientes
		UPDATE TMPGARPRENDSTAFE T
			INNER JOIN CLIENTES C ON T.ClienteID=C.ClienteID
			LEFT OUTER JOIN DIRECCLIENTE D ON (T.ClienteID=D.ClienteID AND D.Oficial = Cons_SI)
		SET T.Domicilio = D.DireccionCompleta,
			T.NombreCompleto = C.NombreCompleto,
			T.RFC = C.RFCOficial,
			T.CURP = C.CURP,
			T.Telefono = C.Telefono,
			T.CorreoElect = C.Correo
			WHERE T.ClienteID != Entero_Cero
				AND T.CreditoID = Par_CreditoID;


		-- Garantes que son prospectos que no son clientes
		UPDATE TMPGARPRENDSTAFE T
			INNER JOIN PROSPECTOS P ON (T.ProspectoID=P.ProspectoID)
		SET T.Domicilio = FNGENDIRECCION(1, P.EstadoID, P.MunicipioID, P.LocalidadID, P.ColoniaID,
									P.Calle, P.NumExterior, P.NumInterior, Cadena_Vacia, Cadena_Vacia,
									Cadena_Vacia, Cadena_Vacia, P.CP, P.Lote, P.Manzana),
			T.NombreCompleto = P.NombreCompleto,
			T.RFC = P.RFC,
			T.CURP = Cadena_Vacia,
			T.Telefono = P.Telefono,
			T.CorreoElect = Cadena_Vacia
			WHERE T.ClienteID = Entero_Cero
				AND T.CreditoID = Par_CreditoID
				AND T.ProspectoID != Entero_Cero;

		-- Actualización de los Tipos de Documentos.
		UPDATE TMPGARPRENDSTAFE T
			INNER JOIN TIPOSDOCUMENTOS D ON T.TipoDocumentoID=D.TipoDocumentoID
		SET T.TipoDocumento = D.Descripcion
			WHERE T.CreditoID = Par_CreditoID;

		SELECT
			(@Var_Consecutivo := @Var_Consecutivo +1) AS ConsecutivoID,
			T.ClienteID,	T.NombreCompleto,	LEFT(T.Domicilio,70) AS Domicilio,
			FNMASCARA(T.Telefono,'(###) ###-####') AS Telefono,
			T.RFC,				T.CorreoElect,	T.CURP,				T.DocIdentificacion,
			CONCAT(T.TipoDocumento,' FOLIO: ',T.Folio) AS TipoDocumento,
			DATE_FORMAT(T.FechaRegistro, '%d-%m-%Y') AS FechaRegistro,
			IFNULL(T.ObservacionesGar, Cadena_Vacia) AS Observaciones
		FROM TMPGARPRENDSTAFE T
		WHERE T.CreditoID = Par_CreditoID
			AND T.TipoGarantiaID = TipoGarantiaPrend;
	END IF;

	-- INFORMACIÓN DE LOS GARANTES HIPOTECARIOS
	IF(Par_TipoReporte = Tipo_Anexo2GaranHipo) THEN
		SELECT
			(@Var_Consecutivo := @Var_Consecutivo +1) AS ConsecutivoID,
			T.ClienteID,	T.NombreCompleto,	LEFT(T.Domicilio,70) AS Domicilio,
			FNMASCARA(T.Telefono,'(###) ###-####') AS Telefono,
			T.RFC,				T.CorreoElect,	T.CURP,				T.DocIdentificacion,
			CONCAT(T.TipoDocumento,' FOLIO: ',T.Folio) AS TipoDocumento,
			T.Folio,
			Cadena_Vacia AS DatosRegistro,
			DATE_FORMAT(T.FechaRegistro, '%d-%m-%Y') AS FechaRegistro,
			IFNULL(T.ObservacionesGar, Cadena_Vacia) AS Observaciones,
			ROUND(P.RelGarantCred,2) AS RelGarantia
		FROM TMPGARPRENDSTAFE T INNER JOIN PRODUCTOSCREDITO P ON T.ProductoCreditoID = P.ProducCreditoID
		WHERE T.CreditoID = Par_CreditoID
			AND T.TipoGarantiaID = TipoGarantiaHipo;
	END IF;


	IF (Par_TipoReporte = TipoFormatoDeposito) THEN
			-- DIRECCION DE LA SUCURSAL DONDE SE OTORGO EL CREDITO
			SELECT
				CONCAT(MUNI.Nombre,', ', EST.Nombre),		MUNI.MunicipioID
			INTO
				Var_MunEstSucursal,							Var_MunicipioSucID
			FROM SUCURSALES SUC
				INNER JOIN CREDITOS CRED 			ON SUC.SucursalID = CRED.SucursalID
				INNER JOIN ESTADOSREPUB   EST   	ON SUC.EstadoID = EST.EstadoID
				INNER JOIN MUNICIPIOSREPUB  MUNI   	ON SUC.EstadoID = MUNI.EstadoID    	AND SUC.MunicipioID = MUNI.MunicipioID
				INNER JOIN LOCALIDADREPUB   LOC   	ON SUC.EstadoID = LOC.EstadoID    	AND SUC.MunicipioID = LOC.MunicipioID 	AND SUC.LocalidadID = LOC.LocalidadID
				LEFT OUTER JOIN COLONIASREPUB COL   ON SUC.EstadoID = COL.EstadoID    	AND SUC.MunicipioID = COL.MunicipioID 	AND SUC.ColoniaID = COL.ColoniaID
			WHERE CRED.CreditoID =  Par_CreditoID;

			SELECT FechaVencim
			INTO Var_FechaVencimien
			FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID
			ORDER BY AmortizacionID DESC LIMIT 1;


			-- CANALES DE PAGO
	        SELECT SucursalInstit, NumCtaInstit INTO SucursalBBVA, CuentaBBVA FROM CUENTASAHOTESO WHERE InstitucionID = Bancomer AND Principal = Cons_SI;
			SELECT SucursalInstit, NumCtaInstit INTO SucursalBajio, CuentaBajio FROM CUENTASAHOTESO WHERE InstitucionID = Bajio AND Principal = Cons_SI;
			SELECT SucursalInstit, NumCtaInstit INTO SucursalBana, CuentaBana FROM CUENTASAHOTESO WHERE InstitucionID = Banamex AND Principal = Cons_SI;

			SELECT ValorParametro
			INTO Var_RutaImagenPaycash
			FROM PARAMGENERALES
			WHERE LlaveParametro = 'RutaImagenPaycash';

			-- FORMATO GRUPAL
			IF (Par_CreditoID > Entero_Cero AND Var_GrupoID <> Entero_Cero) THEN
			SELECT 	C.CreditoID
			INTO CreRef
			FROM CREDITOS C
			INNER JOIN INTEGRAGRUPOSCRE G ON C.SolicitudCreditoID = G.SolicitudCreditoID
			WHERE G.GrupoID = Var_GrupoID
				AND G.Estatus = EstatusAut
                AND G.Cargo = TipoTesorero;

            SELECT 	Referencia
			INTO RefPayCash
		  	FROM REFPAGOSXINST
			WHERE TipoCanalID = CanalCredito
				AND InstitucionID = PayCash
				AND InstrumentoID = CreRef;
			
            -- sacamos fecha de inicio 
			SELECT FechaInicio INTO Var_FechaInicioCred
			FROM CREDITOS
			WHERE CreditoID= Par_CreditoID;

			-- fin

			SELECT
            CLI.NombreCompleto AS Nombre,
				LPAD(IFNULL(G.GrupoID, Cadena_Vacia), 6, '0') AS Var_GrupoID,
				IFNULL(G.NombreGrupo, Cadena_Vacia) AS Var_NombreGrupo,
				IFNULL(C.CicloGrupo, Entero_Cero) AS Var_CicloGrupo,
                CASE WHEN Var_CliEsp = Var_CliEspSFG THEN FNCICLOCLIENTE(Var_GrupoID, Par_CreditoID) ELSE IFNULL(CB.CicloBase, Entero_Cero) END AS Var_CicloBaseIncial,
				IFNULL(C.NumAmortizacion, Cadena_Vacia) AS Var_NumPlazo,
				IFNULL(C.FrecuenciaCap, Cadena_Vacia) AS Var_Frecuencia,
				IFNULL(DATE_FORMAT(C.FechaInicio, "%d/%m/%Y"), Cadena_Vacia) AS Var_FechaInicio,
				LPAD(IFNULL(Var_MunicipioSucID, Cadena_Vacia), 3, '0') AS Var_MunicipioSucID,
				IFNULL(Var_MunEstSucursal, Cadena_Vacia) AS Var_MunEstSucursal,
				IFNULL(DATE_FORMAT(Var_FechaVencimien, "%d/%m/%Y"), Cadena_Vacia) AS Var_FechaVencimiento,
				IFNULL(SucursalBBVA, Cadena_Vacia) AS Var_SucursalBBVA,
				IFNULL(CuentaBBVA, Cadena_Vacia) AS Var_CuentaBBVA,
				IFNULL(SucursalBajio, Cadena_Vacia) AS Var_SucursalBajio,
				IFNULL(CuentaBajio, Cadena_Vacia) AS Var_CuentaBajio,
				IFNULL(SucursalBana, Cadena_Vacia) AS Var_SucursalBanamex,
				IFNULL(CuentaBana, Cadena_Vacia) AS Var_CuentaBanamex,
				IFNULL(CreRef, Cadena_Vacia) AS Var_CreRef,
				IFNULL(RefPayCash, Cadena_Vacia) AS Var_RefPayCash,
				Var_RutaImagenPaycash AS Var_RutaLogoPaycash,
				Var_RutaLogoFarmacia AS RutaLogoFarmacia, Var_NomInstitucionFar AS NombreInstitucionFarmacia
			FROM CREDITOS C
            INNER JOIN GRUPOSCREDITO G ON C.GrupoID=G.GrupoID
			INNER JOIN CLIENTES CLI ON CLI.ClienteID = C.ClienteID
			LEFT JOIN CICLOBASECLIPRO CB ON CB.ClienteID = CLI.ClienteID
			WHERE G.GrupoID = Var_GrupoID AND C.Estatus <> 'P' AND C.FechaInicio= Var_FechaInicioCred;

		-- FORMATO INDIVIDUAL
		ELSE
			SELECT 	Referencia
			INTO RefPayCash
		  	FROM REFPAGOSXINST
			WHERE TipoCanalID = CanalCredito
				AND InstitucionID = PayCash
				AND InstrumentoID = Par_CreditoID;

			SELECT
				LPAD(IFNULL(C.ClienteID, Cadena_Vacia), 6, '0') AS Var_ClienteID,
				IFNULL(C.CreditoID, Cadena_Vacia) AS Var_CreditoID,
				IFNULL(CLI.NombreCompleto, Cadena_Vacia) AS Var_NombreCliente,
				IFNULL(C.NumAmortizacion, Cadena_Vacia) AS Var_NumPlazo,
				IFNULL(C.FrecuenciaCap, Cadena_Vacia) AS Var_Frecuencia,
				IFNULL(DATE_FORMAT(C.FechaInicio, "%d/%m/%Y"), Cadena_Vacia) AS Var_FechaInicio,
                CASE WHEN Var_CliEsp = Var_CliEspSFG THEN FNCICLOCLIENTE(Var_GrupoID, Par_CreditoID) ELSE IFNULL(CB.CicloBase, Entero_Cero) END AS Var_CicloBaseIncial,
				LPAD(IFNULL(Var_MunicipioSucID, Cadena_Vacia), 3, '0') AS Var_MunicipioSucID,
				IFNULL(Var_MunEstSucursal, Cadena_Vacia) AS Var_MunEstSucursal,
				IFNULL(DATE_FORMAT(Var_FechaVencimien, "%d/%m/%Y"), Cadena_Vacia) AS Var_FechaVencimiento,
				IFNULL(SucursalBBVA, Cadena_Vacia) AS Var_SucursalBBVA,
				IFNULL(CuentaBBVA, Cadena_Vacia) AS Var_CuentaBBVA,
				IFNULL(SucursalBajio, Cadena_Vacia) AS Var_SucursalBajio,
				IFNULL(CuentaBajio, Cadena_Vacia) AS Var_CuentaBajio,
				IFNULL(SucursalBana, Cadena_Vacia) AS Var_SucursalBanamex,
				IFNULL(CuentaBana, Cadena_Vacia) AS Var_CuentaBanamex,
				IFNULL(CreRef, Cadena_Vacia) AS Var_CreRef,
				IFNULL(RefPayCash, Cadena_Vacia) AS Var_RefPayCash,
				IFNULL(Var_GrupoID, Entero_Cero) AS Var_GrupoID,
				Var_RutaImagenPaycash AS Var_RutaLogoPaycash,
				Var_RutaLogoFarmacia AS RutaLogoFarmacia, Var_NomInstitucionFar AS NombreInstitucionFarmacia
				FROM
					CREDITOS C
					INNER JOIN CLIENTES CLI ON CLI.ClienteID = C.ClienteID
					LEFT JOIN CICLOBASECLIPRO CB ON CB.ClienteID = CLI.ClienteID
					WHERE C.CreditoID = Par_CreditoID LIMIT 1;
		END IF;
	END IF;

	-- CONSULTA PARA DATOS GENERALES DE FORMATO RECAM033 SANTAFE (CREDITOS GRUPALES)
	IF (Par_TipoReporte = Con_RecaM033)THEN
		-- DATOS GENERALES DEL GRUPO
		SELECT gr.GrupoID,gr.NombreGrupo,igr.Ciclo,mun.Nombre, est.Nombre, cre.FechaMinistrado
			INTO Var_GrupoID,Var_NombreGrupo,Var_CicloGrupo,Var_NombreMun,Var_NombreEst,Var_FechaDesemb
			FROM GRUPOSCREDITO gr
				INNER JOIN INTEGRAGRUPOSCRE igr ON gr.GrupoID=igr.GrupoID AND igr.Cargo=Int_Presiden
				INNER JOIN DIRECCLIENTE dir ON igr.ClienteID=dir.ClienteID AND dir.Oficial='S'
				INNER JOIN MUNICIPIOSREPUB mun ON dir.MunicipioID =  mun.MunicipioID AND dir.EstadoID=mun.EstadoID
				INNER JOIN ESTADOSREPUB est ON dir.EstadoID=est.EstadoID
				INNER JOIN SOLICITUDCREDITO sol ON igr.SolicitudCreditoID=sol.SolicitudCreditoID AND sol.CreditoID <> 0
				INNER JOIN CREDITOS cre ON sol.CreditoID=cre.CreditoID
			WHERE gr.GrupoID=Par_GrupoID;

        SET Var_GrupoID := IFNULL(Var_GrupoID,Entero_Cero);
        SET Var_NombreGrupo := IFNULL(Var_NombreGrupo,Cadena_Vacia);
        SET Var_CicloGrupo := IFNULL(Var_CicloGrupo,Entero_Cero);
        SET Var_NombreMun := IFNULL(Var_NombreMun,Cadena_Vacia);
        SET Var_NombreEst := IFNULL(Var_NombreEst,Cadena_Vacia);
        SET Var_FechaDesemb := IFNULL(Var_FechaDesemb,Fecha_Vacia);

		-- totales
		SELECT COUNT(igr.GrupoID),SUM(sol.MontoAutorizado)
			INTO Var_TotalInteg,Var_TotalMontoGru
			FROM INTEGRAGRUPOSCRE igr
				INNER JOIN SOLICITUDCREDITO sol ON igr.SolicitudCreditoID = sol.SolicitudCreditoID AND sol.CreditoID <> Entero_Cero
				INNER JOIN CREDITOS cre ON sol.CreditoID=cre.CreditoID
			WHERE igr.GrupoID=Par_GrupoID
			GROUP BY igr.GrupoID;

		SET Var_TotalInteg := IFNULL(Var_TotalInteg,Entero_Cero);
        SET Var_TotalMontoGru := IFNULL(Var_TotalMontoGru,Decimal_Cero);

		-- OBTENER LA SOLICITUD DEL CREDITO MINIMA DE LOS INTEGRANTES CON CARGO 4
        SELECT MIN(SolicitudCreditoID)
			INTO Var_SolCreditoMin
			FROM INTEGRAGRUPOSCRE
			WHERE GrupoID=Par_GrupoID
            AND Cargo=Con_IntegranteCuatro
            ORDER BY SolicitudCreditoID ASC
            LIMIT 1;

        SET Var_SolCreditoMin := IFNULL(Var_SolCreditoMin,Entero_Cero);

		-- supervisor
		SELECT pro.NombrePromotor, cli.NombreCompleto
			INTO Var_NombrePromo,Var_NombreSuper
			FROM INTEGRAGRUPOSCRE igr
				INNER JOIN SOLICITUDCREDITO sol ON igr.SolicitudCreditoID = sol.SolicitudCreditoID AND sol.CreditoID <> Entero_Cero
				INNER JOIN CREDITOS cre ON sol.CreditoID=cre.CreditoID
				INNER JOIN PROMOTORES pro ON sol.PromotorID=pro.PromotorID
				INNER JOIN CLIENTES cli ON igr.ClienteID=cli.ClienteID
			WHERE igr.GrupoID=Par_GrupoID
			AND igr.Cargo=Con_IntegranteCuatro
			AND sol.SolicitudCreditoID=Var_SolCreditoMin;

        -- PROMOTOR
		SELECT pro.NombrePromotor
			INTO Var_NombrePromo
			FROM INTEGRAGRUPOSCRE igr
				INNER JOIN SOLICITUDCREDITO sol ON igr.SolicitudCreditoID = sol.SolicitudCreditoID AND sol.CreditoID <> Entero_Cero
				INNER JOIN PROMOTORES pro ON sol.PromotorID=pro.PromotorID
			WHERE igr.GrupoID=Par_GrupoID AND igr.Cargo=Int_Presiden;

		SET Var_NombrePromo := IFNULL(Var_NombrePromo,Cadena_Vacia);
        SET Var_NombreSuper := IFNULL(Var_NombreSuper,Cadena_Vacia);

        SELECT 	Var_GrupoID AS GrupoID,
				Var_NombreGrupo AS NombreGrupo,
				Var_CicloGrupo AS CicloGrupo,
                Var_NombreMun AS Municipio,
                Var_NombreEst AS Estado,
                REPLACE(FORMATEAFECHACONTRATO(Var_FechaDesemb),'DEL','DE') AS FechaDesembolso,
                Var_TotalInteg AS TotalIntegrantes,
                Var_TotalMontoGru AS MontoTotal,
                Var_NombrePromo AS Promotor,
                Var_NombreSuper AS Supervisor
                ;

	END IF;

    -- CONSULTA DE INTEGRANTES DEl GRUPO PARA REPORTE RECAM033 SANTAFE (CREDITOS GRUPALES)
	IF (Par_TipoReporte = Con_GruRecaM033)THEN

        -- OBTENER LA SOLICITUD DEL CREDITO MINIMA DE LOS INTEGRANTES CON CARGO 4
        SELECT MIN(SolicitudCreditoID)
			INTO Var_SolCreditoMin
			FROM INTEGRAGRUPOSCRE
			WHERE GrupoID=Par_GrupoID
            AND Cargo=Con_IntegranteCuatro
            ORDER BY SolicitudCreditoID ASC
            LIMIT 1;

        SET Var_SolCreditoMin := IFNULL(Var_SolCreditoMin,Entero_Cero);

		-- DATOS PARA LA LISTA DE INTEGRANTES
		SELECT igr.ClienteID, cli.NombreCompleto,
				CASE
					WHEN igr.Cargo = Int_Presiden THEN Con_DescPresidente
					WHEN igr.Cargo = TipoTesorero THEN Con_DescTesorero
					WHEN igr.Cargo = Con_TipoSecretario THEN Con_DescSecretario
					WHEN igr.Cargo = Con_IntegranteCuatro AND igr.SolicitudCreditoID= Var_SolCreditoMin
						THEN Con_DescSupervisor
				END AS cargo,
				igr.Cargo, igr.SolicitudCreditoID, sol.MontoAutorizado,sol.Proyecto
			FROM GRUPOSCREDITO gr
				INNER JOIN INTEGRAGRUPOSCRE igr ON gr.GrupoID=igr.GrupoID
				INNER JOIN CLIENTES cli ON igr.ClienteID=cli.ClienteID
				INNER JOIN SOLICITUDCREDITO sol ON igr.SolicitudCreditoID=sol.SolicitudCreditoID AND sol.CreditoID <> Entero_Cero
				INNER JOIN CREDITOS cre ON sol.CreditoID=cre.CreditoID
			WHERE gr.GrupoID=Par_GrupoID ORDER BY igr.Cargo;
	END IF;

END TerminaStore$$
