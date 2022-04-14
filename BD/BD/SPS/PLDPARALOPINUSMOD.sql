
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDPARALOPINUSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDPARALOPINUSMOD`;

DELIMITER $$
CREATE PROCEDURE `PLDPARALOPINUSMOD`(
/*SP PARA MODIFICAR LOS PARAMETROS DE ALERTA DE OPERACIONES INUSUALES*/
	Par_TipoPersona				CHAR(1),					-- Tipo de Persona A:Alto M:Medio B:Bajo
	Par_NivelRiesgo				CHAR(1),					-- Nivel de Riesgo A: Alto B:Bajo M: Medio
	Par_FolioID					INT,						-- Folio de la parametrizacion
	Par_FechaVigencia			DATE,						-- Fecha de vigencia
	Par_TipoInstruMonID 		VARCHAR(10),				-- Tipo de Instrumento ID

	Par_VarPTrans 				DECIMAL(14,2),				-- % Cambio Mínimo en Perfil Transaccional
	Par_VarPagos 				DECIMAL(14,2),				-- % Cambio Mínimo en Pagos Exigibles
	Par_VarPlazo 				INT(11),					-- Plazo en dias
	Par_LiquidAnticipad 		CHAR(1),					-- Permite reportar por liquidación anticipada
	Par_Estatus 				CHAR(1),

	Par_VarNumDep				DECIMAL(14,2),				-- % Cambio Mínimo en Número de Depositos
	Par_VarNumRet				DECIMAL(14,2),				-- % Cambio Mínimo en Número de Retiros
	Par_PorcAmoAnt				DECIMAL(14,2),				-- % para Pago Anticipado de Créditos sobre el Monto de la Cuota.
	Par_PorcLiqAnt				DECIMAL(14,2),				-- % Liquidación Anticipada de Créditos sobre el Monto Total del Crédito (Capital + Interés). Solo si LiquidAnticipad es S.
	Par_PorcDiasLiqAnt			DECIMAL(14,2),				-- % de Días que se tendrá permitido Liquidar un Crédito de manera Anticipada.

	Par_Salida					CHAR(1),					-- Salida S:S N:No
	INOUT Par_NumErr			INT(11),					-- Numero de error
	INOUT Par_ErrMen			VARCHAR(400),				-- Mensaje de error
	Aud_EmpresaID				INT,
	Aud_Usuario					INT(11),					-- Auditoria

	Aud_FechaActual				DATETIME,					-- Auditoria
	Aud_DireccionIP				VARCHAR(15),				-- Auditoria
	Aud_ProgramaID				VARCHAR(50),				-- Auditoria
	Aud_Sucursal				INT(11),					-- Auditoria
	Aud_NumTransaccion			BIGINT(20)					-- Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaSis				DATE;					# Fecha del sistema
	DECLARE Var_AntTipoInstruMonID		VARCHAR(10);			# Valores Anteriores Tipo de instrumento, campo del catalogo de tipo de  instrumentos, no es la cve del instrumento si no la categoria de clasificacion',
	DECLARE Var_AntVarPTrans			DECIMAL(14,2);			# Valores Anteriores % de variacion maxima positiva antes de reportar cambios en el perfil transaccional (OPI3a)',
	DECLARE Var_AntVarPagos				DECIMAL(14,2);			# Valores Anteriores % de variacion maxima  positiva antes de reportar pagos del cliente vs cuotas exigibles (OPI3b)',
	DECLARE Var_AntVarPlazo				INT(11);				# Valores Anteriores Anterior numero de dias maximo antes de reportar pagos anticipados (OPI3c)
	DECLARE Var_AntLiquidAnticipad		CHAR(1);				# Valores Anteriores Si reporta como inusuales las liquidaciones anticipadas\nS=Si\nN=No',
	DECLARE Var_AntDiasMaxDeteccion		INT(11);				# Valores Anteriores Anterior Dias Maximos para Poder reportar una Operacion Detectada a partir de la Fecha de Deteccion
	DECLARE Var_AntVarNumDep			DECIMAL(14,2);			# Valores Anteriores % de variacion maxima positiva antes de reportar cambios en el Numero de Depositos',
	DECLARE Var_AntVarNumRet			DECIMAL(14,2);			# Valores Anteriores % de variacion maxima positiva antes de reportar cambios en el Numero de Retiros',
	DECLARE Var_AntPorcAmoAnt			DECIMAL(14,2);			-- % para Pago Anticipado de Créditos sobre el Monto de la Cuota.
	DECLARE Var_AntPorcLiqAnt			DECIMAL(14,2);			-- % Liquidación Anticipada de Créditos sobre el Monto Total del Crédito (Capital + Interés). Solo si LiquidAnticipad es S.
	DECLARE Var_AntPorcDiasLiqAnt		DECIMAL(14,2);			-- % Liquidación Anticipada de Créditos sobre el Monto Total del Crédito (Capital + Interés). Solo si LiquidAnticipad es S.
	DECLARE	Var_Control					CHAR(15);				-- Control.

	-- Declaracion de constantes
	DECLARE Entero_Cero       		INT;
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE Decimal_Cero      		DECIMAL(14,2);
	DECLARE	Str_SI					CHAR(1);
	DECLARE	Str_NO					CHAR(1);
	DECLARE	Entero_Negativo			INT;
	DECLARE Fecha_Vacia				DATE;
	DECLARE Porc_Cient				DECIMAL(14,2);
	DECLARE	Est_Baja				CHAR(1);

	-- Asignacion de Constantes
	SET Entero_Cero 				:=0;
	SET Cadena_Vacia				:= '';
	SET Decimal_Cero 				:=0.00;
	SET	Str_SI						:= 'S';
	SET	Str_NO						:= 'N';
	SET	Entero_Negativo				:= -1;
	SET Fecha_Vacia    		 		:= '1900-01-01';
	SET Porc_Cient					:= 100.0;		-- Porcentaje Cien
	SET Est_Baja					:= 'B';			-- Estatus Baja.


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-PLDPARALOPINUSMOD[',@Var_SQLState,'-' , @Var_SQLMessage,']');
			SET Var_Control:= 'sqlException';
		END;

		SET Var_FechaSis:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		IF(IFNULL(Par_TipoPersona, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El Tipo de Persona esta Vacio.';
			SET Var_Control:= 'fechaVigencia' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NivelRiesgo, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'El Nivel de Riesgo esta Vacio.';
			SET Var_Control:= 'fechaVigencia' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaVigencia, Fecha_Vacia)) = Fecha_Vacia THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := 'La Fecha de Vigencia esta Vacia.';
			SET Var_Control:= 'fechaVigencia' ;
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_TipoInstruMonID, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen := 'El Tipo de Instrumento esta Vacio.';
			SET Var_Control:= 'tipoInstruMonID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_VarPTrans, Decimal_Cero)) = Decimal_Cero THEN
			SET Par_NumErr := 005;
			SET Par_ErrMen := 'El Porcentaje de Cambio Minimo en Perfil Transaccional esta Vacio.';
			SET Var_Control:= 'varPTrans' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_VarPTrans, Decimal_Cero)) > Porc_Cient THEN
			SET Par_NumErr := 006;
			SET Par_ErrMen := 'El Porcentaje de Cambio Minimo en Perfil Transaccional debe de ser entre 0 y 100.';
			SET Var_Control:= 'varPTrans' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_VarPagos, Decimal_Cero)) = Decimal_Cero THEN
			SET Par_NumErr := 007;
			SET Par_ErrMen := 'El Porcentaje de Cambio Minimo en Pagos Exigibles esta Vacio.';
			SET Var_Control:= 'varPagos' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_VarPagos, Decimal_Cero)) > Porc_Cient THEN
			SET Par_NumErr := 008;
			SET Par_ErrMen := 'El Porcentaje de Cambio Minimo en Pagos Exigibles debe de ser entre 0 y 100.' ;
			SET Var_Control:= 'varPagos' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_VarPlazo, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 009;
			SET Par_ErrMen := 'El Plazo Minimo de Pago Anticipado esta Vacio.';
			SET Var_Control:= 'varPlazo' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_LiquidAnticipad, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 010;
			SET Par_ErrMen := 'El Reporte de Liquidacion Anticipada esta Vacio.';
			SET Var_Control:= 'liquidAnticipad1' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_VarNumDep, Decimal_Cero)) = Decimal_Cero THEN
			SET Par_NumErr := 011;
			SET Par_ErrMen := 'El Porcentaje de Cambio Minimo en Numero de Depositos Extras esta Vacio.';
			SET Var_Control:= 'varNumDep' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_VarNumDep, Decimal_Cero)) > Porc_Cient THEN
			SET Par_NumErr := 012;
			SET Par_ErrMen := 'El Porcentaje de Cambio Minimo en Numero de Depositos Extras debe ser entre 0 y 100.';
			SET Var_Control:= 'varNumDep' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_VarNumRet, Decimal_Cero)) = Decimal_Cero THEN
			SET Par_NumErr := 013;
			SET Par_ErrMen := 'El Porcentaje de Cambio Minimo en Numero de Retiros Extras esta Vacio.';
			SET Var_Control:= 'varNumRet' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_VarNumRet, Decimal_Cero)) > Porc_Cient THEN
			SET Par_NumErr := 014;
			SET Par_ErrMen := 'El Porcentaje de Cambio Minimo en Perfil Transaccional debe de ser entre 0 y 100';
			SET Var_Control:= 'varNumRet' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PorcAmoAnt, Decimal_Cero) NOT BETWEEN Decimal_Cero AND Porc_Cient)THEN
			SET Par_NumErr := 015;
			SET Par_ErrMen := 'El Porcentaje para el Monto Cuota Anticipada debe de ser entre 0 y 100.';
			SET Var_Control:= 'porcAmoAnt' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PorcLiqAnt, Decimal_Cero) NOT BETWEEN Decimal_Cero AND Porc_Cient)THEN
			SET Par_NumErr := 016;
			SET Par_ErrMen := 'El Porcentaje de Liquidacion Anticipada debe de ser entre 0 y 100.';
			SET Var_Control:= 'porcLiqAnt' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PorcDiasLiqAnt, Decimal_Cero) NOT BETWEEN Decimal_Cero AND Porc_Cient)THEN
			SET Par_NumErr := 017;
			SET Par_ErrMen := 'El Porcentaje de Dias en Liquidacion Anticipada debe de ser entre 0 y 100.';
			SET Var_Control:= 'porcDiasLiqAnt' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_LiquidAnticipad = Str_NO)THEN
			SET Par_PorcLiqAnt		:= Decimal_Cero;
			SET Par_PorcDiasLiqAnt	:= Decimal_Cero;
		END IF;

		SELECT
			PLD.TipoInstruMonID,		PLD.VarPTrans,		PLD.VarPagos,		PLD.VarPlazo,		PLD.LiquidAnticipad,
			PLD.DiasMaxDeteccion,		PLD.VarNumDep,		PLD.VarNumRet,		PLD.PorcAmoAnt,		PLD.PorcLiqAnt,
			PLD.PorcDiasLiqAnt
		INTO
			Var_AntTipoInstruMonID,		Var_AntVarPTrans,	Var_AntVarPagos,	Var_AntVarPlazo,	Var_AntLiquidAnticipad,
			Var_AntDiasMaxDeteccion,	Var_AntVarNumDep,	Var_AntVarNumRet,	Var_AntPorcAmoAnt,	Var_AntPorcLiqAnt,
			Var_AntPorcDiasLiqAnt
		FROM PLDPARALEOPINUS AS PLD
		WHERE PLD.NivelRiesgo = Par_NivelRiesgo
			AND PLD.TipoPersona = Par_TipoPersona
		LIMIT 1;

		IF( IFNULL(Var_AntTipoInstruMonID, Cadena_Vacia)	!= IFNULL(Par_TipoInstruMonID, Cadena_Vacia) OR
			IFNULL(Var_AntVarPTrans, Entero_Cero)			!= IFNULL(Par_VarPTrans, Entero_Cero) OR
			IFNULL(Var_AntVarPagos, Entero_Cero)			!= IFNULL(Par_VarPagos, Entero_Cero) OR
			IFNULL(Var_AntVarPlazo, Entero_Cero)			!= IFNULL(Par_VarPlazo, Entero_Cero) OR
			IFNULL(Var_AntLiquidAnticipad, Cadena_Vacia)	!= IFNULL(Par_LiquidAnticipad, Cadena_Vacia) OR
			IFNULL(Var_AntDiasMaxDeteccion, Entero_Cero)	!= IFNULL(Par_VarPlazo, Entero_Cero) OR
			IFNULL(Var_AntVarNumDep, Entero_Cero)			!= IFNULL(Par_VarNumDep, Entero_Cero) OR
			IFNULL(Var_AntVarNumRet, Entero_Cero)			!= IFNULL(Par_VarNumRet, Entero_Cero) OR
			IFNULL(Var_AntPorcAmoAnt, Entero_Cero)			!= IFNULL(Par_PorcAmoAnt, Entero_Cero) OR
			IFNULL(Var_AntPorcLiqAnt, Entero_Cero)			!= IFNULL(Par_PorcLiqAnt, Entero_Cero) OR
			IFNULL(Var_AntPorcDiasLiqAnt, Entero_Cero)		!= IFNULL(Par_PorcDiasLiqAnt, Entero_Cero)) THEN

			INSERT INTO PLDHISPARALEOPINUS(
				Fecha,				FolioID,		TipoPersona,	NivelRiesgo,	FechaVigencia,
				TipoInstruMonID,	VarPTrans,		VarPagos,		VarPlazo,		LiquidAnticipad,
				DiasMaxDeteccion,	Estatus,		VarNumDep,		VarNumRet,		PorcDiasMax,
				PorcAmoAnt,			PorcLiqAnt,		PorcDiasLiqAnt,	EmpresaID,		Usuario,
				FechaActual,		DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion)
			SELECT
				Var_FechaSis,		FolioID,		TipoPersona,	NivelRiesgo,	FechaVigencia,
				TipoInstruMonID,	VarPTrans,		VarPagos,		VarPlazo,		LiquidAnticipad,
				DiasMaxDeteccion,	Est_Baja,		VarNumDep,		VarNumRet,		PorcDiasMax,
				PorcAmoAnt,			PorcLiqAnt,		PorcDiasLiqAnt,	EmpresaID,		Usuario,
				FechaActual,		DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion
			FROM PLDPARALEOPINUS AS PLD
			WHERE PLD.NivelRiesgo = Par_NivelRiesgo
				AND PLD.TipoPersona = Par_TipoPersona;

			SET Par_FolioID 		:= (SELECT MAX(FolioID) FROM PLDPARALEOPINUS AS PLD);
			SET Par_FechaVigencia	:= Var_FechaSis;
		END IF;

		SET Par_FolioID			:= IFNULL(Par_FolioID,Entero_Cero)+1;
		SET Aud_FechaActual 	:= NOW();

		UPDATE PLDPARALEOPINUS
		SET
			FolioID				= Par_FolioID,
			FechaVigencia		= Par_FechaVigencia,
			TipoInstruMonID		= Par_TipoInstruMonID,
			VarPTrans			= Par_VarPTrans,
			VarPagos			= Par_VarPagos,

			VarPlazo			= Par_VarPlazo,
			LiquidAnticipad		= Par_LiquidAnticipad,
			VarNumDep			= Par_VarNumDep,
			VarNumRet			= Par_VarNumRet,
			PorcAmoAnt			= Par_PorcAmoAnt,

			PorcLiqAnt			= Par_PorcLiqAnt,
			PorcDiasLiqAnt		= Par_PorcDiasLiqAnt,
			EmpresaID			= Aud_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual			= Aud_FechaActual,

			DireccionIP			= Aud_DireccionIP,
			ProgramaID			= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion 		= Aud_NumTransaccion
		WHERE TipoPersona		= Par_TipoPersona
			AND NivelRiesgo		= Par_NivelRiesgo;

		SET	Par_NumErr := 0;
		SET	Par_ErrMen := CONCAT("Parametrizacion Modificada Exitosamente: ",Par_FolioID,'.');
		SET Var_Control :='folioID';

	END ManejoErrores;  -- En del Handler de Errores

	 IF (Par_Salida = Str_SI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_FolioID AS Consecutivo;
	 END IF;

END TerminaStore$$

