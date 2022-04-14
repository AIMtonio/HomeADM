-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMGUARDAVALORESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS PARAMGUARDAVALORESLIS;

DELIMITER $$
CREATE PROCEDURE `PARAMGUARDAVALORESLIS`(
	-- Store Procedure: Que Lista la configuracion de los Parametros de Guarda Valores
	-- Modulo Guarda Valores
	Par_ParamGuardaValoresID	INT(11),			-- ID de Tabla PARAMGUARDAVALORES
	Par_NombreEmpresa			VARCHAR(50),		-- Nombre de la Empresa
	Par_NumLista				TINYINT UNSIGNED,	-- Numero de Lista

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);			-- Constante de Entero Cero
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Constante de Decimal Cero
	DECLARE Fecha_Vacia			DATE;				-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia		CHAR(1);			-- Constante de Cadena Vacia
	DECLARE Con_Principal		TINYINT UNSIGNED;	-- Consulta Principal

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0;
	SET Decimal_Cero			:= 0.00;
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Con_Principal			:= 1;

	-- Se realiza la consulta principal
	IF( Par_NumLista = Con_Principal) THEN

		SELECT	ParamGuardaValoresID,	NombreEmpresa
		FROM PARAMGUARDAVALORES
		WHERE NombreEmpresa LIKE CONCAT('%', Par_NombreEmpresa, '%')
		LIMIT 0, 15;

	END IF;

END TerminaStore$$