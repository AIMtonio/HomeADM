-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORATARDEBLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORATARDEBLIS`;DELIMITER $$

CREATE PROCEDURE `BITACORATARDEBLIS`(
    Par_TarjetaDebID      char(16),
    Par_NumLis          tinyint unsigned,

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     datetime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint

	)
TerminaStore: BEGIN




DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Lis_Principal    int;



Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Lis_Principal   := 1;


if(Par_NumLis = Lis_Principal) then
	SELECT
		date(Fecha) as fecha, upper(Est.Descripcion), upper(Cat.Descripcion), upper(DescripAdicio)
	FROM BITACORATARDEB bita
	LEFT JOIN CATALCANBLOQTAR Cat on bita.MotivoBloqID=Cat.MotCanBloId
	LEFT JOIN ESTATUSTD Est on Est.EstatusID=bita.TipoEvenTDID
	WHERE bita.TarjetaDebID = Par_TarjetaDebID;
end if;


END$$