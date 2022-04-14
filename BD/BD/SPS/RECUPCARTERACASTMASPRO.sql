
DELIMITER ;
DROP PROCEDURE IF EXISTS `RECUPCARTERACASTMASPRO`;

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE `RECUPCARTERACASTMASPRO`(
/*PROCESO QUE REALIZA LA RECUPERACION DE CARTERA CASTIGADA MASIVAMENTE DE ACUERDO AL ARCHIVO CARGADO*/
	Par_TransaccionID				BIGINT(20),					# Numero de Transaccion con el que se hizo la carga
	Par_FechaCarga					DATE,
	Par_Salida						CHAR(1),					# Indica el tipo de salida S.- SI N.- No
	INOUT Par_NumErr				INT,						# Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),				# Mensaje de Error
	/*Parametros de Auditoria*/
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(12)
)

TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(50);				-- ID del Control en pantalla
	DECLARE Var_Consecutivo			VARCHAR(50);				-- ID del Control en pantalla
	-- Variables del Cursor
	DECLARE Var_CreditoID			BIGINT(12);					-- Credito ID
	DECLARE Var_CuentaAhoID			BIGINT(12);					-- Numero de Cuenta de Ahorro
	DECLARE Var_MontoRecuperar		DECIMAL(14,2);				-- Monto a Recuperar
	DECLARE Var_Error_Key			INT(11);					-- Clave de Error en el ciclo del cursor
	DECLARE Var_AplicaIVA			CHAR(1);
	DECLARE Var_Estatus				CHAR(1);
	DECLARE Var_TasaIVA				DECIMAL(12,2);
	DECLARE Var_Recupera			DECIMAL(12,2);
	DECLARE Var_SaldoDispo			DECIMAL(12,2);
	DECLARE Var_Poliza				BIGINT(20);
	DECLARE Var_ClienteID			INT(11);
	DECLARE Var_SucCliente			INT(11);
	DECLARE Error_Key				INT(11);
	DECLARE	Var_CuentaStr			VARCHAR(20);

	-- Declaracion de constantes
	DECLARE Entero_Cero					INT(11);
	DECLARE Cadena_Vacia				CHAR(1);
	DECLARE Cons_NO						CHAR(1);
	DECLARE SalidaSi					CHAR(1);
	-- Constantes del Cursor
	DECLARE SI_AplicaIVA				CHAR(1);
	DECLARE PolizaAuto					CHAR(1);
	DECLARE Error_DUPLICATEKEY			INT(11);
	DECLARE Error_INVALIDNULL			INT(11);
	DECLARE Error_SQLEXCEPTION			INT(11);
	DECLARE Error_VARUNQUOTED			INT(11);
	DECLARE concepContaRecCarteraCas 	INT(11);
	DECLARE tipoMovCargoCuenta 			INT(11);
	DECLARE concepContaDepVent 			INT(11);
	DECLARE DescRecCarteraCast			VARCHAR(100);
	DECLARE conceptoAhorro				INT(11);

	-- Cursores
	DECLARE CURSORCRED  CURSOR FOR
	SELECT CreditoID, CuentaAhoID, MontoRecuperar FROM CREDRECCARTCASTMAS
		WHERE /*Estatus = "I"
		AND*/ TransaccionID = Par_TransaccionID;

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;							-- Entero Cero
	SET Cadena_Vacia				:= '';							-- Cadena Vacia
	SET Cons_NO						:= 'N';							-- Constante No
	SET SalidaSi					:= 'S';							-- Salida Si
	SET Error_DUPLICATEKEY			:= 2; 				-- Codigo de Error para el SQLSTATE: LLAVE DUPLICADA, COLUMNA NO DEBE SER NULA, COLUMNA AMBIGUA, ETC.
	SET Error_INVALIDNULL			:= 4; 				-- Codigo de Error para el SQLSTATE: USO INVALIDO DEL VALOR NULL, ERROR OBTENIDO DESDE EXPRESON REGULAR.
	SET Error_SQLEXCEPTION			:= 1;				-- Codigo de Error para el SQLSTATE: SQLEXCEPTION.
	SET Error_VARUNQUOTED			:= 3; 				-- Codigo de Error para el SQLSTATE: VARIABLE SIN COMILLAS, FUNCIONES DE AGREGACION (GROUP BY, SUM, ETC), ETC.
	SET SI_AplicaIVA				:= 'S';
	SET PolizaAuto					:= 'A';
	SET DescRecCarteraCast			:= 'RECUPERACION DE CARTERA CASTIGADA';
	SET concepContaRecCarteraCas	:= 63;
	SET tipoMovCargoCuenta			:= 11;
	SET concepContaDepVent			:= 30;
	SET conceptoAhorro				:= 1;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr		:= 999;
			SET Par_ErrMen		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-RECUPCARTERACASTMASPRO');
			SET Var_Control		:= 'sqlException' ;
		END;

		SET Par_FechaCarga := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Var_TasaIVA := Entero_Cero;

		SET Var_AplicaIVA := (SELECT IVARecuperacion
								FROM PARAMSRESERVCASTIG);
		SET Var_AplicaIVA	:= IFNULL(Var_AplicaIVA, SI_AplicaIVA);
		IF NOT EXISTS(SELECT UsuarioID FROM USUARIOS WHERE UsuarioID = Aud_Usuario) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen:='El Usuario No Existe';
			LEAVE ManejoErrores;
		END IF;

		OPEN CURSORCRED;
			BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP
			FETCH CURSORCRED INTO
			Var_CreditoID,	Var_CuentaAhoID,	Var_MontoRecuperar;
			START TRANSACTION;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
					DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
					DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
					DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

					SET Var_Error_Key		:= Entero_Cero;
					ManejoCiclo: BEGIN
						DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
							SET Par_NumErr		:= 999;
							SET Par_ErrMen		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
													'Disculpe las molestias que esto le ocasiona. Ref: SP-RECUPCARTERACASTMASPRO');
							SET Var_Control		:= 'sqlException' ;
						END;
						SET Var_Estatus := 'E';
						SET Par_NumErr := 0;
						SET Par_ErrMen := '';

						IF NOT EXISTS(SELECT CreditoID FROM CREDITOS WHERE CreditoID = Var_CreditoID) THEN
							SET Par_NumErr := 1;
							SET Par_ErrMen := 'El Credito No Existe.';
							LEAVE ManejoCiclo;
						END IF;

						IF NOT EXISTS(SELECT CuentaAhoID FROM CUENTASAHO WHERE CuentaAhoID = Var_CuentaAhoID) THEN
							SET Par_NumErr := 2;
							SET Par_ErrMen := 'La Cuenta No Existe.';
							LEAVE ManejoCiclo;
						END IF;
						# VALIDACIONES #####################################################################################################
						IF(Var_AplicaIVA = SI_AplicaIVA) THEN
							SET Var_TasaIVA		:= (SELECT Suc.IVA
													FROM CREDITOS Cre INNER JOIN
														SUCURSALES Suc ON Cre.SucursalID = Suc.SucursalID
														WHERE CreditoID = Var_CreditoID);
						END IF;
						SET Var_TasaIVA		:= IFNULL(Var_TasaIVA, Entero_Cero);
						SET Var_Recupera 	:= (SELECT
													ROUND(SaldoCapital * (1 + Var_TasaIVA),2) +
													ROUND(SaldoInteres * ( 1 + Var_TasaIVA),2) +
													ROUND(SaldoMoratorio * (1 + Var_TasaIVA),2) +
													ROUND(SaldoAccesorios * (1 + Var_TasaIVA),2)
													FROM CRECASTIGOS
													WHERE CreditoID = Var_CreditoID);

						SET Var_Recupera 	:= IFNULL(Var_Recupera, Entero_Cero);
						SET Var_SaldoDispo	:= (SELECT SaldoDispon FROM CUENTASAHO WHERE CuentaAhoID = Var_CuentaAhoID);
						SET Var_ClienteID	:= (SELECT ClienteID FROM CREDITOS AS CRED WHERE CRED.CreditoID = Var_CreditoID);
						SET Var_SucCliente	:= (SELECT SucursalOrigen FROM CLIENTES WHERE ClienteID = Var_ClienteID);
						# Validar si la cuenta le pertenece al Cliente
						IF NOT EXISTS(SELECT CuentaAhoID FROM CUENTASAHO WHERE ClienteID = Var_ClienteID AND CuentaAhoID = Var_CuentaAhoID) THEN
							SET Par_NumErr := 1;
							SET Par_ErrMen := 'La Cuenta no le pertenece al Cliente del Credito.';
							LEAVE ManejoCiclo;
						END IF;
						IF(Var_Recupera<=Entero_Cero) THEN
							SET Par_NumErr := 1;
							SET Par_ErrMen := 'El Credito ya fue recuperado.';
							LEAVE ManejoCiclo;
						END IF;

						IF(Var_SaldoDispo = Entero_Cero) THEN
							SET Par_NumErr := 1;
							SET Par_ErrMen := 'La Cuenta no cuenta con el Saldo Suficiente para realizar la Operacion.';
							LEAVE ManejoCiclo;
						END IF;


						IF(Var_MontoRecuperar > Var_SaldoDispo) THEN
							SET Var_MontoRecuperar := Var_SaldoDispo;
						END IF;

						IF(Var_MontoRecuperar > Var_Recupera) THEN
							SET Var_MontoRecuperar := Var_Recupera;
						END IF;
						/* FIN VALIDACIONES ################################################################################################# */
						IF(Var_MontoRecuperar > Entero_Cero) THEN
							# ADVERTENCIA ESTA LLAMADA DEBERA QUITARSE DESpUES EN ALGUN CONTROL DE CAMBIOS
							# CALL TRANSACCIONESPRO(Aud_NumTransaccion);

							CALL MAESTROPOLIZASALT(
								Var_Poliza,				Aud_EmpresaID,		Par_FechaCarga,		PolizaAuto,			concepContaRecCarteraCas,
								DescRecCarteraCast,		Cons_NO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
								Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

							IF(Par_NumErr != Entero_Cero) THEN
								LEAVE ManejoCiclo;
							END IF;

							SET Var_Poliza := IFNULL(Var_Poliza, Entero_Cero);

							IF(Var_Poliza > Entero_Cero) THEN
								# Movimiento Contable del Cargo
								SET Var_CuentaStr 	:= CONCAT("Cta.",CONVERT(Var_CuentaAhoID, CHAR));
								CALL POLIZASAHORROPRO(
									Var_Poliza,			Aud_EmpresaID,		Par_FechaCarga,				Var_ClienteID,		concepContaDepVent,
									Var_CuentaAhoID,	1,					Var_MontoRecuperar,			0,					CONCAT('CARGO A CTA ',DescRecCarteraCast),
									Var_CuentaStr,		Cons_NO,			Par_NumErr,					Par_ErrMen,			Aud_Usuario,
									Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,				Aud_Sucursal,		Aud_NumTransaccion);

								IF(Par_NumErr > Entero_Cero)THEN
									LEAVE ManejoErrores;
								END IF;

								# Movimiento Operativo del Cargo
								CALL CARGOABONOCTAPRO(
									Var_CuentaAhoID,		Var_ClienteID,			Aud_NumTransaccion,		Par_FechaCarga,		Par_FechaCarga,
									'C',					Var_MontoRecuperar,		CONCAT('CARGO A CTA ',DescRecCarteraCast),		Var_CreditoID,		tipoMovCargoCuenta,
									1,						Var_SucCliente,			'N',					concepContaDepVent,	Var_Poliza,
									'N',					conceptoAhorro,			'A',					Cons_NO,			Par_NumErr,
									Par_ErrMen,				Var_Consecutivo,		Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
									Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

								IF(Par_NumErr != Entero_Cero) THEN
									LEAVE ManejoCiclo;
								  ELSE
									CALL CRECASTIGOSRECPRO(
										Var_CreditoID,			Var_MontoRecuperar,		null,				Var_Poliza,			DescRecCarteraCast,
										Cons_NO,				Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,
										Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

									IF(Par_NumErr != Entero_Cero) THEN
										LEAVE ManejoCiclo;
									END IF;
								END IF;
							  ELSE
								SET Par_NumErr := 5;
								SET Par_ErrMen := 'La Poliza esta Vacia';
								LEAVE ManejoCiclo;
							END IF;
							SET Var_Estatus := 'P';
						  ELSE
							SET Par_NumErr = 001;
							SET Par_ErrMen = 'El Credito ya fue Recuperado en su totalidad.';
							LEAVE ManejoCiclo;
						END IF;
					END ManejoCiclo;
					IF (Par_NumErr = 0)THEN
						COMMIT;
					  ELSE
						ROLLBACK;
					END IF;
					# Se actualiza SIEMPRE
					START TRANSACTION;
						UPDATE CREDRECCARTCASTMAS SET
							NumErr = Par_NumErr,
							ErrMen = Par_ErrMen,
							Estatus = Var_Estatus
							WHERE
							CreditoID = Var_CreditoID;
					COMMIT;
				END;
			END LOOP;
			END;
		CLOSE CURSORCRED;

		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Proceso Masivo ejecutado Exitosamente';
		SET Var_Control := 'proceso';
		SET Var_Consecutivo := '';
	END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT 	Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
		Var_Consecutivo AS Consecutivo;
	END IF;
END TerminaStore$$