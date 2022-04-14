-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROIDEMENS015ALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBROIDEMENS015ALT`;
DELIMITER $$


CREATE PROCEDURE `COBROIDEMENS015ALT`(
	-- se usa en el CIERRE del MES para SOFIEXPRESS

	Par_EmpresaID		INT,		-- Parametro Auditoria
	Aud_Usuario			INT,		-- Parametro Auditoria
	Aud_FechaActual		DATETIME,	-- Parametro Auditoria
	Aud_DireccionIP		VARCHAR(15),-- Parametro Auditoria
	Aud_ProgramaID		VARCHAR(50),-- Parametro Auditoria
	Aud_Sucursal		INT,		-- Parametro Auditoria
	Aud_NumTransaccion	BIGINT		-- Parametro Auditoria
		)

TerminaStore: BEGIN

-- declaracion de Constantes
DECLARE	Entero_Cero		INT;				-- Constante 0
DECLARE	Nat_Cargo		CHAR(1);			-- Naturaleza de Cargo
DECLARE	Nat_Abono		CHAR(1);			-- Naturaleza de Abono
DECLARE	Var_Si			CHAR(1);			-- Constante si
DECLARE	No_Considerada	CHAR(1);			-- Constante No considerado
DECLARE	Considerada		CHAR(1);			-- Constante Considerado
DECLARE Decimal_Cero	DECIMAL(12,2);		-- Constante para el valor decimal 0.00

-- declaracion de variables
DECLARE Var_PeriodoVigente 	INT(11);		-- Variable para el periodo Vigente
DECLARE Var_MontoExcIDE	   	DECIMAL(12,2);	-- Variable monto Excedido
DECLARE Var_TasaIDE		   	DECIMAL(12,2);	-- Variable de la Tasa del cobro IDE
DECLARE Var_FechaSistema   	DATE; 			-- variable para almacenar la Fecha del sistema
DECLARE Var_FechaIni		DATE;
DECLARE Var_FechaFin		DATE;
DECLARE FormatoFechaInicio    VARCHAR(10);
-- declaracion de Constantes
SET	Entero_Cero		:= 	0;
SET	Nat_Cargo		:= 'C';
SET	Nat_Abono		:= 'A';
SET	Var_Si			:= 'S';
SET	No_Considerada	:= 'N';
SET	Considerada		:= 'S';
SET Decimal_Cero	:= 0.00;
SET FormatoFechaInicio    := '%Y-%m-01';
SET Var_FechaFin	:= Aud_FechaActual;
SET	Var_FechaIni	:= DATE_FORMAT(Aud_FechaActual, FormatoFechaInicio);
-- declaracion de variables-*
SELECT MontoExcIDE, TasaIDE , month(FechaSistema), FechaSistema
	INTO Var_MontoExcIDE, Var_TasaIDE, Var_PeriodoVigente, Var_FechaSistema
	FROM PARAMETROSSIS;


DROP TABLE IF EXISTS EFECTIVOIDEMES;

CREATE TABLE EFECTIVOIDEMES(
	RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	ClienteID 		INT(11),
	CuentaAhoID		BIGINT(20),
	Fecha 			DATE,
	NatMovimiento 	CHAR(1),
	Abono 			DECIMAL(14,2),
	Cargo      		DECIMAL(14,2)

);

INSERT INTO EFECTIVOIDEMES(ClienteID,CuentaAhoID,Fecha,NatMovimiento,Abono,Cargo)
SELECT E.ClienteID, E.CuentasAhoID, E.Fecha, E.NatMovimiento, E.CantidadMov, Decimal_Cero
FROM
	EFECTIVOMOVS E
LEFT JOIN
	REVERSASOPER R ON E.NumeroMov = R.TransaccionID
WHERE E.Estatus = No_Considerada AND E.NatMovimiento= Nat_Abono
						AND E.Fecha BETWEEN Var_FechaIni AND Var_FechaFin
                        AND R.TransaccionID IS NULL;


DROP TABLE IF EXISTS DATOSBRUTOS;
CREATE TEMPORARY TABLE DATOSBRUTOS(
	RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	ClienteID		int(11),
	PeriodoID		int(11),
	Cantidad		decimal(12,2),
	MontoIDE		decimal(12,2),
	CantidadCob		decimal(12,2),
	CantidadPen		decimal(12,2),
	FechaCorte		date,
	EmpresaID		int(11),
	Usuario			int(11),
	FechaActual		datetime,
	DireccionIP		varchar(15),
	ProgramaID		varchar(50),
	Sucursal		int(11),
	NumTransaccion	bigint(20)
);
-- Se inserta en la tabla de COBROIDEMENS
INSERT INTO DATOSBRUTOS (
		ClienteID,		PeriodoID,			Cantidad,			MontoIDE,			CantidadCob,
		CantidadPen,	FechaCorte,			EmpresaID, 			Usuario, 			FechaActual,
		DireccionIP,	ProgramaID,			Sucursal, 			NumTransaccion
		)
SELECT	 E.ClienteID, Var_PeriodoVigente,CASE WHEN((SUM(Abono)-SUM(Cargo))> Var_MontoExcIDE) THEN
 (SUM(Abono)-SUM(Cargo))- Var_MontoExcIDE
 ELSE Entero_Cero END AS CantidadMov, (SUM(Abono)-SUM(Cargo))*Var_TasaIDE AS MontoIDE,
		Entero_Cero, Entero_Cero, Var_FechaSistema, Par_EmpresaID,
	  	 Aud_Usuario, Aud_FechaActual, Aud_DireccionIP, Aud_ProgramaID,
	  	 Aud_Sucursal, Aud_NumTransaccion
FROM EFECTIVOIDEMES E GROUP BY ClienteID;

INSERT INTO COBROIDEMENS (
		ClienteID,		PeriodoID,			Cantidad,			MontoIDE,			CantidadCob,
		CantidadPen,	FechaCorte,			EmpresaID, 			Usuario, 			FechaActual,
		DireccionIP,	ProgramaID,			Sucursal, 			NumTransaccion
		)
 SELECT DB.ClienteID,		DB.PeriodoID,			DB.Cantidad,			DB.MontoIDE,			DB.CantidadCob,
		DB.CantidadPen,	DB.FechaCorte,			DB.EmpresaID, 			DB.Usuario, 			DB.FechaActual,
		DB.DireccionIP,	DB.ProgramaID,			DB.Sucursal, 			DB.NumTransaccion
FROM DATOSBRUTOS DB, CLIENTES  C WHERE DB.ClienteID = C.ClienteID
AND C.PagaIDE=Var_Si AND
DB.Cantidad > Entero_Cero;


UPDATE EFECTIVOMOVS SET Estatus = Considerada
WHERE NatMovimiento = Nat_Abono
AND 	Estatus	     = No_Considerada;

END TerminaStore$$
