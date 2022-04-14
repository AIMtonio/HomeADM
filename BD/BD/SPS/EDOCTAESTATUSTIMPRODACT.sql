-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAESTATUSTIMPRODACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAESTATUSTIMPRODACT`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAESTATUSTIMPRODACT`(
-- SP HISTORICO DE TIMBRADO DE CTAS
	Par_Anio				INT(11),			-- AÑO
	Par_MesInicio			INT(11),			-- MES INICIO
	Par_MesFin				INT(11),			-- MES FINAL
	Par_Productos			VARCHAR(100),		-- CADENA CON LOS PRODUCTOS DE CREDITO
    Par_Semestre			INT(11),			-- SEMESTRE 1 O 2
    Par_NumAct				TINYINT UNSIGNED,	-- NUMERO DE ACTUALIZACION
   
    Par_Salida    			CHAR(1),			-- SALIDA
    INOUT Par_NumErr 		INT(11),			-- NUMERO DE ERROR
    INOUT Par_ErrMen  		VARCHAR(400),		-- MENSAJE DE ERRO
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
	DECLARE Var_Control         VARCHAR(50);
	DECLARE Var_NombreCte		VARCHAR(50);
	DECLARE Var_Consecutivo		INT(11);
	DECLARE Var_TotalReg		INT(11);
	DECLARE Var_TotalProd		INT(11);				-- NUMERO DE CLIENTES A PROCESAR CON EL CPRODUCTO
	DECLARE Var_TotalGenCadena	INT(11);				-- TOTAL DE PRODUCTOS A PROCESAR LA CADENA
	DECLARE Var_ProductoID		VARCHAR(10);			-- PRODUCTO DE CREDITO
	DECLARE Aux_i				INT(11);				-- AUXILIAR I
	DECLARE Aux_z				INT(11);				-- AUXILIAR Z
    DECLARE Var_Periodo			INT(11);				-- PERIODO
  
-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     	
	DECLARE Fecha_Vacia     	DATE;		   	
	DECLARE Entero_Cero     	INT(1);       	
	DECLARE Decimal_Cero		DECIMAL(14,2);	
	DECLARE Salida_SI       	CHAR(1);  
	DECLARE Salida_NO       	CHAR(1);      	
	DECLARE Entero_Uno      	INT(11);      	
	DECLARE Cons_NO   	    	CHAR(1);
    DECLARE Cons_SI   	    	CHAR(1);
	DECLARE Mensual      		INT(11);
    DECLARE Semestral      		INT(11);
    DECLARE Act_Principa   		INT(11);
    DECLARE Act_Semestral  		INT(11);

-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0; 
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Cons_NO		          	:= 'N';
	SET Cons_SI					:= 'S';
	SET Act_Principa			:=	1;
    SET Act_Semestral			:=	2;
	SET Mensual					:=	1;
	SET Semestral				:=	2;

	ManejoErrores:BEGIN 

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-EDOCTAESTATUSTIMPRODACT');
		SET Var_Control = 'SQLEXCEPTION'; 
	END;

    SET Par_Anio:=IFNULL(Par_Anio, Entero_Cero);
    SET Par_MesInicio:=IFNULL(Par_MesInicio, Entero_Cero);
    SET Par_MesFin:=IFNULL(Par_MesFin, Entero_Cero);
   

	SET Var_TotalReg := (SELECT COUNT(Anio)
							FROM EDOCTAESTATUSTIMPROD
                            WHERE Anio = Par_MesInicio
                            AND MesIni=Par_MesFin);

    SET Var_Periodo := CONCAT(Par_Anio, Par_MesInicio);
	SET Par_Productos := REPLACE(Par_Productos, "'", "");
    
	IF(Par_NumAct = Act_Principa)THEN
		CASE Par_MesInicio
			WHEN 1 THEN 
				UPDATE EDOCTAESTATUSTIMPROD
					SET Mes1 = Cons_SI
					WHERE Anio = Par_Anio
					AND FIND_IN_SET (ProductoCredID, Par_Productos)>0;
			WHEN 2 THEN
				UPDATE EDOCTAESTATUSTIMPROD
					SET Mes2 = Cons_SI
					WHERE Anio = Par_Anio
					AND FIND_IN_SET (ProductoCredID, Par_Productos)>0;
			WHEN 3 THEN
				UPDATE EDOCTAESTATUSTIMPROD
					SET Mes3 = Cons_SI
					WHERE Anio = Par_Anio
					AND FIND_IN_SET (ProductoCredID, Par_Productos)>0;
			WHEN 4 THEN
				UPDATE EDOCTAESTATUSTIMPROD
					SET Mes4 = Cons_SI
					WHERE Anio = Par_Anio
					AND FIND_IN_SET (ProductoCredID, Par_Productos)>0;
			WHEN 5 THEN
				UPDATE EDOCTAESTATUSTIMPROD
					SET Mes5 = Cons_SI
					WHERE Anio = Par_Anio
					AND FIND_IN_SET (ProductoCredID, Par_Productos)>0;
			WHEN 6 THEN
				UPDATE EDOCTAESTATUSTIMPROD
					SET Mes6 = Cons_SI
					WHERE Anio = Par_Anio
					AND FIND_IN_SET (ProductoCredID, Par_Productos)>0;
			WHEN 7 THEN
				UPDATE EDOCTAESTATUSTIMPROD
					SET Mes7 = Cons_SI
					WHERE Anio = Par_Anio
					AND FIND_IN_SET (ProductoCredID, Par_Productos)>0;
			WHEN 8 THEN
				UPDATE EDOCTAESTATUSTIMPROD
					SET Mes8 = Cons_SI
					WHERE Anio = Par_Anio
					AND FIND_IN_SET (ProductoCredID, Par_Productos)>0;
			WHEN 9 THEN
				UPDATE EDOCTAESTATUSTIMPROD
					SET Mes9 = Cons_SI
					WHERE Anio = Par_Anio
					AND FIND_IN_SET (ProductoCredID, Par_Productos)>0;
			WHEN 10 THEN
				UPDATE EDOCTAESTATUSTIMPROD
					SET Mes10 = Cons_SI
					WHERE Anio = Par_Anio
					AND FIND_IN_SET (ProductoCredID, Par_Productos)>0;
			WHEN 11 THEN
				UPDATE EDOCTAESTATUSTIMPROD
					SET Mes11 = Cons_SI
					WHERE Anio = Par_Anio
					AND FIND_IN_SET (ProductoCredID, Par_Productos)>0;
			WHEN 12 THEN
				UPDATE EDOCTAESTATUSTIMPROD
					SET Mes12 = Cons_SI
					WHERE Anio = Par_Anio
					AND FIND_IN_SET (ProductoCredID, Par_Productos)>0;
		END CASE;
	   
	   
		/*ACTUALIZAMOS EL ESTATUS DEL HISTORICO Y EL ESTATUS SI SE GENERO EL PDF*/          
		UPDATE EDOCTADATOSCTE DAT
		INNER JOIN EDOCTAHISCDATOSCTE HIS ON DAT.AnioMes = HIS.Periodo AND DAT.ClienteID = HIS.ClienteID AND DAT.SucursalID= HIS.SucursalID
			SET HIS.PDFGenerado	= CASE DAT.Estatus WHEN 1 THEN "S"
										   WHEN 2 THEN "D"
										   WHEN 3 THEN "D"
							  ELSE HIS.PDFGenerado  END,
				HIS.Estatus=DAT.Estatus
		WHERE HIS.ProductoCredID = Var_ProductoID
		AND HIS.PDFGenerado="N";

	END IF;

	IF(Par_NumAct = Semestral)THEN
		CASE Par_Semestre
			WHEN 1 THEN 
				UPDATE EDOCTAESTATUSTIMPROD
						SET Mes1 = Cons_SI,
							Mes2 = Cons_SI,
							Mes3 = Cons_SI,
							Mes4 = Cons_SI,
							Mes5 = Cons_SI,
							Mes6 = Cons_SI
					WHERE Anio = Par_Anio
					AND FIND_IN_SET (ProductoCredID, Par_Productos)>0;
			WHEN 2 THEN
				UPDATE EDOCTAESTATUSTIMPROD
					SET Mes7 = Cons_SI,
						Mes8 = Cons_SI,
						Mes9 = Cons_SI,
						Mes10 = Cons_SI,
						Mes11 = Cons_SI,
						Mes12 = Cons_SI
					WHERE Anio = Par_Anio
					AND FIND_IN_SET (ProductoCredID, Par_Productos)>0;
		END CASE;
	
	
		/*ACTUALIZAMOS EL ESTATUS DEL HISTORICO Y EL ESTATUS SI SE GENERO EL PDF*/          
		UPDATE EDOCTADATOSCTE DAT
		INNER JOIN EDOCTAHISCDATOSCTE HIS ON DAT.AnioMes = HIS.Periodo AND DAT.ClienteID = HIS.ClienteID AND DAT.SucursalID= HIS.SucursalID
			SET HIS.PDFGenerado	= CASE DAT.Estatus WHEN 1 THEN "S"
										   WHEN 2 THEN "D"
										   WHEN 3 THEN "D"
							  ELSE HIS.PDFGenerado  END,
				HIS.Estatus=DAT.Estatus
		WHERE HIS.ProductoCredID = Var_ProductoID;

	END IF;
            
	SET Par_NumErr 		:= 0;
	SET Par_ErrMen 		:= CONCAT('Estatus de Timbrado por Producto Modificado Exitosamente');
	SET Var_Control		:= 'sucursalID';
	SET Var_Consecutivo	:= Entero_Cero;

END ManejoErrores;
   
	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
 
	END IF;



END TerminaStore$$

