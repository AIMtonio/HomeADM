-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSDISPERSIONLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPTOSDISPERSIONLIS`;
DELIMITER $$

CREATE PROCEDURE `CONCEPTOSDISPERSIONLIS`(
-- ========================================================================
-- ------------- STORED DE LISTA LOS CONCEPTOS DE DISPERSIONES ------------
-- ========================================================================
	Par_Nombre		 		VARCHAR(100),		-- Nombre de Concepto de Dispersion
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista

	Par_EmpresaID			INT(11),			-- Parametros de Auditoria
	Aud_Usuario				INT(11),			-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal		 	INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion	 	BIGINT(20)			-- Parametros de Auditoria
	)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE		Cadena_Vacia	CHAR(1);			-- Constante de Cadena Vacia ''
DECLARE		Fecha_Vacia		DATE;				-- Constante Fecha Vacia
DECLARE		Entero_Cero		INT(11);			-- Constante Entero Cero
DECLARE		Lis_Principal	INT(11);			-- Lista Principal 1
DECLARE		Lis_Conceptos	INT(11);			-- Lista de Conceptos 2
DECLARE 	Est_Activo		CHAR(1);			-- Estatus Activo de Conceptos de Dispersion

-- Seteo de Constantes
SET	Cadena_Vacia			:= '';
SET	Fecha_Vacia				:= '1900-01-01';
SET	Entero_Cero				:= 0;
SET	Lis_Principal			:= 1;
SET Lis_Conceptos			:= 2;
SET Est_Activo				:= 'A';

IF(Par_NumLis = Lis_Principal) THEN

	SELECT DISTINCT CAT.ConceptoDispersionID, CAT.NombreConcepto
	    FROM CATCONCEPTOSDISPERSION CAT
	    WHERE CAT.NombreConcepto	LIKE	CONCAT("%", Par_Nombre, "%")
	    LIMIT 0, 15;

END IF;

IF(Par_NumLis = Lis_Conceptos) THEN
	SELECT DISTINCT CAT.ConceptoDispersionID, CAT.NombreConcepto
	    FROM CATCONCEPTOSDISPERSION CAT
	    WHERE CAT.Estatus = Est_Activo;
END IF;

END TerminaStore$$