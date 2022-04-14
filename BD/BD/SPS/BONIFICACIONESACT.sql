-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BONIFICACIONESACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BONIFICACIONESACT`;

DELIMITER $$
CREATE PROCEDURE `BONIFICACIONESACT`(
	-- =====================================================================================
	-- -------------- STORE PARA LA ACTUALIZACION DE BONIFICACIONES POR WS -----------------
	-- =====================================================================================

	Par_BonificacionID		BIGINT(20),		-- ID de Tabla
	Par_FolioDispersion 	INT(11),		-- Folio de Dispersion
	Par_NumeroActualizacion	TINYINT UNSIGNED,-- Numero de Actualizacion

	Par_Salida 				CHAR(1), 		-- Salida en Pantalla
	INOUT Par_NumErr 		INT(11),		-- Parametro de numero de error
	INOUT Par_ErrMen 		VARCHAR(400),	-- Parametro de mensaje de error

	Par_EmpresaID			INT(11),		-- Parametro de Auditoria
	Aud_Usuario				INT(11),		-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Parametros
	DECLARE Par_Fecha 				DATE;			-- Fecha de Alta de la Bonificacion
	DECLARE Par_FechaVencimiento 	DATE;			-- Fecha de Vencimiento de la Bonificacion
	DECLARE Par_Monto 				DECIMAL(14,2);	-- Monto de la Bonificacion
	DECLARE Par_Meses 				INT(11);		-- Meses de Bonificacion
	DECLARE Act_EstAutorizada 			TINYINT UNSIGNED;-- Numero de Actualizacion

	-- Declaracion de Variables
	DECLARE Var_BonificacionID		BIGINT(20);		-- Numero de Bonificacion
	DECLARE Var_FolioOperacion 		INT(11);		-- Numero de Dispersion
	DECLARE Var_Estatus				CHAR(1);		-- Estatus de la Bonificacion

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante Cadena Vacia
	DECLARE Con_SI 					CHAR(1);		-- Constante SI
	DECLARE Con_NO 					CHAR(1);		-- Constante NO
	DECLARE Est_Inactivo 			CHAR(1);		-- Constante Estatus Inactiva
	DECLARE Est_Vigente 			CHAR(1);		-- Constante Estatus Vigente

	DECLARE	Fecha_Vacia				DATE;			-- Constante Fecha Vacia
	DECLARE Entero_Cero				INT(11);		-- Constante Entero Cero
	DECLARE Decimal_Cero			DECIMAL(12,2);	-- Constante Decumal Cero

	--
	SET Act_EstAutorizada	 				:= 1;

	-- Asignacion de Constantes
	SET	Cadena_Vacia				:= '';
	SET Con_SI 						:= 'S';
	SET Con_NO 						:= 'N';
	SET Est_Inactivo 				:= 'I';
	SET Est_Vigente 				:= 'V';

	SET Fecha_Vacia 				:= '1900-01-01';
	SET	Entero_Cero					:= 0;
	SET	Decimal_Cero				:= 0.0;

	SELECT IFNULL(FechaSistema, Fecha_Vacia)
	INTO Par_Fecha
	FROM PARAMETROSSIS LIMIT 1;

	-- Se validan parametros nulos
	SET Par_BonificacionID 	:= IFNULL(Par_BonificacionID , Entero_Cero);
	SET Par_FolioDispersion	:= IFNULL(Par_FolioDispersion , Entero_Cero);
	SET Par_Fecha 			:= IFNULL(Par_Fecha , Fecha_Vacia);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-BONIFICACIONESACT');
		END;

		IF( Par_BonificacionID = Entero_Cero ) THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El Numero de Bonificacion esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		SELECT BonificacionID
		INTO Var_BonificacionID
		FROM BONIFICACIONES
		WHERE BonificacionID = Par_BonificacionID;

		SET Var_BonificacionID := IFNULL(Var_BonificacionID, Entero_Cero);

		IF( Var_BonificacionID = Entero_Cero ) THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'El Numero de Bonificacion no Existe.';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_FolioDispersion = Entero_Cero ) THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'El Folio de Dispersion no Existe.';
			LEAVE ManejoErrores;
		END IF;

		SELECT FolioOperacion
		INTO Var_FolioOperacion
		FROM DISPERSION
		WHERE FolioOperacion = Par_FolioDispersion;

		SET Var_FolioOperacion := IFNULL(Var_FolioOperacion, Entero_Cero);

		IF( Var_FolioOperacion = Entero_Cero ) THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'El Folio de Dispersion no Existe.';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_NumeroActualizacion = Act_EstAutorizada ) THEN
			SET Aud_FechaActual := NOW();


			SELECT 	Monto,		Meses,		Estatus
			INTO 	Par_Monto,	Par_Meses, 	Var_Estatus
			FROM BONIFICACIONES
			WHERE BonificacionID = Par_BonificacionID;

			IF(Var_Estatus <> Est_Inactivo) THEN
				SET Par_NumErr  := 003;
				SET Par_ErrMen  := 'La Bonificacion tiene un estatus diferente de Inactivo y no puede Autorizarse.';
				LEAVE ManejoErrores;
			END IF;

			-- Ajustar la fecha si la dispersion no se realiza en la fecha programanda
			SET Par_FechaVencimiento := DATE_ADD(LAST_DAY(Par_Fecha), INTERVAL Par_Meses MONTH);

			UPDATE BONIFICACIONES SET
				FechaInicio 	= Par_Fecha,
				FechaVencimiento = Par_FechaVencimiento,
				FechaDispersion = Par_Fecha,
				FolioDispersion = Par_FolioDispersion,
				Estatus 		= Est_Vigente,
				EmpresaID 		= Par_EmpresaID,
				Usuario    		= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID 		= Aud_ProgramaID,
				Sucursal 		= Aud_Sucursal,
				NumTransaccion 	= Aud_NumTransaccion
			WHERE BonificacionID = Par_BonificacionID;

			CALL BONIFICACIONSIMPRO(
				Par_BonificacionID,		Par_Monto,				Par_Meses,			Par_Fecha,			Con_NO,
		 		Par_NumErr,				Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Bonificacion actualizada Correctamente.';

	END ManejoErrores;

	IF( Par_Salida = Con_SI ) THEN
		SELECT  Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Par_BonificacionID AS consecutivo;
	END IF;

END TerminaStore$$