-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MOTIVOSCASTIGOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `MOTIVOSCASTIGOLIS`;DELIMITER $$

CREATE PROCEDURE `MOTIVOSCASTIGOLIS`(
	Par_NumLis				tinyint unsigned,

	Aud_EmpresaID			int,
	Aud_Usuario         	int,
	Aud_FechaActual     	DateTime,
	Aud_DireccionIP     	varchar(15),
	Aud_ProgramaID      	varchar(50),
	Aud_Sucursal        	int(11),
	Aud_NumTransaccion  	bigint(20)
	)
TerminaStore:BEGIN


DECLARE Combo_Castigo		int;

set Combo_Castigo			:=1;

if (Combo_Castigo= Par_NumLis)then
	 select MotivoCastigoID,Descricpion
		from MOTIVOSCASTIGO;
end if;
END TerminaStore$$