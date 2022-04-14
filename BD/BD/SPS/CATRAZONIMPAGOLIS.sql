-- CATRAZONIMPAGOLIS

DELIMITER ;
DROP PROCEDURE IF EXISTS CATRAZONIMPAGOLIS;
DELIMITER $$

CREATE PROCEDURE CATRAZONIMPAGOLIS (

	Par_CatRazonImpagoCreID		INT(11),				-- Cliente ID para consultar
	Par_TamanioLista			INT(11),				-- Parametro tamanio de la lista
	Par_PosicionInicial			INT(11),				-- Parametro posicion inicial de la lista

	Par_NumLis					TINYINT UNSIGNED,		-- Numero de consulta

	Aud_EmpresaID				INT(11),				-- Parametros de auditoria
	Aud_Usuario					INT(11),				-- Parametros de auditoria
	Aud_FechaActual				DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP				VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID				VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal				INT(11),				-- Parametros de auditoria
	Aud_NumTransaccion			BIGINT(20)				-- Parametros de auditoria
)
TerminaStore: BEGIN

    -- Declaracion de Constantes
	DECLARE Entero_Cero				INT(1);							-- Entero cero
	DECLARE Cadena_Vacia        	CHAR(1);
	DECLARE Entero_Uno				INT(11);						-- Entero uno
	DECLARE Entero_Dos				INT(11);						-- Entero dos
	DECLARE Fecha_Vacia				DATE;							-- Fecha Vacia 
	DECLARE LisPrincipal 			INT(11);
	DECLARE EstatusActivo			CHAR(1);


	SET Entero_Cero				:= 0;								-- Entero cero
	SET Cadena_Vacia        	:= '';
	SET Entero_Uno				:= 1;								-- Entero uno
	SET Entero_Dos				:= 2;								-- Entero dos
	SET Fecha_Vacia				:= '1900-01-01';					-- Fecha Vacia
	SET LisPrincipal 			:= 1;
	SET EstatusActivo			:= 'A';

	SET Par_TamanioLista 		:= IFNULL(Par_TamanioLista, Entero_Cero);
	SET Par_PosicionInicial 	:= IFNULL(Par_PosicionInicial, Entero_Cero);

    IF (Par_NumLis = LisPrincipal) THEN

    	IF(Par_TamanioLista = Entero_Cero ) THEN
			SELECT COUNT(CatRazonImpagoCreID)
				INTO Par_TamanioLista
				FROM CATRAZONIMPAGOCRE;
		END IF;

    	SELECT CatRazonImpagoCreID, Descripcion 
			FROM CATRAZONIMPAGOCRE
		    WHERE Estatus = 'A'
		    AND CatRazonImpagoCreID = IF(Par_CatRazonImpagoCreID > Entero_Cero , Par_CatRazonImpagoCreID, CatRazonImpagoCreID)
		    LIMIT Par_PosicionInicial, Par_TamanioLista;

    END IF;

END TerminaStore$$