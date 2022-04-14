-- BANTIPOSCUENTASLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS BANTIPOSCUENTASLIS;

DELIMITER $$

CREATE PROCEDURE `BANTIPOSCUENTASLIS`(
-- 	STORED PROCEDURE PARA LISTAR LOS TIPOS DE CUENTAS DE LAS BANCAS
	Par_NumLis			TINYINT UNSIGNED,	-- Tipo de lista

	Par_EmpresaID		INT(11),			-- Auditoria
	Aud_Usuario			INT(11),			-- Auditoria
	Aud_FechaActual		DATETIME,			-- Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Auditoria
	Aud_Sucursal		INT(11),			-- Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena vacia
	DECLARE	Fecha_Vacia			DATE;			-- Fecha vacia
	DECLARE	Entero_Cero			INT(11);		-- Entero cero
	DECLARE	Lis_Principal 		INT(11);

	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';				-- Cadena Vacia
	SET	Fecha_Vacia	    		:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero	    		:= 0;				-- Entero Cero
	SET	Lis_Principal			:= 1;				-- Lista Principal

	IF(Par_NumLis = Lis_Principal) THEN
		SELECT	Btc.TipoCuentaID,	Tca.Descripcion	
		FROM BANTIPOSCUENTAS AS Btc
		INNER JOIN TIPOSCUENTAS Tca ON Btc.TipoCuentaID = Tca.TipoCuentaID;
	END IF;

END TerminaStore$$
