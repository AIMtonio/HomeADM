-- APPCUENTASDESTINOALT

DELIMITER ;

DROP PROCEDURE IF EXISTS APPWCUENTASDESTINOALT;

DELIMITER $$

CREATE PROCEDURE `APPWCUENTASDESTINOALT`(
	-- Store para dar de alta una cuenta destino ligada a un cliente usuario de la app wallet


    Par_ClienteID			BIGINT(20),
	Par_TipoCuenta			CHAR(1),
	Par_ClaveParticipaSpei	INT(11),
	Par_CuentaCLABE			CHAR(18),
	Par_TarjetaDebID		CHAR(16),
	Par_CuentaInterna   	BIGINT(12),
	Par_AliasCtaDestino		VARCHAR(100),
	Par_TelefonoBenefi		VARCHAR(15),
	Par_EmailBenefi			VARCHAR(50),
	Par_MontoLimite			DECIMAL(14,2),

	Par_Salida         	 	CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN


	DECLARE Var_Control         VARCHAR(50);
	DECLARE Var_BancoID			INT(11);
	DECLARE Var_Beneficiario	VARCHAR(400);
	DECLARE Var_NombreCorto     VARCHAR(50);
	DECLARE Var_StatusCta		CHAR(1);
	DECLARE Var_Consecutivo		INT(11);
	DECLARE Var_TipoSPEI		INT(2);
	DECLARE	Var_Folio			CHAR(3);
	DECLARE Var_InstitucionID 	INT(11);
	DECLARE Var_InstitucionID2	INT(11);
	DECLARE SalidaNO			CHAR(1);
	DECLARE Var_EstatusDomicilio CHAR(1);
	DECLARE No_Afiliada			CHAR(1);
	DECLARE Aplica_Cuenta		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Var_NumCtaTran		INT(11);
	DECLARE Var_FechaSistema	DATE;
	DECLARE	Est_Registrado		CHAR(1);
	DECLARE Par_AplicaPara		CHAR(1);
	DECLARE Var_ClienteDestino	INT(11);
	DECLARE VarClavePSpei		INT(11);
	DECLARE Var_ClienteID		INT(11);
	DECLARE Var_Clave			VARCHAR(20);

	DECLARE Cadena_Vacia    CHAR(1);
	DECLARE Entero_Cero     INT(11);
	DECLARE Estatus_Activo  CHAR(1);
	DECLARE Estatus_Baja	CHAR(1);
	DECLARE SalidaSI        CHAR(1);
	DECLARE Var_SalidaNO	CHAR(1);
	DECLARE	Cta_Interna		CHAR(1);
	DECLARE	Cta_Externa		CHAR(1);
	DECLARE	Tipo_CtaCLABE	INT(2);
	DECLARE	Tipo_TarDebito  INT(2);


	SET Cadena_Vacia    		:= '';
	SET Entero_Cero     		:= 0;
	SET Estatus_Activo  		:= 'A';
	SET Estatus_Baja			:= 'B';
	SET SalidaSI        		:= 'S';
	SET Var_SalidaNO			:= 'N';
	SET	Cta_Interna				:= 'I';
	SET	Cta_Externa    			:= 'E';
	SET	Tipo_CtaCLABE			:= 40;
	SET	Tipo_TarDebito  		:= 3;
	SET Est_Registrado			:= 'A';
	SET	SalidaNO				:= 'N';
	SET Aplica_Cuenta			:= 'S';
	SET No_Afiliada				:= 'N';
	SET Fecha_Vacia				:= '1900-01-01';
	SET Par_AplicaPara			:= 'A';
	SET Var_ClienteDestino		:= 0;
	SET VarClavePSpei		:= 0;


	ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('Estimado Usuario(a), Ha ocurrido una falla en el sistema,',
									'estamos trabajando para resolverla. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-APPWCUENTASDESTINOALT');
					SET Var_Control = 'sqlException' ;
		END;


	SET Var_Consecutivo := Entero_Cero;


	SET Par_CuentaCLABE 	:= IFNULL(Par_CuentaCLABE, Cadena_Vacia);
	SET Par_TarjetaDebID 	:= IFNULL(Par_TarjetaDebID, Cadena_Vacia);
	SET Par_CuentaInterna 	:= IFNULL(Par_CuentaInterna, Entero_Cero);

	SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);


	IF(Par_TipoCuenta = Cta_Externa) THEN

		SELECT ClaveParticipaSpei INTO VarClavePSpei
			FROM INSTITUCIONES
			WHERE	ClaveParticipaSpei	= Par_ClaveParticipaSpei;

		SELECT	Ins.InstitucionID, 		Ins.NombreCorto, 		Ins.Folio
			INTO Var_InstitucionID2, 	Var_NombreCorto, 		Var_Folio
			FROM INSTITUCIONES Ins
			WHERE  Ins.ClaveParticipaSpei = Par_ClaveParticipaSpei
			LIMIT 1;

		SET Var_NombreCorto := IFNULL(Var_NombreCorto, Cadena_Vacia);
		SET Var_Folio 		:= IFNULL(Var_Folio, Cadena_Vacia);

		IF(Var_NombreCorto = Cadena_Vacia) THEN
			SET	Par_NumErr 	:= 002;
			SET	Par_ErrMen	:= 'La Institucion Destino no Existe';
			SET Var_Control := 'bancoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CuentaCLABE = Cadena_Vacia AND Par_TarjetaDebID = Cadena_Vacia) THEN
			SET	Par_NumErr 	:= 003;
			SET	Par_ErrMen	:= 'La Cuenta CLABE o No. de Tarjeta estan Vacios';
			SET Var_Control := 'cuentaClabe';
			LEAVE ManejoErrores;
		END IF;


		IF(Par_CuentaCLABE != Cadena_Vacia) THEN

			SELECT Clabe INTO Var_Clave
						FROM CUENTASTRANSFER
						WHERE ClienteID 	= Par_ClienteID
						  AND Clabe 	= Par_CuentaCLABE;

			IF (IFNULL(Var_Clave,Cadena_Vacia) <> Cadena_Vacia) THEN

				SET	Par_NumErr 	:= 008;
				SET	Par_ErrMen	:= 'La Cuenta CLABE ya se encuentra Registrada';
				SET Var_Control := 'cuentaClabe';
				LEAVE ManejoErrores;

			END IF;

			IF(Var_Folio != MID(Par_CuentaCLABE, 1, 3)) THEN

				SET	Par_NumErr 	:= 012;
				SET	Par_ErrMen	:= 'El Numero de la Cuenta CLABE no Corresponde con el Banco Destino.';
				SET Var_Control := 'cuentaClabe';
				LEAVE ManejoErrores;


			END IF;

			IF (FNVALIDACLABE(Par_CuentaCLABE) != Par_CuentaCLABE) THEN
				SET	Par_NumErr 	:= 011;
				SET	Par_ErrMen	:= 'El Numero de la Cuenta CLABE no es Correcto.';
				SET Var_Control := 'cuentaClabe';
				LEAVE ManejoErrores;
			END IF;

			SET Var_TipoSPEI	:= Tipo_CtaCLABE;

		END IF;

		IF(Par_TarjetaDebID != Cadena_Vacia) THEN

			SET Var_TipoSPEI	:= Tipo_TarDebito;

		END IF;


	ELSE

		SET Var_TipoSPEI	:= Entero_Cero;

		SELECT Ins.InstitucionID, 	Ins.NombreCorto
		INTO Var_InstitucionID,		Var_NombreCorto
		FROM PARAMETROSSIS Par
		INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID
		LIMIT 1;

		SET Var_InstitucionID := IFNULL(Var_InstitucionID, Entero_Cero);
		SET Var_NombreCorto := IFNULL(Var_NombreCorto, Cadena_Vacia);

		SET Var_InstitucionID2 := Var_InstitucionID;

		SELECT ClaveParticipaSpei INTO VarClavePSpei
			FROM INSTITUCIONES
			WHERE	InstitucionID	= Var_InstitucionID2;

		SET VarClavePSpei := IFNULL(VarClavePSpei, Entero_Cero);

		IF(Par_CuentaInterna = Entero_Cero) THEN
			SET	Par_NumErr 	:= 005;
			SET	Par_ErrMen	:= 'La Cuenta Interna esta vacia';
			SET Var_Control := 'cuentaInterna';
			LEAVE ManejoErrores;
		END IF;

		SELECT	Estatus, ClienteID INTO Var_StatusCta, Var_ClienteDestino
			FROM CUENTASAHO
			WHERE  CuentaAhoID = Par_CuentaInterna;

		SET Var_StatusCta := IFNULL(Var_StatusCta, Cadena_Vacia);

		IF (Var_StatusCta != Estatus_Activo) THEN
			SET	Par_NumErr 	:= 006;
			SET	Par_ErrMen	:= 'La Cuenta Destino no Existe';
			SET Var_Control := 'cuentaInterna';
			LEAVE ManejoErrores;
		END IF;

		SELECT ClienteID INTO Var_ClienteID
					FROM CUENTASTRANSFER
					WHERE ClienteID = Par_ClienteID
					  AND CuentaDestino = Par_CuentaInterna
					  AND Estatus <> Estatus_Baja;

		IF (IFNULL(Var_ClienteID, Entero_Cero) <> Entero_Cero) THEN

			SET	Par_NumErr 	:= 010;
			SET	Par_ErrMen	:= 'La Cuenta ya se Encuentra Registrada';
			SET Var_Control := 'cuentaClabe';
			LEAVE ManejoErrores;

		END IF;

	END IF;


    SET Var_Beneficiario := Par_AliasCtaDestino;
	SET Par_AliasCtaDestino := FNCAPITALIZAPALABRA(TRIM(Par_AliasCtaDestino));


	IF(TRIM(Var_Beneficiario) = Cadena_Vacia ) THEN
		SET	Par_NumErr 	:= 007;
		SET	Par_ErrMen	:= 'El Nombre del Beneficiario esta vacio.';
		SET Var_Control := 'beneficiario';
		LEAVE ManejoErrores;
	END IF;



	SET Aud_FechaActual := NOW();

		IF (Par_AplicaPara <> Aplica_Cuenta) THEN
			SET Var_EstatusDomicilio = No_Afiliada;
		ELSE
			SET Var_EstatusDomicilio = Cadena_Vacia;
		END IF;

         CALL CUENTASTRANSFERALT (
        	Par_ClienteID,      	 Par_CuentaInterna,  	Var_InstitucionID2,		Par_CuentaCLABE,	Var_Beneficiario,
        	Par_AliasCtaDestino,	 Var_FechaSistema,	 	Par_TipoCuenta,		 	Par_CuentaInterna,	Var_ClienteDestino,
        	Par_CuentaInterna,		 Var_ClienteDestino,	Var_TipoSPEI,			Cadena_Vacia,		No_Afiliada,
        	Par_AplicaPara,			 Par_MontoLimite,		Var_SalidaNO,     	 	Par_NumErr,         Par_ErrMen,
        	Par_EmpresaID,			 Aud_Usuario, 		 	Aud_FechaActual,  	 	Aud_DireccionIP,    Aud_ProgramaID,
        	Aud_Sucursal,  	 		 Aud_NumTransaccion
        );

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Var_Consecutivo := SUBSTR(Par_ErrMen, LENGTH('Cuenta Destino Agregada: '));
		SET Par_NumErr  := 000;
		SET Par_ErrMen  := 'Cuenta Destino Agregada Exitosamente';
		SET Var_Control := 'cuentaInterna';
		SET Entero_Cero := Par_ClienteID;


		END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$
