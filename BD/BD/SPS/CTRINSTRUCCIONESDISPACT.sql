-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CTRINSTRUCCIONESDISPALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CTRINSTRUCCIONESDISPACT`;
DELIMITER $$

CREATE PROCEDURE `CTRINSTRUCCIONESDISPACT`(

	Par_BenefiDisperID			INT(11),		-- ID de la instruccion de dispersion por beneficiario
	Par_CreditoID				BIGINT(20), 	-- ID del Credito
	Par_FolioDisp				INT(11),		-- ID de Folio de Dispersion
	Par_ClaveDispMov			INT(11),		-- ID de Folio de Dispersion de Movimiento
	Par_TipoDispersion			CHAR(1),		-- Tipo de la dispersion
	Par_TipoCuentaDisper		INT(11),		-- Tipo cuenta de dispersion  1.- Instruccion Nueva , 2.- Instruc. de Carta Liq. Externas, 3.- Instruc. de Carta Liq. Interna'

	Par_FechaDisper				DATE,			-- Fecha de Dispersion
	Par_FechaImport				DATE,			-- Fecha de importacion
	Par_EstatusDisper			CHAR(1),		-- Estatus de la dispersion
	Par_EstatusImport			CHAR(1),		-- Estatus de la importacion

	Par_NumAct					INT(11),		-- Numero de consulta 1 Esatus importacion, 2 Estatus Dispersion

	/* Parametros de Manejo de Errores */
	Par_Salida					CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error

	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),        -- Parametros de Auditoria
	Aud_Usuario					INT(11),        -- Parametros de Auditoria
	Aud_FechaActual				DATETIME,       -- Parametros de Auditoria
	Aud_DireccionIP				VARCHAR(15),    -- Parametros de Auditoria
	Aud_ProgramaID				VARCHAR(50),    -- Parametros de Auditoria
	Aud_Sucursal				INT(11),        -- Parametros de Auditoria
	Aud_NumTransaccion			BIGINT(20)      -- Parametros de Auditoria
)
TerminaStore: BEGIN

    -- Declaracion de Constantes
    DECLARE	Var_Control				CHAR(25);			-- Var Control del Manejo de Errores
	DECLARE Var_ControlDispID		INT(11);			-- Variable que para el ID de la tabla de control
    -- Declaracion de Constantes
    DECLARE	Cadena_Vacia		VARCHAR(1);
    DECLARE	Fecha_Vacia			DATE;
    DECLARE	Entero_Cero			INT(11);
    DECLARE	SalidaSI			CHAR(1);
    DECLARE	SalidaNO			CHAR(1);
    DECLARE TipoCliente			CHAR(1);
	DECLARE TipoCarta			CHAR(1);
	DECLARE Con_SI				CHAR(1);
	DECLARE Act_Import			INT(11);
	DECLARE Act_Disper			INT(11);

    -- Asignacion de Constantes
    SET Cadena_Vacia			:= '';				-- Cadena vacia
    SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
    SET Entero_Cero				:= 0;				-- Entero Cero
    SET	SalidaSI        		:= 'S';				-- Salida Si
    SET	SalidaNO        		:= 'N'; 			-- Salida No
	SET TipoCliente				:= 'C';				-- Tipo de Movimiento perteneciente a Cliente
	SET TipoCarta				:= 'L';				-- Tipo de Movimiento pertenecietne a Cartas de Liquidacion
	SET Con_SI					:= 'S';				-- Constante SI
	SET Act_Disper				:= 2;
	SET Act_Import				:= 1;

	SET Aud_FechaActual 		:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CTRINSTRUCCIONESDISPACT');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(Par_NumAct = Act_Import) THEN

		IF(Par_TipoDispersion = Cadena_Vacia) THEN
			SET Par_NumErr := 005;
			SET Par_ErrMen := 'El tipo de dispersión esta Vacio';
			SET Var_Control:= 'folioOperacion' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoCuentaDisper = Entero_Cero) THEN
			SET Par_NumErr := 006;
			SET Par_ErrMen := 'El tipo de cuenta de la dispersió esta Vacio';
			SET Var_Control:= 'folioOperacion' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CreditoID = Entero_Cero) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El Credito esta Vacio.';
			SET Var_Control:= 'folioOperacion' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_BenefiDisperID = Entero_Cero)THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'El beneficiario de dispersion esta vacio.';
			SET Var_Control:= 'folioOperacion' ;
			LEAVE ManejoErrores;
		END IF;
		IF(Par_FechaImport = Cadena_Vacia)THEN
			SET Par_NumErr := 007;
			SET Par_ErrMen := 'La Fecha de dispersión esta vacía';
			SET Var_Control:= 'folioOperacion';
			LEAVE ManejoErrores;
		END IF;
		IF(Par_EstatusImport = Cadena_Vacia)THEN
			SET Par_NumErr := 008;
			SET Par_ErrMen := 'El estatus de la importación no es válido';
			SET Var_Control:= 'folioOperacion';
			LEAVE ManejoErrores;
		END IF;

		UPDATE CTRINSTRUCCIONESDISP SET
			FechaImportacion 	= Aud_FechaActual,
			EstatusImportacion	= Par_EstatusImport,
			FolioOperacion		= Par_FolioDisp,
			ClaveDispMov		= Par_ClaveDispMov,

			EmpresaID = Par_EmpresaID,
			Usuario = Aud_Usuario,
			FechaActual = Aud_FechaActual,
			DireccionIP = Aud_DireccionIP,
			ProgramaID = Aud_ProgramaID,
			Sucursal = Aud_Sucursal,
			NumTransaccion = Aud_NumTransaccion
		WHERE
			CreditoID = Par_CreditoID
			AND BenefiDisperID = Par_BenefiDisperID;
		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Bitacora del control de dispersiones Actulizada';
		SET Var_Control:= 'folioOperacion';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_NumAct = Act_Disper) THEN
		IF(Par_FolioDisp = Entero_Cero) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El Folio de dispersion esta vacio.';
			SET Var_Control:= 'folioOperacion' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ClaveDispMov = Entero_Cero) THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'La clave de la dispersión esta vacia.';
			SET Var_Control:= 'folioOperacion' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_FechaDisper = Fecha_Vacia)THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := 'La Fecha de dispersión esta vacía';
			SET Var_Control:= 'folioOperacion';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_EstatusDisper = Cadena_Vacia)THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen := 'El estatus de la importación no es válido';
			SET Var_Control:= 'folioOperacion';
			LEAVE ManejoErrores;
		END IF;

		UPDATE CTRINSTRUCCIONESDISP SET
			FechaDispersion 	= Aud_FechaActual,
			EstatusDispersion	= Par_EstatusDisper,

			EmpresaID 		= Par_EmpresaID,
			Usuario 		= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID 		= Aud_ProgramaID,
			Sucursal 		= Aud_Sucursal,
			NumTransaccion 	= Aud_NumTransaccion
		WHERE
			ClaveDispMov = Par_ClaveDispMov
			AND folioOperacion = Par_FolioDisp;

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Bitacora del control de dispersiones Actulizada';
		SET Var_Control:= 'folioOperacion';
		LEAVE ManejoErrores;
	END IF;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
			'' AS Consecutivo;
END IF;

END TerminaStore$$
