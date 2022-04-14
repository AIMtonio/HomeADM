-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDPERFILTRANSACCIONALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDPERFILTRANSACCIONALPRO`;
DELIMITER $$

CREATE PROCEDURE `PLDPERFILTRANSACCIONALPRO`(
    /*SP para realizar el proceso de la evalución del perfil transaccional real del cliente*/
	Par_Salida						CHAR(1),					# Indica el tipo de salida S.- SI N.- No

	INOUT Par_NumErr				INT,						# Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),				# Mensaje de Error
	/*Parametros de Auditoria*/
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,

	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(12)
	)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control					VARCHAR(50);				-- ID del Control en pantalla
	DECLARE Var_Consecutivo 			VARCHAR(200);				-- Numero consecutivo para la imagen a digitalizar
	DECLARE Var_ActPerfilTransOpeMas	CHAR(1);						-- Indica si se realiza la evaluacion masiva
	DECLARE Var_FechaSigEvalMasPerf		DATE;						-- Fecha de la siguiente Evaluacion masiva
	DECLARE Var_FechaSistema			DATE;
	DECLARE Var_FechaInicioEval			DATE;
	DECLARE Var_FechaBitacora			DATETIME;
	DECLARE Var_NumEvalPerfilTrans		INT(11);
	DECLARE Var_FrecuenciaMeses			INT(11);
	DECLARE Var_MinutosBit				INT(11);
	DECLARE Var_Hora					time;

	-- Declaracion de constantes
	DECLARE Pro_EvalPerfilPLD			INT(11);
	DECLARE Entero_Cero					INT(11);
	DECLARE Cons_SI						CHAR(1);
	DECLARE Cons_NO						CHAR(1);
	DECLARE Fecha_Vacia					DATE;

	-- Asignacion de constates
	SET Pro_EvalPerfilPLD			:= 506;		-- Proceso batch 506 Evaluacion de Perfil Transaccional
	SET Entero_Cero					:= 0;
	SET Cons_SI						:= 'S';
	SET Cons_NO						:= 'N';
	SET Fecha_Vacia					:= '1900-01-01';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr		:= 999;
			SET Par_ErrMen		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDPERFILTRANSACCIONALPRO');
			 SET Var_Control	:= 'sqlException' ;
		END;

		SELECT
			FechaSistema,		FrecuenciaMensPerf,			ActPerfilTransOpeMas,		NumEvalPerfilTrans,		FechaSigEvalMasPerf
			INTO
			Var_FechaSistema,	Var_FrecuenciaMeses,		Var_ActPerfilTransOpeMas,	Var_NumEvalPerfilTrans,	Var_FechaSigEvalMasPerf
			FROM PARAMETROSSIS;

		SET Var_ActPerfilTransOpeMas 	:= IFNULL(Var_ActPerfilTransOpeMas, Cons_NO);
		SET Var_NumEvalPerfilTrans		:= IFNULL(Var_NumEvalPerfilTrans,Entero_Cero);
		SET Var_FechaBitacora			:= NOW();
		SET Aud_FechaActual 			:= NOW();

		TRUNCATE TMPPLDPERFILTRANMOV;
		TRUNCATE TMPPLDPERFILTRANREAL;



			INSERT INTO TMPPLDPERFILTRANMOV(
				ClienteID,			NumeroMov,			Fecha,			NatMovimiento,			CantidadMov,
				Mes,				Anio)
				SELECT
					PLD.ClienteID,		MOV.NumeroMov,		MOV.Fecha,		MOV.NatMovimiento,		MOV.CantidadMov,
					MONTH(MOV.Fecha), YEAR(MOV.Fecha)
					FROM PLDPERFILTRANS AS PLD INNER JOIN
					CUENTASAHO AS CTA ON PLD.ClienteID = CTA.ClienteID INNER JOIN
					CUENTASAHOMOV AS MOV ON CTA.CuentaAhoID = MOV.CuentaAhoID INNER JOIN
					TIPOSMOVSAHO AS TIP ON MOV.TipoMovAhoID = TIP.TipoMovAhoID INNER JOIN
					CLIENTES AS CTE ON PLD.ClienteID = CTE.ClienteID
					WHERE
				CTE.Estatus='A' AND
				MOV.Fecha >= PLD.FechaIniPerf AND  MOV.Fecha<PLD.FechaSigPerf
				AND PLD.FechaSigPerf <= Var_FechaSistema
						AND TIP.DetecPLD='S'
					ORDER BY MOV.Fecha;

			INSERT INTO TMPPLDPERFILTRANMOV(
				ClienteID,			NumeroMov,			Fecha,			NatMovimiento,			CantidadMov,
				Mes,				Anio)
				SELECT
					PLD.ClienteID,		MOV.NumeroMov,		MOV.Fecha,		MOV.NatMovimiento,		MOV.CantidadMov,
					MONTH(MOV.Fecha), YEAR(MOV.Fecha)
					FROM PLDPERFILTRANS AS PLD INNER JOIN
					CUENTASAHO AS CTA ON PLD.ClienteID = CTA.ClienteID INNER JOIN
					`HIS-CUENAHOMOV` AS MOV ON CTA.CuentaAhoID = MOV.CuentaAhoID INNER JOIN
					TIPOSMOVSAHO AS TIP ON MOV.TipoMovAhoID = TIP.TipoMovAhoID INNER JOIN
					CLIENTES AS CTE ON PLD.ClienteID = CTE.ClienteID
					WHERE
				CTE.Estatus='A' AND
				MOV.Fecha >= PLD.FechaIniPerf AND  MOV.Fecha<PLD.FechaSigPerf
				AND PLD.FechaSigPerf <= Var_FechaSistema
						AND TIP.DetecPLD = 'S'
						ORDER BY MOV.Fecha;

		INSERT INTO TMPPLDPERFILTRANREAL (
			TransaccionID,			ClienteID,		TotalMonto,								NumMovimiento,		Mes,
			Anio,					Naturaleza)
		  SELECT
			Aud_NumTransaccion,		ClienteID,		SUM(IFNULL(CantidadMov,Entero_Cero)),	COUNT(ClienteID),	Mes,
			Anio,					'A'
			FROM TMPPLDPERFILTRANMOV AS TMP
				WHERE
					TMP.NatMovimiento = 'A'
					GROUP BY TMP.ClienteID, TMP.Anio, TMP.Mes;
					
		INSERT INTO TMPPLDPERFILTRANREAL (
			TransaccionID,			ClienteID,	TotalMonto,								NumMovimiento,		Mes,
			Anio,					Naturaleza
			)
		  SELECT
			Aud_NumTransaccion,		ClienteID,	SUM(IFNULL(CantidadMov,Entero_Cero)),	COUNT(ClienteID),	Mes,
			Anio,					'C'
			FROM TMPPLDPERFILTRANMOV AS TMP
				WHERE
					TMP.NatMovimiento = 'C'
					GROUP BY TMP.ClienteID, TMP.Anio, TMP.Mes;
					
		SET Var_Hora := CURRENT_TIME();
		
		IF(Var_FrecuenciaMeses=1) THEN
			INSERT IGNORE INTO PLDPERFILTRANSREAL(
				TransaccionID,									Fecha,									ClienteID,			DepositosMax,								RetirosMax,
				NumDepositos,									NumRetiros,								EmpresaID,			Usuario,									FechaActual,
				DireccionIP,									ProgramaID,								Sucursal,			NumTransaccion,								Hora
			)
			SELECT
				Aud_NumTransaccion,								PLD.FechaSigPerf,						PLD.ClienteID,		SUM(IFNULL(DEP.TotalMonto,Entero_Cero)),	Entero_Cero,
				SUM(IFNULL(DEP.NumMovimiento,Entero_Cero)),		Entero_Cero,							Aud_EmpresaID,		Aud_Usuario,								Aud_FechaActual,
				Aud_DireccionIP,								Aud_ProgramaID,							Aud_Sucursal,		Aud_NumTransaccion,							Var_Hora
				FROM
					PLDPERFILTRANS AS PLD INNER JOIN
                    CLIENTES AS CTE ON PLD.ClienteID = CTE.ClienteID LEFT JOIN
					TMPPLDPERFILTRANREAL AS DEP ON PLD.ClienteID = DEP.ClienteID AND DEP.Naturaleza = 'A'
					WHERE
						CTE.Estatus='A' AND
						PLD.FechaSigPerf <= Var_FechaSistema
						GROUP BY PLD.ClienteID;

			DROP TABLE IF EXISTS TMPPERFILTRANSOLORETIROS;
			CREATE TEMPORARY TABLE TMPPERFILTRANSOLORETIROS
				SELECT
				Aud_NumTransaccion,			PLD.ClienteID,		SUM(IFNULL(DEP.TotalMonto,Entero_Cero)) AS MontoRetiros, 	SUM(IFNULL(DEP.NumMovimiento,Entero_Cero)) AS NumRetiros
				FROM
					PLDPERFILTRANS AS PLD INNER JOIN
                    CLIENTES AS CTE ON PLD.ClienteID = CTE.ClienteID LEFT JOIN
					TMPPLDPERFILTRANREAL AS DEP ON PLD.ClienteID = DEP.ClienteID AND DEP.Naturaleza = 'C'
					WHERE
						CTE.Estatus='A' AND
						PLD.FechaSigPerf <= Var_FechaSistema
						GROUP BY PLD.ClienteID;
						
            
			ALTER TABLE `TMPPERFILTRANSOLORETIROS`
				ADD COLUMN `RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY FIRST;

			create index IDX_TMPPERFILTRANSOLORETIROS_01 on  TMPPERFILTRANSOLORETIROS(Aud_NumTransaccion,ClienteID);
			
			UPDATE PLDPERFILTRANSREAL AS REA INNER JOIN
				TMPPERFILTRANSOLORETIROS AS PLD ON REA.ClienteID = PLD.ClienteID SET
				REA.RetirosMax		= PLD.MontoRetiros,
				REA.NumRetiros		= PLD.NumRetiros
				WHERE
					REA.TransaccionID = Aud_NumTransaccion
					AND REA.ClienteID = PLD.ClienteID;
		  ELSE
			INSERT IGNORE INTO PLDPERFILTRANSREAL(
				TransaccionID,									Fecha,						ClienteID,			DepositosMax,								RetirosMax,
				NumDepositos,									NumRetiros,					EmpresaID,			Usuario,									FechaActual,
				DireccionIP,									ProgramaID,					Sucursal,			NumTransaccion,								Hora
			)
			SELECT
				Aud_NumTransaccion,								PLD.FechaSigPerf,			PLD.ClienteID,		AVG(IFNULL(DEP.TotalMonto,Entero_Cero)),	Entero_Cero,
				AVG(IFNULL(DEP.NumMovimiento,Entero_Cero)),		Entero_Cero,				Aud_EmpresaID,		Aud_Usuario,								Aud_FechaActual,
				Aud_DireccionIP,								Aud_ProgramaID,				Aud_Sucursal,		Aud_NumTransaccion,							Var_Hora
				FROM
					PLDPERFILTRANS AS PLD INNER JOIN
                    CLIENTES AS CTE ON PLD.ClienteID = CTE.ClienteID LEFT JOIN
					TMPPLDPERFILTRANREAL AS DEP ON PLD.ClienteID = DEP.ClienteID AND DEP.Naturaleza = 'A'
					WHERE
						CTE.Estatus='A' AND
						PLD.FechaSigPerf <= Var_FechaSistema
						GROUP BY PLD.ClienteID;
						
			DROP TABLE IF EXISTS TMPPERFILTRANSOLORETIROS;
			CREATE TEMPORARY TABLE TMPPERFILTRANSOLORETIROS
				SELECT
				Aud_NumTransaccion,			PLD.ClienteID,		SUM(IFNULL(DEP.TotalMonto,Entero_Cero)) AS MontoRetiros, 	SUM(IFNULL(DEP.NumMovimiento,Entero_Cero)) AS NumRetiros
				FROM
					PLDPERFILTRANS AS PLD INNER JOIN
                    CLIENTES AS CTE ON PLD.ClienteID = CTE.ClienteID LEFT JOIN
					TMPPLDPERFILTRANREAL AS DEP ON PLD.ClienteID = DEP.ClienteID AND DEP.Naturaleza = 'C'
					WHERE
						CTE.Estatus='A' AND
						PLD.FechaSigPerf <= Var_FechaSistema
						GROUP BY PLD.ClienteID;

			ALTER TABLE `TMPPERFILTRANSOLORETIROS`
				ADD COLUMN `RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY FIRST;
						
			create index IDX_TMPPERFILTRANSOLORETIROS_01 on  TMPPERFILTRANSOLORETIROS(Aud_NumTransaccion,ClienteID);
			
			UPDATE PLDPERFILTRANSREAL AS REA INNER JOIN
				TMPPERFILTRANSOLORETIROS AS PLD ON REA.ClienteID = PLD.ClienteID SET
				REA.RetirosMax		= PLD.MontoRetiros,
				REA.NumRetiros		= PLD.NumRetiros
				WHERE
					REA.TransaccionID = Aud_NumTransaccion
					AND REA.ClienteID = PLD.ClienteID;
		END IF;

		UPDATE PLDPERFILTRANSREAL AS REA
			INNER JOIN PLDPERFILTRANS AS PLD ON REA.ClienteID = PLD.ClienteID
			INNER JOIN CLIENTES AS CTE ON REA.ClienteID = CTE.ClienteID SET
			REA.FechaInicio		= PLD.FechaIniPerf,
			REA.FechaFin		= PLD.FechaSigPerf,
			REA.AntDepositosMax = PLD.DepositosMax,
			REA.AntRetirosMax = PLD.RetirosMax,
			REA.AntNumRetiros = PLD.NumRetiros,
			REA.AntNumDepositos = PLD.NumDepositos,
			REA.NivelRiesgo		= CTE.NivelRiesgo,
			REA.TipoEval		= 'P'
			WHERE
				REA.TransaccionID = Aud_NumTransaccion
				AND REA.ClienteID = CTE.ClienteID;
				
		UPDATE PLDPERFILTRANS AS PLD SET
			PLD.FechaIniPerf = FechaSigPerf,
			PLD.FechaSigPerf = FNSUMMESFECHA(FechaSigPerf,Var_FrecuenciaMeses),
			PLD.FechaActual  = NOW(),
			PLD.ProgramaID = 'PLDPERFILTRANSACCIONALPRO',
			PLD.NumTransaccion = Aud_NumTransaccion
			WHERE PLD.FechaSigPerf <= Var_FechaSistema;
			
		TRUNCATE TMPPLDPERFILTRANMOV;
		TRUNCATE TMPPLDPERFILTRANREAL;
		
		IF(Var_ActPerfilTransOpeMas = Cons_SI AND Var_FechaSigEvalMasPerf<=Var_FechaSistema) THEN
			SET Var_FechaInicioEval 	:= date_add(date_add(LAST_DAY(Var_FechaSigEvalMasPerf),interval 1 DAY),interval -1 MONTH);
			SET Var_FechaSigEvalMasPerf := LAST_DAY(Var_FechaSigEvalMasPerf);
			
			INSERT INTO TMPPLDPERFILTRANMOV(
				ClienteID,			NumeroMov,			Fecha,			NatMovimiento,			CantidadMov,
				Mes,				Anio)
				SELECT
					PLD.ClienteID,		MOV.NumeroMov,		MOV.Fecha,		MOV.NatMovimiento,		MOV.CantidadMov,
					MONTH(MOV.Fecha), YEAR(MOV.Fecha)
					FROM PLDPERFILTRANS AS PLD INNER JOIN
					CUENTASAHO AS CTA ON PLD.ClienteID = CTA.ClienteID INNER JOIN
					CUENTASAHOMOV AS MOV ON CTA.CuentaAhoID = MOV.CuentaAhoID INNER JOIN
					TIPOSMOVSAHO AS TIP ON MOV.TipoMovAhoID = TIP.TipoMovAhoID INNER JOIN
					CLIENTES AS CTE ON PLD.ClienteID = CTE.ClienteID
					WHERE
						CTE.Estatus='A' AND
						MOV.Fecha >= Var_FechaInicioEval AND  MOV.Fecha<=Var_FechaSigEvalMasPerf
						AND TIP.DetecPLD='S'
						ORDER BY MOV.Fecha;

			INSERT INTO TMPPLDPERFILTRANMOV(
				ClienteID,			NumeroMov,			Fecha,			NatMovimiento,			CantidadMov,
				Mes,				Anio)
				SELECT
					PLD.ClienteID,		MOV.NumeroMov,		MOV.Fecha,		MOV.NatMovimiento,		MOV.CantidadMov,
					MONTH(MOV.Fecha), YEAR(MOV.Fecha)
					FROM PLDPERFILTRANS AS PLD INNER JOIN
					CUENTASAHO AS CTA ON PLD.ClienteID = CTA.ClienteID INNER JOIN
					`HIS-CUENAHOMOV` AS MOV ON CTA.CuentaAhoID = MOV.CuentaAhoID INNER JOIN
					TIPOSMOVSAHO AS TIP ON MOV.TipoMovAhoID = TIP.TipoMovAhoID INNER JOIN
					CLIENTES AS CTE ON PLD.ClienteID = CTE.ClienteID
					WHERE
						CTE.Estatus='A' AND
						MOV.Fecha >= Var_FechaInicioEval AND  MOV.Fecha<=Var_FechaSigEvalMasPerf
						AND TIP.DetecPLD = 'S'
						ORDER BY MOV.Fecha;


		# Depositos
		INSERT INTO TMPPLDPERFILTRANREAL (
			TransaccionID,			ClienteID,	TotalMonto,			NumMovimiento,		Mes,
			Anio,					Naturaleza
			)
		  SELECT
				Aud_NumTransaccion,				ClienteID,			SUM(IFNULL(CantidadMov,Entero_Cero)),		COUNT(ClienteID),	Mes,
			Anio,					'A'
			FROM TMPPLDPERFILTRANMOV AS TMP
				WHERE
					TMP.NatMovimiento = 'A'
					GROUP BY TMP.ClienteID, TMP.Anio, TMP.Mes;

		# Retiros
		INSERT INTO TMPPLDPERFILTRANREAL (
			TransaccionID,			ClienteID,	TotalMonto,			NumMovimiento,		Mes,
			Anio,					Naturaleza
			)
		  SELECT
				Aud_NumTransaccion,		ClienteID,		SUM(IFNULL(CantidadMov,Entero_Cero)),		COUNT(ClienteID),	Mes,
			Anio,					'C'
			FROM TMPPLDPERFILTRANMOV AS TMP
				WHERE
					TMP.NatMovimiento = 'C'
					GROUP BY TMP.ClienteID, TMP.Anio, TMP.Mes;


		SET Var_Hora := CURRENT_TIME();


			IF(Var_FrecuenciaMeses=1) THEN
				INSERT IGNORE INTO PLDPERFILTRANSREAL(
				TransaccionID,			Fecha,					ClienteID,			DepositosMax,		RetirosMax,
				NumDepositos,			NumRetiros,				EmpresaID,			Usuario,			FechaActual,
					DireccionIP,									ProgramaID,						Sucursal,			NumTransaccion,								Hora,
					TipoEval
			)
			SELECT
					Aud_NumTransaccion,								Var_FechaSigEvalMasPerf,		PLD.ClienteID,		SUM(IFNULL(DEP.TotalMonto,Entero_Cero)),	Entero_Cero,
					SUM(IFNULL(DEP.NumMovimiento,Entero_Cero)),		Entero_Cero,					Aud_EmpresaID,		Aud_Usuario,								Aud_FechaActual,
					Aud_DireccionIP,								Aud_ProgramaID,					Aud_Sucursal,		Aud_NumTransaccion,							Var_Hora,
					'M'
				FROM
						PLDPERFILTRANS AS PLD INNER JOIN
						CLIENTES AS CTE ON PLD.ClienteID = CTE.ClienteID LEFT JOIN
						TMPPLDPERFILTRANREAL AS DEP ON PLD.ClienteID = DEP.ClienteID AND DEP.Naturaleza = 'A'
						WHERE CTE.Estatus='A'
						GROUP BY PLD.ClienteID;
						
				DROP TABLE IF EXISTS TMPPERFILTRANSOLORETIROS;
				CREATE TEMPORARY TABLE TMPPERFILTRANSOLORETIROS
					SELECT
					Aud_NumTransaccion,			PLD.ClienteID,		SUM(IFNULL(DEP.TotalMonto,Entero_Cero)) AS MontoRetiros, 	SUM(IFNULL(DEP.NumMovimiento,Entero_Cero)) NumRetiros
					FROM
						PLDPERFILTRANS AS PLD INNER JOIN
						CLIENTES AS CTE ON PLD.ClienteID = CTE.ClienteID LEFT JOIN
						TMPPLDPERFILTRANREAL AS DEP ON PLD.ClienteID = DEP.ClienteID AND DEP.Naturaleza = 'C'
						WHERE CTE.Estatus='A'  AND
							PLD.FechaSigPerf <= Var_FechaSistema
						GROUP BY PLD.ClienteID;

			ALTER TABLE `TMPPERFILTRANSOLORETIROS`
				ADD COLUMN `RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY FIRST;
						
				create index IDX_TMPPERFILTRANSOLORETIROS_01 on  TMPPERFILTRANSOLORETIROS(Aud_NumTransaccion,ClienteID);
				
				UPDATE PLDPERFILTRANSREAL AS REA INNER JOIN
					TMPPERFILTRANSOLORETIROS AS PLD ON REA.ClienteID = PLD.ClienteID SET
					REA.RetirosMax		= PLD.MontoRetiros,
					REA.NumRetiros		= PLD.NumRetiros
					WHERE
						REA.TransaccionID = Aud_NumTransaccion
						AND REA.ClienteID = PLD.ClienteID;
		  ELSE
				INSERT IGNORE INTO PLDPERFILTRANSREAL(
				TransaccionID,			Fecha,					ClienteID,			DepositosMax,		RetirosMax,
				NumDepositos,			NumRetiros,				EmpresaID,			Usuario,			FechaActual,
					DireccionIP,							ProgramaID,					Sucursal,			NumTransaccion,				Hora,
					TipoEval
			)			
			SELECT
					Aud_NumTransaccion,								Var_FechaSigEvalMasPerf,				PLD.ClienteID,		AVG(IFNULL(DEP.TotalMonto,Entero_Cero)),	Entero_Cero,
					AVG(IFNULL(DEP.NumMovimiento,Entero_Cero)),		Entero_Cero,							Aud_EmpresaID,		Aud_Usuario,								Aud_FechaActual,
					Aud_DireccionIP,								Aud_ProgramaID,							Aud_Sucursal,		Aud_NumTransaccion,							Var_Hora,
					'M'
				FROM
						PLDPERFILTRANS AS PLD INNER JOIN
						CLIENTES AS CTE ON PLD.ClienteID = CTE.ClienteID LEFT JOIN
						TMPPLDPERFILTRANREAL AS DEP ON PLD.ClienteID = DEP.ClienteID AND DEP.Naturaleza = 'A'
						WHERE CTE.Estatus='A'
						GROUP BY PLD.ClienteID;

				DROP TABLE IF EXISTS TMPPERFILTRANSOLORETIROS;
				CREATE TEMPORARY TABLE TMPPERFILTRANSOLORETIROS
					SELECT
					Aud_NumTransaccion,			PLD.ClienteID,		SUM(IFNULL(DEP.TotalMonto,Entero_Cero)) AS MontoRetiros, 	SUM(IFNULL(DEP.NumMovimiento,Entero_Cero)) NumRetiros
					FROM
						PLDPERFILTRANS AS PLD INNER JOIN
						CLIENTES AS CTE ON PLD.ClienteID = CTE.ClienteID LEFT JOIN
						TMPPLDPERFILTRANREAL AS DEP ON PLD.ClienteID = DEP.ClienteID AND DEP.Naturaleza = 'C'
						WHERE CTE.Estatus='A'  AND
						PLD.FechaSigPerf <= Var_FechaSistema
						GROUP BY PLD.ClienteID;

			ALTER TABLE `TMPPERFILTRANSOLORETIROS`
				ADD COLUMN `RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY FIRST;
						
				create index IDX_TMPPERFILTRANSOLORETIROS_01 on  TMPPERFILTRANSOLORETIROS(Aud_NumTransaccion,ClienteID);
				
				UPDATE PLDPERFILTRANSREAL AS REA INNER JOIN
					TMPPERFILTRANSOLORETIROS AS PLD ON REA.ClienteID = PLD.ClienteID SET
					REA.RetirosMax		= PLD.MontoRetiros,
					REA.NumRetiros		= PLD.NumRetiros
					WHERE
						REA.TransaccionID = Aud_NumTransaccion
						AND REA.ClienteID = PLD.ClienteID;
		END IF;


			UPDATE PLDPERFILTRANSREAL AS REA INNER JOIN
				PLDPERFILTRANS AS PLD ON REA.ClienteID = PLD.ClienteID INNER JOIN
                CLIENTES AS CTE ON REA.ClienteID = CTE.ClienteID SET
				REA.FechaInicio			= Var_FechaInicioEval,
				REA.FechaFin			= Var_FechaSigEvalMasPerf,
			REA.AntDepositosMax = PLD.DepositosMax,
			REA.AntRetirosMax = PLD.RetirosMax,
			REA.AntNumRetiros = PLD.NumRetiros,
			REA.AntNumDepositos = PLD.NumDepositos,
			REA.NivelRiesgo		= CTE.NivelRiesgo
				WHERE
					REA.TransaccionID = Aud_NumTransaccion
					AND REA.ClienteID = CTE.ClienteID
					AND REA.TipoEval = 'M';

			SET Var_FechaSigEvalMasPerf	:= DATE_ADD(Var_FechaSistema, INTERVAL Var_NumEvalPerfilTrans MONTH);
			-- SE OBTIENE LA ULTIMA FECHA, DE LA FECHA CALCULADA
			SET Var_FechaSigEvalMasPerf	:= LAST_DAY(Var_FechaSigEvalMasPerf);
			-- SE CALCULA UN DIA HÁBIL ANTERIOR A LA FECHA CALCULADA PARA QUE SE EJECUTE JUSTO EN EL CIERRE DE MES.
			CALL DIASFESTIVOSCAL(
				Var_FechaSigEvalMasPerf,	(1 * -1),			Var_FechaSigEvalMasPerf,		Cons_SI,		Aud_EmpresaID,
				Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,				Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			UPDATE PARAMETROSSIS SET
				FechaSigEvalMasPerf 	= Var_FechaSigEvalMasPerf,

				Usuario					= Aud_Usuario,
				FechaActual             = Aud_FechaActual,
				DireccionIP             = Aud_DireccionIP,
				ProgramaID              = Aud_ProgramaID,
				Sucursal                = Aud_Sucursal,
				NumTransaccion          = Aud_NumTransaccion
			WHERE EmpresaID     = Aud_EmpresaID;
		END IF;

		TRUNCATE TMPPLDPERFILTRANMOV;
		TRUNCATE TMPPLDPERFILTRANREAL;

		SET Var_MinutosBit 		:= TIMESTAMPDIFF(MINUTE, Var_FechaBitacora, NOW());
		SET Aud_FechaActual		:= NOW();

		IF(EXISTS(SELECT ProcesoBatchID FROM BITACORABATCH WHERE ProcesoBatchID = Pro_EvalPerfilPLD AND Fecha = Var_FechaSistema))THEN
			DELETE FROM BITACORABATCH
				WHERE ProcesoBatchID = Pro_EvalPerfilPLD AND Fecha = Var_FechaSistema;
		END IF;

		CALL BITACORABATCHALT(
			Pro_EvalPerfilPLD,	Var_FechaSistema,		Var_MinutosBit,		Aud_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Proceso Exitoso';
	END ManejoErrores;

	IF(Par_Salida = 'S') THEN
		SELECT 	Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
		Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$
