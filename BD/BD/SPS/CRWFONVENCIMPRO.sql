-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWFONVENCIMPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWFONVENCIMPRO`;
DELIMITER $$

CREATE PROCEDURE `CRWFONVENCIMPRO`(
/* STORE DE CIERRE DE VENCIMIENTOS Y PAGOS DE INVERSION  */
	Par_Fecha				DATE,				-- FECHA DEL SISTEMA
	Par_EmpresaID			INT(11),			-- NUMERO DE EMPRESA
	Par_Salida				CHAR(1),			-- TIPO DE SALIDA.
	INOUT Par_NumErr		INT(11),			-- NUM DE ERROR
	INOUT Par_ErrMen		VARCHAR(400),		-- MENSAJE DE ERROR

	INOUT Par_Consecutivo	BIGINT(20),			-- NUM CONSECUTIVO
	Aud_Usuario				INT(11),			-- AUDITORIA
	Aud_FechaActual			DATETIME,			-- AUDITORIA
	Aud_DireccionIP			VARCHAR(15),		-- AUDITORIA
	Aud_ProgramaID			VARCHAR(50),		-- AUDITORIA

	Aud_Sucursal			INT(11),			-- AUDITORIA
	Aud_NumTransaccion		BIGINT(20)			-- AUDITORIA

)
TerminaStore: BEGIN
/*Declaracion de Variables*/
DECLARE	Var_SolFondeoID	    BIGINT(20);
DECLARE	Var_AmortizacionID	INT(11);
DECLARE	Var_FechaInicio		DATE;
DECLARE	Var_FechaVencim		DATE;
DECLARE	Var_EmpresaID		INT(11);
DECLARE	Var_MonedaID		INT(11);
DECLARE	Var_NumRetirosMes	INT(11);
DECLARE	Var_CuentaAhoID		BIGINT(12);
DECLARE	Var_CapitalVig		DECIMAL(14,4);
DECLARE	Var_CapitalAtr		DECIMAL(14,4);
DECLARE	Var_Interes			DECIMAL(14,4);
DECLARE	Var_InteresAcum		DECIMAL(14,4);
DECLARE	Var_RetencAcum		DECIMAL(14,4);
DECLARE	Var_SucCliente	 	INT(11);
DECLARE	Var_ClienteID		BIGINT(11);
DECLARE	Var_PagaISR			CHAR(1);
DECLARE	Var_FondeoStr		VARCHAR(50);
DECLARE	Var_FecApl			DATE;
DECLARE	Var_EsHabil			CHAR(1);
DECLARE	Var_Poliza			BIGINT(11);
DECLARE	Var_MonAplicar		DECIMAL(12,2);
DECLARE	Var_MonRetener		DECIMAL(12,2);

-- Declaracion de constantes
DECLARE	Mov_Capita			INT(11);
DECLARE	Con_Capita			INT(11);
DECLARE	Aho_Interes			CHAR(2);
DECLARE	Error_Key			INT(11);
DECLARE	Entero_Cero			INT(11);
DECLARE	Decimal_Cero		DECIMAL(8,2);
DECLARE	Pro_VencimInv		INT(11);
DECLARE	AltaPoliza_NO		CHAR(1);
DECLARE	AltaPol_SI			CHAR(1);
DECLARE	AltaMov_SI			CHAR(1);
DECLARE	AltaMovAho_SI		CHAR(1);
DECLARE	Str_NO 				CHAR(1);
DECLARE	Str_SI 				CHAR(1);
DECLARE	Pol_Automatica		CHAR(1);
DECLARE	Nat_Cargo			CHAR(1);
DECLARE	Nat_Abono			CHAR(1);

DECLARE	Con_CapOrdinario	INT(11);
DECLARE	Con_CapExigible		INT(11);
DECLARE	Con_IntDeven 		INT(11);
DECLARE	Con_RetInt			INT(11);
DECLARE	Mov_IntPro			INT(11);
DECLARE	Mov_RetInt			INT(11);
DECLARE	Mov_CapOrdinario 	INT(11);
DECLARE	Mov_CapExigible 	INT(11);
DECLARE	Con_Vencimientos	INT(11);
DECLARE	Aho_CapInv			CHAR(2);
DECLARE	Aho_IntGra			CHAR(2);
DECLARE	Aho_IntExe			CHAR(2);
DECLARE	Aho_ISRInteres		CHAR(2);
DECLARE	PagaISR_SI			CHAR(1);
DECLARE	Estatus_Pagada		CHAR(1);
DECLARE	Des_PagoCap			VARCHAR(50);
DECLARE	Des_PagoInteres		VARCHAR(50);
DECLARE	Des_PagoRetIntere	VARCHAR(50);
DECLARE	Des_VenFondeo		VARCHAR(50);
DECLARE Des_ErrorGeneral	VARCHAR(100);
DECLARE Des_ErrorLlaveDup	VARCHAR(100);
DECLARE Des_ErrorLlamadaSP	VARCHAR(100);
DECLARE Des_ErrorValNulos	VARCHAR(100);
DECLARE PagoEnIncumpleSI	CHAR(1);
DECLARE EstatusVigente		CHAR(1);
DECLARE Var_NumRegistros	INT(11);
DECLARE Var_AuxContador		INT(11);
DECLARE Var_Control    		VARCHAR(100);   		-- Variable de Control

-- Asignacion de constantes
SET	Entero_Cero			:= 0;										/*Entero Cero*/
SET	Decimal_Cero		:= 0.00;									/*DECIMAL Cero*/
SET	Pro_VencimInv 		:= 302;										/*Numero de procesos batch Vencimientos y Pagos de Inversion  en tabla (PROCESOSBATCH)*/
SET	AltaPoliza_NO		:= 'N';										/*Indica que no requiere de Alta de encabezado de poliza*/
SET	AltaPol_SI			:= 'S';										/*Indica que si requiere de poliza de fondeadores*/
SET	AltaMov_SI			:= 'S';										/*Indica que si registre movimiento de fondeador*/
SET	AltaMovAho_SI		:= 'S';										/*Inidica que Si registre movimiento de Ahorro*/
SET	Str_NO 				:= 'N';										/* Constante NO*/
SET	Str_SI 				:= 'S';										/* Constante SI*/
SET	Pol_Automatica 		:= 'A';										/*Poliza automatica*/
SET	Nat_Cargo			:= 'C';										/*Naturaleza de contabilidad (Cargo)*/
SET	Nat_Abono			:= 'A';										/*Naturaleza de contabilidad (Abono)*/
SET	Mov_CapOrdinario 	:= 1;										/*Capital Vigente 	tabla TIPOSMOVS*/
SET	Mov_CapExigible 	:= 2;										/*Capital Exigible	tabla TIPOSMOVS*/
SET	Mov_IntPro 			:= 10;										/*Interes Ordinario tabla TIPOSMOVS*/
SET	Mov_RetInt 			:= 50;										/*Retencion por Interes tabla TIPOSMOVS*/
SET	Con_CapOrdinario	:= 1;										/* Concepto Contable  tabla CUENTASMAYOR*/
SET	Con_CapExigible		:= 2;										/* Concepto Contable  CUENTASMAYOR*/
SET	Con_RetInt 			:= 4;										/* Concepto Contable  CUENTASMAYOR*/
SET	Con_IntDeven 		:= 8;										/* Concepto Contable  CUENTASMAYOR*/
SET	Con_Vencimientos	:= 21;										/* Concepto Contable para poliza*/
SET	Aho_CapInv			:= '71';									/*PAGO INV . CAPITAL TABLA TIPOSMOVSAHO*/
SET	Aho_IntGra			:= '72';									/*PAGO INV . INTERES GRAVADO TABLA TIPOSMOVSAHO*/
SET	Aho_IntExe			:= '73';									/*PAGO INV . CAPITAL TABLA TIPOSMOVSAHO*/
SET	Aho_ISRInteres		:= '76';									/*PAGO INV . INTERES EXCENTO TABLA TIPOSMOVSAHO*/
SET	PagaISR_SI			:= 'S';										/*Para saber Si paga ISR*/
SET	Estatus_Pagada		:= 'P';										/*Estatus Pagada*/
SET	Des_PagoCap			:= 'PAGO DE INVERSION. CAPITAL'; 			/*Descripcion Pago Capital*/
SET	Des_PagoInteres		:= 'PAGO DE INVERSION. INTERES'; 			/*Descripcion Pago Interes*/
SET	Des_PagoRetIntere	:= 'PAGO DE INVERSION. RETENCION INTERES';	/*Descripcion Retencion Interes*/
SET	Des_VenFondeo		:= 'VENCIMIENTO FONDEO ';					/*Descripcion Vencimiento de Fondeo */
SET Des_ErrorGeneral	:= 'ERROR DE SQL GENERAL'; 					/*Descripcion de Error para tabla BITACORABTCH*/
SET Des_ErrorLlaveDup	:= 'ERROR EN ALTA, LLAVE DUPLICADA';		/*Descripcion de Error para tabla BITACORABTCH*/
SET Des_ErrorLlamadaSP	:= 'ERROR AL LLAMAR A STORE PROCEDURE';		/*Descripcion de Error para tabla BITACORABTCH*/
SET Des_ErrorValNulos	:= 'ERROR VALORES NULOS';					/*Descripcion de Error para tabla BITACORABTCH*/
SET PagoEnIncumpleSI	:= 'S'; 									/*Especifica si se paga al Inversionista en el incumplimiento De de pago de la parte Activa relacionada*/
SET EstatusVigente		:= 'N';										/*Estatus vigente en Inversiones*/

SET Var_FecApl	:= Par_Fecha;

	ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
		   SET Par_NumErr  := 999;
		   SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					  				'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWFONVENCIMPRO');
		   SET Var_Control := 'SQLEXCEPTION';
		END;

		INSERT INTO TMPCRWFONVENCIMPRO (
				SolFondeoID, 			AmortizacionID, 		FechaInicio, 			FechaVencimiento, 		EmpresaID,
				MonedaID, 				NumRetirosMes, 			CuentaAhoID, 			SaldoCapVigente, 		SaldoCapExigible,
				SaldoInteres, 			ProvisionAcum, 			RetencionIntAcum, 		SucursalOrigen, 		ClienteID,
				PagaISR,				NumTransaccion)
		SELECT	Inv.SolFondeoID, 		AmortizacionID,			Amo.FechaInicio,		Amo.FechaVencimiento,
				Inv.EmpresaID,			Inv.MonedaID,			Inv.NumRetirosMes,		Inv.CuentaAhoID,
				Amo.SaldoCapVigente,	Amo.SaldoCapExigible,	Amo.SaldoInteres,		Amo.ProvisionAcum,
				Amo.RetencionIntAcum,	Cli.SucursalOrigen,		Cli.ClienteID	,		Cli.PagaISR,
				Aud_NumTransaccion
			FROM AMORTICRWFONDEO Amo,
				 CRWFONDEO	 Inv,
				 CRWTIPOSFONDEADOR Tip,
				 CLIENTES Cli
			WHERE Amo.SolFondeoID	= Inv.SolFondeoID
			  AND Inv.TipoFondeo	= Tip.TipoFondeadorID
			  AND Inv.ClienteID		= Cli.ClienteID
			  AND Amo.FechaExigible	<= Par_Fecha
			  AND Amo.Estatus			= EstatusVigente
			  AND Inv.Estatus			= EstatusVigente
			  AND Tip.PagoEnIncumple	= PagoEnIncumpleSI;

		SET Var_NumRegistros := (SELECT COUNT(*) FROM TMPCRWFONVENCIMPRO WHERE  NumTransaccion = Aud_NumTransaccion);
		SET Var_NumRegistros := IFNULL(Var_NumRegistros, Entero_Cero);

		IF(Var_NumRegistros > Entero_Cero)THEN
			CALL MAESTROPOLIZASALT(
				Var_Poliza,			Par_EmpresaID,		Var_FecApl,		Pol_Automatica,		Con_Vencimientos,
				Des_VenFondeo,		Str_NO,				Par_NumErr,		Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Var_AuxContador := 0;

		WHILE  Var_AuxContador > Var_NumRegistros DO

			SELECT
				SolFondeoID, 		AmortizacionID,		FechaInicio, 		FechaVencimiento,	EmpresaID,
				MonedaID, 			NumRetirosMes,		CuentaAhoID, 		SaldoCapVigente,	SaldoCapExigible,
				SaldoInteres, 		ProvisionAcum,		RetencionIntAcum, 	SucursalOrigen,		ClienteID,
				PagaISR
			INTO
				Var_SolFondeoID,	Var_AmortizacionID,	Var_FechaInicio,	Var_FechaVencim,	Var_EmpresaID,
				Var_MonedaID,		Var_NumRetirosMes,	Var_CuentaAhoID,	Var_CapitalVig,		Var_CapitalAtr,
				Var_Interes,		Var_InteresAcum,	Var_RetencAcum,		Var_SucCliente,		Var_ClienteID,
				Var_PagaISR
			FROM TMPCRWFONVENCIMPRO
			WHERE  NumTransaccion = Aud_NumTransaccion
			LIMIT Var_AuxContador,1;


			SET	Mov_Capita		:= Entero_Cero;
			SET	Con_Capita		:= Entero_Cero;
			SET	Var_MonAplicar	:= Decimal_Cero;
			SET	Var_MonRetener	:= Decimal_Cero;

			SET Var_FondeoStr = CONCAT(CONVERT(Var_SolFondeoID, CHAR), '-', CONVERT(Var_AmortizacionID, CHAR)) ;
			IF ((Var_CapitalVig + Var_CapitalAtr) > Decimal_Cero ) THEN
				SET Var_MonAplicar	:= Var_CapitalVig + Var_CapitalAtr;
			END IF;

			IF (Var_MonAplicar > Decimal_Cero ) THEN

				IF(Var_CapitalAtr > Decimal_Cero) THEN
					SET	Mov_Capita	:= Mov_CapExigible;
					SET	Con_Capita	:= Con_CapExigible;
				ELSE
					SET	Mov_Capita	:= Mov_CapOrdinario;
					SET	Con_Capita	:= Con_CapOrdinario;
				END IF;
				CALL CRWCONTAINVPRO(
					Var_SolFondeoID,    Var_AmortizacionID,	Var_CuentaAhoID,    Var_ClienteID,	    Par_Fecha,
					Var_FecApl,			Var_MonAplicar,     Var_MonedaID,	    Var_NumRetirosMes,  Var_SucCliente,
					Des_PagoCap,        Var_FondeoStr,		AltaPoliza_NO,      Entero_Cero,		Var_Poliza,
					AltaPol_SI,			AltaMov_SI,     	Con_Capita,			Mov_Capita,         Nat_Cargo,
					Nat_Abono,          AltaMovAho_SI,		Aho_CapInv,  		Nat_Abono,			Str_NO,
					Par_NumErr,			Par_ErrMen,			Par_Consecutivo,    Var_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;

			SET	Var_MonRetener	:= ROUND((Var_RetencAcum / Var_InteresAcum) * ROUND(Var_Interes, 2), 2);
			IF (Var_Interes > Decimal_Cero) THEN
				IF (Var_MonRetener > Decimal_Cero) AND (Var_PagaISR = PagaISR_SI) THEN
					SET	Aho_Interes	:= Aho_IntGra;
				ELSE
					SET	Aho_Interes	:= Aho_IntExe;
				END IF;

				CALL CRWCONTAINVPRO(
					Var_SolFondeoID,	Var_AmortizacionID,	Var_CuentaAhoID,	Var_ClienteID,      Par_Fecha,
					Var_FecApl,			Var_Interes,		Var_MonedaID,		Var_NumRetirosMes,	Var_SucCliente,
					Des_PagoInteres,	Var_FondeoStr,		AltaPoliza_NO,		Entero_Cero,		Var_Poliza,
					AltaPol_SI,			AltaMov_SI,			Con_IntDeven,		Mov_IntPro,			Nat_Cargo,
					Nat_Abono,			AltaMovAho_SI,		Aho_Interes,		Nat_Abono,			Str_NO,
					Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Var_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Var_MonRetener > Decimal_Cero) AND (Var_PagaISR = PagaISR_SI) THEN
				CALL CRWCONTAINVPRO(
					Var_SolFondeoID,	Var_AmortizacionID,	Var_CuentaAhoID,	Var_ClienteID, 		Par_Fecha,
					Var_FecApl,			Var_MonRetener,		Var_MonedaID,		Var_NumRetirosMes,	Var_SucCliente,
					Des_PagoRetIntere,	Var_FondeoStr,		AltaPoliza_NO,		Entero_Cero,		Var_Poliza,
					AltaPol_SI,			AltaMov_SI,			Con_RetInt,			Mov_RetInt,			Nat_Abono,
					Nat_Cargo,			AltaMovAho_SI,		Aho_ISRInteres,		Nat_Cargo,			Str_NO,
					Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Var_EmpresaID,  	Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;


			UPDATE AMORTICRWFONDEO SET
				Estatus			= Estatus_Pagada,
				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE SolFondeoID	= Var_SolFondeoID
				AND AmortizacionID	= Var_AmortizacionID;

			SET Var_AuxContador := Var_AuxContador + 1;

		END WHILE;

		DELETE FROM TMPCRWFONVENCIMPRO WHERE  NumTransaccion = Aud_NumTransaccion;

		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := 'Proceso Terminado Exitosamente';

	END ManejoErrores;  -- END del Handler de Errores

	IF (Par_Salida = Str_SI) THEN
		SELECT  Par_NumErr 		AS NumErr,
				Par_ErrMen		AS ErrMen,
				'creditoID' 	AS control;
	END IF;

END TerminaStore$$