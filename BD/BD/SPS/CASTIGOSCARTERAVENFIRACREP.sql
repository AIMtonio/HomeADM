-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CASTIGOSCARTERAVENFIRACREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CASTIGOSCARTERAVENFIRACREP`;DELIMITER $$

CREATE PROCEDURE `CASTIGOSCARTERAVENFIRACREP`(
	/* Reporte de Cartera Vencida FIRA*/
	Par_Fecha						DATE,			# Fecha en la que se genera el reporte
	Par_Salida						CHAR(1),			# Tipo de Salida S. Si N. No
	INOUT	Par_NumErr				INT(11),			# Numero de Error
	INOUT	Par_ErrMen				VARCHAR(400),		# Mensaje de Error
	/* Parametros de Auditoria */
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),

	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(20)
)
TerminaStore: BEGIN
	# Declaracion de Variables
	DECLARE Var_FechaSis			DATE;				-- Fecha del sistema
	DECLARE Var_Control				VARCHAR(50);		-- Variable para el ID del control de pantalla
	DECLARE Var_FechaReporte		DATE;				-- Fecha en la que se generaReporte
	DECLARE Var_Fecha12MesesAtras	DATE;				-- Fecha 12 meses atras en la que se generaReporte
	DECLARE Var_Contador1			INT(11);			-- Contador
	# Declaracion de Constantes
	DECLARE Cons_No					CHAR(1);			-- Constantes No
	DECLARE Cons_SI					CHAR(1);			-- Constantes Si
	DECLARE Entero_Cero				INT(11);			-- Entero Cero
	DECLARE Mes12					INT(11);			-- Mes 12 (Diciembre)
	DECLARE Cadena_Vacia			VARCHAR(1);			-- Entero Cero
	DECLARE EsAgropecuarioCons		VARCHAR(1);			-- Es Credito Agropecuario
	DECLARE TipoFondeoFinanciado	VARCHAR(1);			-- Tipo de Fondeo Financiado
	DECLARE TipoReporte_CartVenc	INT(11);			-- ID CATREPORTESFIRA Cartera Vencida
	DECLARE Desc_CastigosCartVenc	VARCHAR(50);		-- Descripcion del grupo 1
	DECLARE Desc_CastigosCartVent	VARCHAR(50);		-- Descripcion del grupo 2
	DECLARE Desc_ConceptoMes12		VARCHAR(50);		-- Descripcion que aplica al mes 12 para el campo de concepto
	DECLARE Desc_ConceptoMesActual	VARCHAR(50);		-- Descripcion que aplica al mes actual para el campo de concepto

	# Asignacion de Constantes
	SET Entero_Cero					:= 0;
	SET TipoReporte_CartVenc		:= 4;
	SET Mes12 						:= 12;
	SET Desc_CastigosCartVenc		:= 'CASTIGOS DE CARTERA VENCIDA';
	SET Desc_CastigosCartVent		:= 'VENTA DE CARTERA VENCIDA';
	SET Desc_ConceptoMes12			:= 'ACUMULADA ULTIMOS 12 MESES';
	SET Desc_ConceptoMesActual		:= 'MES ACTUAL';
	SET Var_FechaReporte			:= Par_Fecha;
	SET Var_Fecha12MesesAtras		:= DATE_SUB(Var_FechaReporte, INTERVAL 12 MONTH);
	SET Var_Contador1				:= 1;

	DELETE FROM REPMONITOREOFIRA
			WHERE FechaGeneracion = Par_Fecha AND TipoReporteID = TipoReporte_CartVenc;

	DELETE FROM TMPCASTCARTVENFIRA WHERE Transaccion = Aud_NumTransaccion;
	SET lc_time_names := 'es_MX';

	/*Se llena la tabla temporal con los 12 meses hacia atrás con saldos en 0.*/
	WHILE (Var_FechaReporte > Var_Fecha12MesesAtras) DO
		-- Primer Grupo: ACUMULADA ULTIMOS 12 MESES
		IF(Var_Contador1 = 1) THEN
			INSERT INTO TMPCASTCARTVENFIRA(
				Transaccion,				Numero,						GrupoID,				Grupo,					MesNum,
				Anio,						Importe,					ImporteCalculado,

				Concepto,
				Mes,

				EmpresaID,					Usuario,					FechaActual,			DireccionIP,			ProgramaID,
				Sucursal,					NumTransaccion)
			  VALUES(
				Aud_NumTransaccion,			0,				1,						Desc_CastigosCartVenc,	MONTH(Var_FechaReporte),
				YEAR(Var_FechaReporte),		Entero_Cero,				Entero_Cero,
				Desc_ConceptoMes12,
				'',
				Aud_EmpresaID,				Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);
			INSERT INTO TMPCASTCARTVENFIRA(
				Transaccion,				Numero,						GrupoID,				Grupo,					MesNum,
				Anio,						Importe,					ImporteCalculado,
				Concepto,
				Mes,
				EmpresaID,					Usuario,					FechaActual,			DireccionIP,			ProgramaID,
				Sucursal,					NumTransaccion)
			  VALUES(
				Aud_NumTransaccion,			0,				2,						Desc_CastigosCartVent,	MONTH(Var_FechaReporte),
				YEAR(Var_FechaReporte),		Entero_Cero,				Entero_Cero,
				Desc_ConceptoMes12,
				'',
				Aud_EmpresaID,				Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);
		END IF;
		INSERT INTO TMPCASTCARTVENFIRA(
			Transaccion,				Numero,						GrupoID,				Grupo,					MesNum,
			Anio,						Importe,					ImporteCalculado,

			Concepto,
			Mes,

			EmpresaID,					Usuario,					FechaActual,			DireccionIP,			ProgramaID,
			Sucursal,					NumTransaccion)
		  VALUES(
			Aud_NumTransaccion,			Var_Contador1,				1,						Desc_CastigosCartVenc,	MONTH(Var_FechaReporte),
			YEAR(Var_FechaReporte),		Entero_Cero,				Entero_Cero,

			IF(Var_Contador1 = 1 ,Desc_ConceptoMesActual,CONCAT('MES-',(Var_Contador1-1))),
			CONCAT(CONCAT(UCASE(MID(MONTHNAME(Var_FechaReporte),1,1)),MID(MONTHNAME(Var_FechaReporte),2)),' de ',YEAR(Var_FechaReporte)),

			Aud_EmpresaID,				Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion);

		--  Segundo Grupo
		INSERT INTO TMPCASTCARTVENFIRA(
			Transaccion,				Numero,						GrupoID,				Grupo,					MesNum,
			Anio,						Importe,					ImporteCalculado,

			Concepto,
			Mes,

			EmpresaID,					Usuario,					FechaActual,			DireccionIP,			ProgramaID,
			Sucursal,					NumTransaccion)
		  VALUES(
			Aud_NumTransaccion,			Var_Contador1,				2,						Desc_CastigosCartVent,	MONTH(Var_FechaReporte),
			YEAR(Var_FechaReporte),		Entero_Cero,				Entero_Cero,

			IF(Var_Contador1 = 1 ,Desc_ConceptoMesActual,CONCAT('MES-',(Var_Contador1-1))),
			CONCAT(CONCAT(UCASE(MID(MONTHNAME(Var_FechaReporte),1,1)),MID(MONTHNAME(Var_FechaReporte),2)),' de ',YEAR(Var_FechaReporte)),

			Aud_EmpresaID,				Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion);


		SET Var_FechaReporte		:= DATE_SUB(Var_FechaReporte, INTERVAL 1 MONTH);
		SET Var_Contador1			:= Var_Contador1 + 1;
	END WHILE;

	DROP TABLE IF EXISTS TMPCRECASTIGOSFIRA;
	CREATE TABLE TMPCRECASTIGOSFIRA
	SELECT CreditoID,	Fecha,	MONTH(Fecha) AS MesFecha,	YEAR(Fecha) AS YearFecha,	TotalCastigo
	FROM CRECASTIGOS
		WHERE EstatusCredito ='B';

	/*Se llena el 3 grupo con los saldos de carte para que despues este grupo 3 se combine con el grupo 1*/
	SET @cont := 0;
	INSERT INTO TMPCASTCARTVENFIRA(
		Transaccion,			Numero,						GrupoID,				Grupo,							Concepto,
		MesNum,					Anio,
		Importe,
		ImporteCalculado,
		EmpresaID,				Usuario,					FechaActual,			DireccionIP,					ProgramaID,
		Sucursal,				NumTransaccion)
	  SELECT
		Aud_NumTransaccion,		@cont :=@cont+1,			3,						Desc_CastigosCartVenc,			'',
		CAS.MesFecha,			CAS.YearFecha,
		SUM(CAS.TotalCastigo) AS Importe,
		0 AS ImporteCalculado,
		Aud_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,				Aud_ProgramaID,
		Aud_Sucursal,			Aud_NumTransaccion
		FROM
			TMPCRECASTIGOSFIRA AS CAS INNER JOIN
			CREDITOS AS CRED ON CAS.CreditoID = CRED.CreditoID INNER JOIN
			TMPCASTCARTVENFIRA AS TMP ON TMP.MesNum = CAS.MesFecha AND TMP.Anio = CAS.YearFecha
				GROUP BY CAS.YearFecha,CAS.MesFecha
					ORDER BY CAS.YearFecha,CAS.MesFecha DESC;

	-- Se actualiza los saldos del grupo 1
	UPDATE TMPCASTCARTVENFIRA AS TMP INNER JOIN TMPCASTCARTVENFIRA AS TMP2 ON TMP.Transaccion = TMP2.Transaccion
			AND TMP.MesNum = TMP2.MesNum AND TMP.Anio = TMP2.Anio
			AND TMP.GrupoID = 1 AND TMP2.GrupoID = 3 SET
		TMP.Importe = TMP2.Importe,
		TMP.ImporteCalculado = TMP2.ImporteCalculado
		WHERE TMP.Transaccion = Aud_NumTransaccion
			AND TMP2.Transaccion = Aud_NumTransaccion
			AND TMP.GrupoID =1 AND TMP2.GrupoID = 3
			AND TMP.MesNum = TMP2.MesNum AND TMP.Anio = TMP2.Anio;

	UPDATE TMPCASTCARTVENFIRA AS TMP INNER JOIN (SELECT GrupoID,SUM(Importe) AS Total
												FROM TMPCASTCARTVENFIRA
												WHERE Transaccion = Aud_NumTransaccion GROUP BY GrupoID) AS TMP2 ON TMP.GrupoID = TMP2.GrupoID
												SET
		TMP.ImporteCalculado = TMP2.Total
		WHERE TMP.Numero = 0
		AND TMP.GrupoID = TMP2.GrupoID;
	-- Se elimina grupo 2
	DELETE FROM TMPCASTCARTVENFIRA WHERE Transaccion = Aud_NumTransaccion AND GrupoID = 3;


	/*Se inserta el contenido del reporte*/
	SET @cont := 0;
	INSERT INTO REPMONITOREOFIRA(
		TipoReporteID,				FechaGeneracion,				ConsecutivoID,
		CSVReporte,						EmpresaID,
		Usuario,					FechaActual,					DireccionIP,			ProgramaID,						Sucursal,
		NumTransaccion)
		SELECT
		TipoReporte_CartVenc,		Par_Fecha,						@cont,
		CONCAT_WS(',', '#','GRUPO', 'CONCEPTO', 'MES','IMPORTE', 'IMPORTE CALCULADO'),			Aud_EmpresaID,
		Aud_Usuario,				Aud_FechaActual,				Aud_DireccionIP,		Aud_ProgramaID,					Aud_Sucursal,
		Aud_NumTransaccion;



	INSERT INTO REPMONITOREOFIRA(
		TipoReporteID,				FechaGeneracion,				ConsecutivoID,
		CSVReporte,
		EmpresaID,
		Usuario,					FechaActual,					DireccionIP,			ProgramaID,						Sucursal,
		NumTransaccion)
		SELECT
		TipoReporte_CartVenc,		Par_Fecha,						@cont:=@cont+1,
		CONCAT_WS(',', @cont,TMP.Grupo,TMP.Concepto, TMP.Mes, TMP.Importe, TMP.ImporteCalculado),
		Aud_EmpresaID,
		Aud_Usuario,				Aud_FechaActual,				Aud_DireccionIP,		Aud_ProgramaID,					Aud_Sucursal,
		Aud_NumTransaccion
		FROM TMPCASTCARTVENFIRA AS TMP
			WHERE Transaccion = Aud_NumTransaccion
			ORDER BY GrupoID, Numero;

	DELETE FROM TMPCASTCARTVENFIRA WHERE Transaccion = Aud_NumTransaccion;

END TerminaStore$$