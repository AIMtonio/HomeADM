-- REGIFALTANTESOBRANTELIS

DELIMITER ;
DROP PROCEDURE IF EXISTS REGIFALTANTESOBRANTELIS;
DELIMITER $$

CREATE PROCEDURE REGIFALTANTESOBRANTELIS (

	Par_UsuarioAutoriza		VARCHAR(45),			-- Usuario que va autorizar el ajuste
	Par_Estatus				CHAR(1),				-- Parametros de estatus
	Par_TamanioLista		INT(11),				-- Parametro tamanio de la lista
	Par_PosicionInicial		INT(11),				-- Parametro posicion inicial de la lista
	Par_NumLis				TINYINT UNSIGNED,		-- Numero de consulta

	Aud_EmpresaID			INT(11),				-- Parametros de auditoria
	Aud_Usuario				INT(11),				-- Parametros de auditoria
	Aud_FechaActual			DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal			INT(11),				-- Parametros de auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametros de auditoria
)TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Entero_Cero					INT(11);			-- Entero vacio
	DECLARE Cadena_Vacia				CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia					DATETIME;			-- Fecha Vacia
	DECLARE Lis_AjusteFaltante			INT(11);			-- Lista de Solicitudes de ajuste efectivo para el WS de Milagro

	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(50);		-- Variable para manejar el control del sql
	DECLARE	Var_Consecutivo				BIGINT(20);			-- Variable Consecutivo

	-- Asignacion de Constantes
	SET Entero_Cero						= 0;				-- Asignacion de Entero Vacio
	SET	Cadena_Vacia					= '';				-- Asignacion de Cadena Vacia
	SET Fecha_Vacia						= '1900-01-01';		-- Asignacion de Fecha Vacia

	SET Lis_AjusteFaltante				:= 1;				-- Lista de Solicitudes de ajuste efectivo para el WS de Milagro

	-- Declaracion de Valores Default
	SET Par_TamanioLista		:= IFNULL(Par_TamanioLista, Entero_Cero);
	SET Par_PosicionInicial		:= IFNULL(Par_PosicionInicial, Entero_Cero);
	SET Par_UsuarioAutoriza		:= IFNULL(Par_UsuarioAutoriza, Cadena_Vacia);
	SET Par_Estatus				:= IFNULL(Par_Estatus, Cadena_Vacia);


	IF(Par_NumLis = Lis_AjusteFaltante) THEN
		IF(Par_TamanioLista = Entero_Cero) THEN
			SELECT COUNT(RegFaltanteSobranteID)
				INTO Par_TamanioLista
				FROM REGISTROFALTANTESOBRANTE;
		END IF;

		SELECT	Monto,					NumCaja,		DescripcionCaja,		SucursalID,		UsuarioAutoriza,
				TipoOperacion,			UsuarioID,		Estatus
			FROM REGISTROFALTANTESOBRANTE
			WHERE UsuarioAutoriza LIKE CONCAT("%",Par_UsuarioAutoriza,"%")
			AND Estatus = IF(Par_Estatus <> Cadena_Vacia, Par_Estatus, Estatus)
			LIMIT Par_PosicionInicial, Par_TamanioLista;
	END IF;

END TerminaStore$$
