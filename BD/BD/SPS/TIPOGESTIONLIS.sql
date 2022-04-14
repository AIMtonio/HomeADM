-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOGESTIONLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOGESTIONLIS`;DELIMITER $$

CREATE PROCEDURE `TIPOGESTIONLIS`(
	Par_TipoGestionID	VARCHAR(100),
	Par_NumLis			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN



	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE EstatusAct      CHAR(1);
	DECLARE	Lis_Principal	INT(11);
	DECLARE	Lis_Combo		INT(11);




	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET EstatusAct      := 'A';
	SET	Lis_Principal	:= 1;
	SET	Lis_Combo	    := 2;




	IF(Par_NumLis = Lis_Principal) THEN
		SELECT TipoGestionID,Descripcion
			FROM TIPOGESTION
				WHERE Descripcion like CONCAT("%", Par_TipoGestionID, "%")
						AND Estatus = EstatusAct
		LIMIT 0, 15;
	END IF;


	IF(Par_NumLis = Lis_Combo) THEN
		SELECT TipoGestionID,Descripcion
			FROM TIPOGESTION
			WHERE Estatus=EstatusAct;
	END IF;

END TerminaStore$$