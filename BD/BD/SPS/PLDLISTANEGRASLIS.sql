-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDLISTANEGRASLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDLISTANEGRASLIS`;DELIMITER $$

CREATE PROCEDURE `PLDLISTANEGRASLIS`(
/*SP PARA LISTAR LAS PERSONAS DE LAS LISTAS NEGRAS*/
	Par_ListaNegraID	INT(11),
	Par_PrimerNom		VARCHAR(50),
	Par_NumLis			TINYINT UNSIGNED,
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),

	/*Auditoria*/
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(11)
	)
TerminaStore:BEGIN

-- DECLARACION DE CONSTANTES
DECLARE Lis_Principal		INT(11);
DECLARE Cadena_Vacia		CHAR(1);

-- ASIGNACION DE CONSTANTES
SET Lis_Principal	:=1;			-- LISTA PRINCIPAL
SET Cadena_Vacia	:='';			-- CADENA VACIA

# LISTA 1: LISTA PRINCIPAL DE LISTAS NEGRAS
IF(Par_NumLis = Lis_Principal) THEN
	SELECT 	ListaNegraID,
			COALESCE(IF(IFNULL(TRIM(NombreCompleto),Cadena_Vacia)=Cadena_Vacia,NULL,TRIM(NombreCompleto)),NombresConocidos) AS nombreCompleto
	FROM PLDLISTANEGRAS
		WHERE  NombreCompleto LIKE CONCAT('%', Par_PrimerNom, '%')
			OR NombresConocidos LIKE CONCAT('%', Par_PrimerNom, '%')
		ORDER BY NombreCompleto
		LIMIT 0, 15;
END IF;

END TerminaStore$$