-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWCONTAINVPRO
DELIMITER ;

DROP PROCEDURE IF EXISTS CRWCONTAINVPRO;

DELIMITER $$

CREATE PROCEDURE `CRWCONTAINVPRO`(
/* SP PARA EL ALTA DE MOVIMIENTOS CONTABLES PARA LA INVERSION CROWDFUNDING.*/
	Par_SolFondeoID			BIGINT,				-- ID DEL FONDEO
	Par_AmortizacionID      INT(11),			-- ID DE LA AMORTIZACION
	Par_CuentaAhoID         BIGINT,				-- ID DE LA CUENTA DE AHORRO
	Par_ClienteID           BIGINT,				-- ID DEL CLIENTE
	Par_FechaOperacion      DATE,				-- FECHA DE OPERACION

	Par_FechaAplicacion     DATE,				-- FECHA DE APLICACION
	Par_Monto               DECIMAL(14,4),		-- MONTO
	Par_MonedaID            INT,				-- MONEDA
	Par_NumRetMes           INT,				-- NUMERO DE RETENCIONES EN EL MES
	Par_SucCliente          INT,				-- SUCURSAL DEL CLIENTE

	Par_Descripcion         VARCHAR(100),		-- DESCRIPCION
	Par_Referencia          VARCHAR(50),		-- REFERENCIA
	Par_AltaEncPoliza       CHAR(1),			-- ALTA DE ENCABEZADO DE LA POLIZA
	Par_ConceptoCon         INT,				-- CONCEPTO CONTABLE
	INOUT Par_Poliza		BIGINT,				-- PARAMETRO DE SALIDA POLIZA

	Par_AltaPoliza			CHAR(1),			-- ALTA DE POLIZA S-SI , N-NO
	Par_AltaMovs			CHAR(1),			-- ALTA DE MOVIMIENTOS S-SI, N-NO
	Par_ConcContaCRW		INT,				-- CONCEPTO CONTABLE
	Par_TipoMovCRWID		INT,				-- TIPO DE MOVIMIENTO CONTABLE
	Par_NatContable			CHAR(1),			-- NATURALEZA CONTABLE

	Par_NatOpera			CHAR(1),			-- NATURALEZA OPERATIVA
	Par_AltaMovAho          CHAR(1),			-- ALTA MOVIENTOS DE AHORRO
	Par_TipoMovAho          VARCHAR(4),			-- TIPO DE MOVIMIENTO DE AHORRO
	Par_NatAhorro           CHAR(1),			-- NATURALEZA DE AHORRO
	Par_Salida				CHAR(1),			-- TIPO DE SALIDA.

	INOUT Par_NumErr		INT(11),			-- NUMERO DE ERROR
	INOUT Par_ErrMen		VARCHAR(400),		-- MENSAJE DE ERROR
	INOUT Par_Consecutivo	BIGINT,				-- CONSECUTIVO
	Par_Empresa             INT(11),			-- AUDITORIA
	Aud_Usuario             INT(11),			-- AUDITORIA

	Aud_FechaActual         DATETIME,			-- AUDITORIA
	Aud_DireccionIP         VARCHAR(15),		-- AUDITORIA
	Aud_ProgramaID          VARCHAR(50),		-- AUDITORIA
	Aud_Sucursal            INT(11),			-- AUDITORIA
	Aud_NumTransaccion      BIGINT				-- AUDITORIA
)
TerminaStore: BEGIN

-- Declaración de variables.
DECLARE Var_CuentaStr       VARCHAR(20);
DECLARE Var_InvCRWStr		VARCHAR(20);
DECLARE Var_Cargos          DECIMAL(14,4);
DECLARE Var_Abonos          DECIMAL(14,4);
DECLARE Var_RefCtaAho       VARCHAR(50);
DECLARE Var_Control			VARCHAR(50);

-- Declaración de constantes.
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Entero_Cero         INT;
DECLARE Decimal_Cero        DECIMAL(12, 2);
DECLARE AltaPoliza_SI       CHAR(1);
DECLARE AltaMovAho_SI       CHAR(1);
DECLARE AltaMovCRW_SI		CHAR(1);
DECLARE AltaPolCRW_SI		CHAR(1);
DECLARE Nat_Cargo           CHAR(1);
DECLARE Nat_Abono           CHAR(1);
DECLARE Pol_Automatica      CHAR(1);
DECLARE Str_NO           	CHAR(1);
DECLARE Str_SI           	CHAR(1);
DECLARE Con_AhoCapital      INT;

