-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEICUENTASCLABECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEICUENTASCLABECON`;
DELIMITER $$


CREATE PROCEDURE `SPEICUENTASCLABECON`(
# =================================================================
# -- SP PARA CONSULTAR LA INFORMACION DE CUENTAS CLABES 
# -- TANTO DE PESONAS FISICAS COMO DE PERSONAS MORALES
# =================================================================
	Par_ClienteID				INT(11),				-- ID del Cliente
	Par_CuentaClabe				VARCHAR(18),			-- Cuenta clabe ante STP
	Par_NumCon					TINYINT UNSIGNED,		-- Numero de Consulta

	Aud_EmpresaID				INT(11),				-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),				-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,				-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),			-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),			-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),				-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)				-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);				-- Cadena VAcia
	DECLARE	Fecha_Vacia			DATE;					-- Fecha Vacia
	DECLARE	Entero_Cero			INT(11);				-- Entero Cero
	DECLARE Con_Principal		TINYINT;				-- Numero de consulta de firma
	DECLARE Tipo_Fisica			CHAR(1);				-- Tipo de persona fisica
	DECLARE Tipo_Moral			CHAR(1);				-- Tipo de persona moral
	
	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';					-- Cadena VAcia
	SET	Fecha_Vacia				:= '1900-01-01';		-- Fecha Vacia
	SET	Entero_Cero				:= 0;					-- Entero Cero
	SET Con_Principal			:= 1;					-- Consulta de firma
	SET Tipo_Fisica				:= 'F';					-- Tipo de persona fisica
	SET Tipo_Moral				:= 'M';					-- Tipo de persona moral

	-- Opcion 1 .- Consulta para ws de registro de cuentas clabes
	IF(Par_NumCon = Con_Principal) THEN
		SELECT 	CuentaClabePFisicaID AS CuentaClabeID,		Estatus,				Firma,					ClienteID,					CuentaClabe,
				Tipo_Fisica AS TipoPersona
			FROM SPEICUENTASCLABEPFISICA
			WHERE CuentaClabe = Par_CuentaClabe
		UNION
		SELECT 	SpeiCuentaPMoralID AS CuentaClabeID,		Estatus,				Firma,					ClienteID,					CuentaClabe,
				Tipo_Moral AS TipoPersona
			FROM SPEICUENTASCLABPMORAL
			WHERE CuentaClabe = Par_CuentaClabe;
	END IF;
END TerminaStore$$ 
