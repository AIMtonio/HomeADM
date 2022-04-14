-- SP NOMCAPACIDADPAGOSOLALT

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMCAPACIDADPAGOSOLALT;

DELIMITER $$

CREATE PROCEDURE NOMCAPACIDADPAGOSOLALT(
/* SP PARA REGISTRAR LA CAPACIDAD DE PAGO */
	Par_NomCapacidadPagoSolID	BIGINT(12),		-- Identificador de la tabla NOMCAPACIDADPAGOSOL
    Par_SolicitudCreditoID		BIGINT(20),		-- Identificador de la tabla SOLICITUDCREDITO
    Par_CapacidadPago			DECIMAL(12,2),	-- Valor de capacidad de pago
    Par_MontoCasasComer			DECIMAL(12,2),	-- Valor de monto casas comer
    Par_MontoResguardo			DECIMAL(12,2),	-- Valor monto resguardo
    Par_PorcentajeCapacidad		DECIMAL(12,2),	-- Valor porcentaje capacidad
	/*Parametros de auditoria*/
	Par_Salida					CHAR(1),
	INOUT Par_NumErr			INT(11),
	INOUT Par_ErrMen			VARCHAR(400),
    Aud_EmpresaID				VARCHAR(45),
    Aud_Usuario					INT(11),
    Aud_FechaActual				DATETIME,
    Aud_DireccionIP				VARCHAR(15),
    Aud_ProgramaID				VARCHAR(50),
    Aud_Sucursal				INT(11),
    Aud_NumTransaccion			BIGINT(20)
		)
