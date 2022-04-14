-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTADATOSCTECTMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTADATOSCTECTMOD`;
DELIMITER $$


CREATE PROCEDURE `EDOCTADATOSCTECTMOD`(
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
	DECLARE Var_RutaPDF		VARCHAR(200);
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

    DECLARE Var_ClienteID       INT(11);
    DECLARE Var_Version         VARCHAR(10);
    DECLARE Var_NoCertifSAT     VARCHAR(500);
    DECLARE Var_UUID            VARCHAR(50);
    DECLARE Var_FechaTimbrado   VARCHAR(50);

    DECLARE Var_SelloCFD        VARCHAR(1000);
    DECLARE Var_SelloSAT        VARCHAR(1000);
    DECLARE Var_CadenaOriginal  VARCHAR(1000);
    DECLARE Var_FechaCertifica  VARCHAR(45);
    DECLARE Var_NoCertEmisor    VARCHAR(80);

    DECLARE Var_LugarExpedicion VARCHAR(50);
    DECLARE Var_SubTotal        VARCHAR(15);
    DECLARE Var_Total           VARCHAR(15);
    DECLARE Aux_i				INT(11);				-- AUXILIAR I
    DECLARE Var_TotalCli		INT(11);				-- Total de Clientes

	DECLARE Var_ProveedorTimbrado	CHAR(1);
	DECLARE Timbrado_F			CHAR(1);

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
	SET Timbrado_F		:= 'F';		-- Proveedor de Timbrado de Facturacion Moderna

	-- Realiza la actualizacion del timbrado
	IF (Par_Accion = Principal )THEN

		SELECT 	ProveedorTimbrado
		INTO	Var_ProveedorTimbrado
		FROM PARAMETROSSIS LIMIT 1;

		IF ( Var_ProveedorTimbrado = Timbrado_F ) THEN

			SELECT Ins.RFC, Ins.Nombre
			INTO Var_RFCEmisor, Var_RazonSocial
			FROM PARAMETROSSIS Par, INSTITUCIONES Ins
			WHERE Par.InstitucionID = Ins.InstitucionID;

			SELECT	COUNT(ClienteID) INTO Var_TotalCli
			FROM EDOCTATMPRESPTIMBRE
			WHERE CodigoRespuesta='200'
			ORDER BY RegistroID;

			SET Aux_i := 0;
			WHILE Aux_i < Var_TotalCli DO

				SELECT	ClienteID,          CFDIVersion,        CFDINoCertSAT, 		CFDIUUID, 			CFDIFechaTimbrado,
						CFDISelloCFD,       CFDISelloSAT,       FNSALTOLINEA(CONCAT("||", CFDIVersion, "|", CFDIUUID, "|", CFDIFechaTimbrado,"|", Var_RFCEmisor, "|", CFDISelloCFD, "|", CFDINoCertSAT, "||"), 90) as CadenaOrig,
						CFDIFechaEmision,   CFDINoCertEmisor,   CFDILugExpedicion
				INTO
						Var_ClienteID,       Var_Version,        Var_NoCertifSAT,    Var_UUID,           Var_FechaTimbrado,
						Var_SelloCFD,        Var_SelloSAT,       Var_CadenaOriginal, Var_FechaCertifica, Var_NoCertEmisor,
						Var_LugarExpedicion
				FROM EDOCTATMPRESPTIMBRE
				WHERE CodigoRespuesta='200'
				ORDER BY RegistroID LIMIT Aux_i, 1;

				SET Aud_FechaActual := (SELECT DATE_FORMAT(CURRENT_TIMESTAMP(), '%Y-%m-%d'));

				IF(Par_TipoTimbrado = Tipo_Ingreso)THEN

					UPDATE `EDOCTADATOSCTE`
					SET
						`CFDIVersion`		= Var_Version,
						`CFDINoCertSAT` 	= Var_NoCertifSAT,
						`CFDIFechaTimbrado` = Var_FechaTimbrado,
						`CFDISelloCFD` 		= Var_SelloCFD,
						`CFDISelloSAT` 		= Var_SelloSAT,
						`CFDICadenaOrig` 	= Var_CadenaOriginal,
						`CFDIFechaCertifica`= Var_FechaCertifica,
						`CFDINoCertEmisor` 	= Var_NoCertEmisor,
						`CFDILugExpedicion`	= Var_LugarExpedicion,
						`CFDIFechaEmision`	= Aud_FechaActual
					WHERE ClienteID = Var_ClienteID;
				END IF;

				IF(Par_TipoTimbrado = Tipo_Egreso)THEN
					UPDATE `EDOCTADATOSCTE`
					SET
						`CFDIVersion`		= Var_Version,
						`CFDINoCertSATRet` 	= Var_NoCertifSAT,
						`CFDIUUIDRet` 		= Var_UUID,
						`CFDIFechaTimRet` 	= Var_FechaTimbrado,
						`CFDISelloCFDRet` 	= Var_SelloCFD,
						`CFDISelloSATRet` 	= Var_SelloSAT,
						`CFDICadenaOrigRet` = Var_CadenaOriginal,
						`CFDIFechaCertRet`  = Var_FechaCertifica,
						`CFDINoCertEmiRet` 	= Var_NoCertEmisor,
						`CFDILugExpediRet`	= Var_LugarExpedicion,
						`CFDIFechaEmision`	= Aud_FechaActual
					WHERE ClienteID = Var_ClienteID;
				END IF;


				CALL FOLIOSAPLICAACT('FACTURACFDI', Var_FacturaID);

				SELECT CONVERT(CONCAT(Par.RutaExpPDF,Par.PrefijoEmpresa,'/', Par.MesProceso, '/',
						LPAD(CONVERT(Cte.SucursalID,CHAR), 3, 0) ,'/',
						LPAD(CONVERT(Cte.ClienteID,CHAR), 10, 0),'-', Par.MesProceso, '.pdf'), CHAR) INTO Var_RutaPDF
					FROM EDOCTAPARAMS Par, EDOCTADATOSCTE Cte
					WHERE Cte.ClienteID = Var_ClienteID;

				SET Var_UUID := REPLACE( Var_UUID, "\n", "" );
				SET Var_UUID := REPLACE( Var_UUID, " ", "" );

				INSERT INTO `FACTURACFDI`
				SELECT
					Var_FacturaID,	Cadena_Vacia,	CFDIFechaEmision,	Var_RFCEmisor,		Var_RazonSocial,
					ClienteID, 		RFC, 			NombreComple, 		Var_UUID AS FolioFiscal, 	Cadena_Vacia,
					CFDISubTotal, 	Decimal_Cero, 	CFDITotalXML, 		Fecha_Vacia, 		Entero_Cero,
					Cadena_Vacia, 	Var_RutaPDF, 	AnioMes,			SucursalID,			Estatus_Vigente,
					Aud_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,	Aud_NumTransaccion
				FROM EDOCTADATOSCTE
				WHERE ClienteID = Var_ClienteID;

				SET Aux_i := Aux_i +1;

			END WHILE;


			SELECT
				'000' AS NumErr,
				'Registro Modificado Correctamente'  AS ErrMen,
				Cadena_Vacia AS control,
				Entero_Cero AS Consecutivo;
		ELSE
			-- Se ejecuta cuando no es proveedor Facturacion Moderna
			SELECT
				'000' AS NumErr,
				'No se realiza la modificación, por no ser Proveedor FM' AS ErrMen,
				Cadena_Vacia AS control,
				Entero_Cero AS Consecutivo;
		END IF;
	END IF;

END TerminaStore$$