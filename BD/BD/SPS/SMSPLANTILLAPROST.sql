-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSPLANTILLAPROST
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSPLANTILLAPROST`;
DELIMITER $$

CREATE PROCEDURE `SMSPLANTILLAPROST`(
# =====================================================================================
#	STORE PARA FORMAR LOS MENSAJES CON BASE AL MENSAJE DE LA PLANTILLA
# =====================================================================================
	Par_NumIdentificador	BIGINT(20),
	INOUT Par_Mensaje		VARCHAR(400),
	Par_Receptor			VARCHAR(45),
	Par_NumCon				TINYINT UNSIGNED,

	Par_Salida				CHAR(1),				-- Salida S:Si No:No
	INOUT Par_NumErr		INT(11),				-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),			-- Mensaje de error

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_Nombre              VARCHAR(100);
	DECLARE Var_Credito             BIGINT(12);
	DECLARE Var_NombreSucursal      VARCHAR(50);
	DECLARE Var_Cuenta              BIGINT(12);
	DECLARE Var_SolicitudCredito	BIGINT(20);
	DECLARE Var_MontoCredito        DECIMAL(12,2);
	DECLARE Var_TotAdeudo           VARCHAR(30);
	DECLARE Var_MontoExigible       VARCHAR(30);
	DECLARE Var_FechaExigible   	VARCHAR(30);
    DECLARE Var_SaldoCapital		VARCHAR(30);
	DECLARE Var_DiasAtraso          INT;
	DECLARE Var_Enviar              CHAR(1);
	DECLARE Var_Encontrado			CHAR(1);
	DECLARE Var_Control				VARCHAR(100);  	-- Variable de control

	-- Declaracion de constantes
	DECLARE Cadena_Vacia            CHAR(1);
	DECLARE Entero_Cero             INT(11);
	DECLARE Con_EstatusVig         	CHAR(1);
	DECLARE Con_EstatusVen         	CHAR(1);
	DECLARE Con_EsPrincipal        	CHAR(1);
	DECLARE Con_ProFecPag          	INT;
	DECLARE Fecha_Vacia         	DATE;
	DECLARE Con_Decimal         	DECIMAL;
	DECLARE Aud_FechaActual     	DATE;
	DECLARE Estatus_Pagado          CHAR(1);
	DECLARE NoEncontrado            INT;
	DECLARE SalidaSI				CHAR(1);		-- Indica si la salida esta permitida
	DECLARE	Con_ConIndenti			INT(11);		-- Tipo de Consulta Con Numero Identificador
	DECLARE	Con_SinIndenti			INT(11);		-- TIpo de Consulta Sin Numero Identificador
	DECLARE Con_ActivaCuenta		INT(11);		-- Tipo de consulta Activacion de cuenta

	-- Asignacion de constantes
	SET Cadena_Vacia        		:= '';
	SET Entero_Cero         		:= 0;
	SET Con_EstatusVig      		:= 'V';
	SET Con_EstatusVen      		:= 'B';
	SET Con_EsPrincipal     		:= 'S';
	SET Con_ProFecPag       		:= 9;
	SET Fecha_Vacia         		:= '1900-01-01';
	SET Con_Decimal         		:= 0.00;
	SET Estatus_Pagado      		:= 'P';
	SET NoEncontrado        		:= 0;
    SET	Con_ConIndenti				:= 1;
    SET	Con_SinIndenti				:= 2;
    SET Con_ActivaCuenta			:= 3;

	SELECT EnviarSiNoCoici  INTO Var_Enviar	FROM PARAMETROSSMS;
	SET Var_Enviar		:=IFNULL(Var_Enviar, Cadena_Vacia);
	SET Aud_FechaActual	:= CURRENT_TIMESTAMP();

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CUENTASAHOACT');
		SET Var_Control := 'SQLEXCEPTION' ;
	END;

	# crea tabla temporal para guardar datos de clientes
	DROP TABLE IF EXISTS TMPSMSCLIENTES;
	CREATE TABLE IF NOT EXISTS TMPSMSCLIENTES (
	  ClienteID        	INT(11)			COMMENT 'ID del cliente',
	  PrimerNombre      VARCHAR(50)		COMMENT 'Primer Nombre del cliente',
	  SegundoNombre     VARCHAR(50) 	COMMENT 'Segundo Nombre del cliente',
	  TercerNombre      VARCHAR(50) 	COMMENT 'Tercer Nombre del cliente',
	  ApellidoPaterno   VARCHAR(50) 	COMMENT 'Apellido Paterno del cliente',
	  ApellidoMaterno   VARCHAR(50) 	COMMENT 'Apellido Materno del cliente',
      TelefonoCelular	VARCHAR(20)		COMMENT	'Numero de tel cel de cliente',
      SucursalOrigen	INT(11)			COMMENT 'Sucursal Origen del cliente',
	PRIMARY KEY (ClienteID))
	ENGINE = InnoDB
	DEFAULT CHARACTER SET = LATIN1
	COMMENT = 'Almacena datos temporales del cliente para formar los mensajes de respuesta al cliente.';

	# crea tabla temporal para guardar datos de los creditos del cliente
	DROP TABLE IF EXISTS TMPSMSCREDITOS;
	CREATE TABLE IF NOT EXISTS TMPSMSCREDITOS (
	  ClienteID        	INT(11)			COMMENT 'ID del cliente',
      CreditoID			BIGINT(12)		COMMENT 'ID Credito',
      MontoCredito		DECIMAL(14,2)	COMMENT 'Monto del Credito',
      Estatus			CHAR(1)			COMMENT	'Estatus del Credito',
      FechaAutoriza		DATE			COMMENT	'Fecha de autorizacion del credito',
      FechaActual		DATETIME		COMMENT 'Fecha Actual',
	PRIMARY KEY (ClienteID,CreditoID))
	ENGINE = InnoDB
	DEFAULT CHARACTER SET = LATIN1
	COMMENT = 'Almacena datos temporales de creditos para formar los mensajes de respuesta al cliente.';

	# Inserta datos del cliente segun numero del telefono celular
	INSERT INTO TMPSMSCLIENTES(
				ClienteID,      PrimerNombre,	SegundoNombre,	TercerNombre,	ApellidoPaterno,
				ApellidoMaterno,TelefonoCelular,SucursalOrigen)
	SELECT  	ClienteID,  	PrimerNombre,	SegundoNombre,	TercerNombre,	ApellidoPaterno,
				ApellidoMaterno,TelefonoCelular,SucursalOrigen
		FROM	CLIENTES
		WHERE 	TelefonoCelular	= Par_Receptor;

	# Inserta datos de creditos del cliente segun numero del telefono celular
	INSERT INTO TMPSMSCREDITOS(
				ClienteID,      CreditoID,		MontoCredito,		Estatus,	FechaAutoriza,		FechaActual)
	SELECT  	CR.ClienteID,   CR.CreditoID,	CR.MontoCredito,	CR.Estatus,	CR.FechaAutoriza,	CR.FechaActual
		FROM 	CREDITOS CR INNER JOIN CLIENTES CL
				ON CR.ClienteID = CL.ClienteID
		WHERE 	CL.TelefonoCelular	= Par_Receptor;


	# =====================================================================================
	#	Parte 1: Crea El Nombre del Cliente
    # =====================================================================================
	IF(Par_Mensaje LIKE  '%&CL%'  ) THEN
		SELECT 	CONCAT(IFNULL(PrimerNombre,Cadena_Vacia),' ',IFNULL(SegundoNombre,Cadena_Vacia),' ',IFNULL(TercerNombre,Cadena_Vacia),' ',IFNULL(ApellidoPaterno,Cadena_Vacia),' ',
				IFNULL(ApellidoMaterno,Cadena_Vacia)) INTO Var_Nombre
			FROM TMPSMSCLIENTES
			WHERE	TelefonoCelular	= Par_Receptor;

		IF(IFNULL(Var_Nombre,Cadena_Vacia) =  Cadena_Vacia) THEN
			SET Par_Mensaje := REPLACE(Par_Mensaje,'&CL','CLIENTE');
			SET NoEncontrado:= NoEncontrado + 1;
		ELSE
			SET Par_Mensaje := REPLACE(Par_Mensaje,'&CL',Var_Nombre);
		END IF;
	ELSE
		SET Par_Mensaje := REPLACE(Par_Mensaje,'&CL','CLIENTE');
	END IF;


	# =====================================================================================
	#	Parte 2: Crea la Informacion de la Sucursal del Cliente
    # =====================================================================================
	IF(Par_Mensaje LIKE '%&SU%') THEN
		SELECT  S.NombreSucurs INTO Var_NombreSucursal
			FROM TMPSMSCLIENTES C,
				SUCURSALES S
			WHERE	C.TelefonoCelular	= Par_Receptor
			  AND	C.SucursalOrigen	= S.SucursalID;

		IF(IFNULL(Var_NombreSucursal,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_Mensaje := (REPLACE(Par_Mensaje,'&SU','SUCURSAL'));
			SET NoEncontrado:= NoEncontrado + 1;
		ELSE
			SET Par_Mensaje  :=(REPLACE(Par_Mensaje,'&SU',Var_NombreSucursal));
		END IF;
	ELSE
		SET Par_Mensaje := (REPLACE(Par_Mensaje,'&SU','SUCURSAL'));
	END IF;


    # =====================================================================================
	#	Parte 3: Crea la Informacion de la Cuenta del Cliente
    # =====================================================================================
	IF (Par_NumCon = Con_ActivaCuenta) THEN
		IF(Par_Mensaje LIKE '%&CT%')THEN
			SELECT CA.CuentaAhoID INTO Var_Cuenta
				FROM CUENTASAHO CA,
					TMPSMSCLIENTES C
				WHERE	C.TelefonoCelular	= Par_Receptor
				AND   CA.ClienteID			= C.ClienteID
				AND CA.CuentaAhoID			= Par_NumIdentificador;

			IF (IFNULL(Var_Cuenta, Entero_Cero)= Entero_Cero)THEN
				SET Par_Mensaje		:= (REPLACE(Par_Mensaje,'&CT','CUENTA'));
				SET NoEncontrado	:= NoEncontrado + 1;
			ELSE
				SET Par_Mensaje		:= (REPLACE(Par_Mensaje,'&CT',Var_Cuenta));
			END IF;
		ELSE
			SET Par_Mensaje	:= (REPLACE(Par_Mensaje,'&CT','CUENTA'));
		END IF;
	ELSE
		IF(Par_Mensaje LIKE '%&CT%')THEN
			SELECT CA.CuentaAhoID INTO Var_Cuenta
				FROM CUENTASAHO CA,
			  		TMPSMSCLIENTES C
				WHERE	C.TelefonoCelular	= Par_Receptor
			  	AND   CA.ClienteID		= C.ClienteID
				AND   EsPrincipal			= Con_EsPrincipal;

			IF (IFNULL(Var_Cuenta, Entero_Cero)= Entero_Cero)THEN
				SET Par_Mensaje		:= (REPLACE(Par_Mensaje,'&CT','CUENTA'));
				SET NoEncontrado	:= NoEncontrado + 1;
			ELSE
				SET Par_Mensaje		:= (REPLACE(Par_Mensaje,'&CT',Var_Cuenta));
			END IF;
		ELSE
			SET Par_Mensaje	:= (REPLACE(Par_Mensaje,'&CT','CUENTA'));
		END IF;
	END IF;


    # =====================================================================================
	#	Valida el Tipo de Consulta Si es Individual, Con numero identificador.
	# =====================================================================================
    IF(Par_NumCon = Con_ConIndenti)THEN
			SELECT  C.CreditoID, C.MontoCredito INTO	Var_Credito,	Var_MontoCredito
				FROM  	TMPSMSCREDITOS C,
						TMPSMSCLIENTES S
				WHERE	S.TelefonoCelular	= Par_Receptor
				  AND	S.ClienteID       	= C.ClienteID
                  AND	C.CreditoID			= Par_NumIdentificador
				  AND ( C.Estatus	= Con_EstatusVig OR C.Estatus	= Con_EstatusVen );


		# =====================================================================================
		#	Parte 4: Crea la informacion de Solicitud de Credito
		# =====================================================================================
		IF(Par_Mensaje LIKE '%SL%') THEN
			SELECT SC.SolicitudCreditoID INTO Var_SolicitudCredito
				FROM SOLICITUDCREDITO SC,
					TMPSMSCLIENTES C
				WHERE	C.TelefonoCelular 		= Par_Receptor
				  AND	C.ClienteID				= SC.ClienteID
                  AND	SC.SolicitudCreditoID 	= Par_NumIdentificador;

			IF(IFNULL(Var_SolicitudCredito,Entero_Cero) = Entero_Cero)THEN
				SET Par_Mensaje		:= (REPLACE(Par_Mensaje,'&SL','SOLICITUD DE CREDITO'));
				SET	NoEncontrado	:= NoEncontrado + 1;
			ELSE
				SET Par_Mensaje		:= (REPLACE(Par_Mensaje,'&SL',Var_SolicitudCredito));
			END IF;
		ELSE
			SET Par_Mensaje	:= (REPLACE(Par_Mensaje,'&SL','SOLICITUD DE CREDITO'));
		END IF;

		# =====================================================================================
		#	Parte 4: Crea la informacion del Credito
		# =====================================================================================
		IF(Par_Mensaje LIKE  '%&CR%')THEN

			IF(IFNULL(Var_Credito,Entero_Cero)= Entero_Cero)THEN
				SET Par_Mensaje := REPLACE(Par_Mensaje,'&CR','CREDITO');
				SET NoEncontrado:= NoEncontrado + 1;
			ELSE
				SET Par_Mensaje := REPLACE(Par_Mensaje,'&CR',Var_Credito);
			END IF;
		ELSE
			SET Par_Mensaje := REPLACE(Par_Mensaje,'&CR','CREDITO');
		END IF;

		# =====================================================================================
		#	Parte 5: Crea la informacion del Monto del Credito
		# =====================================================================================
		IF(Par_Mensaje LIKE '%&MC%') THEN

			IF(IFNULL(Var_MontoCredito,Entero_Cero) = Entero_Cero)THEN
				SET Par_Mensaje  := (REPLACE(Par_Mensaje,'&MC','MONTO CREDITO'));
				SET NoEncontrado:=NoEncontrado+1;
			ELSE
				SET Par_Mensaje  := (REPLACE(Par_Mensaje,'&MC',Var_MontoCredito));
			END IF;
		ELSE
			SET Par_Mensaje  := (REPLACE(Par_Mensaje,'&MC','MONTO CREDITO'));
		END IF;


		# =====================================================================================
		#	Parte 6: Crea la informacion del Monto del Proximo Vencimiento
		# =====================================================================================
		IF(Par_Mensaje LIKE '%&MPV%') THEN

			IF(IFNULL(Var_Credito,Entero_Cero)= Entero_Cero)THEN
				SET Par_Mensaje		:= (REPLACE(Par_Mensaje,'&MPV','MONTO DEL PROXIMO VENCIMIENTO'));
				SET NoEncontrado	:= NoEncontrado + 1;
			ELSE

				CALL CREPROXPAGCON(
					Var_Credito,		Con_ProFecPag,	Var_TotAdeudo,	Var_MontoExigible,	Var_FechaExigible,
					Var_SaldoCapital,	Entero_Cero,	Entero_Cero,	Fecha_Vacia,		Cadena_Vacia,
                    Cadena_Vacia,		Entero_Cero,	Entero_Cero);


				IF(IFNULL(Var_MontoExigible,Con_Decimal) = Con_Decimal)THEN
					SET Par_Mensaje		:= (REPLACE(Par_Mensaje,'&MPV','MONTO DEL PROXIMO VENCIMIENTO'));
					SET NoEncontrado	:= NoEncontrado + 1;
				ELSE
					SET Par_Mensaje		:= (REPLACE(Par_Mensaje,'&MPV',Var_MontoExigible));
				END IF;
			END IF;

		ELSE
			SET Par_Mensaje  := (REPLACE(Par_Mensaje,'&MPV','MONTO DEL PROXIMO VENCIMIENTO'));
		END IF;


		# =====================================================================================
		#	Parte 7: Crea la informacion del Saldo del Credito
		# =====================================================================================
		IF(Par_Mensaje LIKE '%&SC%') THEN

			IF(IFNULL(Var_Credito,Entero_Cero)= Entero_Cero)THEN
				SET Par_Mensaje  	:= (REPLACE(Par_Mensaje,'&SC','SALDO DEL CREDITO'));
				SET NoEncontrado	:= NoEncontrado	+ 1;
			ELSE
				CALL CREPROXPAGCON(
					Var_Credito,		Con_ProFecPag,	Var_TotAdeudo,	Var_MontoExigible,	Var_FechaExigible,
					Var_SaldoCapital,	Entero_Cero,	Entero_Cero,	Fecha_Vacia,		Cadena_Vacia,
                    Cadena_Vacia,		Entero_Cero,	Entero_Cero);

				IF(IFNULL(Var_TotAdeudo,Con_Decimal) = Con_Decimal)THEN
					SET NoEncontrado:=NoEncontrado+1;
					SET Par_Mensaje  := (REPLACE(Par_Mensaje,'&SC','SALDO DEL CREDITO'));
				ELSE
					SET Par_Mensaje  := (REPLACE(Par_Mensaje,'&SC',Var_TotAdeudo));
				END IF;
			END IF;
		ELSE
			SET Par_Mensaje  := (REPLACE(Par_Mensaje,'&SC','SALDO DEL CREDITO'));
		END IF;

		# =====================================================================================
		#	Parte 8: Crea la informacion de la Fecha del Proximo Vencimiento
		# =====================================================================================
		IF(Par_Mensaje LIKE '%&FPV%') THEN

			IF(IFNULL(Var_Credito,Entero_Cero)= Entero_Cero)THEN
				SET Par_Mensaje  	:= (REPLACE(Par_Mensaje,'&FPV','FECHA DEL PROXIMO VENCIMIENTO'));
				SET NoEncontrado	:=	NoEncontrado + 1;
			ELSE
				CALL CREPROXPAGCON(
					Var_Credito,		Con_ProFecPag,	Var_TotAdeudo,	Var_MontoExigible,	Var_FechaExigible,
					Var_SaldoCapital,	Entero_Cero,	Entero_Cero,	Fecha_Vacia,		Cadena_Vacia,
                    Cadena_Vacia,		Entero_Cero,	Entero_Cero);

				IF(IFNULL(Var_FechaExigible,Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_Mensaje  	:= (REPLACE(Par_Mensaje,'&FPV','FECHA DEL PROXIMO VENCIMIENTO'));
					SET NoEncontrado	:= NoEncontrado + 1;
				ELSE
					SET Par_Mensaje		:= (REPLACE(Par_Mensaje,'&FPV',Var_FechaExigible));
				END IF;
			END IF;
		ELSE
			SET Par_Mensaje	:= (REPLACE(Par_Mensaje,'&FPV','FECHA DEL PROXIMO VENCIMIENTO'));
		END IF;

		# =====================================================================================
        #	Parte 8: Crea la informacion de los Dias de Atraso
		# =====================================================================================
		IF(Par_Mensaje LIKE '%&DA%') THEN

            SELECT  DATEDIFF(Aud_FechaActual,IFNULL(MIN(FechaExigible), Aud_FechaActual))  INTO Var_DiasAtraso
				FROM AMORTICREDITO Amo
				WHERE	Amo.CreditoID 		= Var_Credito
				  AND	Amo.Estatus			!= Estatus_Pagado
				  AND	Amo.FechaExigible 	<= Aud_FechaActual;

			IF(IFNULL(Var_DiasAtraso,Entero_Cero) = Entero_Cero)THEN
				SET Par_Mensaje  := (REPLACE(Par_Mensaje,'&DA','DIAS DE ATRASO'));
				SET NoEncontrado:=NoEncontrado+1;
			ELSE
				SET Par_Mensaje  := (REPLACE(Par_Mensaje,'&DA', Var_DiasAtraso));
			END IF;
		ELSE
			SET Par_Mensaje  := (REPLACE(Par_Mensaje,'&DA','DIAS DE ATRASO'));
		END IF;
	END IF;

	# =====================================================================================
	#	Valida el Tipo de Consulta Sin numero identificador
	# =====================================================================================
    IF(Par_NumCon = Con_SinIndenti)THEN

		# =====================================================================================
		#	Forma la Informacion de los Creditos que un Ciente Tenga
		# =====================================================================================

		SELECT		CreditoID,	MontoCredito	INTO	Var_Credito,	Var_MontoCredito
			FROM 	TMPSMSCREDITOS C INNER JOIN TMPSMSCLIENTES S
			WHERE	S.TelefonoCelular	= Par_Receptor
			AND		S.ClienteID       	= C.ClienteID
			AND 	( C.Estatus	= Con_EstatusVig OR C.Estatus	= Con_EstatusVen)
			ORDER BY C.FechaAutoriza DESC, C.FechaActual DESC
			LIMIT 1;

		# =====================================================================================
		#	Parte 4: Crea la informacion del Credito
		# =====================================================================================
		IF(Par_Mensaje LIKE  '%&CR%')THEN
			IF(IFNULL(Var_Credito,Entero_Cero)= Entero_Cero)THEN
				SET Par_Mensaje := REPLACE(Par_Mensaje,'&CR','CREDITO');
				SET NoEncontrado:= NoEncontrado + 1;
			ELSE
				SET Par_Mensaje := REPLACE(Par_Mensaje,'&CR',Var_Credito);
			END IF;
		ELSE
			SET Par_Mensaje := REPLACE(Par_Mensaje,'&CR','CREDITO');
		END IF;

		# =====================================================================================
		#	Parte 5: Crea la informacion del Monto del Credito
		# =====================================================================================
		IF(Par_Mensaje LIKE '%&MC%') THEN
			IF(IFNULL(Var_MontoCredito,Entero_Cero) = Entero_Cero)THEN
				SET Par_Mensaje  	:= (REPLACE(Par_Mensaje,'&MC','MONTO CREDITO'));
				SET NoEncontrado	:= NoEncontrado + 1;
			ELSE
				SET Par_Mensaje  := (REPLACE(Par_Mensaje,'&MC',Var_MontoCredito));
			END IF;
		ELSE
			SET Par_Mensaje  := (REPLACE(Par_Mensaje,'&MC','MONTO CREDITO'));
		END IF;

		# =====================================================================================
		#	Parte 6: Crea la informacion del Monto del Proximo Vencimiento
		# =====================================================================================
		IF(Par_Mensaje LIKE '%&MPV%') THEN
			IF(IFNULL(Var_Credito,Entero_Cero)= Entero_Cero)THEN
				SET Par_Mensaje		:= (REPLACE(Par_Mensaje,'&MPV','MONTO DEL PROXIMO VENCIMIENTO'));
				SET NoEncontrado	:= NoEncontrado + 1;
			ELSE

				CALL CREPROXPAGCON(
					Var_Credito,		Con_ProFecPag,	Var_TotAdeudo,	Var_MontoExigible,	Var_FechaExigible,
					Var_SaldoCapital,	Entero_Cero,	Entero_Cero,	Fecha_Vacia,		Cadena_Vacia,
                    Cadena_Vacia,		Entero_Cero,	Entero_Cero);

				IF(IFNULL(Var_MontoExigible,Con_Decimal) = Con_Decimal)THEN
					SET Par_Mensaje		:= (REPLACE(Par_Mensaje,'&MPV','MONTO DEL PROXIMO VENCIMIENTO'));
					SET NoEncontrado	:= NoEncontrado + 1;
				ELSE
					SET Par_Mensaje		:= (REPLACE(Par_Mensaje,'&MPV',Var_MontoExigible));
				END IF;
			END IF;

		ELSE
			SET Par_Mensaje  := (REPLACE(Par_Mensaje,'&MPV','MONTO DEL PROXIMO VENCIMIENTO'));
		END IF;


		# =====================================================================================
		#	Parte 7: Crea la informacion del Saldo del Credito
		# =====================================================================================
		IF(Par_Mensaje LIKE '%&SC%') THEN
			IF(IFNULL(Var_Credito,Entero_Cero)= Entero_Cero)THEN
				SET Par_Mensaje  	:= (REPLACE(Par_Mensaje,'&SC','SALDO DEL CREDITO'));
				SET NoEncontrado	:= NoEncontrado	+ 1;
			ELSE
				CALL CREPROXPAGCON(
					Var_Credito,		Con_ProFecPag,	Var_TotAdeudo,	Var_MontoExigible,	Var_FechaExigible,
					Var_SaldoCapital,	Entero_Cero,	Entero_Cero,	Fecha_Vacia,		Cadena_Vacia,
                    Cadena_Vacia,		Entero_Cero,	Entero_Cero);

				IF(IFNULL(Var_TotAdeudo,Con_Decimal) = Con_Decimal)THEN
					SET NoEncontrado:=NoEncontrado+1;
					SET Par_Mensaje  := (REPLACE(Par_Mensaje,'&SC','SALDO DEL CREDITO'));
				ELSE
					SET Par_Mensaje  := (REPLACE(Par_Mensaje,'&SC',Var_TotAdeudo));
				END IF;
			END IF;
		ELSE
			SET Par_Mensaje  := (REPLACE(Par_Mensaje,'&SC','SALDO DEL CREDITO'));
		END IF;

		# =====================================================================================
		#	Parte 8: Crea la informacion de la Fecha del Proximo Vencimiento
		# =====================================================================================
		IF(Par_Mensaje LIKE '%&FPV%') THEN
			IF(IFNULL(Var_Credito,Entero_Cero)= Entero_Cero)THEN
				SET Par_Mensaje  	:= (REPLACE(Par_Mensaje,'&FPV','FECHA DEL PROXIMO VENCIMIENTO'));
				SET NoEncontrado	:=	NoEncontrado + 1;
			ELSE
				CALL CREPROXPAGCON(
					Var_Credito,		Con_ProFecPag,	Var_TotAdeudo,	Var_MontoExigible,	Var_FechaExigible,
					Var_SaldoCapital,	Entero_Cero,	Entero_Cero,	Fecha_Vacia,		Cadena_Vacia,
                    Cadena_Vacia,		Entero_Cero,	Entero_Cero);

				IF(IFNULL(Var_FechaExigible,Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_Mensaje  	:= (REPLACE(Par_Mensaje,'&FPV','FECHA DEL PROXIMO VENCIMIENTO'));
					SET NoEncontrado	:= NoEncontrado + 1;
				ELSE
					SET Par_Mensaje		:= (REPLACE(Par_Mensaje,'&FPV',Var_FechaExigible));
				END IF;
			END IF;
		ELSE
			SET Par_Mensaje	:= (REPLACE(Par_Mensaje,'&FPV','FECHA DEL PROXIMO VENCIMIENTO'));
		END IF;

		# =====================================================================================
		#	Parte 8: Crea la informacion de los Dias de Atrazo
		# =====================================================================================
		IF(Par_Mensaje LIKE '%&DA%') THEN
			SELECT  DATEDIFF(Aud_FechaActual,IFNULL(MIN(FechaExigible), Aud_FechaActual))  INTO Var_DiasAtraso
				FROM AMORTICREDITO Amo
				WHERE	Amo.CreditoID 		= Var_Credito
				  AND	Amo.Estatus			!= Estatus_Pagado
				  AND	Amo.FechaExigible 	<= Aud_FechaActual;

			IF(IFNULL(Var_DiasAtraso,Entero_Cero) = Entero_Cero)THEN
				SET Par_Mensaje  	:= (REPLACE(Par_Mensaje,'&DA','DIAS DE ATRASO'));
				SET NoEncontrado	:= NoEncontrado	+	1;
			ELSE
				SET Par_Mensaje  	:= (REPLACE(Par_Mensaje,'&DA', Var_DiasAtraso));
			END IF;
		ELSE
			SET Par_Mensaje  := (REPLACE(Par_Mensaje,'&DA','DIAS DE ATRASO'));
		END IF;
	END IF;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
	SELECT	Par_Mensaje		AS MensajeRepuesta,
			NoEncontrado,
			Var_Enviar 		AS EnviarSi;
END IF;

END TerminaStore$$