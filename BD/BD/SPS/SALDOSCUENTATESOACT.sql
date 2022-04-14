-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSCUENTATESOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDOSCUENTATESOACT`;DELIMITER $$

CREATE PROCEDURE `SALDOSCUENTATESOACT`(




	Par_NumCtaInstit    VARCHAR(20),
	Par_InstitucionID   INT(11),
	Par_Monto			DECIMAL(14,2),
	Par_NatMovimiento 	CHAR(1),
    OUT	Par_Consecutivo	BIGINT,

	Par_Salida         	CHAR(1),
	OUT	Par_NumErr		INT,
	OUT	Par_ErrMen		VARCHAR(400),

	Aud_EmpresaID       INT,
	Aud_Usuario         INT,
	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(20),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT,
	Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN


	DECLARE Var_Control	    VARCHAR(100);
	DECLARE Var_Consecutivo	BIGINT(20);


	DECLARE Decimal_Cero 	DECIMAL(14,2);
	DECLARE Entero_Cero		INT;
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Nat_Cargo		CHAR(1);
	DECLARE Nat_Abono		CHAR(1);
	DECLARE	Salida_NO		CHAR(1);
	DECLARE	Salida_SI		CHAR(1);


	SET Decimal_Cero 		:= 0.00;
	SET Entero_Cero      	:= 0;
	SET Cadena_Vacia		:= '';
	SET Nat_Cargo			:= 'C';
	SET Nat_Abono			:= 'A';
	SET	Salida_NO       	:= 'N';
	SET Salida_SI           := 'S';



	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SALDOSCUENTATESOACT');
				SET Var_Control = 'sqlException';
			END;


		IF(IFNULL(Par_NumCtaInstit, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El número de Cta Institución esta Vacio.';
			SET Var_Control:= 'numCtaInstit' ;
			SET Var_Consecutivo := 000;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_InstitucionID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'El número de Institución esta Vacio.';
			SET Var_Control:= 'institucionID' ;
			SET Var_Consecutivo := 000;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Monto, Decimal_Cero)) = Decimal_Cero THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := 'El monto esta Vacio.';
			SET Var_Control:= 'monto' ;
			SET Var_Consecutivo := 000;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen := 'La Naturaleza del Movimiento esta Vacia.';
			SET Var_Control:= 'natMovimiento' ;
			SET Var_Consecutivo := 000;
			LEAVE ManejoErrores;
		END IF;


		IF(Par_NatMovimiento = Nat_Abono) THEN
			UPDATE	CUENTASAHOTESO	SET
				Saldo			  = Saldo + Par_Monto,

				EmpresaID     	  = Aud_EmpresaID,
				Usuario       	  = Aud_Usuario,
				FechaActual  	  = Aud_FechaActual,
				DireccionIP   	  = Aud_DireccionIP,
				ProgramaID    	  = Aud_ProgramaID,
				Sucursal     	  = Aud_Sucursal,
				NumTransaccion	  = Aud_NumTransaccion
			WHERE	InstitucionID = Par_InstitucionID
			AND		NumCtaInstit  = Par_NumCtaInstit;
		END IF;


		IF(Par_NatMovimiento = Nat_Cargo) THEN
			UPDATE	CUENTASAHOTESO	SET
				Saldo			  = Saldo - Par_Monto,

				EmpresaID		  = Aud_EmpresaID,
				Usuario			  = Aud_Usuario,
				FechaActual		  = Aud_FechaActual,
				DireccionIP		  = Aud_DireccionIP,
				ProgramaID		  = Aud_ProgramaID,
				Sucursal		  = Aud_Sucursal,
				NumTransaccion	  = Aud_NumTransaccion
			WHERE	InstitucionID = Par_InstitucionID
			AND		NumCtaInstit  = Par_NumCtaInstit;
		END IF;

		SET	Par_NumErr 	:= 000;
		SET	Par_ErrMen	:= 'Saldo Actualizado.';
		SET Var_Control	:= 'InstitucionID';
		SET Var_Consecutivo := 000;

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$