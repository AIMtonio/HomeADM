-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACCESORIOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIPARAMPAGOCREPRO`;
DELIMITER $$


CREATE PROCEDURE `SPEIPARAMPAGOCREPRO`(
-- ===================================================================================
-- SP PARA REGISTRAR LOS PARAMETROS DE PAGO DE CREDITO POR SPEI
-- ===================================================================================
	Par_NumEmpresaID			INT(11),		# Numero de empresa
	Par_AplicaPagAutCre			CHAR(1),		# Pago Automatico S.-SI N.-NO
	Par_EnCasoNoTieneExiCre	 	CHAR(1),		# No Tiene Exigible el credito A.-Abono a Cta. P.-Prepago
	Par_EnCasoSobrantePagCre	CHAR(1),		# Tiene Sobrante del Pago A.-Abono a Cta. P.-Prepago

	Par_Salida					CHAR(1),		# Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr			INT(11),		# Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	# Mensaje de Error

	/* Parametros de Auditoria */
	Aud_EmpresaID 				INT(11),
	Aud_Usuario 				INT(11),
  	Aud_FechaActual 			DATETIME,
  	Aud_DireccionIP 			VARCHAR(15),
  	Aud_ProgramaID 				VARCHAR(50),
  	Aud_Sucursal 				INT(11),
  	Aud_NumTransaccion 			BIGINT(20)
)

TerminaStore:BEGIN

	/*Declaracion de Variables*/
	DECLARE Var_Control 		VARCHAR(50); 	# Control en Pantalla
	DECLARE	Var_Consecutivo 	INT(11); 		# Consecutivo en Pantalla
	DECLARE Var_NumEmpresaID	INT(11);		# Numero de cliente especifico
	DECLARE Var_NumEmpresa		INT(11);		# Numero de la institucion

	/*Declración de Constantes*/
	DECLARE	Entero_Cero 	INT(11); 		# Constante Entero Cero
    DECLARE Entero_Uno 		INT(11); 		# Constante Entero Uno
	DECLARE Decimal_Cero	DECIMAL(12,2); 	# Constante Decimal Cero
	DECLARE Fecha_Vacia		DATE; 			# Constante Fecha Vacía
	DECLARE SalidaSI		CHAR(1); 		# Constante Cadena Si
	DECLARE Cadena_Vacia	VARCHAR(100); 	# Constante Cadena Vacía
    DECLARE SalidaNo		CHAR(1); 		# Constante Salida No*/
	DECLARE CliEspecifico	VARCHAR(50);	# Cliente Especifico

	/*Asignacion de Constantes*/
	SET Entero_Cero 	:= 0; 				# Constante Entero Cero
    SET Entero_Uno 		:= 1; 				# Constante Entero Uno
	SET Decimal_Cero 	:= 0.0; 			# Constante Decimal Cero
	SET Fecha_Vacia		:= '1900-01-01'; 	# Constante Fecha Vacía
	SET SalidaSI		:= 'S'; 			# Constante Cadena Si
	SET Cadena_Vacia 	:= ''; 				# Constante Cadena Vacía
    SET SalidaNo 		:= 'N'; 			# Constante Salida No
	SET CliEspecifico	:= 'CliProcEspecifico';

	ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocaciones. Ref: SP-SPEIPARAMPAGOCREPRO');
			SET Var_Control	:='SQLEXCEPTION';
		END;
		
        SELECT ValorParametro INTO Var_NumEmpresaID
			FROM PARAMGENERALES 
            WHERE LlaveParametro=CliEspecifico;
		
        SELECT NumEmpresaID INTO Var_NumEmpresa 
			FROM SPEIPARAMPAGOCRE
            WHERE NumEmpresaID = Par_NumEmpresaID;
        
        SET Var_NumEmpresa := IFNULL(Var_NumEmpresa, Entero_Cero);
        
		IF(Par_NumEmpresaID = Entero_Cero)THEN
			SET Par_NumErr := 01;
			SET Par_ErrMen := 'El cliente especifico esta vacio.';
			SET Var_Control := 'aplicaPagAutCre';
			LEAVE ManejoErrores;
        END IF;

		IF(Var_NumEmpresaID != Par_NumEmpresaID)THEN
			SET Par_NumErr := 02;
			SET Par_ErrMen := 'El cliente especifico no existe.';
			SET Var_Control := 'aplicaPagAutCre';
			LEAVE ManejoErrores;
        END IF;
        
        IF(IFNULL(Par_AplicaPagAutCre,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr := 03;
			SET Par_ErrMen := 'Aplica en automático el pago de crédito esta vacio.';
			SET Var_Control := 'aplicaPagAutCre';
			LEAVE ManejoErrores;
		END IF;
        
        IF(IFNULL(Par_EnCasoNoTieneExiCre,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr := 04;
			SET Par_ErrMen := 'En caso de no tener exigible esta vacio.';
			SET Var_Control := 'aplicaPagAutCre';
			LEAVE ManejoErrores;
		END IF;
        
        IF(IFNULL(Par_EnCasoSobrantePagCre,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr := 05;
			SET Par_ErrMen := 'En caso de sobrante esta vacio.';
			SET Var_Control := 'aplicaPagAutCre';
			LEAVE ManejoErrores;
		END IF;
        
        IF(Var_NumEmpresa = Entero_Cero)THEN
			INSERT IGNORE INTO SPEIPARAMPAGOCRE 
					(NumEmpresaID, 			AplicaPagAutCre, 		EnCasoNoTieneExiCre,		EnCasoSobrantePagCre, 
					EmpresaID, 				Usuario, 				FechaActual, 				DireccionIP, 						ProgramaID, 
					Sucursal, 				NumTransaccion)
			VALUES	(Var_NumEmpresaID,		Par_AplicaPagAutCre,	Par_EnCasoNoTieneExiCre,	Par_EnCasoSobrantePagCre,
					Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual, 			Aud_DireccionIP,					Aud_ProgramaID, 			
					Aud_Sucursal, 			Aud_NumTransaccion
                    );
        END IF;
        
        IF(Var_NumEmpresa !=Entero_Cero)THEN
			-- Actualiza Accesorios
			UPDATE SPEIPARAMPAGOCRE SET
				AplicaPagAutCre 		= 	Par_AplicaPagAutCre,
				EnCasoNoTieneExiCre 	= 	Par_EnCasoNoTieneExiCre,
				EnCasoSobrantePagCre 	= 	Par_EnCasoSobrantePagCre,
				EmpresaID 				= 	Aud_EmpresaID,
				Usuario 				= 	Aud_Usuario,
				FechaActual 			= 	Aud_FechaActual,
				DireccionIP 			= 	Aud_DireccionIP,
				ProgramaID 				= 	Aud_ProgramaID,
				Sucursal 				= 	Aud_Sucursal,
				NumTransaccion 			=  	Aud_NumTransaccion
			WHERE NumEmpresaID 	= Var_NumEmpresaID;
        END IF;
        
        
		SET Par_NumErr := 00;
		SET Par_ErrMen := 'Operación realizada correctamente';
		SET Var_Control := 'aplicaPagAutCre';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
                Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$
