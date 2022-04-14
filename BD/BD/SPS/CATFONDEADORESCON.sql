-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATFONDEADORESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATFONDEADORESCON`;
DELIMITER $$

CREATE PROCEDURE `CATFONDEADORESCON`(
# ====================================================================================================
# ------- STORE PARA CONSULTAR LOS TIPOS DE FONDEADORES---------
# ====================================================================================================
	Par_TipoFondeador		INT(11),			-- Identificador tabla Catalogo CATFONDEADORES
	Par_NumCon				TINYINT UNSIGNED,

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

	DECLARE		Cadena_Vacia	CHAR(1);		-- Constante cadena vacia
	DECLARE		Fecha_Vacia		DATE;			-- Constante fecha vacia
	DECLARE		Entero_Cero		INT(11);		-- Constante entero cero
	DECLARE		Con_Principal	INT(11);		 -- Consulta principal


	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET	Con_Principal	:= 1;


	IF(Par_NumCon = Con_Principal) THEN
		SELECT	TipoFondeador, Estatus,	Descripcion
		FROM CATFONDEADORES
		WHERE CatFondeadorID = Par_TipoFondeador;
	END IF;

END TerminaStore$$