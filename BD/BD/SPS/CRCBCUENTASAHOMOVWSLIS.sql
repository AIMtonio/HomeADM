-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBCUENTASAHOMOVWSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBCUENTASAHOMOVWSLIS`;DELIMITER $$

CREATE PROCEDURE `CRCBCUENTASAHOMOVWSLIS`(
# =====================================================================================
# ------- STORE PARA LISTA DE MOVIMIENTOS DE CUENTAS POR WS PARA CREDICLUB ---------
# =====================================================================================
	Par_CuentaAhoID		BIGINT(12),			-- Numero de Cuenta
	Par_Anio			INT(11),			-- Numero de Anio
	Par_Mes				INT(11),			-- Numero de Mes
    Par_NumLis			TINYINT UNSIGNED,	-- Numero de Lista

	Par_EmpresaID		INT(11),			-- Paramatro de Auditoria
	Aud_Usuario			INT(11),			-- Paramatro de Auditoria
	Aud_FechaActual		DATETIME,			-- Paramatro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Paramatro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Paramatro de Auditoria
	Aud_Sucursal		INT(11),			-- Paramatro de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Paramatro de Auditoria

)
TerminaStore:BEGIN
	-- Declaracion de Variables
    DECLARE	Var_Saldo			DECIMAL(14,2); 			-- Valor del Saldo
    DECLARE SaldoIniMesMov		DECIMAL(14,2);			-- Saldo Inicial Mes Actual
    DECLARE	Var_Fecha			DATE; 					-- Fecha de Movimiento
	DECLARE	Var_Naturaleza		CHAR(1); 				-- Naturaleza de Movimiento
	DECLARE	Var_Descripcion		VARCHAR(150); 			-- Descripcion de Movimiento

    DECLARE	Var_Monto			DECIMAL(14,2);			-- Monto Movimiento
	DECLARE	Var_Referencia		VARCHAR(50);			-- Referencia Movimiento
    DECLARE SaldoIniMesHis		DECIMAL(14,2);			-- Saldo Inicial Mes Historico
	DECLARE Var_FechaSistema	DATE;					-- Fecha de Sistema
	DECLARE Var_CuentaAhoID 	BIGINT(12);				-- Numero de Cuenta

	 -- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);
    DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Decimal_Cero	    DECIMAL(12,2);
	DECLARE Fecha_Vacia         DATE;
    DECLARE Lis_MovCtas   		INT(11);

    DECLARE	Nat_Cargo			CHAR(1);
    DECLARE	Nat_Abono			CHAR(1);
    DECLARE DesCargo			VARCHAR(5);
	DECLARE DesAbono			VARCHAR(5);
    DECLARE SimbInterrogacion	VARCHAR(1);

    -- Cursos para obtener los Movimientos Actuales de las Cuentas
	DECLARE CURSORMOV CURSOR FOR
		SELECT 	Fecha, 		DescripcionMov, 	NatMovimiento, 		ReferenciaMov,		CantidadMov
		FROM CUENTASAHOMOV
		WHERE CuentaAhoID =	Par_CuentaAhoID
		AND Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
		AND Fecha <= LAST_DAY(CONCAT(Par_Anio,'-', Par_Mes,'-','01'))
		ORDER BY Fecha,FechaActual,NatMovimiento;

	-- Cursos para obtener los Movimientos Historicos de las Cuentas
	DECLARE CURSORMOVHIS CURSOR FOR
		SELECT 	Fecha, 		DescripcionMov, 	NatMovimiento, 		ReferenciaMov,		CantidadMov
		FROM `HIS-CUENAHOMOV`
		WHERE CuentaAhoID =	Par_CuentaAhoID
		AND Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
		AND Fecha <= LAST_DAY(CONCAT(Par_Anio,'-', Par_Mes,'-','01'))
		ORDER BY Fecha,FechaActual,NatMovimiento;

	-- Asignacion de Constantes
	SET Entero_Cero		:= 0;					-- Entero Cero
	SET Cadena_Vacia	:= '';					-- Cadena Vacia
	SET Decimal_Cero	:=  0.00;   			-- DECIMAL Cero
	SET Fecha_Vacia		:= '1900-01-01';		-- Fecha Vacia
	SET Lis_MovCtas   	:= 1;               	-- Lista de Movimientos de Cuentas

    SET	Nat_Cargo		:= 'C'; 				-- Naturaleza Movimiento: Cargo
	SET	Nat_Abono		:= 'A'; 				-- Naturaleza Movimiento: Abono
	SET DesCargo		:='CARGO';				-- Descripcion Movimiento Cargo
	SET DesAbono		:='ABONO';				-- Descripcion Movimiento Abono
	SET SimbInterrogacion	:= '?';				-- Simbolo de interrogacion


    IF(Par_NumLis = Lis_MovCtas) THEN
		-- Se obtiene la Fecha del Sistema
		SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS);
		-- Se obtiene el Numero de la Cuenta
		SET Var_CuentaAhoID 	:= (SELECT CuentaAhoID	FROM CUENTASAHO	WHERE CuentaAhoID = Par_CuentaAhoID);
        SET Var_CuentaAhoID		:= IFNULL(Var_CuentaAhoID,Entero_Cero);

        SET Par_CuentaAhoID		:= REPLACE(Par_CuentaAhoID, SimbInterrogacion, Entero_Cero);
		SET Par_Anio			:= REPLACE(Par_Anio, SimbInterrogacion, Entero_Cero);
		SET Par_Mes				:= REPLACE(Par_Mes, SimbInterrogacion, Entero_Cero);

        -- Realiza la Consulta de Movimientos si la Cuenta Existe
		IF (Var_CuentaAhoID > Entero_Cero)THEN
			 -- Se compara si el Anio y el Mes es la misma que la Fecha del Sistema
			IF(Par_Anio = YEAR(Var_FechaSistema) AND Par_Mes = MONTH(Var_FechaSistema)) THEN

				SET SaldoIniMesMov 	:= (SELECT IFNULL(SaldoIniMes,Decimal_Cero) FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID LIMIT 1);
				SET Var_Saldo		:= SaldoIniMesMov;

				DROP TEMPORARY TABLE IF EXISTS TMPMOVIMIENTOSCTA;
				CREATE TEMPORARY TABLE TMPMOVIMIENTOSCTA(
					Fecha 			DATE,
					Descripcion 	VARCHAR(150),
					Naturaleza 		CHAR(1),
					Referencia 		VARCHAR(50),
					Monto 			DECIMAL(14,2),
					Saldo 			DECIMAL(14,2));

				CREATE INDEX Idx_Fecha ON TMPMOVIMIENTOSCTA (Fecha);

				INSERT INTO TMPMOVIMIENTOSCTA (
					Fecha,
					Descripcion,
					Naturaleza,
					Referencia,
					Monto,
					Saldo)
				VALUES (
					CONCAT(Par_Anio,'-', Par_Mes,'-','01'),
					'SALDO INICIAL DEL MES',
					Cadena_Vacia,
					Cadena_Vacia,
					SaldoIniMesMov,
					SaldoIniMesMov);

				OPEN CURSORMOV;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
					LOOP
						FETCH CURSORMOV  INTO Var_Fecha, Var_Descripcion, Var_Naturaleza, Var_Referencia, Var_Monto;

						IF(Var_Naturaleza = Nat_Cargo)THEN
							SET  	Var_Saldo	:= ROUND(ROUND(Var_Saldo,2)-ROUND(Var_Monto,2),2);
						END IF;

						IF(Var_Naturaleza = Nat_Abono)THEN
							SET  	Var_Saldo	:= ROUND(ROUND(Var_Saldo,2)+ROUND(Var_Monto,2),2);
						END IF;

						INSERT INTO TMPMOVIMIENTOSCTA (
							Fecha,		Descripcion,		Naturaleza,	 		Referencia,			Monto,
							Saldo)
						VALUES (
							Var_Fecha,	Var_Descripcion, 	Var_Naturaleza,		Var_Referencia, 	Var_Monto,
							Var_Saldo);
					END LOOP;
				END;
				CLOSE CURSORMOV;

				SELECT 	Fecha,
						Descripcion,
						CASE Naturaleza WHEN Nat_Cargo THEN DesCargo
										WHEN Nat_Abono THEN DesAbono
										ELSE Cadena_Vacia END AS Naturaleza,
						Referencia,
						FORMAT(IFNULL(Monto,Decimal_Cero),2) AS Monto,
						FORMAT(IFNULL(Saldo,Decimal_Cero),2) AS Saldo
				FROM TMPMOVIMIENTOSCTA;

				DROP TABLE TMPMOVIMIENTOSCTA;

			ELSE

				SELECT IFNULL(SaldoIniMes,Decimal_Cero) INTO SaldoIniMesHis
				FROM `HIS-CUENTASAHO`
				WHERE CuentaAhoID = Par_CuentaAhoID
				AND Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
				AND Fecha <= LAST_DAY(CONCAT(Par_Anio,'-', Par_Mes,'-','01'))
				LIMIT 1;

				SET Var_Saldo	:= SaldoIniMesHis;

				DROP TEMPORARY TABLE IF EXISTS TMPMOVIMIENTOSCTA;
				CREATE TEMPORARY TABLE TMPMOVIMIENTOSCTA(
					Fecha 			DATE,
					Descripcion 	VARCHAR(150),
					Naturaleza 		CHAR(1),
					Referencia 		VARCHAR(50),
					Monto 			DECIMAL(14,2),
					Saldo 			DECIMAL(14,2));

				CREATE INDEX Idx_Fecha ON TMPMOVIMIENTOSCTA (Fecha);

				INSERT INTO TMPMOVIMIENTOSCTA (
					Fecha,
					Descripcion,
					Naturaleza,
					Referencia,
					Monto,
					Saldo)
				VALUES (
					CONCAT(Par_Anio,'-', Par_Mes,'-','01'),
					'SALDO INICIAL DEL MES',
					Cadena_Vacia,
					Cadena_Vacia,
					SaldoIniMesHis,
					SaldoIniMesHis);

				OPEN CURSORMOVHIS;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
					LOOP
						FETCH CURSORMOVHIS  INTO Var_Fecha, Var_Descripcion, Var_Naturaleza, Var_Referencia, Var_Monto;

						IF(Var_Naturaleza = Nat_Cargo)THEN
							SET  	Var_Saldo	:= ROUND(ROUND(Var_Saldo,2)-ROUND(Var_Monto,2),2);
						END IF;

						IF(Var_Naturaleza = Nat_Abono)THEN
							SET  	Var_Saldo	:= ROUND(ROUND(Var_Saldo,2)+ROUND(Var_Monto,2),2);
						END IF;

						INSERT INTO TMPMOVIMIENTOSCTA (
							Fecha,		Descripcion,		Naturaleza,	 		Referencia,			Monto,
							Saldo)
						VALUES (
							Var_Fecha,	Var_Descripcion, 	Var_Naturaleza,		Var_Referencia, 	Var_Monto,
							Var_Saldo);
					END LOOP;
				END;
				CLOSE CURSORMOVHIS;

				SELECT 	Fecha,
						Descripcion,
						CASE Naturaleza WHEN Nat_Cargo THEN DesCargo
										WHEN Nat_Abono THEN DesAbono
										ELSE Cadena_Vacia END AS Naturaleza,
						Referencia,
						FORMAT(IFNULL(Monto,Decimal_Cero),2) AS Monto,
						FORMAT(IFNULL(Saldo,Decimal_Cero),2) AS Saldo
				FROM TMPMOVIMIENTOSCTA;

				DROP TABLE TMPMOVIMIENTOSCTA;

			  END IF;
		END IF;
	END IF;

END TerminaStore$$