-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDLISTAPERSBLOQLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDLISTAPERSBLOQLIS`;DELIMITER $$

CREATE PROCEDURE `PLDLISTAPERSBLOQLIS`(
/* LISTA A LAS PERSONAS QUE SE ENCUENTRA EN LA LISTA DE PÉRSONAS BLOQUEADAS */
	Par_PersonaBloqID	INT(11),
	Par_PrimerNom		VARCHAR(50),
	Par_NumLis			TINYINT UNSIGNED,
	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),

	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore:BEGIN

-- Declaracion de constantes
DECLARE Lis_Principal	INT(11);
DECLARE Cadena_Vacia	CHAR(1);

-- Asignacion de Constantes
SET	Lis_Principal		:= 1;	-- Lista principal
SET	Cadena_Vacia		:= '';	-- Cadena vacia

IF(Par_NumLis = Lis_Principal) THEN
	SELECT PersonaBloqID, CONCAT(COALESCE(NombreCompleto,''),'',COALESCE(RazonSocial,'')) AS NombreCompleto
	FROM PLDLISTAPERSBLOQ
		WHERE  NombreCompleto LIKE CONCAT("%", Par_PrimerNom, "%")
			OR NombresConocidos LIKE CONCAT("%", Par_PrimerNom, "%")
			OR RazonSocial LIKE CONCAT("%", Par_PrimerNom, "%")
		ORDER BY NombreCompleto, RazonSocial
		LIMIT 0, 15;
END IF;

END TerminaStore$$