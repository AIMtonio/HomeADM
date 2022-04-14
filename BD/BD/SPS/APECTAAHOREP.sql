-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APECTAAHOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `APECTAAHOREP`;DELIMITER $$

CREATE PROCEDURE `APECTAAHOREP`(
# ===============================================================================
# --- INFORMACION PARA CONTRATO DE APERTURA DE CUENTA DE AHORRO PARA SANTA FE ---
# ===============================================================================
	Par_CuentaAhoID         BIGINT(12),         -- Numero de cuenta
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
	DECLARE Var_ClienteID			INT(11);
	DECLARE Var_NombreCompleto		VARCHAR(200);
	DECLARE SucursalBBVA			VARCHAR(50);
  	DECLARE SucursalBajio			VARCHAR(50);
  	DECLARE SucursalBana			VARCHAR(50);
  	DECLARE CuentaBBVA				VARCHAR(20);
  	DECLARE CuentaBajio				VARCHAR(20);
  	DECLARE CuentaBana				VARCHAR(20);
  	DECLARE CreRef					VARCHAR(20);
  	DECLARE RefPayCash				VARCHAR(20);
  	DECLARE Var_MunicipioSucID		INT(11);
	DECLARE Var_MunEstSucursal		VARCHAR(200);
	DECLARE Var_RutaImagenPaycash	VARCHAR(200);


	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);
	DECLARE Decimal_Cero			DECIMAL(14,2);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Cons_No					CHAR(1);
	DECLARE Cons_SI					CHAR(1);
	DECLARE TipoFormatoGarantia		TINYINT;
	DECLARE Bancomer				TINYINT;
	DECLARE Bajio					TINYINT;
	DECLARE Banamex					TINYINT;
	DECLARE PayCash					TINYINT;
	DECLARE CanalCuenta				TINYINT;

	-- Asignacion de Constantes
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET Decimal_Cero			:= 0.0;				-- DECIMAL Cero
	SET Cadena_Vacia			:= '';				-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET Cons_No					:= 'N';				-- Constantes No
	SET Cons_SI					:= 'S';				-- Constantes Si
	SET TipoFormatoGarantia		:= 1;				-- Tipo de Contrato: Formato Grupal
	SET Bancomer				:= 37;
    SET Bajio					:= 18;
    SET Banamex					:= 9;
    SET PayCash 				:= 61;
    SET CanalCuenta 			:= 2;

	-- DATOS DE LA INSTITUCION FINANCIERA


	IF (Par_TipoReporte = TipoFormatoGarantia) THEN
		SELECT
			CTA.ClienteID,				CLI.NombreCompleto
		INTO
			Var_ClienteID,				Var_NombreCompleto
		FROM CUENTASAHO CTA
		INNER JOIN CLIENTES CLI ON CLI.ClienteID = CTA.ClienteID
		WHERE CTA.CuentaAhoID  = Par_CuentaAhoID;

		SELECT 	Referencia
		INTO RefPayCash
	  	FROM REFPAGOSXINST
		WHERE TipoCanalID = CanalCuenta
			AND InstitucionID = PayCash
			AND InstrumentoID = Par_CuentaAhoID;


		-- DIRECCION DE LA SUCURSAL A LA QUE PERTENECE EL CLIENTE
		SELECT
			CONCAT(MUNI.Nombre,', ', EST.Nombre),		MUNI.MunicipioID
		INTO
			Var_MunEstSucursal,							Var_MunicipioSucID
		FROM SUCURSALES SUC
			INNER JOIN CLIENTES CLI 			ON SUC.SucursalID = CLI.SucursalOrigen
			INNER JOIN ESTADOSREPUB   EST   	ON SUC.EstadoID = EST.EstadoID
			INNER JOIN MUNICIPIOSREPUB  MUNI   	ON SUC.EstadoID = MUNI.EstadoID    	AND SUC.MunicipioID = MUNI.MunicipioID
			INNER JOIN LOCALIDADREPUB   LOC   	ON SUC.EstadoID = LOC.EstadoID    	AND SUC.MunicipioID = LOC.MunicipioID 	AND SUC.LocalidadID = LOC.LocalidadID
			LEFT OUTER JOIN COLONIASREPUB COL   ON SUC.EstadoID = COL.EstadoID    	AND SUC.MunicipioID = COL.MunicipioID 	AND SUC.ColoniaID = COL.ColoniaID
		WHERE CLI.ClienteID =  Var_ClienteID;


		-- CANALES DE PAGO
		SELECT SucursalInstit, NumCtaInstit
		INTO SucursalBBVA, CuentaBBVA
		FROM CUENTASAHOTESO WHERE InstitucionID = Bancomer AND Principal = Cons_SI;

		SELECT SucursalInstit, NumCtaInstit
		INTO SucursalBajio, CuentaBajio
		FROM CUENTASAHOTESO WHERE InstitucionID = Bajio AND Principal = Cons_SI;

		SELECT SucursalInstit, NumCtaInstit
		INTO SucursalBana, CuentaBana
		FROM CUENTASAHOTESO WHERE InstitucionID = Banamex AND Principal = Cons_SI;

		SELECT ValorParametro
		INTO Var_RutaImagenPaycash
		FROM PARAMGENERALES
		WHERE LlaveParametro = 'RutaImagenPaycash';

		SELECT
			LPAD(IFNULL(Var_ClienteID, Cadena_Vacia), 6, '0') AS Var_ClienteID,
			IFNULL(Var_NombreCompleto, Cadena_Vacia) AS Var_NombreCliente,
			LPAD(IFNULL(Var_MunicipioSucID, Cadena_Vacia), 3, '0') AS Var_MunicipioSucID,
			IFNULL(Var_MunEstSucursal, Cadena_Vacia) AS Var_MunEstSucursal,
			IFNULL(SucursalBBVA, Cadena_Vacia) AS Var_SucursalBBVA,
				IFNULL(CuentaBBVA, Cadena_Vacia) AS Var_CuentaBBVA,
				IFNULL(SucursalBajio, Cadena_Vacia) AS Var_SucursalBajio,
				IFNULL(CuentaBajio, Cadena_Vacia) AS Var_CuentaBajio,
				IFNULL(SucursalBana, Cadena_Vacia) AS Var_SucursalBanamex,
				IFNULL(CuentaBana, Cadena_Vacia) AS Var_CuentaBanamex,
				IFNULL(RefPayCash, Cadena_Vacia) AS Var_RefPayCash,
				Par_CuentaAhoID AS Var_CuentaAhoID,
				Var_RutaImagenPaycash AS Var_RutaLogoPaycash
		;

	END IF;
END TerminaStore$$