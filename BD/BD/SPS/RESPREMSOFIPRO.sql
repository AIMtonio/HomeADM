-- RESPREMSOFIPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS `RESPREMSOFIPRO`;

DELIMITER $$

CREATE PROCEDURE `RESPREMSOFIPRO` (
	-- SP Para parseo de información de respuestas en servicio para las remesas
	Par_SpeiSolDesID		BIGINT(20),			-- Identificador de una solicitud de descarga de remesas
	Par_AuthoNumber			VARCHAR(30),		-- AUTHO_NUMBER

	Par_CadenaB64			LONGTEXT,			-- Cadena de respuesta de servicio de Incorporate
	Par_TipoProceso         TINYINT UNSIGNED,   -- Tipo de proceso realizado. 1 - Notificacion, 2 - Info, 3 - ReportarPago, 4 - Devolución

	Par_Salida              CHAR(1),            -- Indica si el SP genera una salida
	INOUT Par_NumErr        INT,                -- No. error
	INOUT Par_ErrMen        VARCHAR(400),       -- Msg Error

		/* Parametros de Auditoria */
	Par_EmpresaID           INT(11),
	Aud_Usuario             INT(11),
	Aud_FechaActual         DATETIME,
	Aud_DireccionIP         VARCHAR(15),
	Aud_ProgramaID          VARCHAR(50),
	Aud_Sucursal            INT(11),
	Aud_NumTransaccion      BIGINT(20)
	)
	TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Con_Interaccion		INT(11);
	DECLARE Var_Control			VARCHAR(50);    -- Control en Pantalla
	DECLARE Var_Consecutivo		INT(11);        -- Consecutivo en Pantalla
	DECLARE Var_Opcode1			CHAR(3);
	DECLARE Var_Opcode2			CHAR(3);
	DECLARE Var_FechaSistema	DATE;
	DECLARE Var_FechaHora		DATETIME;

	-- variables para Notificaciones
	DECLARE Var_AUTHO_NUMBER	VARCHAR(20);
	DECLARE Var_STATUS			VARCHAR(5);
	DECLARE Var_DATE_TIME		VARCHAR(20);

	-- Variables para Info
	DECLARE Var_BankAutho		VARCHAR(100);
	DECLARE Var_PaymentMethod	VARCHAR(30);
	DECLARE Var_FName			VARCHAR(100);
	DECLARE Var_MName			VARCHAR(100);
	DECLARE Var_SName			VARCHAR(100);
	DECLARE Var_LName			VARCHAR(100);
	DECLARE Var_IdService		VARCHAR(100);
	DECLARE Var_Relieve			VARCHAR(100);
	DECLARE Var_Service			VARCHAR(100);
	DECLARE Var_Deposit			VARCHAR(100);
	DECLARE Var_IdPos			VARCHAR(100);
	DECLARE Var_IdDestiny		VARCHAR(100);
	DECLARE Var_AccountNum		VARCHAR(100);
	DECLARE Var_FNameB			VARCHAR(100);
	DECLARE Var_MNameB			VARCHAR(100);
	DECLARE Var_SNameB			VARCHAR(100);
	DECLARE Var_LNameB			VARCHAR(100);
	DECLARE Var_IdStatus		VARCHAR(20);
	DECLARE Var_IdTeller		VARCHAR(100);
	DECLARE Var_NombreCli		VARCHAR(400);
	DECLARE Var_NombreBen		VARCHAR(400);

	DECLARE Var_SpeiDetID		BIGINT(20);
	DECLARE Var_Concepto		VARCHAR(15);
	DECLARE Var_InstOrdSpei		INT(5);
	DECLARE Var_ClabeSpei		VARCHAR(18);
	DECLARE Error_Key			INT(11);
	DECLARE Var_Exito			INT(11);

	-- Declaracion de Constantes
	DECLARE Entero_Cero         INT(11);
	DECLARE Entero_Uno          INT(11);
	DECLARE Cadena_Cero         CHAR(1);
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Con_ProNotificacion INT(11);
	DECLARE Con_ProRepPago      INT(11);
	DECLARE Con_ProDevolucion   INT(11);
	DECLARE Con_CadenaXML       LONGTEXT;
	DECLARE Con_TotalRegis      INT(11);
	DECLARE SalidaSI            CHAR(1);    -- Constante Cadena Si
	DECLARE Var_NO				CHAR(1);

	DECLARE Var_IdBancos		INT(11);
	DECLARE Var_IdAgentes		INT(11);
	DECLARE Var_ConcBanco		VARCHAR(15);
	DECLARE Var_ConcAgente		VARCHAR(15);
	DECLARE Var_TipoPagoRem		INT(11);
	DECLARE VAR_SALTO_LINEA		VARCHAR(2);

	DECLARE Con_Error002        CHAR(3);
	DECLARE Con_Error003        CHAR(3);
	DECLARE Con_Error004        CHAR(3);
	DECLARE Con_Error005        CHAR(3);

	DECLARE Var_TipoCtaOrd		INT(2);
	DECLARE Var_InstBenef		INT(5);

	-- Asignacion de Constantes
	SET Entero_Cero             := 0;       -- Entero en Cero
	SET Entero_Uno              := 1;       -- Entero Uno
	SET Cadena_Vacia            := '';      -- Cadena Vacia
	SET Cadena_Cero             := "0";     -- Cadena Cero
	SET Con_ProNotificacion     := 1;       -- Proceso de parseo para notificaciones
	SET Con_ProRepPago          := 3;       -- Proceso de parseo para reporte de pago
	SET Con_ProDevolucion       := 4;       -- Proceso de parseo para devolucion
	SET SalidaSI                := 'S';     -- Constante Cadena Si
	SET Var_NO					:= 'N';
	/*
	SET Var_IdBancos			:= 26;
	SET Var_IdAgentes			:= 1;
	SET Var_ConcBanco			:= 'ENVIO DE DINERO';
	SET Var_ConcAgente			:= 'PAGO A AGENTES';
	*/
	SET Var_IdBancos			:= 1;
	SET Var_IdAgentes			:= 1;
	SET Var_ConcBanco			:= 'ENVIO DE DINERO';
	SET Var_ConcAgente			:= 'PAGO A AGENTES';
	SET Var_TipoPagoRem			:= 15;
	SET VAR_SALTO_LINEA			:= '\n';				-- Saldo de linea

	SET Con_Error002            := "002";   -- código de error 002
	SET Con_Error003            := "003";   -- código de error 003
	SET Con_Error004            := "004";   -- código de error 004
	SET Con_Error005            := "005";   -- código de error 005

	SET Var_TipoCtaOrd			:= 40;		-- Tipo clabe
	SET Var_InstBenef			:= 846;		-- Catalogo INSTITUCIONESSPEI ID GEM-STP (Ambiente Pruebas)
	SET Var_Exito				:= 1;
	SET Error_Key				:= 0;

	SET Aud_FechaActual			:= NOW();

	ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocasiona. Ref: SP-RESPREMSOFIPRO.');
		END;

	SELECT FROM_BASE64(Par_CadenaB64)
			INTO Con_CadenaXML;

	-- Sección de notificaciones
	IF (Par_TipoProceso = Con_ProNotificacion)THEN

		SELECT		ExtractValue(Con_CadenaXML, '//LOTE_SALIDA/TRANSACCION_O/NOTIFICACION_OUTPUT/OPCODE1') AS Opcode1,
					ExtractValue(Con_CadenaXML, '//LOTE_SALIDA/TRANSACCION_O/NOTIFICACION_OUTPUT/OPCODE2') AS Opcode2
			INTO	Var_Opcode1,
					Var_Opcode2;

		IF(Var_Opcode1 = Con_Error002)THEN
			SET Par_NumErr := 01;
			SET Par_ErrMen := "El Corresponsal No Existe";
			SET Var_Control := 'mensaje';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Opcode1 = Con_Error003)THEN
			SET Par_NumErr := 02;
			SET Par_ErrMen := "Corresponsal Deshabilitado";
			SET Var_Control := 'mensaje';
			LEAVE ManejoErrores;
		END IF;

		SELECT		ExtractValue(Con_CadenaXML, 'count(//LOTE_SALIDA/TRANSACCION_O/NOTIFICACION_OUTPUT/AUTHO_NUMBER)')
			INTO	Con_TotalRegis;

		SET Con_Interaccion := Entero_Uno;

		WHILE Con_Interaccion <= Con_TotalRegis DO

			SELECT		ExtractValue(Con_CadenaXML, '//LOTE_SALIDA/TRANSACCION_O[$Con_Interaccion]/NOTIFICACION_OUTPUT/AUTHO_NUMBER') AS AUTHO_NUMBER,
						ExtractValue(Con_CadenaXML, '//LOTE_SALIDA/TRANSACCION_O[$Con_Interaccion]/NOTIFICACION_OUTPUT/STATUS') AS STATUS,
						ExtractValue(Con_CadenaXML, '//LOTE_SALIDA/TRANSACCION_O[$Con_Interaccion]/NOTIFICACION_OUTPUT/DATE_TIME') AS DATE_TIME
				INTO	Var_AUTHO_NUMBER,
						Var_STATUS,
						Var_DATE_TIME;

			SET Con_Interaccion := Con_Interaccion + 1;

		END WHILE;

		SET Par_NumErr := 00;
		SET Par_ErrMen := 'La información Se Proceso Correctamente.';
		SET Var_Control := 'remesas';

	END IF;

	-- Sección reportar pago
	IF (Par_TipoProceso = Con_ProRepPago)THEN

		SELECT		ExtractValue(Con_CadenaXML, '//LOTE_SALIDA/TRANSACCION_O/REPORTAR_PAGO_OUTPUT/OPCODE1') AS Opcode1,
					ExtractValue(Con_CadenaXML, '//LOTE_SALIDA/TRANSACCION_O/REPORTAR_PAGO_OUTPUT/OPCODE2') AS Opcode2
			INTO	Var_Opcode1,
					Var_Opcode2;

		IF(Var_Opcode2 = Con_Error002)THEN
			SET Par_NumErr := 04;
			SET Par_ErrMen := "La Orden No Se Encuentra O Se Encuentra En Un Status Que No Puede Ser Reportada Como Pagada.";
			SET Var_Control := 'mensaje';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Opcode2 = Con_Error003)THEN
			SET Par_NumErr := 05;
			SET Par_ErrMen := "Corresponsal Deshabilitado.";
			SET Var_Control := 'mensaje';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Opcode2 = Con_Error004)THEN
			SET Par_NumErr := 06;
			SET Par_ErrMen := "La Orden No Puede Ser Cambiada A Status De Pagada Ya Que No Se Envió Ninguna Identificación Para Validar Su Pago.";
			SET Var_Control := 'mensaje';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Opcode2 = Con_Error005)THEN
			SET Par_NumErr := 07;
			SET Par_ErrMen := "El Corresponsal No Existe O Se Envio Un Cajero Invalido.";
			SET Var_Control := 'mensaje';
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr := 00;
		SET Par_ErrMen := 'La información Se Proceso Correctamente.';
		SET Var_Control := 'remesas';

	END IF;

	-- Sección devolución
	IF (Par_TipoProceso = Con_ProDevolucion)THEN

		SELECT		ExtractValue(Con_CadenaXML, '//LOTE_SALIDA/TRANSACCION_O/DEVOLUCION_OUTPUT/OPCODE1') AS Opcode1,
					ExtractValue(Con_CadenaXML, '//LOTE_SALIDA/TRANSACCION_O/DEVOLUCION_OUTPUT/OPCODE2') AS Opcode2
			INTO	Var_Opcode1,
					Var_Opcode2;

		IF(Var_Opcode2 = Con_Error002)THEN
			SET Par_NumErr := 08;
			SET Par_ErrMen := "La Orden No Se Encuentra.";
			SET Var_Control := 'mensaje';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Opcode2 = Con_Error003)THEN
			SET Par_NumErr := 09;
			SET Par_ErrMen := "Corresponsal Deshabilitado.";
			SET Var_Control := 'mensaje';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Opcode2 = Con_Error004)THEN
			SET Par_NumErr := 10;
			SET Par_ErrMen := "Solicitud Denegada Por El Status En El Que Se Encuentra La Orden.";
			SET Var_Control := 'mensaje';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Opcode2 = Con_Error005)THEN
			SET Par_NumErr := 11;
			SET Par_ErrMen := "El Corresponsal No Existe O Se Envio Un Cajero Invalido.";
			SET Var_Control := 'mensaje';
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr := 00;
		SET Par_ErrMen := 'La informacion Se Proceso Correctamente.';
		SET Var_Control := 'remesas';

	END IF;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'remesas' AS Control,
				Var_Exito AS Consecutivo;
	END IF;

END TerminaStore$$