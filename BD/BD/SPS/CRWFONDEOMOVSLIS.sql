-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWFONDEOMOVSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWFONDEOMOVSLIS`;

DELIMITER $$
CREATE PROCEDURE `CRWFONDEOMOVSLIS`(
	Par_SolFondeoID		BIGINT(20),				-- Número de Solicitud de Fondeo.
	Par_NumLista		TINYINT UNSIGNED,	-- Número de Lista.
	Par_EmpresaID		INT(11),
	/* Parámetros de Auditoría. */
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,

	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

-- DECLARACIÓN DE CONSTANTES.
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Lis_Princip		INT;

-- ASIGNACIÓN DE CONSTANTES.
SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Lis_Princip			:= 1;

IF(Par_NumLista = Lis_Princip)THEN
	SELECT
		Mov.AmortizacionID,	Mov.FechaOperacion,		Mov.Descripcion,	Tip.Descripcion AS TipoMovCreID,
		Mov.NatMovimiento,	ROUND(Mov.Cantidad,2) AS Cantidad
	FROM CRWFONDEOMOVS Mov
		INNER JOIN TIPOSMOVSCRW Tip ON Mov.TipoMovCRWID = Tip.TipoMovCRWID
	WHERE Mov.SolFondeoID = Par_SolFondeoID;
END IF;


END TerminaStore$$