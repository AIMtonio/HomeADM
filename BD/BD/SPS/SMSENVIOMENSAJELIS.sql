-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSENVIOMENSAJELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSENVIOMENSAJELIS`;DELIMITER $$

CREATE PROCEDURE `SMSENVIOMENSAJELIS`(
# ===============================================
# ------ SP PARA LISTAR MENSAJES POR ENVIAR------
# ===============================================
	Par_Campania 		INT(11),
    Par_Estatus			CHAR(2),
    Par_FechaCon		DATE,
	Par_PIDTarea		VARCHAR(50),		-- Identificador del hilo de ejecucion de la tarea
	Par_NumLis			TINYINT UNSIGNED,

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE	Lis_Principal	INT;
	DECLARE	Lis_Resumen		INT;
	DECLARE	Lis_EnvioModem	INT;
    DECLARE	Lis_MenEnv		INT;
    DECLARE	Lis_MenNoEnv	INT;
    DECLARE	Lis_MenCan  	INT;
    DECLARE Lis_PorEnviar	INT(11);														-- Lista de mensajes pendientes de enviar
	DECLARE	DecimalCien		DECIMAL(12,4);

	-- Constantes de codigos de exito o fallo de sms
	DECLARE	CodigoExito		CHAR(1);
	DECLARE	CodigoFallido	CHAR(1);
	DECLARE	CodigoDescon	CHAR(1);
	DECLARE	DescripExito	VARCHAR(50);
	DECLARE	DescripFallido	VARCHAR(50);
	DECLARE	DescripDescon	VARCHAR(70);
	DECLARE	DescripEncol	VARCHAR(50);
	DECLARE	EstatusNoEnv	CHAR(1);
    DECLARE	EstatusEnv		CHAR(1);
    DECLARE	EstatusCan		CHAR(1);
	DECLARE	Est_Proceso		CHAR(1);														-- Estatus en proceso

	-- Declaracion de Variables
	DECLARE	Var_NumeroEnv	INT;
	DECLARE	Var_Porcentaje	DOUBLE;
	DECLARE	Var_Program		INT;
	DECLARE	Fecha_Act		DATETIME;
	DECLARE	Var_TotalEnv	INT;
	DECLARE	Var_Encolados	INT;

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Lis_Principal		:= 1;
	SET	Lis_Resumen			:= 2;
	SET	Lis_EnvioModem		:= 3;
    SET	Lis_MenEnv			:= 4;
    SET Lis_MenNoEnv		:= 5;
    SET Lis_MenCan  		:= 6;
    SET Lis_PorEnviar		:= 7;															-- Lista de mensajes pendientes de enviar
	SET	CodigoExito			:= 'E';
	SET	CodigoFallido		:= 'F';
	SET	CodigoDescon		:= 'D';
	SET	DescripExito		:= 'EXITO ';
	SET	DescripFallido		:= 'FALLIDOS (Por saldo Insuficiente en el módem)';
	SET	DescripDescon		:= 'DESCONOCIDOS (El Número no fue encontrado o no existe)';
	SET	DescripEncol		:= 'ENCOLADOS';
	SET EstatusNoEnv		:= 'N';
    SET EstatusEnv			:= 'E';
    SET EstatusCan			:= 'C';
    SET Est_Proceso			:= 'P';															-- Estatus en proceso
	SET DecimalCien			:= 100.00;

	-- Lista de Resumen de Actividad SMS
	IF(Par_NumLis = Lis_Resumen) THEN

	IF(Par_NumLis = Lis_Resumen) THEN

		SET Fecha_Act :=  CURRENT_TIMESTAMP();
		SET Var_NumeroEnv := 0;
		SET Var_Program := (SELECT COUNT(EnvioID)
								FROM 	SMSENVIOMENSAJE
								WHERE 	CampaniaID = Par_Campania
								AND 	FechaProgEnvio >= Fecha_Act
								AND 	Estatus	= EstatusNoEnv);





				DROP TEMPORARY TABLE IF EXISTS TMPESTADISTICAS;
				CREATE TEMPORARY TABLE TMPESTADISTICAS
											(	Estatus		VARCHAR(70),
												Total 		INT,
												Porcentaje	DOUBLE);

				DROP TEMPORARY TABLE IF EXISTS TMPESTADISTICASTEMP;
				CREATE TEMPORARY TABLE TMPESTADISTICASTEMP
											(	EnvioID		INT(11),
												CodExitoErr	VARCHAR(70),
												CampaniaID	INT(11),
												PRIMARY KEY(EnvioID),
												KEY `INDEX_TMPESTADISTICASTEMP_1` (`CampaniaID`)
												);

				INSERT INTO TMPESTADISTICASTEMP (EnvioID,	CodExitoErr,	CampaniaID)
												SELECT EnvioID, 	CodExitoErr,	CampaniaID
														FROM 	SMSENVIOMENSAJE
												UNION
												SELECT EnvioID, 	CodExitoErr,	CampaniaID
														FROM 	HISSMSENVIOMENSAJE;

				SET Var_TotalEnv	:= (SELECT COUNT(EnvioID)
								FROM TMPESTADISTICASTEMP
								WHERE CampaniaID = Par_Campania);


				INSERT INTO TMPESTADISTICAS (
												Estatus,		Total,		Porcentaje)
												SELECT (CASE CodExitoErr
																WHEN  CodigoExito  		THEN DescripExito
																WHEN  CodigoFallido  	THEN DescripFallido
																WHEN  CodigoDescon  	THEN DescripDescon
																WHEN  ''  	THEN DescripEncol
																END),
														IFNULL(COUNT(EnvioID),Entero_Cero) AS numEnvio,
														FORMAT(IFNULL(COUNT(EnvioID),Entero_Cero)/(Var_TotalEnv/DecimalCien),2) AS porcentaje
														FROM 	TMPESTADISTICASTEMP
														WHERE	CampaniaID = Par_Campania GROUP BY CodExitoErr;

			DROP TEMPORARY TABLE IF EXISTS TMPESTADISTICASTEMP;
			UPDATE TMPESTADISTICAS SET
			Total = (Total- Var_Program),
			Porcentaje =Total/(Var_TotalEnv/DecimalCien)
			WHERE Estatus = DescripEncol;


			IF NOT EXISTS(SELECT Estatus FROM TMPESTADISTICAS WHERE Estatus = DescripExito )THEN

					INSERT INTO TMPESTADISTICAS (Estatus,			Total,			Porcentaje)
										VALUES
											(DescripExito,				Entero_Cero,	Entero_Cero);

			END IF;

			IF NOT EXISTS(SELECT Estatus FROM TMPESTADISTICAS WHERE Estatus = DescripFallido )THEN

					INSERT INTO TMPESTADISTICAS (Estatus,			Total,			Porcentaje)
										VALUES
											(DescripFallido,				Entero_Cero,	Entero_Cero);

			END IF;

			IF NOT EXISTS(SELECT Estatus FROM TMPESTADISTICAS WHERE Estatus = DescripDescon )THEN

					INSERT INTO TMPESTADISTICAS (Estatus,			Total,			Porcentaje)
										VALUES
											(DescripDescon,				Entero_Cero,	Entero_Cero);

			END IF;

			IF NOT EXISTS(SELECT Estatus FROM TMPESTADISTICAS WHERE Estatus = DescripEncol )THEN

			INSERT INTO TMPESTADISTICAS 	(Estatus,			Total,			Porcentaje)
											VALUES
											(DescripEncol,		Entero_Cero,	Entero_Cero);

			END IF;


			SELECT	Estatus,	Total,	FORMAT(Porcentaje,2),	Var_Program ,	(Var_TotalEnv - Var_Program) AS TotalEnviados
					FROM TMPESTADISTICAS ORDER BY Estatus ASC;

			DROP TEMPORARY TABLE IF EXISTS TMPESTADISTICAS;


	END IF;

	-- Lista  de mensajes listos para enviar al modem
	IF(Par_NumLis = Lis_EnvioModem) THEN

		SET Fecha_Act :=  CURRENT_TIMESTAMP();

			SELECT EnvioID,	Receptor,	Mensaje, CampaniaID
				FROM		SMSENVIOMENSAJE
				WHERE	Estatus = EstatusNoEnv
					AND FechaProgEnvio <= Fecha_Act
					LIMIT 0, 200;
	END IF;

    IF(Par_NumLis = Lis_MenEnv)THEN
    	SET @row=0;
		SELECT 		(@row:=@row+1) AS Consecutivo,	Receptor,	Mensaje, CAST(FechaRealEnvio AS DATE) AS FechaRealEnvio
			FROM	HISSMSENVIOMENSAJE
			WHERE	Estatus = EstatusEnv
			AND 	CAST(FechaRealEnvio AS DATE) = Par_FechaCon;
    END IF;

	IF(Par_NumLis = Lis_MenNoEnv)THEN
		SET @row=0;
		SELECT 		(@row:=@row+1) AS Consecutivo,	Receptor,	Mensaje, CAST(FechaActual AS DATE)AS FechaActual
			FROM	SMSENVIOMENSAJE
			WHERE	Estatus = EstatusNoEnv
			AND 	CAST(FechaActual AS DATE) = Par_FechaCon;
    END IF;

	IF(Par_NumLis = Lis_MenCan)THEN
		SET @row=0;
		SELECT 		(@row:=@row+1) AS Consecutivo,	Receptor,	Mensaje, CAST(FechaActual AS DATE)AS FechaActual
			FROM	SMSENVIOMENSAJE
			WHERE	Estatus = EstatusCan
			AND 	CAST(FechaActual AS DATE) = Par_FechaCon;
	END IF;

    END IF;

	-- Lista de mensajes en proceso de envio
	IF (Par_NumLis = Lis_PorEnviar) THEN
		SELECT		EnvioID,	Receptor,	Mensaje,	CampaniaID
			FROM	SMSENVIOMENSAJE
			WHERE	Estatus = Est_Proceso
			  AND	CodExitoErr = Cadena_Vacia
			  AND	PIDTarea = Par_PIDTarea
			  AND	FechaProgEnvio <= Aud_FechaActual;
	END IF;

END TerminaStore$$