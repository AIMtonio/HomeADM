-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDCREDITOBEMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDCREDITOBEMOD`;DELIMITER $$

CREATE PROCEDURE `SOLICITUDCREDITOBEMOD`(
	Par_Solicitud       int,
	Par_ProspectoID     bigint(20),
	Par_ClienteID       int,

   Par_InstitNominaID  int(11),
   Par_NegocioAfiliadoID int(11),
   Par_FolioCtrl         varchar(20),

	Par_Salida          char(1),
	inout Par_NumErr    int,
	inout Par_ErrMen    varchar(400),
	Par_EmpresaID       int(11),
	Aud_Usuario         int,
	Aud_FechaActual     DateTime,
	Aud_DireccionIP     varchar(15),
	Aud_ProgramaID      varchar(50),
	Aud_Sucursal        int,
	Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN


DECLARE Var_ClienteID   int(11);
DECLARE Var_ProspectoID int(11);


Declare Entero_Cero     int;
Declare Cadena_Vacia    char(1);
Declare SalidaNO        char(1);
Declare SalidaSI        char(1);


set Entero_Cero     := 0;
set Cadena_Vacia    := '';
Set SalidaSI        := 'S';
Set SalidaNO        := 'N';


if(Par_ProspectoID = Entero_Cero and Par_ClienteID = Entero_Cero) then
	select '001' as NumErr,
		'El Prospecto o Cliente estan vacios.' as ErrMen,
		'prospectoID' as control,
		Entero_Cero as consecutivo;
	LEAVE TerminaStore;
else
	if(Par_ProspectoID <> Entero_Cero) then
		set Var_ProspectoID := (select ProspectoID
								from PROSPECTOS
								where ProspectoID = Par_ProspectoID );

	if(ifnull(Var_ProspectoID, Entero_Cero))= Entero_Cero then
			select '002' as NumErr,
				'El prospecto indicado no Existe.' as ErrMen,
				'prospectoID' as control,
				Entero_Cero as consecutivo;
			LEAVE TerminaStore;
		end if;
	else
		if(Par_ClienteID <> Entero_Cero) then
			set Var_ClienteID := (select ClienteID
									from CLIENTES
									where ClienteID = Par_ClienteID );

			if(ifnull(Var_ClienteID, Entero_Cero))= Entero_Cero then
				select '003' as NumErr,
					'El cliente indicado no Existe.' as ErrMen,
					'clienteID' as control,
					Entero_Cero as consecutivo;
				LEAVE TerminaStore;
			end if;

		end if;

	end if;

end if;

if(ifnull(Par_InstitNominaID, Entero_Cero))= Entero_Cero then
	select '004' as NumErr,
		'La Empresa de Nomina no debe estar Vacia.' as ErrMen,
		'institNominaID' as control,
		Entero_Cero as consecutivo;
	LEAVE TerminaStore;
end if;


set Par_FolioCtrl    := ifnull(Par_FolioCtrl, Cadena_Vacia);


if(ifnull(Par_ClienteID, Entero_Cero))= Entero_Cero then

update	SOLICITUDCREDITOBE	set


   InstitNominaID  = Par_InstitNominaID,
   FolioCtrl       = Par_FolioCtrl,


	EmpresaID           	= Par_EmpresaID,
	Usuario             	= Aud_Usuario,
	FechaActual         	= Aud_FechaActual,
	DireccionIP         	= Aud_DireccionIP,
	ProgramaID          	= Aud_ProgramaID,
    NumTransaccion      	= Aud_NumTransaccion

    where SolicitudCreditoID    = Par_Solicitud &&
           ClienteID            = Par_ProspectoID ;

end if;


if(ifnull(Par_ProspectoID, Entero_Cero))= Entero_Cero then

update	SOLICITUDCREDITOBE	set


    InstitNominaID  = Par_InstitNominaID,
    FolioCtrl       = Par_FolioCtrl,


	EmpresaID        = Par_EmpresaID,
	Usuario          = Aud_Usuario,
	FechaActual      = Aud_FechaActual,
	DireccionIP      = Aud_DireccionIP,
	ProgramaID       = Aud_ProgramaID,
    NumTransaccion  = Aud_NumTransaccion

    where SolicitudCreditoID    = Par_Solicitud &&
           ClienteID            = Par_ClienteID;

end if;

if(Par_Salida =SalidaSI) then
        select  '000' as NumErr,
                   concat("Solicitud de Credito Modificada Exitosamente: ",convert(Par_Solicitud,char)) as ErrMen,
                'solicitudCreditoID' as control,
                Par_Solicitud as consecutivo;
end if;


END TerminaStore$$