-- ISOTRXTRANSACCREPORTEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS ISOTRXTRANSACCREPORTEPRO;

DELIMITER $$
CREATE PROCEDURE ISOTRXTRANSACCREPORTEPRO(
	-- Descripcion: Proceso principal para la interaccion entre ISOTRX y SAFI  para el registro de operaciones en SAFI Y mantener la comunicacion con el autorizador  de operaciones por ISOTRX
	-- Modulo: Proceso de ISOTRX
	Par_EmisorID          			INT(11),    	-- Identificador provisto por ISOTRX
	Par_MensajeID         			VARCHAR(50),	-- Identificador del Mensaje. Valor único global.
	Par_TipoOperacion     			INT(11),    	-- Catalogo CATTIPOPERACIONISOTRX
	Par_ResultadoOperacion			INT(11),    	-- Siempre enviarán 1 Aprobada, 0 = Sin Respuesta,1 = Aprobada , 2 = Declinada , 3 = Rechazada
	Par_EstatusOperacion  			INT(11),    	-- Estatus de operaciòn 0 = Indefinida ,1 = Abierta,2 = Completada ,3 = Devuelta ,5 = Cancelada ,6 = Reversa

	Par_FechaOperacion    			VARCHAR(8),		-- Fecha en formato AAAAMMDD
	Par_HoraOperacion     			VARCHAR(6),		-- Hora en formato HHMMSS
	Par_CodigoRespuesta   			VARCHAR(2),		-- Código de respuesta del autorizador, ver catalogo ISOTRXCODRESPUESTA
	Par_CodigoAutorizacion			VARCHAR(6),		-- Código es el que se utilizará para aplicar reversos.
	Par_CodigoRechazo     			INT(11),   		-- Catalogo ISOTRXCODRECHAZO

	Par_GiroComercial   			INT(11),    	-- Catalogo ISOTRXCODGIROCOMER
	Par_NumeroAfiliacion			INT(11),    	-- Id identificador del comercio
	Par_NombreComercio  			VARCHAR(50),	-- Nombre del comercio
	Par_ModoEntrada     			INT(11),    	-- Catalogo ISOTRXMODOENTRADA
	Par_PuntoAcceso     			INT(11),    	-- Catalogo ISOTRXPUNTOACCES

	Par_NumeroCuenta    			BIGINT(20),   	-- Número de Cuenta del Emisor
	Par_NumeroTarjeta   			VARCHAR(16),  	-- Número de Tarjeta del SAFI
	Par_CodigoMoneda    			INT(11),      	-- Código de Moneda  484 = MX Pesos,840 = USD Dollar,484 = MX Pesos, 840 = USD Dollar
	Par_MontoTransaccion			DECIMAL(12,2),	-- Monto total de la transacción
	Par_MontoAdicional  			DECIMAL(12,2),	-- Monto de disposición en compra

	Par_MontoRemplazo   			DECIMAL(12,2),	-- Monto de remplazo por devolución o disposicion parcial
	Par_MontoComision   			DECIMAL(12,2),	-- Monto de comisión por disposición
	Par_FechaTransaccion			VARCHAR(4),   	-- Fecha en formato MMDD
	Par_HoraTransaccion 			VARCHAR(6),   	-- Hora en formato HHMMSS
	Par_SaldoDisponible 			DECIMAL(12,4),	-- Saldo disponible

	Par_ProDiferimiento      		INT(11),   		-- Número de meses a diferir el primer pago.
	Par_ProNumeroPagos       		INT(11),   		-- Número de parcialidades en las que se divide el monto.
	Par_ProTipoPlan          		INT(11),   		-- Tipo plan 0 = Sin Plan,3 = Sin Intereses ,5 = Con Intereses ,7 = Diferimiento
	Par_OriCodigoAutorizacion		VARCHAR(6),		-- Tomado de la transacción original
	Par_OriFechaTransaccion  		VARCHAR(4),		-- Fecha de la transacción original, formato MMDD

	Par_OriHoraTransaccion     		VARCHAR(6), 	-- Hora de la transacción original,  formato HHMMSS
	Par_DesNumeroCuenta        		BIGINT(20), 	-- Número de cuenta destino de la trasferencia local
	Par_DesNumeroTarjeta       		VARCHAR(16),	-- Número de tarjeta destino de la transferencia local
	Par_TrsClaveRastreo        		VARCHAR(30),	-- Clave de rastreo de la transferencia
	Par_TrsInstitucionRemitente		INT(11),    	-- Clave de la institución desde donde se envía la transferencia

	Par_TrsNombreEmisor       		VARCHAR(50),	-- Nombre de quien envía la transferencia
	Par_TrsTipoCuentaRemitente		INT(11),    	-- Tipo de Cuenta de quien envía la transferencia
	Par_TrsCuentaRemitente    		VARCHAR(16),	-- Numero de cuenta de quien envía la transferencia
	Par_TrsConceptoPago       		VARCHAR(50),	-- Concepto de la transferencia
	Par_TrsReferenciaNumerica 		INT(11),    	-- Referencia numérica asociada a la transferencia

	INOUT Par_Poliza				BIGINT(20),		-- Numero de poliza para registrar los detalles contables
	Par_TarDebMovID					INT(11),		-- Consecutivo del movimiento de tarjeta

	Par_Salida						CHAR(1),     	-- Especifica salida o no del sp: Si:'S' y No:'N'
	INOUT Par_NumErr				INT(11),		-- Numero de error
	INOUT Par_ErrMen				VARCHAR(400),	-- Mensaje de error descripctivo

	Par_EmpresaID					INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario						INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual					DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP					VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID					VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal					INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion				BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore: BEGIN

 	/* Declaracion de Variables */
	DECLARE Var_Control			VARCHAR(80);
	DECLARE Var_FechaOpera		DATE;
	DECLARE Var_HoraOpera		TIME;
	DECLARE Var_OriFechaOpera	DATE;
	DECLARE Var_OriHoraOpera	TIME;
	DECLARE Var_CntTrDbBtcrMvs	INT(11);		-- Numero de Operaciones Existentes
	DECLARE Var_FechaHrOpe		VARCHAR(20);	-- Fecha y Hora de la transaccion original


	 /* Declaracion de Constantes */
	DECLARE Entero_Cero         		INT(11);       		-- Entero cero
	DECLARE	Cadena_Vacia				CHAR(1);       		-- Cadena vacia
	DECLARE	Decimal_Cero				DECIMAL(12,2); 		-- decimal cero
	DECLARE	SalidaSI					CHAR(1);       		-- Salida si
	DECLARE	SalidaNO					CHAR(1);       		-- Salida no
	DECLARE Fecha_Vacia         		DATE;
	DECLARE Conta_tarjeta       		INT(11);
	DECLARE Var_EncabezadoNo    		CHAR(1);
	DECLARE Var_AltaPolTarSI    		CHAR(1);
	DECLARE Var_AltaMovAhoSI    		CHAR(1);
	DECLARE Var_Descripcion     		VARCHAR(150);
	DECLARE Hora_Vacia					TIME;				-- Hora vacia
	DECLARE LLave_UsuarioTransaccion	VARCHAR(50);	-- LLave de usuario de transaccion

	-- Declaracion de tipos de transacciones
	DECLARE Tran_VentaNormal    		INT(11);			-- Transaccion de tipo venta normal
	DECLARE Tran_VentaCAT       		INT(11);			-- Transaccion de tipo venta CAT
	DECLARE Tran_VentaInternet  		INT(11);			-- Transaccion de tipo venta por internet
	DECLARE Tran_VentaManual    		INT(11);			-- Transaccion de tipo venta manual
	DECLARE Tran_CargoRecurrente 		INT(11);			-- Transaccion de tipo venta cargo recurrente
	DECLARE Tran_VentaQPS            	INT(11);			-- Transaccion de tipo venta QPS
	DECLARE Tran_VentaMoTo           	INT(11);			-- Transaccion de tipo venta MoTo
	DECLARE Tran_VentaConPromocion   	INT(11);			-- Transaccion de tipo venta con promocion
	DECLARE Tran_CargoEmisor         	INT(11);			-- Transaccion de tipo venta Cargo emisor
	DECLARE Tran_ReversoPago         	INT(11);			-- Transaccion de tipo venta reverso de pago
	DECLARE Tran_VentaVoz            	INT(11);			-- Transaccion de tipo venta venta de voz
	DECLARE Tran_TransferenciaSPEI   	INT(11);			-- Transaccion de tipo venta transferencia spei
	DECLARE Tran_Transferencia       	INT(11);			-- Transaccion de tipo venta transferencia
	DECLARE Tran_TransferenciaEMISOR 	INT(11);			-- Transaccion de tipo venta transferencia emisor
	DECLARE Tran_Disposicion         	INT(11);			-- Transaccion de tipo venta disposicion
	DECLARE Tran_PreAutorizacion        INT(11);			-- Transaccion de tipo preautorizacion
	DECLARE Tran_ReAutorizacion         INT(11);			-- Transaccion de tipo reautorizacion
	DECLARE Tran_ReversoVenta			INT(11);			-- Transaccion de tipo reverso de la venta
	DECLARE Tran_ReversoDisposicion     INT(11);            -- Transaccion de tipo reverso disposicion
	DECLARE Tran_Devolucion				INT(11);			-- Transaccion de tipo devolucion
	DECLARE Tran_Cancelacion			INT(11);			-- Transaccion de tipo cancelacion
	DECLARE Tran_Pago					INT(11);			-- Transaccion de tipo pago
	DECLARE Tran_DepositoSPEI			INT(11);			-- Transaccion de tipo deposito por spei
	DECLARE Tran_DepositoEmisor			INT(11);			-- Transaccion de tipo deposito por emisor
	DECLARE Tran_DepositoTransferencia	INT(11);			-- Transaccion de tipo deposito por trasfrencia
	DECLARE Tran_CambioNIP				INT(11);			-- Transaccion de tipo cambio de nip
	DECLARE Tran_Consulta				INT(11);			-- Transaccion de tipo consulta
	DECLARE Tran_ReversoConsulta		INT(11);			-- Transaccion de tipo reverso de consulta
	DECLARE Tran_Ajuste					INT(11);			-- Transaccion de tipo ajuste
	DECLARE Tran_ReversoParcial			INT(11);			-- Transaccion de tipo reverso parcial
	DECLARE Tran_PosAutorizacion		INT(11);			-- Transaccion de tipo pos autorizacion

	-- Declaracion de numero de actualizaciones
	DECLARE Act_Procesada				INT(11);			-- Actualizacion a estatus procesada

	-- Asignacion  de constantes
	SET	Cadena_Vacia					:= '';				-- Constante Cadena Vacia
	SET	Entero_Cero						:= 0;				-- Constante Entero Cero
	SET	Decimal_Cero					:= 0.0;				-- Constante Decimal Cero
	SET	SalidaSI						:= 'S';				-- Constante SI
	SET	SalidaNO						:= 'N';				-- Constante NO
	SET Fecha_Vacia         			:= '1900-01-01'; 	-- Fecha Vacia
	SET Hora_Vacia						:= '00:00:00';		-- Hora vacia
	SET LLave_UsuarioTransaccion		:= 'UsuarioTransacionID';

	-- DECLARACION DE TIPO DE OPERACION
	SET Tran_VentaNormal             	:= 1;
	SET Tran_VentaConPromocion       	:= 3;
	SET Tran_VentaManual             	:= 5;
	SET Tran_VentaInternet           	:= 6;
	SET Tran_VentaMoTo               	:= 7;
	SET Tran_VentaVoz                	:= 8;
	SET Tran_VentaQPS                	:= 9;
	SET Tran_VentaCAT                	:= 10;
	SET Tran_Disposicion             	:= 12;
	SET Tran_PreAutorizacion            := 14;
	SET Tran_ReAutorizacion             := 15;
	SET Tran_PosAutorizacion			:= 16;
	SET Tran_CargoRecurrente         	:= 17;
	SET Tran_CargoEmisor             	:= 18;
	SET Tran_ReversoPago             	:= 19;
	SET Tran_Devolucion					:= 20;
	SET Tran_Ajuste						:= 21;
	SET Tran_Cancelacion				:= 22;
	SET Tran_Pago						:= 25;
	SET Tran_ReversoVenta				:= 26;
	SET Tran_ReversoDisposicion			:= 27;
	SET Tran_ReversoConsulta			:= 28;
	SET Tran_ReversoParcial				:= 29;
	SET Tran_Consulta					:= 30;
	SET Tran_Transferencia           	:= 40;
	SET Tran_TransferenciaSPEI       	:= 41;
	SET Tran_TransferenciaEMISOR     	:= 42;
	SET Tran_DepositoSPEI				:= 51;
	SET Tran_DepositoEmisor				:= 52;
	SET Tran_DepositoTransferencia		:= 53;
	SET Tran_CambioNIP					:= 96;

	-- Asignacion de numero de actualizaciones
	SET Act_Procesada					:= 1;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ISOTRXTRANSACCREPORTEPRO');
			SET Var_Control:= 'sqlException' ;
		END;

	SET Par_EmisorID                :=(IFNULL(Par_EmisorID,Entero_Cero));
	SET Par_MensajeID               :=(IFNULL(Par_MensajeID,Cadena_Vacia));
	SET Par_CodigoRechazo           :=(IFNULL(Par_CodigoRechazo,Entero_Cero));
	SET Par_NumeroAfiliacion        :=(IFNULL(Par_NumeroAfiliacion,Entero_Cero));
	SET Par_NombreComercio          :=(IFNULL(Par_NombreComercio,Cadena_Vacia));
	SET Par_NumeroCuenta    	    :=(IFNULL(Par_NumeroCuenta,Entero_Cero));
	SET Par_MontoAdicional  	    :=(IFNULL(Par_MontoAdicional,Decimal_Cero));
	SET Par_MontoRemplazo   	    :=(IFNULL(Par_MontoRemplazo,Decimal_Cero));
	SET Par_MontoComision   	    :=(IFNULL(Par_MontoComision,Decimal_Cero));
	SET Par_SaldoDisponible 	    :=(IFNULL(Par_SaldoDisponible,Decimal_Cero));
	SET Par_ProDiferimiento 	    :=(IFNULL(Par_ProDiferimiento,Entero_Cero));
	SET Par_ProNumeroPagos  	    :=(IFNULL(Par_ProNumeroPagos,Entero_Cero));
	SET Par_ProTipoPlan    		    :=(IFNULL(Par_ProTipoPlan,Entero_Cero));
	SET	Par_DesNumeroCuenta 	    :=(IFNULL(Par_DesNumeroCuenta,Entero_Cero));
	SET Par_DesNumeroTarjeta    	:=(IFNULL(Par_DesNumeroTarjeta,Entero_Cero));
	SET Par_TrsClaveRastreo 	    :=(IFNULL(Par_TrsClaveRastreo,Cadena_Vacia));
	SET Par_TrsInstitucionRemitente :=(IFNULL(Par_TrsInstitucionRemitente,Entero_Cero));
	SET Par_TrsNombreEmisor    		:=(IFNULL(Par_TrsNombreEmisor,Cadena_Vacia));
	SET Par_TrsTipoCuentaRemitente 	:=(IFNULL(Par_TrsTipoCuentaRemitente,Entero_Cero));
	SET Par_TrsCuentaRemitente 		:=(IFNULL(Par_TrsCuentaRemitente,Cadena_Vacia));
	SET Par_TrsConceptoPago 		:=(IFNULL(Par_TrsConceptoPago,Cadena_Vacia));
	SET Par_TrsReferenciaNumerica 	:=(IFNULL(Par_TrsReferenciaNumerica,Entero_Cero));
	SET Aud_Usuario					:= CAST(IFNULL(FNPARAMTARJETAS(LLave_UsuarioTransaccion),Entero_Cero) AS UNSIGNED);

	CALL ISOTRXTRANSACCREPORTEVAL(
									Par_EmisorID,           Par_MensajeID,              Par_TipoOperacion,             Par_ResultadoOperacion,        Par_EstatusOperacion,
									Par_FechaOperacion,     Par_HoraOperacion,          Par_CodigoRespuesta,           Par_CodigoAutorizacion,        Par_CodigoRechazo,
									Par_GiroComercial,      Par_NumeroAfiliacion,       Par_NombreComercio,            Par_ModoEntrada,               Par_PuntoAcceso,
									Par_NumeroCuenta,       Par_NumeroTarjeta,          Par_CodigoMoneda,              Par_MontoTransaccion,          Par_MontoAdicional,
									Par_MontoRemplazo,      Par_MontoComision,          Par_FechaTransaccion,          Par_HoraTransaccion,           Par_SaldoDisponible,
									Par_ProDiferimiento,    Par_ProNumeroPagos,         Par_ProTipoPlan,               Par_OriCodigoAutorizacion,     Par_OriFechaTransaccion,
									Par_OriHoraTransaccion, Par_DesNumeroCuenta,        Par_DesNumeroTarjeta,          Par_TrsClaveRastreo,           Par_TrsInstitucionRemitente,
									Par_TrsNombreEmisor,    Par_TrsTipoCuentaRemitente, Par_TrsCuentaRemitente,        Par_TrsConceptoPago,           Par_TrsReferenciaNumerica,
									SalidaNO,               Par_NumErr,                 Par_ErrMen,                    Par_EmpresaID,	              Aud_Usuario,
									Aud_FechaActual,        Aud_DireccionIP,            Aud_ProgramaID,                Aud_Sucursal,                  Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	IF IFNULL(Par_HoraTransaccion,Cadena_Vacia) = Cadena_Vacia THEN
	  	 SET Par_HoraTransaccion := DATE_FORMAT(Var_HoraSistema,"%H%i%s");
	END IF;


	IF IFNULL(Par_FechaOperacion,Cadena_Vacia) = Cadena_Vacia THEN
		SET Var_FechaOpera := Fecha_Vacia;
		ELSE
		SET Var_FechaOpera := STR_TO_DATE(Par_FechaOperacion ,"%Y%m%d");
	END IF;

	IF IFNULL(Par_HoraOperacion,Cadena_Vacia) = Cadena_Vacia THEN
		SET Var_HoraOpera := Hora_Vacia;
		ELSE
		SET Var_HoraOpera := concat(substr(Par_HoraOperacion,1,2),':',substr(Par_HoraOperacion,3,2),':',substr(Par_HoraOperacion,5,2));
	END IF;

	IF IFNULL(Par_OriFechaTransaccion,Cadena_Vacia) = Cadena_Vacia THEN
		SET Var_OriFechaOpera := Fecha_Vacia;
		ELSE
		SET Var_OriFechaOpera := STR_TO_DATE(CONCAT(DATE_FORMAT(Aud_FechaActual,"%Y"),Par_OriFechaTransaccion) ,"%Y%m%d");
	END IF;

	IF IFNULL(Par_OriHoraTransaccion,Cadena_Vacia) = Cadena_Vacia THEN
		SET Var_OriHoraOpera := Hora_Vacia;
		ELSE
		SET Var_OriHoraOpera := concat(substr(Par_OriHoraTransaccion,1,2),':',substr(Par_OriHoraTransaccion,3,2),':',substr(Par_OriHoraTransaccion,5,2));
	END IF;

	IF IFNULL(Par_FechaTransaccion,Cadena_Vacia) = Cadena_Vacia THEN
		SET Var_FechaHrOpe := Fecha_Vacia;
	ELSE
		SET Var_FechaHrOpe := STR_TO_DATE( CONCAT(DATE_FORMAT(Aud_FechaActual,"%Y"),Par_FechaTransaccion," ",Par_HoraTransaccion), "%Y%m%d %H%i%s") ;
	END IF;

	-- VALIDACION DE TRANSACCION REPETIDA
	SELECT COUNT(*)
			INTO Var_CntTrDbBtcrMvs
			FROM TARDEBBITACORAMOVS
			WHERE TarjetaDebID = Par_NumeroTarjeta
			AND CodigoAprobacion = Par_CodigoAutorizacion
			AND Estatus = 'P'
			AND MontoOpe = Par_MontoTransaccion
			AND TerminalID = Par_NumeroAfiliacion
			AND Fechahrope = Var_FechaHrOpe;

	IF Var_CntTrDbBtcrMvs > Entero_Cero  THEN
		SET Par_NumErr	:= 1226;
		SET Par_ErrMen	:= 'Transaccion repetida';
		LEAVE ManejoErrores;
	END IF;

		-- Tipos de transacciones
		CASE Par_TipoOperacion
			WHEN Tran_VentaNormal  THEN
				CALL ISOTRXVENTANORMALPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			WHEN Tran_VentaCAT THEN
				CALL ISOTRXVENTANORMALPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			WHEN Tran_VentaInternet THEN
				CALL ISOTRXVENTANORMALPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			WHEN Tran_VentaManual THEN
				CALL ISOTRXVENTANORMALPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			WHEN Tran_CargoRecurrente THEN
				CALL ISOTRXVENTANORMALPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			WHEN Tran_VentaQPS THEN
				CALL ISOTRXVENTANORMALPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			WHEN Tran_VentaMoTo THEN
				CALL ISOTRXVENTANORMALPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			WHEN Tran_VentaConPromocion THEN
				CALL ISOTRXVENTANORMALPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			WHEN Tran_CargoEmisor THEN
				CALL ISOTRXVENTANORMALPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			WHEN Tran_ReversoPago  THEN
				CALL ISOTRXVENTANORMALPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			WHEN Tran_VentaVoz THEN
				CALL ISOTRXVENTANORMALPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			WHEN Tran_TransferenciaSPEI THEN
				CALL ISOTRXVENTANORMALPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			WHEN Tran_Transferencia THEN
				CALL ISOTRXVENTANORMALPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			WHEN Tran_TransferenciaEMISOR THEN
				CALL ISOTRXVENTANORMALPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			WHEN Tran_Disposicion THEN
				CALL ISOTRXDISPOSICIONPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			WHEN Tran_PreAutorizacion THEN
				CALL ISOTRXPREAUTORIZACIONPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
				-- Transaccion de tipo reautorizacion
			WHEN Tran_ReAutorizacion THEN
				CALL ISOTRXREAUTORIZACIONPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
				-- Transaccion de tipo pos autorizacion
			WHEN Tran_PosAutorizacion THEN
				CALL ISOTRXPOSAUTORIZACIONPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
				-- Proceso de reverso de la venta
			WHEN Tran_ReversoVenta THEN
				CALL ISOTRXREVERSAVENTAPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
				-- Proceso de reverso de dispersion
			WHEN Tran_ReversoDisposicion THEN
				CALL ISOTRXREVERSADISPOSICIONPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
				-- Proceso de reverso de consulta
			WHEN Tran_ReversoConsulta THEN
				CALL ISOTRXREVERSOCONSULTAPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			-- Proceso de ajuste
			WHEN Tran_Ajuste THEN
				CALL ISOTRXAJUSTEREVERSOPARCIALPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
				-- Proceso de devolucion
			WHEN Tran_Devolucion THEN
				CALL ISOTRXDEVOLUCIONCANCELAPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
				-- Proceso de reverso parcial
			WHEN Tran_ReversoParcial THEN
				CALL ISOTRXAJUSTEREVERSOPARCIALPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
				-- Proceso de cancelacion
			WHEN Tran_Cancelacion THEN
				CALL ISOTRXDEVOLUCIONCANCELAPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
				-- Proceso de pago
			WHEN Tran_Pago THEN
				CALL ISOTRXDEPOSITOPAGOPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
				-- Proceso de DEPOSITO SPEI
			WHEN Tran_DepositoSPEI THEN
				CALL ISOTRXDEPOSITOPAGOPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
				-- Proceso de DEPOSITO EMISOR
			WHEN Tran_DepositoEmisor THEN
				CALL ISOTRXDEPOSITOPAGOPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
				-- Proceso de DEPOSITO TRANSFERENCIA
			WHEN Tran_DepositoTransferencia THEN
				CALL ISOTRXDEPOSITOPAGOPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
				-- Proceso de cambio de NIP
			WHEN Tran_CambioNIP THEN
				CALL ISOTRXNIPCONSULTAPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
				-- Proceso de consulta
			WHEN Tran_Consulta THEN
				CALL ISOTRXNIPCONSULTAPRO(
					Par_EmisorID,			Par_MensajeID,					Par_TipoOperacion,			Par_ResultadoOperacion,			Par_EstatusOperacion,
					Var_FechaOpera,			Var_HoraOpera,					Par_CodigoRespuesta,		Par_CodigoAutorizacion,			Par_CodigoRechazo,
					Par_GiroComercial,		Par_NumeroAfiliacion,			Par_NombreComercio,			Par_ModoEntrada,				Par_PuntoAcceso,
					Par_NumeroCuenta,		Par_NumeroTarjeta,				Par_CodigoMoneda,			Par_MontoTransaccion,			Par_MontoAdicional,
					Par_MontoRemplazo,		Par_MontoComision,				Par_FechaTransaccion,		Par_HoraTransaccion,			Par_SaldoDisponible,
					Par_ProDiferimiento,	Par_ProNumeroPagos,				Par_ProTipoPlan,			Par_OriCodigoAutorizacion,		Var_OriFechaOpera,
					Var_OriHoraOpera,		Par_DesNumeroCuenta,			Par_DesNumeroTarjeta,		Par_TrsClaveRastreo,			Par_TrsInstitucionRemitente,
					Par_TrsNombreEmisor,	Par_TrsTipoCuentaRemitente,		Par_TrsCuentaRemitente,		Par_TrsConceptoPago,			Par_TrsReferenciaNumerica,
					Par_Poliza,				SalidaNO,						Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
					Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			ELSE
			-- CUANDO LA TRANSACCION NO EXISTE EN LOS PROCESOS
				SET Par_NumErr	:=  1225;
				SET Par_ErrMen	:= 'La transaccion no existe o no se encuentra el servicio disponible.';
				SET Var_Control	:= 'tipoOperacion';
				LEAVE ManejoErrores;
		END CASE;

	-- CUANDO NO HUBO NINGUN ERROR EN EL PROCESO, SE REALIZA LA ACTUALIZACION DEL MOVIMIENTO DE LA TARJETA A PROCESADO
	CALL ISOTRXTARDEBBITACORAMOVSACT(
		Par_TipoOperacion,	Par_NumeroTarjeta,	Par_TarDebMovID,	Act_Procesada,
		SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion
	);
	-- Se evalua el error
	IF(Par_NumErr <> Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	SET Par_NumErr := 000;
	SET Par_ErrMen := 'Transacción Autorizada.';

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen;
END IF;


END TerminaStore$$