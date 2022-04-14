-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ORGANOINTEGRAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ORGANOINTEGRAALT`;DELIMITER $$

CREATE PROCEDURE `ORGANOINTEGRAALT`(
    Par_OrganoID        int(11),
    Par_ClavePuestoID   varchar(10),
    Par_Salida          char(1),
    inout Par_NumErr    int,
    inout Par_ErrMen    varchar(400),

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint  	)
TerminaStore: BEGIN


DECLARE Var_DescriOrg   varchar(100);
DECLARE Var_DescriPues  varchar(200);
DECLARE varControl      char(30);


DECLARE Entero_Cero     int;
DECLARE Decimal_Cero    int;
DECLARE Cadena_Vacia    char(1);
DECLARE Par_SalidaNO    char(1);

DECLARE SalidaSI    char(1);



Set Entero_Cero     := 0;
Set Decimal_Cero    := 0.00;
Set Cadena_Vacia    := '';
Set Par_SalidaNO    := 'N';

Set SalidaSI    := 'S';


ManejoErrores: BEGIN
   DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            set Par_NumErr = 999;
            set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                         "estamos trabajando para resolverla. Disculpe las molestias que ",
                         "esto le ocasiona. Ref: SP-ORGANOINTEGRAALT");
        END;

	set varControl  := 'organoID';

    select Org.Descripcion into Var_DescriOrg
        from ORGANODESICION Org
        where Org.OrganoID = Par_OrganoID;

	set Var_DescriOrg   := ifnull(Var_DescriOrg, Cadena_Vacia);

    if(Var_DescriOrg 	= Cadena_Vacia ) then
        set Par_NumErr  := '001';
        set Par_ErrMen  := 'El Numero de Facultado no Existe.';
        set varControl  := 'organoID' ;
        LEAVE ManejoErrores;
    end if;

    select Descripcion into Var_DescriPues
        from PUESTOS
        where ClavePuestoID = Par_ClavePuestoID;

    set Var_DescriPues   := ifnull(Var_DescriPues, Cadena_Vacia);

    if(Var_DescriPues = Cadena_Vacia ) then
        set Par_NumErr  := '002';
        set Par_ErrMen  := concat('El Puesto ', Par_ClavePuestoID, ' no Existe');
        set varControl  := 'organoID' ;
        LEAVE ManejoErrores;
    end if;

    Set Aud_FechaActual := CURRENT_TIMESTAMP();

    INSERT INTO ORGANOINTEGRA(
        OrganoID,           ClavePuestoID,      EmpresaID,      Usuario,            FechaActual,
        DireccionIP,        ProgramaID,         Sucursal,       NumTransaccion)
        VALUES(
        Par_OrganoID,       Par_ClavePuestoID,  Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,
        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

    set Par_NumErr := 0;
    set Par_ErrMen := "Puesto(s) Asignado(s) al Facultado Correctamente.";


END ManejoErrores;

 if (Par_Salida = SalidaSI) then
    select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            varControl as control,
            Entero_Cero as consecutivo;
end if;

END TerminaStore$$