-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NIVELRIESGOPLDCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `NIVELRIESGOPLDCON`;DELIMITER $$

CREATE PROCEDURE `NIVELRIESGOPLDCON`(
	-- SP para consultar nivel de riesgo actual del cliente o de una operacion
    Par_ClienteID 			BIGINT(20),			-- Cliente a consultar
    Par_TipoProceso			VARCHAR(50),		-- Tipo de proceso CREDITO, CTAAHORRO, INVERSION
    Par_OperProcesoID		BIGINT(12),			-- Intrumento, operacion a evaluar
	Par_NumCon				TINYINT,			-- No. consulta 1.- Evaluacion Operacioon 2.- Riesgo Actual Cliente
	Par_EmpresaID       	INT(11),  			-- Auditoria

    Aud_Usuario         	INT(11),			-- Auditoria
    Aud_FechaActual     	DATETIME,			-- Auditoria
    Aud_DireccionIP     	VARCHAR(15),		-- Auditoria
    Aud_ProgramaID      	VARCHAR(50),		-- Auditoria
    Aud_Sucursal        	INT(11),			-- Auditoria

    Aud_NumTransaccion  	BIGINT(20) 			-- Auditoria
		)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_NumErr				INT(11);
	DECLARE Var_Errm				VARCHAR(200);
	-- Declaracion de Constantes

	DECLARE Con_OperacionRiesgo     INT; 			    -- Consulta por operacion
    DECLARE Con_RiesgoActualCliente INT; 				-- Consulta riesgo actual del cliente
	DECLARE SalidaSi				CHAR(1);

	-- Asignacion de Constantes
	SET	Con_OperacionRiesgo			:= 1;					-- Consulta por operacion
    SET Con_RiesgoActualCliente 	:= 2;					-- Consulta riesgo actual del cliente
	SET SalidaSi					:='S';					-- Salida SI

    # Llamada al SP que consulta la evaluacion del riesgo de una operacion
    IF (Par_NumCon=Con_OperacionRiesgo) THEN

   	 CALL RIESGOPLDOPERACIONCON(
    	Par_ClienteID,	Par_TipoProceso,	Par_OperProcesoID,	Con_OperacionRiesgo,	Par_EmpresaID,
    	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,Aud_NumTransaccion);
	END IF;

    #Llamada a SP que consulta el Riesgo actual del cliente
	IF (Par_NumCon=Con_RiesgoActualCliente) THEN
		CALL RIESGOPLDCTEPRO(
			Par_ClienteID,	SalidaSi,	Var_NumErr,	Var_Errm, Par_EmpresaID,
			Aud_Usuario,Aud_FechaActual,Aud_DireccionIP ,Aud_ProgramaID,Aud_Sucursal,
			Aud_NumTransaccion );

	END IF;

    END TerminaStore$$