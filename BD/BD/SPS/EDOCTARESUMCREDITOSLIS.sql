-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTARESUMCREDITOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTARESUMCREDITOSLIS`;DELIMITER $$

CREATE PROCEDURE `EDOCTARESUMCREDITOSLIS`(
	-- Store procedure que lista la informacion del resumen de creditos en los estados de cuenta de clientes nuevos en tronco principal
	Par_ClienteID						INT(11),					-- Identificador del cliente

	Par_NumLis							TINYINT UNSIGNED,			-- Numero de lista

	Par_EmpresaID						INT(11),					-- Parametro de Auditoria
	Aud_Usuario							INT(11),					-- Parametro de Auditoria
	Aud_FechaActual						DATETIME,					-- Parametro de Auditoria
	Aud_DireccionIP						VARCHAR(15),				-- Parametro de Auditoria
	Aud_ProgramaID						VARCHAR(50),				-- Parametro de Auditoria
	Aud_Sucursal						INT(11),					-- Parametro de Auditoria
	Aud_NumTransaccion					BIGINT(12)					-- Parametro de Auditoria
)
TerminaStore:BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE Lis_Principal				INT(11);					-- Consulta principal
	DECLARE Cadena_Vacia				VARCHAR(1);					-- Cadena Vacia
	DECLARE Var_ProductoCred			CHAR(1);					-- Valor indicar que se trata de un producto de credito
	DECLARE Var_EntNoventaYNueve		INT(11);					-- Entero 99

	-- ASIGNACION DE CONSTANTES
	SET Lis_Principal					:= 1;						-- Consulta principal de los creditos por cliente
	SET Cadena_Vacia					:= '';						-- Asignacion de cadena vacia
	SET Var_ProductoCred				:= 'C';						-- Valor indicar que se trata de un producto de credito
	SET Var_EntNoventaYNueve			:= 99;						-- Entero 99

	-- Lista del resumen de creditos por cliente
	IF (Lis_Principal = Par_NumLis)THEN

		SELECT			edo.Producto AS 'NombreProd',		edo.CreditoID,			edo.SaldoInsoluto,			edo.FechaLeyenda,		edo.FechaProxPago,
						edo.MontoProximoPago AS TotalPagar,	IFNULL(ord.Orden, Var_EntNoventaYNueve) AS OrdenProducto
		FROM EDOCTARESUM099CREDITOS AS edo
		INNER JOIN CREDITOS AS cred ON edo.CreditoID = cred.CreditoID
		LEFT JOIN EDOCTAORDENPRODUCTOS AS ord ON cred.ProductoCreditoID = ord.ProductoID AND ord.TipoProducto = Var_ProductoCred
		WHERE edo.ClienteID = Par_ClienteID
		ORDER BY ord.TipoProducto, OrdenProducto;
	END IF;

END TerminaStore$$