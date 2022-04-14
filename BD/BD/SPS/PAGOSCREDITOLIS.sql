-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOSCREDITOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOSCREDITOLIS`;DELIMITER $$

CREATE PROCEDURE `PAGOSCREDITOLIS`(
-- SP QUE DEVUELVE LOS PAGOS QUE HA TENIDO UN CREDITO ACTIVO DE ACUERDO A UN CREDITO PASIVO
	Par_NombCliente				VARCHAR(250),		-- Nombre del Cliente
    Par_CreditoFondeoID			BIGINT(20),			-- Numero de Credito Pasivo
	Par_NumLis					TINYINT UNSIGNED,	-- Numero de Lista
	Par_EmpresaID				INT(11),			-- Numero de Empresa

	-- Parametros de Auditoria
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(12),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
    DECLARE Var_EsContingente	CHAR(1);

	-- Declaracion de Constantes
    DECLARE Cons_NO				CHAR(1);	-- Constante: NO
	DECLARE Cons_SI				CHAR(1);	-- Constante: SI
	DECLARE Lis_PagCredActivos	INT(11);	-- Lista de los pagos han recibido los creditos

	-- Asignacion de Constantes
	SET Cons_SI					:= 'S';		-- Constante SI
    SET Cons_NO					:= 'N';		-- Constante NO
	SET Lis_PagCredActivos		:= 62;	-- Lista de los creditos que han recibido pagos.



    SET Var_EsContingente := (SELECT EsContingente FROM CREDITOFONDEO WHERE CreditoFondeoID = Par_CreditoFondeoID);
    SET Var_EsContingente := IFNULL(Var_EsContingente, Cons_NO);

	-- Lista de los Pagos que han recibido los Creditos Activos
	IF(Par_NumLis = Lis_PagCredActivos) THEN

		IF(Var_EsContingente = Cons_NO) THEN
			SELECT Det.CreditoID, Det.FechaPago, SUM(MontoTotPago) AS TotalPagado, MAX(Transaccion) AS Transaccion
			 FROM DETALLEPAGCRE Det
			 INNER JOIN CREDITOS Cre
			 ON Det.CreditoID = Cre.CreditoID
			 INNER JOIN CLIENTES Cl
			 ON Cre.ClienteID = Cl.ClienteID
			 INNER JOIN RELCREDPASIVOAGRO Rel
			 ON Cre.CreditoID = Rel.CreditoID
			 WHERE Cre.EsAgropecuario  = Cons_SI
			 AND Cl.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
			 AND Rel.CreditoFondeoID = Par_CreditoFondeoID
			 GROUP BY Det.CreditoID, Det.FechaPago, Det.NumTransaccion;

		ELSE
			SELECT Det.CreditoID, Det.FechaPago, SUM(MontoTotPago) AS TotalPagado,	MAX(Transaccion) AS Transaccion
			 FROM DETALLEPAGCRECONT Det
			 INNER JOIN CREDITOSCONT Cre
			 ON Det.CreditoID = Cre.CreditoID
			 INNER JOIN CLIENTES Cl
			 ON Cre.ClienteID = Cl.ClienteID
			 WHERE Cre.CreditoFondeoID = Par_CreditoFondeoID
             AND Cl.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
			 AND Cre.CreditoFondeoID = Par_CreditoFondeoID
			 GROUP BY Det.CreditoID, Det.FechaPago, Det.NumTransaccion;

		END IF;

    END IF;

END TerminaStore$$