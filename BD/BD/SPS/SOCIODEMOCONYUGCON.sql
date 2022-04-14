-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOCIODEMOCONYUGCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOCIODEMOCONYUGCON`;DELIMITER $$

CREATE PROCEDURE `SOCIODEMOCONYUGCON`(
	Par_ProspectoID			int(11),
	Par_ClienteID			int(11),
	Par_TipoCon				tinyint unsigned,

    Aud_Empresa           int,
    Aud_Usuario             int,
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int,
    Aud_NumTransaccion      bigint
	)
TerminaStore: BEGIN





DECLARE Cadena_Vacia            char(1);
DECLARE Fecha_Vacia             datetime;
DECLARE Entero_Cero             int(11);
DECLARE Str_SI                  char(1);
DECLARE Str_NO                  char(1);

DECLARE Con_Principal           int(11);


Set Cadena_Vacia            := '';
Set Fecha_Vacia             := '1900-01-01';
Set Entero_Cero             := 0;
Set Str_SI                  := 'S';
Set Str_NO                  := 'N';




Set Con_Principal           := 1;


if(Par_TipoCon = Con_Principal) then

     if Par_ClienteID > Entero_Cero then
        select   ProspectoID        ,ClienteID          ,FechaRegistro      ,PrimerNombre       ,SegundoNombre
                ,TercerNombre       ,ApellidoPaterno    ,ApellidoMaterno    ,Nacionalidad       ,PaisNacimiento
                ,EstadoNacimiento   ,FechaNacimiento    ,RFC                ,TipoIdentiID       ,FolioIdentificacion
                ,FechaExpedicion    ,FechaVencimiento   ,TelCelular         ,OcupacionID        ,EmpresaLabora
                ,EntidadFedTrabajo  ,MunicipioTrabajo   ,LocalidadTrabajo   ,ColoniaTrabajo     ,Colonia
                ,Calle              ,NumeroExterior     ,NumeroInterior     ,CodigoPostal		   ,NumeroPiso
                ,AntiguedadAnios    ,AntiguedadMeses    ,TelefonoTrabajo    ,ExtencionTrabajo   ,ClienteConyID
				,FechaIniTrabajo
        from 	 SOCIODEMOCONYUG
        where	 ClienteID = Par_ClienteID;

    else
        select   ProspectoID        ,ClienteID          ,FechaRegistro      ,PrimerNombre       ,SegundoNombre
                ,TercerNombre       ,ApellidoPaterno    ,ApellidoMaterno    ,Nacionalidad       ,PaisNacimiento
                ,EstadoNacimiento   ,FechaNacimiento    ,RFC                ,TipoIdentiID       ,FolioIdentificacion
                ,FechaExpedicion    ,FechaVencimiento   ,TelCelular         ,OcupacionID        ,EmpresaLabora
                ,EntidadFedTrabajo  ,MunicipioTrabajo   ,LocalidadTrabajo   ,ColoniaTrabajo     ,Colonia
                ,Calle              ,NumeroExterior     ,NumeroInterior     ,CodigoPostal		   ,NumeroPiso
                ,AntiguedadAnios    ,AntiguedadMeses    ,TelefonoTrabajo    ,ExtencionTrabajo   ,ClienteConyID
				,FechaIniTrabajo
        from 	 SOCIODEMOCONYUG
        where	 ProspectoID	= 	Par_ProspectoID;
    end if;

 end if;

END TerminaStore$$