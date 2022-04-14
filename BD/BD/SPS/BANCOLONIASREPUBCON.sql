-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANCOLONIASREPUBCON
DELIMITER ;

DROP PROCEDURE IF EXISTS `BANCOLONIASREPUBCON`;

DELIMITER $$


CREATE PROCEDURE `BANCOLONIASREPUBCON`(

    Par_CodigoPostal    	VARCHAR(10),
	Par_NumCon		    	TINYINT UNSIGNED,

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE Con_CodigoPostal 	INT(11);


	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET Con_CodigoPostal		:= 1;

	SET Par_CodigoPostal		:= IFNULL(Par_CodigoPostal,Cadena_Vacia);
	SET Par_NumCon				:= IFNULL(Par_NumCon,Entero_Cero);


	IF (Par_NumCon = Con_CodigoPostal) THEN
		SELECT	Col.MunicipioID,	Col.EstadoID,
				Est.Nombre AS NombreEstado,
				Mun.Nombre AS NombreMunicipio
			FROM COLONIASREPUB AS Col
			INNER JOIN	ESTADOSREPUB AS Est
				ON Est.EstadoID	= Col.EstadoID
			INNER JOIN	MUNICIPIOSREPUB AS Mun
				ON Mun.EstadoID = Est.EstadoID
					AND Mun.MunicipioID	= Col.MunicipioID
			WHERE	Col.CodigoPostal	= 	Par_CodigoPostal
		LIMIT 1;
	END IF;
END TerminaStore$$
