-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ISOTRXREAUTORIZACIONPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ISOTRXREAUTORIZACIONPRO`;

DELIMITER $$
CREATE PROCEDURE `ISOTRXREAUTORIZACIONPRO`(
    -- Descripcion: Proceso operativo que realiza la afectacion cuando la transacion sea de tipo reautorizacion
	-- Modulo: Procesos de ISOTRX
	Par_EmisorID					INT(11),		-- Identificador provisto por ISOTRX
	Par_MensajeID					VARCHAR(50),	-- Identificador del Mensaje. Valor único global.
	Par_TipoOperacion				INT(11),		-- Catalogo CATTIPOPERACIONISOTRX
	Par_ResultadoOperacion			INT(11),		-- Siempre enviarán 1 Aprobada, 0 = Sin Respuesta,1 = Aprobada , 2 = Declinada , 3 = Rechazada
	Par_EstatusOperacion			INT(11),		-- Estatus de operaciòn 0 = Indefinida ,1 = Abierta,2 = Completada ,3 = Devuelta ,5 = Cancelada ,6 = Reversa

	Par_FechaOperacion				DATE,			-- Fecha en formato AAAAMMDD
	Par_HoraOperacion				TIME,			-- Hora en formato HHMMSS
	Par_CodigoRespuesta				VARCHAR(2),		-- Código de respuesta del autorizador, ver catalogo ISOTRXCODRESPUESTA
	Par_CodigoAutorizacion			VARCHAR(6),		-- Código es el que se utilizará para aplicar reversos.
	Par_CodigoRechazo				INT(11),		-- Catalogo ISOTRXCODRECHAZO

	Par_GiroComercial				INT(11),		-- Catalogo ISOTRXCODGIROCOMER
	Par_NumeroAfiliacion			INT(11),		-- Id identificador del comercio
	Par_NombreComercio				VARCHAR(50),	-- Nombre del comercio
	Par_ModoEntrada					INT(11),		-- Catalogo ISOTRXMODOENTRADA
	Par_PuntoAcceso					INT(11),		-- Catalogo ISOTRXPUNTOACCES

	Par_NumeroCuenta				BIGINT(20),		-- Número de Cuenta del Emisor
	Par_NumeroTarjeta				VARCHAR(16),	-- Número de Tarjeta del SAFI
	Par_CodigoMoneda				INT(11),		-- Código de Moneda  484 = MX Pesos,840 = USD Dollar,484 = MX Pesos, 840 = USD Dollar
	Par_MontoTransaccion			DECIMAL(12,2),	-- Monto total de la transacción
	Par_MontoAdicional				DECIMAL(12,2),	-- Monto de disposición en compra

	Par_MontoRemplazo				DECIMAL(12,2),	-- Monto de remplazo por devolución o disposicion parcial
	Par_MontoComision				DECIMAL(12,2),	-- Monto de comisión por disposición
	Par_FechaTransaccion			VARCHAR(4),		-- Fecha en formato MMDD
	Par_HoraTransaccion				VARCHAR(6),		-- Hora en formato HHMMSS
	Par_SaldoDisponible				DECIMAL(12,4),	-- Saldo disponible

	Par_ProDiferimiento				INT(11),		-- Número de meses a diferir el primer pago.
	Par_ProNumeroPagos				INT(11),		-- Número de parcialidades en las que se divide el monto.
	Par_ProTipoPlan					INT(11),		-- Tipo plan 0 = Sin Plan,3 = Sin Intereses ,5 = Con Intereses ,7 = Diferimiento
	Par_OriCodigoAutorizacion		VARCHAR(6),		-- Tomado de la transacción original
	Par_OriFechaTransaccion			DATE,			-- Fecha de la transacción original, formato MMDD

	Par_OriHoraTransaccion			TIME,			-- Hora de la transacción original,  formato HHMMSS
	Par_DesNumeroCuenta				BIGINT(20),		-- Número de cuenta destino de la trasferencia local
	Par_DesNumeroTarjeta			VARCHAR(16),	-- Número de tarjeta destino de la transferencia local
	Par_TrsClaveRastreo				VARCHAR(30),	-- Clave de rastreo de la transferencia
	Par_TrsInstitucionRemitente		INT(11),		-- Clave de la institución desde donde se envía la transferencia

	Par_TrsNombreEmisor				VARCHAR(50),	-- Nombre de quien envía la transferencia
	Par_TrsTipoCuentaRemitente		INT(11),		-- Tipo de Cuenta de quien envía la transferencia
	Par_TrsCuentaRemitente			VARCHAR(16),	-- Numero de cuenta de quien envía la transferencia
	Par_TrsConceptoPago				VARCHAR(50),	-- Concepto de la transferencia
	Par_TrsReferenciaNumerica		INT(11),		-- Referencia numérica asociada a la transferencia

	INOUT Par_Poliza				BIGINT(20),		-- Numero de poliza para registrar los detalles contables

	Par_Salida						CHAR(1),		-- Especifica salida o no del sp: Si:'S' y No:'N'
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
    DECLARE Var_ClienteID			INT(11);
    DECLARE Var_CuentaAhoID			BIGINT(12);
    DECLARE Var_Descripcion			VARCHAR(150);
    DECLARE Var_FechaSistema		DATE;			-- Almacena la fecha del sistema
    DECLARE Var_MonedaID			INT(1);			-- Indica el tipo de moneda

    DECLARE Var_AutorizadoID		INT(11);
    DECLARE Var_ClaveUsuario		VARCHAR(45);
    DECLARE Var_CodigoAutorizacion	INT(11);		-- Almacena el codigo de autorizacion


    /* Declaracion de Constantes */
    DECLARE SalidaSI				CHAR(1);		-- Indica sin salida
    DECLARE SalidaNO				CHAR(1);		--  Salida no
    DECLARE Cadena_Vacia			CHAR(1);		-- Cadena vacia
    DECLARE Entero_Cero				INT(11);		-- Entero cero
    DECLARE Cons_BloqueoID			INT(11);		-- Id del bloqueo
    DECLARE Cons_NatMovimiento		CHAR(1);
    DECLARE Cons_MovTarjeta			INT(11);
    DECLARE Fecha_Vacia				DATE;
    DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE Nat_Cargo				CHAR(1);		-- Naturaleza cargos
	DECLARE Nat_Abono				CHAR(1);		-- Naturaleza abobos
	DECLARE Est_Procesado			CHAR(1);		-- Estatus procesado


    SET SalidaSI					:= 'S';
    SET SalidaNO					:= 'N';
    SET	Cadena_Vacia				:= '';
    SET Entero_Cero					:= 0;
    SET Cons_BloqueoID				:= 0;
    SET Cons_NatMovimiento			:= 'B';
    SET Cons_MovTarjeta				:= 3;
    SET Fecha_Vacia					:= '1900-01-01';
    SET Decimal_Cero				:= 0.0;
	SET Nat_Cargo					:= 'C';
	SET Nat_Abono					:= 'A';
	SET Est_Procesado				:= 'P';


ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ISOTRXREAUTORIZACIONPRO');
		END;

    -- Fecha del sistema
    SELECT 	FechaSistema,		MonedaBaseID
    INTO	Var_FechaSistema,	Var_MonedaID
    FROM PARAMETROSSIS;

    -- Validacion de datos nulos
    SET Par_NumeroTarjeta			:= IFNULL(Par_NumeroTarjeta, Cadena_Vacia);
    SET Par_TipoOperacion			:= IFNULL(Par_TipoOperacion, Entero_Cero);
    SET Par_MontoRemplazo			:= IFNULL(Par_MontoRemplazo, Decimal_Cero);
    SET Par_OriCodigoAutorizacion	:= IFNULL(Par_OriCodigoAutorizacion, Cadena_Vacia);

	-- Se invoca el proceso que valida la tarjeta
    CALL ISOTRXTARJETADEBVAL(Par_TipoOperacion,		Par_NumeroTarjeta,		Var_ClienteID,		Var_CuentaAhoID,		Nat_Cargo,
							Par_MontoTransaccion,	Par_MontoAdicional,		Par_GiroComercial,
							SalidaNO,				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,
							Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion
							);
    -- Se evalua el error
	IF(Par_NumErr != Entero_Cero)THEN
	   LEAVE ManejoErrores;
	END IF;

    -- Se valida que el codigo de autorizacion no llegue vacio
    IF(IFNULL(Par_OriCodigoAutorizacion,Cadena_Vacia)=Cadena_Vacia)THEN
        SET Par_NumErr := 1112;
        SET Par_ErrMen := 'Codigo de autorizacion vacio.';
        LEAVE ManejoErrores;
    END IF;

    -- Se obtiene la descripcipcion por tipo de operacion
    SELECT	Descripcion
    INTO	Var_Descripcion
    FROM CATTIPOPERACIONISOTRX
    WHERE CodigoOperacion = Par_TipoOperacion;

    -- Validacion de datos nulos
    SET Var_Descripcion := IFNULL(Var_Descripcion, Cadena_Vacia);
    -- CONCADENACION DE LA DESCRIPCION DE LA OPERACION PARA LAS OPERACIONES CONTABLES
    SET Var_Descripcion := CONCAT(Var_Descripcion," ",Par_NombreComercio);

    -- Se obtiene la clave del usuario que realiza la operacion
    SET Var_ClaveUsuario := (SELECT Clave FROM USUARIOS WHERE UsuarioID = Aud_Usuario);
    SET Var_ClaveUsuario := (IFNULL(Var_ClaveUsuario, Cadena_Vacia));
    -- Se obtinene el codigo de autorizacion
    SET Var_AutorizadoID :=(SELECT CodigoAprobacion 
									FROM TARDEBBITACORAMOVS 
									WHERE CodigoAprobacion = Par_OriCodigoAutorizacion
									AND TarjetaDebID = Par_NumeroTarjeta
									AND Estatus = Est_Procesado);
    SET Var_CodigoAutorizacion :=(SELECT CAST(IFNULL(Par_CodigoAutorizacion,Entero_Cero)AS SIGNED));

    -- Se valda que el codigo de autorizacion se encuentre registrado para poder reaizar la reautorizacion
    IF((IFNULL(Var_AutorizadoID,Entero_Cero))=Entero_Cero) THEN
       SET Par_NumErr := 1113;
       SET Par_ErrMen := 'Codigo de autorizacion incorrecto para Re-Autorizacion.';
       LEAVE ManejoErrores;
    END IF;
    -- Se realiza la llamada al Sp de bloqueo para bloquear el saldo para la reautorizacion
    CALL BLOQUEOSPRO( Cons_BloqueoID,        Cons_NatMovimiento,         Var_CuentaAhoID,        Var_FechaSistema,        Par_MontoTransaccion,
                        Fecha_Vacia,           Cons_MovTarjeta,          Var_Descripcion,        Var_CodigoAutorizacion,  Var_ClaveUsuario,
                        Cadena_Vacia,          SalidaNO,                 Par_NumErr,             Par_ErrMen,              Par_EmpresaID,
                        Aud_Usuario,           Aud_FechaActual,          Aud_DireccionIP,        Aud_ProgramaID,          Aud_Sucursal,
                        Aud_NumTransaccion		);
    -- Se valida que no exista error
    IF (Par_NumErr <> Entero_Cero)THEN
		SET Par_NumErr := 1310;
	    SET Par_ErrMen := CONCAT('Error en el Bloqueo de Saldos. ',Par_ErrMen);
        LEAVE ManejoErrores;
    END IF;

	SET Par_NumErr := 000;
	SET Par_ErrMen := 'Proceso de Re-Autorzacion Exitosa.';

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen;
END IF;

END TerminaStore$$