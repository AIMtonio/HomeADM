-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAFRECTIMXPRODALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAFRECTIMXPRODALT`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAFRECTIMXPRODALT`(
-- SP PARA DAR DE ALTA EL Catalogo de Frecuencias de Timbrado por Producto
    Par_FrecuenciaID		CHAR(50),    	-- FRECUENCIA
    Par_ProducCreditoID		INT(11),		-- PRODUCTO DE CREDITO
    Par_Salida    			CHAR(1),		-- SALIDA
    INOUT Par_NumErr 		INT(11),		-- NUMERO DE ERROR
    INOUT Par_ErrMen  		VARCHAR(400),	-- MENSAJE DE ERRO

-- PARAMETROS DE AUDITORIA
    Aud_EmpresaID       	INT(11),	
    Aud_Usuario         	INT(11),	
    Aud_FechaActual     	DATETIME,	
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),	
    Aud_NumTransaccion  	BIGINT(20)  
)
TerminaStore: BEGIN

-- DECALRACION DE VARIABLES   
    DECLARE Var_Consecutivo		VARCHAR(100);   
	DECLARE Var_Control         VARCHAR(100);   
    DECLARE Var_FechaSistema	DATE;
    DECLARE Var_FrecuenciaID	CHAR(1);
    DECLARE Var_ProducCreditoID	INT(11);
	DECLARE Var_Frecuencia		CHAR(1);

-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     	
	DECLARE Fecha_Vacia     	DATE;		   	
	DECLARE Entero_Cero     	INT(1);       	
	DECLARE Decimal_Cero		DECIMAL(14,2);	
	DECLARE Salida_SI       	CHAR(1);      	

	DECLARE Salida_NO       	CHAR(1);      	
	DECLARE Entero_Uno      	INT(11);      	
	DECLARE Cons_NO   	    	CHAR(1);      	
    DECLARE Grupo_Detalle		CHAR(1); 		

-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0; 
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Cons_NO		          	:= 'N';
    SET Grupo_Detalle			:= 'D';
    SET Var_FrecuenciaID		:= '';
    SET Var_Frecuencia			:= '';


	ManejoErrores:BEGIN 

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-EDOCTAFRECTIMXPRODALT');
		SET Var_Control = 'SQLEXCEPTION'; 
	END;
	
    SELECT FrecuenciaID INTO Var_Frecuencia
		FROM EDOCTAFRECTIMXPROD
        WHERE ProducCreditoID = Par_ProducCreditoID
        LIMIT 1;

	SELECT ProducCreditoID INTO Var_ProducCreditoID
		FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID = Par_ProducCreditoID;
	
    SELECT FrecuenciaID INTO Var_FrecuenciaID
		FROM CATFRECUENCIAS
		WHERE FrecuenciaID = Par_FrecuenciaID;
    SET Var_FrecuenciaID :=IFNULL(Var_FrecuenciaID, Cadena_Vacia);
    
   
    SET Var_ProducCreditoID :=IFNULL(Var_ProducCreditoID, Entero_Cero);
	SET Var_FrecuenciaID :=IFNULL(Var_FrecuenciaID,Cadena_Vacia);
    
	IF(IFNULL(Par_FrecuenciaID,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr := 01;
		SET Par_ErrMen := 'La frecuencia esta vacia.';
		SET Var_Control := 'FrecuenciaID';
		LEAVE ManejoErrores;
	END IF;
   
    IF(IFNULL(Par_FrecuenciaID,Cadena_Vacia)!=Var_FrecuenciaID)THEN
		SET Par_NumErr := 02;
		SET Par_ErrMen := 'La frecuencia esta vacia.';
		SET Var_Control := 'FrecuenciaID';
		LEAVE ManejoErrores;
	END IF;
   
	IF(IFNULL(Par_ProducCreditoID,Entero_Cero)=Entero_Cero)THEN
		SET Par_NumErr := 03;
		SET Par_ErrMen := 'Producto de credito esta vacio.';
		SET Var_Control := 'ProducCreditoID';
		LEAVE ManejoErrores;
	END IF;
   
    IF(IFNULL(Par_ProducCreditoID,Entero_Cero)!=Var_ProducCreditoID)THEN
		SET Par_NumErr := 04;
		SET Par_ErrMen := 'Producto de credito no existe.';
		SET Var_Control := 'ProducCreditoID';
		LEAVE ManejoErrores;
	END IF;
    
    IF(IFNULL(Var_Frecuencia,Cadena_Vacia)!=Cadena_Vacia and Var_Frecuencia !=Par_FrecuenciaID)THEN
		SET Par_NumErr := 03;
		SET Par_ErrMen := CONCAT('El Producto ',Par_ProducCreditoID, ' ya se Encuentra Parametrizado Para la Frecuencia ',
									CASE Var_Frecuencia WHEN "M" THEN " <b>MENSUAL</b>" 
														WHEN "E" THEN " <b>SEMESTRAL</b>" 
									ELSE Cadena_Vacia END);
		SET Var_Control := 'lproducCreditoID';
		LEAVE ManejoErrores;
	END IF;


	SET Aud_FechaActual := NOW();
	
    
	INSERT INTO EDOCTAFRECTIMXPROD(
		FrecuenciaID,		ProducCreditoID,
		EmpresaID, 			Usuario, 			FechaActual, 		DireccionIP, 			ProgramaID,
		Sucursal, 			NumTransaccion
	)VALUES(
		Par_FrecuenciaID,	Par_ProducCreditoID,
		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion
	);



	SET Par_NumErr 		:= 0;
	SET Par_ErrMen 		:= CONCAT('Frecuencias de Timbrado por Producto');
	SET Var_Control		:= 'frecuenciaID';
	SET Var_Consecutivo	:= Entero_Cero;
   
END ManejoErrores;
   
	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
 
	END IF;


END TerminaStore$$