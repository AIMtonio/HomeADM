-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMFALTASOBRAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMFALTASOBRAALT`;DELIMITER $$

CREATE PROCEDURE `PARAMFALTASOBRAALT`(
	Par_SucursalID			int(11),
	Par_MontoMaximoSobra	decimal(14,2),
	Par_MontoMaximoFalta	decimal(14,2),

	Par_Salida				char(1),
	inout	Par_NumErr 		int,
	inout	Par_ErrMen  	varchar(350),

	Par_EmpresaID			int,
	Aud_Usuario         	int,
	Aud_FechaActual     	DateTime,
	Aud_DireccionIP     	varchar(15),
	Aud_ProgramaID      	varchar(50),
	Aud_Sucursal        	int(11),
	Aud_NumTransaccion  	bigint(20)

	)
TerminaStore:BEGIN

DECLARE Var_ParamFaltaSobraID		int(11);



DECLARE Entero_Cero					int;
DECLARE Decimal_Cero				decimal;
DECLARE SalidaSI					char(1);

set Entero_Cero						:=0;
set Decimal_Cero					:=0.0;
set SalidaSI						:='S';
ManejoErrores:BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                 "estamos trabajando para resolverla. Disculpe las molestias que ",
                                 "esto le ocasiona. Ref: SP-PARAMFALTASOBRAALT");
    END;



if (ifnull(Par_SucursalID,Entero_Cero) = Entero_Cero )then
		set	Par_NumErr 	:= 1;
		set	Par_ErrMen	:= "El Numero de Sucursal se encuentra Vacio";
		LEAVE ManejoErrores;
end if;
if (ifnull(Par_MontoMaximoSobra,Decimal_Cero) = Decimal_Cero )then
		set	Par_NumErr 	:= 2;
		set	Par_ErrMen	:= "El Monto Maximo Sobrante se encuentra vacio";
		LEAVE ManejoErrores;
end if;
if (ifnull(Par_MontoMaximoFalta,Decimal_Cero) = Decimal_Cero )then
		set	Par_NumErr 	:= 3;
		set	Par_ErrMen	:= "El Monto Maximo Faltante se encuentra vacio";
		LEAVE ManejoErrores;
end if;

if not exists (select SucursalID
					from SUCURSALES
					WHERE SucursalID = Par_SucursalID)then
		set	Par_NumErr 	:= 4;
		set	Par_ErrMen	:= "El Numero de Sucursal indicada no Existe";
		LEAVE ManejoErrores;
end if;

if exists (select SucursalID
					from PARAMFALTASOBRA
					WHERE SucursalID = Par_SucursalID)then
		set	Par_NumErr 	:= 4;
		set	Par_ErrMen	:= "El Numero de Sucursal indicada ya Existe";
		LEAVE ManejoErrores;
end if;


call FOLIOSAPLICAACT('PARAMFALTASOBRA', Var_ParamFaltaSobraID);
set Aud_FechaActual	:=now();

insert into PARAMFALTASOBRA (
				ParamFaltaSobraID,	SucursalID,		MontoMaximoSobra,	MontoMaximoFalta,	EmpresaID,
				Usuario,			FechaActual,	DireccionIP,		ProgramaID,			Sucursal,
				NumTransaccion)
		values(Var_ParamFaltaSobraID,	Par_SucursalID,		Par_MontoMaximoSobra,	Par_MontoMaximoFalta,	Par_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
				Aud_NumTransaccion);

	set Par_NumErr :=0;
	set Par_ErrMen	:=concat('Parametros Guardados Exitosamente: ', convert(Var_ParamFaltaSobraID,char));

END ManejoErrores;
if (Par_Salida = SalidaSI) then
	select  convert(Par_NumErr, char(10)) as NumErr,
			Par_ErrMen as ErrMen,
			'sucursalID' as control,
			Par_SucursalID as consecutivo;
end if;
END TerminaStore$$