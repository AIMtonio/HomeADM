-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCANCELALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCANCELALT`;DELIMITER $$

CREATE PROCEDURE `TARDEBCANCELALT`(
    Par_NumTarjeta      char(16),
    Par_TarjetaHabiente int,
    Par_CorporativoID   int,
    Par_MotivoBloqID    int,
    Par_DescAdicional   varchar(500),
    Par_TipoTran        int,

    Par_Salida          char(1),
    inout Par_NumErr    int,
    inout Par_ErrMen    varchar(400),

    Aud_EmpresaID       int(11),
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN


DECLARE Entero_Cero     int;
DECLARE Cadena_Vacia    char(1);
DECLARE Salida_SI       char(1);
DECLARE Salida_NO       char(1);
DECLARE TranCancel     int;
DECLARE TipoEventoBloq  int;
DECLARE Estatus_Bloq    int;
DECLARE Estatus_Activa  int;
DECLARE Var_Estatus     char(1);
DECLARE Var_NomCliente  varchar(100);
DECLARE ProcesoActualiza int(11);
DECLARE EstatusCanc		int;
DECLARE Est_Expirada         int;


Set Entero_Cero     := 0;
Set Cadena_Vacia    := '';
Set Salida_SI       := 'S';
Set Salida_NO       := 'N';
Set ProcesoActualiza:= 2;
Set TranCancel     := 7;
Set Estatus_Bloq    := 8;
Set Estatus_Activa  := 7;
Set Aud_FechaActual := CURRENT_TIMESTAMP();
set EstatusCanc		     :=9;
Set Est_Expirada        :=10;



    if(ifnull(Par_NumTarjeta, Cadena_Vacia) = Cadena_Vacia) then
        if (Par_Salida = Salida_SI) then
            select '001' as NumErr,
                'Especifique el Numero de Tarjeta' as ErrMen,
                'numTarjeta' as control,
                Entero_Cero as consecutivo;
        else
            set	Par_NumErr := 1;
            set	Par_ErrMen :='Especifique el Numero de Tarjeta';
        end if;
        LEAVE TerminaStore;
    end if;

    if(ifnull(Par_MotivoBloqID, Entero_Cero ) = Entero_Cero) then
        if (Par_Salida = Salida_SI) then
            select '003' as NumErr,
                'Especifique el Motivo de Bloqueo' as ErrMen,
                'motivoID' as control,
                Entero_Cero as consecutivo;
        else
            set	Par_NumErr := 3;
            set	Par_ErrMen :='Especifique el Motivo del Bloqueo';
        end if;
        LEAVE TerminaStore;
    end if;

    if(ifnull(Par_DescAdicional, Cadena_Vacia) = Cadena_Vacia) then
        if (Par_Salida = Salida_SI) then
            select '004' as NumErr,
                'Especifique la Descripcion Adicional' as ErrMen,
                'descripAdic' as control,
                Entero_Cero as consecutivo;
        else
            set	Par_NumErr := 4;
            set	Par_ErrMen :='Especifique la Descripcion Adicional';
        end if;
        LEAVE TerminaStore;
    end if;

    if (Par_TipoTran = TranCancel) then
        SELECT Estatus into Var_Estatus
            FROM TARJETADEBITO
            WHERE TarjetaDebID = Par_NumTarjeta ;

        if (Var_Estatus != EstatusCanc and Var_Estatus != Est_Expirada) then
            SELECT NombreCompleto    into Var_NomCliente
                FROM CLIENTES
                WHERE ClienteID = Par_TarjetaHabiente;

            INSERT INTO `BITACORATARDEB`    VALUES(
                Par_NumTarjeta,     EstatusCanc,     Par_MotivoBloqID,   Par_DescAdicional,  Aud_FechaActual,
                Var_NomCliente,     Aud_EmpresaID,    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
                Aud_ProgramaID,     Aud_Sucursal,     Aud_NumTransaccion  );

            UPDATE TARJETADEBITO SET
                Estatus = EstatusCanc,
                FechaCancelacion =Aud_FechaActual,
                MotivoCancelacion = Par_MotivoBloqID

                WHERE TarjetaDebID = Par_NumTarjeta;



            if (Par_Salida = Salida_SI) then
                select '00' as NumErr,
                    'Tarjeta Cancelada Exitosamente.' as ErrMen,
                    'tarjetaDebID' as control,
                    Par_NumTarjeta as consecutivo;
          LEAVE TerminaStore;
            else
                set	Par_NumErr := 0;
                set	Par_ErrMen :='Tarjeta Cancelada Exitosamente.';
           LEAVE TerminaStore;
            end if;
        else
            if ( Var_Estatus != EstatusCanc and Var_Estatus != Est_Expirada) then
                if (Par_Salida = Salida_SI) then
                    select '005' as NumErr,
                        'La Tarjeta se encuentra Cancelada' as ErrMen,
                        'tarjetaDebID' as control,
                        Entero_Cero as consecutivo;
                else
                    set	Par_NumErr := 5;
                    set	Par_ErrMen :='La Tarjeta se encuentra Cancelada';
                end if;
                LEAVE TerminaStore;
            else
                if (Par_Salida = Salida_SI) then
                    select '006' as NumErr,
                        'La Tarjeta se encuentra Activada.' as ErrMen,
                        'tarjetaDebID' as control,
                        Entero_Cero as consecutivo;
                else
                    set	Par_NumErr := 6;
                    set	Par_ErrMen :='La Tarjeta se encuentra Activada.';
                end if;
                LEAVE TerminaStore;
            end if;
        end if;



    end if;
END TerminaStore$$