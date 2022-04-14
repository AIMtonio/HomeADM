-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTAAPORTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTAAPORTPRO`;DELIMITER $$

CREATE PROCEDURE `CONTAAPORTPRO`(
# ========================================================
# ----- SP PARA REALIZAR LA CONTABILIDAD DE LOS APORTACIONES-----
# ========================================================
	Par_AportacionID			INT(11),
	Aud_EmpresaID		INT(11),
	Par_Fecha			DATE,
	Par_Monto			DECIMAL(12,2),
	Par_TipoMovAho		VARCHAR(4),

	Par_ConceptoCon		INT(11),
	Par_ConceptoAport	INT(11),
	Par_ConceptoAho		INT(11),
	Par_Naturaleza		CHAR(1),
	Par_AltaEncPoliza	CHAR(1),

	Par_AltaMovAho		CHAR(1),

    Par_Salida          CHAR(1),
	INOUT Par_Poliza 	BIGINT(20),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

	Par_CuentaAhoID		BIGINT(12),
	Par_ClienteID		INT(11),
	Par_MonedaID		INT(11),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE	Var_Control		VARCHAR(20);
	DECLARE	Var_Consecutivo	VARCHAR(50);
	DECLARE	Var_Poliza		BIGINT(20);
	DECLARE Var_CuentaStr	VARCHAR(20);
	DECLARE Var_AportStr		VARCHAR(20);
	DECLARE Mon_Cargo		DECIMAL(12,2);
	DECLARE Mon_Abono		DECIMAL(12,2);

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Pol_Automatica	CHAR(1);
	DECLARE	Salida_NO		CHAR(1);
	DECLARE	AltaPoliza_SI	CHAR(1);
	DECLARE	AltaMovAho_SI	CHAR(1);
	DECLARE	Str_SI			CHAR(1);
	DECLARE	Nat_Cargo		CHAR(1);
	DECLARE	Nat_Abono		CHAR(1);
	DECLARE	Des_Concepto	VARCHAR(100);

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Pol_Automatica		:= 'A';
	SET	Salida_NO			:= 'N';
	SET	AltaPoliza_SI		:= 'S';
	SET	AltaMovAho_SI		:= 'S';
	SET	Str_SI				:= 'S';
	SET	Nat_Cargo			:= 'C';
	SET	Nat_Abono			:= 'A';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CONTAAPORTPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		IF (Par_TipoMovAho != Cadena_Vacia) THEN
			SET Des_Concepto:= (SELECT Descripcion
									FROM 	TIPOSMOVSAHO
									WHERE	TipoMovAhoID = Par_TipoMovAho);
		ELSE
			SET Des_Concepto:= (SELECT Descripcion
									FROM 	CONCEPTOSAPORTACION
									WHERE	ConceptoAportID	= Par_ConceptoAport);
		END IF;

		SET Var_AportStr		:=  CONCAT("Aport.",	CONVERT(Par_AportacionID, CHAR));
		SET Var_CuentaStr 	:=  CONCAT("Cta.",	CONVERT(Par_CuentaAhoID, CHAR));


		IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN

			SET	Var_Poliza	:= Entero_Cero;

			CALL MAESTROPOLIZASALT(
				Var_Poliza,			Aud_EmpresaID,		Par_Fecha, 			Pol_Automatica,		Par_ConceptoCon,
				Des_Concepto,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr!= Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			SET	Var_Poliza	:= Var_Poliza;
		ELSE
			SET Var_Poliza := Par_Poliza;
		END IF;


		IF(Par_Naturaleza = Nat_Abono)THEN
			IF (Par_AltaMovAho = AltaMovAho_SI) THEN

				CALL CUENTASAHORROMOVALT(
					Par_CuentaAhoID, 	Aud_NumTransaccion, 	Par_Fecha, 			Nat_Abono, 		Par_Monto,
					Des_Concepto,		Par_AportacionID,				Par_TipoMovAho,		Salida_NO,		Par_NumErr,
					Par_ErrMen,			Aud_EmpresaID, 			Aud_Usuario,		Aud_FechaActual,Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

				IF(Par_NumErr!= Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

				CALL POLIZASAHORROPRO(
					Var_Poliza,			Aud_EmpresaID,		Par_Fecha, 		Par_ClienteID,	Par_ConceptoAho,
					Par_CuentaAhoID,	Par_MonedaID,		Entero_Cero,	Par_Monto,		Des_Concepto,
					Var_CuentaStr,		Salida_NO,			Par_NumErr,		Par_ErrMen, 	Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

				IF(Par_NumErr!= Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

				SET Mon_Cargo	:= Par_Monto;
				SET Mon_Abono	:= Entero_Cero;
			ELSE
				SET Mon_Cargo	:= Entero_Cero;
				SET Mon_Abono	:= Par_Monto;
			END IF;


			CALL POLIZAAPORTPRO(
				Var_Poliza,			Par_Fecha,			Par_ClienteID,		Par_ConceptoAport,	Par_AportacionID,
				Par_MonedaID,		Mon_Cargo,			Mon_Abono,			Des_Concepto,		Var_AportStr,
				Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr!= Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		IF(Par_Naturaleza = Nat_Cargo)THEN
			IF (Par_AltaMovAho = AltaMovAho_SI) THEN

				CALL CUENTASAHORROMOVALT(
					Par_CuentaAhoID, 	Aud_NumTransaccion,	Par_Fecha, 			Nat_Cargo,			Par_Monto,
					Des_Concepto,		Par_AportacionID,			Par_TipoMovAho,		Salida_NO,			Par_NumErr,
					Par_ErrMen,			Aud_EmpresaID, 		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr!= Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

				CALL POLIZASAHORROPRO(
					Var_Poliza,			Aud_EmpresaID,		Par_Fecha,			Par_ClienteID,		Par_ConceptoAho,
					Par_CuentaAhoID,	Par_MonedaID,		Par_Monto,			Entero_Cero,		Des_Concepto,
					Var_CuentaStr,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr!= Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

				SET Mon_Cargo	:= Entero_Cero;
				SET Mon_Abono	:= Par_Monto;
			ELSE
				SET Mon_Cargo	:= Par_Monto;
				SET Mon_Abono	:= Entero_Cero;
			END IF;


			CALL POLIZAAPORTPRO(
				Var_Poliza,			Par_Fecha,			Par_ClienteID,		Par_ConceptoAport,	Par_AportacionID,
				Par_MonedaID,		Mon_Cargo,			Mon_Abono,			Des_Concepto,		Var_AportStr,
				Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr!= Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_NumErr := 0;
		SET Par_ErrMen := CONCAT('Proceso Exitoso para la Aportacion ',Par_AportacionID,'.');
		SET Var_Control:= 'aportacionID';
		SET Var_Consecutivo:= Par_AportacionID;

	END ManejoErrores;

	IF(Par_Salida = Str_SI)THEN
		SELECT  Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$