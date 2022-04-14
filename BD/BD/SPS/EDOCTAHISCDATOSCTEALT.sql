
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAHISCDATOSCTEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAHISCDATOSCTEALT`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAHISCDATOSCTEALT`(
-- SP HISTORICO DE TIMBRADO DE CTAS
	Par_Anio				INT(11),	-- AÑO
	Par_MesInicio			INT(11),	-- MES INICIO
	Par_MesFin				INT(11),	-- MES FINAL
	Par_Tipo				CHAR(1),	-- TIPO "MENSUAL O SEMESTRAL"
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
   DECLARE Var_Control          VARCHAR(50);
   DECLARE Var_NombreCte		VARCHAR(50);
   DECLARE Var_Consecutivo		INT(11);
   DECLARE Var_Periodo			INT(11);
  
-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     	
	DECLARE Fecha_Vacia     	DATE;		   	
	DECLARE Entero_Cero     	INT(1);       	
	DECLARE Decimal_Cero		DECIMAL(14,2);	
	DECLARE Salida_SI       	CHAR(1);  

  
	DECLARE Salida_NO       	CHAR(1);      	
	DECLARE Entero_Uno      	INT(11);      	
	DECLARE Cons_NO   	    	CHAR(1);      	
  		

-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0; 
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Cons_NO		          	:= 'N';
 


	ManejoErrores:BEGIN 

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-EDOCTAHISCDATOSCTEALT');
		SET Var_Control = 'SQLEXCEPTION'; 
	END;

    SET Par_Anio:=IFNULL(Par_Anio, Entero_Cero);
    SET Par_MesInicio:=IFNULL(Par_MesInicio, Entero_Cero);
    SET Par_MesFin:=IFNULL(Par_MesFin, Entero_Cero);

    IF(Par_Anio!=Entero_Cero)THEN
		SET Var_Periodo := Par_Anio;
    END IF;

    IF(Par_MesInicio!=Entero_Cero AND Par_Anio>Entero_Cero)THEN
		IF(Par_MesInicio <=9)THEN
			SET Var_Periodo := CONCAT(Var_Periodo, Entero_Cero, Par_MesInicio);
        END IF;
		IF(Par_MesInicio >=10)THEN
			SET Var_Periodo := CONCAT(Var_Periodo, Par_MesInicio);
        END IF;
    END IF;

    SET Aud_FechaActual := NOW();

	INSERT INTO EDOCTAHISCDATOSCTE
		(	Periodo,		    SucursalID,        ClienteID,				NombreComple, 			RFC,
			CFDIUUID,			CFDIFechaTimbrado,	Estatus,				CFDITotal,
			EmpresaID, 			Usuario, 			FechaActual, 			DireccionIP, 			ProgramaID,
			Sucursal, 			NumTransaccion,		ProductoCredID,			CreditoID
		)
	SELECT 	AnioMes, 			SucursalID, 			ClienteID, 			NombreComple, 			RFC,
			CFDIUUID,			CFDIFechaTimbrado,		Estatus,			CFDITotal,
			Aud_EmpresaID, 		Aud_Usuario, 			Aud_FechaActual, 	Aud_DireccionIP, 		Aud_ProgramaID,
			Aud_Sucursal, 		Aud_NumTransaccion,		ProductoCredID,		CreditoID
	FROM EDOCTADATOSCTE WHERE AnioMes = Var_Periodo;
   
   
   
	SET Par_NumErr 		:= 0;
	SET Par_ErrMen 		:= CONCAT('Historico de Timbrado por Periodo');
	SET Var_Control		:= 'sucursalID';
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