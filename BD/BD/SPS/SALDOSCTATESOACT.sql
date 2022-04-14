-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSCTATESOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDOSCTATESOACT`;
DELIMITER $$


CREATE PROCEDURE `SALDOSCTATESOACT`(
/* se utiliza para hacer un Cargo o un Abono a algun registro de la tabla CUENTASAHOTESO*/
	Par_NumCtaInstit     	VARCHAR(20),
	Par_InstitucionID    	INT(11),
        Par_Monto           DECIMAL(14,4),
	Par_NatMovimiento 	CHAR(1), -- C .- Cargo A.- Abono

	Par_Salida         	CHAR(1),
	OUT	Par_NumErr			INT(11),
	OUT	Par_ErrMen			VARCHAR(400),
	OUT	Par_Consecutivo		BIGINT,
	Aud_EmpresaID        	INT,
	Aud_Usuario          	INT,
	Aud_FechaActual      	DATETIME,
	Aud_DireccionIP      	VARCHAR(20),
	Aud_ProgramaID       	VARCHAR(50),
	Aud_Sucursal         	INT,
	Aud_NumTransaccion   	BIGINT(20)
	)

TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE Decimal_Cero 	DECIMAL(14,2);
DECLARE Entero_Cero	INT;
DECLARE Cadena_Vacia	CHAR(1);
DECLARE Nat_Cargo		CHAR(1);
DECLARE Nat_Abono		CHAR(1);
DECLARE Salida_SI     CHAR(1);

-- Declaracion de Variables
-- Asignacion de Constantes
SET Decimal_Cero 		:= 0.00;
SET Entero_Cero      	:= 0;
SET Cadena_Vacia		:= '';
SET Nat_Cargo			:= 'C';
SET Nat_Abono			:= 'A';
SET Salida_SI        	:= 'S';

-- Asignacion de Variables

-- Se valida que los parametros necesarios tengan valores
IF(IFNULL(Par_NumCtaInstit, Cadena_Vacia)) = Cadena_Vacia THEN
    IF (Par_Salida = Salida_SI) THEN
        SELECT 1 AS NumErr,
             'El Numero de Cta Institucion esta Vacio.' AS ErrMen,
             'numCtaInstit' AS control;
    ELSE
        SET Par_NumErr      := 1;
        SET Par_ErrMen      := 'El numero de Cta Institucion esta Vacio.';
        SET Par_Consecutivo := Entero_Cero;
    END IF;

    LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_InstitucionID, Entero_Cero)) = Entero_Cero THEN
    IF (Par_Salida = Salida_SI) THEN
        SELECT 2 AS NumErr,
             'El numero de Institucion esta Vacio.' AS ErrMen,
             'institucionID' AS control;
    ELSE
        SET Par_NumErr      := 2;
        SET Par_ErrMen      := 'El numero de Institucion esta Vacio.';
        SET Par_Consecutivo := Entero_Cero;
    END IF;
    LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_Monto, Decimal_Cero)) = Decimal_Cero THEN
    IF (Par_Salida = Salida_SI) THEN
        SELECT 3 AS NumErr,
             'El monto esta Vacio.' AS ErrMen,
             'monto' AS control;
    ELSE
        SET Par_NumErr      := 3;
        SET Par_ErrMen      := 'El Monto esta Vacio.';
        SET Par_Consecutivo := Entero_Cero;
    END IF;
    LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia THEN
    IF (Par_Salida = Salida_SI) THEN
        SELECT 4 AS NumErr,
             'La Naturaleza del Movimiento esta Vacia.' AS ErrMen,
             'natMovimiento' AS control;
    ELSE
        SET Par_NumErr      := 4;
        SET Par_ErrMen      := 'La Naturaleza del Movimiento esta Vacia.';
        SET Par_Consecutivo := Entero_Cero;
    END IF;
    LEAVE TerminaStore;
END IF;

-- Se hace un Abono a la tabla CUENTASAHOTESO
IF(Par_NatMovimiento = Nat_Abono) THEN
	UPDATE CUENTASAHOTESO SET
		Saldo	     = Saldo + Par_Monto,

		EmpresaID     = Aud_EmpresaID,
		Usuario       = Aud_Usuario,
		FechaActual   = Aud_FechaActual,
		DireccionIP   = Aud_DireccionIP,
		ProgramaID    = Aud_ProgramaID,
		Sucursal      = Aud_Sucursal,
		NumTransaccion= Aud_NumTransaccion
	WHERE InstitucionID   = Par_InstitucionID
	 AND NumCtaInstit     = Par_NumCtaInstit;

END IF;

-- Se hace un Cargo a la tabla CUENTASAHOTESO
IF(Par_NatMovimiento = Nat_Cargo) THEN
	UPDATE CUENTASAHOTESO SET
		Saldo	     = Saldo - Par_Monto,

		EmpresaID     = Aud_EmpresaID,
		Usuario       = Aud_Usuario,
		FechaActual   = Aud_FechaActual,
		DireccionIP   = Aud_DireccionIP,
		ProgramaID    = Aud_ProgramaID,
		Sucursal      = Aud_Sucursal,
		NumTransaccion= Aud_NumTransaccion
	WHERE InstitucionID   = Par_InstitucionID
	 AND NumCtaInstit     = Par_NumCtaInstit;
END IF;
IF (Par_Salida = Salida_SI) THEN
    SELECT 0 AS NumErr,
		'Saldo Actualizado.',
		'InstitucionID' AS control,
		Entero_Cero AS consecutivo;
ELSE
    SET Par_NumErr      := 0;
    SET Par_ErrMen      := 'Saldo Actualizado.';
    SET Par_Consecutivo := Entero_Cero;
END IF;


END TerminaStore$$