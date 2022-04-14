-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAESTATUSTIMPRODALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAESTATUSTIMPRODALT`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAESTATUSTIMPRODALT`(
-- SP HISTORICO DE TIMBRADO DE CTAS
	Par_Anio				INT(11),		-- AÑO
	Par_MesInicio			INT(11),		-- MES INICIO
	Par_MesFin				INT(11),		-- MES FINAL
	Par_Tipo				CHAR(1),		-- TIPO "MENSUAL O SEMESTRAL"
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
   DECLARE Var_TotalReg			INT(11);
  
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
						'esto le ocasiona. Ref: SP-EDOCTAESTATUSTIMPRODALT');
		SET Var_Control = 'SQLEXCEPTION'; 
	END;

    SET Par_Anio:=IFNULL(Par_Anio, Entero_Cero);
    SET Par_MesInicio:=IFNULL(Par_MesInicio, Entero_Cero);
    SET Par_MesFin:=IFNULL(Par_MesFin, Entero_Cero);
    SET Par_Tipo:=IFNULL(Par_Tipo, Cadena_Vacia);

	INSERT INTO EDOCTAESTATUSTIMPROD
		(	Anio,		    	MesIni,        		MesFin,					Frecuencia, 			ProductoCredID,
			Mes1, 				Mes2, 				Mes3, 					Mes4, 					Mes5,
			Mes6, 				Mes7, 				Mes8, 					Mes9, 					Mes10,
			Mes11, 				Mes12,
			EmpresaID, 			Usuario, 			FechaActual, 			DireccionIP, 			ProgramaID,
			Sucursal, 			NumTransaccion
		)
	SELECT 	Par_Anio, 			Par_MesInicio, 			Par_MesFin, 		Par_Tipo, 				ProducCreditoID,
			Cons_NO,			Cons_NO,				Cons_NO,			Cons_NO,				Cons_NO,
			Cons_NO,			Cons_NO,				Cons_NO,			Cons_NO,				Cons_NO,
			Cons_NO,			Cons_NO,
			Aud_EmpresaID, 		Aud_Usuario, 			Aud_FechaActual, 	Aud_DireccionIP, 		Aud_ProgramaID,
			Aud_Sucursal, 		Aud_NumTransaccion
	FROM PRODUCTOSCREDITO PRO
		LEFT OUTER JOIN EDOCTAESTATUSTIMPROD EDO ON PRO.ProducCreditoID = EDO.ProductoCredID AND EDO.Anio = Par_Anio
	WHERE EDO.ProductoCredID IS NULL;
  
   
	SET Par_NumErr 		:= 0;
	SET Par_ErrMen 		:= CONCAT('Timbrado por Producto EDOCTAESTATUSTIMPROD');
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
