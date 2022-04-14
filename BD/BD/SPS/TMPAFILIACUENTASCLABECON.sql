-- SP TMPAFILIACUENTASCLABECON

DELIMITER ;

DROP PROCEDURE IF EXISTS TMPAFILIACUENTASCLABECON;

DELIMITER $$

CREATE PROCEDURE `TMPAFILIACUENTASCLABECON`(
# ==========================================================================
# --- STORE PARA LA CONSULTA DE AFILIACIONES CUENTAS CLABE PARA PROCESAR ---
# ==========================================================================
	Par_Tipo				CHAR(1),			-- Tipo Afiliacion: A = Alta B = Baja
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
	DECLARE	Var_NumAfiliacionID	BIGINT(20);		-- Numero de Afiliacion

	-- Declaracion de Constantes
	DECLARE Entero_Cero    		INT(11);
	DECLARE Cadena_Vacia   	 	CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE Con_NumAfiliacion	INT(11);

	-- Asignacion de Constantes
	SET Entero_Cero				:= 0; 				-- Entero Cero
	SET Cadena_Vacia			:= '';   			-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';  	-- Fecha Vacia
	SET Con_NumAfiliacion		:= 1;				-- Consulta Numero de Afiliacion

	-- 1.- Consulta Numero de Afiliacion
	IF(Par_NumCon = Con_NumAfiliacion)THEN
         -- Se obtiene el Numero de Folio Consecutivo
		CALL FOLIOSAPLICAACT('TMPAFILIACUENTASCLABE', Var_NumAfiliacionID);

        SELECT Var_NumAfiliacionID;
	END IF;


END TerminaStore$$