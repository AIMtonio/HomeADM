-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMIMGANTIPHISHINGLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMIMGANTIPHISHINGLIS`;DELIMITER $$

CREATE PROCEDURE `BAMIMGANTIPHISHINGLIS`(
-- Store para listar el catalogo de imagnes antiphishing
    Par_NumLis			TINYINT UNSIGNED,			-- Numero de lista que se ejecutara

    Par_EmpresaID       INT(11),					-- Auditoria
    Aud_Usuario         INT(11),					-- Auditoria
    Aud_FechaActual     DATETIME,					-- Auditoria
    Aud_DireccionIP     VARCHAR(15),				-- Auditoria
    Aud_ProgramaID      VARCHAR(50),				-- Auditoria
    Aud_Sucursal        INT(11),					-- Auditoria
    Aud_NumTransaccion  BIGINT(20)					-- Auditoria
	)
TerminaStore: BEGIN
    -- Declaracion de Constantes
    DECLARE Lis_Principal INT;						-- Lista  Principal
    DECLARE Est_Activo	  CHAR(1); 					-- Estado Activo
    -- Asignacion de Constantes
    SET Lis_Principal := 1;    						-- Lista principal
    SET Est_Activo	  := 'A';						-- Estatus activo

    IF(Par_NumLis = Lis_Principal) THEN
        SELECT ImagenPhishingID, ImagenBinaria, Descripcion,Estatus
        FROM BAMIMGANTIPHISHING WHERE Estatus=Est_Activo LIMIT 15;
    END IF;

END TerminaStore$$