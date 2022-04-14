-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOMOVHIALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOMOVHIALT`;DELIMITER $$

CREATE PROCEDURE `CUENTASAHOMOVHIALT`(
	/* inserta movimientos en la tabla del historico .- `HIS-CUENAHOMOV`*/
	Par_CuentaAhoID			BIGINT(12),
	Par_NumeroMov			BIGINT(20),
	Par_Fecha				DATE,
	Par_NatMovimiento		CHAR(1),
	Par_CantidadMov			DECIMAL(12,2),

	Par_DescripcionMov		VARCHAR(150),
	Par_ReferenciaMov		VARCHAR(35),
	Par_TipoMovAhoID		CHAR(4),
	Par_SiBloquea			CHAR(1), /*para saber si si bloquea el saldo con mes anterior*/
	Par_Salida				CHAR(1),

	INOUT Par_NumErr		INT,
	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo	BIGINT,
	Aud_EmpresaID			INT,
	Aud_Usuario				INT,

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
)
TerminaStore: BEGIN

/* Declaracion de Variables */
DECLARE	Cliente				INT;
DECLARE	SaldoDisp			DECIMAL(12,2);
DECLARE	MonedaCon			INT;
DECLARE	EstatusC			CHAR(1);
DECLARE	Var_TipoMovID		CHAR(4);
DECLARE Var_EstatusDes		VARCHAR(50);
DECLARE Var_PrimerDiaMes	DATE;
DECLARE Var_UltimoDiaMes	DATE;
DECLARE Var_FechaActual   	DATE;
DECLARE Var_UltimoDiaMesAct DATE;
DECLARE Var_PrimerDiaMesAct DATE;

/* Declaracion de Constantes */
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Entero_Cero			INT;
DECLARE	DECIMAL_Cero		DECIMAL(12,2);
DECLARE	EstatusActual		CHAR(1);
DECLARE	EstatusActivo		CHAR(1);
DECLARE	Nat_Cargo			CHAR(1);
DECLARE	Nat_Abono			CHAR(1);
DECLARE	Fecha_Vacia			DATE;

DECLARE	Salida_NO 			CHAR(1);
DECLARE	Var_Si	 			CHAR(1);
DECLARE Est_Cancelado		CHAR(1)	;
DECLARE Var_Control			VARCHAR(30);

/* Asignacion de Constantes */
SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET DECIMAL_Cero    := 0.0;
SET EstatusActivo   := 'A';
SET Nat_Cargo       := 'C';
SET Nat_Abono       := 'A';
SET Salida_NO       := 'N';
SET Var_Si          := 'S';
SET Est_Cancelado	:= 'C';
SET Aud_FechaActual	:= NOW();

-- Inicializacion
SET SaldoDisp			:= 0.0;
ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: SP-CUENTASAHOMOVHIALT');
		SET Var_Control:= 'sqlException' ;
	END;

	SELECT 	FechaSistema  INTO 	Var_FechaActual
		FROM PARAMETROSSIS;

	-- para obtener primer dia del mes
	SET Var_PrimerDiaMes	:= CONVERT(DATE_ADD(Par_Fecha, INTERVAL -1*(day(Par_Fecha))+1 DAY),DATE);
	SET Var_UltimoDiaMes	:= LAST_DAY (Par_Fecha);
	SET Var_PrimerDiaMesAct	:= CONVERT(DATE_ADD(Var_FechaActual, INTERVAL -1*(DAY(Var_FechaActual))+1 DAY),DATE);
	SET Var_UltimoDiaMesAct := LAST_DAY (Var_FechaActual);

	IF(ifnull(Par_CuentaAhoID, Entero_Cero))= Entero_Cero THEN
		SET Par_NumErr      := 1;
		SET Par_ErrMen      := 'El numero de Cuenta esta vacio.' ;
		SET Var_Control		:= 'cuentaAhoID';
		LEAVE ManejoErrores;
	END IF;

	IF(ifnull(Par_NumeroMov, Entero_Cero))= Entero_Cero THEN
		SET Par_NumErr      := 2;
		SET Par_ErrMen      := 'El numero de Movimiento esta vacio.' ;
		SET Var_Control		:= 'cuentaAhoID';
		LEAVE ManejoErrores;
	END IF;

	IF(ifnull(Par_Fecha, Fecha_Vacia)) = Fecha_Vacia THEN
		SET Par_NumErr      := 3;
		SET Par_ErrMen      := 'La fecha esta Vacia.';
		SET Var_Control		:= 'cuentaAhoID';
		LEAVE ManejoErrores;
	END IF;

	IF(ifnull(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr      := 4;
		SET Par_ErrMen      := 'La naturaleza del Movimiento esta vacia.';
		SET Var_Control		:= 'cuentaAhoID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_NatMovimiento<>Nat_Cargo)THEN
		IF(Par_NatMovimiento<>Nat_Abono)THEN
			SET Par_NumErr      := 5;
			SET Par_ErrMen      := 'La naturaleza del Movimiento no es correcta.';
			SET Var_Control		:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(Par_NatMovimiento<>Nat_Abono)THEN
		IF(Par_NatMovimiento<>Nat_Cargo)THEN
			SET Par_NumErr      := 6;
			SET Par_ErrMen      := 'La naturaleza del Movimiento no es correcta.';
			SET Var_Control		:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(ifnull(Par_CantidadMov, DECIMAL_Cero))= DECIMAL_Cero THEN
		SET Par_NumErr      := 7;
		SET Par_ErrMen      := 'La Cantidad esta Vacia.';
		SET Var_Control		:= 'cuentaAhoID';
		LEAVE ManejoErrores;
	END IF;

	IF(ifnull(Par_DescripcionMov, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr      := 8;
		SET Par_ErrMen      := 'La Descripcion del Movimiento esta vacia.' ;
		SET Var_Control		:= 'cuentaAhoID';
		LEAVE ManejoErrores;
	END IF;

	IF(ifnull(Par_ReferenciaMov, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr      := 9;
		SET Par_ErrMen      := 'La Referencia esta vacia.';
		SET Var_Control		:= 'cuentaAhoID';
		LEAVE ManejoErrores;
	END IF;

	IF(ifnull(Par_TipoMovAhoID, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr      := 10;
		SET Par_ErrMen      := 'El Tipo de Movimiento esta vacio.';
		SET Var_Control		:= 'cuentaAhoID';
		LEAVE ManejoErrores;
	END IF;

	CALL SALDOSAHORROCON( Cliente,	SaldoDisp,	MonedaCon,	EstatusC,	Par_CuentaAhoID);
	IF(ifnull(EstatusC, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr      := 11;
		SET Par_ErrMen      := 'La Cuenta no existe.';
		SET Var_Control		:= 'cuentaAhoID';
		LEAVE ManejoErrores;
	END IF;

	IF(EstatusC<>EstatusActivo) THEN
		SET Par_NumErr      := 12;
		SET Par_ErrMen      := CONCAT('No se Puede hacer movimientos en esta Cuenta. Estatus',Var_EstatusDes, ' Cuenta: ', Par_CuentaAhoID) ;
		SET Var_Control		:= 'cuentaAhoID';
		LEAVE ManejoErrores;
	END IF;

	IF (EstatusC	='R') THEN
		SET Var_EstatusDes :='REGISTRADA';
	ELSEIF(EstatusC	='A') THEN
		SET Var_EstatusDes :='ACTIVA';
	ELSEIF(EstatusC	='B') THEN
		SET Var_EstatusDes :='BLOQUEADA';
	ELSEIF(EstatusC	='I') THEN
		SET Var_EstatusDes :='INACTIVA';
	ELSEIF( EstatusC ='C') THEN
		SET Var_EstatusDes :='CANCELADA';
	END IF;

	-- SI EL MOVIMIENTO ES UN CARGO
	IF(Par_NatMovimiento = Nat_Cargo)THEN
		IF(SaldoDisp<Par_CantidadMov) THEN
			SET Par_NumErr      := 13;
			SET Par_ErrMen      := 'Saldo insuficiente.';
			SET Var_Control		:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

		UPDATE `HIS-CUENTASAHO` SET
			CargosDia		= CargosDia		+ Par_CantidadMov,
			CargosMes		= CargosMes		+ Par_CantidadMov,
			Saldo 			= Saldo			- Par_CantidadMov,
			SaldoDispon		= SaldoDispon	- Par_CantidadMov,
			EmpresaID		= Aud_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE CuentaAhoID 	= Par_CuentaAhoID
			AND Fecha >= Var_PrimerDiaMes AND Fecha <= Var_UltimoDiaMes ;

		UPDATE `HIS-CUENTASAHO` SET
			SaldoIniMes		= SaldoIniMes	- Par_CantidadMov,
			Saldo 			= Saldo	-  Par_CantidadMov ,
			SaldoDispon		= SaldoDispon	- Par_CantidadMov,
			EmpresaID		= Aud_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE CuentaAhoID 	= Par_CuentaAhoID
			AND Fecha > Var_UltimoDiaMes;

		UPDATE CUENTASAHO SET
			SaldoIniMes		= SaldoIniMes	- Par_CantidadMov,
			Saldo 			= Saldo			- Par_CantidadMov,
			SaldoDispon		= SaldoDispon	- Par_CantidadMov,
			EmpresaID		= Aud_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE CuentaAhoID 	= Par_CuentaAhoID;
	END IF;

	-- SI EL MOVIMIENTO ES UN ABONO
	IF(Par_NatMovimiento = Nat_Abono)THEN
		/* ACTUALIZA EN EL HISTORICO DEL MES DEL MOVIMIENTO*/
		UPDATE `HIS-CUENTASAHO` SET
			AbonosDia		= AbonosDia		+ Par_CantidadMov,
			AbonosMes		= AbonosMes		+ Par_CantidadMov,
			Saldo 			= Saldo			+ Par_CantidadMov,
			SaldoDispon		= SaldoDispon	+ Par_CantidadMov,
			EmpresaID		= Aud_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE CuentaAhoID 	= Par_CuentaAhoID
		AND Fecha >= Var_PrimerDiaMes AND Fecha <= Var_UltimoDiaMes;

		/* ACTUALIZA LOS MESES POSTERIORES AL MES DEL MOVIMIENTO EN CASO QUE LOS HUBIERA */
		UPDATE `HIS-CUENTASAHO` SET
			SaldoIniMes		= SaldoIniMes	+ Par_CantidadMov,
			Saldo 			= Saldo			+ Par_CantidadMov,
			SaldoDispon		= SaldoDispon	+ Par_CantidadMov,
			EmpresaID		= Aud_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE CuentaAhoID 	= Par_CuentaAhoID
		AND Fecha > Var_UltimoDiaMes AND Fecha <= Var_UltimoDiaMesAct;

        /* ACTUALIZA EL SALDO ACTUAL DE LA CUENTA */
		UPDATE CUENTASAHO SET
			SaldoIniMes		= SaldoIniMes	+ Par_CantidadMov,
			Saldo 			= Saldo			+ Par_CantidadMov,
			SaldoDispon		= SaldoDispon	+ Par_CantidadMov,
			EmpresaID		= Aud_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE CuentaAhoID 	= Par_CuentaAhoID;
	END IF;

	/* SE OBTIENE EL TIPO DE MOVIMIENTO PARA SABER SI FUE EN EFECTIVO*/
	SET Var_TipoMovID	:= (SELECT TipoMovAhoID
								FROM TIPOSMOVSAHO
								WHERE TipoMovAhoID = Par_TipoMovAhoID and EsEfectivo = Var_Si);
	IF(ifnull(Var_TipoMovID, Cadena_Vacia) != Cadena_Vacia) THEN
		call EFECTIVOMOVSALT(
			Par_CuentaAhoID,		Par_NumeroMov	,		Par_Fecha,			Par_NatMovimiento	,	Par_CantidadMov,
			Par_DescripcionMov,		Par_ReferenciaMov,		Par_TipoMovAhoID,	MonedaCon,				Cliente,
			Aud_EmpresaID	,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion
		);

	END IF;

	INSERT `HIS-CUENAHOMOV` (
		CuentaAhoID,			NumeroMov,			Fecha,				NatMovimiento,			CantidadMov,
		DescripcionMov,			ReferenciaMov,		TipoMovAhoID,		MonedaID,				EmpresaID,
		Usuario,				FechaActual,		DireccionIP,		ProgramaID,				Sucursal,
		NumTransaccion)
	VALUES(
		Par_CuentaAhoID,		Aud_NumTransaccion,	Par_Fecha,			Par_NatMovimiento,		Par_CantidadMov,
		Par_DescripcionMov,		Par_ReferenciaMov,	Par_TipoMovAhoID,	MonedaCon,				Aud_EmpresaID,
		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
		Aud_NumTransaccion
	);

	# ÚNICAMENTE TIPOS DE MOVIMIENTO EN EFECTIVO.
	IF(ifnull(Var_TipoMovID, Cadena_Vacia) != Cadena_Vacia) THEN
		# DETECCIÓN DE OPERACIONES RELEVANTES.
		CALL PLDOPERELEVPRO(
			Aud_Sucursal,		Par_CuentaAhoID,	Par_CantidadMov,	Par_Fecha,				Aud_NumTransaccion,
			Par_NatMovimiento,	MonedaCon,			Par_TipoMovAhoID,	Par_DescripcionMov,		Salida_NO,
			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	SET Par_NumErr      := 0;
	SET Par_ErrMen      := 'Movimiento Registrado Exitosamente.';
	SET Var_Control		:= 'cuentaAhoID';
END ManejoErrores;

-- SI LA SALIDA ES SI DEVUELVE EL MENSAJE DE EXITO
IF (Par_Salida = Var_SI) THEN
    SELECT	Par_NumErr,
			Par_ErrMen,
			Var_Control,
			Par_Consecutivo;
END IF;

END TerminaStore$$