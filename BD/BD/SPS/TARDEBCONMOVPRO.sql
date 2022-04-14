-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONMOVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCONMOVPRO`;DELIMITER $$

CREATE PROCEDURE `TARDEBCONMOVPRO`(
	Par_NumeroTarjeta       char(16),
    Par_FechaHoraOperacion  varchar(13),
	Par_NumeroTransaccion   char(6),
	Par_IdTerminal          varchar(40),
	Par_NomUbicTerminal     varchar(50),
	Par_MontoSurcharge      varchar(13),
    Par_MontoLoyaltyfee     varchar(13)
	)
TerminaStore:BEGIN

	DECLARE Var_Movto			varchar(50);
	DECLARE NumeroTransaccion	varchar(20);
	DECLARE SaldoContableAct	varchar(13);
	DECLARE SaldoDisponibleAct	varchar(13);
	DECLARE CodigoRespuesta		varchar(3);
	DECLARE FechaAplicacion		varchar(4);
	DECLARE UltimosMovimientos	varchar(500);
	DECLARE Entero_Cero			int(11);
	DECLARE Cadena_Vacia		char(1);
	DECLARE Decimal_Cero		decimal(12,2);
	DECLARE Var_CuentaAho		bigint(12);
	DECLARE Var_Saldo			varchar(13);
	DECLARE Var_SaldoDispon		varchar(13);
	DECLARE Var_NumTransaccion	bigint(20);
	DECLARE Saldo_Cero			varchar(13);


    DECLARE Cur_Movtos CURSOR FOR
		SELECT convert(concat(DATE_FORMAT(Fecha, '%d%m%y'), "  ",
				RPAD(CASE NatMovimiento WHEN 'C' THEN 'CARGO' WHEN 'A' THEN 'ABONO' END, 8, ' '),
				LPAD(replace(cast(CantidadMov  as char), '.', ''), 12, 0), 'C'), char) as Movimiento
		FROM CUENTASAHOMOV
		WHERE CuentaAhoID = Var_CuentaAho AND TipoMovAhoID IN (17, 20, 21, 22, 86, 88, 19, 96, 97, 98 )
		ORDER BY FechaActual DESC limit 5;

	Set Entero_Cero			:= 0;
	Set Cadena_Vacia		:= '';
	Set Decimal_Cero		:= '0.0';
	Set Saldo_Cero			:= 'C000000000000';
	Set UltimosMovimientos	:= Cadena_Vacia;

	Set FechaAplicacion	:=	(SELECT DATE_FORMAT(FechaSistema , '%m%d') FROM PARAMETROSSIS);

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
			Set NumeroTransaccion	:= LPAD(convert(Entero_Cero,char), 6, 0);
			Set SaldoContableAct	:= Saldo_Cero;
			Set SaldoDisponibleAct	:= Saldo_Cero;
			Set CodigoRespuesta   	:= "909";
			Set FechaAplicacion		:= FechaAplicacion;
			Set UltimosMovimientos	:= Cadena_Vacia;
        END;

		if (ifnull(Par_NumeroTarjeta, Cadena_Vacia) = Cadena_Vacia) then
			Set NumeroTransaccion	:= LPAD(convert(Entero_Cero,char), 6, 0);
			Set SaldoContableAct	:= Saldo_Cero;
			Set SaldoDisponibleAct	:= Saldo_Cero;
			Set CodigoRespuesta   	:= "214";
			Set FechaAplicacion		:= FechaAplicacion;
			Set UltimosMovimientos	:= Cadena_Vacia;
            LEAVE ManejoErrores;
        end if;

		if (ifnull(Par_FechaHoraOperacion, Cadena_Vacia) = Cadena_Vacia) then
			Set NumeroTransaccion	:= LPAD(convert(Entero_Cero,char), 6, 0);
			Set SaldoContableAct	:= Saldo_Cero;
			Set SaldoDisponibleAct	:= Saldo_Cero;
			Set CodigoRespuesta   	:= "412";
			Set FechaAplicacion		:= FechaAplicacion;
			Set UltimosMovimientos	:= Cadena_Vacia;
            LEAVE ManejoErrores;
        end if;

		if (ifnull(Par_NumeroTransaccion, Cadena_Vacia) = Cadena_Vacia) then
			Set NumeroTransaccion	:= LPAD(convert(Entero_Cero,char), 6, 0);
			Set SaldoContableAct	:= Saldo_Cero;
			Set SaldoDisponibleAct	:= Saldo_Cero;
			Set CodigoRespuesta   	:= "412";
			Set FechaAplicacion		:= FechaAplicacion;
			Set UltimosMovimientos	:= Cadena_Vacia;
            LEAVE ManejoErrores;
        end if;

		if (ifnull(Par_IdTerminal, Cadena_Vacia) = Cadena_Vacia) then
			Set NumeroTransaccion	:= LPAD(convert(Entero_Cero,char), 6, 0);
			Set SaldoContableAct	:= Saldo_Cero;
			Set SaldoDisponibleAct	:= Saldo_Cero;
			Set CodigoRespuesta   	:= "412";
			Set FechaAplicacion		:= FechaAplicacion;
			Set UltimosMovimientos	:= Cadena_Vacia;
			LEAVE ManejoErrores;
        end if;

		SELECT CuentaAhoID into Var_CuentaAho
			FROM TARJETADEBITO
			WHERE TarjetaDebID = Par_NumeroTarjeta;

		SELECT concat('C',LPAD(replace(cast(Saldo as char), '.', ''), 12, 0)),
			concat('C',LPAD(replace(cast(SaldoDispon as char), '.', ''), 12, 0))
					into Var_Saldo, Var_SaldoDispon
			FROM CUENTASAHO
			WHERE CuentaAhoID = Var_CuentaAho;

		call TARDEBTRANSACPRO(Var_NumTransaccion);

		OPEN Cur_Movtos;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP
			FETCH Cur_Movtos into Var_Movto;

				Set UltimosMovimientos	:=	concat(UltimosMovimientos, Var_Movto);
			End LOOP;
		END;
		CLOSE Cur_Movtos;

	if (ifnull(UltimosMovimientos, Cadena_Vacia) != Cadena_Vacia) then
		Set NumeroTransaccion	:=	LPAD(convert(Var_NumTransaccion, char), 6, 0);
		Set SaldoContableAct	:=	concat('C' , LPAD(REPLACE(convert(Var_Saldo,char) , '.', ''), 12, 0));
		Set SaldoDisponibleAct	:=	concat('C' , LPAD(REPLACE(convert(Var_SaldoDispon,char) , '.', ''), 12, 0));
		Set CodigoRespuesta		:=	"000";
		Set FechaAplicacion		:=	FechaAplicacion;
	elseif(UltimosMovimientos = Cadena_Vacia) then
		Set NumeroTransaccion	:= LPAD(convert(Var_NumTransaccion,char), 6, 0);
		Set SaldoContableAct	:= Saldo_Cero;
		Set SaldoDisponibleAct	:= Saldo_Cero;
		Set CodigoRespuesta   	:= "000";
		Set FechaAplicacion		:= FechaAplicacion;
		Set UltimosMovimientos	:= Cadena_Vacia;
	else
		Set NumeroTransaccion	:= LPAD(convert(Entero_Cero,char), 6, 0);
		Set SaldoContableAct	:= Saldo_Cero;
		Set SaldoDisponibleAct	:= Saldo_Cero;
		Set CodigoRespuesta   	:= "412";
		Set FechaAplicacion		:= FechaAplicacion;
		Set UltimosMovimientos	:= Cadena_Vacia;
	end if;
	END ManejoErrores;
	SELECT
			NumeroTransaccion,
			SaldoContableAct,
			SaldoDisponibleAct,
			CodigoRespuesta,
			FechaAplicacion,
			UltimosMovimientos;

END TerminaStore$$