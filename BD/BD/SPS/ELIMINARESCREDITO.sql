-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ELIMINARESCREDITO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ELIMINARESCREDITO`;DELIMITER $$

CREATE PROCEDURE `ELIMINARESCREDITO`(
	Par_Fecha			datetime,


    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)
TerminaStore:BEGIN


	delete from RESCREDITOS;

	delete from RESAMORTICREDITO;

	delete from RESCREDITOSMOVS;

	delete from RESPAGCREDITO;

END TerminaStore$$