-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBARCHACLARALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBARCHACLARALIS`;DELIMITER $$

CREATE PROCEDURE `TARDEBARCHACLARALIS`(
	Par_ReporteID       varchar(22),
	Par_NumLis		  	tinyint unsigned,

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE FechaSist       date;
DECLARE Lis_AclaraArchivo   int;


Set Lis_AclaraArchivo		:= 2;

if(Par_NumLis = Lis_AclaraArchivo) then
    select FolioID, TipoArchivo, Recurso, Fecha, NombreArchivo
        from TARDEBARCHACLARA
		where ReporteID = Par_ReporteID;
end if;

END TerminaStore$$