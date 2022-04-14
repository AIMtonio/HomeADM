-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWTIPOSFONDEADORLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWTIPOSFONDEADORLIS`;
DELIMITER $$

CREATE PROCEDURE `CRWTIPOSFONDEADORLIS`(
	Par_TipoFondeadorID		INT(11),			-- Id del Tipo de Fondeador.
	Par_Descripcion			VARCHAR(100),		-- Nombre del fondeador.
	Par_NumLis				TINYINT UNSIGNED,	-- Número de lista.
	/* Parámetros de Auditoría. */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

-- Declaración de Constantes.
DECLARE Entero_Cero				INT;
DECLARE Decimal_Cero			DECIMAL(12,2);
DECLARE Cadena_Vacia			CHAR(1);
DECLARE Str_SI					CHAR(1);
DECLARE Str_NO					CHAR(1);
DECLARE Lis_Principal			INT;
DECLARE Est_Vigente				CHAR(1);

-- Asignación de constantes.
SET Entero_Cero					:=0;		-- Constante Entero Cero
SET Decimal_Cero				:=0.00;		-- Constante Decimal Cero
SET Cadena_Vacia				:= '';		-- Constante Cadena Vacia
SET Str_SI						:= 'S';		-- Constante SI
SET Str_NO						:= 'N';		-- Constante NO
SET	Lis_Principal				:= 1;		-- consulta principal
SET Est_Vigente					:= 'V';		-- Estatus Vigente.

IF(Par_NumLis = Lis_Principal) THEN
	SELECT
		TipoFondeadorID,	Descripcion,	EsobligadoSol,	PagoEnIncumple,	PorcentajeMora,
		PorcentajeComisi
	FROM CRWTIPOSFONDEADOR
	WHERE Descripcion LIKE CONCAT('%',Par_Descripcion,'%')
		AND Estatus = Est_Vigente;
END IF;

END TerminaStore$$