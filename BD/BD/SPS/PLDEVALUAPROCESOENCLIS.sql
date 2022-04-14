-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDEVALUAPROCESOENCLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDEVALUAPROCESOENCLIS`;DELIMITER $$

CREATE PROCEDURE `PLDEVALUAPROCESOENCLIS`(

	-- SP Para listar las operaciones evaluadas de alto riesgo
    Par_ClienteID			BIGINT(20),			-- Cliente a consultar
    Par_TipoOperacion 		VARCHAR(50),		-- Tipo de operacion a filtrar
    Par_NumLis				TINYINT UNSIGNED,	-- Numero de lista
	Par_EmpresaID       	INT(11),  			-- Auditoria

    Aud_Usuario         	INT(11),			-- Auditoria
    Aud_FechaActual     	DATETIME,			-- Auditoria
    Aud_DireccionIP     	VARCHAR(15),		-- Auditoria
    Aud_ProgramaID      	VARCHAR(50),		-- Auditoria
    Aud_Sucursal        	INT(11),			-- Auditoria

    Aud_NumTransaccion  	BIGINT(20) 			-- Auditoria
		)
TerminaStore: BEGIN

-- Declaracion de Constantes
	DECLARE Lis_OperacionesClienteTipo	INT; 				-- Consulta las operaciones por clientes y por tipo de op.

	-- Asignacion de Constantes
	SET	Lis_OperacionesClienteTipo		:= 1;

    IF (Par_NumLis=Lis_OperacionesClienteTipo) THEN

		SELECT OperProcID AS OperProcesoID FROM  PLDEVALUAPROCESOENC
		WHERE ClienteID=Par_ClienteID AND TipoProceso=Par_TipoOperacion;

	END IF;

    END TerminaStore$$