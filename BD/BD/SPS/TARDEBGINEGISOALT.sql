-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBGINEGISOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBGINEGISOALT`;DELIMITER $$

CREATE PROCEDURE `TARDEBGINEGISOALT`(
    Par_GiroID        char(50),
    Par_Descripcion	 varchar(500),
    Par_NombreCorto    varchar(30),
    Par_Estatus		    char(3),

    Par_TipoTran        int,
    Par_Salida         char(1),
    inout Par_NumErr   int,
    inout Par_ErrMen   varchar(400),


   Aud_EmpresaID		int(11),
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal	    	int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE	Estatus_Activo	char(1);
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE Salida_SI       char(1);
DECLARE Salida_NO       char(1);
DECLARE	NumeroGiroTarjeta		int;
DECLARE  TranTipoTarjeta int;

Set Entero_Cero     := 0;
Set Cadena_Vacia    := '';
Set Salida_SI       := 'S';
Set Salida_NO       := 'N';

Set  TranTipoTarjeta = 1;

       if(ifnull(Par_GiroID, Cadena_Vacia) = Cadena_Vacia) then
        if (Par_Salida = Salida_SI) then
            select '001' as NumErr,
                'Especifique el Giro de Negocio' as ErrMen,
                'giroID' as control,
                Entero_Cero as consecutivo;
        else
            set	Par_NumErr := 1;
            set	Par_ErrMen :='Especifique el Giro de Negocio';
        end if;
        LEAVE TerminaStore;
    end if;

 if(ifnull(Par_Descripcion, Cadena_Vacia ) = Cadena_Vacia) then
        if (Par_Salida = Salida_SI) then
            select '002' as NumErr,
                'Especifique la Descripcion del Giro' as ErrMen,
                'descripcion' as control,
                Entero_Cero as consecutivo;
        else
            set	Par_NumErr := 2;
            set	Par_ErrMen :='Especifique la Descripcion de Giro';
        end if;
        LEAVE TerminaStore;
    end if;

    if(ifnull(Par_NombreCorto, Cadena_Vacia ) = Cadena_Vacia) then
        if (Par_Salida = Salida_SI) then
            select '003' as NumErr,
                'Especifique el Nombre Corto de Giro' as ErrMen,
                'nomCorto' as control,
                Par_MontoMaxDia as consecutivo;
        else
            set	Par_NumErr := 3;
            set	Par_ErrMen :='Especifique el Nombre Corto de Giro';
        end if;
        LEAVE TerminaStore;
    end if;

    if(ifnull(Par_Estatus,  Cadena_Vacia ) = Cadena_Vacia) then
        if (Par_Salida = Salida_SI) then
            select '004' as NumErr,
                'Especifique el Estatus' as ErrMen,
                'estatus' as control,
                Entero_Cero as consecutivo;
        else
            set	Par_NumErr := 4;
            set	Par_ErrMen :='Especifique el Estatus';
        end if;
        LEAVE TerminaStore;
    end if;

   insert into TARDEBGIROSNEGISO (
                GiroID,                      Descripcion,                   NombreCorto,         Estatus,        EmpresaID,
                Usuario,                    FechaActual,                    DireccionIP,         ProgramaID,       Sucursal,       NumTransaccion)
    values   (
              Par_GiroID ,                Par_Descripcion,              Par_NombreCorto,      Par_Estatus,        Aud_EmpresaID,
               Aud_Usuario,                 Aud_FechaActual,              Aud_DireccionIP,      Aud_ProgramaID,     Aud_Sucursal,         Aud_NumTransaccion);


    if(Par_Salida =  Salida_SI) then
        SELECT '00' as CodigoRespuesta,
            'Giro de Negocio Agregado Exitosamente.' as MensajeRespuesta,
            'giroID' as LimiteRegistrado,
            Entero_Cero as NumeroTransaccion;
    else
        Set Par_NumErr  := 0;
        Set Par_ErrMen  := 'Giro de Negocio Agregado Exitosamente.';
    end if;
END TerminaStore$$