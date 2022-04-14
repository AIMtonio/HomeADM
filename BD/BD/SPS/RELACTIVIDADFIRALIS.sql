-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELACTIVIDADFIRALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `RELACTIVIDADFIRALIS`;DELIMITER $$

CREATE PROCEDURE `RELACTIVIDADFIRALIS`(
	/*SP Para Listar las Activiadades FIRA relacionadas*/
	Par_NumLis					TINYINT UNSIGNED,		# Numero de Lista
	Par_CveCadena				INT(11),				# Clave de Cadena Productiva
	Par_CveRamaFIRA				INT(11),				# Clave de Rama FIRA
	Par_CveSubramaFIRA			INT(11),				# Clave de la SubRama FIRA
	Par_CveActividadFIRA		INT(11),				# Clave de la Actividad
	Par_DesActividadFIRA		VARCHAR(45),			# Descripcion de la Actividad

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
		SET Par_DesActividadFIRA := IFNULL(Par_DesActividadFIRA, Cadena_Vacia);
		SELECT
			REL.CveCadena,		REL.CveRamaFIRA,		REL.CveSubramaFIRA,			REL.CveActividadFIRA,CAT.DesActividadFIRA
			FROM RELACTIVIDADFIRA AS REL INNER JOIN
				CATACTIVIDADFIRA AS CAT ON REL.CveActividadFIRA=CAT.CveActividadFIRA
				WHERE
					CveCadena = Par_CveCadena AND
					CveRamaFIRA = Par_CveRamaFIRA AND
					CveSubramaFIRA = Par_CveSubramaFIRA AND
					DesActividadFIRA LIKE CONCAT("%", Par_DesActividadFIRA,"%");
	END IF;


END TerminaStore$$