-- Asignación de constantes.
SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Decimal_Cero        := 0.00;
SET AltaPoliza_SI       := 'S';
SET AltaMovAho_SI       := 'S';
SET AltaMovCRW_SI		:= 'S';
SET AltaPolCRW_SI		:= 'S';
SET Nat_Cargo           := 'C';
SET Nat_Abono           := 'A';
SET Pol_Automatica      := 'A';
SET Str_NO           	:= 'N';
SET Str_SI           	:= 'S';
SET Con_AhoCapital      := 1;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					  				'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWCONTAINVPRO');
			SET Var_Control := 'SQLEXCEPTION';
		END;

	SET Var_InvCRWStr  := CONVERT(Par_SolFondeoID, CHAR);
	SET Var_CuentaStr   := CONVERT(Par_CuentaAhoID, CHAR);

	IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
		CALL MAESTROPOLIZASALT(
			Par_Poliza,			Par_Empresa,		Par_FechaAplicacion,	Pol_Automatica,		Par_ConceptoCon,
			Par_Descripcion,	Str_NO,				Par_NumErr,				Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF (Par_AltaMovs = AltaMovCRW_SI) THEN
		CALL CRWFONDEOMOVSSALT(
			Par_SolFondeoID,	Par_AmortizacionID,	Aud_NumTransaccion, Par_FechaOperacion,     Par_FechaAplicacion,
			Par_TipoMovCRWID,	Par_NatOpera,		Par_MonedaID,       Par_Monto,              Par_Descripcion,
			Par_Referencia,		Str_NO,				Par_NumErr,			Par_ErrMen,				Par_Consecutivo,
			Par_Empresa,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF (Par_AltaPoliza = AltaPolCRW_SI) THEN
		IF(Par_NatContable = Nat_Cargo) THEN
			SET Var_Cargos  := Par_Monto;
			SET Var_Abonos  := Decimal_Cero;
		ELSE
			SET Var_Cargos  := Decimal_Cero;
			SET Var_Abonos  := Par_Monto;
		END IF;

		CALL CRWPOLIZAINVPRO(
			Par_Poliza,     	Par_Empresa,        	Par_FechaAplicacion,	Par_SolFondeoID,	Par_NumRetMes,
			Par_SucCliente, 	Par_ConcContaCRW,		Var_Cargos,         	Var_Abonos,			Par_MonedaID,
			Par_Descripcion,	Var_InvCRWStr,			Str_NO,					Par_NumErr,			Par_ErrMen,
			Par_Consecutivo,	Aud_Usuario,			Aud_FechaActual,    	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;


	IF (Par_AltaMovAho = AltaMovAho_SI  ) THEN
		IF(Par_NatAhorro = Nat_Cargo) THEN
			SET Var_Cargos  := Par_Monto;
			SET Var_Abonos  := Decimal_Cero;
		ELSE
			SET Var_Cargos  := Decimal_Cero;
			SET Var_Abonos  := Par_Monto;
		END IF;

		SET Var_RefCtaAho       := CONCAT('INV: ', Var_InvCRWStr,'-',Par_AmortizacionID);  -- Vladimir Jz, se agrega el numero de amortización para poder validar
																							-- las operaciones, el deposito por cada pago.

		CALL CUENTASAHORROMOVALT(
			Par_CuentaAhoID,    Aud_NumTransaccion, Par_FechaAplicacion,	Par_NatAhorro,		Par_Monto,
			Par_Descripcion,    Var_RefCtaAho,      Par_TipoMovAho,			Str_NO,				Par_NumErr,
			Par_ErrMen,			Par_Empresa,        Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		CALL POLIZASAHORROPRO(
			Par_Poliza,         Par_Empresa,        Par_FechaAplicacion,    Par_ClienteID,      1,
			Par_CuentaAhoID,    Par_MonedaID,       Var_Cargos,             Var_Abonos,         Par_Descripcion,
			Var_CuentaStr,      Str_NO,				Par_NumErr,				Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

	END IF;

	SET Par_NumErr  := Entero_Cero;
	SET Par_ErrMen  := 'Proceso Terminado Exitosamente';

END ManejoErrores;  -- END del Handler de Errores

	IF (Par_Salida = Str_SI) THEN
		SELECT  Par_NumErr 		AS NumErr,
				Par_ErrMen		AS ErrMen,
				'creditoID' 	AS control;
	END IF;

END TerminaStore$$
