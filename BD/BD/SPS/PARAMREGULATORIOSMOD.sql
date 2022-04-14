-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMREGULATORIOSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMREGULATORIOSMOD`;

DELIMITER $$
CREATE PROCEDURE `PARAMREGULATORIOSMOD`(
	-- --------------------------------------------------------------------------------
	-- Modifica los parametros de regulatorios
	-- ---------------------------------------------------------------------------------
	Par_TipoRegulatorios 			INT,				-- Tipo de Regulatorio
    Par_ClaveEntidad     			VARCHAR(10), 		-- Clave de la Entidad
    Par_NivelOperaciones 			INT, 				-- Nivel de Operaciones
    Par_NivelPrudencial  			INT, 				-- Nivel Prudencial
    Par_CuentaEPRC		 			VARCHAR(10),      	-- Cuenta de Estimacion Preventiva

    Par_ClaveFederacion  			VARCHAR(10),		-- Clave de la federacion - sofipo
    Par_MuestraRegistros 			CHAR(1),			-- Mostrar todos los registros
    Par_MostrarComoOtros 			CHAR(1),			-- Mostrar Sucursal como Otros
    Par_SumaIntCredVencidos 		CHAR(1),			-- Suma Intereses de Credito Vencido
    Par_AjusteSaldo 				CHAR(1),			-- Si se Realiza Ajuste al Catalogo minimo

    Par_CuentaContableAjusteSaldo 	VARCHAR(15),		-- Cuenta Contable para el Ajuste del Catalogo minimo
	Par_MostrarSucursalOrigen		CHAR(1),			-- Valida si se muestra la sucursal origen del cliente o la sucursal donde se origino un credito, Inversion o CEDE
    Par_ContarEmpleados				CHAR(1),			-- Valiad si el conteo de empleados sera manual o por el sistema
    Par_TipoRepActEco				CHAR(1),			-- Indica la forma de reportar el destino de credito
    Par_AjusteResPreventiva			CHAR(1),			-- Campo que Ajusta la Reserva Preventiva de Cero Dias de Mora del Reporte R21 A2111. Valores: \nN.- NO \nS.- SI
	Par_AjusteCargoAbono			CHAR(1),			-- Ajustar Cargos y Abonos en Inversión y Cedes en el Regulatorio D0841
	Par_AjusteRFCMenor				CHAR(1),			-- Ajustar RFC del Cliente Menor en el Regulatorio D0841

    Par_Salida						CHAR(1), 			-- Parametro de Salida
	INOUT	Par_NumErr 				INT, 				-- Numero de error
	INOUT	Par_ErrMen  			VARCHAR(400),   	-- Mensaje de Salida

    Par_EmpresaID					INT,				-- Auditoria
	Aud_Usuario						INT, 				-- Auditoria
    Aud_FechaActual					DATETIME, 			-- Auditoria
	Aud_DireccionIP					VARCHAR(15), 		-- Auditoria
	Aud_ProgramaID					VARCHAR(50), 		-- Auditoria
	Aud_Sucursal					INT, 				-- Auditoria
	Aud_NumTransaccion				BIGINT 				-- Auditoria

)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_ClaveEntidad  	VARCHAR(10);	-- Clave de la entidad
	DECLARE Var_CuentaEprc    	VARCHAR(18); 	-- Cuenta Estimacion preventiva
	DECLARE Var_TipoRegula    	VARCHAR(4); 	-- Tipo de Regulatorios
	DECLARE Var_NivelEntidad  	VARCHAR(4);		-- Nivel de la entidad
	DECLARE Var_NivelOperacion  INT; 			-- Nivel de Operaciones
	DECLARE Var_NivelPrudencual INT; 			-- Nivel prudencial
	DECLARE Var_Control 		VARCHAR(50); 	-- Variable de control

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena Vacia
	DECLARE	Salida_SI			CHAR(1); 		-- Salida SI
	DECLARE	Salida_NO			CHAR(1); 		-- Salida NO
	DECLARE Con_SI				CHAR(1); 		-- Constante SI
	DECLARE Con_NO				CHAR(1); 		-- Constante NO
	DECLARE	Fecha_Vacia			DATE; 			-- Fecha Vacia
	DECLARE	Entero_Cero			INT; 			-- Entero cero
	DECLARE	Registro_ID			INT; 			-- ID del Registro
	DECLARE	Llave_TipoReg		VARCHAR(22); 	-- Llave Tipo de Regulatorios

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET Salida_SI		:= 'S';
	SET Salida_NO		:= 'N';
	SET Con_SI			:= 'S';
	SET Con_NO			:= 'N';
	SET Llave_TipoReg   := 'TipoRegulatorios';
	SET Registro_ID		:= 1;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr   := 999;
			SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									   'esto le ocasiona. Ref: SP-PARAMREGULATORIOSMOD');
			SET Var_Control  := 'SQLEXCEPTION';
		END;


		IF(IFNULL(Par_TipoRegulatorios, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 001;
				SET Par_ErrMen := 'El Tipo de Regulatorios esta vacio.';
				SET Var_Control := 'tipoRegulatorios';
				LEAVE ManejoErrores;
		END IF;

	    IF(IFNULL(Par_ClaveEntidad, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 002;
				SET Par_ErrMen := 'La clave de la entidad esta vacia.';
				SET Var_Control := 'claveEntidad';
				LEAVE ManejoErrores;
		END IF;

	    IF(IFNULL(Par_NivelOperaciones, Entero_Cero)) = Entero_Cero THEN
				SET Par_NivelPrudencial := Entero_Cero;
		END IF;

	    IF(IFNULL(Par_NivelPrudencial, Entero_Cero)) = Entero_Cero THEN
				SET Par_NivelOperaciones := Entero_Cero;
		END IF;


	    IF(IFNULL(Par_CuentaEPRC, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 005;
				SET Par_ErrMen := 'La Cuenta de Estimaciones Preventivas esta vacia.';
				SET Var_Control := 'cuentaEPRC';
				LEAVE ManejoErrores;
		END IF;

	    IF(IFNULL(Par_MuestraRegistros, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 006;
				SET Par_ErrMen := 'Indique si se muestran todos los registros.';
				SET Var_Control := 'muestraRegistros';
				LEAVE ManejoErrores;
		END IF;

	    IF(IFNULL(Par_MostrarComoOtros, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 007;
				SET Par_ErrMen := 'Indique si se cambia el canal de transaccion.';
				SET Var_Control := 'mostrarComoOtros';
				LEAVE ManejoErrores;
		END IF;

	    IF(IFNULL(Par_SumaIntCredVencidos, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 008;
				SET Par_ErrMen := 'Indique si se sumaran los intereses de credito vencido.';
				SET Var_Control := 'tipoSumaCreditos';
				LEAVE ManejoErrores;
		END IF;

	    IF(IFNULL(Par_AjusteSaldo, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 009;
				SET Par_ErrMen := 'Indique si se realizara Ajuste al Catalogo minimo.';
				SET Var_Control := 'ajusteSaldo';
				LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MostrarSucursalOrigen, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 010;
				SET Par_ErrMen := 'Indique si se muestra la sucursal origen del cliente.';
				SET Var_Control := 'mostrarSucursalOrigen';
				LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ContarEmpleados, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 011;
				SET Par_ErrMen := 'Indique si el conteo de Empleados es Manual o Por Sistema.';
				SET Var_Control := 'contarEmpleados';
				LEAVE ManejoErrores;
		END IF;

	    IF(IFNULL(Par_TipoRepActEco, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 012;
				SET Par_ErrMen := 'Indique la forma de Vincular la Actividad del Credito.';
				SET Var_Control := 'tipoRepActEco';
				LEAVE ManejoErrores;
		END IF;

		SET Par_AjusteResPreventiva := IFNULL(Par_AjusteResPreventiva, Cadena_Vacia);
		IF( Par_AjusteResPreventiva = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 013;
			SET Par_ErrMen 	:= 'Indique si Ajusta la Reserva Preventiva del Reporte R21 A2111.';
			SET Var_Control := 'ajusteResPreventiva';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_AjusteResPreventiva NOT IN (Con_SI, Con_NO)) THEN
			SET Par_NumErr 	:= 014;
			SET Par_ErrMen 	:= 'El valor Ingresado Para el Ajuste de Reserva Preventiva del Reporte R21 A2111 no es Correcto.';
			SET Var_Control := 'ajusteResPreventiva';
			LEAVE ManejoErrores;
		END IF;

		SET Par_AjusteCargoAbono := IFNULL(Par_AjusteCargoAbono, Cadena_Vacia);
		IF( Par_AjusteCargoAbono = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 015;
			SET Par_ErrMen 	:= 'Indique si Ajusta Cargos y Abonos en Inversion y Cedes en el Regulatorio D0841.';
			SET Var_Control := 'ajusteCargoAbono';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_AjusteCargoAbono NOT IN (Con_SI, Con_NO)) THEN
			SET Par_NumErr 	:= 016;
			SET Par_ErrMen 	:= 'El valor Ingresado Para el Ajuste de Cargos y Abonos en Inversion y Cedes en el Regulatorio D0841 no es Correcto.';
			SET Var_Control := 'ajusteCargoAbono';
			LEAVE ManejoErrores;
		END IF;

		SET Par_AjusteRFCMenor := IFNULL(Par_AjusteRFCMenor, Cadena_Vacia);
		IF( Par_AjusteRFCMenor = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 017;
			SET Par_ErrMen 	:= 'Indique si Ajusta el RFC del Cliente Menor en el Regulatorio D0841.';
			SET Var_Control := 'ajusteRFCMenor';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_AjusteRFCMenor NOT IN (Con_SI, Con_NO)) THEN
			SET Par_NumErr 	:= 018;
			SET Par_ErrMen 	:= 'El valor Ingresado Para el Ajuste el RFC del Cliente Menor en el Regulatorio D0841 no es Correcto.';
			SET Var_Control := 'ajusteRFCMenor';
			LEAVE ManejoErrores;
		END IF;

	    -- Actualizacion de los campos en tablas actuales,

	    SELECT CodigoOpcion
	    INTO Var_NivelEntidad
	    FROM CATNIVELENTIDADREG
	    WHERE NivelOperacionID  = IFNULL(Par_NivelOperaciones,Entero_Cero)
	      AND NivelPrudencialID = IFNULL(Par_NivelPrudencial,Entero_Cero);

		UPDATE PARAMETROSSIS SET
			ClaveEntidad			= 	Par_ClaveEntidad,
	        CuentaEPRC				=	Par_CuentaEPRC,
	        ClaveNivInstitucion		=   Var_NivelEntidad
	    WHERE EmpresaID = Par_EmpresaID;

	    UPDATE PARAMGENERALES
	    SET    ValorParametro = Par_TipoRegulatorios
		WHERE 	LlaveParametro = Llave_TipoReg;

		-- > Actualizacion de los campos en tablas actuales,


	-- Actualizacion/ registro en NIVELPRUDENOPERAINS
	    CALL NIVELPRUDENOPERAINSPRO(
				Var_NivelEntidad, 			Salida_NO, 			Par_NumErr,			Par_ErrMen,     Par_EmpresaID,
	            Aud_Usuario,        		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID, Aud_Sucursal,
	            Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


	    /* Actualizacion de la tabla de PARAMETROS REGULATORIOS */
	    UPDATE PARAMREGULATORIOS SET
		 	ClaveEntidad				= Par_ClaveEntidad,
	        NivelOperaciones			= Par_NivelOperaciones,
	        NivelPrudencial				= Par_NivelPrudencial,
	        CuentaEPRC					= Par_CuentaEPRC,
	        TipoRegulatorios			= Par_TipoRegulatorios,

	        ClaveFederacion 			= Par_ClaveFederacion,
	        MuestraRegistros 			= Par_MuestraRegistros,
	        MostrarComoOtros 			= Par_MostrarComoOtros,
	        IntCredVencidos 			= Par_SumaIntCredVencidos,
	        AjusteSaldo 				= Par_AjusteSaldo,

			CuentaContableAjusteSaldo 	= Par_CuentaContableAjusteSaldo,
			MostrarSucursalOrigen 		= Par_MostrarSucursalOrigen,
	        ContarEmpleados				= Par_ContarEmpleados,
	        TipoRepActEco				= Par_TipoRepActEco,
	        AjusteResPreventiva 		= Par_AjusteResPreventiva,

			AjusteCargoAbono			= Par_AjusteCargoAbono,
			AjusteRFCMenor 				= Par_AjusteRFCMenor,

	        EmpresaID					= Par_EmpresaID,
	        Usuario						= Aud_Usuario,
	        FechaActual					= Aud_FechaActual,
	        DireccionIP					= Aud_DireccionIP,
	        ProgramaID					= Aud_ProgramaID,
	        Sucursal					= Aud_Sucursal,
	        NumTransaccion				= Aud_NumTransaccion
	    WHERE ParametrosID = Registro_ID;


	    SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= 'Parametros modificados exitosamente.';
		SET Var_Control 	:= 'tipoRegulatorios';
		LEAVE ManejoErrores;

	END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control;
	END IF;

END TerminaStore$$