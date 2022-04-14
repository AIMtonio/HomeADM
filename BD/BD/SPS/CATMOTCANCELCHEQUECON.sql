-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATMOTCANCELCHEQUECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATMOTCANCELCHEQUECON`;DELIMITER $$

CREATE PROCEDURE `CATMOTCANCELCHEQUECON`(
	Par_MotivoID			INT(11),
	Par_NumCon				TINYINT UNSIGNED,

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
		)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Entero_Cero			INT(11);
DECLARE Con_MotivosCancela 	INT(11);
DECLARE Con_ChequesCancela 	INT(11);


SET	Cadena_Vacia			:= '';
SET	Entero_Cero				:= 0;
SET	Con_MotivosCancela		:= 1;
SET Con_ChequesCancela		:= 2;


IF(Par_NumCon = Con_MotivosCancela) THEN
	SELECT	MotivoID,	Descripcion,	Estatus
	FROM CATMOTCANCELCHEQUE
	WHERE  MotivoID = Par_MotivoID;
END IF;


IF(Par_NumCon = Con_ChequesCancela) THEN
	SELECT	COUNT(MotivoID)AS NumCancela
	FROM CANCELACHEQUES
	WHERE  MotivoID = Par_MotivoID;
END IF;

END TerminaStore$$