-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ORGANOINTEGRABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `ORGANOINTEGRABAJ`;DELIMITER $$

CREATE PROCEDURE `ORGANOINTEGRABAJ`(
    Par_OrganoID        int(11),
    Par_ClavePuestoID   varchar(10),
    Par_TipoBaja        varchar(1),

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


DECLARE Var_DescriOrg   varchar(200);
DECLARE varControl      char(30);


DECLARE Entero_Cero     int;
DECLARE Decimal_Cero    int;
DECLARE Cadena_Vacia    char(1);
DECLARE Par_SalidaNO    char(1);

DECLARE SalidaSI    char(1);
DECLARE Baja_PorOrgano  int;
DECLARE Baja_PorPuesto  int;



Set Entero_Cero     := 0;
Set Decimal_Cero    := 0.00;
Set Cadena_Vacia    := '';

 Set SalidaSI    := 'S';
Set Baja_PorOrgano  := 1;
Set Baja_PorPuesto  := 2;


ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            set Par_NumErr = 999;
            set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                         "estamos trabajando para resolverla. Disculpe las molestias que ",
                         "esto le ocasiona. Ref: SP-ORGANOINTEGRABAJ");
        END;
set varControl  := 'organoID';

    select Descripcion into Var_DescriOrg
        from ORGANODESICION
        where OrganoID = Par_OrganoID;

    set Var_DescriOrg   := ifnull(Var_DescriOrg, Cadena_Vacia);

    if(Var_DescriOrg = Cadena_Vacia ) then
        set Par_NumErr  := '001';
        set Par_ErrMen  := 'El Numero de Facultado no Existe.';
        set varControl  := 'organoID' ;
        LEAVE ManejoErrores;
    end if;

    if( Par_TipoBaja = Baja_PorOrgano) then
        delete from ORGANOINTEGRA
            where OrganoID = Par_OrganoID;

        set Par_NumErr := 0;
        set Par_ErrMen := "Todos los Puestos se Eliminaron del Facultado, Correctamente.";
    end if;

    if( Par_TipoBaja = Baja_PorPuesto) then
        delete from ORGANOINTEGRA
            where OrganoID = Par_OrganoID
              and ClavePuestoID = Par_ClavePuestoID;

        set Par_NumErr := 0;
        set Par_ErrMen := "Puesto(s) Eliminado(s) del Facultado, Correctamente.";
    end if;



END ManejoErrores;

 if (Par_Salida = SalidaSI) then
    select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            varControl as control,
            Entero_Cero as consecutivo;
end if;

END TerminaStore$$