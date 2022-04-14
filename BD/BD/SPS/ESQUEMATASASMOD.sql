-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMATASASMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMATASASMOD`;
DELIMITER $$

CREATE PROCEDURE `ESQUEMATASASMOD`(
# =====================================================================================
# ------- STORED PARA MODIFICACION ESQUEMA DE TASAS POR PRODUCTO DE CREDITO Y SUCURSAL---------
# =====================================================================================
	Par_SucursalID 			INT(11),			-- Numero de sucursal
	Par_ProdCreID 			INT(11),			-- Producto de credito
	Par_MinCredito			INT(11),			-- Minimo de creditos
	Par_MaxCredito			INT(11),			-- Maximo de creditos
	Par_Califi				VARCHAR(45),		-- Calificacion del cliente

	Par_MontoInf			DECIMAL(12,2),		-- Monto Inferior
	Par_MontoSup			DECIMAL(12,2),		-- Monto Superior
	Par_PlazoID				VARCHAR(20),		-- ID del plazo del producto, DEFAULT es "T"=TODOS, tabla CREDITOSPLAZOS.
	Par_TasaFija			DECIMAL(12,4),		-- Tasa Fija
	Par_SobreTasa			DECIMAL(12,4),		-- Sobre Tasa

	Par_InstitNominaID		INT(11),			-- ID De la Institucion de Nomina
   	Par_NivelID				INT(11),			-- Valor que el analista de credito asigna en el registro, DEFAULT 0=TODA, hace referecia a una tabla

    Par_Salida    			CHAR(1), 			-- Parametro de salida S= si, N= no
    INOUT	Par_NumErr 		INT(11),			-- Parametro de salida numero de error
    INOUT	Par_ErrMen  	VARCHAR(400),		-- Parametro de salida mensaje de error

	/* Parametros de Auditoria */
    Par_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	Var_MonMin		DECIMAL(12,2);
	DECLARE	Var_MonMax		DECIMAL(12,2);
	DECLARE Var_Control 	VARCHAR(50);
	DECLARE Var_Consecutivo	VARCHAR(50);
	DECLARE	Var_CalcInteres	INT;
	DECLARE Var_Estatus		CHAR(2);		-- Almacena el estatus del producto de credito
	DECLARE Var_Descripcion	VARCHAR(100);	-- Almacena la descripcion del producto de credito


	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT;
	DECLARE	Float_Cero		FLOAT;
	DECLARE	Decimal_Cero	DECIMAL(12,2);
	DECLARE	SalidaSI		CHAR(1);
	DECLARE	SalidaNO		CHAR(1);
	DECLARE	TasaFijaID		INT;
	DECLARE Estatus_Inactivo			CHAR(1);	-- Estatus Inactivo

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Entero_Cero			:= 0;
	SET	Float_Cero			:= 0.0;
	SET	Decimal_Cero		:= 0.0;
	SET	SalidaSI			:= 'S';
	SET	SalidaNO			:= 'N';
	SET TasaFijaID			:= 1;
	SET Estatus_Inactivo	:= 'I';		 -- Estatus Inactivo

	SET Aud_FechaActual 	:= NOW();

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ESQUEMATASASMOD');
				SET Var_Control= 'SQLEXCEPTION' ;
			END;

		SET Par_InstitNominaID := IFNULL(Par_InstitNominaID,Entero_Cero);

		SELECT	MontoMinimo,	MontoMaximo,	Estatus,		Descripcion
		 INTO	Var_MonMin,		Var_MonMax,		Var_Estatus,	Var_Descripcion
			FROM PRODUCTOSCREDITO
			WHERE ProducCreditoID = Par_ProdCreID;

		IF IFNULL(Par_SucursalID, Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'La sucursal esta vacia';
			SET Var_Control		:= 'sucursalID';
			SET Var_Consecutivo	:= Par_SucursalID;
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_ProdCreID, Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'El Producto de Credito esta Vacio.';
			SET Var_Control		:= 'productoCreditoID';
			SET Var_Consecutivo	:= Par_ProdCreID;
			LEAVE ManejoErrores;
		END IF;


		IF IFNULL(Par_MinCredito, Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr 		:= 3;
			SET Par_ErrMen 		:= 'El Minimo de Creditos esta Vacio.';
			SET Var_Control		:= 'minCredito';
			SET Var_Consecutivo	:= Par_MinCredito;
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_MaxCredito, Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr 		:= 4;
			SET Par_ErrMen 		:= 'El Maximo de Creditos esta Vacio.';
			SET Var_Control		:= 'maxCredito';
			SET Var_Consecutivo	:= Par_MaxCredito;
			LEAVE ManejoErrores;
		END IF;


		IF IFNULL(Par_Califi, Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr 		:= 5;
			SET Par_ErrMen 		:= 'La Calificacion esta Vacia.';
			SET Var_Control		:= 'calificacion';
			SET Var_Consecutivo	:= Par_Califi;
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_MontoInf, Decimal_Cero) < Var_MonMin ) THEN
			SET Par_NumErr 		:= 6;
			SET Par_ErrMen 		:= CONCAT('El Monto Inferior no debe ser menor a: ',CONVERT(Var_MonMin,CHAR(20)));
			SET Var_Control		:= 'montoInferior';
			SET Var_Consecutivo	:= Par_MontoInf;
			LEAVE ManejoErrores;
		END IF;


		IF (IFNULL(Par_MontoInf, Decimal_Cero) > Var_MonMax ) THEN
			SET Par_NumErr 		:= 7;
			SET Par_ErrMen 		:= 'El Monto Inferior no debe ser Mayor al Superior';
			SET Var_Control		:= 'montoInferior';
			SET Var_Consecutivo	:= Par_MontoInf;
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_MontoSup, Entero_Cero) > Var_MonMax ) THEN
			SET Par_NumErr 		:= 8;
			SET Par_ErrMen 		:= CONCAT('El monto Superior no debe ser Mayor a: ',CONVERT(Var_MonMax,CHAR(20)));
			SET Var_Control		:= 'montoSuperior';
			SET Var_Consecutivo	:= Par_MontoSup;
			LEAVE ManejoErrores;
		END IF;

		SELECT CalcInteres INTO Var_CalcInteres
			FROM PRODUCTOSCREDITO
				WHERE ProducCreditoID=IFNULL(Par_ProdCreID, Entero_Cero);

		/* Se valida que la tasa fija no venga vacia cuando el producto de credito
		 * hace el calculo de intereses por tasa fija
		 * */
		IF(((IFNULL(Par_TasaFija,Decimal_Cero))=Decimal_Cero) AND IFNULL(Var_CalcInteres,Entero_Cero)=TasaFijaID)THEN
			SET Par_NumErr 		:= 9;
			SET Par_ErrMen 		:= 'La Tasa Fija esta Vacia.';
			SET Var_Control		:= 'tasaFija';
			SET Var_Consecutivo	:= Par_TasaFija;
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Estatus = Estatus_Inactivo) THEN
			SET Par_NumErr 	:= 10;
			SET Par_ErrMen 	:= CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
			SET Var_Control	:= 'productoCreditoID';
			LEAVE ManejoErrores;
		END IF;

		UPDATE ESQUEMATASAS SET
			SucursalID 				= Par_SucursalID,
			ProductoCreditoID 		= Par_ProdCreID,
			MinCredito 				= Par_MinCredito,
			MaxCredito 				= Par_MaxCredito,
			Calificacion 			= Par_Califi,

			MontoInferior 			= Par_MontoInf,
			MontoSuperior			= Par_MontoSup,
			PlazoID					= Par_PlazoID,
			TasaFija				= Par_TasaFija,
			SobreTasa 				= Par_SobreTasa,

			InstitNominaID			= Par_InstitNominaID,

			Empresa 				= Par_EmpresaID,
			Usuario 				= Aud_Usuario,
			FechaActual 			= Aud_FechaActual,
			DireccionIP 			= Aud_DireccionIP,
			ProgramaID 				= Aud_ProgramaID,
			Sucursal 				= Aud_Sucursal,
			NumTransaccion 			= Aud_NumTransaccion

		WHERE SucursalID 			= Par_SucursalID
			AND ProductoCreditoID 	= Par_ProdCreID
			AND MinCredito 			= Par_MinCredito
			AND MaxCredito 			= Par_MaxCredito
			AND Calificacion 		= Par_Califi
			AND MontoInferior 		= Par_MontoInf
			AND MontoSuperior 		= Par_MontoSup
			AND PlazoID				= Par_PlazoID
			AND InstitNominaID		= Par_InstitNominaID
            AND NivelID				= Par_NivelID;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= 'Esquema de Tasa Modificado.';
		SET Var_Control		:= 'sucursalID';
		SET Var_Consecutivo	:= Par_SucursalID;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$