
-- CARCREDITOSUSPENDIDOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARCREDITOSUSPENDIDOLIS`;
DELIMITER $$


CREATE PROCEDURE `CARCREDITOSUSPENDIDOLIS`(
	Par_Descripcion		VARCHAR(50),
	Par_NumLis			TINYINT(1) UNSIGNED,
	Par_EmpresaID		INT(11),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT(20)
	)

TerminaStore: BEGIN

	DECLARE		Cadena_Vacia	CHAR(1);
	DECLARE		Fecha_Vacia		DATE;
	DECLARE		Entero_Cero		INT(11);
	DECLARE		Lis_Principal	INT(11);
    DECLARE		Estatus_R		CHAR(1);		-- Estatus Registrado.


	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET	Lis_Principal	:= 1;
    SET Estatus_R		:= 'R';

	IF(Par_NumLis = Lis_Principal) THEN
        SELECT cr.CreditoID,cl.NombreCompleto 
        FROM CREDITOS cr 
			INNER JOIN CLIENTES cl ON cr.ClienteID = cl.ClienteID
			INNER JOIN CARCREDITOSUSPENDIDO csp ON csp.CreditoID = cr.CreditoID
        WHERE cl.NombreCompleto LIKE CONCAT("%", Par_Descripcion, "%")
			AND csp.Estatus = Estatus_R
        LIMIT 0,15;
	END IF;

END TerminaStore$$