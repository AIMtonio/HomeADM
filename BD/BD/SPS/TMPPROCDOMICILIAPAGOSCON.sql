-- SP TMPPROCDOMICILIAPAGOSCON

DELIMITER ;

DROP PROCEDURE IF EXISTS TMPPROCDOMICILIAPAGOSCON;

DELIMITER $$

CREATE PROCEDURE `TMPPROCDOMICILIAPAGOSCON`(
# ==========================================================================
# ----- STORE PARA LA CONSULTA DE DOMICILIACION DE PAGOS PARA PROCESAR -----
# ==========================================================================
	Par_NumCon              TINYINT UNSIGNED, 	-- Numero de consulta

	Par_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP 
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de auditoria Programa 
    Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE	Var_FolioID		BIGINT(20);				-- ID Folio

	-- Declaracion de Constantes
	DECLARE Entero_Cero    		INT(11);
	DECLARE Cadena_Vacia   	 	CHAR(1);
	DECLARE	Fecha_Vacia			DATE;	
	DECLARE Con_NumFolio		INT(11);

	-- Asignacion de Constantes
	SET Entero_Cero				:= 0; 				-- Entero Cero
	SET Cadena_Vacia			:= '';   			-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';  	-- Fecha Vacia
	SET Con_NumFolio			:= 1;				-- Consulta Numero de Folios

	-- 1.- Consulta Numero de Folios
	IF(Par_NumCon = Con_NumFolio)THEN
        -- Se obtiene el Numero de Folio Consecutivo
		CALL FOLIOSAPLICAACT('TMPPROCDOMICILIAPAGOS', Var_FolioID);

        SELECT Var_FolioID;
	END IF;


END TerminaStore$$