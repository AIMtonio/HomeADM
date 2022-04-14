-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIASPASOVENCIDOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIASPASOVENCIDOALT`;DELIMITER $$

CREATE PROCEDURE `DIASPASOVENCIDOALT`(
	Par_ProducCreditoID		int(11),
	Par_Frecuencia			char(1),
	Par_DiasPasoVencido		int(3),

	Par_Salida              char(1),
    inout Par_NumErr        int,
    inout Par_ErrMen        varchar(400),

    Par_EmpresaID       	int(11),
    Aud_Usuario         	int(11),
    Aud_FechaActual     	DateTime,
    Aud_DireccionIP     	varchar(15),
    Aud_ProgramaID      	varchar(50),
    Aud_Sucursal        	int,
	Aud_NumTransaccion  	bigint(20)


	)
TerminaStore:BEGIN

DECLARE Var_Control		char(1);

DECLARE SalidaSI		char(1);
DECLARE Entero_Cero		int;
DECLARE Cadena_Vacia	char;


set SalidaSI		:='S';
set Entero_Cero		:=0;
set Cadena_Vacia	:='';
set Par_NumErr		:=1;
set Par_ErrMen		:=Cadena_Vacia;

 ManejoErrores: BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					set Par_NumErr = 999;
					set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
								 "estamos trabajando para resolverla. Disculpe las molestias que ",
								 "esto le ocasiona. Ref: SP-DIASPASOVENCIDOALT");
				END;

if (Par_ProducCreditoID=Entero_Cero)then
		set Par_NumErr  := 1;
        set Par_ErrMen  := 'El producto de credito está vacio';
        LEAVE ManejoErrores;
end if;
if not exists(select ProducCreditoID
					from PRODUCTOSCREDITO
					where ProducCreditoID=Par_ProducCreditoID)then
		set Par_NumErr  := 2;
        set Par_ErrMen  := concat('El Producto de credito ',Par_ProducCreditoID,'no existe');
        LEAVE ManejoErrores;
end if;
if (Par_Frecuencia=Cadena_Vacia)then
	set Par_NumErr  := 3;
        set Par_ErrMen  := concat('La frecuencia esta vacia');
        LEAVE ManejoErrores;
end if;

if (Par_DiasPasoVencido=Entero_Cero)then
		set Par_NumErr  := 4;
        set Par_ErrMen  := concat('El numero de Dias esta vacio');
        LEAVE ManejoErrores;
end if;

insert into DIASPASOVENCIDO (
				ProducCreditoID,	Frecuencia,		DiasPasoVencido,	EmpresaID,		Usuario,
				FechaActual,		DireccionIP,	ProgramaID,			Sucursal,		NumTransaccion)
		values(	Par_ProducCreditoID,Par_Frecuencia,	Par_DiasPasoVencido,Par_EmpresaID ,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		set Par_NumErr  := 0;
        set Par_ErrMen  := 'Dias paso a Vencido Agregados Correctamente';

END ManejoErrores;
 if (Par_Salida = SalidaSI) then
     select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            'producCreditoID' as control,
            Entero_Cero as consecutivo;
end if;

END TerminaStore$$