-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPRESPUESTAORDPAGOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPRESPUESTAORDPAGOCON`;
DELIMITER $$

CREATE PROCEDURE `DISPRESPUESTAORDPAGOCON`(
/* SP PARA CONSULTAR LAS CANTIDADES DE ORDENES DE PAGOS PROCESADAS SEGUN EL ESTATUS */
	Par_NombreArchivo		VARCHAR(100),	-- Especifica el tipo de consulta
	Par_TipoConsulta		INT(11),		-- Especifica el tipo de consulta
    -- Parametros de Auditoria
	Aud_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario

    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore:BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE ConPrincipal	INT(11);
	
	-- ASIGNACION DE CONSTANTES
	SET ConPrincipal		:= 1;		-- Consulta Principal
	


	IF(Par_TipoConsulta=ConPrincipal)THEN
		SELECT SUM(ContVencido) AS ContVencido,	SUM(ContCancelado) AS ContCancelado,	SUM(ContLiquidado)  AS ContLiquidado,	SUM(ContPendiente) AS ContPendiente
			FROM DISPRESPUESTAORDPAGO
			WHERE NombreArchivo=Par_NombreArchivo;

	END IF;


END TerminaStore$$