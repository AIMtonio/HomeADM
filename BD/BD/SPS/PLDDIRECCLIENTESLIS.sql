-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDDIRECCLIENTESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDDIRECCLIENTESLIS`;
DELIMITER $$

CREATE PROCEDURE `PLDDIRECCLIENTESLIS`(
	Par_ClienteExtID			VARCHAR(20),				-- Numero del Cliente
	Par_NumLis					TINYINT UNSIGNED,		-- Numero de Listado
	
	Aud_EmpresaID				INT(11),				-- Parametro de Auditorias
	Aud_Usuario					INT(11),				-- Parametro de Auditorias
	Aud_FechaActual				DATETIME,				-- Parametro de Auditorias
	Aud_DireccionIP				VARCHAR(15),			-- Parametro de Auditorias
	Aud_ProgramaID				VARCHAR(50),			-- Parametro de Auditorias
	Aud_Sucursal				INT(11),				-- Parametro de Auditorias
	Aud_NumTransaccion			BIGINT(20)				-- Parametro de Auditorias
)TerminaStore: BEGIN

	-- Declaracion de variable
	DECLARE Var_ClienteID		INT(11);			-- Variable para guardar el numero de cliente
	DECLARE	NumErr				INT(11);			-- Variable De Numero Error
	DECLARE	ErrMen				VARCHAR(40);		-- Variable De Mensaje de Error

	-- Declaracion de constante
	DECLARE Cadena_Vacia		CHAR(1);			-- Constante Cadena Vacia
	DECLARE Fecha_Vacia			DATE;				-- Constante Fecha Vacia
	DECLARE Entero_Cero			INT(11);			-- Constante Entero cero
	DECLARE Lis_Principal		INT(11);			-- Lista principal	

	-- Asignacion de constante
	SET	Cadena_Vacia			:= '';				-- Constante Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Constante Fecha Vacia
	SET	Entero_Cero				:= 0;				-- Constante Entero cero
	SET	Lis_Principal			:= 1;				-- Lista principal

	-- 1.- Lista principal
	IF(Par_NumLis = Lis_Principal) THEN
			SELECT 	DIR.DireccionID,			PLD.ClienteIDExt,		DIR.TipoDireccionID,		DIR.EstadoID,		DIR.MunicipioID,
					DIR.LocalidadID,			DIR.ColoniaID,			DIR.Colonia,				DIR.Calle,			DIR.NumeroCasa,
					DIR.CP,						DIR.Oficial,			DIR.Fiscal,					DIR.NumInterior,	DIR.Lote,
					DIR.Manzana,				PLD.ClienteID
			FROM PLDDIRECCIONESCLIENTES PLD
			INNER JOIN DIRECCLIENTE DIR ON PLD.ClienteID = DIR.ClienteID AND PLD.DireccionID = DIR.DireccionID
			WHERE ClienteIDExt = Par_ClienteExtID;
	END IF;
END TerminaStore$$
