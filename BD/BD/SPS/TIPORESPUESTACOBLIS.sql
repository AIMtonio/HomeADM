-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPORESPUESTACOBLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPORESPUESTACOBLIS`;DELIMITER $$

CREATE PROCEDURE `TIPORESPUESTACOBLIS`(

    Par_AccionID		INT(11),
	Par_NumList			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)


	)
TerminaStore:BEGIN


    DECLARE Lis_TiposRespuestas	INT(11);
    DECLARE Lis_ComboRespuestas	INT(11);
    DECLARE Est_Activo			CHAR(1);



    SET Lis_TiposRespuestas 	:= 1;
    SET Lis_ComboRespuestas 	:= 2;
    SET Est_Activo 				:= 'A';


	IF(Par_NumList = Lis_TiposRespuestas) THEN
		SELECT 	`RespuestaID`,		`Descripcion`,		`Estatus`
		FROM TIPORESPUESTACOB
        WHERE AccionID = Par_AccionID;
    END IF;

	IF(Par_NumList = Lis_ComboRespuestas) THEN
		SELECT 	`RespuestaID`,		`Descripcion`,		`Estatus`
		FROM TIPORESPUESTACOB
        WHERE AccionID = Par_AccionID AND
			Estatus = Est_Activo;
    END IF;

END TerminaStore$$