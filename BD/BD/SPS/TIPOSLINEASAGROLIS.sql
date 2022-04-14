-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before AND after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSLINEASAGROLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSLINEASAGROLIS`;

DELIMITER $$
CREATE PROCEDURE `TIPOSLINEASAGROLIS`(
	-- Store procedure para la Lista de Tipos de lineas de credito Agro
	-- Modulo Cartera y Solicitud de Credito Agro
	Par_Nombre				VARCHAR(100),		-- Nombre del Cliente
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista

	Aud_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);		-- Constantes Cadena Vacia
	DECLARE Fecha_Vacia			DATE;			-- Constantes Fecha Vacia
	DECLARE Entero_Cero			INT(11);		-- Constantes Entero Cero
	DECLARE Est_Activo			CHAR(1);		-- Constantes Estatus Activo

	-- Declaracion de Listas
	DECLARE Lis_Principal		INT(11);		-- Lista Principal
	DECLARE Lis_ComboActivos	INT(11);		-- Lista combo Activos
	DECLARE Lis_ComboTodos		INT(11);		-- Lista combo Todos

	-- Declaracion de Constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET Est_Activo			:='A';

	-- Declaracion de Listas
	SET	Lis_Principal		:= 1;
	SET	Lis_ComboActivos	:= 2;
	SET	Lis_ComboTodos		:= 3;

	IF( Par_NumLis = Lis_Principal ) THEN
		SELECT	LC.TipoLineaAgroID, LC.Nombre
		FROM TIPOSLINEASAGRO LC
		WHERE  LC.Nombre  LIKE CONCAT("%", Par_Nombre, "%")
		LIMIT 0, 15;
	END IF;

	IF( Par_NumLis = Lis_ComboActivos ) THEN
		SELECT  TipoLineaAgroID,	Nombre
		FROM TIPOSLINEASAGRO
		WHERE Estatus = Est_Activo;
	END IF;

	IF( Par_NumLis = Lis_ComboTodos ) THEN
		SELECT  TipoLineaAgroID,	Nombre
		FROM TIPOSLINEASAGRO;
	END IF;


END TerminaStore$$