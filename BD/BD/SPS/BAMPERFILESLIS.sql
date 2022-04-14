-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMPERFILESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMPERFILESLIS`;DELIMITER $$

CREATE PROCEDURE `BAMPERFILESLIS`(
-- Store para listar los perfiles de usuario para banca electronica
	Par_Nombre			VARCHAR(45),			-- Parametro para mostrar lista de perfiles de BM
    Par_NumLis			TINYINT UNSIGNED,		--  Tipo de lista solicitada

    Par_EmpresaID       INT(11),				-- Auditoria
    Aud_Usuario         INT(11),				-- Auditoria
    Aud_FechaActual     DATETIME,				-- Auditoria
    Aud_DireccionIP     VARCHAR(15),			-- Auditoria
    Aud_ProgramaID      VARCHAR(50),			-- Auditoria
    Aud_Sucursal        INT(11),				-- Auditoria
    Aud_NumTransaccion  BIGINT(20)				-- Auditoria
	)
TerminaStore: BEGIN

	/* Declaracion de Constantes */

    DECLARE Lis_Nombre INT; 					--  Lista en base a nombre

    /* Asignacion de Constantes */

    SET Lis_Nombre := 1;						-- Lista en base a nombre


    IF(Par_NumLis = Lis_Nombre) THEN
        SELECT `PerfilID` AS Perfil, `NombrePerfil`
        FROM BAMPERFILES
        WHERE NombrePerfil LIKE CONCAT("%", Par_Nombre, "%")
        LIMIT 0, 15;
    END IF;



END TerminaStore$$