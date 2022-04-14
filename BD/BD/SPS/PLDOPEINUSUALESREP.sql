-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEINUSUALESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEINUSUALESREP`;
DELIMITER $$


CREATE PROCEDURE `PLDOPEINUSUALESREP`(
	/*SP PARA EL REPORTE DE OPERACIONES PLD*/
	Par_TipoReporte				TINYINT,			# Tipo de reporte
	Par_FechaInicio				DATE,				# Fecha de Inicio
	Par_FechaFinal				DATE,				# Fecha Final
	Par_Estatus					INT(11),			# Estatus de la Operacion
	Par_Periodo					VARCHAR(2),			# ID del mes 01: Enero, 02: Febrero ... 12: Diciembre

	Par_Operaciones				CHAR(1),			-- Operaciones de: C = CLIENTES, U = USUARIOS DE SERVICIOS, "" = TODOS
	Par_ClienteID				INT(11),			# ID de Cliente
	Par_UsuarioServicioID		INT(11),			-- ID de Usuario de Servicio
	/* Parametros de Auditoria */
	Aud_EmpresaID				INT(11),			# Auditoria
	Aud_Usuario					INT(11),			# Auditoria

	Aud_FechaActual				DATETIME,			# Auditoria
	Aud_DireccionIP				VARCHAR(15),		# Auditoria
	Aud_ProgramaID				VARCHAR(50),		# Auditoria
	Aud_Sucursal				INT(11),			# Auditoria
	Aud_NumTransaccion			BIGINT(20)			# Auditoria
)
TerminaStore: BEGIN

	# Declaracion de Variables
	DECLARE Var_FecIniMes           DATE;           	--  Almacena la fecha con el primer dia del mes
	DECLARE Var_FecFinMes           DATE;           	--  Almacena la fehca con el ultimo dia del mes
	DECLARE Var_MontoEvalua         DECIMAL(14,2);  	--  Monto parametrizado a evaluar
	DECLARE Var_FechaSis            DATE;           	--  Fecha del sistema
	DECLARE Var_MesID	            VARCHAR(2);        	--  ID del mes, comienza en 01 y termina hasta el 12.
	DECLARE Var_MonedaLimOPR		INT(11);			-- ID de la Moneda de parametros de operaciones relevantes.
	DECLARE Var_LimiteInferior		DECIMAL(14,2);		-- limite de parametros de operaciones relevantes.
	DECLARE Var_Sentencia			VARCHAR(5000);		-- SENTENCIA SQL PARA OBTENER LA INFORMACIÓN DEL REPORTE DE ACUERDO A LOS FILTROS.
	DECLARE Var_TipoMoneda			INT(11);			-- Tipo de Moneda
	DECLARE Var_ValMoneda  			DECIMAL(18,6);		-- Valor de la moneda
	DECLARE Var_DetectCargos		CHAR(1);

	# Declaracion de Constantes
	DECLARE TipoRepAlertas			INT(11);			-- Tipo reporte alertas inusuales.
	DECLARE TipoRepFracc			INT(11);			-- Tipo reporte operaciones fraccionadas.
	DECLARE TipoPers_CTE			VARCHAR(3);			-- Cliente
	DECLARE TipoPers_USU			VARCHAR(3);			-- Usuario de Servicios
	DECLARE TipoPers_AVA			VARCHAR(3);			-- Avales
	DECLARE TipoPers_PRO			VARCHAR(3);			-- Prospectos
	DECLARE TipoPers_REL			VARCHAR(3);			-- Relacionados de la cuenta (Que no son socios/clientes)
	DECLARE TipoPers_NA				VARCHAR(3);			-- No Aplica (cuando no se trata de Clientes ni de Usuarios)
	DECLARE TipoPers_PRV			VARCHAR(3);			-- Proveedores
	DECLARE DesTipoPers_CTE			VARCHAR(100);		-- Descripcion Cliente
	DECLARE DesTipoPers_USU			VARCHAR(100);		-- Descripcion Usuario de Servicios
	DECLARE DesTipoPers_AVA			VARCHAR(100);		-- Descripcion Avales
	DECLARE DesTipoPers_PRO			VARCHAR(100);		-- Descripcion Prospectos
	DECLARE DesTipoPers_REL			VARCHAR(100);		-- Descripcion Relacionados de la cuenta (Que no son socios/clientes)
	DECLARE DesTipoPers_NA			VARCHAR(100);		-- Descripcion No Aplica (cuando no se trata de Clientes ni de Usuarios)
	DECLARE DesTipoPers_PRV			VARCHAR(100);		-- Descripcion proveedores
	DECLARE Cons_No					CHAR(1);			-- Constantes No
	DECLARE Cons_SI					CHAR(1);			-- Constantes Si
	DECLARE Entero_Cero				INT(11);			-- Entero Cero
	DECLARE Decimal_Cero            DECIMAL(12,2);		-- Decimal cero
	DECLARE Cadena_Vacia			CHAR(1);			-- Cadena Vacia
	DECLARE Fecha_Vacia				DATE;				-- Fecha Vacia
	DECLARE Forma_Efectivo			CHAR(1);			-- Forma de Pago Efectivo
	DECLARE Forma_Transferencia		CHAR(1);			-- Forma de Pago Transferencias
	DECLARE Forma_Cheque			CHAR(1);			-- Forma de Pago Cheque
	DECLARE Forma_EfectivoDes		VARCHAR(20);		-- Forma de Pago Efectivo Descripcion
	DECLARE Forma_TransferenciaDes	VARCHAR(20);		-- Forma de Pago Transferencias Descripcion
	DECLARE Forma_ChequeDes			VARCHAR(20);		-- Forma de Pago Cheque Descripcion
	DECLARE DiaUnoDelMes            CHAR(2);        	-- Almaceba una constante con los digitos el dia 1 del mes
	DECLARE NaturalezaAbono			CHAR(1);        	-- Naturaleza Abono
	DECLARE TipoSumarizado			CHAR(1);        	-- Naturaleza Abono

	# Asignacion de Constantes
	SET TipoRepAlertas			:= 1;
	SET TipoRepFracc			:= 2;
	SET Entero_Cero				:= 0;
	SET Decimal_Cero			:= 0.0;
	SET TipoPers_CTE			:= 'CTE';
	SET TipoPers_USU			:= 'USU';
	SET TipoPers_AVA			:= 'AVA';
	SET TipoPers_PRO			:= 'PRO';
	SET TipoPers_REL			:= 'REL';
	SET TipoPers_NA				:= 'NA';
	SET TipoPers_PRV			:= 'PRV';
	SET DesTipoPers_CTE			:= 'safilocale.cliente';
	SET DesTipoPers_USU			:= 'Usuario de Servicios';
	SET DesTipoPers_AVA			:= 'Aval';
	SET DesTipoPers_PRO			:= 'Prospecto';
	SET DesTipoPers_REL			:= 'Relacionado de la cuenta';
	SET DesTipoPers_NA			:= 'No Aplica';
	SET DesTipoPers_PRV			:= 'Proveedor';
	SET Cons_No					:= 'N';
	SET Cons_SI					:= 'S';
	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia				:= '1900-01-01';
	SET Forma_Efectivo			:= 'E';
	SET Forma_Transferencia		:= 'T';
	SET Forma_Cheque			:= 'H';
	SET Forma_EfectivoDes		:= 'Efectivo';
	SET Forma_TransferenciaDes	:= 'Transferencia';
	SET Forma_ChequeDes			:= 'Cheque';
	SET DiaUnoDelMes    		:= '01';
	SET NaturalezaAbono    		:= 'A';
	SET TipoSumarizado			:= 'S';
	SET Var_DetectCargos 		:= FNPARAMGENERALES('EvaluaCargosFracPLD');
	SET Var_DetectCargos		:= IFNULL(Var_DetectCargos, Cons_No);

	-- REPORTE DE ALERTAS INUSUALES NO REPORTADAS
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=TipoRepAlertas)THEN
		TRUNCATE TEMPPLDOPEINUREP;
		INSERT INTO TEMPPLDOPEINUREP(
			Fecha,							OpeInusualID,				CatProcedIntID,				Desc_CatProcedInt,			CatMotivInuID,
			Desc_CatMotivInu,				FechaDeteccion,				SucursalID,					ClavePersonaInv,			NomPersonaInv,
			Frecuencia,						DesFrecuencia,				DesOperacion,				Estatus,					DescripcionEstatus,
			CreditoID,						CuentaAhoID,				NaturaOperacion,			MontoOperacion,				MonedaID,
			FolioInterno,					TipoOpeCNBV,				FormaPago,					TipoPersonaSAFI,			EmpresaID,
			Usuario,						FechaActual,				DireccionIP,				ProgramaID,					Sucursal,
			NumTransaccion)
			SELECT
			PLD.Fecha,						PLD.OpeInusualID,			PLD.CatProcedIntID,			PRO.Descripcion,			PLD.CatMotivInuID,
			MOT.DesCorta,					PLD.FechaDeteccion,			PLD.SucursalID,				PLD.ClavePersonaInv,		PLD.NomPersonaInv,
			PLD.Frecuencia,					PLD.DesFrecuencia,			PLD.DesOperacion,			PLD.Estatus,				EST.Descripcion,
			PLD.CreditoID,					PLD.CuentaAhoID,			PLD.NaturaOperacion,		PLD.MontoOperacion,			PLD.MonedaID,
			PLD.FolioInterno,				PLD.TipoOpeCNBV,			PLD.FormaPago,				IFNULL(PLD.TipoPersonaSAFI, Cadena_Vacia),		Aud_EmpresaID,
			Aud_Usuario,					Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,				Aud_Sucursal,
			Aud_NumTransaccion
			FROM
				PLDOPEINUSUALES AS PLD LEFT JOIN
				PLDCATMOTIVINU AS MOT ON PLD.CatMotivInuID = MOT.CatMotivInuID LEFT JOIN
				PLDCATPROCEDINT AS PRO ON PLD.CatProcedIntID = PRO.CatProcedIntID LEFT JOIN
				PLDCATEDOSPREO AS EST ON PLD.Estatus = EST.CatEdosPreoID
				WHERE
					PLD.FechaDeteccion BETWEEN Par_FechaInicio AND Par_FechaFinal;

		# Se Actualiza el ID Actividad BMX De los que son Clientes
		UPDATE TEMPPLDOPEINUREP AS TMP INNER JOIN CLIENTES AS CTE ON TMP.ClavePersonaInv = CTE.ClienteID SET
			TMP.ActividadBancoMX = CTE.ActividadBancoMX,
			TMP.FechaAlta = CTE.FechaAlta,
			TMP.NivelRiesgo = CTE.NivelRiesgo
			WHERE
				TipoPersonaSAFI = TipoPers_CTE;

		# Se actualiza la descripcion de la Actividad BMX
		UPDATE TEMPPLDOPEINUREP AS TMP INNER JOIN ACTIVIDADESBMX AS ACT ON TMP.ActividadBancoMX = ACT.ActividadBMXID SET
			TMP.ActividadBMXDesc = ACT.Descripcion
			WHERE
				TipoPersonaSAFI = TipoPers_CTE;

		# Se actualiza la descripcion de la Actividad BMX
		UPDATE TEMPPLDOPEINUREP AS TMP INNER JOIN MONEDAS AS ACT ON TMP.MonedaID = ACT.MonedaID SET
			TMP.EqCNBVUIF = ACT.EqCNBVUIF;

		SELECT
			Fecha,							OpeInusualID,			CatProcedIntID,			Desc_CatProcedInt,			CatMotivInuID,
			Desc_CatMotivInu,				FechaDeteccion,			SucursalID,				ClavePersonaInv,			NomPersonaInv,
			IF(Frecuencia=Cons_No,'NO',		IF(Frecuencia=Cons_SI,'SI',Cadena_Vacia)) AS Frecuencia,		DesFrecuencia,				DesOperacion,
			DescripcionEstatus AS Estatus,	DescripcionEstatus,		CreditoID,				CuentaAhoID,				CASE NaturaOperacion WHEN 'C' THEN 'CARGO'  WHEN 'A' THEN 'ABONO' ELSE 'SIN ESPECIFICAR' END AS NaturaOperacion ,
			FORMAT(MontoOperacion, 2) AS MontoOperacion,			MonedaID,				EqCNBVUIF,				FolioInterno,				TipoOpeCNBV,
			CASE FormaPago WHEN Forma_Efectivo THEN Forma_EfectivoDes
				WHEN Forma_Transferencia THEN Forma_TransferenciaDes
				WHEN Forma_Cheque THEN Forma_ChequeDes
				ELSE Cadena_Vacia END FormaPago,
			CASE TipoPersonaSAFI WHEN TipoPers_CTE THEN DesTipoPers_CTE
				WHEN TipoPers_REL THEN DesTipoPers_REL
				WHEN TipoPers_PRO THEN DesTipoPers_PRO
				WHEN TipoPers_AVA THEN DesTipoPers_AVA
				WHEN TipoPers_USU THEN DesTipoPers_USU
				WHEN TipoPers_PRV THEN DesTipoPers_PRV
				ELSE DesTipoPers_NA
			END AS TipoPersonaSAFI,		FechaAlta,
			ActividadBancoMX,			ActividadBMXDesc, CASE NivelRiesgo WHEN 'B' THEN 'BAJO'
			WHEN 'M' THEN 'MEDIO'
			WHEN 'A' THEN 'ALTO' ELSE Cadena_Vacia END NivelRiesgo
			FROM TEMPPLDOPEINUREP AS PLD LEFT JOIN PLDCATEDOSPREO EST ON PLD.Estatus = EST.Estatus
			WHERE Par_Estatus = Entero_Cero OR PLD.Estatus = Par_Estatus
			ORDER BY PLD.OpeInusualID;

		TRUNCATE TEMPPLDOPEINUREP;
	END IF;

	-- REPORTE DE OPERACIONES FRACCIONADAS PARA EVADIR EL REPORTE DE OP RELEVANTES.
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=TipoRepFracc)THEN

		# Se obtienen las fechas de inicio y de fin de acuerdo al periodo filtrado
		SET Var_MesID 			:= IFNULL(Par_Periodo,Cadena_Vacia);
		SET Var_FechaSis 		:= Par_FechaInicio;
		SET Var_FecIniMes		:= DATE(CONCAT(CAST(YEAR(Var_FechaSis) AS CHAR),'-',CAST(LPAD(MONTH(Var_FechaSis),2,'0') AS CHAR),'-',DiaUnoDelMes ));
		SET Var_FecFinMes		:= LAST_DAY(Var_FecIniMes);

		# Tabla Temporal que guarda todos los Abonos en Efectivo
		DROP TABLE IF EXISTS TMP_PLDDEPEFECTIVO;
		CREATE TABLE TMP_PLDDEPEFECTIVO (
			RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			NumeroMov   		BIGINT(20),
			ClienteID   		INT(11),
			CuentaAhoID 		BIGINT(12),
			Monto       		DECIMAL(18,2),
			DescripcionMov		VARCHAR(200),
			Fecha       		DATE,
			NatMovimiento		CHAR(1),
			TipoDetalle			CHAR(1),
			INDEX(NumeroMov,ClienteID,CuentaAhoID),
			INDEX(ClienteID,NatMovimiento),
			INDEX(ClienteID),
			INDEX(Monto)
		);

		# Tabla Temporal de paso, que guarda el total por cliente cuyas transacciones si superan el limite de op relevantes
		DROP TABLE IF EXISTS TMP_PLDDEPEFECTIVOMES;
		CREATE TABLE TMP_PLDDEPEFECTIVOMES (
			RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			NumeroMov   		BIGINT(20),
			ClienteID   		INT(11),
			MontoTotal     		DECIMAL(18,2),
			NatMovimiento		CHAR(1),
			INDEX(ClienteID,NatMovimiento),
			INDEX(ClienteID)
		);

		# Se obtiene el parámetro del histórico
		SELECT
			MonedaLimOPR,		LimiteInferior
		INTO
			Var_MonedaLimOPR,	Var_LimiteInferior
		FROM HISPARAMOPREL
			WHERE Var_FecFinMes BETWEEN FechaInicioVig AND FechaFinVig
				ORDER BY ConsecutivoID DESC LIMIT 1;

		# Sino existe, se obtiene de los parámetros actuales.
		IF(IFNULL(Var_MonedaLimOPR, Entero_Cero) = Entero_Cero)THEN
			SELECT
				MonedaLimOPR,		LimiteInferior
			INTO
				Var_MonedaLimOPR,	Var_LimiteInferior
			FROM PARAMETROSOPREL
				LIMIT 1;
		END IF;

		SET Var_MonedaLimOPR	:= IFNULL(Var_MonedaLimOPR, Entero_Cero);
		SET Var_LimiteInferior	:= IFNULL(Var_LimiteInferior, Entero_Cero);

		SET Var_ValMoneda := FNGETTIPOCAMBIO(Var_MonedaLimOPR, 1, Var_FecFinMes);

		SET Var_ValMoneda :=IFNULL(Var_ValMoneda, Entero_Cero);

		SET Var_MontoEvalua := ROUND((Var_LimiteInferior * Var_ValMoneda),2);
		SET Var_MontoEvalua   := ROUND(IFNULL(Var_MontoEvalua, Decimal_Cero),2);

		# Se obtienen todos los Abonos que se realizaron en Efectivo durante el mes en curso, por transaccion,
		SET Var_Sentencia := CONCAT(
			'INSERT INTO TMP_PLDDEPEFECTIVO ( ',
				'NumeroMov,			ClienteID,			CuentaAhoID,	DescripcionMov,		Fecha, ',
				'Monto, 			NatMovimiento,		TipoDetalle) ',
			'(SELECT ',
				'CM.NumeroMov,		C.ClienteID,		C.CuentaAhoID,	CM.DescripcionMov,	CM.Fecha, ',
				'CM.CantidadMov,	CM.NatMovimiento,	\'D\' ',
			'FROM CUENTASAHO C ',
				'INNER JOIN `CUENTASAHOMOV` CM ON C.CuentaAhoID=CM.CuentaAhoID ',
				'LEFT JOIN TIPOSMOVSAHO T ON CM.TipoMovAhoID=T.TipoMovAhoID ',
			'WHERE ',
				' CM.Fecha BETWEEN \'',Var_FecIniMes,'\' AND \'',Var_FecFinMes,'\' ',
				'AND T.EsEfectivo=\'',Cons_SI,'\' ');

		IF(IFNULL(Par_ClienteID,Entero_Cero)>Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'AND C.ClienteID = ',Par_ClienteID,' ');
		END IF;

			# SI NO SE DETECTA MOVIMIENTOS DE TIPO CARGO, SÓLO ABONOS.
		IF(Var_DetectCargos = Cons_No)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'AND CM.NatMovimiento = \'',NaturalezaAbono,'\' ');
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia, ') ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,
			'UNION ',
			'(SELECT ',
				'CM.NumeroMov,		C.ClienteID,		C.CuentaAhoID,		CM.DescripcionMov,	CM.Fecha, ',
				'CM.CantidadMov,	CM.NatMovimiento,	\'D\' ',
			'FROM CUENTASAHO C ',
				'INNER JOIN `HIS-CUENAHOMOV` CM ON C.CuentaAhoID=CM.CuentaAhoID ',
				'LEFT JOIN TIPOSMOVSAHO T ON CM.TipoMovAhoID=T.TipoMovAhoID ',
			'WHERE ',
				' CM.Fecha BETWEEN \'',Var_FecIniMes,'\' AND \'',Var_FecFinMes,'\' ',
				'AND T.EsEfectivo=\'',Cons_SI,'\' ');

		IF(IFNULL(Par_ClienteID,Entero_Cero)>Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'AND C.ClienteID = ',Par_ClienteID,' ');
		END IF;

		# SI NO SE DETECTA MOVIMIENTOS DE TIPO CARGO, SÓLO ABONOS.
		IF(Var_DetectCargos = Cons_No)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'AND CM.NatMovimiento = \'',NaturalezaAbono,'\' ');
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia, '); ');

		SET @Sentencia	:= (Var_Sentencia);

		PREPARE ST_REP_FRACCIONADAS_PLD FROM @Sentencia;
		EXECUTE ST_REP_FRACCIONADAS_PLD ;
		DEALLOCATE PREPARE ST_REP_FRACCIONADAS_PLD;

		#SE ELIMINAN AQUELLAS OPERACIONES QUE ESTAN POR ARRIBA DEL LÍMITE.
		DELETE FROM TMP_PLDDEPEFECTIVO
			WHERE Monto > Var_MontoEvalua;

		# Se obtiene la sumatoria por cliente de aquellas transacciones que no rebasen el limite de operaciones relevantes
		INSERT INTO TMP_PLDDEPEFECTIVOMES (
			ClienteID,	MontoTotal, NatMovimiento,	NumeroMov)
		SELECT
			ClienteID,	SUM(Monto), NatMovimiento,	(MAX(NumeroMov)+1)
		FROM TMP_PLDDEPEFECTIVO
			GROUP BY ClienteID , NatMovimiento
			HAVING SUM(Monto) > Var_MontoEvalua;

		# SE GUARDAN LOS DETALLES DE TIPO SUMA (SUMA DE TOTALES POR CLIENTE).
		INSERT INTO TMP_PLDDEPEFECTIVO(
			NumeroMov,		ClienteID,			CuentaAhoID,	DescripcionMov,		Fecha,
			Monto, 			NatMovimiento,		TipoDetalle)
		SELECT
			NumeroMov,		ClienteID,			Entero_Cero,	Cadena_Vacia,		Fecha_Vacia,
			MontoTotal, 	NatMovimiento,		TipoSumarizado
		FROM TMP_PLDDEPEFECTIVOMES;

		# Guarda los clientes con la suma total de sus depositos en efectivo durante el mes que si rebasan el limite de operaciones relevantes
		SELECT
			IF(TE.TipoDetalle = TipoSumarizado,Cadena_Vacia,Cli.ClienteID) AS ClienteID,
			IF(TE.TipoDetalle = TipoSumarizado,Cadena_Vacia,Cli.NombreCompleto) AS NombreCliente,
			IF(TE.TipoDetalle = TipoSumarizado,Cadena_Vacia,TE.CuentaAhoID) AS CuentaAhoID,
			IF(TE.TipoDetalle = TipoSumarizado,Cadena_Vacia,TE.NumeroMov) AS NumTransaccion,
			IF(TE.TipoDetalle = TipoSumarizado,'Total:',TE.DescripcionMov) AS DescripcionMov,
			TE.Monto,
			FORMAT(TM.MontoTotal,2) AS MontoTotal,
			IF(TE.TipoDetalle = TipoSumarizado,Cadena_Vacia,Fecha) AS FechaMov,
			TE.TipoDetalle,
			Var_MonedaLimOPR AS MonedaIDOpeRel,
			Var_LimiteInferior AS LimOpeRel,
			Var_ValMoneda AS CambioDof,
			Var_MontoEvalua AS MontoEvalua
			FROM TMP_PLDDEPEFECTIVO TE
				INNER JOIN TMP_PLDDEPEFECTIVOMES TM ON TE.ClienteID = TM.ClienteID
													AND TE.NatMovimiento = TM.NatMovimiento
				INNER JOIN CLIENTES Cli ON TE.ClienteID = Cli.ClienteID
			WHERE TM.MontoTotal > Var_MontoEvalua
		ORDER BY TE.ClienteID ASC, TE.NumeroMov ASC;

		DROP TABLE IF EXISTS TMP_PLDDEPEFECTIVO;
		DROP TABLE IF EXISTS TMP_PLDDEPEFECTIVOMES;
	END IF;

END TerminaStore$$