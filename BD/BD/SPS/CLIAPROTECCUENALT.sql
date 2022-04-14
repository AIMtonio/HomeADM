-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIAPROTECCUENALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIAPROTECCUENALT`;DELIMITER $$

CREATE PROCEDURE `CLIAPROTECCUENALT`(
	Par_ClienteID		int(11),
	Par_CuentaAhoID		bigint(12),
	Par_MontoAplica		decimal(14,2),
	Par_Salida			char(1),
	inout	Par_NumErr	int,

	inout	Par_ErrMen	varchar(350),
	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual     DateTime,
	Aud_DireccionIP     varchar(15),

	Aud_ProgramaID      varchar(50),
	Aud_Sucursal        int(11),
	Aud_NumTransaccion  bigint(20)

		)
TerminaStore:BEGIN

DECLARE Var_CuentaAhoID				bigint(12);
DECLARE Var_Saldo					decimal(14,2);
DECLARE Var_MontoMaximoProteccion	decimal(14,2);
DECLARE Var_SumaMontoAplicaraTotal	decimal(14,2);
DECLARE Var_MonAplicaCuenta			decimal(14,2);
DECLARE Var_MontoAplicadoCreditos	decimal(14,2);
DECLARE Var_MontoAdeudoCred			decimal(14,2);


DECLARE EnteroCero		int;
DECLARE SalidaSI		char(1);
DECLARE Decimal_Cero	decimal;



set EnteroCero			:=0;
set SalidaSI			:='S';
set Decimal_Cero		:=0.00;

ManejoErrores:Begin

	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN	SET Par_NumErr = 999;
		SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ',
						'estamos trabajando para resolverla. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-CLIAPROTECCUENALT');

		END;


if not exists(select ClienteID
				from CLIENTES
				 where ClienteID = Par_ClienteID)then
	set Par_NumErr	:=1;
	set Par_ErrMen	:='El Cliente indicado no existe';
	LEAVE ManejoErrores;
end if;

select CuentaAhoID, SaldoDispon into Var_CuentaAhoID, Var_Saldo
				from CUENTASAHO
				where CuentaAhoID =Par_CuentaAhoID;

if(ifnull(Var_CuentaAhoID,EnteroCero)= EnteroCero)then
	set Par_NumErr	:=2;
	set Par_ErrMen	:='La Cuenta indicada no existe';
	LEAVE ManejoErrores;
end if;

set Var_Saldo :=ifnull(Var_Saldo,EnteroCero);


select MontoMaxProtec into Var_MontoMaximoProteccion
		from PARAMETROSCAJA limit 1;
set Var_MontoMaximoProteccion :=ifnull(Var_MontoMaximoProteccion, Decimal_Cero);

select sum(MontoAplicaCred) into Var_MontoAplicadoCreditos
		from CLIAPROTECCRED
			where ClienteID =Par_ClienteID;

select sum(MonAplicaCuenta) into Var_MonAplicaCuenta
		from CLIAPROTECCUEN
		where ClienteID	= Par_ClienteID;


set Var_MontoAplicadoCreditos	:= ifnull(Var_MontoAplicadoCreditos, Decimal_Cero);
set Var_MonAplicaCuenta			:= ifnull(Var_MonAplicaCuenta,Decimal_Cero);
set Var_SumaMontoAplicaraTotal	:= Var_MontoAplicadoCreditos + Var_MonAplicaCuenta + Par_MontoAplica;

if(Var_SumaMontoAplicaraTotal > Var_MontoMaximoProteccion)then
	set Par_NumErr	:=3;
	set Par_ErrMen	:='Se ha Superado el Monto Maximo para la Proteccion de Ahorro y Credito';
	LEAVE ManejoErrores;
end if;


set Aud_FechaActual		:=now();


insert into CLIAPROTECCUEN(
	ClienteID,		CuentaAhoID,		SaldoCuenta,		MonAplicaCuenta,	EmpresaID,
	Usuario,		FechaActual,		DireccionIP,		ProgramaID,			Sucursal,
	NumTransaccion)
values (
	Par_ClienteID,	Par_CuentaAhoID,	Var_Saldo,			Par_MontoAplica,	Par_EmpresaID,
	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
	Aud_NumTransaccion);

	set Par_NumErr	:=0;
	set Par_ErrMen	:='Proteccion del Ahorro Agregado Correctamente';
END ManejoErrores;

 if (Par_Salida = SalidaSI) then
    select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            'clienteID' as control,
            EnteroCero as consecutivo;
end if;

END TerminaStore$$