-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIEXTRANJEROMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIEXTRANJEROMOD`;DELIMITER $$

CREATE PROCEDURE `CLIEXTRANJEROMOD`(
    Par_ClienteID           int,
    Par_Inmigrado           char(1),
    Par_DocLegal            char(3),
    Par_MotivoEst           varchar(30),
    Par_FechVen             date,

    Par_Entidad             varchar(100),
    Par_Localidad           varchar(100),
    Par_Colonia             varchar(150),
    Par_Calle               varchar(50),
    Par_NumCasa             varchar(10),

    Par_NumIntCasa          varchar(10),
    Par_Adi_CoPoEx          char(6),
    Par_PaisRFC             int(11),

    Par_EmpresaID           int(11),
    Aud_Usuario             int(11),
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int(11),
    Aud_NumTransaccion      bigint(20)
    )
TerminaStore: BEGIN


DECLARE     Var_Estatus     char(1);
DECLARE     NumeroCteExt    int;
DECLARE     Estatus_Activo  char(1);
DECLARE     Cadena_Vacia    char(1);
DECLARE     Fecha_Vacia     date;
DECLARE     Entero_Cero     int;
DECLARE     Fecha_Alta      date;
DECLARE     Var_Pais        int;
DECLARE     ClienteInactivo char(1);


Set NumeroCteExt            := 0;
Set Estatus_Activo          := 'A';
Set Cadena_Vacia            := '';
Set Fecha_Vacia             := '1900-01-01';
Set Entero_Cero             := 0;
Set ClienteInactivo         :='I';


select Estatus into Var_Estatus
    from CLIENTES
        where ClienteID=Par_ClienteID;

if (Var_Estatus = ClienteInactivo) then
    select '001' as NumErr,
        'El cliente se encuentra Inactivo.' as ErrMen,
        'clienteID' as control,
        Par_ClienteID as consecutivo;
    LEAVE TerminaStore;
end if;
if(not exists(select ClienteID
            from CLIENTES
            where ClienteID = Par_ClienteID
            and Nacion = 'E'))then
    select '001' as NumErr,
         'El Cliente no es Extranjero.' as ErrMen,
         'clienteID' as control,
          Entero_Cero as consecutivo;
    LEAVE TerminaStore;
end if;
if(ifnull(Par_DocLegal, Cadena_Vacia))= Cadena_Vacia then
    select '002' as NumErr,
         'El Documento Legal esta Vacio.' as ErrMen,
         'documentoLegal' as control,
          NumeroCteExt as consecutivo;
    LEAVE TerminaStore;
end if;
if(ifnull(Par_Inmigrado, Cadena_Vacia))= Cadena_Vacia then
    select '003' as NumErr,
         'Inmigrado esta Vacio.' as ErrMen,
         'inmigrado' as control,
          NumeroCteExt as consecutivo;
    LEAVE TerminaStore;
end if;
if(ifnull(Par_FechVen, Fecha_Vacia))= Fecha_Vacia then
    select '004' as NumErr,
         'La fecha esta Vacia.' as ErrMen,
         'fechaVencimiento' as control,
          NumeroCteExt as consecutivo;
    LEAVE TerminaStore;
end if;

if(ifnull(Par_Entidad, Cadena_Vacia))= Cadena_Vacia then
    select '006' as NumErr,
         'La Entidad esta Vacia.' as ErrMen,
         'entidad' as control,
          NumeroCteExt as consecutivo;
    LEAVE TerminaStore;
end if;
if(ifnull(Par_Localidad, Cadena_Vacia))= Cadena_Vacia then
    select '007' as NumErr,
         'La Localidad esta Vacia.' as ErrMen,
         'localidad' as control,
          NumeroCteExt as consecutivo;
    LEAVE TerminaStore;
end if;
if(ifnull(Par_Colonia, Cadena_Vacia))= Cadena_Vacia then
    select '008' as NumErr,
         'La Colonia esta Vacia.' as ErrMen,
         'colonia' as control,
          NumeroCteExt as consecutivo;
    LEAVE TerminaStore;
end if;
if(ifnull(Par_Calle, Cadena_Vacia))= Cadena_Vacia then
    select '009' as NumErr,
         'La Calle esta Vacia.' as ErrMen,
         'calle' as control,
          NumeroCteExt as consecutivo;
    LEAVE TerminaStore;
end if;
if(ifnull(Par_NumCasa, Cadena_Vacia))= Cadena_Vacia then
    select '0010' as NumErr,
         'La Numero de casa esta Vacio.' as ErrMen,
         'numeroCasa' as control,
          NumeroCteExt as consecutivo;
    LEAVE TerminaStore;

end if;

if(ifnull(Par_Adi_CoPoEx, Cadena_Vacia))= Cadena_Vacia then
    select '011' as NumErr,
         'El Codigo Postal Vacio.' as ErrMen,
         'adi_CoPoEx' as control,
          NumeroCteExt as consecutivo;
    LEAVE TerminaStore;

end if;



if(ifnull( Aud_Usuario, Entero_Cero)) = Entero_Cero then
    select '012' as NumErr,
         'El Usuario no esta logeado' as ErrMen,
         'inversionID' as control,
         Entero_Cero as consecutivo;
    LEAVE TerminaStore;
end if;


if(ifnull( Aud_FechaActual, Fecha_Vacia)) = Fecha_Vacia then
    select '013' as NumErr,
         'La fecha Actual' as ErrMen,
         'inversionID' as control,
         Entero_Cero as consecutivo;
    LEAVE TerminaStore;
end if;

 if(ifnull( Aud_DireccionIP, Cadena_Vacia)) = Cadena_Vacia then
    select '014' as NumErr,
         'La direccion IP no existe' as ErrMen,
         'inversionID' as control,
         Entero_Cero as consecutivo;
    LEAVE TerminaStore;
end if;
if(ifnull( Aud_ProgramaID, Cadena_Vacia)) = Cadena_Vacia then
    select '015' as NumErr,
         'El Programa no existe' as ErrMen,
         'inversionID' as control,
         Entero_Cero as consecutivo;
    LEAVE TerminaStore;
end if;

if(ifnull( Aud_Sucursal, Entero_Cero)) = Entero_Cero then
    select '016' as NumErr,
         'La Sucursal no existe' as ErrMen,
         'inversionID' as control,
         Entero_Cero as consecutivo;
    LEAVE TerminaStore;
end if;
if(ifnull( Aud_NumTransaccion, Entero_Cero)) = Entero_Cero then
    select '017' as NumErr,
         'La Sucursal no existe' as ErrMen,
         'inversionID' as control,
         Entero_Cero as consecutivo;
    LEAVE TerminaStore;
end if;



if(ifnull( Par_PaisRFC, Entero_Cero) = Entero_Cero) then
    select '018' as NumErr,
         'El Pais de Registro de RFC Esta Vacio' as ErrMen,
         'paisRFC' as control,
         Entero_Cero as consecutivo;
    LEAVE TerminaStore;
else
    if not exists(select PaisID from PAISES
            where PaisID = Par_PaisRFC)then
        select '019' as NumErr,
            'El Pais de Registro de RFC No Existe' as ErrMen,
            'paisRFC' as control,
            Entero_Cero as consecutivo;
        LEAVE TerminaStore;
    end if;
end if;


Set Aud_FechaActual := CURRENT_TIMESTAMP();

update CLIEXTRANJERO set
    Inmigrado       = Par_Inmigrado,
    DocumentoLegal  = Par_DocLegal,
    MotivoEstancia  = Par_MotivoEst,
    FechaVencimien  = Par_FechVen,
    Entidad         = Par_Entidad,

    Localidad       = Par_Localidad,
    Colonia         = Par_Colonia,
    Calle           = Par_Calle,
    NumeroCasa      = Par_NumCasa,
    NumeroIntCasa   = Par_NumIntCasa,

    Adi_CoPoEx      = Par_Adi_CoPoEx,
    PaisRFC         = Par_PaisRFC,

    EmpresaID       = Par_EmpresaID,
    Usuario         = Aud_Usuario,
    FechaActual     = Aud_FechaActual,
    DireccionIP     = Aud_DireccionIP,
    ProgramaID      = Aud_ProgramaID,
    Sucursal        = Aud_Sucursal,
    NumTransaccion  = Aud_NumTransaccion
where ClienteID     = Par_ClienteID;

select '000' as NumErr ,
       concat("Cliente Extranjero Modificado: ", convert(Par_ClienteID, CHAR))as ErrMen,
      'clienteID' as control, Par_ClienteID as consecutivo;

END TerminaStore$$