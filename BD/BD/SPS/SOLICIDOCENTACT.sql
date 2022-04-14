-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICIDOCENTACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICIDOCENTACT`;DELIMITER $$

CREATE PROCEDURE `SOLICIDOCENTACT`(
    Par_Solicitud           BIGINT(20),
    Par_ClasificaTipDocID   INT(11),
    Par_DocRecibido         CHAR(1),
    Par_TipoDocumentoID     INT(11),
    Par_Comentarios         Varchar(100),
    Par_TipAct              tinyint unsigned,

    Par_Salida              char(1),
    inout Par_NumErr        int,
    inout Par_ErrMen        varchar(400),
    Par_EmpresaID           int(11),
    Aud_Usuario             int,
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int,
    Aud_NumTransaccion      bigint(20)
		)
TerminaStore: BEGIN


                                    /*  Declaracion de Variables   */
DECLARE		Var_ProductoSol	       int(11);

                                    /*  Declaracion de   Constantes   */
DECLARE	Con_Cadena_Vacia				char(1);
DECLARE	Con_Fecha_Vacia				datetime;
DECLARE	Con_Entero_Cero				int(11);
DECLARE	Con_Str_SI					char(1);
DECLARE	Con_Str_NO					char(1);
DECLARE	Con_SolStaInactiva			char(1);
DECLARE	Con_TipoSolicitud			char(1);
DECLARE ClasificaAmbos				char(1);
DECLARE	Con_DocNoEntregado			int(11);
DECLARE	Con_TipActGrabarGrid			int(11);
DECLARE EstatusGuardado				char(1);

                                    /*  asignacion de Constantes   */
Set	Con_Cadena_Vacia					:= '';              -- Cadena Vacia
Set	Con_Fecha_Vacia					:= '1900-01-01';    -- Fecha Vacia
Set	Con_Entero_Cero					:= 0;               -- Entero Cero
Set	Con_Str_SI						:= 'S';             -- String de Si
Set	Con_Str_NO						:= 'N';             -- String de No
Set	Con_SolStaInactiva				:= 'I';             -- Estatus de Solicitud Inactiva
Set	Con_TipoSolicitud				:= 'S';             -- Tipo de Clasificacion para Solicitud
Set ClasificaAmbos					:= 'A';             -- Tipo de Clasificacion para Mesa de Control y Solicitudes (Ambos)
Set	Con_DocNoEntregado				:= 9999;            -- Documento No entregado
Set	Con_TipActGrabarGrid				:= 1;               -- Tipo de Actualizacion para grabar contenido de grid de Checklist de Solicitudes
set EstatusGuardado					:='P';				-- Estatus del Calculo = Guardado

Set	Aud_FechaActual					:= CURRENT_TIMESTAMP();

/* Inicializar parametros de salida */
Set	Par_NumErr  					:= 1;
set	Par_ErrMen  					:= Con_Cadena_Vacia;

if(ifnull(Par_Solicitud, Con_Entero_Cero))= Con_Entero_Cero then
    select  '001' as NumErr,
            'El numero de solicitud no es valido.' as ErrMen,
				'SolicitudCreditoID' as control,
				Con_Entero_Cero as consecutivo;
    LEAVE TerminaStore;
end if;


Set Var_ProductoSol := (select ProductoCreditoID from SOLICITUDCREDITO
                                    where SolicitudCreditoID = Par_Solicitud
                                      and Estatus = Con_SolStaInactiva);


if ifnull(Var_ProductoSol, Con_Entero_Cero) = Con_Entero_Cero then
    select  '002' as NumErr,
            concat("La Solicitud de Credito NO tiene estatus de Inactiva o no existe: ", convert(Par_Solicitud, char)) as ErrMen,
				'solicitudCreditoID' as control,
				Con_Entero_Cero as consecutivo;
    LEAVE TerminaStore;
end if;

if not exists(select SolicitudCreditoID from SOLICIDOCENT where SolicitudCreditoID = Par_Solicitud) then
    select  '003' as NumErr,
            concat("La Solicitud de Credito NO existe en el checklist: ", convert(Par_Solicitud, char)) as ErrMen,
				'solicitudCreditoID' as control,
				Con_Entero_Cero as consecutivo;
    LEAVE TerminaStore;
end if;


if not exists(  select Sol.SolDocReqID
                from SOLICIDOCREQ Sol,
                     CLASIFICATIPDOC Cla
                where Sol.ProducCreditoID = Var_ProductoSol
                  and Sol.ClasificaTipDocID = Cla.ClasificaTipDocID
                  and Cla.ClasificaTipo in (Con_TipoSolicitud, ClasificaAmbos)) then
    select  '004' as NumErr,
            concat("El producto de la solicitud no tiene checklist asignado ", convert(Var_ProductoSol, char)) as ErrMen,
				'productoCreditoID' as control,
				Con_Entero_Cero as consecutivo;
    LEAVE TerminaStore;
end if;

if Par_DocRecibido not in (Con_Str_SI, Con_Str_NO)  then
    select  '005' as NumErr,
            concat("El valor para Documento recibido no es valido: ", convert(Par_DocRecibido, char)) as ErrMen,
				'DocRecibido' as control,
				Con_Entero_Cero as consecutivo;
    LEAVE TerminaStore;
end if;

/* Actualizacion para grabar contenido de grid de Checklist de Solicitudes */
if Par_TipAct = Con_TipActGrabarGrid then
    if Par_DocRecibido = Con_Str_NO then
        set Par_Comentarios     := Con_Cadena_Vacia;
        set Par_TipoDocumentoID := Con_DocNoEntregado;
    else
        if not exists(select GrupoDocID
                        from CLASIFICAGRPDOC
                        where ClasificaTipDocID = Par_ClasificaTipDocID
                          and TipoDocumentoID = Par_TipoDocumentoID) then

            select '005' as NumErr,
                    concat("El documento no corresponde con la categoria indicada.") as ErrMen,
                    'DocRecibido' as control,
                    Con_Entero_Cero as consecutivo;
            LEAVE TerminaStore;

        end if;

        if  Par_TipoDocumentoID = Con_DocNoEntregado then
            select '006' as NumErr,
                    concat("El Documento seleccionado no es valido.") as ErrMen,
                    'TipoDocumentoID' as control,
                    Con_Entero_Cero as consecutivo;
            LEAVE TerminaStore;
        end if;

    end if;
	--  Ratios
	if exists(select ProducCreditoID
			from SOLICITUDCREDITO Sol
				inner join PRODUCTOSCREDITO Pro  on Pro.ProducCreditoID = Sol.ProductoCreditoID
				and CalculoRatios = Con_Str_SI
				and Sol.SolicitudCreditoID = Par_Solicitud)then
			if not Exists(select SolicitudCreditoID
								from RATIOS where SolicitudCreditoID = Par_Solicitud
									and Estatus = EstatusGuardado)then
				select '007' as NumErr,
						concat('Es Necesario Realizar el Calculo de Ratios para la solicitud: ',convert(Par_Solicitud, char)) as ErrMen,
						'solicitudCreditoID' as control,
						Con_Entero_Cero as consecutivo;
				LEAVE TerminaStore;
			end if;
	end if;

    update SOLICIDOCENT
    Set     Comentarios     = Par_Comentarios,
            TipoDocumentoID = Par_TipoDocumentoID,
            DocRecibido     = Par_DocRecibido,
            Usuario         = Aud_Usuario,
            FechaActual     = Aud_FechaActual,
            DireccionIP     = Aud_DireccionIP,
            ProgramaID      = Aud_ProgramaID,
            Sucursal        = Aud_Sucursal,
            NumTransaccion  = Aud_NumTransaccion
    where   SolicitudCreditoID  = Par_Solicitud
      and   ClasificaTipDocID   = Par_ClasificaTipDocID;

    set	Par_ErrMen := concat("Checklist de la solicitud: ", convert(Par_Solicitud, char)," fue grabado con Exito.");

end if;


set 	Par_NumErr := Con_Entero_Cero;

if(Par_Salida = Con_Str_SI) then
    select '000' as NumErr,
            Par_ErrMen  as ErrMen,
            'solicitudCreditoID' as control,
            Par_Solicitud as consecutivo;
end if;



END TerminaStore$$