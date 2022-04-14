-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LIMITESOPECLIENTELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `LIMITESOPECLIENTELIS`;DELIMITER $$

CREATE PROCEDURE `LIMITESOPECLIENTELIS`(



    Par_Nombre        	VARCHAR(50),
    Par_LimiteOperID	INT(11),
    Par_ClienteID		INT(11),
	Par_NumLis			TINYINT UNSIGNED,

    Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(20),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT

)
TerminaStore: BEGIN


	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Lis_Usuario	 		INT;


	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET	Lis_Usuario			    := 1;


	IF(Par_NumLis = Lis_Usuario) THEN
		SELECT	LTE.LimiteOperID,	CTE.ClienteID,	CTE.NombreCompleto
			FROM LIMITESOPERCLIENTE LTE
				INNER JOIN	CLIENTES CTE ON LTE.ClienteID = CTE.ClienteID
			WHERE	CTE.NombreCompleto LIKE	CONCAT("%", Par_Nombre, "%")
			LIMIT 0, 15;
	END IF;


END TerminaStore$$