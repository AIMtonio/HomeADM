-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMACOMISCREALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMACOMISCREALT`;DELIMITER $$

CREATE PROCEDURE `ESQUEMACOMISCREALT`(


	Par_MontoInicial		decimal(12,2),
	Par_MontoFinal			decimal(12,2),
	Par_TipoComision		varchar(1),
	Par_Comision			decimal(12,4),
	Par_ProducCreditoID 	int(11),

	Par_EmpresaID			int(11),
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint(20)

	)
TerminaStore :BEGIN

DECLARE Var_EsquemaComID int(11);


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Decimal_Cero		decimal;



set	Cadena_Vacia			:= '';
set	Fecha_Vacia			:= '1900-01-01';
set	Decimal_Cero			:= 0.0;


set	Var_EsquemaComID		:= (select ifnull(Max(EsquemaComID),Decimal_Cero)+1
				    		from ESQUEMACOMISCRE );




if Par_MontoInicial > Par_MontoFinal then
select  '002' as NumErr,
        'El monto final no puede ser menor que el monto inicial' as ErrMen,
		 'montoFinal' as control,
        Par_ProducCreditoID as consecutivo;
LEAVE TerminaStore;
end if;

if(ifnull( Par_MontoFinal, Decimal_Cero)) = Decimal_Cero then
select  '003' as NumErr,
        'El Monto Final esta Vacio ' as ErrMen,
		 'montoFinal' as control,
        Par_MontoFinal as consecutivo;
LEAVE TerminaStore;
end if;

if(ifnull( Par_Comision, Decimal_Cero)) = Decimal_Cero then
select  '004' as NumErr,
        'La Comisión esta Vacia ' as ErrMen,
		 'comision' as control,
        Par_Comision as consecutivo;
LEAVE TerminaStore;
end if;

insert into ESQUEMACOMISCRE (
							EsquemaComID,		MontoInicial,			MontoFinal,				TipoComision,			Comision,
							ProducCreditoID,		EmpresaID,			ProgramaID,				Usuario,				FechaActual,
							DireccionIP,			Sucursal, 	       			NumTransaccion)

				    values (
							Var_EsquemaComID,	Par_MontoInicial,		Par_MontoFinal,				Par_TipoComision,		Par_Comision,
							Par_ProducCreditoID,	Par_EmpresaID,		Aud_ProgramaID,			Aud_Usuario,			Aud_FechaActual,
							Aud_DireccionIP,		Aud_Sucursal,			Aud_NumTransaccion);


select  '000' as NumErr,
        concat("Esquema Agregado Correctamente: ",Par_ProducCreditoID) as ErrMen,
		 'producCreditoID' as control,
        Par_ProducCreditoID as consecutivo;

END TerminaStore$$