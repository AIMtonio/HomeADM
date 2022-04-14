-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBSOLICALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBSOLICALT`;DELIMITER $$

CREATE PROCEDURE `TARDEBSOLICALT`(
    Par_TipoTransaccion     int(11),
    Par_CorpRelacionadoID   int(11),
    Par_ClienteID           int(11),
    Par_CuentaAhoID			bigint(12),
    Par_TipoTarjetaID       int(11),
    Par_NombreTarjeta       varchar(45),
    Par_Relacion            char(1),
    Par_Costo               decimal(13,2),

    Par_Salida              char(1),
    inout Par_NumErr        int(11),
    inout Par_ErrMen        varchar (350),

    Aud_EmpresaID           int(11),
    Aud_Usuario             int(11),
    Aud_FechaActual         DateTime,
    Aud_DireccionIP			varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int(11),
    Aud_NumTransaccion      bigint
)
TerminaStore: BEGIN
-- variables
DECLARE VarFolioID				  	int(11);
DECLARE Var_EstatusCancelado    	char;
DECLARE Var_TarjetaDebAntID     	char(16);
DECLARE Var_TipoTarjeta 		    int(11);
DECLARE Var_TipoTarDeb          	int(11);
DECLARE Var_Relacion			    char(1);
DECLARE Var_Status              	int(11);
DECLARE Var_ClasTarDeb          	char(1);
DECLARE Var_IdentSocio        		char(1);
-- Constantes
DECLARE Transaccion     char(1);
DECLARE Cadena_Vacia    char(1);
DECLARE Entero_Cero     int;
DECLARE TarNueva        int(11);
DECLARE TarReposicion   int(11);
DECLARE SalidaSI        char(1);
DECLARE SalidaNO        char(1);
DECLARE EstatusCanc     char;
DECLARE EstatusSolic    char(1);
DECLARE TransacNueva    char(1);
DECLARE TransacRepo     char(1);
DECLARE Est_Act         int(11);
DECLARE Est_Bloq        int(11);
DECLARE Est_Canc        int(11);
DECLARE Est_Exp         int(11);
DECLARE Es_Titular      char(1);
DECLARE Es_Adicional    char(1);
DECLARE IdentSocioSI    char(1);

-- Asignacion de Constantes
Set Cadena_Vacia    := '';
Set Entero_Cero     := 0;
set TarNueva        := 1;
set TarReposicion   := 2;
set SalidaSI        :='S';
set SalidaNO        := 'N';
set EstatusCanc     := 9;
set EstatusSolic    := 'S';
set Est_Act         := 7;
set Est_Bloq        :=8;
set Est_Canc        :=9;
set Est_Exp         :=10;
set Es_Titular      :='T';
set Es_Adicional    :='A';
set IdentSocioSI    := 'S';


set Var_IdentSocio := (SELECT IdentificacionSocio from TIPOTARJETADEB
						WHERE TipoTarjetaDebID  = Par_TipoTarjetaID);

	if(ifnull(Par_TipoTransaccion, Entero_Cero))= Entero_Cero then
		if(Par_Salida = SalidaSI)then
			select '001' as NumErr,
				'El Tipo de Movimiento esta Vacio.' as ErrMen,
				'corpRelacionado'  as control,
				Entero_Cero as consecutivo;
			LEAVE TerminaStore;
		end if;
		if(Par_Salida = SalidaNO)then
			set	 Par_NumErr := 1;
			set  Par_ErrMen := 'El Tipo de Movimiento esta Vacio.';
		end if;
	end if;

	if(ifnull(Par_ClienteID, Entero_Cero))= Entero_Cero then
		if(Par_Salida = SalidaSI)then
			select '002' as NumErr,
				'El Numero de Cliente esta Vacio.' as ErrMen,
				'clienteID'  as control,
				Par_ClienteID as consecutivo;
			LEAVE TerminaStore;
		end if;
		if(Par_Salida = SalidaNO)then
			set	 Par_NumErr := 2;
			set  Par_ErrMen := 'El Numero de Cliente esta Vacio.';
		end if;
	end if;

	if(ifnull(Par_CuentaAhoID, Entero_Cero))= Entero_Cero then
		if(Par_Salida = SalidaSI)then
			select '003' as NumErr,
				'Cuenta de Ahorro Vacio.' as ErrMen,
				'cuentaAhoID'  as control,
				Par_CuentaAhoID as consecutivo;
			LEAVE TerminaStore;
		end if;
		if(Par_Salida = SalidaNO)then
			set	 Par_NumErr := 3;
			set  Par_ErrMen := 'Cuenta de Ahorro esta Vacio.';
		end if;
	end if;

    if (Par_TipoTransaccion = TarNueva )then
        if(ifnull(Par_TipoTarjetaID, Entero_Cero))= Entero_Cero then
            if(Par_Salida = SalidaSI)then
                select '004' as NumErr,
                    'El Tipo de Tarjeta esta Vacio.' as ErrMen,
                    'tipoTarjetaDebID'  as control,
                Par_TipoTarjetaID as consecutivo;
                LEAVE TerminaStore;
            end if;
            if(Par_Salida = SalidaNO)then
                set Par_NumErr := 4;
                set  Par_ErrMen := 'El Tipo de Tarjeta esta Vacio';
            end if;
        end if;
    end if;

    if(ifnull(Par_NombreTarjeta, Cadena_Vacia))= Cadena_Vacia then
		if(Par_Salida = SalidaSI)then
			select '005' as NumErr,
				'Nombre de Tarjeta Vacia.' as ErrMen,
				'nombreClienteTar'  as control,
				Par_NombreTarjeta as consecutivo;
			LEAVE TerminaStore;
		end if;
		if(Par_Salida = SalidaNO)then
			set	 Par_NumErr := 5;
			set  Par_ErrMen := 'Nombre de Tarjeta Vacia.';
		end if;
	end if;

	if(ifnull(Par_Costo, Entero_Cero))= Entero_Cero then
		if(Par_Salida = SalidaSI)then
			select '006' as NumErr,
				'El Costo esta Vacio.' as ErrMen,
				'costo'  as control,
				Entero_Cero as consecutivo;
			LEAVE TerminaStore;
		end if;
		if(Par_Salida = SalidaNO)then
			set	 Par_NumErr := 6;
			set  Par_ErrMen :='El Costo esta Vacio.';
		end if;
	end if;

		if(Var_IdentSocio= IdentSocioSI) then
			if(Par_Salida = SalidaSI)then
				select '008' as NumErr,
					'El Tipo de Tarjeta es de Identificacion.' as ErrMen,
					'tipoTarjetaDebID'  as control,
					Entero_Cero as consecutivo;
				LEAVE TerminaStore;
			end if;
			if(Par_Salida = SalidaNO)then
				set	 Par_NumErr := 8;
				set  Par_ErrMen :='El Tipo de Tarjeta es de Identificacion.';
			end if;
		end if;


	if exists (SELECT * FROM TARJETADEBITO
						WHERE CuentaAhoID = Par_CuentaAhoID) then
					SELECT Estatus
							into Var_Status
							FROM TARJETADEBITO
								WHERE CuentaAhoID= Par_CuentaAhoID
									and Relacion='T';
	else set Var_status := Entero_Cero;
end if;
call FOLIOSAPLICAACT('SOLICITUDTARDEB', VarFolioID);

    if (Par_TipoTransaccion = TarNueva) then
        if (Var_Status =Est_Canc or Var_Status =Est_Act or Var_Status =Est_Bloq or Var_Status =Est_Exp or Var_Status = Cadena_Vacia )then -- Est_Act,Est_Bloq,Est_Canc,Est_Exp)then
            if (Par_Relacion = Es_Titular) then
                if exists (SELECT * FROM SOLICITUDTARDEB
                                WHERE CuentaAhoID = Par_CuentaAhoID and Relacion = 'T' and estatus ='S') then -- && 'G') then
                    if(Par_Salida = SalidaSI)then
                        select '007' as NumErr,
                            'La Cuenta ya Tiene una Tarjeta Nominativa Titular.' as ErrMen,
                            'cuentaAhoID'  as control,
                        Entero_Cero as consecutivo;
                        LEAVE TerminaStore;
                    end if;
                    if(Par_Salida = SalidaNO)then
                        set	 Par_NumErr := 7;
                        set  Par_ErrMen :='La Cuenta ya Tiene una Tarjeta Nominativa Titular.';
                    end if;
                else
                    Set TransacNueva = 'N';
                    INSERT INTO SOLICITUDTARDEB ( FolioSolicitudID, TipoSolicitud,    TarjetaDebAntID,CorpRelacionadoID,ClienteID,
									   CuentaAhoID,      TipoTarjetaDebID, NombreTarjeta,  Relacion,		 Costo,
									   FechaSolicitud,   Estatus,		   EmpresaID,      Usuario,          FechaActual,
									   DireccionIP,      ProgramaID,       Sucursal,       NumTransaccion)
							  VALUES(  VarFolioID ,		 TransacNueva, 		  Cadena_Vacia,	    Par_CorpRelacionadoID,	 Par_ClienteID,
									   Par_CuentaAhoID,  Par_TipoTarjetaID,   Par_NombreTarjeta,Par_Relacion,		     Par_Costo,
									   Aud_FechaActual,  EstatusSolic,        Aud_EmpresaID,	Aud_Usuario,	         Aud_FechaActual,
									   Aud_DireccionIP,  Aud_ProgramaID,      Aud_Sucursal,  	Aud_NumTransaccion);
                end if;
            else
                Set TransacNueva = 'N';
                INSERT INTO SOLICITUDTARDEB ( FolioSolicitudID, TipoSolicitud,    TarjetaDebAntID,CorpRelacionadoID,ClienteID,
									   CuentaAhoID,      TipoTarjetaDebID, NombreTarjeta,  Relacion,		 Costo,
									   FechaSolicitud,   Estatus,		   EmpresaID,      Usuario,          FechaActual,
									   DireccionIP,      ProgramaID,       Sucursal,       NumTransaccion)
							  VALUES(  VarFolioID ,		 TransacNueva, 		  Cadena_Vacia,		Par_CorpRelacionadoID,Par_ClienteID,
									   Par_CuentaAhoID,  Par_TipoTarjetaID,   Par_NombreTarjeta,Par_Relacion,		  Par_Costo,
									   Aud_FechaActual,  EstatusSolic,        Aud_EmpresaID,	Aud_Usuario,	      Aud_FechaActual,
									   Aud_DireccionIP,  Aud_ProgramaID,      Aud_Sucursal,  	Aud_NumTransaccion);
            end if;
        else
            if(Par_Salida = SalidaSI)then
                select '006' as NumErr,
                    'La Cuenta tiene una Tarjeta con un Estatus que no permite Solicitar.' as ErrMen,
                    'cuentaAhoID'  as control,
                    Entero_Cero as consecutivo;
                LEAVE TerminaStore;
            end if;
            if(Par_Salida = SalidaNO)then
                set	 Par_NumErr := 6;
                set  Par_ErrMen :='La Cuenta tiene una Tarjeta con un Estatus que no permite Solicitar.';
            end if;
        end if;
    end if;

    if (Par_TipoTransaccion = TarReposicion) then
        select Estatus into Var_EstatusCancelado
            from TARJETADEBITO
            where ClienteID=Par_ClienteID and  CuentaAhoID=Par_CuentaAhoID;

        if (Var_EstatusCancelado != EstatusCanc) then
            select	'006' as NumErr ,
                concat("La Tarjeta no esta Cancelada")  as ErrMen,
                'numeroTar'  as control,
                Entero_Cero as consecutivo;
            LEAVE TerminaStore;
        end if;
        if (Par_Relacion = Es_Titular) then
            if exists (SELECT * FROM SOLICITUDTARDEB
                        WHERE CuentaAhoID = Par_CuentaAhoID and Relacion = 'T' and estatus ='S') then -- && 'G') then
                if(Par_Salida = SalidaSI)then
                    select '007' as NumErr,
                        'La Cuenta ya Tiene una Solicitud de Tarjeta Nominativa Titular.' as ErrMen,
                        'cuentaAhoID'  as control,
                    Entero_Cero as consecutivo;
                    LEAVE TerminaStore;
                end if;
                if(Par_Salida = SalidaNO)then
                    set	 Par_NumErr := 7;
                    set  Par_ErrMen :='La Cuenta ya Tiene una Solicitud de Tarjeta Nominativa Titular.';
                end if;
            end if;
        end if;

        select TarjetaDebID,TipoTarjetaDebID
            into Var_TarjetaDebAntID,Var_TipoTarjeta
            from TARJETADEBITO
                where ClienteID=Par_ClienteID
                and CuentaAhoID=Par_CuentaAhoID ;

        if (Var_EstatusCancelado = EstatusCanc) then
            Set TransacRepo = 'R';
                INSERT INTO SOLICITUDTARDEB  (FolioSolicitudID, TipoSolicitud, TarjetaDebAntID,ClienteID,     CuentaAhoID,
										  TipoTarjetaDebID, NombreTarjeta, Relacion,	   Costo,         FechaSolicitud,
										  Estatus,          EmpresaID,     Usuario,        FechaActual,   DireccionIP,
										  ProgramaID,       Sucursal,      NumTransaccion)
									VALUES(
										  VarFolioID , 		  TransacRepo, 	 		Var_TarjetaDebAntID, Par_ClienteID,	   Par_CuentaAhoID	,
										  Var_TipoTarjeta,    Par_NombreTarjeta,    Par_Relacion, 		 Par_Costo,  	   Aud_FechaActual,
										  EstatusSolic,       Aud_EmpresaID,        Aud_Usuario,	     Aud_FechaActual,  Aud_DireccionIP,
										  Aud_ProgramaID,     Aud_Sucursal,  	    Aud_NumTransaccion);
        end if;
    end if;


	if(Par_Salida = SalidaSI)then
		select	'000' as NumErr ,
			concat("Tarjeta Solicitada con Folio ", convert(VarFolioID, CHAR))  as ErrMen,
			'folio'  as control,
			VarFolioID as consecutivo;
		else
		Set Par_NumErr := 0;
		Set Par_ErrMen := concat("Tarjeta Solicitada con Folio ", convert(VarFolioID, CHAR));
	end if;

END TerminaStore$$