-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOPORTUNIDADESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOPORTUNIDADESALT`;DELIMITER $$

CREATE PROCEDURE `PAGOPORTUNIDADESALT`(
	Par_Referencia	        varchar(45),
    Par_Monto               decimal(14,2),
	Par_ClienteID			int(11),
	Par_NombreCompleto		varchar(200),
	Par_Direccion			varchar(500),
	Par_NumTelefono			varchar(20),

	Par_TipoIdentiID		int(11),
	Par_FolioIdentific		varchar(45)	,
	Par_FormaPago			char(1),
	Par_NumeroCuenta		bigint(12),
	Par_Fecha				date,

	Par_SucursalID			int(11),
    Par_CajaID              int(11),
    Par_MonedaID            int(11),
	Par_UsuarioID           int(11),

    Par_Salida              char(1),
    inout Par_NumErr        int,
    inout Par_ErrMen        varchar(400),

    Par_EmpresaID           int(11),
    Aud_Usuario             int(11),
    Aud_FechaActual         datetime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int(11),
    Aud_NumTransaccion      bigint(20)
		)
TerminaStore:BEGIN


DECLARE Var_LongMinimaFolioOport	int;
DECLARE Var_LongMaximaFolioOport	int;


DECLARE Entero_Cero		int;
DECLARE Var_Control		varchar(50);
DECLARE SalidaSi		char(1);
DECLARE Cadena_Vacia	char;
DECLARE Deciamal_Cero	decimal;
DECLARE Deposito		char(1);


set Entero_Cero			:=0;
set Var_Control 		:= 'tipoOperacion' ;
set SalidaSi			:='S';
set Cadena_Vacia		:='';
set Deciamal_Cero		:=0.0;
set Deposito			:='D';

ManejoErrores: BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					set Par_NumErr = 999;
					set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
								 "estamos trabajando para resolverla. Disculpe las molestias que ",
								 "esto le ocasiona. Ref: SP-PAGOPORTUNIDADESALT");
				END;

	if(Par_ClienteID > Entero_Cero)then
		if not exists(select ClienteID
					from CLIENTES
					where ClienteID=Par_ClienteID)then
			set	Par_NumErr 	:= 1;
			set	Par_ErrMen	:= concat("El Cliente ",Par_ClienteID,  "no Existe");
			LEAVE ManejoErrores;
		end if;
	end if;
	if not exists(select CajaID,SucursalID
					from CAJASVENTANILLA
					where SucursalID=Par_SucursalID
					and CajaID= Par_CajaID)then
			set Par_NumErr  := 2;
			set Par_ErrMen  := 'La caja especificada no existe o pertenece a otra sucursal';
			LEAVE ManejoErrores;
	end if;
	if exists(select Referencia
				from PAGOPORTUNIDADES
					where Referencia=Par_Referencia)then
			set Par_NumErr  := 3;
			set Par_ErrMen  := concat('El pago con folio ',Par_Referencia,' ya fue realizado');
			LEAVE ManejoErrores;
	end if;


if (Par_FormaPago = Deposito)then
	if(Par_NumeroCuenta > Entero_Cero)then
			if not exists(select CuentaAhoID
						from CUENTASAHO
						where Par_NumeroCuenta=CuentaAhoID)then
				set	Par_NumErr 	:= 5;
				set	Par_ErrMen	:= 'La Cuenta especificada no existe';
				LEAVE ManejoErrores;
			end if;
	else if(Par_NumeroCuenta = Entero_Cero)then
		set	Par_NumErr 	:= 6;
		set	Par_ErrMen	:= 'Especifique el Numero de Cuenta para la forma de pago deposito a cuenta';
		LEAVE ManejoErrores;
	end if;
end if;
end if;


if (Par_Monto = Deciamal_Cero)then
	set	Par_NumErr 	:= 7;
	set	Par_ErrMen	:= 'El monto del pago esta vacio';
	LEAVE ManejoErrores;
end if;



select LonMinPagOport,LonMaxPagOport into Var_LongMinimaFolioOport, Var_LongMaximaFolioOport
	from PARAMETROSSIS;
set Var_LongMinimaFolioOport := ifnull(Var_LongMinimaFolioOport,Entero_Cero);
set Var_LongMaximaFolioOport:=ifnull(Var_LongMaximaFolioOport,Entero_Cero);

 if (character_length(Par_Referencia) < Var_LongMinimaFolioOport)then
	set	Par_NumErr 	:= 9;
	set	Par_ErrMen	:= concat('La longitud minima de la referencia es ',Var_LongMinimaFolioOport);
	LEAVE ManejoErrores;
else if  (character_length(Par_Referencia) > Var_LongMaximaFolioOport)then
	set	Par_NumErr 	:= 10;
	set	Par_ErrMen	:= concat('La longitud maxima de la referencia es ',Var_LongMaximaFolioOport);
	LEAVE ManejoErrores;
end if;
end if;

if (Par_NombreCompleto = Cadena_Vacia)then
	set	Par_NumErr 	:= 11;
	set	Par_ErrMen	:= 'El nombre de la persona esta vacio';
	LEAVE ManejoErrores;
end if;




	insert into PAGOPORTUNIDADES	(
					Referencia,		Monto,			ClienteID,		NombreCompleto,	Direccion,
					NumTelefono,	TipoIdentiID,	FolioIdentific,	FormaPago,		NumeroCuenta,
					Fecha,			SucursalID,    	CajaID,   		MonedaID,		UsuarioID,
					EmpresaID,		Usuario,    	FechaActual,    DireccionIP,	ProgramaID,
					Sucursal, 		NumTransaccion)
			values(
					Par_Referencia,		Par_Monto,			Par_ClienteID,	Par_NombreCompleto,	Par_Direccion,
					Par_NumTelefono,	Par_TipoIdentiID,	Par_FolioIdentific,	Par_FormaPago,	Par_NumeroCuenta,
					Par_Fecha,			Par_SucursalID,		Par_CajaID,			Par_MonedaID,	Par_UsuarioID,
					Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion);

				set	Par_NumErr 	:= 0;
				set	Par_ErrMen	:= 'Pago realizado exitosamente';

END ManejoErrores;
	 if (Par_Salida = SalidaSi) then
		 select  Par_NumErr as NumErr,
				Par_ErrMen as ErrMen,
				Var_Control as control,
				Entero_Cero as consecutivo;
	end if;
END TerminaStore$$