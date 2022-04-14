-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPREFAUTOMATICOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPREFAUTOMATICOPRO`;
DELIMITER $$

CREATE PROCEDURE `DEPREFAUTOMATICOPRO`(
	/*SP que realiza el pago o deposito referenciado para el procesos de depositos automaticos.
	NO EJECUTAR DESDE JAVA
	STORED EXCLUSIVO DEL ETL DE DEPOSITOS AUTOMÁTICOS DE PAGOS REFERENCIADOS*/
	Par_Salida				CHAR(1),			-- Indica si se espera una salida
	INOUT Par_NumErr		INT(11),			-- Parametro de salida para el numero de error o exito
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro de salida para el mensaje de error o exito
	Aud_EmpresaID			INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria

	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
)
TerminaStore:BEGIN

	-- Declaracio de Varibles
	DECLARE Var_Control		VARCHAR(50);		-- Variable de control
	DECLARE Var_Limite		INT(11);			-- Variable para el limite de el WHILE
	DECLARE Var_Contador	INT(11);			-- Variable para contador del WHILE
	DECLARE Var_FechaSis	DATE;				-- Variable para la fecha del sistema
	DECLARE Var_Consecutivo BIGINT(12);			-- Varialbe valor consecutivo de registro
	DECLARE Var_ConsecutivoID	BIGINT(12);		-- VAriable para el consecutivo de la tabla
	DECLARE Var_InstitucionID	INT(11);		-- Variable para el numero de institucion
	DECLARE Var_NumCtaInstit	VARCHAR(20);	-- Variable para el numero de cuenta afectada
	DECLARE Var_FechaOperacion	DATE;			-- Variable para la fecha de la operacion
	DECLARE Var_ReferenciaMov	VARCHAR(150);	-- Variable para la referencia del movimiento
	DECLARE Var_DescripcionMov	VARCHAR(150);	-- Variable para la descripcion del movimiento
	DECLARE Var_NatMovimiento	CHAR(1);		-- Varialbe para la naturaleza del movimiento
	DECLARE Var_MontoMov		DECIMAL(12,2);	-- Variable para el monto del movimiento
	DECLARE Var_MontoPendApli	DECIMAL(12,2);	-- Variable para el monto peniente
	DECLARE Var_TipoCanal		INT(11);		-- Variable para el tipo de canal
	DECLARE Var_TipoDeposito	CHAR(1);		-- Variable para el tipo de deposito
	DECLARE Var_Moneda 			INT(11);		-- Variable para el tipo de moneda
	DECLARE Var_InsertaTabla	CHAR(1);		-- Variable para indicar si se inserta en tabla
	DECLARE Var_NumIdenArchivo	VARCHAR(20);	-- Variable para el numero de indentificador del archivo
	DECLARE Var_BancoEstandar	CHAR(1);		-- Variable para indicar si no es de banco (estandar) o de tipo bancario
	DECLARE Var_ConceptoArchivo	VARCHAR(150);	-- Variable para el concepto del movimiento.
	DECLARE Error_Key			INT(11);

	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT(11);
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Fecha_Vacia		DATE;
	DECLARE Con_SalidaNo	CHAR(1);
	DECLARE Con_Aplicado	CHAR(1);
	DECLARE SalidaSI		CHAR(1);
	DECLARE Con_Origen      CHAR(1);

	-- Seteo de Valores
	SET Entero_Cero			:= 0;
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Aud_FechaActual 	:= NOW();
	SET Var_FechaSis		:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Con_SalidaNo		:= 'N';
	SET Con_Aplicado		:= 'A';
	SET SalidaSI			:= 'S';
	SET Con_Origen			:= 'R';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocaciones. Ref: SP-DEPREFAUTOMATICOPRO');
			SET Var_Control	:='SQLEXCEPTION';
		END;

		START TRANSACTION;
		InicioTransaccion:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
		DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
		DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
		DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

		SET Error_Key				:= Entero_Cero;

		DELETE FROM TMPDEPREFAUTOMATICO;

		SET @Numero :=0;

		INSERT INTO TMPDEPREFAUTOMATICO(
			Numero,				ConsecutivoID,		InstitucionID, 	NumCtaInstit, 	FechaOperacion,
			ReferenciaMov,		DescripcionMov,		NatMovimiento, 	MontoMov, 		MontoPendApli,
			TipoCanal,			TipoDeposito,		Moneda, 		InsertaTabla, 	NumIdenArchivo,
			BancoEstandar,		ConceptoArchivo)
		SELECT
			@Numero:=@Numero+1,	ConsecutivoID, 		InstitucionID, 	NumCtaInstit, 	FechaOperacion,
			ReferenciaMov,		DescripcionMov, 	NatMovimiento, 	MontoMov, 		MontoPendApli,
			TipoCanal,			TipoDeposito, 		Moneda, 		InsertaTabla, 	NumIdenArchivo,
			BancoEstandar,		ConceptoArchivo
		FROM DEPREFAUTOMATICO
		WHERE FechaOperacion <= Var_FechaSis
			AND Estatus ='N';

		SELECT IFNULL(MAX(Numero),Entero_Cero) INTO Var_Limite
		FROM TMPDEPREFAUTOMATICO;

		SET Var_Contador := 1;

		realizaPagos:WHILE Var_Contador <= Var_Limite DO

			SELECT
				ConsecutivoID,		InstitucionID,		NumCtaInstit,	 	FechaOperacion,			ReferenciaMov,
				DescripcionMov,		NatMovimiento,		MontoMov,	 		MontoPendApli,			TipoCanal,
				TipoDeposito,		Moneda,				InsertaTabla,	 	NumIdenArchivo,			BancoEstandar,
				RIGHT(TRIM(ConceptoArchivo),15)
			INTO
				Var_ConsecutivoID,	Var_InstitucionID, 	Var_NumCtaInstit,	Var_FechaOperacion,		Var_ReferenciaMov,
				Var_DescripcionMov,	Var_NatMovimiento, 	Var_MontoMov,		Var_MontoPendApli,		Var_TipoCanal,
				Var_TipoDeposito,	Var_Moneda, 		Var_InsertaTabla,	Var_NumIdenArchivo,		Var_BancoEstandar,
				Var_ConceptoArchivo
			FROM TMPDEPREFAUTOMATICO
			WHERE Numero = Var_Contador;

			CALL DEPOSITOREFEREPRO(
				Var_InstitucionID,	Var_NumCtaInstit,	Var_FechaOperacion,		Var_ConceptoArchivo,Var_DescripcionMov,
				Var_NatMovimiento,	Var_MontoMov,		Var_MontoPendApli,		Var_TipoCanal,		Var_TipoDeposito,
				Var_Moneda,			Var_InsertaTabla,	Var_NumIdenArchivo,		Var_BancoEstandar,	Entero_Cero,
				Con_SalidaNo,		Par_NumErr,			Par_ErrMen,				Var_Consecutivo,	Aud_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			UPDATE DEPREFAUTOMATICO
			SET
				Estatus			= IF(Par_NumErr = Entero_Cero,Con_Aplicado,Estatus),
				FechaActual		= Aud_FechaActual,
				NumTransaccion	= Aud_NumTransaccion,
				NumErr			= Par_NumErr,
				ErrMen			= Par_ErrMen
			WHERE ConsecutivoID = Var_ConsecutivoID;

			IF Par_NumErr != Entero_Cero THEN
				LEAVE ManejoErrores;
			END IF;

			SET Var_Contador := Var_Contador+1;
		END WHILE realizaPagos;

		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= 'Depositos Realizados Exitosamente.';
		SET Var_Control := 'Control';

	END InicioTransaccion;
	END ManejoErrores;
	IF Error_Key = 0 && Par_NumErr = Entero_Cero THEN
			COMMIT;
		ELSE
			ROLLBACK;
	END IF;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS Control,
				Entero_Cero		AS Consecutivo;
	END IF;
END TerminaStore$$