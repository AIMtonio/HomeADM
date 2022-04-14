-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ELIMINARESCREDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ELIMINARESCREDPRO`;

DELIMITER $$
CREATE PROCEDURE `ELIMINARESCREDPRO`(
	# ====================================================================
	# -------SP ENCARGADO DE ELIMINAR LAS TABLAS DE RESPALDO--------
	# ====================================================================
	Par_Fecha			DATE, 			-- Fecha De Operacion

	Par_EmpresaID       INT(11),		-- Parametro de Auditoria
	Aud_Usuario         INT(11),		-- Parametro de Auditoria
	Aud_FechaActual     DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP     VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID      VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal        INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion  BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore:BEGIN

	-- Eliminamos la tabla de Respaldo de Creditos
	TRUNCATE TABLE RESCREDITOS;
	--  Eliminamos la tabla de respaldo de las amortizaciones
	TRUNCATE TABLE RESAMORTICREDITO;
	-- Eliminamos la tabla de Respaldo de los movimientos de creditos
	TRUNCATE TABLE RESCREDITOSMOVS;
	-- Eliminamos la tabla de respaldo de creditos pagados
	TRUNCATE TABLE RESPAGCREDITO;
	-- Eliminamos la tabla de respaldo de Inversiones dejadas como GL
	TRUNCATE TABLE RESCREDITOINVGAR;
	-- Eliminamos la tabla de respaldo de Creditos Contingentes
	TRUNCATE TABLE RESCREDITOSCONT;
	--  Eliminamos la tabla de respaldo de las amortizaciones contingentes
	TRUNCATE TABLE RESAMORTICONT;
	-- Eliminamos la tabla de respaldo de Creditos Contingentes pagados
	TRUNCATE TABLE RESPAGCREDITOCONT;
	-- Eliminamos la tabla de Respaldo de los movimientos de creditos contingentes
	TRUNCATE TABLE RESCREDITOSCONTMOVS;
	-- Eliminamos la tabla de Respaldo de los detalles de accesorios
	TRUNCATE TABLE RESDETACCESORIOS;

END TerminaStore$$