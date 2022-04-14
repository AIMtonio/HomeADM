DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2PRODUCTOSALT`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2PRODUCTOSALT`(
     -- SP que genera informacion de los productos para el Estado Cuenta
	Par_Salida			CHAR(1),		-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),

    -- Parametros de Auditoria
	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore: BEGIN

    DECLARE Entero_Uno              	INT(11);
    DECLARE Var_Contador            	INT(11);
	DECLARE Var_ContadorLimit          	INT(11);
    DECLARE Var_ContadorProduc      	INT(11); 
    DECLARE Var_TipoProductoCre        	INT(11);
	DECLARE Var_TipoProductoAho        	INT(11);
	DECLARE Var_TipoProductoInv       	INT(11);
	DECLARE Var_TipoProductoCed        	INT(11);
    DECLARE Var_DescripcionProAho    	VARCHAR(100);
	DECLARE Var_DescripcionProCre	 	VARCHAR(100);  
	DECLARE Var_DescripcionInv		 	VARCHAR(100);  
	DECLARE Var_DescripcionCedes		VARCHAR(100);  
    DECLARE Var_EmpresaID           	INT(11);
    DECLARE Var_Usuario             	INT(11);
    DECLARE Var_FechaActual         	DATETIME;
    DECLARE Var_DireccionIP         	VARCHAR(15);
    DECLARE Var_ProgramaID          	VARCHAR(50);
    DECLARE Var_Sucursal            	INT(11);      
    DECLARE Var_NumTransaccion      	BIGINT(20);
    DECLARE Var_ProductoID    	 		INT(11);
	DECLARE Var_ProductoAhoID  	 		INT(11);
	DECLARE Var_ProductoInvID  	 		INT(11);
	DECLARE Var_ProductoCedesID	 		INT(11);

    DECLARE Var_SucursalMenor       	INT(11);
    DECLARE Var_SalidaSI            	CHAR(1);
    DECLARE Var_SalidaNO            	CHAR(1);

    -- DECLARACION DE VARIABLES
	DECLARE Var_FechaSis		    DATE;
	DECLARE Var_FolioProceso	    BIGINT(20);
	DECLARE Var_AnioMes			    INT(11);
	DECLARE Var_Control			    VARCHAR(50);
	DECLARE Var_FecIniMes		    DATE;						-- Fecha inicial del Periodo a procesar
	DECLARE Var_FecFinMes		    DATE;						-- Fecha final del Periodo a Procear
    DECLARE Constante_Si		    CHAR(1);
    DECLARE Entero_Cero			    INT(11);

    SET	Entero_Uno		            := 1;

    SET Var_EmpresaID               := 1;
    SET Var_Usuario                 := 1;  
    SET Var_DireccionIP             := '127.0.0.0';
    SET Var_ProgramaID              := 'MYSQL';
    SET Var_Sucursal                := 100;
    SET Var_NumTransaccion          := 0;

	SET Var_TipoProductoCre        	:= 4;
	SET Var_TipoProductoAho        	:= 1;
	SET Var_TipoProductoInv       	:= 3;
	SET Var_TipoProductoCed        	:= 2;

	SET Var_DescripcionProCre    	:= 'PRODUCTO DE CREDITO';
	SET Var_DescripcionProAho	 	:= 'PRODUCTO DE AHORRO';
	SET Var_DescripcionInv		 	:= 'PRODUCTO INVERSION';  
	SET Var_DescripcionCedes		:= 'PRODUCTO CEDES'; 

    SET Var_Contador                 =0;
	SET Var_ContadorLimit			 = 0;
    SET Var_SalidaSi                := 'S';
    SET Var_SalidaNo                := 'N';
    SET Constante_Si		        := 'S';
    SET Entero_Cero			        := 0;

    ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAV2PRODUCTOSALT');
			SET Var_Control	= 'sqlException';
		END;

    SELECT	MesProceso,  FechaInicio, 	FechaFin,  		FolioProceso	INTO	Var_AnioMes, Var_FecIniMes, Var_FecFinMes, 	Var_FolioProceso
		FROM	EDOCTAV2PARAMS
		LIMIT	1;               

    SELECT FechaSistema INTO Var_FechaSis FROM PARAMETROSSIS;
    SELECT COUNT(*) INTO  Var_ContadorProduc FROM PRODUCTOSCREDITO p ;

    DELETE FROM EDOCTAV2PRODUCTOS;

    WHILE (Var_Contador < Var_ContadorProduc) DO 

		SELECT ProducCreditoID INTO Var_ProductoID FROM PRODUCTOSCREDITO WHERE ProducCreditoID NOT IN (SELECT ProductoID FROM EDOCTAV2PRODUCTOS WHERE TipoProducto = 4)
			ORDER BY ProducCreditoID LIMIT Var_Contador, Entero_Uno;
        
        INSERT INTO EDOCTAV2PRODUCTOS( EdoCtaV2ProductoID,      ProductoID,		     TipoProducto,	            Descripcion,	     	EmpresaID,
        							   Usuario,				    FechaActual,	     DireccionIP,	            ProgramaID,		     	Sucursal,
                                       NumTransaccion)
                                VALUES (Var_Contador,         	Var_ProductoID,		 Var_TipoProductoCre,       Var_DescripcionProCre,  Aud_EmpresaID,
                                        Aud_Usuario,            Var_FechaSis,     	 Aud_DireccionIP,           Aud_ProgramaID,      	Aud_Sucursal, 
                                        Aud_NumTransaccion);
                                          
    SET Var_Contador = Var_Contador + 1;
    END WHILE;

	SELECT COUNT(*) INTO  Var_ContadorProduc FROM TIPOSCUENTAS p ;
	SET Var_ContadorLimit			 = 0;
	WHILE (Var_ContadorLimit < Var_ContadorProduc) DO 
		SELECT TipoCuentaID INTO Var_ProductoAhoID FROM TIPOSCUENTAS WHERE TipoCuentaID NOT IN (SELECT ProductoID FROM EDOCTAV2PRODUCTOS WHERE TipoProducto = 1)
			ORDER BY TipoCuentaID LIMIT Entero_Cero, Entero_Uno;

		INSERT INTO EDOCTAV2PRODUCTOS( EdoCtaV2ProductoID,      ProductoID,		     TipoProducto,	            Descripcion,	     	EmpresaID,
        							   Usuario,				    FechaActual,	     DireccionIP,	            ProgramaID,		     	Sucursal,
                                       NumTransaccion)
                                VALUES (Var_Contador,         	Var_ProductoAhoID,   Var_TipoProductoAho,       Var_DescripcionProAho,  Aud_EmpresaID,
                                        Aud_Usuario,            Var_FechaSis,     	 Aud_DireccionIP,           Aud_ProgramaID,      	Aud_Sucursal, 
                                        Aud_NumTransaccion);

    SET Var_ContadorLimit = Var_ContadorLimit + 1;
	SET Var_Contador = Var_Contador + 1;
    END WHILE;

	SELECT COUNT(*) INTO  Var_ContadorProduc FROM CATINVERSION p ;
	SET Var_ContadorLimit			 = 0;
	WHILE (Var_ContadorLimit < Var_ContadorProduc) DO 
	
		SELECT TipoInversionID INTO Var_ProductoInvID FROM CATINVERSION WHERE TIPOINVERSIONID NOT IN (SELECT ProductoID FROM EDOCTAV2PRODUCTOS WHERE TipoProducto = 3)
			ORDER BY TipoInversionID LIMIT Entero_Cero, Entero_Uno;

		INSERT INTO EDOCTAV2PRODUCTOS( EdoCtaV2ProductoID,      ProductoID,		     TipoProducto,	            Descripcion,	     	EmpresaID,
        							   Usuario,				    FechaActual,	     DireccionIP,	            ProgramaID,		     	Sucursal,
                                       NumTransaccion)
                                VALUES (Var_Contador,         	Var_ProductoInvID,   Var_TipoProductoInv,       Var_DescripcionInv,  	Aud_EmpresaID,
                                        Aud_Usuario,            Var_FechaSis,     	 Aud_DireccionIP,           Aud_ProgramaID,      	Aud_Sucursal, 
                                        Aud_NumTransaccion);	
              
    SET Var_ContadorLimit = Var_ContadorLimit + 1;
	SET Var_Contador = Var_Contador + 1;
    END WHILE;

	SELECT COUNT(*) INTO  Var_ContadorProduc FROM TIPOSCEDES p ;
	
	SET Var_ContadorLimit			 = 0;
	WHILE (Var_ContadorLimit < Var_ContadorProduc) DO 
		
		SELECT TipoCedeID INTO Var_ProductoCedesID FROM TIPOSCEDES WHERE TipoCedeID NOT IN (SELECT ProductoID FROM EDOCTAV2PRODUCTOS WHERE TipoProducto = 2)
			ORDER BY TipoCedeID LIMIT Entero_Cero, Entero_Uno;

		INSERT INTO EDOCTAV2PRODUCTOS( EdoCtaV2ProductoID,      ProductoID,		     TipoProducto,	            Descripcion,	     	EmpresaID,
        							   Usuario,				    FechaActual,	     DireccionIP,	            ProgramaID,		     	Sucursal,
                                       NumTransaccion)
                                VALUES (Var_Contador,         	Var_ProductoCedesID, Var_TipoProductoCed,       Var_DescripcionCedes,   Aud_EmpresaID,
                                        Aud_Usuario,            Var_FechaSis,     	 Aud_DireccionIP,           Aud_ProgramaID,      	Aud_Sucursal, 
                                        Aud_NumTransaccion);																						
                       
    SET Var_ContadorLimit = Var_ContadorLimit + 1;
	SET Var_Contador = Var_Contador + 1;
    END WHILE;

     SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Datos de los productos de credito del Cliente Terminado exitosamente con Folio: ', CAST(Var_FolioProceso AS CHAR));
		SET Var_Control	:= 'EDOCTAV2PRODUCTOSALT';
    END ManejoErrores;

	IF (Par_Salida = Constante_Si) THEN
		SELECT	Par_NumErr			AS NumErr,
				Par_ErrMen			AS ErrMen,
				Var_FolioProceso	AS control;
	END IF;

END TerminaStore$$