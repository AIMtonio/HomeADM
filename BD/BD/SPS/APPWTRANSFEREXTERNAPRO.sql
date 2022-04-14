-- APPWTRANSFEREXTERNAPRO
DELIMITER ;

DROP PROCEDURE IF EXISTS APPWTRANSFEREXTERNAPRO;

DELIMITER $$

CREATE PROCEDURE `APPWTRANSFEREXTERNAPRO`(

	Par_CuentaAhoID			BIGINT(12),
	Par_CuentaCLABE			VARCHAR(18),
	Par_ConceptoPago		VARCHAR(40),
	Par_ReferenciaNum		INT(7),
	Par_Monto				DECIMAL(14,2),

	Par_IvaPorPagarSPEI		DECIMAL(14,2),
	Par_UsuarioEnvioSPEI	VARCHAR(30),
	Par_CuentaTranID        INT(11),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN


	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Decimal_Cero			DECIMAL(14,2);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Salida_SI				CHAR(1);
	DECLARE Salida_NO				CHAR(1);
	DECLARE Var_TipoPagoTercer		INT(1);
	DECLARE Var_TipoCuentaOrd		INT(2);
	DECLARE Var_AreaEmite			INT(1);
    DECLARE Var_OrigenOperVent		CHAR(1);
    DECLARE Var_PorcentajeIVA		DECIMAL(14,2);
    DECLARE Var_PersonaMoral		CHAR(1);
    DECLARE Var_PersFisConAct		CHAR(1);
    DECLARE Var_PersFisSinAct		CHAR(1);


	DECLARE Var_ClabeOrdenante		VARCHAR(20);
	DECLARE Var_NombreOrdenante		VARCHAR(100);
    DECLARE Var_RFCOrdenante		VARCHAR(18);
	DECLARE Var_FolioEnvio			BIGINT(20);
	DECLARE Var_ClaveRastreo		VARCHAR(30);
	DECLARE Var_NombreOrd			VARCHAR(100);
	DECLARE Var_RFCOrd				VARCHAR(18);
	DECLARE Var_MonedaID			INT(11);
	DECLARE Var_IVAPorPagar			DECIMAL(16,2);
	DECLARE Var_ComisionTrans		DECIMAL(16,2);
	DECLARE Var_IVAComision			DECIMAL(16,2);
	DECLARE Var_TotalCargo			DECIMAL(18,2);
	DECLARE Var_NombreBen			VARCHAR(100);
	DECLARE Var_RFCBen				VARCHAR(18);
	DECLARE Var_ClienteID			INT(11);
	DECLARE Var_ParticipanteSPI		CHAR(1);
	DECLARE Var_ComSpeiPerFis		DECIMAL(16,2);
	DECLARE Var_ComSpeiPerMor		DECIMAL(16,2);
	DECLARE Var_UsuarioEnvio		VARCHAR(30);
	DECLARE Var_AreaEmiteID			INT(11);
	DECLARE Var_InstiReceptora		INT(5);
	DECLARE Var_TipoCuentaBen		INT(2);
	DECLARE Var_ReferenciaNum		INT(7);
    DECLARE Var_UsuEnvioSPEI		VARCHAR(30);
    DECLARE Var_TipoPerson			CHAR(1);
    DECLARE Var_Control				VARCHAR(50);
    DECLARE Var_OrigenOperMovil		CHAR(1);
    DECLARE Var_ClabePart			INT(5);
    DECLARE Var_MontLimite          DECIMAL(12,2);
    DECLARE Var_EstatusActivo       CHAR(1);


	SET Cadena_Vacia				:=	'';
	SET Fecha_Vacia					:=	'1900-01-01';
	SET Entero_Cero					:=	0;
	SET Decimal_Cero				:=	0.0;
	SET Var_TipoPagoTercer			:= 1;
    SET Var_TipoCuentaOrd			:= 40;
    SET Var_AreaEmite				:= 10;
    SET Var_OrigenOperMovil			:= 'B';
    SET Var_PorcentajeIVA			:= 0.16;
    SET Var_PersonaMoral			:= 'M';
	SET Var_PersFisConAct			:= 'A';
	SET Var_PersFisSinAct			:= 'F';
    SET Var_EstatusActivo           := 'A';

	SET Salida_SI					:= 'S';
	SET Salida_NO					:= 'N';

    SET Par_CuentaAhoID 			:= IFNULL(Par_CuentaAhoID, Entero_Cero);
    SET Par_CuentaCLABE 			:= IFNULL(Par_CuentaCLABE, Cadena_Vacia);
    SET Par_ConceptoPago 			:= IFNULL(Par_ConceptoPago, Cadena_Vacia);
    SET Par_ReferenciaNum 			:= IFNULL(Par_ReferenciaNum, Entero_Cero);
    SET Par_Monto 					:= IFNULL(Par_Monto, Decimal_Cero);
	SET	Par_IvaPorPagarSPEI			:= IFNULL(Par_IvaPorPagarSPEI, Decimal_Cero);
	SET	Par_UsuarioEnvioSPEI		:= IFNULL(Par_UsuarioEnvioSPEI, Cadena_Vacia);
	SET Par_CuentaTranID            := IFNULL(Par_CuentaTranID, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
			   SET Par_NumErr  = 999;
			   SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
						  			'Disculpe las molestias que esto le ocasiona. Ref: SP-APPWTRANSFEREXTERNAPRO');
			   SET Var_Control = 'SQLEXCEPTION';
			END;


		IF (Par_CuentaAhoID = Entero_Cero) THEN
			SET	Par_NumErr 	:= 001;
			SET	Par_ErrMen	:= 'La cuenta de Ahorro no puede ser 0';
			SET Var_Control := 'cuantaAhoID';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_CuentaTranID = Entero_Cero) THEN
            SET	Par_NumErr 	:= 002;
			SET	Par_ErrMen	:= 'La cuenta transfer no puede ser 0';
			SET Var_Control := 'cuentaTranID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Monto  = Entero_Cero ) THEN
            SET	Par_NumErr 	:= 003;
			SET	Par_ErrMen	:= 'El monto no puede ser 0';
			SET Var_Control := 'monto';
			LEAVE ManejoErrores;
		END IF;

		SET Var_FolioEnvio := Entero_Cero;
		SET Var_ClaveRastreo := Cadena_Vacia;

		SELECT cli.ClienteID, 		cli.NombreCompleto, 	cli.RFC, 			cli.TipoPersona,			cue.MonedaID,
				cue.Clabe
			INTO Var_ClienteID, 	Var_NombreOrdenante, 	Var_RFCOrdenante, 	Var_TipoPerson,				Var_MonedaID,
				Var_ClabeOrdenante
			FROM CUENTASAHO cue
			INNER JOIN CLIENTES cli ON cue.ClienteID = cli.ClienteID
			WHERE cue.CuentaAhoID = Par_CuentaAhoID
			LIMIT 1;

        SELECT MontoLimite
        INTO   Var_MontLimite
        FROM CUENTASTRANSFER
        WHERE CuentaTranID = Par_CuentaTranID
        AND ClienteID = Var_ClienteID
        AND Estatus = Var_EstatusActivo;

        IF(Par_Monto > Var_MontLimite) THEN
            SET	Par_NumErr 	:= 004;
			SET	Par_ErrMen	:= 'El monto es mayor al monto limite de la cuenta transfer';
			SET Var_Control := 'montoLimite';
			LEAVE ManejoErrores;
        END IF;

		SET Var_ClienteID 		:= IFNULL(Var_ClienteID, Entero_Cero);
		SET Var_NombreOrdenante := IFNULL(Var_NombreOrdenante, Cadena_Vacia);
		SET Var_RFCOrdenante 	:= IFNULL(Var_RFCOrdenante, Cadena_Vacia);
		SET Var_MonedaID 		:= IFNULL(Var_MonedaID, Entero_Cero);
		SET Var_ClabeOrdenante 	:= IFNULL(Var_ClabeOrdenante, Cadena_Vacia);

		SELECT 		Cue.Beneficiario,		Cue.TipoCuentaSpei, 			Ins.ClaveParticipaSpei
			INTO 	Var_NombreBen,			Var_TipoCuentaBen, 				Var_InstiReceptora
			FROM CUENTASTRANSFER Cue
			INNER JOIN INSTITUCIONES Ins ON Cue.InstitucionID = Ins.InstitucionID
			WHERE ClienteID = Var_ClienteID
			AND Clabe		= Par_CuentaCLABE
			LIMIT 1;

		SELECT TipoCuenta.ComSpeiPerFis, 	TipoCuenta.ComSpeiPerMor
			INTO Var_ComSpeiPerFis, 		Var_ComSpeiPerMor
			FROM CUENTASAHO Cuenta
			INNER JOIN TIPOSCUENTAS TipoCuenta ON Cuenta.TipoCuentaID = TipoCuenta.TipoCuentaID
			WHERE Cuenta.CuentaAhoID = Par_CuentaAhoID;

		SET Var_ComSpeiPerMor := IFNULL(Var_ComSpeiPerMor, Decimal_Cero);
		SET Var_ComSpeiPerFis := IFNULL(Var_ComSpeiPerFis, Decimal_Cero);

		SET Var_IVAComision 	:= Decimal_Cero;

		SET	Var_IVAPorPagar		:=	Par_IvaPorPagarSPEI;
		SET Var_UsuarioEnvio	:=	Par_UsuarioEnvioSPEI;


		IF (Var_TipoPerson = Var_PersonaMoral) THEN

			SET Var_ComisionTrans := Var_ComSpeiPerMor;
			SET Var_IVAComision := CAST((Var_ComSpeiPerMor * Var_PorcentajeIVA) AS DECIMAL(16,2));
		END IF;

		IF (Var_TipoPerson = Var_PersFisConAct OR Var_TipoPerson = Var_PersFisSinAct) THEN

			SET Var_ComisionTrans := Var_ComSpeiPerFis;
			SET Var_IVAComision := CAST((Var_ComSpeiPerFis * Var_PorcentajeIVA) AS DECIMAL(16,2));
		END IF;

		SET Var_ComisionTrans := IFNULL(Var_ComisionTrans, Decimal_Cero);
		SET Var_IVAComision := IFNULL(Var_IVAComision, Decimal_Cero);

		SET Var_TotalCargo := Par_Monto + Var_ComisionTrans + Var_IVAComision;


		CALL SPEIENVIOSPRO (	Var_FolioEnvio, 		Var_ClaveRastreo, 		Var_TipoPagoTercer,		Par_CuentaAhoID,		Var_TipoCuentaOrd,
								Var_ClabeOrdenante, 	Var_NombreOrdenante,	Var_RFCOrdenante,		Var_MonedaID,			Entero_Cero,
								Par_Monto,				Var_IVAPorPagar,		Var_ComisionTrans,		Var_IVAComision,		Var_TotalCargo,
								Var_InstiReceptora,		Par_CuentaCLABE,		Var_NombreBen,			Var_RFCBen,				Var_TipoCuentaBen,
								Par_ConceptoPago,		Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Entero_Cero,
								Cadena_Vacia,			Cadena_Vacia,			Par_ReferenciaNum,		Var_UsuarioEnvio,		Var_AreaEmite,
								Var_OrigenOperMovil,	Salida_NO,				Par_NumErr,				Par_ErrMen,				Aud_EmpresaID,
								Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
								Aud_NumTransaccion);


		IF (Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_FolioEnvio AS consecutivo;
	END IF;


END TerminaStore$$