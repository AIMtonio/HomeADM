-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTANCLAJELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTANCLAJELIS`;DELIMITER $$

CREATE PROCEDURE `APORTANCLAJELIS`(
	/***SP QUE SE ENCARGA DE LISTAR APORTACIONES ANCLADAS***/
	Par_AportacionID		INT,                -- ID de la Aportacion
	Par_NombreCliente       VARCHAR(50),        -- ID del Cliente
	Par_Estatus             CHAR(1),            -- Estatus de la Aportacion
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
		SELECT Ce.AportacionID, Cli.NombreCompleto,FORMAT(Ce.Monto,2) AS Monto, Ce.FechaVencimiento, Cat.Descripcion
		FROM APORTACIONES Ce,
			CLIENTES Cli,
			TIPOSAPORTACIONES Cat
			INNER JOIN APORTANCLAJE Anc
		WHERE Ce.ClienteID      = Cli.ClienteID
		  AND Ce.Estatus        = Var_Estatus
		  AND Cat.TipoAportacionID    = Ce.TipoAportacionID
		  AND Ce.AportacionID         = Par_AportacionID
		  AND   Cli.NombreCompleto  LIKE CONCAT('%', Par_NombreCliente, '%')
		ORDER BY AportacionID LIMIT 0,15;
	END IF;

	IF(Par_NumLis = Lis_ConAnclaje)THEN
		SELECT AportacionAncID, Cli.NombreCompleto,FORMAT(Ce.Monto,2) AS Monto, Ce.FechaVencimiento, Cat.Descripcion
		FROM APORTACIONES Ce,
			CLIENTES Cli,
			TIPOSAPORTACIONES Cat
			INNER JOIN APORTANCLAJE Anc
		WHERE Ce.ClienteID      = Cli.ClienteID
		  AND Ce.Estatus IN     (Var_Estatus, Var_Registrada)
		  AND Cat.TipoAportacionID    = Ce.TipoAportacionID
		  AND Ce.AportacionID         = Anc.AportacionAncID
		  AND Cli.NombreCompleto    LIKE CONCAT('%', Par_NombreCliente, '%')
		ORDER BY AportacionID LIMIT 0,15;
	END IF;

	IF(Par_NumLis = Lis_SinAnclaje)THEN
		SELECT  AP.AportacionID,        cte.NombreCompleto, FORMAT(AP.Monto,2) AS Monto,  AP.FechaVencimiento,
			tipo.Descripcion
		FROM APORTACIONES AP
			INNER JOIN CLIENTES cte ON AP.ClienteID = cte.ClienteID AND cte.NombreCompleto LIKE CONCAT('%',Par_NombreCliente,'%')
			INNER JOIN TIPOSAPORTACIONES tipo ON AP.TipoAportacionID = tipo.TipoAportacionID
		WHERE AP.Estatus = Par_Estatus AND AP.AportacionID NOT IN(SELECT anc.AportacionAncID
																		FROM APORTANCLAJE anc
																		WHERE anc.AportacionAncID = AP.AportacionID)
		ORDER BY AP.AportacionID LIMIT 0,15;
	END IF;

END TerminaStore$$