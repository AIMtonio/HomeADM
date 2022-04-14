-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGOXDISPOSCREDALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGOXDISPOSCREDALT`;
DELIMITER $$


CREATE PROCEDURE `CARGOXDISPOSCREDALT`(
/* SP DE ALTA LOS CARGOS POR DISPOSICION DE CREDITOS. */
	Par_CreditoID 				BIGINT(12), 		# ID del Crédito.
	Par_CuentaAhoID 			BIGINT(12), 		# ID de la Cuenta de Ahorro.
	Par_ClienteID 				INT(11), 			# ID del Cliente.
	Par_MontoCargo 				DECIMAL(14,2), 		# Monto del cargo por disposición.
	Par_FechaCargo 				DATE, 				# Fecha en la que se realiza el cargo por disposición.

	Par_InstitucionID 			INT(11), 			# ID de INSTITUCIONES.
	Par_NombInstitucion 		VARCHAR(100), 		# Nombre largo de la Institucion.
    Par_NatMovimiento			CHAR(1),			# Indica la Naturaleza del Movimiento C:Cargo  A:Abono
    Par_Salida           		CHAR(1),			# Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     		INT(11),			# Numero de Error
	INOUT Par_ErrMen     		VARCHAR(400),		# Mensaje de Error

    /* Parametros de Auditoria */
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),

	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)

TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Var_Control     		VARCHAR(50);
DECLARE	Var_TipoDispersion		CHAR(1);
DECLARE	Var_ProductoCreditoID	INT(11);
DECLARE	Var_TipoCargo			CHAR(1);
DECLARE	Var_Nivel				CHAR(1);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		VARCHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE	SalidaSI        	CHAR(1);
DECLARE	SalidaNO        	CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia			:= '';				-- Cadena vacia
SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero				:= 0;				-- Entero Cero
SET	SalidaSI        		:= 'S';				-- Salida Si
SET	SalidaNO        		:= 'N'; 			-- Salida No
SET Aud_FechaActual 		:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CARGOXDISPOSCREDALT');
			SET Var_Control:= 'sqlException' ;
		END;


	IF(IFNULL(Par_CreditoID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'El Credito esta Vacio.';
		SET Var_Control:= 'CreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_CuentaAhoID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := 'La Cuenta esta Vacia.';
		SET Var_Control:= 'cuentaAhoID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_ClienteID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'El Cliente esta Vacio.';
		SET Var_Control:= 'clienteID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_InstitucionID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 4;
		SET Par_ErrMen := 'La Institucion Bancaria esta Vacia.';
		SET Var_Control:= 'institucionID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MontoCargo, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 5;
		SET Par_ErrMen := 'El Monto se Encuentra Vacio.';
		SET Var_Control:= 'montoCargo' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_FechaCargo, Fecha_Vacia)) = Fecha_Vacia THEN
		SET Par_NumErr := 6;
		SET Par_ErrMen := 'La Fecha se Encuentra Vacia.';
		SET Var_Control:= 'fechaCargo' ;
		LEAVE ManejoErrores;
	END IF;

    IF(IFNULL(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 7;
		SET Par_ErrMen := 'La Naturaleza del Movimiento esta Vacia.';
		SET Var_Control:= 'natMovimiento' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_NombInstitucion, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NombInstitucion := (SELECT Nombre FROM INSTITUCIONES WHERE InstitucionID=IFNULL(Par_InstitucionID, Entero_Cero));
		SET Par_NombInstitucion := IFNULL(Par_NombInstitucion, Cadena_Vacia);
	END IF;

	SET Var_TipoDispersion		:= (SELECT TipoDispersion FROM CREDITOS WHERE CreditoID = Par_CreditoID);
    SET Var_TipoDispersion 		:=IFNULL(Var_TipoDispersion, "O");
	SET Var_ProductoCreditoID	:= (SELECT ProductoCreditoID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
	SET Var_TipoCargo			:= (SELECT TipoCargo FROM ESQUEMACARGOSDISP
									WHERE ProductoCreditoID = Var_ProductoCreditoID
										AND InstitucionID = Par_InstitucionID
                                        AND TipoDispersion = Var_TipoDispersion);
	
	SET Var_Nivel				:= (SELECT Nivel FROM ESQUEMACARGOSDISP
									WHERE ProductoCreditoID = Var_ProductoCreditoID
										AND InstitucionID = Par_InstitucionID
										AND TipoDispersion = Var_TipoDispersion);

	INSERT INTO CARGOXDISPOSCRED(
		CreditoID,			CuentaAhoID,			ClienteID,				MontoCargo,				FechaCargo,
		InstitucionID,		NombInstitucion,		Naturaleza,				TipoDispersion,			TipoCargo,
		Nivel,				EmpresaID,				Usuario,		        FechaActual,			DireccionIP,
        ProgramaID,			Sucursal,				NumTransaccion)
	VALUES(
		Par_CreditoID,		Par_CuentaAhoID,		Par_ClienteID,			Par_MontoCargo,			Par_FechaCargo,
		Par_InstitucionID,	Par_NombInstitucion,	Par_NatMovimiento,		Var_TipoDispersion,		Var_TipoCargo,
		Var_Nivel,			Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
        Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Disposicion de Cargo Grabado Exitosamente.';
	SET Var_Control:= 'creditoID' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
			Par_CreditoID AS Consecutivo;
END IF;

END TerminaStore$$