TerminaStore:BEGIN

	# Declaracion de Variables
	DECLARE Var_Control 			VARCHAR(50);		-- Variable control
	DECLARE Var_Consecutivo			VARCHAR(100);		-- Variable consecutivo
	DECLARE Var_TipoCredito			CHAR(1);			-- Variable d etipo de credito
     -- JQUINTAL NARRATIVA 0010 MEXI
	DECLARE Cliente_Vigua_Serv_Pat 	INT(11); 		-- CLIENTE VIGUA SERVICIOS PATRIMONIALES
	DECLARE Var_CliEsp  			INT (11);		-- CLIENTE ESPECIFICO
	DECLARE Var_ParamCli			VARCHAR(50);	-- PARAMETRO PARA BUSCAR CLIENTE ESPECIFICO EN PARAMGENERALES
    DECLARE Var_ClienteID 			INT(11);

	-- Declaracion de constantes
    DECLARE	Decimal_Cero			DECIMAL(12,2);		-- Decimal vacio
	DECLARE Entero_Cero				INT;
	DECLARE	Salida_NO				CHAR(1);
	DECLARE	Salida_SI				CHAR(1);
	-- MMARTINEZ  MEXI
    DECLARE Var_RolPerf             VARCHAR(50);        -- PARAMETRO PARA VALIDAR ROL
    DECLARE Var_RolA                INT(11);
    DECLARE Var_RolUsuario          INT(11);

	-- Asignacion  de constantes
    SET Decimal_Cero			:= 0.0;			-- Asignacion de Decima Vacio
	SET	Entero_Cero				:= 0;			-- Constante Entero valor cero
	SET	Salida_NO				:= 'N';			-- Constante Salida NO
	SET	Salida_SI				:= 'S';			-- Constante Salida SI
	-- JQUINTAL NARRATIVA 0010 MEXI
	SET Cliente_Vigua_Serv_Pat	:=38;
	SET Var_ParamCli			:='CliProcEspecifico';
	-- MMARTINEZ  MEXI
    SET Var_RolPerf             :='RolActPerfil';


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-NOMCAPACIDADPAGOSOLALT');
			SET Var_Control := 'sqlexception';
		END;





		-- Validacion para el Folio de la Solicitud esta vacio
		IF( IFNULL(Par_SolicitudCreditoID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El Folio de la Solicitud esta Vacio.';
			SET Var_Control	:= 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT TipoCredito,ClienteID
			INTO Var_TipoCredito,Var_ClienteID
			FROM SOLICITUDCREDITO
			WHERE SolicitudCreditoId = Par_SolicitudCreditoID;



         -- JQuintal NARRATIVA 0010 MEXI
	SELECT ValorParametro
		INTO Var_CliEsp
		FROM PARAMGENERALES
			WHERE LlaveParametro = Var_ParamCli;

    SELECT ValorParametro
			INTO Var_RolA
			FROM PARAMGENERALES
				WHERE LlaveParametro = Var_RolPerf;

    SELECT RolID INTO Var_RolUsuario FROM USUARIOS WHERE  UsuarioID = Aud_Usuario;

		SET Var_CliEsp:=IFNULL(Var_CliEsp,Entero_Cero);

        SET Var_RolUsuario:=IFNULL(Var_RolUsuario,Entero_Cero);

		IF (Var_CliEsp=Cliente_Vigua_Serv_Pat) THEN

            IF(Var_RolA != Var_RolUsuario)THEN

                CALL VALIDADATOSCTEVAL(
                        Var_ClienteID,			Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
                        Aud_Usuario ,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
                        Aud_NumTransaccion);

                        IF( Par_NumErr<>Entero_Cero) THEN
                            SET Par_NumErr  := Par_NumErr;
                            SET Par_ErrMen  := Par_ErrMen;
                            SET Var_Control := 'clienteID ';
                            LEAVE ManejoErrores;
                        END IF;
                 END IF;
		END IF;




		-- Validacion para el Monto Casas Comer este Vacio
		IF (Var_TipoCredito != "N") THEN
			IF( IFNULL(Par_MontoCasasComer, Decimal_Cero) < Decimal_Cero ) THEN
				SET Par_NumErr	:= 003;
				SET Par_ErrMen	:= 'El Monto Casas Comer no puede ser Menor que cero.';
				SET Var_Control	:= 'montoCasasComer';
				LEAVE ManejoErrores;
			END IF;
		END IF;

        -- Validacion para el Monto Resguardo este Vacio
		IF( IFNULL(Par_MontoResguardo, Decimal_Cero) < Decimal_Cero ) THEN
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= 'El Monto Resguardo no puede ser Menor que cero.';
			SET Var_Control	:= 'montoResguardo';
			LEAVE ManejoErrores;
		END IF;

        -- Validacion para el Monto Resguardo este Vacio
		IF( IFNULL(Par_PorcentajeCapacidad, Decimal_Cero) < Decimal_Cero ) THEN
			SET Par_NumErr	:= 005;
			SET Par_ErrMen	:= 'El Porcentaje Capacidad no puede ser Menor que cero.';
			SET Var_Control	:= 'porcentajeCapacidad';
			LEAVE ManejoErrores;
		END IF;

		CALL FOLIOSAPLICAACT('NOMCAPACIDADPAGOSOL', Par_NomCapacidadPagoSolID);

		INSERT INTO NOMCAPACIDADPAGOSOL
				(	NomCapacidadPagoSolID,		SolicitudCreditoID,			CapacidadPago,		MontoCasasComer,
					MontoResguardo, 			PorcentajeCapacidad,		EmpresaID,			Usuario,
                    FechaActual,				DireccionIP,				ProgramaID,			Sucursal,
                    NumTransaccion)
		VALUES(		Par_NomCapacidadPagoSolID,	Par_SolicitudCreditoID,		Par_CapacidadPago,	Par_MontoCasasComer,
					Par_MontoResguardo,			Par_PorcentajeCapacidad,	Aud_EmpresaID,		Aud_Usuario,
                    Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
      LEAVE ManejoErrores;
        END IF;

    SET Par_NumErr		:= 0;
    -- SET Par_ErrMen		:= CONCAT('Capacidad de Pago Agregado Exitosamente:',CAST(Par_NomCapacidadPagoSolID AS CHAR) );
    SET Par_ErrMen		:= 'Capacidad de Pago Agregado Exitosamente';
    SET Var_Control		:= 'nomCapacidadPagoSolID';
    SET Var_Consecutivo	:= Par_NomCapacidadPagoSolID;

  END ManejoErrores;

  IF (Par_Salida = Salida_SI) THEN
    SELECT
		Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS control,
		Var_Consecutivo AS consecutivo;

  END IF;

END TerminaStore$$
