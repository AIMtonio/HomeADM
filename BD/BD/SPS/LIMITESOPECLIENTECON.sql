-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LIMITESOPECLIENTECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `LIMITESOPECLIENTECON`;DELIMITER $$

CREATE PROCEDURE `LIMITESOPECLIENTECON`(



	Par_LimiteOperID	BIGINT(20),
   	Par_ClienteID		INT(11),
	Par_NumCon			TINYINT UNSIGNED,

	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(20),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN

	DECLARE		Cadena_Vacia	CHAR(1);
	DECLARE		Fecha_Vacia		DATE;
	DECLARE		Entero_Cero		INT;
	DECLARE		Con_Principal   INT;


	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET	Con_Principal	:= 1;


	IF(Par_NumCon = Con_Principal) THEN
		SELECT	LTE.LimiteOperID,	CTE.ClienteID,	CTE.NombreCompleto,	LTE.BancaMovil,	LTE.MonMaxBcaMovil
			FROM LIMITESOPERCLIENTE LTE
				INNER JOIN	CLIENTES CTE ON LTE.ClienteID = CTE.ClienteID
			WHERE	LTE.LimiteOperID	= Par_LimiteOperID;
	END IF;

END TerminaStore$$