-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RENOVORDENPAGOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `RENOVORDENPAGOPRO`;DELIMITER $$

CREATE PROCEDURE `RENOVORDENPAGOPRO`(
# =======================================================
# --- SP PARA REALIZAR LA RENOVACION DE ORDEN DE PAGO----
# =======================================================
	Par_InstitucionIDCan	INT(11),		-- Numero de institucion de donde se esta cancelando la orden de pago
	Par_NumCtaInstitCan		VARCHAR(20),	-- Numero de cuenta de la institucion de donde se esta cancelando la orden de pago
	Par_NumOrdenPagoCan		VARCHAR(25),	-- Numero de orden de pago a cancelar
	Par_InstitucionID		INT(11),		-- Numero de institucion de donde se registra la nueva orden de pago
	Par_NumCtaInstit		VARCHAR(20),	-- Numero de cuenta de la institucion de donde se registra la nueva orden de pago

	Par_NumOrdenPago		VARCHAR(25),	-- Numero de la nueva orden de pago
	Par_Beneficiario		VARCHAR(200),	-- Nombre del beneficiario
	Par_MotivoRenov			VARCHAR(150),   -- Motivo d ela renovacion de la orden de pago
	Par_Poliza				BIGINT(20),		-- Numero de poliza generada

	Par_Salida				CHAR(1),		-- Indica parametro de salida
	INOUT	Par_NumErr		INT(11),		-- Indica numero de error
	INOUT	Par_ErrMen		VARCHAR(400),	-- Indica el mensaje de error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria
	Aud_Usuario				INT(11),		-- Parametro de auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal			INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria
)
TerminaStore:BEGIN

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);	-- Entero Cero
	DECLARE Cancelado 				CHAR(1);	-- Constante Cancelado
	DECLARE Cadena_Vacia			CHAR(1);	-- Cadena Vacia
	DECLARE FechaVacia				DATE;		-- Fecha Vacia
	DECLARE Salida_No				CHAR(1);	-- Salida pantalla No
	DECLARE Salida_SI				CHAR(1);	-- Salida de pantalla SI
	DECLARE Entero_Uno				INT(11);	-- Entero Uno
	DECLARE AltaPoliza_SI			CHAR(1);	-- Alta de poliza SI
    DECLARE AltaPoliza_NO			CHAR(1);	-- Alta de poliza No
	DECLARE Nat_Abono				CHAR(1);	-- Naturaleza Abono
	DECLARE Nat_Cargo				CHAR(1);	-- Naturaleza Cargo
	DECLARE Mov_AhorroNO			CHAR(1);	-- Alta en movimiento de ahorro NO
	DECLARE DesMovimientoAbono		VARCHAR(45);-- Descripcion de movimiento de ahorro abono
	DECLARE ConContaRenovOrdenPago	INT(11);	-- Concepto contable para renovacion de orden de pago
	DECLARE Conciliado_NO			CHAR(1);	-- Movimiento de tesoreria no conciliado
	DECLARE Conciliado_SI			CHAR(1);	-- Movimiento de tesoreria conciliado
	DECLARE Tip_RegPantalla			CHAR(1);	-- Tipo de registro: pantalla
	DECLARE Tip_MovTeso				CHAR(4);	-- Tipo de movimiento de tesoreria
	DECLARE Est_Emitido				CHAR(1); 	-- Estatus de cheque emitido
    DECLARE Est_Reempla				CHAR(1);	-- Estatus de cheque reemplazado
    DECLARE	Var_Concepto			VARCHAR(50);-- Concepto de renovacion de orden de pago

	-- Declaracion de variables
	DECLARE VarControl 				VARCHAR(100);-- Variable de control
	DECLARE Var_Monto  				DECIMAL(14,2);-- Variable monto
	DECLARE Var_ClienteID			INT(11);	 -- Variable que guarda el numero de cliente
	DECLARE Var_Beneficiario		VARCHAR(200);-- Variable que guarda el beneficiario
	DECLARE Var_Referencia			VARCHAR(50); -- Variable que guarda la referencia
	DECLARE Var_FechaEmision		DATE;	     -- Variable que guarda le fecha de emision
	DECLARE Var_NumTransaccion		BIGINT(20);  -- Variable que guarda el numero de transaccion
	DECLARE Var_FechaCancela		DATE;        -- Variable que guarda la fecha de renovacion de la orden de pago
	DECLARE Var_MonedaBase			INT(11);	 -- Variable que guarda la moneda base del sistema
	DECLARE Var_Consecutivo			BIGINT(20);  -- Variable que guarda el consecutivo
	DECLARE Var_EmpresaID			INT(11);	 -- Variable que guarda el numero de empresa
	DECLARE Var_RefTeso				VARCHAR(50); -- Variable que guarda la referencia para la tabla de TESORERIAMOVS
	DECLARE Var_CuentaAhoTeso		BIGINT(12);  -- Variable que guarda la cuenta de tesoreria
	DECLARE Var_Estatus				CHAR(1);	 -- Variable que guarda el estatus de la orden de pago

	-- Asignacion de constantes
	SET Cancelado					:= 'C';
	SET Entero_Cero					:= 0;
	SET Cadena_Vacia				:= '';
    SET FechaVacia					:= '1900-01-01';
	SET Salida_No					:= 'N';
	SET Salida_SI					:= 'S';
	SET Entero_Uno					:= 1;
	SET AltaPoliza_SI				:= 'S';
	SET AltaPoliza_NO				:= 'N';
	SET	Nat_Abono					:= 'A';
	SET Nat_Cargo					:= 'C';
	SET	Mov_AhorroNO				:= 'N';
	SET DesMovimientoAbono			:= 'CANCELACION POR RENOVACION';
	SET Var_Concepto				:= 'RENOVACION DE ORDEN DE PAGO';
	SET ConContaRenovOrdenPago		:= 839;
	SET Conciliado_NO   			:= 'N';
	SET Conciliado_SI				:= 'C';
	SET Tip_RegPantalla 			:= 'P';
	SET	Tip_MovTeso					:= '700';
	SET Est_Emitido					:= 'E';
    SET Est_Reempla					:= 'R';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-RENOVORDENPAGOPRO');
				SET VarControl = 'sqlException';
			END;


		SET Var_FechaCancela := IFNULL((SELECT FechaSistema FROM PARAMETROSSIS),FechaVacia);


		SELECT	Monto,				ClienteID,		Beneficiario,		Referencia,			Fecha,
				NumTransaccion,		Estatus
		  INTO	Var_Monto, 			Var_ClienteID, 	Var_Beneficiario, 	Var_Referencia,		Var_FechaEmision,
		   		Var_NumTransaccion,	Var_Estatus
			FROM ORDENPAGODESCRED
			WHERE 	InstitucionID 		= Par_InstitucionIDCan
			  AND 	NumCtaInstit 		= Par_NumCtaInstitCan
			  AND 	NumOrdenPago		= Par_NumOrdenPagoCan;


		SET Var_ClienteID := IFNULL(Var_ClienteID,Entero_Cero);


		IF(IFNULL(Par_InstitucionIDCan, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr   := 01;
			SET Par_ErrMen   := 'El Numero de Institucion Esta Vacio';
			SET VarControl   := 'institucionIDCan';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumCtaInstitCan, Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr		:= 02;
			SET Par_ErrMen		:= 'El Numero de Cuenta Esta Vacia';
			SET VarControl		:= 'numCtaInstitCan';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumOrdenPagoCan,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:= 03;
			SET	Par_ErrMen	:= 'El Numero de Orden de Pago Esta Vacio';
			SET VarControl	:= 'numOrdenPagoCan';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_InstitucionID,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:=04;
			SET Par_ErrMen	:='El Numero de Institucion Esta Vacio';
			SET VarControl	:='institucionID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumCtaInstit,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:= 05;
			SET Par_ErrMen	:= 'El Numero de Cuenta Esta Vacia';
			SET VarControl	:= 'numCtaInstit';
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_NumOrdenPago,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:= 06;
			SET Par_ErrMen	:= 'El Numero de Orden de Pago Esta Vacio';
			SET Varcontrol	:= 'numOrdenPago';
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_Beneficiario,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:= 07;
			SET Par_ErrMen	:= 'El Nombre del Beneficiario Esta Vacio';
			SET VarControl	:= 'beneficiario';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MotivoRenov,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:= 11;
			SET Par_ErrMen	:= 'El Motivo de Renovacion Esta Vacio';
			SET VarControl	:= 'motivoRenov';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Estatus != Est_Emitido)THEN
			SET Par_NumErr	:= 12;
			SET Par_ErrMen	:= 'La Orden de Pago ya Fue Renovada o Conciliada.';
			SET VarControl	:= 'numOrdenPagoCan';
			LEAVE ManejoErrores;
		END IF;


		UPDATE ORDENPAGODESCRED SET
			Estatus 			= Est_Reempla,
			MotivoRenov			= Par_MotivoRenov,
			EmpresaID   		= Par_EmpresaID,
            Usuario     		= Aud_Usuario,
            FechaActual     	= Aud_FechaActual,
            DireccionIP     	= Aud_DireccionIP,
            ProgramaID      	= Aud_ProgramaID,
            Sucursal        	= Aud_Sucursal,
            NumTransaccion  	= Aud_NumTransaccion
		WHERE 	InstitucionID 	= Par_InstitucionIDCan
		  AND 	NumCtaInstit 	= Par_NumCtaInstitCan
	  	  AND 	NumOrdenPago 	= Par_NumOrdenPagoCan;


		CALL ORDENPAGODESCREDALT(
			Var_ClienteID,			Par_InstitucionID,	Par_NumCtaInstit,	Par_NumOrdenPago,	Var_Monto,
            Par_Beneficiario,		Var_Referencia,		Var_Concepto,		Cadena_Vacia,		Salida_No,
            Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
            Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		SELECT MonedaBaseID, EmpresaID	INTO Var_MonedaBase, Var_EmpresaID
			FROM PARAMETROSSIS;

		SET Var_MonedaBase := IFNULL(Var_MonedaBase,Entero_Uno);

		CALL CONTATESOREPRO(
			Aud_Sucursal,     		Var_MonedaBase,   	Par_InstitucionIDCan,  	Par_NumCtaInstitCan,	Entero_Cero,
			Entero_Cero,    		Entero_Cero,        Var_FechaCancela,		Var_FechaCancela,       Var_Monto,
			DesMovimientoAbono,     Par_NumOrdenPagoCan,Par_NumCtaInstitCan, 	AltaPoliza_NO,     		Par_Poliza,
			ConContaRenovOrdenPago,	Entero_Cero,        Nat_Cargo,          	Mov_AhorroNO,     		Entero_Cero,
			Var_ClienteID,      	Cadena_Vacia,       Cadena_Vacia,          	Salida_No,				Par_NumErr,
			Par_ErrMEn, 			Var_Consecutivo,    Par_EmpresaID,      	Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,     Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		CALL CONTATESOREPRO(
			Aud_Sucursal,     		Var_MonedaBase,   	Par_InstitucionID,  	Par_NumCtaInstit,		Entero_Cero,
			Entero_Cero,    		Entero_Cero,        Var_FechaCancela,		Var_FechaCancela,       Var_Monto,
			Var_Concepto,       	Par_NumOrdenPago,	Par_NumCtaInstit, 		AltaPoliza_NO,     		Par_Poliza,
			ConContaRenovOrdenPago,	Entero_Cero,        Nat_Abono,          	Mov_AhorroNO,     		Entero_Cero,
			Var_ClienteID,      	Cadena_Vacia,       Cadena_Vacia,          	Salida_No,				Par_NumErr,
			Par_ErrMEn, 			Var_Consecutivo,    Par_EmpresaID,      	Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,     Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		SET	Var_RefTeso 		:= CONCAT('NO.ORDEN PAGO: ', CONVERT(Par_NumOrdenPagoCan, CHAR));
		SET Var_CuentaAhoTeso	:= (SELECT CuentaAhoID
										FROM CUENTASAHOTESO
										WHERE 	InstitucionID	= Par_InstitucionIDCan
										AND 	NumCtaInstit	= Par_NumCtaInstitCan);

		CALL TESORERIAMOVALT(
			Var_CuentaAhoTeso,  Var_FechaCancela, 	Var_Monto,       	DesMovimientoAbono, 	Var_RefTeso,
			Conciliado_SI,      Nat_Abono,         	Tip_RegPantalla,    Tip_MovTeso,     		Entero_Cero,
			Salida_No,          Par_NumErr,         Par_ErrMen,         Var_Consecutivo,    	Par_EmpresaID,
			Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     	Aud_Sucursal,
			Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;


		CALL SALDOSCUENTATESOACT(
			Par_NumCtaInstitCan,	Par_InstitucionIDCan,	Var_Monto,			Nat_Abono,			Var_Consecutivo,
			Salida_No,				Par_NumErr,       		Par_ErrMen,     	Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,   		Aud_ProgramaID, 	Aud_Sucursal,     	Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET	Var_RefTeso := CONCAT('NO.ORDEN PAGO: ', CONVERT(Par_NumOrdenPago, CHAR));

		SET Var_CuentaAhoTeso	:= (SELECT 	CuentaAhoID FROM CUENTASAHOTESO
										WHERE InstitucionID	= Par_InstitucionID
										  AND NumCtaInstit	= Par_NumCtaInstit);

		CALL TESORERIAMOVALT(
			Var_CuentaAhoTeso,  Var_FechaCancela, 	Var_Monto,       	Var_Concepto, 			Var_RefTeso,
			Conciliado_NO,      Nat_Cargo,         	Tip_RegPantalla,    Tip_MovTeso,     		Entero_Cero,
			Salida_No,          Par_NumErr,         Par_ErrMen,         Var_Consecutivo,    	Par_EmpresaID,
			Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     	Aud_Sucursal,
			Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;


		CALL SALDOSCUENTATESOACT(
			Par_NumCtaInstit,		Par_InstitucionID,	Var_Monto,			Nat_Cargo,		Var_Consecutivo,
			Salida_No,				Par_NumErr,       	Par_ErrMen,     	Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,   	Aud_ProgramaID, 	Aud_Sucursal,   Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		UPDATE TESORERIAMOVS SET
			Status				= Cancelado,
			EmpresaID   		= Par_EmpresaID,
			Usuario     		= Aud_Usuario,
			FechaActual     	= Aud_FechaActual,
			DireccionIP     	= Aud_DireccionIP,
			ProgramaID      	= Aud_ProgramaID,
			Sucursal        	= Aud_Sucursal,
			NumTransaccion  	= Aud_NumTransaccion
		WHERE NumTransaccion	= Var_NumTransaccion;

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := CONCAT('Orden de Pago Renovada Exitosamente: ', CONVERT(Par_NumOrdenPagoCan,CHAR));
		SET varControl	:= 'institucionIDCan';

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT  Par_NumErr 		AS NumErr,
					Par_ErrMen		AS ErrMen,
					varControl		AS control,
					Par_Poliza		AS consecutivo;
		END IF;

END  TerminaStore$$