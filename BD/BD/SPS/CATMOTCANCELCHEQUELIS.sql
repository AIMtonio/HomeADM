-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATMOTCANCELCHEQUELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATMOTCANCELCHEQUELIS`;DELIMITER $$

CREATE PROCEDURE `CATMOTCANCELCHEQUELIS`(
	Par_MotivoID		INT(11),
	Par_Descripcion		VARCHAR(200),
	Par_NumLis			TINYINT UNSIGNED,

	Par_EmpresaID   	INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
		)
TerminaStore: BEGIN



DECLARE	Entero_Cero		INT(11);
DECLARE Estatus_Activo	CHAR(1);
DECLARE	Lis_Principal	INT(11);
DECLARE Lis_MotivosCan	INT(11);


SET	Entero_Cero		:= 0;
SET Estatus_Activo	:= 'A';
SET	Lis_Principal	:= 1;
SET	Lis_MotivosCan	:= 2;


IF(Par_NumLis = Lis_Principal) THEN
	SELECT	MotivoID,	Descripcion,	Estatus
		FROM CATMOTCANCELCHEQUE
		ORDER BY MotivoID;
END IF;

IF(Par_NumLis = Lis_MotivosCan) THEN
	SELECT	MotivoID,	Descripcion
		FROM CATMOTCANCELCHEQUE
        WHERE Estatus = Estatus_Activo
        AND Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		ORDER BY MotivoID
        LIMIT 0, 15;
END IF;


END TerminaStore$$