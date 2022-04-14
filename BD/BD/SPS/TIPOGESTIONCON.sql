-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOGESTIONCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOGESTIONCON`;DELIMITER $$

CREATE PROCEDURE `TIPOGESTIONCON`(
	Par_TipoGestionID	    INT(20),
	Par_NumCon				TINYINT UNSIGNED,

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN



	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Con_Principal	INT(11);
	DECLARE Con_TipoGestion	INT(11);
	DECLARE	Est_Activo		CHAR(1);



	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET	Con_Principal	:= 1;
	SET Con_TipoGestion	:= 2;
	SET	Est_Activo		:= 'A';


	IF(Par_NumCon = Con_Principal) THEN
		SELECT
			TipoGestionID,	Descripcion
		FROM TIPOGESTION
		WHERE TipoGestionID	= Par_TipoGestionID
			AND Estatus		= Est_Activo;
	END IF;


	IF(Par_NumCon = Con_TipoGestion) THEN
		SELECT
			TipoGestionID, 	Descripcion,	TipoAsigna,	Estatus
		FROM TIPOGESTION
		WHERE TipoGestionID	= Par_TipoGestionID;
	END IF;

END TerminaStore$$