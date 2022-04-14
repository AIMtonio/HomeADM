DELIMITER ;
DROP PROCEDURE IF EXISTS `CATCODLEYENDACON`;
DELIMITER $$
CREATE PROCEDURE `CATCODLEYENDACON`(
/*SP para buscar rl tipo de depositos realizado en el catalogo de leyendas Bancomer*/
	Par_CodigoLeyenda		VARCHAR(5),			-- Codigo de la leyenda a buscar
	Par_Identificador		VARCHAR(10),		-- Identificador de la operacion puede ir vacio
	Par_NumConsulta			INT(11),			-- Numero de consulta a realizar
	INOUT Par_TipoDeposito	CHAR(1),			-- Tipo de deposito valor consultado para algunas ocaciones puede retornar vacio
	Aud_EmpresaID			INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria

	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de variables

	-- Declaracion de constantes
	DECLARE Entero_Cero		INT(11);		-- Constante para valor 0
	DECLARE Cadena_Vacia	CHAR(1);		-- Constante para valor cadena vacia
	DECLARE Fecha_Vacia		DATE;			-- Constante para fecha vacia
	DECLARE Con_Principal	INT(11);		-- Constante para consulta principal
	DECLARE Con_Foranea		INT(11);		-- Constante para la consulta en el DAO

	-- Seteo de valores
	SET Entero_Cero			:= 0;
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Aud_FechaActual		:= NOW();
	SET Con_Principal		:= 1;
	SET Con_Foranea			:= 2;


	IF Par_NumConsulta = Con_Principal THEN
		SELECT TipoDeposito INTO Par_TipoDeposito
		FROM CATCODLEYENDA
		WHERE CodigoLeyenda = Par_CodigoLeyenda;
	END IF;

	IF Par_NumConsulta = Con_Foranea THEN
		SELECT CodigoLeyenda,Identificador,Descripcion,TipoDeposito
		FROM CATCODLEYENDA
		WHERE CodigoLeyenda = Par_CodigoLeyenda;
	END IF;

END TerminaStore$$