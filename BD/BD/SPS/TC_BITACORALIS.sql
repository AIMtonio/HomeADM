-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_BITACORALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_BITACORALIS`;DELIMITER $$

CREATE PROCEDURE `TC_BITACORALIS`(
-- SP PARA EL LISTADO DE LA BITACORA DE TARJETA DE CREDITO
    Par_TarjetaCredID   CHAR(16),				-- ID de la tarjeta de credito
    Par_NumLis          TINYINT UNSIGNED, 		-- Numero de la lista

    Par_EmpresaID       INT,					-- Auditoria
    Aud_Usuario         INT, 					-- Auditoria
    Aud_FechaActual     DATETIME, 				-- Auditoria
    Aud_DireccionIP     VARCHAR(15), 			-- Auditoria
    Aud_ProgramaID      VARCHAR(50), 			-- Auditoria
    Aud_Sucursal        INT, 					-- Auditoria
    Aud_NumTransaccion  BIGINT 					-- Auditoria

	)
TerminaStore: BEGIN

-- Declaracion de Variables

-- Declaracion de Constantes
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Lis_Principal   INT;


-- Asignacion de Constantes
SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Lis_Principal   := 1;

IF(Par_NumLis = Lis_Principal) THEN
    SELECT DATE(Fecha) AS fecha, 	Est.Descripcion,		Cat.Descripcion , 	DescripAdicio
	  FROM BITACORATARCRED AS Bita
        LEFT JOIN CATALCANBLOQTAR AS Cat ON Bita.MotivoBloqID=Cat.MotCanBloId
        LEFT JOIN ESTATUSTD AS Est ON Est.EstatusID=Bita.TipoEvenTDID
	 WHERE Bita.TarjetaCredID=Par_TarjetaCredID;
END IF;


END$$