-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPOLIZAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEPOLIZAREP`;
DELIMITER $$


CREATE PROCEDURE `DETALLEPOLIZAREP`(
# ==================================================================================
#	SP QUE GENERA EL REPORTE DE MOVIMIENTOS POR CUENTAS CONTABLES MOVCTACONTABLEREP
# ==================================================================================
    Par_CuentaCompleta		VARCHAR(50),			# Numero de cuenta completa de inicio
	Par_CuentaCompFin		VARCHAR(50),			# Numero de cuenta final
	Par_FechaIni			DATE,					# Fecha de Inicio
	Par_FechaFin			DATE,					# Fecha final
	Par_PrimerRango			BIGINT(25),				# Primer rango este campo es de los instrumentos

	Par_SegundoRango		BIGINT(25),				# Rango para finalizar los instrumentos
	Par_PrimerCentroC		BIGINT(25),				# Centro de Costos inicial
	Par_SegundoCentroC		BIGINT(25),				# Centro de Costos final
	Par_TipoInstrumento		BIGINT(11),				# Tipo de Instrumento
	Par_NumRep				TINYINT UNSIGNED,		# Numero de reporte 1: Movimientos de las cuentas

    /*Parametros de Auditoria*/
	Aud_EmpresaID			INT(11),				# Auditoria
	Aud_Usuario				INT(11),				# Auditoria
	Aud_FechaActual			DATETIME,				# Auditoria
	Aud_DireccionIP			VARCHAR(15),			# Auditoria
	Aud_ProgramaID			VARCHAR(50),			# Auditoria

	Aud_Sucursal			INT(11),				# Auditoria
	Aud_NumTransaccion		BIGINT(20)				# Auditoria
)

TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE movCuentaConta				INT(11);
	DECLARE Entero_Cero					INT(11);
	DECLARE TipoCliente					INT(11);				# Instrumento Cliente
	DECLARE TipoCuenta					INT(11);				# Instrumento Cuenta
	DECLARE TipoCredito					INT(11);				# Instrumento Credito

    DECLARE TipoInversion				INT(11);				# Instrumento Inversion

	-- Declaracion de variables
	DECLARE Var_FechaSalHis				DATE;
	DECLARE Var_FechaUltPeriodo			DATE;

	-- Variables del cursor
	DECLARE Var_CuentaCompleta			VARCHAR(50);				# Cuenta completa Se deja con el tamano de 50 por que asi se guarda en detallepoliza
	DECLARE Var_Descripcion				VARCHAR(400);				# Descripcion de la cuenta
	DECLARE Var_Naturaleza				CHAR(1);					# Naturaleza A Acrededora D Deudora
	DECLARE Var_PolizaID				BIGINT(20);					# Equivale al campo de PolizaID de DetallePoliza
	DECLARE Var_Fecha 					DATE;						# Fecha de la poliza

    DECLARE Var_Cargos 					DECIMAL(16,4);				# Cargos (Proviene de la tabla de Detallepoliza e Hisdetallepoliza)
	DECLARE Var_Abonos					DECIMAL(16,4);				# Abonos (Proviene de la tabla de Detallepoliza e Hisdetallepoliza)
	DECLARE Var_SaldoInicial			DECIMAL(16,4);				# Valor calculado proviende de la tabla de SALDOSCONTABLES
	DECLARE Var_CuentaCompletaAnt		VARCHAR(50);				# Cuenta contable anterior para poder comparar en el cursor
	DECLARE Var_SaldoCalculado			DECIMAL(16,4);				# Saldo calculado por cuenta contable va cambiando por cada poliza

    DECLARE Var_EmpresaID				INT(11);					# Campo pertenece a la tabla TMPHISPOLIZA llenada con Detalle Poliza e His-detallepoliza
	DECLARE Var_Consecutivo				INT(11);					# Consecutivo para ordenar la cuentas
	DECLARE Var_Orden					INT(11);					# Numero de ordenamiento
	DECLARE Var_CentroCostoID			INT(11);					# Centro de costos del detalle de la poliza
	DECLARE Var_NombreCuenta			VARCHAR(250);				# Numero de instrumento del detalle de la poliza

    DECLARE Var_Instrumento				VARCHAR(50);				# Tipo de instrumento
	DECLARE Var_TipoInstrumentoID		INT(11);

    DECLARE CURSORSALDOS CURSOR FOR # Esta tabla se llena con  de TMPHISPOLIZA se llena con las tablas de DETALLEPOLIZA e HIS-DETALLEPOLIZA
	SELECT 							# La tabla de TEMPCUENTASCONTABLES Se llena con la tabla de SALDOSCONTABLES
		T.EmpresaID,		T.Consecutivo,		0 AS ORDEN, 					T.PolizaID,						T.Fecha,
		T.CentroCostoID,	T.CuentaCompleta,	C.Descripcion AS NombreCuenta,	IFNULL(Cargos,0.0) AS Cargos,	IFNULL(Abonos,0.0) AS Abonos,
		T.Descripcion,		T.Instrumento,		T.TipoInstrumentoID,			C.SaldoInicial,					C.Naturaleza
		FROM TMPHISPOLIZA AS T
		LEFT JOIN TEMPCUENTASCONTABLES AS C ON T.CuentaCompleta=C.CuentaCompleta
			ORDER BY T.CuentaCompleta,T.Fecha, T.PolizaID; # El orden del cursor siempre debe quedar por Cuenta completa primero

	-- Asignacion de constantes
	SET movCuentaConta			:= 1;
	SET Entero_Cero				:= 0;
	SET TipoCliente				:= 4;
	SET TipoCuenta				:= 2;
	SET TipoCredito				:= 11;
	SET TipoInversion			:= 13;
	SET Var_FechaSalHis			:= (SELECT MAX(FechaCorte) FROM SALDOSCONTABLES WHERE FechaCorte<=Par_FechaIni);
	SET Var_FechaUltPeriodo		:= (SELECT MAX(Fin) FROM PERIODOCONTABLE WHERE EStatus='C' );

	-- No olvidar inicializar las variables que se ocupen en el cursor
	SET Var_CuentaCompletaAnt := '';
	SET Var_SaldoCalculado := 0.0;

	ManejoErrores:BEGIN
		/*	IMPORTANTE: El Saldo Inicial no puede salir con filtrado de los instrumentos ya que por la cantidad de registros
			Podria agotar los recursos de memoria.
			1. Validar los filtros de (Centro de costos, Instrumentos)
			2.1 Saldos Iniciales - Llenar la tabla temporal TEMPCUENTASCONTABLES con la informacion de el catalogo de las cuentas contables
			2.2 Saldos Iniciales - Llenar la tabla temporal TEMPSALDOSCONTABLES con la informacion de la tabla SALDOSCONTABLES Solo si el instrumento es 0
			2.3 Saldos Iniciales - Llenar la tabla temporal TMPMOVSPOLIZA con los movimientos de DETALLEPOLIZA e HIS-DETALLEPOLIZA
			2.4 Actulizar el Saldo inicial solo si el instrumento es 0 - Todos
			3. Poblar la tabla con los detalles del reporte
			4. Actualizar los saldos de cada detalle
		*/

		# Paso 1: Validacion de los filtros
		-- Instrumentos
		SET Par_TipoInstrumento		:= IFNULL(Par_TipoInstrumento,Entero_Cero);
		SET Par_PrimerRango			:= IFNULL(Par_PrimerRango, Entero_Cero);
		SET Par_SegundoRango		:= IFNULL(Par_SegundoRango, Entero_Cero);
		-- Centro de costos
		IF(IFNULL(Par_PrimerCentroC,Entero_Cero)=Entero_Cero)THEN
			-- Es posible que el cliente quiera obtener reporte de CC = 0
			SELECT
				MIN(CentroCostoID),		MAX(CentroCostoID)
				INTO
				Par_PrimerCentroC,		Par_SegundoCentroC
				FROM CENTROCOSTOS
					WHERE EmpresaID=Aud_EmpresaID;
		END IF;
		# Fin Paso 1

		# Paso 	2
		# Paso	2.1: Saldo Inicial - Creando tabla temporal con el catalogo de cuentas contables
		/*tabla temporal para las cuentas contables, Se usa en el paso 1*/
		DROP TABLE IF EXISTS TEMPCUENTASCONTABLES;
		CREATE TEMPORARY TABLE TEMPCUENTASCONTABLES (
			CuentaCompleta			CHAR(25) 		NOT NULL COMMENT 'Cuenta Contable Completa',
			CuentaMayor				CHAR(4) 		NOT NULL COMMENT 'Cuenta de Mayor',
			Descripcion				VARCHAR(400)	NOT NULL COMMENT 'Descripcion de la\nCuenta\n',
			Naturaleza				CHAR(1) 		NOT NULL COMMENT 'Naturaleza de la\nCuenta\nA .-  Acreedora\nD .-  Deudora',
			Grupo					CHAR(1) 		NOT NULL COMMENT 'Nivel de Desglose\nE= ''Encabezado'' \nD= ''Detalle''     ',
            TipoCuenta				CHAR(1) 		NOT NULL COMMENT 'Tipo de Cuenta\n1 .- Activo\n2 .- Pasivo\n3 .- Complementaria de Activo\n4.- Capital y Reserva\n5 .- Resultados (Ingresos)\n6 .- Resultados (Gastos)\n7 .- Orden Deudora\n8 .- Orden Acreedora',
			SaldoInicial			DECIMAL(16,4)		COMMENT 'Saldo historico perteneciente a la tabla de SALDOSCONTABLES',
			PRIMARY KEY (CuentaCompleta)
		) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Maestro o Catalogo de Cuentas Contables\nGenerales de la Apli';

		/*Poblamos la tabla con el catalogo CUENTASCONTABLES*/
		INSERT INTO TEMPCUENTASCONTABLES (
			CuentaCompleta,			CuentaMayor,		Descripcion,		Naturaleza,		Grupo,
			TipoCuenta,				SaldoInicial)
		SELECT
			CuentaCompleta,			CuentaMayor,		Descripcion,		Naturaleza,		Grupo,
			TipoCuenta,				Entero_Cero
			FROM CUENTASCONTABLES
				WHERE
					CuentaCompleta BETWEEN CAST(Par_CuentaCompleta AS UNSIGNED)
										AND CAST(Par_CuentaCompFin AS UNSIGNED);
		# Fin Paso 2.1



		IF(IFNULL(Par_TipoInstrumento,Entero_Cero)=Entero_Cero)THEN
			# Paso 2.2: Saldo Inicial - Llenar la tabla TEMPSALDOSCONTABLES y actualizar la informacion del campo SaldoInicial de la tabla TEMPCUENTASCONTABLES
			-- Si el instrumento es 0 crear la tabla
			DROP TABLE IF EXISTS TEMPSALDOSCONTABLES;
			CREATE TEMPORARY TABLE TEMPSALDOSCONTABLES (
				CuentaCompleta 		CHAR(25) NOT NULL COMMENT 'Cuenta Contable Completa',
				SaldoFinal			DECIMAL(16,4)		COMMENT 'Saldo Final',
				PRIMARY KEY (CuentaCompleta)
			) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Maestro o Catalogo de Cuentas Contables Generales de la Aplicion';

			-- Llenar la tabla con la informacion de SALDOSCONTABLES del ultimo periodo mas cercano a la fecha inicial
			INSERT INTO TEMPSALDOSCONTABLES (
				CuentaCompleta,			SaldoFinal)
			SELECT
				S.CuentaCompleta,		SUM(SaldoFinal)
				FROM TEMPCUENTASCONTABLES AS T
					INNER JOIN SALDOSCONTABLES AS S ON T.CuentaCompleta=S.CuentaCompleta
						WHERE (CAST(S.CuentaCompleta AS UNSIGNED) BETWEEN CAST(Par_CuentaCompleta AS UNSIGNED) AND CAST(Par_CuentaCompFin AS UNSIGNED))
							AND (S.CentroCosto BETWEEN Par_PrimerCentroC AND Par_SegundoCentroC)
							AND FechaCorte=Var_FechaSalHis
								GROUP BY S.CuentaCompleta;

				UPDATE TEMPCUENTASCONTABLES AS T INNER JOIN TEMPSALDOSCONTABLES AS S ON T.CuentaCompleta=S.CuentaCompleta
				SET SaldoInicial = S.SaldoFinal;
			# Fin Paso 2.2

			# Paso 2.3
			/* Tabla que almacenara los datos de la tabla de detallepoliza y de his-detallepoliza para poder calcular el saldo inicial **/
			DROP TABLE IF EXISTS  TMPMOVSPOLIZA;
			CREATE TEMPORARY TABLE TMPMOVSPOLIZA(
				CuentaCompleta  VARCHAR(50),
				Cargos          DECIMAL(16,4),
				Abonos          DECIMAL(16,4)
			);
			/** Traemos los saldos del historico de detalle poliza, tomamos los movimientos que hayan ocurrido despues del ultimo historico
			y antes de la fecha de inicio del rango a mostrar.*/
			IF(Var_FechaSalHis<Var_FechaUltPeriodo)THEN -- Tomaremos parte del detalle del historico de polizas
				/*TOMAMOS DEL HISTORICO SI ES QUE YA HAY DATOS EN EL Y YA CERRARON SU PERIODO CONTABLE*/
				INSERT INTO TMPMOVSPOLIZA (
					CuentaCompleta,			Cargos,				Abonos)
					SELECT
					CuentaCompleta,	SUM(Cargos),		SUM(Abonos)
					FROM `HIS-DETALLEPOL`
						WHERE CuentaCompleta >= Par_CuentaCompleta
							AND CuentaCompleta <= Par_CuentaCompFin
							AND  CentroCostoID>=Par_PrimerCentroC
							AND CentroCostoID<=Par_SegundoCentroC
							AND Fecha>Var_FechaSalHis
							AND Fecha<Par_FechaIni
							GROUP BY CuentaCompleta;
			END IF;

			-- tomamos los registros de periodos no cerrados
			INSERT INTO TMPMOVSPOLIZA (
				CuentaCompleta,			Cargos,			Abonos)
				SELECT
					CuentaCompleta,	SUM(Cargos),	SUM(Abonos)
					FROM DETALLEPOLIZA
						WHERE CuentaCompleta >= Par_CuentaCompleta
							AND CuentaCompleta <= Par_CuentaCompFin
							AND  CentroCostoID>=Par_PrimerCentroC
							AND CentroCostoID<=Par_SegundoCentroC
							AND Fecha>Var_FechaUltPeriodo
							AND Fecha<Par_FechaIni
							GROUP BY CuentaCompleta;

			-- Le sumamos este saldo al saldo de la tabla TEMPSALDOSCONTABLES
			-- Calculamos los Saldos historicos de las cuentas del rango seleccionado.
			DROP TABLE IF EXISTS TMPSALDOINICIAL;
			CREATE TEMPORARY TABLE TMPSALDOINICIAL(
				CuentaCompleta   VARCHAR(50),
				Cargos          DECIMAL(16,4),
				Abonos          DECIMAL(16,4)
			);
			INSERT INTO TMPSALDOINICIAL(
				CuentaCompleta, Cargos,Abonos)
			SELECT CuentaCompleta, SUM(IFNULL(Cargos,0.0)), SUM(IFNULL(Abonos,0.0))
				FROM TMPMOVSPOLIZA
					GROUP BY CuentaCompleta;
			# Fin Paso 2.3
			# Paso 2.4
			UPDATE TEMPCUENTASCONTABLES AS S
				INNER JOIN TMPSALDOINICIAL AS I ON S.CuentaCompleta = I.CuentaCompleta
			SET SaldoInicial = SaldoInicial + IFNULL((CASE S.Naturaleza	WHEN 'D' THEN I.Cargos-I.Abonos
															WHEN 'A' THEN I.Abonos-I.Cargos END), 0.0);
			# Fin Paso 2.4

		END IF;
		# Fin Paso 2


		# Paso 3
		DROP TABLE IF EXISTS TMPHISPOLIZA;
		CREATE TEMPORARY TABLE TMPHISPOLIZA(
			EmpresaID           INT(11),
			PolizaID            BIGINT(20),
			Fecha               DATE,
			CentroCostoID       INT(11),
			Cargos              DECIMAL(16,4),

			Abonos              DECIMAL(16,4),
			Descripcion         VARCHAR(400),
			Instrumento         VARCHAR(20),
			TipoInstrumentoID   INT(11),
			CuentaCompleta      VARCHAR(50),

			Consecutivo         INT(11)
			);
		CREATE INDEX idxConsecutivo ON TMPHISPOLIZA(EmpresaID,PolizaID);

		-- Insertamos el detalle de los movimientos.
		SET @Consecutivo:=1;
		IF(Par_FechaIni<Var_FechaUltPeriodo)THEN
			INSERT INTO TMPHISPOLIZA (
				EmpresaID ,				PolizaID,			Fecha,				CentroCostoID,				Cargos,
				Abonos,					Descripcion,		Instrumento,		TipoInstrumentoID,			CuentaCompleta,
				Consecutivo)
				SELECT
				deHis.EmpresaID,		deHis.PolizaID,		deHis.Fecha,		deHis. CentroCostoID,		deHis.Cargos,
				deHis.Abonos,			deHis.Descripcion,	deHis.Instrumento,	deHis.TipoInstrumentoID,	deHis.CuentaCompleta ,
				(@Consecutivo:=@Consecutivo+1)
				FROM `HIS-DETALLEPOL` deHis
				LEFT JOIN TEMPCUENTASCONTABLES as Tem ON deHis.CuentaCompleta = Tem.CuentaCompleta
					WHERE  deHis.Fecha >= Par_FechaIni
						AND deHis.Fecha <= Par_FechaFin
						AND deHis.CuentaCompleta >= Par_CuentaCompleta
						AND deHis.CuentaCompleta <= Par_CuentaCompFin
						AND deHis.CentroCostoID BETWEEN Par_PrimerCentroC AND Par_SegundoCentroC
						AND (Par_TipoInstrumento = Entero_Cero OR (deHis.TipoInstrumentoID = Par_TipoInstrumento))
						AND (Par_PrimerRango = Entero_Cero OR (deHis.Instrumento BETWEEN Par_PrimerRango AND Par_SegundoRango))
							ORDER BY Fecha,PolizaID;
		END IF;


		INSERT INTO TMPHISPOLIZA (
			EmpresaID ,			PolizaID,			Fecha,				CentroCostoID,				Cargos,
			Abonos,				Descripcion,		Instrumento,		TipoInstrumentoID,			CuentaCompleta,
			Consecutivo)
		SELECT
			deHis.EmpresaID,	deHis.PolizaID,		deHis.Fecha,		deHis. CentroCostoID,		deHis.Cargos,
			deHis.Abonos,		deHis.Descripcion,	deHis.Instrumento,	deHis.TipoInstrumentoID,	deHis.CuentaCompleta,
			(@Consecutivo:=@Consecutivo+1)
			FROM    DETALLEPOLIZA  deHis
				WHERE  deHis.Fecha >= Par_FechaIni
					AND deHis.Fecha <= Par_FechaFin
					AND deHis.CuentaCompleta >= Par_CuentaCompleta
					AND deHis.CuentaCompleta <= Par_CuentaCompFin
					AND deHis.CentroCostoID BETWEEN Par_PrimerCentroC AND Par_SegundoCentroC
					AND (Par_TipoInstrumento = Entero_Cero OR (deHis.TipoInstrumentoID = Par_TipoInstrumento))
					AND (Par_PrimerRango = Entero_Cero OR (deHis.Instrumento BETWEEN Par_PrimerRango AND Par_SegundoRango))
				ORDER BY Fecha,PolizaID;

		# Paso 4 Actualizando los saldos y poblando la tabla de detalle del reporte
		DROP TABLE IF EXISTS TMPDETALLEPOLIZAREP;
		CREATE TEMPORARY TABLE TMPDETALLEPOLIZAREP(
			EmpresaID			INT(11),
			Consecutivo			INT(11),
			Orden				INT(11),
			PolizaID			INT(11),
			Fecha				DATE,

			CentroCostoID		INT(11),
			CuentaCompleta		VARCHAR(50),
			NombreCuenta		VARCHAR(250),
			Cargos				DECIMAL(12,2),
			Abonos				DECIMAL(12,2),

			Descripcion			VARCHAR(400),
			Instrumento			VARCHAR(50),
			TipoInstrumentoID	INT(11),
			Saldo				DECIMAL(16,4),
			SaldoInicial 		DECIMAL(16,4),

            SaldoFinal			DECIMAL(16,4)
		);

		OPEN CURSORSALDOS;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				LOOP
					FETCH CURSORSALDOS into
						Var_EmpresaID,		Var_Consecutivo,	Var_Orden,				Var_PolizaID,			Var_Fecha,
						Var_CentroCostoID,	Var_CuentaCompleta,	Var_NombreCuenta,		Var_Cargos,				Var_Abonos,
						Var_Descripcion,	Var_Instrumento,	Var_TipoInstrumentoID,	Var_SaldoInicial,		Var_Naturaleza;
					BEGIN
						-- Inicializar las variables del cursor
						SET Var_Cargos			:= IFNULL(Var_Cargos, 0.0);
						SET Var_Abonos			:= IFNULL(Var_Abonos,0.0);
						SET Var_SaldoInicial	:= IFNULL(Var_SaldoInicial,0.0);
						SET Var_SaldoCalculado	:= IFNULL(Var_SaldoCalculado,0.0);

						IF(Var_CuentaCompleta != Var_CuentaCompletaAnt) THEN

                            UPDATE TMPDETALLEPOLIZAREP SET
                            SaldoFinal = Var_SaldoCalculado
                            WHERE CuentaCompleta = Var_CuentaCompletaAnt;
                            SET Var_CuentaCompletaAnt		:= Var_CuentaCompleta;
							SET Var_SaldoCalculado			:= Var_SaldoInicial;
						END IF;

						IF(Var_Naturaleza = 'D') THEN
							-- Calculo para cuentas de tipo DEUDORA
							SET Var_SaldoCalculado := Var_SaldoCalculado + Var_Cargos - Var_Abonos;
						  ELSE
							-- Calculo para cuentas de tipo Acredora
							SET Var_SaldoCalculado := Var_SaldoCalculado + Var_Abonos - Var_Cargos;
						END IF;

						INSERT INTO TMPDETALLEPOLIZAREP(
							EmpresaID,			Consecutivo,		Orden,					PolizaID,				Fecha,
							CentroCostoID,		CuentaCompleta,		NombreCuenta,			Cargos,					Abonos,
							Descripcion,		Instrumento,		TipoInstrumentoID,		Saldo,					SaldoInicial,
                            SaldoFinal)
						VALUES(
							Var_EmpresaID,		Var_Consecutivo,	Var_Orden,				Var_PolizaID,			Var_Fecha,
							Var_CentroCostoID,	Var_CuentaCompleta,	Var_NombreCuenta,		Var_Cargos,				Var_Abonos,
							Var_Descripcion,	Var_Instrumento,	Var_TipoInstrumentoID,	Var_SaldoCalculado,		Var_SaldoInicial,
                            Entero_Cero);

					END;

				End LOOP;
			END;
		CLOSE CURSORSALDOS;

        -- IF(Var_CuentaCompleta != Var_CuentaCompletaAnt) THEN
			SET Var_CuentaCompletaAnt		:= Var_CuentaCompleta;
			UPDATE TMPDETALLEPOLIZAREP SET
			SaldoFinal = Var_SaldoCalculado
			WHERE CuentaCompleta = Var_CuentaCompleta;
		-- END IF;

		SELECT
			EmpresaID,			PolizaID,				Fecha,
			CentroCostoID,		CuentaCompleta,		NombreCuenta,
            Cargos,					Abonos,
			Descripcion,		Instrumento,		Saldo,		SaldoInicial,
            SaldoFinal
		FROM TMPDETALLEPOLIZAREP;
	END ManejoErrores;

END TerminaStore$$