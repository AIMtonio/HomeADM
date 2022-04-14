-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VERIFICAPREGUNTASSEGLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `VERIFICAPREGUNTASSEGLIS`;DELIMITER $$

CREATE PROCEDURE `VERIFICAPREGUNTASSEGLIS`(
	-- Lista de Verificacion de Preguntas de Seguridad
    Par_ClienteID		INT(11),			-- Numero de Cliente
	Par_NumLis			TINYINT UNSIGNED,	-- Numero de Lista

	Par_EmpresaID		INT(11),			-- Parametro de Auditoria
	Aud_Usuario			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal		INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Decimal_Cero		DECIMAL(12,2);
	DECLARE Lis_PreSeguridad	INT(11);

	-- Asignacion de Constantes
	SET	Cadena_Vacia		    := '';           -- Cadena vacia
	SET	Fecha_Vacia			    := '1900-01-01'; -- Fecha vacia
	SET	Entero_Cero			    := 0;            -- Entero cero
	SET	Decimal_Cero		    := 0.0;          -- Decimal cero
	SET	Lis_PreSeguridad		:= 1;			 -- Lista Preguntas Seguridad por Cliente

	-- 1.- Lista Preguntas Seguridad por Cliente
	IF(Par_NumLis = Lis_PreSeguridad) THEN
		SELECT Cat.PreguntaID,Cat.Descripcion,Pre.Respuestas
		FROM CATPREGUNTASSEG Cat
		INNER JOIN PREGUNTASSEGURIDAD Pre
		ON Pre.PreguntaID = Cat.PreguntaID
		WHERE Pre.ClienteID = Par_ClienteID;
	END IF;

END TerminaStore$$