-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELCADENARAMAFIRACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `RELCADENARAMAFIRACON`;DELIMITER $$

CREATE PROCEDURE `RELCADENARAMAFIRACON`(
	/*SP Para Consultar las Ramas FIRA relacionadas a las cadenas produvtivas SCIAC*/
	Par_NumCon					TINYINT UNSIGNED,		# Numero de Lista
	Par_CveCadena				INT(11),				# Clave de Cadena Productiva
	Par_CveRamaFIRA				INT(11),				# Clave de Rama FIRA

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
	DECLARE Con_Principal			INT(11);

	-- Asignacion de Constantes
	SET	Con_Principal					:= 1;				-- Consulta Principal

	/* Numero de Lista: 1
	Lista Principal */
	IF(Par_NumCon = Con_Principal) THEN
		SELECT
			REL.CveCadena,		CAD.NomCadenaProdSCIAN,			REL.CveRamaFIRA,		RAM.DescripcionRamaFIRA
		FROM
			RELCADENARAMAFIRA AS REL INNER JOIN
			CATCADENAPRODUCTIVA AS CAD ON REL.CveCadena=CAD.CveCadena INNER JOIN
			CATRAMAFIRA AS RAM ON REL.CveRamaFIRA = RAM.CveRamaFIRA
		WHERE
			REL.CveCadena = Par_CveCadena AND
			REL.CveRamaFIRA = Par_CveRamaFIRA;
	END IF;

END TerminaStore$$