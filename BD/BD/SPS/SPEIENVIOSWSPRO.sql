-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIENVIOSWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIENVIOSWSPRO`;DELIMITER $$

CREATE PROCEDURE `SPEIENVIOSWSPRO`(



	INOUT Par_Folio		   BIGINT(20),
    INOUT Par_ClaveRas	   VARCHAR(30),
	Par_ClienteID		   INT(11),
	Par_CuentaAhoID		   BIGINT(12),
	Par_MontoTransferir	   DECIMAL(16,2),

	Par_ConceptoPago	   VARCHAR(40),
	Par_InstiReceptora	   INT(5),
    Par_TipoCuentaBen	   INT(2),
    Par_CuentaBeneficiario VARCHAR(20),
    Par_NombreBeneficiario VARCHAR(100),

	Par_ReferenciaNum      INT(7),
	Par_RFCBeneficiario	   VARCHAR(18),
	Par_IVAPorPagar		   DECIMAL(16,2),
    Par_UsuarioEnvio       VARCHAR(30),

	Par_Salida			   CHAR(1),
	INOUT Par_NumErr	   INT,
	INOUT Par_ErrMen	   VARCHAR(400),

	Par_EmpresaID		   INT(11),
	Aud_Usuario			   INT(11),
	Aud_FechaActual		   DATETIME,
	Aud_DireccionIP		   VARCHAR(20),
	Aud_ProgramaID		   VARCHAR(50),
	Aud_Sucursal		   INT(11),
	Aud_NumTransaccion	   BIGINT(20)
	)
TerminaStore: BEGIN



	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT;
	DECLARE	Decimal_Cero		DECIMAL(18,2);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE Salida_SI 			CHAR(1);
	DECLARE	Salida_NO			CHAR(1);
	DECLARE TipoPago			INT(2);
	DECLARE TipoCuentaOrd		INT(2);
	DECLARE TipoOperacion		INT(2);
	DECLARE AreaEmiteID	       	INT(2);
	DECLARE	ParticipaSpei		CHAR(1);
	DECLARE PersonaFisica		CHAR(1);
	DECLARE PersonaMoral		CHAR(1);
	DECLARE	EstatusAct			CHAR(1);
	DECLARE TipoExterna			CHAR(1);
    DECLARE Var_OrigenOperacion	CHAR(1);
	DECLARE Var_PartBcaMovil	CHAR(1);
    DECLARE Var_LimitBcaMovil	CHAR(1);


	DECLARE Var_Control	    		VARCHAR(200);
	DECLARE Var_Consecutivo			BIGINT(20);
	DECLARE Var_CuentaOrd			VARCHAR(20);
	DECLARE Var_NombreOrdenate		VARCHAR(40);
	DECLARE Var_RFCOrdenate			VARCHAR(18);
	DECLARE Var_MonedaID			INT(11);
	DECLARE Var_ComisionTrans		DECIMAL(16,2);
	DECLARE Var_IVAComision			DECIMAL(16,2);
	DECLARE Var_TotalCargoCuenta	DECIMAL(16,2);
	DECLARE Var_FechaAutoriza		VARCHAR(20);
	DECLARE Var_ClaveRas    		VARCHAR(30);
    DECLARE Var_FechaOperacion		DATE;

	DECLARE Var_UsuarioEnvio       	VARCHAR(30);

	DECLARE Var_TipoCuentaID		INT;
	DECLARE Var_TipoPersona			CHAR(1);
	DECLARE	Var_ComSpeiTipoPer		DECIMAL(16,2);
	DECLARE Var_SaldoDispon			DECIMAL(16,2);
	DECLARE Var_ParticipaSpei		CHAR(1);
	DECLARE Var_TotalMontoTrans		DECIMAL(16,2);
	DECLARE	Var_MonMaxSpeiBcaMovil	DECIMAL(16,2);
	DECLARE Var_Iva					DECIMAL(16,2);


	SET	Cadena_Vacia	    := '';
	SET	Fecha_Vacia	    	:= '1900-01-01 00:00:00';
	SET	Entero_Cero		    := 0;
	SET	Decimal_Cero	    := 0.00;
	SET Salida_SI 	     	:= 'S';
	SET	Salida_NO	       	:= 'N';
	SET TipoPago			:= 1;
	SET TipoCuentaOrd		:= 40;
	SET TipoOperacion		:= 0;
	SET	AreaEmiteID			:= 8;
	SET	EstatusAct			:= 'A';
	SET ParticipaSpei		:= 'S';
	SET PersonaFisica		:= 'F';
	SET PersonaMoral		:= 'M';
	SET TipoExterna			:= 'E';
    SET Var_OrigenOperacion	:= 'M';
    SET Var_PartBcaMovil	:= 'S';
    SET Var_LimitBcaMovil	:= 'S';
	SET Var_FechaAutoriza	:= CONCAT(CURRENT_DATE,'T',CURRENT_TIME);

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIENVIOSWSPRO');
				SET Var_Control = 'sqlException';
			END;

        IF NOT EXISTS (SELECT	EmpresaID
			FROM PARAMETROSSPEI
			WHERE	EmpresaID			= Par_EmpresaID
			  AND	ParticipaPagoMovil	= Var_PartBcaMovil)THEN
				SET Par_NumErr := 001;
				SET Par_ErrMen := 'Estimado Usuario(a), por el Momento No se Pueden Realizar Spei\'s Moviles';
				LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS (SELECT	CuentaAhoID
			FROM CUENTASAHO
			WHERE	CuentaAhoID	= Par_CuentaAhoID
			  AND	Estatus		= EstatusAct)THEN
				SET Par_NumErr := 002;
				SET Par_ErrMen := 'Estimado Usuario(a), la Cuenta de Ahorro No se Encuentra Activa';
				LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS (SELECT	ClienteID
			FROM CLIENTES
			WHERE	ClienteID	= Par_ClienteID
			  AND	Estatus		= EstatusAct)THEN
				SET Par_NumErr := 003;
				SET Par_ErrMen := 'Estimado Usuario(a), su Estatus No le Permite Realizar la Operacion';
				LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MontoTransferir,Decimal_Cero)) = Entero_Cero then
			SET Par_NumErr := 004;
			SET Par_ErrMen :='Especificar Monto de la Transferencia';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS (SELECT	CT.CuentaTranID
			FROM CUENTASTRANSFER CT,
				INSTITUCIONESSPEI ISP
			WHERE   ISP.InstitucionID = CT.InstitucionID
			  AND	CT.ClienteID	= Par_ClienteID
			  AND	CT.Clabe 		= Par_CuentaBeneficiario
			  AND 	CT.TipoCuenta 	= TipoExterna
			  AND 	CT.Estatus  	= EstatusAct)THEN
				SET Par_NumErr := 005;
				SET Par_ErrMen := 'Cuenta Beneficiorio Incorrecta';
				LEAVE ManejoErrores;
		END IF;


		SELECT	CTE.NombreCompleto,		CTE.RFC,				CTE.TipoPersona,	CA.Clabe,		CA.MonedaID,
				CASE	CTE.TipoPersona
					WHEN	PersonaFisica	THEN IFNULL(TCTA.ComSpeiPerFis,Decimal_Cero)
					WHEN	PersonaMoral    THEN IFNULL(TCTA.ComSpeiPerMor,Decimal_Cero)
					ELSE	Decimal_Cero	END AS ComSpei,
				TCTA.ParticipaSpei,		CA.SaldoDispon
		  INTO	Var_NombreOrdenate,		Var_RFCOrdenate,		Var_TipoPersona,	Var_CuentaOrd,	Var_MonedaID,
				Var_ComSpeiTipoPer,		Var_ParticipaSpei,		Var_SaldoDispon
			FROM CUENTASAHO CA,
				MONEDAS MO,
				TIPOSCUENTAS TCTA,
				CLIENTES CTE
			WHERE  	CuentaAhoID 	= Par_CuentaAhoID
			  AND	CA.TipoCuentaID	= TCTA.TipoCuentaID
			  AND	CA.MonedaID 	= MO.MonedaID
			  AND	CTE.ClienteID	= CA.ClienteID;


		IF(Var_ParticipaSpei != ParticipaSpei) THEN
			SET Par_NumErr := 006;
			SET Par_ErrMen :='El Tipo de Cuenta no Participa en SPEI.';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_SaldoDispon = Decimal_Cero) THEN
			SET Par_NumErr := 007;
			SET Par_ErrMen :='La Cuenta no tiene Saldo Disponible.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_CuentaOrd,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 008;
			SET Par_ErrMen := 'La Cuenta de Ahorro no tiene asignada una Cuenta Clabe.';
			LEAVE ManejoErrores;
		END IF;

		SELECT 	SUC.IVA		INTO	Var_Iva
			FROM CUENTASAHO CO
				INNER JOIN SUCURSALES SUC ON SUC.SucursalID = CO.SucursalID
			WHERE CuentaAhoID = Par_CuentaAhoID;

		SET  Var_ComisionTrans	:= Var_ComSpeiTipoPer;
		SET  Var_IVAComision	:= (Var_ComSpeiTipoPer * Var_Iva);

		SET Var_TotalMontoTrans := Par_MontoTransferir + Var_ComisionTrans + Var_IVAComision;

		IF(Var_TotalMontoTrans > Var_SaldoDispon )THEN
			SET Par_NumErr := 009;
			SET Par_ErrMen :='El Monto es Superior al Saldo Disponible.';
			LEAVE ManejoErrores;
		END IF;

		SELECT 	MonMaxSpeiBcaMovil INTO Var_MonMaxSpeiBcaMovil
			FROM PARAMETROSSPEI;

        IF EXISTS (SELECT	LimiteOperID
			FROM LIMITESOPERCLIENTE
			WHERE	ClienteID 	= Par_ClienteID
              AND	BancaMovil	= Var_LimitBcaMovil) THEN
				SELECT	MonMaxBcaMovil INTO Var_MonMaxSpeiBcaMovil
					FROM LIMITESOPERCLIENTE
					WHERE	ClienteID = Par_ClienteID;
		END IF;

		IF(Par_MontoTransferir > Var_MonMaxSpeiBcaMovil)THEN
			SET Par_NumErr := 010;
			SET Par_ErrMen :='La Cantidad es Superior al Monto Permitido.';
			LEAVE ManejoErrores;
		END IF;


        SET Var_RFCOrdenate	:= IFNULL(Var_RFCOrdenate, Cadena_Vacia);

		CALL SPEIENVIOSPRO(
			Par_Folio,					Par_ClaveRas,			TipoPago,				Par_CuentaAhoID,		TipoCuentaOrd,
			Var_CuentaOrd,			    Var_NombreOrdenate,		Var_RFCOrdenate,		Var_MonedaID,			TipoOperacion,
			Par_MontoTransferir,	    Par_IVAPorPagar,	    Var_ComisionTrans,		Var_IVAComision,		Var_TotalMontoTrans,
			Par_InstiReceptora,		    Par_CuentaBeneficiario,	Par_NombreBeneficiario,	Par_RFCBeneficiario,	Par_TipoCuentaBen,
			Par_ConceptoPago,		    Entero_Cero,			Cadena_Vacia,			Cadena_Vacia,			Entero_Cero,
			Cadena_Vacia,			    Cadena_Vacia,		    Par_ReferenciaNum,		Par_UsuarioEnvio,		AreaEmiteID,
			Var_OrigenOperacion,		Salida_NO,				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,
            Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		    Aud_Sucursal,
            Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr 			:= 000;
		SET Par_ErrMen 			:= CONCAT("Envio SPEI Agregado Exitosamente: ", CONVERT(Par_Folio, CHAR));
		SET Var_Consecutivo 	:= Par_Folio;
		SET Var_ClaveRas 		:= Par_ClaveRas;
		SET Var_FechaOperacion 	:= DATE(Aud_FechaActual);


	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_FechaAutoriza AS AutFecha,
					Aud_NumTransaccion AS FolioAut,
					Var_Consecutivo AS FolioSpei,
					Var_ClaveRas AS ClaveRastreo,
					Var_FechaOperacion AS FechaOperacion;
		END IF;

END TerminaStore$$