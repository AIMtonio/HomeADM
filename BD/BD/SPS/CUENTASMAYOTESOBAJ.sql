-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYOTESOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYOTESOBAJ`;
DELIMITER $$


CREATE PROCEDURE `CUENTASMAYOTESOBAJ`(
    Par_ConceptoTesoID  int(11),

    Par_Salida            char(1),
INOUT	Par_NumErr        int(11),
INOUT	Par_ErrMen        varchar(100),
INOUT	Par_Consecutivo   bigint,

    Aud_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint  	)

TerminaStore: BEGIN


DECLARE Cadena_Vacia    char(1);
DECLARE Entero_Cero     int;
DECLARE Salida_SI       char(1);


Set Cadena_Vacia    := '';
Set Entero_Cero     := 0;
Set Salida_SI       := 'S';


delete from CUENTASMAYORTESO
    where  ConceptoTesoID 	= Par_ConceptoTesoID;

if (Par_Salida = Salida_SI) then
    select '000' as NumErr ,
      'Cuenta Eliminada' as ErrMen,
      'ConceptoTesoID' as control;
else
    set Par_NumErr      := '000';
    set Par_ErrMen      := 'Cuenta Eliminada';
    set Par_Consecutivo := Entero_Cero;
end if;


END TerminaStore$$