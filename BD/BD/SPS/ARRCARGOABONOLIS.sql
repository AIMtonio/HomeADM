-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRCARGOABONOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRCARGOABONOLIS`;DELIMITER $$

CREATE PROCEDURE `ARRCARGOABONOLIS`(
  -- STORED PROCEDURE QUE ENLISTA LOS CARGOS Y ABONOS DE UN ARRENDAMIENTO
	Par_ArrendaID		INT(11),					-- ID del arrendamiento
	Par_NumLis			TINYINT UNSIGNED,		-- Numero de lista

	Aud_EmpresaID		INT(11),				-- Parametros de Auditoria
	Aud_Usuario			INT(11),				-- Parametros de Auditoria
	Aud_FechaActual		DATETIME,				-- Parametros de Auditoria
	Aud_DireccionIP		VARCHAR(15),			-- Parametros de Auditoria
	Aud_ProgramaID 		VARCHAR(50),			-- Parametros de Auditoria
	Aud_Sucursal		INT(11),				-- Parametros de Auditoria
	Aud_NumTransaccion 	BIGINT(20)				-- Parametros de Auditoria
)
TerminaStore: Begin
	-- Declaracion de constantes
	DECLARE Entero_Cero			INT;			-- Entero cero
	DECLARE Lis_Principal		INT;			-- Lista principal
	DECLARE Decimal_Cero		DECIMAL(18,2);	-- Decimal cero
	DECLARE Cadena_Vacia		CHAR(1);		-- Cadena vacia

	-- Asignacion de constantes
	SET Entero_Cero				:= 0; 			-- Entero cero
	SET Lis_Principal			:= 1; 			-- Lista principal
	SET Decimal_Cero			:= 0.0;			-- Decimal 0.0
	SET Cadena_Vacia			:= '';			-- Cadena Vacia

	IF(Lis_Principal = Par_NumLis)THEN
		SELECT	cb.FechaMovimiento, 	us.NombreCompleto, 		cb.ArrendaAmortiID,		cb.Descripcion AS CargoDescripcion,		cb.Monto,
				con.Descripcion AS ConDescripcion,
				CASE cb.Naturaleza
					WHEN	"C"		THEN 	"CARGO"
					WHEN	"A"		THEN	"ABONO"
				END AS Naturaleza
			FROM ARRCARGOABONO AS cb
			INNER JOIN USUARIOS AS us on cb.UsuarioMovimiento = us.UsuarioID
			INNER JOIN CONCEPTOSARRENDA AS con ON cb.TipoConcepto = con.ConceptoArrendaID
			WHERE ArrendaID = Par_ArrendaID
            ORDER BY cb.CargoAbonoID DESC;
	END IF;

END TerminaStore$$