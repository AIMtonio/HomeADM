-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RATIOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `RATIOSPRO`;DELIMITER $$

CREATE PROCEDURE `RATIOSPRO`(
	/*SP que realiza proceso de ratios*/
	Par_SolicitudCreditoID	INT(11),
	-- C1
	Par_MorosidadCred		CHAR(1),
	Par_MaximoMorosidad		DECIMAL(12,2),
	Par_CalificaBuro		DECIMAL(12,2),
	-- C2
	Par_PorDeuda			DECIMAL(12,2),
	Par_PorDeudaCredito		DECIMAL(12,2),
	-- C3
	Par_Cobertura			DECIMAL(12,2),
	Par_Gastos				DECIMAL(12,2),
	Par_GastosCredito		DECIMAL(12,2),
	-- C4
	Par_TieneNegocio		CHAR(1),
	Par_EstabEmpleo			INT(11),
	Par_VentasMensual		INT(11),
	Par_Liquidez			INT(11),
	Par_Mercado				INT(11),
	Par_MontoTerreno		DECIMAL(14,2),
	Par_MontoVivienda		DECIMAL(14,2),
	Par_MontoVehiculos		DECIMAL(14,2),
	Par_MontoOtros			DECIMAL(14,2),
	Par_MontoGarantizado	DECIMAL(14,2),
	Par_TipoTransaccion		INT(11),
	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore:BEGIN
	-- Declaracion de Variables
	DECLARE Var_FechaActual							DATE;
	DECLARE Var_ClienteID							INT(11);
	DECLARE Var_ProspectoID							INT(11);
	DECLARE Var_PuntosVivienda						INT(11);
	DECLARE Var_RFC									CHAR(13);

	DECLARE PorMaxVivienda							DECIMAL(12,2);
	DECLARE Var_MaxPuntosVivienda					DECIMAL(12,2);
	DECLARE PorTotalVivienda						DECIMAL(12,2);

	DECLARE Var_PuntosEstabEmpleo					INT(11);
	DECLARE Var_PuntosVentasMensual					INT(11);
	DECLARE Var_PuntosLiquidez						INT(11);
	DECLARE Var_PuntosMercado						INT(11);

	DECLARE Var_RatiosPorClasifEmpleo				INT(11);
	DECLARE Var_RatiosPorClasifVentasMesual			INT(11);
	DECLARE Var_RatiosPorClasifLiquidez				INT(11);
	DECLARE Var_RatiosPorClasifMercado				INT(11);

	DECLARE Var_PorEstabEmpleo						DECIMAL(12,2);
	DECLARE Var_PorEstabVentasMensual				DECIMAL(12,2);
	DECLARE Var_PorEstabVentasLiquidez				DECIMAL(12,2);
	DECLARE Var_PorMercado							DECIMAL(12,2);

	DECLARE Var_MaxPuntosEstabEmpleo				DECIMAL(12,2);
	DECLARE Var_MaxPuntosVentasMensual				DECIMAL(12,2);
	DECLARE Var_MaxPuntosLiquidez					DECIMAL(12,2);
	DECLARE Var_MaxPuntosMercado					DECIMAL(12,2);


	DECLARE Var_PorTotalEstabEmpleo					DECIMAL(12,2);
	DECLARE Var_PorTotalVentasMensual				DECIMAL(12,2);
	DECLARE Var_PorTotalLiquidez 					DECIMAL(12,2);
	DECLARE Var_PorTotalMercado						DECIMAL(12,2);
	DECLARE Var_PorNegocio							DECIMAL(12,2);

	DECLARE Var_PorClasificaConEstabIng				DECIMAL(12,2);
	DECLARE Var_PorClasificaConNegocio				DECIMAL(12,2);

	/*  */
	DECLARE Var_PorcenClasif						DECIMAL(12,2);
	DECLARE Var_PorcenClasificaCon					DECIMAL(12,2);
	DECLARE Var_PorcenConceptos						DECIMAL(12,2);

	/*  variables C3 */
	DECLARE Var_PuntosCobertura						DECIMAL(12,2);
	DECLARE Var_RatiosPorClasifCobertura 			DECIMAL(12,2);
	DECLARE Var_PuntosGastos						DECIMAL(12,2);
	DECLARE Var_RatiosPorClasifGastos				DECIMAL(12,2);
	DECLARE Var_PorcenClasifGastos					DECIMAL(12,2);
	DECLARE Var_PorcenClaficaConGastos 				DECIMAL(12,2);
	DECLARE Var_PuntosGastosCred					DECIMAL(12,2);
	DECLARE Var_RatiosPorClasifGastosCred			DECIMAL(12,2);
	DECLARE Var_PorcenClasifGastosCred 				DECIMAL(12,2);
	DECLARE Var_PorcenClaficaConGastosCred			DECIMAL(12,2);

	DECLARE Var_MaxPuntosCobertura			DECIMAL(12,2);
	DECLARE Var_MaxPuntosGastos				DECIMAL(12,2);
	DECLARE Var_MaxPuntosGstosCred			DECIMAL(12,2);

	DECLARE Var_PorTotalCobertura			DECIMAL(12,2);
	DECLARE Var_PorTotalGastos				DECIMAL(12,2);
	DECLARE Var_PorTotalGastosCred			DECIMAL(12,2);

	DECLARE Var_SumaClaficicaCon			DECIMAL(12,2);
	DECLARE  Var_PorTotal					DECIMAL(12,2);

	/* C2 */
	DECLARE Var_PuntosDeuda					DECIMAL(12,2);
	DECLARE Var_RatiosPorClasifDeuda		DECIMAL(12,2);

	DECLARE Var_PuntosDeudaCred				DECIMAL(12,2);
	DECLARE Var_RatiosPorClasifDeudaCred	DECIMAL(12,2);
	DECLARE Var_PorcenClasifDeudaCre		DECIMAL(12,2);
	DECLARE Var_PorcenClasificaConDeudaCre	DECIMAL(12,2);

	DECLARE Var_MaxPuntosDeuda				DECIMAL(12,2);
	DECLARE Var_MaxPuntosDeudaCre 			DECIMAL(12,2);
	DECLARE Var_PorTotalDeuda				DECIMAL(12,2);
	DECLARE Var_PorTotalDeudaCre			DECIMAL(12,2);

	/* C1  */
	DECLARE Var_PuntosRa					DECIMAL(12,4);
	DECLARE Var_TiempoHabitarDom			DECIMAL(12,4);
	DECLARE Var_PorClasfi					DECIMAL(12,4);
	DECLARE Var_MaxPuntos					DECIMAL(12,4);
	DECLARE Var_PorTotalRatiosPorCla 		DECIMAL(12,4);
	DECLARE Var_TotalClasificaVivie			DECIMAL(12,4);
	DECLARE Var_SumaOcupacion				DECIMAL(12,4);
	DECLARE Var_TotalClasificaOcupa			DECIMAL(12,4);
	DECLARE Var_SumaMora					DECIMAL(12,4);
	DECLARE Var_TotalMora					DECIMAL(12,4);
	DECLARE Var_SumaAfiliacion				DECIMAL(12,4);
	DECLARE Var_TotalClasificaAfilia		DECIMAL(12,4);
	DECLARE Var_TotalClasifica				DECIMAL(12,4);
	DECLARE Var_MaxPuntosOupacion			DECIMAL(12,4);
	DECLARE  Var_AntigOcup					DECIMAL(12,4);
	DECLARE Var_CalificaCaja				CHAR(1);
	DECLARE Var_SumaClaficicaResid			DECIMAL(12,4);

	--
	DECLARE Var_PuntajeMinimo				DECIMAL(14,4);
	DECLARE Var_PuntajeTotal				DECIMAL(14,4);
	-- Buro de Credito
	DECLARE Var_FolioConsulta				VARCHAR(30);
	DECLARE Var_DiasVigencia				INT(11);
	DECLARE Var_DeudaTotBuro				DECIMAL(14,4);
	DECLARE Var_CalificaBuro				VARCHAR(11);
	DECLARE Var_DiasVigBC					INT;
	-- Solicitud Credito
	DECLARE Var_ProductoCreditoID			INT(11);
	DECLARE Var_EstatusSol					CHAR(1);
	DECLARE Var_GrupoID						INT;
	DECLARE Var_Control						VARCHAR(1000);
	DECLARE Act_RechazoAutomatico			INT(11);
	DECLARE Comentario_RechazoAut			VARCHAR(100);

	-- Declaracion de Constantes
	DECLARE SalidaSI						CHAR(1);
	DECLARE Entero_Cero						INT;
	DECLARE ConstanteSI						CHAR(1);
	DECLARE EstatusInactiva					CHAR(1);
	DECLARE EstatusCancelada 				CHAR(1);
	DECLARE Cadena_Vacia					CHAR;
	DECLARE SalidaNO						CHAR(1);
	DECLARE GardarCalculo					INT;
	DECLARE GenerarCalculo					INT;

	DECLARE Tip_RechazarInteg				INT;
	DECLARE Fecha_Vacia						DATE;
	DECLARE EstatusCalculado				CHAR(1);
	DECLARE EstatusGuardado					CHAR(1);
	DECLARE IDClasifCasa					INT;
	DECLARE IDClasifMesHabitaVi				INT;
	DECLARE IDClasXOcupacion				INT(11);
	DECLARE IDMesesXOcupacion				INT(11);
	DECLARE CalificacionExcelente			CHAR(1);
	DECLARE CalificacionBuena				CHAR(1);
	DECLARE Aval_Autorizado					CHAR(1);				# Estatus Autorizado
	DECLARE TipoValRatio					INT;
	DECLARE Var_Sin_NRatiosConf				INT(11);				# Numero de clasificaciones y subclasificaciones de ratios sin configurar
	/*C5 Colaterales*/
	DECLARE Var_Colaterales					DECIMAL(14,2);			# Valor para los colaterales
	DECLARE Var_NAvales						INT(11);				# Numero de avales
	DECLARE Var_NGarantias					INT(11);				# Numero de garantias
	DECLARE Var_aporteCliente				DECIMAL(14,6);				# Numero de garantias


	-- Asignacion de Constantes
	SET SalidaSI				:='S';		-- Salida en pantalla si
	SET Entero_Cero				:=0;
	SET Var_SumaOcupacion		:=0.0;
	SET Var_TotalClasificaVivie	:=0.0;
	SET Var_SumaClaficicaResid	:=0.0;
	SET Var_SumaAfiliacion		:=0.0;
	SET Var_SumaMora			:=0.0;
	SET ConstanteSI				:='S';
	SET EstatusInactiva			:='I';
	SET EstatusCancelada		:='C';
	SET Cadena_Vacia			:='';
	SET SalidaNO				:='N';
	SET GardarCalculo			:=2;				-- Marca Como Guardado el Calculo del Ratios
	SET GenerarCalculo			:=1;				--  Genera el Calculo
	SET Tip_RechazarInteg		:= 1;				-- Tipo de Actualizacion para Rechazar Integrante de Grupo
	SET Fecha_Vacia				:='1900-01-01';
	SET EstatusCalculado		:='C';
	SET EstatusGuardado			:='G';
	SET IDClasifCasa			:= 17;				#Clasificacion por Vivienda segun catalogo de CATRATIOS
	SET IDClasifMesHabitaVi		:= 18;				# Sub clasificacion por vivienda
	SET IDClasXOcupacion		:= 7;				# Sub Clasificacion por ocupacion
	SET IDMesesXOcupacion		:= 20;				# Sub Clasificacion por meses ocupacion
	SET CalificacionExcelente	:='A';
	SET CalificacionBuena		:='B';
	SET Aval_Autorizado			:='U';

	SET Var_Control				:='';
	SET Act_RechazoAutomatico	:=4;			-- Actualizacion de rechazo
	SET Comentario_RechazoAut	:='Calificacion mala en calculo de ratios. Solicitud Cancelada automaticamente.';
	SET TipoValRatio			:= 1;
	SET Aud_FechaActual			:=NOW();

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-RATIOSPRO');
			SET Var_Control := 'sqlException' ;
		END;

		/** ############################### VALIDACIONES PARAMETRIZACION ############################## **/
		/*  Seleccionamos los datos la Solicitud  */
		SELECT
			ClienteID,			ProspectoID,		ProductoCreditoID, 		Estatus,			GrupoID,
            AporteCliente
			INTO
			Var_ClienteID,		Var_ProspectoID,	Var_ProductoCreditoID,	Var_EstatusSol,		Var_GrupoID,
            Var_aporteCliente
			FROM SOLICITUDCREDITO
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

		SET Var_ClienteID 			:= IFNULL(Var_ClienteID, Entero_Cero);
		SET Var_ProspectoID 		:= IFNULL(Var_ProspectoID,Entero_Cero);
		SET Var_ProductoCreditoID 	:= IFNULL(Var_ProductoCreditoID,Entero_Cero);
		SET Var_EstatusSol 			:= IFNULL(Var_EstatusSol,Cadena_Vacia);
		SET Var_GrupoID				:= IFNULL(Var_GrupoID,Entero_Cero);

		IF NOT EXISTS(SELECT ProducCreditoID FROM PRODUCTOSCREDITO  WHERE ProducCreditoID = Var_ProductoCreditoID AND CalculoRatios = ConstanteSI)THEN
			SET Par_NumErr = 001;
			SET Par_ErrMen = CONCAT('El Producto de Credito no Requiere Calculo de Ratios');
			SET Var_Control	:='solicitudCreditoID' ;
			LEAVE ManejoErrores;
		END IF;

		/* SE VALIDA QUE TODAS LAS CLASIFICACIONES Y SUBCLASIFICACIONES ESTEN CONFIGURADAS */
		SELECT COUNT(Cat.RatiosCatalogoID)
			INTO Var_Sin_NRatiosConf
			FROM
				CATRATIOS AS Cat LEFT JOIN
				RATIOSCONFXPROD AS Rat ON Cat.RatiosCatalogoID=Rat.RatiosCatalogoID AND Rat.ProducCreditoID = Var_ProductoCreditoID
				WHERE Tipo IN (1,2,3) AND Rat.Porcentaje IS NULL;

		IF(IFNULL(Var_Sin_NRatiosConf, Entero_Cero) > Entero_Cero) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := CONCAT('No se ha Configurado Completamente el Catalogo de Ratios');
			SET Var_Control := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_EstatusSol <> EstatusInactiva)THEN
			SET Par_NumErr = 03;
			SET Par_ErrMen = 'La Solicitud de Credito no se Encuentra Inactiva';
			SET Var_Control	:='solicitudCreditoID' ;
			LEAVE ManejoErrores;
		END IF;

		SELECT PuntajeMinimo INTO Var_PuntajeMinimo
			FROM PARAMETROSCAJA
			LIMIT 1;

		IF(Var_PuntajeMinimo IS NULL) THEN
			SET Par_NumErr = 03;
			SET Par_ErrMen = 'No se ha Parametrizado el Puntaje Minimo para Capacidad de Pago de la Caja.';
			SET Var_Control	:='solicitudCreditoID' ;
			LEAVE ManejoErrores;
		END IF;

		SELECT DiasVigenciaBC, FechaSistema
			INTO Var_DiasVigBC, Var_FechaActual
				FROM PARAMETROSSIS	LIMIT 1;

		SET Var_DiasVigBC 			:= IFNULL(Var_DiasVigBC, Entero_Cero);
		SET Var_FechaActual 		:= IFNULL(Var_FechaActual, Fecha_Vacia);

		IF(Par_TipoTransaccion = GenerarCalculo)THEN
			IF(Var_ClienteID > Entero_Cero)THEN
				SELECT RFC INTO Var_RFC	FROM CLIENTES WHERE ClienteID =Var_ClienteID;
			  ELSE
				SELECT  RFC INTO Var_RFC FROM PROSPECTOS  WHERE ProspectoID = Var_ProspectoID;
			END IF;

			SET Var_RFC	:= IFNULL(Var_RFC, Cadena_Vacia);

			IF NOT EXISTS (SELECT SolicitudCreditoID FROM RATIOS WHERE SolicitudCreditoID = Par_SolicitudCreditoID)THEN
				INSERT INTO RATIOS (
					SolicitudCreditoID,		UsuarioAlta,		FechaRegistro,			EmpresaID,			Usuario,
					FechaActual,			DireccionIP,		ProgramaID,				Sucursal,			NumTransaccion
					) VALUES (
					Par_SolicitudCreditoID,	Aud_Usuario,		Var_FechaActual,		Aud_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
			END IF;

			SELECT
				FolioConsulta,
				IFNULL(Var_DiasVigBC-DATEDIFF(NOW(),FechaConsulta),0) AS DiasVigencia
				INTO
				Var_FolioConsulta, Var_DiasVigencia
				FROM  SOLBUROCREDITO
					WHERE RFC=Var_RFC AND !(ISNULL(FolioConsulta))
						AND FolioConsulta != ''
						ORDER BY FechaConsulta DESC LIMIT 1;

			SET Var_FolioConsulta	:=IFNULL(Var_FolioConsulta, Cadena_Vacia);
			SET Var_DiasVigencia	:=IFNULL(Var_DiasVigencia,Entero_Cero );

			IF(Var_DiasVigencia <= Entero_Cero)THEN
				SET Par_NumErr = 01;
				SET Par_ErrMen = 'Es Necesario Consultar los datos del safilocale.cliente en Buro de Credito';
				SET Var_Control	:='solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_DiasVigencia > 0)THEN
				SELECT MAX(CONVERT(IFNULL(TL_VALOR,Cadena_Vacia),UNSIGNED))  INTO Var_CalificaBuro
						FROM 	bur_segtl
						WHERE 	BUR_SOLNUM = Var_FolioConsulta
							AND  	TL_SEGMEN = 26
							LIMIT 1;
			END IF;

			-- Validamos que el cliente tenga Capturados sus Datos Socioeconomicos
			CALL CLIDATSOCIOEVAL(
				Entero_Cero,		Var_clienteID,		Var_ProspectoID,	Fecha_Vacia,	TipoValRatio,
				SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion
			);

			IF(Par_NumErr <> Entero_Cero ) THEN
				 LEAVE ManejoErrores;
			END IF;


			/* C1*/
			--  Vivienda
			IF NOT EXISTS(SELECT FechaRegistro
							FROM SOCIODEMOVIVIEN Soc
								WHERE CASE WHEN Var_ClienteID > Entero_Cero THEN  Soc.ClienteID =  Var_ClienteID ELSE
										Soc.ProspectoID = Var_ProspectoID END) THEN
				SET Par_NumErr = 01;
				SET Par_ErrMen = 'Es Necesario que Registre los Datos Socioeconomicos (Datos de Vivienda)';
				SET Var_Control	:='solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			SELECT
				Tip.Puntos, TiempoHabitarDom
				INTO
				Var_PuntosRa, Var_TiempoHabitarDom
				FROM SOCIODEMOVIVIEN Soc
					INNER JOIN TIPOVIVIENDA Tip ON Tip.TipoViviendaID = Soc.TipoViviendaID
					WHERE CASE WHEN Var_ClienteID > Entero_Cero THEN  Soc.ClienteID =  Var_ClienteID ELSE
							Soc.ProspectoID = Var_ProspectoID END;

			SET Var_PuntosRa			:= IFNULL(Var_PuntosRa,Entero_Cero);
			SET Var_TiempoHabitarDom 	:= IFNULL(Var_TiempoHabitarDom,Entero_Cero);

			SELECT
				RatSub.Porcentaje AS PorcXSubClasifacion,		RatCla.Porcentaje AS PorcXClasifacion ,		RatCon.Porcentaje AS PorcXConcepto
				INTO
				Var_PorClasfi, 									Var_PorcenClasificaCon, 					Var_PorcenConceptos
			FROM CATRATIOS AS Sub LEFT JOIN
				RATIOSCONFXPROD AS RatSub ON Sub.RatiosCatalogoID = RatSub.RatiosCatalogoID AND RatSub.ProducCreditoID = Var_ProductoCreditoID LEFT JOIN
				RATIOSCONFXPROD AS RatCla ON Sub.ClasificacionID=RatCla.RatiosCatalogoID AND RatCla.ProducCreditoID = Var_ProductoCreditoID LEFT JOIN
				RATIOSCONFXPROD AS RatCon ON Sub.ConceptoID=RatCon.RatiosCatalogoID AND RatCon.ProducCreditoID = Var_ProductoCreditoID
				WHERE Sub.RatiosCatalogoID = 17
				AND RatSub.ProducCreditoID = Var_ProductoCreditoID;

			SET Var_PorClasfi				:= IFNULL(Var_PorClasfi,Entero_Cero);
			SET Var_PorcenClasificaCon		:= IFNULL(Var_PorcenClasificaCon,Entero_Cero);
			SET Var_PorcenConceptos			:= IFNULL(Var_PorcenConceptos,Entero_Cero);
			SET Var_MaxPuntosVivienda		:= (SELECT MAX(Puntos) FROM TIPOVIVIENDA);
			SET Var_MaxPuntosVivienda		:= IFNULL(Var_MaxPuntosVivienda, Entero_Cero);
			SET Var_PorTotalRatiosPorCla	:= case when Var_MaxPuntosVivienda = Entero_Cero  then Entero_Cero else ROUND((Var_PuntosRa * Var_PorClasfi / Var_MaxPuntosVivienda),2) end;
			SET Var_SumaClaficicaResid		:= Var_SumaClaficicaResid + Var_PorTotalRatiosPorCla;

			UPDATE RATIOS SET
				Vivienda		= Var_PorTotalRatiosPorCla
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

			--  Tiempo en Vivienda
			SELECT PuntosDef,Porcentaje
				INTO Var_PuntosRa, Var_PorClasfi
				FROM CATRATIOS AS Pun LEFT JOIN
					RATIOSCONFXPROD AS Sub ON Pun.SubClasificacionID=Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
				WHERE Pun.SubClasificacionID = IDClasifMesHabitaVi
					AND Var_TiempoHabitarDom >= LimiteInferiorDef
					AND Var_TiempoHabitarDom <= LimiteSuperiorDef;

			SET Var_PuntosRa				:=IFNULL(Var_PuntosRa, Entero_Cero);
			SET Var_PorClasfi				:=IFNULL(Var_PorClasfi, Entero_Cero);
			SET Var_MaxPuntos				:=(SELECT MAX(PuntosDef)
												FROM CATRATIOS
													WHERE SubClasificacionID = IDClasifMesHabitaVi);
			SET Var_MaxPuntos				:= IFNULL(Var_MaxPuntos, Entero_Cero);
			SET Var_PorTotalRatiosPorCla 	:= case when Var_MaxPuntos = Entero_Cero then Entero_Cero else ROUND((Var_PuntosRa * Var_PorClasfi / Var_MaxPuntos),2) end;
			SET Var_SumaClaficicaResid		:= ROUND((Var_SumaClaficicaResid + Var_PorTotalRatiosPorCla),2);
			SET Var_TotalClasificaVivie		:= ROUND((Var_SumaClaficicaResid * Var_PorcenClasificaCon /100),2);

			UPDATE RATIOS SET
				TotalResidencia			= Var_TotalClasificaVivie,
				MesesVivienda			= Var_PorTotalRatiosPorCla
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

			IF (Var_ClienteID > Entero_Cero)THEN
				SELECT  Ocu.Puntos INTO Var_PuntosRa
					FROM CLIENTES Cli
						INNER JOIN OCUPACIONES Ocu ON Ocu.OcupacionID =  Cli.OcupacionID
						WHERE  ClienteID = Var_ClienteID;
			  ELSE
				SELECT  Ocu.Puntos INTO Var_PuntosRa
					FROM PROSPECTOS Cli
						INNER JOIN OCUPACIONES Ocu ON Ocu.OcupacionID =  Cli.OcupacionID
						WHERE  ProspectoID = Var_ProspectoID;
			END IF;

			SET Var_PuntosRa	:=IFNULL(Var_PuntosRa, Entero_Cero);

			SELECT
				RatCla.Porcentaje AS PorcXCla,RatSub.Porcentaje AS PorcXSubCla
                INTO Var_PorClasfi,					Var_PorcenClasificaCon
				FROM	CATRATIOS AS Sub LEFT JOIN
					RATIOSCONFXPROD AS RatCla ON Sub.RatiosCatalogoID=RatCla.RatiosCatalogoID AND RatCla.ProducCreditoID = Var_ProductoCreditoID LEFT JOIN
					RATIOSCONFXPROD AS RatSub ON Sub.ClasificacionID=RatSub.RatiosCatalogoID AND RatSub.ProducCreditoID = Var_ProductoCreditoID
					WHERE Sub.RatiosCatalogoID = 19;

			SET Var_PorClasfi				:= IFNULL(Var_PorClasfi,Entero_Cero);
			SET Var_PorcenClasificaCon		:= IFNULL(Var_PorcenClasificaCon,Entero_Cero);
			SET Var_MaxPuntosOupacion		:= (SELECT MAX(Puntos)  FROM OCUPACIONES);
			SET Var_MaxPuntosOupacion		:= IFNULL(Var_MaxPuntosOupacion, Entero_Cero);
			SET Var_PorTotalRatiosPorCla	:= case when Var_MaxPuntosOupacion = Entero_Cero then Entero_Cero else Var_PuntosRa * Var_PorClasfi / Var_MaxPuntosOupacion end;
			SET Var_PorTotalRatiosPorCla	:= IFNULL(Var_PorTotalRatiosPorCla, Entero_Cero);
			SET Var_SumaOcupacion			:= Var_SumaOcupacion + Var_PorTotalRatiosPorCla;

			UPDATE RATIOS SET
				PorOcupacion			= Var_PorTotalRatiosPorCla
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

			-- Antiguedad en su Ocupacion
			IF NOT EXISTS(SELECT FechaRegistro
							FROM SOCIODEMOGRAL Soc
								WHERE CASE WHEN Var_ClienteID > Entero_Cero THEN  ClienteID =  Var_ClienteID ELSE
								ProspectoID = Var_ProspectoID END) THEN
				SET Par_NumErr = 01;
				SET Par_ErrMen = 'Es Necesario que Registre los Datos Socioeconomicos (Socio Demográficos).';
				SET Var_Control	:='solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			SELECT AntiguedadLab  INTO Var_AntigOcup
				FROM SOCIODEMOGRAL
					WHERE CASE WHEN Var_ClienteID > Entero_Cero THEN  ClienteID =  Var_ClienteID ELSE
								ProspectoID = Var_ProspectoID END;

			IF(IFNULL(Var_AntigOcup, Entero_Cero) = Entero_Cero)THEN
				IF(Var_ClienteID > Entero_Cero)THEN
					SELECT AntiguedadTra INTO Var_AntigOcup FROM CLIENTES WHERE ClienteID = Var_ClienteID;
				  ELSE
					SELECT AntiguedadTra  INTO Var_AntigOcup FROM PROSPECTOS WHERE ProspectoID = Var_ProspectoID;
				END IF;
			END IF;

			SET Var_AntigOcup := IFNULL(Var_AntigOcup, Entero_Cero);

			SELECT Pun.PuntosDef,	Sub.Porcentaje
				INTO Var_PuntosRa, Var_PorClasfi
					FROM CATRATIOS Pun
						LEFT JOIN RATIOSCONFXPROD Sub ON Sub.RatiosCatalogoID = Pun.SubClasificacionID AND Sub.ProducCreditoID = Var_ProductoCreditoID
						WHERE Pun.SubClasificacionID = IDMesesXOcupacion
						AND Var_AntigOcup >= LimiteInferiorDef
						AND Var_AntigOcup <= LimiteSuperiorDef;

			SET Var_MaxPuntos				:= (SELECT MAX(PuntosDef)
												FROM CATRATIOS
												WHERE SubClasificacionID = IDMesesXOcupacion);
			SET Var_MaxPuntos 				:= IFNULL(Var_MaxPuntos, Entero_Cero);
			SET Var_PuntosRa				:= IFNULL(Var_PuntosRa, Entero_Cero);
			SET Var_PorClasfi				:= IFNULL(Var_PorClasfi, Entero_Cero);
			SET Var_PorTotalRatiosPorCla	:= case when Var_MaxPuntos = Entero_Cero then Entero_Cero else Var_PuntosRa * Var_PorClasfi / Var_MaxPuntos end;
			SET Var_SumaOcupacion			:= Var_SumaOcupacion + Var_PorTotalRatiosPorCla;
			SET Var_TotalClasificaOcupa		:= Var_SumaOcupacion * Var_PorcenClasificaCon /100;
			SET Var_TotalClasificaOcupa		:= IFNULL(Var_TotalClasificaOcupa, Entero_Cero);

			UPDATE RATIOS SET
				TotalOupacion		= Var_TotalClasificaOcupa,
				MesesOcupacion			= Var_PorTotalRatiosPorCla
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

			-- Mora en el Credito
			CASE WHEN Par_MorosidadCred	= ConstanteSI THEN
					SELECT PuntosDef,		Sub.Porcentaje,	Clas.Porcentaje
						INTO Var_PuntosRa, 	Var_PorClasfi, 	Var_PorcenClasificaCon
						FROM CATRATIOS AS Pun LEFT JOIN
							RATIOSCONFXPROD AS  Clas ON Pun.ClasificacionID = Clas.RatiosCatalogoID AND Clas.ProducCreditoID = Var_ProductoCreditoID LEFT JOIN
							RATIOSCONFXPROD AS  Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
							WHERE Pun.RatiosCatalogoID=42;
				ELSE
					SELECT PuntosDef,Sub.Porcentaje,Clas.Porcentaje
						INTO Var_PuntosRa, Var_PorClasfi, Var_PorcenClasificaCon
						FROM CATRATIOS AS Pun LEFT JOIN
							RATIOSCONFXPROD AS  Clas ON Pun.ClasificacionID = Clas.RatiosCatalogoID AND Clas.ProducCreditoID = Var_ProductoCreditoID LEFT JOIN
							RATIOSCONFXPROD AS  Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
							WHERE Pun.RatiosCatalogoID=43;
			END CASE;
			SET Var_PuntosRa				:= IFNULL(Var_PuntosRa, Entero_Cero);
			SET Var_PorClasfi				:= IFNULL(Var_PorClasfi, Entero_Cero);
			SET Var_PorcenClasificaCon		:= IFNULL(Var_PorcenClasificaCon, Entero_Cero);
			SET Var_MaxPuntos				:= (SELECT MAX(PuntosDef)
													FROM CATRATIOS
														WHERE SubClasificacionID = 21);
			SET Var_MaxPuntos 				:= IFNULL(Var_MaxPuntos, Entero_Cero);
			SET Var_PorTotalRatiosPorCla	:= case when Var_MaxPuntos = Entero_Cero then Entero_Cero else Var_PuntosRa * Var_PorClasfi / Var_MaxPuntos end;
			SET Var_PorTotalRatiosPorCla	:= IFNULL(Var_PorTotalRatiosPorCla, Entero_Cero);
			SET Var_SumaMora				:= Var_SumaMora + Var_PorTotalRatiosPorCla;


			UPDATE RATIOS SET
				MoraCredito	= Var_PorTotalRatiosPorCla
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

			-- Meses Maximo de mora
			SELECT
				PuntosDef,		Sub.Porcentaje
				INTO
				Var_PuntosRa,	Var_PorClasfi
				FROM CATRATIOS AS Pun LEFT JOIN
					RATIOSCONFXPROD AS  Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
					WHERE Pun.SubClasificacionID=22
						AND Par_MaximoMorosidad >= Pun.LimiteInferiorDef
						AND Par_MaximoMorosidad <= Pun.LimiteSuperiorDef;

			SET Var_PuntosRa	:= IFNULL(Var_PuntosRa, Entero_Cero);
			SET Var_PorClasfi	:= IFNULL(Var_PorClasfi, Entero_Cero);
			SET Var_MaxPuntos	:= (SELECT MAX(PuntosDef)
										FROM CATRATIOS
										WHERE SubClasificacionID = 22);

			SET Var_MaxPuntos 	:= IFNULL(Var_MaxPuntos, Entero_Cero);
			SET Var_PorTotalRatiosPorCla	:= case when Var_MaxPuntos = Entero_Cero then Entero_Cero else Var_PuntosRa * Var_PorClasfi / Var_MaxPuntos end;
			SET Var_PorTotalRatiosPorCla	:= IFNULL(Var_PorTotalRatiosPorCla, Entero_Cero);

			SET Var_SumaMora				:=Var_SumaMora + Var_PorTotalRatiosPorCla;

			UPDATE RATIOS SET
				MaximoMesesMora				= Var_PorTotalRatiosPorCla
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

			-- Califica Buro de Credito
			SELECT
				PuntosDef,Sub.Porcentaje
				INTO Var_PuntosRa, Var_PorClasfi
				FROM CATRATIOS AS Pun LEFT JOIN
					RATIOSCONFXPROD AS  Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
					WHERE Pun.SubClasificacionID=23
					AND Par_CalificaBuro >= Pun.LimiteInferiorDef
					AND Par_CalificaBuro <= Pun.LimiteSuperiorDef;


			SET Var_PuntosRa				:= IFNULL(Var_PuntosRa, Entero_Cero);
			SET Var_PorClasfi				:= IFNULL(Var_PorClasfi, Entero_Cero);
			SET Var_MaxPuntos				:= (SELECT MAX(PuntosDef)
												FROM CATRATIOS
												WHERE SubClasificacionID = 23);
			SET Var_MaxPuntos 				:= IFNULL(Var_MaxPuntos, Entero_Cero);
			SET Var_PorTotalRatiosPorCla	:= case when Var_MaxPuntos = Entero_Cero then Entero_Cero else Var_PuntosRa * Var_PorClasfi / Var_MaxPuntos end;
			SET Var_PorTotalRatiosPorCla 	:= IFNULL(Var_PorTotalRatiosPorCla,Entero_Cero);
			SET Var_SumaMora				:= Var_SumaMora + Var_PorTotalRatiosPorCla;
			SET Var_SumaMora				:= IFNULL(Var_SumaMora, Entero_Cero);

			UPDATE RATIOS SET
				CalificaBuroCred			= Var_PorTotalRatiosPorCla
				WHERE SolicitudCreditoID 	= Par_SolicitudCreditoID;

			-- Calificacion Caja
			IF(Var_ClienteID > Entero_Cero)THEN
				SET Var_CalificaCaja	:=(SELECT CalificaCredito
											FROM CLIENTES
												WHERE ClienteID = Var_ClienteID);
			  ELSE
				SET Var_CalificaCaja	:=(SELECT CalificaProspecto
											FROM PROSPECTOS
												WHERE ClienteID = Var_ProspectoID);
			END IF;

			CASE WHEN Var_CalificaCaja	= CalificacionExcelente THEN
				SELECT
					Pun.PuntosDef,			Sub.Porcentaje
					INTO
					Var_PuntosRa,			Var_PorClasfi
					FROM CATRATIOS AS Pun LEFT JOIN
						RATIOSCONFXPROD AS Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
							WHERE  Pun.RatiosCatalogoID=53;
				WHEN  Var_CalificaCaja	= CalificacionBuena THEN
					SELECT
						Pun.PuntosDef,			Sub.Porcentaje
						INTO
						Var_PuntosRa,			Var_PorClasfi
						FROM CATRATIOS AS Pun LEFT JOIN
							RATIOSCONFXPROD AS Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
							WHERE Pun.RatiosCatalogoID=54;
			  ELSE
				SELECT
						Pun.PuntosDef,			Sub.Porcentaje
						INTO
						Var_PuntosRa,			Var_PorClasfi
						FROM CATRATIOS AS Pun LEFT JOIN
						RATIOSCONFXPROD AS Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
							WHERE  Pun.RatiosCatalogoID=55;
			END CASE;
			SET Var_PuntosRa				:= IFNULL(Var_PuntosRa, Entero_Cero);
			SET Var_PorClasfi				:= IFNULL(Var_PorClasfi, Entero_Cero);
			SET Var_MaxPuntos				:= (SELECT MAX(PuntosDef)
													FROM CATRATIOS
														WHERE SubClasificacionID = 24);
			SET Var_MaxPuntos 				:= IFNULL(Var_MaxPuntos, Entero_Cero);
			SET Var_PorTotalRatiosPorCla	:= case when Var_MaxPuntos = Entero_Cero then Entero_Cero else Var_PuntosRa * Var_PorClasfi / Var_MaxPuntos end;
			SET Var_SumaMora				:= IFNULL(Var_SumaMora + Var_PorTotalRatiosPorCla, Entero_Cero);
			SET Var_TotalMora				:= IFNULL(Var_SumaMora * Var_PorcenClasificaCon /100, Entero_Cero);

			UPDATE RATIOS SET
				TotalMora		= Var_TotalMora,
				CalificaCaja	= Var_PorTotalRatiosPorCla
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

			-- Afiliacion
			CASE WHEN Var_ClienteID	> Entero_Cero THEN
				SELECT
					PuntosDef,			Sub.Porcentaje,		Clas.Porcentaje
					INTO
					Var_PuntosRa,		Var_PorClasfi,		Var_PorcenClasificaCon
					FROM CATRATIOS AS Pun LEFT JOIN
						RATIOSCONFXPROD AS  Clas ON Pun.ClasificacionID = Clas.RatiosCatalogoID AND Clas.ProducCreditoID = Var_ProductoCreditoID LEFT JOIN
						RATIOSCONFXPROD AS  Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
						WHERE Pun.RatiosCatalogoID=56;
			  ELSE
				SELECT
					PuntosDef,			Sub.Porcentaje,		Clas.Porcentaje
					INTO
					Var_PuntosRa,		Var_PorClasfi,		Var_PorcenClasificaCon
					FROM CATRATIOS AS Pun LEFT JOIN
						RATIOSCONFXPROD AS  Clas ON Pun.ClasificacionID = Clas.RatiosCatalogoID AND Clas.ProducCreditoID = Var_ProductoCreditoID LEFT JOIN
						RATIOSCONFXPROD AS  Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
						WHERE Pun.RatiosCatalogoID = 57;
			END CASE;

			SET Var_PuntosRa				:=IFNULL(Var_PuntosRa, Entero_Cero);
			SET Var_PorClasfi				:=IFNULL(Var_PorClasfi, Entero_Cero);
			SET Var_PorcenClasificaCon		:=IFNULL(Var_PorcenClasificaCon, Entero_Cero);
			SET Var_MaxPuntos				:= (SELECT MAX(PuntosDef)
												FROM CATRATIOS
												WHERE SubClasificacionID = 25);
			SET Var_MaxPuntos 				:= IFNULL(Var_MaxPuntos, Entero_Cero);
			SET Var_PorTotalRatiosPorCla	:= case when Var_MaxPuntos = Entero_Cero then Entero_Cero else IFNULL(Var_PuntosRa * Var_PorClasfi / Var_MaxPuntos, Entero_Cero) end;
			SET Var_SumaAfiliacion			:= IFNULL(Var_SumaAfiliacion + Var_PorTotalRatiosPorCla, Entero_Cero);

			UPDATE RATIOS SET
				SocioCaja	= Var_PorTotalRatiosPorCla
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

			-- Saldo Promedio de Ahorro
			CASE WHEN Var_CalificaCaja	= CalificacionExcelente OR Var_CalificaCaja = CalificacionBuena THEN
				SELECT
					PuntosDef,			Sub.Porcentaje
					INTO Var_PuntosRa, Var_PorClasfi
					FROM CATRATIOS AS Pun LEFT JOIN
						RATIOSCONFXPROD AS Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
							WHERE Pun.RatiosCatalogoID=58;
			  ELSE
				SELECT
					PuntosDef,			Sub.Porcentaje
					INTO Var_PuntosRa, Var_PorClasfi
					FROM CATRATIOS AS Pun LEFT JOIN
						RATIOSCONFXPROD AS  Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
						WHERE Pun.RatiosCatalogoID=59;
			END CASE;

			SET Var_PuntosRa			:= IFNULL(Var_PuntosRa, Entero_Cero);
			SET Var_PorClasfi			:= IFNULL(Var_PorClasfi, Entero_Cero);
			SET Var_MaxPuntos			:= (SELECT MAX(PuntosDef)
												FROM CATRATIOS
													WHERE SubClasificacionID = 26);
			SET Var_MaxPuntos 				:= IFNULL(Var_MaxPuntos, Entero_Cero);
			SET Var_PorTotalRatiosPorCla	:= case when Var_MaxPuntos = Entero_Cero then Entero_Cero else IFNULL(Var_PuntosRa * Var_PorClasfi / Var_MaxPuntos,Entero_Cero) end;
			SET Var_SumaAfiliacion			:= IFNULL(Var_SumaAfiliacion + Var_PorTotalRatiosPorCla,Entero_Cero);
			SET Var_TotalClasificaAfilia	:= IFNULL(Var_SumaAfiliacion * Var_PorcenClasificaCon /100,Entero_Cero);
			SET Var_TotalClasifica			:= IFNULL(Var_TotalClasificaAfilia+ Var_TotalMora+ Var_TotalClasificaOcupa+ Var_TotalClasificaVivie,Entero_Cero);
			SET Var_TotalClasifica			:= IFNULL(Var_TotalClasifica *  Var_PorcenConceptos/100,Entero_Cero);

			UPDATE RATIOS SET
				Caracter			= Var_TotalClasifica,
				TotalAfiliacion		= Var_TotalClasificaAfilia,
				SaldoPromAhorro		= Var_PorTotalRatiosPorCla
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID;
			/* C2 */
			-- Endeudamiento Actual Sin el Credito
			SELECT
				Pun.PuntosDef,		Pun.SubClasificacionID,		Sub.Porcentaje,		Cla.Porcentaje,				Con.PorcentajeDefault
				INTO
				Var_PuntosDeuda,	Var_RatiosPorClasifDeuda,	Var_PorcenClasif,	Var_PorcenClasificaCon,		Var_PorcenConceptos
				FROM CATRATIOS AS Pun LEFT JOIN
					CATRATIOS AS Con ON Pun.ConceptoID = Con.RatiosCatalogoID LEFT JOIN
					RATIOSCONFXPROD AS Cla ON Pun.ClasificacionID = Cla.RatiosCatalogoID AND Cla.ProducCreditoID = Var_ProductoCreditoID LEFT JOIN
					RATIOSCONFXPROD AS Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
					WHERE Pun.SubClasificacionID = 27
						AND Par_PorDeuda >= Pun.LimiteInferiorDef
						AND Par_PorDeuda <= Pun.LimiteSuperiorDef;

			SET Var_PuntosDeuda				:= IFNULL(Var_PuntosDeuda, Entero_Cero);
			SET Var_RatiosPorClasifDeuda	:= IFNULL(Var_RatiosPorClasifDeuda, Entero_Cero);
			SET Var_PorcenClasif			:= IFNULL(Var_PorcenClasif, Entero_Cero);
			SET Var_PorcenClasificaCon		:= IFNULL(Var_PorcenClasificaCon, Entero_Cero);
			SET Var_PorcenConceptos			:= IFNULL(Var_PorcenConceptos, Entero_Cero);

			SELECT
				Pun.PuntosDef,			Pun.SubClasificacionID,			Sub.Porcentaje,				Cla.Porcentaje
				INTO
				Var_PuntosDeudaCred,	Var_RatiosPorClasifDeudaCred,	Var_PorcenClasifDeudaCre,	Var_PorcenClasificaConDeudaCre
				FROM CATRATIOS AS Pun LEFT JOIN
					CATRATIOS AS Con ON Pun.ConceptoID = Con.RatiosCatalogoID LEFT JOIN
					RATIOSCONFXPROD AS Cla ON Pun.ClasificacionID = Cla.RatiosCatalogoID AND Cla.ProducCreditoID = Var_ProductoCreditoID LEFT JOIN
					RATIOSCONFXPROD AS Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
					WHERE Pun.SubClasificacionID = 28
					AND Par_PorDeudaCredito >= Pun.LimiteInferiorDef
					AND Par_PorDeudaCredito <= Pun.LimiteSuperiorDef;

			SET Var_PuntosDeudaCred				:=IFNULL(Var_PuntosDeudaCred, Entero_Cero);
			SET Var_RatiosPorClasifDeudaCred	:=IFNULL(Var_RatiosPorClasifDeudaCred, Entero_Cero);
			SET Var_PorcenClasifDeudaCre		:=IFNULL(Var_PorcenClasifDeudaCre, Entero_Cero);
			SET Var_PorcenClasificaConDeudaCre	:=IFNULL(Var_PorcenClasificaConDeudaCre, Entero_Cero);

			SET Var_MaxPuntosDeuda				:=(SELECT MAX(PuntosDef)
													FROM CATRATIOS
														WHERE SubClasificacionID = Var_RatiosPorClasifDeuda);

			SET Var_MaxPuntosDeudaCre			:=(SELECT MAX(PuntosDef)
													FROM CATRATIOS
														WHERE SubClasificacionID = Var_RatiosPorClasifDeudaCred);

			SET Var_MaxPuntosDeuda 				:= IFNULL(Var_MaxPuntosDeuda, Entero_Cero);
			SET Var_MaxPuntosDeudaCre 			:= IFNULL(Var_MaxPuntosDeudaCre, Entero_Cero);
			SET Var_PorTotalDeuda				:= case when Var_MaxPuntosDeuda = Entero_Cero then Entero_Cero else IFNULL(Var_PuntosDeuda * Var_PorcenClasif / Var_MaxPuntosDeuda, Entero_Cero) end;
			SET Var_PorTotalDeudaCre			:= case when Var_MaxPuntosDeudaCre = Entero_Cero then Entero_Cero else IFNULL(Var_PuntosDeudaCred * Var_PorcenClasifDeudaCre / Var_MaxPuntosDeudaCre,Entero_Cero) end;


			UPDATE RATIOS SET
				Deuda						= Var_PorTotalDeuda,
				DeudaConCredito				= Var_PorTotalDeudaCre
				WHERE SolicitudCreditoID 	=Par_SolicitudCreditoID;

			SET Var_PorTotalDeuda			:= IFNULL(Var_PorTotalDeuda *  Var_PorcenClasificaCon/100, Entero_Cero);
			SET Var_PorTotalDeudaCre		:= IFNULL(Var_PorTotalDeudaCre * Var_PorcenClasificaConDeudaCre/100, Entero_Cero);
			SET Var_SumaClaficicaCon		:= IFNULL(Var_PorTotalDeuda+ Var_PorTotalDeudaCre, Entero_Cero);
			SET Var_PorTotal				:= IFNULL(Var_SumaClaficicaCon * Var_PorcenConceptos /100, Entero_Cero);

			UPDATE RATIOS SET
				Capital				= Var_PorTotal,
				TotalDeudaActual	= Var_PorTotalDeuda,
				TotalDeudaCredito	= Var_PorTotalDeudaCre
				WHERE SolicitudCreditoID =Par_SolicitudCreditoID;

			/* C3  */
			-- Cobertura Para pagar el Credito
			SELECT
				Pun.PuntosDef,			Pun.SubClasificacionID,			Sub.Porcentaje,		Cla.Porcentaje,			Con.PorcentajeDefault
				INTO
				Var_PuntosCobertura,	Var_RatiosPorClasifCobertura,	Var_PorcenClasif,	Var_PorcenClasificaCon,	Var_PorcenConceptos
				FROM CATRATIOS AS Pun LEFT JOIN
					CATRATIOS AS Con ON Pun.ConceptoID = Con.RatiosCatalogoID LEFT JOIN
					RATIOSCONFXPROD AS Cla ON Pun.ClasificacionID = Cla.RatiosCatalogoID AND Cla.ProducCreditoID = Var_ProductoCreditoID LEFT JOIN
					RATIOSCONFXPROD AS Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
					WHERE Pun.SubClasificacionID = 29
					AND Par_Cobertura >= Pun.LimiteInferiorDef
					AND Par_Cobertura <= Pun.LimiteSuperiorDef;

				IF(Var_RatiosPorClasifCobertura IS NULL) THEN
					SELECT
						Pun.PuntosDef,			Pun.SubClasificacionID,			Sub.Porcentaje,		Cla.Porcentaje,			Con.PorcentajeDefault
						INTO
						Var_PuntosCobertura,	Var_RatiosPorClasifCobertura,	Var_PorcenClasif,	Var_PorcenClasificaCon,	Var_PorcenConceptos
						FROM CATRATIOS AS Pun LEFT JOIN
							CATRATIOS AS Con ON Pun.ConceptoID = Con.RatiosCatalogoID LEFT JOIN
							RATIOSCONFXPROD AS Cla ON Pun.ClasificacionID = Cla.RatiosCatalogoID AND Cla.ProducCreditoID = Var_ProductoCreditoID LEFT JOIN
							RATIOSCONFXPROD AS Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
							WHERE Pun.SubClasificacionID = 29
							ORDER BY Pun.PuntosDef DESC LIMIT 1;
				END IF;

			SET Var_PuntosCobertura			:=IFNULL(Var_PuntosCobertura, Entero_Cero);
			SET Var_RatiosPorClasifCobertura:=IFNULL(Var_RatiosPorClasifCobertura, Entero_Cero);
			SET Var_PorcenClasif			:=IFNULL(Var_PorcenClasif, Entero_Cero);
			SET Var_PorcenClasificaCon		:=IFNULL(Var_PorcenClasificaCon, Entero_Cero);
			SET Var_PorcenConceptos			:=IFNULL(Var_PorcenConceptos, Entero_Cero);

			--  Gastos Actuales
			SELECT
				Pun.PuntosDef,			Pun.SubClasificacionID,			Sub.Porcentaje,			Cla.Porcentaje
				INTO
				Var_PuntosGastos,	Var_RatiosPorClasifGastos,		Var_PorcenClasifGastos,	Var_PorcenClaficaConGastos
				FROM CATRATIOS AS Pun LEFT JOIN
					CATRATIOS AS Con ON Pun.ConceptoID = Con.RatiosCatalogoID LEFT JOIN
					RATIOSCONFXPROD AS Cla ON Pun.ClasificacionID = Cla.RatiosCatalogoID AND Cla.ProducCreditoID = Var_ProductoCreditoID LEFT JOIN
					RATIOSCONFXPROD AS Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
					WHERE Pun.SubClasificacionID = 30
					AND Par_Gastos >= Pun.LimiteInferiorDef
					AND Par_Gastos <= Pun.LimiteSuperiorDef;


			SET Var_PuntosGastos 				:=IFNULL(Var_PuntosGastos, Entero_Cero);
			SET Var_RatiosPorClasifGastos 		:=IFNULL(Var_RatiosPorClasifGastos, Entero_Cero);
			SET Var_PorcenClasifGastos 			:=IFNULL(Var_PorcenClasifGastos, Entero_Cero);
			SET Var_PorcenClaficaConGastos 		:=IFNULL(Var_PorcenClaficaConGastos, Entero_Cero);

			-- Gastos Actuales con el Credito
			SELECT
				Pun.PuntosDef,				Pun.SubClasificacionID,			Sub.Porcentaje,				Cla.Porcentaje
				INTO
				Var_PuntosGastosCred,	Var_RatiosPorClasifGastosCred,	Var_PorcenClasifGastosCred,	Var_PorcenClaficaConGastosCred
				FROM CATRATIOS AS Pun LEFT JOIN
					CATRATIOS AS Con ON Pun.ConceptoID = Con.RatiosCatalogoID LEFT JOIN
					RATIOSCONFXPROD AS Cla ON Pun.ClasificacionID = Cla.RatiosCatalogoID AND Cla.ProducCreditoID = Var_ProductoCreditoID LEFT JOIN
					RATIOSCONFXPROD AS Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
					WHERE Pun.SubClasificacionID = 31
						AND Par_GastosCredito >= Pun.LimiteInferiorDef
						AND Par_GastosCredito <= Pun.LimiteSuperiorDef;

			SET Var_PuntosGastosCred				:= IFNULL(Var_PuntosGastosCred, Entero_Cero);
			SET Var_RatiosPorClasifGastosCred		:= IFNULL(Var_RatiosPorClasifGastosCred, Entero_Cero);
			SET Var_PorcenClasifGastosCred			:= IFNULL(Var_PorcenClasifGastosCred, Entero_Cero);
			SET Var_PorcenClaficaConGastosCred		:= IFNULL(Var_PorcenClaficaConGastosCred, Entero_Cero);

			SET Var_MaxPuntosCobertura	:=(SELECT MAX(PuntosDef)
											FROM CATRATIOS
												WHERE SubClasificacionID =Var_RatiosPorClasifCobertura);
			SET Var_MaxPuntosGastos		:=(SELECT MAX(PuntosDef)
											FROM CATRATIOS
												WHERE SubClasificacionID =Var_RatiosPorClasifGastos);
			SET Var_MaxPuntosGstosCred	:=(SELECT MAX(PuntosDef)
											FROM CATRATIOS
												WHERE SubClasificacionID =Var_RatiosPorClasifGastosCred);

			SET Var_MaxPuntosCobertura		:= IFNULL(Var_MaxPuntosCobertura, Entero_Cero);
			SET Var_MaxPuntosGastos			:= IFNULL(Var_MaxPuntosGastos, Entero_Cero);
			SET Var_MaxPuntosGstosCred		:= IFNULL(Var_MaxPuntosGstosCred, Entero_Cero);
			SET Var_PorTotalCobertura	 	:= case when Var_MaxPuntosCobertura = Entero_Cero then Entero_Cero else IFNULL(Var_PuntosCobertura * Var_PorcenClasif / Var_MaxPuntosCobertura, Entero_Cero) end;
			SET Var_PorTotalGastos			:= case when Var_MaxPuntosGastos = Entero_Cero then Entero_Cero else IFNULL(Var_PuntosGastos * Var_PorcenClasifGastos / Var_MaxPuntosGastos, Entero_Cero) end ;
			SET Var_PorTotalGastosCred		:= case when Var_MaxPuntosGstosCred = Entero_Cero then Entero_Cero else IFNULL(Var_PuntosGastosCred * Var_PorcenClasifGastosCred /Var_MaxPuntosGstosCred, Entero_Cero) end;

			UPDATE RATIOS SET
				PorCobertura			= Var_PorTotalCobertura,
				GastosActual			= Var_PorTotalGastos,
				GastosCredito			= Var_PorTotalGastosCred
				WHERE SolicitudCreditoID =Par_SolicitudCreditoID;

			SET Var_PorTotalCobertura			:= IFNULL(Var_PorTotalCobertura *  Var_PorcenClasificaCon/100, Entero_Cero);
			SET Var_PorTotalGastos				:= IFNULL(Var_PorTotalGastos * Var_PorcenClaficaConGastos/100, Entero_Cero);
			SET Var_PorTotalGastosCred			:= IFNULL(Var_PorTotalGastosCred * Var_PorcenClaficaConGastosCred /100, Entero_Cero);
			SET Var_SumaClaficicaCon			:= IFNULL(Var_PorTotalCobertura + Var_PorTotalGastos+Var_PorTotalGastosCred, Entero_Cero);
			SET Var_PorTotal					:= IFNULL(Var_SumaClaficicaCon * Var_PorcenConceptos /100, Entero_Cero);

			UPDATE RATIOS SET
				CapacidadPago 		=Var_PorTotal,
				TotalCobertura		=Var_PorTotalCobertura,
				TotalGastos			=Var_PorTotalGastos,
				TotalGastosCredito	=Var_PorTotalGastosCred
				WHERE SolicitudCreditoID =Par_SolicitudCreditoID;
			/* C4 */
			-- Estabilidad de su negocio
			SELECT
				Pun.PuntosDef,				Pun.SubClasificacionID,			Sub.Porcentaje,				Cla.Porcentaje,			Con.PorcentajeDefault
				INTO
				Var_PuntosEstabEmpleo,		Var_RatiosPorClasifEmpleo,		Var_PorcenClasif,			Var_PorcenClasificaCon, Var_PorcenConceptos
				FROM CATRATIOS AS Pun LEFT JOIN
					CATRATIOS AS Con ON Pun.ConceptoID = Con.RatiosCatalogoID LEFT JOIN
					RATIOSCONFXPROD AS Cla ON Pun.ClasificacionID = Cla.RatiosCatalogoID AND Cla.ProducCreditoID = Var_ProductoCreditoID LEFT JOIN
					RATIOSCONFXPROD AS Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
						WHERE Pun.RatiosCatalogoOriID = Par_EstabEmpleo
						AND Pun.Tipo = 4;

			SET Var_PuntosEstabEmpleo		:= IFNULL(Var_PuntosEstabEmpleo, Entero_Cero);
			SET Var_RatiosPorClasifEmpleo	:= IFNULL(Var_RatiosPorClasifEmpleo, Entero_Cero);
			SET Var_PorcenClasif			:= IFNULL(Var_PorcenClasif, Entero_Cero);
			SET Var_PorcenClasificaCon		:= IFNULL(Var_PorcenClasificaCon, Entero_Cero);
			SET Var_PorcenConceptos			:= IFNULL(Var_PorcenConceptos, Entero_Cero);
			SET Var_MaxPuntosEstabEmpleo	:=(SELECT MAX(PuntosDef)
												FROM CATRATIOS
													WHERE SubClasificacionID =Var_RatiosPorClasifEmpleo);
			SET Var_MaxPuntosEstabEmpleo	:= IFNULL(Var_MaxPuntosEstabEmpleo, Entero_Cero);


			SET Var_PorTotalEstabEmpleo		:=  case when Var_MaxPuntosEstabEmpleo = Entero_Cero then Entero_Cero else  IFNULL(Var_PuntosEstabEmpleo * Var_PorcenClasif / Var_MaxPuntosEstabEmpleo, Entero_Cero) end;

			IF(Par_TieneNegocio = ConstanteSI)THEN
				SELECT
					Pun.PuntosDef,					Pun.SubClasificacionID,				Sub.Porcentaje,				Cla.Porcentaje
					INTO
					Var_PuntosVentasMensual,		Var_RatiosPorClasifVentasMesual,	Var_PorEstabVentasMensual,	Var_PorClasificaConNegocio
					FROM CATRATIOS AS Pun LEFT JOIN
							CATRATIOS AS Con ON Pun.ConceptoID = Con.RatiosCatalogoID LEFT JOIN
							RATIOSCONFXPROD AS Cla ON Pun.ClasificacionID = Cla.RatiosCatalogoID AND Cla.ProducCreditoID = Var_ProductoCreditoID LEFT JOIN
							RATIOSCONFXPROD AS Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
								WHERE Pun.RatiosCatalogoOriID = Par_VentasMensual AND Pun.Tipo = 4;

				SET Var_PuntosVentasMensual				:= IFNULL(Var_PuntosVentasMensual, Entero_Cero);
				SET Var_RatiosPorClasifVentasMesual		:= IFNULL(Var_RatiosPorClasifVentasMesual, Entero_Cero);
				SET Var_PorEstabVentasMensual			:= IFNULL(Var_PorEstabVentasMensual, Entero_Cero);
				SET Var_PorClasificaConNegocio			:= IFNULL(Var_PorClasificaConNegocio, Entero_Cero);

				SELECT
						Pun.PuntosDef,					Pun.SubClasificacionID,				Sub.Porcentaje
						INTO
						Var_PuntosLiquidez,				Var_RatiosPorClasifLiquidez,		Var_PorEstabVentasLiquidez
					FROM CATRATIOS AS Pun LEFT JOIN
						RATIOSCONFXPROD AS Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
						WHERE Pun.RatiosCatalogoOriID = Par_Liquidez AND Pun.Tipo = 4;

				SET Var_PuntosLiquidez				:= IFNULL(Var_PuntosLiquidez, Entero_Cero);
				SET Var_RatiosPorClasifLiquidez		:= IFNULL(Var_RatiosPorClasifLiquidez, Entero_Cero);
				SET Var_PorEstabVentasLiquidez		:= IFNULL(Var_PorEstabVentasLiquidez, Entero_Cero);

				SELECT
						Pun.PuntosDef,					Pun.SubClasificacionID,				Sub.Porcentaje
						INTO
						Var_PuntosMercado,				Var_RatiosPorClasifMercado,			Var_PorMercado
					FROM CATRATIOS AS Pun LEFT JOIN
						RATIOSCONFXPROD AS Sub ON Pun.SubClasificacionID = Sub.RatiosCatalogoID AND Sub.ProducCreditoID = Var_ProductoCreditoID
						WHERE Pun.RatiosCatalogoOriID = Par_Mercado AND Pun.Tipo = 4;


				SET Var_PuntosMercado 			:= IFNULL(Var_PuntosMercado, Entero_Cero);
				SET Var_RatiosPorClasifMercado 	:= IFNULL(Var_RatiosPorClasifMercado, Entero_Cero);
				SET Var_PorMercado 				:= IFNULL(Var_PorMercado, Entero_Cero);

				SET Var_MaxPuntosVentasMensual	:=  IFNULL((SELECT MAX(PuntosDef)
													FROM CATRATIOS
														WHERE SubClasificacionID = Var_RatiosPorClasifVentasMesual), Entero_Cero);

				SET Var_MaxPuntosLiquidez		:= IFNULL((SELECT MAX(PuntosDef)
													FROM CATRATIOS
														WHERE SubClasificacionID = Var_RatiosPorClasifLiquidez), Entero_Cero);

				SET Var_MaxPuntosMercado		:= IFNULL((SELECT  MAX(PuntosDef)
													FROM CATRATIOS
														WHERE SubClasificacionID = Var_RatiosPorClasifMercado), Entero_Cero);

				SET Var_PorTotalVentasMensual 	:= case when Var_MaxPuntosVentasMensual = Entero_Cero then Entero_Cero else IFNULL(Var_PuntosVentasMensual * Var_PorEstabVentasMensual / Var_MaxPuntosVentasMensual,Entero_Cero) end;
				SET Var_PorTotalLiquidez 		:= case when Var_MaxPuntosLiquidez = Entero_Cero then Entero_Cero else IFNULL(Var_PuntosLiquidez * Var_PorEstabVentasLiquidez / Var_MaxPuntosLiquidez,Entero_Cero) end;
				SET Var_PorTotalMercado			:= case when Var_MaxPuntosMercado = Entero_Cero then Entero_Cero else IFNULL(Var_PuntosMercado * Var_PorMercado / Var_MaxPuntosMercado,Entero_Cero) end;
			  ELSE
				SET Var_PorTotalVentasMensual 	:= Entero_Cero;
				SET Var_PorTotalLiquidez 		:= Entero_Cero;
				SET Var_PorTotalMercado			:= Entero_Cero;
				SET Var_PorClasificaConNegocio	:= Entero_Cero;
			END IF;-- Si tiene Negocio

			SET Var_PorNegocio			:= IFNULL(Var_PorTotalMercado + Var_PorTotalLiquidez + Var_PorTotalVentasMensual, Entero_Cero);
			SET Var_PorcenClasif		:= IFNULL(Var_PorTotalEstabEmpleo * Var_PorcenClasificaCon /100, Entero_Cero);
			SET Var_PorNegocio 			:= IFNULL(Var_PorNegocio *Var_PorClasificaConNegocio/100, Entero_Cero);
			SET Var_SumaClaficicaCon	:= IFNULL(Var_PorcenClasif + Var_PorNegocio, Entero_Cero);
			SET Var_PorTotal			:= IFNULL(Var_SumaClaficicaCon *  Var_PorcenConceptos / 100, Entero_Cero);
			SET Var_PorTotal 				:= IFNULL(Var_PorTotal, Entero_Cero);
			SET Var_PorcenClasif 			:= IFNULL(Var_PorcenClasif, Entero_Cero);
			SET Var_PorNegocio 				:= IFNULL(Var_PorNegocio, Entero_Cero);
			SET Var_PorTotalEstabEmpleo 	:= IFNULL(Var_PorTotalEstabEmpleo, Entero_Cero);
			SET Var_PorTotalVentasMensual 	:= IFNULL(Var_PorTotalVentasMensual, Entero_Cero);
			SET Var_PorTotalMercado 		:= IFNULL(Var_PorTotalMercado, Entero_Cero);
			SET Var_PorTotalLiquidez 		:= IFNULL(Var_PorTotalLiquidez, Entero_Cero);
			SET Par_MontoTerreno 			:= IFNULL(Par_MontoTerreno, Entero_Cero);
			SET Par_MontoVivienda 			:= IFNULL(Par_MontoVivienda, Entero_Cero);
			SET Par_MontoVehiculos 			:= IFNULL(Par_MontoVehiculos, Entero_Cero);
			SET Par_MontoOtros 				:= IFNULL(Par_MontoOtros, Entero_Cero);
			SET Par_EstabEmpleo 			:= IFNULL(Par_EstabEmpleo, Entero_Cero);
			SET Par_TieneNegocio 			:= IFNULL(Par_TieneNegocio, Entero_Cero);
			SET Par_VentasMensual 			:= IFNULL(Par_VentasMensual, Entero_Cero);
			SET Par_Liquidez 				:= IFNULL(Par_Liquidez, Entero_Cero);
			SET Par_Mercado 				:= IFNULL(Par_Mercado, Entero_Cero);
			SET Var_FechaActual 			:= IFNULL(Var_FechaActual, Entero_Cero);
			SET EstatusCalculado 			:= IFNULL(EstatusCalculado, Cadena_Vacia);
			SET Par_MontoGarantizado 		:= IFNULL(Par_MontoGarantizado, Entero_Cero);


			UPDATE RATIOS SET
				Condiciones			=Var_PorTotal,
				TotalEstabilidadIng	=Var_PorcenClasif,
				TotalNegocio		=Var_PorNegocio,
				EstabilidadEmp		=Var_PorTotalEstabEmpleo,
				VentasMensuales		=Var_PorTotalVentasMensual,
				Mercado				=Var_PorTotalMercado,
				Liquidez			=Var_PorTotalLiquidez,

				MontoTerreno		=Par_MontoTerreno,
				MontoVivienda		=Par_MontoVivienda,
				MontoVehiculos		=Par_MontoVehiculos,
				MontoOtros			=Par_MontoOtros,
				PuntosIDEstNeg		=Par_EstabEmpleo,
				TieneNegocio		=Par_TieneNegocio,
				PuntosIDVentasMen	=Par_VentasMensual,
				PuntosIDLiquidez	=Par_Liquidez,
				PuntosIDMercado		= Par_Mercado,
				FechaCalculo		=Var_FechaActual,
				Estatus				= EstatusCalculado,
				MontoGarantizado	=Par_MontoGarantizado

				WHERE SolicitudCreditoID =Par_SolicitudCreditoID;

			/*C5 Colaterales*/
			SET Var_NAvales 		:= (SELECT COUNT(SolicitudCreditoID)
										FROM AVALESPORSOLICI
											WHERE SolicitudCreditoID = Par_SolicitudCreditoID
                                            AND Estatus = Aval_Autorizado);
			SET Var_NGarantias 		:= (SELECT COUNT(SolicitudCreditoID)
										FROM ASIGNAGARANTIAS
											WHERE SolicitudCreditoID = Par_SolicitudCreditoID);

			SET Var_NAvales			:= IFNULL(Var_NAvales, Entero_Cero);
			SET Var_NGarantias		:= IFNULL(Var_NGarantias, Entero_Cero);
			SET Var_aporteCliente	:= IFNULL(Var_aporteCliente, Entero_Cero);

			IF(Var_NAvales > Entero_Cero OR Var_NGarantias > Entero_Cero OR Var_aporteCliente > Entero_Cero) THEN
				SET Var_Colaterales	:= 5;
			ELSE
				SET Var_Colaterales := 0;
			END IF;

			UPDATE RATIOS SET
				Colaterales					= Var_Colaterales
				WHERE SolicitudCreditoID	= Par_SolicitudCreditoID;
			/*FIN C5 Colaterales*/

			UPDATE RATIOS  SET
					PuntosTotal	=(Caracter+ Capital+ CapacidadPago + Condiciones + Colaterales),
					EmpresaID = Aud_EmpresaID,
					Usuario = Aud_Usuario,
					FechaActual = Aud_FechaActual,
					DireccionIP = Aud_DireccionIP,
					ProgramaID = Aud_ProgramaID,
					Sucursal = Aud_Sucursal,
					NumTransaccion = Aud_NumTransaccion
			WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

			UPDATE 	RATIOS Rat,
					RATIOSNIVELRIESGO  Niv SET
					Rat.NivelRiesgo	= Niv.NivelRiesgoID,
					Rat.EmpresaID = Aud_EmpresaID,
					Rat.Usuario = Aud_Usuario,
					Rat.FechaActual = Aud_FechaActual,
					Rat.DireccionIP = Aud_DireccionIP,
					Rat.ProgramaID = Aud_ProgramaID,
					Rat.Sucursal = Aud_Sucursal,
					Rat.NumTransaccion = Aud_NumTransaccion
						WHERE Rat.SolicitudCreditoID = Par_SolicitudCreditoID
						AND Rat.PuntosTotal >= Niv.RangoInferior
						AND Rat.PuntosTotal <= Niv.RangoSuperior;

			SET Par_NumErr	:=0;
			SET Par_ErrMen	:="Calculo Realizado Correctamente";
			SET Var_Control	:='generar';
		END IF; -- Realizar Calculo

		IF(Par_TipoTransaccion = GardarCalculo)THEN
			SELECT PuntosTotal INTO Var_PuntajeTotal
					FROM RATIOS
						WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

			SET Var_PuntajeTotal	:= IFNULL(Var_PuntajeTotal,Entero_Cero);

			UPDATE RATIOS SET
					Estatus	= EstatusGuardado
					WHERE SolicitudCreditoID =Par_SolicitudCreditoID;

			IF(Var_PuntajeTotal < Var_PuntajeMinimo)THEN
				CALL RATIOSACT(
					Par_SolicitudCreditoID,			Aud_Usuario,			Comentario_RechazoAut,			Act_RechazoAutomatico,	SalidaNO,
					Par_NumErr,						Par_ErrMen,				Aud_EmpresaID,					Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP,				Aud_ProgramaID,			Aud_Sucursal,					Aud_NumTransaccion
				);
				IF(Par_NumErr!=Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

				UPDATE SOLICITUDCREDITO SET
					Estatus             = EstatusCancelada,
					FechaCancela		= IFNULL(CONCAT(DATE(Var_FechaActual)," ",CURRENT_TIME), Fecha_Vacia),
					ComentarioEjecutivo = 'Solicitud de Credito Cancelada por no alcanzar el Porcentaje minimo de Ratios'
					WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

					IF Var_GrupoID > Entero_Cero THEN
						CALL INTEGRAGRUPOSACT (
							Var_GrupoID,    Par_SolicitudCreditoID,	Entero_Cero,    Entero_Cero,       Cadena_Vacia,
							Fecha_Vacia,     Entero_Cero,        	Entero_Cero,    Tip_RechazarInteg, SalidaNO,
							Par_NumErr,      Par_ErrMen,        	Aud_EmpresaID,  Aud_Usuario,       Aud_FechaActual,
							Aud_DireccionIP, Aud_ProgramaID,     	Aud_Sucursal,   Aud_NumTransaccion);

						IF Par_NumErr > Entero_Cero THEN
							LEAVE ManejoErrores;
						END IF;
					END IF;
				SET Par_NumErr	:=0;
				SET Par_ErrMen	:="Calculo Realizado. La Solicitud de Credito ha sido Cancelada por no alcanzar el Porcentaje minimo de Ratios";
				SET Var_Control	:='imprimir' ;
			  ELSE
				SET Par_NumErr	:=0;
				SET Par_ErrMen	:="Calculo Realizado Correctamente";
				SET Var_Control	:='imprimir';
			END IF;
		END IF;	--  Guardar Calculo

	END ManejoErrores;  -- END del Handler de Errores.

	 IF (Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control  AS control,
				'' AS consecutivo;
	END IF;

END TerminaStore$$