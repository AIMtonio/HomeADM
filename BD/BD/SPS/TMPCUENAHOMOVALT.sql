-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCUENAHOMOVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPCUENAHOMOVALT`;DELIMITER $$

CREATE PROCEDURE `TMPCUENAHOMOVALT`(
	Par_CuentaAhoID		BIGINT(12),
	Par_NumeroMov		BIGINT(20),
	Par_Fecha			DATE,
	Par_NatMovimiento	CHAR(1),
	Par_CantidadMov		FLOAT,
	Par_DescripcionMov	VARCHAR(150),
	Par_ReferenciaMov	VARCHAR(35),
	Par_TipoMovAhoID	CHAR(4),

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(20),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20),
	INOUT NumErr		INT(11),
	INOUT ErrMen		VARCHAR(400)
	)
TerminaStore: BEGIN
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT;
	DECLARE	Float_Cero		FLOAT;
	DECLARE	EstatusActual	CHAR(1);
	DECLARE	EstatusActivo	CHAR(1);
	DECLARE	Nat_Cargo		CHAR(1);
	DECLARE	Nat_Abono		CHAR(1);
	DECLARE	SaldoDisp		FLOAT;
	DECLARE	MonedaCon		INT;
	DECLARE	Cliente			INT;
	DECLARE	EstatusC		CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Fecha			DATE;
	DECLARE	Var_ClienteID 	INT;
	DECLARE	Var_PolizaID	BIGINT;
	DECLARE Salida_NO 		CHAR(1);
	DECLARE Pol_Automatica	CHAR(1);

	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Fecha			:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET	Float_Cero		:= 0.0;
	SET	EstatusActual	:= '';
	SET	EstatusActivo	:= 'A';
	SET	Nat_Cargo		:= 'C';
	SET	Nat_Abono		:= 'A';
	SET	SaldoDisp		:= 0.0;
	SET	MonedaCon		:= 1;
	SET	Cliente			:= 1;
	SET	EstatusC		:= '';
	SET	Salida_NO		:= 'N';
	SET	Pol_Automatica	:= 'A';

	IF(IFNULL(Par_CuentaAhoID, Entero_Cero))= Entero_Cero THEN
		SET NumErr := 1;
		SET ErrMen := 'El numero de Cuenta esta vacio.';

		LEAVE TerminaStore;
	END IF;

	IF(NOT EXISTS(SELECT CuentaAhoID
			FROM CUENTASAHO
			WHERE CuentaAhoID = Par_CuentaAhoID)) THEN
		SET NumErr := 2;
		SET ErrMen := 'La Cuenta no existe.';

	LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_NumeroMov, Entero_Cero))= Entero_Cero THEN
		SET NumErr := 3;
		SET ErrMen := 'El numero de Movimiento esta vacio.';

		LEAVE TerminaStore;
	END IF;

	IF(Par_Fecha=Fecha_Vacia)THEN
		SET Par_Fecha := Fecha;
	END IF;

	IF(IFNULL(Par_Fecha, Fecha)) = Fecha THEN
		SET NumErr := 4;
		SET ErrMen := 'La fecha esta Vacia.';

		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia THEN
		SET NumErr := 5;
		SET ErrMen := 'La naturaleza del Movimiento esta vacia.';

		LEAVE TerminaStore;
	END IF;

	IF(Par_NatMovimiento<>Nat_Cargo)THEN
		IF(Par_NatMovimiento<>Nat_Abono)THEN
		SET NumErr := 6;
		SET ErrMen := 'La naturaleza del Movimiento no es correcta.';

			LEAVE TerminaStore;
		END IF;
	END IF;

	IF(Par_NatMovimiento<>Nat_Abono)THEN
		IF(Par_NatMovimiento<>Nat_Cargo)THEN
			SET NumErr := 7;
		SET ErrMen := 'La naturaleza del Movimiento no es correcta.';

			LEAVE TerminaStore;
		END IF;
	END IF;

	IF(IFNULL(Par_CantidadMov, Float_Cero))= Float_Cero THEN
		SET NumErr := 8;
		SET ErrMen := 'La Cantidad esta Vacia.';

		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_DescripcionMov, Cadena_Vacia)) = Cadena_Vacia THEN
		SET NumErr := 9;
		SET ErrMen := 'La Descripcion del Movimiento esta vacia.';

		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_ReferenciaMov, Cadena_Vacia)) = Cadena_Vacia THEN
		SET NumErr := 10;
		SET ErrMen := 'La Referencia esta vacia.';

		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_TipoMovAhoID, Cadena_Vacia)) = Cadena_Vacia THEN
		SET NumErr := 11;
		SET ErrMen := 'El Tipo de Movimiento esta vacio.';

		LEAVE TerminaStore;
	END IF;


	CALL TMPMAESTROPOLALT(
		Var_PolizaID,		Aud_EmpresaID,	Aud_FechaActual, 	Pol_Automatica,	1,
		'DEPOSITO EN EFECTIVO',	Salida_NO, 	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


	IF(Par_NatMovimiento=Nat_Cargo)THEN
		CALL SALDOSAHORROCON(Cliente,SaldoDisp,MonedaCon,EstatusC,Par_CuentaAhoID);
		IF(EstatusC=EstatusActivo) THEN
		 	IF(SaldoDisp>=Par_CantidadMov) THEN
				CALL TMPSALDOSAHOACT(Par_CuentaAhoID, Par_NatMovimiento,Par_CantidadMov);
		 	END IF;
			IF(SaldoDisp<Par_CantidadMov) THEN
				SET NumErr := 12;
				SET ErrMen := 'Saldo insuficiente.';

					LEAVE TerminaStore;
		 	END IF;
		END IF;
		IF(EstatusC<>EstatusActivo) THEN
			SET NumErr := 13;
			SET ErrMen := 'No se Puede hacer movimientos en esta Cuenta.';

			LEAVE TerminaStore;
		END IF;
	END IF;

	IF(Par_NatMovimiento=Nat_Abono)THEN
		SET EstatusActual:= (SELECT 		Estatus
						FROM		CUENTASAHO
						WHERE		CuentaAhoID = Par_CuentaAhoID
						);
		IF(EstatusActual=EstatusActivo) THEN
			CALL TMPSALDOSAHOACT(Par_CuentaAhoID, Par_NatMovimiento,Par_CantidadMov);
		END IF;
		IF(EstatusActual<>EstatusActivo) THEN
			SET NumErr := 14;
			SET ErrMen := 'No se Puede hacer movimientos en esta Cuenta.';

			LEAVE TerminaStore;
		END IF;
	END IF;
	SET Var_ClienteID:= (SELECT ClienteID FROM CUENTASAHO WHERE CuentaAhoID=Par_CuentaAhoID);
	CALL TMPPOLIZAAHOPRO(
		Var_PolizaID,		Aud_EmpresaID,	Aud_FechaActual, 		Var_ClienteID,		1,
		Par_CuentaAhoID,	MonedaCon,		Par_CantidadMov,		Entero_Cero,			Par_DescripcionMov,
		Par_ReferenciaMov,	Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

	CALL TMPPOLIZAAHOPRO(
		Var_PolizaID,		Aud_EmpresaID,	Aud_FechaActual, 		Var_ClienteID,		1,
		Par_CuentaAhoID,	MonedaCon,		Entero_Cero,			Par_CantidadMov,		Par_DescripcionMov,
		Par_ReferenciaMov,	Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);


	SET Aud_FechaActual := CURRENT_TIMESTAMP();
	INSERT INTO CUENTASAHOMOV(
		CuentaAhoID,	    NumeroMov,	            Fecha,				NatMovimiento,			CantidadMov,
		DescripcionMov,	 	ReferenciaMov,			TipoMovAhoID,		MonedaID,	  			EmpresaID,
		Usuario,			FechaActual,			DireccionIP, 		ProgramaID,				Sucursal,
		NumTransaccion)
	VALUES(
		Par_CuentaAhoID,	Aud_NumTransaccion,		Par_Fecha,			Par_NatMovimiento,		Par_CantidadMov,
        Par_DescripcionMov,	Par_ReferenciaMov,		Par_TipoMovAhoID,	MonedaCon,				Aud_EmpresaID,
        Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
        Aud_NumTransaccion);

	SET NumErr := 0;
	SET ErrMen := 'Movimiento Agregado.';

END TerminaStore$$