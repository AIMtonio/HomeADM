-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOMOVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOMOVALT`;DELIMITER $$

CREATE PROCEDURE `CUENTASAHOMOVALT`(

	Par_CuentaAhoID		BIGINT(12),
	Par_NumeroMov		BIGINT(20),
	Par_Fecha			DATE,
	Par_NatMovimiento	CHAR(1),
	Par_CantidadMov		DECIMAL(12,2),

	Par_DescripcionMov	VARCHAR(150),
	Par_ReferenciaMov	VARCHAR(50),
	Par_TipoMovAhoID	CHAR(4),
	Aud_EmpresaID		INT,
	Aud_Usuario			INT,

	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
	)
TerminaStore: BEGIN


DECLARE	Cliente			INT;
DECLARE	SaldoDisp		DECIMAL(12,2);
DECLARE	MonedaCon		INT;
DECLARE	EstatusC			CHAR(1);
DECLARE	Var_TipoMovID		CHAR(4);
DECLARE Var_EstatusDes		VARCHAR(50);
DECLARE Par_NumErr		INT;
DECLARE Par_ErrMen		VARCHAR(400);

DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Entero_Cero			INT;
DECLARE	Decimal_Cero		DECIMAL(12,2);
DECLARE	EstatusActual		CHAR(1);
DECLARE	EstatusActivo		CHAR(1);
DECLARE	Nat_Cargo			CHAR(1);
DECLARE	Nat_Abono			CHAR(1);
DECLARE	Fecha_Vacia			DATE;

DECLARE	Salida_NO 			CHAR(1);
DECLARE	Var_Si	 			CHAR(1);
DECLARE Est_Cancelado		CHAR(1)	;


SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.0;
SET EstatusActivo   := 'A';
SET Nat_Cargo       := 'C';
SET Nat_Abono       := 'A';
SET Salida_NO       := 'N';
SET Var_Si          := 'S';
SET Est_Cancelado	:='C';


SET SaldoDisp		:= 0.0;

IF(IFNULL(Par_CuentaAhoID, Entero_Cero))= Entero_Cero THEN
	SELECT '001' AS NumErr,
		 'El numero de Cuenta esta vacio.' AS ErrMen,
		 'cuentaAhoID' AS control,
			0 AS consecutivo;
	LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_NumeroMov, Entero_Cero))= Entero_Cero THEN
	SELECT '002' AS NumErr,
		 'El numero de Movimiento esta vacio.' AS ErrMen,
		 'numeroMov' AS control,
			0 AS consecutivo;
	LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_Fecha, Fecha_Vacia)) = Fecha_Vacia THEN
	SELECT '003' AS NumErr,
		  'La fecha esta Vacia.' AS ErrMen,
		  'fecha' AS control,
			0 AS consecutivo;
	LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia THEN
	SELECT '004' AS NumErr,
		  'La naturaleza del Movimiento esta vacia.' AS ErrMen,
		  'natMovimiento' AS control,
			0 AS consecutivo;
	LEAVE TerminaStore;
END IF;

IF(Par_NatMovimiento<>Nat_Cargo)THEN
	IF(Par_NatMovimiento<>Nat_Abono)THEN
		SELECT '005' AS NumErr,
		  'La naturaleza del Movimiento no es correcta.' AS ErrMen,
		  'natMovimiento' AS control,
			0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;
END IF;

IF(Par_NatMovimiento<>Nat_Abono)THEN
	IF(Par_NatMovimiento<>Nat_Cargo)THEN
		SELECT '006' AS NumErr,
		  'La naturaleza del Movimiento no es correcta.' AS ErrMen,
		  'natMovimiento' AS control,
			0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;
END IF;

IF(IFNULL(Par_CantidadMov, Decimal_Cero))= Decimal_Cero THEN
	SELECT '007' AS NumErr,
		 'La Cantidad esta Vacia' AS ErrMen,
		 'cantidadMov' AS control,
			0 AS consecutivo;
	LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_DescripcionMov, Cadena_Vacia)) = Cadena_Vacia THEN
	SELECT '008' AS NumErr,
		  'La Descripcion del Movimiento esta vacia.' AS ErrMen,
		  'descripcionMov' AS control,
			0 AS consecutivo;
	LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_ReferenciaMov, Cadena_Vacia)) = Cadena_Vacia THEN
	SELECT '009' AS NumErr,
		  'La Referencia esta vacia.' AS ErrMen,
		  'referenciaMov' AS control,
			0 AS consecutivo;
	LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_TipoMovAhoID, Cadena_Vacia)) = Cadena_Vacia THEN
	SELECT '010' AS NumErr,
		  'El Tipo de Movimiento esta vacio.' AS ErrMen,
		  'tipoMov' AS control,
			0 AS consecutivo;
	LEAVE TerminaStore;
END IF;

CALL SALDOSAHORROCON(
	Cliente,	SaldoDisp,	MonedaCon,	EstatusC,	Par_CuentaAhoID);


IF(IFNULL(EstatusC, Cadena_Vacia)) = Cadena_Vacia THEN
	SELECT '011' AS NumErr,
		  'La Cuenta no existe.' AS ErrMen,
		  'cuentaAhoID' AS control,
			0 AS consecutivo;
	LEAVE TerminaStore;
END IF;


IF (EstatusC	='R')		THEN
	SET Var_EstatusDes :='REGISTRADA';
ELSEIF(EstatusC	='A')THEN
	SET Var_EstatusDes :='ACTIVA';
ELSEIF(EstatusC	='B')	THEN
	SET Var_EstatusDes :='BLOQUEADA';
ELSEIF(EstatusC	='I'	)THEN
	SET Var_EstatusDes :='INACTIVA';
ELSEIF( EstatusC	='C'	)THEN
	SET Var_EstatusDes :='CANCELADA';
END IF;


IF(Par_NatMovimiento=Nat_Cargo)THEN
	IF(EstatusC=EstatusActivo) THEN
		IF(SaldoDisp>=Par_CantidadMov) THEN
			CALL SALDOSAHORROACT(Par_CuentaAhoID, Par_NatMovimiento,Par_CantidadMov);
		END IF;
		IF(SaldoDisp<Par_CantidadMov) THEN
			SELECT '012' AS NumErr,
				'Saldo insuficiente.' AS ErrMen,
				'cuentaAhoID' AS control,
			0 AS consecutivo;
				LEAVE TerminaStore;
		END IF;
	END IF;
	IF(EstatusC<>EstatusActivo) THEN
		SELECT '013' AS NumErr,
		  CONCAT('No se Puede hacer movimientos en esta Cuenta. Estatus',Var_EstatusDes, ' Cuenta: ', Par_CuentaAhoID) AS ErrMen,
		  'cuentaAhoID' AS control,
			0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;
END IF;

IF(Par_NatMovimiento=Nat_Abono)THEN
	IF(EstatusC = EstatusActivo) THEN
		CALL SALDOSAHORROACT(Par_CuentaAhoID, Par_NatMovimiento,Par_CantidadMov);
	END IF;
	IF(EstatusC <> EstatusActivo) THEN
		SELECT '014' AS NumErr,
		  CONCAT('No se Puede hacer movimientos en esta Cuenta. Estatus: ',Var_EstatusDes, ' Cuenta: ', Par_CuentaAhoID) AS ErrMen,
		  'cuentaAhoID' AS control,
			0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;
END IF;

SET Aud_FechaActual := CURRENT_TIMESTAMP();
SET Var_TipoMovID	:= (SELECT TipoMovAhoID
					    FROM TIPOSMOVSAHO
						WHERE TipoMovAhoID = Par_TipoMovAhoID AND EsEfectivo = Var_Si);


CALL PLDOPEINUALERTNUMPRO(
			Par_CuentaAhoID,	Par_NumeroMov,		Par_Fecha,			Par_NatMovimiento,	Par_CantidadMov,
			Par_DescripcionMov,	Par_ReferenciaMov,	Par_TipoMovAhoID,	MonedaCon,			Cliente,
			Salida_NO, 			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


IF(IFNULL(Var_TipoMovID, Cadena_Vacia) != Cadena_Vacia) THEN
	CALL EFECTIVOMOVSALT(	Par_CuentaAhoID,		Par_NumeroMov	,		Par_Fecha,		Par_NatMovimiento	,	Par_CantidadMov,
						Par_DescripcionMov,	Par_ReferenciaMov,	Par_TipoMovAhoID,	MonedaCon,			Cliente,
						Aud_EmpresaID	,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
						Aud_Sucursal,			Aud_NumTransaccion
	);

END IF;

INSERT INTO CUENTASAHOMOV( CuentaAhoID,	     NumeroMov,	            Fecha,			NatMovimiento,	CantidadMov,
						   DescripcionMov,	 ReferenciaMov,			TipoMovAhoID,	MonedaID,	  	EmpresaID,
						   Usuario,			 FechaActual,			DireccionIP, 	ProgramaID,		Sucursal,
						   NumTransaccion)
 VALUES(
	Par_CuentaAhoID,		Aud_NumTransaccion,		Par_Fecha,				Par_NatMovimiento,		Par_CantidadMov,
	Par_DescripcionMov,	    Par_ReferenciaMov,			Par_TipoMovAhoID,	MonedaCon,				Aud_EmpresaID,
	Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
	Aud_NumTransaccion);


END TerminaStore$$