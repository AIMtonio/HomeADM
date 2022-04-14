-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWFONTRASEXIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWFONTRASEXIPRO`;
DELIMITER $$

CREATE PROCEDURE `CRWFONTRASEXIPRO`(
	Par_Fecha				DATE,				-- FECHA DE APLICACION
	Par_EmpresaID			INT(11),			-- NUMERO DE EMPRESA
	Par_Salida				CHAR(1),			-- TIPO DE SALIDA.
	INOUT Par_NumErr		INT(11),			-- NUMERO DE ERROR
	INOUT Par_ErrMen		VARCHAR(400),		-- MENSAJE DE ERROR

	Aud_Usuario				INT(11),				-- AUDITORIA
	Aud_FechaActual			DATETIME,				-- AUDITORIA
	Aud_DireccionIP			VARCHAR(15),			-- AUDITORIA
	Aud_ProgramaID			VARCHAR(50),			-- AUDITORIA
	Aud_Sucursal			INT(11),				-- AUDITORIA

	Aud_NumTransaccion		BIGINT(20)				-- AUDITORIA
)
TerminaStore: BEGIN


DECLARE	Var_SolFondeoID		BIGINT(20);
DECLARE	Var_AmortizacionID	INT;
DECLARE	Var_FechaInicio		DATE;
DECLARE	Var_FechaVencim		DATE;
DECLARE	Var_EmpresaID		INT;
DECLARE	Var_MonedaID		INT(11);
DECLARE	Var_NumRetirosMes	INT;
DECLARE	Var_CuentaAhoID		BIGINT;
DECLARE	Var_CapitalVig		DECIMAL(12,2);
DECLARE	Var_Interes			DECIMAL(12,4);
DECLARE	Var_SucCliente	 	INT;
DECLARE	Var_ClienteID		BIGINT;

DECLARE	Var_FecApl			DATE;
DECLARE	Var_EsHabil			CHAR(1);
DECLARE	Var_Poliza			BIGINT;
DECLARE	Error_Key			INT;
DECLARE	Var_FondeoStr		VARCHAR(20);

DECLARE	Par_Consecutivo		BIGINT;



DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE	Decimal_Cero		DECIMAL(8,2);
DECLARE	Pro_TraspaExi		INT;

DECLARE	AltaPoliza_NO		CHAR(1);
DECLARE	AltaPol_SI			CHAR(1);
DECLARE	AltaMov_SI			CHAR(1);
DECLARE	AltaMovAho_NO		CHAR(1);
DECLARE	Str_NO		 		CHAR(1);
DECLARE	Str_SI		 		CHAR(1);
DECLARE	Pol_Automatica		CHAR(1);
DECLARE	Nat_Cargo			CHAR(1);
DECLARE	Nat_Abono			CHAR(1);
DECLARE	Mov_CapOrdinario 	INT;
DECLARE	Mov_CapExigible 	INT;
DECLARE	Con_CapOrdinario	INT;
DECLARE	Con_CapExigible		INT;
DECLARE	Con_TraspaExi		INT;
DECLARE	Des_TraspaExi		VARCHAR(50);
DECLARE Var_NumRegistros	INT(11);
DECLARE Var_AuxContador		INT(11);
DECLARE Var_Control    		VARCHAR(100);   		-- Variable de Control

SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Decimal_Cero		:= 0.00;
SET	Pro_TraspaExi 		:= 303;

SET	AltaPoliza_NO		:= 'N';
SET	AltaPol_SI			:= 'S';
SET	AltaMov_SI			:= 'S';
SET	AltaMovAho_NO		:= 'N';
SET	Str_NO		 		:= 'N';
SET	Str_SI		 		:= 'S';
SET	Pol_Automatica 		:= 'A';
SET	Nat_Cargo			:= 'C';
SET	Nat_Abono			:= 'A';

SET	Mov_CapOrdinario 	:= 1;
SET	Mov_CapExigible 	:= 2;

SET	Con_CapOrdinario	:= 1;
SET	Con_CapExigible		:= 2;
SET	Con_TraspaExi		:= 22;

SET	Des_TraspaExi		:= 'TRASPASO EXIGIBLE INVERSIONES ';


SET Var_FecApl	:= Par_Fecha;

ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
		   SET Par_NumErr  := 999;
		   SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					  				'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWFONTRASEXIPRO');
		   SET Var_Control := 'SQLEXCEPTION';
		END;


			INSERT INTO TMPCRWFONTRASEXIPRO (
						SolFondeoID, 		AmortizacionID, 	FechaInicio, 			FechaVencimiento, 			EmpresaID,
						MonedaID, 			NumRetirosMes, 		CuentaAhoID, 			SaldoCapVigente, 			SaldoInteres,
						SucursalOrigen, 	ClienteID, 			NumTransaccion)
				SELECT	Inv.SolFondeoID, 	AmortizacionID,		Amo.FechaInicio,		Amo.FechaVencimiento,		Inv.EmpresaID,
						Inv.MonedaID,		Inv.NumRetirosMes,	Inv.CuentaAhoID,		Amo.SaldoCapVigente,		Amo.SaldoInteres,
						Cli.SucursalOrigen,	Cli.ClienteID,		Aud_NumTransaccion
					FROM AMORTICRWFONDEO Amo,
						 CRWFONDEO	 Inv,
						 CLIENTES Cli
					WHERE Amo.SolFondeoID 		= Inv.SolFondeoID
					  AND Inv.ClienteID			= Cli.ClienteID
					  AND Amo.FechaExigible		<= Par_Fecha
					  AND Amo.Estatus				=  'N'
					  AND Inv.Estatus				=  'N'
					  AND Amo.SaldoCapVigente 		> 0.00;

			CALL MAESTROPOLIZASALT(
				Var_Poliza,			Par_EmpresaID,		Var_FecApl,		Pol_Automatica,	Con_TraspaExi,
				Des_TraspaExi,		Str_NO,				Par_NumErr,		Par_ErrMen,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SELECT COUNT(*) INTO Var_NumRegistros FROM TMPCRWFONTRASEXIPRO WHERE NumTransaccion = Aud_NumTransaccion;

			SET Var_AuxContador = 0;

			WHILE  Var_AuxContador > Var_NumRegistros DO

				SELECT SolFondeoID, 		AmortizacionID, 	FechaInicio, 			FechaVencimiento, 			EmpresaID,
						MonedaID, 			NumRetirosMes, 		CuentaAhoID, 			SaldoCapVigente, 			SaldoInteres,
						SucursalOrigen, 	ClienteID
				INTO
						Var_SolFondeoID,	Var_AmortizacionID,	Var_FechaInicio,	Var_FechaVencim,	Var_EmpresaID,
						Var_MonedaID,		Var_NumRetirosMes,	Var_CuentaAhoID,	Var_CapitalVig,	Var_Interes,
						Var_SucCliente,		Var_ClienteID
				FROM TMPCRWFONTRASEXIPRO
				WHERE NumTransaccion = Aud_NumTransaccion
				LIMIT Var_AuxContador,1;

					SET Var_FondeoStr 	:= CONCAT(CONVERT(Var_SolFondeoID, CHAR), '-', CONVERT(Var_AmortizacionID, CHAR));

				IF(Var_CapitalVig > Decimal_Cero) THEN

					CALL CRWCONTAINVPRO(
						Var_SolFondeoID,		Var_AmortizacionID,		Var_CuentaAhoID,	Var_ClienteID,			Par_Fecha,
						Var_FecApl,				Var_CapitalVig,			Var_MonedaID,		Var_NumRetirosMes,		Var_SucCliente,
						Des_TraspaExi,			Var_FondeoStr,			AltaPoliza_NO,		Entero_Cero,			Var_Poliza,
						AltaPol_SI,				AltaMov_SI,				Con_CapOrdinario,	Mov_CapOrdinario,		Nat_Cargo,
						Nat_Abono,				AltaMovAho_NO,			Cadena_Vacia,		Cadena_Vacia,			Str_NO,
						Par_NumErr,				Par_ErrMen,				Par_Consecutivo,	Var_EmpresaID,			Aud_Usuario,
						Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

					IF(Par_ErrMen != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

					CALL CRWCONTAINVPRO(
						Var_SolFondeoID,		Var_AmortizacionID,		Var_CuentaAhoID,	Var_ClienteID,			Par_Fecha,
						Var_FecApl,				Var_CapitalVig,			Var_MonedaID,		Var_NumRetirosMes,		Var_SucCliente,
						Des_TraspaExi,			Var_FondeoStr,			AltaPoliza_NO,		Entero_Cero,			Var_Poliza,
						AltaPol_SI,				AltaMov_SI,				Con_CapExigible,	Mov_CapExigible,		Nat_Abono,
						Nat_Cargo,				AltaMovAho_NO,			Cadena_Vacia,		Cadena_Vacia,			Str_NO,
						Par_NumErr,				Par_ErrMen,				Par_Consecutivo,	Var_EmpresaID,			Aud_Usuario,
						Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

					IF(Par_ErrMen != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;


			SET Var_AuxContador := Var_AuxContador + 1;
			END WHILE;

	DELETE FROM TMPCRWFONTRASEXIPRO
				WHERE NumTransaccion = Aud_NumTransaccion;

	SET Par_NumErr  := Entero_Cero;
	SET Par_ErrMen  := 'Proceso Terminado Exitosamente';

	END ManejoErrores;  -- END del Handler de Errores

	IF (Par_Salida = Str_SI) THEN
		SELECT  Par_NumErr 		AS NumErr,
				Par_ErrMen		AS ErrMen,
				'creditoID' 	AS control;
	END IF;

END TerminaStore$$