-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESCREDITOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `RESCREDITOSLIS`;DELIMITER $$

CREATE PROCEDURE `RESCREDITOSLIS`(
	Par_NombCliente		VARCHAR(20),
	Par_CreditoID		BIGINT(12),
	Par_NumLis			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)

	)
TerminaStore:BEGIN
-- Declaracion de Constantes
	DECLARE List_CrediosPagados	INT;

-- Asignacion de Constantes
SET List_CrediosPagados		:=1;

-- 14 Lista de creditos Vigentes y Pagados
IF(Par_NumLis = List_CrediosPagados) THEN
	SELECT 	cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
			Pro.Descripcion
		FROM	RESCREDITOS cr ,
				CLIENTES c,
				PRODUCTOSCREDITO Pro
		WHERE cr.ClienteID=c.ClienteID
			AND ( c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%"))
			AND	cr.ProductoCreditoID = Pro.ProducCreditoID
			GROUP BY cr.CreditoID,		c.NombreCompleto, 	cr.Estatus,
					 cr.FechaInicio, 	cr.FechaVencimien,	Pro.Descripcion
		LIMIT 0, 15;
END IF;



END TerminaStore$$