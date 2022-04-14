-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCRESUMMOVLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTATDCRESUMMOVLIS`;DELIMITER $$

CREATE PROCEDURE `EDOCTATDCRESUMMOVLIS`(
    -- Store PROCEDURE que consulta de resumen de movimientos de tarjeta del credito

    Par_Periodo			        INT		(11),              -- Periodo de inicio a fecha de corte de una targeta de credito
    Par_DiaCorte		        INT		(11),              -- Dia del corte del un tarjeta de credito
    Par_Linea			        BIGINT	(20),              -- Linea del credito     
    Par_NumLis                  TINYINT UNSIGNED,          -- Numero de lista

    Aud_EmpresaID               INT,                       -- Parametros de auditoria
    Aud_Usuario                 INT,                       -- Parametros de auditoria
    Aud_FechaActual             DATETIME,                  -- Parametros de auditoria
    Aud_DireccionIP             VARCHAR(15),               -- Parametros de auditoria
    Aud_ProgramaID              VARCHAR(50),               -- Parametros de auditoria
		
    Aud_Sucursal                INT(11),         	       -- Parametros de auditoria
    Aud_NumTransaccion          BIGINT(20)     	           -- Parametros de auditoria
)
TerminaStore:BEGIN

    -- Declaracion de constantes
    DECLARE Lis_Principal    TINYINT UNSIGNED;

    -- Asignacion de constantes
	SET Lis_Principal        :=1;

    IF (Lis_Principal= Par_NumLis) THEN 
		SELECT Concepto, Monto, Sombreado
			FROM    EDOCTATDCRESUMMOV
			WHERE Periodo = Par_Periodo
				AND DiaCorte =  Par_DiaCorte
				AND LineaTarCredID    = Par_Linea
				ORDER BY Orden;
    END IF;

END TerminaStore$$