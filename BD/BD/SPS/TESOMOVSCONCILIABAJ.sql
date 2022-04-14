-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESOMOVSCONCILIABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `TESOMOVSCONCILIABAJ`;
DELIMITER $$


CREATE PROCEDURE `TESOMOVSCONCILIABAJ`(
    Par_FolioCarga		bigint,

    Par_Salida         	char(1),
inout Par_NumErr		int(11),
inout Par_ErrMen		varchar(400),
inout Par_Consecutivo	bigint,

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     datetime,
    Aud_DireccionIP     varchar(20),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint(20)
	)

TerminaStore: BEGIN


DECLARE Var_EstPagNom	char(1);


DECLARE Entero_Cero	int;
DECLARE Est_Concilado  	char(1);
DECLARE Decimal_Cero  	decimal(14,2);
DECLARE ActConciliado  	int;
DECLARE Salida_SI     	char(1);



Set Entero_Cero     	:= 0;
Set Est_Concilado	 	:= 'C';
Set Decimal_Cero 		:= 0.00;
Set Salida_SI       	:= 'S';
Set Aud_FechaActual		:= now();

set Par_FolioCarga := ifnull(Par_FolioCarga,Entero_Cero);
if(Par_FolioCarga = Entero_Cero) then
	  select '001' as NumErr,
		'El Folio de Carga Viene Vacio.' as ErrMen,
		'numCtaInstit' as control,
		Entero_Cero as consecutivo;
end if;

delete from TESOMOVSCONCILIA
where FolioCargaID = Par_FolioCarga;

if (Par_Salida = Salida_SI) then
    select '000' as NumErr,
		'Movimiento Eliminado.' as ErrMen,
		'numCtaInstit' as control,
		Entero_Cero as consecutivo;
else
    set Par_NumErr      := '000';
    set Par_ErrMen      := 'Movimiento Eliminado.';
    set Par_Consecutivo := Entero_Cero;
end if;

END TerminaStore$$