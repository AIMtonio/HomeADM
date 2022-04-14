-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTIZAINDIVREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTIZAINDIVREP`;
DELIMITER $$

CREATE PROCEDURE `AMORTIZAINDIVREP`(
    Par_CreditoID       BIGINT(12),
    Par_ClienteID       INT(11),
    Par_TipoReporte     INT,

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT
                )
TerminaStore: BEGIN

-- Declaracion de Variables amortizacion
DECLARE	NumInstitucion 		INT;
DECLARE DireccionInstitu 	VARCHAR(250);
DECLARE NombreInstitu 		VARCHAR(100);
DECLARE	Sucurs				VARCHAR(50);
DECLARE Registro_Reca		VARCHAR(200);
-- --------------------------------------
-- variables datos grupo
DECLARE Var_NumInt          INT;
DECLARE Var_NomGrupo        VARCHAR(50);
DECLARE Var_SolicitudPres   INT;
DECLARE Var_Cargo           INT;
DECLARE Var_Estado          VARCHAR(50);
DECLARE Var_TipoPlan       	VARCHAR(50);
DECLARE Var_TipoPrestamo   	VARCHAR(50);
DECLARE Var_NumAmort        INT;
DECLARE Var_ClienteID       INT;
DECLARE Var_Promotor       	VARCHAR(50);
DECLARE Var_Sucursal       	VARCHAR(50);
DECLARE Var_CicloGruAc      INT;
DECLARE Var_CicloAnt        INT;
DECLARE Var_NumCredAnt      VARCHAR (50);
DECLARE Var_MontoCredAnt    DECIMAL(12,2);

DECLARE Var_TasaAnual   		DECIMAL(12,4);
DECLARE Var_TasaMens   	 		DECIMAL(12,4);
DECLARE Var_TasaFlat    		DECIMAL(12,4);
DECLARE Var_CAT         		DECIMAL(12,4);
DECLARE Var_CreditoID   		BIGINT;
DECLARE Var_TotInteres  		DECIMAL(14,2);
DECLARE Var_NumAmorti   		INT;
DECLARE Var_MontoCred   		DECIMAL(14,2);
DECLARE Var_SumMonCred         	DECIMAL(14,2);
DECLARE Var_MontoGarLiq   		DECIMAL(14,2);
DECLARE Var_MonGarLiq   		VARCHAR(20);
DECLARE Var_Plazo       		VARCHAR(100);
DECLARE Var_FechaVenc   		DATE;
DECLARE Var_MontoSeguro 		DECIMAL(14,2);
DECLARE Var_PorcCobert  		DECIMAL(12,4);
DECLARE Var_NomRepres   		VARCHAR(300);
DECLARE Var_Periodo     		INT;
DECLARE Var_Frecuencia  		CHAR(1);
DECLARE Var_FrecuenciaInt  		CHAR(1);
DECLARE Var_DesFrec     		VARCHAR(100);
DECLARE Var_FacRiesgo   		DECIMAL(12,6);
DECLARE Var_FrecSeguro  		VARCHAR(100);
DECLARE Var_NumRECA    			VARCHAR(200);
DECLARE Var_DiaVencimiento		VARCHAR(20);
DECLARE Var_MesVencimiento		VARCHAR(20);
DECLARE Var_AnioVencimiento		VARCHAR(20);
DECLARE Var_RepresentanteLegal	VARCHAR(200);
DECLARE Var_DirccionInstitucion	VARCHAR(300);
DECLARE Var_SexoRepteLegal		CHAR(200);
DECLARE Var_TelInstitucion		VARCHAR(20);
DECLARE Var_NombreEstado		VARCHAR(100);
DECLARE Var_RFCOficial 			VARCHAR(20);
DECLARE Var_DiaSistema			INT;
DECLARE Var_AnioSistema			INT;
DECLARE Var_MesSistema 			VARCHAR(20);
DECLARE Var_NomCortoInstit		VARCHAR(50);
DECLARE Var_FechaMinistrado     VARCHAR(25);
DECLARE Var_ProductoCreditoID   INT;
DECLARE Var_EstatusCredito		CHAR(1);
DECLARE Var_NumCuotas			INT;
DECLARE Var_NombreDireccion		VARCHAR(500);
DECLARE Var_FolioControl		VARCHAR(20);
DECLARE Var_DescProdCre			VARCHAR(250);
DECLARE Var_TipoCredito			CHAR(1);
DECLARE Var_EstatusSol			CHAR(1);
DECLARE Var_FechaRegistro 		DATE;

-- SECCION 6: PLAN DE PAGOS - SOFIEXPRESS
DECLARE	Tipo_PlanPagos			INT;						-- Reporte Plan de Pagos SOFIEXPRESS.
DECLARE	Var_NomSuc				VARCHAR(100);				-- Nombre de la Sucursal a la que pertenece el cliente.
DECLARE	Var_FechaActual			DATE;						-- Fecha Actual del Sistema.
DECLARE	Var_FechaActTxt			VARCHAR(100);				-- Fecha Actual del Sistema con el formato deseado.
DECLARE	Var_CliNombres			VARCHAR(100);				-- Nombres del Cliente.
DECLARE	Var_CliApPat			VARCHAR(50);				-- Apellido Paterno Cliente.
DECLARE	Var_CliApMat			VARCHAR(50);				-- Apellido Materno Cliente.
DECLARE	Var_ProdCredAnt			VARCHAR(100);				-- Nombre del producto del crédito anterior del cliente
DECLARE	Var_TipPrestamo			VARCHAR(100);				-- Indica tipo de préstamo otorgado al cliente.
DECLARE VGraciaFaltaPago		VARCHAR(100);
DECLARE NomCortoInstitu			VARCHAR(100);
DECLARE TipoProCre				VARCHAR(100);
DECLARE Var_FecInicio			DATE;

-- 	SECCION 7: ALTERNATIVA 19
DECLARE Var_CarProdCred				VARCHAR(250);
DECLARE Var_NumeroCuenta			VARCHAR(100);
DECLARE Var_NombreBanco				VARCHAR(100);
DECLARE Var_Clabe					VARCHAR(100);
DECLARE Var_ProductoCredito 		INT(11);
DECLARE Var_SucursalCred			INT(11);

-- Finaciera ZAFY
DECLARE	Var_NombreCliente		VARCHAR(200);
DECLARE	Var_MontoSeguroCuota	DECIMAL(12,2);
DECLARE Var_IVASeguroCuota		DECIMAL(12,2);

-- FRECUENCIAS

DECLARE Frec_Semanal 			CHAR(1);
DECLARE Frec_Catorcenal			CHAR(1);
DECLARE Frec_Quincenal			CHAR(1);
DECLARE Frec_Mensual			CHAR(1);
DECLARE Frec_Periodica			CHAR(1);
DECLARE Frec_Bimestral			CHAR(1);
DECLARE Frec_Trimestral			CHAR(1);
DECLARE Frec_Tetramestral		CHAR(1);
DECLARE Frec_Semestral			CHAR(1);
DECLARE Frec_Anual				CHAR(1);
DECLARE Frec_Decenal			CHAR(1);
DECLARE Frec_Mixto				VARCHAR(15);
DECLARE Frec_Unico				CHAR(1);

DECLARE Desc_Semanal 			VARCHAR(20);
DECLARE Desc_Catorcenal			VARCHAR(20);
DECLARE Desc_Quincenal			VARCHAR(20);
DECLARE Desc_Mensual			VARCHAR(20);
DECLARE Desc_Periodica			VARCHAR(20);
DECLARE Desc_Bimestral			VARCHAR(20);
DECLARE Desc_Trimestral			VARCHAR(20);
DECLARE Desc_Tetramestral		VARCHAR(20);
DECLARE Desc_Semestral			VARCHAR(20);
DECLARE Desc_Anual				VARCHAR(20);
DECLARE Desc_Decenal			VARCHAR(20);

DECLARE Mayus_Semanal 			VARCHAR(20);
DECLARE Mayus_Catorcenal		VARCHAR(20);
DECLARE Mayus_Quincenal			VARCHAR(20);
DECLARE Mayus_Mensual			VARCHAR(20);
DECLARE Mayus_Periodica			VARCHAR(20);
DECLARE Mayus_Bimestral			VARCHAR(20);
DECLARE Mayus_Trimestral		VARCHAR(20);
DECLARE Mayus_Tetramestral		VARCHAR(20);
DECLARE Mayus_Semestral			VARCHAR(20);
DECLARE Mayus_Anual				VARCHAR(20);
DECLARE Mayus_Decenal			VARCHAR(20);
DECLARE Mayus_Unico				VARCHAR(20);

DECLARE Perio_Semanal 			VARCHAR(20);
DECLARE Perio_Catorcenal		VARCHAR(20);
DECLARE Perio_Quincenal			VARCHAR(20);
DECLARE Perio_Mensual			VARCHAR(20);
DECLARE Perio_Periodica			VARCHAR(20);
DECLARE Perio_Bimestral			VARCHAR(20);
DECLARE Perio_Trimestral		VARCHAR(20);
DECLARE Perio_Tetramestral		VARCHAR(20);
DECLARE Perio_Semestral			VARCHAR(20);
DECLARE Perio_Anual				VARCHAR(20);
DECLARE Perio_Decenal			VARCHAR(20);

DECLARE Pag_Crecientes			CHAR(1);
DECLARE Pag_Iguales				CHAR(1);
DECLARE Pag_Libres				CHAR(1);

DECLARE Desc_Crecientes			VARCHAR(20);
DECLARE Desc_Iguales			VARCHAR(20);
DECLARE Desc_Libres				VARCHAR(20);

DECLARE Cred_Comercial			CHAR(1);
DECLARE Cred_Consumo			CHAR(1);
DECLARE Cred_Hipotecario		CHAR(1);

DECLARE Desc_Comercial			VARCHAR(20);
DECLARE Desc_Consumo			VARCHAR(20);
DECLARE Desc_Hipotecario		VARCHAR(20);
DECLARE Desc_NoAplica			VARCHAR(20);

DECLARE Var_Activo				VARCHAR(20);
DECLARE Var_Inactivo			VARCHAR(20);
DECLARE Var_Rechazado			VARCHAR(20);
DECLARE Var_ImgTelecomm         VARCHAR(200);
DECLARE Var_ImgOXXO         	VARCHAR(200);
DECLARE Var_InstBANORTE			VARCHAR(50);	-- Valor de la institucion BANORTE
DECLARE Var_InstTELECOM			VARCHAR(50);	-- Valor de la institucion TELECOM

-- CONSTANTES --
DECLARE	Decimal_Cero		DECIMAL(12,4);
DECLARE Esta_Activo     	CHAR(1);
DECLARE Esta_Inactivo     	CHAR(1);
DECLARE Esta_Rechazado     	CHAR(1);
DECLARE Lis_Integra         INT;
DECLARE Tipo_Amortizacion   INT;
DECLARE	EstCerrado			CHAR(1);
DECLARE Tipo_DatosGrupo	 	INT;
DECLARE Tipo_Enca          	INT;
DECLARE Var_Libres			VARCHAR(10);
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Entero_Cero         INT;
DECLARE Fecha_Vacia         DATE;
DECLARE Est_Activo          CHAR(1);
DECLARE Int_Presiden        INT;
DECLARE Tipo_DatosCred      INT;
DECLARE EstatusAutorizado	CHAR(1);
DECLARE EstatusInactivo		CHAR(1);
DECLARE SiMostrar			CHAR(1);
DECLARE NoMostrar			CHAR(1);
DECLARE EstDesembolsada		CHAR(1);
DECLARE CredReestructura	CHAR(1);

-- Tipo Alternativa 19
DECLARE Tipo_Individual			VARCHAR(20);
DECLARE Tipo_Alternativa        CHAR(1);
DECLARE Tipo_AmortizaAlternativa     CHAR(1);
DECLARE Var_PeriodCap 			INT(11);
DECLARE Var_PeriodInt 			INT(11);
DECLARE Var_FrecCapital 		CHAR(1);
DECLARE Var_FrecInteres 		CHAR(1);
DECLARE Var_FrecuenciaTxt		VARCHAR(30);

-- Constantes Financiera ZAFY
DECLARE Tipo_AmortizacionZafy	INT(11);

DECLARE Tipo_AmortAsefimex		INT(11);
DEClARE Cons_Si					CHAR(1);
DECLARE Var_MunicipioID			INT(11);
DECLARE Var_EstadoID			INT(11);
DECLARE Var_FechaNacimiento		VARCHAR(10);
DECLARE Var_AhorroMenssual		DECIMAL(16,2);
DECLARE Var_CodigoTeleCom       VARCHAR(22);
DECLARE Var_CreditoFormat       VARCHAR(20);
DECLARE Var_NumCred             INT(11);
DEClARE Var_LogSuc              INT(11);
DECLARE Var_Suc                 INT(11);
DECLARE Var_TipoPersona         CHAR(1);
DECLARE Var_RefBansefi			VARCHAR(19);
DECLARE Var_Comision  			INT(11);       -- agregado T15304



DECLARE Tipo_AmortizacionAsefimex   INT(11);
DECLARE LlaveImgTelecomm		VARCHAR(50);
DECLARE LlaveImgOXXO			VARCHAR(50);
DECLARE LlaveInstBANORTE		VARCHAR(50);	-- Institucion que corresponde a BANORTE
DECLARE LlaveInstTELECOM		VARCHAR(50);	-- Institucion que corresponde a TELECOM
DECLARE Frec_Libre 				CHAR(1); 		-- Frecuencia de Pago Libre

-- Asignacion de Constantes
SET	EstCerrado			:= 'C';
SET Esta_Activo         := 'A';
SET Esta_Inactivo		:= 'I';
SET Esta_Rechazado		:= 'R';
SET Cadena_Vacia        := '';              -- String Vacio
SET Fecha_Vacia         := '1900-01-01';    -- Fecha Vacia
SET Entero_Cero         := 0;               -- Entero en Cero
SET Est_Activo          := 'A';             -- Estatus del Integrante: Activo
SET Int_Presiden        := 1;               -- Tipo de Integrante: Presidente
SET Tipo_DatosCred      := 1;               -- Reporte datos de credito
SET Tipo_DatosGrupo    	:= 2;				-- ReporteGrupos
SET Lis_Integra    		:= 3;               -- Reporte Integrantes
SET Tipo_Amortizacion   := 4;               -- Reporte Amortizacion
SET Tipo_Enca           := 5;           	-- encabezado
SET EstatusAutorizado	:='A';				-- Estatus Autorizado
SET EstatusInactivo		:='I';				-- Estatus Inactivo
SET Var_Libres			:='LIBRES';
SET SiMostrar			:='S';
SET NoMostrar			:='N';
SET EstDesembolsada		:='D';
SET CredReestructura	:='R';


SET Frec_Semanal 			:='S';
SET Frec_Catorcenal			:='C';
SET Frec_Quincenal			:='Q';
SET Frec_Mensual			:='M';
SET Frec_Periodica			:='P';
SET Frec_Bimestral			:='B';
SET Frec_Trimestral			:='T';
SET Frec_Tetramestral		:='R';
SET Frec_Semestral			:='E';
SET Frec_Anual				:='A';
SET Frec_Decenal			:='D';
SET Frec_Unico 				:='U';
SET Frec_Libre 				:='L'; -- T_15937 by hussein chan
SET Frec_Mixto				:= 'mixto';

SET Desc_Semanal 			:='semanal';
SET Desc_Catorcenal			:='catorcenal';
SET Desc_Quincenal			:='quincenal';
SET Desc_Mensual			:='mensual';
SET Desc_Periodica			:='periodica';
SET Desc_Bimestral			:='bimestral';
SET Desc_Trimestral			:='trimestral';
SET Desc_Tetramestral		:='tetramestral';
SET Desc_Semestral			:='semestral';
SET Desc_Anual				:='anual';
SET Desc_Decenal			:='decenal';

SET Mayus_Semanal 			:='Semanal';
SET Mayus_Catorcenal		:='Catorcenal';
SET Mayus_Quincenal			:='Quincenal';
SET Mayus_Mensual			:='Mensual';
SET Mayus_Periodica			:='Periodica';
SET Mayus_Bimestral			:='Bimestral';
SET Mayus_Trimestral		:='Trimestral';
SET Mayus_Tetramestral		:='Tetramestral';
SET Mayus_Semestral			:='Semestral';
SET Mayus_Anual				:='Anual';
SET Mayus_Decenal			:='Decenal';
SET Mayus_Unico 			:='Único';

SET Perio_Semanal 			:='Semanas';
SET Perio_Catorcenal		:='Catorcenas';
SET Perio_Quincenal			:='Quincenas';
SET Perio_Mensual			:='Meses';
SET Perio_Periodica			:='Periodos';
SET Perio_Bimestral			:='Bimestres';
SET Perio_Trimestral		:='Trimestres';
SET Perio_Tetramestral		:='Tetramestres';
SET Perio_Semestral			:='Semestres';
SET Perio_Anual				:='Años';
SET Perio_Decenal			:='Decenas';

SET Pag_Crecientes			:='C';
SET Pag_Iguales				:='I';
SET Pag_Libres				:='L';

SET Desc_Crecientes			:='CRECIENTES';
SET Desc_Iguales			:='IGUALES';
SET Desc_Libres				:='LIBRES';


SET Cred_Comercial			:='C';
SET Cred_Consumo			:='O';
SET Cred_Hipotecario		:='H';
SET Desc_Comercial			:='Comercial';
SET Desc_Consumo			:='Consumo';
SET Desc_Hipotecario		:='Hipotecario';
SET Desc_NoAplica			:='No aplica';

SET Var_Activo				:='ACTIVO';
SET Var_Inactivo			:='INACTIVO';
SET Var_Rechazado			:='RECHAZADO';
SET Tipo_Individual			:='INDIVIDUAL';
SET LlaveImgTelecomm		:='RutaImgTelecomm';
SET LlaveImgOXXO			:='RutaImgOXXO';
SET LlaveInstBANORTE		:= 'InstitucionBanorte';
SET LlaveInstTELECOM		:= 'InstitucionTelecom';


-- Iniciación variables PLAN DE PAGOS SOFIEXPRESS
SET	Tipo_PlanPagos		:=	6;
SET	Var_FechaActual		:=	(SELECT	FechaSistema	FROM	PARAMETROSSIS);
SET	Decimal_Cero		:=	0.0;

-- Constantes Alternativa 19
SET Tipo_Alternativa    		:= 7;
SET Tipo_AmortizaAlternativa    := 8;

-- Asignacion de Constantes Finaciera ZAFY
SET Tipo_AmortizacionZafy		:= 9;

-- Asignacion de tipo de reporte de amortizaciones de asefimex
SET Tipo_AmortAsefimex	:= 10;
SET Cons_Si				:= 'S';
SET Tipo_AmortizacionAsefimex := 11;


SELECT FechaRegistro  INTO Var_FechaRegistro
    FROM REESTRUCCREDITO Res,
        CREDITOS Cre
WHERE Res.CreditoOrigenID= Par_CreditoID
    AND Res.CreditoDestinoID = Par_CreditoID
    AND Cre.CreditoID = Res.CreditoDestinoID
    AND Res.EstatusReest = EstDesembolsada
    AND Res.Origen= CredReestructura;

-- Tipo de Reporte datos de credito
IF (Par_TipoReporte = Tipo_DatosCred) THEN
    SET Var_NumCredAnt := Entero_Cero;
    SET Var_MontoCredAnt := 0.0;
    SET Var_TipoPrestamo := Tipo_Individual;
    SELECT TasaFija, NumAmortizacion, ValorCAT, FrecuenciaCap, FrecuenciaInt, MontoCredito, PeriodicidadCap,
            FechaMinistrado, ProductoCreditoID,
            CASE WHEN TipoPagoCapital = Pag_Crecientes THEN Desc_Crecientes
            ELSE CASE WHEN TipoPagoCapital = Pag_Iguales THEN Desc_Iguales
            ELSE CASE WHEN TipoPagoCapital = Pag_Libres THEN Desc_Libres
            END	END END
	INTO 	Var_TasaAnual, Var_NumAmorti,
                        Var_CAT, Var_Frecuencia, Var_FrecuenciaInt,Var_MontoCred, Var_Periodo,
                        Var_FechaMinistrado, Var_ProductoCreditoID, Var_TipoPlan
    FROM CREDITOS
    WHERE CreditoID = Par_CreditoID;

    SELECT CreditoID, MontoCredito INTO Var_NumCredAnt, Var_MontoCredAnt
    FROM CREDITOS
    WHERE ClienteID = Par_ClienteID AND FechaMinistrado < Var_FechaMinistrado
    AND (GrupoID IS NULL OR GrupoID = 0) AND ProductoCreditoID = Var_ProductoCreditoID
    ORDER BY FechaMinistrado DESC LIMIT 1;

    SELECT  SUM(Amo.Interes) INTO Var_TotInteres
            FROM AMORTICREDITO Amo
            WHERE Amo.CreditoID = Par_CreditoID;

        SET Var_TotInteres  := IFNULL(Var_TotInteres, Entero_Cero);
        SET Var_TasaFlat := CASE
                                WHEN Var_Periodo = Entero_Cero THEN Entero_Cero
                                ELSE  ( ( (Var_TotInteres / Var_NumAmorti) / Var_MontoCred ) /
                                Var_Periodo ) * 30 * 100
                            END;
        SET Var_TasaFlat    := ROUND(Var_TasaFlat, 4);

 IF(Var_TipoPlan=Var_Libres OR Var_Frecuencia != Var_FrecuenciaInt) THEN
    SET Var_DesFrec = Frec_Mixto;
 ELSE
        SELECT  CASE
                WHEN Var_Frecuencia = Frec_Semanal		 	THEN 	Desc_Semanal
                WHEN Var_Frecuencia = Frec_Catorcenal		THEN  	Desc_Catorcenal
                WHEN Var_Frecuencia = Frec_Quincenal		THEN  	Desc_Quincenal
                WHEN Var_Frecuencia = Frec_Mensual			THEN  	Desc_Mensual
                WHEN Var_Frecuencia = Frec_Periodica		THEN 	Desc_Periodica
                WHEN Var_Frecuencia = Frec_Bimestral		THEN  	Desc_Bimestral
                WHEN Var_Frecuencia = Frec_Trimestral		THEN  	Desc_Trimestral
                WHEN Var_Frecuencia = Frec_Tetramestral		THEN  	Desc_Tetramestral
                WHEN Var_Frecuencia = Frec_Semestral		THEN 	Desc_Semestral
                WHEN Var_Frecuencia = Frec_Anual		 	THEN 	Desc_Anual
				WHEN Var_Frecuencia = Frec_Decenal		 	THEN 	Desc_Decenal

            END INTO Var_DesFrec;
 END IF;
        SET Var_NumAmort = Var_NumAmorti;

        SET Var_TipoCredito :=(SELECT TipoCredito
                            FROM CREDITOS
                                WHERE CreditoID = Par_CreditoID);


        IF(Var_TipoCredito != CredReestructura) THEN
            SELECT COUNT(CreditoID) INTO Var_NumCuotas
            FROM AMORTICREDITO Amo
            WHERE Amo.CreditoID = Par_CreditoID;
        ELSE
            SELECT COUNT(Amo.CreditoID) INTO Var_NumAmort
            FROM SOLICITUDCREDITO Sol
            INNER JOIN CREDITOS Cre
                ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
                AND Sol.Estatus= EstDesembolsada
                AND Sol.TipoCredito= CredReestructura
            INNER JOIN REESTRUCCREDITO Res
                ON Res.CreditoOrigenID = Cre.CreditoID
                AND Res.CreditoDestinoID = Cre.CreditoID
                AND Cre.TipoCredito = CredReestructura
            INNER JOIN AMORTICREDITO Amo
                ON Amo.CreditoID = Cre.CreditoID
            WHERE Amo.CreditoID = Par_CreditoID
            AND (Amo.FechaLiquida > Var_FechaRegistro
                OR Amo.FechaLiquida = Fecha_Vacia);
        END IF;

        SET Var_DescProdCre := (SELECT Descripcion FROM PRODUCTOSCREDITO WHERE ProducCreditoID =  Var_ProductoCreditoID );


        SELECT Var_NumCredAnt,	Var_MontoCredAnt,	Var_TipoPrestamo,	Var_TasaAnual,	Var_TasaFlat,
				Var_CAT,  		Var_TipoPlan,		Var_DesFrec,  		Var_NumAmort,	Var_NumCuotas,
                Var_DescProdCre;
END IF;


IF (Par_TipoReporte = Tipo_DatosGrupo) THEN

    SELECT NombreCompleto,
        CASE WHEN Estatus = Esta_Activo THEN Var_Activo
            WHEN Estatus= Esta_Inactivo THEN Var_Inactivo
            WHEN Estatus= Esta_Rechazado THEN Var_Rechazado END AS Estado
        FROM
            CLIENTES
        WHERE ClienteID = Par_ClienteID;

END IF;

IF(Par_TipoReporte = Lis_Integra) THEN
    SELECT  Cre. ClienteID,     Cte.NombreCompleto, Cre.MontoCredito
    FROM INTEGRAGRUPOSCRE Inte,
             CLIENTES  Cte,
             SOLICITUDCREDITO Sol,
             CREDITOS Cre
    WHERE Inte.GrupoID	= Par_GrupoID
    AND Cre.ClienteID = Sol.ClienteID
    AND Sol.ClienteID = Inte.ClienteID
    AND Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
    AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
    AND Cte.ClienteID = Cre.ClienteID
    AND Inte.Estatus = Esta_Activo;

END IF;

IF(Par_TipoReporte = Tipo_Amortizacion) THEN
    SET NumInstitucion  	:= (SELECT InstitucionID FROM PARAMETROSSIS);
	SELECT Direccion,		Nombre
	INTO DireccionInstitu,	NombreInstitu
    FROM INSTITUCIONES
    WHERE InstitucionID = NumInstitucion;

	SET Sucurs	:= (SELECT S.NombreSucurs
                    FROM USUARIOS U, SUCURSALES S
					WHERE	UsuarioID=1
                        AND U.SucursalUsuario= S.SucursalID);

	SET Var_EstatusCredito	:=(SELECT Estatus
                            FROM CREDITOS
                                WHERE CreditoID = Par_CreditoID);

    SET Var_TipoCredito :=(SELECT TipoCredito
                            FROM CREDITOS
                                WHERE CreditoID = Par_CreditoID);

    SET Var_EstatusSol	:=(SELECT Sol.Estatus
                            FROM SOLICITUDCREDITO  Sol
                            INNER JOIN CREDITOS Cre
                            ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
                            WHERE Cre.CreditoID = Par_CreditoID);

	SET Var_EstatusCredito	:=IFNULL(Var_EstatusCredito,Cadena_Vacia);
	SET Var_TipoCredito		:=IFNULL(Var_TipoCredito,Cadena_Vacia);
	SET Var_EstatusSol		:=IFNULL(Var_EstatusSol,Cadena_Vacia);

    SELECT MontoCredito INTO Var_MontoCred FROM CREDITOS WHERE CreditoID = Par_CreditoID;

    IF (Var_TipoCredito = CredReestructura AND Var_EstatusSol = EstDesembolsada)THEN
        SET @row=0;
        SELECT (@row:= @row+1) AS AmortizacionID,    Amo.FechaInicio,    Amo.FechaVencim,    Amo.FechaExigible,
            (Amo.Capital+Amo.Interes+Amo.IVAInteres+IFNULL(Amo.MontoOtrasComisiones,Entero_Cero)
            +IFNULL(Amo.MontoIVAOtrasComisiones,Entero_Cero)  + IFNULL(Amo.MontoIntOtrasComis, Entero_Cero) + IFNULL(Amo.MontoIVAIntComisi,Entero_Cero)) AS montoCuota,     Amo.Interes,    Amo.IVAInteres,
			Amo.Capital,	Amo.SaldoCapital, NombreInstitu,	DireccionInstitu,   Sucurs,
            Amo.MontoOtrasComisiones, Amo.MontoIVAOtrasComisiones, Var_MontoCred
            FROM SOLICITUDCREDITO Sol
            INNER JOIN CREDITOS Cre
                ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
                AND Sol.Estatus= EstDesembolsada
                AND Sol.TipoCredito= CredReestructura
            INNER JOIN REESTRUCCREDITO Res
                ON Res.CreditoOrigenID = Cre.CreditoID
                AND Res.CreditoDestinoID = Cre.CreditoID
                AND Cre.TipoCredito = CredReestructura
            INNER JOIN AMORTICREDITO Amo
                ON Amo.CreditoID = Cre.CreditoID
            WHERE Amo.CreditoID = Par_CreditoID
            AND (Amo.FechaLiquida > Var_FechaRegistro
                OR Amo.FechaLiquida = Fecha_Vacia);
    END IF;

    IF (Var_EstatusCredito = EstatusAutorizado OR Var_EstatusCredito = EstatusInactivo)THEN
		SELECT Amo.AmortizacionID,	    Amo.FechaInicio,    Amo.FechaVencim,    Amo.FechaExigible,
            (Amo.Capital+Amo.Interes+Amo.IVAInteres+IFNULL(Amo.MontoOtrasComisiones,Entero_Cero)
            +IFNULL(Amo.MontoIVAOtrasComisiones,Entero_Cero) + IFNULL(Amo.MontoIntOtrasComis, Entero_Cero) + IFNULL(Amo.MontoIVAIntComisi,Entero_Cero)) AS montoCuota,     Amo.Interes,    Amo.IVAInteres,
			Amo.Capital,	Amo.SaldoCapital, NombreInstitu,	DireccionInstitu,   Sucurs,
            Amo.MontoOtrasComisiones AS MontoOtrasComisiones, Amo.MontoIVAOtrasComisiones, Var_MontoCred
            FROM AMORTICREDITO Amo
                WHERE Amo.CreditoID = Par_CreditoID;
    END IF;

    IF (Var_TipoCredito != CredReestructura AND Var_EstatusCredito != EstatusAutorizado
        AND Var_EstatusCredito != EstatusInactivo)THEN
        SET Var_MontoCred = (SELECT SUM(Pag.Capital)
                        FROM PAGARECREDITO Pag
                WHERE Pag.CreditoID = Par_CreditoID);
        SELECT      MAX(Pag.AmortizacionID) AS AmortizacionID,      MAX(Pag.FechaInicio) as FechaInicio,    MAX(Pag.FechaVencim) as FechaVencim, MAX(Pag.FechaExigible) as FechaExigible,
            (MAX(Pag.Capital)+MAX(Pag.Interes)+MAX(Pag.IVAInteres)+IFNULL(SUM(Det.MontoCuota),Entero_Cero)+IFNULL(SUM(Det.MontoIVACuota),Entero_Cero)) AS montoCuota,     MAX(Pag.Interes) as Interes,    MAX(Pag.IVAInteres) as IVAInteres,
            MAX(Pag.Capital) AS Capital,(Var_MontoCred -(SELECT SUM(Pag2.Capital)
                FROM PAGARECREDITO Pag2
                WHERE Pag2.CreditoID = Par_CreditoID
                AND Pag2.AmortizacionID <= Pag.AmortizacionID
			)) AS SaldoCapital  ,NombreInstitu,	DireccionInstitu,   Sucurs,
            SUM(Det.MontoCuota) AS MontoOtrasComisiones, SUM(Det.MontoIVACuota) AS MontoIVAOtrasComisiones, Var_MontoCred
            FROM PAGARECREDITO Pag
            LEFT JOIN DETALLEACCESORIOS Det ON Det.CreditoID =Pag.CreditoID  AND Det.AmortizacionID=Pag.AmortizacionID
                WHERE Pag.CreditoID = Par_CreditoID
                GROUP BY Pag.AmortizacionID;
    END IF;

END IF;

IF(Par_TipoReporte = Lis_Integra) THEN
    SELECT  Cre. ClienteID,     Cte.NombreCompleto, Cre.MontoCredito
        FROM INTEGRAGRUPOSCRE Inte,
                 CLIENTES  Cte,
                 SOLICITUDCREDITO Sol,
                 CREDITOS Cre
        WHERE Inte.GrupoID	= Par_GrupoID
        AND Cre.ClienteID = Sol.ClienteID
        AND Sol.ClienteID = Inte.ClienteID
        AND Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
        AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
        AND Cte.ClienteID = Cre.ClienteID
        AND Inte.Estatus = Esta_Activo;

END IF;

IF(Par_TipoReporte = Tipo_Enca) THEN

    SELECT	P.NombrePromotor, S.NombreSucurs INTO Var_Promotor, Var_Sucursal
        FROM
				CLIENTES 	C,
				PROMOTORES 	P,
                SUCURSALES  S
            WHERE C.ClienteID= Par_ClienteID
            AND C.PromotorActual=P.PromotorID
            AND C.SucursalOrigen=S.SucursalID;

	SELECT R.RegistroReca,	C.FechaInicio
	INTO Registro_Reca,		Var_FecInicio
    FROM  CREDITOS C
        INNER JOIN PRODUCTOSCREDITO R
        WHERE  CreditoID=Par_CreditoID
            AND C.ProductoCreditoID=R.ProducCreditoID;

	SET Var_NombreDireccion	:=	(SELECT CONCAT(Ins.Nombre,", ",Ins.DirFiscal)  FROM INSTITUCIONES Ins
                                INNER JOIN PARAMETROSSIS Par ON Par.InstitucionID = Ins.InstitucionID LIMIT 1);


    IF  EXISTS(SELECT s.FolioCtrl
        FROM CREDITOS c
        INNER JOIN SOLICITUDCREDITO s ON s.SolicitudCreditoID = c.SolicitudCreditoID
        AND c.CreditoID =Par_CreditoID
        AND s.FolioCtrl <> Cadena_Vacia)THEN

        SET Var_FolioControl :=SiMostrar;
    ELSE
        SET Var_FolioControl :=NoMostrar;
    END IF;

	SET NombreInstitu	:=	(SELECT Nombre  FROM INSTITUCIONES Ins
                                INNER JOIN PARAMETROSSIS Par ON Par.InstitucionID = Ins.InstitucionID LIMIT 1);

    SELECT	Par_ClienteID,			Var_Promotor,		Var_Sucursal,	Registro_Reca,
			Var_NombreDireccion,	Var_FolioControl,	NombreInstitu AS Var_NombreInstitu,
            Var_FecInicio;

END IF;
IF(	Par_TipoReporte	=	Tipo_PlanPagos	)	THEN
    -- vaida si el credito es de restructuracion para poner los plazos

	SELECT	Par.InstitucionID,	Ins.Nombre,		Ins.Direccion, Ins.NombreCorto
	INTO	NumInstitucion,		NombreInstitu,	DireccionInstitu, NomCortoInstitu
	FROM		PARAMETROSSIS	Par
	INNER JOIN	INSTITUCIONES	Ins	ON	Ins.InstitucionID	=	Par.InstitucionID;
	SELECT	Suc.NombreSucurs,	Pro.NombrePromotor,
			CONCAT(	Cli.PrimerNombre,
					CASE	WHEN	IFNULL(Cli.SegundoNombre, Cadena_Vacia)	<>	Cadena_Vacia	THEN	CONCAT(' ',Cli.SegundoNombre)  -- CS JCENTENO TKT 13505
							ELSE	Cadena_Vacia
                    END,
					CASE	WHEN	IFNULL(Cli.TercerNombre, Cadena_Vacia)	<>	Cadena_Vacia	THEN	CONCAT(' ',Cli.TercerNombre)  -- CS JCENTENO TKT 13505
							ELSE	Cadena_Vacia
                    END
			),					Cli.ApellidoPaterno,		Cli.ApellidoMaterno
	INTO	Var_NomSuc,			Var_Promotor,
			Var_CliNombres,		Var_CliApPat,				Var_CliApMat
	FROM			CLIENTES	Cli
	LEFT OUTER JOIN	SUCURSALES	Suc	ON	Suc.SucursalID	=	Cli.SucursalOrigen
	LEFT OUTER JOIN	PROMOTORES 	Pro	ON	Pro.PromotorID	=	Cli.PromotorActual
	WHERE	Cli.ClienteID	=	Par_ClienteID;

	SELECT	Cre.FrecuenciaCap,		Cre.NumAmortizacion,	Cre.ValorCAT,			Cre.FechaMinistrado,	Cre.MontoCredito,
			Cre.TipoPagoCapital,	Cre.PeriodicidadCap,	Cre.ProductoCreditoID,	Cre.TasaFija,			Pro.Descripcion,
            CONCAT(IFNULL(Pro.GraciaFaltaPago,0), ' dia(s).') ,
            CASE
				WHEN Pro.Tipo = Cred_Comercial		 THEN Desc_Comercial
				WHEN Pro.Tipo = Cred_Consumo		 THEN Desc_Consumo
				WHEN Pro.Tipo = Cred_Hipotecario	 THEN Desc_Hipotecario
                ELSE Desc_NoAplica
									END,					Cre.FechaInicio
	INTO	Var_Frecuencia,			Var_NumAmort,			Var_CAT,				Var_FechaMinistrado,	Var_MontoCred,
			Var_TipoPlan,			Var_Periodo,			Var_ProductoCreditoID,	Var_TasaAnual,			Var_TipPrestamo,
			VGraciaFaltaPago, 		TipoProCre,				Var_FecInicio
	FROM		CREDITOS	Cre
	INNER JOIN	PRODUCTOSCREDITO	Pro	ON	Pro.ProducCreditoID	=	Cre.ProductoCreditoID
	WHERE	Cre.CreditoID	=	Par_CreditoID;



    SELECT  SUM(Amo.Interes)
	INTO	Var_TotInteres
	FROM	AMORTICREDITO Amo
	WHERE	Amo.CreditoID = Par_CreditoID;

	SELECT	Cre.CreditoID,		Cre.MontoCredito,	Cre.ProductoCreditoID
	INTO	Var_NumCredAnt,		Var_MontoCredAnt,	Var_ProdCredAnt
	FROM	CREDITOS Cre
	WHERE	Cre.ClienteID	=	Par_ClienteID
		AND Cre.FechaInicio	<	Var_FechaActual
		AND	Cre.CreditoID	!=	Par_CreditoID
        AND IFNULL(Cre.GrupoID,0) = 0
		AND Cre.Estatus		!=	'C'
    ORDER BY Cre.FechaInicio DESC, Cre.FechaActual DESC
    LIMIT 1;
    -- ----------------------------------------------------------------------------
    SET Var_TipoCredito := (SELECT TipoCredito  FROM CREDITOS WHERE CreditoID=Par_CreditoID);
    IF(Var_TipoCredito = CredReestructura) THEN
            SELECT COUNT(Amo.CreditoID) INTO Var_NumAmort
            FROM SOLICITUDCREDITO Sol
            INNER JOIN CREDITOS Cre
                ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
                AND Sol.Estatus= EstDesembolsada
                AND Sol.TipoCredito= CredReestructura
            INNER JOIN REESTRUCCREDITO Res
                ON Res.CreditoOrigenID = Cre.CreditoID
                AND Res.CreditoDestinoID = Cre.CreditoID
                AND Cre.TipoCredito = CredReestructura
            INNER JOIN AMORTICREDITO Amo
                ON Amo.CreditoID = Cre.CreditoID
            WHERE Amo.CreditoID = Par_CreditoID
            AND (Amo.FechaLiquida > Var_FechaRegistro
                OR Amo.FechaLiquida = Fecha_Vacia);
    END IF;
-- -----------------------------------------------------------------------------------
	SET	NombreInstitu	:=	IFNULL(NombreInstitu, Cadena_Vacia);
	SET	Var_NomSuc		:=	IFNULL(Var_NomSuc, Cadena_Vacia);
	SET	Var_FechaActTxt	:=	FORMATOFECHACOMPLETA(Var_FechaActual);
	SET	Var_Promotor	:=	IFNULL(Var_Promotor, Cadena_Vacia);
	SET	Var_DesFrec		:=	CASE
								WHEN Var_Frecuencia = Frec_Semanal		 	THEN 	Mayus_Semanal
				                WHEN Var_Frecuencia = Frec_Catorcenal		THEN  	Mayus_Catorcenal
				                WHEN Var_Frecuencia = Frec_Quincenal		THEN  	Mayus_Quincenal
				                WHEN Var_Frecuencia = Frec_Mensual			THEN  	Mayus_Mensual
				                WHEN Var_Frecuencia = Frec_Periodica		THEN 	Mayus_Periodica
				                WHEN Var_Frecuencia = Frec_Bimestral		THEN  	Mayus_Bimestral
				                WHEN Var_Frecuencia = Frec_Trimestral		THEN  	Mayus_Trimestral
				                WHEN Var_Frecuencia = Frec_Tetramestral		THEN  	Mayus_Tetramestral
				                WHEN Var_Frecuencia = Frec_Semestral		THEN 	Mayus_Semestral
				                WHEN Var_Frecuencia = Frec_Anual		 	THEN 	Mayus_Anual
								WHEN Var_Frecuencia = Frec_Decenal		 	THEN 	Mayus_Decenal
								WHEN Var_Frecuencia = Frec_Unico		 	THEN 	Mayus_Unico
                            END;

	SET	Var_Plazo		:=	CONCAT( CONVERT(Var_NumAmort, CHAR), ' ',
                                    CASE
										WHEN Var_Frecuencia = Frec_Semanal		 	THEN 	Perio_Semanal
						                WHEN Var_Frecuencia = Frec_Catorcenal		THEN  	Perio_Catorcenal
						                WHEN Var_Frecuencia = Frec_Quincenal		THEN  	Perio_Quincenal
						                WHEN Var_Frecuencia = Frec_Mensual			THEN  	Perio_Mensual
						                WHEN Var_Frecuencia = Frec_Periodica		THEN 	Perio_Periodica
						                WHEN Var_Frecuencia = Frec_Bimestral		THEN  	Perio_Bimestral
						                WHEN Var_Frecuencia = Frec_Trimestral		THEN  	Perio_Trimestral
						                WHEN Var_Frecuencia = Frec_Tetramestral		THEN  	Perio_Tetramestral
						                WHEN Var_Frecuencia = Frec_Semestral		THEN 	Perio_Semestral
						                WHEN Var_Frecuencia = Frec_Anual		 	THEN 	Perio_Anual
										WHEN Var_Frecuencia = Frec_Decenal		 	THEN 	Perio_Decenal
                                    END );
    IF(Var_Frecuencia = Frec_Unico OR Var_Frecuencia = Frec_Libre) THEN
		SET	Var_Plazo		:=	CONCAT( CONVERT(Var_Periodo, CHAR),' Días');
    END IF;

	SET Var_CAT				:=	IFNULL(Var_CAT,	Decimal_Cero);
	SET	Var_CliNombres		:=	IFNULL(Var_CliNombres,	Cadena_Vacia);
	SET	Var_CliApPat		:=	IFNULL(Var_CliApPat,	Cadena_Vacia);
	SET	Var_CliApMat		:=	IFNULL(Var_CliApMat,	Cadena_Vacia);
	SET	Var_NumCredAnt		:=	IFNULL(Var_NumCredAnt,	Entero_Cero);
	SET	Var_MontoCredAnt	:=	IFNULL(Var_MontoCredAnt, Decimal_Cero);
	SET	Var_ProdCredAnt		:=	IFNULL(Var_ProdCredAnt,	Entero_Cero);
	SET	Var_FechaMinistrado	:=	IFNULL(Var_FechaMinistrado, Cadena_Vacia);
	SET	Var_MontoCred		:=	IFNULL(Var_MontoCred,	Decimal_Cero);
	SET	Var_TipPrestamo		:=	IFNULL(Var_TipPrestamo,	Cadena_Vacia);
	SET	Var_TasaAnual		:=	IFNULL(Var_TasaAnual,	Decimal_Cero);
	SET	Var_TipoPlan		:=	CASE	Var_TipoPlan
										WHEN	Pag_Crecientes	THEN	Desc_Crecientes
										WHEN	Pag_Iguales 	THEN	Desc_Iguales
										WHEN	Pag_Libres 		THEN	Desc_Libres
                                END;
	SET	Var_Periodo			:=	IFNULL(Var_Periodo, Entero_Cero);
	SET	Var_NumAmort		:=	IFNULL(Var_NumAmort, Entero_Cero);

	SET Var_TotInteres		:= 	IFNULL(Var_TotInteres, Entero_Cero);
    SET Var_TasaFlat    :=  ( ( (Var_TotInteres / IFNULL(Var_NumAmort, 0)) / IFNULL(Var_MontoCred,0 )) / NULLIF(Var_Periodo, 0) ) * 30 * 100;

    SET Var_TipoCredito :=(SELECT TipoCredito
                            FROM CREDITOS
                                WHERE CreditoID = Par_CreditoID);
    -- agregado  Ticket  15304
    SELECT
        RegistroRECA INTO Var_numRECA
    FROM  PRODUCTOSCREDITO Pro, CREDITOS Cre
    WHERE ProducCreditoID = Cre.ProductoCreditoID
    AND   Cre.CreditoID = Par_CreditoID;

    SELECT
        MontoComApert INTO Var_Comision
    FROM CREDITOS
    WHERE CreditoID = Par_CreditoID;

    SET Var_Comision := IFNULL(Var_Comision, Decimal_Cero);
    -- fin agregado

	SELECT	NombreInstitu,	Var_NomSuc,			Var_FechaActTxt,	Var_FechaActual,		Var_Promotor,			Var_DesFrec,
			Var_Plazo,		ROUND(Var_CAT,2) AS Var_CAT,			Var_CliNombres,		Var_CliApPat,			Var_CliApMat,
			Var_NumCredAnt,	Var_MontoCredAnt,	Var_ProdCredAnt,	Var_FechaMinistrado,	Var_MontoCred,
			Var_TipoPlan,	Var_Periodo,		Var_NumAmort,		ROUND(Var_TasaAnual,2) AS Var_TasaAnual,	ROUND(Var_TasaFlat, 2)	AS	Var_TasaFlat,
			Var_TipPrestamo,VGraciaFaltaPago,	NomCortoInstitu,	TipoProCre,				Var_FecInicio,	Var_TipoCredito, Var_numRECA, Var_Comision
    ;
END IF;
-- Seccion Alternativa 19
IF( Par_TipoReporte =   Tipo_Alternativa )   THEN
    SET Var_SucursalCred := (SELECT SucursalID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
    -- Datos del Banco
    SELECT CA.SucursalInstit, CA.NumCtaInstit, CA.CueClave
	INTO 	Var_NombreBanco,	Var_NumeroCuenta,	Var_Clabe
    FROM SUCURSALES SU
    INNER JOIN CENTROCOSTOS CC ON SU.CentroCostoID = CC.CentroCostoID
    INNER JOIN CUENTASAHOTESO CA ON CC.CentroCostoID = CA.CentroCostoID
    WHERE SucursalID = Var_SucursalCred
    ORDER BY SucursalID
    LIMIT 1;

    SELECT  Par.InstitucionID,  Ins.Nombre,     Ins.DirFiscal, Ins.NombreCorto
    INTO    NumInstitucion,     NombreInstitu,  DireccionInstitu, NomCortoInstitu
    FROM        PARAMETROSSIS   Par
    INNER JOIN  INSTITUCIONES   Ins ON  Ins.InstitucionID   =   Par.InstitucionID;
    SELECT  Suc.NombreSucurs,   Cli.NombreCompleto
    INTO    Var_NomSuc,         Var_CliNombres
    FROM            CLIENTES    Cli
    LEFT OUTER JOIN SUCURSALES  Suc ON  Suc.SucursalID  =   Cli.SucursalOrigen
    LEFT OUTER JOIN PROMOTORES  Pro ON  Pro.PromotorID  =   Cli.PromotorActual
    WHERE   Cli.ClienteID   =   Par_ClienteID;

    SELECT IFNULL(PeriodicidadCap,Entero_Cero), IFNULL(PeriodicidadInt,Entero_Cero),
                IFNULL(FrecuenciaCap, Cadena_Vacia), IFNULL(FrecuenciaInt, Cadena_Vacia)
        INTO Var_PeriodCap, Var_PeriodInt, Var_FrecCapital, Var_FrecInteres
        FROM CREDITOS
        WHERE CreditoID =Par_CreditoID;

        IF(Var_PeriodCap <= Var_PeriodInt) THEN
            SET Var_Frecuencia := Var_FrecCapital;
            ELSE
            SET Var_Frecuencia := Var_FrecInteres;
            END IF;

        SELECT
            CASE
                WHEN Var_Frecuencia = Frec_Semanal   THEN Mayus_Semanal
                WHEN Var_Frecuencia =Frec_Catorcenal   THEN Mayus_Catorcenal
                WHEN Var_Frecuencia =Frec_Quincenal  THEN Mayus_Quincenal
                WHEN Var_Frecuencia =Frec_Mensual    THEN Mayus_Mensual
                WHEN Var_Frecuencia =Frec_Periodica  THEN Mayus_Periodica
                WHEN Var_Frecuencia =Frec_Bimestral  THEN Mayus_Bimestral
                WHEN Var_Frecuencia =Frec_Trimestral   THEN Mayus_Trimestral
                WHEN Var_Frecuencia =Frec_Tetramestral THEN Mayus_Tetramestral
                WHEN Var_Frecuencia =Frec_Semestral  THEN Mayus_Tetramestral
                WHEN Var_Frecuencia =Frec_Anual    THEN Mayus_Anual
                WHEN Var_Frecuencia =Frec_Decenal    THEN Mayus_Decenal
                ELSE Cadena_Vacia
            END
            INTO Var_FrecuenciaTxt
            FROM CREDITOS
           WHERE CreditoID = Par_CreditoID;

	SELECT 	Pro.Descripcion, 		Pro.Caracteristicas,	Cre.TipoCredito,  		Pro.RegistroRECA,   Cre.TasaFija,
			Cre.NumAmortizacion, 	Pc.Descripcion, 		Cre.PeriodicidadCap, 	Cre.MontoCredito, ProducCreditoID
		INTO	Var_DescProdCre,  	Var_CarProdCred, 		Var_TipoCredito, 		Registro_Reca,		Var_TasaAnual,
				Var_NumAmorti,		Var_Plazo, 				Var_Periodo, 			Var_MontoCred,		Var_ProductoCredito
    FROM        CREDITOS    Cre
    INNER JOIN  PRODUCTOSCREDITO    Pro ON  Pro.ProducCreditoID =   Cre.ProductoCreditoID
    INNER JOIN CREDITOSPLAZOS Pc ON Pc.PlazoID = Cre.PlazoID
    WHERE   Cre.CreditoID   =   Par_CreditoID;



    SET NombreInstitu   		:=  IFNULL(NombreInstitu, Cadena_Vacia);
    SET Var_NomSuc      		:=  IFNULL(Var_NomSuc, Cadena_Vacia);
    SET DireccionInstitu 		:= IFNULL(DireccionInstitu, Cadena_Vacia);
    SET Var_CliNombres      	:=  IFNULL(Var_CliNombres,  Cadena_Vacia);
    SET Var_DescProdCre      	:=  IFNULL(Var_DescProdCre,  Cadena_Vacia);
    SET Var_CarProdCred      	:=  IFNULL(Var_CarProdCred,  Cadena_Vacia);
    SET Var_TipoCredito        	:=  IFNULL(Var_TipoCredito,    Cadena_Vacia);
    SET Registro_Reca        	:=  IFNULL(Registro_Reca,    Cadena_Vacia);
    SET Var_TasaAnual        	:=  IFNULL(Var_TasaAnual,    Cadena_Vacia);
    SET Var_NumAmorti        	:=  IFNULL(Var_NumAmorti,    Cadena_Vacia);
    SET Var_Plazo        		:=  IFNULL(Var_Plazo,    Cadena_Vacia);
    SET Var_Periodo         	:= IFNULL(Var_Periodo,  Cadena_Vacia);
    SET Var_NombreBanco			:=	IFNULL(Var_NombreBanco, Cadena_Vacia);
    SET Var_NumeroCuenta		:=	IFNULL(Var_NumeroCuenta, Cadena_Vacia);
    SET Var_Clabe				:=	IFNULL(Var_Clabe, Cadena_Vacia);
    SET Var_MontoCred			:=	IFNULL(Var_MontoCred, Decimal_Cero);
	SET Var_ProductoCredito		:=	IFNULL(Var_ProductoCredito, Decimal_Cero);

    SELECT  NombreInstitu,  		Var_NomSuc,  	 	 DireccionInstitu,   	Var_CliNombres,		 Var_DescProdCre,
			Var_CarProdCred,        Var_TipoCredito,   	 Registro_Reca,   		CONCAT(ROUND(Var_TasaAnual , 2), ' %' ) AS Var_TasaAnual,
            Var_NumAmorti,  		Var_Plazo,  		 Var_Periodo, 	 		Var_NombreBanco,	  Var_NumeroCuenta,
            Var_Clabe, 				Var_MontoCred,		 Var_ProductoCredito,	Var_FrecuenciaTxt;

END IF;

IF(Par_TipoReporte = Tipo_AmortizaAlternativa) THEN
    SET NumInstitucion      := (SELECT InstitucionID FROM PARAMETROSSIS);
    SELECT Direccion,       Nombre
    INTO DireccionInstitu,  NombreInstitu
    FROM INSTITUCIONES
    WHERE InstitucionID = NumInstitucion;

    SET Sucurs  := (SELECT S.NombreSucurs
                    FROM USUARIOS U, SUCURSALES S
                    WHERE   UsuarioID=1
                        AND U.SucursalUsuario= S.SucursalID);

    SET Var_EstatusCredito  :=(SELECT Estatus
                            FROM CREDITOS
                                WHERE CreditoID = Par_CreditoID);

    SET Var_TipoCredito :=(SELECT TipoCredito
                            FROM CREDITOS
                                WHERE CreditoID = Par_CreditoID);

    SET Var_EstatusSol  :=(SELECT Sol.Estatus
                            FROM SOLICITUDCREDITO  Sol
                            INNER JOIN CREDITOS Cre
                            ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
                            WHERE Cre.CreditoID = Par_CreditoID);

    SET Var_EstatusCredito  :=IFNULL(Var_EstatusCredito,Cadena_Vacia);
    SET Var_TipoCredito     :=IFNULL(Var_TipoCredito,Cadena_Vacia);
    SET Var_EstatusSol      :=IFNULL(Var_EstatusSol,Cadena_Vacia);

    SET Var_MontoSeguro		:=IFNULL(Var_MontoSeguro, Decimal_Cero);
    IF (Var_TipoCredito = CredReestructura AND Var_EstatusSol = EstDesembolsada)THEN
        SET @row=0;
        SELECT (@row:= @row+1) AS AmortizacionID,    Amo.FechaInicio,    Amo.FechaVencim,    Amo.FechaExigible,
            CONCAT('$ ', FORMAT((Amo.Capital+Amo.Interes+Amo.IVAInteres+IFNULL(Amo.MontoOtrasComisiones,Entero_Cero)
            +IFNULL(Amo.MontoIVAOtrasComisiones,Entero_Cero) + IFNULL(Amo.MontoIntOtrasComis, Entero_Cero) + IFNULL(Amo.MontoIVAIntComisi,Entero_Cero)),2)) AS montoCuota,
            CONCAT('$ ', FORMAT(Amo.Interes,2)) AS Interes,
            CONCAT('$ ', FORMAT(Amo.IVAInteres,2)) AS IVAInteres,
            CONCAT('$ ',FORMAT(Amo.Capital,2)) AS Capital,
            CONCAT('$ ', FORMAT(Amo.SaldoCapital,2)) AS SaldoCapital,
            NombreInstitu,    DireccionInstitu,   Sucurs,
            CONCAT('$ ', FORMAT(Var_MontoSeguro,2)) AS Var_MontoSeguro
            FROM SOLICITUDCREDITO Sol
            INNER JOIN CREDITOS Cre
                ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
                AND Sol.Estatus= EstDesembolsada
                AND Sol.TipoCredito= CredReestructura
            INNER JOIN REESTRUCCREDITO Res
                ON Res.CreditoOrigenID = Cre.CreditoID
                AND Res.CreditoDestinoID = Cre.CreditoID
                AND Cre.TipoCredito = CredReestructura
            INNER JOIN AMORTICREDITO Amo
                ON Amo.CreditoID = Cre.CreditoID
            WHERE Amo.CreditoID = Par_CreditoID
            AND (Amo.FechaLiquida > Var_FechaRegistro
                OR Amo.FechaLiquida = Fecha_Vacia);
    END IF;
    IF (Var_EstatusCredito = EstatusAutorizado OR Var_EstatusCredito = EstatusInactivo)THEN
       SELECT Amo.AmortizacionID,      Amo.FechaInicio,    Amo.FechaVencim,    Amo.FechaExigible,
            CONCAT('$ ',FORMAT((Amo.Capital+Amo.Interes+Amo.IVAInteres+IFNULL(Amo.MontoOtrasComisiones,Entero_Cero)
            +IFNULL(Amo.MontoIVAOtrasComisiones,Entero_Cero) + IFNULL(Amo.MontoIntOtrasComis, Entero_Cero) + IFNULL(Amo.MontoIVAIntComisi,Entero_Cero)),2)) AS montoCuota,
            CONCAT('$ ', FORMAT(Amo.Interes,2)) AS Interes,
            CONCAT('$ ', FORMAT(Amo.IVAInteres,2)) AS IVAInteres,
            CONCAT('$ ', FORMAT(Amo.Capital,2)) AS Capital,
            CONCAT('$ ', FORMAT(Amo.SaldoCapital,2)) AS SaldoCapital,
            NombreInstitu,    DireccionInstitu,   Sucurs,
            CONCAT('$ ', FORMAT(Var_MontoSeguro,2)) AS Var_MontoSeguro
            FROM AMORTICREDITO Amo
                WHERE Amo.CreditoID = Par_CreditoID;
    END IF;

    IF (Var_TipoCredito != CredReestructura AND Var_EstatusCredito != EstatusAutorizado
        AND Var_EstatusCredito != EstatusInactivo)THEN
        SET Var_MontoCred = (SELECT SUM(Pag.Capital)
                        FROM PAGARECREDITO Pag
                WHERE Pag.CreditoID = Par_CreditoID);
        SELECT  Pag.AmortizacionID,     Pag.FechaInicio,    Pag.FechaVencim,    Pag.FechaExigible,
            CONCAT('$ ', FORMAT((Pag.Capital+Pag.Interes+Pag.IVAInteres),2)) AS montoCuota,
            CONCAT('$ ', FORMAT(Pag.Interes,2)) AS Interes,
            CONCAT('$ ',FORMAT(Pag.IVAInteres,2)) AS IVAInteres,
            CONCAT('$ ', FORMAT(Pag.Capital,2)) AS Capital,
            CONCAT('$ ', FORMAT((Var_MontoCred -(SELECT SUM(Pag2.Capital)
                FROM PAGARECREDITO Pag2
                WHERE Pag2.CreditoID = Par_CreditoID
                AND Pag2.AmortizacionID <= Pag.AmortizacionID
            )),2)) AS SaldoCapital  ,NombreInstitu, DireccionInstitu,   Sucurs,
            CONCAT('$ ', FORMAT(Var_MontoSeguro,2)) AS Var_MontoSeguro
            FROM PAGARECREDITO Pag
                WHERE Pag.CreditoID = Par_CreditoID;
    END IF;

END IF;

IF(Par_TipoReporte = Tipo_AmortizacionZafy) THEN

    SELECT NombreCompleto INTO Var_NombreCliente
    FROM CLIENTES
    WHERE ClienteID = Par_ClienteID;

	SELECT MontoSeguroCuota,	IVASeguroCuota, FechaMinistrado
	 INTO Var_MontoSeguroCuota,	Var_IVASeguroCuota, Var_FechaMinistrado
     FROM CREDITOS
     WHERE CreditoID = Par_CreditoID;

	SET Var_EstatusCredito	:=(SELECT Estatus
                                FROM CREDITOS
                                WHERE CreditoID = Par_CreditoID);

    SET Var_TipoCredito :=(SELECT TipoCredito
                                FROM CREDITOS
                                WHERE CreditoID = Par_CreditoID);

	SET Var_EstatusSol	:=(SELECT Sol.Estatus
                            FROM SOLICITUDCREDITO Sol
                            INNER JOIN CREDITOS Cre
                            ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
                            WHERE Cre.CreditoID = Par_CreditoID);

	SET Var_EstatusCredito	:=IFNULL(Var_EstatusCredito,Cadena_Vacia);
	SET Var_TipoCredito		:=IFNULL(Var_TipoCredito,Cadena_Vacia);
	SET Var_EstatusSol		:=IFNULL(Var_EstatusSol,Cadena_Vacia);
	SET Var_NombreCliente	:=IFNULL(Var_NombreCliente,Cadena_Vacia);
    SET Var_MontoSeguroCuota:=IFNULL(Var_MontoSeguroCuota,Decimal_Cero);
	SET Var_IVASeguroCuota	:=IFNULL(Var_IVASeguroCuota,Decimal_Cero);

    IF (Var_TipoCredito = CredReestructura AND Var_EstatusSol = EstDesembolsada)THEN
        SET @ROW=0;
        SELECT (@ROW:= @ROW+1) AS AmortizacionID, DATE_FORMAT(Amo.FechaExigible, '%d/%m/%Y') AS FechaExigible,
            (Amo.Capital+Amo.Interes+Amo.IVAInteres+Amo.SaldoComFaltaPa+
            Amo.SaldoIVAComFalP+ Var_MontoSeguroCuota+ Var_IVASeguroCuota
            +IFNULL(Amo.MontoOtrasComisiones,Entero_Cero)
            +IFNULL(Amo.MontoIVAOtrasComisiones,Entero_Cero) + IFNULL(Amo.MontoIntOtrasComis, Entero_Cero) + IFNULL(Amo.MontoIVAIntComisi,Entero_Cero)) AS montoCuota, Amo.Interes, Amo.IVAInteres,
			Amo.SaldoComFaltaPa, Amo.SaldoIVAComFalP, Var_MontoSeguroCuota,	Var_IVASeguroCuota,
			Amo.Capital,	Amo.SaldoCapital, Var_NombreCliente, DATE_FORMAT(Var_FechaMinistrado, '%d/%m/%Y') AS Var_FechaMinistrado
            FROM SOLICITUDCREDITO Sol
            INNER JOIN CREDITOS Cre
                ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
                AND Sol.Estatus= EstDesembolsada
                AND Sol.TipoCredito= CredReestructura
            INNER JOIN REESTRUCCREDITO Res
                ON Res.CreditoOrigenID = Cre.CreditoID
                AND Res.CreditoDestinoID = Cre.CreditoID
                AND Cre.TipoCredito = CredReestructura
            INNER JOIN AMORTICREDITO Amo
                ON Amo.CreditoID = Cre.CreditoID
            WHERE Amo.CreditoID = Par_CreditoID
                AND (Amo.FechaLiquida > Var_FechaRegistro
                OR Amo.FechaLiquida = Fecha_Vacia);
    END IF;

    IF (Var_EstatusCredito = EstatusAutorizado OR Var_EstatusCredito = EstatusInactivo)THEN
		SELECT Amo.AmortizacionID,	 DATE_FORMAT(Amo.FechaExigible, '%d/%m/%Y') AS FechaExigible,
            (Amo.Capital+Amo.Interes+Amo.IVAInteres+Amo.SaldoComFaltaPa+
            Amo.SaldoIVAComFalP+ Var_MontoSeguroCuota+ Var_IVASeguroCuota
            +IFNULL(Amo.MontoOtrasComisiones,Entero_Cero)
            +IFNULL(Amo.MontoIVAOtrasComisiones,Entero_Cero)) AS montoCuota, Amo.Interes, Amo.IVAInteres,
			Amo.SaldoComFaltaPa, Amo.SaldoIVAComFalP, Var_MontoSeguroCuota,	Var_IVASeguroCuota,
			Amo.Capital,	Amo.SaldoCapital, Var_NombreCliente, Cadena_Vacia AS Var_FechaMinistrado
            FROM AMORTICREDITO Amo
                WHERE Amo.CreditoID = Par_CreditoID;
    END IF;

    IF (Var_TipoCredito != CredReestructura AND Var_EstatusCredito != EstatusAutorizado
        AND Var_EstatusCredito != EstatusInactivo)THEN
            SET Var_MontoCred = (SELECT SUM(Pag.Capital)
                                    FROM PAGARECREDITO Pag
                                    WHERE Pag.CreditoID = Par_CreditoID);
		SELECT	Pag.AmortizacionID,	 DATE_FORMAT(Pag.FechaExigible, '%d/%m/%Y') AS FechaExigible,
            (Pag.Capital+Pag.Interes+Pag.IVAInteres+Decimal_Cero+Decimal_Cero+
            Var_MontoSeguroCuota+ Var_IVASeguroCuota) AS montoCuota, Pag.Interes, Pag.IVAInteres,
            Decimal_Cero AS SaldoComFaltaPa, Decimal_Cero AS SaldoIVAComFalP,
            Var_MontoSeguroCuota, Var_IVASeguroCuota,
            Pag.Capital,(Var_MontoCred -(SELECT SUM(Pag2.Capital)
                FROM PAGARECREDITO Pag2
                WHERE Pag2.CreditoID = Par_CreditoID
                AND Pag2.AmortizacionID <= Pag.AmortizacionID
            )) AS SaldoCapital , Var_NombreCliente, DATE_FORMAT(Var_FechaMinistrado, '%d/%m/%Y') AS Var_FechaMinistrado
            FROM PAGARECREDITO Pag
                WHERE Pag.CreditoID = Par_CreditoID;
    END IF;

END IF;

IF(	Par_TipoReporte	=	Tipo_AmortAsefimex	)	THEN
    -- vaida si el credito es de restructuracion para poner los plazos

	SELECT	Par.InstitucionID,	Ins.Nombre,		Ins.Direccion, Ins.NombreCorto
	INTO	NumInstitucion,		NombreInstitu,	DireccionInstitu, NomCortoInstitu
	FROM		PARAMETROSSIS	Par
	INNER JOIN	INSTITUCIONES	Ins	ON	Ins.InstitucionID	=	Par.InstitucionID;
	SELECT	Suc.NombreSucurs,	Pro.NombrePromotor,
			CONCAT(	Cli.PrimerNombre,
					CASE	WHEN	IFNULL(Cli.SegundoNombre, Cadena_Vacia)	<>	Cadena_Vacia	THEN	Cli.SegundoNombre
							ELSE	Cadena_Vacia
                    END,
					CASE	WHEN	IFNULL(Cli.TercerNombre, Cadena_Vacia)	<>	Cadena_Vacia	THEN	Cli.TercerNombre
							ELSE	Cadena_Vacia
                    END
			),					Cli.ApellidoPaterno,		Cli.ApellidoMaterno
	INTO	Var_NomSuc,			Var_Promotor,
			Var_CliNombres,		Var_CliApPat,				Var_CliApMat
	FROM			CLIENTES	Cli
	LEFT OUTER JOIN	SUCURSALES	Suc	ON	Suc.SucursalID	=	Cli.SucursalOrigen
	LEFT OUTER JOIN	PROMOTORES 	Pro	ON	Pro.PromotorID	=	Cli.PromotorActual
	WHERE	Cli.ClienteID	=	Par_ClienteID;

	SELECT	Cre.FrecuenciaCap,		Cre.NumAmortizacion,	Cre.ValorCAT,			Cre.FechaMinistrado,	Cre.MontoCredito,
			Cre.TipoPagoCapital,	Cre.PeriodicidadCap,	Cre.ProductoCreditoID,	Cre.TasaFija,			Pro.Descripcion,
            CONCAT(IFNULL(Pro.GraciaFaltaPago,0), ' dia(s).') ,
            CASE
				WHEN Pro.Tipo = Cred_Comercial		 THEN Desc_Comercial
				WHEN Pro.Tipo = Cred_Consumo		 THEN Desc_Consumo
				WHEN Pro.Tipo = Cred_Hipotecario	 THEN Desc_Hipotecario
                ELSE Desc_NoAplica
									END,					Cre.FechaInicio
	INTO	Var_Frecuencia,			Var_NumAmort,			Var_CAT,				Var_FechaMinistrado,	Var_MontoCred,
			Var_TipoPlan,			Var_Periodo,			Var_ProductoCreditoID,	Var_TasaAnual,			Var_TipPrestamo,
			VGraciaFaltaPago, 		TipoProCre,				Var_FecInicio
	FROM		CREDITOS	Cre
	INNER JOIN	PRODUCTOSCREDITO	Pro	ON	Pro.ProducCreditoID	=	Cre.ProductoCreditoID
	WHERE	Cre.CreditoID	=	Par_CreditoID;



    SELECT  SUM(Amo.Interes)
	INTO	Var_TotInteres
	FROM	AMORTICREDITO Amo
	WHERE	Amo.CreditoID = Par_CreditoID;

	SELECT	Cre.CreditoID,		Cre.MontoCredito,	Cre.ProductoCreditoID
	INTO	Var_NumCredAnt,		Var_MontoCredAnt,	Var_ProdCredAnt
	FROM	CREDITOS Cre
	WHERE	Cre.ClienteID	=	Par_ClienteID
		AND Cre.FechaInicio	<	Var_FechaActual
		AND	Cre.CreditoID	!=	Par_CreditoID
        AND IFNULL(Cre.GrupoID,0) = 0
		AND Cre.Estatus		!=	'C'
    ORDER BY Cre.FechaInicio DESC, Cre.FechaActual DESC
    LIMIT 1;
    -- ----------------------------------------------------------------------------
    SET Var_TipoCredito := (SELECT TipoCredito  FROM CREDITOS WHERE CreditoID=Par_CreditoID);
    IF(Var_TipoCredito = CredReestructura) THEN
            SELECT COUNT(Amo.CreditoID) INTO Var_NumAmort
            FROM SOLICITUDCREDITO Sol
            INNER JOIN CREDITOS Cre
                ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
                AND Sol.Estatus= EstDesembolsada
                AND Sol.TipoCredito= CredReestructura
            INNER JOIN REESTRUCCREDITO Res
                ON Res.CreditoOrigenID = Cre.CreditoID
                AND Res.CreditoDestinoID = Cre.CreditoID
                AND Cre.TipoCredito = CredReestructura
            INNER JOIN AMORTICREDITO Amo
                ON Amo.CreditoID = Cre.CreditoID
            WHERE Amo.CreditoID = Par_CreditoID
            AND (Amo.FechaLiquida > Var_FechaRegistro
                OR Amo.FechaLiquida = Fecha_Vacia);
    END IF;
-- -----------------------------------------------------------------------------------
	SET	NombreInstitu	:=	IFNULL(NombreInstitu, Cadena_Vacia);
	SET	Var_NomSuc		:=	IFNULL(Var_NomSuc, Cadena_Vacia);
	SET	Var_FechaActTxt	:=	FORMATOFECHACOMPLETA(Var_FechaActual);
	SET	Var_Promotor	:=	IFNULL(Var_Promotor, Cadena_Vacia);
	SET	Var_DesFrec		:=	CASE
								WHEN Var_Frecuencia = Frec_Semanal		 	THEN 	Mayus_Semanal
				                WHEN Var_Frecuencia = Frec_Catorcenal		THEN  	Mayus_Catorcenal
				                WHEN Var_Frecuencia = Frec_Quincenal		THEN  	Mayus_Quincenal
				                WHEN Var_Frecuencia = Frec_Mensual			THEN  	Mayus_Mensual
				                WHEN Var_Frecuencia = Frec_Periodica		THEN 	Mayus_Periodica
				                WHEN Var_Frecuencia = Frec_Bimestral		THEN  	Mayus_Bimestral
				                WHEN Var_Frecuencia = Frec_Trimestral		THEN  	Mayus_Trimestral
				                WHEN Var_Frecuencia = Frec_Tetramestral		THEN  	Mayus_Tetramestral
				                WHEN Var_Frecuencia = Frec_Semestral		THEN 	Mayus_Semestral
				                WHEN Var_Frecuencia = Frec_Anual		 	THEN 	Mayus_Anual
								WHEN Var_Frecuencia = Frec_Decenal		 	THEN 	Mayus_Decenal
								WHEN Var_Frecuencia = Frec_Unico		 	THEN 	Mayus_Unico
                            END;

	SET	Var_Plazo		:=	CONCAT( CONVERT(Var_NumAmort, CHAR), ' ',
                                    CASE
										WHEN Var_Frecuencia = Frec_Semanal		 	THEN 	Perio_Semanal
						                WHEN Var_Frecuencia = Frec_Catorcenal		THEN  	Perio_Catorcenal
						                WHEN Var_Frecuencia = Frec_Quincenal		THEN  	Perio_Quincenal
						                WHEN Var_Frecuencia = Frec_Mensual			THEN  	Perio_Mensual
						                WHEN Var_Frecuencia = Frec_Periodica		THEN 	Perio_Periodica
						                WHEN Var_Frecuencia = Frec_Bimestral		THEN  	Perio_Bimestral
						                WHEN Var_Frecuencia = Frec_Trimestral		THEN  	Perio_Trimestral
						                WHEN Var_Frecuencia = Frec_Tetramestral		THEN  	Perio_Tetramestral
						                WHEN Var_Frecuencia = Frec_Semestral		THEN 	Perio_Semestral
						                WHEN Var_Frecuencia = Frec_Anual		 	THEN 	Perio_Anual
										WHEN Var_Frecuencia = Frec_Decenal		 	THEN 	Perio_Decenal
                                    END );
    IF(Var_Frecuencia = Frec_Unico) THEN
		SET	Var_Plazo		:=	CONCAT( CONVERT(Var_Periodo, CHAR),' Días');
    END IF;

	SET Var_CAT				:=	IFNULL(Var_CAT,	Decimal_Cero);
	SET	Var_CliNombres		:=	IFNULL(Var_CliNombres,	Cadena_Vacia);
	SET	Var_CliApPat		:=	IFNULL(Var_CliApPat,	Cadena_Vacia);
	SET	Var_CliApMat		:=	IFNULL(Var_CliApMat,	Cadena_Vacia);
	SET	Var_NumCredAnt		:=	IFNULL(Var_NumCredAnt,	Entero_Cero);
	SET	Var_MontoCredAnt	:=	IFNULL(Var_MontoCredAnt, Decimal_Cero);
	SET	Var_ProdCredAnt		:=	IFNULL(Var_ProdCredAnt,	Entero_Cero);
	SET	Var_FechaMinistrado	:=	IFNULL(Var_FechaMinistrado, Cadena_Vacia);
	SET	Var_MontoCred		:=	IFNULL(Var_MontoCred,	Decimal_Cero);
	SET	Var_TipPrestamo		:=	IFNULL(Var_TipPrestamo,	Cadena_Vacia);
	SET	Var_TasaAnual		:=	IFNULL(Var_TasaAnual,	Decimal_Cero);
	SET	Var_TipoPlan		:=	CASE	Var_TipoPlan
										WHEN	Pag_Crecientes	THEN	Desc_Crecientes
										WHEN	Pag_Iguales 	THEN	Desc_Iguales
										WHEN	Pag_Libres 		THEN	Desc_Libres
                                END;
	SET	Var_Periodo			:=	IFNULL(Var_Periodo, Entero_Cero);
	SET	Var_NumAmort		:=	IFNULL(Var_NumAmort, Entero_Cero);

	SET Var_TotInteres		:= 	IFNULL(Var_TotInteres, Entero_Cero);

    SET Var_TipoCredito :=(SELECT TipoCredito
                            FROM CREDITOS
                                WHERE CreditoID = Par_CreditoID);

    SELECT DATE_FORMAT(C.FechaNacimiento,"%d%m%y") AS FechaNacimiento, D.EstadoID, D.MunicipioID
            INTO Var_FechaNacimiento, Var_EstadoID, Var_MunicipioID
        FROM CLIENTES C
        INNER JOIN DIRECCLIENTE D ON C.ClienteID = D.ClienteID
            WHERE C.ClienteID= Par_ClienteID AND D.Oficial = Cons_Si;

    SELECT DepositosMax INTO Var_AhorroMenssual
        FROM PLDPERFILTRANS
            WHERE ClienteID = Par_ClienteID;

    SELECT ValorParametro
        INTO Var_ImgOXXO
        FROM PARAMGENERALES
        WHERE LlaveParametro = LlaveImgOXXO;

    SELECT ValorParametro
        INTO Var_ImgTelecomm
        FROM PARAMGENERALES
        WHERE LlaveParametro = LlaveImgTelecomm;

   SELECT ValorParametro
        INTO Var_InstBANORTE
        FROM PARAMGENERALES
        WHERE LlaveParametro = LlaveInstBANORTE;

    SELECT ValorParametro
        INTO Var_InstTELECOM
        FROM PARAMGENERALES
        WHERE LlaveParametro = LlaveInstTELECOM;

    SELECT CLI.TipoPersona, CRE.SucursalID
        INTO Var_TipoPersona,  Var_Sucursal
        FROM CREDITOS CRE
        iNNER JOIN CLIENTES CLI ON CRE.ClienteID = CLI.ClienteID
        WHERE CRE.CreditoID = Par_CreditoID;

    SELECT LENGTH(Var_Sucursal) INTO Var_LogSuc;

    SET Var_Suc := SUBSTRING(Par_CreditoID, 1, Var_LogSuc);
    SET Var_NumCred := CAST(SUBSTRING(Par_CreditoID, Var_LogSuc+1, LENGTH(Par_CreditoID)) AS  UNSIGNED);


    IF(Var_NumCred > 99999) THEN
        SET Var_CreditoFormat := CONCAT(Var_Suc, Var_NumCred);
    ELSE
        SET Var_CreditoFormat := CONCAT(Var_Suc, LPAD(Var_NumCred, (8 - Var_LogSuc), 0));
    END IF;

    IF(Var_TipoPersona = 'M') THEN
        SET Var_CodigoTeleCom := Cadena_Vacia;
    ELSE
        SET Var_CodigoTeleCom := CONCAT(LPAD(Var_EstadoID,2,0), LPAD(Var_MunicipioID,3,0),Var_FechaNacimiento,Var_CreditoFormat);
    END IF;

    UPDATE REFPAGOSXINST
    SET Referencia = Var_CodigoTeleCom
    WHERE InstrumentoID =  Par_CreditoID
    AND InstitucionID = Var_InstTELECOM;

     SET Var_RefBansefi := (SELECT Referencia
    FROM REFPAGOSXINST R INNER JOIN INSTITUCIONES I
    ON R.InstitucionID = I.InstitucionID
    WHERE I.AlgoritmoID = 4
    AND R.InstrumentoID = Par_CreditoID );


	SELECT	NombreInstitu,	Var_NomSuc,			Var_FechaActTxt,	Var_FechaActual,		Var_Promotor,			Var_DesFrec,
			Var_Plazo,		ROUND(Var_CAT,2) AS Var_CAT,			Var_CliNombres,		    Var_CliApPat,			Var_CliApMat,
			Var_NumCredAnt,	Var_MontoCredAnt,	Var_ProdCredAnt,	Var_FechaMinistrado,	Var_MontoCred,
			Var_TipoPlan,	Var_Periodo,		Var_NumAmort,		ROUND(Var_TasaAnual,2) AS Var_TasaAnual,
			Var_TipPrestamo,VGraciaFaltaPago,	NomCortoInstitu,	TipoProCre,				Var_FecInicio,	Var_TipoCredito,
			LPAD(Var_EstadoID,2,0) AS Var_EstadoID,	 LPAD(Var_MunicipioID,3,0) AS Var_MunicipioID,	Var_FechaNacimiento, FNGENERACODIGOOXXO(Par_CreditoID, Par_ClienteID) AS DigVerificador, Var_AhorroMenssual,
            Var_CreditoFormat, Var_ImgOXXO AS RutaImgOXXO, Var_ImgTelecomm AS RutaImgTelecomm,        Var_CodigoTeleCom, Var_RefBansefi;
END IF;

IF(Par_TipoReporte = Tipo_AmortizacionAsefimex) THEN
    SET NumInstitucion      := (SELECT InstitucionID FROM PARAMETROSSIS);
    SELECT Direccion,       Nombre
    INTO DireccionInstitu,  NombreInstitu
    FROM INSTITUCIONES
    WHERE InstitucionID = NumInstitucion;

    SET Sucurs  := (SELECT S.NombreSucurs
                    FROM USUARIOS U, SUCURSALES S
                    WHERE   UsuarioID=1
                        AND U.SucursalUsuario= S.SucursalID);

    SET Var_EstatusCredito  :=(SELECT Estatus
                            FROM CREDITOS
                                WHERE CreditoID = Par_CreditoID);

    SET Var_TipoCredito :=(SELECT TipoCredito
                            FROM CREDITOS
                                WHERE CreditoID = Par_CreditoID);

    SET Var_EstatusSol  :=(SELECT Sol.Estatus
                            FROM SOLICITUDCREDITO  Sol
                            INNER JOIN CREDITOS Cre
                            ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
                            WHERE Cre.CreditoID = Par_CreditoID);

    SET Var_EstatusCredito  :=IFNULL(Var_EstatusCredito,Cadena_Vacia);
    SET Var_TipoCredito     :=IFNULL(Var_TipoCredito,Cadena_Vacia);
    SET Var_EstatusSol      :=IFNULL(Var_EstatusSol,Cadena_Vacia);

    SELECT MontoCredito INTO Var_MontoCred FROM CREDITOS WHERE CreditoID = Par_CreditoID;

        SELECT Amo.AmortizacionID,      Amo.FechaInicio,    Amo.FechaVencim,    Amo.FechaExigible,
            (IFNULL(Amo.Capital,Entero_Cero)+IFNULL(Amo.Interes,Entero_Cero)+IFNULL(Amo.IVAInteres,Entero_Cero)+IFNULL(Amo.MontoOtrasComisiones,Entero_Cero)
            +IFNULL(Amo.MontoIVAOtrasComisiones,Entero_Cero)+ IFNULL(Amo.MontoIntOtrasComis, Entero_Cero) + IFNULL(Amo.MontoIVAIntComisi,Entero_Cero)) AS montoCuota,
            IFNULL(Amo.Interes,Entero_Cero) AS Interes,    IFNULL(Amo.IVAInteres,Entero_Cero) As IVAInteres,
            IFNULL(Amo.Capital,Entero_Cero) AS Capital,    IFNULL(Amo.SaldoCapital,Entero_Cero) AS SaldoCapital, NombreInstitu,    DireccionInstitu,   Sucurs,
            IFNULL(Amo.MontoOtrasComisiones,Entero_Cero) AS MontoOtrasComisiones, IFNULL(Amo.MontoIVAOtrasComisiones,Entero_Cero) AS MontoIVAOtrasComisiones, IFNULL(Var_MontoCred,Entero_Cero) AS Var_MontoCred
            FROM AMORTICREDITO Amo
                WHERE Amo.CreditoID = Par_CreditoID;


END IF;


END TerminaStore$$

DELIMITER ;

