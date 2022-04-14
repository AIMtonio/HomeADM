-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BLOQUEOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BLOQUEOSLIS`;DELIMITER $$

CREATE PROCEDURE `BLOQUEOSLIS`(
	Par_CuentaAhoID		BIGINT(12),
	Par_Mes				INT,
	Par_Anio			INT,
	Par_NumLis			TINYINT UNSIGNED,

	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
	)
TerminaStore: BEGIN

-- declaracion de constantes
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Decimal_Cero	DECIMAL(14,2);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Lis_Principal	INT;
DECLARE	Lis_Bloqueos    INT;
DECLARE	Con_Foranea		INT;
DECLARE	nat_Bloq		CHAR(1);
DECLARE EstatusActivo   CHAR(1);
DECLARE TipBloqPlanAho 	INT(11);

-- declaracion de variables
DECLARE varFecha		DATE;
DECLARE varSaldoActual	DECIMAL(14,2);
DECLARE varSaldoBloq	DECIMAL(14,2);

-- asignacion de constantes
SET	Cadena_Vacia		:= '';
SET Decimal_Cero		:= 0.00;
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Lis_Principal		:= 1;
SET Lis_Bloqueos     	:= 3;
SET nat_Bloq			:= 'B';
SET EstatusActivo 		:= 'A'; -- Estatus Activo de las cuentas de ahorro
SET TipBloqPlanAho		:= 19;

IF(Par_NumLis = Lis_Principal) THEN 	 /* Consulta por Llave Principal */
	SET varFecha := (SELECT DATE_ADD(cast(CONCAT(Par_Anio,'-', Par_Mes,'-','01') AS DATETIME), INTERVAL -1 MONTH));
	SET varSaldoBloq:= (SELECT IFNULL(SaldoBloq,Decimal_Cero)
							FROM  `HIS-CUENTASAHO`
							WHERE  CuentaAhoID = Par_CuentaAhoID
							AND month(Fecha)= month(varFecha)
							AND year(Fecha)= year(varFecha) );

  SET varSaldoActual := (SELECT IFNULL(SaldoBloq,Decimal_Cero) FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID);

	(SELECT  	Par_CuentaAhoID,		nat_Bloq,	varFecha,	format(varSaldoBloq,2),	'SALDO BLOQUEADO ANTES DEL CORTE',
				format(varSaldoActual,2)
	)
	UNION ALL (
		SELECT	CuentaAhoID,		NatMovimiento,	FechaMov,	CONCAT(FORMAT(IFNULL(MontoBloq,Decimal_Cero),2)) AS MontoBloq,	Descripcion,
				format(varSaldoActual,2)
			FROM BLOQUEOS
			WHERE  CuentaAhoID = Par_CuentaAhoID
			AND month(FechaMov)= Par_Mes
			AND year(FechaMov)= Par_Anio
			ORDER BY FechaMov ASC
	);
END IF;

IF(Par_NumLis = Lis_Bloqueos) THEN
    SELECT bl.BloqueoID,  bl.CuentaAhoID, tc.Descripcion AS DescripcionCta, bl.NatMovimiento, bl.MontoBloq, bl.TiposBloqID,
			bl.Descripcion, (CASE WHEN bl.TiposBloqID= TipBloqPlanAho THEN CONCAT('No.Folios ',bl.Referencia) ELSE bl.Referencia END) AS Referencia, ct.SaldoDispon, ct.SaldoSBC, DATE(bl.FechaMov) AS FechaMov
        FROM BLOQUEOS bl
        LEFT JOIN CUENTASAHO ct ON bl.CuentaAhoID = ct.CuentaAhoID AND ct.Estatus = 'A'
        INNER JOIN TIPOSCUENTAS tc ON ct.TipoCuentaID = tc.TipoCuentaID
        WHERE bl.CuentaAhoID= Par_CuentaAhoID AND bl.NatMovimiento = nat_Bloq AND  bl.FolioBloq = 0 ;
END IF;
END TerminaStore$$