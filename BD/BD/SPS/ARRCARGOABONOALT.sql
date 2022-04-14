-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRCARGOABONOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRCARGOABONOALT`;DELIMITER $$

CREATE PROCEDURE `ARRCARGOABONOALT`(
# =====================================================================================
# -- STORED PROCEDURE PARA DAR DE ALTA UN CARGO O UN ABONO PARA UN ARRENDAMIENTO
# =====================================================================================
	Par_ArrendaID					BIGINT(12),				-- Id del arrendamiento
    Par_ArrendaAmortiID				INT(4),					-- Id de arreendamiento mortizacion
    Par_TipoConcepto				INT(11),				-- Tipo de concepto
    Par_Naturaleza					CHAR(1),				-- Naturaleza del abono o cargo
    Par_Monto						DECIMAL(14, 2),			-- Monto del cargo o abono
    Par_Descripcion					VARCHAR(100), 			-- Descripcion del cargo o abono
    Par_UsuarioMovimiento  			INT(11),				-- Usuario que realiza el movimiento

    Par_Salida						CHAR(1),				-- Indica si el SP genera o no una salida
	INOUT Par_NumErr				INT(11),				-- Parametro de salida que indica el num. de error
	INOUT Par_ErrMen				VARCHAR(400),			-- Parametro de salida que indica el mensaje de eror
    INOUT Par_ConsecutivoCb 		INT(11),            	-- Parametro de salida que corresponde al consecutivo del registro agregado.

    Par_EmpresaID					INT(11),				-- Id de la empresa
	Aud_Usuario         			INT(11),				-- Usuario
    Aud_FechaActual					DATETIME,      			-- Parametro de Auditoria
	Aud_DireccionIP     			VARCHAR(15),			-- Descripcion IP
	Aud_ProgramaID      			VARCHAR(50),			-- Id del programa
	Aud_Sucursal        			INT(11),				-- Numero de sucursal
	Aud_NumTransaccion  			BIGINT(20)				-- Numero de transaccion

)
TerminaStore: BEGIN
	-- Declaracion de variables
    DECLARE Var_Control				VARCHAR(100);      	-- Variable de control
    DECLARE Var_FechaSistema		DATETIME;          	-- Fecha del sistema
    DECLARE Var_CargoAbonoID		BIGINT(12);        	-- ID de CargoAbono
	DECLARE Var_Consecutivo			BIGINT(12);        	-- Numero consecutivo
	DECLARE Var_ConArrendaID		BIGINT(12);			-- ID del concepto que hace referencia a la tabla CONCEPTOSARRENDA
    DECLARE Var_FolioCarBon			BIGINT;	        	-- Variable que tiene el folio generado para el activo

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia			CHAR(1);			-- Cadena Vacia
	DECLARE Entero_Cero				INT(11);			-- Entero cero
	DECLARE Salida_Si				CHAR(1);			-- Indica que si se devuelve un mensaje de salida
	DECLARE	Salida_NO       		CHAR(1);			-- Indica que no se devuelve un mensaje de salida
    DECLARE Est_Vigente				CHAR(1);			-- Estatus del arrendamiento
    DECLARE Var_NumActAmorti		INT(1);				-- Tipo de actualizacion para el SP que actualiza los amortizaciones
    DECLARE Var_NumActArre			INT(1);				-- Tipo de actualizacion para el SP que actualiza los arrendamientos
    DECLARE Var_Abono				VARCHAR(10);		-- Variable que se utiliza para verificar si Par_Naturaleza es igual a un abono
    DECLARE Decimal_Cero			DECIMAL(14,2);		-- Decimal 0
    DECLARE Est_Vencido				CHAR(1);			-- Estatus del arrendamiento

    -- Asignacion de Constantes
	SET Cadena_Vacia				:= '';				-- Cadena Vacia
	SET Entero_Cero					:= 0;				-- Entero Cero
	SET Salida_Si					:= 'S';				-- Salida SI
	SET Salida_NO					:= 'N';   			-- No se devuelve una salida
	SET Var_Control					:= '';				-- Valor inicial de la variable de control
    SET Est_Vigente					:= 'V';				-- Estatus vigente del arrendamiento
    SET Var_NumActAmorti			:= 1;				-- Tipo de actualizacion de la amortizacion
    SET Var_NumActArre				:= 5;				-- Tipo de actualizacion de saldos de arrendamiento
    SET Var_Abono					:= 'A';				-- Valor para verificar si es un abono
    SET Decimal_Cero				:= 0.0;				-- Decimal Cero
	SET Est_Vencido					:= 'B';				-- Estatus vencido del arrendamiento

    -- Asignacion de variables
    SET Aud_FechaActual 	:= NOW();
    SELECT	FechaSistema
	  INTO	Var_FechaSistema
		FROM PARAMETROSSIS LIMIT 1;

    ManejoErrores: BEGIN

      DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. REF: SP-ARRCARGOABONOALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

        SET Par_ConsecutivoCb   		:= Entero_Cero;

        SET Par_ArrendaID				:= IFNULL(Par_ArrendaID, Entero_Cero);
        SET Par_ArrendaAmortiID			:= IFNULL(Par_ArrendaAmortiID, Entero_Cero);
        SET Par_TipoConcepto			:= IFNULL(Par_TipoConcepto, Entero_Cero);
        SET Par_Naturaleza				:= IFNULL(Par_Naturaleza, Cadena_Vacia);
        SET Par_Monto					:= IFNULL(Par_Monto, Entero_Cero);
        SET Par_Descripcion				:= IFNULL(Par_Descripcion, Cadena_Vacia);

        IF(Par_ArrendaID = Entero_Cero )THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'Especificar el numero de arrendamiento.';
			SET Var_Control		:= 'ArrendaID';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS(SELECT Estatus
			FROM ARRENDAMIENTOS
            WHERE ArrendaID = Par_ArrendaID AND Estatus IN (Est_Vigente, Est_Vencido)) THEN

            SET Par_NumErr		:= 002;
			SET Par_ErrMen		:= CONCAT('El arrendamiento[',CAST(Par_ArrendaID AS CHAR(20)),']  tiene un estatus no valido para realizar cargos y abonos.');
			SET Var_Control		:= 'ArrendaID';
			LEAVE ManejoErrores;

		END IF;

        IF(Par_ArrendaAmortiID	= Entero_Cero )THEN
			SET Par_NumErr		:= 003;
			SET Par_ErrMen		:= 'Especificar el numero de amortizacion.';
			SET Var_Control		:= 'ArrendaAmortiID';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_TipoConcepto	= Entero_Cero)THEN
			SET Par_NumErr		:= 004;
			SET Par_ErrMen		:= 'Seleccionar un tipo de concepto.';
			SET Var_Control		:= 'TipoConcepto';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_Naturaleza	= Cadena_Vacia )THEN
			SET Par_NumErr		:= 005;
			SET Par_ErrMen		:= 'Seleccionar un cargo o abono.';
			SET Var_Control		:= 'Naturaleza';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_Monto	= Entero_Cero )THEN
			SET Par_NumErr		:= 006;
			SET Par_ErrMen		:= 'El monto debe de ser mayor a 0.';
			SET Var_Control		:= 'Monto';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_Descripcion	= Cadena_Vacia )THEN
			SET Par_NumErr		:= 007;
			SET Par_ErrMen		:= 'Especificar una descripcion.';
			SET Var_Control		:= 'Descripcion';
			LEAVE ManejoErrores;
		END IF;

        -- se genera el folio
		CALL FOLIOSAPLICAACT('ARRCARGOABONO', Var_FolioCarBon);

        -- SE INSERTA EL CARGO O ABONO A LA TABLA
        INSERT INTO ARRCARGOABONO(
			CargoAbonoID,		ArrendaID,				ArrendaAmortiID,		TipoConcepto, 		Naturaleza,
            Monto,	          	Descripcion, 			FechaMovimiento, 		UsuarioMovimiento, 	EmpresaID,
            Usuario,            FechaActual, 			DireccionIP, 			ProgramaID, 		Sucursal,
            NumTransaccion
        )	VALUES (
			Var_FolioCarBon,	Par_ArrendaID, 			Par_ArrendaAmortiID, 	Par_TipoConcepto, 	Par_Naturaleza,
            Par_Monto,			Par_Descripcion,		Var_FechaSistema, 		Par_UsuarioMovimiento, 	Par_EmpresaID,
            Aud_Usuario,		Aud_FechaActual, 		Aud_DireccionIP, 		Aud_ProgramaID, 	Aud_Sucursal,
            Aud_NumTransaccion
        );

        -- Se valida si es un cargo o un abono, para que el monto se sume o se reste al actualizar la amortizacion
        IF (Par_Naturaleza = Var_Abono) THEN
			SET Par_Monto := Par_Monto * -1;
        END IF;

        -- STORE QUE ACTUALIZA LAS AMORTIZACIONES DE UN ARRENDAMIENTO
       CALL ARRENDAAMORTIACT(
			Par_ArrendaID,		Par_ArrendaAmortiID, 	Par_Monto,		 		Par_TipoConcepto,		Var_NumActAmorti,
			Salida_NO,			Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
			Aud_FechaActual,    Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
        );

		-- SE VALIDA QUE EL STORE SE EJECUTE CORRECTAMENTE
       IF(Par_NumErr != Entero_Cero )THEN
			LEAVE ManejoErrores;
        END IF;

		-- STORE QUE ACTUALIZA EL ARRENDAMIENTO
		CALL ARRENDAMIENTOSACT(
			Par_ArrendaID, 		Var_NumActArre, 		Salida_NO,				Par_NumErr,				Par_ErrMen,
			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,    	Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion
		);

		-- SE VALIDA QUE EL STORE SE EJECUTE CORRECTAMENTE
		IF(Par_NumErr != Entero_Cero )THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr      := 000;
		SET Var_Control     := 'CargoAbonoID';
		SET Par_ErrMen      := CONCAT('Movimiento(s) de Cargo/Abono agregado(s) exitosamente: ',Var_FolioCarBon);
		SET Par_ConsecutivoCb  := Var_FolioCarBon;


	END ManejoErrores;

	IF (Par_Salida = Salida_Si) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control As control,
				Par_ConsecutivoCb AS consecutivo;

	END IF;

END TerminaStore$$