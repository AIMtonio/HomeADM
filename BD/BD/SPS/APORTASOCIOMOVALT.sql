-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTASOCIOMOVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTASOCIOMOVALT`;DELIMITER $$

CREATE PROCEDURE `APORTASOCIOMOVALT`(

    Par_ClienteID           int(11),
    Par_Monto               decimal(14,2),
    Par_Tipo                char(1),
    Par_SucursalID          int(11),
    Par_CajaID              int(11),
    Par_Fecha               date,
    Par_UsuarioID           int(11),
    Par_DescripcionMov      varchar(150),
    Par_NumMovimiento       bigint(20),
    Par_MonedaID            int(11),

    Par_Salida              char(1),
    inout Par_NumErr        int,
    inout Par_ErrMen        varchar(400),

    Par_EmpresaID           int(11),
    Aud_Usuario             int,
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int,
    Aud_NumTransaccion      bigint
	)
TerminaStore:BEGIN


DECLARE Cadena_Vacia        char(1);
DECLARE Entero_Cero         int(11);
DECLARE Str_SI              char(1);
DECLARE Devolucion          char(1);
DECLARE Aportacion          char(1);
DECLARE Act_Devolucion		int;
DECLARE Act_Aportacion		int;


DECLARE Var_Control         varchar(50);
DECLARE Var_APortaSocID     varchar(50);
DECLARE Var_ClienteID       int(11);
DECLARE Var_Saldo           decimal(14,2);


Set Cadena_Vacia        := '';
Set Entero_Cero         := 0;
Set Str_SI              := 'S';
Set Devolucion          := 'D';
Set Aportacion          := 'A';
Set Act_Devolucion      := 2;
Set Act_Aportacion      := 1;


    Set Aud_FechaActual := CURRENT_TIMESTAMP();


    Set     Par_NumErr  := 1;
    Set     Par_ErrMen  := Cadena_Vacia;

    ManejoErrores: BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					set Par_NumErr = 999;
					set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
								 "estamos trabajando para resolverla. Disculpe las molestias que ",
								 "esto le ocasiona. Ref: SP-APORTASOCIOMOVALT");
				END;

    if not exists(select ClienteID
				from CLIENTES
				where ClienteID=Par_ClienteID)then
		set	Par_NumErr 	:= 1;
		set	Par_ErrMen	:= concat("El Cliente ",Par_ClienteID,  "no Existe");
        set Var_Control := 'tipoOperacion' ;
        LEAVE ManejoErrores;
    end if;

   if not exists(select SucursalID
				from SUCURSALES
				where SucursalID=Par_SucursalID)then
		set	Par_NumErr 	:= 2;
		set	Par_ErrMen	:= concat("La Sucursal",Par_SucursalID,"Indicada no Existe");
        set Var_Control := 'tipoOperacion' ;
        LEAVE ManejoErrores;
    end if;

if not exists(select CajaID,SucursalID
				from CAJASVENTANILLA
				where SucursalID=Par_SucursalID
				and CajaID= Par_CajaID)then
		Set Par_NumErr  := 3;
        set Par_ErrMen  := 'La caja especificada no existe o pertenece a otra sucursal';
        set Var_Control  := 'cajaID' ;
        LEAVE ManejoErrores;
end if;

select ClienteID,Saldo  into Var_ClienteID,Var_Saldo
            from APORTACIONSOCIO
            where ClienteID=Par_ClienteID;

set Var_ClienteID= ifnull(Var_ClienteID,Entero_Cero);
set Var_Saldo= ifnull(Var_Saldo,Entero_Cero);

if (Var_ClienteID != Entero_Cero)then
    if(Par_Tipo=Devolucion )then
		if(Par_Monto=Var_Saldo)then
			call APORTACIONSOCIOACT(
                    Par_ClienteID,      Par_Monto,          Act_Devolucion,        Par_EmpresaID,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,       Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
		else
			set	Par_NumErr 	:= 4;
			set	Par_ErrMen	:= concat("El Monto de la Devolucion no es igual al Saldo Disponible");
			set Var_Control := 'tipoOperacion' ;
			LEAVE ManejoErrores;
		   end if;
	end if;

    if(Par_Tipo=Aportacion)then
       call APORTACIONSOCIOACT(
                    Par_ClienteID,      Par_Monto,           Act_Aportacion,      Par_EmpresaID,
                    Aud_Usuario,        Aud_FechaActual,     Aud_DireccionIP,     Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
     end if;

else
    call APORTACIONSOCIOALT(
                    Par_ClienteID,      Par_Monto,          Par_SucursalID,         Par_Fecha,
                    Par_UsuarioID,      Par_Salida,         Par_NumErr,             Par_ErrMen,
                    Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
                    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
    end if;


     call FOLIOSAPLICAACT('APORTASOCIOMOV', Var_APortaSocID);

    INSERT INTO APORTASOCIOMOV (
                    AportaSocMOvID,     ClienteID,          Monto,              Tipo,
                    SucursalID,         CajaID,             Fecha,              UsuarioID,
                    DescripcionMov,     NumMovimiento,      MonedaID,           EmpresaID,
                    Usuario,            FechaActual,        DireccionIP,        ProgramaID,
                    Sucursal,           NumTransaccion)
            VALUES  (
                    Var_APortaSocID,    Par_ClienteID,      Par_Monto,          Par_Tipo,
                    Par_SucursalID,     Par_CajaID,         Par_Fecha,          Par_UsuarioID,
                    Par_DescripcionMov, Par_NumMovimiento,  Par_MonedaID,       Par_EmpresaID,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

       set	Par_NumErr 	:= 0;
	    set	Par_ErrMen	:= concat("Operacion realizada correctamente");

END ManejoErrores;
 if (Par_Salida = Str_SI) then
     select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Entero_Cero as consecutivo;
end if;
END TerminaStore$$