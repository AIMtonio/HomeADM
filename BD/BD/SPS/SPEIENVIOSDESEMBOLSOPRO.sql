DELIMITER ;

DROP PROCEDURE IF EXISTS SPEIENVIOSDESEMBOLSOPRO;

DELIMITER $$

CREATE PROCEDURE `SPEIENVIOSDESEMBOLSOPRO`(
	-- SP que realiza el alta a la tabla SPEIENVIOSDESEMBOLSO que ayuda a realizar movimientos de pagos por SPEI
	Par_FolioSPEI							BIGINT(20),				-- Folio de envio por SPEI
	Par_Descripcion							VARCHAR(150),			-- Indica la descripcion del bloqueo
	Par_Fecha								DATETIME,

	Par_Salida								CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr						INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen						VARCHAR(400),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Aud_EmpresaID 							INT(11),				-- Parametros de auditoria
	Aud_Usuario								INT(11),				-- Parametros de auditoria
	Aud_FechaActual							DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP							VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID							VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal							INT(11), 				-- Parametros de auditoria
	Aud_NumTransaccion						BIGINT(20)				-- Parametros de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control						VARCHAR(200);
	DECLARE Var_Consecutivo					INT(11);				-- ID desembolso de un envio SPEI
	DECLARE Var_CreditoID					BIGINT(20);				-- ID del credito a desbloquear
	DECLARE Var_BloqueoID					INT(11);				-- ID del bloqueo de saldo
	DECLARE Var_MontoBloq					DECIMAL(12,2);			-- Monto bloqueado
	DECLARE Var_TipoBloqOrig				INT(11);				-- Tipo de bloqueo original
	DECLARE Var_CuentaAhoID					BIGINT(12);				-- Cuenta de Ahorro
	DECLARE Var_DescMov						VARCHAR(150);			-- Descripcion de Movimiento
	DECLARE Var_Poliza						BIGINT;					-- ID de poliza
	DECLARE Var_ClienteID					INT(11);				-- ID del cliente
	DECLARE Var_FechaSis					DATE;					-- Fecha del sistema
	DECLARE Var_MonedaID					INT(11);				-- Clave de la moneda referente a la tabla de MONEDAS
	DECLARE Var_MontoTransferir				DECIMAL(14,2);			-- Monto a transferir
	DECLARE Var_ComisionTrans				DECIMAL(14,2);			-- Comision de la transferencia
	DECLARE Var_IVAComision					DECIMAL(14,2);			-- Iva de la comision
	DECLARE Var_ReferenciaNum				INT(7);					-- Referencia numerica
	DECLARE Var_Clave						VARCHAR(25);			-- Clave del usuario que desbloqueara el saldo
	DECLARE Var_Contrasenia					VARCHAR(500);			-- Contrasenia del usuario que desbloqueara el saldo

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia					CHAR(1);				-- Cadena vacia
	DECLARE	Fecha_Vacia						DATE;					-- Fecha vacias
	DECLARE	Entero_Cero						INT(1);					-- Entero cero
	DECLARE	Decimal_Cero					DECIMAL(14,2);			-- Decimal cero
	DECLARE Salida_SI						CHAR(1);				-- Salida SI
	DECLARE bloqueoDisp						INT(4);					-- Bloqueo por dispersion
	DECLARE Nat_Desbloqueo					CHAR(1);				-- Naturaleza del bloqueo
	DECLARE Est_Activa						CHAR(1);				-- Estatus activa
	DECLARE Var_FechaHora					DATE;					-- Fecha y hora
	DECLARE Var_Fecha						CHAR(20);				-- Fecha
	DECLARE AltaPoliza_SI					CHAR(1);				-- Indica si se dara de alta la poliza
	DECLARE CtoCon_Spei						INT(11);				-- Concepto de SPEI
	DECLARE Nat_Abono						CHAR(1);				-- Naturaleza abono
	DECLARE Nat_Cargo						CHAR(1);				-- Naturaleza cargo
	DECLARE AltaMovAhorro_SI				CHAR(1);				-- Indica si se dara de alta los movimientos en la cuenta de ahorro
	DECLARE CtoAho_Spei						INT(11);				-- Concepto de ahorro SPEI
	DECLARE Salida_NO						CHAR(1);				-- Salida NO
	DECLARE NumErrNoDesembolso				INT(11);				-- Numero de error de desembolso

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= ''; 									-- Cadena vacia
	SET Fecha_Vacia			:= '1900-01-01';						-- Fecha Vacia
	SET Entero_Cero			:= 0; 									-- Entero Cero
	SET Decimal_Cero		:= 0.0;									-- Decimal Cero
	SET Salida_SI			:= 'S';									-- Salida: SI
	SET bloqueoDisp			:= 1;									-- bloqueo por dispersion
	SET Nat_Desbloqueo		:= 'D';									-- Naturaleza desbloqueo
	SET Est_Activa			:= 'A';									-- Estatus activa
	SET Var_Poliza			:= 0;									-- ID de Poliza
	SET AltaPoliza_SI		:= 'S';									-- Alta poliza SI
	SET CtoCon_Spei			:= 808;									-- Concepto Contable de ENVIO SPEI
	SET Nat_Abono			:= 'A';									-- Naturaleza Abono
	SET Nat_Cargo			:= 'C';									-- Naturaleza Cargo
	SET AltaMovAhorro_SI	:= 'S';									-- Si Alta Movimientos Ahorro
	SET CtoAho_Spei			:= 1;									-- Pasivo
	SET Salida_NO			:= 'N';									-- Salida NO

	ManejoErrores:BEGIN
		 DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-SPEIENVIOSDESEMBOLSOPRO');
				SET Var_Control = 'SQLEXCEPTION' ;
			END;

		IF(IFNULL(Par_FolioSPEI,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen 	:= 'El Folio de SPEI se encuentra vacio.';
			SET Var_Control := 'FolioSPEI' ;
			LEAVE ManejoErrores;
		END IF;

		-- Se obtiene el ID de la Solicitud de Credito y el ID de Bloqueo para saber si se hara el proceso de desbloqueo de saldo
		SELECT	SED.CreditoID, SED.BloqueoID
		INTO	Var_CreditoID, Var_BloqueoID
			FROM SPEIENVIOSDESEMBOLSO AS SED
				WHERE SED.FolioSpei = Par_FolioSPEI;

		SET Var_CreditoID	:= IFNULL(Var_CreditoID, Entero_Cero);

		IF(Var_CreditoID != Entero_Cero) THEN
			SELECT	MontoBloq, IFNULL(TiposBloqID,Entero_Cero),	CuentaAhoID
				INTO Var_MontoBloq, Var_TipoBloqOrig,	Var_CuentaAhoID
					FROM BLOQUEOS
						WHERE BloqueoID = Var_BloqueoID;

			SELECT		USU.Clave,		USU.Contrasenia
				INTO	Var_Clave,		Var_Contrasenia
				FROM USUARIOS USU
				INNER JOIN PARAMETROSSPEI PS ON USU.Clave = PS.ClaveUsuarioAut;

			CALL BLOQUEOSPRO(
				Var_BloqueoID,			Nat_Desbloqueo,			Var_CuentaAhoID,			Par_Fecha,			Var_MontoBloq,
				Fecha_Vacia,			Var_TipoBloqOrig,		Par_Descripcion,			Entero_Cero,		Var_Clave,
				Var_Contrasenia,		Salida_NO,				Par_NumErr,					Par_ErrMen,			Aud_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion
			);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			-- Proceso para realizar el cargo a la cuenta del cliente
			SET Var_DescMov := 'ENVIO SPEI DESEMBOLSO';
			SET Var_Poliza := Entero_Cero;

			SELECT	ClienteID	INTO	Var_ClienteID
				FROM CUENTASAHO
				WHERE	CuentaAhoID	= Var_CuentaAhoID;

			-- se setea la fecha de operaciona  fecha del sistema
			SELECT	FechaSistema 	INTO	Var_FechaSis
				FROM	PARAMETROSSIS;

			SELECT	MonedaID,	FNDECRYPTSAFI(MontoTransferir),	ComisionTrans,	IVAComision,	ReferenciaNum
				INTO	Var_MonedaID,	Var_MontoTransferir,	Var_ComisionTrans,	Var_IVAComision,	Var_ReferenciaNum
				FROM SPEIENVIOS
				WHERE FolioSpeiID = Par_FolioSPEI;

			-- Contabilidad para SPEI
			CALL CONTASPEISPRO(
				Par_FolioSPEI,			Aud_Sucursal,		Var_MonedaID,		Var_FechaSis,		Var_FechaSis,
				Var_MontoTransferir,	Var_ComisionTrans,	Var_IVAComision,	Var_DescMov,		Var_ReferenciaNum,
				Var_CuentaAhoID,		AltaPoliza_SI,		Var_Poliza,			CtoCon_Spei, 		Nat_Abono,
				AltaMovAhorro_SI,		Var_CuentaAhoID,	Var_ClienteID, 		Nat_Cargo,			CtoAho_Spei,
				Entero_Cero,			Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			CALL SPEIENVIOSDESEMBOLSOBAJ(
				Par_FolioSPEI,			Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion
			);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Var_Consecutivo	:=Var_BloqueoID;
			SET Par_NumErr 	:= Entero_Cero;
			SET Par_ErrMen 	:= CONCAT(" El desbloqueo SPEI fue realizado exitosamente: ", CONVERT(Var_Consecutivo, CHAR));
			SET Var_Control	:= 'BloqueoID' ;
		ELSE
			SET Var_Consecutivo	:=Entero_Cero;
			SET Par_NumErr 	:= NumErrNoDesembolso;
			SET Par_ErrMen 	:= CONCAT(" El SPEI no fue realizado por Desembolso de Credito: ", CONVERT(Par_FolioSPEI, CHAR));
			SET Var_Control	:= 'FolioSPEI' ;
		END IF;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$