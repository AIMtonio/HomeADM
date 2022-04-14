-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSMOVTESOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSMOVTESOLIS`;DELIMITER $$

CREATE PROCEDURE `TIPOSMOVTESOLIS`(
    Par_Descripcion     varchar(50),
    Par_TipoMovimi      char(1),
    Par_NumLis          tinyint unsigned,

    Aud_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     Datetime,
    Aud_DireccionIP     varchar(20),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint(20)
	)
TerminaStore: BEGIN




DECLARE Cadena_Vacia 	char(1);
DECLARE Fecha_Vacia  	date;
DECLARE Entero_Cero  	int;

DECLARE TipoConcili 	char(1);

DECLARE Lis_Principal	int;
DECLARE Lis_Concili  	int;


Set Cadena_Vacia 		:= '';
Set Fecha_Vacia   	:= '1900-01-01';
Set Entero_Cero      	:= 0;
Set TipoConcili		:= 'C';
Set Lis_Principal    	:= 1;
Set Lis_Concili      	:= 2;

if(Par_NumLis = Lis_Principal) then
    select  TipoMovTesoID,  Descripcion
        from TIPOSMOVTESO
        where TipoMovimiento    = Par_TipoMovimi
          and Descripcion like concat("%", Par_Descripcion, "%")
     limit 0, 15;
end if;


if(Par_NumLis = Lis_Concili) then
    select  TipoMovTesoID,  Descripcion
        from TIPOSMOVTESO
        where TipoMovimiento = TipoConcili;
end if;


END TerminaStore$$