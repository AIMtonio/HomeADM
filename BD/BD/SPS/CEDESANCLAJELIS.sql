-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDESANCLAJELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDESANCLAJELIS`;DELIMITER $$

CREATE PROCEDURE `CEDESANCLAJELIS`(
    /***SP QUE SE ENCARGA DE LISTAR CEDES ANCLADAS***/
    Par_CedeID              INT,                -- ID de la Cede
    Par_NombreCliente       VARCHAR(50),        -- ID del Cliente
    Par_Estatus             CHAR(1),            -- Estatus de la CEDE
    Par_NumLis              TINYINT UNSIGNED,   -- Numero de lista

    Par_EmpresaID           INT,                -- Auditoria
    Par_UsuarioID           INT,                -- Auditoria
    Par_Fecha               DATE,               -- Auditoria
    Par_DireccionIP         VARCHAR(15),        -- Auditoria
    Par_ProgramaID          VARCHAR(50),        -- Auditoria
    Par_Sucursal            INT,                -- Auditoria
    Par_NumeroTransaccion   BIGINT              -- Auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE Lis_Principal       INT;
	DECLARE Lis_SinAnclaje      INT;
	DECLARE Lis_ConAnclaje      INT;
	DECLARE Var_Estatus         CHAR(1);
	DECLARE Var_Registrada      CHAR(1);

	-- ASIGNACION DE CONSTANTES
	SET Lis_Principal   := 1;               -- Lista Principal
	SET Lis_ConAnclaje  := 2;               -- Lista Con Anclaje
	SET Lis_SinAnclaje  := 3;               -- Lista Sin Anclaje
	SET Var_Estatus     := 'N';             -- Valor Estatus Vigente
	SET Var_Registrada  := 'A';             -- Valor Estatus Registrada

	IF(Par_NumLis = Lis_Principal)THEN
		SELECT Ce.CedeID, Cli.NombreCompleto,FORMAT(Ce.Monto,2) AS Monto, Ce.FechaVencimiento, Cat.Descripcion
		FROM CEDES Ce,
			CLIENTES Cli,
			TIPOSCEDES Cat
			INNER JOIN CEDESANCLAJE Anc
		WHERE Ce.ClienteID      = Cli.ClienteID
		  AND Ce.Estatus        = Var_Estatus
		  AND Cat.TipoCedeID    = Ce.TipoCedeID
		  AND Ce.CedeID         = Par_CedeID
		  AND   Cli.NombreCompleto  LIKE CONCAT('%', Par_NombreCliente, '%')
		ORDER BY CedeID LIMIT 0,15;
	END IF;

	IF(Par_NumLis = Lis_ConAnclaje)THEN
		SELECT CedeAncID, Cli.NombreCompleto,FORMAT(Ce.Monto,2) AS Monto, Ce.FechaVencimiento, Cat.Descripcion
		FROM CEDES Ce,
			CLIENTES Cli,
			TIPOSCEDES Cat
			INNER JOIN CEDESANCLAJE Anc
		WHERE Ce.ClienteID      = Cli.ClienteID
		  AND Ce.Estatus IN     (Var_Estatus, Var_Registrada)
		  AND Cat.TipoCedeID    = Ce.TipoCedeID
		  AND Ce.CedeID         = Anc.CedeAncID
		  AND Cli.NombreCompleto    LIKE CONCAT('%', Par_NombreCliente, '%')
		ORDER BY CedeID LIMIT 0,15;
	END IF;

	IF(Par_NumLis = Lis_SinAnclaje)THEN
		SELECT  cede.CedeID,        cte.NombreCompleto, FORMAT(cede.Monto,2) AS Monto,  cede.FechaVencimiento,
			tipo.Descripcion
		FROM CEDES cede
			INNER JOIN CLIENTES cte ON cede.ClienteID = cte.ClienteID AND cte.NombreCompleto LIKE CONCAT('%',Par_NombreCliente,'%')
			INNER JOIN TIPOSCEDES tipo ON cede.TipoCedeID = tipo.TipoCedeID
		WHERE cede.Estatus = Par_Estatus AND cede.CedeID NOT IN(SELECT anc.CedeAncID
																		FROM CEDESANCLAJE anc
																		WHERE anc.CedeAncID = cede.CedeID)
		ORDER BY cede.CedeID LIMIT 0,15;
	END IF;

END TerminaStore$$