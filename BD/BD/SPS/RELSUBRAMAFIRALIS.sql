-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELSUBRAMAFIRALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `RELSUBRAMAFIRALIS`;DELIMITER $$

CREATE PROCEDURE `RELSUBRAMAFIRALIS`(
	/*SP Para Listar las Ramas FIRA relacionadas a las cadenas produvtivas SCIAC*/
	Par_NumLis					TINYINT UNSIGNED,		# Numero de Lista
	Par_CveCadena				INT(11),				# Clave de Cadena Productiva
	Par_CveRamaFIRA				INT(11),				# Clave de Rama FIRA
	Par_CveSubramaFIRA			INT(11),				# Clave de la SubRama FIRA
	Par_DescSubramaFIRA			VARCHAR(100),			# Descripcion de la SubRama

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
	DECLARE Cadena_Vacia			VARCHAR(1);
	DECLARE Lis_Principal			INT(11);

	-- Asignacion de Constantes
    SET Cadena_Vacia					:= '';				-- Cadena Vacia
	SET	Lis_Principal					:= 1;				-- Lista Principal

	/* Numero de Lista: 1
	Lista Principal */
	IF(Par_NumLis = Lis_Principal) THEN
		SET Par_DescSubramaFIRA := IFNULL(Par_DescSubramaFIRA, Cadena_Vacia);
		SELECT
			CveCadena,		CveRamaFIRA,		CveSubramaFIRA,			DescSubramaFIRA
		FROM
			RELSUBRAMAFIRA AS REL
		WHERE
			REL.CveCadena = Par_CveCadena AND
			REL.CveRamaFIRA = Par_CveRamaFIRA AND
			REL.DescSubramaFIRA LIKE CONCAT("%", Par_DescSubramaFIRA, "%");
	END IF;

END TerminaStore$$