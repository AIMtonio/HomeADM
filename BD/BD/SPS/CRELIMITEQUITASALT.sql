-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRELIMITEQUITASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRELIMITEQUITASALT`;
DELIMITER $$

CREATE PROCEDURE `CRELIMITEQUITASALT`(
	Par_ProducCreditoID			INT(11),			-- Identificador del producto de credito
	Par_ClavePuestoID			VARCHAR(10),		-- Clave del puesto del cliente
	Par_LimMontoCap				DECIMAL(12,2),		-- Parametro del Limite del monto capital
	Par_LimPorcenCap			DECIMAL(12,4),		-- Parametro del Limite del porcentaje de capital
	Par_LimMontoIntere			DECIMAL(12,2),		-- Parametro del Limite del monto del interes

	Par_LimPorcenIntere			DECIMAL(12,4),		-- Parametro del porcentaje del monto interes
	Par_LimMontoMorato			DECIMAL(12,2),		-- Parametro del limite del monto moratorio
	Par_LimPorcenMorato			DECIMAL(12,4),		-- Parametro del porcentaje moratorio
	Par_LimMontoAccesorios		DECIMAL(12,2),		-- Parametro del limite del monto de accesorios
	Par_LimPorcenAccesorios		DECIMAL(12,4),		-- Parametro limite del porcentaje de accesorios

	Par_LimMontoNotasCargos		DECIMAL(12,2),		-- Parametro del Monto Limite de Condonacion de Notas cargos
	Par_LimPorcenNotasCargos	DECIMAL(12,4),		-- Parametro Limite de Porcentaje de Condonacion de Notas Cargos
	Par_NumMaxCondona			INT(11),			-- Parametro del numero de condonaciones

	Par_Salida					CHAR(1),			-- Parametro de salida
	INOUT Par_NumErr			INT(11),			-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje de Error

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
  )
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_DescriProd  	CHAR(150);		-- Descripcion del producto
	DECLARE Var_DescriPues  	CHAR(150);		-- Descripcion del puesto
	DECLARE Var_Control			VARCHAR(100);	-- Control de Retorno en Pantalla

	-- Declaracion de constantes
	DECLARE Cadena_Vacia    	CHAR(1);		-- Constante de cadena vacia
	DECLARE Entero_Cero     	INT(11);		-- Entero cero
	DECLARE SalidaNO        	CHAR(1);		-- Salidad no
	DECLARE SalidaSI        	CHAR(1);		-- Salidad si

	SET Cadena_Vacia    		:= '';
	SET Entero_Cero     		:= 0;
	SET SalidaNO        		:= 'N';
	SET SalidaSI        		:= 'S';

ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
       SET Par_NumErr  = 999;
       SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
            'Disculpe lAS molestiAS que esto le ocASiona. Ref: SP-CRELIMITEQUITASALT');
       SET Var_Control = 'sqlException';
    END;

	SELECT  Descripcion into    Var_DescriProd
	    FROM PRODUCTOSCREDITO
	    WHERE  ProducCreditoID = Par_ProducCreditoID;

	SET Var_DescriProd  := IFNULL(Var_DescriProd, Cadena_Vacia);


	IF(Var_DescriProd = Cadena_Vacia) THEN
	    IF(Par_Salida = SalidaSI) THEN
	        SELECT '001' AS NumErr,
	               'Producto de Credito Incorrecto.' AS ErrMen,
	               'ProducCreditoID' AS control,
	                0 AS consecutivo;
	        LEAVE TerminaStore;
	  END IF;
	  IF(Par_Salida = SalidaNO) THEN
	    SET Par_NumErr := 1;
	    SET Par_ErrMen := 'Producto de Credito Incorrecto' ;
	    LEAVE TerminaStore;
	  END IF;
	END IF;

	SELECT Descripcion into Var_DescriPues
	    FROM PUESTOS
	    WHERE ClavePuestoID = Par_ClavePuestoID;

	SET Var_DescriPues  := IFNULL(Var_DescriPues, Cadena_Vacia);


	IF(Var_DescriPues = Cadena_Vacia) THEN
	    IF(Par_Salida = SalidaSI) THEN
	        SELECT '002' AS NumErr,
	               concat('El Puesto ',Par_ClavePuestoID,' es Incorrecto.') AS ErrMen,
	               'ClavePuestoID' AS control,
	                0 AS consecutivo;
	        LEAVE TerminaStore;
	  END IF;
	  IF(Par_Salida = SalidaNO) THEN
	    SET Par_NumErr := 2;
	    SET Par_ErrMen := 'Puesto Incorrecto.' ;
	    LEAVE TerminaStore;
	  END IF;
	END IF;


	IF(IFNULL(Par_LimMontoCap, Entero_Cero)) < Entero_Cero THEN
	  IF(Par_Salida = SalidaSI) THEN
	        SELECT '003' AS NumErr,
	               'Limite de Capital Incorrecto.' AS ErrMen,
	               'LimPorcenCap' AS control,
	                0 AS consecutivo;
	        LEAVE TerminaStore;
	  END IF;
	  IF(Par_Salida =SalidaNO) THEN
	    SET Par_NumErr := 3;
	    SET Par_ErrMen := 'Limite de Capital Incorrecto.' ;
	    LEAVE TerminaStore;
	  END IF;

	END IF;

	IF(IFNULL(Par_LimPorcenCap, Entero_Cero)) < Entero_Cero THEN
	  IF(Par_Salida = SalidaSI) THEN
	        SELECT '004' AS NumErr,
	               'Limite Porcentaje de Capital Incorrecto.' AS ErrMen,
	               'LimPorcenCap' AS control,
	                0 AS consecutivo;
	        LEAVE TerminaStore;
	  END IF;
	  IF(Par_Salida =SalidaNO) THEN
	    SET Par_NumErr := 4;
	    SET Par_ErrMen := 'Limite Porcentaje de Capital Incorrecto.' ;
	    LEAVE TerminaStore;
	  END IF;

	END IF;


	IF(IFNULL(Par_LimMontoIntere, Entero_Cero)) < Entero_Cero THEN
	  IF(Par_Salida = SalidaSI) THEN
	        SELECT '005' AS NumErr,
	               'Limite de Interes Incorrecto.' AS ErrMen,
	               'LimMontoIntere' AS control,
	                0 AS consecutivo;
	        LEAVE TerminaStore;
	  END IF;
	  IF(Par_Salida =SalidaNO) THEN
	    SET Par_NumErr := 5;
	    SET Par_ErrMen := 'Limite de Interes Incorrecto.' ;
	    LEAVE TerminaStore;
	  END IF;

	END IF;

	IF(IFNULL(Par_LimPorcenIntere, Entero_Cero)) < Entero_Cero THEN
	  IF(Par_Salida = SalidaSI) THEN
	        SELECT '006' AS NumErr,
	               'Limite Porcentaje de Interes Incorrecto.' AS ErrMen,
	               'LimPorcenIntere' AS control,
	                0 AS consecutivo;
	        LEAVE TerminaStore;
	  END IF;
	  IF(Par_Salida =SalidaNO) THEN
	    SET Par_NumErr := 6;
	    SET Par_ErrMen := 'Limite Porcentaje de Interes Incorrecto.' ;
	    LEAVE TerminaStore;
	  END IF;

	END IF;

	IF(IFNULL(Par_LimMontoMorato, Entero_Cero)) < Entero_Cero THEN
	  IF(Par_Salida = SalidaSI) THEN
	        SELECT '007' AS NumErr,
	               'Limite de Moratorios Incorrecto.' AS ErrMen,
	               'LimMontoMorato' AS control,
	                0 AS consecutivo;
	        LEAVE TerminaStore;
	  END IF;
	  IF(Par_Salida =SalidaNO) THEN
	    SET Par_NumErr := 7;
	    SET Par_ErrMen := 'Limite de Moratorios Incorrecto.' ;
	    LEAVE TerminaStore;
	  END IF;

	END IF;

	IF(IFNULL(Par_LimPorcenMorato, Entero_Cero)) < Entero_Cero THEN
	  IF(Par_Salida = SalidaSI) THEN
	        SELECT '008' AS NumErr,
	               'Limite Porcentaje de Moratorios Incorrecto.' AS ErrMen,
	               'LimPorcenMorato' AS control,
	                0 AS consecutivo;
	        LEAVE TerminaStore;
	  END IF;
	  IF(Par_Salida =SalidaNO) THEN
	    SET Par_NumErr := 8;
	    SET Par_ErrMen := 'Limite Porcentaje de Moratorios Incorrecto.' ;
	    LEAVE TerminaStore;
	  END IF;

	END IF;

	IF(IFNULL(Par_LimMontoAccesorios, Entero_Cero)) < Entero_Cero THEN
	  IF(Par_Salida = SalidaSI) THEN
	        SELECT '009' AS NumErr,
	               'Limite de Accesorios Incorrecto.' AS ErrMen,
	               'LimMontoAccesorios' AS control,
	                0 AS consecutivo;
	        LEAVE TerminaStore;
	  END IF;
	  IF(Par_Salida = SalidaNO) THEN
	    SET Par_NumErr := 9;
	    SET Par_ErrMen := 'Limite de Accesorios Incorrecto.' ;
	    LEAVE TerminaStore;
	  END IF;

	END IF;

	IF(IFNULL(Par_LimPorcenAccesorios, Entero_Cero)) < Entero_Cero THEN
	  IF(Par_Salida = SalidaSI) THEN
	        SELECT '010' AS NumErr,
	               'Limite Porcentaje de Accesorios Incorrecto.' AS ErrMen,
	               'LimPorcenAccesorios' AS control,
	                0 AS consecutivo;
	        LEAVE TerminaStore;
	  END IF;
	  IF(Par_Salida =SalidaNO) THEN
	    SET Par_NumErr := 10;
	    SET Par_ErrMen := 'Limite Porcentaje de Accesorios Incorrecto.' ;
	    LEAVE TerminaStore;
	  END IF;

	END IF;

	IF(IFNULL(Par_LimMontoNotasCargos, Entero_Cero)) < Entero_Cero THEN
		IF(Par_Salida = SalidaSI) THEN
			SELECT '011' AS NumErr,
					'Limite de Notas Cargos Incorrecto.' AS ErrMen,
					'LimMontoNotasCargos' AS control,
					0 AS consecutivo;
			LEAVE TerminaStore;
		END IF;

		IF(Par_Salida = SalidaNO) THEN
			SET Par_NumErr := 11;
			SET Par_ErrMen := 'Limite de Notas Cargos Incorrecto.' ;
			LEAVE TerminaStore;
		END IF;
	END IF;

	IF(IFNULL(Par_LimPorcenNotasCargos, Entero_Cero)) < Entero_Cero THEN
		IF(Par_Salida = SalidaSI) THEN
			SELECT '012' AS NumErr,
				'Limite Porcentaje de Notas Cargos Incorrecto.' AS ErrMen,
				'LimPorcenNotasCargos' AS control,
				 0 AS consecutivo;
			LEAVE TerminaStore;
		END IF;

		IF(Par_Salida =SalidaNO) THEN
			SET Par_NumErr := 12;
			SET Par_ErrMen := 'Limite Porcentaje de Notas Cargos Incorrecto.' ;
			LEAVE TerminaStore;
		END IF;
	END IF;

	IF(IFNULL(Par_NumMaxCondona, Entero_Cero)) < Entero_Cero THEN
	  IF(Par_Salida = SalidaSI) THEN
	        SELECT '013' AS NumErr,
	               'Numero Maximo de Condonaciones Incorrecto.' AS ErrMen,
	               'NumMaxCondona' AS control,
	                0 AS consecutivo;
	        LEAVE TerminaStore;
	  END IF;
	  IF(Par_Salida =SalidaNO) THEN
	    SET Par_NumErr := 13;
	    SET Par_ErrMen := 'Numero Maximo de Condonaciones Incorrecto.' ;
	    LEAVE TerminaStore;
	  END IF;
	END IF;

	SET Aud_FechaActual:= NOW();

	INSERT CRELIMITEQUITAS VALUES(
		Par_ProducCreditoID,		Par_ClavePuestoID,			Par_LimMontoCap,			Par_LimPorcenCap,
		Par_LimMontoIntere,			Par_LimPorcenIntere,		Par_LimMontoMorato,			Par_LimPorcenMorato,
		Par_LimMontoAccesorios,		Par_LimPorcenAccesorios,	Par_LimMontoNotasCargos,	Par_LimPorcenNotasCargos,
		Par_NumMaxCondona,			Aud_EmpresaID,				Aud_Usuario,				Aud_FechaActual,
		Aud_DireccionIP,			Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion);

	SET Par_NumErr 	:= Entero_Cero;
	SET Par_ErrMen	:= 'Limite Agregado Exitosamente';
	SET Var_Control := 'producCreditoID';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
	    SELECT  Par_NumErr AS NumErr,
	            Par_ErrMen AS ErrMen,
	            Var_Control AS control,
	            Entero_Cero AS consecutivo;
	END IF;

	IF(Par_Salida = SalidaNO) THEN
	        SET Par_NumErr := 0;
	        SET Par_ErrMen := "Limite Agregado Exitosamente";
	END IF;

END$$
