-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOCIODEMOCONYUGALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOCIODEMOCONYUGALT`;
DELIMITER $$

CREATE PROCEDURE `SOCIODEMOCONYUGALT`(
    Par_Prospecto               INT(11)
    ,Par_Cliente                INT(11)
    ,Par_ClienteConyID          INT(11)
    ,Par_PrimerNombre           Varchar(25)
    ,Par_SegundoNombre          Varchar(25)

    ,Par_TercerNombre           Varchar(25)
    ,Par_ApellidoPaterno        Varchar(30)
    ,Par_ApellidoMaterno        Varchar(30)
    ,Par_Nacionalidad           Char(1)
    ,Par_PaisNacimiento         INT(11)

    ,Par_EstadoNacimiento       INT(11)
    ,Par_FechaNacimiento        DATE
    ,Par_RFC                    Varchar(13)
    ,Par_TipoIdentiID           INT(11)
    ,Par_FolioIdentificacion    Varchar(25)
    ,Par_FechaExpedicion        DATE

    ,Par_FechaVencimiento       DATE
    ,Par_TelCelular             Varchar(16)
    ,Par_OcupacionID            INT(11)
    ,Par_EmpresaLabora           Varchar(100)
    ,Par_EntidadFedTrabajo      INT(11)

    ,Par_MunicipioTrabajo       INT(11)
    ,Par_LocalidadTrabajo       INT(11)
    ,Par_ColoniaTrabajo         INT(11)
    ,Par_Colonia                Varchar(100)
    ,Par_Calle                  Varchar(100)

    ,Par_NumeroExterior         CHAR(10)
    ,Par_NumeroInterior         CHAR(10)
    ,Par_CodigoPostal           varchar(5)
    ,Par_NumeroPiso             VARCHAR(20)
    ,Par_AntiguedadAnios        CHAR(10)

    ,Par_AntiguedadMeses        CHAR(10)
    ,Par_TelefonoTrabajo        Varchar(16)
    ,Par_ExtencionTrabajo       Varchar(6)
    ,Par_FechaIniTrabajo        DATE
    ,Par_Salida                 char(1)

    ,inout Par_NumErr           int(11)
    ,inout Par_ErrMen           varchar(400)

    ,Aud_Empresa                int(11)
    ,Aud_Usuario                int(11)
    ,Aud_FechaActual            DateTime
    ,Aud_DireccionIP            varchar(15)
    ,Aud_ProgramaID             varchar(50)
    ,Aud_Sucursal               int(11)
    ,Aud_NumTransaccion         bigint(20)
)
TerminaStore: BEGIN


DECLARE Var_FechaRegistro       DATE;
DECLARE Var_TipoPersona         CHAR(1);


DECLARE Cadena_Vacia            char(1);
DECLARE Fecha_Vacia             datetime;
DECLARE Entero_Cero             int(11);
DECLARE Str_SI                  char(1);
DECLARE Str_NO                  char(1);

DECLARE Nac_Mexicana            char(1);
DECLARE Nac_Extranjero          char(1);
DECLARE Persona_Moral			char(1);
DECLARE CliProEsp               INT(11);
DECLARE CliCrediClub            INT(11);
DECLARE EsNA                    CHAR(2);
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
Set Nac_Mexicana            := 'N';
Set Nac_Extranjero          := 'E';
Set Persona_Moral       	:= 'M';



Set Aud_FechaActual         := CURRENT_TIMESTAMP();


Set Par_NumErr              := 1;
set Par_ErrMen              := Cadena_Vacia;

Set Var_FechaRegistro       :=	(select FechaSistema from PARAMETROSSIS);


Set Par_Prospecto           := ifnull(Par_Prospecto, Entero_Cero);
Set Par_Cliente             := ifnull(Par_Cliente, Entero_Cero);
Set Par_ClienteConyID       := ifnull(Par_ClienteConyID, Entero_Cero);
Set Par_FolioIdentificacion := ifnull(Par_FolioIdentificacion, Cadena_Vacia);
Set Par_PrimerNombre        := ifnull(Par_PrimerNombre, Cadena_Vacia);
Set Par_SegundoNombre       := ifnull(Par_SegundoNombre, Cadena_Vacia);
Set Par_TercerNombre        := ifnull(Par_TercerNombre, Cadena_Vacia);
Set Par_ApellidoPaterno     := ifnull(Par_ApellidoPaterno, Cadena_Vacia);
Set Par_ApellidoMaterno     := ifnull(Par_ApellidoMaterno, Cadena_Vacia);
SET CliProEsp               := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'CliProcEspecifico');
SET CliCrediClub            := '24';
SET EsNA                    := 'NA';
SET DescripOpera            :='LISTA DE PERSONAS BLOQUEADAS';   -- Comentario en operaciones de alta o modificacion de clientes
SET CatMotivInusualID       :='LISBLOQ';        -- Clave interna motivo Tabla catalogo PLDCATMOTIVINU: LISTAS PERSONAS BLOQUEADAS
SET CatProcIntID            :='PR-SIS-000';     -- Clave interna
SET RegistraSAFI            := 'SAFI';          -- Clave que registra la operacion
SET ClaveRegistra           := '3';             -- Clave del tipo de persona que detecta la operacion  (1.-personal interno  2.-personal externo  3.-sistema automatico)
SET Var_FechaDeteccion      := (SELECT FechaSistema FROM PARAMETROSSIS);
SET Con_LPB                 := 'LPB';           -- Inidica que es de lista de personas bloqueadas
SET Var_SoloNombre          :=  FNGENNOMBRECOMPLETO(Par_PrimerNombre, Par_SegundoNombre,Par_TercerNombre,Cadena_Vacia,Cadena_Vacia);
SET Var_SoloApellido        :=  FNGENNOMBRECOMPLETO(Cadena_Vacia, Cadena_Vacia,Cadena_Vacia,Par_ApellidoPaterno,Par_ApellidoMaterno);
SET Var_NombreCompleto      :=  FNGENNOMBRECOMPLETO(Par_PrimerNombre, Par_SegundoNombre,Par_TercerNombre,Par_ApellidoPaterno,Par_ApellidoMaterno);


if (Par_Prospecto = Entero_Cero and Par_Cliente = Entero_Cero) then
    Set Par_ErrMen  := 'Número de Cliente y Prospecto No son Validos.';
    if(Par_Salida = Str_SI) then
			select '001' as NumErr,
				Par_ErrMen as ErrMen,
				'clienteID' as control,
             Entero_Cero as consecutivo;
	else
		set Par_NumErr := 001;
    end if;
    LEAVE TerminaStore;
end if;


if Par_Cliente > Entero_Cero then
    if not exists(select ClienteID from CLIENTES where ClienteID = Par_Cliente) then
        Set Par_ErrMen  := 'El Número de Cliente No Existe.';
        if(Par_Salida = Str_SI) then
                select '002' as NumErr,
                        Par_ErrMen as ErrMen,
                        'clienteID' as control,
                        Entero_Cero as consecutivo;
		else
			set Par_NumErr := 002;
        end if;
        LEAVE TerminaStore;
    end If;
else
    if not exists(select ProspectoID from PROSPECTOS where ProspectoID = Par_Prospecto) then
        Set Par_ErrMen  := 'El Número de Prospecto no Existe.';
        if(Par_Salida = Str_SI) then
                select '003' as NumErr,
                        Par_ErrMen as ErrMen,
                        'prospectoID' as control,
                        Entero_Cero as consecutivo;
		else
			set Par_NumErr := 003;
        end if;
        LEAVE TerminaStore;
    end If;
end if;

if CHAR_LENGTH(Par_PrimerNombre) <= Entero_Cero then
    Set Par_ErrMen  := 'El Primer Nombre del Cónyuge esta Vacío.';
    if(Par_Salida = Str_SI) then
            select '005' as NumErr,
                    Par_ErrMen as ErrMen,
                    'pNombre' as control,
                    Entero_Cero as consecutivo;
	else
		set Par_NumErr := 005;
    end if;
    LEAVE TerminaStore;
end if;

if CHAR_LENGTH(Par_ApellidoPaterno) <= Entero_Cero then
    Set Par_ErrMen  := 'El Apellido Paterno del Conyuge esta Vacío.';
    if(Par_Salida = Str_SI) then
            select '006' as NumErr,
                    Par_ErrMen as ErrMen,
                    'aPaterno' as control,
                    Entero_Cero as consecutivo;
	else
		set Par_NumErr := 006;
    end if;
    LEAVE TerminaStore;
end if;

if Par_Nacionalidad not in (Nac_Mexicana, Nac_Extranjero) then
    Set Par_ErrMen  := 'La Nacionalidad Indicada No es Valida.';
    if(Par_Salida = Str_SI) then
            select '008' as NumErr,
                    Par_ErrMen as ErrMen,
                    'nacionaID' as control,
                    Entero_Cero as consecutivo;
	else
		set Par_NumErr := 008;
    end if;
    LEAVE TerminaStore;
end if;

if not exists(select PaisID from PAISES where PaisID = Par_PaisNacimiento) then
    Set Par_ErrMen  := 'El País indicado No Existe.';
    if(Par_Salida = Str_SI) then
            select '009' as NumErr,
                    Par_ErrMen as ErrMen,
                    'paisNacimiento' as control,
                    Entero_Cero as consecutivo;
	else
		set Par_NumErr := 009;
    end if;
    LEAVE TerminaStore;
end if;

if not exists(select EstadoID from ESTADOSREPUB where EstadoID = Par_EstadoNacimiento) then
    Set Par_ErrMen  := 'La Entidad Federativa indicada No Existe.';
    if(Par_Salida = Str_SI) then
            select '010' as NumErr,
                    Par_ErrMen as ErrMen,
                    'estadoID' as control,
                    Entero_Cero as consecutivo;
	else
		set Par_NumErr := 010;
    end if;
    LEAVE TerminaStore;
end if;

if (ifnull(Par_FechaNacimiento, Fecha_Vacia) = Fecha_Vacia) then
    Set Par_ErrMen  := 'La Fecha de Nacimiento esta vacía';
    if(Par_Salida = Str_SI) then
            select '011' as NumErr,
                    Par_ErrMen as ErrMen,
                    'fecNacimiento' as control,
                    Entero_Cero as consecutivo;
	else
		set Par_NumErr := 011;
    end if;
    LEAVE TerminaStore;
   end if;

if CHAR_LENGTH(Par_RFC) < 13 then
    Set Par_ErrMen  := 'El RFC no es valido.';
    if(Par_Salida = Str_SI) then
            select '012' as NumErr,
                    Par_ErrMen as ErrMen,
                    'rfcConyugue' as control,
                    Entero_Cero as consecutivo;
	else
		set Par_NumErr := 012;
    end if;
    LEAVE TerminaStore;
end if;

if not exists(select TipoIdentiID from TIPOSIDENTI where TipoIdentiID = Par_TipoIdentiID) then
    Set Par_ErrMen  := 'El Tipo de Identificación no Existe.';
    if(Par_Salida = Str_SI) then
            select '013' as NumErr,
                    Par_ErrMen as ErrMen,
                    'tipoIdentiID' as control,
                    Entero_Cero as consecutivo;
	else
		set Par_NumErr := 013;
    end if;
    LEAVE TerminaStore;
end if;

IF CHAR_LENGTH(Par_FolioIdentificacion) <= Entero_Cero then
    Set Par_ErrMen  := 'El Folio de la Identificación se encuentra vacío.';
    if(Par_Salida = Str_SI) then
            select '014' as NumErr,
                    Par_ErrMen as ErrMen,
                    'folioIdentificacion' as control,
                    Entero_Cero as consecutivo;
	else
		set Par_NumErr := 014;
    end if;
    LEAVE TerminaStore;
end if;


if(Par_ClienteConyID != Entero_Cero && Par_Cliente != Entero_Cero)then
	if (Par_ClienteConyID = Par_Cliente) then
		Set Par_ErrMen  := 'El Cónyugue No debe ser la misma Persona que el Cliente.';
		if(Par_Salida = Str_SI) then
				select '015' as NumErr,
						Par_ErrMen as ErrMen,
						'buscClienteID' as control,
						Entero_Cero as consecutivo;
		else
			set Par_NumErr := 015;
		end if;
		LEAVE TerminaStore;
	end if;
end if;

set Var_TipoPersona  := (select TipoPersona from CLIENTES where ClienteID = Par_ClienteConyID);

if (Var_TipoPersona = Persona_Moral ) then
	Set Par_ErrMen  := 'El Cónyugue No debe ser una Persona Moral.';
    if(Par_Salida = Str_SI) then
            select '015' as NumErr,
                    Par_ErrMen as ErrMen,
                    'buscClienteID' as control,
                    Entero_Cero as consecutivo;
	else
		set Par_NumErr := 015;
    end if;
    LEAVE TerminaStore;
end if;

    IF( CliProEsp <> CliCrediClub) THEN
        /*SECCION PLD: Deteccion de operaciones inusuales*/
        CALL PLDDETECCIONPRO(
            Par_ClienteConyID,      Par_PrimerNombre,       Par_SegundoNombre,      Par_TercerNombre,       Par_ApellidoPaterno,
            Par_ApellidoMaterno,    Var_TipoPersona,        Cadena_Vacia,           Par_RFC,                Cadena_Vacia,
            Par_FechaNacimiento,    Entero_Cero,            Par_PaisNacimiento,     Par_EstadoNacimiento,   Cadena_Vacia,
            EsNA,                   Str_NO,                 Str_SI,                 Str_NO,                 Str_NO,
            Par_NumErr,             Par_ErrMen,             Aud_Empresa,            Aud_Usuario,            Aud_FechaActual,
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
                                            AND ClavePersonaInv = Par_ClienteConyID LIMIT 1);


                SET Var_ErrMen := Par_ErrMen;
                IF IFNULL(Var_OpeInusualID,Entero_Cero) != Entero_Cero THEN

                    SELECT OpeInusualID INTO Var_OpeInusualIDSPL
                    FROM PLDSEGPERSONALISTAS
                    WHERE OpeInusualID = Var_OpeInusualID;

                    IF IFNULL(Var_OpeInusualIDSPL,Entero_Cero) = Entero_Cero THEN
                        -- Damos de alta en la tabla de coincidencias de personas en listas e personas bloqueadas por el momento es para este tipo de lista
                        CALL PLDSEGPERSONALISTASALT(Var_OpeInusualID,   EsNA,               Par_ClienteConyID,     Var_NombreCompleto,     Var_FechaDeteccion,
                                                    Con_LPB,            Var_SoloNombre,     Var_SoloApellido,       Par_FechaNacimiento,    Par_RFC,
                                                    Par_PaisNacimiento,  Str_NO,             Par_NumErr,             Par_ErrMen,             Aud_Empresa,
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
    
    

insert SOCIODEMOCONYUG (ProspectoID         ,ClienteID          ,FechaRegistro      ,ClienteConyID      ,PrimerNombre       ,SegundoNombre
                        ,TercerNombre       ,ApellidoPaterno    ,ApellidoMaterno    ,Nacionalidad       ,PaisNacimiento
                        ,EstadoNacimiento   ,FechaNacimiento    ,RFC                ,TipoIdentiID       ,FolioIdentificacion
                        ,FechaExpedicion    ,FechaVencimiento   ,TelCelular         ,OcupacionID        ,EmpresaLabora
                        ,EntidadFedTrabajo  ,MunicipioTrabajo   ,LocalidadTrabajo   ,ColoniaTrabajo     ,Colonia            ,Calle              ,CodigoPostal
                        ,NumeroExterior     ,NumeroInterior     ,NumeroPiso         ,AntiguedadAnios    ,AntiguedadMeses
                        ,TelefonoTrabajo    ,ExtencionTrabajo   ,FechaIniTrabajo
						,EmpresaID          ,Usuario            ,FechaActual        ,DireccionIP        ,ProgramaID
						,Sucursal           ,NumTransaccion )

values( Par_Prospecto           ,Par_Cliente            ,Var_FechaRegistro		  ,Par_ClienteConyID     ,Par_PrimerNombre       	,Par_SegundoNombre
		,Par_TercerNombre        ,Par_ApellidoPaterno    ,Par_ApellidoMaterno    ,Par_Nacionalidad       ,Par_PaisNacimiento
		,Par_EstadoNacimiento    ,Par_FechaNacimiento    ,Par_RFC                ,Par_TipoIdentiID       ,Par_FolioIdentificacion
		,Par_FechaExpedicion	 ,Par_FechaVencimiento   ,Par_TelCelular         ,Par_OcupacionID        ,Par_EmpresaLabora
		,Par_EntidadFedTrabajo   ,Par_MunicipioTrabajo   ,Par_LocalidadTrabajo  ,Par_ColoniaTrabajo     ,Par_Colonia            ,Par_Calle
		,Par_CodigoPostal
		,Par_NumeroExterior      , Par_NumeroInterior    ,Par_NumeroPiso         ,Par_AntiguedadAnios    ,Par_AntiguedadMeses
		,Par_TelefonoTrabajo     ,Par_ExtencionTrabajo   ,Par_FechaIniTrabajo
		,Aud_Empresa             ,Aud_Usuario            ,Aud_FechaActual  		,Aud_DireccionIP         ,Aud_ProgramaID
		,Aud_Sucursal           ,Aud_NumTransaccion);

Set Par_NumErr  := Entero_Cero;
Set Par_ErrMen  := 'Datos del Cónyuge grabado con Éxito.';

if(Par_Salida = Str_SI) then
        select '000' as NumErr,
                Par_ErrMen as ErrMen,
                'pNombre' as control,
                Entero_Cero as consecutivo;
end if;

END TerminaStore$$