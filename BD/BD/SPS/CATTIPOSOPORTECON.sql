-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOSOPORTECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATTIPOSOPORTECON`;DELIMITER $$

CREATE PROCEDURE `CATTIPOSOPORTECON`(
	-- Consulta de Tipos de Soporte
	Par_TipoSoporteID	INT(11),			-- Numero de Tipo de Soporte
    Par_NumCon          TINYINT UNSIGNED,	-- Numero de Consulta

    Par_EmpresaID       INT(11),			-- Parametro de Auditoria
    Aud_Usuario         INT(11),			-- Parametro de Auditoria
    Aud_FechaActual     DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),		-- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),		-- Parametro de Auditoria
    Aud_Sucursal        INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT(20)  		-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia    CHAR(1);
	DECLARE Fecha_Vacia     DATE;
	DECLARE Entero_Cero     INT(11);
	DECLARE Con_Principal   INT(11);

	-- Asignacion de constantes
	SET Cadena_Vacia    	:= '';				-- Cadena vacia
	SET Fecha_Vacia     	:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero     	:= 0;				-- Entero cero
	SET Con_Principal   	:= 1;				-- Consulta principal Tipos de Soporte

    -- 1.- Consulta Principal Tipos de Soporte
	IF(Par_NumCon = Con_Principal) THEN
		SELECT TipoSoporteID, Descripcion
		FROM CATTIPOSOPORTE
		WHERE TipoSoporteID  = Par_TipoSoporteID;
	END IF;

END TerminaStore$$