-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSCAPITALREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDOSCAPITALREP`;

DELIMITER $$
CREATE PROCEDURE `SALDOSCAPITALREP`(
	-- ---------------------------------------------------
	-- SP PARA GENERAR EL REPORTE DE SALDOS DE CARTERA
	-- ---------------------------------------------------

    Par_Fecha					DATE,    -- parametro fecha
    Par_Sucursal				INT(11), -- parametro sucursal
    Par_Moneda					INT(11), -- parametro moneda
    Par_ProductoCre 			INT(11), -- parametro producto
    Par_Promotor 				INT(11), -- parametro promotor

    Par_Genero 					CHAR(1), -- parametro genero
    Par_Estado 					INT(11), -- parametro estado
    Par_Municipio 				INT(11), -- parametro municipio
    Par_Criterio 				CHAR(1), -- parametro criterio
    Par_AtrasoInicial 			INT(11), -- parametro atraso inicial

    Par_AtrasoFinal 			INT(11), -- parametro atraso final
    Par_InstitucionID 			INT(11), -- parametro atraso final
    Par_ConvenioNominaID    	BIGINT UNSIGNED, -- Numero del Convenio de Nomina

    Par_EmpresaID 				INT(11), -- parametro empresa id
    Aud_Usuario 				INT(11), -- parametro de auditoria usuario
    Aud_FechaActual 			DATETIME,    -- parametro de auditoria fecha actual
    Aud_DireccionIP 			VARCHAR(15), -- parametro de auditoria direccion ip

    Aud_ProgramaID	 			VARCHAR(50), -- parametro de auditoria programa id
    Aud_Sucursal 				INT(11),     -- parametro de auditoria sucursal
    Aud_NumTransaccion 			BIGINT(20)	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE pagoExigible        DECIMAL(12,2); -- pago exigible
	DECLARE TotalCartera        DECIMAL(12,2); -- total de cartera
	DECLARE TotalCapVigent      DECIMAL(12,2); -- total de capital vigente
	DECLARE TotalCapVencido     DECIMAL(12,2); -- total de capital vencido
	DECLARE nombreUsuario       VARCHAR(50);   -- nombre del usuario

	DECLARE Var_Sentencia       VARCHAR(9000); -- variable sentencia
    DECLARE Var_PerFisica       CHAR(1);       -- variable persona fisica
	DECLARE Var_RestringeReporte	CHAR(1);
	DECLARE Var_UsuDependencia		VARCHAR(1000);
	DECLARE Var_MontoAccesorio		DECIMAL(14,2);
	DECLARE Var_MontoIntAccesorio	DECIMAL(14,2);
	DECLARE Var_MontoIVAIntAcce		DECIMAL(14,2);

-- Declaracion contadores
	DECLARE Con_PagareTfija     INT(11); -- pagare tasa fija
	DECLARE Con_Saldos          INT(11); -- contador de saldos
	DECLARE Con_PagareImp       INT(11); -- contador pagare imp
	DECLARE Con_PagoCred        INT(11); -- contador pago de credito

-- Declaracion de Constantes
	DECLARE Cadena_Vacia        CHAR(1); -- Cadena vacia
	DECLARE Fecha_Vacia         DATE;    -- fecha vacia
	DECLARE Entero_Cero         INT(11); -- entero cero
	DECLARE Lis_SaldosRep       INT(11); -- lista de reportes de saldo
	DECLARE Con_Foranea         INT(11); -- con foranea

	DECLARE EstatusVigente      CHAR(1); -- estatus vigente

    DECLARE EstatusAtras        CHAR(1); -- estatus atrasado
	DECLARE EstatusPagado       CHAR(1); -- estatus pagado
	DECLARE EstatusVencido      CHAR(1); -- estatus vencido
	DECLARE CienPorciento       DECIMAL(10,2); -- cien por ciento
	DECLARE FechaSist           DATE; -- fecha del sistema

	DECLARE SiCobraIVA          CHAR(1); -- si cobra iva
	DECLARE CriterioConta       CHAR(1); -- criterio contable
	DECLARE CriterioComer       CHAR(1); -- criterio comercial
    DECLARE EsNomina           	CHAR(1); -- Producto de nomina
    DECLARE Cons_No           	CHAR(1); -- Constante NO
    DECLARE Cons_Si           	CHAR(1); -- Constante SI
	DECLARE EstatusSuspendido	CHAR(1);	-- Estatus Ssupendido
    DECLARE Cons_OtrasCom		INT(11); -- Constante para el Tipo de Movimiento: 43 - Otras Comisiones
	DECLARE Cons_OtraIVACom		INT(11); -- Constante para el Tipo de Movimiento: 26 - IVA Otras Comisiones
	DECLARE Cons_NatMovimiento	CHAR(1); -- Constante para la Naturaleza del Movimiento  C: Cargo o A: Abono segùn sea el caso

-- Asignacion de constantes
	SET Cadena_Vacia            := '';
	SET Fecha_Vacia             := '1900-01-01';
	SET Entero_Cero             := 0;
	SET Lis_SaldosRep           := 4;
	SET EstatusVigente          := 'V';
	SET EstatusAtras            := 'A';
	SET EstatusPagado           := 'P';
	SET CienPorciento           := 100.00;
	SET EstatusVencido          := 'B';
	SET Var_PerFisica           := 'F';
	SET SiCobraIVA              := 'S';
	SET CriterioConta           := 'C';
	SET CriterioComer           := 'O';
	SET Cons_No           		:= 'N';
	SET Cons_Si           		:= 'S';
    SET EstatusSuspendido       := 'S';
	SET Cons_OtrasCom			:= 43; -- Tipo de Movimiento: 43 - Otras Comisiones
	SET Cons_OtraIVACom			:= 26; -- Tipo de Movimiento: 26 - IVA Otras Comisiones
	SET Cons_NatMovimiento		:= 'C'; --  Naturaleza del Movimiento  C: Cargo

	SELECT	RestringeReporte
		INTO Var_RestringeReporte
	FROM PARAMETROSSIS LIMIT 1;
	SET Var_RestringeReporte:= IFNULL(Var_RestringeReporte,'N');

    SET Par_ProductoCre := IFNULL(Par_ProductoCre, Entero_Cero);
    SET EsNomina		:= (SELECT ProductoNomina
								FROM PRODUCTOSCREDITO
                                WHERE ProducCreditoID = Par_ProductoCre);
	SET EsNomina		:= IFNULL(EsNomina, Cons_No);


	CALL TRANSACCIONESPRO (Aud_NumTransaccion);

	SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);
	DROP TEMPORARY TABLE IF EXISTS tmp_TMPSALDOSCAPITALREP;
	CREATE TEMPORARY TABLE tmp_TMPSALDOSCAPITALREP (
			Transaccion         BIGINT,
			GrupoID             INT(12),
			NombreGrupo         VARCHAR(200),
			CreditoID           BIGINT(12),
			ClienteID           INT(12),
			NombreCompleto      VARCHAR(250),
			ProductoCreditoID   INT(12),
			Descripcion         VARCHAR(100),
			TasaFija			DECIMAL(12,4),
			MontoCredito        DECIMAL(14,2),
			FechaInicio         DATE,
			FechaVencimiento    DATE,
			CapitalVigente      DECIMAL(14,2),
			InteresesVigente    DECIMAL(14,2),
			MoraVigente         DECIMAL(14,2),
			CargosVigente       DECIMAL(14,2),
			IvaVigente          DECIMAL(14,2),
			TotalVigente        DECIMAL(14,2),
			CapitalVencido      DECIMAL(14,2),
			InteresesVencido    DECIMAL(14,2),
			MoraVencido         DECIMAL(14,2),
			CargosVencido       DECIMAL(14,2),
			IvaVencido          DECIMAL(14,2),
			TotalVencido        DECIMAL(14,2),
			CapitalAtrasado		DECIMAL(14,2),
			DiasAtraso          INT(12),
			SucursalID          INT(12),
			NombreSucurs        VARCHAR(50),
			PromotorActual      INT(12),
			NombrePromotor      VARCHAR(100),
			FechaEmision        DATE,
			HoraEmision         TIME,
			EstatusCre          CHAR(1),
            NombreInstit		VARCHAR(100),
            DesConvenio			VARCHAR(100),
            ProductoNomina		CHAR(1),
            MontoOtrasComisiones	DECIMAL(14,2),
            MontoIVAOtrasComisiones	DECIMAL(14,2),
            MontoNotasCargo			DECIMAL(14,2),
            MontoIVANotasCargo		DECIMAL(14,2),
            TotalNotasCargo			DECIMAL(14,2),
			Accesorio			DECIMAL(14,2),
			InteresAccesorio	DECIMAL(14,2),
			IvaInteresAccesorio	DECIMAL(14,2),
			KEY `IDX_tmp_TMPSALDOSCAPITALREP_1` (`CreditoID`));


			-- Tabla para los Accesorios
			DROP TEMPORARY TABLE IF EXISTS tmp_ACCESORIOSREP;
			CREATE TEMPORARY TABLE tmp_ACCESORIOSREP(
				CreditoID BIGINT(12),
				MontoAccesorio DECIMAL(14,2),
				InteresAccesorio DECIMAL(14,2),
				IVAInteresAccesorio DECIMAL(14,2),
				KEY `IDX_tmp_ACCESORIOSREP1` (`CreditoID`)
			);


	SET Var_Sentencia := '
	INSERT INTO tmp_TMPSALDOSCAPITALREP (
			Transaccion,        		GrupoID,            NombreGrupo,        CreditoID,          ClienteID,
			NombreCompleto,     		ProductoCreditoID,  Descripcion,        TasaFija,			MontoCredito,       FechaInicio,
			FechaVencimiento,   		CapitalVigente,     InteresesVigente,   MoraVigente,        CargosVigente,
			IvaVigente,         		TotalVigente,       CapitalVencido,     InteresesVencido,   MoraVencido,
			CargosVencido,     		 	IvaVencido,         TotalVencido,       CapitalAtrasado,	DiasAtraso,         SucursalID,
			NombreSucurs,      		 	PromotorActual,     NombrePromotor,     FechaEmision,       HoraEmision,
			EstatusCre,					NombreInstit,		DesConvenio,		ProductoNomina,		MontoOtrasComisiones,
			MontoIVAOtrasComisiones,	MontoNotasCargo,	MontoIVANotasCargo,	TotalNotasCargo,	Accesorio,
			InteresAccesorio,			IvaInteresAccesorio)';

    SET Par_InstitucionID := IFNULL(Par_InstitucionID, Entero_Cero);
    SET Par_ConvenioNominaID := IFNULL(Par_ConvenioNominaID, Entero_Cero);
	-- SI ES MENOR QUE LA FECHA DEL SISTEMA
	IF(Par_Fecha < FechaSist) THEN
		SET Var_Sentencia :=    CONCAT(Var_Sentencia, '
		SELECT
		CONVERT("',Aud_NumTransaccion,'",UNSIGNED INT), IFNULL(Gpo.GrupoID, 0) ,    Gpo.NombreGrupo , SAL.CreditoID,    SAL.ClienteID,
		CLI.NombreCompleto,                             SAL.ProductoCreditoID,      PRO.Descripcion,  Cre.TasaFija,		SAL.MontoCredito, SAL.FechaInicio,
		SAL.FechaVencimiento, ');


			SET Var_Sentencia := CONCAT(Var_Sentencia, '
				CASE WHEN SAL.EstatusCredito IN ("V","S") THEN SAL.SalCapVigente + SAL.SalCapAtrasado ELSE 0.00 END AS CapitalVigente,
				CASE WHEN SAL.EstatusCredito IN ("V","S") THEN (SAL.SalIntProvision + SAL.SalIntOrdinario +SAL.SalIntAtrasado) ELSE  0.00 END AS InteresesVigente,
				CASE WHEN SAL.EstatusCredito IN ("V","S") THEN (SAL.SalMoratorios + SAL.SaldoMoraVencido + SAL.SaldoMoraCarVen)  ELSE 0.00 END AS MoraVigente,
				CASE WHEN SAL.EstatusCredito IN ("V","S") THEN SAL.SalComFaltaPago ELSE 0.00 END AS CargosVigente,
				CASE WHEN SAL.EstatusCredito IN ("V","S") THEN ROUND( CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN
				(ROUND(SAL.SalIntAtrasado,2)+ ROUND(SAL.SalIntProvision,2))*(Suc.IVA)
				ELSE 0.00 END  +
				CASE WHEN   PRO.CobraIVAMora="',SiCobraIVA,'"  OR PRO.CobraIVAMora IS NULL THEN
				ROUND((SAL.SalMoratorios + SAL.SaldoMoraVencido + SAL.SaldoMoraCarVen) * (Suc.IVA),2)
				ELSE 0.00 END + ROUND( SAL.SalComFaltaPago *(Suc.IVA) ,2) ,2) ELSE 0.00 END AS IvaVigente,
				CASE WHEN SAL.EstatusCredito IN ("V","S") THEN ROUND( CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN
																	(ROUND(SAL.SalIntAtrasado,2)+ ROUND(SAL.SalIntProvision,2)) * (Suc.IVA)
																	ELSE 0.00 END  +
				CASE WHEN PRO.CobraIVAMora = "',SiCobraIVA,'"  OR PRO.CobraIVAMora IS NULL THEN
															   ROUND((SAL.SalMoratorios + SAL.SaldoMoraVencido + SAL.SaldoMoraCarVen) * (Suc.IVA),2)
															   ELSE 0.00 END + ROUND( SAL.SalComFaltaPago *(Suc.IVA) ,2) ,2) +
															   (SAL.SalCapVigente + SAL.SalCapAtrasado + SAL.SalIntProvision + SAL.SalIntOrdinario + SAL.SalIntAtrasado +
															   SAL.SalComFaltaPago + SAL.SalMoratorios + SAL.SaldoMoraVencido + SAL.SaldoMoraCarVen) ELSE 0.00 END AS TotalVigente,
				CASE WHEN SAL.EstatusCredito IN ("V","S") THEN 0.00 ELSE (SAL.SalCapVencido  + SAL.SalCapVenNoExi) END AS CapitalVencido,
				CASE WHEN SAL.EstatusCredito IN ("B","S") THEN (SAL.SalIntVencido) ELSE 0.00 END AS InteresesVencido,
				CASE WHEN SAL.EstatusCredito IN ("V","S") THEN 0.00 ELSE SAL.SalMoratorios + SAL.SaldoMoraVencido + SAL.SaldoMoraCarVen END AS MoraVencido,
				CASE WHEN SAL.EstatusCredito IN ("V","S") THEN 0.00 ELSE SAL.SalComFaltaPago END AS CargosVencido,
				CASE WHEN SAL.EstatusCredito IN ("V","S") THEN 0.00 ELSE ROUND(CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN
																			(ROUND(SAL.SalIntNoConta,2)+ ROUND(SAL.SalIntVencido,2)) * (Suc.IVA) ELSE 0.00 END  +
				CASE WHEN   PRO.CobraIVAMora="',SiCobraIVA,'"  OR PRO.CobraIVAMora IS NULL THEN
															   ROUND((SAL.SalMoratorios + SAL.SaldoMoraVencido + SAL.SaldoMoraCarVen) * (Suc.IVA),2)
															   ELSE 0.00 END + ROUND( SAL.SalComFaltaPago * (Suc.IVA) ,2) ,2) END AS IvaVencido,
				CASE WHEN SAL.EstatusCredito IN ("V,S") THEN 0.00 ELSE ROUND(CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN
															  (ROUND(SAL.SalIntNoConta,2)+ ROUND(SAL.SalIntVencido,2)) * (Suc.IVA) ELSE 0.00 END  +
				CASE WHEN   PRO.CobraIVAMora="',SiCobraIVA,'"  OR PRO.CobraIVAMora IS NULL THEN
																ROUND((SAL.SalMoratorios + SAL.SaldoMoraVencido + SAL.SaldoMoraCarVen) * (Suc.IVA),2) ELSE 0.00 END +
																ROUND( SAL.SalComFaltaPago *(Suc.IVA) ,2) ,2) +
																(SAL.SalCapVencido + SAL.SalCapVenNoExi) + (SAL.SalIntNoConta + SAL.SalIntVencido) +
																SAL.SalMoratorios + SAL.SaldoMoraVencido + SAL.SaldoMoraCarVen +
																SalComFaltaPago END AS TotalVencido, 	SAL.SalCapAtrasado ,
			');

		SET Var_Sentencia :=    CONCAT(Var_Sentencia,
			   'SAL.DiasAtraso AS DiasAtraso,    SAL.Sucursal AS SucursalID, Suc.NombreSucurs,   CLI.PromotorActual,
				PROM.NombrePromotor,Par.FechaSistema AS FechaEmision, TIME(NOW()) AS HoraEmision, SAL.EstatusCredito AS EstatusCre');
        IF(Par_ProductoCre!=0 AND EsNomina = Cons_Si)THEN
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,', Nomi.InstitNominaID AS NombreInstit, Nomi.ConvenioNominaID AS DesConvenio, ');
		ELSE
			SET Var_Sentencia :=    CONCAT(Var_Sentencia,', ', Entero_Cero,' AS NombreInstit,', Entero_Cero,' AS DesConvenio, ');
        END IF;
        SET Var_Sentencia :=    CONCAT(Var_Sentencia,'PRO.ProductoNomina');

        /* RQN 31_FMEX_0031_ConfiguraciónAccesoriosPorConvenio
           Fecha de ajuste: 26-07-2020
           Dev: RLA
           Desc: Acumula los importes de accesorios
		*/
		SET Var_Sentencia :=    CONCAT(Var_Sentencia, '	, (SAL.SalOtrasComisi + SAL.SaldoComServGar) AS MontoOtrasComisiones');

		SET Var_Sentencia :=    CONCAT(Var_Sentencia, '	, (SAL.SalIVAComisi + SAL.SaldoIVAComSerGar) AS MontoIVAOtrasComisiones ');
		/*FIN RQN 31_FMEX_0031_ConfiguraciónAccesoriosPorConvenio*/

		SET Var_Sentencia :=    CONCAT(Var_Sentencia, ', ', Entero_Cero, ' AS MontoNotasCargo,  ', Entero_Cero, ' AS MontoIVANotasCargo, ', Entero_Cero, ' AS TotalNotasCargo,');

		-- Aqui va lo nuevo
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 0, 0, 0 ');

       SET Var_Sentencia :=    CONCAT(Var_Sentencia,'
			FROM SALDOSCREDITOS SAL
			INNER JOIN  PARAMETROSSIS Par ON Par.EmpresaID=Par.EmpresaID
			INNER JOIN CREDITOS Cre ON Cre.CreditoID = SAL.CreditoID
			LEFT JOIN GRUPOSCREDITO Gpo ON Gpo.GrupoID = Cre.GrupoID
			INNER JOIN PRODUCTOSCREDITO PRO ON SAL.ProductoCreditoID = PRO.ProducCreditoID');
		-- VALIDACION DE CONVENIOS
        IF(Par_ProductoCre!=0)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND SAL.ProductoCreditoID =',CONVERT(Par_ProductoCre,CHAR));
            IF( EsNomina = Cons_Si) THEN
				IF(IFNULL(Par_InstitucionID,Entero_Cero) != Entero_Cero) THEN
					SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN NOMCONDICIONCRED Nomi ON SAL.ProductoCreditoID = Nomi.ProducCreditoID AND Cre.ConvenioNominaID=Nomi.ConvenioNominaID AND Nomi.InstitNominaID = ',Par_InstitucionID);
				 ELSE
					SET Var_Sentencia := CONCAT(Var_Sentencia,' LEFT OUTER JOIN NOMCONDICIONCRED Nomi ON Cre.ProductoCreditoID= Nomi.ProducCreditoID AND Cre.ConvenioNominaID=Nomi.ConvenioNominaID ');
				END IF;

				IF(IFNULL(Par_ConvenioNominaID,Entero_Cero) != Entero_Cero) THEN
					SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Nomi.ConvenioNominaID = ',Par_ConvenioNominaID);
				END IF;
				SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN INSTITNOMINA InstNom ON CRE.InstitNominaID = InstNom.InstitNominaID ');
			END IF;
		END IF;
        -- FIN VALIDACION DE CONVENIOS
		SET Var_Sentencia :=    CONCAT(Var_Sentencia,'
		INNER JOIN CLIENTES CLI ON SAL.ClienteID = CLI.ClienteID');

		SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);
			IF(Par_Genero!=Cadena_Vacia)THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND CLI.Sexo="',Par_Genero,'" AND CLI.TipoPersona="',Var_PerFisica,'"');
		   END IF;

		SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
		IF(Par_Estado!=0)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,'
		INNER JOIN DIRECCLIENTE Dir ON CLI.ClienteID=Dir.ClienteID AND Dir.Oficial="',SiCobraIVA,'"  AND Dir.EstadoID= ',CONVERT(Par_Estado,CHAR));
		END IF;

		SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);

		IF(Par_Estado!=0 AND Par_Municipio!=0)THEN
		   SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Dir.MunicipioID= ',CONVERT(Par_Municipio,CHAR));
		END IF;


		SET Var_Sentencia :=    CONCAT(Var_Sentencia,'
		INNER JOIN PROMOTORES PROM ON PROM.PromotorID=CLI.PromotorActual ');
		SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);
		IF(Par_Promotor!=0)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,'  AND PROM.PromotorID=',CONVERT(Par_Promotor,CHAR));
		END IF;
		SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);
		IF(Par_Moneda!=0)THEN
			SET Var_Sentencia = CONCAT(Var_Sentencia,' AND SAL.MonedaID=',CONVERT(Par_Moneda,CHAR));
		END IF;

		SET Var_Sentencia :=    CONCAT(Var_Sentencia, '
		INNER JOIN SUCURSALES Suc ON Suc.SucursalID =  Cre.SucursalID ');
		SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
			IF(Par_Sucursal!=0)THEN
				SET Var_Sentencia = CONCAT(Var_Sentencia,' AND Cre.SucursalID=',CONVERT(Par_Sucursal,CHAR));
			END IF;
		SET Var_Sentencia :=    CONCAT(Var_Sentencia,'
		WHERE   (SAL.EstatusCredito = "',EstatusVigente,'" OR SAL.EstatusCredito = "',EstatusVencido,'"  OR SAL.EstatusCredito = "',EstatusSuspendido,'")
		AND SAL.FechaCorte = ?
		ORDER BY SAL.Sucursal, SAL.ProductoCreditoID,CLI.PromotorActual, IFNULL(Gpo.GrupoID, 0), SAL.CreditoID ; ');
		SET @Sentencia  = (Var_Sentencia);
		SET @Fecha  = Par_Fecha;
	  PREPARE STSALDOSCAPITALREP FROM @Sentencia;
	  EXECUTE STSALDOSCAPITALREP USING @Fecha;
	  DEALLOCATE PREPARE STSALDOSCAPITALREP;

	-- FIN SI ES MENOR QUE LA FECHA DEL SISTEMA
	END IF;

	IF(Par_Fecha = FechaSist) THEN
		SET Var_Sentencia :=CONCAT(Var_Sentencia,  'SELECT  CONVERT("',Aud_NumTransaccion,'",UNSIGNED INT),
		IFNULL(Gpo.GrupoID, 0) AS GrupoID, IFNULL(Gpo.NombreGrupo, "") AS NombreGrupo, CRE.CreditoID,          CRE.ClienteID,      CLI.NombreCompleto, ');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' CRE.ProductoCreditoID,  PRO.Descripcion,    CRE.Tasafija, CRE.MontoCredito,');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' CRE.FechaInicio,        CRE.FechaVencimien  AS FechaVencimiento,');


			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus IN ("V","S") THEN ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'CRE.SaldoCapVigent + CRE.SaldoCapAtrasad ELSE ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, '0.00 END AS CapitalVigente,');


			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus IN ("V","S") THEN ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, '(CRE.SaldoInterProvi + CRE.SaldoInterOrdin + CRE.SaldoInterAtras) ELSE ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' 0.00 END AS InteresesVigente,');



			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus IN ("V","S") THEN ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, '(CRE.SaldoMoratorios + CRE.SaldoMoraVencido + CRE.
				SaldoMoraCarVen) ELSE 0.00 END AS MoraVigente,');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus IN ("V","S") THEN ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'CRE.SaldComFaltPago ELSE 0.00 END AS CargosVigente,');


			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus IN ("V","S") THEN ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'ROUND( CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' (ROUND(CRE.SaldoInterAtras,2)+ ROUND(CRE.SaldoInterProvi,2))');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' *(Suc.IVA)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END ');

			SET Var_Sentencia := CONCAT(Var_Sentencia, ' +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN   PRO.CobraIVAMora="',SiCobraIVA,'"  OR PRO.CobraIVAMora IS NULL THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ROUND( (CRE.SaldoMoratorios + CRE.SaldoMoraVencido + CRE.SaldoMoraCarVen) *(Suc.IVA),2)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ROUND( CRE.SaldComFaltPago *(Suc.IVA) ,2) ,2)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00 END AS IvaVigente, ');

			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus IN ("V","S") THEN ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'ROUND( CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' (ROUND(CRE.SaldoInterAtras,2)+ ROUND(CRE.SaldoInterProvi,2))');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' * (Suc.IVA)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN PRO.CobraIVAMora = "',SiCobraIVA,'"  OR PRO.CobraIVAMora IS NULL THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ROUND( (CRE.SaldoMoratorios + CRE.SaldoMoraVencido + CRE.SaldoMoraCarVen) * (Suc.IVA),2)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ROUND( CRE.SaldComFaltPago *(Suc.IVA) ,2) ,2)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' + ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' (CRE.SaldoCapVigent + CRE.SaldoCapAtrasad + ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CRE.SaldoInterProvi + CRE.SaldoInterOrdin + CRE.SaldoInterAtras +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CRE.SaldComFaltPago + CRE.SaldoMoratorios + CRE.SaldoMoraVencido + CRE.SaldoMoraCarVen)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00 END AS TotalVigente, ');

			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus IN ("V","S") THEN ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' 0.00 ELSE ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, '(CRE.SaldoCapVencido  + CRE.SaldCapVenNoExi) END AS CapitalVencido,');

			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus IN ("B","S") THEN ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' (CRE.SaldoIntNoConta + CRE.SaldoInterVenc)  ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00 END AS InteresesVencido,');

			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus IN ("V","S") THEN ');
			SET Var_Sentencia := CONCAT(Var_Sentencia,  '0.00 ELSE (CRE.SaldoMoratorios + CRE.SaldoMoraVencido + CRE.SaldoMoraCarVen) END AS MoraVencido,');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus IN ("V","S") THEN ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' 0.00 ELSE CRE.SaldComFaltPago END AS CargosVencido,');

			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus IN ("V","S") THEN 0.00 ELSE ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'ROUND( CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' (ROUND(CRE.SaldoIntNoConta,2)+ ROUND(CRE.SaldoInterVenc,2))');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' *(Suc.IVA)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN   PRO.CobraIVAMora="',SiCobraIVA,'"  OR PRO.CobraIVAMora IS NULL THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ROUND( (CRE.SaldoMoratorios + CRE.SaldoMoraVencido + CRE.SaldoMoraCarVen) *(Suc.IVA),2)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ROUND( CRE.SaldComFaltPago *(Suc.IVA) ,2) ,2)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END AS IvaVencido, ');

			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN CRE.Estatus IN ("V","S") THEN 0.00 ELSE ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'ROUND( CASE WHEN   PRO.CobraIVAInteres="',SiCobraIVA,'"   OR PRO.CobraIVAInteres IS NULL  THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' (ROUND(CRE.SaldoIntNoConta,2)+ ROUND(CRE.SaldoInterVenc,2))');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' *(Suc.IVA)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN   PRO.CobraIVAMora="',SiCobraIVA,'"  OR PRO.CobraIVAMora IS NULL THEN');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ROUND( ( CRE.SaldoMoratorios + CRE.SaldoMoraVencido + CRE.SaldoMoraCarVen) * (Suc.IVA),2)');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ELSE 0.00');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' +');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' ROUND( CRE.SaldComFaltPago *(Suc.IVA) ,2) ,2) + ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, '(CRE.SaldoCapVencido + CRE.SaldCapVenNoExi) + ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, '(CRE.SaldoIntNoConta + CRE.SaldoInterVenc) + ');
			SET Var_Sentencia := CONCAT(Var_Sentencia,  ' CRE.SaldoMoratorios + CRE.SaldoMoraVencido + CRE.SaldoMoraCarVen + ');
			SET Var_Sentencia := CONCAT(Var_Sentencia,  ' CRE.SaldComFaltPago ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' END AS TotalVencido,  CRE.SaldoCapAtrasad,');


			SET Var_Sentencia := CONCAT(Var_Sentencia, 'IFNULL(FUNCIONDIASATRASO(CRE.CreditoID, "',Par_Fecha,'"), 0) AS DiasAtraso,');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CRE.SucursalID, Suc.NombreSucurs,CLI.PromotorActual,PROM.NombrePromotor,');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' Par.FechaSistema AS FechaEmision, TIME(NOW()) AS HoraEmision,  ');
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' CRE.Estatus AS EstatusCre ');
            IF(Par_ProductoCre!=0 AND EsNomina = Cons_Si)THEN
				SET Var_Sentencia :=	CONCAT(Var_Sentencia,', Nomi.InstitNominaID AS NombreInstit, Nomi.ConvenioNominaID AS DesConvenio, ');
			ELSE
				SET Var_Sentencia :=    CONCAT(Var_Sentencia,', ', Entero_Cero,' AS NombreInstit,', Entero_Cero,' AS DesConvenio, ');
			END IF;
            SET Var_Sentencia :=    CONCAT(Var_Sentencia,'PRO.ProductoNomina');

        /* RQN 31_FMEX_0031_ConfiguraciónAccesoriosPorConvenio
           Fecha de ajuste: 26-07-2020
           Dev: RLA
           Desc: Acumula los importes de accesorios
		*/

		SET Var_Sentencia :=    CONCAT(Var_Sentencia, '	, CRE.SaldoOtrasComis, ROUND(CRE.SaldoOtrasComis * (Suc.IVA),2)');
		/*FIN RQN 31_FMEX_0031_ConfiguraciónAccesoriosPorConvenio*/

		SET Var_Sentencia :=    CONCAT(Var_Sentencia, ', ', Entero_Cero, ' AS MontoNotasCargo,  ', Entero_Cero, ' AS MontoIVANotasCargo, ', Entero_Cero, ' AS TotalNotasCargo');

		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ', 0, 0, 0 ');

			SET Var_Sentencia := CONCAT(Var_Sentencia, ' FROM CREDITOS CRE');
			SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO PRO ON CRE.ProductoCreditoID = PRO.ProducCreditoID');
			SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);
		IF(Par_ProductoCre!=0)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND CRE.ProductoCreditoID =',CONVERT(Par_ProductoCre,CHAR));
			IF( EsNomina = Cons_Si) THEN
				IF(IFNULL(Par_InstitucionID,Entero_Cero) != Entero_Cero) THEN
					SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN NOMCONDICIONCRED Nomi ON CRE.ProductoCreditoID = Nomi.ProducCreditoID AND CRE.ConvenioNominaID=Nomi.ConvenioNominaID AND Nomi.InstitNominaID = ',Par_InstitucionID);
				 ELSE
					SET Var_Sentencia := CONCAT(Var_Sentencia,' LEFT OUTER JOIN NOMCONDICIONCRED Nomi ON CRE.ProductoCreditoID= Nomi.ProducCreditoID AND CRE.ConvenioNominaID=Nomi.ConvenioNominaID ');
				END IF;

				IF(IFNULL(Par_ConvenioNominaID,Entero_Cero) != Entero_Cero) THEN
					SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Nomi.ConvenioNominaID = ',Par_ConvenioNominaID);
				END IF;
				SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN INSTITNOMINA InstNom ON CRE.InstitNominaID = InstNom.InstitNominaID ');
			END IF;
		END IF;
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN  PARAMETROSSIS Par ON Par.EmpresaID=Par.EmpresaID ');
			SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CLIENTES CLI ON CRE.ClienteID = CLI.ClienteID');
			SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);
		IF(Par_Genero!=Cadena_Vacia)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND CLI.Sexo="',Par_Genero,'"');
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND CLI.TipoPersona="',Var_PerFisica,'"');
	   END IF;

			SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
			IF(Par_Estado!=0)THEN
			   SET Var_Sentencia := CONCAT(Var_Sentencia,'
			   INNER JOIN DIRECCLIENTE Dir ON CLI.ClienteID=Dir.ClienteID AND Dir.Oficial="',SiCobraIVA,'"  AND Dir.EstadoID= ',CONVERT(Par_Estado,CHAR));
			END IF;

			SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);

            IF(Par_Estado!=0 AND Par_Municipio!=0)THEN
			   SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Dir.MunicipioID= ',CONVERT(Par_Municipio,CHAR));
			END IF;


			SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES PROM ON PROM.PromotorID=CLI.PromotorActual ');

			SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);
			IF(Par_Promotor!=0)THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,'   AND PROM.PromotorID=',CONVERT(Par_Promotor,CHAR));
			END IF;

			SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);
			IF(Par_Moneda!=0)THEN
				SET Var_Sentencia = CONCAT(Var_Sentencia,' AND CRE.MonedaID=',CONVERT(Par_Moneda,CHAR));
			END IF;

			SET Var_Sentencia := CONCAT(Var_Sentencia, ' LEFT JOIN GRUPOSCREDITO Gpo ON Gpo.GrupoID = CRE.GrupoID ');
			SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN SUCURSALES Suc ON Suc.SucursalID =  CRE.SucursalID ');
			SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
			IF(Par_Sucursal!=0)THEN
				SET Var_Sentencia = CONCAT(Var_Sentencia,' AND CRE.SucursalID=',CONVERT(Par_Sucursal,CHAR));
			END IF;

			SET Var_Sentencia :=    CONCAT(Var_Sentencia,' AND  (CRE.Estatus    = "',EstatusVigente,'" OR CRE.Estatus = "',EstatusVencido,'" OR CRE.Estatus = "',EstatusSuspendido,'") ');

		  SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ORDER BY CRE.SucursalID,CRE.ProductoCreditoID,CLI.PromotorActual, IFNULL(Gpo.GrupoID, 0), CRE.CreditoID ; ');

          SET @Sentencia    = (Var_Sentencia);
		  PREPARE STSALDOSCAPITALREP FROM @Sentencia;
		  EXECUTE STSALDOSCAPITALREP;
		  DEALLOCATE PREPARE STSALDOSCAPITALREP;

	  DROP TEMPORARY TABLE IF EXISTS TMPSALDOACCESORIOSCRE;
      CREATE TEMPORARY TABLE TMPSALDOACCESORIOSCRE (
        CreditoID       BIGINT(12),
        Monto         DECIMAL(14,2),
        IvaMonto        DECIMAL(14,2),
        PRIMARY KEY (CreditoID)
      );

      INSERT INTO TMPSALDOACCESORIOSCRE
      SELECT Cre.CreditoID,0,
      SUM(FNEXIGIBLEIVAACCESORIOS(Cre.CreditoID, Amo.AmortizacionID,Suc.IVA, Cli.PagaIVA))
      FROM tmp_TMPSALDOSCAPITALREP Cre,AMORTICREDITO Amo,
      CLIENTES Cli, SUCURSALES Suc 
      WHERE Cre.CreditoID = Amo.CreditoID
      AND Amo.ClienteID = Cli.ClienteID
      AND Cre.SucursalID = Suc.SucursalID
      GROUP BY Cre.CreditoID;

      UPDATE tmp_TMPSALDOSCAPITALREP Rep,TMPSALDOACCESORIOSCRE Acc
        SET Rep.MontoIVAOtrasComisiones = Acc.IvaMonto
      WHERE Rep.CreditoID = Acc.CreditoID;

			UPDATE tmp_TMPSALDOSCAPITALREP rep
			SET
				rep.Accesorio = IFNULL((SELECT SUM(Amor.SaldoOtrasComis) FROM AMORTICREDITO Amor WHERE Amor.CreditoID = rep.CreditoID),Entero_Cero),
				rep.InteresAccesorio = IFNULL((SELECT  SUM(Amor.SaldoIntOtrasComis) FROM AMORTICREDITO Amor WHERE Amor.CreditoID = rep.CreditoID), Entero_Cero),
				rep.IvaInteresAccesorio = IFNULL((SELECT SUM(ROUND(FNEXIGIBLEIVAINTERESACCESORIOS(Amor.CreditoID,Amor.AmortizacionID,
				IFNULL((SELECT Suc.IVA FROM CREDITOS   Cre,
					CLIENTES   Cli,
					SUCURSALES Suc,
					PRODUCTOSCREDITO Pro
				WHERE   Cre.CreditoID         = rep.CreditoID
				AND   Cre.ProductoCreditoID   = Pro.ProducCreditoID
				AND   Cre.ClienteID           = Cli.ClienteID
				AND   Cre.SucursalID          = Suc.SucursalID),SiCobraIVA),
				IFNULL((SELECT Cli.PagaIVA FROM CREDITOS   Cre,
					CLIENTES   Cli,
					SUCURSALES Suc,
					PRODUCTOSCREDITO Pro
				WHERE   Cre.CreditoID         = rep.CreditoID
				AND   Cre.ProductoCreditoID   = Pro.ProducCreditoID
				AND   Cre.ClienteID           = Cli.ClienteID
				AND   Cre.SucursalID          = Suc.SucursalID),Entero_Cero)),2)) FROM AMORTICREDITO Amor WHERE Amor.CreditoID = rep.CreditoID), Entero_Cero);

	END IF;

	/*Inicia Seccion de Accesorios*/
	INSERT INTO tmp_ACCESORIOSREP(CreditoID,MontoAccesorio,InteresAccesorio,IVAInteresAccesorio)
	  (
	  	SELECT 	Cre.CreditoID,
	  			IFNULL(SUM(Amor.SaldoOtrasComis),Entero_Cero),
	  			IFNULL(SUM(Amor.SaldoIntOtrasComis),Entero_Cero),
	  			IFNULL(SUM(FNEXIGIBLEIVAINTERESACCESORIOS(Cre.CreditoID,Amor.AmortizacionID,Suc.IVA,Cli.PagaIVA)),Entero_Cero)
	  			
	  			
		FROM CREDITOS Cre 
		INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
		INNER JOIN SUCURSALES Suc ON Cre.SucursalID = Suc.SucursalID
		INNER JOIN AMORTICREDITO Amor ON Cre.CreditoID = Amor.CreditoID
		INNER JOIN tmp_TMPSALDOSCAPITALREP rep ON Cre.CreditoID = rep.CreditoID
		GROUP BY Cre.CreditoID
	  	);


	
		UPDATE tmp_TMPSALDOSCAPITALREP rep, tmp_ACCESORIOSREP acc SET
			rep.Accesorio = acc.MontoAccesorio,
			rep.InteresAccesorio = acc.InteresAccesorio,
			rep.IvaInteresAccesorio = acc.IVAInteresAccesorio
		WHERE rep.CreditoID = acc.CreditoID;

		/*Fin Seccion de Accesorios*/

    -- ACTUALIZAMOS LOS DATOS DE INSTITUCION DE NOMINA
	UPDATE CREDITOS CRE
    INNER JOIN tmp_TMPSALDOSCAPITALREP TMP ON TMP.CreditoID=CRE.CreditoID
    SET TMP.DesConvenio = IFNULL(CRE.ConvenioNominaID , Entero_Cero),
		TMP.NombreInstit = IFNULL(CRE.InstitNominaID, Entero_Cero);
	-- FIN ACTUALIZACION LOS DATOS DE INSTITUCION DE NOMINA

	-- INICIO Tablas Notas Cargo

	DROP TEMPORARY TABLE IF EXISTS TMPCREDITOSNOTASCARGOSALDOSCAP;
	CREATE TEMPORARY TABLE TMPCREDITOSNOTASCARGOSALDOSCAP (
		CreditoID				BIGINT(12),
		PRIMARY KEY (CreditoID)
	);

    DROP TEMPORARY TABLE IF EXISTS TMPEXIGIBLESNOTASCARGOSALDOSCAP;
	CREATE TEMPORARY TABLE TMPEXIGIBLESNOTASCARGOSALDOSCAP (
		CreditoID				BIGINT(12),
		Monto					DECIMAL(14,2),
		Iva						DECIMAL(14,2),
		SaldoNotas				DECIMAL(14,2),
		SaldoIvas				DECIMAL(14,2),
		PRIMARY KEY (CreditoID)
	);

	DROP TEMPORARY TABLE IF EXISTS TMPPAGOSNOTASCARGOSALDOSCAP;
	CREATE TEMPORARY TABLE TMPPAGOSNOTASCARGOSALDOSCAP (
		CreditoID				BIGINT(12),
		Monto					DECIMAL(14,2),
		IvaMonto				DECIMAL(14,2),
		PRIMARY KEY (CreditoID)
	);

	-- Creditos con notas de cargo a fecha corte
	INSERT INTO TMPCREDITOSNOTASCARGOSALDOSCAP (	CreditoID	)
										SELECT		NTC.CreditoID
											FROM	NOTASCARGO NTC
											INNER JOIN tmp_TMPSALDOSCAPITALREP TMP ON NTC.CreditoID = TMP.CreditoID
											INNER JOIN AMORTICREDITO AMO ON AMO.CreditoID = NTC.CreditoID AND NTC.AmortizacionID = AMO.AmortizacionID
											WHERE NTC.FechaRegistro <= Par_Fecha
											GROUP BY NTC.CreditoID, AMO.CreditoID;

	-- Montos de notas de cargo a fecha corte
	INSERT INTO TMPEXIGIBLESNOTASCARGOSALDOSCAP (	CreditoID,			Monto,									Iva,									SaldoNotas,		SaldoIvas	)
										SELECT		NTC.CreditoID,		ROUND(SUM(ROUND(NTC.Monto, 2)), 2),		ROUND(SUM(ROUND(NTC.IVA, 2)), 2),		Entero_Cero,	Entero_Cero
											FROM	TMPCREDITOSNOTASCARGOSALDOSCAP TMP
											INNER JOIN NOTASCARGO NTC ON TMP.CreditoID = NTC.CreditoID AND NTC.FechaRegistro <= Par_Fecha
											INNER JOIN AMORTICREDITO AMO ON AMO.CreditoID = NTC.CreditoID AND NTC.AmortizacionID = AMO.AmortizacionID
											GROUP BY NTC.CreditoID, AMO.CreditoID;

	-- Montos pagados de notas de cargo a fechas exigibles
	INSERT INTO TMPPAGOSNOTASCARGOSALDOSCAP (	CreditoID,			Monto,												IvaMonto	)
									SELECT		DET.CreditoID,		ROUND(SUM(ROUND(DET.MontoNotasCargo, 2)), 2),		ROUND(SUM(ROUND(DET.MontoIVANotasCargo, 2)), 2)
										FROM	TMPCREDITOSNOTASCARGOSALDOSCAP TMP
										INNER JOIN DETALLEPAGCRE DET ON DET.CreditoID = TMP.CreditoID AND DET.FechaPago <= Par_Fecha
										GROUP BY DET.CreditoID;

	-- Exigible de notas de cargo a fecha corte
	UPDATE TMPEXIGIBLESNOTASCARGOSALDOSCAP NTC
		INNER JOIN TMPPAGOSNOTASCARGOSALDOSCAP PAG ON NTC.CreditoID = PAG.CreditoID
	SET	NTC.SaldoNotas	= ROUND(NTC.Monto - PAG.Monto, 2),
		NTC.SaldoIvas	= ROUND(NTC.Iva - PAG.IvaMonto, 2);

	UPDATE TMPEXIGIBLESNOTASCARGOSALDOSCAP
	SET	SaldoNotas = Entero_Cero
	WHERE SaldoNotas < Entero_Cero;

	UPDATE TMPEXIGIBLESNOTASCARGOSALDOSCAP
	SET	SaldoIvas = Entero_Cero
	WHERE SaldoIvas < Entero_Cero;

	UPDATE tmp_TMPSALDOSCAPITALREP TMP
		INNER JOIN TMPEXIGIBLESNOTASCARGOSALDOSCAP NTC ON NTC.CreditoID = TMP.CreditoID
	SET	TMP.MontoNotasCargo		= NTC.SaldoNotas,
		TMP.MontoIVANotasCargo	= NTC.SaldoIvas,
		TMP.TotalNotasCargo		= ROUND(NTC.SaldoNotas + NTC.SaldoIvas, 2);

	-- FIN Tablas Notas Cargo

	IF(Var_RestringeReporte = Cons_No)THEN
		SELECT
			GrupoID,            NombreGrupo,        CreditoID,          ClienteID,      	NombreCompleto,
			ProductoCreditoID,  Descripcion,        TasaFija,			MontoCredito,       FechaInicio,    FechaVencimiento,
			CapitalVigente,     InteresesVigente,   MoraVigente,        CargosVigente,  	IvaVigente,
			TotalVigente,       CapitalVencido,     InteresesVencido,   MoraVencido,    	CargosVencido,
			IvaVencido,         TotalVencido,       CapitalAtrasado,	DiasAtraso,         SucursalID,     NombreSucurs,
			PromotorActual,     NombrePromotor,     FechaEmision,       HoraEmision,    	EstatusCre,
            NombreInstit,       DesConvenio,		ProductoNomina,		MontoOtrasComisiones,	MontoIVAOtrasComisiones,
			MontoNotasCargo,	MontoIVANotasCargo,	TotalNotasCargo, 	Accesorio, 		InteresAccesorio,
			IvaInteresAccesorio


			FROM tmp_TMPSALDOSCAPITALREP
			WHERE Transaccion = Aud_NumTransaccion
			AND DiasAtraso >= Par_AtrasoInicial
			AND DiasAtraso <=Par_AtrasoFinal
			AND (CapitalVigente +  InteresesVigente +  MoraVigente +  CargosVigente +  IvaVigente +
				TotalVigente +  CapitalVencido +  InteresesVencido +  MoraVencido +  CargosVencido +
				IvaVencido +  TotalVencido) > Entero_Cero;
	END IF;

    IF(Var_RestringeReporte = 'S')THEN

        -- OBTENEMOS LOS USUARIOS QUE SON DEPENDENCIAS
		SET Var_UsuDependencia := (SELECT FNUSUARIOSDEPENDECIA(Aud_Usuario));

		SET Var_Sentencia := CONCAT('
			SELECT
				TMP.GrupoID,            TMP.NombreGrupo,        TMP.CreditoID,          TMP.ClienteID,      TMP.NombreCompleto,
				TMP.ProductoCreditoID,  TMP.Descripcion,        TMP.TasaFija,			TMP.MontoCredito,   TMP.FechaInicio,    TMP.FechaVencimiento,
				TMP.CapitalVigente,     TMP.InteresesVigente,   TMP.MoraVigente,        TMP.CargosVigente,  TMP.IvaVigente,
				TMP.TotalVigente,       TMP.CapitalVencido,     TMP.InteresesVencido,   TMP.MoraVencido,    TMP.CargosVencido,
				TMP.IvaVencido,         TMP.TotalVencido,       TMP.CapitalAtrasado,	TMP.DiasAtraso,     TMP.SucursalID,     TMP.NombreSucurs,
				TMP.PromotorActual,     TMP.NombrePromotor,     TMP.FechaEmision,       TMP.HoraEmision,    TMP.EstatusCre,
                TMP.NombreInstit,       TMP.DesConvenio,		TMP.ProductoNomina,		TMP.MontoOtrasComisiones,	TMP.MontoIVAOtrasComisiones,
				TMP.MontoNotasCargo,	TMP.MontoIVANotasCargo,	TMP.TotalNotasCargo,	TMP.Accesorio,		TMP.InteresAccesorio,
				TMP.IvaInteresAccesorio
				FROM tmp_TMPSALDOSCAPITALREP TMP
					INNER JOIN SOLICITUDCREDITO SOL
						ON TMP.CreditoID = SOL.CreditoID
				WHERE TMP.Transaccion = ',Aud_NumTransaccion,'
				AND TMP.DiasAtraso >= ',Par_AtrasoInicial,'
				AND TMP.DiasAtraso <= ',Par_AtrasoFinal,'
				AND (TMP.CapitalVigente +  TMP.InteresesVigente +  TMP.MoraVigente +  TMP.CargosVigente +  TMP.IvaVigente +
					TMP.TotalVigente +  TMP.CapitalVencido +  TMP.InteresesVencido +  TMP.MoraVencido +  TMP.CargosVencido +
					TMP.IvaVencido +  TMP.TotalVencido) > ',Entero_Cero,'
				AND SOL.UsuarioAltaSol IN(',Var_UsuDependencia,')
                ;');

		SET @Sentencia2	= (Var_Sentencia);

		PREPARE STSALDOSCAPITALREP2 FROM @Sentencia2;
		EXECUTE STSALDOSCAPITALREP2;
		DEALLOCATE PREPARE STSALDOSCAPITALREP2;

	END IF;


	DROP TEMPORARY TABLE IF EXISTS tmp_TMPSALDOSCAPITALREP;
	DROP TEMPORARY TABLE IF EXISTS TMPCREDITOSNOTASCARGOSALDOSCAP;
    DROP TEMPORARY TABLE IF EXISTS TMPEXIGIBLESNOTASCARGOSALDOSCAP;
	DROP TEMPORARY TABLE IF EXISTS TMPPAGOSNOTASCARGOSALDOSCAP;

END TerminaStore$$
