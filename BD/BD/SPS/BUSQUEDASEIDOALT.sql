-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BUSQUEDASEIDOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BUSQUEDASEIDOALT`;DELIMITER $$

CREATE PROCEDURE `BUSQUEDASEIDOALT`(
	Par_ClienteID			int(11),
	Par_Nombre				varchar(200),

	Par_Salida				char(1),
    inout	Par_NumErr		int,
    inout	Par_ErrMen		varchar(350),

    Par_EmpresaID			int,
    Aud_Usuario         	int,
    Aud_FechaActual     	DateTime,
    Aud_DireccionIP     	varchar(15),
    Aud_ProgramaID      	varchar(50),
    Aud_Sucursal        	int,
    Aud_NumTransaccion  	bigint
)
TerminaStore:  BEGIN

DECLARE Entero_Cero			int(1);
DECLARE Cadena_Vacia		char(1);
DECLARE FechaVacia			date;
DECLARE Cliente				char(1);
DECLARE RelacionadoCta		char(2);
DECLARE RelacionadoInver	char(2);
DECLARE Aval				char(1);
DECLARE Prospecto			char(1);
DECLARE Esta_Vigente		char(1);
DECLARE Credito_Vencido		char(1);
DECLARE Credito_Vigente		char(1);
DECLARE Salida_SI			char(1);


DECLARE VarControl			varchar(60);
DECLARE Var_FechaSistema	date;
DECLARE Var_BusquedaSeidoID	int(11);


set Entero_Cero			:= 0;
set Cadena_Vacia		:= '';
set FechaVacia			:= '1900-01-01';
set Cliente				:= 'C';
set RelacionadoCta		:= 'RC';
set RelacionadoInver	:= 'RI';
set Aval				:= 'A';
set Prospecto			:= 'P';
set Esta_Vigente		:= 'N';
set Credito_Vencido		:= 'B';
set Credito_Vigente		:= 'V';
set Salida_SI			:= 'S';
set Aud_FechaActual 	:= now();

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-BUSQUEDASEIDOALT');
				SET VarControl = 'sqlException' ;
			END;

set Var_FechaSistema :=ifnull((select FechaSistema from PARAMETROSSIS),FechaVacia);

if(ifnull(Par_ClienteID, Entero_Cero) = Entero_Cero and ifnull(Par_Nombre,Cadena_Vacia) = Cadena_Vacia) then
		set Par_NumErr   := 01;
		set Par_ErrMen   := 'Especifique la Persona que Desea Buscar';
		set VarControl   := 'clienteID';
		LEAVE ManejoErrores;
	end if;

call FOLIOSAPLICAACT('BUSQUEDASEIDO', Var_BusquedaSeidoID);
	if(Par_ClienteID > Entero_Cero) then
		insert into BUSQUEDASEIDO(BusquedaSeidoID,		Nombre,			TipoBusqueda, 	ClienteID, 	CuentaAhoID,
									PersonaID, 			InversionID, 	BenefInverID, 	Fecha, 		SolicitudID,
									Tipo, 				Numero, 		EmpresaID, 		Usuario, 	FechaActual,
									DireccionIP, 		ProgramaID,		Sucursal,		NumTransaccion)

		Select Var_BusquedaSeidoID,	Par_Nombre,		Cliente, 		cli.ClienteID,		Entero_Cero,
				Entero_Cero,		Entero_Cero,	Entero_Cero,	Var_FechaSistema, 	Entero_Cero,
				Cadena_Vacia,		Entero_Cero,	Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
				from CLIENTES cli
				where cli.ClienteID = Par_ClienteID;
	else
		insert into BUSQUEDASEIDO(BusquedaSeidoID,		Nombre,			TipoBusqueda, 	ClienteID, 	CuentaAhoID,
								PersonaID, 			InversionID, 	BenefInverID, 	Fecha, 		SolicitudID,
								Tipo, 				Numero, 		EmpresaID, 		Usuario, 	FechaActual,
								DireccionIP, 		ProgramaID,		Sucursal,		NumTransaccion)

		select Var_BusquedaSeidoID, 	cli.NombreCompleto, Cliente, 		cli.ClienteID,		Entero_Cero,
					Entero_Cero, 		Entero_Cero, 		Entero_Cero, 	Var_FechaSistema, 	Entero_Cero,
					Cadena_Vacia,  		Entero_Cero,		Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion
				from CLIENTES cli
				where cli.NombreCompleto = Par_Nombre;
	end if;
		insert into BUSQUEDASEIDO(BusquedaSeidoID,		Nombre,			TipoBusqueda, 	ClienteID, 	CuentaAhoID,
									PersonaID, 			InversionID, 	BenefInverID, 	Fecha, 		SolicitudID,
									Tipo, 				Numero, 		EmpresaID, 		Usuario, 	FechaActual,
									DireccionIP, 		ProgramaID,		Sucursal,		NumTransaccion)

		select 	Var_BusquedaSeidoID,	Par_Nombre,		RelacionadoCta,	Entero_Cero,		ctap.CuentaAhoID,
				ctap.PersonaID,			Entero_Cero,	Entero_Cero,	Var_FechaSistema, 	Entero_Cero,
				Cadena_Vacia,			Entero_Cero, 	Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
			from CUENTASPERSONA ctap
		 where ctap.NombreCompleto = Par_Nombre;


		insert into BUSQUEDASEIDO(BusquedaSeidoID,		Nombre,			TipoBusqueda, 	ClienteID, 	CuentaAhoID,
									PersonaID, 			InversionID, 	BenefInverID, 	Fecha, 		SolicitudID,
									Tipo, 				Numero, 		EmpresaID, 		Usuario, 	FechaActual,
									DireccionIP, 		ProgramaID,		Sucursal,		NumTransaccion)

		select	Var_BusquedaSeidoID,	Par_Nombre,			RelacionadoInver, 	Entero_Cero,		Entero_Cero,
				Entero_Cero,			inv.InversionID,	ben.BenefInverID,	Var_FechaSistema,	Entero_Cero,
				Cadena_Vacia,			Entero_Cero,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				from  INVERSIONES inv
				inner join BENEFICIARIOSINVER  ben on inv.InversionID = ben.InversionID and inv.Estatus = Esta_Vigente
				inner join CLIENTES cli2 on ben.ClienteID = cli2.ClienteID and cli2.NombreCompleto = Par_Nombre;


		insert into BUSQUEDASEIDO(BusquedaSeidoID,		Nombre,			TipoBusqueda, 	ClienteID, 	CuentaAhoID,
									PersonaID, 			InversionID, 	BenefInverID, 	Fecha, 		SolicitudID,
									Tipo, 				Numero, 		EmpresaID, 		Usuario, 	FechaActual,
									DireccionIP, 		ProgramaID,		Sucursal,		NumTransaccion)

		select	Var_BusquedaSeidoID,	Par_Nombre,			RelacionadoInver, 	Entero_Cero,		Entero_Cero,
				Entero_Cero,			inv.InversionID,	ben.BenefInverID,	Var_FechaSistema,	Entero_Cero,
				Cadena_Vacia,			Entero_Cero,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				from  INVERSIONES inv
				inner join CLIENTES cli on inv.ClienteID = cli.ClienteID
				inner join BENEFICIARIOSINVER  ben on inv.InversionID = ben.InversionID and inv.Estatus = Esta_Vigente and  ben.NombreCompleto = Par_Nombre;


			insert into BUSQUEDASEIDO(BusquedaSeidoID,		Nombre,			TipoBusqueda, 	ClienteID, 	CuentaAhoID,
										PersonaID, 			InversionID, 	BenefInverID, 	Fecha, 		SolicitudID,
										Tipo, 				Numero, 		EmpresaID, 		Usuario, 	FechaActual,
										DireccionIP, 		ProgramaID,		Sucursal,		NumTransaccion)


			select 	Var_BusquedaSeidoID,	Par_Nombre,		Aval, 					Entero_Cero,		Entero_Cero,
					Entero_Cero,			Entero_Cero,	Entero_Cero,			Var_FechaSistema, 	cre.SolicitudCreditoID,
					Aval,					ava.AvalID,		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
					from AVALES ava
					inner join AVALESPORSOLICI avs on (ava.AvalID = avs.AvalID)
					inner join CREDITOS cre on avs.SolicitudCreditoID = cre.SolicitudCreditoID and (cre.Estatus = Credito_Vigente or cre.Estatus=Credito_Vencido)
					inner join CLIENTES cli on cre.ClienteID = cli.ClienteID
					where ava.NombreCompleto = Par_Nombre;


			insert into BUSQUEDASEIDO(BusquedaSeidoID,		Nombre,			TipoBusqueda, 	ClienteID, 	CuentaAhoID,
										PersonaID, 			InversionID, 	BenefInverID, 	Fecha, 		SolicitudID,
										Tipo, 				Numero, 		EmpresaID, 		Usuario, 	FechaActual,
										DireccionIP, 		ProgramaID,		Sucursal,		NumTransaccion)

			select 	Var_BusquedaSeidoID,	Par_Nombre,		Aval, 					Entero_Cero,		Entero_Cero,
					Entero_Cero,			Entero_Cero,	Entero_Cero,			Var_FechaSistema, 	avs.SolicitudCreditoID,
					Cliente,				cli.ClienteID,		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
					from CLIENTES cli
					inner join  AVALESPORSOLICI avs on  cli.ClienteID = avs.ClienteID
					inner join  CREDITOS cre on avs.SolicitudCreditoID = cre.solicitudCreditoID	and (cre.Estatus = Credito_Vigente or cre.Estatus = Credito_Vencido)
					where cli.NombreCompleto = Par_Nombre;

			insert into BUSQUEDASEIDO(BusquedaSeidoID,		Nombre,			TipoBusqueda, 	ClienteID, 	CuentaAhoID,
										PersonaID, 			InversionID, 	BenefInverID, 	Fecha, 		SolicitudID,
										Tipo, 				Numero, 		EmpresaID, 		Usuario, 	FechaActual,
										DireccionIP, 		ProgramaID,		Sucursal,		NumTransaccion)

			select 	Var_BusquedaSeidoID,Par_Nombre,			Aval, 				Entero_Cero,			Entero_Cero,
					Entero_Cero,		Entero_Cero,		Entero_Cero,		Var_FechaSistema, 		cre.SolicitudCreditoID,
					Prospecto,			pro.ProspectoID, 	Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
					from PROSPECTOS pro
						inner join AVALESPORSOLICI avs on pro.ProspectoID = avs.ProspectoID
						inner join CREDITOS cre on avs.SolicitudCreditoID = cre.SolicitudCreditoID
						where pro.NombreCompleto = Par_Nombre
						and cre.Estatus in(Credito_Vigente,Credito_Vencido);



	if not exists (select BusquedaSeidoID
			from BUSQUEDASEIDO WHERE BusquedaSeidoID= Var_BusquedaSeidoID AND TipoBusqueda =Cliente)then
		insert into BUSQUEDASEIDO(BusquedaSeidoID,		Nombre,			TipoBusqueda, 	ClienteID, 	CuentaAhoID,
								PersonaID, 			InversionID, 	BenefInverID, 	Fecha, 		SolicitudID,
								Tipo, 				Numero, 		EmpresaID, 		Usuario, 	FechaActual,
								DireccionIP, 		ProgramaID,		Sucursal,		NumTransaccion)
		select	Var_BusquedaSeidoID,	Par_Nombre,		Cliente, 		Entero_Cero,		Entero_Cero,
				Entero_Cero,			Entero_Cero,	Entero_Cero,	Var_FechaSistema, 	Entero_Cero,
				Cadena_Vacia,			Entero_Cero,	Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion;
	end if;

	if not exists (select BusquedaSeidoID
			from BUSQUEDASEIDO WHERE BusquedaSeidoID= Var_BusquedaSeidoID AND TipoBusqueda =RelacionadoCta)then
		insert into BUSQUEDASEIDO(BusquedaSeidoID,		Nombre,			TipoBusqueda, 	ClienteID, 	CuentaAhoID,
								PersonaID, 			InversionID, 	BenefInverID, 	Fecha, 		SolicitudID,
								Tipo, 				Numero, 		EmpresaID, 		Usuario, 	FechaActual,
								DireccionIP, 		ProgramaID,		Sucursal,		NumTransaccion)
		select	Var_BusquedaSeidoID,	Par_Nombre,		RelacionadoCta,	Entero_Cero,		Entero_Cero,
				Entero_Cero,			Entero_Cero,	Entero_Cero,	Var_FechaSistema, 	Entero_Cero,
				Cadena_Vacia,			Entero_Cero,	Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion;
	end if;

	if not exists (select BusquedaSeidoID
			from BUSQUEDASEIDO WHERE BusquedaSeidoID= Var_BusquedaSeidoID AND TipoBusqueda =RelacionadoInver)then
		insert into BUSQUEDASEIDO(BusquedaSeidoID,		Nombre,			TipoBusqueda, 	ClienteID, 	CuentaAhoID,
								PersonaID, 			InversionID, 	BenefInverID, 	Fecha, 		SolicitudID,
								Tipo, 				Numero, 		EmpresaID, 		Usuario, 	FechaActual,
								DireccionIP, 		ProgramaID,		Sucursal,		NumTransaccion)
		select	Var_BusquedaSeidoID,	Par_Nombre,		RelacionadoInver,	Entero_Cero,		Entero_Cero,
				Entero_Cero,			Entero_Cero,	Entero_Cero,		Var_FechaSistema, 	Entero_Cero,
				Cadena_Vacia,			Entero_Cero,	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion;
	end if;

	if not exists (select BusquedaSeidoID
				from BUSQUEDASEIDO WHERE BusquedaSeidoID= Var_BusquedaSeidoID AND TipoBusqueda =Aval)then
		insert into BUSQUEDASEIDO(BusquedaSeidoID,		Nombre,			TipoBusqueda, 	ClienteID, 	CuentaAhoID,
								PersonaID, 			InversionID, 	BenefInverID, 	Fecha, 		SolicitudID,
								Tipo, 				Numero, 		EmpresaID, 		Usuario, 	FechaActual,
								DireccionIP, 		ProgramaID,		Sucursal,		NumTransaccion)
		select	Var_BusquedaSeidoID,	Par_Nombre,		Aval,				Entero_Cero,		Entero_Cero,
				Entero_Cero,			Entero_Cero,	Entero_Cero,		Var_FechaSistema, 	Entero_Cero,
				Cadena_Vacia,			Entero_Cero,	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion;
	end if;

	set Par_NumErr  := 000;
	set Par_ErrMen  := concat('Busqueda Realizada Exitosamente.');
	set varControl	:= 'clienteID';

	  end ManejoErrores;
	if (Par_Salida = Salida_SI) then
	select  convert(Par_NumErr, char(3)) as NumErr,
			Par_ErrMen	 as ErrMen,
			varControl	 as control,
			Entero_Cero	 as consecutivo;
	end IF;
end TerminaStore$$