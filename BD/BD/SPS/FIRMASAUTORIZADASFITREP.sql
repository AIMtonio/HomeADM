-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FIRMASAUTORIZADASFITREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `FIRMASAUTORIZADASFITREP`;DELIMITER $$

CREATE PROCEDURE `FIRMASAUTORIZADASFITREP`(
/* Procedimiento para obtener los datos de la caratula de contrato unico para personas fisicas y morales*/
	Par_Cuenta				BIGINT(12),		-- Numero de Cuenta de Ahorro
	Par_Sucursal				INT(11),		-- Numero de sucursal
	Par_TipoReporte     		TINYINT(1),     -- Tipo o Seccion del Reporte

    Aud_EmpresaID       		INT,			-- Parametro de Auditoria
    Aud_Usuario         		INT,			-- Parametro de Auditoria
    Aud_FechaActual     		DATETIME,		-- Parametro de Auditoria
    Aud_DireccionIP     		VARCHAR(15),	-- Parametro de Auditoria
    Aud_ProgramaID      		VARCHAR(50),	-- Parametro de Auditoria
    Aud_Sucursal        		INT(11),		-- Parametro de Auditoria
    Aud_NumTransaccion  		BIGINT			-- Parametro de Auditoria
	)
TerminaStore: BEGIN


# Declaracion de variables
DECLARE Var_NombreCliente		VARCHAR(200);		-- Nombre completo del cliente
DECLARE Var_Sucursal 			VARCHAR(50);		-- Nombre de la sucursal
DECLARE Var_NumeroCliente		INT(11);			-- Numero de Cliente
DECLARE Var_NumeroCuenta		BIGINT(12);			-- Numero de Cuenta de Ahorro
DECLARE Var_NomFirmante			VARCHAR(200);		-- Nombre del Firmante de la cuenta
DECLARE Var_NomFirmaCot			VARCHAR(200);		-- Nombre del Firmante Cotitular de la cuenta
DECLARE Var_NomFirmaAut			VARCHAR(200);		-- Nombre del Firmante Autorizado de la cuenta
DECLARE Var_NomEjecutivo		VARCHAR(200);		-- Nombre del Ejecutivo
DECLARE Var_NumRECA 			VARCHAR(100);		-- Numero RECA por la CONDUSEF
DECLARE Var_Opcion				CHAR(1);			-- Opcion N: Carta Nueva, 	R: Carta que Reemplaza a la anterior
DECLARE Var_CuentaInversion 	CHAR(1);			-- Si / No es una cuenta de Inversion
DECLARE Var_NumRelCancelada		TINYINT(2);			-- Numero de Estatus de Relacion Cancelado de la cuenta de ahorro

DECLARE Var_FechaImpresion		DATE;				-- Fecha de impresion del archivo de Firmas
DECLARE Var_FechaModificacion	DATE;				-- Fecha de Modificacion de las firmas


# Declaracion de Constantes
DECLARE Entero_Cero			TINYINT(1);
DECLARE Tipo_Firmantes		TINYINT(1);
DECLARE Tipo_Cotitulares	TINYINT(1);
DECLARE Tipo_Autorizados	TINYINT(1);
DECLARE Datos_Generales		TINYINT(1);
DECLARE Str_Si				CHAR(1);
DECLARE Str_Vigente			CHAR(1);
DECLARE Str_Cancelada		CHAR(1);


# Asigancion de Constantes
SET Entero_Cero 		:= 		0;
SET Tipo_Firmantes		:=		1;
SET Tipo_Cotitulares 	:= 		2;
SET Tipo_Autorizados	:= 		3;
SET Datos_Generales		:=		4;
SET Str_Si				:=		'S';
SET Str_Vigente			:=		'V';
SET Str_Cancelada		:=		'C';
SET Var_Opcion 			:=		'N';

-- OPCION 1: FIRMANTES
IF(Par_TipoReporte = Tipo_Firmantes) THEN
	SELECT
		CP.NombreCompleto AS NombreFirmante
	FROM CUENTASPERSONA CP
		INNER JOIN CUENTASAHO CA ON CA.CuentaAhoID = CP.CuentaAhoID
		WHERE CP.CuentaAhoID = Par_Cuenta
		AND CP.EstatusRelacion = Str_Vigente
		AND CP.EsFirmante = Str_Si;
END IF;


