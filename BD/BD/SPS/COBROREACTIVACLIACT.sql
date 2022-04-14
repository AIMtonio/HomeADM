-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROREACTIVACLIACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBROREACTIVACLIACT`;DELIMITER $$

CREATE PROCEDURE `COBROREACTIVACLIACT`(
    Par_ClienteID       int(11),
    Par_numAct          int,

    Par_Salida          char(1),
    inout Par_NumErr    int,
    inout Par_ErrMen    varchar(400),

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)
TerminaStore:BEGIN

    DECLARE varControl              char(50);
    DECLARE Var_PermiteReactivacion char(1);
    DECLARE Var_RequiereCobro       char(1);
    DECLARE Var_Estatus             char(1);


    DECLARE Entero_Cero     INT;
    DECLARE Decimal_Cero		DECIMAL(14,2);
    DECLARE Cadena_Vacia		CHAR(1);
    DECLARE Salida_SI       CHAR(1);
    DECLARE Est_Aplicado    CHAR(1);
    DECLARE ActivaCliente   INT;
    DECLARE Var_EstatusCobroReactivaCli char(1);
    DECLARE PermiteReactivacionSI  char(1);
    DECLARE RequiereCobroSI char(1);




    Set Entero_Cero     := 0;
    Set Decimal_Cero    := 0.0;
    Set Cadena_Vacia    := '';
    Set Salida_SI       := 'S';
    Set Est_Aplicado    :='A';
    Set ActivaCliente   := 5;
    Set PermiteReactivacionSI   :='S';
    Set RequiereCobroSI     := 'S';

ManejoErrores: BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-COBROREACTIVACLIACT');
				SET varControl = 'sqlException' ;
			END;

        IF(ifnull(Par_ClienteID,Entero_Cero)= Entero_Cero) THEN
            SET Par_NumErr  := '001';
            SET Par_ErrMen  := 'El numero de cliente esta vacio.';
            SET varControl  := 'numero' ;
        LEAVE ManejoErrores;
        END IF;

        IF(ifnull(Par_numAct,Entero_Cero)= Entero_Cero) THEN
            SET Par_NumErr  := '001';
            SET Par_ErrMen  := 'El numero de actualizacion esta vacio.';
            SET varControl  := 'numero' ;
        LEAVE ManejoErrores;
        END IF;

        if (Par_NumAct = ActivaCliente)then
        SELECT M.PermiteReactivacion, M.RequiereCobro, C.Estatus into Var_PermiteReactivacion, Var_RequiereCobro, Var_Estatus
            from    MOTIVACTIVACION M, CLIENTES C
            where C.ClienteID = Par_ClienteID
            and C.TipoInactiva = M.MotivoActivaID;

        set Var_PermiteReactivacion	:=ifnull(Var_PermiteReactivacion, Cadena_Vacia);
        set Var_RequiereCobro	:=ifnull(Var_RequiereCobro,Cadena_Vacia);
        set Var_Estatus     := ifnull(Var_Estatus, Cadena_Vacia);


          IF(Var_PermiteReactivacion != PermiteReactivacionSI) then
            SET Par_NumErr  := '007';
                SET Par_ErrMen  := 'El motivo de inactivacion del cliente no permite reactivacion.';
                SET varControl  := 'numero' ;
                LEAVE ManejoErrores;
        end if;



        if not exists(select CobroReactCliID
                                from COBROREACTIVACLI
                                where Estatus= 'P'
                                and ClienteID = Par_ClienteID)then
           if(Var_RequiereCobro = RequiereCobroSI) then
              SET Par_NumErr  := '008';
                SET Par_ErrMen  := 'El motivo de reactivacion tiene un costo favor de pagarlo en caja.';
                SET varControl  := 'numero' ;
                LEAVE ManejoErrores;
            end if;
end if;


 UPDATE COBROREACTIVACLI
        SET Estatus 	   = Est_Aplicado,

            EmpresaID		= Par_EmpresaID,
            Usuario         = Aud_Usuario,
            FechaActual 	= Aud_FechaActual,
            DireccionIP 	= Aud_DireccionIP,
            ProgramaID  	= Aud_ProgramaID,
            Sucursal		= Aud_Sucursal,
            NumTransaccion	= Aud_NumTransaccion
        WHERE ClienteID    = Par_ClienteID;
             set Par_NumErr  := 000;
                set Par_ErrMen  := concat('Cliente Actualizado ', Par_ClienteID);
                set varControl  := 'numero' ;
            LEAVE ManejoErrores;
end if;


END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen			 AS ErrMen,
			varControl			 AS control,
			Par_ClienteID	 AS consecutivo;
end IF;
END TerminaStore$$