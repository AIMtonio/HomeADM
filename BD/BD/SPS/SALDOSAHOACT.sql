-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSAHOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDOSAHOACT`;DELIMITER $$

CREATE PROCEDURE `SALDOSAHOACT`(



	Par_CuentaAhoID 	BIGINT(12),
	Par_NatMovimiento 	CHAR(1),
	Par_CantidadMov		DECIMAL(12,2),

    Par_Salida         	CHAR(1),
	OUT	Par_NumErr		INT,
	OUT	Par_ErrMen		VARCHAR(400),

    Par_EmpresaID       INT,
	Aud_Usuario         INT,
	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(20),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT,
	Aud_NumTransaccion  BIGINT(20)
	)
TerminaStore: BEGIN


	DECLARE Var_Control	    	VARCHAR(100);
	DECLARE Var_Consecutivo		BIGINT(20);


	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT;
	DECLARE	Float_Cero			FLOAT;
	DECLARE	Nat_Cargo			CHAR(1);
	DECLARE	Nat_Abono			CHAR(1);
	DECLARE	Salida_NO			CHAR(1);
	DECLARE	Salida_SI			CHAR(1);

	SET	Cadena_Vacia	:= '';
	SET	Entero_Cero		:= 0;
	SET	Float_Cero		:= 0.0;
	SET	Nat_Cargo		:= 'C';
	SET	Nat_Abono		:= 'A';
	SET	Salida_NO       := 'N';
	SET Salida_SI       := 'S';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SALDOSAHOACT');
				SET Var_Control = 'sqlException';
			END;

		IF(IFNULL(Par_CuentaAhoID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr	:=	001;
			SET Par_ErrMen	:=	'El numero de Cuenta esta vacio.';
			SET Var_Control	:=	'cuentaAhoID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(NOT EXISTS(SELECT	CuentaAhoID
			FROM CUENTASAHO
			WHERE	CuentaAhoID = Par_CuentaAhoID)) THEN
				SET Par_NumErr	:=	002;
				SET Par_ErrMen	:=	'La Cuenta no existe';
				SET Var_Control	:=	'cuentaAhoID' ;
				LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr	:=	003;
			SET Par_ErrMen	:=	'La naturaleza del Movimiento esta vacia.';
			SET Var_Control	:=	'natMovimiento' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NatMovimiento<>Nat_Cargo) THEN
			IF(Par_NatMovimiento<>Nat_Abono) THEN
				SET Par_NumErr	:=	004;
				SET Par_ErrMen	:=	'La naturaleza del Movimiento no es correcta.';
				SET Var_Control	:=	'natMovimiento' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_NatMovimiento<>Nat_Abono) THEN
			IF(Par_NatMovimiento<>Nat_Cargo) THEN
				SET Par_NumErr	:=	005;
				SET Par_ErrMen	:=	'La naturaleza del Movimiento no es correcta.';
				SET Var_Control	:=	'natMovimiento' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_CantidadMov, Float_Cero))= Float_Cero THEN
			SET Par_NumErr	:=	006;
			SET Par_ErrMen	:=	'La Cantidad esta Vacia.';
			SET Var_Control	:=	'cantidadMov' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NatMovimiento = Nat_Abono) THEN
			UPDATE	CUENTASAHO SET
				AbonosDia		= AbonosDia		+Par_CantidadMov,
				AbonosMes		= AbonosMes		+Par_CantidadMov,
				Saldo 			= (SaldoDispon + SaldoBloq) + Par_CantidadMov,
				SaldoDispon		= (((SaldoDispon + SaldoBloq + SaldoSBC) + Par_CantidadMov) - SaldoBloq - SaldoSBC),

				EmpresaID		= Par_EmpresaID,
				Usuario        	= Aud_Usuario,
				FechaActual    	= Aud_FechaActual,
				DireccionIP    	= Aud_DireccionIP,
				ProgramaID     	= Aud_ProgramaID,
				Sucursal	   	= Aud_Sucursal,
				NumTransaccion 	= Aud_NumTransaccion
			WHERE	CuentaAhoID = Par_CuentaAhoID;
		END IF;

		IF(Par_NatMovimiento = Nat_Cargo) THEN
			UPDATE	CUENTASAHO SET
				CargosDia		= CargosDia		+Par_CantidadMov,
				CargosMes		= CargosMes		+Par_CantidadMov,
				Saldo 			= (SaldoDispon + SaldoBloq) - Par_CantidadMov,
				SaldoDispon		= (((SaldoDispon + SaldoBloq + SaldoSBC) - Par_CantidadMov) - SaldoBloq - SaldoSBC),

				EmpresaID		= Par_EmpresaID,
				Usuario        	= Aud_Usuario,
				FechaActual    	= Aud_FechaActual,
				DireccionIP    	= Aud_DireccionIP,
				ProgramaID     	= Aud_ProgramaID,
				Sucursal	   	= Aud_Sucursal,
				NumTransaccion 	= Aud_NumTransaccion
			WHERE	CuentaAhoID = Par_CuentaAhoID;
		END IF;

		SET	Par_NumErr 	:= 000;
		SET	Par_ErrMen	:= 'Transaccion Realizada Correctamente';
		SET Var_Control	:= 'cuentaAhoID';

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$