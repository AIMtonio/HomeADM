-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANCELACIONORDPAGPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CANCELACIONORDPAGPRO`;
DELIMITER $$

CREATE PROCEDURE `CANCELACIONORDPAGPRO`(
-- ===================================================================================
-- SP PARA LA CANCELACION DE UNA ORDEN DE PAGO
-- ===================================================================================
	Par_FolioOperacion 		INT(11), 			-- Identificador de la tabla DISPERSION
	Par_ClaveDispMov 		INT(11), 			-- Id de la tabla DISPERSIONMOV

	Par_Salida				CHAR(1),			-- Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),			-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de Error

	/* Parametros de Auditoria */
	Aud_EmpresaID 			INT(11),			-- AUDITORIA
	Aud_Usuario 			INT(11),			-- AUDITORIA
  	Aud_FechaActual 		DATETIME,			-- AUDITORIA
  	Aud_DireccionIP 		VARCHAR(15),		-- AUDITORIA
  	Aud_ProgramaID 			VARCHAR(50),		-- AUDITORIA
  	Aud_Sucursal 			INT(11),			-- AUDITORIA
  	Aud_NumTransaccion 		BIGINT(20)			-- AUDITORIA
)
TerminaStore:BEGIN

	/*Declaracion de Variables*/
	DECLARE Var_Control 		VARCHAR(50); 	-- Control en Pantalla
	DECLARE	Var_Consecutivo 	INT(11); 		-- Consecutivo en Pantalla
	DECLARE Var_FechaSistema DATE;			-- Variable Fecha del Sistema

	/*Declración de Constantes*/
	DECLARE	Entero_Cero 	INT(11); 		-- Constante Entero Cero
	DECLARE Entero_Uno 		INT(11); 		-- Constante Entero Uno
	DECLARE Decimal_Cero	DECIMAL(12,2); 	-- Constante Decimal Cero
	DECLARE Fecha_Vacia		DATE; 			-- Constante Fecha Vacía
	DECLARE SalidaSI		CHAR(1); 		-- Constante Cadena Si
	DECLARE Cadena_Vacia	VARCHAR(100); 	-- Constante Cadena Vacía
	DECLARE SalidaNo		CHAR(1); 		-- Constante Salida No
	DECLARE Act_Cancelada	INT(11);		-- Constante Cancelacion
	DECLARE Con_EstatusC	CHAR(1);		-- Estatus cancelado
	/*Asignacion de Constantes*/
	SET Entero_Cero 	:= 0; 				-- Constante Entero Cero
	SET Entero_Uno 		:= 1; 				-- Constante Entero Uno
	SET Decimal_Cero 	:= 0.0; 			-- Constante Decimal Cero
	SET Fecha_Vacia		:= '1900-01-01'; 	-- Constante Fecha Vacía
	SET SalidaSI		:= 'S'; 			-- Constante Cadena Si
	SET Cadena_Vacia 	:= ''; 				-- Constante Cadena Vacía
	SET SalidaNo 		:= 'N'; 			-- Constante Salida No
	SET Act_Cancelada	:= 4;
	SET Con_EstatusC	:= 'C';

	ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocaciones. Ref: SP-CANCELACIONORDPAGPRO');
			SET Var_Control	:='SQLEXCEPTION';
		END;

	SELECT IFNULL(FechaSistema, Fecha_Vacia)
		INTO Var_FechaSistema
		FROM PARAMETROSSIS LIMIT 1;

	/* Se Actualiza el Estatus de la Orden de Pago*/
	CALL REFORDENPAGOSANACT(
			Par_FolioOperacion,		Par_ClaveDispMov,	Cadena_Vacia,		Act_Cancelada,		SalidaNO,
			Par_NumErr, 			Par_ErrMen, 		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP, 		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
	END IF;

    -- ACTUALIZAMOS EL ESTATUS DE LA DISPERSION
    UPDATE  DISPERSIONMOV  SET
			Estatus				= Con_EstatusC,

			EmpresaID			= Aud_EmpresaID ,
			Usuario				= Aud_Usuario,
			FechaActual			= Aud_FechaActual,
			DireccionIP			= Aud_DireccionIP,
			ProgramaID			= Aud_ProgramaID ,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE  ClaveDispMov 	= Par_ClaveDispMov
		  AND DispersionID 		= Par_FolioOperacion ;

	/* Se da de alta en el historico la orden de pago*/
	CALL HISDISPERSIONMOVALT(
			Par_FolioOperacion,		Par_ClaveDispMov,	Var_FechaSistema,	Aud_NumTransaccion,	SalidaNO,
			Par_NumErr, 			Par_ErrMen, 		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP, 		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
	END IF;


	IF(Par_NumErr <> Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	SET Par_NumErr := 00;
	SET Par_ErrMen := 'Cancelacion de Orden de Pago Exitoso';
	SET Var_Control := 'solicitudCreditoID';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
                Aud_NumTransaccion AS Consecutivo;
	END IF;

END TerminaStore$$