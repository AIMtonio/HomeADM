-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTAATMPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTAATMPRO`;
DELIMITER $$


CREATE PROCEDURE `CONTAATMPRO`(
	Par_CajeroID			VARCHAR(20),
	Par_CantidadMov			DECIMAL(12,2),
	Par_DescripcionMov		VARCHAR(150),
	Par_MonedaID			INT,
	Par_AltaEncPoliza		CHAR(1),

	Par_AltaDetPol			CHAR(1),
	Par_ConceptoCon			INT,
	Par_NatConta			CHAR(1),
	Par_ReferDetPol			VARCHAR(200),
	Par_InstruDetPol		VARCHAR(20),

	Par_TipoAfectacion		CHAR(1),
	Par_AfectarSaldo		CHAR(1),
	Par_NaturalezaOp		CHAR(1),
	Par_Fecha				DATE,
	Par_TipoInstrumento		INT(11),

    Par_NumeroTarjeta		VARCHAR(16),
	INOUT Par_Poliza		BIGINT,
	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT

	)

TerminaStore:BEGIN


	DECLARE Var_Cargos	 			DECIMAL(14,2);
	DECLARE Var_Abonos				DECIMAL(14,2);
	DECLARE Var_MonedaBaseID		INT;
	DECLARE Var_MonedaExtrangeraID	INT;
	DECLARE Var_Control				VARCHAR(50);


	DECLARE Salida_SI 			CHAR(1);
	DECLARE Salida_NO 			CHAR(1);
	DECLARE AltaEncabePoliza_SI	CHAR(1);
	DECLARE AltaDetPoliza_SI	CHAR(1);
	DECLARE	Pol_Automatica		CHAR(1);

    DECLARE Nat_Cargo			CHAR(1);
	DECLARE Nat_Abono			CHAR(1);
	DECLARE	Decimal_Cero		DECIMAL(14,2);
	DECLARE Entero_Cero			INT;
	DECLARE Cadena_Vacia		CHAR;

    DECLARE AfectarSaldoSI		CHAR(1);


	SET Salida_NO			:='N';
	SET Salida_SI			:='S';
	SET AltaEncabePoliza_SI	:='S';
	SET AltaDetPoliza_SI	:='S';
	SET	Pol_Automatica		:='A';

    SET Nat_Cargo			:='C';
	SET Nat_Abono			:='A';
	SET Decimal_Cero		:=0.0;
	SET Entero_Cero			:=0;
	SET Cadena_Vacia		:='';

    SET AfectarSaldoSI		:='S';

    ManejoErrores:BEGIN

	SELECT  MonedaBaseID,MonedaExtrangeraID  INTO Var_MonedaBaseID, Var_MonedaExtrangeraID FROM PARAMETROSSIS LIMIT 1;

	SET Var_MonedaBaseID = IFNULL(Var_MonedaBaseID, Entero_Cero);
	SET Var_MonedaExtrangeraID = IFNULL(Var_MonedaExtrangeraID, Entero_Cero);
	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := Cadena_Vacia;

	IF (IFNULL(Par_CajeroID,Cadena_Vacia) = Cadena_Vacia)THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := "El Numero de Cajero esta Vacio";
		SET Var_Control:='cajeroID';
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Par_MonedaID,Entero_Cero) = Entero_Cero)THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := "La Moneda esta Vacia";
		SET Var_Control	:= 'monedaID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_AltaEncPoliza = AltaEncabePoliza_SI)THEN
		CALL MAESTROPOLIZAALT(
			Par_Poliza,			Par_EmpresaID,		Par_Fecha, 		Pol_Automatica,		Par_ConceptoCon,
			Par_DescripcionMov,	Salida_NO, 			Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	ELSE
		IF (IFNULL(Par_Poliza,Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := "El Numero de Poliza esta Vacio";
			SET Var_Control	:= 'cajeroID';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(Par_AltaDetPol = AltaDetPoliza_SI)THEN
		IF(Par_NatConta = Nat_Cargo) THEN
			SET	Var_Cargos	:= Par_CantidadMov;
			SET	Var_Abonos	:= Decimal_Cero;
		ELSE
			SET	Var_Cargos	:= Decimal_Cero;
			SET	Var_Abonos	:= Par_CantidadMov;
		END IF;

		CALL POLIZAATMPRO(
			Par_CajeroID,			Par_Poliza,			Par_Fecha,				Par_InstruDetPol,	Par_MonedaID,
			Var_Cargos,				Var_Abonos, 		Par_DescripcionMov,		Par_ReferDetPol,	Par_TipoAfectacion,
			Par_TipoInstrumento,	Par_NumeroTarjeta,	Salida_NO,				Par_NumErr,			Par_ErrMen,
			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
            Aud_Sucursal,			Aud_NumTransaccion);

	END IF;

	IF(Par_AfectarSaldo = AfectarSaldoSI)THEN
		IF(Par_NaturalezaOp = Nat_Abono)THEN
			IF(Par_MonedaID = Var_MonedaBaseID)THEN
				UPDATE CATCAJEROSATM SET
						SaldoMN	=SaldoMN +	Par_CantidadMov
					WHERE CajeroID = Par_CajeroID;
			ELSEIF(Par_MonedaID = Var_MonedaExtrangeraID)THEN
				UPDATE CATCAJEROSATM SET
						SaldoME	=SaldoME +	Par_CantidadMov
					WHERE CajeroID = Par_CajeroID;
			END IF;
		ELSEIF(Par_NaturalezaOp = Nat_Cargo )THEN
				IF(Par_MonedaID = Var_MonedaBaseID)THEN
				UPDATE CATCAJEROSATM SET
						SaldoMN	=SaldoMN -	Par_CantidadMov
					WHERE CajeroID = Par_CajeroID;
			ELSEIF(Par_MonedaID = Var_MonedaExtrangeraID)THEN
				UPDATE CATCAJEROSATM SET
						SaldoME	=SaldoME -	Par_CantidadMov
					WHERE CajeroID = Par_CajeroID;
			END IF;
		END IF;

	END IF;
	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := "Proceso Realizado Correctamente";

	END ManejoErrores;
		IF (Par_Salida = Salida_SI) THEN
			SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Par_CajeroID AS consecutivo;
		END IF;

END TerminaStore$$