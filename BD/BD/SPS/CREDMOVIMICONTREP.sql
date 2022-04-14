-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDMOVIMICONTREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDMOVIMICONTREP`;

DELIMITER $$
CREATE PROCEDURE `CREDMOVIMICONTREP`(
	-- Reporte de Movimientos de Creditos Contigente
	-- Modulo: Cartera Agro

	Par_CreditoID		BIGINT(12),		-- Numero de Credito
	Par_FechaInicial	DATE,			-- Fecha Inicial del Reporte
	Par_FechaFin		DATE,			-- Fecha Fin del Reporte

	Par_EmpresaID		INT(11),		-- Parametro de Auditoria Empresa ID
	Aud_Usuario			INT(11),		-- Parametro de Auditoria Usuarios ID
	Aud_FechaActual		DATETIME,		-- Parametro de Auditoria Fecha Actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de Auditoria DireccionIP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de Auditoria Programa ID
	Aud_Sucursal		INT(11),		-- Parametro de Auditoria Sucursal ID
	Aud_NumTransaccion	BIGINT(11)		-- Parametro de Auditoria Numero Transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaSistema	DATE;		-- Fecha del Sistema

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);	-- Constante Cadena Vacia
	DECLARE Fecha_Vacia			DATE;		-- Constante Fecha Vacia
	DECLARE Entero_Cero			INT(11);	-- Constante Entero Cero

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;

	SELECT IFNULL(FechaSistema , Fecha_Vacia)
	INTO Var_FechaSistema
	FROM PARAMETROSSIS LIMIT 1;

	-- Reporte de Creditos Contigente
	SELECT  Mov.AmortiCreID,	Mov.Transaccion,	Mov.FechaOperacion,	Mov.FechaAplicacion,
			Mov.Descripcion,	Mov.TipoMovCreID,	Mov.NatMovimiento,	Mov.MonedaID,
			Mov.Cantidad,		Mov.Referencia,		Tip.Descripcion AS TipoMov,
			CONCAT(CONVERT(LPAD(HOUR(Mov.FechaActual), 2,'0'), CHAR), ":",
				   CONVERT(LPAD(MINUTE(Mov.FechaActual), 2,'0'), CHAR), ":",
				   CONVERT(LPAD(SECOND(Mov.FechaActual), 2,'0'), CHAR)) AS HoraMov,
			Var_FechaSistema AS FechaEmision,
			CONVERT(LPAD(Cre.CuentaID, 11,'0'), CHAR) AS CuentaID,TIME(NOW()) AS HoraEmision
	FROM CREDITOSCONTMOVS Mov,
		 TIPOSMOVSCRE Tip,CREDITOS Cre
	WHERE Mov.CreditoID = Par_CreditoID
	  AND Mov.CreditoID =Cre.CreditoID
	  AND Tip.TipoMovCreID = Mov.TipoMovCreID
	  AND FechaOperacion >= Par_FechaInicial
	  AND FechaOperacion <= Par_FechaFin
	  ORDER BY Mov.FechaOperacion;

END TerminaStore$$