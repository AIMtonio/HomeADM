DELIMITER ;
DROP PROCEDURE IF EXISTS `BANTIPOSMOVSAHOLIS`;
DELIMITER $$

CREATE PROCEDURE `BANTIPOSMOVSAHOLIS`(
	Par_NumLis					TINYINT UNSIGNED,		-- Numero de lista

	Aud_EmpresaID				INT(11),				-- Parametro de Auditoria
	Aud_Usuario					INT(11),				-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal				INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)				-- Parametro de Auditoria
)
TerminaStore: BEGIN
	DECLARE	Cadena_Vacia	CHAR(1);				-- Cadena vacia
	DECLARE	Fecha_Vacia		DATE;					-- Fecha Vacia
	DECLARE	Entero_Cero		INT(11);				-- Entero Vacio
	DECLARE	Lis_Principal 	TINYINT UNSIGNED;		-- Numero para lista principal

	
	SET	Cadena_Vacia		:= '';					-- Cadena vacia
	SET	Fecha_Vacia			:= '1900-01-01';		-- Fecha Vacia
	SET	Entero_Cero			:= 0;					-- Entero Vacio
	SET	Lis_Principal		:= 1;					-- Numero para lista principal

	IF(Par_NumLis = Lis_Principal) THEN
		SET @var_QueryListaTipoMovsAho := 'SELECT	TipoMovAhoID, FNCAPITALIZAPALABRA(Descripcion) AS Descripcion
											FROM  TIPOSMOVSAHO
											ORDER BY Descripcion ASC ';

		PREPARE sentenciaListaTiposMovsAho From @var_QueryListaTipoMovsAho;
		EXECUTE sentenciaListaTiposMovsAho;
		DEALLOCATE PREPARE sentenciaListaTiposMovsAho;
	END IF;
END TerminaStore$$