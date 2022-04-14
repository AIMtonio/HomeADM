-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMPANIASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMPANIASCON`;
DELIMITER $$


CREATE PROCEDURE `COMPANIASCON`(
	Par_CompaniaID		INT(11),
	Par_NumCon			INT(11),
	Par_OrigenDatos		VARCHAR(45),
	Par_EmpresaID		INT,

	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
)

TerminaStore: BEGIN

DECLARE Con_Prefijo      INT; -- Obtiene el prefijo de la compania.
DECLARE Con_Principal	 INT; -- Consulta Principal.

SET Con_Prefijo      := 1;
SET Con_Principal	 := 2;


IF(Par_NumCon = Con_Principal) THEN
    SELECT CompaniaID,  	RazonSocial, 	DireccionCompleta,	OrigenDatos,	Prefijo,
		   MostrarPrefijo,	Desplegado,		Subdominio
        FROM COMPANIA
			WHERE CompaniaID = Par_CompaniaID;
END IF;


IF(Par_NumCon = Con_Prefijo) THEN
    SELECT  Prefijo, Desplegado
        FROM COMPANIA
		WHERE OrigenDatos LIKE Par_OrigenDatos;

END IF;


END TerminaStore$$