-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELCADENARAMAFIRALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `RELCADENARAMAFIRALIS`;DELIMITER $$

CREATE PROCEDURE `RELCADENARAMAFIRALIS`(
	/*SP Para Listar las Ramas FIRA relacionadas a las cadenas produvtivas SCIAC*/
	Par_NumLis					TINYINT UNSIGNED,		# Numero de Lista
	Par_CveCadena				INT(11),				# Clave de Cadena Productiva
	Par_NomCadenaProdSCIAN		VARCHAR(45),			# Nombre de la Cadena Productiva
	Par_CveRamaFIRA				INT(11),				# Clave de Rama FIRA
	Par_DescripcionRamaFIRA		VARCHAR(30),			# Descripcio de la Rama FIRA

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

	-- Asignacion de Constantes
	SET	Lis_Principal					:= 1;				-- Lista Principal

	/* Numero de Lista: 1
	Lista Principal */
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT
			REL.CveCadena,		CAD.NomCadenaProdSCIAN,			REL.CveRamaFIRA,		RAM.DescripcionRamaFIRA
		FROM
			RELCADENARAMAFIRA AS REL INNER JOIN
			CATCADENAPRODUCTIVA AS CAD ON REL.CveCadena=CAD.CveCadena INNER JOIN
			CATRAMAFIRA AS RAM ON REL.CveRamaFIRA = RAM.CveRamaFIRA
		WHERE
			REL.CveCadena = Par_CveCadena AND
			RAM.DescripcionRamaFIRA LIKE CONCAT("%", Par_DescripcionRamaFIRA, "%");
	END IF;

END TerminaStore$$