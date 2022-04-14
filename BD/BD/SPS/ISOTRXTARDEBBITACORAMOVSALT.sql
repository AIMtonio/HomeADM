-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ISOTRXTARDEBBITACORAMOVSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS ISOTRXTARDEBBITACORAMOVSALT;
DELIMITER $$


CREATE PROCEDURE ISOTRXTARDEBBITACORAMOVSALT(
	/* SP QUE INSERTA EN LA TABLA DE BITACORA DE TARJETAS
		USADO EN WS DE OPERACIONES TARJETA*/
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

	Par_MontoRemplazo            DECIMAL(12,2), -- Monto de remplazo por devolución o disposicion parcial
	Par_MontoComision            DECIMAL(12,2), -- Monto de comisión por disposición
	Par_FechaTransaccion         VARCHAR(4),    -- Fecha en formato MMDD
	Par_HoraTransaccion          VARCHAR(6),    -- Hora en formato HHMMSS
	Par_SaldoDisponible          DECIMAL(12,4), -- Saldo disponible

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

	INOUT Par_TarDebMovID		INT(11),		-- Consecutivo del movimiento de tarjeta

	Par_Salida					CHAR(1),		-- Parametro de salida
	INOUT Par_NumErr 			INT(11), 		-- Numero de Error
	INOUT Par_ErrMen 			VARCHAR(400),	-- Mensaje de Error
	INOUT Par_ErrLog 			VARCHAR(400),   -- Mensaje de erorr que se imprime en los logs cuando ocurre un error de mysql

	Par_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE Var_TarDebMovID		INT(11);		-- Almacena el valor del numero consecutivo
	DECLARE Var_Control			VARCHAR(50);	-- Variable de contrl
	DECLARE Var_FechaHraOpe		DATETIME;
	DECLARE Var_FechaSistema	DATE;
	DECLARE Var_HoraSistema		TIME;
    DECLARE Var_SqlState		INT;
    DECLARE Var_SqlMsg			VARCHAR(400);
	DECLARE Var_FechaOpera		DATE;
	DECLARE Var_HoraOpera		TIME;
	DECLARE Var_OriFechaOpera	DATE;
	DECLARE Var_OriHoraOpera	TIME;

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT;
	DECLARE	DecimalCero			DECIMAL(12,2);
	DECLARE Salida_NO 			CHAR(1);
	DECLARE	Var_Si	 			CHAR(1);
	DECLARE Concilia_NO			CHAR(1);
	DECLARE Est_Registrado		CHAR(1);
	DECLARE Fecha_Vacia         DATE;
	DECLARE Hora_Vacia          TIME;
	DECLARE Tipo_Mensaje		INT;
	DECLARE Origen_CtaAho		INT;
	DECLARE Est_NoConciliado	CHAR(1);
	DECLARE Trans_EnLinea		CHAR(1);
	DECLARE Tipo_CheckIN		INT;

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';		-- Cadena vacia
	SET	Entero_Cero				:= 0;		-- Entero cero
	SET	DecimalCero				:= 0.00;	-- DECIMAL cero
	SET	Salida_NO				:= 'N';		-- Mensaje de salida: NO
	SET	Var_Si					:= 'S';	    -- Mensaje de salida: SI
	SET Concilia_NO				:= 'N';		-- Estatus NO Conciliado
	SET Est_Registrado			:= 'R';		-- Estatus Registrado
	SET Fecha_Vacia     		:= '1900-01-01';  -- Fecha Vacia
	SET Hora_Vacia      		:= '00:00:00'; -- Hora vacia
	SET Tipo_Mensaje 			:= 1200;
	SET Origen_CtaAho 			:= 10;
	SET Est_NoConciliado		:= 'N';
	SET Trans_EnLinea			:= 'S';
	SET Tipo_CheckIN			:= CASE WHEN Par_TipoOperacion IN(14,15) THEN 0 ELSE 1 END;
	SET Par_ErrLog				:= '';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS CONDITION 1
			Var_SqlState = RETURNED_SQLSTATE, Var_SqlMsg = MESSAGE_TEXT;

			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-ISOTRXTARDEBBITACORAMOVSALT');
			SET Par_ErrLog	:= CONCAT(IFNULL(Var_SqlState,0),'-',IFNULL(Var_SqlMsg,''));
			SET Var_Control := 'SQLEXCEPTION';
		END;

		SET	 Par_EmisorID                 :=(IFNULL(Par_EmisorID          ,Entero_Cero));
		SET	 Par_MensajeID                :=(IFNULL(Par_MensajeID         ,Cadena_Vacia));
		SET	 Par_ResultadoOperacion       :=(IFNULL(Par_ResultadoOperacion,Entero_Cero));
		SET	 Par_EstatusOperacion         :=(IFNULL(Par_EstatusOperacion  ,Entero_Cero));
		SET	 Par_CodigoRespuesta          :=(IFNULL(Par_CodigoRespuesta   ,Cadena_Vacia));
		SET	 Par_CodigoAutorizacion       :=(IFNULL(Par_CodigoAutorizacion,Cadena_Vacia));
		SET	 Par_CodigoRechazo            :=(IFNULL(Par_CodigoRechazo     ,Entero_Cero));
		SET	 Par_GiroComercial            :=(IFNULL(Par_GiroComercial     ,Entero_Cero));
		SET	 Par_NumeroAfiliacion         :=(IFNULL(Par_NumeroAfiliacion  ,Entero_Cero));
		SET	 Par_NombreComercio           :=(IFNULL(Par_NombreComercio    ,Cadena_Vacia));
		SET	 Par_ModoEntrada              :=(IFNULL(Par_ModoEntrada       ,Entero_Cero));
		SET	 Par_PuntoAcceso              :=(IFNULL(Par_PuntoAcceso       ,Entero_Cero));
		SET	 Par_NumeroCuenta             :=(IFNULL(Par_NumeroCuenta      ,Entero_Cero));
		SET	 Par_NumeroTarjeta            :=(IFNULL(Par_NumeroTarjeta     ,Cadena_Vacia));
		SET	 Par_CodigoMoneda             :=(IFNULL(Par_CodigoMoneda      ,Entero_Cero));
		SET	 Par_MontoTransaccion         :=(IFNULL(Par_MontoTransaccion  ,DecimalCero));
		SET	 Par_MontoAdicional           :=(IFNULL(Par_MontoAdicional    ,DecimalCero));
		SET	 Par_MontoRemplazo            :=(IFNULL(Par_MontoRemplazo     ,DecimalCero));
		SET	 Par_MontoComision            :=(IFNULL(Par_MontoComision     ,DecimalCero));
		SET	 Par_SaldoDisponible          :=(IFNULL(Par_SaldoDisponible   ,DecimalCero));
		SET	 Par_ProDiferimiento          :=(IFNULL(Par_ProDiferimiento   ,Entero_Cero));
		SET	 Par_ProNumeroPagos           :=(IFNULL(Par_ProNumeroPagos    ,Entero_Cero));
		SET	 Par_ProTipoPlan              :=(IFNULL(Par_ProTipoPlan       ,Entero_Cero));
		SET	 Par_OriCodigoAutorizacion    :=(IFNULL(Par_OriCodigoAutorizacion ,Cadena_Vacia));
		SET	 Par_DesNumeroCuenta          :=(IFNULL(Par_DesNumeroCuenta   ,Entero_Cero));
		SET	 Par_DesNumeroTarjeta         :=(IFNULL(Par_DesNumeroTarjeta  ,Cadena_Vacia));
		SET	 Par_TrsClaveRastreo          :=(IFNULL(Par_TrsClaveRastreo   ,Cadena_Vacia));
		SET	 Par_TrsInstitucionRemitente  :=(IFNULL(Par_TrsInstitucionRemitente,Entero_Cero));
		SET	 Par_TrsNombreEmisor          :=(IFNULL(Par_TrsNombreEmisor   ,Cadena_Vacia));
		SET	 Par_TrsTipoCuentaRemitente   :=(IFNULL(Par_TrsTipoCuentaRemitente,Entero_Cero));
		SET	 Par_TrsCuentaRemitente       :=(IFNULL(Par_TrsCuentaRemitente,Cadena_Vacia));
		SET	 Par_TrsConceptoPago          :=(IFNULL(Par_TrsConceptoPago   ,Cadena_Vacia));
		SET	 Par_TrsReferenciaNumerica    :=(IFNULL(Par_TrsReferenciaNumerica ,Entero_Cero));


		SET Aud_FechaActual	:= NOW();
		SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Var_HoraSistema	:= TIME(NOW());

		IF IFNULL(Par_HoraTransaccion,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_HoraTransaccion := DATE_FORMAT(Var_HoraSistema,"%H%i%s");
		END IF;

		IF IFNULL(Par_FechaTransaccion,Cadena_Vacia) = Cadena_Vacia THEN
			SET Var_FechaHraOpe := Fecha_Vacia;
		ELSE
			SET Var_FechaHraOpe := STR_TO_DATE( CONCAT(DATE_FORMAT(Aud_FechaActual,"%Y"),Par_FechaTransaccion," ",Par_HoraTransaccion), "%Y%m%d %H%i%s") ;
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

		-- SE VALIDA EL TIPO DE OPERACION ACTUAL
		IF(Par_TipoOperacion > 99)THEN
			SET Par_NumErr	:=  1225;
			SET Par_ErrMen	:= 'La transaccion no existe o no se encuentra el servicio disponible.';
			SET Var_Control	:= 'tipoOperacion';
			LEAVE ManejoErrores;
		END IF;


		CALL FOLIOSAPLICAACT('TARDEBBITACORAMOVS', Var_TarDebMovID);

		INSERT INTO `TARDEBBITACORAMOVS`
			(TarDebMovID,			TipoMensaje,			TipoOperacionID,		TarjetaDebID,				OrigenInst,
			MontoOpe,				FechaHrOpe,				NumeroTran,				GiroNegocio,				PuntoEntrada,
			TerminalID,				NombreUbicaTer,			NIP,					CodigoMonOpe,				MontosAdiciona,
			MontoSurcharge,			MontoLoyaltyfee,		Referencia,				DatosTiempoAire,			EstatusConcilia,
			FolioConcilia,			DetalleConciliaID,		TransEnLinea,			CheckIn,					CodigoAprobacion,
			Estatus,				EmisorID,				MensajeID,				ModoEntrada,
			ResultadoOperacion,		EstatusOperacion,		FechaOperacion,			HoraOperacion,				CodigoRespuesta,
			CodigoRechazo,			NumeroCuenta,			MontoRemplazo,			SaldoDisponible,			ProDiferimiento,
			ProNumeroPagos,			ProTipoPlan,			OriCodigoAutorizacion,	OriFechaTransaccion,		OriHoraTransaccion,
			DesNumeroCuenta,		DesNumeroTarjeta,		TrsClaveRastreo,		TrsInstitucionRemitente,	TrsNombreEmisor,
			TrsTipoCuentaRemitente,	TrsCuentaRemitente,		TrsConceptoPago,		EmpresaID,					Usuario,
			FechaActual,			DireccionIP,			ProgramaID,				Sucursal,					NumTransaccion	)
		VALUES(
			Var_TarDebMovID,			Tipo_Mensaje,			Par_TipoOperacion,			Par_NumeroTarjeta,			Origen_CtaAho,
			Par_MontoTransaccion,		Var_FechaHraOpe,		Entero_Cero,				Par_GiroComercial,			Par_PuntoAcceso,
			Par_NumeroAfiliacion,		Par_NombreComercio,		Cadena_Vacia,				Par_CodigoMoneda,			Par_MontoAdicional,
			Par_MontoComision,			Entero_Cero,			Par_TrsReferenciaNumerica,	Cadena_Vacia,				Est_NoConciliado,
			Entero_Cero,				Entero_Cero,			Trans_EnLinea,				Tipo_CheckIN,				Par_CodigoAutorizacion,
			Est_Registrado,				Par_EmisorID,			Par_MensajeID,				Par_ModoEntrada,
			Par_ResultadoOperacion,		Par_EstatusOperacion,	Var_FechaOpera,				Var_HoraOpera,				Par_CodigoRespuesta,
			Par_CodigoRechazo,			Par_NumeroCuenta,		Par_MontoRemplazo,			Par_SaldoDisponible,		Par_ProDiferimiento,
			Par_ProNumeroPagos,			Par_ProTipoPlan,		Par_OriCodigoAutorizacion,	Var_OriFechaOpera,			Var_OriHoraOpera,
			Par_DesNumeroCuenta,		Par_DesNumeroTarjeta,	Par_TrsClaveRastreo,		Par_TrsInstitucionRemitente,Par_TrsNombreEmisor,
			Par_TrsTipoCuentaRemitente,	Par_TrsCuentaRemitente,	Par_TrsConceptoPago,		Par_EmpresaID,            	Aud_Usuario,
			Aud_FechaActual,	    	Aud_DireccionIP,		Aud_ProgramaID,		        Aud_Sucursal,             	Aud_NumTransaccion	);

		SET Par_TarDebMovID	:= Var_TarDebMovID;

		SET	Par_NumErr := 0;
	    SET	Par_ErrMen := 'Registro exitoso.';

	END ManejoErrores;

	IF (Par_Salida = Var_Si) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_TarDebMovID AS Consecutivo;

	END IF;

END TerminaStore$$