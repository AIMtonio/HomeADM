-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCTIMBRADOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTATDCTIMBRADOLIS`;DELIMITER $$

CREATE PROCEDURE `EDOCTATDCTIMBRADOLIS`(
    -- Storer PROCEDURE para realizar consulta de timbrado en la linea de targeta del credito de un cliente

    Par_NumLis			       TINYINT UNSIGNED,	 -- Numero de lista

    Aud_EmpresaID		       INT,                  -- Parametro de Auditoria
	Aud_Usuario			       INT,                  -- Parametro de Auditoria
	Aud_FechaActual		       DATETIME,             -- Parametro de Auditoria
	Aud_DireccionIP		       VARCHAR	(15),        -- Parametro de Auditoria
	Aud_ProgramaID		       VARCHAR	(50),        -- Parametro de Auditoria
	Aud_Sucursal		       INT,                  -- Parametro de Auditoria
	Aud_NumTransaccion	       BIGINT	(20)         -- Parametro de Auditoria

)
TerminaStore: BEGIN
    -- Declaracion de Constantes
	DECLARE	Cadena_Vacia	   CHAR(1);	             -- Cadena Vacia
	DECLARE	Fecha_Vacia		   DATE;		         -- Fecha Vacia
	DECLARE	Entero_Cero		   INT;		             -- Entero Cero
    DECLARE Lis_Principal	   INT;		             -- Lista Principal

    -- Asignacion de Constantes
	SET	Cadena_Vacia	      := '';			     -- Entero cero
	SET Fecha_Vacia		      := '1900-01-01';       -- Asignacion de fecha vacia
	SET Entero_Cero		      := 0;			         -- Entero_Cero
    SET Lis_Principal	      := 1;			         -- Lista principal

	IF(Par_NumLis = Lis_Principal) THEN
		SELECT	CFDIUUID 		  AS FOLIOEDOCTA,    CFDINoCertSAT,
				CFDIFechaTimbrado AS CFDIFechaCertifica,    CFDIFechaEmision,    CFDINoCertEmisor,
				CFDISelloCFD,        CFDISelloSAT,		CFDICadenaOrig
		FROM    EDOCTATDCTIMBRADO;
	END IF;
END TerminaStore$$