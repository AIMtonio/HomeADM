
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAMBIOTASAAPORTCIERREALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAMBIOTASAAPORTCIERREALT`;
DELIMITER $$

CREATE PROCEDURE `CAMBIOTASAAPORTCIERREALT`(
-- =========================================================================
-- ---- SP PARA REGISTRAR LOS CAMBIOS MANUALES DE TASAS DE APORTACIONES ----
-- =========================================================================
	Par_AportacionID			BIGINT(20), 			-- ID de la aportacion
	Par_NuevaAportID			BIGINT(20), 			-- ID de la nueva aportacion
	Par_TipoAportID				BIGINT(20),				-- ID del tipo de aportacion
	Par_Salida 					CHAR(1), 				-- Salida en Pantalla
	INOUT Par_NumErr 			INT(11),				-- Parametro de numero de error

	INOUT Par_ErrMen 			VARCHAR(400),			-- Parametro de mensaje de error
	Par_EmpresaID				INT(11),				-- Parametro de Auditoria
	Aud_Usuario					INT(11),				-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),			-- Parametro de Auditoria

	Aud_ProgramaID				VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal				INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)				-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Consecutivo			BIGINT(20);			-- consecutivo de la tabla
	DECLARE Var_Coment				VARCHAR (100);		-- Comentario de cambio de tasa
	DECLARE Var_Control				VARCHAR(50);		-- Control
	DECLARE Var_ClaveUsuario		VARCHAR(50);		-- Clave de usuario
	DECLARE Var_TasaFV				VARCHAR(50);		-- Almacena tasa fija variable
	DECLARE Var_EspTasa				VARCHAR(50);		-- Almacena si se especifica tasa
	DECLARE Var_CamTasaID			BIGINT(20);			-- Consecutivo del cambio de tasa de las cond de vencimiento.

	-- Declaracion de constantes
	DECLARE	Entero_Cero				INT(11);
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE Var_Si					CHAR(1);
	DECLARE Cons_TasaFija			CHAR(1);
	DECLARE	TipoReg_Aport			INT(11);
	DECLARE	TipoReg_CondV			INT(11);

	SET	Entero_Cero					:= 0;				-- Constante Entero Cero
	SET	Decimal_Cero				:= 0.0;				-- Constante DECIMAL Cero
	SET Var_Si						:= 'S';				-- Salida Si
	SET Cons_TasaFija				:= 'F';				-- Tasa fija
	SET	TipoReg_Aport				:= 01;				-- Tipo de Registro Alta de aportaciones.
	SET	TipoReg_CondV				:= 02;				-- Tipo de Registro Alta de condiciones de vencimiento.

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr :=	999;
				SET Par_ErrMen :=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-CAMBIOTASAAPORTCIERREALT');
			END;

		IF(IFNULL(Par_AportacionID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr	:=	1;
			SET Par_ErrMen	:=	'El Numero de Aportacion se Encuentra Vacio.';
			SET Var_Control	:=	'aportacionID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TipoAportID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr	:=	2;
			SET Par_ErrMen	:=	'El tipo de Aportacion se Encuentra Vacio.';
			SET Var_Control	:=	'aportacionID';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT * FROM TIPOSAPORTACIONES WHERE TipoAportacionID=Par_TipoAportID) THEN
			SET Par_NumErr	:=	3;
			SET Par_ErrMen	:=	'El tipo de Aportacion no Existe.';
			SET Var_Control	:=	'aportacionID';
			LEAVE ManejoErrores;
		END IF;

		SELECT TasaFV,EspecificaTasa INTO Var_TasaFV,Var_EspTasa
		FROM TIPOSAPORTACIONES
		WHERE TipoAportacionID = Par_TipoAportID;

		/** SE OBTIENE EL REGISTRO DEL CAMBIO DE TASA QUE TUVO CUANDO
		 ** SE CAPTURARON LAS CONDICIONES DE VENCIMIENTO PARA LA NUEVA APORTACIÓN (APORTACIÓN RENOVADA). */
		SET Var_CamTasaID := (SELECT MAX(ConsecutivoID) FROM CAMBIOTASAAPORT WHERE AportacionID = Par_AportacionID AND TipoRegistro = TipoReg_CondV);
		SET Var_CamTasaID := IFNULL(Var_CamTasaID, Entero_Cero);

		# SI ES TASA FIJA Y SI ESPECIFICA TASA MANUAL.
		IF(Var_TasaFV = Cons_TasaFija AND Var_EspTasa = Var_Si)THEN
			# SI HUBO UN CAMBIO DE TASA EN SUS COND DE VENC.
			IF(Var_CamTasaID > Entero_Cero)THEN
				SET Var_Consecutivo := (SELECT MAX(ConsecutivoID) FROM CAMBIOTASAAPORT);
				SET Var_Consecutivo := IFNULL(Var_Consecutivo,Entero_Cero)+1;

				SET Var_ClaveUsuario:= (SELECT UPPER(Clave) FROM USUARIOS WHERE UsuarioID=Aud_Usuario);

				# REGISTRO DEL CAMBIO DE TASA, SI AL MOMENTO DE REGISTRAR LAS CONDICIONES PARA LA NUEVA APORTACIÓN TUVO UN CAMBIO DE TASA.
				INSERT INTO CAMBIOTASAAPORT (
					ConsecutivoID,		AportacionID,		TasaSugerida,		TasaNueva,			Comentario,
					ClaveUsuario,		TipoRegistro,		EmpresaID,			Usuario,			FechaActual,
					DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					Var_Consecutivo,	Par_NuevaAportID, 	TasaSugerida, 		TasaNueva, 			Comentario,
					ClaveUsuario,		TipoReg_Aport,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM CAMBIOTASAAPORT
				WHERE ConsecutivoID = Var_CamTasaID;
			END IF;
		END IF;

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:=	CONCAT('Modificacion de tasa agregada exitosamente: ', CONVERT(Par_AportacionID, CHAR),'.');
		SET Var_Control	:=	'aportacionID';

	END ManejoErrores;

	IF(Par_Salida = Var_Si)THEN
		SELECT 	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control,
				Par_AportacionID 	AS consecutivo;
	END IF;

END TerminaStore$$

