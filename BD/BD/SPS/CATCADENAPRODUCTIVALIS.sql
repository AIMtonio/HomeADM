-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCADENAPRODUCTIVALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATCADENAPRODUCTIVALIS`;
DELIMITER $$

CREATE PROCEDURE `CATCADENAPRODUCTIVALIS`(
	/*SP las Cadenas Productivas de la SCIA*/
	Par_NumLis					TINYINT UNSIGNED,		# Numero de Lista
	Par_NomCadenaProdSCIAN		VARCHAR(45),			# Descripcion de la garantia

	/*Parametros de Auditoria*/
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),

	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de constantes
	DECLARE Lis_Principal			INT(11);
	DECLARE Lis_Foranea				INT(11);			-- Numero de listado de toda los registro de la tabla CATCADENAPRODUCTIVA Para el ws de milagro

	-- Asignacion de Constantes
	SET	Lis_Principal					:= 1;			-- Lista Principal
	SET Lis_Foranea						:= 2;			-- Numero de listado de toda los registro de la tabla CATCADENAPRODUCTIVA Para el ws de milagro

	/* Numero de Lista: 1 Lista Principal */
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT CveCadena,		NomCadenaProdSCIAN
			FROM CATCADENAPRODUCTIVA
				WHERE
					NomCadenaProdSCIAN LIKE CONCAT("%", Par_NomCadenaProdSCIAN, "%")
					ORDER BY CveCadena ASC
			LIMIT 15;
	END IF;

	-- 2.- Numero de listado de toda los registro de la tabla CATCADENAPRODUCTIVA Para el ws de milagro
	IF(Par_NumLis = Lis_Foranea) THEN
		SELECT CveCadena,		NomCadenaProdSCIAN
			FROM CATCADENAPRODUCTIVA;
	END IF;

END TerminaStore$$