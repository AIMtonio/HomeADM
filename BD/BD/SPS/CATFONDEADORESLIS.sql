-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATFONDEADORESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATFONDEADORESLIS`;
DELIMITER $$

CREATE PROCEDURE `CATFONDEADORESLIS`(
# ====================================================================================================
# ------- STORE PARA LISTAR LOS TIPOS DE FONDEADORES---------
# ====================================================================================================
	Par_Descripcion			VARCHAR(200),		-- Descripcion de la Cuenta
	Par_NumLis		 		TINYINT UNSIGNED,	-- Numero de Lista

	Par_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Par_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Par_FechaActual			DATETIME,			-- Parametro de auditoria Feha actual
	Par_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Par_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Par_SucursalID			INT(11),			-- Parametro de auditoria ID de la sucursal
	Par_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;			-- Fecha Vacia
	DECLARE	Entero_Cero				INT(11);		-- Entero Cero
	DECLARE	Lis_Principal			INT(11);		-- Lista principal de los Tipos de Fondeadores activos e inactivos
	DECLARE	Lis_ComboTipFondAct		INT(11);		-- Lista Combo de los Tipos de Fondeadores activos

	DECLARE Estatus_Activo			CHAR(1);		-- Estatus Activo

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Lis_Principal		:= 1;
	SET	Lis_ComboTipFondAct	:= 2;

	SET Estatus_Activo		:= 'A';

	-- Lista Principal
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT 	CatFondeadorID,	Descripcion
		FROM 	CATFONDEADORES
		WHERE 	Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		LIMIT 0, 15;
	END IF;

	-- Lista Combo Tipos Fondeadores activos
	IF(Par_NumLis = Lis_ComboTipFondAct) THEN
		SELECT 	TipoFondeador,	Descripcion
		FROM 	CATFONDEADORES
		WHERE   Estatus = Estatus_Activo;
	END IF;

END TerminaStore$$