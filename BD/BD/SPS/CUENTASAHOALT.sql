-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOALT`;
DELIMITER $$


CREATE PROCEDURE `CUENTASAHOALT`(
# ========== SP PARA ALTA DE CUENTAS DE AHORRO =============================================
	Par_SucursalID 			INT(11),
	Par_ClienteID 			INT(11),
	Par_Clabe 				VARCHAR(18),
	Par_MonedaID 			INT(11),
	Par_TipoCuentaID 		INT(11),

	Par_FechaReg 			DATE,
	Par_Etiqueta 			VARCHAR(50),
	Par_EdoCta 			    CHAR(1),
	Par_InstitucionID		INT(11),
	Par_EsPrincipal			CHAR(1),

    Par_TelefonoCelular     VARCHAR(20),
    INOUT Par_CuentaAho  	BIGINT(12),

	Par_Salida         		CHAR(1),
    INOUT Par_NumErr		INT(11),
    INOUT Par_ErrMen    	VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN

-- declaracion de constantes
DECLARE Estatus_Registrada	CHAR(1);
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Entero_Cero			INT;
DECLARE Fecha_Vacia			DATE;
DECLARE Edo_Domicilio		CHAR(1);
DECLARE Edo_Internet		CHAR(1);
DECLARE Edo_Sucursal		CHAR(1);
DECLARE TipoBancaria 		CHAR(1);
DECLARE Var_SI				CHAR(1);
DECLARE Var_NO				CHAR(1);
DECLARE Decimal_Cero		DECIMAL;
DECLARE siReqAportacionSoc	CHAR(1);
DECLARE	Si					CHAR(1);
DECLARE Estatus_Cancelada	CHAR(1);
DECLARE ClienteNUno			CHAR(1);
DECLARE	Salida_NO			CHAR(1);
DECLARE	Salida_SI			CHAR(1);
DECLARE Per_Moral			CHAR(1);	-- Persona Moral
DECLARE Per_Emp				CHAR(1);	-- Persona Fisica Act. Empresarial
DECLARE Per_Fisica			CHAR(1);	-- Persona Fisica
DECLARE InstrumentoCH		CHAR(2);
-- declaracion de variables
DECLARE var_Principal		CHAR(1);
DECLARE NumCuentaAhoID	    CHAR(11);
DECLARE NumCuentaAho	    CHAR(10);
DECLARE Verifica			INT;
DECLARE i				    INT;
DECLARE j				    INT;
DECLARE Modulo2			    INT;
DECLARE consecutivo		    INT;
DECLARE NumVerificador	    CHAR(1);
DECLARE Var_Estatus         CHAR(1);
DECLARE ClienteInactivo     CHAR(1);
DECLARE Var_ReqAportSocio   CHAR(1);
DECLARE Var_MontoAportacion DECIMAL(14,2);
DECLARE Var_Saldo			DECIMAL(14,2);
DECLARE Var_TipoPersona     CHAR(1);
DECLARE TipoCuentaNO        CHAR(1);
DECLARE Var_EsSocioMenor    CHAR(1);
DECLARE Per_MenorEdad       CHAR(1);
DECLARE VarEsMenorEdad      CHAR(1);
DECLARE	Var_ClienteNUno		CHAR(1);
DECLARE	Var_EsBancaria		CHAR(1);
DECLARE Var_GAT             DECIMAL(12,2);
DECLARE Var_GATReal         DECIMAL(12,2);
DECLARE Var_Tasa            DECIMAL(12,4);
DECLARE Var_Inflacion       DECIMAL(12,4);
DECLARE Var_GenInte         CHAR(1);
DECLARE Var_Control	    	VARCHAR(100);
DECLARE Var_DetecNoDeseada	    CHAR(1);	-- Valida la activacion del proceso de personas no deseadas
DECLARE Var_RFCOficial			CHAR(13);	-- RFC de la persona
DECLARE	Var_TipoPersCliente		CHAR(1);	-- Tipo de Persona Fisica, Fisica Act. Empresarial y Moral
DECLARE Var_CuentasClabes		INT(11);
DECLARE Var_CuentaClabe 		VARCHAR(20);
DECLARE Var_NumIntentos			INT(11);
DECLARE Var_Contador   			INT(11);
DECLARE Entero_Uno			INT(11);
DECLARE	Var_ParticipaSpei		CHAR(1);	-- Indica si la cuenta participa para spei
DECLARE Var_DepositoActiva		CHAR(1);	-- Indica si el tipo de cuenta requiere un deposito para activarla S= si, N= no
DECLARE Var_MontoDepositoActiva	DECIMAL(18,2); -- Si requiere un deposito para activar la cuenta, se indica el monto del deposito

-- asignacion de Constantes
SET	Estatus_Registrada		:= 'R';
SET	Cadena_Vacia			:= '';
SET	Fecha_Vacia			    := '1900-01-01';
SET	Entero_Cero			    := 0;
SET	Edo_Domicilio			:= 'D';
SET	Edo_Internet			:= 'I';
SET	Edo_Sucursal			:= 'S';
SET TipoBancaria 			:= 'S';
SET Var_SI	 			    := 'S';
SET Var_NO	 			    := 'N';
SET ClienteInactivo  	    := 'I';
SET Decimal_Cero		    :=0.00;
SET siReqAportacionSoc	    :='S';
SET TipoCuentaNO            := 'N';
SET Si					    :='S';
SET Estatus_Cancelada	    :='C';
SET	Salida_SI				:= 'S';
SET	Salida_NO				:= 'N';
-- asignacion de variables
SET	NumCuentaAho		    := '';
SET	NumCuentaAhoID		    := 0;
SET	Verifica				:= 0;
SET	i					    := 1;
SET	j					    := 5;
SET	consecutivo			    := 0;
SET	Modulo2				    := 1;
SET Per_MenorEdad		    := 'E';
SET VarEsMenorEdad 		    := 'S';
SET ClienteNUno     		:= 'L';
SET	Per_Moral				:= 'M';
SET Per_Emp					:= 'A';
SET Per_Fisica				:= 'F';
SET Entero_Uno				:= 1;
SET Var_NumIntentos			:= 3;
SET InstrumentoCH			:= 'CH';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-CUENTASAHOALT');
				SET Var_Control = 'SQLEXCEPTION';
			END;

	SELECT EsMenorEdad, Clasificacion, Estatus
		INTO Var_EsSocioMenor, Var_ClienteNUno, Var_Estatus
		FROM CLIENTES
			WHERE ClienteID 	= Par_ClienteID;

	SELECT ReqAportacionSo, MontoAportacion
		INTO Var_ReqAportSocio, Var_MontoAportacion
		FROM PARAMETROSSIS;


	SET Var_ReqAportSocio 	:=IFNULL(Var_ReqAportSocio,Cadena_Vacia);
	SET Var_MontoAportacion	:=IFNULL(Var_MontoAportacion,Decimal_Cero);
	SET Var_EsSocioMenor	:=IFNULL(Var_EsSocioMenor, Cadena_Vacia);
	SET Var_ClienteNUno		:=IFNULL(Var_ClienteNUno, Cadena_Vacia);
	SET Var_Estatus			:=IFNULL(Var_Estatus, Cadena_Vacia);

	IF (Var_Estatus = ClienteInactivo) THEN

		SET	Par_NumErr 	:= 1;
		SET	Par_ErrMen 	:= 'El Cliente Seleccionado esta Inactivo.';
		SET Var_Control := 'clienteID';

		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_SucursalID, Entero_Cero))= Entero_Cero THEN

		SET	Par_NumErr 	:= 2;
		SET	Par_ErrMen 	:= 'El numero de Sucursal esta Vacio.';
		SET Var_Control := 'sucursalID';

		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_ClienteID, Entero_Cero))= Entero_Cero THEN

		SET	Par_NumErr 	:= 3;
		SET	Par_ErrMen 	:=  'El numero de Cliente esta Vacio.';
		SET Var_Control := 'clienteID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MonedaID, Entero_Cero))= Entero_Cero THEN

		SET	Par_NumErr 	:= 4;
		SET	Par_ErrMen 	:=  'La Moneda esta Vacia.';
		SET Var_Control := 'monedaID';

		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipoCuentaID, Entero_Cero))= Entero_Cero THEN

		SET	Par_NumErr 	:= 5;
		SET	Par_ErrMen 	:= 'El Tipo de Cuenta esta Vacio.';
		SET Var_Control := 'tipoCuentaID';

		LEAVE ManejoErrores;
	END IF;


	IF(IFNULL(Par_FechaReg,Fecha_Vacia)) = Fecha_Vacia THEN

		SET	Par_NumErr 	:= 6;
		SET	Par_ErrMen 	:= 'La Fecha esta Vacia.';
		SET Var_Control := 'fechaReg';

		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Etiqueta,Cadena_Vacia)) = Cadena_Vacia THEN

		SET	Par_NumErr 	:= 7;
		SET	Par_ErrMen 	:= 'La Etiqueta esta Vacia.';
		SET Var_Control := 'etiqueta';

		LEAVE ManejoErrores;
	END IF;

	IF(EXISTS(SELECT esBancaria
	            FROM TIPOSCUENTAS
	            WHERE TipoCuentaID 	= Par_TipoCuentaID
	              AND esBancaria 	= TipoBancaria))THEN

	    IF(IFNULL(Par_Clabe,Cadena_Vacia))= Cadena_Vacia THEN

			SET	Par_NumErr 	:= 9;
			SET	Par_ErrMen 	:= 'Especifique la Clabe.';
			SET Var_Control := 'Clabe';

			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_InstitucionID,Entero_Cero))= Entero_Cero THEN

			SET	Par_NumErr 	:= 10;
			SET	Par_ErrMen 	:= 'Especifique el Banco.';
			SET Var_Control := 'InstitucionID';

			LEAVE ManejoErrores;

		END IF;

	END IF;

	IF(IFNULL(Par_EsPrincipal,Cadena_Vacia)) = Cadena_Vacia THEN

		SET	Par_NumErr 	:= 11;
		SET	Par_ErrMen 	:= 'Especifique si es Cuenta Principal';
		SET Var_Control := 'esPrincipal';

		LEAVE ManejoErrores;
	ELSE

		IF(IFNULL(Par_EsPrincipal,Cadena_Vacia)) = Var_SI THEN

			SELECT EsPrincipal
				INTO var_Principal
				FROM CUENTASAHO
				WHERE 	ClienteID 		= Par_ClienteID
				  AND 	EsPrincipal 	= Var_SI
				  AND 	Estatus 		<> Estatus_Cancelada;

			IF(IFNULL(var_Principal,Cadena_Vacia)) = Var_SI THEN

				SET	Par_NumErr 	:= 12;
				SET	Par_ErrMen 	:= 'No puede tener dos cuentas Principal';
				SET Var_Control := 'esPrincipal';

				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;

	IF(IFNULL(Par_EdoCta,Cadena_Vacia)) = Cadena_Vacia THEN

		SET	Par_NumErr 	:= 13;
		SET	Par_ErrMen 	:= 'Especifique forma Estado Cuenta.' ;
		SET Var_Control := 'edoCta';

		LEAVE ManejoErrores;
	END IF;


	IF (Par_EdoCta != Edo_Domicilio
			AND Par_EdoCta != Edo_Internet
			AND Par_EdoCta != Edo_Sucursal) THEN

		SET	Par_NumErr 	:= 14;
		SET	Par_ErrMen 	:= 'Estado de Cuenta no valido.' ;
		SET Var_Control := 'periodicidad';

		LEAVE ManejoErrores;
	END IF;


	IF( var_ReqAportSocio = siReqAportacionSoc  AND  Var_ClienteNUno != ClienteNUno)THEN
		SELECT Saldo INTO Var_Saldo
			FROM APORTACIONSOCIO
				WHERE ClienteID=Par_ClienteID;

		SET Var_Saldo := IFNULL(Var_Saldo,Decimal_Cero);
		IF(Var_Saldo < Var_MontoAportacion AND  Var_EsSocioMenor != Si)THEN

			SET	Par_NumErr := 15;
			SET	Par_ErrMen := CONCAT('El socio ',Par_ClienteID,' no ha depositado el total de la Aportacion Social');
			SET Var_Control := 'clienteID';

			LEAVE ManejoErrores;
		END IF;
	END IF;

    IF (Var_EsSocioMenor = VarEsMenorEdad ) THEN
        SELECT CASE WHEN cta.TipoPersona LIKE CONCAT('%',Per_MenorEdad,'%')
        			AND cli.EsMenorEdad = VarEsMenorEdad  THEN 'S' ELSE 'N'
            END AS Permite
            INTO Var_TipoPersona
        FROM TIPOSCUENTAS cta, CLIENTES cli
        WHERE cli.ClienteID = Par_ClienteID
          AND TipoCuentaID 	= Par_TipoCuentaID;
    ELSE
        SELECT CASE WHEN cta.TipoPersona LIKE CONCAT('%', cli.TipoPersona,'%') THEN 'S' ELSE 'N'
                END AS Permite
                INTO Var_TipoPersona
        FROM TIPOSCUENTAS cta, CLIENTES cli
        WHERE cli.ClienteID = Par_ClienteID
          AND TipoCuentaID 	= Par_TipoCuentaID;
    END IF;
    IF (Var_TipoPersona = TipoCuentaNO)THEN

		SET	Par_NumErr := 17;
		SET	Par_ErrMen := CONCAT('El Tipo de Cuenta no esta permitido para la Personalidad del Cliente.' );
		SET Var_Control := 'cuentaAhoID';

		LEAVE ManejoErrores;

    END IF;

	/*INICIO VALIDACION PERSONAS NO DESEADAS*/
		SET Var_DetecNoDeseada := IFNULL((SELECT  PersonNoDeseadas FROM PARAMETROSSIS LIMIT 1),Var_NO);
        IF(Var_DetecNoDeseada = Var_SI) THEN
			SELECT	Cli.TipoPersona
				INTO	Var_TipoPersCliente
				FROM	CLIENTES Cli,
						SUCURSALES Suc
				WHERE 	Cli.ClienteID 	= Par_ClienteID
				AND		Suc.SucursalID 	= Cli.SucursalOrigen;
                
			IF(Var_TipoPersCliente = Per_Moral) THEN 
				SELECT 	Cli.RFCpm
				INTO 	Var_RFCOficial FROM	CLIENTES Cli,	SUCURSALES Suc
				WHERE 	Cli.ClienteID 	= Par_ClienteID
				AND		Suc.SucursalID 	= Cli.SucursalOrigen;
			END IF;
        
			IF(Var_TipoPersCliente = Per_Fisica OR Var_TipoPersona = Per_Emp ) THEN 
				SELECT 	Cli.RFC
				INTO 	Var_RFCOficial FROM	CLIENTES Cli,	SUCURSALES Suc
				WHERE 	Cli.ClienteID 	= Par_ClienteID
				AND		Suc.SucursalID 	= Cli.SucursalOrigen;
			END IF;
        
			CALL PLDDETECPERSNODESEADASPRO(
				Entero_Cero,	Var_RFCOficial,	Var_TipoPersCliente,	Salida_NO,	Par_NumErr,					
                Par_ErrMen,				Par_EmpresaID,				Aud_Usuario,	Aud_FechaActual,	
				Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

			IF(Par_NumErr!=Entero_Cero)THEN
				SET Par_NumErr			:= 050;
				SET Par_ErrMen			:= Par_ErrMen;	
				LEAVE ManejoErrores;
			END IF;
		END IF;
        /*FIN VALIDACION PERSONAS NO DESEADAS*/

	SELECT GeneraInteres INTO Var_GenInte
		FROM TIPOSCUENTAS
		WHERE TipoCuentaID = Par_TipoCuentaID;


	IF(Var_GenInte = Var_SI) THEN
		SELECT  TA.Tasa INTO Var_Tasa
		FROM 	TASASAHORRO   TA INNER JOIN  TIPOSCUENTAS TC ON TA.TipoCuentaID = TC.TipoCuentaID,
				CLIENTES CL
		WHERE  	CL.ClienteID       = Par_ClienteID
		  AND 	TA.TipoCuentaID    = Par_TipoCuentaID
		  AND   TA.MonedaID        = Par_MonedaID
		  AND   TA.TipoPersona     = CL.TipoPersona
		  AND   TA.MontoInferior  <= TC.MinimoApertura
		  AND   TA.MontoSuperior  >= TC.MinimoApertura;


		SET Var_GAT := FUNCIONCALCTAGATAHO(Par_FechaReg,Par_FechaReg,Var_Tasa);



		SELECT InflacionProy INTO Var_Inflacion
			FROM INFLACIONACTUAL
			WHERE FechaActualizacion =(SELECT MAX(FechaActualizacion) FROM INFLACIONACTUAL);

		SET Var_GATReal := FUNCIONCALCGATREAL(Var_GAT,Var_Inflacion);
	ELSE
	    SET Var_GAT 	:= Decimal_Cero;
	    SET Var_GATReal := Decimal_Cero;

	END IF;

	CALL FOLIOSSUCAPLICACT(
	    'CUENTASAHO', Par_SucursalID, consecutivo);

	SET NumCuentaAho := CONCAT((SELECT LPAD(Par_SucursalID,3,0)),(SELECT LPAD(consecutivo,7,0)));


	WHILE i <= 10 DO
		SET Verifica :=  Verifica +  (CONVERT((SUBSTRING(NumCuentaAho,i,1)),UNSIGNED INT) * j);
		SET j := j - 1;
	      SET i := i + 1;
		IF (j = 1) THEN
			SET j := 7;
		END IF;
	END WHILE;

	SET Modulo2 := Verifica % 11;

	IF (Modulo2 = 0) THEN
		SET Verifica = 1;
	ELSE
		IF (Modulo2 = 1) THEN
			SET Verifica = 0;
		ELSE
			SET Verifica = 11 - Modulo2;
		END IF;
	END IF;

	SET NumVerificador := LTRIM(RTRIM(CONVERT(Verifica, CHAR)));

	SET NumCuentaAhoID := CONCAT(NumCuentaAho,NumVerificador);




	 IF EXISTS(SELECT EmpresaID
	          FROM PARAMETROSSPEI) THEN

		SELECT EsBancaria,		ParticipaSpei
		INTO  Var_EsBancaria, 	Var_ParticipaSpei
		FROM TIPOSCUENTAS
		WHERE TipoCuentaID = Par_TipoCuentaID;


		IF (Var_EsBancaria = Var_NO AND Var_ParticipaSpei = Var_SI) THEN
			SET Par_Clabe := Cadena_Vacia;
        	SET Var_Contador = Entero_Cero;
			/* Se deja en 3 intentos para crear una cuenta clabe */
			LoopCuentas: WHILE Var_Contador < Var_NumIntentos DO 
			
				SET Var_Contador := Var_Contador + Entero_Uno;
				SELECT	Cli.TipoPersona
					INTO	Var_TipoPersCliente
					FROM	CLIENTES Cli,
							SUCURSALES Suc
					WHERE 	Cli.ClienteID 	= Par_ClienteID
					AND		Suc.SucursalID 	= Cli.SucursalOrigen;

				CALL GENERACLABEPRO(
					 	Var_TipoPersCliente,	Par_Clabe,			Var_NO,				Par_NumErr,			Par_ErrMen, 		
						Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,		 	Aud_NumTransaccion);
				
				IF(Par_NumErr = Entero_Cero)THEN
					LEAVE LoopCuentas;
				END IF;
			END WHILE LoopCuentas;

			IF(Par_NumErr != Entero_Cero)THEN
				SET Par_NumErr	:= 50;
				SET Par_ErrMen	:= CONCAT('La Cuenta CLABE no puede estar vacia.');
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;

	

	SET Aud_FechaActual := CURRENT_TIMESTAMP();

	INSERT INTO CUENTASAHO (
			CuentaAhoID,	 	SucursalID, 		ClienteID ,		Clabe,				MonedaID,
			Gat,       			TipoCuentaID,		FechaReg,		Etiqueta,			Estatus,
			SaldoDispon,		Saldo,				SaldoBloq,		SaldoSBC,	    	SaldoIniMes,
	     	CargosMes,			AbonosMes,			Comisiones,		SaldoProm,		    TasaInteres,
			InteresesGen,		ISR,				TasaISR,		SaldoIniDia,	    CargosDia,
			AbonosDia,			EstadoCta, 			InstitucionID,	EsPrincipal,	    GatReal,
	        TelefonoCelular,    MontoDepInicial,	FechaDepInicial,EmpresaID,	    	Usuario,
            FechaActual,		DireccionIP,		ProgramaID,		Sucursal,			NumTransaccion)
		VALUES (
			NumCuentaAhoID,		Par_SucursalID,		Par_ClienteID ,		Par_Clabe,				Par_MonedaID,
			Var_GAT,            Par_TipoCuentaID,	Par_FechaReg,		Par_Etiqueta,			Estatus_Registrada,
			Entero_Cero,		Entero_Cero,		Entero_Cero,		Entero_Cero,		    Entero_Cero,
			Entero_Cero,		Entero_Cero,		Entero_Cero,		Entero_Cero,		    Entero_Cero,
			Entero_Cero,        Entero_Cero,		Entero_Cero,		Entero_Cero,		    Entero_Cero,
			Entero_Cero,		Par_EdoCta,     	Par_InstitucionID,  Par_EsPrincipal,	    Var_GATReal,
			Par_TelefonoCelular,Decimal_Cero,		Fecha_Vacia,		Par_EmpresaID,			Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);


	IF (Var_EsBancaria = Var_NO AND Var_ParticipaSpei = Var_SI) THEN
		CALL BITASPEICUENTASCLABEPRO(
			Par_ClienteID,		Par_Clabe,			InstrumentoCH,		NumCuentaAhoID, 	'FIRMA PENDIENTE POR AUTORIZAR',
			Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN 
			LEAVE ManejoErrores;
		END IF;
	END IF;

    -- INICIO DEPOSITO ACTIVACION CUENTA
    SELECT DepositoActiva,	MontoDepositoActiva
		INTO Var_DepositoActiva, Var_MontoDepositoActiva
    FROM TIPOSCUENTAS
    WHERE TipoCuentaID = Par_TipoCuentaID;

	-- SI EL TIPO DE CUENTA REQUIERE UN DEPOSITO PARA ACTIVACION DE CUENTA
    IF(IFNULL(Var_DepositoActiva,Var_NO) = Var_SI )THEN

        CALL DEPOSITOACTIVACTAAHOALT(
			NumCuentaAhoID,		Var_MontoDepositoActiva,
            Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
        );

        IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

    END IF;
    -- FIN DEPOSITO ACTIVACION CUENTA
	
	SET	Par_NumErr 	:= 0;
	SET	Par_ErrMen 	:= CONCAT("safilocale.ctaAhorro Agregada Exitosamente: ", CONVERT(NumCuentaAhoID, CHAR));
	SET Var_Control := 'cuentaAhoID';
    SET Par_CuentaAho := NumCuentaAhoID;


	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_CuentaAho AS Consecutivo;
	END IF;


END TerminaStore$$
