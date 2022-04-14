-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOCAJEROLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATTIPOCAJEROLIS`;DELIMITER $$

CREATE PROCEDURE `CATTIPOCAJEROLIS`(
	Par_Descripcion 	VARCHAR(100),       -- Descripcion del tipo de cajero
	Par_NumLis			TINYINT UNSIGNED,   -- Numero de lista

	Aud_EmpresaID		INT,                -- Auditoria
	Aud_Usuario			INT,	            -- Auditoria
	Aud_FechaActual		DATETIME,           -- Auditoria
	Aud_DireccionIP		VARCHAR(15),        -- Auditoria
	Aud_ProgramaID		VARCHAR(50),        -- Auditoria
	Aud_Sucursal		INT,                -- Auditoria
	Aud_NumTransaccion	BIGINT              -- Auditoria
)
TerminaStore: BEGIN
-- Variables

-- Constantes
DECLARE	Cadena_Vacia	CHAR(1);    -- Cadena Vacia
DECLARE	Entero_Cero		INT;        -- Emtero cero
DECLARE	Lis_Principal	INT;        -- Lista Principal
DECLARE	EstatusActivo	CHAR(1);    -- Estatus activo

SET	Cadena_Vacia		:= '';
SET	Entero_Cero			:= 0;
SET	Lis_Principal		:= 1;

IF(Par_NumLis = Lis_Principal) THEN
	SELECT TipoCajeroID, Descripcion
	FROM CATTIPOCAJERO
	LIMIT 0, 15;
END IF;

END TerminaStore$$