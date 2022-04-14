-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DENOMINAMOVSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DENOMINAMOVSALT`;
DELIMITER $$


CREATE PROCEDURE `DENOMINAMOVSALT`(
    Par_SucursalID      	int(11),
    Par_CajaID          	int(11),
    Par_Fecha           	date,
    Par_Transaccion     	bigint,
    Par_Naturaleza      	int,
    Par_DenominacionID  	int,
    Par_Cantidad        	decimal(14,2),
    Par_Monto           	decimal(14,2),
    Par_MonedaID        	int,
    Par_AltaEncPoliza   	char(1),
    Par_Instrumento     	varchar(20),
    Par_Referencia      	varchar(200),
    Par_Salida          	char(1),
    Par_EmpresaID       	int,
    Par_DesMovCaja      	varchar(150),
	Par_ClienteID			int(11),

    Var_Poliza        		bigint,
	inout Par_NumErr       	int(11),
	inout Par_ErrMen       	varchar(400),
	inout Par_Consecutivo  	bigint,

	Aud_Usuario         	int,
	Aud_FechaActual     	DateTime,
	Aud_DireccionIP     	varchar(15),
	Aud_ProgramaID      	varchar(50),
	Aud_Sucursal        	int(11),
	Aud_NumTransaccion  	bigint(20)
		)

TerminaStore: BEGIN

	/* Declaracion de Variables */
	DECLARE Var_EstatusCaja     	char(1);
	DECLARE Var_FechaSistema    	date;
	DECLARE Var_TipoDenom       	char(1);
	DECLARE Var_Cargos          	decimal(14,2);
	DECLARE Var_Abonos          	decimal(14,2);
	DECLARE Var_SucursalCaja    	int;
	DECLARE Var_EstatusOpera    	char(1);
	DECLARE Var_SaldoEfecMN     	decimal(14,2);
	DECLARE Var_SaldoEfecME     	decimal(14,2);
	DECLARE Var_MonedaBaseID    	int;
	DECLARE Var_CantidBalanza   	decimal(14,2);
	DECLARE Var_SucursalOrigenCte 	int(11);	-- Para almacenar la sucursal Origen del cte
	DECLARE Var_MaximoRetiro		decimal(14,2);
	DECLARE Var_LimiteEfectivoMN	decimal(14,2);
	DECLARE Var_LimiteDesemMN		decimal(14,2);
	DECLARE Var_Monto				decimal(14,2);
	DECLARE varControl				varchar(50);
	/* Declaracion de Constantes */
	DECLARE Cadena_Vacia	  		char(1);
	DECLARE Fecha_Vacia				date;
	DECLARE Entero_Cero				int;
	DECLARE Decimal_Cero			decimal(12, 2);

	DECLARE Esta_Activo     		char(1);
	DECLARE Par_SalidaNO    		char(1);
	DECLARE Par_SalidaSI    		char(1);
	DECLARE AltaPoliza_SI   		char(1);
	DECLARE AltaPoliza_NO   		char(1);
	DECLARE Mov_Entrada     		int;
	DECLARE Mov_Salida      		int;
	DECLARE Pol_Automatica  		char(1);
	DECLARE Coc_MovCaja     		int;
	DECLARE Den_Billete     		char(1);
	DECLARE Den_Moneda      		char(1);
	DECLARE Con_Divisa     			int;
	DECLARE Act_Saldo       		int;
	DECLARE Des_MovCaja     		varchar(50);
	DECLARE EstO_Cerrado			char(1);


	/* Asignacion de Constantes */
	Set Cadena_Vacia   				:= '';
	Set Fecha_Vacia     			:= '1900-01-01';
	Set Entero_Cero     			:= 0;
	Set Decimal_Cero    			:= 0.00;
	Set Esta_Activo     			:= 'A';				-- Estatus de la Caja: Activa

	Set Par_SalidaNO    			:= 'N';
	Set Par_SalidaSI    			:= 'S';
	Set AltaPoliza_SI   			:= 'S';
	Set AltaPoliza_NO   			:= 'N';
	Set Mov_Entrada     			:= 1;           -- Movimiento de Entrada.
	Set Mov_Salida      			:= 2;           -- Movimiento de Salida
	Set Pol_Automatica  			:= 'A';
	Set Coc_MovCaja     			:= 30;          -- Concepto Contable, Movimiento de Caja
	Set Con_Divisa      			:= 1;           -- Concepto del Movimiento Contable: Divisa
	Set Den_Billete     			:= 'B';         -- Denominacion Billete
	Set Den_Moneda      			:= 'M';         -- Denominacion Monedas
	Set Act_Saldo       			:= 1;           -- Tipo de Actualizacion de la Balanza: Saldo
	Set Des_MovCaja     			:= 'MOVIMIENTO DE EFECTIVO EN CAJA';
	Set EstO_Cerrado				:='C';
	Set Aud_FechaActual 			:= now();

ManejoErrores:BEGIN 	#bloque para manejar los posibles errores

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = 'Estimado Usuario(a), ha ocurrido una falla en el sistema,
										 estamos trabajando para resolverla. Disculpe las molestias que
										 esto le ocasiona. Ref: SP-DENOMINAMOVSALT';
				SET VarControl = 'sqlException' ;
			END;

	select FechaSistema, MonedaBaseID
		into Var_FechaSistema, Var_MonedaBaseID
		from PARAMETROSSIS;

	select   Estatus,    SucursalID,	EstatusOpera,LimiteEfectivoMN,
			 SaldoEfecMN,MaximoRetiroMN,LimiteDesemMN
		into Var_EstatusCaja, Var_SucursalCaja,Var_EstatusOpera,Var_LimiteEfectivoMN,Var_SaldoEfecMN,
			 Var_MaximoRetiro,Var_LimiteDesemMN
		from CAJASVENTANILLA
		where SucursalID 	= Par_SucursalID
		and   CajaID        = Par_CajaID;

	select SucursalOrigen
		into Var_SucursalOrigenCte
		from CLIENTES
		where ClienteID= Par_ClienteID;

	set Var_SucursalOrigenCte :=ifnull(Var_SucursalOrigenCte, Entero_Cero);
	set Var_EstatusCaja = ifnull(Var_EstatusCaja, Cadena_Vacia);

	select ifnull(sum(Monto),0) into Var_Monto
		from DENOMINACIONMOVS
			where Transaccion=Par_Transaccion;

	set Var_Monto:=  Par_Monto+Var_Monto;


	if(Var_EstatusCaja != Esta_Activo) then
		if(Par_Salida = Par_SalidaSI) then
		 set Par_NumErr		:= 1;
		 set Par_ErrMen		:='La Caja no Existe o no se Encuentra Activa.';
		 set varControl		:='cajaID';
		 set Par_Consecutivo:= Entero_cero;
	else
		set Par_NumErr		:= 1;
		set Par_ErrMen		:= 'La Caja no Existe o no se Encuentra Activa.';
		set Par_Consecutivo	:= Entero_cero;
	end if;
	LEAVE ManejoErrores;
end if;

if(ifnull(Var_EstatusOpera, Cadena_Vacia)) = EstO_Cerrado then
	if (Par_Salida = Par_SalidaSI) then
		set Par_NumErr		:= 2;
		set Par_ErrMen		:='La Caja se encuentra Cerrada.';
		set varControl		:='caja';
		set Par_Consecutivo := Entero_cero;
	else
		Set	Par_NumErr 		:= 2;
		Set	Par_ErrMen 		:= 'La Caja se encuentra Cerrada.' ;
		set Par_Consecutivo	:= 0;
	end if;
	LEAVE ManejoErrores;
end if;

if(ifnull(Par_Monto, Decimal_Cero)) <= Decimal_Cero then
	if(Par_Salida = Par_SalidaSI) then
		set Par_NumErr		:= 3;
		set Par_ErrMen		:= 'Monto del Movimiento Menor o Igual a Cero.';
		set varControl		:='monto';
		set Par_Consecutivo:= Entero_cero;
	else
		set Par_NumErr		:= 3;
		set Par_ErrMen		:= 'Monto del Movimiento Menor o Igual a Cero';
		set Par_Consecutivo	:= 0;
	end if;
	LEAVE ManejoErrores;
end if;


if(ifnull(Par_DesMovCaja, Cadena_Vacia)) = Cadena_Vacia then
	Set Par_DesMovCaja := Des_MovCaja;
end if;

-- Validar las Denominaciones
select TipoDenominacion into Var_TipoDenom
    from DENOMINACIONES
    where DenominacionID = Par_DenominacionID
      and MonedaID       = Par_MonedaID;

if(ifnull(Var_TipoDenom, Cadena_Vacia)) = Cadena_Vacia then
	if(Par_Salida = Par_SalidaSI) then
		set Par_NumErr		:= 4;
		set Par_ErrMen		:= 'La Denominacion no Existe.';
		set varControl		:= 'monto';
		set Par_Consecutivo := Entero_cero;
	else
		set Par_NumErr		:= 5;
		set Par_ErrMen		:= 'La Denominacion no Existe.';
		set Par_Consecutivo	:= 0;
	end if;
	LEAVE ManejoErrores;
end if;

-- TODO: Validar el usuario y la Caja
-- TODO: Validar Solo Mov de Entrada Salida
-- TODO: Validar Coincidencia de Cantidad y Monto

-- Validamos Contar con el Saldo en Caso de Salida de Efectivo
 if(Par_Naturaleza = Mov_Salida) then
    select  Caj.SaldoEfecMN, Caj.SaldoEfecMN into Var_SaldoEfecMN, Var_SaldoEfecME
        from CAJASVENTANILLA Caj
        where SucursalID = Par_SucursalID
          and CajaID     = Par_CajaID;

    set Var_SaldoEfecMN := ifnull(Var_SaldoEfecMN, Entero_Cero);
    set Var_SaldoEfecME := ifnull(Var_SaldoEfecME, Entero_Cero);

    if(Par_DenominacionID = Var_MonedaBaseID) then
        if(Var_SaldoEfecMN < Par_Monto) then
            if(Par_Salida = Par_SalidaSI) then
				set Par_NumErr		:= 7;
				set Par_ErrMen		:='Saldo de la Caja Insuficiente.';
				set varControl		:='monto';
				set Par_Consecutivo := Entero_cero;
            else
                set Par_NumErr		:= 7;
                set Par_ErrMen		:= 'Saldo de la Caja Insuficiente.';
                set Par_Consecutivo	:= 0;
            end if;
            LEAVE ManejoErrores;
        end if;
    else
        if(Var_SaldoEfecME < Par_Monto) then
            if(Par_Salida = Par_SalidaSI) then
				set Par_NumErr		:= 8;
				set Par_ErrMen      :='Saldo de la Caja Insuficiente.';
				set varControl		:='monto';
				set Par_Consecutivo := Entero_cero;
            else
                set Par_NumErr		:= 8;
                set Par_ErrMen		:= 'Saldo de la Caja Insuficiente.';
                set Par_Consecutivo	:= 0;
            end if;
            LEAVE ManejoErrores;
        end if;
    end if;

    select Bal.Cantidad into Var_CantidBalanza
        from BALANZADENOM Bal
        where SucursalID     = Par_SucursalID
          and CajaID         = Par_CajaID
          and DenominacionID = Par_DenominacionID
          and MonedaID       = Par_MonedaID;

    set Var_CantidBalanza   := ifnull(Var_CantidBalanza, Entero_Cero);

    if(Var_CantidBalanza < Par_Cantidad) then
        if(Par_Salida = Par_SalidaSI) then

			set Par_NumErr		:= 9;
			set Par_ErrMen		:='La Caja no Cuenta con el Saldo en la Denominacion Especificada.';
			set varControl		:='monto';
			set Par_Consecutivo := Entero_cero;
        else
            set Par_NumErr		:= 9;
            set Par_ErrMen		:= 'La Caja no Cuenta con el Saldo en la Denominacion Especificada.';
            set Par_Consecutivo	:= 0;
        end if;
        LEAVE ManejoErrores;
    end if;

end if;

insert into DENOMINACIONMOVS(
    SucursalID,     CajaID,         Fecha,          Transaccion,    Naturaleza,
    DenominacionID, Cantidad,       Monto,          MonedaID,       EmpresaID,
    Usuario,        FechaActual,    DireccionIP,    ProgramaID,     Sucursal,
    NumTransaccion)
    values(
    Var_SucursalCaja,	Par_CajaID,         Par_Fecha,          Par_Transaccion,    Par_Naturaleza,
    Par_DenominacionID, Par_Cantidad,       Par_Monto,          Par_MonedaID,       Par_EmpresaID,
    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
    Aud_NumTransaccion);


-- Movimiento Contable del Efectivo
if (Par_AltaEncPoliza = AltaPoliza_SI) then
set Var_Poliza:=0;
    call MAESTROPOLIZAALT(
        Var_Poliza,		Par_EmpresaID,  Var_FechaSistema,   Pol_Automatica,     Coc_MovCaja,
        Par_DesMovCaja,	Par_SalidaNO,   Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,	Aud_Sucursal,   Aud_NumTransaccion);
end if;

if (Par_Naturaleza = Mov_Entrada) then
    set Var_Cargos  = Par_Monto;
    set Var_Abonos  = Decimal_Cero;
else
    set Var_Cargos  = Decimal_Cero;
    set Var_Abonos  = Par_Monto;
end if;


call  POLIZADIVISAPRO(
    Var_Poliza,         Par_SucursalID, 	Par_CajaID,     Par_EmpresaID,  		Var_FechaSistema,
    Var_TipoDenom,      Con_Divisa,     	Par_MonedaID,   Var_Cargos,     		Var_Abonos,
    Par_Instrumento,    Par_DesMovCaja, 	Par_Referencia, Var_SucursalOrigenCte,	Aud_Usuario,
	Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   		Aud_NumTransaccion  );

-- Actualizamos la Balanza de Efectivo
call BALANZADENOMACT(
    Par_SucursalID,     Par_CajaID,     Par_DenominacionID, Par_MonedaID,       Par_Cantidad,
    Par_Naturaleza,     Act_Saldo,      Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion  );

-- Actualizamos el Saldo de la Caja

call CAJASVENTANILLAACT(
	Par_SucursalID,		Par_CajaID,     	Cadena_Vacia,		Entero_Cero,		Cadena_Vacia,
	Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Fecha_Vacia,		Cadena_Vacia,
	Fecha_Vacia,		Cadena_Vacia,		Fecha_Vacia,		Cadena_Vacia,		Par_MonedaID,
	Par_Monto,			Decimal_Cero,		Decimal_Cero,		Par_Naturaleza,   	Cadena_Vacia,
	Act_Saldo,      	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
	Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion );


	set Par_NumErr		:= Entero_Cero;
	set Par_ErrMen		:= 'Movimiento de Efectivo Realizado';
	set Par_Consecutivo := Var_Poliza;

END ManejoErrores; #fin del manejador de errores

	if (Par_Salida = Par_SalidaSI) then
		SELECT  Par_NumErr 		AS NumErr,
				Par_ErrMen	 	AS ErrMen,
				varControl	 	AS control,
				Par_Consecutivo	AS consecutivo;
	else
		set Par_NumErr		:= Entero_Cero;
		set Par_ErrMen		:= 'Movimiento de Efectivo Realizado';
		set Par_Consecutivo	:= Var_Poliza;
	end if;

END TerminaStore$$