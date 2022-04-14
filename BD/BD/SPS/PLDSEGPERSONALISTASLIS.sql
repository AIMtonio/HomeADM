DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDSEGPERSONALISTASLIS`;
DELIMITER $$
CREATE PROCEDURE `PLDSEGPERSONALISTASLIS`(
	Par_Nombre				VARCHAR(300),	-- Nombre a buscar
	Par_NumLista			INT(11),		-- Numero de lista
	Par_EmpresaID 			INT(11),    	-- Parametros de auditoria,
  	Aud_Usuario 			INT(11),    	-- Parametros de auditoria,
  	Aud_FechaActual 		DATETIME,    	-- Parametros de auditoria,
  	Aud_DireccionIP 		VARCHAR(15),    -- Parametros de auditoria,
  	Aud_ProgramaID 			VARCHAR(50),    -- Parametros de auditoria,
  	Aud_Sucursal 			INT(11),    	-- Parametros de auditoria,
  	Aud_NumTransaccion 		BIGINT(20)    	-- Parametros de auditoria,
)
TerminaStore:BEGIN
	
	-- Declaracion de variables

	-- Declaracion de constantes
	DECLARE Lis_Principal		INT(11);
	DECLARE Entero_Cero			INT(11);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;

	-- Seteo de valores
	SET Lis_Principal			:= 1;
	SET Entero_Cero				:= 0;
	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia				:= '1900-01-01';

	-- Lista para la pantalla de Seguimiento de personas en listas
	IF Par_NumLista = Lis_Principal THEN
		SELECT OpeInusualID,Nombre FROM PLDSEGPERSONALISTAS
		WHERE Nombre LIKE CONCAT("%",Par_Nombre,"%") AND IFNULL(Comentario,Cadena_Vacia) = Cadena_Vacia LIMIT 15;
	END IF;

END TerminaStore$$