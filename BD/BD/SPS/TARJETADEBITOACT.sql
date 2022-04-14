-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARJETADEBITOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARJETADEBITOACT`;
DELIMITER $$


CREATE PROCEDURE `TARJETADEBITOACT`(
    Par_TarjetaDebID        char(16),
    Par_FechaActivacion     date,
    Par_ClienteID           int(11),
    Par_CuentaAhoID         bigint(12),
    Par_NombreTarjeta       varchar(250),
    Par_Relacion            char(1),
    Par_TipoTarjetaDebID    int(11),
    Par_TipoCuentaID        int(11),
	Par_TipoCobro			char(3),
    Par_NumAct              tinyint unsigned,

    Par_Salida              char(1),
    inout Par_NumErr        int,
    inout Par_ErrMen        varchar(400),

    Par_EmpresaID           int(11),
    Aud_Usuario             int(11),
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int(11),
    Aud_NumTransaccion      bigint(20)
	)

TerminaStore:BEGIN


DECLARE Var_ClienteID       int(11);
DECLARE Var_CuentaAhoID     bigint(12);
DECLARE Var_TiTarDebID      int(11);
DECLARE Var_TipoCuentaID    int(11);
DECLARE Var_Descripcion		varchar(150);
DECLARE Var_TarjetaDebID		char(16);
DECLARE var_TipoTitular		int(11);
DECLARE Var_IdentificaSocio	char(1);


DECLARE Con_ActAsociaCta		int;
DECLARE Entero_Cero			int;
DECLARE SalidaSI				char(1);
DECLARE SalidaNO				char(1);
DECLARE Cadena_Vacia			char(1);
DECLARE RelacionTitular		char(1);
DECLARE RelacionAdicional	char(1);
DECLARE ProcesoActualiza    int(11);
DECLARE Est_Importada       int(11);
DECLARE Est_Creada          int(11);
DECLARE Est_Entregada       int(11);
DECLARE Var_Estatus         int(11);
DECLARE Var_Procede         char(1);
DECLARE ProcedeNO           char(1);
DECLARE DescAsocia          varchar(50);
DECLARE Var_TipoTarDebID	int(11);
DECLARE Est_Asignado 		int(11);
DECLARE Est_Activa			int(11);
DECLARE Est_Bloqueado		int(11);
DECLARE EsIdentificador		char(1);
DECLARE Var_RelacionTD		char(1);

Set Entero_Cero         := 0;
Set SalidaSI            :='S';
Set SalidaNO            :='N';
Set Cadena_Vacia        := '';

set Est_Importada       := 1;
set Est_Creada          := 2;
set Est_Entregada       := 5;
set Est_Asignado        := 6;
Set Est_Activa			:= 7;
Set Est_Bloqueado		:= 8;

set Con_ActAsociaCta    := 1;
set RelacionTitular     :='T';
set RelacionAdicional   :='A';
Set Aud_FechaActual     := now();
Set ProcesoActualiza    := 2;
set ProcedeNO           := 'N';
set EsIdentificador		:="S";

	if(Par_NumAct = Con_ActAsociaCta) then
		select Descripcion,IdentificacionSocio
			INTO Var_Descripcion,Var_IdentificaSocio
			from  TIPOTARJETADEB
			where TipoTarjetaDebID = Par_TipoTarjetaDebID;



		SELECT ClienteID, CuentaAhoID, Estatus,
			CASE WHEN Estatus = Est_Importada OR Estatus = Est_Creada OR Estatus = Est_Entregada OR Estatus = Est_Asignado
				THEN 'S' ELSE 'N' END as Procede
            into Var_ClienteID, Var_CuentaAhoID, Var_Estatus, Var_Procede
            FROM TARJETADEBITO
            WHERE TipoTarjetaDebID = Par_TipoTarjetaDebID
            AND TarjetaDebID = Par_TarjetaDebID;

			SELECT TipoTarjetaDebID into Var_TipoTarDebID
				FROM TARJETADEBITO
				WHERE TarjetaDebID = Par_TarjetaDebID;

		if (Var_Procede = ProcedeNO) then
			if(Par_Salida = SalidaSI)then
				SELECT '001' as NumErr,
                    concat("La Tarjeta: ",cast(Par_TarjetaDebID as char), " no puede ser Asignada. Verifique su Estatus.")  as ErrMen,
                    'tipoTarjetaDebID' as control,
                    Par_TipoTarjetaDebID as consecutivo;
			else
                set Par_NumErr	:= 1;
                set Par_ErrMen := concat("La Tarjeta: ",cast(Par_TarjetaDebID as char), " no puede ser Asignada. Verifique su Estatus.");
            end if;
			LEAVE TerminaStore;
		end if;

		if(ifnull(Var_ClienteID,Entero_Cero) !=Entero_Cero)then
			if(Par_Salida = SalidaSI)then
				SELECT '002' as NumErr,
					concat("La Tarjeta ya esta Asociada a la Cuenta: ",cast(Var_CuentaAhoID as char))  as ErrMen,
					'tarjetaDebID' as control,
					Par_TipoTarjetaDebID as consecutivo;
			else
				Set Par_NumErr	:= 2;
				Set Par_ErrMen 	:= concat("La Tarjeta ya esta Asociada a la Cuenta: ",cast(Var_CuentaAhoID as char));
			end if;
			LEAVE TerminaStore;
		end if;

		if ( Par_TipoTarjetaDebID != Var_TipoTarDebID ) then
			if (Par_Salida = SalidaSI) then
				select	'003' as NumErr,
					concat("La Tarjeta de Debito: ",Par_TarjetaDebID, ", No se Puede Asociar al Tipo de Tarjeta Seleccionado.") as ErrMen,
					'tipoTarjetaDebID' as control,
					Par_TipoTarjetaDebID as consecutivo;
			else
				Set Par_NumErr	:= 3;
				Set Par_ErrMen 	:= concat("La Tarjeta de Debito: ",Par_TarjetaDebID, ", No se Puede Asociar al Tipo de Tarjeta Seleccionado.");
			end if;
			LEAVE TerminaStore;

		end if;

		SELECT TipoTarjetaDebID, TipoCuentaID       into Var_TiTarDebID, Var_TipoCuentaID
			from TIPOSCUENTATARDEB
			where 	TipoCuentaID	= Par_TipoCuentaID
			and TipoTarjetaDebID	= Par_TipoTarjetaDebID;

		if( ifnull(Var_TipoCuentaID,Entero_Cero) = Entero_Cero) then
			if (Par_Salida = SalidaSI) then
				select	'004' as NumErr ,
					concat("El Tipo de Tarjeta: ",Var_Descripcion, ", No se Puede Asociar al Tipo de Cuenta Indicado.") as ErrMen,
					'tipoTarjetaDebID' as control,
					Par_TipoTarjetaDebID as consecutivo;
			else
				Set Par_NumErr	:= 4;
				Set Par_ErrMen 	:= concat("El Tipo de Tarjeta: ",Var_Descripcion, ", No se Puede Asociar al Tipo de Cuenta Indicado.");
			end if;
			LEAVE TerminaStore;
		end if;

		SELECT TarjetaDebID     into Var_TarjetaDebID
			FROM TARJETADEBITO
			WHERE TarjetaDebID = Par_TarjetaDebID;

		if (ifnull(Var_TarjetaDebID,Cadena_Vacia) = Cadena_Vacia) then
			if (Par_Salida = SalidaSI) then
				SELECT '005' as NumErr,
					concat("La Tarjeta de Debito: ",Par_TarjetaDebID ,", No Existe.") as ErrMen,
					'tarjetaDebID' as control,
					Par_TipoTarjetaDebID as consecutivo;
			else
				Set Par_NumErr	:= 5;
				Set Par_ErrMen 	:= concat("La Tarjeta de Debito: ",Par_TarjetaDebID ,", No Existe.");
			end if;
			LEAVE TerminaStore;
		end if;

		SELECT TD.Relacion    into Var_RelacionTD
					FROM TARJETADEBITO TD
					inner join TIPOTARJETADEB Tip on Tip.TipoTarjetaDebID=TD.TipoTarjetaDebID
					WHERE TD.CuentaAhoID = Par_CuentaAhoID
					AND TD.Relacion = RelacionTitular
					AND ifnull(Tip.IdentificacionSocio,"N")="N"
					AND (TD.Estatus = Est_Asignado OR TD.Estatus = Est_Activa OR TD.Estatus = Est_Bloqueado);


		if ifnull(Var_RelacionTD,'')!="" then
			if(Par_Relacion= RelacionTitular and ifnull(Var_IdentificaSocio,"N")!=EsIdentificador)then
				if(Par_Salida = SalidaSI)then
					SELECT '007' as NumErr ,
						concat("La Cuenta: ",Par_CuentaAhoID ,", Ya tiene una Tarjeta con Relacion Titular.") as ErrMen,
						'tipoTarjetaDebID' as control,
						Par_TipoTarjetaDebID as consecutivo;
				else
					Set Par_NumErr	:= 7;
					Set Par_ErrMen 	:= 	concat("La Cuenta: ",Par_CuentaAhoID ,", Ya tiene una Tarjeta con Relacion Titular.");
				end if;
				LEAVE TerminaStore;
			end if;
		end if;

		if (Par_Relacion = RelacionAdicional ) then
			if  ifnull(Var_RelacionTD,'')="" then
				if(Par_Salida = SalidaSI)then
					select	'006' as NumErr ,
						concat("La Cuenta: ",Par_CuentaAhoID ,", No Tiene una Tarjeta con Relacion Titular.") as ErrMen,
						'tipoTarjetaDebID' as control,
						Par_TipoTarjetaDebID as consecutivo;
				else
					Set Par_NumErr	:= 6;
					Set Par_ErrMen 	:= concat("La Cuenta: ",Par_CuentaAhoID ,", No Tiene una Tarjeta con Relacion Titular.");
				end if;
				LEAVE TerminaStore;
			end if;


			SELECT TD.TipoTarjetaDebID , Tip.IdentificacionSocio into Var_TipoTarDebID,Var_IdentificaSocio
				FROM TARJETADEBITO TD
					 inner join TIPOTARJETADEB Tip on Tip.TipoTarjetaDebID=TD.TipoTarjetaDebID
				WHERE TD.CuentaAhoID = Par_CuentaAhoID
				AND TD.Relacion = 'T'
				AND ifnull(Tip.IdentificacionSocio,"N")="N"
				AND (TD.Estatus = Est_Asignado OR TD.Estatus = Est_Activa OR TD.Estatus = Est_Bloqueado);

			if (Var_TipoTarDebID != Par_TipoTarjetaDebID and ifnull(Var_IdentificaSocio,"N")!=EsIdentificador) then
				if(Par_Salida = SalidaSI)then
					select	'007' as NumErr ,
						concat("La Tarjeta de Debito: ",Par_TarjetaDebID ,", No Es del Mismo Tipo de Tarjeta al Titular.") as ErrMen,
						'tipoTarjetaDebID' as control,
						Par_TipoTarjetaDebID as consecutivo;
				else
					Set Par_NumErr	:= 7;
					Set Par_ErrMen 	:= concat("La Tarjeta de Debito: ",Par_TarjetaDebID ,", No Es del Mismo Tipo de Tarjeta al Titular.");
				end if;
				LEAVE TerminaStore;
			end if;
		end if;

		if (Var_IdentificaSocio=EsIdentificador and Par_Relacion = RelacionAdicional) then
			if(Par_Salida = SalidaSI)then
					select	'008' as NumErr ,
						concat("La Tarjeta de Debito: ",Par_TarjetaDebID ,", Es de Identificacion, no puede ser Adicional.") as ErrMen,
						'tipoTarjetaDebID' as control,
						Par_TipoTarjetaDebID as consecutivo;
				else
					Set Par_NumErr	:= 8;
					Set Par_ErrMen 	:= concat("La Tarjeta de Debito: ",Par_TarjetaDebID ,",  Es de Identificacion, no puede ser Adicional.");
				end if;
				LEAVE TerminaStore;
		end if;


		UPDATE TARJETADEBITO SET
			Estatus         =   Est_Asignado,
			ClienteID       =   Par_ClienteID,
			CuentaAhoID     =   Par_CuentaAhoID,
			NombreTarjeta   =   Par_NombreTarjeta,
			Relacion        =   Par_Relacion,
			TipoTarjetaDebID=   Par_TipoTarjetaDebID,
			TipoCobro		= 	Par_TipoCobro
			WHERE TarjetaDebID = Par_TarjetaDebID;


		Set DescAsocia := 'Asignada a Cuenta/Cliente';
		call BITACORATARDEBALT(
			Par_TarjetaDebID,   Est_Asignado,       Entero_Cero,        DescAsocia,         Par_FechaActivacion,
			Par_NombreTarjeta,  SalidaNO,           Par_NumErr,         Par_ErrMen,         Par_EmpresaID,
			Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
			Aud_NumTransaccion );




		if(Par_Salida = SalidaSI)then
			SELECT '000' as NumErr,
				concat("Tarjeta: ",cast(Par_TarjetaDebID as char) ," Asignada a: ",cast(Par_NombreTarjeta as char))  as ErrMen,
				'tipoTarjetaDebID' as control,
				Par_TipoTarjetaDebID as consecutivo;
		end if;
	end if;


END TerminaStore$$
