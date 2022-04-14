-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONDEOSOLICITUDACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONDEOSOLICITUDACT`;DELIMITER $$

CREATE PROCEDURE `FONDEOSOLICITUDACT`(
	Par_SolicCredID		bigint(20),
	Par_ClienteID       	int(11),
	Par_CuentaAhoID	  	bigint(12),
	Par_MontoFondeo     	decimal(12,2),
	Par_NumAct			tinyint unsigned,
	Par_Salida			char (1),

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia		char(1);
DECLARE	Decimal_Cero		decimal (12,4);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Act_Cancelar		int;
DECLARE	Estatus_Can		char(1);
DECLARE	Salida_SI		char(1);


DECLARE	Var_Estatus		char(1);


Set Cadena_Vacia		:= '';
Set Decimal_Cero		:= 0.0;
Set Fecha_Vacia		:= '1900-01-01';
Set Entero_Cero		:= 0;
Set Act_Cancelar		:= 2;
Set Estatus_Can		:= 'C';
Set Salida_SI			:= 'S';


Set Var_Estatus := (select Estatus
					from FONDEOSOLICITUD
					where SolicitudCreditoID= Par_SolicCredID
						and ClienteID= Par_ClienteID
						and CuentaAhoID= Par_CuentaAhoID
						and MontoFondeo = Par_MontoFondeo);

if(ifnull(Par_SolicCredID, Entero_Cero))= Entero_Cero then
	select '001' as NumErr,
		 'El numero de Solicitud de Credito esta Vacio.' as ErrMen,
		 'SolicitudCreditoID' as control,
		 Entero_Cero as consecutivo;
	LEAVE TerminaStore;
end if;


if(ifnull(Par_ClienteID, Entero_Cero))= Entero_Cero then
        select '002' as NumErr,
                 'El numero de Cliente esta vacio.' as ErrMen,
                 'clienteID' as control,NumConsecutivo as consecutivo,
		 Entero_Cero as consecutivo;
        LEAVE TerminaStore;
end if;

if(ifnull(Par_CuentaAhoID, Entero_Cero))= Entero_Cero then
        select '003' as NumErr,
                 'Especifique Cuenta de Ahorro.' as ErrMen,
                 'cuentaAhoID' as control,NumConsecutivo as consecutivo,
		 Entero_Cero as consecutivo;
        LEAVE TerminaStore;
end if;

if(ifnull(Par_MontoFondeo, Decimal_Cero))= Decimal_Cero then
        select '004' as NumErr,
                 'El monto de fondeo esta vacio.' as ErrMen,
                 'MontoFondeo' as control,NumConsecutivo as consecutivo,
		 Entero_Cero as consecutivo;
        LEAVE TerminaStore;
end if;


if(not exists(select SolicitudCreditoID
			from FONDEOSOLICITUD
			where SolicitudCreditoID = Par_SolicCredID)) then
	select '005' as NumErr,
		 'El Numero de Solicitud no existe no existe.' as ErrMen,
		 'solicitudCreditoID' as control,
		 Entero_Cero as consecutivo;
	LEAVE TerminaStore;
end if;



if(Par_NumAct = Act_Cancelar) then
	if(Var_Estatus = Estatus_Can) then
		select '006' as NumErr,
			 'La Solicitud de Fondeo ya estaba Cancelada.' as ErrMen,
			 'SolicitudCreditoID' as control,
		 Entero_Cero as consecutivo;
		LEAVE TerminaStore;
	end if;

	update FONDEOSOLICITUD set
		Estatus  		= Estatus_Can,
		EmpresaID		= Aud_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual 		= Aud_FechaActual,
		DireccionIP 		= Aud_DireccionIP,
		ProgramaID  		= Aud_ProgramaID,
		Sucursal			= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	where SolicitudCreditoID= Par_SolicCredID
	and ClienteID= Par_ClienteID
	and CuentaAhoID= Par_CuentaAhoID
	and MontoFondeo = Par_MontoFondeo;

	if (Par_Salida = Salida_SI) then
		select '000' as NumErr ,
		  'Solicitud de Fondeo Cancelada' as ErrMen,
		  'Par_SolicCredID' as control,
		 Entero_Cero as consecutivo;
	end if;

end if;


END TerminaStore$$