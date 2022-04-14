-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMAAUTORIZABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMAAUTORIZABAJ`;DELIMITER $$

CREATE PROCEDURE `ESQUEMAAUTORIZABAJ`(
	Par_Esquema         INT(11),
	Par_Producto        INT(11),
   Par_TipoBaja        INT(11),

	Par_Salida		    CHAR(1),
	inout Par_NumErr	 INT(11),
	inout Par_ErrMen	 VARCHAR(400),
	Par_EmpresaID		 INT(11),
	Aud_Usuario		    INT(11),
	Aud_FechaActual		 DateTime,
	Aud_DireccionIP		 VARCHAR(15),
	Aud_ProgramaID		 VARCHAR(50),
	Aud_Sucursal		    INT(11),
	Aud_NumTransaccion  BIGINT(20)
	)
TerminaStore: BEGIN


DECLARE Cadena_Vacia        char(1);
DECLARE Fecha_Vacia         datetime;
DECLARE Entero_Cero         int(11);
DECLARE Str_SI              char(1);
DECLARE Str_NO              char(1);
DECLARE Baja_PorEsquema     INT(11);
DECLARE Baja_PorProducto    INT(11);



Set Cadena_Vacia        := '';
Set Fecha_Vacia         := '1900-01-01';
Set Entero_Cero         := 0;
Set Str_SI              := 'S';
Set Str_NO              := 'N';
Set Baja_PorEsquema     := 1;
set Baja_PorProducto    := 2;



Set Aud_FechaActual         := CURRENT_TIMESTAMP();


Set     Par_NumErr  := 1;
set     Par_ErrMen  := Cadena_Vacia;


ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            set Par_NumErr = 999;
            set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                         "estamos trabajando para resolverla. Disculpe las molestias que ",
                         "esto le ocasiona. Ref: SP-ESQUEMAAUTORIZABAJ");
        END;


    if( Par_TipoBaja = Baja_PorEsquema) then
        if not exists(select EsquemaID
                        from ESQUEMAAUTORIZA
                        where EsquemaID = Par_Esquema) then

            Set Par_ErrMen  := 'No Existe el Esquema de Autorizacion que intenta Eliminar.';
            if(Par_Salida = Str_SI) then
                select  '001' as NumErr,
                         Par_ErrMen as ErrMen,
                         'productoID' as control,
                          Entero_Cero as consecutivo;
            end if;
            LEAVE TerminaStore;
        end if;

        if exists(select EsquemaID
                  from ORGANOAUTORIZA
                  where EsquemaID = Par_Esquema) then

            Set Par_ErrMen  := 'No puede Eliminar el Esquema de Autorizacion, existen Firmas que dependen de dicho esquema.';
            if(Par_Salida = Str_SI) then
                select  '002' as NumErr,
                         Par_ErrMen as ErrMen,
                         'productoID' as control,
                          Entero_Cero as consecutivo;
            end if;
            LEAVE TerminaStore;
        end if;


        delete from ESQUEMAAUTORIZA
            where EsquemaID = Par_Esquema;


        set Par_NumErr := Entero_Cero;
        set Par_ErrMen := concat("Esquema de Autorizacion Eliminado con Exito.");

        if(Par_Salida = Str_SI) then
            select '000' as NumErr,
                    Par_ErrMen  as ErrMen,
                    'producCreditoID' as control,
                    Par_Producto as consecutivo;
        end if;
    end if;


    if( Par_TipoBaja = Baja_PorProducto) then
        if not exists(select EsquemaID
                        from ESQUEMAAUTORIZA
                        where EsquemaID = Par_Esquema) then

            Set Par_ErrMen  := 'No Existe el Esquema de Autorizacion que intenta Eliminar.';
            if(Par_Salida = Str_SI) then
                select  '001' as NumErr,
                         Par_ErrMen as ErrMen,
                         'productoID' as control,
                          Entero_Cero as consecutivo;
            end if;
            LEAVE TerminaStore;
        end if;


        if exists(select Fir.EsquemaID
                  from ESQUEMAAUTORIZA Esq
                    inner join ORGANOAUTORIZA Fir on Esq.EsquemaID = Fir.EsquemaID
                  where Esq.ProducCreditoID = Par_Producto) then

            Set Par_ErrMen  := 'El Producto tiene Esquemas de Autorizacion con Firmas asignadas.';
            if(Par_Salida = Str_SI) then
                select  '002' as NumErr,
                         Par_ErrMen as ErrMen,
                         'productoID' as control,
                          Entero_Cero as consecutivo;
            end if;
            LEAVE TerminaStore;
        end if;



        delete from ESQUEMAAUTORIZA
            where ProducCreditoID = Par_Producto;


        set Par_NumErr := Entero_Cero;
        set Par_ErrMen := concat("Esquema de Autorizacion Eliminado con Exito.");

        if(Par_Salida = Str_SI) then
            select '000' as NumErr,
                    Par_ErrMen  as ErrMen,
                    'producCreditoID' as control,
                    Par_Producto as consecutivo;
        end if;
    end if;



END ManejoErrores;



END TerminaStore$$