-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLCREPROSPECTOSOL
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLCREPROSPECTOSOL`;


	Par_SolCredPID  int
	)

select SolCredProsID
from SOLCREPROSPECTO
where  SolCredProsID = Par_SolCredPID ;
END$$