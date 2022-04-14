-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATPLDDESTINORECLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATPLDDESTINORECLIS`;DELIMITER $$

CREATE PROCEDURE `CATPLDDESTINORECLIS`(
/*SP que Lista el Catalogo de Destino de los Recursos.*/
	Par_NumLis						TINYINT UNSIGNED,			# Número de Lista

	Par_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion 				BIGINT(20)
	)
TerminaStore: BEGIN

-- Declaracion de Constantes,
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Entero_Cero			INT;
DECLARE Lis_Principal		INT;

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena Vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET Lis_Principal		:= 2;				-- Tipo de Lista Principal Muestra todos los archivos Adjuntos

IF(Par_NumLis = Lis_Principal) THEN
	SELECT
		CatDestinoRecID,	Descripcion,	NivelRiesgo
		FROM CATPLDDESTINOREC;
END IF;

END TerminaStore$$