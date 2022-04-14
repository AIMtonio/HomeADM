-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTADATOSCTEMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTADATOSCTEMOD`;DELIMITER $$

CREATE PROCEDURE `EDOCTADATOSCTEMOD`(
	-- SP creado para actualizar informacion del timbrado del Estado de Cuenta
	Par_ClienteID 		INT(11),			-- Numero de Cliente
	Par_Version			VARCHAR(10),		-- Numero de Version CFDI
	Par_NoCertifSAT		VARCHAR(500),		-- Numero Certificado SAT
	Par_UUID			VARCHAR(150),		-- Valor UUID
	Par_FechaTimbrado	VARCHAR(50),		-- Fecha Timbrado

	Par_SelloCFD		VARCHAR(1000),		-- Sello CFDI
	Par_SelloSAT		VARCHAR(1000),		-- Sello SAT
	Par_CadenaOriginal	VARCHAR(1000),		-- Cadena Original
	Par_FechaCertifica	VARCHAR(45),		-- Fecha Certificacion
	Par_NoCertEmisor	VARCHAR(80),		-- Numero Certificado Emisor

	Par_LugarExpedicion VARCHAR(50),		-- Lugar Expedicion
	Par_SucursalCte		INT(11),			-- Sucursal del Cliente
	Par_Serie			VARCHAR(15),		-- Serie
	Par_SubTotal 		VARCHAR(15),		-- Subtotal
	Par_Descuento		VARCHAR(15),		-- Descuento

    Par_Total			VARCHAR(15),		-- Total
	Par_Accion			INT(11),			-- Cambio de Estatus
	Par_Estatus			INT(11),			-- Valor del Estatus
    Par_TipoTimbrado	CHAR(1),			-- Ingreso = I   Egreso = E

	Aud_EmpresaID		INT(11),			-- Parametro de Auditoria
	Aud_Usuario			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal		INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de Auditoria
		)
TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE Var_RutaPDF		VARCHAR(60);
	DECLARE Var_RFCEmisor	VARCHAR(20);
	DECLARE Var_RazonSocial	VARCHAR(100);
	DECLARE Var_FacturaID	INT(11);

	-- Declaracion de constantes
	DECLARE Entero_Cero		INT;
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Estatus_Vigente	CHAR(1);
	DECLARE Principal		INT(11);
	DECLARE Estatus 		INT(11);

	DECLARE Fecha_Vacia	    DATE;
	DECLARE Decimal_Cero    DECIMAL(12,2);
    DECLARE Tipo_Ingreso    CHAR(1);
    DECLARE Tipo_Egreso	    CHAR(1);

	-- Asignacion de constantes
	SET Entero_Cero		:= 0;		-- Entero cero
	SET Cadena_Vacia	:= '';		-- Cadena vacia
	SET Estatus_Vigente	:= 'V';		-- Estatus Vigente
	SET Principal		:= 1;		-- Realiza la actualizacion del timbrado
	SET Estatus			:= 2;		-- Realiza el cambio del estatus

	SET Fecha_Vacia     := '1900-01-01';	-- Fecha vacia
	SET Decimal_Cero	:= 0.0;				-- Decimal cero
    SET Tipo_Ingreso    := 'I';		-- Tipo Timbrado: Ingreso
    SET Tipo_Egreso     := 'E';     -- Tipo Timbrado: Egreso

	-- Realiza la actualizacion del timbrado
	IF (Par_Accion = Principal )THEN
		SET Aud_FechaActual := (SELECT DATE_FORMAT(CURRENT_TIMESTAMP(), '%Y-%m-%d'));

           IF(Par_TipoTimbrado = Tipo_Ingreso)THEN
				UPDATE `EDOCTADATOSCTE`
				SET
					`CFDIVersion`		= Par_Version,
					`CFDINoCertSAT` 	= Par_NoCertifSAT,
					`CFDIUUID` 			= Par_UUID,
					`CFDIFechaTimbrado` = Par_FechaTimbrado,
					`CFDISelloCFD` 		= Par_SelloCFD,
					`CFDISelloSAT` 		= Par_SelloSAT,
					`CFDICadenaOrig` 	= Par_CadenaOriginal,
					`CFDIFechaCertifica`= Par_FechaCertifica,
					`CFDINoCertEmisor` 	= Par_NoCertEmisor,
					`CFDILugExpedicion`	= Par_LugarExpedicion,
					`CFDIFechaEmision`	= Aud_FechaActual
				WHERE ClienteID = Par_ClienteID;
            END IF;

            IF(Par_TipoTimbrado = Tipo_Egreso)THEN
				UPDATE `EDOCTADATOSCTE`
				SET
					`CFDIVersion`		= Par_Version,
					`CFDINoCertSATRet` 	= Par_NoCertifSAT,
					`CFDIUUIDRet` 		= Par_UUID,
					`CFDIFechaTimRet` 	= Par_FechaTimbrado,
					`CFDISelloCFDRet` 	= Par_SelloCFD,
					`CFDISelloSATRet` 	= Par_SelloSAT,
					`CFDICadenaOrigRet` = Par_CadenaOriginal,
					`CFDIFechaCertRet`  = Par_FechaCertifica,
					`CFDINoCertEmiRet` 	= Par_NoCertEmisor,
					`CFDILugExpediRet`	= Par_LugarExpedicion,
					`CFDIFechaEmision`	= Aud_FechaActual
				WHERE ClienteID = Par_ClienteID;
            END IF;


			CALL FOLIOSAPLICAACT('FACTURACFDI', Var_FacturaID);

			SELECT Ins.RFC, Ins.Nombre INTO Var_RFCEmisor, Var_RazonSocial
			FROM PARAMETROSSIS Par, INSTITUCIONES Ins
			WHERE Par.InstitucionID = Ins.InstitucionID;

			SELECT CONVERT(CONCAT(Par.RutaExpPDF, Par.MesProceso, '/',
					LPAD(CONVERT(Cte.SucursalID,CHAR), 3, 0) ,'/',
					LPAD(CONVERT(Cte.ClienteID,CHAR), 10, 0),'-', Par.MesProceso, '.pdf'), CHAR) INTO Var_RutaPDF
				FROM EDOCTAPARAMS Par, EDOCTADATOSCTE Cte
				WHERE Cte.ClienteID = Par_ClienteID;

			INSERT INTO `FACTURACFDI`
			SELECT
				Var_FacturaID,	Cadena_Vacia,	CFDIFechaEmision,	Var_RFCEmisor,		Var_RazonSocial,
				ClienteID, 		RFC, 			NombreComple, 		REPLACE(CFDIUUID, "\n", "") AS FolioFiscal, 	Par_Serie,
				Par_Subtotal, 	Decimal_Cero, 	Par_Total, 			Fecha_Vacia, 		Entero_Cero,
				Cadena_Vacia, 	Var_RutaPDF, 	AnioMes,			SucursalID,			Estatus_Vigente,
				Aud_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,	Aud_NumTransaccion
			FROM EDOCTADATOSCTE
			WHERE ClienteID = Par_ClienteID;


		SELECT
			'000' AS NumErr,
			'Registro Modificado Correctamente'  AS ErrMen,
			Cadena_Vacia AS control,
			Entero_Cero AS Consecutivo;
	END IF;

	-- Realiza el cambio del estatus
	IF (Par_Accion = Estatus )THEN

		IF(Par_TipoTimbrado = Tipo_Ingreso)THEN
			UPDATE `EDOCTADATOSCTE`
			SET
				`Estatus`	= Par_Estatus
			WHERE ClienteID = Par_ClienteID;
		END IF;

		IF(Par_TipoTimbrado = Tipo_Egreso)THEN
			UPDATE `EDOCTADATOSCTE`
			SET
				`EstatusRet` = Par_Estatus
			WHERE ClienteID = Par_ClienteID;
		END IF;

		SELECT
			'000' AS NumErr,
			'Registro Modificado Correctamente'  AS ErrMen,
			Cadena_Vacia AS control,
			Entero_Cero AS Consecutivo;
	END IF;

END TerminaStore$$