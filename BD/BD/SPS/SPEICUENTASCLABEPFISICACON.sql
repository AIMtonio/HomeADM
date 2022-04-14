-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEICUENTASCLABEPFISICACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEICUENTASCLABEPFISICACON`;
DELIMITER $$


CREATE PROCEDURE `SPEICUENTASCLABEPFISICACON`(
# =================================================================
# -- SP PARA CONSULTAR LA INFORMACION DE CUENTAS CLABES --
# =================================================================
	Par_CuentaClabePFisicaID	INT(11),				-- Identificador de la tabla
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
	DECLARE Con_Firma			TINYINT;				-- Numero de consulta de firma
	
	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';					-- Cadena VAcia
	SET	Fecha_Vacia				:= '1900-01-01';		-- Fecha Vacia
	SET	Entero_Cero				:= 0;					-- Entero Cero
	SET Con_Firma				:= 2;					-- Consulta de firma

	-- Opcion 1 .- Consulta para ws de registro de cuentas clabes
	IF(Par_NumCon = Con_Firma) THEN
		SELECT 	CuentaClabePFisicaID,		Estatus,				Firma,					ClienteID,					CuentaClabe
		FROM SPEICUENTASCLABEPFISICA
		WHERE CuentaClabe = Par_CuentaClabe;
	END IF;
END TerminaStore$$ 
