-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOACT`;
DELIMITER $$

CREATE PROCEDURE `CUENTASAHOACT`(
	-- SP para actualizar las cuentas de ahorro
	Par_CuentaAhoID			BIGINT(12),				-- Cuenta de ahorro
	Par_UsuarioID			INT(11),				-- Usuario ID que autoriza
	Par_Fecha				DATE,					-- Fecha
	Par_Motivo				VARCHAR(100),			-- Motivo
	Par_NumAct				TINYINT UNSIGNED,		-- Numero de Actualizacion Apertura:1 Bloqueo:2 Desbloqueo:3 Cancelacion:4

	Par_Salida				CHAR(1),				-- Salida S:Si No:No
	INOUT Par_NumErr		INT(11),				-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),			-- Mensaje de error
	-- Auditoria
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_SaldoDisponible DECIMAL(14,2);
	DECLARE Var_SaldoBloqueado 	DECIMAL(14,2);
	DECLARE Var_SaldoSBC		DECIMAL(14,2);
	DECLARE Var_IdentificID		INT;
	DECLARE Var_EstatusCredito	CHAR(1);
	DECLARE	Var_Estatus			CHAR(1);
	DECLARE Var_CreditoID		BIGINT(20);
	DECLARE Var_EstatusCli		CHAR(1);
	DECLARE Var_Cliente			INT(11);
	DECLARE Var_EdadCliente		INT(11);
	DECLARE Var_IdeOficial		CHAR(1);
	DECLARE Var_DirOficial		CHAR(1);
	DECLARE Var_NoConociCte		INT(11);
	DECLARE Var_NoConociCta		BIGINT(12);
	DECLARE Var_NoTitular		INT(11);
	DECLARE Var_RelCuenta 		CHAR(1);
	DECLARE Var_RegFirmas 		CHAR(1);
	DECLARE Var_HuellasFir 		CHAR(1);
	DECLARE Var_ConCuenta 		CHAR(1);
	DECLARE Var_RelCta		    BIGINT(12);
	DECLARE Var_FirCta		    BIGINT(12);
	DECLARE Var_TipoPersona 	CHAR(1);
	DECLARE Var_PersonaID       INT(11);
	DECLARE Var_ChecListCte		CHAR(1);
	DECLARE Var_NoAceptado		INT(11);
	DECLARE Var_FunHuella		CHAR(1);
	DECLARE Var_ReqHuella		CHAR(1);
	DECLARE Var_Control	    	VARCHAR(100);  	-- Variable de control
	DECLARE Var_Consecutivo		BIGINT(20);     -- Variable consecutivo
    DECLARE Var_ValidaEstCivil	CHAR(1);     	-- Variable para almacenar si se valida el estado civil o no
    DECLARE Var_EstCivilCliente	VARCHAR(5);     -- Variable para almacenar el estado civil del cliente
    DECLARE Var_ExiDatosConyu	CHAR(1);     	-- Variable para almacenar si el cliente tiene datos del conyuge registrados
	DECLARE Var_DetecNoDeseada	    CHAR(1);	-- Variable que valida el proceso de personas no deseadas
	DECLARE Var_RFCOficial			CHAR(13);	-- RFC de la Persona
	DECLARE	Var_TipoPersCliente		CHAR(1);	-- Tipo Persona Fisica, Fisica Act. Empresarial y Moral
	DECLARE	Var_NotificaSMS			CHAR(1);	-- Identifica si el tipo de cuenta permite el envio de mensaje de bienvenida
	DECLARE Var_EstatusDepositoActiva INT(11);	-- Estatus del deposito de activacion
    DECLARE Var_datosConyuge		CHAR(1);		-- Variable para almacenar si son obligatirios los datos del conyuge
    DECLARE Var_obligaDatoConyuge	CHAR(1);

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Act_Apertura		INT;
	DECLARE	Act_AperturaWsCrcb	INT;
	DECLARE	Act_Bloqueo			INT;
	DECLARE	Act_Cancelacion		INT;
	DECLARE	Act_Desbloqueo		INT;
	DECLARE	Estatus_Activa		CHAR(1);
	DECLARE	Estatus_Bloqueada	CHAR(1);
	DECLARE	Estatus_Cancelada	CHAR(1);
	DECLARE	Estatus_Desbloqueada	CHAR(1);
	DECLARE	Estatus_Registrada	CHAR(1);
	DECLARE	Est_Vigente			CHAR(1);
	DECLARE Est_Vencido			CHAR(1);
	DECLARE	Est_Autorizado		CHAR(1);
	DECLARE Est_Inactiva		CHAR(1);
	DECLARE	NombreProceso		VARCHAR(16);
	DECLARE	SalidaNO			CHAR(1);
	DECLARE	SalidaSI			CHAR(1);
	DECLARE Decimal_Cero		DECIMAL;
	DECLARE EstInversionAlta	CHAR(1);
	DECLARE EstatusInverVigente	CHAR(1);
	DECLARE Inactivo			CHAR(1);
	DECLARE No_Oficial			CHAR(1);
	DECLARE Si					CHAR(1);
	DECLARE Menor_No			CHAR(1);
	DECLARE Var_EsMenorEdad		CHAR(1);
	DECLARE Tipo_Cliente        CHAR(1);
	DECLARE Var_TipoCuenta		INT(11);
	DECLARE Var_DireccionOf		CHAR(1);
	DECLARE Var_IdenOf			CHAR(1);
    DECLARE Var_NumInversiones 	INT(5);
    DECLARE Con_CasadoBienSep		CHAR(3);
	DECLARE Con_CasadoBienMan		CHAR(3);
	DECLARE Con_CasadoBienManCap	CHAR(3);
    DECLARE Con_UnioLibre			CHAR(3);
    DECLARE Con_No					CHAR(1);	-- Constante No
    DECLARE Con_Si					CHAR(1);	-- Constante Si
    DECLARE Per_Moral			CHAR(1);		-- Persona Moral
	DECLARE Per_Emp				CHAR(1);		-- Persona Fisica Act. Empresarial
	DECLARE Per_Fisica			CHAR(1);		-- Persona Fisica
	DECLARE	Entero_Uno			INT;
	DECLARE Est_Registrado		INT(11);			-- 1 estatus registrado

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET	Act_Apertura			:= 1;
	SET	Act_AperturaWsCrcb		:= 5;
	SET	Act_Bloqueo				:= 2;
	SET	Act_Desbloqueo			:= 3;
	SET	Act_Cancelacion			:= 4;
	SET	Estatus_Activa			:= 'A';
	SET	Estatus_Bloqueada		:= 'B';
	SET	Estatus_Desbloqueada	:= 'A';
	SET	Estatus_Cancelada		:= 'C';
	SET	Estatus_Registrada		:= 'R';
	SET Est_Vigente				:='V';
	SET Est_Vencido				:='B';
	SET Est_Autorizado			:='A';
	SET Est_Inactiva			:='I';
	SET EstInversionAlta		:='A';
	SET EstatusInverVigente		:='N';
	SET Tipo_Cliente            :='C';
	SET	NombreProceso			:= 'CTAAHO'; -- proceso que dispara el escalamiento interno de PLD Valor de acuerdo a la tabla PROCESCALINTPLD
	SET	SalidaSI				:= 'S';
	SET	SalidaNO				:= 'N';
	SET Decimal_Cero			:=0.0;		-- DECIMAL 0
	SET Aud_FechaActual 		:= NOW();
	SET	Inactivo				:='I';
	SET Si						:='S';
	SET Menor_No				:='N';

    SET Con_CasadoBienSep		:='CS';		-- Casado bienes separados
	SET Con_CasadoBienMan		:='CM';		-- casado bienes mancomunados
	SET Con_CasadoBienManCap	:='CC';		-- casado bienes mancomunados con capitulacion
    SET Con_UnioLibre			:='U';		-- UNION libre
    SET Con_No					:='N';		-- constante NO
	SET Con_Si					:='S';
    SET	Per_Moral				:= 'M';
	SET Per_Emp					:= 'A';
	SET Per_Fisica				:= 'F';
	SET Entero_Uno				:= 1;		-- Entero uno constante
	SET	Est_Registrado			:= 1;
    SET Var_obligaDatoConyuge	:= 'S';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CUENTASAHOACT');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

		SELECT 		Cli.Estatus, 	Cli.ClienteID, 	Cli.EsMenorEdad,	Cue.TipoCuentaID
			INTO 	Var_EstatusCli,	Var_Cliente, 	Var_EsMenorEdad,	Var_TipoCuenta
			FROM CLIENTES Cli
				 INNER JOIN CUENTASAHO Cue ON Cue.ClienteID=Cli.ClienteID
					WHERE CuentaAhoID = Par_CuentaAhoID;

		SET Var_EsMenorEdad	:= IFNULL(Var_EsMenorEdad, Menor_No);

		-- si el cliente tiene idenfificacion oficial
		SELECT ide.Oficial
			INTO Var_IdeOficial
			FROM IDENTIFICLIENTE ide
				INNER JOIN CLIENTES cli ON cli.ClienteID = ide.ClienteID
				WHERE ide.ClienteID = Var_Cliente
					AND ide.Oficial = Si
					AND cli.EsMenorEdad = Menor_No
					LIMIT 1;

		SET Var_IdeOficial :=IFNULL(Var_IdeOficial, No_Oficial);

		-- si el cliente tiene direccion oficial
		SELECT dir.Oficial
			INTO Var_DirOficial
			FROM DIRECCLIENTE dir
				WHERE dir.ClienteID = Var_Cliente
					AND dir.Oficial = Si;

		SET Var_DirOficial :=IFNULL(Var_DirOficial,No_Oficial);

		-- si  el cliente tiene conocimiento solo para mayores de edad
		SELECT c.ClienteID
			INTO Var_NoConociCte
			FROM CONOCIMIENTOCTE c
				WHERE c.ClienteID = Var_Cliente;

		SET Var_NoConociCte:= IFNULL(Var_NoConociCte, Entero_Cero);

		--  Si la cuenta tiene conocimiento
		SELECT cta.CuentaAhoID
			INTO Var_NoConociCta
			FROM CONOCIMIENTOCTA cta
				WHERE cta.CuentaAhoID = Par_CuentaAhoID;

		SET Var_NoConociCta :=IFNULL(Var_NoConociCta,Entero_Cero);

		--  Si la cuenta tiene relacionados
		SELECT cta.CuentaAhoID
			INTO Var_RelCta
			FROM CUENTASPERSONA cta
				WHERE cta.CuentaAhoID = Par_CuentaAhoID
					LIMIT 1;

		SET Var_RelCta :=IFNULL(Var_RelCta,Entero_Cero);

		--  Si la cuenta tiene Firmantes
		SELECT cta.CuentaAhoID
			INTO Var_FirCta
			FROM CUENTASFIRMA cta
				WHERE cta.CuentaAhoID = Par_CuentaAhoID
					LIMIT 1;

		SET Var_FirCta :=IFNULL(Var_FirCta, Entero_Cero);

		--  Si la cuenta tiene Huella Digital
		SELECT huell.TipoPersona, huell.PersonaID
			INTO Var_TipoPersona, Var_PersonaID
			FROM HUELLADIGITAL huell
				WHERE huell.PersonaID = Var_Cliente
					AND huell.TipoPersona = Tipo_Cliente
						LIMIT 1;

		SET Var_PersonaID :=IFNULL(Var_PersonaID, Entero_Cero);

		-- se consultan los requerimientos para la activacion de la cuenta
		SELECT tip.RelacionadoCuenta, tip.RegistroFirmas, tip.HuellasFirmante, tip.ConCuenta,tip.EstadoCivil
			INTO Var_RelCuenta, Var_RegFirmas, Var_HuellasFir, Var_ConCuenta,Var_ValidaEstCivil
			FROM CUENTASAHO cue
				INNER JOIN TIPOSCUENTAS tip
				ON cue.TipoCuentaID = tip.TipoCuentaID
				 	WHERE CuentaAhoID = Par_CuentaAhoID
						AND   cue.TipoCuentaID = tip.TipoCuentaID
						LIMIT 1;

		SELECT FuncionHuella, ReqHuellaProductos
			INTO Var_FunHuella, Var_ReqHuella
			FROM PARAMETROSSIS;

		SELECT IFNULL(ChecListCte,"N") INTO Var_ChecListCte
			FROM PARAMETROSSIS;

		SELECT COUNT(*) INTO Var_NoAceptado
			FROM CHECLIST
				WHERE Instrumento=Var_Cliente
					AND IFNULL(Aceptado,"N")="N";


		IF(Var_EstatusCli=Inactivo)THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= CONCAT('El Cliente se Encuentra Inactivo.');
			SET Var_Control	:= 'clienteID' ;
			SET Var_Consecutivo := Var_Cliente;
			LEAVE ManejoErrores;
		END IF;

		IF(NOT EXISTS(
				SELECT CuentaAhoID
						FROM CUENTASAHO
							WHERE CuentaAhoID = Par_CuentaAhoID)) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= CONCAT('El Numero de Cuenta no existe.');
			SET Var_Control	:= 'cuentaAhoID' ;
			SET Var_Consecutivo := Par_CuentaAhoID;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CuentaAhoID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:= CONCAT('El Numero de safilocale.ctaAhorro esta Vacio.');
			SET Var_Control	:= 'cuentaAhoID' ;
			SET Var_Consecutivo := Var_Cliente;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_UsuarioID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= CONCAT('El Numero de Usuario esta Vacio.');
			SET Var_Control	:= 'usuarioID' ;
			SET Var_Consecutivo := Par_UsuarioID;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Fecha,Fecha_Vacia)) = Fecha_Vacia THEN
			SET Par_NumErr	:= 005;
			SET Par_ErrMen	:= CONCAT('La Fecha esta Vacia.');
			SET Var_Control	:= 'fechaApertura' ;
			SET Var_Consecutivo := Par_Fecha;
			LEAVE ManejoErrores;
		END IF;

		SET Var_Estatus := (SELECT Estatus FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID);

		-- AUTORIZACION DE LAS CUENTA
		IF(Par_NumAct = Act_Apertura) THEN
		-- INICIO VALIDACION PERSONAS NO DESEADAS
			SET Var_DetecNoDeseada := IFNULL((SELECT  PersonNoDeseadas FROM PARAMETROSSIS LIMIT 1),Con_No);
			IF(Var_DetecNoDeseada = Con_Si) THEN
				SELECT	Cli.TipoPersona
					INTO	Var_TipoPersCliente
					FROM	CLIENTES Cli,
							SUCURSALES Suc
					WHERE 	Cli.ClienteID 	= Var_Cliente
					AND		Suc.SucursalID 	= Cli.SucursalOrigen;
				IF(Var_TipoPersCliente = Per_Moral) THEN
					SELECT 	Cli.RFCpm
					INTO 	Var_RFCOficial FROM	CLIENTES Cli,	SUCURSALES Suc
					WHERE 	Cli.ClienteID 	= Var_Cliente
					AND		Suc.SucursalID 	= Cli.SucursalOrigen;
				END IF;

				IF(Var_TipoPersCliente = Per_Fisica OR Var_TipoPersona = Per_Emp ) THEN
					SELECT 	Cli.RFC
					INTO 	Var_RFCOficial FROM	CLIENTES Cli,	SUCURSALES Suc
					WHERE 	Cli.ClienteID 	= Var_Cliente
					AND		Suc.SucursalID 	= Cli.SucursalOrigen;
				END IF;

				CALL PLDDETECPERSNODESEADASPRO(
					Var_Cliente,	Var_RFCOficial,	Var_TipoPersCliente,	SalidaNO,	Par_NumErr,
					Par_ErrMen,		Aud_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

				IF(Par_NumErr!=Entero_Cero)THEN
					SET Par_NumErr			:= 050;
					SET Par_ErrMen			:= Par_ErrMen;
					LEAVE ManejoErrores;
				END IF;
			END IF;
			/*FIN PERSONAS NO DESEADAS*/

			-- Llamada al proceso de deteccion de nivel de riesgo del cliente, modulo PLD
			CALL DETESCALAINTPLDPRO (
				Par_CuentaAhoID,	Entero_Cero,		NombreProceso,		Entero_Cero,	SalidaNO,
				Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,	Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			-- INICIO SECCIÓN PARA VALIDAR ESTADO CIVIL Y DATOS DEL CONYUGE
			IF(Var_ValidaEstCivil=Si)THEN
				SET Var_EstCivilCliente := (SELECT EstadoCivil FROM CLIENTES WHERE  ClienteID=Var_Cliente);

				IF(Var_EstCivilCliente=Con_CasadoBienSep OR Var_EstCivilCliente=Con_CasadoBienMan
					OR Var_EstCivilCliente=Con_CasadoBienManCap OR Var_EstCivilCliente=Con_UnioLibre)THEN
                    
                    IF (Var_datosConyuge = Var_obligaDatoConyuge) THEN

					SET Var_ExiDatosConyu := (IF(EXISTS (SELECT *
														FROM SOCIODEMOCONYUG
														WHERE ClienteID=Var_Cliente),Si,Con_No));
					IF(Var_ExiDatosConyu=Con_No)THEN
						SET Par_NumErr	:= 017;
						SET Par_ErrMen	:= CONCAT('Los datos del conyuge se encuentran vacios.');
						SET Var_Control	:= 'clienteID' ;
						SET Var_Consecutivo := Par_CuentaAhoID;
						LEAVE ManejoErrores;
					END IF;
                    END IF;
				END IF;
			END IF;
			-- FIN SECCIÓN PARA VALIDAR ESTADO CIVIL Y DATOS DEL CONYUGE

			IF(Par_NumErr = Entero_Cero OR Par_NumErr = 502) THEN
				IF(Var_Estatus = Estatus_Activa) THEN
					SET Par_NumErr	:= 006;
					SET Par_ErrMen	:= CONCAT('La Cuenta ya estaba Activada.');
					SET Var_Control	:= 'cuentaAhoID' ;
					SET Var_Consecutivo := Par_CuentaAhoID;
					LEAVE ManejoErrores;
				END IF;

				SET Var_EdadCliente := (SELECT  (YEAR (CURRENT_DATE)- YEAR (FechaNacimiento)) - (RIGHT(CURRENT_DATE,5)<RIGHT(FechaNacimiento,5)) AS Edad
											FROM CLIENTES
												WHERE ClienteID = Var_Cliente);

				IF(Var_ChecListCte="S") THEN
					IF(Var_NoAceptado>Entero_Cero) THEN
						SET Par_NumErr	:= 014;
						SET Par_ErrMen	:= CONCAT('El Cliente no tiene su CHECK List de Registro.');
						SET Var_Control	:= 'clienteID' ;
						SET Var_Consecutivo := Par_CuentaAhoID;
						LEAVE ManejoErrores;
					END IF;
				END IF;

				-- validaciones de los requerimientos segun el tipo de cuenta
				CALL VALIDACUENTACLIE(
					Var_Cliente,		Var_TipoCuenta,		Par_CuentaAhoID,	SalidaNO,			Par_NumErr,
					Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					SET Var_Control := 'cuentaAhoID';
					SET Var_Consecutivo := Par_CuentaAhoID;
					LEAVE ManejoErrores;
				END IF;
				-- FIN validaciones de los requerimientos segun el tipo de cuenta

				-- Validar Envio de mensaje
				SELECT		Tp.NotificacionSms
				INTO	Var_NotificaSMS
				FROM CUENTASAHO Cue
				INNER JOIN TIPOSCUENTAS Tp
				ON Cue.TipoCuentaID = Tp.TipoCuentaID
				WHERE Cue.CuentaAhoID = Par_CuentaAhoID
				LIMIT Entero_Uno;

				SET Var_NotificaSMS := IFNULL(Var_NotificaSMS, Cadena_Vacia);
				IF (Var_NotificaSMS = SalidaSI) THEN

					CALL SMSACTIVACUENTAPRO(	Par_CuentaAhoID,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
												Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
												Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero) THEN
						SET Var_Control		:= 'cuentaAhoID';
						SET Par_ErrMen		:= 'El Teléfono Celular del Cliente no es Válido o no Tiene Plantilla Registrada, No se Mandará Mensaje de Bienvenida.';
						SET Var_Consecutivo := Par_CuentaAhoID;
						LEAVE ManejoErrores;
					END IF;

				END IF;

				IF(Var_Estatus = Estatus_Registrada) THEN

                    -- VALIDACION SI REQUIERE UN DEPOSITO PARA ACTIVACION
                    SET Var_EstatusDepositoActiva := (SELECT Estatus FROM DEPOSITOACTIVACTAAHO WHERE CuentaAhoID = Par_CuentaAhoID AND Estatus = Est_Registrado);
                    IF(IFNULL(Var_EstatusDepositoActiva,Entero_Cero) = Est_Registrado)THEN
						SET Par_NumErr		:= 015;
						SET Par_ErrMen		:= 'La Cuenta de Ahorro Requiere un Deposito en Ventanilla para su Activacion.';
						SET Var_Control		:= 'cuentaAhoID';
                    END IF;
                    -- FIN VALIDACION DEPOSITO PAR ACTIVACION

					UPDATE CUENTASAHO SET
						UsuarioApeID	= Par_UsuarioID,
						FechaApertura	= Par_Fecha,
						Estatus			= Estatus_Activa,

						EmpresaID		= Aud_EmpresaID,
						Usuario			= Aud_Usuario,
						FechaActual		= Aud_FechaActual,
						DireccionIP		= Aud_DireccionIP,
						ProgramaID		= Aud_ProgramaID,
						Sucursal		= Aud_Sucursal,
						NumTransaccion	= Aud_NumTransaccion
					WHERE CuentaAhoID 	= Par_CuentaAhoID;

					SET Par_NumErr	:= 0;
					SET Par_ErrMen	:= CONCAT('Cuenta Activada Exitosamente.');
					SET Var_Control	:= 'cuentaAhoID' ;
					SET Var_Consecutivo := Par_CuentaAhoID;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(Par_NumErr != Entero_Cero OR Par_NumErr != 502) THEN
				SET Var_Control	:= 'cuentaAhoID' ;
				SET Var_Consecutivo := Par_CuentaAhoID;
				LEAVE ManejoErrores;
			END IF;

		END IF;
		-- FIN AUTORIZACION DE LAS CUENTA

		-- BLOQUEO DE CUENTA
		IF(Par_NumAct = Act_Bloqueo) THEN
			IF(IFNULL(Par_Motivo, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr	:= 008;
				SET Par_ErrMen	:= CONCAT('El Motivo esta Vacio.');
				SET Var_Control	:= 'motivo' ;
				SET Var_Consecutivo := Par_CuentaAhoID;
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus = Estatus_Bloqueada) THEN
				SET Par_NumErr	:= 009;
				SET Par_ErrMen	:= CONCAT('La Cuenta ya estaba Bloqueada.');
				SET Var_Control	:= 'cuentaAhoID' ;
				SET Var_Consecutivo := Par_CuentaAhoID;
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus = Estatus_Registrada) THEN
				SET Par_NumErr	:= 010;
				SET Par_ErrMen	:= CONCAT('La Cuenta no ha sido Activada.');
				SET Var_Control	:= 'cuentaAhoID' ;
				SET Var_Consecutivo := Par_CuentaAhoID;
				LEAVE ManejoErrores;
			END IF;

			SET Var_NumInversiones := (SELECT COUNT(*) FROM INVERSIONES INV INNER JOIN CUENTASAHO CTA ON INV.CuentaAhoID = CTA.CuentaAhoID WHERE CTA.CuentaAhoID = Par_CuentaAhoID AND INV.Estatus = 'N');
			IF (Var_NumInversiones > Entero_Cero) THEN
				SET Par_NumErr	:= 20;
				SET Par_ErrMen	:= 'La Cuenta no se Puede Bloquear por que se Encuentra Asociada a una Inversion Vigente.';
				SET Var_Control	:= 'cuentaAhoID' ;
				SET Var_Consecutivo := Par_CuentaAhoID;
				LEAVE ManejoErrores;
			ELSE
			UPDATE CUENTASAHO SET
				UsuarioBloID	= Par_UsuarioID,
				FechaBlo		= Par_Fecha,
				MotivoBlo		= Par_Motivo,
				Estatus			= Estatus_Bloqueada,

				EmpresaID		= Aud_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE CuentaAhoID 	= Par_CuentaAhoID;

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= CONCAT('Cuenta Bloqueada Exitosamente.');
			SET Var_Control	:= 'cuentaAhoID' ;
			SET Var_Consecutivo := Par_CuentaAhoID;
			LEAVE ManejoErrores;
		END IF;
		-- FIN BLOQUEO DE CUENTA
		END IF;

		-- DESBLOQUEO DE LA CUENTA
		IF(Par_NumAct = Act_Desbloqueo) THEN
			IF(Var_Estatus = Estatus_Activa) THEN
				SET Par_NumErr	:= 011;
				SET Par_ErrMen	:= CONCAT('La Cuenta ya estaba Activa.');
				SET Var_Control	:= 'cuentaAhoID' ;
				SET Var_Consecutivo := Par_CuentaAhoID;
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus = Estatus_Bloqueada) THEN
				UPDATE CUENTASAHO SET
					UsuarioDesbID	= Par_UsuarioID,
					FechaDesbloq	= Par_Fecha,
					MotivoBlo		= Cadena_Vacia,
					MotivoDesbloq	= Par_Motivo,
					Estatus			= Estatus_Desbloqueada,

					EmpresaID		= Aud_EmpresaID,
					Usuario			= Aud_Usuario,
					FechaActual 	= Aud_FechaActual,
					DireccionIP 	= Aud_DireccionIP,
					ProgramaID  	= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion
				WHERE CuentaAhoID 		= Par_CuentaAhoID;

				SET Par_NumErr	:= 000;
				SET Par_ErrMen	:= CONCAT('Cuenta Desbloqueada Exitosamente.');
				SET Var_Control	:= 'cuentaAhoID' ;
				SET Var_Consecutivo := Par_CuentaAhoID;
				LEAVE ManejoErrores;
			END IF;
		END IF;
		-- FIN DESBLOQUEO DE LA CUENTA

		-- CANCELACION DE LA CUENTA
		IF(Par_NumAct = Act_Cancelacion) THEN
			IF(IFNULL(Par_Motivo, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr	:= 013;
				SET Par_ErrMen	:= CONCAT('El Motivo esta Vacio.');
				SET Var_Control	:= 'motivo' ;
				SET Var_Consecutivo := Var_Cliente;
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus = Estatus_Cancelada) THEN
				SET Par_NumErr	:= 014;
				SET Par_ErrMen	:= CONCAT('La Cuenta se encuentra cancelada.');
				SET Var_Control	:= 'cuentaAhoID' ;
				SET Var_Consecutivo := Par_CuentaAhoID;
				LEAVE ManejoErrores;
			END IF;

			SELECT
				SaldoDispon,			SaldoBloq,			SaldoSBC
				INTO
				Var_SaldoDisponible,	Var_SaldoBloqueado,	Var_SaldoSBC
				FROM CUENTASAHO
					WHERE CuentaAhoID 	= Par_CuentaAhoID;

			SET Var_SaldoDisponible :=IFNULL(Var_SaldoDisponible,Decimal_Cero);
			SET Var_SaldoBloqueado 	:=IFNULL(Var_SaldoBloqueado,Decimal_Cero);
			SET Var_SaldoSBC 		:=IFNULL(Var_SaldoSBC,Decimal_Cero);

			IF(Var_SaldoDisponible >Decimal_Cero)THEN
				SET Par_NumErr	:= 015;
				SET Par_ErrMen	:= CONCAT('La Cuenta tiene Saldo Disponible.');
				SET Var_Control	:= 'cuentaAhoID' ;
				SET Var_Consecutivo := Par_CuentaAhoID;
				LEAVE ManejoErrores;
			END IF;

			IF(Var_SaldoBloqueado >Decimal_Cero)THEN
				SET Par_NumErr	:= 016;
				SET Par_ErrMen	:= CONCAT('La Cuenta tiene Saldo Bloqueado.');
				SET Var_Control	:= 'cuentaAhoID' ;
				SET Var_Consecutivo := Par_CuentaAhoID;
				LEAVE ManejoErrores;
			END IF;

			IF(Var_SaldoSBC >Decimal_Cero)THEN
				SET Par_NumErr	:= 017;
				SET Par_ErrMen	:= CONCAT('La Cuenta tiene Saldo SBC.');
				SET Var_Control	:= 'cuentaAhoID' ;
				SET Var_Consecutivo := Par_CuentaAhoID;
				LEAVE ManejoErrores;
			END IF;

			IF EXISTS(SELECT  Monto
						FROM INVERSIONES
							WHERE CuentaAhoID=Par_CuentaAhoID
								AND (Estatus = EstInversionAlta OR
									Estatus = EstatusInverVigente))THEN
				SET Par_NumErr	:= 018;
				SET Par_ErrMen	:= CONCAT('La Cuenta Tiene una Inversion Vigente o Inactiva.');
				SET Var_Control	:= 'cuentaAhoID' ;
				SET Var_Consecutivo := Par_CuentaAhoID;
				LEAVE ManejoErrores;
			END IF;

			SELECT  CreditoID INTO Var_CreditoID
				FROM CREDITOS
					WHERE CuentaID=Par_CuentaAhoID
						AND Estatus IN( Est_Vigente,Est_Vencido)
							LIMIT 1;

			SET Var_CreditoID :=IFNULL(Var_CreditoID,Entero_Cero );

			IF(Var_CreditoID != Entero_Cero)THEN
				SET Par_NumErr	:= 019;
				SET Par_ErrMen	:= CONCAT('La Cuenta se encuentra relacionada al credito ',Var_CreditoID);
				SET Var_Control	:= 'cuentaAhoID' ;
				SET Var_Consecutivo := Par_CuentaAhoID;
				LEAVE ManejoErrores;
			END IF;

			UPDATE CUENTASAHO SET
				UsuarioCanID	= Par_UsuarioID,
				FechaCan		= Par_Fecha,
				MotivoCan		= Par_Motivo,
				Estatus			= Estatus_Cancelada,

				EmpresaID		= Aud_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
				WHERE CuentaAhoID 	= Par_CuentaAhoID;

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= CONCAT('Cuenta ',CONVERT(Par_CuentaAhoID,CHAR) ,' Cancelada Exitosamente');
			SET Var_Control	:= 'cuentaAhoID' ;
			SET Var_Consecutivo := Par_CuentaAhoID;
			LEAVE ManejoErrores;
		END IF;
		-- FIN CANCELACION DE LA CUENTA


        -- AUTORIZACION DE LAS CUENTA WEB SERVICE CRCB SIN PLD
		IF(Par_NumAct = Act_AperturaWsCrcb) THEN

				IF(Var_Estatus = Estatus_Activa) THEN
					SET Par_NumErr	:= 006;
					SET Par_ErrMen	:= CONCAT('La Cuenta ya estaba Activada.');
					SET Var_Control	:= 'cuentaAhoID' ;
					SET Var_Consecutivo := Par_CuentaAhoID;
					LEAVE ManejoErrores;
				END IF;

				SET Var_EdadCliente := (SELECT  (YEAR (CURRENT_DATE)- YEAR (FechaNacimiento)) - (RIGHT(CURRENT_DATE,5)<RIGHT(FechaNacimiento,5)) AS Edad
											FROM CLIENTES
												WHERE ClienteID = Var_Cliente);

				IF(Var_ChecListCte="S") THEN
					IF(Var_NoAceptado>Entero_Cero) THEN
						SET Par_NumErr	:= 014;
						SET Par_ErrMen	:= CONCAT('El Cliente no tiene su CHECK List de Registro.');
						SET Var_Control	:= 'clienteID' ;
						SET Var_Consecutivo := Par_CuentaAhoID;
						LEAVE ManejoErrores;
					END IF;
				END IF;

				-- validaciones de los requerimientos segun el tipo de cuenta
				CALL VALIDACUENTACLIE(
					Var_Cliente,		Var_TipoCuenta,		Par_CuentaAhoID,	SalidaNO,			Par_NumErr,
					Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					SET Var_Control := 'cuentaAhoID';
					SET Var_Consecutivo := Par_CuentaAhoID;
					LEAVE ManejoErrores;
				END IF;
				-- FIN validaciones de los requerimientos segun el tipo de cuenta

				IF(Var_Estatus = Estatus_Registrada) THEN
					UPDATE CUENTASAHO SET
						UsuarioApeID	= Par_UsuarioID,
						FechaApertura	= Par_Fecha,
						Estatus			= Estatus_Activa,

						EmpresaID		= Aud_EmpresaID,
						Usuario			= Aud_Usuario,
						FechaActual		= Aud_FechaActual,
						DireccionIP		= Aud_DireccionIP,
						ProgramaID		= Aud_ProgramaID,
						Sucursal		= Aud_Sucursal,
						NumTransaccion	= Aud_NumTransaccion
					WHERE CuentaAhoID 	= Par_CuentaAhoID;

					SET Par_NumErr	:= 0;
					SET Par_ErrMen	:= CONCAT('Cuenta Activada Exitosamente.');
					SET Var_Control	:= 'cuentaAhoID' ;
					SET Var_Consecutivo := Par_CuentaAhoID;
					LEAVE ManejoErrores;
				END IF;

		END IF;
		-- FIN AUTORIZACION DE LAS CUENTA WEBSERVICE CRCB

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$
