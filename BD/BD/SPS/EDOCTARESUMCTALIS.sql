-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTARESUMCTALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTARESUMCTALIS`;DELIMITER $$

CREATE PROCEDURE `EDOCTARESUMCTALIS`(
	-- Store procedure que lista la informacion del resumen de cuentas de ahorro en los estados de cuenta de clientes nuevos en tronco principal
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
	DECLARE Var_ProductoAhorro			CHAR(1);					-- Valor indicar que se trata de un producto de ahorro
	DECLARE Var_ProductoInv				CHAR(1);					-- Valor indicar que se trata de un producto de inversion
	DECLARE Var_EntNoventaYNueve		INT(11);					-- Entero 99

	-- ASIGNACION DE CONSTANTES
	SET Lis_Principal					:= 1;						-- Consulta principal de las cuentas de ahorro y inversiones de plazo fijo por cliente
	SET Cadena_Vacia					:= '';						-- Asignacion de cadena vacia
	SET Var_ProductoAhorro				:= 'A';						-- Valor indicar que se trata de un producto de ahorro
	SET Var_ProductoInv					:= 'I';						-- Valor indicar que se trata de un producto de inversion
	SET Var_EntNoventaYNueve			:= 99;						-- Entero 99

	-- Lista del resumen de cuenta por cliente
	IF (Lis_Principal = Par_NumLis)THEN
		(SELECT			Edo.AnioMes,			Edo.SucursalID,			Edo.ClienteID,			Edo.CuentaAhoID,		Edo.MonedaID,
						Edo.MonedaDescri,		Edo.Etiqueta,			Edo.SaldoActual,		Edo.SaldoMesAnterior,	Edo.SaldoPromedio,
						Edo.Estatus,			(	SELECT SUM(Edo1.SaldoActual)
												FROM EDOCTARESUMCTA Edo1
												WHERE Edo1.ClienteID	= Edo.ClienteID
												  AND Edo1.Estatus IN ('VIGENTE','ACTIVA','BLOQUEADA','PAGADA')
											) AS TotalInvAho,			IFNULL(ordcta.Orden, Var_EntNoventaYNueve) AS OrdenProducto,
						IFNULL(ordcta.TipoProducto, Cadena_Vacia) AS TipoProducto
		FROM EDOCTARESUMCTA Edo
		INNER JOIN CUENTASAHO AS cue ON Edo.CuentaAhoID = cue.CuentaAhoID
		LEFT JOIN EDOCTAORDENPRODUCTOS AS ordcta ON cue.TipoCuentaID = ordcta.ProductoID AND ordcta.TipoProducto = Var_ProductoAhorro
		WHERE Edo.ClienteID = Par_ClienteID
		ORDER BY ordcta.TipoProducto, OrdenProducto, Edo.CuentaAhoID)
		UNION
		(SELECT			Edo.AnioMes,			Edo.SucursalID,			Edo.ClienteID,			Edo.CuentaAhoID,		Edo.MonedaID,
						Edo.MonedaDescri,		Edo.Etiqueta,			Edo.SaldoActual,		Edo.SaldoMesAnterior,	Edo.SaldoPromedio,
						Edo.Estatus,			(	SELECT SUM(Edo1.SaldoActual)
												FROM EDOCTARESUMCTA Edo1
												WHERE Edo1.ClienteID	= Edo.ClienteID
												  AND Edo1.Estatus IN ('VIGENTE','ACTIVA','BLOQUEADA','PAGADA')
											) AS TotalInvAho,			IFNULL(ordinv.Orden, Var_EntNoventaYNueve) AS OrdenProducto,
						IFNULL(ordinv.TipoProducto, Cadena_Vacia) AS TipoProducto
		FROM EDOCTARESUMCTA Edo
		INNER JOIN INVERSIONES AS inv ON Edo.CuentaAhoID = inv.InversionID
		LEFT JOIN EDOCTAORDENPRODUCTOS AS ordinv ON inv.TipoInversionID = ordinv.ProductoID AND ordinv.TipoProducto = Var_ProductoInv
		WHERE Edo.ClienteID = Par_ClienteID
		ORDER BY ordinv.TipoProducto, OrdenProducto, Edo.CuentaAhoID)
		ORDER BY TipoProducto, OrdenProducto;
	END IF;

END TerminaStore$$