-- OPCION 2: FIRMANTES COTITULARES
IF(Par_TipoReporte = Tipo_Cotitulares) THEN
	SELECT
		CP.NombreCompleto AS NombreFirmanteCotitular
	FROM CUENTASPERSONA CP
	INNER JOIN CUENTASAHO CA ON CA.CuentaAhoID = CP.CuentaAhoID
		WHERE CP.CuentaAhoID = Par_Cuenta
		AND CP.EsCotitular = Str_Si
		AND CP.EstatusRelacion = Str_Vigente;

END IF;

-- OPCION 3: FIRMANTES AUTORIZADOS
IF(Par_TipoReporte = Tipo_Autorizados) THEN

	SELECT 	CCTA.CtaInversion
	INTO 	Var_CuentaInversion
	FROM CONOCIMIENTOCTA CCTA
		INNER JOIN CUENTASAHO CA ON CA.CuentaAhoID = CCTA.CuentaAhoID
		WHERE CA.CuentaAhoID = Par_Cuenta;

	-- SI ES UNA CUENTA DE INVERSION
	IF(Var_CuentaInversion = Str_Si) THEN
		SELECT
			CP.NombreCompleto AS NombreFirmaAutorizada
		FROM CUENTASAHO CA
		INNER JOIN CUENTASPERSONA CP ON CP.CuentaAhoID = CA.CuentaAhoID
		WHERE CA.CuentaAhoID = Par_Cuenta
		AND CP.EstatusRelacion = Str_Vigente
		AND CP.EsFirmante = Str_Si;


	-- SI NO ES UNA CUENTA DE INVERSION
	ELSE
		SELECT	CF.NombreCompleto  AS NombreFirmaAutorizada
		FROM CUENTASFIRMA CF
			INNER JOIN CUENTASAHO CA ON CA.CuentaAhoID = CF.CuentaAhoID
			WHERE CF.CuentaAhoID = Par_Cuenta;
	END IF;

END IF;


-- OPCION 4: DATOS GENRALES DEL REPORTE
IF(Par_TipoReporte = Datos_Generales) THEN
	SELECT
		CA.CuentaAhoID,			CLI.ClienteID,				CLI.NombreCompleto,			TC.NumRegistroRECA
	INTO
		Var_NumeroCuenta,		Var_NumeroCliente,			Var_NombreCliente,			Var_NumRECA
	FROM CUENTASAHO CA
		INNER JOIN CLIENTES CLI ON CLI.ClienteID = CA.ClienteID
		INNER JOIN TIPOSCUENTAS TC ON TC.TipoCuentaID = CA.TipoCuentaID
		WHERE CA.CuentaAhoID = Par_Cuenta;



	SELECT
		SUC.NombreSucurs, 		US.NombreCompleto
	INTO
		Var_Sucursal,			Var_NomEjecutivo
	FROM SUCURSALES SUC , USUARIOS US
		WHERE SUC.SucursalID = Par_Sucursal
		AND US.UsuarioID = Aud_Usuario ;



	SELECT
			COUNT(CP.EstatusRelacion)
	INTO
			Var_NumRelCancelada
	FROM CUENTASPERSONA CP
		WHERE CP.CuentaAhoID = Par_Cuenta AND CP.EstatusRelacion = Str_Cancelada;


	SELECT
		FI.FechaImpresion, 		FI.FechaModificacion
	INTO
		Var_FechaImpresion,		Var_FechaModificacion
	FROM FIRMASIMPRESIONFIT FI
	WHERE FI.CuentaAhoID = Par_Cuenta;



	IF((SELECT DATEDIFF(Var_FechaModificacion, Var_FechaImpresion)) > 0) THEN
		SET Var_Opcion :=	'R';
	END IF;



	SELECT LPAD(Var_NumeroCliente, 11, 0) AS NumeroCliente,
		LPAD(Var_NumeroCuenta, 11, 0) AS NumeroCuenta,
		Var_NombreCliente AS NombreCliente,				Var_Sucursal AS Sucursal,			Var_NomEjecutivo AS NombreEjecutivo,
		Var_NumRelCancelada AS Opcion,					Var_NumRECA AS RECA,				Var_Opcion AS OpcionImpresion,
		(DATE_FORMAT(Aud_FechaActual, "%d-%m-%Y")) AS FechaRegistro
		;
END IF;


END TerminaStore$$