-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CTRINSTRUCCIONESDISPALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CTRINSTRUCCIONESDISPALT`;
DELIMITER $$

CREATE PROCEDURE `CTRINSTRUCCIONESDISPALT`(

	Par_BenefiDisperID			INT(11),		-- ID de la instruccion de dispersion por beneficiario
	Par_CreditoID				BIGINT(20), 	-- ID del Credito
	Par_FolioDisp				INT(11),		-- ID de Folio de Dispersion
	Par_ClaveDispMov			INT(11),		-- ID de Folio de Dispersion de Movimiento
	Par_TipoDispersion			CHAR(1),		-- Tipo de la dispersion
	Par_TipoCuentaDisper		INT(11),		-- Tipo cuenta de dispersion  1.- Instruccion Nueva , 2.- Instruc. de Carta Liq. Externas, 3.- Instruc. de Carta Liq. Interna'

	Par_MontoDisp				DECIMAL(14,2),	-- Monto de la Dispersion
	Par_FechaDisper				DATE,			-- Fecha de Dispersion
	Par_FechaImport				DATE,			-- Fecha de importacion
	Par_EstatusDisper			CHAR(1),		-- Estatus de la dispersion
	Par_EstatusImport			CHAR(1),		-- Estatus de la importacion

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

    -- Asignacion de Constantes
    SET Cadena_Vacia			:= '';				-- Cadena vacia
    SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
    SET Entero_Cero				:= 0;				-- Entero Cero
    SET	SalidaSI        		:= 'S';				-- Salida Si
    SET	SalidaNO        		:= 'N'; 			-- Salida No
	SET TipoCliente				:= 'C';				-- Tipo de Movimiento perteneciente a Cliente
	SET TipoCarta				:= 'L';				-- Tipo de Movimiento pertenecietne a Cartas de Liquidacion
	SET Con_SI					:= 'S';				-- Constante SI

    SET Aud_FechaActual 		:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CTRINSTRUCCIONESDISPALT');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(Par_CreditoID = Entero_Cero) THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := 'El Credito esta Vacio.';
		SET Var_Control:= 'folioOperacion' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Par_MontoDisp = Entero_Cero) THEN
		SET Par_NumErr := 002;
		SET Par_ErrMen := 'El monto esta Vacio';
		SET Var_Control:= 'folioOperacion' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Par_BenefiDisperID = Entero_Cero)THEN
		SET Par_NumErr := 003;
		SET Par_ErrMen := 'La instrucción de dispersion esta vacía';
		SET Var_Control:= 'folioOperacion' ;
		LEAVE ManejoErrores;
	END IF;

	SET Var_ControlDispID := (SELECT MAX(ControlDispID) FROM CTRINSTRUCCIONESDISP);
	SET Var_ControlDispID := IFNULL(Var_ControlDispID, Entero_Cero) + 1;

	INSERT INTO CTRINSTRUCCIONESDISP
		(	ControlDispID,		BenefiDisperID,		CreditoID,			FolioOperacion,		ClaveDispMov,
			TipoDispersionID,	TipoCuentaDisper,	MontoDispersion,	FechaDispersion,	EstatusDispersion,
			FechaImportacion,	EstatusImportacion,	EmpresaID,			Usuario,			FechaActual,
			DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
	VALUES
		(	Var_ControlDispID,	Par_BenefiDisperID,		Par_CreditoID,		Par_FolioDisp,		Par_ClaveDispMov,
			Par_TipoDispersion,	Par_TipoCuentaDisper,	Par_MontoDisp,		Par_FechaDisper,	Par_EstatusDisper,
			Par_FechaImport,	Par_EstatusImport,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);


	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Bitacora de Instrucciones de dispersion  Registrada Correctamente';
	SET Var_Control:= 'folioOperacion' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
			'' AS Consecutivo;
END IF;

END TerminaStore$$