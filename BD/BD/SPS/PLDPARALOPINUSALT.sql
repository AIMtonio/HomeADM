
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDPARALOPINUSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDPARALOPINUSALT`;

DELIMITER $$
CREATE PROCEDURE `PLDPARALOPINUSALT`(
/*SP PARA DAR DE ALTA LOS PARAMETROS DE ALERTA DE OPERACIONES INUSUALES*/
	Par_TipoPersona				CHAR(1),					-- Tipo de Persona A:Alto M:Medio B:Bajo
	Par_NivelRiesgo				CHAR(1),					-- Nivel de Riesgo A: Alto B:Bajo M: Medio
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
	Aud_EmpresaID				INT(11),					-- Auditoria
	Aud_Usuario					INT(11),					-- Auditoria
	Aud_FechaActual				DATETIME,					-- Auditoria

	Aud_DireccionIP				VARCHAR(15),				-- Auditoria
	Aud_ProgramaID				VARCHAR(50),				-- Auditoria
	Aud_Sucursal				INT(11),					-- Auditoria
	Aud_NumTransaccion			BIGINT(20)					-- Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	Var_FolioID				INT(11);	-- Folio Consecutivo de la tabla PLDPARALEOPINUS
	DECLARE	Var_Control   			CHAR(15);	-- Control.

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT;
	DECLARE Decimal_Cero			DECIMAL(14,2);
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Entero_Negativo			INT;
	DECLARE Fecha_Vacia				DATE;
	DECLARE	Str_SI					CHAR(1);
	DECLARE	Str_NO					CHAR(1);
	DECLARE NumDiasMaxDeteccion		INT(11);
	DECLARE Porc_Cient				DECIMAL(14,2);

	-- Asignacion de Constantes
	SET Entero_Cero 				:=0;			-- Constante Entero Cero
	SET Decimal_Cero 				:=0.00;			-- Decimal Cero
	SET Cadena_Vacia				:= '';			-- Constante Cadena Vacia
	SET	Entero_Negativo				:= -1;			-- Numero entero negativo
	SET Fecha_Vacia    		 		:= '1900-01-01';-- Fecha Vacia
	SET	Str_SI						:= 'S';			-- Salida SI
	SET	Str_NO						:= 'N'; 		-- Salida NO
	SET NumDiasMaxDeteccion			:= 60;			-- 60 dias xomo maximo de detecciÃ³n
	SET Porc_Cient					:= 100.0;		-- Porcentaje Cien


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 'esto le ocasiona. Ref: SP-PLDPARALOPINUSALT[',@Var_SQLState,'-' , @Var_SQLMessage,']');
			SET Var_Control:= 'sqlException';
		END;

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
			SET Par_NumErr := 006;
			SET Par_ErrMen := 'El Porcentaje de Cambio Minimo en Pagos Exigibles esta Vacio.';
			SET Var_Control:= 'varPagos' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_VarPagos, Decimal_Cero)) > Porc_Cient THEN
			SET Par_NumErr := 007;
			SET Par_ErrMen := 'El Porcentaje de Cambio Minimo en Pagos Exigibles debe de ser entre 0 y 100.' ;
			SET Var_Control:= 'varPagos' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_VarPlazo, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 008;
			SET Par_ErrMen := 'El Plazo Minimo de Pago Anticipado esta Vacio.';
			SET Var_Control:= 'varPlazo' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_LiquidAnticipad, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 009;
			SET Par_ErrMen := 'El Reporte de Liquidacion Anticipada esta Vacio.';
			SET Var_Control:= 'liquidAnticipad1' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_VarNumDep, Decimal_Cero)) = Decimal_Cero THEN
			SET Par_NumErr := 010;
			SET Par_ErrMen := 'El Porcentaje de Cambio Minimo en Numero de Depositos Extras esta Vacio.';
			SET Var_Control:= 'varNumDep' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_VarNumDep, Decimal_Cero)) > Porc_Cient THEN
			SET Par_NumErr := 011;
			SET Par_ErrMen := 'El Porcentaje de Cambio Minimo en Numero de Depositos Extras debe ser entre 0 y 100.';
			SET Var_Control:= 'varNumDep' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_VarNumRet, Decimal_Cero)) = Decimal_Cero THEN
			SET Par_NumErr := 012;
			SET Par_ErrMen := 'El Porcentaje de Cambio Minimo en Numero de Retiros Extras esta Vacio.';
			SET Var_Control:= 'varNumRet' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_VarNumRet, Decimal_Cero)) > Porc_Cient THEN
			SET Par_NumErr := 013;
			SET Par_ErrMen := 'El Porcentaje de Cambio Minimo en Perfil Transaccional debe de ser entre 0 y 100';
			SET Var_Control:= 'varNumRet' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PorcAmoAnt, Decimal_Cero) NOT BETWEEN Decimal_Cero AND Porc_Cient)THEN
			SET Par_NumErr := 014;
			SET Par_ErrMen := 'El Porcentaje para el Monto Cuota Anticipada debe de ser entre 0 y 100.';
			SET Var_Control:= 'porcAmoAnt' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PorcLiqAnt, Decimal_Cero) NOT BETWEEN Decimal_Cero AND Porc_Cient)THEN
			SET Par_NumErr := 015;
			SET Par_ErrMen := 'El Porcentaje de Liquidacion Anticipada debe de ser entre 0 y 100.';
			SET Var_Control:= 'porcLiqAnt' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PorcDiasLiqAnt, Decimal_Cero) NOT BETWEEN Decimal_Cero AND Porc_Cient)THEN
			SET Par_NumErr := 015;
			SET Par_ErrMen := 'El Porcentaje de Dias en Liquidacion Anticipada debe de ser entre 0 y 100.';
			SET Var_Control:= 'porcDiasLiqAnt' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_LiquidAnticipad = Str_NO)THEN
			SET Par_PorcLiqAnt		:= Decimal_Cero;
			SET Par_PorcDiasLiqAnt	:= Decimal_Cero;
		END IF;

		SET Aud_FechaActual	:= NOW();
		SET Var_FolioID		:= (SELECT IFNULL(MAX(FolioID),Entero_Cero) + 1  FROM PLDPARALEOPINUS);

		INSERT INTO PLDPARALEOPINUS(
			TipoPersona,		NivelRiesgo,		FolioID,			FechaVigencia,		TipoInstruMonID,
			VarPTrans,			VarPagos,			VarPlazo,			LiquidAnticipad,	DiasMaxDeteccion,
			Estatus,			VarNumDep,			VarNumRet,			PorcAmoAnt,			PorcLiqAnt,
			PorcDiasLiqAnt,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
			ProgramaID,			Sucursal,			NumTransaccion)
		VALUES(
			Par_TipoPersona,	Par_NivelRiesgo,	Var_FolioID,		Par_FechaVigencia,	Par_TipoInstruMonID,
			Par_VarPTrans,		Par_VarPagos,		Par_VarPlazo,		Par_LiquidAnticipad,NumDiasMaxDeteccion,
			Par_Estatus,		Par_VarNumDep,		Par_VarNumRet,		Par_PorcAmoAnt,		Par_PorcLiqAnt,
			Par_PorcDiasLiqAnt,	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


		SET	Par_NumErr := 0;
		SET	Par_ErrMen := CONCAT("Parametros Agregados Exitosamente: ",Var_FolioID);
		SET Var_Control :='folioID';

	END ManejoErrores;  -- End del Handler de Errores

	 IF (Par_Salida = Str_SI) THEN
		SELECT	CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_FolioID AS Consecutivo;
	 END IF;

END TerminaStore$$

