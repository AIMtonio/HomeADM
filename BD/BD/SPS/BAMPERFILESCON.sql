-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMPERFILESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMPERFILESCON`;DELIMITER $$

CREATE PROCEDURE `BAMPERFILESCON`(

-- Store para consultar un perfil de usario de banca electronica
	Par_PerfilID			BIGINT(20),			-- ID Del perfil que se desea consultar
	Par_NumCon				TINYINT UNSIGNED,	-- Tipo de consulta a ejecutar
	Par_EmpresaID       	INT(11),			-- Auditoria
    Aud_Usuario         	INT(11),			-- Auditoria
    Aud_FechaActual     	DATETIME,			-- Auditoria
    Aud_DireccionIP     	VARCHAR(15),		-- Auditoria
    Aud_ProgramaID      	VARCHAR(50),		-- Auditoria
    Aud_Sucursal        	INT(11),			-- Auditoria
    Aud_NumTransaccion  	BIGINT(20)			-- Auditoria
	)
TerminaStore: BEGIN

-- Declaracion de Constantes
	DECLARE Con_Principal	INT;			 -- Consulta pricipal

-- Asignacion de Constantes
	SET	Con_Principal		:= 1;			 -- Consulta principal

	IF (Par_NumCon=Con_Principal) THEN
	SELECT PerfilID,		NombrePerfil,	Descripcion,	AccesoConToken,	TransacConToken,
		   CostoPrimeraVez,	CostoMensual
	FROM BAMPERFILES
	WHERE PerfilID 		= 	Par_PerfilID;

END IF;
END TerminaStore$$