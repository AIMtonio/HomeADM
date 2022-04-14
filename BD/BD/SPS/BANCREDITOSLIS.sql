-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANCREDITOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCREDITOSLIS`;

DELIMITER $$
CREATE PROCEDURE `BANCREDITOSLIS`(

	Par_ClienteID			INT(11),				-- Cliente ID para consultar
	Par_CreditoID			BIGINT(12),				-- Numero de credito
	Par_PromotorID			INT(11),				-- Numero de promotor
	Par_NombreCliente		VARCHAR(50),			-- Nombre del cliente
	Par_TamanioLista		INT(11),				-- Parametro tamanio de la lista

	Par_PosicionInicial		INT(11),				-- Parametro posicion inicial de la lista
	Par_Estatus				CHAR(1),				-- Estaus del credito
	Par_FechaExigible		DATE,					-- Fecha de exigibilidad del credito
	Par_FechaPagado			DATE,					-- Fecha esta pagado de credito

	Par_NumLis				TINYINT UNSIGNED,		-- Numero de consulta
	Par_NombreConsulta      VARCHAR(100),           -- Nombre de la pantalla y de la consulta que ejecuta la consulta por clave

	Aud_EmpresaID			INT(11),				-- Parametros de auditoria
	Aud_Usuario				INT(11),				-- Parametros de auditoria
	Aud_FechaActual			DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal			INT(11),				-- Parametros de auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametros de auditoria
)
TerminaStore: BEGIN

    -- Declaracion de Constantes
	DECLARE Var_NumLisPrincipal		TINYINT UNSIGNED;			-- Lista principal
	DECLARE Var_LisCredClientes		TINYINT UNSIGNED;			-- Lista  de los creditos del cliente
	DECLARE Var_LisInforCredito		TINYINT UNSIGNED;			-- Lista  de las informacion del credito
	DECLARE Var_LisDefaultRuta		TINYINT UNSIGNED;			-- Lista  de las de creditos ruta del dia(presenta lentitud)
	DECLARE Var_LisCreditosBancas   TINYINT UNSIGNED;
	DECLARE Var_LisResumenCredito	TINYINT UNSIGNED;
	DECLARE Var_LisDetalladaCredito TINYINT UNSIGNED;

	DECLARE Entero_Cero					INT(1);						-- Entero cero
	DECLARE Cadena_Vacia        		CHAR(1);
	DECLARE Entero_Uno					INT(11);						-- Entero uno
	DECLARE Entero_Dos					INT(11);						-- Entero dos
	DECLARE Fecha_Vacia					DATE;							-- Fecha Vacia
	DECLARE FechaMaxima					DATE;
	DECLARE TipoPrepagoProy				CHAR(1);				-- Pago Cuotas Completas Proyectadas
	DECLARE Var_AdelantaFecha			CHAR(1);					-- Indica si la consulta adelantará fechas

	-- Declaracion de variables
	DECLARE Var_FecActual      			DATE;							-- Fecha del sistema
	DECLARE Var_cantidad				INT(11);
	DECLARE var_Conta					INT(11);
	DECLARE Var_CantidadCre				INT(11);
	DECLARE Var_CreditoID				BIGINT(20);
	DECLARE Var_ClienteID 				INT(11);						-- ID del Cliente
	DECLARE Var_PosicionID				INT(11);						-- Posicion del Cliente en la lista de cobros
	DECLARE Var_FechaAnt				DATE;
	DECLARE Var_TodosCred				CHAR(1);
	DECLARE Var_NumSubConsulta			CHAR(2);
	DECLARE Var_SucCredito				INT(11);
 	DECLARE Var_IVASucurs 				DECIMAL(12,2);
 	DECLARE Var_CliPagIVA 				CHAR(1);

	-- Declaracion de variables clave de pantallas por consultas
    DECLARE Var_ClaConDefault           VARCHAR(100);               -- Clave consulta por default sin ninguna caracteristica en particular
    DECLARE Var_ClaConCredNomInput      VARCHAR(100);               -- Clave pantalla input nombre consulta/credito
    DECLARE Var_ClaRutaDiaNomInput      VARCHAR(100);               -- Clave pantalla input nombre Ruta Dia/ Clientes Dia
    DECLARE Var_ClaRutaDiaLisCre        VARCHAR(100);               -- Clave pantalla listado creditos Ruta Dia/ Clientes Dia
    DECLARE Var_ClaCreditoID            VARCHAR(100);               -- Clave consultas de credito por ID
    DECLARE Var_ClaDescargaCreditos     VARCHAR(100);               -- Clave pantalla descarga de creditos Ruta Dia/ Clientes Dia


	-- Asignacion de Constantes
	SET Var_NumLisPrincipal		:= 1;									-- Lista principal
	SET Var_LisCredClientes		:= 2;									-- Lista  de los creditos del cliente
	SET Var_LisInforCredito		:= 3;									-- Lista  de las informacion del credito
	SET Var_LisDefaultRuta		:= 4;									-- Lista  de las de creditos ruta del dia(presenta lentitud)
	SET Var_LisCreditosBancas   := 5;
	SET Var_LisResumenCredito	:= 6;
	SET Var_LisDetalladaCredito := 7;

	SET Entero_Cero				:= 0;									-- Entero cero
	SET Cadena_Vacia        	:= '';
	SET Entero_Uno					:= 1;									-- Entero uno
	SET Entero_Dos					:= 2;									-- Entero dos
	SET Fecha_Vacia				:= '1900-01-01';					-- Fecha Vacia
	SET Par_TamanioLista 		:= IFNULL(Par_TamanioLista, Entero_Cero);
	SET Par_PosicionInicial 	:= IFNULL(Par_PosicionInicial, Entero_Cero);
	SET FechaMaxima 			:= '9999-12-31';
	SET TipoPrepagoProy			:= 'P';
	SET Var_AdelantaFecha		:= 'N';

	-- Clave de las pantallas para consultas
    SET Var_ClaConDefault       := '00CON-DEFAULT';             -- Consulta por default
    SET Var_ClaRutaDiaLisCre    := '01RD-CD-LISCRE';            -- Ruta del dia / Clientes del dia -- Listado de creditos
    SET Var_ClaRutaDiaNomInput  := '02RD-CD-INPUTNAME';         -- Ruta del dia / Clientes del dia -- Input Nombre
    SET Var_ClaConCredNomInput  := '03CRE-CC-INPUTNAME';        -- Creditos / Consultas -- Busqueda por nombre de cliente
    SET Var_ClaCreditoID        := '04ANY-CREDITID';            -- Cualquier pantalla que requiera busqueda de credito por id
	SET Var_ClaDescargaCreditos := '05RD-CD-CREDOWNLOAD';       -- Ruta del dia / Clientes del dia -- Boton descarga de creditos

    IF (Par_NumLis = Var_NumLisPrincipal) THEN
       SET @Var_QueryListaCreditos	:= 'SELECT
                                                cred.CreditoID,                  cred.LineaCreditoID,                 cred.ClienteID,              cred.CuentaID,               cred.Clabe,                  cred.MonedaID,
                                                cred.ProductoCreditoID,          cred.DestinoCreID,                   cred.MontoCredito,           cred.TipoCredito,            cred.Relacionado,            cred.SolicitudCreditoID,
                                                cred.TipoFondeo,                 cred.InstitFondeoID,                 cred.LineaFondeo,            cred.FechaInicio,            cred.FechaInicioAmor,        cred.FechaVencimien,
                                                cred.CalcInteresID,              cred.TasaBase,                       cred.TasaFija,               cred.SobreTasa,              cred.PisoTasa,               cred.TechoTasa,
                                                cred.TipCobComMorato,            cred.FactorMora,                     cred.FrecuenciaCap,          cred.PeriodicidadCap,        cred.FrecuenciaInt,          cred.PeriodicidadInt,
                                                cred.TipoPagoCapital,            cred.NumAmortizacion,                cred.MontoCuota,             cred.FechTraspasVenc,        cred.FechTerminacion,        cred.IVAInteres,
                                                cred.IVAComisiones,              cred.Estatus,                        cred.FechaAutoriza,          cred.UsuarioAutoriza,        cred.SaldoCapVigent,         cred.SaldoCapAtrasad,
                                                cred.SaldoCapVencido,            cred.SaldCapVenNoExi,                cred.SaldoInterOrdin,        cred.SaldoInterAtras,        cred.SaldoInterVenc,         cred.SaldoInterProvi,
                                                cred.SaldoIntNoConta,            cred.SaldoIVAInteres,                cred.SaldoMoratorios,        cred.SaldoIVAMorator,        cred.SaldComFaltPago ,       cred.SalIVAComFalPag,
(cred.SaldoOtrasComis + cred.SaldoComServGar) AS SaldoOtrasComis, (cred.SaldoIVAComisi + cred.SaldoIVAComSerGar) AS  SaldoIVAComisi,    cred.ProvisionAcum,     cred.PagareImpreso,    cred.FechaInhabil,           cred.CalendIrregular,
                                                cred.DiaPagoInteres,             cred.DiaPagoCapital,                 cred.DiaPagoProd,            cred.DiaMesInteres,          cred.DiaMesCapital,          cred.AjusFecUlVenAmo,
                                                cred.AjusFecExiVen,              cred.NumTransacSim,                  cred.FechaMinistrado,        cred.FolioDispersion,        cred.SucursalID,             cred.ValorCAT,
                                                cred.ClasifRegID,                cred.MontoComApert,                  cred.IVAComApertura,         cred.PlazoID,                cred.TipoDispersion,         cred.CuentaCLABE,
                                                cred.TipoCalInteres,             cred.TipoGeneraInteres,              cred.MontoDesemb,            cred.MontoPorDesemb,         cred.NumAmortInteres,        cred.AporteCliente,
                                                cred.PorcGarLiq,                 cred.MontoSeguroVida,                cred.SeguroVidaPagado,       cred.ForCobroSegVida,        cred.ComAperPagado,          cred.ForCobroComAper,
                                                cred.ClasiDestinCred,            cred.CicloGrupo,                     cred.GrupoID,                cred.TipoPrepago,            cred.SaldoMoraVencido,       cred.SaldoMoraCarVen,
                                                cred.DescuentoSeguro,            cred.MontoSegOriginal,               cred.IdenCreditoCNBV,        cred.CobraSeguroCuota,       cred.CobraIVASeguroCuota,    cred.MontoSeguroCuota,
                                                cred.IVASeguroCuota,             cred.CobraComAnual,                  cred.TipoComAnual,           cred.BaseCalculoComAnual,    cred.MontoComAnual,          cred.PorcentajeComAnual,
                                                cred.DiasGraciaComAnual,         cred.SaldoComAnual,                  cred.TipoLiquidacion,        cred.CantidadPagar,          cred.ComAperCont,            cred.IVAComAperCont,
                                                cred.ComAperReest,               cred.IVAComAperReest,                cred.FechaAtrasoCapital,     cred.FechaAtrasoInteres,     cred.TipoConsultaSIC,        cred.FolioConsultaBC,
                                                cred.FolioConsultaCC,            cred.EsAgropecuario,                 cred.TipoCancelacion,        cred.Refinancia,             cred.CadenaProductivaID,     cred.RamaFIRAID,
                                                cred.SubramaFIRAID,              cred.ActividadFIRAID,                cred.TipoGarantiaFIRAID,     cred.EstatusGarantiaFIRA,    cred.ProgEspecialFIRAID,     cred.FechaCobroComision,
                                                cred.EsAutomatico,               cred.TipoAutomatico,                 cred.InvCredAut,             cred.CtaCredAut,             cred.AcreditadoIDFIRA,       cred.CreditoIDFIRA,
                                                cred.InteresAcumulado,           cred.InteresRefinanciar,             cred.Reacreditado,           cred.TipoComXApertura,       cred.MontoComXApertura,      cred.DiasAtrasoMin,
                                                cred.ReferenciaPago,             cred.NivelID,                        cred.CobraAccesorios,        prod.Descripcion,
                                                CASE cred.Estatus WHEN "I" THEN "INACTIVO"
                                                             WHEN "A" THEN "AUTORIZADO"
                                                             WHEN "V" THEN "VIGENTE"
                                                             WHEN "P" THEN "PAGADO"
                                                             WHEN "C" THEN "CANCELADO"
                                                             WHEN "B" THEN "VENCIDO"
                                                             WHEN "K" THEN "CASTIGADO"
                                                END AS DescripcionStatus
                                        FROM CREDITOS cred INNER JOIN PRODUCTOSCREDITO prod ON cred.ProductoCreditoID = prod.ProducCreditoID';

        IF (Par_ClienteID >  Entero_Cero) THEN
				SET @Var_QueryListaCreditos := CONCAT(@Var_QueryListaCreditos, ' WHERE ClienteID = ', Par_ClienteID);
		END IF;

        IF (Par_ClienteID = Entero_Cero) THEN
				SET @Var_QueryListaCreditos := CONCAT(@Var_QueryListaCreditos, ' ORDER BY ClienteID ');
				IF (Par_TamanioLista > Entero_Cero) THEN
					SET @Var_QueryListaCreditos := CONCAT(@Var_QueryListaCreditos, ' LIMIT ', Par_PosicionInicial, ' , ', Par_TamanioLista);
				END IF;
				IF (Par_TamanioLista = Entero_Cero AND Par_PosicionInicial > Entero_Cero ) THEN
					SELECT COUNT(ClienteID)
						INTO Par_TamanioLista
						FROM CLIENTES;
					SET @Var_QueryListaCreditos := CONCAT(@Var_QueryListaCreditos, ' LIMIT ', Par_PosicionInicial, ' , ', Par_TamanioLista);
				END IF;
		END IF;

        PREPARE sentenciaListaCreditos FROM @Var_QueryListaCreditos;
		EXECUTE sentenciaListaCreditos;
		DEALLOCATE PREPARE sentenciaListaCreditos;
    END IF;

	-- COnsulta de los creditos del cliente
	IF(Par_NumLis = Var_LisCredClientes) THEN

		SELECT	CRED.CreditoID,		CRED.LineaCreditoID,		CRED.CuentaID,		CRED.MontoCredito,		CRED.TipoCredito,	CRED.Estatus,
				CASE WHEN CRED.TipoCredito = 'N' THEN 'NUEVO' WHEN CRED.TipoCredito = 'R' THEN 'REESTRUCTURA' WHEN CRED.TipoCredito = 'O' THEN 'RENOVACION' END AS DescTipoCredito,
				CASE WHEN CRED.Estatus = 'I' THEN 'INACTIVO' WHEN CRED.Estatus = 'A' THEN 'AUTORIZADO' WHEN CRED.Estatus = 'V' THEN 'VIGENTE' WHEN CRED.Estatus = 'K' THEN 'CASTIGADO'
					WHEN CRED.Estatus = 'P' THEN 'PAGADO' WHEN CRED.Estatus = 'C' THEN 'CANCELADO' WHEN CRED.Estatus = 'V' THEN 'VENCIDO' END AS DescEstaCredito,
				CRED.ProductoCreditoID,		PROD.Descripcion AS DescripcionProd,		CRED.FechaVencimien,		CRED.FechaMinistrado,		CRED.MontoCredito AS SaldoCredito
		FROM CREDITOS CRED
		INNER JOIN PRODUCTOSCREDITO PROD ON PROD.ProducCreditoID = CRED.ProductoCreditoID
		WHERE CRED.ClienteID = Par_ClienteID;

	END IF;
	-- CONSULTA DE VARIAS PANTALLAS
	IF(Par_NumLis = Var_LisInforCredito) THEN

		SET Par_FechaExigible	:= IFNULL(Par_FechaExigible, Fecha_Vacia);
		SET Var_AdelantaFecha	:= 'N';
        SET Par_NombreConsulta := IFNULL(Par_NombreConsulta, Cadena_Vacia);
		SET Var_NumSubConsulta := 1;

		SELECT 		FechaSistema,		FUNCIONDIAHABILANT(Var_FecActual, 1,1)
			INTO 	Var_FecActual, 		Var_FechaAnt
		FROM PARAMETROSSIS;

        IF(IFNULL(Par_CreditoID, Entero_Cero) != Entero_Cero) THEN
            SET Par_NombreConsulta  := Var_ClaCreditoID;
        END IF;

        CASE Par_NombreConsulta
            -- Consulta de autorizacion de Creditos que desean que salgan todos los creditos incluyendo los vigentes, vencidos y pendientes por Autorizar
            WHEN Var_ClaConCredNomInput THEN
                SET Var_NumSubConsulta      := 2;
                SET Var_AdelantaFecha       := 'S';

            -- Consulta en la seccion de ruta del dia por credito estatus v b se usa la 5 por el estatus de pago
            WHEN Var_ClaRutaDiaNomInput THEN
                SET Var_NumSubConsulta      := 5;
                SET Var_AdelantaFecha       := 'S';

            -- Consulta por id del credito todos los creditos
            WHEN Var_ClaCreditoID       THEN
                SET Var_NumSubConsulta      := 4;

            -- Opcion listado de creditos ruta del dia
            WHEN Var_ClaRutaDiaLisCre   THEN
                SET Var_NumSubConsulta      := 5;

            -- Opcion descarga de creditos RutaDia / Clientes del dia -- Descarga
            WHEN Var_ClaDescargaCreditos THEN
                SET Var_NumSubConsulta      := 6;

            ELSE
                SET Var_NumSubConsulta      := 1;
        END CASE;

        IF(Var_AdelantaFecha = 'S') THEN
            SET Par_FechaExigible   := DATE_ADD(Var_FecActual, INTERVAl 6 MONTH);
        END IF;

        CALL BANCREDITOSCON(Par_ClienteID,			Par_CreditoID,		Par_PromotorID,		Par_NombreCliente,		Par_TamanioLista,
                            Par_PosicionInicial,	Par_Estatus,		Par_FechaExigible,	Par_FechaPagado,		Var_NumSubConsulta,
                            Par_NombreConsulta,     Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	    Aud_DireccionIP,
                            Aud_ProgramaID,         Aud_Sucursal,		Aud_NumTransaccion);

	END IF;

	-- Consulta de toda la informacion del credito Se cambia por modificaciones de consultas(lentitud)
	IF(Par_NumLis = Var_LisDefaultRuta) THEN


		DROP TEMPORARY TABLE IF EXISTS TMP_BANCLIENTES_2;

		CREATE TEMPORARY TABLE `TMP_BANCLIENTES_2` (
			  `ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Identificador de la tabla',
			  `PosicionID` int(11) DEFAULT NULL COMMENT 'Numero de la posicion',
			  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero del cliente',
			  `CreditoID` bigint(20) DEFAULT NULL COMMENT 'Numero del credito',
			  `Fecha` date DEFAULT NULL COMMENT 'Fecha del proceso',
			  `Hora` time DEFAULT NULL COMMENT 'hora del proceso',
			  `TipoMovs` char(2) DEFAULT NULL COMMENT 'Tipo de movimiento',
			  `EstatusMov` char(2) DEFAULT NULL COMMENT 'Estatus del movimiento',
			  `PromotorID` int(11) DEFAULT NULL COMMENT 'ID del Promotor',
			  `FechaExi` date DEFAULT NULL COMMENT 'Fecha de la primera amortizacion con exigibilidad del Credito',
			  `FechaPago` date DEFAULT NULL COMMENT 'Fecha de la ultima amortizacion con estatus pagado del Credito',
			  `MontoExigible` decimal(12,2) DEFAULT NULL COMMENT 'Monto exigible',
			  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
			  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
			  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
			  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
			  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
			  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
			  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
			  PRIMARY KEY (`ID`),
			  KEY `IDX_TMP_CREDITOSRUTADIA_01` (`PosicionID`),
			  KEY `IDX_TMP_CREDITOSRUTADIA_02` (`ClienteID`, `CreditoID`)
			) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 ;

		SET Par_FechaExigible := IFNULL(Par_FechaExigible, Fecha_Vacia);

		/*IF(Par_TamanioLista = Entero_Cero ) THEN
			SELECT COUNT(CreditoID)
				INTO Par_TamanioLista
				FROM AMORTICREDITO;
		END IF;*/


		SELECT 		FechaSistema,		FUNCIONDIAHABILANT(Var_FecActual, 1,1)
			INTO 	Var_FecActual, 		Var_FechaAnt
			FROM PARAMETROSSIS;

      	SET Var_TodosCred = 'S';     --  Se inicializa
		IF(Par_CreditoID = Entero_Cero AND Par_NombreCliente <> Cadena_Vacia ) THEN
			IF(Par_FechaExigible = Fecha_Vacia) THEN
				SET Var_TodosCred = 'S'; -- Es para la consulta donde van a autorizar Creditos que desean que salgan todos los creditos incluyendo los vigentes, vencidos y pendientes por Autorizar
			ELSE
				SET Var_TodosCred = 'N';
			END IF;
            -- SET Par_FechaExigible   := DATE_ADD(Par_FechaExigible, INTERVAl 6 MONTH);
			SET Par_FechaExigible   := DATE_ADD(Var_FecActual, INTERVAl 6 MONTH);
		END IF;

		SET Par_TamanioLista  := 1000;

		DELETE FROM TMP_CLIENTES WHERE NumTransaccion = Aud_NumTransaccion;
		SET @Num :=0;
		INSERT INTO TMP_CLIENTES (	PosicionID,			ClienteID, 		CreditoID,		Fecha,				Hora,
									TipoMovs,			EstatusMov,		EmpresaID,		Usuario,			FechaActual,
									DireccionIP,		ProgramaID,		Sucursal,		NumTransaccion
							)
							SELECT 	@Num := @Num +1,	ClienteID, 		CreditoID, 		Fecha, 				Hora,
									TipoMov, 			'PE',			Aud_EmpresaID,	Aud_Usuario,		Var_FecActual,
									Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
								FROM BITACORAMOVSWS WHERE Fecha = Var_FechaAnt
								ORDER BY Fecha, Hora;

		DELETE FROM TMP_CLIENTESBAJ WHERE NumTransaccion = Aud_NumTransaccion;
		SET @ID :=0;
		INSERT INTO TMP_CLIENTESBAJ(ClientesBajID,		Cantidad,					ClienteID,			PosicionID,			EmpresaID,
									Usuario,			FechaActual,				DireccionIP,		ProgramaID,			Sucursal,
									NumTransaccion
							)
							SELECT @ID := @ID +1, 		COUNT(CreditoID) AS Cant, 	ClienteID,			MIN(PosicionID),	Aud_EmpresaID,
									Aud_Usuario,		Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
									Aud_NumTransaccion
								FROM TMP_CLIENTES GROUP BY ClienteID HAVING Cant > 1;

		SELECT 		MIN(ID),				MAX(ID)
			INTO 	var_Conta,				Var_cantidad
			FROM TMP_CLIENTESBAJ
			WHERE NumTransaccion = Aud_NumTransaccion;

		WHILE(var_Conta <= Var_cantidad) DO
			SET Var_CantidadCre := NULL;
			SET Var_CreditoID := NULL;

			SELECT 		Cantidad, 			ClienteID,			PosicionID
				INTO 	Var_CantidadCre, 	Var_ClienteID,		Var_PosicionID
				FROM TMP_CLIENTESBAJ
					WHERE ID = var_Conta
					AND NumTransaccion = Aud_NumTransaccion;

			IF(IFNULL(Var_CreditoID, Entero_Cero) = Entero_Cero) THEN
				DELETE
					FROM TMP_CLIENTES
					WHERE ClienteID = Var_ClienteID
					AND NumTransaccion = Aud_NumTransaccion
					AND PosicionID > Var_PosicionID;
			END IF;

			SET var_Conta := var_Conta + 1;
		END WHILE;

		DELETE FROM TMP_BANCLIENTES_2 WHERE NumTransaccion = Aud_NumTransaccion;
		INSERT INTO TMP_BANCLIENTES_2 (
				ClienteID,			 	CreditoID,				PosicionID,			NumTransaccion,
				EstatusMov,				MontoExigible
			)
			SELECT 	CLI.ClienteID,		CRE.CreditoID,			CLI.PosicionID,		Aud_NumTransaccion,
					'PE',				FUNCIONEXIGIBLE(CRE.CreditoID)
				FROM TMP_CLIENTES CLI
				INNER JOIN CREDITOS CRE ON CRE.ClienteID = CLI.ClienteID
				INNER JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID = CRE.SolicitudCreditoID
				WHERE CRE.CreditoID = IF(Par_CreditoID > Entero_Cero, Par_CreditoID, CRE.CreditoID)
				AND CRE.ClienteID = IF(Par_ClienteID > Entero_Cero, Par_ClienteID, CRE.ClienteID)
				AND SOL.PromotorID = IF(Par_PromotorID > Entero_Cero, Par_PromotorID, SOL.PromotorID)
				AND CRE.Estatus = IF(Par_Estatus <> Cadena_Vacia , Par_Estatus,  CRE.Estatus)
				AND CLI.NumTransaccion = Aud_NumTransaccion;

		INSERT INTO TMP_BANCLIENTES_2(
				ClienteID, 			CreditoID,			EstatusMov,			NumTransaccion,			MontoExigible
		)
		SELECT 	 CLI.ClienteID,		CRE.CreditoID,		'PE',				Aud_NumTransaccion,		FUNCIONEXIGIBLE(CRE.CreditoID)
			FROM CLIENTES CLI
			INNER JOIN CREDITOS CRE ON CRE.ClienteID = CLI.ClienteID
			INNER JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID = CRE.SolicitudCreditoID AND SOL.PromotorID = IF(Par_PromotorID > Entero_Cero, Par_PromotorID, SOL.PromotorID)
			LEFT JOIN TMP_CLIENTES TMP ON TMP.ClienteID = CLI.ClienteID AND TMP.NumTransaccion = Aud_NumTransaccion
			WHERE CLI.Estatus = 'A' AND TMP.ClienteID IS NULL AND CRE.Estatus NOT IN ('C', 'I', 'K');

		UPDATE TMP_BANCLIENTES_2 CLI
			INNER JOIN BITACORAMOVSWS MOV ON MOV.ClienteID = CLI.ClienteID AND CLI.CreditoID = MOV.CreditoID
			SET CLI.PosicionID = CLI.PosicionID + 99999,
				CLI.EstatusMov = 'PI'
			WHERE MOV.Fecha = Var_FecActual
			AND MOV.TipoMov = 'PC'
			AND CLI.MontoExigible > 0;

		UPDATE TMP_BANCLIENTES_2 CLI
			INNER JOIN BITACORAMOVSWS MOV ON MOV.ClienteID = CLI.ClienteID AND CLI.CreditoID = MOV.CreditoID
			SET CLI.EstatusMov = 'PC'
			WHERE MOV.Fecha = Var_FecActual
			AND MOV.TipoMov = 'PC'
			AND CLI.MontoExigible = 0;

		UPDATE TMP_BANCLIENTES_2 CLI
			INNER JOIN BITACORAMOVSWS MOV ON MOV.ClienteID = CLI.ClienteID AND CLI.CreditoID = MOV.CreditoID
			SET CLI.EstatusMov = 'NP'
			WHERE MOV.Fecha = Var_FecActual
			AND MOV.TipoMov = 'IC';

		SELECT	CRE.CreditoID,					CRE.LineaCreditoID,					CRE.ClienteID,						CONCAT(CONCAT(CLI.NombreCompleto,' - '),CLI.Observaciones) as NombreCliente,	CRE.CuentaID,
				CRE.Clabe,						CRE.MonedaID,						MON.Descripcion AS DescMoneda,		CRE.ProductoCreditoID,					PROD.Descripcion AS NombreProducto,
				CRE.DestinoCreID,				DES.Descripcion AS NombreDestCredito,CRE.MontoCredito,					CRE.TipoCredito,						CRE.Relacionado,
				CRE.SolicitudCreditoID,			CRE.TipoFondeo,						CRE.InstitFondeoID,					CRE.LineaFondeo,						CRE.FechaInicio,
				CRE.FechaInicioAmor,			CRE.FechaVencimien,					CRE.CalcInteresID,					CRE.TasaBase,							CRE.TasaFija,
				CRE.SobreTasa,					CRE.PisoTasa,						CRE.TechoTasa,						CRE.TipCobComMorato,					CRE.FactorMora,
				CRE.FrecuenciaCap,				CRE.PeriodicidadCap,				CRE.FrecuenciaInt,					CRE.PeriodicidadInt,					CRE.TipoPagoCapital,
				CRE.NumAmortizacion,			CRE.MontoCuota,						CRE.FechTraspasVenc,				CRE.FechTerminacion,					CRE.IVAInteres,
				CRE.IVAComisiones ,				CRE.Estatus,						CRE.FechaAutoriza ,					CRE.UsuarioAutoriza,					CRE.SaldoCapVigent,
				CRE.SaldoCapAtrasad,			CRE.SaldoCapVencido,				CRE.SaldCapVenNoExi,				CRE.SaldoInterOrdin,					CRE.SaldoInterAtras,
				CRE.SaldoInterVenc,				CRE.SaldoInterProvi,				CRE.SaldoIntNoConta,				CRE.SaldoIVAInteres,					CRE.SaldoMoratorios,
				CRE.SaldoIVAMorator,			CRE.SaldComFaltPago,				CRE.SalIVAComFalPag,				(CRE.SaldoOtrasComis + CRE.SaldoComServGar) AS SaldoOtrasComis, (CRE.SaldoIVAComisi + CRE.SaldoIVAComSerGar) AS SaldoIVAComisi,
				CRE.ProvisionAcum,				CRE.PagareImpreso,					CRE.FechaInhabil,					CRE.CalendIrregular,					CRE.DiaPagoInteres,
				CRE.DiaPagoCapital,				CRE.DiaPagoProd,					CRE.DiaMesInteres,					CRE.DiaMesCapital,						CRE.AjusFecUlVenAmo,
				CRE.AjusFecExiVen,				CRE.NumTransacSim,					CRE.FechaMinistrado,				CRE.FolioDispersion,					CRE.SucursalID,
				CRE.ValorCAT,					CRE.ClasifRegID,					CRE.MontoComApert,					CRE.IVAComApertura,						CRE.PlazoID,
				CRE.TipoDispersion,				CRE.CuentaCLABE ,					CRE.TipoCalInteres,					CRE.TipoGeneraInteres,					CRE.MontoDesemb,
				CRE.MontoPorDesemb,				CRE.NumAmortInteres,				CRE.AporteCliente,					CRE.PorcGarLiq,							CRE.MontoSeguroVida,
				CRE.SeguroVidaPagado,			CRE.ForCobroSegVida,				CRE.ComAperPagado,					CRE.ForCobroComAper,					CRE.ClasiDestinCred,
				CRE.CicloGrupo,					CRE.GrupoID,						CRE.TipoPrepago,					CRE.SaldoMoraVencido,					CRE.SaldoMoraCarVen,
				CRE.DescuentoSeguro,			CRE.MontoSegOriginal,				CRE.IdenCreditoCNBV,				CRE.CobraSeguroCuota,					CRE.CobraIVASeguroCuota,
				CRE.MontoSeguroCuota,			CRE.IVASeguroCuota,					CRE.CobraComAnual,					CRE.TipoComAnual,						CRE.BaseCalculoComAnual,
				CRE.MontoComAnual,				CRE.PorcentajeComAnual,				CRE.DiasGraciaComAnual,				CRE.SaldoComAnual,						CRE.TipoLiquidacion,
				CRE.CantidadPagar,				CRE.ComAperCont,					CRE.IVAComAperCont,					CRE.ComAperReest,						CRE.IVAComAperReest,
				CRE.FechaAtrasoCapital,			CRE.FechaAtrasoInteres,				CRE.TipoConsultaSIC,				CRE.FolioConsultaBC,					CRE.FolioConsultaCC,
				CRE.EsAgropecuario,				CRE.TipoCancelacion ,				CRE.Refinancia,						CRE.CadenaProductivaID,					CATPR.NomCadenaProdSCIAN NombreCadenaProductiva,
				CRE.RamaFIRAID,					CATFIR.DescripcionRamaFIRA AS DescRamaFIRA,	CRE.SubramaFIRAID,			CRE.ActividadFIRAID,					CRE.TipoGarantiaFIRAID,
				CRE.EstatusGarantiaFIRA,		CRE.ProgEspecialFIRAID,				FIRA.SubPrograma AS DescProgEspecialFIRA, CRE.FechaCobroComision,			CRE.EsAutomatico,
				CRE.TipoAutomatico,				CRE.InvCredAut,						CRE.CtaCredAut,						CRE.AcreditadoIDFIRA,					CRE.CreditoIDFIRA,
				CRE.InteresAcumulado,			CRE.InteresRefinanciar,				CRE.Reacreditado,					CRE.TipoComXApertura,					CRE.MontoComXApertura,
				CRE.DiasAtrasoMin,				CRE.ReferenciaPago,					CRE.NivelID,						CRE.CobraAccesorios,					FUNCIONFECHAEXIGIBLECRED(CRE.CreditoID) AS FechaExigible,
				FUNCALNUMAMORTIZACION(CRE.CreditoID,Entero_Uno) AS NumAmortPorPagar,	FUNCALNUMAMORTIZACION(CRE.CreditoID,Entero_Dos) AS NumAmortPagada,		CRE.NumAmortizacion AS NumTotalAmort,
				FUNCIONCONFINIQCRE(CRE.CreditoID) AS MontoLiquidarCred,					FUNCIONEXIGIBLE(CRE.CreditoID) AS MontoExigible,						SOL.MontoAutorizado,
				CASE CRE.Estatus WHEN "I" THEN "INACTIVO"
								 WHEN "A" THEN "AUTORIZADO"
								 WHEN "V" THEN "VIGENTE"
								 WHEN "P" THEN "PAGADO"
								 WHEN "C" THEN "CANCELADO"
								 WHEN "B" THEN "VENCIDO"
								 WHEN "K" THEN "CASTIGADO"
				END AS DescripcionStatus,
				CASE CRE.FrecuenciaCap WHEN "S" THEN "Semanal"
									   WHEN "C" THEN "Catorcenal"
									   WHEN "Q" THEN "Quincenal"
									   WHEN "M" THEN "Mensual"
									   WHEN "P" THEN "Periodo"
									   WHEN "B" THEN "Bimestral"
									   WHEN "T" THEN "Trimestral"
									   WHEN "R" THEN "TetraMestral"
									   WHEN "E" THEN "Semestral"
									   WHEN "A" THEN "Anual"
									   WHEN "L" THEN "Libres"
									   WHEN "U" THEN "Unico"
				END AS DescFrecuenciaCap,
				CASE CRE.FrecuenciaInt WHEN "S" THEN "Semanal"
								   WHEN "C" THEN "Catorcenal"
								   WHEN "Q" THEN "Quincenal"
								   WHEN "M" THEN "Mensual"
								   WHEN "P" THEN "Periodo"
								   WHEN "B" THEN "Bimestral"
								   WHEN "T" THEN "Trimestral"
								   WHEN "R" THEN "TetraMestral"
								   WHEN "E" THEN "Semestral"
								   WHEN "A" THEN "Anual"
								   WHEN "L" THEN "Libres"
								   WHEN "U" THEN "Unico"
				END AS DescFrecuenciaInt,
				FUNCIONTOTDEUDACRE(CRE.CreditoID) AS MontoTotDeuda,
                FUNCIONEXIGIBLECAP(CRE.CreditoID, Var_FecActual) AS CapitalExigible,
                FUNCIONEXIGIBLEINT(CRE.CreditoID, Var_FecActual) AS InteresExigible,
                FUNCIONIVAINTERESCRE(CRE.CreditoID) AS IVAInteresEx,
                FUNCIONEXIGIBLEACC(CRE.CreditoID, Var_FecActual) AS AccesoriosExigibles,
				FUNCIONIVAACCEXIGIBLE(CRE.CreditoID, Var_FecActual) AS IVAAccesoriosEx,
				FUNCIONDIASATRASO(CRE.CreditoID, Var_FecActual) AS DiasAtraso,
				IFNULL(TMP.EstatusMov, 'PE') AS EstatusPago,
				TMP.PosicionID, SOL.PromotorID,
				IF ((PROD.TipoPrepago = TipoPrepagoProy), FNFINIQCUOTASCOMPLETAS(CRE.CreditoID, ESQ.CobraComLiqAntici), FUNCIONCONFINIQCRE(CRE.CreditoID)) AS MontoLiquidarCredProy
		FROM CREDITOS CRE
		INNER JOIN CLIENTES CLI ON CLI.ClienteID = CRE.ClienteID AND CRE.ClienteID = IF(Par_ClienteID > Entero_Cero, Par_ClienteID, CRE.ClienteID)
		INNER JOIN PRODUCTOSCREDITO PROD ON PROD.ProducCreditoID = CRE.ProductoCreditoID
		INNER JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID = CRE.SolicitudCreditoID AND SOL.PromotorID = IF(Par_PromotorID > Entero_Cero, Par_PromotorID, SOL.PromotorID)
		INNER JOIN DESTINOSCREDITO DES ON DES.DestinoCreID = CRE.DestinoCreID
		INNER JOIN MONEDAS MON ON MON.MonedaId = CRE.MonedaID
		-- LEFT JOIN TMP_BANCLIENTES TMP ON TMP.ClienteID = CLI.ClienteID AND TMP.CreditoID = CRE.CreditoID AND TMP.NumTransaccion = Aud_NumTransaccion
		LEFT JOIN TMP_BANCLIENTES_2 TMP ON TMP.ClienteID = CRE.ClienteID AND TMP.CreditoID = CRE.CreditoID
		LEFT JOIN CATRAMAFIRA CATFIR ON CATFIR.CveRamaFIRA = CRE.RamaFIRAID
		LEFT JOIN CATCADENAPRODUCTIVA CATPR ON CATPR.CveCadena = CRE.CadenaProductivaID
		LEFT JOIN CATFIRAPROGESP FIRA ON FIRA.CveSubProgramaID = CRE.ProgEspecialFIRAID
		INNER JOIN ESQUEMACOMPRECRE ESQ ON ESQ.ProductoCreditoID = CRE.ProductoCreditoID
		WHERE CRE.CreditoID = IF(Par_CreditoID <> Entero_Cero, Par_CreditoID, CRE.CreditoID)
		AND CLI.NombreCompleto LIKE CONCAT("%",Par_NombreCliente,"%")
      	AND CRE.Estatus = IF(Par_Estatus <> Cadena_Vacia , Par_Estatus,  CRE.Estatus)
      	AND IF(Var_TodosCred = 'N', CRE.Estatus IN('V', 'B'), CRE.Estatus = CRE.Estatus)
        /*La corrección de estatus fue por las pantallas de busqueda por nombre y por filtro desde la ruta del dia, las validaciones*/
		HAVING IFNULL(FechaExigible, Fecha_Vacia) <= IF(Par_FechaExigible <> Fecha_Vacia, Par_FechaExigible, IFNULL(FechaExigible, FechaMaxima))
		ORDER BY IFNULL(PosicionID, 99999)
		LIMIT Par_PosicionInicial, Par_TamanioLista;


		DELETE FROM TMP_BANCLIENTES_2 WHERE NumTransaccion = Aud_NumTransaccion;
		DELETE FROM TMP_CLIENTESBAJ WHERE NumTransaccion = Aud_NumTransaccion;
		DELETE FROM TMP_CLIENTES WHERE NumTransaccion = Aud_NumTransaccion;
		DROP TEMPORARY TABLE IF EXISTS TMP_BANCLIENTES_2;

	END IF;

	IF (Par_NumLis = Var_LisCreditosBancas) THEN
		SELECT	cred.CreditoID,					cred.ProductoCreditoID, 				cred.CuentaID,				cred.MonedaID,				cred.TasaFija,
				cred.ValorCAT,					cred.SaldoCapVigent,					cred.SaldoInterOrdin,		cred.SaldoIVAInteres,		cred.SaldoCapAtrasad,
				cred.SaldoInterAtras,			cred.SaldoMoratorios,					cred.SaldoOtrasComis,		cred.SaldoInterVenc,		pro.Descripcion DescProductoCred,
				mon.Descripcion DescMoneda,
				FUNCALNUMAMORTIZACION(cred.CreditoID,Entero_Uno) AS NumAmortPorPagar,
				FUNCIONFECHAEXIGIBLECRED(cred.CreditoID) AS FechaProxPago,
				FUNCIONTOTDEUDACRE(cred.CreditoID) AS MontoTotDeuda,
				BANFNEXIGIBLEALDIA(cred.CreditoID) AS MontoExigible,
				CASE cred.Estatus 	WHEN "I" THEN "INACTIVO"
									WHEN "A" THEN "AUTORIZADO"
									WHEN "V" THEN "VIGENTE"
									WHEN "P" THEN "PAGADO"
									WHEN "C" THEN "CANCELADO"
									WHEN "B" THEN "VENCIDO"
									WHEN "K" THEN "CASTIGADO"
				END AS DescripcionStatus
				FROM CREDITOS cred
				INNER JOIN PRODUCTOSCREDITO pro ON pro.ProducCreditoID = cred.ProductoCreditoID
				INNER JOIN MONEDAS mon ON mon.MonedaID = cred.MonedaID
				WHERE cred.ClienteID = Par_ClienteID
				ORDER BY cred.CreditoID;
    END IF;

	IF Par_NumLis  = Var_LisResumenCredito THEN
		SELECT Cre.CreditoID, Pro.Descripcion AS NombreProducto, Cre.MontoDesemb, FUNCIONTOTDEUDACRE(Cre.CreditoID) AS TotalAdeudo
			FROM CREDITOS Cre
			INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
			WHERE Cre.ClienteID = Par_ClienteID AND
				Cre.CreditoID = IF (Par_CreditoID > Entero_Cero, Par_CreditoID, Cre.CreditoID);
	END IF;

	IF Par_NumLis = Var_LisDetalladaCredito THEN

		SELECT ClienteID,SucursalID INTO Var_ClienteID, Var_SucCredito FROM CREDITOS WHERE CreditoID = Par_CreditoID;

		SELECT PagaIVA INTO Var_CliPagIVA FROM CLIENTES WHERE ClienteID = Var_ClienteID;

		SELECT IFNULL(IVA,Entero_Cero) INTO Var_IVASucurs FROM SUCURSALES WHERE  SucursalID = Var_SucCredito;



		SELECT
		    Cre.CreditoID,Pro.Descripcion AS NombreProducto, Cre.MontoDesemb,FUNCIONEXIGIBLE(Cre.CreditoID) AS TotalExigible, FUNCIONTOTDEUDACRE(Cre.CreditoID) AS TotalAdeudo,
		    FUNCALNUMAMORTIZACION(Cre.CreditoID,Entero_Dos) AS NumAmortPagada,
		    CASE Cre.FrecuenciaCap WHEN "S" THEN "Semanal"
		                                       WHEN "C" THEN "Catorcenal"
		                                       WHEN "Q" THEN "Quincenal"
		                                       WHEN "M" THEN "Mensual"
		                                       WHEN "P" THEN "Periodo"
		                                       WHEN "B" THEN "Bimestral"
		                                       WHEN "T" THEN "Trimestral"
		                                       WHEN "R" THEN "TetraMestral"
		                                       WHEN "E" THEN "Semestral"
		                                       WHEN "A" THEN "Anual"
		                                       WHEN "L" THEN "Libres"
		                                       WHEN "U" THEN "Unico"
		                END AS DescFrecuenciaCap,
		                Cre.TasaFija, Cre.FechaVencimien,
		                FORMAT(IFNULL(SUM(ROUND(Amo.SaldoCapVigente,2)  +
		                                  ROUND(Amo.SaldoCapAtrasa,2)   +
		                                  ROUND(Amo.SaldoCapVencido,2)  +
		                                  ROUND(Amo.SaldoCapVenNExi,2)),Entero_Cero),2) AS SaldoCapital,

		                    FORMAT(ROUND(IFNULL(SUM(ROUND(Amo.SaldoInteresOrd +
		                                              Amo.SaldoInteresAtr +
		                                              Amo.SaldoInteresVen +
		                                              Amo.SaldoInteresPro +
		                                              Amo.SaldoIntNoConta
		                                            ,2)),Entero_Cero), 2), 2) AS SaldoInteres,

		                    FORMAT(IFNULL(SUM(Amo.SaldoMoratorios + Amo.SaldoMoraVencido + Amo.SaldoMoraCarVen),Entero_Cero),2) AS SaldoMoratorios,

		                    FORMAT(ROUND(IFNULL(SUM(ROUND(Amo.SaldoComFaltaPa,2) + ROUND(Amo.SaldoOtrasComis,2)),Entero_Cero),2), 2) AS SaldoComisiones ,

		                    FORMAT(SUM(ROUND(ROUND(Amo.SaldoInteresOrd * IF(Var_CliPagIVA = 'S',Var_IVASucurs,0), 2) +
		                                 ROUND(Amo.SaldoInteresAtr * IF(Var_CliPagIVA = 'S',Var_IVASucurs,0), 2) +
		                                 ROUND(Amo.SaldoInteresVen * IF(Var_CliPagIVA = 'S',Var_IVASucurs,0), 2) +
		                                 ROUND(Amo.SaldoInteresPro * IF(Var_CliPagIVA = 'S',Var_IVASucurs,0), 2) +
		                                 ROUND(Amo.SaldoIntNoConta * IF(Var_CliPagIVA = 'S',Var_IVASucurs,0), 2) ,2)), 2) AS SaldoIVAInteres
		FROM CREDITOS Cre
		INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
		INNER JOIN AMORTICREDITO Amo ON Cre.CreditoID = Amo.CreditoID
		WHERE Cre.CreditoID = Par_CreditoID
		AND Cre.ClienteID = IF(Par_ClienteID > Entero_Cero,Par_ClienteID,Cre.ClienteID);


    END IF;


END TerminaStore$$
