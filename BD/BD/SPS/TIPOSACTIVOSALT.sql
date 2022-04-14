-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSACTIVOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSACTIVOSALT`;

DELIMITER $$
CREATE PROCEDURE `TIPOSACTIVOSALT`(
	# =====================================================================================
	# ------- STORED PARA ALTA DE TIPOS DE ACTIVOS ---------
	# =====================================================================================
	Par_Descripcion			VARCHAR(300), 	-- Descripcion larga del tipo de activo
	Par_DescripcionCorta	VARCHAR(15), 	-- Descripcion corta del tipo de activo
	Par_DepreciacionAnual	DECIMAL(14,2), 	-- % puede ser un valor a dos decimales en un rango del 1 al 100
	Par_ClasificaActivoID	INT(11), 		-- ID Tipo de clasificacion del activo,TABLA CLASIFICACTIVOS
	Par_TiempoAmortiMeses	INT(11), 		-- tiempo en meses que se consideraran para amortizar el activo esto solo tratandose de "Otros Activos", en el caso de "Activo Fijo" su valor sera 12 ya que corresponde al periodo de un anio

	Par_Estatus				CHAR(1), 		-- Indica el estatus del tipo de activo, A=ACTIVO o I=INACTIVO

	Par_Salida				CHAR(1),		-- Parametro de salida S= si, N= no
	INOUT Par_NumErr		INT(11),		-- Parametro de salida numero de error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro de salida mensaje de error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Consecutivo		INT(14);		-- Variable consecutivo
	DECLARE Var_Control			VARCHAR(100);		-- Variable de Control
	DECLARE Var_TipoActivoID	INT(11);			-- Variable de ID tipo activo
	DECLARE Var_ClaveTipoActivo	CHAR(3);			-- Variable de Clave por Tipo de Activo

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);			-- Constante cadena vacia ''
	DECLARE Fecha_Vacia			DATE;				-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero			INT(11);			-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI			CHAR(1);			-- Parametro de salida SI

	DECLARE Salida_NO			CHAR(1);			-- Parametro de salida NO
	DECLARE Entero_Uno			INT(11);			-- Entero Uno
	DECLARE Entero_Tres			INT(11);			-- Entero Tres
	DECLARE Entero_Doce			INT(11);			-- Entero Doce

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI				:= 'S';

	SET Salida_NO				:= 'N';
	SET Entero_Uno				:= 1;
	SET Entero_Tres				:= 3;
	SET Entero_Doce				:= 12;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-TIPOSACTIVOSALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Var_Consecutivo	:= Entero_Cero;

		IF(IFNULL(Par_Descripcion, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'La Descripcion esta Vacia';
			SET Var_Control		:= 'descripcion';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_DescripcionCorta, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'La Descripcion Corta esta Vacia';
			SET Var_Control		:= 'descripcionCorta';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ClasificaActivoID, Entero_Cero) = Entero_Uno)THEN
			IF(IFNULL(Par_DepreciacionAnual, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr 		:= 3;
				SET Par_ErrMen 		:= 'El Porcentaje esta Vacio';
				SET Var_Control		:= 'depreciacionAnual';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_ClasificaActivoID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 4;
			SET Par_ErrMen 		:= 'La Clasificacion esta Vacia';
			SET Var_Control		:= 'clasificaActivoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TiempoAmortiMeses, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 5;
			SET Par_ErrMen 		:= 'El Tiempo Amortizar en Meses esta Vacio';
			SET Var_Control		:= 'depreciacionAnual';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Estatus, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 6;
			SET Par_ErrMen 		:= 'El Estatus esta Vacio';
			SET Var_Control		:= 'estatus';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TiempoAmortiMeses, Entero_Cero) > Entero_Doce) THEN
			SET Par_NumErr 		:= 7;
			SET Par_ErrMen 		:= 'El Tiempo Amortizar en Meses debe ser Mayor a 0 y Menor o Igual a 12';
			SET Var_Control		:= 'depreciacionAnual';
			LEAVE ManejoErrores;
		END IF;

		SET Par_DescripcionCorta := IFNULL(Par_DescripcionCorta, Cadena_Vacia);
		SET Var_ClaveTipoActivo := LEFT( UPPER(Par_DescripcionCorta), Entero_Tres);
		SET Var_ClaveTipoActivo := IFNULL(Var_ClaveTipoActivo, Cadena_Vacia);
		IF( LENGTH(Var_ClaveTipoActivo) <> Entero_Tres ) THEN
			SET Par_NumErr 		:= 8;
			SET Par_ErrMen 		:= 'La Clave del Tipo Activo no es Valida.';
			SET Var_Control		:= 'claveTipoActivo';
			LEAVE ManejoErrores;
		END IF;

		SET Var_TipoActivoID := (SELECT IFNULL(MAX(TipoActivoID),Entero_Cero) + Entero_Uno FROM TIPOSACTIVOS);
		SET Aud_FechaActual := NOW();

		INSERT INTO TIPOSACTIVOS(
			TipoActivoID, 			Descripcion,		DescripcionCorta,		DepreciacionAnual,		ClasificaActivoID,
			TiempoAmortiMeses,		Estatus,			ClaveTipoActivo,
			EmpresaID, 				Usuario, 			FechaActual, 			DireccionIP,			ProgramaID,
			Sucursal, 				NumTransaccion)
		VALUES(
			Var_TipoActivoID,		Par_Descripcion,	Par_DescripcionCorta,	Par_DepreciacionAnual,	Par_ClasificaActivoID,
			Par_TiempoAmortiMeses,	Par_Estatus,		Var_ClaveTipoActivo,
			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion);

		SET Par_NumErr 		:= Entero_Cero;
		SET Par_ErrMen 		:= CONCAT('Tipo de Activo Agregado Exitosamente:',CAST(Var_TipoActivoID AS CHAR) );
		SET Var_Control		:= 'tipoActivoID';
		SET Var_Consecutivo	:= Var_TipoActivoID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$