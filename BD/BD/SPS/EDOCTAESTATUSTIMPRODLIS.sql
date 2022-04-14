-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAESTATUSTIMPRODLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAESTATUSTIMPRODLIS`;
DELIMITER $$


CREATE PROCEDURE `EDOCTAESTATUSTIMPRODLIS`(
-- SP DE ESTATUS DEL TIMBRADO POR PRODUCTO
	Par_Anio         			INT(12),	  		-- AÑO      
	Par_TipoLista				TINYINT UNSIGNED,	-- TIPO DE LISTA
	-- PARAMETROS DE AUDITORIA
	Aud_EmpresaID			INT(11),           
	Aud_Usuario           	INT(11),           
	Aud_FechaActual       	DATETIME,          
	Aud_DireccionIP       	VARCHAR(15),       
	Aud_ProgramaID        	VARCHAR(50),       
	Aud_Sucursal          	INT(11),           
	Aud_NumTransaccion    	BIGINT(20)     
)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE Entero_Cero				INT(11);
	DECLARE Decimal_Cero			DECIMAL(14,2);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Cons_No					CHAR(1);
	DECLARE Cons_SI					CHAR(1);
	DECLARE EstatusTimbrado			TINYINT;

	-- ASIGNACION DE CONSTANTES
	SET Entero_Cero				:= 0;			
	SET Decimal_Cero			:= 0.0;			
	SET Cadena_Vacia			:= '';			
	SET Fecha_Vacia				:= '1900-01-01';
	SET Cons_No					:= 'N';			
	SET Cons_SI					:= 'S';			
	SET EstatusTimbrado			:= 1;			

	IF(Par_TipoLista = EstatusTimbrado) THEN		               
		SELECT 	EDO.Mes1,		EDO.Mes2,	EDO.Mes3,		EDO.Mes4,							EDO.Mes5,
				EDO.Mes6,		EDO.Mes7,	EDO.Mes8,		EDO.Mes9,   						EDO.Mes10,
                EDO.Mes11,		EDO.Mes12,	EDO.Anio,		EDO.ProductoCredID as ProductoID,	CONCAT(PRO.ProducCreditoID,"-",PRO.Descripcion) AS Nombre
			FROM EDOCTAESTATUSTIMPROD EDO
            INNER JOIN PRODUCTOSCREDITO PRO ON PRO.ProducCreditoID = EDO.ProductoCredID
            WHERE EDO.Anio = Par_Anio;
           
	END IF;
   
END TerminaStore$$

