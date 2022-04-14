-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IDENTIFICLIENTELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `IDENTIFICLIENTELIS`;
DELIMITER $$

CREATE PROCEDURE `IDENTIFICLIENTELIS`(
	Par_ClienteID			INT(11),				-- Numero del Cliente
	Par_Descripcion			VARCHAR(45),			-- Descripcion de la identificacion
	Par_NumLis				TINYINT UNSIGNED,		-- Numero de Listado
	Par_EmpresaID			INT(11),				-- Parametro de Auditorias

	Aud_Usuario				INT(11),				-- Parametro de Auditorias
	Aud_FechaActual			DATETIME,				-- Parametro de Auditorias
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de Auditorias
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de Auditorias
	Aud_Sucursal			INT(11),				-- Parametro de Auditorias
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de Auditorias
)TerminaStore: BEGIN

	-- Declaracion de constante
	DECLARE Cadena_Vacia		CHAR(1);			-- Constante Cadena Vacia
	DECLARE Fecha_Vacia			DATE;				-- Constante Fecha Vacia
	DECLARE Entero_Cero			INT(11);			-- Constante Entero cero
	DECLARE Lis_Principal		INT(11);			-- Lista principal
	DECLARE Lis_IdentClieWS		INT(11);			-- Lista de la identificacion del cliente para el ws de milagro

	-- Asignacion de constante
	SET	Cadena_Vacia			:= '';				-- Constante Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Constante Fecha Vacia
	SET	Entero_Cero				:= 0;				-- Constante Entero cero
	SET	Lis_Principal			:= 1;				-- Lista principal
	SET	Lis_IdentClieWS			:= 2;				-- Lista de la identificacion del cliente para el ws de milagro

	-- 1.- Lista principal
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT I.IdentificID, I.Descripcion AS Descripcion
			FROM IDENTIFICLIENTE I, TIPOSIDENTI T
			WHERE I.ClienteID = Par_ClienteID AND  T.TipoIdentiID=I.TipoIdentiID
				AND I.Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		LIMIT 0, 15;
	END IF;

	-- 2.- Lista de la identificacion del cliente para el ws de milagro
	IF(Par_NumLis = Lis_IdentClieWS) THEN
		SELECT	ClienteID,		IdentificID,		TipoIdentiID,		Descripcion,		FecExIden,
				FecVenIden,		NumIdentific
			FROM IDENTIFICLIENTE
			WHERE ClienteID = Par_ClienteID;
	END IF;

END TerminaStore$$