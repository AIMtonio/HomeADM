-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARTASLIQDISPERSIONALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARTASLIQDISPERSIONALT`;
DELIMITER $$

CREATE PROCEDURE `CARTASLIQDISPERSIONALT`(
/* SP QUE REALIZA EL ALTA A LA BITACORA DE CARTAS DE LIQUIDACION QUE SE HAN DISPERSADO*/

	Par_CreditoID		        BIGINT(20), 	-- ID del Credito
    Par_AsignacionCartaID       BIGINT(11),     -- ID de Asignacion de Carta de Liquidacion
	Par_CasaComercial			BIGINT(11),		-- ID de Casa Comercial
	Par_FolioDisp				INT(11),		-- ID de Folio de Dispersion
	Par_ClaveDispMov			INT(11),		-- ID de Folio de Dispersion de Movimiento

    Par_Fecha                   DATE,	        -- Fecha de Dispersion
	Par_MontoDisp				DECIMAL(12,2),	-- Monto de la Dispersion
	Par_TipoDestino				CHAR(1),		-- Tipo de Destino C- Cliente L- Carta de Liquidacion

	Par_Salida           		CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     		INT(11),		-- Numero de Error
	INOUT Par_ErrMen     		VARCHAR(400),	-- Mensaje de Error
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
    DECLARE	Var_Control         CHAR(25);           -- Var Control del Manejo de Errores
	DECLARE Var_IDCartaDisp		INT(11);			-- Variable ID de Carta de Dispersion
	DECLARE Var_Solicitud		BIGINT(20);			-- Variable solicitud de Credito
	DECLARE VarIDControl		INT(11);			-- Variable de Contol
	DECLARE VarID				INT(11);			-- Variable de Contol
    -- Declaracion de Constantes
    DECLARE	Cadena_Vacia		VARCHAR(1);
    DECLARE	Fecha_Vacia			DATE;
    DECLARE	Entero_Cero			INT(11);
    DECLARE	SalidaSI        	CHAR(1);
    DECLARE	SalidaNO        	CHAR(1);
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
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CARTASLIQDISPERSIONALT');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(Par_CreditoID = Entero_Cero) THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := 'El Credito esta Vacio.';
		SET Var_Control:= 'folioOperacion' ;
		LEAVE ManejoErrores;
	END IF;
	IF( Par_TipoDestino = TipoCarta) THEN
		IF(Par_AsignacionCartaID = Entero_Cero) THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'La Asignacion de Carta Comercial esta Vacia.';
			SET Var_Control:= 'folioOperacion' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CasaComercial = Entero_Cero) THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := 'La Casa Comercial esta Vacia.';
			SET Var_Control:= 'folioOperacion' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(Par_FolioDisp = Entero_Cero) THEN
		SET Par_NumErr := 004;
		SET Par_ErrMen := 'El Folio de Dispersion esta Vacia.';
		SET Var_Control:= 'folioOperacion' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Par_ClaveDispMov = Entero_Cero) THEN
		SET Par_NumErr := 005;
		SET Par_ErrMen := 'El Folio de Dispersion de Movimiento esta Vacia.';
		SET Var_Control:= 'folioOperacion' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Par_Fecha = Fecha_Vacia) THEN
		SET Par_NumErr := 006;
		SET Par_ErrMen := 'La Fecha de Dispersion esta Vacia.';
		SET Var_Control:= 'folioOperacion' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Par_MontoDisp = Entero_Cero) THEN
		SET Par_NumErr := 007;
		SET Par_ErrMen := 'El monto esta Vacio';
		SET Var_Control:= 'folioOperacion' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Par_TipoDestino NOT IN (TipoCliente,TipoCarta)) THEN
		SET Par_NumErr := 005;
		SET Par_ErrMen := 'El Tipo de Destino no Exite.';
		SET Var_Control:= 'ClaveDispMov' ;
		LEAVE ManejoErrores;
	END IF;
	
	SET Var_IDCartaDisp := (SELECT MAX(CartaDispersionID) FROM HISCARTASLIQDISPERSION);
	SET Var_IDCartaDisp := IFNULL(Var_IDCartaDisp, Entero_Cero) + 1;
    
	INSERT INTO HISCARTASLIQDISPERSION
		(CartaDispersionID, CreditoID,			AsignacionCartaID,  CasaComercialID,	FolioOperacion,
		ClaveDispMov,		Fecha,				Monto,				Destino,			EmpresaID,			Usuario,
		FechaActual,		DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
	VALUES(
		Var_IDCartaDisp,	Par_CreditoID,		Par_AsignacionCartaID,	Par_CasaComercial, 		Par_FolioDisp,
		Par_ClaveDispMov,	Par_Fecha,			Par_MontoDisp,			Par_TipoDestino,		Par_EmpresaID,			Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
	);

	SET Var_Solicitud := (SELECT SolicitudCreditoID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
	SET VarIDControl := (SELECT IDControl
						 	FROM CTRDISPERSIONCARTAS
								WHERE SolicitudCreditoID =  Var_Solicitud
									AND AsignacionCartaID = Par_AsignacionCartaID );
	SET VarIDControl := IFNULL(VarIDControl,Entero_Cero);

	IF(VarIDControl = Entero_Cero)THEN
		SET VarID := (SELECT COUNT(*) FROM CTRDISPERSIONCARTAS);
		SET VarID := IFNULL(VarID, Entero_Cero) + 1;

		INSERT INTO CTRDISPERSIONCARTAS 
			(IDControl,		CreditoID,				SolicitudCreditoID,		Destino,		AsignacionCartaID,		CasaComercialID,
			Estatus,		EmpresaID,				Usuario,		FechaActual,			DireccionIP,
			ProgramaID,		Sucursal,				NumTransaccion)
		VALUES(
			VarID,			Par_CreditoID,			Var_Solicitud,			Par_TipoDestino,	Par_AsignacionCartaID,		Par_CasaComercial,
			Con_SI,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,			Aud_DireccionIP,
			Aud_ProgramaID,	Aud_Sucursal,			Aud_NumTransaccion
		);
	ELSE
		UPDATE CTRDISPERSIONCARTAS SET
			Estatus = Con_SI
		WHERE SolicitudCreditoID = Var_Solicitud
			AND AsignacionCartaID = Par_AsignacionCartaID;

	END IF;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Bitacora de Cartas de Liquidacion Registrada Correctamente';
	SET Var_Control:= 'folioOperacion' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
			'' AS Consecutivo;
END IF;

END TerminaStore$$
