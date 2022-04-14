-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUROCLIENTEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUROCLIENTEALT`;DELIMITER $$

CREATE PROCEDURE `SEGUROCLIENTEALT`(
    Par_ClienteID               int(11),
	Par_MontoSeguro             decimal(14,2),
	Par_MontoSegAyuda			decimal(14,2),
    Par_MontoSegPagado          decimal(14,2),
	Par_FechaInicio				date,
	out Par_SeguroClienteID		int(11),

    Par_Salida                  char(1),
    out Par_NumErr              int,
    out Par_ErrMen              varchar(200),


    Par_EmpresaID               int(11),
    Aud_Usuario                 int(11),
    Aud_FechaActual             datetime,
    Aud_DireccionIP             varchar(15),
    Aud_ProgramaID              varchar(50),
    Aud_Sucursal                int(11),
    Aud_NumTransaccion          bigint(20)
	)
TerminaStore: BEGIN


DECLARE Var_Control             varchar(50);
DECLARE Var_FechaVencimiento	date;
DECLARE Var_DiasVencSeguro		int(11);
DECLARE Var_Fechabil			date;
DECLARE Es_DiaHabil				char(1);


DECLARE Cadena_Vacia            char(1);
DECLARE Fecha_Vacia             date;
DECLARE Entero_Cero             int;
DECLARE SalidaSI        	    char(1);
DECLARE EstatusVigente			char(1);
DECLARE Un_DiaHabil				int;


Set Cadena_Vacia 		:= '';
Set Fecha_Vacia			:= '1900-01-01';
Set Entero_Cero 		:= 0;
Set SalidaSI			:= 'S';
set EstatusVigente		:='V';
Set Un_DiaHabil 		:= 1;


Set Aud_FechaActual := CURRENT_TIMESTAMP();


Set     Par_NumErr  := 0;
Set     Par_ErrMen  := Cadena_Vacia;

select VigDiasSeguro into Var_DiasVencSeguro from PARAMETROSSIS where EmpresaID = Par_EmpresaID ;

ManejoErrores: BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				set Par_NumErr = 999;
				set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
							 "estamos trabajando para resolverla. Disculpe las molestias que ",
							 "esto le ocasiona. Ref: SP-SEGUROCLIENTEALT");
			END;

    if not exists(select ClienteID
				from CLIENTES
				where ClienteID=Par_ClienteID)then
		set	Par_NumErr 	:= 1;
		set	Par_ErrMen	:= concat("El cliente ",Par_ClienteID,  "no Existe");
        set Var_Control := 'tipoOperacion' ;
        LEAVE ManejoErrores;
    end if;


	set Var_FechaVencimiento :=date_add(Par_FechaInicio, INTERVAL Var_DiasVencSeguro DAY);
	call DIASFESTIVOSCAL(
		Var_FechaVencimiento,	Entero_Cero,		Var_Fechabil,		Es_DiaHabil,		Par_EmpresaID,
		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);
	set Var_FechaVencimiento := Var_Fechabil;


    call FOLIOSAPLICAACT('SEGUROCLIENTE', Par_SeguroClienteID);

    INSERT INTO SEGUROCLIENTE(
		SeguroClienteID,	ClienteID,			FechaInicio,		FechaVencimiento,		Estatus,
		MontoSeguro,		MontoSegAyuda,		MontoSegPagado,		EmpresaID,				Usuario,
		FechaActual,		DireccionIP,		ProgramaID,			Sucursal,				NumTransaccion)
	VALUES (
		Par_SeguroClienteID,Par_ClienteID,		Par_FechaInicio,	Var_FechaVencimiento,	EstatusVigente,
		Par_MontoSeguro,	Par_MontoSegAyuda,  Par_MontoSegPagado,	Par_EmpresaID,			Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP, 	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

    set Par_NumErr := Entero_Cero;
    set Par_ErrMen := "Seguro de Cliente Agregado Exitosamente.";

    END ManejoErrores;

 if(Par_Salida = SalidaSI) then
    select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            'seguroClienteID' as control,
             Entero_Cero as consecutivo;
    end if;

END TerminaStore$$