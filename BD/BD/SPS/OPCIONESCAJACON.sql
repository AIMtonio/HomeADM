-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPCIONESCAJACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPCIONESCAJACON`;DELIMITER $$

CREATE PROCEDURE `OPCIONESCAJACON`(
	-- SP PARA CONSULTAR LAS OPCIONES DE CAJA
    Par_OpcionCajaID        INT(11),
    Par_NumCon              TINYINT UNSIGNED,

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT,
    Aud_NumTransaccion      BIGINT
	)
TerminaStore: BEGIN
-- Declaracion de variables
DECLARE Con_Principal       INT;
-- Asignacion de variables
SET Con_Principal           := 1;

    IF(Par_NumCon = Con_Principal) THEN
        SELECT  OpcionCajaID,       Descripcion, EsReversa, 	ReqAutentificacion
        FROM OPCIONESCAJA
        WHERE OpcionCajaID = Par_OpcionCajaID;
    END IF;

END TerminaStore$$