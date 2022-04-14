-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALIFICACREDITOSOFIPOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALIFICACREDITOSOFIPOPRO`;
DELIMITER $$

CREATE PROCEDURE `CALIFICACREDITOSOFIPOPRO`(
-- ===========================================================================================================
-- ------------------------ SP PARA ASIGNAR CALIFICACION A LA CARTERA PARA EPRC ------------------------------
-- ===========================================================================================================
    Par_Fecha           DATETIME,     -- Fecha de calificacion EPRC

    -- Parametros de auditoria
    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de variabless
	DECLARE Var_TipoInstitucion CHAR(2);
    DECLARE Var_FechaSig    	DATE;
	DECLARE Es_DiaHabil    	    CHAR(1);
	DECLARE Var_MicroCredito	INT;
	DECLARE Var_Reacreditamiento	CHAR(1);

	-- Declaracion de constantes
	DECLARE Entero_Cero     INT;
	DECLARE String_Cero     CHAR(1);

	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Decimal_Cero    DECIMAL(12,2);
	DECLARE EstatusActiva   CHAR(1);
	DECLARE TipoExpuesto    CHAR(1);

    DECLARE SinCalificacion CHAR(2);
	DECLARE CreReestructura	CHAR(1);
	DECLARE CreRenovacion	CHAR(1);
	DECLARE Esta_Desembolso CHAR(1);
    DECLARE EsOficial       CHAR(1);

    DECLARE Consumo         CHAR(1);
    DECLARE Comercial       CHAR(1);
    DECLARE Vivienda        CHAR(1);
	DECLARE MicroCredito   	CHAR(1);
    DECLARE MarginadaSi     CHAR(1);
    DECLARE MarginadaNo     CHAR(1);

	DECLARE Cero_DiaHabil   INT;
	DECLARE SiEs_DiaHabil   CHAR(1);
    DECLARE Un_DiaHabil     INT;
    DECLARE TipoRegReserva  CHAR(2);
    DECLARE Cons_NO			CHAR(1);
    DECLARE Cons_SI			CHAR(1);
    DECLARE Ori_Reestructura	CHAR(1);		--  Indica si el tratamiento al credito origen es Reestructura

    -- Asignacion de constantes
	SET Entero_Cero     	:= 0;           -- Entero cero
	SET String_Cero     	:= '0';         -- String cero
	SET Cadena_Vacia		:= '';          -- Cadena vacia
	SET Decimal_Cero     	:= 0.00;        -- Decimal cero
	SET EstatusActiva   	:= 'A';       	-- Estatus calificacion y porcentaje: ACTIVA
	SET TipoExpuesto    	:= 'E';  		-- Tipo de Rango: Expuesto

    SET SinCalificacion 	:= 'SC';      	-- Sin calificacion por rango de reserva
    SET CreReestructura		:= 'R';			-- Tipo de credito: Reestructura
	SET CreRenovacion		:= 'O';			-- Tipo de credito: Renovacion
	SET Esta_Desembolso		:= 'D';			-- Estatus de la reestructura: Desembolsado
    SET EsOficial           := 'S';			-- Es Direccion Oficial: SI

    SET Consumo             := 'O';			-- Clasificacion credito: CONSUMO
    SET Comercial           := 'C';			-- Clasificacion credito: COMERCIAL
    SET Vivienda            := 'H';         -- Clasificacion credito: VIVIENDA
	SET MicroCredito		:= 'M';         -- Clasificacion credito: MICROCREDITO

    SET MarginadaSi         := 'S';			-- Localidad marginada: SI
    SET MarginadaNo         := 'N';			-- Localidad marginada: NO

    SET Cero_DiaHabil   	:= 0;	        -- Dia habil: Cero
	SET SiEs_DiaHabil   	:= 'S';	        -- Indica que el dia siguiente es habil
    SET Un_DiaHabil    		:= 1;			-- Un dia habil
    SET TipoRegReserva      := 'R';         -- Tipo de Registro : Dato para reserva
    SET Cons_NO				:= 'N';			-- Constante NO
    SET Cons_SI				:= 'S';			-- Constante SI
    SET Ori_Reestructura	:= 'R';


	SELECT CONVERT(IFNULL(ValorParametro, String_Cero), UNSIGNED) INTO Var_MicroCredito
		FROM PARAMGENERALES
		WHERE LlaveParametro = 'ClasifMicrocredito';

	SELECT IFNULL(ValorParametro, Cons_NO) INTO Var_Reacreditamiento
		FROM PARAMGENERALES
		WHERE LlaveParametro = 'Reacreditamiento';


	SET Var_MicroCredito := IFNULL(Var_MicroCredito, Entero_Cero);

	-- Se obtiene el tipo de la institucion
	SELECT TipoInstitucion INTO Var_TipoInstitucion FROM PARAMSCALIFICA;

    -- Tabla temporal creada para obtener la calificacion y el porcentaje de la reserva
    DROP TEMPORARY TABLE IF EXISTS TMPCALIFPORCENTAJE;
	CREATE TEMPORARY TABLE TMPCALIFPORCENTAJE(
		RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
		 FechaCorte         DATE,
		 CreditoID			BIGINT(20),
		 Clasificacion      CHAR(1),
		 ClienteID          INT(11),
		 EsMarginada        CHAR(1),
		 DiasAtraso         INT(11),
         Calificacion       CHAR(2),
		 Porcentaje         DECIMAL(14,2),
		 DestinoCreID       INT(11));

    -- Se obtiene los datos del credito del cliente
	INSERT INTO TMPCALIFPORCENTAJE (
		FechaCorte,					CreditoID,		Clasificacion,			ClienteID,			EsMarginada,
		DiasAtraso,					Calificacion,	Porcentaje,				DestinoCreID)
	SELECT Sal.FechaCorte,		Sal.CreditoID, 		Des.Clasificacion,		Sal.ClienteID, 		Loc.Esmarginada,
			Sal.DiasAtraso,		Cadena_Vacia,		Entero_Cero,			Sal.DestinoCreID
	FROM SALDOSCREDITOS Sal
		INNER JOIN DESTINOSCREDITO Des
			ON Des.DestinoCreID = Sal.DestinoCreID
		INNER JOIN DIRECCLIENTE Dir
			ON Sal.ClienteID = Dir.ClienteID
		INNER JOIN LOCALIDADREPUB Loc
			ON Loc.LocalidadID = Dir.LocalidadID
			AND Loc.EstadoID = Dir.EstadoID
			AND Loc.MunicipioID = Dir.MunicipioID
		WHERE Sal.FechaCorte = Par_Fecha
			AND Dir.Oficial = EsOficial;

    -- Se obtiene la calificacion y porcentaje de reserva para la EPRC
    UPDATE TMPCALIFPORCENTAJE Tmp
		INNER JOIN DESTINOSCREDITO Des ON Des.DestinoCreID = Tmp.DestinoCreID
		INNER JOIN PORCRESPERIODO Por ON CASE WHEN IFNULL(Tmp.DiasAtraso, Entero_Cero) < Entero_Cero
													THEN Entero_Cero
											  ELSE Tmp.DiasAtraso
										 END BETWEEN Por.LimInferior AND Por.LimSuperior

										AND CASE WHEN Des.SubClasifID != Var_MicroCredito THEN Des.Clasificacion
												 ELSE MicroCredito
										END = Por.Clasificacion

		LEFT JOIN CALPORRANGO Cal ON IFNULL(Cal.TipoInstitucion, Por.TipoInstitucion) = Por.TipoInstitucion
										AND (CASE WHEN IFNULL(Por.PorResCarSReest, 0.1) <= Entero_Cero
														THEN 0.1
														ELSE IFNULL(Por.PorResCarSReest, 0.1)
												  END ) > Cal.LimInferior
										AND Por.PorResCarSReest <= Cal.LimSuperior
										AND Por.Estatus = EstatusActiva
                                        AND Cal.Tipo = TipoRegReserva

										AND CASE WHEN Des.SubClasifID != Var_MicroCredito THEN Des.Clasificacion
												 ELSE MicroCredito
										END = Cal.Clasificacion

	   LEFT OUTER JOIN REESTRUCCREDITO Res ON Res.CreditoDestinoID = Tmp.CreditoID AND Res.EstatusReest = Esta_Desembolso
	   									  AND Res.Origen = Ori_Reestructura SET

		Tmp.Calificacion = IFNULL(Cal.Calificacion, SinCalificacion),

		Tmp.Porcentaje   = IFNULL(
							CASE WHEN Tmp.Clasificacion = Consumo AND Tmp.EsMarginada = MarginadaSi THEN Por.PorResCarReest
								 WHEN Tmp.Clasificacion = Consumo AND Tmp.EsMarginada = MarginadaNo THEN Por.PorResCarSReest

								 # Porcentaje Cartera Tipo 1 (Considera a todos los creditos que no han tenido tratamiento - Reestructura o Renovacion
                                WHEN Tmp.Clasificacion = Comercial	AND IFNULL(Res.Origen, Cadena_Vacia) = Cadena_Vacia
																	AND Des.SubClasifID != Var_MicroCredito
																	AND Var_Reacreditamiento = Cons_NO THEN  Por.PorResCarSReest

								 # Porcentaje Cartera Tipo 2 (Considerar a todos los creditos renovados)
								WHEN Tmp.Clasificacion = Comercial	AND Des.SubClasifID != Var_MicroCredito
																	AND	(IFNULL(Res.Origen, Cadena_Vacia) = CreReestructura
																		OR IFNULL(Res.Origen, Cadena_Vacia) = CreRenovacion
																		)
																	AND Var_Reacreditamiento = Cons_NO THEN Por.PorResCarReest
								# REACREDITAMIENTO
								# Porcentaje Cartera Tipo 1
								#(Considera a todos los creditos que no han tenido tratamiento de reestructura y a los creditos que fueron renovados de la pantalla Reacreditamiento
								WHEN Tmp.Clasificacion = Comercial	AND Des.SubClasifID != Var_Microcredito
																	AND	(IFNULL(Res.Origen, Cadena_Vacia) = Cadena_Vacia
																		OR (IFNULL(Res.Origen, Cadena_Vacia)= CreRenovacion
																	AND IFNULL(Res.Reacreditado, Cons_NO)= Cons_SI)
																		)
																	AND Var_Reacreditamiento = Cons_SI THEN Por.PorResCarSReest

                                # Porcentaje Cartera Tipo 2
								# (Considerar a todos los creditos renovados excepto a los que fueron dados de alta en la pantalla Reacreditamiento)
								WHEN Tmp.Clasificacion = Comercial	AND Des.SubClasifID != Var_Microcredito
																	AND	(IFNULL(Res.Origen, Cadena_Vacia) = CreReestructura
																		OR (IFNULL(Res.Origen, Cadena_Vacia)= CreRenovacion
																	AND IFNULL(Res.Reacreditado, Cons_NO)= Cons_NO)
																		)
																	AND Var_Reacreditamiento = Cons_SI THEN Por.PorResCarReest

								 WHEN Tmp.Clasificacion = Comercial AND Tmp.EsMarginada = MarginadaSi AND
																Des.SubClasifID = Var_MicroCredito THEN  Por.PorResCarReest

								 WHEN Tmp.Clasificacion = Comercial AND Tmp.EsMarginada = MarginadaNo AND
														Des.SubClasifID = Var_MicroCredito THEN  Por.PorResCarSReest

								WHEN Tmp.Clasificacion = Vivienda THEN Por.PorResCarSReest END , Entero_Cero)

		WHERE Tmp.FechaCorte  	= Par_Fecha
		  AND Por.TipoInstitucion = Var_TipoInstitucion
		  AND Por.Estatus     = EstatusActiva
		  AND Por.TipoRango   = TipoExpuesto
		  AND Cal.Estatus     = EstatusActiva;

        -- Se obtiene la fecha siguiente
        SET Var_FechaSig := DATE_ADD(Par_Fecha,INTERVAL 1 DAY);

		IF(MONTH(Par_Fecha) != MONTH(Var_FechaSig))THEN
			/* Se actualiza el porcentaje de estimacion cuando la clasificacion del destino de credito sea de CONSUMO o COMERCIAL
			 y tengan garantias hipotecarias debidamente registradas a nombre de la Entidad */
			UPDATE TMPCALIFPORCENTAJE Tmp
				INNER JOIN CREGARPRENHIPO Gah ON Gah.CreditoID = Tmp.CreditoID
				INNER JOIN PORCRESPERIODO Por
				ON CASE WHEN IFNULL(Tmp.DiasAtraso, Entero_Cero) < Entero_Cero THEN Entero_Cero
						ELSE Tmp.DiasAtraso
						END
				BETWEEN Por.LimInferior AND Por.LimSuperior
					AND Por.Clasificacion = Vivienda
			SET Tmp.Porcentaje = Por.PorResCarSReest
			WHERE Tmp.FechaCorte = Par_Fecha
				AND Tmp.Clasificacion IN (Consumo)
				AND IFNULL(Gah.CreditoID, Entero_Cero) != Entero_Cero
				AND IFNULL(Gah.MontoGarHipo, Entero_Cero) > Entero_Cero;

			/* Se actualiza el porcentaje de estimacion cuando la clasificacion del destino de credito sea de VIVIENDA
			 y no tengan garantias hipotecarias debidamente registradas a nombre de la Entidad */
			UPDATE TMPCALIFPORCENTAJE Tmp
				LEFT OUTER JOIN CREGARPRENHIPO Gah ON Gah.CreditoID = Tmp.CreditoID
				INNER JOIN PORCRESPERIODO Por
				ON CASE WHEN IFNULL(Tmp.DiasAtraso, Entero_Cero) < Entero_Cero THEN Entero_Cero
						ELSE Tmp.DiasAtraso
						END
				BETWEEN Por.LimInferior AND Por.LimSuperior
					AND Por.Clasificacion = Consumo
			SET Tmp.Porcentaje = IFNULL(CASE WHEN Tmp.Clasificacion = Vivienda
											AND Tmp.EsMarginada = MarginadaSi
										THEN Por.PorResCarReest
									WHEN Tmp.Clasificacion = Vivienda  AND Tmp.EsMarginada = MarginadaNo
										THEN Por.PorResCarSReest
										END, Entero_Cero)
			WHERE Tmp.FechaCorte = Par_Fecha
				AND Tmp.Clasificacion = Vivienda
				AND IFNULL(Gah.CreditoID, Entero_Cero) = Entero_Cero;

	END IF;


	-- Se actualiza la calificacion y porcentaje en SALDOSCREDITOS
	UPDATE SALDOSCREDITOS Sal,
			TMPCALIFPORCENTAJE Tmp
		SET Sal.Calificacion = Tmp.Calificacion,
			Sal.PorcReserva = Tmp.Porcentaje
	WHERE Sal.FechaCorte = Par_Fecha
	 AND Sal.CreditoID = Tmp.CreditoID;

    DROP TABLE TMPCALIFPORCENTAJE;

END TerminaStore$$
