-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ISOTRXTRANSACCREPORTEVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS ISOTRXTRANSACCREPORTEVAL;

DELIMITER $$
CREATE PROCEDURE ISOTRXTRANSACCREPORTEVAL(
	-- Descripcion: Proceso de validacion de parametros enviados por WS para el registro de operaciones por el autorizador  de operaciones por ISOTRX
	-- Modulo: Proceso de ISOTRX
	Par_EmisorID                 INT(11),       -- Identificador provisto por ISOTRX
	Par_MensajeID                VARCHAR(50),   -- Identificador del Mensaje. Valor único global.
	Par_TipoOperacion            INT(11),       -- Catalogo CATTIPOPERACIONISOTRX
	Par_ResultadoOperacion       INT(11),       -- Siempre enviarán 1 Aprobada, 0 = Sin Respuesta,1 = Aprobada , 2 = Declinada , 3 = Rechazada
	Par_EstatusOperacion         INT(11),       -- Estatus de operaciòn 0 = Indefinida ,1 = Abierta,2 = Completada ,3 = Devuelta ,5 = Cancelada ,6 = Reversa

	Par_FechaOperacion           VARCHAR(8),    -- Fecha en formato AAAAMMDD
	Par_HoraOperacion            VARCHAR(6),    -- Hora en formato HHMMSS
	Par_CodigoRespuesta          VARCHAR(2),    -- Código de respuesta del autorizador, ver catalogo ISOTRXCODRESPUESTA
	Par_CodigoAutorizacion       VARCHAR(6),    -- Código es el que se utilizará para aplicar reversos.
	Par_CodigoRechazo            INT(11),       -- Catalogo ISOTRXCODRECHAZO

	Par_GiroComercial            INT(11),       -- Catalogo ISOTRXCODGIROCOMER
	Par_NumeroAfiliacion         INT(11),       -- Id identificador del comercio
	Par_NombreComercio           VARCHAR(50),   -- Nombre del comercio
	Par_ModoEntrada              INT(11),       -- Catalogo ISOTRXMODOENTRADA
	Par_PuntoAcceso              INT(11),       -- Catalogo ISOTRXPUNTOACCES

	Par_NumeroCuenta             BIGINT(20),    -- Número de Cuenta del Emisor
	Par_NumeroTarjeta            VARCHAR(16),   -- Número de Tarjeta del SAFI
	Par_CodigoMoneda             INT(11),       -- Código de Moneda  484 = MX Pesos,840 = USD Dollar,484 = MX Pesos, 840 = USD Dollar
	Par_MontoTransaccion         DECIMAL(12,2), -- Monto total de la transacción
	Par_MontoAdicional           DECIMAL(12,2), -- Monto de disposición en compra

	Par_MontoRemplazo            DECIMAL(12,2),  -- Monto de remplazo por devolución o disposicion parcial
	Par_MontoComision            DECIMAL(12,2),  -- Monto de comisión por disposición
	Par_FechaTransaccion         VARCHAR(4),     -- Fecha en formato MMDD
	Par_HoraTransaccion          VARCHAR(6),     -- Hora en formato HHMMSS
	Par_SaldoDisponible          DECIMAL(12,4),  -- Saldo disponible

	Par_ProDiferimiento          INT(11),       -- Número de meses a diferir el primer pago.
	Par_ProNumeroPagos           INT(11),       -- Número de parcialidades en las que se divide el monto.
	Par_ProTipoPlan              INT(11),       -- Tipo plan 0 = Sin Plan,3 = Sin Intereses ,5 = Con Intereses ,7 = Diferimiento
	Par_OriCodigoAutorizacion    VARCHAR(6),    -- Tomado de la transacción original
	Par_OriFechaTransaccion      VARCHAR(4),    -- Fecha de la transacción original, formato MMDD

	Par_OriHoraTransaccion       VARCHAR(6),    -- Hora de la transacción original,  formato HHMMSS
	Par_DesNumeroCuenta          BIGINT(20),    -- Número de cuenta destino de la trasferencia local
	Par_DesNumeroTarjeta         VARCHAR(16),   -- Número de tarjeta destino de la transferencia local
	Par_TrsClaveRastreo          VARCHAR(30),   -- Clave de rastreo de la transferencia
	Par_TrsInstitucionRemitente  INT(11),       -- Clave de la institución desde donde se envía la transferencia

	Par_TrsNombreEmisor          VARCHAR(50),   -- Nombre de quien envía la transferencia
	Par_TrsTipoCuentaRemitente   INT(11),       -- Tipo de Cuenta de quien envía la transferencia
	Par_TrsCuentaRemitente       VARCHAR(16),   -- Numero de cuenta de quien envía la transferencia
	Par_TrsConceptoPago          VARCHAR(50),   -- Concepto de la transferencia
	Par_TrsReferenciaNumerica    INT(11),       -- Referencia numérica asociada a la transferencia

	Par_Salida				     CHAR(1),       -- Especifica salida o no del sp: Si:'S' y No:'N'
	INOUT Par_NumErr			 INT(11),		-- Numero de error
	INOUT Par_ErrMen			 VARCHAR(400),	-- Mensaje de error descripctivo

	Par_EmpresaID				 INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					 INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				 DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP				 VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				 VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				 INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			 BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

 	/* Declaraciond e Variables */
	DECLARE Var_TipoOperacion   			INT(11);
	DECLARE Var_CodigoRespuesta 			INT(11);
	DECLARE Var_GiroComercial   			INT(11);
	DECLARE Var_ModoEntrada     			INT(11);
	DECLARE Var_PuntoAcces      			INT(11);
	DECLARE Par_Consecutivo     			BIGINT(20);
	DECLARE Var_CodigoRechazo   			INT(11);
	DECLARE Var_Control			     		VARCHAR(80);
	DECLARE Var_AutorizaTerceroTranTD		VARCHAR(200);	-- Variable para almacenar el valor del campo AutorizaTerceroTranTD
	DECLARE Var_EjecucionCierreDia			VARCHAR(200);	-- Variable para almacenar el valor del campo EjecucionCierreDia
	DECLARE Var_NotificacionTarCierreDia 	VARCHAR(200);  -- Variable para almacenar el valor del campo NotificacionTarCierreDia
	DECLARE Con_SI							CHAR(1);		-- Constante SI
	DECLARE Con_NO 							CHAR(1);		-- Constante NO
	DECLARE Var_AltaPoliza					CHAR(1);		-- Bandera que indica cuando se da de alta la poliza
	DECLARE Var_Concepto					VARCHAR(250);	-- Nombre del concepto para las polizas contables
	DECLARE Var_UsuarioTransaccionID		INT(11);		-- Usuario de transaccion de ISOTRX
	DECLARE Var_CntTrDbBtcrMvs				INT(11);		-- Numero de Operaciones Existentes
	DECLARE Var_FechaHrOpe					VARCHAR(20);	-- Fecha y Hora de la transaccion original

 	/* Declaracion de Constantes */
	DECLARE Entero_Cero                 	INT(11);       -- Entero cero
	DECLARE	Cadena_Vacia	        		CHAR(1);       -- Cadena vacia
	DECLARE	Decimal_Cero		        	DECIMAL(12,2); -- decimal cero
	DECLARE	SalidaSI			        	CHAR(1);       -- Salida si
	DECLARE	SalidaNO			        	CHAR(1);       -- Salida no
	DECLARE CatResultOper               	VARCHAR(50);
	DECLARE CatEstatusOper              	VARCHAR(50);
	DECLARE CatCodigoMoneda             	VARCHAR(50);
	DECLARE ConsPostAutoriza            	INT(11);
	DECLARE EstatusOPerReversa          	INT(11);
	DECLARE Fecha_Vacia                 	DATE;
	DECLARE Entero_error                	INT(11);
	DECLARE Entero_Cien                 	INT(11);
	DECLARE Hora_Vacia                  	TIME;
	DECLARE Llave_AutorizaTerceroTranTD		VARCHAR(50);	-- Llave AutorizaTerceroTranTD
	DECLARE Llave_EjecucionCierreDia		VARCHAR(50);	-- Llave EjecucionCierreDia
	DECLARE Llave_NotificacionTarCierreDia 	VARCHAR(50);	-- Llave NotificacionTarCierreDia
	DECLARE LLave_UsuarioTransaccion		VARCHAR(50);	-- LLave de usuario de transaccion
	DECLARE Cons_Seis                       INT(11);
	DECLARE Cons_cuatro                     INT(11);

	-- DECLARACION DE TIPO DE TRANSCCIONES
	DECLARE Tran_PreAutorizacion			INT(11);		-- Transaccion de tipo preautorizacion
	DECLARE Tran_ReAutorizacion				INT(11);		-- Transaccion de tipo reautorizacion
	DECLARE Tran_CambioNIP					INT(11);		-- Transaccion de tipo cambio de nip
	DECLARE Tran_Consulta					INT(11);		-- Transaccion de tipo consulta
	DECLARE Tran_ReversoVenta				INT(11);		-- Transaccion de tipo reverso de la venta
	DECLARE Tran_Ajuste						INT(11);		-- Transaccion de tipo ajuste
	DECLARE Tran_ReversoParcial				INT(11);		-- Transaccion de tipo reverso parcial
	DECLARE Tran_VentaNormal    			INT(11);		-- Transaccion de tipo venta normal
	DECLARE Tran_VentaCAT       			INT(11);		-- Transaccion de tipo venta CAT
	DECLARE Tran_VentaInternet  			INT(11);		-- Transaccion de tipo venta por internet
	DECLARE Tran_VentaManual    			INT(11);		-- Transaccion de tipo venta manual
	DECLARE Tran_CargoRecurrente 			INT(11);		-- Transaccion de tipo venta cargo recurrente
	DECLARE Tran_VentaQPS            		INT(11);		-- Transaccion de tipo venta QPS
	DECLARE Tran_VentaMoTo           		INT(11);		-- Transaccion de tipo venta MoTo
	DECLARE Tran_VentaConPromocion   		INT(11);		-- Transaccion de tipo venta con promocion
	DECLARE Tran_CargoEmisor         		INT(11);		-- Transaccion de tipo venta Cargo emisor
	DECLARE Tran_ReversoPago         		INT(11);		-- Transaccion de tipo venta reverso de pago
	DECLARE Tran_VentaVoz            		INT(11);		-- Transaccion de tipo venta venta de voz
	DECLARE Tran_TransferenciaSPEI   		INT(11);		-- Transaccion de tipo venta transferencia spei
	DECLARE Tran_Transferencia       		INT(11);		-- Transaccion de tipo venta transferencia
	DECLARE Tran_TransferenciaEMISOR 		INT(11);		-- Transaccion de tipo venta transferencia emisor
	DECLARE Tran_PosAutorizacion			INT(11);		-- Transaccion de tipo pos autorizacion
	DECLARE Tran_ReversoDisposicion			INT(11);		-- Transaccion de tipo reverso disposicion
	DECLARE Tran_Devolucion					INT(11);		-- Transaccion de tipo devolucion
	DECLARE Tran_Cancelacion				INT(11);		-- Transaccion de tipo cancelacion
	DECLARE Tran_ReversoConsulta			INT(11);		-- Transaccion de tipo reverso de consulta

	-- Asignacion  de constantes
	SET	Cadena_Vacia						:= '';		        -- Constante Cadena Vacia
	SET	Entero_Cero							:= 0;	         	-- Constante Entero Cero
	SET	Decimal_Cero						:= 0.0;		        -- Constante Decimal Cero
	SET	SalidaSI							:= 'S';		        -- Constante SI
	SET	SalidaNO							:= 'N';		        -- Constante NO
	SET Fecha_Vacia         				:= '1900-01-01';    -- Fecha Vacia
	SET CatResultOper           			:= '0,1,2,3';       -- Tipos de resultado de operacion
	SET CatEstatusOper          			:= '0,1,2,3,4,5,6'; -- Estatus de operacion
	SET CatCodigoMoneda         			:= '484,840';       -- Codigos para moneda  484 = MX Pesos,840 = USD Dollar
	SET ConsPostAutoriza        			:= 16;              -- Valor para postAutoriza
	SET EstatusOPerReversa      			:= 6;               -- Estatus de operacion de Reversa
	SET Entero_error            			:= -1;              -- Entero negativo 1
	SET Entero_Cien             			:= 100;             -- Entero con valor 100
	SET Hora_Vacia              			:= '00:00:00';      -- Hora vacia
	SET Con_NO 								:= 'N';             -- Constante NO
	SET Con_SI								:= 'S';             -- Constante SI
	SET Cons_Seis                           := 6;
	SET Cons_cuatro                         := 4;

	-- ASIGNACION DE TIPO DE TRANSACCIONES
	SET Tran_VentaNormal             		:= 1;
	SET Tran_VentaConPromocion       		:= 3;
	SET Tran_VentaManual             		:= 5;
	SET Tran_VentaInternet           		:= 6;
	SET Tran_VentaMoTo               		:= 7;
	SET Tran_VentaVoz                		:= 8;
	SET Tran_VentaQPS                		:= 9;
	SET Tran_VentaCAT                		:= 10;
	SET Tran_PreAutorizacion				:= 14;
	SET Tran_ReAutorizacion					:= 15;
	SET Tran_PosAutorizacion				:= 16;
	SET Tran_CargoRecurrente         		:= 17;
	SET Tran_CargoEmisor             		:= 18;
	SET Tran_ReversoPago             		:= 19;
	SET Tran_Devolucion						:= 20;
	SET Tran_Ajuste							:= 21;
	SET Tran_Cancelacion					:= 22;
	SET Tran_ReversoVenta					:= 26;
	SET Tran_ReversoDisposicion				:= 27;
	SET Tran_ReversoConsulta				:= 28;
	SET Tran_ReversoParcial					:= 29;
	SET Tran_Consulta						:= 30;
	SET Tran_Transferencia           		:= 40;
	SET Tran_TransferenciaSPEI       		:= 41;
	SET Tran_TransferenciaEMISOR     		:= 42;
	SET Tran_CambioNIP						:= 96;

	SET Llave_AutorizaTerceroTranTD	    	:= 'AutorizaTerceroTranTD';
	SET Llave_EjecucionCierreDia	    	:= 'EjecucionCierreDia';
	SET Llave_NotificacionTarCierreDia		:= 'NotificacionTarCierreDia';
	SET LLave_UsuarioTransaccion			:= 'UsuarioTransacionID';

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ISOTRXTRANSACCREPORTEVAL');
			SET Var_Control:= 'sqlException' ;
		END;
	-- Validacion sobre datos nulos
	SET Par_EmisorID                :=(IFNULL(Par_EmisorID,Entero_Cero));
	SET Par_MensajeID               :=(IFNULL(Par_MensajeID,Cadena_Vacia));
	SET Par_FechaOperacion          :=(IFNULL(Par_FechaOperacion,Cadena_Vacia));
	SET Par_HoraOperacion           :=(IFNULL(Par_HoraOperacion,Cadena_Vacia));
	SET Par_CodigoRechazo           :=(IFNULL(Par_CodigoRechazo,Entero_error));
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
	SET Par_DesNumeroTarjeta    	:=(IFNULL(Par_DesNumeroTarjeta,Cadena_Vacia));
	SET Par_TrsClaveRastreo 	    :=(IFNULL(Par_TrsClaveRastreo,Cadena_Vacia));
	SET Par_TrsInstitucionRemitente :=(IFNULL(Par_TrsInstitucionRemitente,Entero_Cero));
	SET Par_TrsNombreEmisor    		:=(IFNULL(Par_TrsNombreEmisor,Cadena_Vacia));
	SET Par_TrsTipoCuentaRemitente 	:=(IFNULL(Par_TrsTipoCuentaRemitente,Entero_Cero));
	SET Par_TrsCuentaRemitente 		:=(IFNULL(Par_TrsCuentaRemitente,Cadena_Vacia));
	SET Par_TrsConceptoPago 		:=(IFNULL(Par_TrsConceptoPago,Cadena_Vacia));
	SET Par_TrsReferenciaNumerica 	:=(IFNULL(Par_TrsReferenciaNumerica,Entero_Cero));

	SET Var_AutorizaTerceroTranTD 	    := IFNULL( FNPARAMTARJETAS(Llave_AutorizaTerceroTranTD), Con_NO);
	SET Var_EjecucionCierreDia 	      	:= IFNULL( FNPARAMGENERALES(Llave_EjecucionCierreDia), Con_NO);
	SET Var_NotificacionTarCierreDia	:= IFNULL( FNPARAMTARJETAS(Llave_NotificacionTarCierreDia), Con_NO);
	SET Var_UsuarioTransaccionID		:= CAST(IFNULL( FNPARAMTARJETAS(LLave_UsuarioTransaccion), Entero_Cero) AS UNSIGNED);

	-- Valia que el valor no llegue vacio
	IF(IFNULL(Par_TipoOperacion,Entero_Cero)=Entero_Cero) THEN
		SET Par_NumErr	:= 1200;
		SET Par_ErrMen	:= 'Tipo de operacion vacio';
		LEAVE ManejoErrores;
	END IF;

	-- Valida que el valor TipoOperacion no supere el valor 100
	IF(Par_TipoOperacion>=Entero_Cien) THEN
		SET Par_NumErr	:= 1201;
		SET Par_ErrMen	:= 'Tipo de operacion incorrecto';
		LEAVE ManejoErrores;
	END IF;

	-- Valida el tipoOperacion en el catalogo
	SET Var_TipoOperacion :=(SELECT CodigoOperacion FROM CATTIPOPERACIONISOTRX WHERE CodigoOperacion=Par_TipoOperacion);
	IF(IFNULL(Var_TipoOperacion,Entero_error)=Entero_error) THEN
		SET Par_NumErr	:= 1202;
		SET Par_ErrMen	:= 'El Tipo de operacion no existe';
		LEAVE ManejoErrores;
	END IF;

	-- Valida el resultado sobre los tipos validos
	IF(FIND_IN_SET(IFNULL(Par_ResultadoOperacion, Cadena_Vacia),CatResultOper) = Entero_Cero)THEN
		SET Par_NumErr    := 1203;
		SET Par_ErrMen    := 'Resultado operacion invalido';
		LEAVE ManejoErrores;
	END IF;

	-- Valida que el  tipo de validacion se encuentre entre los estatus validos
	IF(FIND_IN_SET(IFNULL(Par_EstatusOperacion, Cadena_Vacia),CatEstatusOper) = Entero_Cero)THEN
		SET Par_NumErr    := 1204;
		SET Par_ErrMen    := 'Estatus operacion invalido';
		LEAVE ManejoErrores;
	END IF;

	-- Valida y convierte el valir a tipo entero en caso de que no este vacio
	IF(IFNULL(Par_CodigoRespuesta,Cadena_Vacia)=Cadena_Vacia)THEN
	   SET Var_CodigoRespuesta:=Entero_error;
	ELSE
	   SET Var_CodigoRespuesta:=(SELECT CAST(Par_CodigoRespuesta AS UNSIGNED));
	END IF;

	-- Busca el valor en la tabla de catalogo correspondiente y valida
	SET Var_CodigoRespuesta :=(SELECT CodRespuestaID FROM ISOTRXCODRESPUESTA WHERE CodRespuestaID=Var_CodigoRespuesta);
	IF(IFNULL(Var_CodigoRespuesta,Entero_error)=Entero_error) THEN
		SET Par_NumErr	:= 1205;
		SET Par_ErrMen	:= 'Codigo de respuesta incorrecta';
		LEAVE ManejoErrores;
	END IF;

	-- Verifica que el codigo de autorizacion no llegue vacio
	IF(IFNULL(Par_CodigoAutorizacion,Cadena_Vacia)=Cadena_Vacia) THEN
		SET Par_NumErr	:= 1206;
		SET Par_ErrMen	:= 'Codigo de autorizacion vacia';
		LEAVE ManejoErrores;
	END IF;

    -- BUsca el codigo de rechazo en el catalogo correspondiente y valida que se se encuentre
	IF(Par_CodigoRechazo>Entero_Cero) THEN
		SET Var_CodigoRechazo :=(SELECT CodRechazoID FROM ISOTRXCODRECHAZO WHERE CodRechazoID=Par_CodigoRechazo);
		IF(IFNULL(Var_CodigoRechazo,Entero_error)=Entero_error) THEN
			SET Par_NumErr	:= 1207;
			SET Par_ErrMen	:= 'Codigo de rechazo incorrecta';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	-- Busca y valida el giro comercial en la tabla catalogo correspondiente
	SET Par_GiroComercial:=(IFNULL(Par_GiroComercial,Entero_error));
	SET Var_GiroComercial :=(SELECT CodGiroComerID FROM ISOTRXCODGIROCOMER WHERE CodGiroComerID=Par_GiroComercial);
		IF(IFNULL(Var_GiroComercial,Entero_error)=Entero_error) THEN
		SET Par_NumErr	:= 1208;
		SET Par_ErrMen	:= 'Giro comercial incorrecto';
		LEAVE ManejoErrores;
	END IF;

	-- Valida el Modo de entrada en el catalogo correspondiente
	SET Par_ModoEntrada:=(IFNULL(Par_ModoEntrada,Entero_error));
	SET Var_ModoEntrada :=(SELECT ModoEntradaID FROM ISOTRXMODOENTRADA WHERE ModoEntradaID=Par_ModoEntrada);
		IF(IFNULL(Var_ModoEntrada,Entero_error)=Entero_error) THEN
		SET Par_NumErr	:= 1209;
		SET Par_ErrMen	:= 'Modo entrada incorecto';
		LEAVE ManejoErrores;
	END IF;

	-- Valida el punto de acceso ingresado en el catalogo correspondiente
	SET Par_PuntoAcceso:=(IFNULL(Par_PuntoAcceso,Entero_error));
	SET Var_PuntoAcces :=(SELECT PuntoAccesoID FROM ISOTRXPUNTOACCES WHERE PuntoAccesoID=Par_PuntoAcceso);
		IF(IFNULL(Var_PuntoAcces,Entero_error)=Entero_error) THEN
		SET Par_NumErr	:= 1210;
		SET Par_ErrMen	:= 'Punto de acceso incorrecto';
		LEAVE ManejoErrores;
	END IF;

	-- Valida que el numero de tarjeta no llegue vacia
	IF(IFNULL(Par_NumeroTarjeta,Cadena_Vacia)=Cadena_Vacia) THEN
		SET Par_NumErr	:= 1211;
		SET Par_ErrMen	:= 'Numero de tarjeta vacio';
		LEAVE ManejoErrores;
	END IF;

	-- Busca y valida el codigo moneda dentro de los permitidos
	IF(FIND_IN_SET(IFNULL(Par_CodigoMoneda, Cadena_Vacia),CatCodigoMoneda) = Entero_Cero)THEN
		SET Par_NumErr    := 1212;
		SET Par_ErrMen    := 'Resultado operacion invalido';
		LEAVE ManejoErrores;
	END IF;

	-- Valida el monto de la transaccion no llegue vacia
	IF(IFNULL(Par_MontoTransaccion,Decimal_Cero)=Decimal_Cero AND Par_TipoOperacion
																NOT IN(Tran_Consulta, Tran_CambioNIP,Tran_PosAutorizacion,
																	Tran_ReversoVenta,Tran_ReversoDisposicion,Tran_Devolucion,
																	Tran_Cancelacion,Tran_ReversoConsulta,Tran_Ajuste,Tran_ReversoParcial)) THEN
   		SET Par_NumErr    := 1213;
		SET Par_ErrMen    := 'Monto de transaccion incorrecto';
		LEAVE ManejoErrores;
	END IF;

	-- Valida la fecha de transaccion no llegue vacia
	IF(IFNULL(Par_FechaTransaccion,Fecha_Vacia)=Fecha_Vacia) THEN
   		SET Par_NumErr    := 1214;
		SET Par_ErrMen    := 'Fecha Transaccion Vacia';
		LEAVE ManejoErrores;
	END IF;
	-- Valida el formato de la fecha
	IF(LENGTH(Par_FechaTransaccion)<>Cons_cuatro) THEN
   		SET Par_NumErr    := 1215;
		SET Par_ErrMen    := 'Fecha Transaccion incorrecto';
		LEAVE ManejoErrores;
	END IF;

	-- Valida la hora de la transaccion
	IF(IFNULL(Par_HoraTransaccion,Cadena_Vacia)=Cadena_Vacia) THEN
	  	SET Par_NumErr    := 1216;
		SET Par_ErrMen    := 'Hora Transaccion Vacia';
		LEAVE ManejoErrores;
	END IF;
		-- Valida formato de la hora de la transaccion
	IF(LENGTH(Par_HoraTransaccion)<>Cons_Seis) THEN
	  	SET Par_NumErr    := 1217;
		SET Par_ErrMen    := 'Hora Transaccion incorrecto';
		LEAVE ManejoErrores;
	END IF;

	-- Realiza una validacion en el cual las condiciones se cumplan que el estatus sea por revresa y el tipo de operacion sea de Post-Autoriza
	IF(Par_EstatusOperacion=EstatusOPerReversa OR Par_TipoOperacion=ConsPostAutoriza)THEN
		IF(IFNULL(Par_OriCodigoAutorizacion,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr    := 1218;
			SET Par_ErrMen    := 'Codigo de autorización de la transacción vacia';
			LEAVE ManejoErrores;
		 END IF;

		IF(IFNULL(Par_OriFechaTransaccion,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr    := 1219;
			SET Par_ErrMen    := 'Fecha de transacción vacia';
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_OriHoraTransaccion,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr    := 1220;
			SET Par_ErrMen    := 'Hora de transacción vacia';
			LEAVE ManejoErrores;
		END IF;

		IF(LENGTH(Par_OriFechaTransaccion)<>Cons_cuatro)THEN
			SET Par_NumErr    := 1221;
			SET Par_ErrMen    := 'Fecha de transacción incorrecto';
			LEAVE ManejoErrores;
		END IF;
		IF(LENGTH(Par_OriHoraTransaccion)<>Cons_Seis)THEN
			SET Par_NumErr    := 1222;
			SET Par_ErrMen    := 'Hora de transacción incorrecto';
			LEAVE ManejoErrores;
		END IF;

	END IF;

	-- Valida que el parametro de AutorizaTerceroTranTD se encuentre encendido
	IF( Var_AutorizaTerceroTranTD = Con_NO ) THEN
			SET Par_NumErr    := 0001;
			SET Par_ErrMen    := '900 - La Operación Fue Rechazada, No se Permite Transaccionar';
			LEAVE ManejoErrores;
	END IF;

	-- Valida que no se estè ejecutando cierre de dia
	IF( Var_EjecucionCierreDia = Con_SI ) THEN
			SET Par_NumErr    := 0002;
			SET Par_ErrMen    := '901 - El Servicio se Encuentra Fuera de Línea, Reintentar Nuevamente';
			LEAVE ManejoErrores;
	END IF;

	-- Validar que no se este ejecutando el proceso masivo de envio de saldos finales
	IF( Var_NotificacionTarCierreDia = Con_SI ) THEN
			SET Par_NumErr    := 0002;
			SET Par_ErrMen    := '902 - El Servicio se Encuentra Fuera de Línea, Reintentar Nuevamente';
			LEAVE ManejoErrores;
	END IF;

	-- SE LE ASIGNA BANDERA ACTIVA PARA TODAS LAS OPERACIONES
	SET Var_AltaPoliza := Con_SI;
	-- PARA LAS TRANSACCIONES DE PRE Y RE AUTORIZACION NO SE DAN DE ALTAS POLIZAS
	IF(Par_TipoOperacion IN(Tran_PreAutorizacion, Tran_ReAutorizacion))THEN
		SET Var_AltaPoliza := Con_NO;
	END IF;
	-- PARA LAS TRANSACCIONES DE CONSULTA Y NIP SOLO SE OCUPAN POLIZAS CUANDO EL MONTO DE LA COMISON ES MAYOR A CERO
	IF(Par_TipoOperacion IN(Tran_Consulta, Tran_CambioNIP) AND Par_MontoComision <= Decimal_Cero)THEN
		SET Var_AltaPoliza := Con_NO;
	END IF;

	-- Se obtiene la descripcipcion por tipo de operacion
	SELECT	Descripcion
	INTO	Var_Concepto
	FROM CATTIPOPERACIONISOTRX
	WHERE CodigoOperacion = Par_TipoOperacion;

	-- Validacion de datos nulos
	SET Var_Concepto := IFNULL(Var_Concepto, Cadena_Vacia);

	-- PARA LOS MOVIMIENTOS DE REVERSO SE LE ASIGNA OTRO CONCEPTO
	IF(Par_TipoOperacion IN(Tran_ReversoVenta, Tran_Ajuste, Tran_ReversoParcial))THEN
		SET Var_Concepto	:= CONCAT("REVERSO ",Var_Concepto," ",Par_NombreComercio);
	ELSE
		-- CONCADENACION DE LA DESCRIPCION DE LA OPERACION PARA LAS OPERACIONES CONTABLES
		SET Var_Concepto	:= CONCAT(Var_Concepto," ",Par_NombreComercio);
	END IF;

	-- EL MONTO ADICIONAL ES CUANDO SE REALIZA EFECTIVO POR ALGUNA COMPRA DE TIENDA COMERCIALES, SOLO SE APLICAN PARA CIERTOS MOVIMIENTOS
	IF(Par_MontoAdicional > Decimal_Cero)THEN
		-- EL MONTO ADICIONAL SOLO APLICA PARA LAS TRANSACCIONES QUE SON DE VENTA
		IF(Par_TipoOperacion NOT IN(Tran_VentaNormal,Tran_VentaCAT,Tran_VentaInternet,Tran_VentaManual,Tran_CargoRecurrente,
									Tran_VentaQPS,Tran_VentaMoTo,Tran_VentaConPromocion,Tran_CargoEmisor,Tran_ReversoPago,
									Tran_VentaVoz,Tran_TransferenciaSPEI,Tran_Transferencia,Tran_TransferenciaEMISOR))THEN
			SET Par_NumErr	:= 1223;
			SET Par_ErrMen	:= 'El Monto Adicional solo aplica para transacciones de Ventas.';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	-- SE VALIDA QUE SE ENCUENTRA CONFIGURADO EL USUARIO
	IF(Var_UsuarioTransaccionID = Entero_Cero)THEN
		SET Par_NumErr	:= 1224;
		SET Par_ErrMen	:= 'El Usuario para las transacciones de reporte Isotrx no se encuentra configurado.';
		LEAVE ManejoErrores;
	END IF;

	SET Par_NumErr := 000;
	SET Par_ErrMen := 'Proceso de Transaccion Exitosa.';
	SET Par_Consecutivo := Par_EmisorID;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Cadena_Vacia AS Control,
			Par_Consecutivo AS Consecutivo,
			Var_AltaPoliza AS AltaPoliza,
			Var_Concepto AS Concepto;
END IF;


END TerminaStore$$