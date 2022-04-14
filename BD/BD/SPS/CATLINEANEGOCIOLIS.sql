-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATLINEANEGOCIOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATLINEANEGOCIOLIS`;
DELIMITER $$


CREATE PROCEDURE `CATLINEANEGOCIOLIS`(
-- ------------------------------------------------------------------
-- SP PARA LISTAR LINEAS DE NEGOCIO PANTALLA SOLICITUD Y SOLITUD AGRO
-- ------------------------------------------------------------------
	Par_LineaNeg		int(11),
	Par_NumLis			tinyint unsigned,

	Par_EmpresaID		int(11),
	Aud_Usuario			int(11),
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int(11),
	Aud_NumTransaccion	bigint(20)
)

TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		char(1);
	DECLARE	Fecha_Vacia			date;
	DECLARE	Entero_Cero			int;
	DECLARE	Lis_Principal		int;
	DECLARE	Lis_Combo			int;
    DECLARE Lis_EsAgro			INT;
	DECLARE Lis_Todos			INT;				-- Consulta lista de lineas de negocio
    DECLARE Es_Agropecuario		CHAR(1);
    DECLARE No_Es_Agropecuario	CHAR(1);
	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Lis_Principal		:= 1;
	SET	Lis_Combo			:= 2;
    SET Lis_EsAgro			:= 3;
    SET Lis_Todos			:= 4; 				-- Lista que devuelve todos los campos sin distincion
    SET Es_Agropecuario		:= 'S';
	SET No_Es_Agropecuario 	:= 'N';

	-- Lista de lineas de negocio
	IF(Par_NumLis = Lis_Combo) THEN
		SELECT LinNegID,	LinNegDescri
			FROM CATLINEANEGOCIO
		WHERE EsAgropecuario = No_Es_Agropecuario;
	end IF;

    -- Lista para lineas Agro
	IF(Par_NumLis = Lis_EsAgro)THEN
		SELECT LinNegID,	LinNegDescri
			FROM CATLINEANEGOCIO
		WHERE EsAgropecuario = Es_Agropecuario;
    END IF;
    
	-- Lista de lineas de negocio app
	IF(Par_NumLis = Lis_Todos)THEN
		SELECT 	LinNegID,		LinNegDescri,		LinNegEstatus,		EsAgropecuario
			FROM CATLINEANEGOCIO;
    END IF;

END TerminaStore$$
