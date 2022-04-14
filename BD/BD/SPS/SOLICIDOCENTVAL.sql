-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICIDOCENTVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICIDOCENTVAL`;DELIMITER $$

CREATE PROCEDURE `SOLICIDOCENTVAL`(
    Par_Solicitud       BIGINT(20),
    Par_Grupo           INT(11),
    Par_TipVal          INT(11),
    inout Par_CheckComple    CHAR(1),

    Par_Salida          char(1),
    inout Par_NumErr    int,
    inout Par_ErrMen    varchar(400),
    Par_EmpresaID       int(11),
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint(20)

	)
TerminaStore: BEGIN


DECLARE     Var_Solicitud           BIGINT(20);
DECLARE     Var_SoliciCheckIncomp   varchar(150);




DECLARE     Con_Cadena_Vacia        char(1);
DECLARE     Con_Fecha_Vacia         datetime;
DECLARE     Con_Entero_Cero         int(11);
DECLARE     Con_Str_SI              char(1);
DECLARE     Con_Str_NO              char(1);
DECLARE     Con_SolStaInactiva      char(1);
DECLARE     Con_TipoSolicitud       char(1);
DECLARE     Con_TipValSolInd        int(11);
DECLARE     Con_TipValSolGrup       int(11);


DECLARE Cur_Grupos CURSOR FOR
    SELECT SolGrp.SolicitudCreditoID
    FROM INTEGRAGRUPOSCRE SolGrp
    inner join SOLICITUDCREDITO Sol on Sol.SolicitudCreditoID =  SolGrp.SolicitudCreditoID and Sol.Estatus = Con_SolStaInactiva
    where SolGrp.GrupoID = Par_Grupo
    order by SolGrp.SolicitudCreditoID;



Set     Con_Cadena_Vacia        := '';
Set     Con_Fecha_Vacia         := '1900-01-01';
Set     Con_Entero_Cero         := 0;
Set     Con_Str_SI              := 'S';
Set     Con_Str_NO              := 'N';
Set     Con_SolStaInactiva      := 'I';
Set     Con_TipoSolicitud       := 'S';


Set     Con_TipValSolInd        := 1;
Set     Con_TipValSolGrup       := 2;


Set     Par_NumErr              := 1;
Set     Par_ErrMen              := Con_Cadena_Vacia;
Set     Var_SoliciCheckIncomp   := Con_Cadena_Vacia;


Set     Par_CheckComple := Con_Str_NO;




if Par_TipVal = Con_TipValSolInd then
    if(ifnull(Par_Solicitud, Con_Entero_Cero))= Con_Entero_Cero then
        set Par_ErrMen  := 'El numero de solicitud no es valido.';
        if Par_Salida = Con_Str_SI then
            select  '001' as NumErr,
                     Par_ErrMen as ErrMen,
                    'solicitudCreditoID' as control,
                    Con_Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end if;

    if not exists(select SolicitudCreditoID from SOLICIDOCENT where SolicitudCreditoID = Par_Solicitud) then
        set Par_ErrMen  := concat("La Solicitud de Credito ",convert(Par_Solicitud, char)," no existe en el checklist.");
        if Par_Salida = Con_Str_SI then
            select  '002' as NumErr,
                    Par_ErrMen as ErrMen,
                    'solicitudCreditoID' as control,
                    Con_Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end if;

    if exists(  select SolicitudCreditoID
                from SOLICIDOCENT
                where SolicitudCreditoID = Par_Solicitud
                  and DocRecibido = Con_Str_NO) then

        Set     Par_CheckComple := Con_Str_NO;
        Set     Par_NumErr  := 0;
        Set     Par_ErrMen  := concat("La Solicitud de Credito no tiene su checklist Completo: ", convert(Par_Solicitud, char));

        if Par_Salida = Con_Str_SI then
            select  '000' as NumErr,
                    Par_ErrMen as ErrMen,
                    'solicitudCreditoID' as control,
                    Par_Solicitud as consecutivo;
        end if;
        LEAVE TerminaStore;

    else
        Set     Par_CheckComple := Con_Str_SI;
        Set     Par_NumErr  := 0;
        Set     Par_ErrMen  := concat("Solicitud de Credito ",convert(Par_Solicitud, char)," con checklist Completo.");

        if Par_Salida = Con_Str_SI then
            select  '000' as NumErr,
                    Par_ErrMen as ErrMen,
                    'solicitudCreditoID' as control,
                    Par_Solicitud as consecutivo;
        end if;
        LEAVE TerminaStore;

    end if;
end if;




if Par_TipVal = Con_TipValSolGrup then
    if(ifnull(Par_Grupo, Con_Entero_Cero))= Con_Entero_Cero then
        Set     Par_ErrMen  := 'El numero de Grupo no es valido.';
        if Par_Salida = Con_Str_SI then
            select  '003' as NumErr,
                    Par_ErrMen as ErrMen,
                    'GrupoID' as control,
                    Con_Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end if;

    if not exists(select GrupoID from GRUPOSCREDITO where GrupoID = Par_Grupo) then
         Set     Par_ErrMen  := concat("El Grupo ",convert(Par_Grupo, char)," de Solicitudes no existe.");
        if Par_Salida = Con_Str_SI then
            select  '004' as NumErr,
                    Par_ErrMen as ErrMen,
                    'GrupoID' as control,
                    Con_Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end if;

    if( SELECT count(SolGrp.SolicitudCreditoID)
        FROM INTEGRAGRUPOSCRE SolGrp
        where GrupoID = Par_Grupo) <= Con_Entero_Cero then
        Set     Par_ErrMen  := concat("El Grupo ",convert(Par_Grupo, char)," no tiene Solicitudes Asignadas.");
        if Par_Salida = Con_Str_SI then
            select  '005' as NumErr,
                    Par_ErrMen as ErrMen,
                    'GrupoID' as control,
                    Con_Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end if;

    set Par_ErrMen  := Con_Cadena_Vacia;

    OPEN Cur_Grupos;
    BEGIN
        DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        cicloCur_Grupos: LOOP
            FETCH Cur_Grupos INTO Var_Solicitud;

            if not exists(select SolicitudCreditoID from SOLICIDOCENT where SolicitudCreditoID = Var_Solicitud) then
                Set     Par_ErrMen  := concat("La Solicitud de Credito ", convert(Var_Solicitud, char), " no existe en el checklist.");
                if Par_Salida = Con_Str_SI then
                    select  '006' as NumErr,
                             Par_ErrMen as ErrMen,
                            'solicitudCreditoID' as control,
                            Var_Solicitud as consecutivo;
                end if;
                LEAVE cicloCur_Grupos;
            end if;

            if exists(  select SolicitudCreditoID
                        from SOLICIDOCENT
                        where SolicitudCreditoID = Var_Solicitud
                          and DocRecibido = Con_Str_NO) then

                if Var_SoliciCheckIncomp = Con_Cadena_Vacia then
                    Set     Var_SoliciCheckIncomp := convert(Var_Solicitud, char);
                else
                    Set     Var_SoliciCheckIncomp := concat(Var_SoliciCheckIncomp, ",", convert(Var_Solicitud, char));
                end if;
            end if;

        END LOOP cicloCur_Grupos;
    END;
    Close Cur_Grupos;

    if Par_ErrMen <> Con_Cadena_Vacia then
         LEAVE TerminaStore;
    end if;

    if Var_SoliciCheckIncomp = Con_Cadena_Vacia then
        Set     Par_CheckComple := Con_Str_SI;
        Set     Par_ErrMen      := concat("El Grupo ",convert(Par_Grupo, char)," tiene Todas las Solicitudes con checklist Completo");
    else
        Set     Par_CheckComple := Con_Str_NO;
        Set     Par_ErrMen      := concat("El Grupo ",convert(Par_Grupo, char)," tiene CheckList Incompleto, para las Solicitudes: ", Var_SoliciCheckIncomp);

    end if;

    Set     Par_NumErr      := 0;
    if Par_Salida = Con_Str_SI then
        select  '000' as NumErr,
                Par_ErrMen as ErrMen,
                'grupoID' as control,
                Par_Grupo as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;


END TerminaStore$$