-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIRECCLIENTELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIRECCLIENTELIS`;
DELIMITER $$

CREATE PROCEDURE `DIRECCLIENTELIS`(
	Par_ClienteID			INT(11),				-- Numero del Cliente
	Par_DirecComple			VARCHAR(500),			-- Direccion del cliente
	Par_NumLis				TINYINT UNSIGNED,		-- Numero de Listado
	Par_EmpresaID			INT(11),				-- Parametro de Auditorias

	Aud_Usuario				INT(11),				-- Parametro de Auditorias
	Aud_FechaActual			DATETIME,				-- Parametro de Auditorias
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de Auditorias
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de Auditorias
	Aud_Sucursal			INT(11),				-- Parametro de Auditorias
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de Auditorias
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
	DECLARE Lis_DirecWS			INT(11);			-- Lista de Direccion del cliente
	DECLARE Lis_DirecClienWS	INT(11);			-- Lista de las diecciones del Cliente para el Ws de Milagro

	-- Asignacion de constante
	SET	Cadena_Vacia			:= '';				-- Constante Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Constante Fecha Vacia
	SET	Entero_Cero				:= 0;				-- Constante Entero cero
	SET	Lis_Principal			:= 1;				-- Lista principal
	SET Lis_DirecWS				:= 2;				-- Lista de Direccion del cliente
	SET Lis_DirecClienWS		:= 3;				-- Lista de las diecciones del Cliente para el Ws de Milagro

	-- 1.- Lista principal
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT D.DireccionID,	SUBSTR(D.DireccionCompleta,1,30) AS DireccionCompleta,	T.Descripcion
			FROM 	 DIRECCLIENTE D, TIPOSDIRECCION T
			WHERE  D.ClienteID = Par_ClienteID AND T.TipoDireccionID = D.TipoDireccionID
			AND	DireccionCompleta LIKE concat("%", Par_DirecComple, "%")
		LIMIT 0, 15;
	END IF;

	-- 2.- Lista de Direccion del cliente
	IF(Par_NumLis = Lis_DirecWS) THEN
		SELECT D.DireccionID, SUBSTR(D.DireccionCompleta,1,30) as DireccionCompleta
			FROM DIRECCLIENTE D inner join NOMINAEMPLEADOS N
					on (D.ClienteID = N.ClienteID)
			WHERE  D.ClienteID  = Par_ClienteID
		limit 0, 15;
	END IF;

	-- 3.- Lista de las diecciones del Cliente para el Ws de Milagro
	IF(Par_NumLis = Lis_DirecClienWS) THEN
		SELECT	DireccionID,		ClienteID,		TipoDireccionID,		EstadoID,				MunicipioID,
				LocalidadID,		ColoniaID,		Calle,					NumeroCasa,				NumInterior,
				Piso,				CP,				Descripcion,			PrimeraEntreCalle,		SegundaEntreCalle,
				Latitud,			Longitud,		Oficial,				Fiscal,					Lote,
				Manzana,			DireccionCompleta
			FROM DIRECCLIENTE
			WHERE ClienteID = Par_ClienteID;
	END IF;

END TerminaStore$$