-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIGENCUENTACLABECREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIGENCUENTACLABECREPRO`;
DELIMITER $$


CREATE PROCEDURE `SPEIGENCUENTACLABECREPRO`(
-- ====================================================================================================================================
-- ---------------------- SP QUE GENERA LA CUENTA CLABE DE UN CREDITO -----------------------------------------------------
-- ====================================================================================================================================
  Par_CreditoID				BIGINT(12),			-- ID del credito

  Par_Salida				CHAR(1),			-- Parametro de Salida
  INOUT Par_NumErr			INT(11),			-- Numero de Error
  INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje de error
  INOUT Par_CuentaClabe		VARCHAR(18),		-- Cuenta Clabe generada
  
  -- Parametros de Auditoria
  Par_EmpresaID				INT(11),			-- Parametro de Auditoria
  Aud_Usuario				INT(11),			-- Parametro de Auditoria
  Aud_FechaActual			DATETIME,			-- Parametro de Auditoria
  Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
  Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
  Aud_Sucursal				INT(11),			-- Parametro de Auditoria
  Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_CuentaClabe				VARCHAR(18);    	-- Cuenta clabe del credito
	DECLARE Var_Contador      			INT(11);      		-- Variable contador
	DECLARE Var_TipoPersona				CHAR(1);			-- Tipo de persona Fisica, Fisica Act. Empresarial y Moral
	DECLARE Var_Control					VARCHAR(50);		-- Nombre de Control
	DECLARE Var_Consecutivo				VARCHAR(18);		-- ID de la cuenta clabe
	DECLARE Var_CreditoID				BIGINT(12);			-- ID del Credito
	DECLARE Var_ClienteID				INT(11);			-- ID del Cliente
	DECLARE Var_EstatusCre				CHAR(1);			-- Estatus del Credito
	DECLARE Var_ProductCreID			INT(11);			-- ID del Producto de Credito
	DECLARE Var_ParticipaSpei			CHAR(1);			-- Indica si el credito participa en SPEI
	DECLARE Var_CuentaClabeAct			VARCHAR(18);		-- Cuenta clabe actual

	-- Declaracion de Constantes
	DECLARE Fecha_Vacia     			DATE;				-- Fecha Vacia
	DECLARE Entero_Cero     			INT;				-- Entero en Cero
	DECLARE Cadena_Vacia    			CHAR(1);			-- String o Cadena Vacia
	DECLARE Decimal_Cero    			DECIMAL(12,2);		-- Decimal Cero
	DECLARE Var_NumIntentos      	 	INT(11);    		-- Numero de intentos para registrar la cuenta clabe
	DECLARE Constante_SI				CHAR(1);			-- Constante SI
	DECLARE Constante_NO				CHAR(1);			-- Constante NO
	DECLARE Per_Emp						CHAR(1);			-- Tipo persona Fisica con actividad empresarial
	DECLARE Per_Fisica					CHAR(1);			-- Tipo persona Fisica
	DECLARE InstrumentoCR				CHAR(2);			-- Instrumento de Credito
	DECLARE DesFirmaPrueba				VARCHAR(13);		-- Descripcion Firma de Prueba
	DECLARE Entero_Uno					TINYINT;			-- Entero con valor 1

	-- Asignacion de Constantes
	SET Fecha_Vacia   					:= '1900-01-01';  	-- Fecha Vacia
	SET Entero_Cero   					:= 0;				-- Entero en Cero
	SET Cadena_Vacia  					:= '';				-- String o Cadena Vacia
	SET Decimal_Cero  					:= '0.00';			-- Decimal Cero
	SET Var_NumIntentos       			:= 3;				-- Numero de intentos para registrar la cuenta clabe
	SET Constante_SI					:= 'S';				-- Constante SI
	SET Constante_NO					:= 'N';				-- Constante NO
	SET Per_Emp							:= 'A';				-- Tipo persona Fisica con actividad empresarial
	SET Per_Fisica						:= 'F';				-- Tipo persona Fisica
	SET InstrumentoCR					:='CR';				-- Instrumento de Credito
	SET DesFirmaPrueba					:= 'FIRMA PRUEBA';	-- Descripcion Firma de Prueba
	SET Entero_Uno						:= 1;				-- Entero con valor 1

	-- Asignacion de valores por defecto
	SET Par_CreditoID := IFNULL(Par_CreditoID, Entero_Cero);


	ManejoErrores: BEGIN
	    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
	                  'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIGENCUENTACLABECREPRO');
			SET Var_Control := 'sqlexception';
		END;

		IF(Par_CreditoID = Entero_Cero) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'Especifique el numero de credito.';
			SET Var_Control := 'creditoID';
			SET Var_Consecutivo := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		SELECT 		CreditoID,			ClienteID,			Estatus,			ProductoCreditoID
			INTO 	Var_CreditoID,		Var_ClienteID,		Var_EstatusCre,		Var_ProductCreID
			FROM 	CREDITOS 
			WHERE CreditoID = Par_CreditoID;

		IF(IFNULL(Var_CreditoID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'No se encontro informacion con el numero de credito proporcionado.';
			SET Var_Control  := 'creditoID';
			SET Var_Consecutivo := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		SELECT 		ParticipaSpei
			INTO 	Var_ParticipaSpei
			FROM PRODUCTOSCREDITO 
			WHERE ProducCreditoID = Var_ProductCreID;

		IF(IFNULL(Var_ParticipaSpei, Constante_NO) = Constante_NO) THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'El producto de credito no esta configurado para participar en SPEI.';
			SET Var_Control  := 'creditoID';
			SET Var_Consecutivo := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		SELECT 		TipoPersona 
			INTO 	Var_TipoPersona
			FROM CLIENTES 
			WHERE ClienteID = Var_ClienteID;

		SET Var_CuentaClabe := Cadena_Vacia;
		SET Var_Contador = Entero_Cero;

		IF(Var_TipoPersona NOT IN (Per_Emp, Per_Fisica)) THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := 'No se puede registrar la cuenta clabe para personas morales.';
			SET Var_Control  := 'creditoID';
			SET Var_Consecutivo := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		SELECT 		CuentaClabe
			INTO 	Var_CuentaClabeAct
			FROM SPEICUENTASCLABEPFISICA
			WHERE TipoInstrumento = InstrumentoCR 
			AND Instrumento = Par_CreditoID;


		IF(IFNULL(Var_CuentaClabeAct, Cadena_Vacia) <> Cadena_Vacia) THEN
			SET Par_NumErr := 5;
			SET Par_ErrMen := 'El credito ya tiene asignado una cuenta clabe.';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		/* Se deja en 3 intentos para crear una cuenta clabe */
		LoopCuentas: WHILE Var_Contador < Var_NumIntentos DO
			SET Var_Contador := Var_Contador + Entero_Uno;

			CALL GENERACLABEPRO(
				Var_TipoPersona,    	Var_CuentaClabe,    	Constante_NO,   		Par_NumErr,     		Par_ErrMen,
				Par_EmpresaID,			Aud_Usuario,      		Aud_FechaActual,  		Aud_DireccionIP,  		Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion
			);

			IF(Par_NumErr = Entero_Cero)THEN
				LEAVE LoopCuentas;
			END IF;
		END WHILE LoopCuentas;

		IF(Par_NumErr != Entero_Cero)THEN
			SET Par_NumErr := 50;
			SET Par_ErrMen := CONCAT('La Cuenta CLABE no puede estar vacia.');
			SET Var_Control := 'creditoID';
			SET Var_Consecutivo := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		CALL BITASPEICUENTASCLABEPRO(
			Var_ClienteID,    		Var_CuentaClabe,  		InstrumentoCR,    		Par_CreditoID,   		DesFirmaPrueba,
			Constante_NO,			Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
		);

		IF(Par_NumErr != Entero_Cero) THEN 
			LEAVE ManejoErrores;
		END IF;

   		SET Par_CuentaClabe := Var_CuentaClabe;
	    SET Par_NumErr  := 0;
	    SET Par_ErrMen  := CONCAT('Cuenta clabe de Credito Generado Exitosamente: ', Var_CuentaClabe);
	    SET Var_Control  := 'cuentaClabe';
	    SET Var_Consecutivo := Var_CuentaClabe;
	END ManejoErrores; -- End del Handler de Errores

	IF (Par_Salida = Constante_SI) THEN
	    SELECT CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
	        Par_ErrMen    AS ErrMen,
	        Var_Control    AS control,
	        Var_Consecutivo   AS consecutivo;
	END IF;

END TerminaStore$$ 
