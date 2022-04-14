-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISSOCIODEMOCONALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISSOCIODEMOCONALT`;
DELIMITER $$

CREATE PROCEDURE `HISSOCIODEMOCONALT`(
    Par_Prospecto              INT(11),
    Par_Cliente                INT(11),

    Par_Salida                 char(1),
    inout Par_NumErr           int(11),
    inout Par_ErrMen           varchar(400),

    Aud_EmpresaID              int(11),
    Aud_Usuario                int(11),
    Aud_FechaActual            DateTime,
    Aud_DireccionIP            varchar(15),
    Aud_ProgramaID             varchar(50),
    Aud_Sucursal               int(11),
    Aud_NumTransaccion         bigint(20)
	)
TerminaStore: BEGIN


DECLARE Var_FechaHistorico      DATE;
DECLARE Var_Consecutivo         INT(11);


DECLARE Cadena_Vacia            char(1);
DECLARE Fecha_Vacia             datetime;
DECLARE Entero_Cero             int(11);
DECLARE Str_SI                  char(1);
DECLARE Str_NO                  char(1);
DECLARE Baj_PorCliProspe        int(11);
DECLARE Var_TipoPersonaCta      CHAR(1);
DECLARE CliProEsp           INT(11);
DECLARE CliCrediClub        INT(11);
DECLARE EsNA                CHAR(2);

DECLARE Var_ClienteConyID       INT(11);
DECLARE Var_PrimerNom           VARCHAR(25);
DECLARE Var_SegundoNom          VARCHAR(25);

DECLARE Var_TercerNom           VARCHAR(25);
DECLARE Var_ApellidoPat        VARCHAR(30);
DECLARE Var_ApellidoMat        VARCHAR(30);

DECLARE Var_PaisNac             INT(11);

DECLARE Var_EstadoID            INT(11);
DECLARE Var_FechaNac            DATE;
DECLARE Var_RFC                 VARCHAR(13);
DECLARE DescripOpera        VARCHAR(52);
DECLARE CatMotivInusualID   VARCHAR(15);
DECLARE CatProcIntID        VARCHAR(10);
DECLARE RegistraSAFI        CHAR(4);
DECLARE ClaveRegistra       CHAR(2);
DECLARE Var_FechaDeteccion  DATE;
DECLARE Var_OpeInusualID    BIGINT(20);
DECLARE Con_LPB             CHAR(3);
DECLARE Var_SoloApellido    VARCHAR(150);
DECLARE Var_SoloNombre      VARCHAR(150);
DECLARE Var_OpeInusualIDSPL BIGINT(20);
DECLARE Var_ErrMen          VARCHAR(400);
DECLARE Var_RFCOficial      VARCHAR(13);
DECLARE Var_NombreCompleto  VARCHAR(300);



Set Cadena_Vacia            := '';
Set Fecha_Vacia             := '1900-01-01';
Set Entero_Cero             := 0;
Set Str_SI                  := 'S';
Set Str_NO                  := 'N';
Set Baj_PorCliProspe        := 1;
SET CliProEsp               := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'CliProcEspecifico');
SET CliCrediClub            := '24';
SET EsNA                    := 'NA';



Set Aud_FechaActual         := CURRENT_TIMESTAMP();


Set Par_NumErr              := 1;
set Par_ErrMen              := Cadena_Vacia;

Set Var_FechaHistorico      :=  (select FechaSistema from PARAMETROSSIS);

SET DescripOpera            :='LISTA DE PERSONAS BLOQUEADAS';   -- Comentario en operaciones de alta o modificacion de clientes
SET CatMotivInusualID       :='LISBLOQ';        -- Clave interna motivo Tabla catalogo PLDCATMOTIVINU: LISTAS PERSONAS BLOQUEADAS
SET CatProcIntID            :='PR-SIS-000';     -- Clave interna
SET RegistraSAFI            := 'SAFI';          -- Clave que registra la operacion
SET ClaveRegistra           := '3';             -- Clave del tipo de persona que detecta la operacion  (1.-personal interno  2.-personal externo  3.-sistema automatico)
SET Var_FechaDeteccion      := (SELECT FechaSistema FROM PARAMETROSSIS);
SET Con_LPB                 := 'LPB';           -- Inidica que es de lista de personas bloqueadas


if (Par_Prospecto = Entero_Cero and Par_Cliente = Entero_Cero) then
    Set Par_ErrMen  := 'Numero de Cliente y Prospecto no son validos.';
    if(Par_Salida = Str_SI) then
            select '001' as NumErr,
                Par_ErrMen as ErrMen,
                'clienteID' as control,
             Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;


if Par_Cliente > Entero_Cero then
    if not exists(select ClienteID from CLIENTES where ClienteID = Par_Cliente) then
        Set Par_ErrMen  := 'El Numero de Cliente no Existe';
        if(Par_Salida = Str_SI) then
                select '002' as NumErr,
                        Par_ErrMen as ErrMen,
                        'clienteID' as control,
                        Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end If;
else
    if not exists(select ProspectoID from PROSPECTOS where ProspectoID = Par_Prospecto) then
        Set Par_ErrMen  := 'El Numero de Prospecto no Existe';
        if(Par_Salida = Str_SI) then
                select '003' as NumErr,
                        Par_ErrMen as ErrMen,
                        'prospectoID' as control,
                        Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end If;
end if;

if Par_Cliente > Entero_Cero then
    SELECT  ClienteConyID,      PrimerNombre,            SegundoNombre,         TercerNombre,       ApellidoPaterno,
            ApellidoMaterno,    PaisNacimiento,          EstadoNacimiento,      FechaNacimiento,    RFC
    INTO    Var_ClienteConyID,  Var_PrimerNom,           Var_SegundoNom,        Var_TercerNom,      Var_ApellidoPat,
            Var_ApellidoMat,    Var_PaisNac,             Var_EstadoID,          Var_FechaNac,       Var_RFC       
    FROM SOCIODEMOCONYUG
    where ClienteID = Par_Cliente;
else
    SELECT  ClienteConyID,      PrimerNombre,            SegundoNombre,         TercerNombre,       ApellidoPaterno,
            ApellidoMaterno,    PaisNacimiento,          EstadoNacimiento,      FechaNacimiento,    RFC
    INTO    Var_ClienteConyID,  Var_PrimerNom,           Var_SegundoNom,        Var_TercerNom,      Var_ApellidoPat,
            Var_ApellidoMat,    Var_PaisNac,             Var_EstadoID,          Var_FechaNac,       Var_RFC
    FROM SOCIODEMOCONYUG
    where ProspectoID = Par_Prospecto;
end if;


    SET Var_ClienteConyID := IFNULL(Var_ClienteConyID,Entero_Cero);
    SET Var_PrimerNom := IFNULL(Var_PrimerNom,Cadena_Vacia);
    SET Var_SegundoNom := IFNULL(Var_SegundoNom,Cadena_Vacia);
    SET Var_TercerNom := IFNULL(Var_TercerNom,Cadena_Vacia);
    SET Var_ApellidoPat := IFNULL(Var_ApellidoPat,Cadena_Vacia);
    SET Var_ApellidoMat := IFNULL(Var_ApellidoMat,Cadena_Vacia);
    SET Var_PaisNac := IFNULL(Var_PaisNac,Entero_Cero);
    SET Var_EstadoID := IFNULL(Var_EstadoID,Entero_Cero);
    SET Var_FechaNac := IFNULL(Var_FechaNac,Fecha_Vacia);
    SET Var_RFC := IFNULL(Var_RFC,Cadena_Vacia);

    SET Var_SoloNombre          :=  FNGENNOMBRECOMPLETO(Var_PrimerNom, Var_SegundoNom,Var_TercerNom,Cadena_Vacia,Cadena_Vacia);
    SET Var_SoloApellido        :=  FNGENNOMBRECOMPLETO(Cadena_Vacia, Cadena_Vacia,Cadena_Vacia,Var_ApellidoPat,Var_ApellidoMat);
    SET Var_NombreCompleto      :=  FNGENNOMBRECOMPLETO(Var_PrimerNom, Var_SegundoNom,Var_TercerNom,Var_ApellidoPat,Var_ApellidoMat);

    SET Var_TipoPersonaCta := 'F'; 
    IF( CliProEsp <> CliCrediClub) THEN
        /*SECCION PLD: Deteccion de operaciones inusuales*/

        CALL PLDDETECCIONPRO(
            Var_ClienteConyID,      Var_PrimerNom,          Var_SegundoNom,         Var_TercerNom,          Var_ApellidoPat,
            Var_ApellidoMat,        Var_TipoPersonaCta,     Cadena_Vacia,           Var_RFC,                Cadena_Vacia,
            Var_FechaNac,           Entero_Cero,            Var_PaisNac,            Var_EstadoID,           Cadena_Vacia,
            EsNA,                   Str_NO,                 Str_SI,                 Str_NO,                 Str_NO,
            Par_NumErr,             Par_ErrMen,             Aud_EmpresaID,          Aud_Usuario,            Aud_FechaActual,
            Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

        IF(Par_NumErr!=Entero_Cero)THEN
           

                SET Var_OpeInusualID :=(SELECT OpeInusualID FROM PLDOPEINUSUALES
                                        WHERE Fecha=Var_FechaDeteccion
                                            AND FechaDeteccion = Var_FechaDeteccion
                                            AND ClaveRegistra=ClaveRegistra
                                            AND NombreReg = RegistraSAFI
                                            AND CatProcedIntID = CatProcIntID
                                            AND CatMotivInuID = CatMotivInusualID
                                            AND NomPersonaInv = Var_NombreCompleto
                                            AND TipoPersonaSAFI = EsNA
                                            AND DesOperacion = DescripOpera
                                            AND ClavePersonaInv = Var_ClienteConyID LIMIT 1);


                SET Var_ErrMen := Par_ErrMen;
                IF IFNULL(Var_OpeInusualID,Entero_Cero) != Entero_Cero THEN

                    SELECT OpeInusualID INTO Var_OpeInusualIDSPL
                    FROM PLDSEGPERSONALISTAS
                    WHERE OpeInusualID = Var_OpeInusualID;

                    IF IFNULL(Var_OpeInusualIDSPL,Entero_Cero) = Entero_Cero THEN
                        -- Damos de alta en la tabla de coincidencias de personas en listas e personas bloqueadas por el momento es para este tipo de lista
                        CALL PLDSEGPERSONALISTASALT(Var_OpeInusualID,   EsNA,               Var_ClienteConyID,     Var_NombreCompleto,     Var_FechaDeteccion,
                                                    Con_LPB,            Var_SoloNombre,     Var_SoloApellido,       Var_FechaNac,           Var_RFC,
                                                    Var_PaisNac,        Str_NO,             Par_NumErr,             Par_ErrMen,             Aud_EmpresaID,
                                                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,
                                                    Aud_NumTransaccion);

                        IF(Par_NumErr != Entero_Cero)THEN
                            LEAVE TerminaStore;
                        END IF;
                    END IF;
                END IF;

                 IF(Par_Salida = Str_SI) THEN
            -- NO CAMBIAR ESTE NUMERO DE ERROR
                select '50' as NumErr,
                        Var_ErrMen as ErrMen,
                        'clienteID' as control,
                        Entero_Cero as consecutivo;
                 LEAVE TerminaStore;
            END IF;
           
        END IF;
    END IF;

    


if Par_Cliente > Entero_Cero then
    if not exists(select ClienteID from SOCIODEMOCONYUG where ClienteID = Par_Cliente) then
        Set Par_NumErr  := Entero_Cero;
        Set Par_ErrMen  := 'No hay datos para enviar a Historico';
        if(Par_Salida = Str_SI) then
                select '000' as NumErr,
                        Par_ErrMen as ErrMen,
                        'clienteID' as control,
                        Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end If;
else
    if not exists(select ProspectoID from SOCIODEMOCONYUG where ProspectoID = Par_Prospecto) then
        Set Par_NumErr  := Entero_Cero;
        Set Par_ErrMen  := 'No hay datos para enviar a Historico';
        if(Par_Salida = Str_SI) then
                select '000' as NumErr,
                        Par_ErrMen as ErrMen,
                        'clienteID' as control,
                        Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end If;
end if;

Set Var_Consecutivo := (select max(Consecutivo) from HISSOCIODEMOCON);
Set Var_Consecutivo := ifnull(Var_Consecutivo, Entero_Cero) + 1;


if Par_Cliente > Entero_Cero then
    insert into HISSOCIODEMOCON
		   (ProspectoID			,ClienteID				,Consecutivo			,FechaRegistro		,FechaHistorico,
			PrimerNombre		,SegundoNombre			,TercerNombre			,ApellidoPaterno	,ApellidoMaterno,
            Nacionalidad		,PaisNacimiento			,EstadoNacimiento		,FechaNacimiento	,RFC,
            TipoIdentiID		,FolioIdentificacion	,FechaExpedicion		,FechaVencimiento	,TelCelular,
            OcupacionID			,EmpresaLabora			,EntidadFedTrabajo		,MunicipioTrabajo	,Colonia,
            Calle				,NumeroExterior			,NumeroInterior			,CodigoPostal		,NumeroPiso,
            AntiguedadAnios 	,AntiguedadMeses		,TelefonoTrabajo		,ExtencionTrabajo	,FechaIniTrabajo,
            EmpresaID			,Usuario				,FechaActual			,DireccionIP		,ProgramaID,
            Sucursal			,NumTransaccion)
    select  ProspectoID         ,ClienteID              ,Var_Consecutivo        ,FechaRegistro      ,Var_FechaHistorico
            ,PrimerNombre       ,SegundoNombre          ,TercerNombre           ,ApellidoPaterno    ,ApellidoMaterno
            ,Nacionalidad       ,PaisNacimiento         ,EstadoNacimiento       ,FechaNacimiento    ,RFC
            ,TipoIdentiID       ,FolioIdentificacion    ,FechaExpedicion        ,FechaVencimiento   ,TelCelular
            ,OcupacionID        ,EmpresaLabora          ,EntidadFedTrabajo      ,MunicipioTrabajo   ,Colonia
            ,Calle              ,NumeroExterior         ,NumeroInterior         ,CodigoPostal       ,NumeroPiso
			,CONVERT((case AntiguedadAnios when '' then '0' else AntiguedadAnios end), SIGNED INTEGER)    ,CONVERT((case AntiguedadMeses when '' then '0' else AntiguedadMeses end ), SIGNED INTEGER)        ,TelefonoTrabajo        ,ExtencionTrabajo   ,FechaIniTrabajo
            ,Aud_EmpresaID      ,Aud_Usuario            ,Aud_FechaActual        ,Aud_DireccionIP    ,Aud_ProgramaID
            ,Aud_Sucursal        ,Aud_NumTransaccion
    from SOCIODEMOCONYUG
    where ClienteID = Par_Cliente;
else
    insert into HISSOCIODEMOCON
           (ProspectoID			,ClienteID				,Consecutivo			,FechaRegistro		,FechaHistorico,
			PrimerNombre		,SegundoNombre			,TercerNombre			,ApellidoPaterno	,ApellidoMaterno,
            Nacionalidad		,PaisNacimiento			,EstadoNacimiento		,FechaNacimiento	,RFC,
            TipoIdentiID		,FolioIdentificacion	,FechaExpedicion		,FechaVencimiento	,TelCelular,
            OcupacionID			,EmpresaLabora			,EntidadFedTrabajo		,MunicipioTrabajo	,Colonia,
            Calle				,NumeroExterior			,NumeroInterior			,CodigoPostal		,NumeroPiso,
            AntiguedadAnios		,AntiguedadMeses		,TelefonoTrabajo		,ExtencionTrabajo	,FechaIniTrabajo,
            EmpresaID			,Usuario				,FechaActual			,DireccionIP		,ProgramaID,
            Sucursal			,NumTransaccion)
    select  ProspectoID,        ClienteID,             Var_Consecutivo,        FechaRegistro,      Var_FechaHistorico,
            PrimerNombre,       SegundoNombre,         TercerNombre,           ApellidoPaterno,    ApellidoMaterno,
            Nacionalidad,       PaisNacimiento,        EstadoNacimiento,       FechaNacimiento,    RFC,
            TipoIdentiID,       FolioIdentificacion,   FechaExpedicion,        FechaVencimiento,   TelCelular,
            OcupacionID,        EmpresaLabora,         EntidadFedTrabajo,      MunicipioTrabajo,   Colonia,
            Calle,              NumeroExterior,        NumeroInterior,         CodigoPostal,       NumeroPiso,
            CONVERT(AntiguedadAnios, SIGNED INTEGER),    CONVERT(AntiguedadMeses, SIGNED INTEGER),       TelefonoTrabajo,        ExtencionTrabajo,   FechaIniTrabajo,
            Aud_EmpresaID,      Aud_Usuario,           Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,       Aud_NumTransaccion
    from SOCIODEMOCONYUG
    where ProspectoID = Par_Prospecto;
end if;

call SOCIODEMOCONYUGBAJ(Par_Prospecto   ,Par_Cliente        ,Baj_PorCliProspe   ,Str_NO             ,Par_NumErr
                        ,Par_ErrMen     ,Aud_EmpresaID      ,Aud_Usuario        ,Aud_FechaActual    ,Aud_DireccionIP
                        ,Aud_ProgramaID ,Aud_Sucursal   ,Aud_NumTransaccion);

if(Par_NumErr <> Entero_Cero) then
    if(Par_Salida = Str_SI) then
            select '006' as NumErr,
                    Par_ErrMen as ErrMen,
                    'clienteID' as control,
                    Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;

Set Par_NumErr  := Entero_Cero;
Set Par_ErrMen  := 'Datos del Conyuge Grabados con Exito';

if(Par_Salida = Str_SI) then
        select '000' as NumErr,
                Par_ErrMen as ErrMen,
                'clienteID' as control,
                Entero_Cero as consecutivo;
end if;



END TerminaStore$$