-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSTOTALESREP
DELIMITER ;
DROP procedure IF EXISTS `SALDOSTOTALESREP`;

DELIMITER $$

CREATE PROCEDURE `SALDOSTOTALESREP`(
    -- SP QUE GENERA EL REPORTE DE ANALITICO DE CARTERA
    Par_Fecha           DATE,               -- Fecha corte
    Par_Sucursal        INT(11),            -- Numero de Sucursal
    Par_Moneda          INT(11),            -- Id de la Moneda
    Par_ProductoCre     INT(11),            -- Id del Prodcucto de Crédito
    Par_Promotor        INT(11),            -- promotor que tiene el cliente

    Par_Genero          CHAR(1),            -- Sexo F o M
    Par_Estado          INT(11),            -- De la tabla de DIRECCLIENTE
    Par_Municipio       INT(11),            -- De la tabla de DIRECCLIENTE
    Par_Clasificacion   INT(11),            -- De la tabla de CLASIFICCREDITO
    Par_AtrasoInicial   INT(11),            -- Dias de Atraso Inicial

    Par_AtrasoFinal     INT(11),            -- Dias de Atraso Inicial
    Par_InstNominaID    INT(11),            -- ID Institucion de Nomina
    Par_ConvNominaID     INT(11),           -- Numero de Convenio
    Par_NumList         TINYINT UNSIGNED,   -- Numero de Lista

    Par_EmpresaID       INT(11),            -- Parametro de Auditoria ID de la Empresa
    Aud_Usuario         INT(11),            -- Parametro de Auditoria ID del Usuario
    Aud_FechaActual     DATETIME,           -- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP     VARCHAR(15),        -- Parametro de Auditoria Direccion IP
    Aud_ProgramaID      VARCHAR(50),        -- Parametro de Auditoria Programa
    Aud_Sucursal        INT(11),            -- Parametro de Auditoria ID de la Sucursal
    Aud_NumTransaccion  BIGINT(20)          -- Parametro de Auditoria Numero de la Transaccion
)
TerminaStore: BEGIN

    -- Declaracion de Constantes
    DECLARE Var_Sentencia           TEXT(90000);
    DECLARE Var_ExisteCobraSeguro   INT(11);    -- Existen creditos que cobran seguros
    DECLARE Var_NatMovimiento       CHAR(1);
    DECLARE Var_PerFisica           CHAR(1);
    DECLARE EsNomina           		CHAR(1);
	DECLARE Var_PrimerDiaMes	    DATE;

    -- Declaracion de Variables
    DECLARE Fecha_corte             DATE;
    DECLARE Cadena_Vacia            CHAR(1);
    DECLARE Cons_No            		CHAR(1);
    DECLARE Cons_Si            		CHAR(1);
    DECLARE CienPorciento           DECIMAL(16,2);
    DECLARE Con_Foranea             INT;
    DECLARE Con_PagareImp           INT;
    DECLARE Con_PagareTfija         INT;
    DECLARE Con_PagoCred            INT;
    DECLARE Con_Saldos              INT;
    DECLARE Entero_Cero             INT;
    DECLARE Decimal_Cero			DECIMAL(12,2);
    DECLARE EstatusAtras            CHAR(1);
    DECLARE EstatusPagado           CHAR(1);
    DECLARE EstatusVencido          CHAR(1);
    DECLARE EstatusVigente          CHAR(1);
    DECLARE EstatusSuspendido       CHAR(1);
    DECLARE Fecha_Vacia             DATE;
    DECLARE FechaSist               DATE;
    DECLARE Lis_SaldosRep           INT;
    DECLARE Lis_SaldosRepEx         INT;
    DECLARE PagoAnual               CHAR(1);    -- PagoAnual (A)
    DECLARE PagoBimestral           CHAR(1);    -- PagoBimestral (B)
    DECLARE PagoCatorcenal          CHAR(1);    -- Pago Catorcenal (C)
    DECLARE PagoMensual             CHAR(1);    -- Pago Mensual (M)
    DECLARE PagoPeriodo             CHAR(1);    -- Pago por periodo (P)
    DECLARE PagoQuincenal           CHAR(1);    -- Pago Quincenal (Q)
    DECLARE PagoSemanal             CHAR(1);    -- Pago Semanal (S)
    DECLARE PagoSemestral           CHAR(1);    -- PagoSemestral (E)
    DECLARE PagoTetrames            CHAR(1);    -- PagoTetraMestral (R)
    DECLARE PagoTrimestral          CHAR(1);    -- PagoTrimestral (T)
    DECLARE PagoUnico               CHAR(1);    -- PagoUnico (U)
	DECLARE Var_RestringeReporte	CHAR(1);
	DECLARE Var_UsuDependencia		VARCHAR(1000);

    -- Asignacion de constantes
    SET Cadena_Vacia                := '';
    SET Cons_No                		:= 'N';
    SET Cons_Si                		:= 'S';
    SET CienPorciento               := 100.00;
    SET Entero_Cero                 := 0;
    SET Decimal_Cero				:= 0.00;
    SET EstatusAtras                := 'A';
    SET EstatusPagado               := 'P';
    SET EstatusVencido              := 'B';
    SET EstatusVigente              := 'V';
    SET EstatusSuspendido           := 'S';
    SET Fecha_Vacia                 := '1900-01-01';
    SET Lis_SaldosRep               := 2;
    SET Lis_SaldosRepEx             := 3;
    SET PagoAnual                   := 'A';         -- PagoAnual
    SET PagoBimestral               := 'B';         -- PagoBimestral
    SET PagoCatorcenal              := 'C';         -- PagoCatorcenal
    SET PagoMensual                 := 'M';         -- PagoMensual
    SET PagoPeriodo                 := 'P';         -- PagoPeriodo
    SET PagoQuincenal               := 'Q';         -- PagoQuincenal
    SET PagoSemanal                 := 'S';         -- PagoSemanal
    SET PagoSemestral               := 'E';         -- PagoSemestral
    SET PagoTetrames                := 'R';         -- PagoTetraMestral
    SET PagoTrimestral              := 'T';         -- PagoTrimestral
    SET PagoUnico                   := 'U';
    SET Var_NatMovimiento           := 'A';         -- Naturaleza de Moviemiento Abono
    SET Var_PerFisica               := 'F';
    SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Var_PrimerDiaMes :=(SELECT DATE_FORMAT(FechaSistema,'%Y-%m-01') FROM PARAMETROSSIS);

	SELECT	RestringeReporte
		INTO Var_RestringeReporte
	FROM PARAMETROSSIS LIMIT 1;
	SET Var_RestringeReporte:= IFNULL(Var_RestringeReporte,'N');
	SET EsNomina		:= IFNULL(EsNomina, Cons_No);

    DROP TABLE IF EXISTS tmp_TMPSALDOSTOTALESREP;
    CREATE TEMPORARY TABLE tmp_TMPSALDOSTOTALESREP (
    Transaccion         BIGINT,             CreditoID       BIGINT(12),         ProductoCreditoID   INT(12),            Descripcion         VARCHAR(200),           ClienteID           INT(12),
    NombreCompleto      VARCHAR(200),       SaldoCapVigent  DECIMAL(16,2),      SaldoCapAtrasad     DECIMAL(16,2),      SaldoCapVencido     DECIMAL(16,2),          SaldCapVenNoExi     DECIMAL(16,2),
    SaldoInterProvi     DECIMAL(16,2),      SaldoInterAtras DECIMAL(16,2),      SaldoInterVenc      DECIMAL(16,2),      SaldoIntNoConta     DECIMAL(16,2),          SaldoMoratorios     DECIMAL(16,2),
    SaldComFaltPago     DECIMAL(16,2),      SaldoOtrasComis DECIMAL(16,2),      SaldoIVAInteres     DECIMAL(16,2),      SaldoIVAMorator     DECIMAL(16,2),          SalIVAComFalPag     DECIMAL(16,2),
    SaldoIVAComisi      DECIMAL(16,2),      PasoCapAtraDia  DECIMAL(16,2),      PasoCapVenDia       DECIMAL(16,2),      PasoCapVNEDia       DECIMAL(16,2),          PasoIntAtraDia      DECIMAL(16,2),
    PasoIntVenDia       DECIMAL(16,2),      CapRegularizado DECIMAL(16,2),      IntOrdDevengado     DECIMAL(16,2),      IntMorDevengado     DECIMAL(16,2),          ComisiDevengado     DECIMAL(16,2),
    PagoCapVigDia       DECIMAL(16,2),      PagoCapAtrDia   DECIMAL(16,2),      PagoCapVenDia       DECIMAL(16,2),      PagoCapVenNexDia    DECIMAL(16,2),          PagoIntOrdDia       DECIMAL(16,2),
    PagoIntAtrDia       DECIMAL(16,2),      PagoIntVenDia   DECIMAL(16,2),      PagoIntCalNoCon     DECIMAL(16,2),      PagoComisiDia       DECIMAL(16,2),          PagoMoratorios      DECIMAL(16,2),
    PagoIvaDia          DECIMAL(16,2),      IntCondonadoDia DECIMAL(16,2),      MorCondonadoDia     DECIMAL(16,2),      IntDevCtaOrden      DECIMAL(16,2),          CapCondonadoDia     DECIMAL(16,2),
    ComAdmonPagDia      DECIMAL(16,2),      ComCondonadoDia DECIMAL(16,2),      DesembolsosDia      DECIMAL(16,2),      FechaInicio         DATE,                   FechaVencimiento    DATE,
    FechaUltAbonoCre    DATE,               FrecuenciaCap   VARCHAR(15),        FrecuenciaInt       VARCHAR(15),        CapVigenteExi       DECIMAL(16,2),          MontoTotalExi       DECIMAL(16,2),
    MontoCredito        DECIMAL(16,2),      TasaFija        DECIMAL(16,2),      DiasAtraso          INT(12),            SaldoDispon         DECIMAL(16,2),          SaldoBloq           DECIMAL(16,2),
    FechaUltDepCta      DATE,               PromotorID      INT(12),            NombrePromotor      VARCHAR(200),       FechaEmision        DATE,                   HoraEmision         TIME,
    MoraVencido         DECIMAL(16,2),      MoraCarVen      DECIMAL(16,2),      CalcInteresID       INT(11),            MontoSeguroCuota    DECIMAL(12,2),          IVASeguroCuota      DECIMAL(12,2),
    FolioFondeo         VARCHAR(45),        DestinoCredID   INT(11),            DesDestino          VARCHAR(300),       GrupoID             INT(11),                NombreGrupo         VARCHAR(200),
    SucursalGrupo       INT(11),            SucursalNombreGrupo VARCHAR(200),   InstitutFondID      INT(11),			FechaProxPago       DATE,					EstatusAmortiza		CHAR(1),
    InstitNominaID		INT(11),			ConvenioNominaID	BIGINT UNSIGNED,NombreInstit		VARCHAR(200),		NotasCargo			DECIMAL(14,2),			IvaNotasCargo		DECIMAL(14,2),
    PRIMARY KEY (CreditoID)
    );

    CREATE INDEX IDX_1 ON tmp_TMPSALDOSTOTALESREP(FechaProxPago);
    CREATE INDEX IDX_2 ON tmp_TMPSALDOSTOTALESREP(FechaUltAbonoCre);


    SET Var_Sentencia := '
    INSERT INTO tmp_TMPSALDOSTOTALESREP (
    Transaccion,            CreditoID,          ProductoCreditoID,      Descripcion,        ClienteID,
    NombreCompleto,         SaldoCapVigent,     SaldoCapAtrasad,        SaldoCapVencido,    SaldCapVenNoExi,
    SaldoInterProvi,        SaldoInterAtras,    SaldoInterVenc,         SaldoIntNoConta,    SaldoMoratorios,
    SaldComFaltPago,        SaldoOtrasComis,    SaldoIVAInteres,        SaldoIVAMorator,    SalIVAComFalPag,
    SaldoIVAComisi,         PasoCapAtraDia,     PasoCapVenDia,          PasoCapVNEDia ,     PasoIntAtraDia,
    PasoIntVenDia,          CapRegularizado,    IntOrdDevengado,        IntMorDevengado,    ComisiDevengado,
    PagoCapVigDia,          PagoCapAtrDia,      PagoCapVenDia,          PagoCapVenNexDia,   PagoIntOrdDia,
    PagoIntAtrDia,          PagoIntVenDia,      PagoIntCalNoCon,        PagoComisiDia,      PagoMoratorios,
    PagoIvaDia,             IntCondonadoDia,    MorCondonadoDia,        IntDevCtaOrden,     CapCondonadoDia,
    ComAdmonPagDia,         ComCondonadoDia,    DesembolsosDia,         FechaInicio,        FechaVencimiento,
    FechaUltAbonoCre,       MontoCredito,       DiasAtraso,             SaldoDispon,        SaldoBloq ,
    FechaUltDepCta,         FrecuenciaCap,      FrecuenciaInt,          CapVigenteExi,      MontoTotalExi,
    TasaFija,               PromotorID,         NombrePromotor,         FechaEmision,       HoraEmision,
    MoraVencido,            MoraCarVen,         CalcInteresID,          MontoSeguroCuota,   IVASeguroCuota,
    FolioFondeo,            DestinoCredID,      DesDestino,				FechaProxPago,		EstatusAmortiza,
	InstitNominaID,			ConvenioNominaID,	NombreInstit,			NotasCargo,			IvaNotasCargo	)';

    IF(Par_NumList = Lis_SaldosRep) THEN
        IF(Par_Fecha < FechaSist) THEN
            SET Var_Sentencia :=  'SELECT  Sal.CreditoID,       Cli.NombreCompleto, Sal.SalCapVigente , Sal.SalCapAtrasado , ';
            SET Var_Sentencia :=  CONCAT(Var_Sentencia,'     Sal.SalCapVencido ,    Sal.SalIntProvision ,   Sal.SalIntAtrasado ,    Sal.SalIntVencido , ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia,' Sal.SalCapVenNoExi ,   Sal.SalIntNoConta,
            (Sal.SalMoratorios + Sal.SaldoMoraVencido + Sal.SaldoMoraCarVen) AS SalMoratorios,  Sal.SalComFaltaPago , ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia,' (Sal.SalOtrasComisi + Sal.SaldoComServGar)  AS SalOtrasComisi ,   Sal.SalIVAInteres , Sal.SalIVAMoratorios ,Sal.SalIVAComFalPago , Sal.SalIVAComisi');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia,' FROM SALDOSCREDITOS Sal ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN CREDITOS Cre ON   Sal.CreditoID = Cre.CreditoID');
            SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);

            IF(Par_Moneda!=0)THEN
                SET Var_Sentencia = CONCAT(Var_Sentencia,' AND Cre.MonedaID=',CONVERT(Par_Moneda,CHAR));
            END IF;

            SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
            IF(Par_Sucursal!=0)THEN
                SET Var_Sentencia = CONCAT(Var_Sentencia,' AND Cre.SucursalID=',CONVERT(Par_Sucursal,CHAR));
            END IF;

            SET Var_Sentencia := CONCAT(Var_Sentencia,' AND (Cre.Estatus    = "',EstatusVigente,'" OR Cre.Estatus = "',EstatusVencido,'" OR Cre.Estatus = "',EstatusSuspendido,'") ');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID');
            SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);

            IF(Par_Genero!=Cadena_Vacia)THEN
                SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Cli.Sexo="',Par_Genero,'"');
                SET Var_Sentencia := CONCAT(Var_Sentencia,' AND CLI.TipoPersona="',Var_PerFisica,'"');
            END IF;

            SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
            IF(Par_Estado!=0)THEN
                SET Var_Sentencia := CONCAT(Var_Sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cre.ClienteID=Dir.ClienteID)=',CONVERT(Par_Estado,CHAR));
            END IF;

            SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);
            IF(Par_Municipio!=0)THEN
                SET Var_Sentencia := CONCAT(Var_Sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cre.ClienteID=Dir.ClienteID)=',CONVERT(Par_Municipio,CHAR));
            END IF;

            SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);
            IF(Par_ProductoCre!=0)THEN
                SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO Pro ON Sal.ProductoCreditoID = Pro.ProducCreditoID');
                SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Sal.ProductoCreditoID =',CONVERT(Par_ProductoCre,CHAR));
				/* ***** CONVENIOS ***************************************************************************************************** */
				SET EsNomina		:= (SELECT ProductoNomina FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProductoCre);
				SET EsNomina		:= IFNULL(EsNomina, Cons_No);
				IF( EsNomina = Cons_Si) THEN
                    SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN INSTITNOMINA InstNom ON Cre.InstitNominaID = InstNom.InstitNominaID ');
                    SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CONVENIOSNOMINA Con ON Con.ConvenioNominaID = Cre.ConvenioNominaID AND Con.InstitNominaID  = InstNom.InstitNominaID');

					IF(IFNULL(Par_InstNominaID,Entero_Cero) != Entero_Cero) THEN
						SET Var_Sentencia := CONCAT(Var_Sentencia,' AND InstNom.InstitNominaID = ',Par_InstNominaID);
					END IF;

					IF(IFNULL(Par_ConvNominaID,Entero_Cero) != Entero_Cero) THEN
						SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Con.ConvenioNominaID = ',Par_ConvNominaID);
					END IF;
				END IF;
				/* ***** FIN CONVENIOS ***************************************************************************************************** */
            END IF;

            SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);
            IF(Par_Promotor!=0)THEN
                SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES PROM ');
                SET Var_Sentencia := CONCAT(Var_sentencia,'  ON PROM.PromotorID=Cli.PromotorActual AND PROM.PromotorID=',CONVERT(Par_Promotor,CHAR));
            END IF;

            SET Var_Sentencia := CONCAT(Var_Sentencia,'  AND    Sal.FechaCorte = ? ');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Cre.EsAgropecuario="N"  ORDER BY Sal.CreditoID ASC ; ');

            SET @Sentencia  = (Var_Sentencia);
            SET @Fecha  = Par_Fecha;
            PREPARE STSALDOSTOTALESREP FROM @Sentencia;
            EXECUTE STSALDOSTOTALESREP USING @Fecha;
            DEALLOCATE PREPARE STSALDOSTOTALESREP;

        END IF;

        IF(Par_Fecha = FechaSist) THEN
            SET Var_Sentencia := 'SELECT    Cre.CreditoID, Cli.NombreCompleto,  Cre.SaldoCapVigent AS SalCapVigente,    Cre.SaldoCapAtrasad AS SalCapAtrasado,  Cre.SaldoCapVencido AS SalCapVencido, ';
            SET Var_Sentencia := CONCAT(Var_Sentencia,' Cre.SaldCapVenNoExi AS SalCapVenNoExi,  ROUND(Cre.SaldoInterProvi,2) AS SalIntProvision,    ROUND(Cre.SaldoInterAtras,2) AS SalIntAtrasado,     ROUND(Cre.SaldoInterVenc,2) AS SalIntVencido,   ROUND(Cre.SaldoIntNoConta,2) AS SalIntNoConta, ');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' (Cre.SaldoMoratorios + Cre.SaldoMoraVencido + Cre.SaldoMoraCarVen ) AS SalMoratorios,   Cre.SaldComFaltPago AS SalComFaltaPago, (Cre.SaldoOtrasComis + Cre.SaldoComServGar ) AS SalOtrasComisi,  Cre.SaldoIVAInteres AS SalIVAInteres,   Cre.SaldoIVAMorator AS SalIVAMoratorios, ');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' Cre.SalIVAComFalPag AS SalIVAComFalPago,    (ROUND(Cre.SaldoOtrasComis * (Suc.IVA),2) + ROUND(Cre.SaldoComServGar * (Suc.IVA),2)) AS SalIVAComisi');

            SET Var_Sentencia := CONCAT(Var_Sentencia,' FROM CREDITOS Cre ');
			SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Cre.SucursalID');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID');

            SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);
            IF(Par_Genero!=Cadena_Vacia)THEN
                SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.Sexo="',Par_Genero,'"');
                SET Var_Sentencia := CONCAT(Var_sentencia,' AND CLI.TipoPersona="',Var_PerFisica,'"');
            END IF;

            SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
            IF(Par_Estado!=0)THEN
                SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cre.ClienteID=Dir.ClienteID)=',CONVERT(Par_Estado,CHAR));
            END IF;

            SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);
            IF(Par_Municipio!=0)THEN
                SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cre.ClienteID=Dir.ClienteID)=',CONVERT(Par_Municipio,CHAR));
            END IF;


            SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);
            IF(Par_ProductoCre!=0)THEN
                SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID');
                SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Cre.ProductoCreditoID =',CONVERT(Par_ProductoCre,CHAR));
				/* ***** CONVENIOS ***************************************************************************************************** */
				SET EsNomina		:= (SELECT ProductoNomina FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProductoCre);
				SET EsNomina		:= IFNULL(EsNomina, Cons_No);
				IF( EsNomina = Cons_Si) THEN
                    SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN INSTITNOMINA InstNom ON Cre.InstitNominaID = InstNom.InstitNominaID ');
                    SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CONVENIOSNOMINA Con ON Con.ConvenioNominaID = Cre.ConvenioNominaID AND Con.InstitNominaID  = InstNom.InstitNominaID');

					IF(IFNULL(Par_InstNominaID,Entero_Cero) != Entero_Cero) THEN
						SET Var_Sentencia := CONCAT(Var_Sentencia,' AND InstNom.InstitNominaID = ',Par_InstNominaID);
					END IF;

					IF(IFNULL(Par_ConvNominaID,Entero_Cero) != Entero_Cero) THEN
						SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Con.ConvenioNominaID = ',Par_ConvNominaID);
					END IF;
				END IF;
				/* ***** FIN CONVENIOS ***************************************************************************************************** */
            END IF;

            SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);
            IF(Par_Promotor!=0)THEN
                SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES PROM ');
                SET Var_Sentencia := CONCAT(Var_sentencia,'  ON PROM.PromotorID=Cli.PromotorActual AND PROM.PromotorID=',CONVERT(Par_Promotor,CHAR));
            END IF;

            SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);
            IF(Par_Moneda!=0)THEN
                SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.MonedaID=',CONVERT(Par_Moneda,CHAR));
            END IF;

            SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
            IF(Par_Sucursal!=0)THEN
                SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.SucursalID=',CONVERT(Par_Sucursal,CHAR));
            END IF;

            SET Var_Sentencia := CONCAT(Var_Sentencia,' AND (Cre.Estatus    = "',EstatusVigente,'" OR Cre.Estatus = "',EstatusVencido,'" OR Cre.Estatus = "',EstatusSuspendido,'") ');
            SET Var_Sentencia :=    CONCAT(Var_Sentencia,'AND Cre.EsAgropecuario="N" ORDER BY Cre.CreditoID; ');

            SET @Sentencia  = (Var_Sentencia);
            SET @Fecha  = Par_Fecha;
            PREPARE STSALDOSTOTALESREP FROM @Sentencia;
            EXECUTE  STSALDOSTOTALESREP;

        END IF;
    END IF;
	-- REPORTE DE ANALITICO DE CARTERA EN EXCEL
    IF(Par_NumList = Lis_SaldosRepEx) THEN
		-- SI LA FECHA FILTRADA ES MENOR A LA FECHA DEL SISTEMA Y LA FECHA FILTRADA ES MAYOR O IGUAL AL PRIMER DIA DEL MES DE LA FECHA DEL SISTEMA
        IF(Par_Fecha < FechaSist AND Par_Fecha >= Var_PrimerDiaMes) THEN
            SET Var_Sentencia := CONCAT(Var_Sentencia, 'SELECT  CONVERT("',Aud_NumTransaccion,'",unsigned int),Sal.CreditoID,Sal.ProductoCreditoID, Prod.Descripcion, Cli.ClienteID,Cli.NombreCompleto, Sal.SalCapVigente,      Sal.SalCapAtrasado, ');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' Sal.SalCapVencido,     Sal.SalCapVenNoExi,     Sal.SalIntProvision,    Sal.SalIntAtrasado, ');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' Sal.SalIntVencido,     Sal.SalIntNoConta,      (Sal.SalMoratorios) AS SalMoratorios,           Sal.SalComFaltaPago, ');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' (Sal.SalOtrasComisi +  Sal.SaldoComServGar ) AS SalOtrasComisi,    Sal.SalIVAInteres,      Sal.SalIVAMoratorios,   Sal.SalIVAComFalPago,   Sal.SalIVAComisi, ');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' Sal.PasoCapAtraDia,    Sal.PasoCapVenDia   ,   Sal.PasoCapVNEDia,      Sal.PasoIntAtraDia, ');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' Sal.PasoIntVenDia,     Sal.CapRegularizado,    Sal.IntOrdDevengado,    Sal.IntMorDevengado,    Sal.ComisiDevengado, ');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' Sal.PagoCapVigDia,     Sal.PagoCapAtrDia,      Sal.PagoCapVenDia,      Sal.PagoCapVenNexDia,   Sal.PagoIntOrdDia, ');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' Sal.PagoIntAtrDia,     Sal.PagoIntVenDia,      Sal.PagoIntCalNoCon,    Sal.PagoComisiDia,      Sal.PagoMoratorios, ');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' Sal.PagoIvaDia,        Sal.IntCondonadoDia,    Sal.MorCondonadoDia,    Sal.IntDevCtaOrden,     Sal.CapCondonadoDia, Sal.ComAdmonPagDia,    ');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' Sal.ComCondonadoDia,   Sal.DesembolsosDia ,    Sal.FechaInicio,        Sal.FechaVencimiento,');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' "',Fecha_Vacia,'" as FechaUltAbonoCre,         Sal.MontoCredito,       Sal.DiasAtraso,');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' Cue.SaldoDispon,       Cue.SaldoBloq ,         "',Fecha_Vacia,'"  as FechaUltDepCta,');

            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' CASE Cre.FrecuenciaCap WHEN "',PagoSemanal,'" THEN "SEMANAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoCatorcenal,'" THEN "CATORCENAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoQuincenal,'"  THEN "QUINCENAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoMensual,'"    THEN "MENSUAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoPeriodo,'"    THEN "PERIODO"  ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoBimestral,'"  THEN "BIMESTRAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoTrimestral,'" THEN "TRIMESTRAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoTetrames,'"   THEN "TETRAMES"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoSemestral,'"  THEN "SEMESTRAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoAnual,'"      THEN "ANUAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoUnico,'"      THEN "UNICO"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' ELSE Cre.FrecuenciaCap END AS FrecuenciaCap , ');

            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' CASE Cre.FrecuenciaInt WHEN "',PagoSemanal,'" THEN "SEMANAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoCatorcenal,'" THEN "CATORCENAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoQuincenal,'"  THEN "QUINCENAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoMensual,'"    THEN "MENSUAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoPeriodo,'"    THEN "PERIODO"  ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoBimestral,'"  THEN "BIMESTRAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoTrimestral,'" THEN "TRIMESTRAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoTetrames,'"   THEN "TETRAMES"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoSemestral,'"  THEN "SEMESTRAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoAnual,'"  THEN "ANUAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' ELSE Cre.FrecuenciaInt END AS FrecuenciaInt,');

            SET Var_Sentencia := CONCAT(Var_Sentencia,  '  "',Entero_Cero,'"  as CapVigenteExi,');
            SET Var_Sentencia := CONCAT(Var_Sentencia,  ' (	ROUND(Sal.SalCapVigente,2) 	+ ROUND(Sal.SalCapAtrasado,2) 	+ ROUND(Sal.SalCapVencido,2)+
															ROUND(Sal.SalCapVenNoExi,2) + ROUND(Sal.SalIntOrdinario,2)	+ ROUND(Sal.SalIntAtrasado,2)+
															ROUND(Sal.SalIntVencido,2)	+ ROUND(Sal.SalIntProvision,2)	+ ROUND(Sal.SalIntNoConta,2)+
															ROUND(Sal.SalMoratorios,2)  + ROUND(Sal.SaldoMoraVencido,2)	+ ROUND(Sal.SaldoMoraCarVen,2)+
															ROUND(Sal.SalComFaltaPago,2)+ ROUND(Sal.SaldoComServGar,2)  + ROUND(Sal.SalOtrasComisi)) AS MontoTotalExi,');
            SET Var_Sentencia := CONCAT(Var_Sentencia,  ' Cre.TasaFija,         Prom.PromotorID,        Prom.NombrePromotor,');
            SET Var_Sentencia := CONCAT(Var_Sentencia,  ' Par.FechaSistema AS FechaEmision,             TIME(NOW()) AS HoraEmision,  ');
            SET Var_Sentencia := CONCAT(Var_Sentencia,  ' Sal.SaldoMoraVencido AS MoraVencido,          Sal.SaldoMoraCarVen AS MoraCarVen,      Cre.CalcInteresID,      Cre.MontoSeguroCuota, Cre.IVASeguroCuota,"',Cadena_Vacia,'",Des.DestinoCreID,Des.Descripcion,  "',Fecha_Vacia,'","',Cadena_Vacia,'" ');
			/* CONVENIOS ****************************************************************** */
            IF(Par_ProductoCre!=0)THEN
                SET EsNomina		:= (SELECT ProductoNomina FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProductoCre);
    			SET EsNomina		:= IFNULL(EsNomina, Cons_No);
    			IF(EsNomina	=  Cons_Si) THEN
    				SET Var_Sentencia := CONCAT(Var_Sentencia, ' ,InstNom.InstitNominaID, Con.ConvenioNominaID, InstNom.NombreInstit');
    			  ELSE
    				SET Var_Sentencia := CONCAT(Var_Sentencia, ' ,NULL AS InstitNominaID, NULL AS ConvenioNominaID, "" AS NombreInstit');
    			END IF;
            ELSE
                SET Var_Sentencia := CONCAT(Var_Sentencia, ' ,InstNom.InstitNominaID, Con.ConvenioNominaID, InstNom.NombreInstit');
            END IF;
			/* FIN CONVENIOS ****************************************************************** */

			SET Var_Sentencia := CONCAT(Var_Sentencia, ' , ', Entero_Cero, ', ', Entero_Cero);

            SET Var_Sentencia := CONCAT(Var_Sentencia,  ' FROM SALDOSCREDITOS Sal ');
            SET Var_Sentencia := CONCAT(Var_Sentencia,  ' INNER JOIN CREDITOS Cre ON   Sal.CreditoID = Cre.CreditoID');
            SET Var_Sentencia := CONCAT(Var_Sentencia,  ' INNER JOIN CUENTASAHO Cue ON Cue.CuentaAhoID = Cre.CuentaID');
            SET Var_Sentencia := CONCAT(Var_Sentencia,  ' INNER JOIN PRODUCTOSCREDITO Prod ON Cre.ProductoCreditoID = Prod.ProducCreditoID');
            SET Var_Sentencia := CONCAT(Var_Sentencia,  ' INNER JOIN  PARAMETROSSIS Par ON Par.EmpresaID=Par.EmpresaID ');


            SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);
            IF(Par_Moneda!=0)THEN
                SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.MonedaID=',CONVERT(Par_Moneda,CHAR));
            END IF;

            SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
            IF(Par_Sucursal!=0)THEN
                SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.SucursalID=',CONVERT(Par_Sucursal,CHAR));
            END IF;

            SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN DESTINOSCREDITO Des ON Des.DestinoCreID = Cre.DestinoCreID');
            SET Par_Clasificacion := IFNULL(Par_Clasificacion,Entero_Cero);

            IF(Par_Clasificacion!=Entero_Cero)THEN
                SET Var_Sentencia := CONCAT(Var_sentencia,' AND Des.SubClasifID=',CONVERT(Par_Clasificacion,CHAR));
            END IF;

            SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES Prom ON Cli.PromotorActual = Prom.PromotorID');
            SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);

            IF(Par_Genero!=Cadena_Vacia)THEN
                SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.Sexo="',Par_Genero,'"');
                SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.TipoPersona="',Var_PerFisica,'"');
            END IF;

            SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
            IF(Par_Estado!=0)THEN
                SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cre.ClienteID=Dir.ClienteID)=',CONVERT(Par_Estado,CHAR));
            END IF;

            SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);
            IF(Par_Municipio!=0)THEN
                SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cre.ClienteID=Dir.ClienteID)=',CONVERT(Par_Municipio,CHAR));
            END IF;

            SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);

            IF(Par_ProductoCre!=0)THEN
                SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO Pro ON Sal.ProductoCreditoID = Pro.ProducCreditoID');
                SET Var_Sentencia := CONCAT(Var_sentencia,' AND Sal.ProductoCreditoID =',CONVERT(Par_ProductoCre,CHAR));
				/* ***** CONVENIOS ***************************************************************************************************** */
				SET EsNomina		:= (SELECT ProductoNomina FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProductoCre);
				SET EsNomina		:= IFNULL(EsNomina, Cons_No);
				IF( EsNomina = Cons_Si) THEN
                    SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN INSTITNOMINA InstNom ON Cre.InstitNominaID = InstNom.InstitNominaID ');
                    SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CONVENIOSNOMINA Con ON Con.ConvenioNominaID = Cre.ConvenioNominaID AND Con.InstitNominaID  = InstNom.InstitNominaID');

					IF(IFNULL(Par_InstNominaID,Entero_Cero) != Entero_Cero) THEN
						SET Var_Sentencia := CONCAT(Var_Sentencia,' AND InstNom.InstitNominaID = ',Par_InstNominaID);
					END IF;

					IF(IFNULL(Par_ConvNominaID,Entero_Cero) != Entero_Cero) THEN
						SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Con.ConvenioNominaID = ',Par_ConvNominaID);
					END IF;
				END IF;
				/* ***** FIN CONVENIOS ***************************************************************************************************** */
            ELSE
                SET Var_Sentencia := CONCAT(Var_Sentencia,' LEFT JOIN INSTITNOMINA InstNom ON Cre.InstitNominaID = InstNom.InstitNominaID ');
                SET Var_Sentencia := CONCAT(Var_Sentencia,' LEFT JOIN CONVENIOSNOMINA Con ON Con.ConvenioNominaID = Cre.ConvenioNominaID AND Con.InstitNominaID  = InstNom.InstitNominaID');
            END IF;

            SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);
            IF(Par_Promotor!=0)THEN
                SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES PROM ');
                SET Var_Sentencia := CONCAT(Var_sentencia,'  ON PROM.PromotorID=Cli.PromotorActual AND PROM.PromotorID=',CONVERT(Par_Promotor,CHAR));
            END IF;

			SET Var_Sentencia := CONCAT(Var_Sentencia,'  WHERE Sal.FechaCorte = "',Par_Fecha,'"');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Cre.EsAgropecuario="N"  ORDER BY Sal.CreditoID ASC ; ');

            SET @Sentencia      := (Var_Sentencia);


            PREPARE STSALDOSTOTALESREP FROM @Sentencia;
            EXECUTE  STSALDOSTOTALESREP;
            DEALLOCATE PREPARE STSALDOSTOTALESREP;

            -- OBTENEMOS LA FECHA DE PROXIMO PAGO Y EL ESTATUS DE LA AMORTIZACION
			DROP TABLE IF EXISTS TMPFECHAPROXPAGOCRE;
			CREATE TEMPORARY TABLE TMPFECHAPROXPAGOCRE (
				AmortizacionID	INT(4)		COMMENT 'Numero de Amortizacion',
				CreditoID       BIGINT(12)	COMMENT 'Numero de Credito',
				FechaProxPago	DATE		COMMENT 'Fecha Proximo de Pago del Credito',
				Estatus			CHAR(1)		COMMENT 'Estatus de la Amortizacion',
				INDEX (AmortizacionID,CreditoID));
			CREATE INDEX IDX_1 ON TMPFECHAPROXPAGOCRE(FechaProxPago);


			INSERT INTO TMPFECHAPROXPAGOCRE (
				AmortizacionID,			CreditoID,		FechaProxPago,			Estatus)
			SELECT
				MIN(Amo.AmortizacionID),Amo.CreditoID, 	MIN(Amo.FechaExigible),	MIN(Amo.Estatus)
			FROM tmp_TMPSALDOSTOTALESREP Tmp,
				 AMORTICREDITO Amo
			WHERE Tmp.CreditoID = Amo.CreditoID
			AND Amo.FechaExigible > Par_Fecha
			AND Amo.Estatus = EstatusVigente
			GROUP BY Tmp.CreditoID;

			-- SE ACTUALIZA LA FECHA DE PROXIMO PAGO Y EL ESTATUS DE LA AMORTIZACION
			UPDATE tmp_TMPSALDOSTOTALESREP Tmp,
				   TMPFECHAPROXPAGOCRE Cre
			SET Tmp.FechaProxPago = Cre.FechaProxPago,
				Tmp.EstatusAmortiza = Cre.Estatus
			WHERE Tmp.CreditoID = Cre.CreditoID;

        END IF;
		-- SI LA FECHA FILTRADA ES MENOR A LA FECHA DEL SISTEMA Y LA FECHA FILTRADA ES MENOR AL PRIMER DIA DEL MES DE LA FECHA DEL SISTEMA
        IF(Par_Fecha < FechaSist AND Par_Fecha < Var_PrimerDiaMes) THEN
            SET Var_Sentencia := CONCAT(Var_Sentencia,' SELECT  convert("',Aud_NumTransaccion,'",unsigned int),Sal.CreditoID,Sal.ProductoCreditoID, Prod.Descripcion, Cli.ClienteID,Cli.NombreCompleto, Sal.SalCapVigente,      Sal.SalCapAtrasado, ');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' Sal.SalCapVencido,      Sal.SalCapVenNoExi,         Sal.SalIntProvision,        Sal.SalIntAtrasado, ');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' Sal.SalIntVencido,      Sal.SalIntNoConta,          Sal.SalMoratorios,          Sal.SalComFaltaPago, ');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' (Sal.SalOtrasComisi + Sal.SaldoComServGar ) As SalOtrasComisi,     Sal.SalIVAInteres,          Sal.SalIVAMoratorios,       Sal.SalIVAComFalPago,       Sal.SalIVAComisi, ');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' Sal.PasoCapAtraDia,     Sal.PasoCapVenDia   ,       Sal.PasoCapVNEDia,          Sal.PasoIntAtraDia, ');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' Sal.PasoIntVenDia,      Sal.CapRegularizado,        Sal.IntOrdDevengado,        Sal.IntMorDevengado,        Sal.ComisiDevengado, ');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' Sal.PagoCapVigDia,      Sal.PagoCapAtrDia,          Sal.PagoCapVenDia,          Sal.PagoCapVenNexDia,       Sal.PagoIntOrdDia, ');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' Sal.PagoIntAtrDia,      Sal.PagoIntVenDia,          Sal.PagoIntCalNoCon,        Sal.PagoComisiDia,          Sal.PagoMoratorios, ');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' Sal.PagoIvaDia,         Sal.IntCondonadoDia,        Sal.MorCondonadoDia,        Sal.IntDevCtaOrden,         Sal.CapCondonadoDia,        Sal.ComAdmonPagDia, ');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' Sal.ComCondonadoDia,    Sal.DesembolsosDia ,        Sal.FechaInicio,            Sal.FechaVencimiento,');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' "',Fecha_Vacia,'" as FechaUltAbonoCre,              Sal.MontoCredito,          Sal.DiasAtraso, ');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' Cue.SaldoDispon,        Cue.SaldoBloq ,             "',Fecha_Vacia,'"  as FechaUltDepCta,');

            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' CASE Cre.FrecuenciaCap WHEN "',PagoSemanal,'" THEN "SEMANAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoCatorcenal,'" THEN "CATORCENAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoQuincenal,'"  THEN "QUINCENAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoMensual,'"    THEN "MENSUAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoPeriodo,'"    THEN "PERIODO"  ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoBimestral,'"  THEN "BIMESTRAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoTrimestral,'" THEN "TRIMESTRAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoTetrames,'"   THEN "TETRAMES"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoSemestral,'"  THEN "SEMESTRAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoAnual,'"      THEN "ANUAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoUnico,'"      THEN "UNICO"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' ELSE Cre.FrecuenciaCap END AS FrecuenciaCap , ');

            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' CASE Cre.FrecuenciaInt WHEN "',PagoSemanal,'" THEN "SEMANAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoCatorcenal,'" THEN "CATORCENAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoQuincenal,'"  THEN "QUINCENAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoMensual,'"    THEN "MENSUAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoPeriodo,'"    THEN "PERIODO"  ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoBimestral,'"  THEN "BIMESTRAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoTrimestral,'" THEN "TRIMESTRAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoTetrames,'"   THEN "TETRAMES"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoSemestral,'"  THEN "SEMESTRAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoAnual,'"  THEN "ANUAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' ELSE Cre.FrecuenciaInt END AS FrecuenciaInt,');


            SET Var_Sentencia := CONCAT(Var_Sentencia, '  "',Entero_Cero,'"  as CapVigenteExi,');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' (ROUND(Sal.SalCapVigente,2) 	+ ROUND(Sal.SalCapAtrasado,2) 	+ ROUND(Sal.SalCapVencido,2)+
															ROUND(Sal.SalCapVenNoExi,2) + ROUND(Sal.SalIntOrdinario,2)	+ ROUND(Sal.SalIntAtrasado,2)+
															ROUND(Sal.SalIntVencido,2) 	+ ROUND(Sal.SalIntProvision,2)	+ ROUND(Sal.SalIntNoConta,2)+
															ROUND(Sal.SalMoratorios,2)  + ROUND(Sal.SaldoMoraVencido,2)	+ ROUND(Sal.SaldoMoraCarVen,2)+
															ROUND(Sal.SalComFaltaPago,2)+ ROUND(Sal.SaldoComServGar,2)  + ROUND(Sal.SalOtrasComisi)) as MontoTotalExi,');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' Cre.TasaFija,      Prom.PromotorID,        Prom.NombrePromotor,');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' Par.FechaSistema AS FechaEmision,          TIME(NOW()) AS HoraEmision,  ');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' Sal.SaldoMoraVencido AS MoraVencido,       Sal.SaldoMoraCarVen AS MoraCarVen,      Cre.CalcInteresID,      Cre.MontoSeguroCuota, Cre.IVASeguroCuota,"',Cadena_Vacia,'",Des.DestinoCreID,Des.Descripcion,  "',Fecha_Vacia,'","',Cadena_Vacia,'" ');
            IF(Par_ProductoCre!=0)THEN
    			/* CONVENIOS ****************************************************************** */
                SET EsNomina		:= (SELECT ProductoNomina FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProductoCre);
    			SET EsNomina		:= IFNULL(EsNomina, Cons_No);
    			IF(EsNomina	=  Cons_Si) THEN
    				SET Var_Sentencia := CONCAT(Var_Sentencia, ' ,InstNom.InstitNominaID, Con.ConvenioNominaID, InstNom.NombreInstit');
    			  ELSE
    				SET Var_Sentencia := CONCAT(Var_Sentencia, ' ,NULL AS InstitNominaID, NULL AS ConvenioNominaID, "" AS NombreInstit');
    			END IF;
    			/* FIN CONVENIOS ****************************************************************** */
		    ELSE
                SET Var_Sentencia := CONCAT(Var_Sentencia, ' ,InstNom.InstitNominaID, Con.ConvenioNominaID, InstNom.NombreInstit');
            END IF;

			SET Var_Sentencia := CONCAT(Var_Sentencia, ' , ', Entero_Cero, ', ', Entero_Cero);

            SET Var_Sentencia := CONCAT(Var_Sentencia, ' FROM SALDOSCREDITOS Sal ');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN CREDITOS Cre ON   Sal.CreditoID = Cre.CreditoID');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN `HIS-CUENTASAHO` Cue ON Cue.CuentaAhoID = Cre.CuentaID');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN PRODUCTOSCREDITO Prod ON Cre.ProductoCreditoID = Prod.ProducCreditoID');
            SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN  PARAMETROSSIS Par ON Par.EmpresaID=Par.EmpresaID ');


            SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);
            IF(Par_Moneda!=0)THEN
                SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.MonedaID=',CONVERT(Par_Moneda,CHAR));
            END IF;

            SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
            IF(Par_Sucursal!=0)THEN
                SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.SucursalID=',CONVERT(Par_Sucursal,CHAR));
            END IF;

            SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN DESTINOSCREDITO Des ON Des.DestinoCreID = Cre.DestinoCreID');
            SET Par_Clasificacion := IFNULL(Par_Clasificacion,Entero_Cero);
            IF(Par_Clasificacion!=Entero_Cero)THEN
                SET Var_Sentencia := CONCAT(Var_sentencia,' AND Des.SubClasifID=',CONVERT(Par_Clasificacion,CHAR));
            END IF;

            SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES Prom ON Cli.PromotorActual = Prom.PromotorID');

            SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);
            IF(Par_Genero!=Cadena_Vacia)THEN
                SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.Sexo="',Par_Genero,'"');
                SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.TipoPersona="',Var_PerFisica,'"');
            END IF;

            SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
            IF(Par_Estado!=0)THEN
                SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cre.ClienteID=Dir.ClienteID)=',CONVERT(Par_Estado,CHAR));
            END IF;

            SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);
            IF(Par_Municipio!=0)THEN
                SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cre.ClienteID=Dir.ClienteID)=',CONVERT(Par_Municipio,CHAR));
            END IF;

            SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);
            IF(Par_ProductoCre!=0)THEN
                SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO Pro ON Sal.ProductoCreditoID = Pro.ProducCreditoID');
                SET Var_Sentencia := CONCAT(Var_sentencia,' AND Sal.ProductoCreditoID =',CONVERT(Par_ProductoCre,CHAR));
				/* ***** CONVENIOS ***************************************************************************************************** */
				SET EsNomina		:= (SELECT ProductoNomina FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProductoCre);
				SET EsNomina		:= IFNULL(EsNomina, Cons_No);
				IF( EsNomina = Cons_Si) THEN
                    SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN INSTITNOMINA InstNom ON Cre.InstitNominaID = InstNom.InstitNominaID ');
                    SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CONVENIOSNOMINA Con ON Con.ConvenioNominaID = Cre.ConvenioNominaID AND Con.InstitNominaID  = InstNom.InstitNominaID');

					IF(IFNULL(Par_InstNominaID,Entero_Cero) != Entero_Cero) THEN
						SET Var_Sentencia := CONCAT(Var_Sentencia,' AND InstNom.InstitNominaID = ',Par_InstNominaID);
					END IF;

					IF(IFNULL(Par_ConvNominaID,Entero_Cero) != Entero_Cero) THEN
						SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Con.ConvenioNominaID = ',Par_ConvNominaID);
					END IF;
				END IF;
				/* ***** FIN CONVENIOS ***************************************************************************************************** */
            ELSE
                SET Var_Sentencia := CONCAT(Var_Sentencia,' LEFT JOIN INSTITNOMINA InstNom ON Cre.InstitNominaID = InstNom.InstitNominaID ');
                SET Var_Sentencia := CONCAT(Var_Sentencia,' LEFT JOIN CONVENIOSNOMINA Con ON Con.ConvenioNominaID = Cre.ConvenioNominaID AND Con.InstitNominaID  = InstNom.InstitNominaID');
            END IF;

            SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);
            IF(Par_Promotor!=0)THEN
                SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES PROM ');
                SET Var_Sentencia := CONCAT(Var_sentencia,' ON PROM.PromotorID=Cli.PromotorActual AND PROM.PromotorID=',CONVERT(Par_Promotor,CHAR));
            END IF;

            -- Consulta para obtener la fecha de corte de la tabla `HIS-CUENTASAHO`
            -- dada una fecha como parametro Par_Fecha, posteriormente la almacenamos en nuestra variable para completar
            -- la consuta
            SELECT MAX(Fecha)
                INTO Fecha_corte
            FROM `HIS-CUENTASAHO`
            WHERE Fecha BETWEEN
                DATE_ADD(Par_Fecha, INTERVAL -1*(DAY(Par_Fecha))+1 DAY) AND
                    LAST_DAY(Par_Fecha);

            SET Var_Sentencia   := CONCAT(Var_Sentencia,' WHERE   Sal.FechaCorte ="',Par_Fecha,'"');

            SET Var_Sentencia   := CONCAT(Var_Sentencia,' AND Cre.EsAgropecuario="N" AND Cue.Fecha = "',Fecha_corte,'" AND Sal.EstatusCredito != "P"  order by Sal.CreditoID asc ; '); -- ialdana T_16076

			SET @Sentencia      := (Var_Sentencia);


			IF(@Sentencia <> '' OR @Sentencia <> NULL)THEN  -- ALTER CENTENO
				PREPARE STSALDOSTOTALESREP FROM @Sentencia;
				EXECUTE  STSALDOSTOTALESREP;
				DEALLOCATE PREPARE STSALDOSTOTALESREP;
			END IF;

             -- OBTENEMOS LA FECHA DE PROXIMO PAGO Y EL ESTATUS DE LA AMORTIZACION
			DROP TABLE IF EXISTS TMPFECHAPROXPAGOCRE;
			CREATE TEMPORARY TABLE TMPFECHAPROXPAGOCRE (
				AmortizacionID	INT(4)		COMMENT 'Numero de Amortizacion',
				CreditoID       BIGINT(12)	COMMENT 'Numero de Credito',
				FechaProxPago	DATE		COMMENT 'Fecha Proximo de Pago del Credito',
				Estatus			CHAR(1)		COMMENT 'Estatus de la Amortizacion',
				INDEX (AmortizacionID,CreditoID));
				CREATE INDEX IDX_1 ON TMPFECHAPROXPAGOCRE(FechaProxPago);


            INSERT INTO TMPFECHAPROXPAGOCRE (
				AmortizacionID,			CreditoID,		FechaProxPago,			Estatus)
			SELECT
				MIN(Amo.AmortizacionID),Amo.CreditoID, 	MIN(Amo.FechaExigible),	MIN(Amo.Estatus)
			FROM tmp_TMPSALDOSTOTALESREP Tmp,
				 AMORTICREDITO Amo
			WHERE Tmp.CreditoID = Amo.CreditoID
			AND Amo.FechaExigible > Par_Fecha
			GROUP BY Tmp.CreditoID;

			-- SE ACTUALIZA EL ESTATUS DE LA AMORTIZACION
			UPDATE TMPFECHAPROXPAGOCRE Tmp,
				   SALDOSCREDITOS Sal
			SET Tmp.Estatus = CASE WHEN Sal.SalCapVigente > Decimal_Cero AND Sal.SalCapAtrasado = Decimal_Cero AND SalCapVencido = Decimal_Cero THEN EstatusVigente
								   WHEN Sal.SalCapVigente > Decimal_Cero AND Sal.SalCapAtrasado > Decimal_Cero AND SalCapVencido = Decimal_Cero THEN EstatusAtras
								   WHEN Sal.SalCapVigente = Decimal_Cero AND Sal.SalCapAtrasado > Decimal_Cero AND SalCapVencido = Decimal_Cero THEN EstatusAtras
                                   WHEN Sal.SalCapVigente = Decimal_Cero AND Sal.SalCapAtrasado > Decimal_Cero AND SalCapVencido > Decimal_Cero THEN EstatusVencido
								   WHEN Sal.SalCapVigente = Decimal_Cero AND Sal.SalCapAtrasado = Decimal_Cero AND SalCapVencido > Decimal_Cero THEN EstatusVencido
                                   ELSE Sal.EstatusCredito END
			WHERE Tmp.CreditoID = Sal.CreditoID
            AND Sal.FechaCorte = Par_Fecha
            AND Tmp.Estatus != EstatusVigente;

			-- SE ACTUALIZA LA FECHA DE PROXIMO PAGO Y EL ESTATUS DE LA AMORTIZACION
			UPDATE tmp_TMPSALDOSTOTALESREP Tmp,
				   TMPFECHAPROXPAGOCRE Cre
			SET Tmp.FechaProxPago = Cre.FechaProxPago,
				Tmp.EstatusAmortiza = Cre.Estatus
			WHERE Tmp.CreditoID = Cre.CreditoID;

        END IF;
		-- SI LA FECHA FILTRADA ES IGUAL A LA FECHA DEL SISTEMA
        IF(Par_Fecha = FechaSist) THEN
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'SELECT CONVERT("',Aud_NumTransaccion,'",UNSIGNED INT),           Cre.CreditoID,                Cre.ProductoCreditoID,       Pro.Descripcion, ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'Cli.ClienteID,                   Cli.NombreCompleto,             Cre.SaldoCapVigent,           Cre.SaldoCapAtrasad, ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'Cre.SaldoCapVencido,             Cre.SaldCapVenNoExi,            ROUND(Cre.SaldoInterProvi,2),');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'ROUND(Cre.SaldoInterAtras,2),    ROUND(Cre.SaldoInterVenc,2),');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'ROUND(Cre.SaldoIntNoConta,2),    Cre.SaldoMoratorios,            Cre.SaldComFaltPago,');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, '(Cre.SaldoOtrasComis + Cre.SaldoComServGar)  AS SaldoOtrasComis ,             Cre.SaldoIVAInteres,            Cre.SaldoIVAMorator, ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'Cre.SalIVAComFalPag,  ( ROUND(Cre.SaldoOtrasComis * (Suc.IVA),2) + ROUND(Cre.SaldoComServGar * (Suc.IVA),2)) AS SaldoOtrasComis,             "',Entero_Cero,'" AS PasoCapAtraDia,');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, '"',Entero_Cero,'" AS PasoCapVenDia,    "',Entero_Cero,'" AS PasoCapVNEDia ,  "',Entero_Cero,'" AS PasoIntAtraDia,    "',Entero_Cero,'" AS PasoIntVenDia, ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, '"',Entero_Cero,'" AS CapRegularizado,  "',Entero_Cero,'" AS IntOrdDevengado, "',Entero_Cero,'" AS IntMorDevengado,   "',Entero_Cero,'" AS ComisiDevengado, ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, '"',Entero_Cero,'" AS PagoCapVigDia,    "',Entero_Cero,'" AS PagoCapAtrDia,   "',Entero_Cero,'" AS PagoCapVenDia,     "',Entero_Cero,'" AS PagoCapVenNexDia, ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, '"',Entero_Cero,'" AS PagoIntOrdDia,    "',Entero_Cero,'" AS PagoIntAtrDia,   "',Entero_Cero,'" AS PagoIntVenDia,     "',Entero_Cero,'" AS PagoIntCalNoCon, ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, '"',Entero_Cero,'" AS PagoComisiDia,    "',Entero_Cero,'" AS PagoMoratorios,  "',Entero_Cero,'" AS PagoIvaDia,        "',Entero_Cero,'" AS IntCondonadoDia,');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, '"',Entero_Cero,'" AS MorCondonadoDia,  "',Entero_Cero,'" AS IntDevCtaOrden,  "',Entero_Cero,'" AS CapCondonadoDia,   "',Entero_Cero,'" AS ComAdmonPagDia, ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, '"',Entero_Cero,'" AS ComCondonadoDia,  "',Entero_Cero,'" AS DesembolsosDia,    Cre.FechaInicio,                        Cre.FechaVencimien AS FechaVencimiento, ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, '"',Fecha_Vacia,'" AS FechaUltAbonoCre, Cre.MontoCredito,                       FUNCIONDIASATRASO(Cre.CreditoID,"',Par_Fecha,'")AS DiasAtraso, ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'Cue.SaldoDispon,Cue.SaldoBloq ,  "',Fecha_Vacia,'" AS FechaUltDepCta,   ');

            SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'CASE Cre.FrecuenciaCap WHEN "',PagoSemanal,'" THEN "SEMANAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoCatorcenal,'"   THEN "CATORCENAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoQuincenal,'"    THEN "QUINCENAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoMensual,'"      THEN "MENSUAL"  ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoPeriodo,'"      THEN "PERIODO"  ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoBimestral,'"    THEN "BIMESTRAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoTrimestral,'"   THEN "TRIMESTRAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoTetrames,'"     THEN "TETRAMES"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoSemestral,'"    THEN "SEMESTRAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoAnual,'"        THEN "ANUAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoUnico,'"        THEN "UNICO"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'ELSE Cre.FrecuenciaCap END AS FrecuenciaCap, ');

            SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'CASE Cre.FrecuenciaInt WHEN "',PagoSemanal,'" THEN "SEMANAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoCatorcenal,'"   THEN "CATORCENAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoQuincenal,'"    THEN "QUINCENAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoMensual,'"      THEN "MENSUAL"  ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoPeriodo,'"      THEN "PERIODO"  ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoBimestral,'"    THEN "BIMESTRAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoTrimestral,'"   THEN "TRIMESTRAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoTetrames,'"     THEN "TETRAMES"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoSemestral,'"    THEN "SEMESTRAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoAnual,'"        THEN "ANUAL"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHEN "',PagoUnico,'"        THEN "UNICO"');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' ELSE Cre.FrecuenciaInt END AS FrecuenciaInt, ');

            SET Var_Sentencia :=  CONCAT(Var_Sentencia, '  "',Entero_Cero,'"  AS CapVigenteExi, FUNCIONDEUCRENOIVA(Cre.CreditoID) AS MontoTotalExi,   Cre.TasaFija,   Prom.PromotorID, ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' Prom.NombrePromotor,    Par.FechaSistema AS FechaEmision,       time(now()) AS HoraEmision, ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' Cre.SaldoMoraVencido,   Cre.SaldoMoraCarVen ,     Cre.CalcInteresID,      Cre.MontoSeguroCuota, ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' Cre.IVASeguroCuota,     "',Cadena_Vacia,'",       Des.DestinoCreID,       Des.Descripcion,  "',Fecha_Vacia,'","',Cadena_Vacia,'" ');

            IF(Par_ProductoCre!=0)THEN
            /* CONVENIOS ****************************************************************** */
                SET EsNomina		:= (SELECT ProductoNomina FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProductoCre);
    			SET EsNomina		:= IFNULL(EsNomina, Cons_No);
    			IF(EsNomina	=  Cons_Si) THEN
    				SET Var_Sentencia := CONCAT(Var_Sentencia, ' ,InstNom.InstitNominaID, Con.ConvenioNominaID, InstNom.NombreInstit');
    			  ELSE
    				SET Var_Sentencia := CONCAT(Var_Sentencia, ' ,NULL AS InstitNominaID, NULL AS ConvenioNominaID, "" AS NombreInstit');
    			END IF;
			/* FIN CONVENIOS ****************************************************************** */
			ELSE
		        SET Var_Sentencia := CONCAT(Var_Sentencia, ' ,InstNom.InstitNominaID, Con.ConvenioNominaID, InstNom.NombreInstit');
            END IF;

			SET Var_Sentencia := CONCAT(Var_Sentencia, ' , ', Entero_Cero, ', ', Entero_Cero);

            SET Var_Sentencia :=  CONCAT(Var_Sentencia,' From CREDITOS Cre ');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN CLIENTES Cli on Cre.ClienteID = Cli.ClienteID');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN CUENTASAHO Cue on Cue.CuentaAhoID = Cre.CuentaID');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES Prom on Cli.PromotorActual = Prom.PromotorID');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN PRODUCTOSCREDITO Pro on Cre.ProductoCreditoID = Pro.ProducCreditoID');
            SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN  PARAMETROSSIS Par on Par.EmpresaID=Par.EmpresaID ');
			SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Cre.SucursalID');


            SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);
            IF(Par_Genero!=Cadena_Vacia)THEN
                SET Var_Sentencia :=  CONCAT(Var_sentencia,' AND Cli.Sexo="',Par_Genero,'"');
                SET Var_Sentencia :=  CONCAT(Var_sentencia,' AND Cli.TipoPersona =',CONVERT(Par_ProductoCre,CHAR));
            END IF;

            SET Var_Sentencia :=  CONCAT(Var_Sentencia,' INNER JOIN DESTINOSCREDITO Des ON Des.DestinoCreID = Cre.DestinoCreID');
            SET Par_Clasificacion := IFNULL(Par_Clasificacion,Entero_Cero);
            IF(Par_Clasificacion!=Entero_Cero)THEN
                SET Var_Sentencia := CONCAT(Var_sentencia,' AND Des.SubClasifID=',CONVERT(Par_Clasificacion,CHAR));
            END IF;

            SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
            IF(Par_Estado!=0)THEN
                SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cre.ClienteID=Dir.ClienteID)=',CONVERT(Par_Estado,CHAR));
            END IF;

            SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);
            IF(Par_Municipio!=0)THEN
                SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cre.ClienteID=Dir.ClienteID)=',CONVERT(Par_Municipio,CHAR));
            END IF;

            SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);
            IF(Par_ProductoCre!=0)THEN
                SET Var_Sentencia :=  CONCAT(Var_sentencia,' AND Cre.ProductoCreditoID =',CONVERT(Par_ProductoCre,CHAR));
				/* ***** CONVENIOS ***************************************************************************************************** */
				SET EsNomina		:= (SELECT ProductoNomina FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProductoCre);
				SET EsNomina		:= IFNULL(EsNomina, Cons_No);
				IF( EsNomina = Cons_Si) THEN
                    SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN INSTITNOMINA InstNom ON Cre.InstitNominaID = InstNom.InstitNominaID ');
                    SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CONVENIOSNOMINA Con ON Con.ConvenioNominaID = Cre.ConvenioNominaID AND Con.InstitNominaID  = InstNom.InstitNominaID');
					IF(IFNULL(Par_InstNominaID,Entero_Cero) != Entero_Cero) THEN
						SET Var_Sentencia := CONCAT(Var_Sentencia,' AND InstNom.InstitNominaID = ',Par_InstNominaID);
					END IF;

					IF(IFNULL(Par_ConvNominaID,Entero_Cero) != Entero_Cero) THEN
						SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Con.ConvenioNominaID = ',Par_ConvNominaID);
					END IF;


				END IF;
				/* ***** FIN CONVENIOS ***************************************************************************************************** */
            ELSE
                SET Var_Sentencia := CONCAT(Var_Sentencia,' LEFT JOIN INSTITNOMINA InstNom ON Cre.InstitNominaID = InstNom.InstitNominaID ');
                SET Var_Sentencia := CONCAT(Var_Sentencia,' LEFT JOIN CONVENIOSNOMINA Con ON Con.ConvenioNominaID = Cre.ConvenioNominaID AND Con.InstitNominaID  = InstNom.InstitNominaID');
            END IF;

            SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);
            IF(Par_Promotor!=0)THEN
                SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN PROMOTORES PROM ');
                SET Var_Sentencia := CONCAT(Var_sentencia,' ON PROM.PromotorID=Cli.PromotorActual AND PROM.PromotorID=',CONVERT(Par_Promotor,CHAR));
            END IF;

            SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);
            IF(Par_Moneda!=0)THEN
                SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.MonedaID=',CONVERT(Par_Moneda,CHAR));
            END IF;

            SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
            IF(Par_Sucursal!=0)THEN
            SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.SucursalID=',CONVERT(Par_Sucursal,CHAR));
            END IF;

            SET Var_Sentencia := CONCAT(Var_Sentencia,' WHERE (Cre.Estatus    = "',EstatusVigente,'" OR Cre.Estatus = "',EstatusVencido,'" OR Cre.Estatus = "',EstatusSuspendido,'") ');
            SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Cre.EsAgropecuario="N"  ORDER BY Cre.CreditoID; ');

            SET @Sentencia  = (Var_Sentencia);


            PREPARE STSALDOSTOTALESREP FROM @Sentencia;
            EXECUTE  STSALDOSTOTALESREP;

			-- OBTENEMOS LA FECHA DE PROXIMO PAGO Y EL ESTATUS DE LA AMORTIZACION
			DROP TABLE IF EXISTS TMPFECHAPROXPAGOCRE;
			CREATE TEMPORARY TABLE TMPFECHAPROXPAGOCRE (
				AmortizacionID	INT(4)		COMMENT 'Numero de Amortizacion',
				CreditoID       BIGINT(12)	COMMENT 'Numero de Credito',
				FechaProxPago	DATE		COMMENT 'Fecha Proximo de Pago del Credito',
				Estatus			CHAR(1)		COMMENT 'Estatus de la Amortizacion',
				INDEX (AmortizacionID,CreditoID));
				CREATE INDEX IDX_1 ON TMPFECHAPROXPAGOCRE(FechaProxPago);


			INSERT INTO TMPFECHAPROXPAGOCRE (
				AmortizacionID,			CreditoID,		FechaProxPago,			Estatus)
			SELECT
				MIN(Amo.AmortizacionID),Amo.CreditoID, 	MIN(Amo.FechaExigible),	MIN(Amo.Estatus)
			FROM tmp_TMPSALDOSTOTALESREP Tmp,
				 AMORTICREDITO Amo
			WHERE Tmp.CreditoID = Amo.CreditoID
			AND Amo.FechaExigible > Par_Fecha
			AND Amo.Estatus = EstatusVigente
			GROUP BY Tmp.CreditoID;

			-- SE ACTUALIZA LA FECHA DE PROXIMO PAGO Y EL ESTATUS DE LA AMORTIZACION
			UPDATE tmp_TMPSALDOSTOTALESREP Tmp,
				   TMPFECHAPROXPAGOCRE Cre
			SET Tmp.FechaProxPago = Cre.FechaProxPago,
				Tmp.EstatusAmortiza = Cre.Estatus
			WHERE Tmp.CreditoID = Cre.CreditoID;

        END IF;

         -- OBTENEMOS LA FECHA DEL ULTIMO ABONO FechaUltAbonoCre
        DROP TABLE IF EXISTS tmp_UltAbono;
        CREATE TEMPORARY TABLE tmp_UltAbono (
            CreditoID       BIGINT(12),
            FechaUltAbonoCre    DATE,
            INDEX (CreditoID)   );
		CREATE INDEX IDX_1 ON tmp_UltAbono(FechaUltAbonoCre);


        INSERT INTO tmp_UltAbono
          SELECT Tmp.CreditoID, MAX(Cre.FechaAplicacion) AS FechaUltAbonoCre
              FROM tmp_TMPSALDOSTOTALESREP Tmp
                LEFT OUTER JOIN  CREDITOSMOVS Cre  ON Tmp.CreditoID=Cre.CreditoID
                  WHERE  Cre.NatMovimiento='A'
                  and Cre.FechaAplicacion <=Par_Fecha
                  GROUP BY Tmp.CreditoID;

        UPDATE tmp_TMPSALDOSTOTALESREP Tmp INNER JOIN  tmp_UltAbono Ult ON Tmp.CreditoID = Ult.CreditoID
          SET   Tmp.FechaUltAbonoCre = Ult.FechaUltAbonoCre;

        -- OBTENEMOS EL CAPITAL VIGENTE CapVigenteExi
        DROP TABLE IF EXISTS tmp_CapVigenteExi;
        CREATE TEMPORARY TABLE tmp_CapVigenteExi (
             CreditoID       BIGINT(12),
             CapVigenteExi       DECIMAL(16,2),
             INDEX (CreditoID)   );

        INSERT INTO tmp_CapVigenteExi
          SELECT Tmp.CreditoID,  IFNULL(SUM(Amo.SaldoCapVigente), 0)
              FROM tmp_TMPSALDOSTOTALESREP Tmp INNER JOIN AMORTICREDITO Amo ON Tmp.CreditoID = Amo.CreditoID
                  WHERE  Amo.Estatus != "P" AND Amo.FechaExigible <= FechaSist
                    GROUP BY Tmp.CreditoID;

        UPDATE tmp_TMPSALDOSTOTALESREP Tmp INNER JOIN  tmp_CapVigenteExi Cap ON Tmp.CreditoID = Cap.CreditoID
          SET   Tmp.CapVigenteExi = Cap.CapVigenteExi
        WHERE Tmp.CreditoID = Cap.CreditoID;


                -- OBTENEMOS LA FECHA DE ULTIMO DEPOSITO A CUENTA FechaUltDepCta
        DROP TABLE IF EXISTS tmp_AuxHis;
        CREATE  TABLE tmp_AuxHis (
            CreditoID       BIGINT(12),
            CuentaID        BIGINT(12),
            FechaHisCtaAho   DATE,

            INDEX (CreditoID)   );
		CREATE INDEX IDX_1 ON tmp_AuxHis(CuentaID);
		CREATE INDEX IDX_2 ON tmp_AuxHis(FechaHisCtaAho);


        INSERT INTO tmp_AuxHis
            SELECT Tmp.CreditoID, MAX(Cre.CuentaID), IFNULL(MAX(His.Fecha), Fecha_Vacia) AS FechaHisCtaAho
               FROM tmp_TMPSALDOSTOTALESREP Tmp
                   LEFT OUTER JOIN CREDITOS Cre ON Tmp.CreditoID = Cre.CreditoID
                   LEFT OUTER JOIN `HIS-CUENAHOMOV` His ON Cre.CuentaID = His.CuentaAhoID
                   WHERE His.NatMovimiento= Var_NatMovimiento
                   AND His.Fecha<=Par_Fecha
                   GROUP BY Tmp.CreditoID;

        DROP TABLE IF EXISTS tmp_AuxAho;
        CREATE  TABLE tmp_AuxAho (
            CreditoID       BIGINT(12),
            CuentaID        BIGINT(12),
            FechaCtaAho   DATE,
            INDEX (CreditoID)   );

        CREATE INDEX IDX_1 ON tmp_AuxAho(CuentaID);
		CREATE INDEX IDX_2 ON tmp_AuxAho(FechaCtaAho);

        INSERT INTO tmp_AuxAho
            SELECT Tmp.CreditoID, MAX(Cre.CuentaID),  IFNULL(MAX(CueMov.Fecha), Fecha_Vacia)  AS FechaCtaAho
               FROM tmp_TMPSALDOSTOTALESREP Tmp
                   LEFT OUTER JOIN CREDITOS Cre ON Tmp.CreditoID = Cre.CreditoID
                   LEFT OUTER JOIN CUENTASAHOMOV CueMov ON Cre.CuentaID = CueMov.CuentaAhoID
                   WHERE CueMov.NatMovimiento= Var_NatMovimiento
                   and CueMov.Fecha<=Par_Fecha
                   GROUP BY Tmp.CreditoID;


        DROP TABLE IF EXISTS tmp_UltDepCta;
        CREATE TEMPORARY TABLE tmp_UltDepCta (
            CreditoID       BIGINT(12),
            FechaCtaAho    DATE,
            FechaHisCtaAho   DATE,
            INDEX (CreditoID)   );
		CREATE INDEX IDX_1 ON tmp_UltDepCta(FechaCtaAho);
		CREATE INDEX IDX_2 ON tmp_UltDepCta(FechaHisCtaAho);

        INSERT INTO tmp_UltDepCta
            SELECT Tmp.CreditoID, Aho.FechaCtaAho, His.FechaHisCtaAho
                FROM tmp_TMPSALDOSTOTALESREP Tmp
                    LEFT OUTER JOIN tmp_AuxHis His ON Tmp.CreditoID = His.CreditoID
                    LEFT OUTER JOIN tmp_AuxAho Aho ON Tmp.CreditoID = Aho.CreditoID;

        UPDATE tmp_TMPSALDOSTOTALESREP  Tmp INNER JOIN tmp_UltDepCta Ult ON Tmp.CreditoID = Ult.CreditoID
            SET Tmp.FechaUltDepCta = CASE WHEN ( IFNULL(Ult.FechaCtaAho, Fecha_Vacia) > IFNULL(Ult.FechaHisCtaAho, Fecha_Vacia)) THEN
                     CONVERT(IFNULL(Ult.FechaCtaAho, Fecha_Vacia), CHAR)
                ELSE CONVERT(IFNULL(Ult.FechaHisCtaAho, Fecha_Vacia), CHAR) END;
    END IF;

    SET Var_ExisteCobraSeguro := (SELECT COUNT(CR.CreditoID)
                                    FROM tmp_TMPSALDOSTOTALESREP AS CR INNER JOIN
                                    CREDITOS AS C    ON CR.CreditoID = C.CreditoID
                                    WHERE CR.Transaccion = Aud_NumTransaccion
                                    AND C.CobraSeguroCuota = 'S'
                                    AND CR.DiasAtraso >= Par_AtrasoInicial
                                    AND CR.DiasAtraso <=Par_AtrasoFinal);

    SET Var_ExisteCobraSeguro := IFNULL(Var_ExisteCobraSeguro,0); -- No existen creditos que cobran seguros

    UPDATE tmp_TMPSALDOSTOTALESREP T
        LEFT JOIN CREDITOS C
        ON T.CreditoID = C.CreditoID
        LEFT JOIN LINEAFONDEADOR L
        ON C.LineaFondeo = L.LineaFondeoID
        SET
            T.FolioFondeo = CASE
            WHEN C.LineaFondeo > Entero_Cero THEN L.FolioFondeo
            WHEN C.LineaFondeo = Entero_Cero THEN 'NA'
            END,
            T.InstitutFondID = L.InstitutFondID
        WHERE Transaccion = Aud_NumTransaccion
        AND T.CreditoID = C.CreditoID;


    UPDATE tmp_TMPSALDOSTOTALESREP AS T INNER JOIN CREDITOS AS G ON T.CreditoID = G.CreditoID
        SET
        T.GrupoID = G.GrupoID
        WHERE G.GrupoID>0;


    UPDATE tmp_TMPSALDOSTOTALESREP AS T INNER JOIN GRUPOSCREDITO AS G ON T.GrupoID = G.GrupoID
        LEFT JOIN SUCURSALES AS SUC ON G.SucursalID =SUC.SucursalID
        SET
        T.NombreGrupo = G.NombreGrupo,
        T.SucursalGrupo = G.SucursalID,
        T.SucursalNombreGrupo = SUC.NombreSucurs
        WHERE T.GrupoID = G.GrupoID;

    UPDATE tmp_TMPSALDOSTOTALESREP AS T INNER JOIN CREDITOS AS CRED ON T.CreditoID = CRED.CreditoID
        INNER JOIN SUCURSALES AS SUC ON CRED.SucursalID =SUC.SucursalID
        SET
        T.SucursalGrupo = CRED.SucursalID,/*Sucursal de todos los creditos*/
        T.SucursalNombreGrupo = SUC.NombreSucurs
        WHERE T.CreditoID =CRED.CreditoID;

    -- INICIO Tablas Notas Cargo

    DROP TEMPORARY TABLE IF EXISTS TMPCREDITOSNOTASCARGO;
	CREATE TEMPORARY TABLE TMPCREDITOSNOTASCARGO (
		CreditoID				BIGINT(12),
		PRIMARY KEY (CreditoID)
	);

    DROP TEMPORARY TABLE IF EXISTS TMPEXIGIBLESNOTASCARGO;
	CREATE TEMPORARY TABLE TMPEXIGIBLESNOTASCARGO (
		CreditoID				BIGINT(12),
		Monto					DECIMAL(14,2),
		MontoExigible			DECIMAL(14,2),
		PRIMARY KEY (CreditoID)
	);

	DROP TEMPORARY TABLE IF EXISTS TMPPAGOSNOTASCARGO;
	CREATE TEMPORARY TABLE TMPPAGOSNOTASCARGO (
		CreditoID				BIGINT(12),
		Monto					DECIMAL(14,2),
		IvaMonto				DECIMAL(14,2),
		PRIMARY KEY (CreditoID)
	);

	DROP TEMPORARY TABLE IF EXISTS TMPIVAPAGADONOTASCARGO;
	CREATE TEMPORARY TABLE TMPIVAPAGADONOTASCARGO (
		CreditoID				BIGINT(12),
		IvaMonto				DECIMAL(14,2),
		PRIMARY KEY (CreditoID)
	);

	-- Creditos con notas de cargo a fecha corte
	INSERT INTO TMPCREDITOSNOTASCARGO (	CreditoID	)
							SELECT		NTC.CreditoID
								FROM	NOTASCARGO NTC
								INNER JOIN tmp_TMPSALDOSTOTALESREP TMP ON NTC.CreditoID = TMP.CreditoID
								INNER JOIN AMORTICREDITO AMO ON AMO.CreditoID = NTC.CreditoID AND NTC.AmortizacionID = AMO.AmortizacionID
								WHERE NTC.FechaRegistro <= Par_Fecha
								GROUP BY NTC.CreditoID, AMO.CreditoID;

	-- Montos de notas de cargo a fecha corte
	INSERT INTO TMPEXIGIBLESNOTASCARGO (	CreditoID,			Monto,									MontoExigible	)
								SELECT		NTC.CreditoID,		ROUND(SUM(ROUND(NTC.Monto, 2)), 2),		Entero_Cero
									FROM	TMPCREDITOSNOTASCARGO TMP
									INNER JOIN NOTASCARGO NTC ON TMP.CreditoID = NTC.CreditoID AND NTC.FechaRegistro <= Par_Fecha
									INNER JOIN AMORTICREDITO AMO ON AMO.CreditoID = NTC.CreditoID AND NTC.AmortizacionID = AMO.AmortizacionID
									GROUP BY NTC.CreditoID, AMO.CreditoID;

	-- Montos pagados de notas de cargo a fechas exigibles
	INSERT INTO TMPPAGOSNOTASCARGO (	CreditoID,			Monto	)
							SELECT		DET.CreditoID,		ROUND(SUM(ROUND(DET.MontoNotasCargo, 2)), 2)
								FROM	TMPCREDITOSNOTASCARGO TMP
								INNER JOIN DETALLEPAGCRE DET ON DET.CreditoID = TMP.CreditoID AND DET.FechaPago <= Par_Fecha
								GROUP BY DET.CreditoID;

	-- Montos de iva pagados en total
	INSERT INTO TMPIVAPAGADONOTASCARGO (	CreditoID,			IvaMonto	)
								SELECT		DET.CreditoID,		ROUND(SUM(ROUND(DET.MontoIVANotasCargo, 2)), 2)
									FROM	TMPCREDITOSNOTASCARGO TMP
									INNER JOIN DETALLEPAGCRE DET ON DET.CreditoID = TMP.CreditoID AND DET.FechaPago <= Par_Fecha
									GROUP BY DET.CreditoID;

	-- Exigible de notas de cargo a fecha corte
	UPDATE TMPEXIGIBLESNOTASCARGO NTC
		INNER JOIN TMPPAGOSNOTASCARGO PAG ON NTC.CreditoID = PAG.CreditoID
	SET	NTC.MontoExigible = ROUND(NTC.Monto - PAG.Monto, 2);

	UPDATE TMPEXIGIBLESNOTASCARGO
	SET	MontoExigible = Entero_Cero
	WHERE MontoExigible < Entero_Cero;

	UPDATE tmp_TMPSALDOSTOTALESREP TMP
		INNER JOIN TMPIVAPAGADONOTASCARGO NTC ON NTC.CreditoID = TMP.CreditoID
	SET	TMP.IvaNotasCargo = NTC.IvaMonto;

	UPDATE tmp_TMPSALDOSTOTALESREP TMP
		INNER JOIN TMPEXIGIBLESNOTASCARGO NTC ON NTC.CreditoID = TMP.CreditoID
	SET	TMP.NotasCargo = NTC.MontoExigible,
		TMP.MontoTotalExi = ROUND(TMP.MontoTotalExi + NTC.MontoExigible, 2);

    -- FIN Tablas Notas Cargo

	IF(Var_RestringeReporte = 'N')THEN
		SELECT
			CR.CreditoID AS CreditoID,           CR.ProductoCreditoID,   CR.Descripcion,         LPAD(CR.ClienteID,10,0) AS ClienteID,   CR.NombreCompleto,
			CR.SaldoCapVigent,      CR.SaldoCapAtrasad,     CR.SaldoCapVencido,     CR.SaldCapVenNoExi,                     CR.SaldoInterProvi,
			CR.SaldoInterAtras,     CR.SaldoInterVenc,      CR.SaldoIntNoConta,     CR.SaldoMoratorios,                     CR.SaldComFaltPago,
			CR.SaldoOtrasComis,     CR.SaldoIVAInteres,     CR.SaldoIVAMorator,     CR.SalIVAComFalPag,                     CR.SaldoIVAComisi,
			CR.PasoCapAtraDia,      CR.PasoCapVenDia,       CR.PasoCapVNEDia ,      CR.PasoIntAtraDia,                      CR.PasoIntVenDia,
			CR.CapRegularizado,     CR.IntOrdDevengado,     CR.IntMorDevengado,     CR.ComisiDevengado,                     CR.PagoCapVigDia,
			CR.PagoCapAtrDia,       CR.PagoCapVenDia,       CR.PagoCapVenNexDia,    CR.PagoIntOrdDia,                       CR.PagoIntAtrDia,
			CR.PagoIntVenDia,       CR.PagoIntCalNoCon,     CR.PagoComisiDia,       CR.PagoMoratorios,                      CR.PagoIvaDia,
			CR.IntCondonadoDia,     CR.MorCondonadoDia,     CR.IntDevCtaOrden,      CR.CapCondonadoDia,                     CR.ComAdmonPagDia,
			CR.ComCondonadoDia,     CR.DesembolsosDia,      CR.FechaInicio,         CR.FechaVencimiento,                    CR.FechaUltAbonoCre,
			CR.MontoCredito,        CR.DiasAtraso,          CR.SaldoDispon,         CR.SaldoBloq ,                          CR.FechaUltDepCta,
			CR.FrecuenciaCap,       CR.FrecuenciaInt,       CR.CapVigenteExi,       CR.MontoTotalExi,                       CR.TasaFija,
			CR.PromotorID,          CR.NombrePromotor,      CR.FechaEmision,        CR.HoraEmision,                         CR.MoraVencido,
			CR.MoraCarVen,          F.Formula,              CR.MontoSeguroCuota,    CR.IVASeguroCuota,                      CR.FolioFondeo,
			CR.GrupoID,             CR.NombreGrupo,         CR.SucursalGrupo,       CR.SucursalNombreGrupo,
			IF(Var_ExisteCobraSeguro>0,'S','N') AS ExisteCredCobraSeguro,
			CR.DestinoCredID,   UPPER(CR.DesDestino) AS DesDestino, IFNULL(I.NombreInstitFon, 'RECURSOS PROPIOS') AS InstFondeo,
			CASE WHEN CR.FechaProxPago != Fecha_Vacia THEN CR.FechaProxPago ELSE Cadena_Vacia END AS FechaProxPago,
			CASE WHEN CR.EstatusAmortiza = EstatusVigente AND CR.FechaProxPago != Fecha_Vacia THEN 'VIGENTE'
				 WHEN CR.EstatusAmortiza = EstatusAtras AND CR.FechaProxPago != Fecha_Vacia THEN 'ATRASADA'
				 WHEN CR.EstatusAmortiza = EstatusVencido AND CR.FechaProxPago != Fecha_Vacia THEN 'VENCIDA'
				 WHEN CR.EstatusAmortiza = EstatusPagado AND CR.FechaProxPago != Fecha_Vacia THEN 'PAGADA'
				 ELSE Cadena_Vacia END AS EstatusAmortiza,
			CR.InstitNominaID,		CR.ConvenioNominaID,	CR.NombreInstit,		CR.NotasCargo,							CR.IvaNotasCargo
			FROM tmp_TMPSALDOSTOTALESREP AS CR
				LEFT JOIN FORMTIPOCALINT AS F ON CR.CalcInteresID=F.FormInteresID
				LEFT JOIN INSTITUTFONDEO I ON CR.InstitutFondID = I.InstitutFondID
			WHERE Transaccion = Aud_NumTransaccion
			AND DiasAtraso >= Par_AtrasoInicial
			AND DiasAtraso <=Par_AtrasoFinal;
        END IF;

		IF(Var_RestringeReporte = 'S')THEN

			-- OBTENEMOS LOS USUARIOS QUE SON DEPENDENCIAS
			SET Var_UsuDependencia := (SELECT FNUSUARIOSDEPENDECIA(Aud_Usuario));

			SET Var_Sentencia := CONCAT("
				SELECT
			CR.CreditoID AS CreditoID,           CR.ProductoCreditoID,   CR.Descripcion,         LPAD(CR.ClienteID,10,0) AS ClienteID,   CR.NombreCompleto,
			CR.SaldoCapVigent,      CR.SaldoCapAtrasad,     CR.SaldoCapVencido,     CR.SaldCapVenNoExi,                     CR.SaldoInterProvi,
			CR.SaldoInterAtras,     CR.SaldoInterVenc,      CR.SaldoIntNoConta,     CR.SaldoMoratorios,                     CR.SaldComFaltPago,
			CR.SaldoOtrasComis,     CR.SaldoIVAInteres,     CR.SaldoIVAMorator,     CR.SalIVAComFalPag,                     CR.SaldoIVAComisi,
			CR.PasoCapAtraDia,      CR.PasoCapVenDia,       CR.PasoCapVNEDia ,      CR.PasoIntAtraDia,                      CR.PasoIntVenDia,
			CR.CapRegularizado,     CR.IntOrdDevengado,     CR.IntMorDevengado,     CR.ComisiDevengado,                     CR.PagoCapVigDia,
			CR.PagoCapAtrDia,       CR.PagoCapVenDia,       CR.PagoCapVenNexDia,    CR.PagoIntOrdDia,                       CR.PagoIntAtrDia,
			CR.PagoIntVenDia,       CR.PagoIntCalNoCon,     CR.PagoComisiDia,       CR.PagoMoratorios,                      CR.PagoIvaDia,
			CR.IntCondonadoDia,     CR.MorCondonadoDia,     CR.IntDevCtaOrden,      CR.CapCondonadoDia,                     CR.ComAdmonPagDia,
			CR.ComCondonadoDia,     CR.DesembolsosDia,      CR.FechaInicio,         CR.FechaVencimiento,                    CR.FechaUltAbonoCre,
			CR.MontoCredito,        CR.DiasAtraso,          CR.SaldoDispon,         CR.SaldoBloq ,                          CR.FechaUltDepCta,
			CR.FrecuenciaCap,       CR.FrecuenciaInt,       CR.CapVigenteExi,       CR.MontoTotalExi,                       CR.TasaFija,
			CR.PromotorID,          CR.NombrePromotor,      CR.FechaEmision,        CR.HoraEmision,                         CR.MoraVencido,
			CR.MoraCarVen,          F.Formula,              CR.MontoSeguroCuota,    CR.IVASeguroCuota,                      CR.FolioFondeo,
			CR.GrupoID,             CR.NombreGrupo,         CR.SucursalGrupo,       CR.SucursalNombreGrupo,
			IF(",Var_ExisteCobraSeguro,">0,'S','N') AS ExisteCredCobraSeguro,
			CR.DestinoCredID,   UPPER(CR.DesDestino) AS DesDestino, IFNULL(I.NombreInstitFon, 'RECURSOS PROPIOS') AS InstFondeo,
			CASE WHEN CR.FechaProxPago != '1900-01-01' THEN CR.FechaProxPago ELSE '' END AS FechaProxPago,
			CASE WHEN CR.EstatusAmortiza = 'V' AND CR.FechaProxPago != '1900-01-01' THEN 'VIGENTE'
				 WHEN CR.EstatusAmortiza = 'A' AND CR.FechaProxPago != '1900-01-01' THEN 'ATRASADA'
				 WHEN CR.EstatusAmortiza = 'B' AND CR.FechaProxPago != '1900-01-01' THEN 'VENCIDA'
				 WHEN CR.EstatusAmortiza = 'P' AND CR.FechaProxPago != '1900-01-01' THEN 'PAGADA'
				 ELSE '' END AS EstatusAmortiza,
			CR.InstitNominaID,		CR.ConvenioNominaID,	CR.NombreInstit,		CR.NotasCargo,							CR.IvaNotasCargo
			FROM tmp_TMPSALDOSTOTALESREP AS CR
				LEFT JOIN FORMTIPOCALINT AS F ON CR.CalcInteresID=F.FormInteresID
				LEFT JOIN INSTITUTFONDEO I ON CR.InstitutFondID = I.InstitutFondID
                LEFT JOIN SOLICITUDCREDITO SOL
						ON CR.CreditoID = SOL.CreditoID
			WHERE Transaccion = ",Aud_NumTransaccion,"
			AND DiasAtraso >= ",Par_AtrasoInicial,"
			AND DiasAtraso <= ",Par_AtrasoFinal,"
            AND SOL.UsuarioAltaSol IN(",Var_UsuDependencia,")
			 ;");

			SET @Sentencia2	= (Var_Sentencia);

			PREPARE STSALDOSCAPITALREP2 FROM @Sentencia2;
			EXECUTE STSALDOSCAPITALREP2;
			DEALLOCATE PREPARE STSALDOSCAPITALREP2;

		END IF;

        DROP TABLE IF EXISTS tmp_TMPSALDOSTOTALESREP;
		DROP TEMPORARY TABLE IF EXISTS TMPPAGOSNOTASCARGO;
		DROP TEMPORARY TABLE IF EXISTS TMPCREDITOSNOTASCARGO;
		DROP TEMPORARY TABLE IF EXISTS TMPEXIGIBLESNOTASCARGO;
		DROP TEMPORARY TABLE IF EXISTS TMPIVAPAGADONOTASCARGO;

END TerminaStore$$
