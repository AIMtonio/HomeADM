-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICIDOCENTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICIDOCENTALT`;DELIMITER $$

CREATE PROCEDURE `SOLICIDOCENTALT`(
	Par_Solicitud		BIGINT(20),
	Par_Salida			char(1),
	inout Par_NumErr	int,
	inout Par_ErrMen	varchar(400),
	Par_EmpresaID		int(11),
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion  bigint(20)
	)
TerminaStore: BEGIN



DECLARE Var_ProductoSol	       int(11);
DECLARE Var_Control 			VARCHAR(20);


DECLARE Con_Cadena_Vacia        char(1);
DECLARE Con_Fecha_Vacia         datetime;
DECLARE Con_Entero_Cero         int(11);
DECLARE Con_Str_SI              char(1);
DECLARE Con_Str_NO              char(1);
DECLARE Con_SolStaInactiva      char(1);
DECLARE Con_TipoSolicitud       char(1);
DECLARE Con_ClasificaAmbos      char(1);
DECLARE Con_DocNoEntregado      int(11);


Set Con_Cadena_Vacia            := '';
Set Con_Fecha_Vacia             := '1900-01-01';
Set Con_Entero_Cero             := 0;
Set Con_Str_SI                  := 'S';
Set Con_Str_NO                  := 'N';
Set Con_SolStaInactiva          := 'I';
Set Con_TipoSolicitud           := 'S';
Set Con_ClasificaAmbos          := 'A';
Set Con_DocNoEntregado          := 9999;

ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
				set Par_NumErr := 999;
				set Par_ErrMen := concat('Estimado Usuario(a), Ha ocurrido una falla en el sistema, ' ,
							 'estamos trabajando para resolverla. Disculpe las molestias que ',
							 'esto le ocasiona. Ref: SP-SOLICIDOCENTALT');
			END;

if(ifnull(Par_Solicitud, Con_Entero_Cero))= Con_Entero_Cero then
				set Par_NumErr := 001;
				set Par_ErrMen := 'El numero de solicitud no es valido.' ;
                set Var_Control := 'solicitudCreditoID';
    LEAVE ManejoErrores;
end if;


Set Var_ProductoSol := (select ProductoCreditoID from SOLICITUDCREDITO
                                    where SolicitudCreditoID = Par_Solicitud
                                      and Estatus = Con_SolStaInactiva);

if ifnull(Var_ProductoSol, Con_Entero_Cero) = Con_Entero_Cero then
				set Par_NumErr := 002;
				set Par_ErrMen := concat("La Solicitud de Credito NO tiene estatus de Inactiva o no existe: ", convert(Par_Solicitud, char));
                set Var_Control := 'solicitudCreditoID';
    LEAVE ManejoErrores;
end if;

if exists(select SolicitudCreditoID from SOLICIDOCENT where SolicitudCreditoID = Par_Solicitud) then
				set Par_NumErr := 003;
				set Par_ErrMen := concat("La Solicitud de Credito ya existe en el checklist: ", convert(Par_Solicitud, char));
                set Var_Control := 'solicitudCreditoID';
    LEAVE ManejoErrores;
end if;


if not exists(  select Sol.SolDocReqID
                from SOLICIDOCREQ Sol,
                     CLASIFICATIPDOC Cla
                where Sol.ProducCreditoID = Var_ProductoSol
                  and Sol.ClasificaTipDocID = Cla.ClasificaTipDocID
                  and Cla.ClasificaTipo in (Con_TipoSolicitud, Con_ClasificaAmbos)) then
				set Par_NumErr := 004;
				set Par_ErrMen := concat("El producto de la solicitud no tiene checklist asignado ", convert(Var_ProductoSol, char));
                set Var_Control := 'productoCreditoID';
    LEAVE ManejoErrores;
end if;



insert into SOLICIDOCENT (
		SolicitudCreditoID, ProducCreditoID, 	ClasificaTipDocID, 		DocRecibido, 		TipoDocumentoID,
        Comentarios, 		EmpresaID, 			Usuario, 				FechaActual, 		DireccionIP,
        ProgramaID, 		Sucursal, 			NumTransaccion)
select  Par_Solicitud,      Var_ProductoSol,    Sol.ClasificaTipDocID,  Con_Str_NO,         Con_DocNoEntregado,
        Con_Cadena_Vacia,   Par_EmpresaID,      Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,    	Aud_Sucursal,       Aud_NumTransaccion
from    SOLICIDOCREQ Sol,
        CLASIFICATIPDOC Cla
where Sol.ProducCreditoID = Var_ProductoSol
  and Sol.ClasificaTipDocID = Cla.ClasificaTipDocID
  and Cla.ClasificaTipo in (Con_TipoSolicitud, Con_ClasificaAmbos);


set Par_NumErr := Con_Entero_Cero;
set	Par_ErrMen := concat("La Solicitud de Credito: ", convert(Par_Solicitud, char)," fue incluida en el checklist.");
set Var_Control := 'solicitudCreditoID';

END ManejoErrores;

if(Par_Salida = Con_Str_SI) then
    select 	Par_NumErr as NumErr,
            Par_ErrMen  as ErrMen,
            Var_Control as control,
            Par_Solicitud as consecutivo;
end if;

END TerminaStore$$