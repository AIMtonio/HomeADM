-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPROTECCIONESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISPROTECCIONESALT`;DELIMITER $$

CREATE PROCEDURE `HISPROTECCIONESALT`(
	Par_ClienteID			int(11),

	Par_Salida				CHAR(1),
    inout Par_NumErr        int,
    inout Par_ErrMen        varchar(400),

	Par_EmpresaID			int,
	Aud_Usuario         	int,
	Aud_FechaActual     	DateTime,
	Aud_DireccionIP     	varchar(15),
	Aud_ProgramaID      	varchar(50),
	Aud_Sucursal        	int(11),
	Aud_NumTransaccion  	bigint(20)
)
TerminaStore:BEGIN



DECLARE Cadena_Vacia		char(1);
DECLARE Entero_Cero			int;
DECLARE Decimal_Cero		decimal;
DECLARE SalidaSI            char(1);



set Cadena_Vacia		:='';
set Entero_Cero			:=0;
set Decimal_Cero		:=0.0;
set SalidaSI            :='S';


ManejoErrores:BEGIN


set Aud_FechaActual := CURRENT_TIMESTAMP();

		insert into HISPROTECCIONES (
						ClienteID,			ClienteCancelaID,		TotalSaldoOriCap,	ParteSocial,	InteresCap,
						InteresRetener,		TotalHaberes,			TotalAdeudoCre,		AplicaPROFUN,	AplicaSERVIFUN,
						AplicaProtecCre,	AplicaProtecAho,		MontoPROFUN,		MontoSERVIFUN,	MontoProtecCre,
						MontoProtecAho,		TotalBeneAplicado,		SaldoFavorCliente,	EmpresaID,		Usuario,
						FechaActual,		DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion)

		select 			ClienteID,			ClienteCancelaID,		TotalSaldoOriCap,	ParteSocial,	InteresCap,
						InteresRetener,		TotalHaberes,			TotalAdeudoCre,		AplicaPROFUN,	AplicaSERVIFUN,
						AplicaProtecCre,	AplicaProtecAho,		MontoPROFUN,		MontoSERVIFUN,	MontoProtecCre,
						MontoProtecAho,		TotalBeneAplicado,		SaldoFavorCliente,	EmpresaID,		Usuario,
						FechaActual,		DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion
		from 	PROTECCIONES
		where 	ClienteID	= Par_ClienteID;

Set Par_NumErr  := Entero_Cero;
Set Par_ErrMen  := 'Datos Agregados Exitosamente';


END ManejoErrores;



if(Par_Salida = SalidaSI) then
        select '000' as NumErr,
                Par_ErrMen as ErrMen,
                'clienteID' as control,
                Entero_Cero as consecutivo;
end if;

END  TerminaStore$$