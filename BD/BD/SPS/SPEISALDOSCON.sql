-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEISALDOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEISALDOSCON`;DELIMITER $$

CREATE PROCEDURE `SPEISALDOSCON`(



	Par_EmpresaID		INT(11),
	Par_NumCon			TINYINT UNSIGNED,

	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT

)
TerminaStore: BEGIN


	DECLARE	Con_SaldoActual		INT;


	SET	Con_SaldoActual	:= 1;

	IF(Par_NumCon = Con_SaldoActual) THEN
		SELECT  SaldoActual
		  FROM 	SPEISALDOS
		 WHERE 	EmpresaID	= Par_EmpresaID;
	END IF;

END TerminaStore$$