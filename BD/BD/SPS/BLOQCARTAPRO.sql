-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BLOQCARTAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `BLOQCARTAPRO`;
DELIMITER $$

CREATE PROCEDURE `BLOQCARTAPRO`(
/* SP QUE REALIZA EL BLOQUEO DEL MONTO DISPONIBLE PARA PODER DISPERSAR DE LAS DEMAS CARTAS LIQ
        Y SE ACUTALIZA LOS REGISTROS DE LA BITACORA DE CARTAS DE LIQUIDACION DISPERADAS */
	Par_CreditoID		        BIGINT(20), 	-- ID del Credito
	Par_DispersionID			INT(11),		-- ID de la Dispersion
	Par_MovDisp					INT(11),		-- ID del Movimiento de Dispersion
	Par_MontoDisp               DECIMAL(12,2),  -- Monto Dispersado
	Par_TipoProceso				CHAR(1),		-- Tipo Proceso		A- Autorizada	P- No Autorizada

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
	DECLARE Var_CuentaAhoID		BIGINT(12);			-- ID de la cuenta de ahorro
	DECLARE Var_AntMontoBloq	DECIMAL(12,2);		-- Monto Anterior Bloqueado
	DECLARE Var_MontoBloq		DECIMAL(12,2);		-- Monto Bloqueado
	DECLARE FechSistema         DATE;				-- Fecha del Sistema
	DECLARE DescripBloqueo      VARCHAR(100);		-- Descripcion de Bloqueo
	DECLARE Var_AsignaCarta		BIGINT(11);			-- Var ID de Asignacion de Carta de Liq
	DECLARE Var_CartaCom		BIGINT(11);			-- Var ID de Casa Comercial
    DECLARE Var_TipoDestino     CHAR(1);            -- Var Tipo de Destino C- Cliente L- Carta de Liquidacion
	DECLARE Var_IDCtr			INT(11);			-- Var ID de Control

    -- Declaracion de Constantes
    DECLARE	Cadena_Vacia		VARCHAR(1);
    DECLARE	Fecha_Vacia			DATE;
    DECLARE	Entero_Cero			INT(11);
	DECLARE	Entero_Uno			INT(11);
    DECLARE	SalidaSI        	CHAR(1);
    DECLARE	SalidaNO        	CHAR(1);
	DECLARE Var_Autoriza		CHAR(1);
	DECLARE Var_NoAutoriza		CHAR(1);
	DECLARE Bloquear			CHAR(1);
	DECLARE TipoBloqueo         INT(11);
	DECLARE TipoCliente			CHAR(1);
	DECLARE TipoCarta			CHAR(1);
    DECLARE Var_Dispersada      CHAR(1);
	DECLARE Con_NO				CHAR(1);

    -- Asignacion de Constantes
    SET Cadena_Vacia			:= '';				-- Cadena vacia
    SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
    SET Entero_Cero				:= 0;				-- Entero Cero
	SET Entero_Uno				:= 1;				-- Entero Uno
    SET	SalidaSI        		:= 'S';				-- Salida Si
    SET	SalidaNO        		:= 'N'; 			-- Salida No
	SET Var_Autoriza			:= 'A';				-- Variable Autoriza
	SET Var_NoAutoriza			:= 'P';				-- Variable No Autoriza
	SET Bloquear         		:= 'B';				-- Tipo Bloqueo en Cta Ahorro: Bloquear
	SET TipoBloqueo 			:= 1;               -- Tipo de Movimiento de Bloqueo
	SET TipoCliente				:= 'C';				-- Tipo de Movimiento perteneciente a Cliente
	SET TipoCarta				:= 'L';				-- Tipo de Movimiento pertenecietne a Cartas de Liquidacion
    SET Var_Dispersada          := 'S';             -- Variable Dispersada Estatus de Carta Liquidacion
	SET Con_NO					:= 'N';				-- Constante No

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-BLOQCARTAPRO');
			SET Var_Control:= 'sqlException' ;
		END;

	SET FechSistema := (SELECT FechaSistema FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID);

	IF(Par_CreditoID = Entero_Cero) THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := 'El Credito esta Vacio.';
		SET Var_Control:= 'ClaveDispMov' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Par_DispersionID = Entero_Cero) THEN
		SET Par_NumErr := 002;
		SET Par_ErrMen := 'La Dispersion esta Vacia.';
		SET Var_Control:= 'ClaveDispMov' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Par_MovDisp = Entero_Cero) THEN
		SET Par_NumErr := 003;
		SET Par_ErrMen := 'El Movimiento de la Dispersion esta Vacia.';
		SET Var_Control:= 'ClaveDispMov' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Par_MontoDisp = Entero_Cero) THEN
		SET Par_NumErr := 004;
		SET Par_ErrMen := 'El Monto esta Vacio.';
		SET Var_Control:= 'ClaveDispMov' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Par_TipoProceso NOT IN (Var_Autoriza,Var_NoAutoriza)) THEN
		SET Par_NumErr := 005;
		SET Par_ErrMen := 'El Tipo de Proceso no Exite.';
		SET Var_Control:= 'ClaveDispMov' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Par_TipoProceso = Var_Autoriza) THEN

		SELECT DisMov.CuentaCargo
			INTO Var_CuentaAhoID
		FROM DISPERSION Dis
			INNER JOIN DISPERSIONMOV DisMov
                ON Dis.FolioOperacion = DisMov.DispersionID
		WHERE DisMov.DispersionID   = Par_DispersionID
				AND DisMov.ClaveDispMov   = Par_MovDisp;

		SELECT MontoBloq,		Descripcion
		INTO Var_AntMontoBloq, DescripBloqueo
		FROM BLOQUEOS
		WHERE CuentaAhoID = Var_CuentaAhoID AND NatMovimiento = Bloquear
			AND TiposBloqID = Entero_Uno AND  Referencia = Par_CreditoID
			AND FolioBloq != Entero_Cero
			ORDER BY BloqueoID DESC LIMIT Entero_Uno;

		SET Var_AntMontoBloq := IFNULL(Var_AntMontoBloq, Entero_Cero);

		SET Var_MontoBloq := Var_AntMontoBloq - Par_MontoDisp ;

        IF(Var_MontoBloq > Entero_Cero ) THEN
            CALL BLOQUEOSPRO(
                Entero_Cero,		Bloquear,			Var_CuentaAhoID,		FechSistema,		Var_MontoBloq,
                Fecha_Vacia,		TipoBloqueo,		DescripBloqueo,			Par_CreditoID,		Cadena_Vacia,
                Cadena_Vacia,		SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,
                Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
                Aud_NumTransaccion);

            IF (Par_NumErr <> Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;
        END IF;

		UPDATE HISCARTASLIQDISPERSION SET
			Estatus = Var_Autoriza,
			Monto = Par_MontoDisp
		WHERE FolioOperacion = Par_DispersionID
			AND ClaveDispMov = Par_MovDisp;


		SELECT AsignacionCartaID,   CasaComercialID,    Destino
		INTO Var_AsignaCarta,       Var_CartaCom,       Var_TipoDestino
		FROM HISCARTASLIQDISPERSION
		WHERE  FolioOperacion = Par_DispersionID
			AND ClaveDispMov = Par_MovDisp;


		IF(Var_TipoDestino = TipoCliente)THEN
			UPDATE CREDITOS SET
				MontoClienteCartas = MontoClienteCartas - Par_MontoDisp
			WHERE  CreditoID = Par_CreditoID;
		END IF;

		IF(Var_TipoDestino = TipoCarta)THEN
			UPDATE ASIGCARTASLIQUIDACION SET
				MontoDispersion = MontoDispersion + Par_MontoDisp,
                Estatus = Var_Dispersada
			WHERE AsignacionCartaID = Var_AsignaCarta
				AND CasaComercialID = Var_CartaCom;
		END IF;


        UPDATE CREDITOS SET
			MontoDesemb = IF((MontoDesemb + Par_MontoDisp)>MontoCredito,MontoCredito,(MontoDesemb + Par_MontoDisp)),
            MontoPorDesemb = IF((MontoPorDesemb - Par_MontoDisp)<Entero_Cero,Entero_Cero,(MontoPorDesemb - Par_MontoDisp))
		WHERE  CreditoID = Par_CreditoID;

	END IF;

	IF(Par_TipoProceso = Var_NoAutoriza) THEN

		SELECT AsignacionCartaID,   CasaComercialID,    Destino
		INTO Var_AsignaCarta,       Var_CartaCom,       Var_TipoDestino
		FROM HISCARTASLIQDISPERSION
		WHERE  FolioOperacion = Par_DispersionID
			AND ClaveDispMov = Par_MovDisp;

		SET Var_IDCtr := (SELECT IDControl
							 FROM CTRDISPERSIONCARTAS
							 	WHERE CreditoID = Par_CreditoID
								 	AND AsignacionCartaID = Var_AsignaCarta
									AND  CasaComercialID = Var_CartaCom
									AND Destino = Var_TipoDestino);

		UPDATE CTRDISPERSIONCARTAS SET
			Estatus = Con_NO
		WHERE IDControl = Var_IDCtr;

		DELETE  FROM HISCARTASLIQDISPERSION
		WHERE FolioOperacion = Par_DispersionID
			AND ClaveDispMov = Par_MovDisp;


	END IF;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Carta de Liquidacion Modificada Correctamente';
	SET Var_Control:= 'ClaveDispMov' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control;
END IF;

END TerminaStore$$
