-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSCUENTACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSCUENTACON`;
DELIMITER $$

CREATE PROCEDURE `TIPOSCUENTACON`(
	Par_TipoCuentaID	INT,
	Par_NumCon			TINYINT UNSIGNED,
	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
		)
TerminaStore: BEGIN

	DECLARE		Cadena_Vacia	CHAR(1);
	DECLARE		Fecha_Vacia		DATE;
	DECLARE		Entero_Cero		INT;
	DECLARE		Con_Principal	INT;
	DECLARE		Con_Foranea		INT;
	DECLARE		Con_TiposCta	INT;
	DECLARE 	NomInstit 		VARCHAR(100);
	DECLARE 	NomCortoInst 	VARCHAR(45);
	DECLARE 	DirecInst		VARCHAR(250);
	DECLARE		FechEsc			DATE;
	DECLARE 	Con_ComisionSPEI INT;

	SET	Cadena_Vacia	:= '';          -- Constante cadena vacia
	SET	Fecha_Vacia		:= '1900-01-01';-- Constante fecha vacia
	SET	Entero_Cero		:= 0;           -- Constante entero cero
	SET	Con_Principal	:= 1;           -- Consulta principal
	SET	Con_Foranea		:= 2;           -- Consulta FOranea
	SET	Con_TiposCta	:= 3;           -- Consulta tipos cuentas
	SET Con_ComisionSPEI := 4;          -- Consulta comision spei




	IF(Par_NumCon = Con_Principal) THEN
		SELECT	TipoCuentaID,						MonedaID,						Descripcion,
				Abreviacion,						GeneraInteres,					TipoInteres,
				EsServicio,							EsBancaria, 					EsConcentradora,
				CONCAT(FORMAT(MinimoApertura,2))MinimoApertura,	CONCAT(FORMAT(ComApertura,2))ComApertura,	CONCAT(FORMAT(ComManejoCta,2))ComManejoCta,
				CONCAT(FORMAT(ComAniversario,2))ComAniversario,	CobraBanEle,		CobraSpei,
				CONCAT(FORMAT(ComFalsoCobro,2))ComFalsoCobro,	ExPrimDispSeg,      CONCAT(FORMAT(ComDispSeg,2))ComDispSeg,
				CONCAT(FORMAT(SaldoMinReq,2))SaldoMinReq,		TipoPersona, 		EsBloqueoAuto,
				ClasificacionConta, 				RelacionadoCuenta,  			RegistroFirmas,
				HuellasFirmante,                    ConCuenta,						GatInformativo,
	            ParticipaSpei,						ComSpeiPerFis,          		ComSpeiPerMor,
	            NivelID,							DireccionOficial,     			IdenOficial,
	            CheckListExpFisico,                 LimAbonosMensuales,             AbonosMenHasta,
	            PerAboAdi,               			AboAdiHas,                      LimSaldoCuenta,
	            SaldoHasta,                         NumRegistroRECA,                FechaInscripcion,
	            NombreComercial,					ClaveCNBV,						ClaveCNBVAmpCred,
				EnvioSMSRetiro,						MontoMinSMSRetiro,				EstadoCivil,
				NotificacionSms,					Estatus,						PlantillaID,
				SaldoPromMinReq,					ExentaCobroSalPromOtros, 		ComisionSalProm,
				DepositoActiva,						MontoDepositoActiva
		FROM TIPOSCUENTAS
		WHERE TipoCuentaID = Par_TipoCuentaID;
	END IF;


	IF(Par_NumCon = Con_Foranea) THEN
		SELECT	TipoCuentaID,		Descripcion,	MonedaID, 		ClasificacionConta
		FROM TIPOSCUENTAS
		WHERE  TipoCuentaID = Par_TipoCuentaID;
	END IF;

	IF(Par_NumCon = Con_TiposCta) THEN
		SELECT	TipoCuentaID,     Descripcion,     MonedaID	,      GeneraInteres,		TipoInteres,
				EsServicio,		  EsBancaria,      CobraBanEle,		CobraSpei,			ExPrimDispSeg,
				SaldoMinReq,	  ClasificacionConta
		FROM TIPOSCUENTAS
		WHERE  TipoCuentaID = Par_TipoCuentaID;
	END IF;

	IF(Par_NumCon = Con_ComisionSPEI) THEN
		SELECT	TipoCuentaID, ParticipaSpei, CobraSpei, ComSpeiPerFis,   ComSpeiPerMor
		FROM TIPOSCUENTAS
		WHERE  TipoCuentaID = Par_TipoCuentaID;
	END IF;

END TerminaStore$$