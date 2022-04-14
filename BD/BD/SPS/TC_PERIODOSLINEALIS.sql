-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_PERIODOSLINEALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_PERIODOSLINEALIS`;DELIMITER $$

CREATE PROCEDURE `TC_PERIODOSLINEALIS`(
#SP PARA LISTAR LA FEHCA DE CORTE POR LINEA DE TARJETA
	Par_LineaTarCredID  INT(11),			-- Parametro de Linea de tarjeta Credito ID
    Par_NumLis          TINYINT UNSIGNED,	-- Parametro de Numero de Lista

    Par_EmpresaID       INT(11),			-- Parametro de Auditoria
    Aud_Usuario         INT(11),			-- Parametro de Auditoria
    Aud_FechaActual     DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),		-- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),		-- Parametro de Auditoria
    Aud_Sucursal        INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN

-- Declaracion de Constantes

DECLARE Cadena_Vacia        	CHAR(1);
DECLARE Fecha_Vacia         	DATE;
DECLARE Entero_Cero				INT(11);
DECLARE Lis_Principal       	INT(11);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';              -- Cadena Vacia
SET Fecha_Vacia			:= '1900-01-01';    -- Fecha Vacia
SET Entero_Cero			:= 0;               -- Entero Cero
SET Lis_Principal		:= 1;               -- Tipo de Lista Principal

    IF(Par_NumLis = Lis_Principal) THEN
		SELECT YEAR(FechaSistema) AS FechaCorte FROM PARAMETROSSIS
        UNION
        SELECT DISTINCT YEAR(FechaCorte) AS FechaCorte
            FROM TC_PERIODOSLINEA
            WHERE LineaTarCredID = Par_LineaTarCredID;
    END IF;
END TerminaStore$$