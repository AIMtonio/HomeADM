-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTAARRENDAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTAARRENDAPRO`;DELIMITER $$

CREATE PROCEDURE `CONTAARRENDAPRO`(
# =====================================================================================
# -- STORED PROCEDURE QUE REALIZA LOS MOVIEMTOS OPERATIVOS Y CONTABLES DEL MODULO DE ARRENDAMIENTO.
# =====================================================================================
	Par_FechaOperacion			DATE,				-- Fecha de Operacion
	Par_FechaAplicacion			DATE,				-- Fecha de Aplicacion
	Par_TipoArrenda				VARCHAR(1),			-- Tipo de arrendamiento (financiado o puro)
	Par_ProductoArrendaID 		INT(11), 			-- Corresponde con el tipo de producto
	Par_ConceptoOpera			INT(11), 			-- Concepto de operacion, corresponde con la tabla CONCEPTOSARRENDA

	Par_ArrendaID				BIGINT(12),			-- ID de arrendamiento
	Par_ArrendaAmortiID			INT(4),				-- Numero de Amortizacion del credito
	Par_Cliente					INT(11),			-- ID del cliente
	Par_MonedaID 				INT(11),			-- Moneda o Divisa
	Par_Descripcion 			VARCHAR(100),		-- Descripcion de la Poliza

	Par_Referencia				VARCHAR(50), 		-- Referencia de la Poliza
	Par_Monto 					DECIMAL(14,4),		-- Monto
	Par_AltaEncPoliza 			CHAR(1),
	Par_ConceptoCon				INT(11),			-- CONCEPTO CONTABLE - Tabla CONCEPTOSCONTA
	Par_AltaPolizaArrenda 		CHAR(1),			-- ALTA DE POLIZA DE ARRENDAMIENTO S=SI N = NO

	Par_AltaMovArrenda 			CHAR(1), 			-- ALTA DE MOVIMIENTO DE ARRENDAMIENTO S=SI N = NO
	Par_ConContaArrenda 		INT(11), 			-- Concepto contable de arrendamiento, corresponde con la tabla CONCEPTOSARRENDA
	Par_TipoMovArrendaID 		INT(11), 			-- Tipo de movimiento de Arrendamiento
	Par_Naturaleza 				CHAR(1), 			-- Naturaleza de arrendamiento  C = CARGO   A = ABONO
	Par_ModoPago				CHAR(1),			-- Modo de pago

	Par_Plazo					CHAR(1),			-- Plazo C = corto L = largo
	Par_SucursalID 				INT(11), 			-- Sucursal ID
	Par_Transaccion 			BIGINT(20), 		-- Numero de Transaccion
	Par_Salida 					CHAR(1), 			-- Salida Si o No
	INOUT Par_Poliza 			BIGINT, 			-- Numero de poliza

	INOUT Par_NumErr 			INT(11),			-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen 			VARCHAR(400), 		-- Parametro que corresponde a un mensaje de exito o error
	INOUT Par_Consecutivo 		BIGINT, 			-- Consecutivo

	Aud_EmpresaID 				INT(11),			-- Parametros de Auditoria
	Aud_Usuario 				INT(11),			-- Parametros de Auditoria

	Aud_FechaActual 			DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP 			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID 				VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal 				INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion 			BIGINT(20) 			-- Parametros de Auditoria
)
TerminaStore: BEGIN

	/* Declaracion de Variables */
	DECLARE Var_Cargos			DECIMAL(14,4);		-- Cargos
	DECLARE Var_Abonos 			DECIMAL(14,4);		-- Abonos
	DECLARE Var_Control			VARCHAR(50);		-- Variable de Control

	/* Declaracion de Constantes */
	DECLARE Cadena_Vacia		CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia			DATE;				-- Fecha Vacia
	DECLARE Entero_Cero			INT;				-- Entero cero
	DECLARE Decimal_Cero		DECIMAL(12, 2);		-- Decimal cero
	DECLARE AltaPoliza_SI		CHAR(1);			-- Alta de poliza Si
	DECLARE AltaMovArendaSi		CHAR(1);			-- Alta de movimiento si
	DECLARE AltaPolArrendaSi	CHAR(1);			-- Alta poliza arrenda Si
	DECLARE Nat_Cargo 			CHAR(1);			-- Naturaleza cargo
	DECLARE Nat_Abono 			CHAR(1);			-- Naturaleza abono
	DECLARE Pol_Automatica 		CHAR(1);			-- Poliza automatica
	DECLARE Salida_NO			CHAR(1);			-- Salida no
	DECLARE Salida_SI			CHAR(1);			-- Salida si

	/* Asignacion de Constantes */
	SET Cadena_Vacia 			:= '';				-- Cadena vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero 			:= 0;				-- Entero cero
	SET Decimal_Cero			:= 0.00;			-- Decimal 0
	SET AltaPoliza_SI			:= 'S';				-- Si alta de poliza
	SET AltaMovArendaSi			:= 'S';				-- Si alta de movimiento de arrendamiento
	SET AltaPolArrendaSi		:= 'S';				-- Si alata de poliza arrendamiento
	SET Nat_Cargo				:= 'C';				-- Cargo
	SET Nat_Abono 				:= 'A';				-- Abono
	SET Pol_Automatica 			:= 'A';				-- Poliza automatica
	SET Salida_NO 				:= 'N';				-- Salida no
	SET Salida_SI				:= 'S';				-- Salida si

	SET Aud_FechaActual   := NOW();

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  = 999;
				SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										 'Disculpe las molestias que esto le ocasiona. Ref: SP-CONTAARRENDAPRO');
				SET Var_Control = 'sqlException';
			END;

	IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
		CALL MAESTROPOLIZASALT(
		Par_Poliza,			Aud_EmpresaID,		Par_FechaAplicacion,	Pol_Automatica,		Par_ConceptoCon,
		Par_Descripcion,	Salida_NO,			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		IF(IFNULL(Par_NumErr, Entero_Cero)!= Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF (Par_AltaMovArrenda = AltaMovArendaSi) THEN
		IF(Par_Naturaleza = Nat_Cargo) THEN
			SET Var_Cargos	:= Par_Monto;
			SET Var_Abonos	:= Decimal_Cero;
		ELSE
			SET Var_Cargos	:= Decimal_Cero;
			SET Var_Abonos	:= Par_Monto;
		END IF;

		CALL ARRENDAMIENTOMOVSALT( /*SP para dar de alta los movimientos de los arrendamientos*/
			Par_ArrendaID,      	Par_ArrendaAmortiID,  	Par_Transaccion,    Par_FechaOperacion,   	Par_FechaAplicacion,
			Par_TipoMovArrendaID, 	Par_Naturaleza,     	Par_MonedaID,     	Par_Monto,        		Par_Descripcion,
			Par_Referencia,     	Par_Poliza,				Salida_NO,			Par_NumErr,       		Par_ErrMen,
			Par_Consecutivo,		Par_ModoPago,			Aud_EmpresaID,      Aud_Usuario,      		Aud_FechaActual,
			Aud_DireccionIP,    	Aud_ProgramaID,			Aud_Sucursal,     	Aud_NumTransaccion);
	END IF;

	IF (Par_AltaPolizaArrenda = AltaPolArrendaSi) THEN
		IF(Par_Naturaleza = Nat_Cargo) THEN
			SET Var_Cargos	:= Par_Monto;
			SET Var_Abonos	:= Decimal_Cero;
		ELSE
			SET Var_Cargos	:= Decimal_Cero;
			SET Var_Abonos	:= Par_Monto;
		END IF;

		CALL POLIZAARRENDAPRO( /* SP QUE SE UTILIZA PARA DAR DE ALTA UN DETALLE DE POLIZA RELACIONADO CON EL MODULO DE ARRENDAMIENTOS*/
			Par_Poliza,			Par_FechaAplicacion,	Par_TipoArrenda,	Par_ProductoArrendaID,	Par_ConceptoOpera,
			Par_ArrendaID,		Par_Cliente,			Par_MonedaID,		Var_Cargos,				Var_Abonos,
			Par_Descripcion,	Par_Referencia,			Par_Plazo,			Par_SucursalID,			Salida_NO,
			Par_NumErr,			Par_ErrMen,				Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		IF(IFNULL(Par_NumErr, Entero_Cero)!= Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	END ManejoErrores;

		-- Se muestran los datos
	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS Control,
				Par_Poliza  AS Consecutivo;
	END IF;


END TerminaStore$$