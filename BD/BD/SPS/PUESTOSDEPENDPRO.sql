-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PUESTOSDEPENDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PUESTOSDEPENDPRO`;DELIMITER $$

CREATE PROCEDURE `PUESTOSDEPENDPRO`(
	Par_PuestoDependPadreID	bigint,
	Par_PuestoDependHijoID	bigint,

	Aud_EmpresaID				int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal				int,
	Aud_NumTransaccion		bigint
	)
TerminaStore: BEGIN

END$$