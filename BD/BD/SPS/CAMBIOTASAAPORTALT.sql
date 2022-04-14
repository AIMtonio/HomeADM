
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAMBIOTASAAPORTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAMBIOTASAAPORTALT`;
DELIMITER $$

CREATE PROCEDURE `CAMBIOTASAAPORTALT`(
-- =========================================================================
-- ---- SP PARA REGISTRAR LOS CAMBIOS MANUALES DE TASAS DE APORTACIONES ----
-- =========================================================================
	Par_AportacionID			BIGINT(20), 			-- ID de la aportacion
	Par_TasaSugerida			DECIMAL(12,2),			-- Tasa sugerida por Safi
	Par_TasaNueva				DECIMAL(12,2),			-- Tasa nueva (ingresada manualmente)
	Par_TipoRegistro			INT(11),				-- Tipo de Registro. 1: Alta de aportaciones. 2: Alta de condiciones de vencimiento.
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
    DECLARE Var_ClaveUsuario		VARCHAR(50);		-- Clade de usuario

	-- Declaracion de constantes
    DECLARE	Entero_Cero				INT(11);			-- Constante Entero Cero
	DECLARE Decimal_Cero			DECIMAL(12,2);		-- Constante DECIMAL Cero
    DECLARE Var_Si					CHAR(1);			-- VALOR S

    SET	Entero_Cero					:= 0;				-- Constante Entero Cero
	SET	Decimal_Cero				:= 0.0;				-- Constante DECIMAL Cero
    SET Var_Si						:= 'S';				-- Salida Si

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr :=	999;
				SET Par_ErrMen :=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-CAMBIOTASAAPORTALT');
			END;

        IF(IFNULL(Par_AportacionID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr	:=	1;
			SET Par_ErrMen	:=	'El Numero de Aportacion se Encuentra Vacio.';
			SET Var_Control	:=	'aportacionID';
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_TasaSugerida,Decimal_Cero) = Decimal_Cero) THEN
			SET Par_NumErr	:=	2;
			SET Par_ErrMen	:=	'La Tasa Sugerida se Encuentra Vacia.';
			SET Var_Control	:=	'aportacionID';
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_TasaNueva,Decimal_Cero) = Decimal_Cero) THEN
			SET Par_NumErr	:=	3;
			SET Par_ErrMen	:=	'La Tasa Nueva se Encuentra Vacia.';
			SET Var_Control	:=	'aportacionID';
			LEAVE ManejoErrores;
		END IF;

        SET Par_TasaSugerida	:= FORMAT(Par_TasaSugerida,2);
        SET Par_TasaNueva		:= FORMAT(Par_TasaNueva,2);

        SET Var_Coment := CONCAT('Especificacion Manual de Tasa, Sugerida:',Par_TasaSugerida,
								', Nueva Tasa:',Par_TasaNueva,'.');

        SET Var_Consecutivo := (SELECT MAX(ConsecutivoID) FROM CAMBIOTASAAPORT);
        SET Var_Consecutivo := IFNULL(Var_Consecutivo,Entero_Cero)+1;

        SET Var_ClaveUsuario:= (SELECT UPPER(Clave) FROM USUARIOS WHERE UsuarioID=Aud_Usuario);

		INSERT INTO CAMBIOTASAAPORT(
			ConsecutivoID,		AportacionID,		TasaSugerida,		TasaNueva,			Comentario,
            ClaveUsuario,		TipoRegistro,		EmpresaID,			Usuario,			FechaActual,
            DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
		VALUES(
			Var_Consecutivo,	Par_AportacionID,	Par_TasaSugerida,	Par_TasaNueva,		Var_Coment,
			Var_ClaveUsuario,	Par_TipoRegistro,	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


		SET Par_NumErr	:= 	0;
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

