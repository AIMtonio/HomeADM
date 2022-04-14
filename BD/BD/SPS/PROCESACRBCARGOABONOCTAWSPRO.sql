-- PROCESACRBCARGOABONOCTAWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROCESACRBCARGOABONOCTAWSPRO`;

DELIMITER $$
CREATE PROCEDURE `PROCESACRBCARGOABONOCTAWSPRO`(
	-- SP para procesar el abono a cuentas
	 Par_FolioCarga			INT(11),			-- Identificador del folio de la Carga

	Par_Salida				CHAR(1),			-- Salida S:Si No:No
	INOUT Par_NumErr		INT(11),			-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de error

	Par_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(100);		-- Variable de control
	DECLARE Var_NumTransaccion		BIGINT(20);			-- Variable para el numero de transaccion
	DECLARE Var_PolizaID			BIGINT(20);			-- Variable para almacenar el numero de poliza
	DECLARE Var_Contador			BIGINT(20);			-- Variable contador
	DECLARE Var_NumRegistro			BIGINT(20);			-- Variable para contar los numeros de registros
	DECLARE Var_FechaSistema		DATE;				-- Almacena la fecha actual del sistema
	DECLARE Var_CuentaAhoID			BIGINT(12);			-- Variable para la cuenta de ahorro
	DECLARE Var_Monto				DECIMAL(14,2);		-- Variable para el monto
	DECLARE Var_NatMovimiento		CHAR(1);			-- Naturaleza del movimiento
	DECLARE Var_Referencia			VARCHAR(50);		-- Referencia del movimiento
	DECLARE Var_FechaCarga			DATETIME;			-- Fecha de la carga
	DECLARE Var_RegistroNoExitoso	INT(11);			-- Variable para almacenar los registros no exitosos

	-- Declaracion de constantes
	DECLARE	SalidaNO				CHAR(1);			-- Salida si
	DECLARE	SalidaSI				CHAR(1);			-- Constante de Salida no
	DECLARE	Nat_Abono				CHAR(1);			-- Naturaleza abono
	DECLARE Nat_Cargo				CHAR(1);			-- Naturaleza cargo
	DECLARE Con_ConceptoAbonoID		INT(11);			-- Identificador del concepto abono
	DECLARE Con_ConceptoCargoID		INT(11);			-- Identificador del concepto cargo
	DECLARE Con_DesAbonoCuenta		VARCHAR(150);		-- Descripcion del abono a cuenta
	DECLARE Con_DesCargoCuenta		VARCHAR(150);		-- Descripcion del abono a cuenta
	DECLARE	Pol_Automatica			CHAR(1);			-- Tipo de poliza automatica
	DECLARE Entero_Cero				INT(11);			-- Constante Entero Cero
	DECLARE Fecha_Vacia				DATE;				-- Constante de fecha vacia
	DECLARE	Cadena_Vacia			CHAR(1);			-- Cadena vacia
	DECLARE Error_Key				INT(11);			-- Numero de error

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;
	SET	Fecha_Vacia					:= '1900-01-01 00:00:00';
	SET	Cadena_Vacia				:= '';
	SET	SalidaSI					:= 'S';
	SET	SalidaNO					:= 'N';
	SET	Nat_Abono					:= 'A';
	SET	Nat_Cargo					:= 'C';
	SET Con_ConceptoAbonoID			:= 45;
	SET Con_ConceptoCargoID			:= 46;
	SET Con_DesAbonoCuenta			:= 'ABONO REALIZADO A CUENTA';
	SET Con_DesCargoCuenta			:= 'RETIRO REALIZADO A CUENTA';
	SET	Pol_Automatica				:= 'A';
	SET Aud_NumTransaccion			:= IFNULL(Aud_NumTransaccion, Entero_Cero);
	SET Var_FechaSistema			:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Aud_FechaActual				:= NOW();
	SET Var_Contador				:= 1;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PROCESACRBCARGOABONOCTAWSPRO');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

		IF (IFNULL(Par_FolioCarga,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El Folio de la carga esta vacio.';
			SET Var_Control := 'folioCarga';
			LEAVE ManejoErrores;
		END IF;

		SET @RegistroID := 0;
		INSERT TMPCRCBCARGOABONOCTAWS
				(NumRegistro,						FechaCarga,		FolioCarga,				CuentaAhoID,	Monto,
				NatMovimiento,						Referencia
				)
		SELECT 	(@RegistroID := @RegistroID +1),	FechaCarga,		FolioCarga,				CuentaAhoID,	Monto,
				NatMovimiento,						Referencia
		FROM CS_CRCBCARGOABONOCTAWS
		WHERE FolioCarga = Par_FolioCarga
		ORDER BY NatMovimiento ASC;

		-- Totales de registros a procesar
		SET Var_NumRegistro := (SELECT COUNT(*) FROM TMPCRCBCARGOABONOCTAWS WHERE FolioCarga = Par_FolioCarga);

		-- Iteraciones de registros
		WHILE (Var_Contador <= Var_NumRegistro) DO

			SELECT	FechaCarga,			CuentaAhoID,		Monto,		NatMovimiento,		Referencia
			INTO 	Var_FechaCarga,		Var_CuentaAhoID,	Var_Monto,	Var_NatMovimiento,	Var_Referencia
			FROM TMPCRCBCARGOABONOCTAWS
			WHERE NumRegistro = Var_Contador;

			-- SE INICIA TRANSACCION
			START TRANSACTION;
			TransaccionGenerica:BEGIN
				DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
				DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
				DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
				DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;
				SET Error_Key := Entero_Cero;

				CALL MAESTROPOLIZASALT	(	Var_PolizaID,		Par_EmpresaID,		Var_FechaSistema,	Pol_Automatica,		IF(Var_NatMovimiento = Nat_Abono, Con_ConceptoAbonoID, Con_ConceptoCargoID),
											IF(Var_NatMovimiento = Nat_Abono, Con_DesAbonoCuenta, Con_DesCargoCuenta),		SalidaNO,
											Par_NumErr,			Par_ErrMen,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
											Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
										);

				-- Se evalua el numero de error para ver si se hace rollback o commit
				IF(Par_NumErr <> Entero_Cero OR Error_Key <> Entero_Cero)THEN
					LEAVE TransaccionGenerica;
				END IF;

				CALL CRCBCARGOABONOCTAWSPRO	(	Var_CuentaAhoID,	Var_Monto,			Var_NatMovimiento,	Var_Referencia,		Cadena_Vacia,
												Var_PolizaID,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
												Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
												Aud_NumTransaccion
											);

				-- Se evalua el numero de error para ver si se hace rollback o commit
				IF(Par_NumErr <> Entero_Cero OR Error_Key <> Entero_Cero)THEN
					LEAVE TransaccionGenerica;
				END IF;

			END TransaccionGenerica;
			IF (Error_Key = 0 AND Par_NumErr = 0) THEN
				COMMIT;
			ELSE
				ROLLBACK;
					-- Se realiza insert a la bitacora en caso que falle algun proceso
					INSERT BITACORACRBCARGOABONOCTAWS
							(FechaCarga,		FolioCarga,			CuentaAhoID,		Monto,			NatMovimiento,
							Referencia,			MensajeError, 		CodigoError,		EmpresaID,		Usuario,
							FechaActual,		DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion
							)
					VALUES	(Var_FechaCarga,	Par_FolioCarga,		Var_CuentaAhoID,	Var_Monto,		Var_NatMovimiento,
							Var_Referencia,		Par_ErrMen,			Par_NumErr,			Par_EmpresaID,	Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion
							);
			END IF;
			-- Se asignan variables valores por defecto
			SET Var_Contador 		:= Var_Contador + 1;
			SET Var_CuentaAhoID		:= Entero_Cero;
			SET Var_Monto			:= Entero_Cero;
			SET Var_NatMovimiento	:= Cadena_Vacia;
			SET Var_Referencia		:= Cadena_Vacia;
			SET Var_FechaCarga		:= Fecha_Vacia;
		END WHILE;

		-- Totales de registros a procesar
		SET Var_RegistroNoExitoso := (SELECT COUNT(*) FROM BITACORACRBCARGOABONOCTAWS WHERE FolioCarga = Par_FolioCarga);

		SET Par_NumErr	:= 000;
		IF(Var_RegistroNoExitoso = Entero_Cero)THEN
			SET Par_ErrMen	:= 'Proceso de Cargo/Abono Realizado Exitosamente';
		ELSE
			SET Par_ErrMen	:= CONCAT('Proceso de Cargo/Abono Realizado Exitosamente', '\nTotales de Registros no Exitosos : ', '[',Var_RegistroNoExitoso,']');
		END IF;
		SET Var_Control	:= 'cuentaAhoID' ;

	END ManejoErrores;

	-- Se borran los registros de la tabla temporal
	DELETE FROM TMPCRCBCARGOABONOCTAWS WHERE FolioCarga = Par_FolioCarga;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS control;
	END IF;

END TerminaStore$$
