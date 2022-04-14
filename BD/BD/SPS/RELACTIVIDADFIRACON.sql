-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELACTIVIDADFIRACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `RELACTIVIDADFIRACON`;DELIMITER $$

CREATE PROCEDURE `RELACTIVIDADFIRACON`(
	/*SP Para Consultar las Actividades FIRA relacionadas*/
	Par_NumCon					TINYINT UNSIGNED,		# Numero de Consulta
	Par_CveCadena				INT(11),				# Clave de Cadena Productiva
	Par_CveRamaFIRA				INT(11),				# Clave de Rama FIRA
	Par_CveSubramaFIRA			INT(11),				# Clave de la SubRama FIRA
	Par_CveActividadFIRA		INT(11),				# Clave de la Actividad

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
	DECLARE Con_Principal			INT(11);

	-- Asignacion de Constantes
	SET Cadena_Vacia					:= '';				-- Cadena Vacia
	SET	Con_Principal					:= 1;				-- Consulta Principal

	/* Numero de Consulta: 1
	Consulta Principal */
	IF(Par_NumCon = Con_Principal) THEN
		SELECT
			REL.CveCadena,		REL.CveRamaFIRA,		REL.CveSubramaFIRA,			REL.CveActividadFIRA,		CAT.DesActividadFIRA
			FROM RELACTIVIDADFIRA AS REL INNER JOIN
				CATACTIVIDADFIRA AS CAT ON REL.CveActividadFIRA=CAT.CveActividadFIRA
				WHERE
					REL.CveCadena = Par_CveCadena AND
					REL.CveRamaFIRA = Par_CveRamaFIRA AND
					REL.CveSubramaFIRA = Par_CveSubramaFIRA AND
					REL.CveActividadFIRA = Par_CveActividadFIRA;
	END IF;

END TerminaStore$$