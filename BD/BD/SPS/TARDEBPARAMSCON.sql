-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBPARAMSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBPARAMSCON`;DELIMITER $$

CREATE PROCEDURE `TARDEBPARAMSCON`(
	Par_NumCon				int,


	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
	)
TerminaStore: BEGIN


DECLARE Con_Ruta  		int;


set Con_Ruta		:=2;


if(Par_NumCon = Con_Ruta) then
   select RutaAclaracion from TARDEBPARAMS;
	end if;
END TerminaStore$$