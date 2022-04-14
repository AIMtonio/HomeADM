-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSPUESTOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSPUESTOSLIS`;DELIMITER $$

CREATE PROCEDURE `TIPOSPUESTOSLIS`(
Par_TipoPuestoId            		INT(11),
Par_NumLis				TINYINT UNSIGNED,

Par_EmpresaID				INT,
Aud_Usuario				INT,
Aud_FechaActual				DATETIME,
Aud_DireccionIP				VARCHAR(15),
Aud_ProgramaID				VARCHAR(50),
Aud_Sucursal				INT,
Aud_NumTransaccion		   	BIGINT

	)
TerminaStore: BEGIN



DECLARE Entero_Cero		 int;
DECLARE Lis_Principal	 int;


set Lis_Principal	 	 := 1;
set Entero_Cero			 := 0;


if(Par_NumLis = Lis_Principal) then
	select `TipoPuestoID` , `Descripcion`
	from TIPOSPUESTOS where TipoPuestoID > Entero_Cero;
END IF;

END TerminaStore$$