-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APPWTARJETASMOVSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `APPWTARJETASMOVSLIS`;

DELIMITER $$
CREATE PROCEDURE `APPWTARJETASMOVSLIS`(

	Par_TarjetaID		CHAR(16),
	Par_FechaInicio		DATE,
	Par_FechaFin		DATE,

	Par_NumLis			TINYINT UNSIGNED,

	Aud_EmpresaID		INT(11),				-- Parametro de auditoria
	Aud_Usuario			INT(11),				-- Parametro de auditoria
	Aud_FechaActual		DATEtIME,				-- Parametro de auditoria
	Aud_DireccionIP		VARCHAR(15),			-- Parametro de auditoria
	Aud_ProgramaID		VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal		INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion	BIGINT(12)				-- Parametro de auditoria
	)

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_CuentaAhoID		BIGINT(12);
	DECLARE Var_LineaTarCredID	INT(11);

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Decimal_Cero		DECIMAL(12,2);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT(11);
	DECLARE TiposMovs			INT(11);
	DECLARE TiposMovs1			INT(11);
	DECLARE TiposMovs2			INT(11);
	DECLARE TiposMovs3			INT(11);
	DECLARE TiposMovs4			INT(11);
	DECLARE TiposMovs5			INT(11);
	DECLARE TiposMovs6			INT(11);
	DECLARE TiposMovs7			INT(11);
	DECLARE TiposMovs8			INT(11);
	DECLARE	Lis_Principal 		INT(11);

	SET	Cadena_Vacia			:= '';
	SET	Decimal_Cero			:= 0.00;
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Entero_Cero     		:= 0;
	SET TiposMovs				:= 18;
	SET TiposMovs1				:= 19;
	SET TiposMovs2				:= 20;
	SET TiposMovs3				:= 21;
	SET TiposMovs4				:= 22;
	SET TiposMovs5				:= 17;
	SET TiposMovs6				:= 90;
	SET TiposMovs7				:= 86;
	SET TiposMovs8				:= 14;
	SET	Lis_Principal			:= 1;

	IF Par_NumLis = Lis_Principal THEN

		SELECT CuentaAhoID INTO Var_CuentaAhoID  FROM TARJETADEBITO WHERE TarjetaDebID = Par_TarjetaID;

		SET Var_CuentaAhoID := IFNULL(Var_CuentaAhoID,Entero_Cero);

		IF Var_CuentaAhoID <> Entero_Cero THEN
			SELECT Fecha, CONCAT(DescripcionMov, ' - ', ReferenciaMov) as DescripcionMov, CantidadMov, NatMovimiento, ReferenciaMov, NumTransaccion, NumeroMov,
				CASE
					WHEN NatMovimiento = 'A' THEN
						'ABONO'
					WHEN NatMovimiento = 'C' THEN
						'CARGO'
					END AS DescNatMovimiento
			FROM CUENTASAHOMOV
			WHERE TipoMovAhoID IN (TiposMovs,TiposMovs1,TiposMovs2,TiposMovs3,TiposMovs4,TiposMovs5,TiposMovs6,TiposMovs7,TiposMovs8)
			AND CuentaAhoID = Var_CuentaAhoID
			AND Fecha >= Par_FechaInicio AND Fecha <= Par_FechaFin
			UNION
			SELECT Fecha, CONCAT(DescripcionMov, ' - ', ReferenciaMov) as DescripcionMov, CantidadMov, NatMovimiento, ReferenciaMov, NumTransaccion, NumeroMov,
				CASE
					WHEN NatMovimiento = 'A' THEN
						'ABONO'
					WHEN NatMovimiento = 'C' THEN
						'CARGO'
					END AS DescNatMovimiento
			FROM `HIS-CUENAHOMOV`
			WHERE TipoMovAhoID IN (TiposMovs,TiposMovs1,TiposMovs2,TiposMovs3,TiposMovs4,TiposMovs5,TiposMovs6,TiposMovs7,TiposMovs8)
			AND CuentaAhoID = Var_CuentaAhoID
			AND Fecha >= Par_FechaInicio AND Fecha <= Par_FechaFin  ORDER BY Fecha ASC;
		ELSE
			SELECT LineaTarCredID INTO Var_LineaTarCredID FROM TARJETACREDITO WHERE TarjetaCredID = Par_TarjetaID;

			SELECT FechaAplicacion AS Fecha, DescripcionMov, CantidadMov, NatMovimiento,  ReferenciaMov, NumTransaccion, NumeroMov,
					CASE
					WHEN NatMovimiento = 'A' THEN
						'ABONO'
					when NatMovimiento = 'C' THEN
						'CARGO'
					END AS DescNatMovimiento
				FROM TC_LINEACREDITOMOVS
				WHERE LineaTarCredID = Var_LineaTarCredID
				AND TarjetaCredID = Par_TarjetaID
				AND FechaAplicacion >= Par_FechaInicio AND FechaAplicacion <= Par_FechaFin;
		END IF;
	END IF;

END TerminaStore$$