-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQACCESORIOSPRODMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQACCESORIOSPRODMOD`;
DELIMITER $$


CREATE PROCEDURE `ESQACCESORIOSPRODMOD`(
-- ===================================================================================
-- SP PARA MODIFICAR LOS ACCESORIOS A COBRAR DE UN CREDITO
-- ===================================================================================
	Par_ProducCreditoID		INT(11),				-- Numero del Producto de Credito
    Par_AccesorioID			INT(11),				-- Numero de Acceosorio
	Par_InstitNominaID		INT(11),				-- Numero de Empresa de Nómina
	Par_CobraIVA			CHAR(1),				-- Indica si el Accesorio Cobra IVA
	Par_GeneraInteres		CHAR(1),				-- Indica si el Accesorio cobra intereses.
	Par_CobraIVAInteres		CHAR(1),				-- Indica si el Accesorio cobra interes bajo su IVA.

	Par_TipoFormaCobro		CHAR(1),				-- Indica la Forma de Cobro del Accesorio F: FINANCIAMIENTO  D: DEDUCCION:  A: ANTICIPADO
    Par_TipoPago			CHAR(1),				-- Indica el Tipo de Pago del Accesorio M: Monto Fijo    P: Porcentaje
    Par_BaseCalculo			CHAR(1),				-- Indica la base de calculo para el cobro del Accesorio cuando la forma de cobro sea FINANCIAMIENTO y el tipo de pago sea Porcentaje

	Par_Salida				CHAR(1),				-- Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),				-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),			-- Mensaje de Error

	/* Parametros de Auditoria */
	Aud_EmpresaID 			INT(11),
	Aud_Usuario 			INT(11),
  	Aud_FechaActual 		DATETIME,
  	Aud_DireccionIP 		VARCHAR(15),
  	Aud_ProgramaID 			VARCHAR(50),
  	Aud_Sucursal 			INT(11),
  	Aud_NumTransaccion 		BIGINT(20)
)

TerminaStore:BEGIN

	/*Declaracion de Variables*/
	DECLARE Var_Control 			VARCHAR(50); 		-- Variable Cotrol en Pantalla
	DECLARE	Var_Consecutivo 		INT(11); 			-- Variable Consecutivo
	DECLARE	Var_MontoBase			DECIMAL(12,2); 		-- Variable Monto Base
	DECLARE Var_EsqAccesorioID 		INT(11); 			-- Variable ID del Esquema de Accesorios
	DECLARE Var_Contador			INT(11); 			-- Variable Contador Auxiliar
	DECLARE Var_SaldoDipon			DECIMAL(12,2); 		-- Variable Saldo Disponible
	DECLARE Var_EstatusProducCred	CHAR(2);			-- Estatus del Producto Credito
	DECLARE Var_Descripcion			VARCHAR(100);		-- Descripcion Producto Credito


	/*Declaración de Constantes*/
	DECLARE	Entero_Cero 	INT(11); 				-- Constante Entero Cero
	DECLARE Decimal_Cero	DECIMAL(12,2); 			-- Constante Decimal Cero
	DECLARE Fecha_Vacia		DATE; 					-- Constante Fecha Vacía
	DECLARE SalidaSI		CHAR(1); 				-- Constante Salida Si
	DECLARE Cadena_Vacia	VARCHAR(100); 			-- Constante Cedena Vacía
    DECLARE SalidaNo		CHAR(1); 				-- Constante Salida No
    DECLARE Pago_Porcen		CHAR(1); 				-- constante Pago Porcentaje : P
	DECLARE Estatus_Inactivo    CHAR(1); 			-- Estatus Inactivo


	/*Asignacion de Constantes*/
	SET Entero_Cero 		:= 0; 						-- Constante Entero Cero
	SET Decimal_Cero 		:= 0.0; 					-- Constante Decimal Cero
	SET Fecha_Vacia			:= '1900-01-01'; 			-- Constante Fecha Vacía
	SET SalidaSI			:= 'S'; 					-- Constante Salida Si
	SET Cadena_Vacia 		:= ''; 						-- Constante Cadena Vacía
    SET SalidaNo 			:= 'N'; 					-- Constante Salida No
    SET Pago_Porcen 		:= 'P'; 					-- Constante Pago Porcentaje
    SET Estatus_Inactivo	:= 'I';						-- Estatus Inactivo

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocaciones. Ref: SP-ESQACCESORIOSPRODMOD');
			SET Var_Control	:='SQLEXCEPTION';
		END;

    IF(IFNULL(Par_AccesorioID,Entero_Cero)=Entero_Cero)THEN
		SET Par_NumErr := 01;
		SET Par_ErrMen := 'El Numero Accesrios esta vacio.';
		SET Var_Control := 'descripcion';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_ProducCreditoID,Entero_Cero)=Entero_Cero)THEN
		SET Par_NumErr := 02;
		SET Par_ErrMen := 'El Producto de Credito esta vacio.';
		SET Var_Control := 'descripcion';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_CobraIVA,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr := 03;
		SET Par_ErrMen := 'Indicar el valor Cobra IVA.';
		SET Var_Control := 'abreviatura';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipoFormaCobro,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr := 04;
		SET Par_ErrMen := 'Indicar el Tipo de Forma de Cobro.';
		SET Var_Control := 'prelacion';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipoPago,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr := 05;
		SET Par_ErrMen := 'Indicar el Tipo de Pago.';
		SET Var_Control := 'prelacion';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_BaseCalculo,Cadena_Vacia)=Cadena_Vacia AND IFNULL(Par_TipoPago,Cadena_Vacia)=Pago_Porcen)THEN
		SET Par_NumErr := 06;
		SET Par_ErrMen := 'Indicar la Base de Calculo.';
		SET Var_Control := 'prelacion';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_GeneraInteres,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr := 07;
		SET Par_ErrMen := 'Indicar el valor Genera Interes.';
		SET Var_Control := 'generaInteres';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_GeneraInteres = SalidaNo)THEN
		SET Par_CobraIVAInteres	:= SalidaNo;
	END IF;

	IF(IFNULL(Par_CobraIVAInteres,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr := 08;
		SET Par_ErrMen := 'Indicar el valor Cobra IVA Interes.';
		SET Var_Control := 'cobraIVaInteres';
		LEAVE ManejoErrores;
	END IF;

    SELECT 	Estatus, 				Descripcion
    INTO	Var_EstatusProducCred,	Var_Descripcion
    FROM PRODUCTOSCREDITO
    WHERE ProducCreditoID = IFNULL(Par_ProducCreditoID, Entero_Cero);

	IF(Var_EstatusProducCred = Estatus_Inactivo) THEN
		SET Par_NumErr := 009;
		SET Par_ErrMen := CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
		SET Var_Control:= 'producCreditoID' ;
		LEAVE ManejoErrores;
	END IF;


    SET Par_BaseCalculo := IFNULL(Par_BaseCalculo,Cadena_Vacia);

	UPDATE ESQUEMAACCESORIOSPROD SET
		CobraIVA 			= 	Par_CobraIVA,
		GeneraInteres		=	Par_GeneraInteres,
		CobraIVAInteres		=	Par_CobraIVAInteres,
		TipoFormaCobro 		= 	Par_TipoFormaCobro,
		TipoPago 			= 	Par_TipoPago,
		BaseCalculo 		= 	Par_BaseCalculo,
		EmpresaID 			= 	Aud_EmpresaID,
		Usuario 			= 	Aud_Usuario,
		FechaActual 		= 	Aud_FechaActual,
		DireccionIP 		= 	Aud_DireccionIP,
		ProgramaID 			= 	Aud_ProgramaID,
		Sucursal 			= 	Aud_Sucursal,
		NumTransaccion 		= 	Aud_NumTransaccion
	WHERE ProductoCreditoID = Par_ProducCreditoID
    AND AccesorioID = Par_AccesorioID
    AND InstitNominaID	= Par_InstitNominaID;

	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := 'Esquema Modificado Exitosamente';
	SET Var_Control := 'accesorioID';
	SET Var_Consecutivo := Par_ProducCreditoID;

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
                Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$