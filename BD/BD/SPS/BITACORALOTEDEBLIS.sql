-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORALOTEDEBLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORALOTEDEBLIS`;DELIMITER $$

CREATE PROCEDURE `BITACORALOTEDEBLIS`(
    Par_BitCargaID      int,
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
DECLARE Estatus_Exito   char(1);
DECLARE Estatus_Fallo   char(1);
DECLARE Lis_Fallo       int;
DECLARE Lis_Exito       int;


Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Estatus_Exito   := 'E';
Set Estatus_Fallo   := 'F';
Set Lis_Fallo       := 1;
Set Lis_Exito       := 2;

if(Par_NumLis = Lis_Fallo) then
    select ConsecutivoBit, TarjetaDebID, MotivoFallo
        from BITACORALOTEDEB
        where BitCargaID = Par_BitCargaID
          and Estatus = Estatus_Fallo;
end if;
    select ConsecutivoBit, TarjetaDebID, MotivoFallo
        from BITACORALOTEDEB
        where BitCargaID = Par_BitCargaID
          and Estatus = Estatus_Exito;
END$$