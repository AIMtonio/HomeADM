-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELSUBRAMAFIRACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `RELSUBRAMAFIRACON`;DELIMITER $$

CREATE PROCEDURE `RELSUBRAMAFIRACON`(
	/*SP Para Consultar las SubRamas FIRA relacionadas a las cadenas produvtivas SCIAC*/
	Par_NumCon					TINYINT UNSIGNED,		# Numero de Consulta
	Par_CveCadena				INT(11),				# Clave de Cadena Productiva
	Par_CveRamaFIRA				INT(11),				# Clave de Rama FIRA
	Par_CveSubramaFIRA			INT(11),				# Clave de la SubRama FIRA

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
	SET	Con_Principal					:= 1;				-- Lista Principal

	/* Numero de Consulta: 1
	Consulta Principal */
	IF(Par_NumCon = Con_Principal) THEN
		SELECT
			CveCadena,		CveRamaFIRA,		CveSubramaFIRA,			DescSubramaFIRA
		FROM
			RELSUBRAMAFIRA AS REL
		WHERE
			REL.CveCadena = Par_CveCadena AND
			REL.CveRamaFIRA = Par_CveRamaFIRA AND
			REL.CveSubramaFIRA = Par_CveSubramaFIRA;
	END IF;

END TerminaStore$$