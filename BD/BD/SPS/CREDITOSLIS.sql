-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS CREDITOSLIS;

DELIMITER $$
CREATE PROCEDURE `CREDITOSLIS`(
	-- Store Procedure de tipo Lista para el modulo de creditos
	Par_NombCliente				VARCHAR(250),	-- Nombre del Cliente
	Par_ClienteID				INT(11),		-- Numero del Cliente
	Par_Fecha					DATE,			-- Fecha de deteccion de operacion inusual --
	Par_NumLis					TINYINT UNSIGNED,-- Numero de Lista
	Par_EmpresaID				INT(11),		--  Numero de Empresa

	Aud_Usuario					INT(11),		-- Parametro de Auditoria Usuario
	Aud_FechaActual				DATETIME,		-- Parametro de Auditoria Fecha
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de Auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de Auditoria Programa ID
	Aud_Sucursal				INT(12),		-- Parametro de Auditoria Sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de Auditoria Numero Transaccion
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_CreditoID			BIGINT(12);
DECLARE Var_ProductoCreditoID	BIGINT;
DECLARE Var_MontoCredito		DECIMAL(14,2);
DECLARE Var_FechaMinistrado 	DATE;
DECLARE Var_FechaVencimien 		DATE;
DECLARE Var_FechaRegistro		DATE;
DECLARE Var_MontoSolici 		DECIMAL(14,2);
DECLARE Var_Estatus				CHAR(1);
DECLARE Var_FechaSistema		DATE;
DECLARE Str_SaldoTot			CHAR(30);
DECLARE Str_MontoExi			CHAR(30);
DECLARE Str_ProxVenc			CHAR(30);
DECLARE Var_FecActual			DATE;
DECLARE Tmp_DeudaTotal 			DECIMAL(14,2);
DECLARE Var_FechaSis			DATE;
DECLARE Var_DescripcionPC		VARCHAR(45);
DECLARE Var_ProspectoID			INT(11);
DECLARE Var_ValCredAvalados		CHAR(1);
DECLARE Var_Fecha30Dias			DATE;

-- Declaracion de Constantes
DECLARE	Cadena_Vacia			CHAR(1);
DECLARE	Fecha_Vacia				DATE;
DECLARE	Entero_Cero				INT;
DECLARE Decimal_Cero			DECIMAL(12,2);
DECLARE	Lis_Principal 			INT;
DECLARE	Lis_Combo				INT;
DECLARE	Lis_CrePagare			INT;
DECLARE	Lis_CreCliente 			INT;-- Listar creditos por clientes
DECLARE	Lis_CreVig				INT;-- Listar creditos con estatus vigente
DECLARE	Lis_CreAutInac 			INT;-- Listar creditos con estatus Autorizado o Inactivo
DECLARE	Lis_ResCliente 			INT;-- Listar Resumen de Creditos del Cliente
DECLARE	Lis_CreInactivo 		INT;-- Lista de creditos Inactivos
DECLARE	Lis_CreVigVenci			INT;-- Lista de creditos Vigentes o Vencidos
DECLARE	Lis_CreAutPagIm			INT;-- Lista de creditos Autorizados y con estatus de pagare Impreso
DECLARE	Lis_CreIndivid			INT;-- Lista de creditos individuales (todos los estatus)
DECLARE	Lis_CreInvGar			INT;-- Lista de créditos excepto pagados y cancelados
DECLARE Lis_CreCastigados		INT;-- Lista de Creditos Castigados
DECLARE Lis_CreVigentesClie		INT;
DECLARE Lis_CreBloqSaldo		INT;
DECLARE Lis_CliAvalaCreditos	INT;
DECLARE Lis_CreInactivosVen		INT;
DECLARE Lis_TodosCreditos		INT;	-- Lista todos los creditos de un cliente
DECLARE LisCredVigentesPag		INT;	-- Lista de Creditos Vigentes y Pagados
DECLARE LisCredTipoBloq			INT(11);
DECLARE Lis_CreditosCliente		INT;
DECLARE Lis_CreAutVigVen		INT; /* lista creditos AUTORIZADOS, VIGENTES y VENCIDOS */
DECLARE Lis_CreCastigados2		INT;
DECLARE Lis_CreVigVenci2		INT;
DECLARE Lis_CreVigVenci2Suc 	INT(11);
DECLARE Lis_CrePagados			INT;
DECLARE Lis_CreInactivos		INT;
DECLARE Lis_CreVigentes			INT;
DECLARE Lis_CreVigentesSuc 		INT(11);
DECLARE Lis_CartaLiq			INT(11);	-- Lista Carta de Liquidación
-- DECLARE Lis_CrePagaServicio		INT;
DECLARE Lis_ComxAperturaCred	INT(11);	/*Lista para pantalla Cobro Comision x Apertura de Credito*/
DECLARE Lis_CobroCoberturaRiesgo INT(11);	/*Lista para pantalla Cobro cobertura de Riesgo en Ventanilla*/
DECLARE Lis_AplicaPolizaSegVida	 INT(11);	/*Lista para pantalla Aplicar Poliza Cobertura de Riesgo en Ventanilla*/
DECLARE Lista_CredAval			INT(11);	/*Lista Creditos Vencidos,Castigados o con dias de atraso que un cliente o prospecto este avalando */
DECLARE Lista_CreReestructura	INT(11);	/*Lista Creditos para reestructuracion con créditos relacionados*/
DECLARE Lis_CreVigVenci2Ven		INT(11);
DECLARE Lis_CreVigentesVen		INT(11);
DECLARE Lis_devoGaranLiq		INT(11);
DECLARE Lis_CrePerPrepago 		INT(11);
DECLARE Lis_CredLiqOpeInu		INT(1);
DECLARE Lis_CreIndVigVenci		INT(11);   /*Lista los creditos individuales vigentes o vencidos*/
DECLARE Lis_CreVigVenciCli		INT(11);   /*Lista los creditos individuales vigentes o vencidos*/
DECLARE Lis_MonitorDes			INT(11);
DECLARE Lis_CredVigVencInac		INT(11);
DECLARE Lis_CredComisiones		INT(11);
DECLARE Lis_CredGarSinFondeo	INT(11);
DECLARE Lis_CredAgropecuarios	INT(11);
DECLARE Lis_CreAutPagImAgro		INT(11);
DECLARE	Lis_CreVigVenciAgro		INT(11);	-- Lista de creditos Vigentes o Vencidos Agropecuarios
DECLARE	Lis_CreCambioFondeador	INT(11);	-- Lista de creditos que pueden cambiar de fuenta de fondeo
DECLARE Lis_CreReacreditados	INT(11);	-- Lista de Creditos Vigentes para Reacreditacion
DECLARE	Lis_CreVigVenciNOAgro	INT(11);	-- Lista de creditos Vigentes o Vencidos NO Agropecuarios
DECLARE Lis_CreContingentes		INT(11);	-- Lista de créditos Contingentes
DECLARE Lis_CreAccesorios		INT(11); 	-- Lista de Créditos que Cobran Accesorios
DECLARE Lis_CreGarFOGAFI		INT(11);
DECLARE	Lis_GuardaValores		TINYINT UNSIGNED;-- Numero de Lista 56 Guarda Valores
DECLARE Lis_CredSuspension		INT(11);	-- Numero de Listado de Credito Vigentes A Suspender de Tipo de persona Fisica con actividad empresarial
DECLARE Lis_CambioFuentFondCred	INT(11);		-- Lista de creditos para realizar cambio de fuente de fondeo
DECLARE Lis_ClienteCartas		INT(11);		-- Lista de créditos de cartas de liquidación por cliente
DECLARE Var_LisNotasCargo		INT(11);		-- Lista de creditos a los que se les puede aplicar una nota de cargo

DECLARE	PagareImpSi				CHAR(1);
DECLARE	Est_Autorizado			CHAR(1);
DECLARE	Est_Inactivo			CHAR(1);
DECLARE	Est_Vigente				CHAR(1);
DECLARE	Est_Vencido				CHAR(1);
DECLARE	Est_Castigado			CHAR(1);
DECLARE Est_CastigadoDes		CHAR(15);
DECLARE Est_Pagado				CHAR(1);
DECLARE Est_Proceso				CHAR(1);
DECLARE	CredNoGrupal			CHAR(1);
DECLARE TipoBloGarLiq			INT(11);
DECLARE NatMov					CHAR(1);
DECLARE TipoDisEfectivo			CHAR(1);
DECLARE Est_AutorizadoDes		CHAR(15);
DECLARE Est_VigenteDes			CHAR(15);
DECLARE Est_VencidoDes			CHAR(15);
DECLARE FormaCobroAnticipado	CHAR(1);
DECLARE FormaCobroOtro			CHAR(1);
DECLARE StringSI				CHAR(1);
DECLARE StringNO				CHAR(1);
DECLARE ComAperturaAnt			CHAR(1);
DECLARE ComAperturaC			CHAR(2);
DECLARE ComFaltaPagoC			CHAR(2);
DECLARE ComSeguroCuotaC			CHAR(2);
DECLARE ComAnual				CHAR(2);
DECLARE Est_Atrasado			CHAR(1);
DECLARE Fondeo_Propio			CHAR(1);

DECLARE Tipo_Nuevo				CHAR(1);-- tipo de credito N
DECLARE Tipo_Renovado			CHAR(1);-- tipo de credito O
DECLARE Tipo_Reestruc			CHAR(1);-- tipo de credito R
DECLARE Tipo_NuevoDes			CHAR(15);-- tipo de credito N = Nuevo
DECLARE Tipo_RenovadoDes		CHAR(15);-- tipo de credito O = Renovado
DECLARE Tipo_ReestrucDes		CHAR(15);-- tipo de credito R = Reeestructurado
DECLARE Tipo_FIRA				INT;     -- Fuente Fira
DECLARE Cons_NO					CHAR(1);
DECLARE ComAnualLin 			CHAR(2); 	-- Comisión Anual de Linea de crédito
DECLARE Modalidad_Anticipado	CHAR(1);
DECLARE Cons_TipoPersona		CHAR(1);	-- Tipo de Persona A.- Persona Fisica Con Actividad Empresarial
DECLARE Est_Cancelado			CHAR(1);	-- Estatus cancelado del credito
DECLARE Cons_TipoPersonaFis		CHAR(1);	-- Tipo de Persona F.- Persona Fisica Sin Actividad Empresarial
DECLARE Est_Suspendido			CHAR(1);	-- Estatus Suspendido
DECLARE Var_Consolidado			CHAR(15);	-- Texto CONSOLIDADO

-- Asignacion de Constantes
SET Cadena_Vacia			:='';
SET Fecha_Vacia 			:='1900-01-01';
SET Entero_Cero				:= 0;
SET Decimal_Cero			:=0.0;
SET Lis_Principal 			:= 1;
SET Lis_Combo				:= 2;
SET Lis_CreCliente 			:= 3;
SET Lis_CreVig 				:= 4;
SET Lis_CrePagare			:= 5;
SET Lis_CreAutInac 			:= 6;
SET Lis_ResCliente 			:= 7;
SET Lis_CreInactivo 			:= 8;
SET Lis_CreVigVenci 			:= 9;
SET Lis_CreAutPagIm				:=10;
SET Lis_CreIndivid				:=11;
SET Lis_CreInvGar				:=12;
SET Lis_TodosCreditos			:=13;
SET LisCredVigentesPag			:=14;	-- Lista de Creditos Vigentes y Pagados
SET LisCredTipoBloq				:=15;		-- lista para bloqueo de saldos
SET Lis_CreCastigados			:=16;	-- Lista de Creditos Castigados
SET Lis_CreVigentesClie			:=17;
SET Lis_CreditosCliente			:=18;-- Lista los creditos del Cliente para pantalla de banca en linea
SET Lis_CreBloqSaldo			:=19;	-- Deposito de GL en ventanilla y bloqueo manual de saldo
SET Lis_CreAutVigVen			:=20;	/* lista creditos AUTORIZADOS, VIGENTES y VENCIDOS */
SET Lis_CreCastigados2			:=21;
SET Lis_CreVigVenci2			:=22;
SET Lis_CrePagados				:=23;
SET Lis_CreInactivos			:=24;
SET Lis_CreVigentes				:=25;
-- SET Lis_CrePagaServicio			:=26;
SET Lis_CliAvalaCreditos 		:=27;
SET Lis_CreInactivosVen			:=28;
SET Lis_CreVigVenci2Suc 		:=29;
SET Lis_CreVigentesSuc  		:=30;
SET Lis_ComxAperturaCred		:=31;  /*Lista Para pantalla opcion en ventanilla Cobro Comision por apertura*/
SET Lis_CobroCoberturaRiesgo	:=32;  /*Lista para pantalla Cobro Cobertura de Riesgo en Ventanilla*/
SET Lis_AplicaPolizaSegVida		:=33;  /*Lista para pantalla Aplicar Poliza Cobertura de Riesgo en Ventanilla*/
SET Lista_CredAval				:=34;  /*Lista Creditos Vencidos,Castigados o con dias de atraso que un cliente o prospecto este avalando */
SET Lista_CreReestructura		:=35;  /*Lista Creditos para reestructuracion con créditos relacionados*/
SET Lis_CreVigentesVen			:=36;
SET Lis_CreVigVenci2Ven			:=37;
SET Lis_devoGaranLiq			:=38;
SET Lis_CrePerPrepago			:=39;-- Lista de creditos que permiten prepago para ventanilla
SET Lis_CredLiqOpeInu			:=40;-- Lista de los Ultimos 5 Creditos utilizados en pantalla de operaciones Inusuales (Grid)
SET Lis_CreIndVigVenci			:=41;-- Lista los creditos individuales vigentes y vencidos
SET Lis_CreVigVenciCli			:=42;-- Lista los creditos vigentes y vencidos de un cliente
SET Lis_MonitorDes				:=43;-- Lista de los creditos que pasaron por el monito de desembolso de credito
SET Lis_CredVigVencInac			:=44;-- Lista de Creditos Vigentes, Vencidos e Inactivos
SET Lis_CredComisiones			:=45;-- Lista de Creditos con el Monto de Adeudo de Comisiones
SET Lis_CredGarSinFondeo		:=46;-- Lista de Creditos con Garantia sin Fondeo
SET Lis_CredAgropecuarios		:=47;-- Lista de Creditos Agropecuarios
SET Lis_CreAutPagImAgro			:= 48;-- Lista de creditos Autorizados y con estatus de pagare Impreso de Creditos Agropecuarios
SET Lis_CreVigVenciAgro			:= 49;-- Lista de Creditos vigentes y vencidos agropecuarios
SET Lis_CreCambioFondeador		:= 50;-- Lista para cambio de fuente de fondeo
SET Lis_CreReacreditados		:= 51;	-- Lista de Creditos Vigentes para Reacreditacion
SET Lis_CreVigVenciNOAgro		:= 52;	-- Lista de creditos Vigentes o Vencidos NO Agropecuarios
SET Lis_CreContingentes			:= 53;	-- Lista de Creditos Contingentes
SET Lis_CreAccesorios 			:= 54; 	-- Lista de Creditos que Cobran Accesorios
SET Lis_CreGarFOGAFI			:= 55;
SET Lis_GuardaValores 			:= 56;
SET Lis_CredSuspension			:= 57;	-- Numero de Listado de Credito Vigentes A Suspender de Tipo de persona Fisica con actividad empresarial
SET Lis_CambioFuentFondCred		:= 58;	-- Lista de creditos para realizar cambio de fuente de fondeo
SET Lis_CartaLiq				:= 59;	-- Lista para pantalla de Cartas de Liquidacion
SET Lis_ClienteCartas			:= 60;	-- Lista de créditos de cartas de liquidación por cliente
SET Var_LisNotasCargo			:= 61;	-- Lista de creditos a los que se les puede aplicar una nota de cargo

SET PagareImpSi					:='S';
SET Est_Autorizado 				:='A';
SET Est_Inactivo				:='I';
SET Est_Vigente					:='V';
SET Est_Vencido					:='B';
SET Est_Castigado				:='K';
SET Est_Pagado					:='P';		-- Estatus Pagado
SET Est_Proceso					:='M';		-- Estatus Proceso
SET CredNoGrupal				:='N';
SET NatMov						:='B';		-- COrresponde con el tipo de bloqueo
SET TipoBloGarLiq				:= 8;		-- el tipo 8 corresponde con Garantia Liguida
SET Est_AutorizadoDes			:='AUTORIZADO';
SET Est_VigenteDes				:='VIGENTE';
SET Est_VencidoDes				:='VENCIDO';
SET Est_CastigadoDes			:='CASTIGADO';
SET Tmp_DeudaTotal  			:=0.0;
SET FormaCobroAnticipado		:="A";		/*Forma de Cobro Anticipado*/
SET FormaCobroOtro				:="O";		/*Forma de Cobro Otro*/
SET StringSI					:='S';		/* String SI*/
SET StringNO					:='N';
SET TipoDisEfectivo				:='E';
SET ComAperturaAnt				:='A';
SET ComAperturaC				:='CA';
SET ComFaltaPagoC				:='FP';
SET ComSeguroCuotaC				:='PS';
SET ComAnual					:='AN';
SET ComAnualLin					:= 'CL';
SET Est_Atrasado				:= 'A';

SET Tipo_Nuevo					:='N';
SET Tipo_Renovado				:='O';
SET Tipo_Reestruc				:='R';
SET Tipo_NuevoDes				:='NORMAL';
SET Tipo_RenovadoDes			:='RENOVADO';
SET Tipo_ReestrucDes			:='REESTRUCTURADO';
SET Fondeo_Propio				:= 'P';		-- Tipo de Fondeo Propio
SET Tipo_FIRA					:= 1; 		-- Fuente Fira
SET Cons_NO						:= 'N';		-- Constante NO
SET Modalidad_Anticipado		:= 'A';
SET Cons_TipoPersona			:= 'A';		-- Tipo de Persona A.- Persona Fisica Con Actividad Empresarial
SET Cons_TipoPersonaFis			:= 'F';		-- Tipo de Persona F.- Persona Fisica Sin Actividad Empresarial
SET Est_Cancelado				:= 'C';		-- Estatus cancelado del credito
SET Est_Suspendido				:= 'S';		-- Estatus Suspendido
SET	Var_Consolidado				:= 'CONSOLIDADO';	-- Texto CONSOLIDADO

SELECT FechaSistema INTO Var_FecActual
	FROM PARAMETROSSIS;

SET Var_Fecha30Dias		:= DATE_SUB(Var_FecActual, INTERVAL 30 DAY);-- 30 días naturales para asignar un tipo de garantía
-- Inicializacion de Variables

IF(Par_NumLis = Lis_Principal) THEN
	SELECT cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
		pro.Descripcion
		FROM CREDITOS cr ,
			CLIENTES c,
			PRODUCTOSCREDITO pro
		WHERE cr.ClienteID=c.ClienteID
		AND c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
		AND cr.ProductoCreditoID = pro.ProducCreditoID
		AND cr.EsAgropecuario = StringNO
		ORDER BY cr.FechaInicio DESC
		LIMIT 0, 50;
END IF;

IF(Par_NumLis = Lis_CrePagare) THEN
	SELECT Cre.CreditoID,	Cli.NombreCompleto AS ClienteID , Cre.Estatus,	Cre.FechaInicio, Cre.FechaVencimien,
		   Pro.Descripcion
		FROM CREDITOS Cre,
			 CLIENTES Cli,
			 PRODUCTOSCREDITO Pro
		WHERE Cli.NombreCompleto LIKE CONCAT("%", Par_NombCliente, "%")
		  AND Cre.ClienteID	= Cli.ClienteID
		  AND (Cre.Estatus = Est_Vigente
				OR Cre.Estatus = Est_Autorizado)
		 AND Cre.ProductoCreditoID = Pro.ProducCreditoID
		 AND Pro.EsGrupal =CredNoGrupal
		ORDER BY Cre.FechaInicio DESC
		LIMIT 0, 50;
END IF;

-- Listar Creditos por Cliente (usada en Ingreso de Operaciones Ventanilla)
IF(Par_NumLis = Lis_CreCliente) THEN
	SELECT	CR.CreditoID,	 CONCAT(CONVERT(CR.CreditoID,CHAR)," - ",PC.Descripcion," - ",CONVERT(FORMAT(CR.MontoCredito,2),CHAR) )
		FROM	CREDITOS CR,
			PRODUCTOSCREDITO PC
		WHERE CR.ClienteID = Par_ClienteID
		AND   CR.ProductoCreditoID = PC.ProducCreditoID
		AND  (CR.Estatus = Est_Inactivo OR CR.Estatus = Est_Autorizado OR  CR.Estatus = Est_Vigente) ;
END IF;

IF(Par_NumLis = Lis_CreVig) THEN
	SELECT 	cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
			Pro.Descripcion
		FROM	CREDITOS cr ,
				CLIENTES c,
				PRODUCTOSCREDITO Pro
		WHERE cr.ClienteID=c.ClienteID
			AND (  c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%"))
			AND cr.Estatus = Est_Vigente
			AND	cr.ProductoCreditoID = Pro.ProducCreditoID
		ORDER BY cr.FechaInicio DESC
		LIMIT 0, 50;
END IF;

IF(Par_NumLis = Lis_CreAutInac) THEN
	SELECT	cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
			pro.Descripcion
		FROM	CREDITOS cr ,
				CLIENTES c,
				PRODUCTOSCREDITO pro
		WHERE 	cr.ClienteID=c.ClienteID
			AND	c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
			AND (cr.Estatus = Est_Inactivo OR cr.Estatus = Est_Autorizado)
			AND	cr.ProductoCreditoID = pro.ProducCreditoID
		ORDER BY cr.FechaInicio DESC
		LIMIT 0, 50;
END IF;

IF(Par_NumLis = Lis_ResCliente  ) THEN

	SELECT  Cre.CreditoID AS Tmp_CreditoID, CONCAT(Cre.ProductoCreditoID," - ",Pro.Descripcion) AS Tmp_ProdCre, FORMAT(Cre.MontoCredito,2) AS MontoCredito,
			Cre.FechaMinistrado AS Tmp_FechaMinis, Cre.FechaVencimien AS Tmp_FechaVenc, FORMAT(IFNULL(Sol.MontoSolici, Decimal_Cero),2) AS MontoSolici ,
			FORMAT(
					FNTOTALADEUDO(Cre.CreditoID) + FNTOTALCOMISION (Cre.CreditoID),2) AS Tmp_SaldoTot,
			FORMAT(FNEXIGIBLEALDIA(Cre.CreditoID) ,2) AS Tmp_MontoExi,
			FNFECHAPROXPAG(Cre.CreditoID) AS Tmp_ProxVenc,
			IFNULL(Sol.FechaRegistro, Fecha_Vacia) AS Tmp_FechaSolici,
			Decimal_Cero AS Tmp_DeudaTotal,
			CASE Cre.Estatus
					WHEN Est_Castigado 	THEN Est_CastigadoDes
					WHEN Est_Vigente 	THEN Est_VigenteDes
					WHEN Est_Vencido 	THEN Est_VencidoDes
					ELSE Cre.Estatus
					END AS Estatus,
			IF (Cre.EsConsolidado=StringSI,Var_Consolidado,CASE Cre.TipoCredito
					WHEN Tipo_Nuevo		THEN Tipo_NuevoDes
					WHEN Tipo_Renovado	THEN Tipo_RenovadoDes
					WHEN Tipo_Reestruc	THEN Tipo_ReestrucDes
					END) AS Origen
		FROM PRODUCTOSCREDITO Pro LEFT JOIN
			 CREDITOS Cre ON Pro.ProducCreditoID = Cre.ProductoCreditoID
	  LEFT OUTER JOIN SOLICITUDCREDITO AS Sol ON         (Sol.SolicitudCreditoID = Cre.SolicitudCreditoID)
		WHERE Cre.ClienteID = Par_ClienteID
		  AND (	Cre.Estatus =  Est_Vigente     -- Vigente
		   OR	Cre.Estatus	=  Est_Vencido	   -- Vencido
		   OR	Cre.Estatus	=  Est_Castigado	); -- Quebrantado
END IF;

-- Lista de creditos Inactivos
IF(Par_NumLis = Lis_CreInactivo) THEN
	SELECT	cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
			Pro.Descripcion
		FROM	CREDITOS cr ,
				CLIENTES c,
				PRODUCTOSCREDITO Pro
		WHERE cr.ClienteID=c.ClienteID
			AND c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
			AND cr.Estatus = Est_Inactivo
			AND	cr.ProductoCreditoID = Pro.ProducCreditoID
			AND Pro.EsGrupal =CredNoGrupal
		ORDER BY cr.FechaInicio DESC
		LIMIT 0, 50;

END IF;

-- Lista de creditos Vigentes o Vencidos
IF(Par_NumLis = Lis_CreVigVenci) THEN
	IF(IFNULL(Par_ClienteID,Entero_Cero) = Entero_Cero) THEN
		SELECT	cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
				PC.Descripcion
			FROM	CREDITOS cr ,
					CLIENTES c,
					PRODUCTOSCREDITO PC
			WHERE 	cr.ClienteID=c.ClienteID
				AND	c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
				AND (cr.Estatus = Est_Vigente OR
					cr.Estatus = Est_Vencido OR
					cr.Estatus = Est_Suspendido)
				AND	cr.ProductoCreditoID = PC.ProducCreditoID
				ORDER BY cr.CreditoID
			LIMIT 0, 15;
	ELSE
		SELECT cr.CreditoID, CONCAT(CONVERT(cr.CreditoID,CHAR),'-',SUBSTRING(PC.Descripcion,1,35))
			FROM 	CREDITOS cr ,
					PRODUCTOSCREDITO PC
			WHERE 	cr.ClienteID= Par_ClienteID
				AND (cr.Estatus = Est_Vigente OR
					cr.Estatus = Est_Vencido OR
					cr.Estatus = Est_Suspendido)
				AND cr.ProductoCreditoID = PC.ProducCreditoID
				ORDER BY cr.CreditoID
			LIMIT 0, 15;
	END IF;
END IF;

-- Lista de creditos Vigentes o Vencidos de un cliente especifico
IF(Par_NumLis = Lis_CreVigVenciCli) THEN

				SELECT	CR.CreditoID,	C.NombreCompleto AS ClienteID , CR.Estatus,
			CR.FechaInicio, CR.FechaVencimien, 	PRO.Descripcion
		FROM	CREDITOS CR,
				CLIENTES C,
				PRODUCTOSCREDITO PRO
		WHERE CR.ClienteID = Par_ClienteID
		 AND	C.NombreCompleto LIKE CONCAT("%", Par_NombCliente, "%")
		AND 	CR.ProductoCreditoID = PRO.ProducCreditoID
		AND 	CR.ClienteID=C.ClienteID
		AND (CR.Estatus = Est_Vigente OR
					CR.Estatus = Est_Vencido )
		LIMIT 15;


END IF;

-- Lista de creditos Autorizados con estatus de pagare impreso
IF(Par_NumLis = Lis_CreAutPagIm) THEN
	SELECT	cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
			Pro.Descripcion
		FROM CREDITOS cr ,
			 CLIENTES c,
			 PRODUCTOSCREDITO Pro
		WHERE cr.ClienteID=c.ClienteID
			AND c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
			AND cr.Estatus = Est_Autorizado
			AND cr.PagareImpreso = PagareImpSi
			AND cr.EsAgropecuario = StringNO
			AND	cr.ProductoCreditoID = Pro.ProducCreditoID
			AND Pro.EsGrupal =CredNoGrupal
		ORDER BY cr.FechaInicio DESC
		LIMIT 0, 50;
END IF;

-- Lista Creditos individuales (todos los estatus)
IF(Par_NumLis = Lis_CreIndivid) THEN
	SELECT	Cre.CreditoID,	Cli.NombreCompleto AS ClienteID , Cre.Estatus,	Cre.FechaInicio, Cre.FechaVencimien,
			Pro.Descripcion
		FROM	CREDITOS Cre,
				CLIENTES Cli,
				PRODUCTOSCREDITO Pro
			WHERE Cre.ClienteID= Cli.ClienteID
				AND	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
				AND	Cre.ProductoCreditoID = Pro.ProducCreditoID
				AND Pro.EsGrupal =CredNoGrupal
				ORDER BY Cre.FechaInicio DESC
				LIMIT 0, 50;
END IF;

IF(Par_NumLis = Lis_CreInvGar) THEN
	SELECT	cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
			pro.Descripcion
		FROM	CREDITOS cr ,
				CLIENTES c,
				PRODUCTOSCREDITO pro
		WHERE 	cr.ClienteID=c.ClienteID
			AND	c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
			AND (	cr.Estatus = Est_Inactivo OR
					cr.Estatus = Est_Autorizado OR
					cr.Estatus = Est_Vigente OR
					cr.Estatus = Est_Vencido	)
			AND	cr.ProductoCreditoID = pro.ProducCreditoID
		ORDER BY cr.Estatus =  Est_Vencido, cr.Estatus = Est_Vigente, cr.Estatus = Est_Autorizado, cr.Estatus = Est_Inactivo
		LIMIT 0, 15;
END IF;


-- 13 Lista todos los creditos
IF(Par_NumLis = Lis_TodosCreditos) THEN
	SELECT	CR.CreditoID,	C.NombreCompleto AS ClienteID , CR.Estatus,
			CR.FechaInicio, CR.FechaVencimien, 	PRO.Descripcion
		FROM	CREDITOS CR,
				CLIENTES C,
				PRODUCTOSCREDITO PRO
		WHERE CR.ClienteID = Par_ClienteID
		 AND	C.NombreCompleto LIKE CONCAT("%", Par_NombCliente, "%")
		AND 	CR.ProductoCreditoID = PRO.ProducCreditoID
		AND 	CR.ClienteID=C.ClienteID
		ORDER BY CR.FechaInicio DESC
		LIMIT 0, 50;
END IF;

-- 14 Lista de creditos Vigentes y Pagados
IF(Par_NumLis = LisCredVigentesPag) THEN
	SELECT 	cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
			Pro.Descripcion
		FROM	CREDITOS cr ,
				CLIENTES c,
				PRODUCTOSCREDITO Pro
		WHERE cr.ClienteID=c.ClienteID
			AND ( c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%"))
			AND	cr.ProductoCreditoID = Pro.ProducCreditoID
		ORDER BY cr.FechaInicio DESC
		LIMIT 0, 50;
END IF;



IF(Par_NumLis = LisCredTipoBloq) THEN
SELECT	CR.CreditoID, CR.ClienteID,	CONCAT(CONVERT(CR.CreditoID,CHAR)," - ",PC.Descripcion,
		" - ",CONVERT(FORMAT(CR.MontoCredito,2),CHAR) ) AS Credito_Descripcion_Monto
		FROM	CREDITOS CR,
			PRODUCTOSCREDITO PC
		WHERE ClienteID=Par_ClienteID
			AND CR.ProductoCreditoID = PC.ProducCreditoID
		AND (CR.Estatus = Est_Inactivo OR CR.Estatus = Est_Autorizado);
END IF;

-- Lista de creditos Castigados
IF(Par_NumLis = Lis_CreCastigados) THEN
	SELECT	cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
			Pro.Descripcion
		FROM	CREDITOS cr ,
				CLIENTES c,
				PRODUCTOSCREDITO Pro
		WHERE cr.ClienteID=c.ClienteID
			AND c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
			AND cr.Estatus = Est_Castigado
			AND	cr.ProductoCreditoID = Pro.ProducCreditoID
		ORDER BY cr.FechaInicio DESC
		LIMIT 0, 50;

END IF;

-- Lista de Creditos Vigentes del Cliente

IF (Lis_CreVigentesClie = Par_NumLis )THEN
SELECT  Cre.CreditoID,
		CONCAT(CONVERT(Cre.ProductoCreditoID, CHAR), " ",Pro.Descripcion) AS DescripPro,
		Cre.Estatus,
		FORMAT(Cre.MontoCredito,2) AS MontoCredito,
		FORMAT(FUNCIONTOTDEUDACRE(Cre.CreditoID),2) AS TotalAdeConIVA,
		FORMAT(FUNCTOTDEUCRESINIIVA(Cre.CreditoID),2) AS TotalAdeSinIVA,
		Cre.FechaMinistrado,
		Cre.FechaVencimien
		FROM CREDITOS Cre
		LEFT JOIN PRODUCTOSCREDITO Pro	ON Cre.ProductoCreditoID =Pro.ProducCreditoID
		WHERE Cre.ClienteID = Par_ClienteID
		  AND (	Cre.Estatus     =  Est_Vigente    -- Vigente
		   OR	Cre.Estatus		=  Est_Vencido		  -- Vencido
		);


END IF;

IF (Lis_CreditosCliente = Par_NumLis )THEN
	SELECT CreditoID, PC.Descripcion
	FROM   CREDITOS  CR INNER JOIN
		PRODUCTOSCREDITO PC ON CR.ProductoCreditoID=PC.ProducCreditoID
	WHERE  CR.ClienteID = Par_ClienteID
	AND (CR.Estatus = Est_Vencido	 OR  Estatus = Est_Vigente) ;


END IF;
-- 19.- Deposito de GL en ventanilla y pantalla bloqueo manual de saldo
IF(Par_NumLis = Lis_CreBloqSaldo) THEN
	SELECT	CR.CreditoID, CR.ClienteID,	CONCAT(CONVERT(CR.CreditoID,CHAR)," - ",PC.Descripcion,
			" - ",CONVERT(FORMAT(CR.MontoCredito,2),CHAR) ) AS Credito_Descripcion_Monto
			FROM CREDITOS CR,
				  PRODUCTOSCREDITO PC
			WHERE CR.ClienteID = Par_ClienteID
			  AND CR.ProductoCreditoID = PC.ProducCreditoID
			  AND (CR.Estatus = Est_Inactivo OR CR.Estatus = Est_Autorizado OR CR.Estatus = Est_Vigente OR CR.Estatus = Est_Vencido)
			  AND CR.AporteCliente > Entero_Cero
			  AND 	CR.CreditoID  NOT IN  (		SELECT Blo.Referencia AS CreditoID
											FROM BLOQUEOS Blo
											LEFT JOIN CREDITOINVGAR CIG ON CIG.CreditoID = Blo.Referencia
											WHERE	NatMovimiento 		= 'B'
											 AND	IFNULL(FolioBloq,0)	= 0
											 AND	TiposBloqID 		= 8
											 AND 	Referencia 			= CR.CreditoID
											 AND 	CuentaAhoID 		= CR.CuentaID
											GROUP BY Referencia,	CR.CreditoID,	CR.ClienteID
											HAVING CR.AporteCliente  <= IFNULL(SUM(MontoBloq),0)+ IFNULL(SUM(CIG.MontoEnGar),0) );

END IF;


/* lista creditos AUTORIZADOS, VIGENTES y VENCIDOS */
IF(Par_NumLis = Lis_CreAutVigVen) THEN
	SELECT	cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
			pro.Descripcion
		FROM	CREDITOS cr ,
				CLIENTES c,
				PRODUCTOSCREDITO pro
		WHERE 	cr.ClienteID=c.ClienteID
			AND	c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
			AND (	cr.Estatus = Est_Autorizado OR
					cr.Estatus = Est_Vigente OR
					cr.Estatus = Est_Vencido	)
			AND	cr.ProductoCreditoID = pro.ProducCreditoID
		ORDER BY cr.Estatus =  Est_Vencido, cr.Estatus = Est_Vigente, cr.Estatus = Est_Autorizado
		LIMIT 0, 15;
END IF;


# 21. Lista de creditos Castigados, utilizada en operaciones ventanilla
IF(Par_NumLis = Lis_CreCastigados2) THEN
	SELECT	cr.CreditoID,			c.ClienteID,		c.NombreCompleto,	 cr.Estatus,		cr.FechaInicio,
			cr.FechaVencimien, 		Pro.Descripcion,	Suc.NombreSucurs,c.FechaNacimiento
		FROM	CREDITOS cr ,
				CLIENTES c,
				PRODUCTOSCREDITO Pro,
				SUCURSALES Suc
		WHERE cr.ClienteID=c.ClienteID
			AND c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
			AND cr.Estatus = Est_Castigado
			AND	cr.ProductoCreditoID = Pro.ProducCreditoID
			AND c.SucursalOrigen = Suc.SucursalID
		ORDER BY cr.FechaInicio DESC
		LIMIT 0, 50;
END IF;

#22. lista creditos vigentes y vencidos, utilizada en operaciones ventanilla
# (Pago credito, prepago de Credito)

IF(Par_NumLis = Lis_CreVigVenci2) THEN
		SELECT	cr.CreditoID,	 	c.ClienteID, 	c.NombreCompleto, 	cr.Estatus,	cr.FechaInicio,
				cr.FechaVencimien, 	PC.Descripcion, Suc.NombreSucurs, c.FechaNacimiento
			FROM	CREDITOS cr ,
					CLIENTES c,
					PRODUCTOSCREDITO PC,
					SUCURSALES	Suc
			WHERE 	cr.ClienteID=c.ClienteID
				AND	c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
				AND (cr.Estatus = Est_Vigente OR
					cr.Estatus = Est_Vencido )
				AND	cr.ProductoCreditoID = PC.ProducCreditoID
				AND c.SucursalOrigen = Suc.SucursalID
			ORDER BY cr.FechaInicio DESC
			LIMIT 0, 50;
END IF;

-- Num. 39 Prepagos en Ventanilla
IF(Par_NumLis = Lis_CrePerPrepago) THEN
		IF IFNULL(Par_ClienteID,Entero_Cero)>Entero_Cero THEN
			SELECT	cr.CreditoID,	 	c.ClienteID, 	c.NombreCompleto, 	cr.Estatus,	cr.FechaInicio,
				cr.FechaVencimien, 	PC.Descripcion, Suc.NombreSucurs, c.FechaNacimiento
			FROM	CREDITOS cr ,
					CLIENTES c,
					PRODUCTOSCREDITO PC,
					SUCURSALES	Suc
			WHERE c.ClienteID=Par_ClienteID
				AND cr.ClienteID=c.ClienteID
				AND (cr.Estatus = Est_Vigente OR
					cr.Estatus = Est_Vencido OR
					cr.Estatus = Est_Suspendido)
				AND	cr.ProductoCreditoID = PC.ProducCreditoID AND PC.PermitePrepago='S'
				AND c.SucursalOrigen = Suc.SucursalID
				ORDER BY cr.FechaInicio DESC
				LIMIT 0, 50;
		ELSE
			SELECT	cr.CreditoID,	 	c.ClienteID, 	c.NombreCompleto, 	cr.Estatus,	cr.FechaInicio,
					cr.FechaVencimien, 	PC.Descripcion, Suc.NombreSucurs, c.FechaNacimiento
				FROM	CREDITOS cr ,
						CLIENTES c,
						PRODUCTOSCREDITO PC,
						SUCURSALES	Suc
				WHERE 	cr.ClienteID=c.ClienteID
					AND	c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
					AND (cr.Estatus = Est_Vigente OR
						cr.Estatus = Est_Vencido OR
						cr.Estatus = Est_Suspendido)
					AND	cr.ProductoCreditoID = PC.ProducCreditoID AND PC.PermitePrepago='S'
					AND c.SucursalOrigen = Suc.SucursalID
				ORDER BY cr.FechaInicio DESC
				LIMIT 0, 50;
		END IF;
END IF;
-- Num. 37 Pago de Credito en ventanilla
IF(Par_NumLis = Lis_CreVigVenci2Ven) THEN
	IF IFNULL(Par_ClienteID,Entero_Cero)>Entero_Cero THEN
		SELECT	cr.CreditoID,	 	c.ClienteID, 	c.NombreCompleto, 	cr.Estatus,	cr.FechaInicio,
				cr.FechaVencimien, 	PC.Descripcion, Suc.NombreSucurs, c.FechaNacimiento
			FROM	CREDITOS cr ,
					CLIENTES c,
					PRODUCTOSCREDITO PC,
					SUCURSALES	Suc
			WHERE 	cr.ClienteID=c.ClienteID
				AND c.ClienteID=Par_ClienteID
				AND (cr.Estatus = Est_Vigente OR
					cr.Estatus = Est_Vencido OR
					cr.Estatus = Est_Suspendido)
				AND	cr.ProductoCreditoID = PC.ProducCreditoID
				AND c.SucursalOrigen = Suc.SucursalID
			ORDER BY cr.FechaInicio DESC
			LIMIT 0, 50;
	ELSE
		SELECT	cr.CreditoID,	 	c.ClienteID, 	c.NombreCompleto, 	cr.Estatus,	cr.FechaInicio,
				cr.FechaVencimien, 	PC.Descripcion, Suc.NombreSucurs, c.FechaNacimiento
			FROM	CREDITOS cr ,
					CLIENTES c,
					PRODUCTOSCREDITO PC,
					SUCURSALES	Suc
			WHERE 	cr.ClienteID=c.ClienteID
				AND	c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
				AND (cr.Estatus = Est_Vigente OR
					cr.Estatus = Est_Vencido OR
					cr.Estatus = Est_Suspendido)
				AND	cr.ProductoCreditoID = PC.ProducCreditoID
				AND c.SucursalOrigen = Suc.SucursalID ORDER BY cr.FechaInicio DESC LIMIT 0, 50;
	END IF;

END IF;

IF(Par_NumLis = Lis_CreVigVenci2Suc) THEN
	IF IFNULL(Par_ClienteID,Entero_Cero) THEN
		SELECT
			Cli.CreditoID,	 	Cli.ClienteID, 	Cli.NombreCompleto, Cre.Estatus,		Cre.FechaInicio,
			Cre.FechaVencimien, PC.Descripcion, Suc.NombreSucurs, 	Cli.FechaNacimiento
		FROM CREDITOS Cre
		INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
		INNER JOIN PRODUCTOSCREDITO PC ON Cre.ProductoCreditoID = PC.ProducCreditoID
		INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Cli.SucursalOrigen
		WHERE Cli.ClienteID=Par_ClienteID
		AND   Cli.NombreCompleto LIKE CONCAT("%", Par_NombCliente, "%")
		AND   Cli.SucursalOrigen = Aud_Sucursal
		AND  (Cre.Estatus = Est_Vigente OR
				Cre.Estatus = Est_Vencido )
		ORDER BY Cre.FechaInicio DESC
		LIMIT 0, 50;
	ELSE
		SELECT
			cr.CreditoID,	 	c.ClienteID, 	c.NombreCompleto, 	cr.Estatus,		cr.FechaInicio,
			cr.FechaVencimien, 	PC.Descripcion, suc.NombreSucurs, 	c.FechaNacimiento
		FROM CREDITOS cr
		INNER JOIN CLIENTES c ON cr.ClienteID = c.ClienteID
		INNER JOIN PRODUCTOSCREDITO PC ON cr.ProductoCreditoID = PC.ProducCreditoID
		INNER JOIN SUCURSALES suc ON suc.SucursalID = c.SucursalOrigen
		WHERE (cr.Estatus = Est_Vigente OR
				cr.Estatus = Est_Vencido ) AND c.NombreCompleto LIKE CONCAT("%", Par_NombCliente, "%")
		AND c.SucursalOrigen = Aud_Sucursal
		ORDER BY cr.FechaInicio DESC
		LIMIT 0, 50;
	END IF;
END IF;

#23. lista creditos pagados, utilizada en operaciones ventanilla
#Devolucion de GL, Aplicar Cobertura de Riesgo
IF(Par_NumLis = Lis_CrePagados) THEN
		SELECT	cr.CreditoID,	 	c.ClienteID, 	c.NombreCompleto, 	cr.Estatus,	cr.FechaInicio,
				cr.FechaVencimien, 	PC.Descripcion, Suc.NombreSucurs, c.FechaNacimiento
			FROM	CREDITOS cr ,
					CLIENTES c,
					PRODUCTOSCREDITO PC,
					SUCURSALES	Suc
			WHERE 	cr.ClienteID=c.ClienteID
				AND	c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
				AND cr.Estatus = Est_Pagado
				AND	cr.ProductoCreditoID = PC.ProducCreditoID
				AND c.SucursalOrigen = Suc.SucursalID
			ORDER BY cr.FechTerminacion DESC
			LIMIT 0, 15;
END IF;

-- Num 38. Devolucion de Garantia Liquida en Ventanilla
IF(Par_NumLis = Lis_devoGaranLiq) THEN
		SELECT	DISTINCT cr.CreditoID,	 	c.ClienteID, 	c.NombreCompleto, 	cr.Estatus,	cr.FechaInicio,
				cr.FechaVencimien, 	PC.Descripcion, Suc.NombreSucurs, c.FechaNacimiento, cr.FechTerminacion
			FROM	CREDITOS cr ,
					CLIENTES c,
					PRODUCTOSCREDITO PC,
					SUCURSALES	Suc,
					CUENTASAHO cta,
					BLOQUEOS blo
			WHERE 	cr.ClienteID=c.ClienteID
				AND	c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
				AND c.ClienteID=cta.ClienteID
				AND cta.CuentaAhoID=blo.CuentaAhoID AND blo.TiposBloqID=8
				AND cr.Estatus = Est_Pagado
				AND	cr.ProductoCreditoID = PC.ProducCreditoID
				AND c.SucursalOrigen = Suc.SucursalID
			ORDER BY cr.FechTerminacion DESC
			LIMIT 0, 15;
END IF;

-- ok
#24. lista creditos inactivos, utilizada en operaciones ventanilla
#Solo Comision por Apertura
IF(Par_NumLis = Lis_CreInactivos) THEN
		SELECT	cr.CreditoID,	 	c.ClienteID, 	c.NombreCompleto, 	cr.Estatus,	cr.FechaInicio,
				cr.FechaVencimien, 	PC.Descripcion, Suc.NombreSucurs, c.FechaNacimiento
			FROM	CREDITOS cr ,
					CLIENTES c,
					PRODUCTOSCREDITO PC,
					SUCURSALES	Suc
			WHERE 	cr.ClienteID=c.ClienteID
				AND	c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
				AND IFNULL(cr.ComAperPagado,Decimal_Cero) < IFNULL(cr.MontoComApert,Decimal_Cero)
				AND cr.Estatus = Est_Inactivo
				AND	cr.ProductoCreditoID = PC.ProducCreditoID
				AND c.SucursalOrigen = Suc.SucursalID
			ORDER BY cr.FechaInicio ASC
			LIMIT 0, 15;
END IF;

#25. lista creditos vigentes, utilizada en operaciones ventanilla
IF(Par_NumLis = Lis_CreVigentes) THEN
		SELECT	cr.CreditoID,	 	c.ClienteID, 	c.NombreCompleto, 	cr.Estatus,	cr.FechaInicio,
				cr.FechaVencimien, 	PC.Descripcion, Suc.NombreSucurs, c.FechaNacimiento
			FROM	CREDITOS cr ,
					CLIENTES c,
					PRODUCTOSCREDITO PC,
					SUCURSALES	Suc
			WHERE 	cr.ClienteID=c.ClienteID
				AND	c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
				AND cr.Estatus = Est_Vigente
				AND	cr.ProductoCreditoID = PC.ProducCreditoID
				AND c.SucursalOrigen = Suc.SucursalID
			ORDER BY cr.FechaInicio DESC
			LIMIT 0, 15;
END IF;
IF(Par_NumLis = Lis_CreVigentesVen) THEN
		IF IFNULL(Par_ClienteID,Entero_Cero)>Entero_Cero THEN
			SELECT	Cre.CreditoID,	 	Cli.ClienteID, 	Cli.NombreCompleto, Cre.Estatus,	Cre.FechaInicio,
					Cre.FechaVencimien, 	PC.Descripcion, Suc.NombreSucurs, Cli.FechaNacimiento
				FROM	CREDITOS Cre ,
						CLIENTES Cli,
						PRODUCTOSCREDITO PC,
						SUCURSALES	Suc
				WHERE 	Cre.ClienteID=Cli.ClienteID
					AND Cli.ClienteID=Par_ClienteID
					AND	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
					AND Cre.Estatus = Est_Vigente
					AND	Cre.ProductoCreditoID = PC.ProducCreditoID
					AND Cli.SucursalOrigen = Suc.SucursalID
					AND Cre.MontoPorDesemb>Decimal_Cero
					AND Cre.TipoDispersion = TipoDisEfectivo
				ORDER BY Cre.FechaInicio DESC
				LIMIT 0, 50;
		ELSE
		SELECT	cr.CreditoID,	 	c.ClienteID, 	c.NombreCompleto, 	cr.Estatus,	cr.FechaInicio,
				cr.FechaVencimien, 	PC.Descripcion, Suc.NombreSucurs, c.FechaNacimiento
			FROM	CREDITOS cr ,
					CLIENTES c,
					PRODUCTOSCREDITO PC,
					SUCURSALES	Suc
			WHERE 	cr.ClienteID=c.ClienteID
				AND	c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
				AND cr.Estatus = Est_Vigente
				AND	cr.ProductoCreditoID = PC.ProducCreditoID
				AND c.SucursalOrigen = Suc.SucursalID
				AND cr.MontoPorDesemb>Decimal_Cero
				AND cr.TipoDispersion = TipoDisEfectivo
			ORDER BY cr.FechaInicio DESC
			LIMIT 0, 50;
		END IF;
END IF;

IF(Par_NumLis = Lis_CreVigentesSuc) THEN
SELECT cr.CreditoID,	 	c.ClienteID, 	c.NombreCompleto, 	cr.Estatus,	cr.FechaInicio,
				cr.FechaVencimien, 	pc.Descripcion, suc.NombreSucurs, c.FechaNacimiento
	FROM CREDITOS cr
			INNER JOIN CLIENTES c ON cr.ClienteID=c.ClienteID AND c.SucursalOrigen=Aud_Sucursal
			INNER JOIN PRODUCTOSCREDITO pc ON cr.ProductoCreditoID=pc.ProducCreditoID
			INNER JOIN SUCURSALES suc ON c.SucursalOrigen=suc.SucursalID
	WHERE c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
		AND cr.Estatus = Est_Vigente
		AND cr.MontoPorDesemb>Decimal_Cero
		AND cr.TipoDispersion = TipoDisEfectivo
	ORDER BY cr.FechaInicio DESC
	LIMIT 0,25;

END IF;

#28. lista creditos Inactivos, utilizada en operaciones ventanilla
# Cobro Cobertura de Riesgo
IF(Par_NumLis = Lis_CreInactivosVen) THEN
		SELECT	cr.CreditoID,	 	c.ClienteID, 	c.NombreCompleto, 	cr.Estatus,	cr.FechaInicio,
				cr.FechaVencimien, 	PC.Descripcion, Suc.NombreSucurs,c.FechaNacimiento
			FROM	CREDITOS cr ,
					CLIENTES c,
					PRODUCTOSCREDITO PC,
					SUCURSALES	Suc
			WHERE 	cr.ClienteID=c.ClienteID
				AND	c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
				AND cr.Estatus = Est_Inactivo
				AND	cr.ProductoCreditoID = PC.ProducCreditoID
				AND c.SucursalOrigen = Suc.SucursalID
			ORDER BY cr.FechaInicio ASC
			LIMIT 0, 15;
END IF;

#27. creditos avalados por un cliente, utilizada en el grid de la pantalla "RESUMEN CLIENTE" y de "SEGTO. OP. INUSUALES"
IF(Par_NumLis = Lis_CliAvalaCreditos) THEN
SET Var_FechaSis   := (SELECT FechaSistema FROM PARAMETROSSIS);
	IF(IFNULL(Par_ClienteID,Entero_Cero)!=Entero_Cero) THEN
		SELECT	Cre.CreditoID, Cre.ClienteID, Cli.NombreCompleto, CONCAT(Pro.ProducCreditoID,' - ',Pro.Descripcion) AS Descripcion,
				FUNCIONDIASATRASO(Cre.CreditoID,Var_FechaSis) AS DiasAtraso,
				FORMAT(Cre.MontoCredito,2) AS MontoCredito,
				FORMAT((Cre.SaldoCapAtrasad + Cre.SaldoCapVigent + Cre.SaldoCapVencido + Cre.SaldCapVenNoExi),2) AS SaldoCapitalDia,
				CASE Cre.Estatus
				WHEN Est_Autorizado THEN Est_AutorizadoDes
				WHEN Est_Vigente THEN Est_VigenteDes
				WHEN Est_Vencido THEN Est_VencidoDes
				ELSE Cre.Estatus
				END AS Estatus
			FROM	CLIENTES Cli
						 INNER JOIN CREDITOS Cre ON	Cre.ClienteID = Cli.ClienteID
						 INNER JOIN AVALESPORSOLICI Ava ON Cre.SolicitudCreditoID = Ava.SolicitudCreditoID
						 LEFT JOIN PRODUCTOSCREDITO Pro	ON Cre.ProductoCreditoID = Pro.ProducCreditoID

					WHERE (Cre.Estatus = Est_Autorizado OR Cre.Estatus = Est_Vigente OR Cre.Estatus = Est_Vencido)
					AND Ava.ClienteID = Par_ClienteID;
	END IF;
END IF;
/*LISTA COMISION POR APERTURA DE CREDITO PANTALLA DE VENTANILLA*/
IF Lis_ComxAperturaCred=Par_NumLis THEN
	SELECT	cr.CreditoID,	 	c.ClienteID, 	c.NombreCompleto, 	cr.Estatus,	cr.FechaInicio,
			cr.FechaVencimien, 	PC.Descripcion, Suc.NombreSucurs, c.FechaNacimiento
	FROM	CREDITOS cr ,
			CLIENTES c,
			PRODUCTOSCREDITO PC,
			SUCURSALES	Suc
	WHERE 	cr.ClienteID=c.ClienteID
		AND	c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
		AND IFNULL(cr.ComAperPagado,Decimal_Cero) < IFNULL(cr.MontoComApert,Decimal_Cero)
		AND cr.ForCobroComAper= FormaCobroAnticipado
		AND cr.Estatus = Est_Inactivo
		AND	cr.ProductoCreditoID = PC.ProducCreditoID
		AND c.SucursalOrigen = Suc.SucursalID
		ORDER BY cr.FechaInicio ASC
		LIMIT 0, 15;
END IF;


/*LISTA COBRO COBERTURA DE RIESGO*/
IF Lis_CobroCoberturaRiesgo=Par_NumLis THEN
	SELECT FechaSistema INTO Var_FechaSistema
		FROM PARAMETROSSIS;
	SELECT	cr.CreditoID,	 	c.ClienteID, 	c.NombreCompleto, 	cr.Estatus,	cr.FechaInicio,
				cr.FechaVencimien, 	PC.Descripcion, Suc.NombreSucurs,c.FechaNacimiento
			FROM	CREDITOS cr ,
					CLIENTES c,
					PRODUCTOSCREDITO PC,
					SUCURSALES	Suc,
					SEGUROVIDA Seg
			WHERE 	cr.ClienteID=c.ClienteID
				AND	c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
				AND cr.Estatus = Est_Inactivo
				AND cr.ForCobroSegVida IN (FormaCobroAnticipado, FormaCobroOtro)
				AND	cr.ProductoCreditoID = PC.ProducCreditoID
				AND c.SucursalOrigen = Suc.SucursalID
				AND (Seg.CreditoID=cr.CreditoID AND Seg.FechaVencimiento > Var_FechaSistema
					 AND Seg.Estatus="I")
			GROUP BY cr.CreditoID,			c.ClienteID, 		c.NombreCompleto, 	cr.Estatus,			cr.FechaInicio,
					 cr.FechaVencimien, 	PC.Descripcion, 	Suc.NombreSucurs,	c.FechaNacimiento
			ORDER BY cr.FechaInicio ASC
			LIMIT 0, 15;
END IF;

/*LISTA APLICA POLIZA COBERTURA DE RIESGO*/
IF Lis_AplicaPolizaSegVida= Par_NumLis THEN
SELECT FechaSistema INTO Var_FechaSistema FROM PARAMETROSSIS;
	SELECT	 Cre.CreditoID,	 		Cli.ClienteID, 	Cli.NombreCompleto, 	 Cre .Estatus,	 Cre.FechaInicio,
			 Cre .FechaVencimien, 	PC.Descripcion, Suc.NombreSucurs, 		 Cli.FechaNacimiento
			FROM	CREDITOS Cre
					INNER JOIN 	CLIENTES Cli ON Cre.ClienteID= Cli.ClienteID
					INNER JOIN PRODUCTOSCREDITO PC ON Cre.ProductoCreditoID = PC.ProducCreditoID
					INNER JOIN SUCURSALES Suc ON Cli.SucursalOrigen = Suc.SucursalID
					INNER JOIN SEGUROVIDA Seg  ON Seg.CreditoID=Cre.CreditoID
			WHERE 	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
				AND (Cre.Estatus =Est_Vigente	OR
					Cre.Estatus = Est_Vencido )
				AND (Seg.Estatus="V" AND Seg.FechaVencimiento>Var_FechaSistema)
				GROUP BY Cre.CreditoID,			Cli.ClienteID, 		Cli.NombreCompleto, 	 Cre .Estatus,			Cre.FechaInicio,
						 Cre .FechaVencimien, 	PC.Descripcion, 	Suc.NombreSucurs, 		 Cli.FechaNacimiento
			LIMIT 0, 15;
END IF;
/*LISTA TODOS LOS CREDITOS QUE UN CLIENTE ESTE AVALANDO Y QUE ESTEN VENCIDOS, CASTIGADOS O QUE TENGAN DIAS DE ATRASO
  SI EL CLIENTE FUE PROSPECTO Y QUE AVALO UN CREDITO TAMBIEN SE MUESTRA EL CREDITO SI SE ENCUENTRA EN LAS CONDICIONES
  ANTERIORES*/
IF Par_NumLis=Lista_CredAval THEN

	SELECT ValCredAvalados INTO Var_ValCredAvalados FROM PARAMCAMBIOSUCUR LIMIT 1;
	SET Var_ValCredAvalados = IFNULL(Var_ValCredAvalados, Cadena_Vacia);
	IF(Var_ValCredAvalados = StringSI)THEN
		SELECT FechaSistema INTO Var_FechaSis
			FROM PARAMETROSSIS;

		SELECT Pro.ProspectoID INTO Var_ProspectoID
			FROM  PROSPECTOS Pro
			WHERE Pro.ClienteID=Par_ClienteID;


		SELECT Cre.CreditoID,Cre.Estatus,Ava.ClienteID,FUNCIONDIASATRASO(Cre.CreditoID,Var_FechaSis) AS DiasAtraso
			FROM CREDITOS Cre
			INNER JOIN AVALESPORSOLICI Ava ON Cre.SolicitudCreditoID=Ava.SolicitudCreditoID
			WHERE Ava.ClienteID=Par_ClienteID OR  Ava.ProspectoID=Var_ProspectoID;
	ELSE
		SELECT Cadena_Vacia AS CreditoID,Cadena_Vacia AS Estatus,Cadena_Vacia AS ClienteID,Cadena_Vacia  AS DiasAtraso;

	END IF;

END IF;

-- Lista Creditos individuales (todos los estatus) con creditos relacionados para reestructura
IF(Par_NumLis = Lista_CreReestructura) THEN
	SELECT	Cre.CreditoID,	Cli.NombreCompleto AS ClienteID , Cre.Estatus,	Cre.FechaInicio, Cre.FechaVencimien,
			Pro.Descripcion
		FROM	CREDITOS Cre,
				CLIENTES Cli,
				PRODUCTOSCREDITO Pro
			WHERE Cre.ClienteID= Cli.ClienteID
				AND	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
				AND	Cre.ProductoCreditoID = Pro.ProducCreditoID
				AND Pro.EsGrupal =CredNoGrupal
				AND	Cre.Estatus = Est_Inactivo
				AND Cre.Relacionado != Entero_Cero
				ORDER BY Cre.FechaInicio DESC
				LIMIT 0, 50;
END IF;
IF(Par_NumLis = Lis_CredLiqOpeInu) THEN
	SELECT cre.CreditoID,  cre.ProductoCreditoID,pro.Descripcion AS DesProductoCredito, cre.FechaMinistrado, cre.FechTerminacion,
			FORMAT(MontoCredito,2) AS  MontoCredito, IFNULL(sol.UsuarioAltaSol, Entero_Cero) AS UsuarioAltaSol,IFNULL(usu.NombreCompleto,Cadena_Vacia) AS NombreCompleto ,
			CONCAT(des.DestinoCreID," ",des.Descripcion) AS DestinoCredito, 	IFNULL(sol.Proyecto, Cadena_Vacia) AS Proyecto
		FROM CREDITOS cre
			INNER JOIN PRODUCTOSCREDITO pro ON cre.ProductoCreditoID = pro.ProducCreditoID
			LEFT OUTER JOIN SOLICITUDCREDITO sol ON cre.SolicitudCreditoID = sol.SolicitudCreditoID
			LEFT OUTER JOIN USUARIOS usu ON sol.UsuarioAltaSol = usu.UsuarioID
			LEFT OUTER JOIN DESTINOSCREDITO des ON cre.DestinoCreID = des.DestinoCreID
		WHERE cre.ClienteID = Par_ClienteID
		AND cre.Estatus = Est_Pagado
		AND cre.FechTerminacion <= Par_Fecha
		ORDER BY cre.FechTerminacion DESC
		LIMIT 5;
END IF;



-- Lista de creditos Vigentes o Vencidos Individuales para pantalla de Pago de Intereses con Cargo a cuenta
IF(Par_NumLis = Lis_CreIndVigVenci) THEN
	IF(IFNULL(Par_ClienteID,Entero_Cero) = Entero_Cero) THEN
		SELECT	cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
				PC.Descripcion
			FROM	CREDITOS cr ,
					CLIENTES c,
					PRODUCTOSCREDITO PC
			WHERE 	cr.ClienteID=c.ClienteID
				AND	c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
				AND (cr.Estatus = Est_Vigente OR
					cr.Estatus = Est_Vencido OR
					cr.Estatus = Est_Suspendido)
				AND	cr.ProductoCreditoID = PC.ProducCreditoID
				AND IFNULL(cr.GrupoID,Entero_Cero)=Entero_Cero
				ORDER BY cr.CreditoID
			LIMIT 0, 15;
	ELSE
		SELECT cr.CreditoID, CONCAT(CONVERT(cr.CreditoID,CHAR),'-',SUBSTRING(PC.Descripcion,1,35))
			FROM 	CREDITOS cr ,
					PRODUCTOSCREDITO PC
			WHERE 	cr.ClienteID= Par_ClienteID
				AND (cr.Estatus = Est_Vigente OR
					cr.Estatus = Est_Vencido OR
					cr.Estatus = Est_Suspendido)
				AND cr.ProductoCreditoID = PC.ProducCreditoID
				AND IFNULL(cr.GrupoID,Entero_Cero)=Entero_Cero
				ORDER BY cr.CreditoID
			LIMIT 0, 15;
	END IF;
END IF;

-- Lista de creditos que pasaron por el Monitor de Desembolso de Credito
IF(Par_NumLis = Lis_MonitorDes) THEN
	SELECT	cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
			Pro.Descripcion
		FROM CREDITOS cr ,
			 CLIENTES c,
			 PRODUCTOSCREDITO Pro
		WHERE cr.ClienteID=c.ClienteID
			AND c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente , "%")
			AND cr.Estatus = Est_Proceso
			AND cr.PagareImpreso = PagareImpSi
			AND	cr.ProductoCreditoID = Pro.ProducCreditoID
			AND Pro.EsGrupal = CredNoGrupal
		ORDER BY cr.FechaInicio DESC
		LIMIT 0, 50;
END IF;

## Lista para los créditos que tengan Estatus Inactivo, Vigente o Vencido
IF(Par_NumLis = Lis_CredVigVencInac) THEN


	IF(IFNULL(Par_ClienteID,Entero_Cero) = Entero_Cero) THEN

		SELECT	Cr.CreditoID,	 C.ClienteID,	PC.ProducCreditoID,	C.NombreCompleto, Cr.Estatus,
				Cr.FechaInicio, Cr.FechaVencimien, Cr.CuentaID,
			(FORMAT(IFNULL(SUM(A.SaldoComFaltaPa),Entero_Cero),2)) AS ComFaltaPago,
			(FORMAT(IFNULL(SUM(A.SaldoSeguroCuota),Entero_Cero),2)) AS ComSeguroCuota,
				CASE Cr.ForCobroComAper
					WHEN ComAperturaAnt THEN (Cr.MontoComApert-Cr.ComAperPagado)
					ELSE Entero_Cero
				END AS ComAperturaCred,
					PC.Descripcion, Decimal_Cero AS ComAnualLin
				FROM	CREDITOS Cr
				LEFT JOIN CLIENTES C
				ON Cr.ClienteID = C.ClienteID
				LEFT JOIN PRODUCTOSCREDITO PC
				ON Cr.ProductoCreditoID = PC.ProducCreditoID
				LEFT JOIN AMORTICREDITO A
				ON Cr.CreditoID = A.CreditoID
				WHERE 	Cr.ClienteID=C.ClienteID
					AND	C.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
					AND (Cr.Estatus = Est_Vigente OR
						Cr.Estatus = Est_Vencido OR
						Cr.Estatus = Est_Inactivo)
					AND	Cr.ProductoCreditoID = PC.ProducCreditoID
					AND Cr.CreditoID = A.CreditoID
					AND IFNULL(Cr.GrupoID,Entero_Cero)=Entero_Cero
					AND A.Estatus <> Est_Pagado
					AND IF(A.Estatus = Est_Vencido OR A.Estatus = Est_Atrasado, A.FechaExigible <= Var_FecActual,A.FechaExigible<>Var_FecActual)
					GROUP BY Cr.CreditoID,		C.ClienteID,		PC.ProducCreditoID,		C.NombreCompleto,	 Cr.Estatus,
							 Cr.FechaInicio,	Cr.FechaVencimien, 	Cr.CuentaID,			PC.Descripcion
				   HAVING ComFaltaPago>Decimal_Cero
					OR ComSeguroCuota>Decimal_Cero
					OR	ComAperturaCred>Decimal_Cero
					ORDER BY Cr.CreditoID
					LIMIT 0, 15;
		END IF;


END IF;

## Lista para los créditos que tengan Estatus Inactivo, Vigente o Vencido
IF(Par_NumLis = Lis_CredComisiones) THEN


	IF(IFNULL(Par_NombCliente,Cadena_Vacia) = ComAperturaC) THEN

		SELECT	Cr.CreditoID,	 C.ClienteID,	PC.ProducCreditoID,	C.NombreCompleto, Cr.Estatus,
				Cr.FechaInicio, Cr.FechaVencimien, Cr.CuentaID,
			(FORMAT(IFNULL(SUM(A.SaldoComFaltaPa),Entero_Cero),2)) AS ComFaltaPago,
			(FORMAT(IFNULL(SUM(A.SaldoSeguroCuota),Entero_Cero),2)) AS ComSeguroCuota, Decimal_Cero AS ComAnualLin,
				CASE Cr.ForCobroComAper
					WHEN ComAperturaAnt THEN (Cr.MontoComApert-Cr.ComAperPagado)
					ELSE Entero_Cero
				END AS ComAperturaCred,
					PC.Descripcion
				FROM	CREDITOS Cr
				LEFT JOIN CLIENTES C
				ON Cr.ClienteID = C.ClienteID
				LEFT JOIN PRODUCTOSCREDITO PC
				ON Cr.ProductoCreditoID = PC.ProducCreditoID
				LEFT JOIN AMORTICREDITO A
				ON Cr.CreditoID = A.CreditoID
				WHERE 	Cr.ClienteID=C.ClienteID
					AND (Cr.Estatus = Est_Vigente OR
						Cr.Estatus = Est_Vencido OR
						Cr.Estatus = Est_Inactivo)
					AND	Cr.ProductoCreditoID = PC.ProducCreditoID
					AND Cr.CreditoID = A.CreditoID
					AND IFNULL(Cr.GrupoID,Entero_Cero)=Entero_Cero
					AND A.Estatus <> Est_Pagado
					GROUP BY Cr.CreditoID,		C.ClienteID,		PC.ProducCreditoID,	C.NombreCompleto,	Cr.Estatus,
							 Cr.FechaInicio,	Cr.FechaVencimien, 	Cr.CuentaID, 		PC.Descripcion
					HAVING ComAperturaCred>Decimal_Cero
					ORDER BY Cr.CreditoID;
		END IF;

		IF(IFNULL(Par_NombCliente,Cadena_Vacia) = ComSeguroCuotaC) THEN

		SELECT	Cr.CreditoID,	 C.ClienteID,	PC.ProducCreditoID,	C.NombreCompleto, Cr.Estatus,
				Cr.FechaInicio, Cr.FechaVencimien, Cr.CuentaID,
			(FORMAT(IFNULL(SUM(A.SaldoComFaltaPa),Entero_Cero),2)) AS ComFaltaPago,
			(FORMAT(IFNULL(SUM(A.SaldoSeguroCuota),Entero_Cero),2)) AS ComSeguroCuota,Decimal_Cero AS ComAnualLin,
				CASE Cr.ForCobroComAper
					WHEN ComAperturaAnt THEN (Cr.MontoComApert-Cr.ComAperPagado)
					ELSE Entero_Cero
				END AS ComAperturaCred,
					PC.Descripcion
				FROM	CREDITOS Cr
				INNER JOIN CLIENTES C
				ON Cr.ClienteID = C.ClienteID
				INNER JOIN PRODUCTOSCREDITO PC
				ON Cr.ProductoCreditoID = PC.ProducCreditoID
				INNER JOIN AMORTICREDITO A
				ON Cr.CreditoID = A.CreditoID
				WHERE 	Cr.ClienteID=C.ClienteID
					AND (Cr.Estatus = Est_Vigente OR
						Cr.Estatus = Est_Vencido OR
						Cr.Estatus = Est_Inactivo)
					AND	Cr.ProductoCreditoID = PC.ProducCreditoID
					AND Cr.CreditoID = A.CreditoID
					AND IFNULL(Cr.GrupoID,Entero_Cero)=Entero_Cero
					AND A.Estatus <> Est_Pagado
					AND A.FechaExigible <= Var_FecActual
					GROUP BY Cr.CreditoID,	 C.ClienteID,		PC.ProducCreditoID,	C.NombreCompleto,	Cr.Estatus,
							 Cr.FechaInicio, Cr.FechaVencimien, Cr.CuentaID,		PC.Descripcion
					HAVING ComSeguroCuota>Decimal_Cero
					ORDER BY Cr.CreditoID;
		END IF;

		IF(IFNULL(Par_NombCliente,Cadena_Vacia) = ComFaltaPagoC) THEN
		SET Par_NombCliente:= Cadena_Vacia;
		SELECT	Cr.CreditoID,	 C.ClienteID,	PC.ProducCreditoID,	C.NombreCompleto, Cr.Estatus,
				Cr.FechaInicio, Cr.FechaVencimien, Cr.CuentaID,
			(FORMAT(IFNULL(SUM(A.SaldoComFaltaPa),Entero_Cero),2)) AS ComFaltaPago,
			(FORMAT(IFNULL(SUM(A.SaldoSeguroCuota),Entero_Cero),2)) AS ComSeguroCuota, Decimal_Cero AS ComAnualLin,
				CASE Cr.ForCobroComAper
					WHEN ComAperturaAnt THEN (Cr.MontoComApert-Cr.ComAperPagado)
					ELSE Entero_Cero
				END AS ComAperturaCred,
					PC.Descripcion
				FROM	CREDITOS Cr
				INNER JOIN CLIENTES C
				ON Cr.ClienteID = C.ClienteID
				INNER JOIN PRODUCTOSCREDITO PC
				ON Cr.ProductoCreditoID = PC.ProducCreditoID
				INNER JOIN AMORTICREDITO A
				ON Cr.CreditoID = A.CreditoID
				WHERE 	Cr.ClienteID=C.ClienteID
					AND (Cr.Estatus = Est_Vigente OR
						Cr.Estatus = Est_Vencido OR
						Cr.Estatus = Est_Inactivo)
					AND	Cr.ProductoCreditoID = PC.ProducCreditoID
					AND Cr.CreditoID = A.CreditoID
					AND IFNULL(Cr.GrupoID,Entero_Cero)=Entero_Cero
					AND A.Estatus <> Est_Pagado
					AND A.FechaExigible <= Var_FecActual
					GROUP BY Cr.CreditoID,	 C.ClienteID,		PC.ProducCreditoID,	C.NombreCompleto, Cr.Estatus,
							 Cr.FechaInicio, Cr.FechaVencimien, Cr.CuentaID, 		PC.Descripcion
					HAVING ComFaltaPago>Decimal_Cero
					ORDER BY Cr.CreditoID;
		END IF;

		 IF(IFNULL(Par_NombCliente,Cadena_Vacia) = ComAnual) THEN
		SET Par_NombCliente:= Cadena_Vacia;

		SELECT	Cr.CreditoID,	 C.ClienteID,	PC.ProducCreditoID,	C.NombreCompleto, Cr.Estatus,
				Cr.FechaInicio, Cr.FechaVencimien, Cr.CuentaID,
			(FORMAT(IFNULL(SUM(A.SaldoComFaltaPa),Entero_Cero),2)) AS ComFaltaPago,
			(FORMAT(IFNULL(SUM(A.SaldoSeguroCuota),Entero_Cero),2)) AS ComSeguroCuota,
			(FORMAT(IFNULL(SUM(A.SaldoComisionAnual),Entero_Cero),2)) AS ComAnual, Decimal_Cero AS ComAnualLin,
				CASE Cr.ForCobroComAper
					WHEN ComAperturaAnt THEN (Cr.MontoComApert-Cr.ComAperPagado)
					ELSE Entero_Cero
				END AS ComAperturaCred,
					PC.Descripcion
				FROM	CREDITOS Cr
				INNER JOIN CLIENTES C
				ON Cr.ClienteID = C.ClienteID
				INNER JOIN PRODUCTOSCREDITO PC
				ON Cr.ProductoCreditoID = PC.ProducCreditoID
				INNER JOIN AMORTICREDITO A
				ON Cr.CreditoID = A.CreditoID
				WHERE 	Cr.ClienteID=C.ClienteID
					AND (Cr.Estatus = Est_Vigente OR
						Cr.Estatus = Est_Vencido OR
						Cr.Estatus = Est_Inactivo)
					AND	Cr.ProductoCreditoID = PC.ProducCreditoID
					AND Cr.CreditoID = A.CreditoID
					AND IFNULL(Cr.GrupoID,Entero_Cero)=Entero_Cero
					AND A.Estatus <> Est_Pagado
					AND A.FechaExigible <= Var_FecActual
					GROUP BY Cr.CreditoID,		C.ClienteID,		PC.ProducCreditoID,	C.NombreCompleto, Cr.Estatus,
							 Cr.FechaInicio, 	Cr.FechaVencimien, 	Cr.CuentaID,		PC.Descripcion
					HAVING ComAnual > 0
					ORDER BY Cr.CreditoID;
		END IF;

		-- Consulta para la comisión anual de linea de crédito
		IF(IFNULL(Par_NombCliente,Cadena_Vacia) = ComAnualLin) THEN
			SELECT Cre.CreditoID,		Cre.ClienteID,			Cre.ProductoCreditoID, Cli.NombreCompleto, 	Cre.Estatus,
				Cre.FechaInicio,		Cre.FechaVencimien, 	Cre.CuentaID, Decimal_Cero AS ComFaltaPago,
				Decimal_Cero AS ComSeguroCuota,		Decimal_Cero AS ComAnual,
				CASE WHEN Ln.TipoComAnual='P' THEN Ln.Autorizado*(Ln.ValorComAnual/100) ELSE Ln.ValorComAnual END AS ComAnualLin,
				Decimal_Cero AS ComAperturaCred, Cadena_Vacia AS Descripcion
			FROM CREDITOS Cre
			INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
			INNER JOIN LINEASCREDITO Ln ON Cre.LineaCreditoID=Ln.LineaCreditoID
				AND Ln.CobraComAnual = 'S' AND	Ln.ComisionCobrada = 'N';
		END IF;

END IF;



IF (Par_NumLis = Lis_CredGarSinFondeo) THEN
	SELECT Cli.ClienteID, 		Cli.NombreCompleto AS NombreCliente, 	Cre.CreditoID,
	Cre.MontoCredito, 			Cre.FechaMinistrado, 					Cre.TipoGarantiaFIRAID
	FROM CREDITOS Cre,CLIENTES Cli
	WHERE Cre.ClienteID = Cli.ClienteID
		AND Cre.Estatus IN (Est_Vigente)
		AND Cre.EsAgropecuario = StringSI
		AND Cre.InstitFondeoID	<> Tipo_FIRA
		AND IFNULL(Cre.EstatusGarantiaFIRA,Est_Inactivo) = Est_Inactivo
		AND Cre.FechaInicio >= Var_Fecha30Dias;
END IF;

IF(Par_NumLis = Lis_CredAgropecuarios) THEN
	SELECT cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
		pro.Descripcion
		FROM CREDITOS cr ,
			CLIENTES c,
			PRODUCTOSCREDITO pro
		WHERE cr.ClienteID=c.ClienteID
		AND c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
		AND cr.ProductoCreditoID = pro.ProducCreditoID
		AND cr.EsAgropecuario = StringSI
		ORDER BY cr.FechaInicio DESC
		LIMIT 0, 50;
END IF;

IF(Par_NumLis = Lis_CreAutPagImAgro) THEN
	SELECT	cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
			Pro.Descripcion
		FROM CREDITOS cr ,
			CLIENTES c,
			PRODUCTOSCREDITO Pro
		WHERE cr.ClienteID=c.ClienteID
			AND c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
			AND cr.Estatus IN (Est_Autorizado, Est_Vigente)
			AND cr.PagareImpreso = PagareImpSi
			AND cr.EsAgropecuario = StringSI
			AND	cr.ProductoCreditoID = Pro.ProducCreditoID
			AND Pro.EsGrupal =CredNoGrupal
		ORDER BY cr.FechaInicio DESC
		LIMIT 0, 50;
END IF;



-- Lista de creditos Vigentes o Vencidos
IF(Par_NumLis = Lis_CreVigVenciAgro) THEN
		SELECT	cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
				PC.Descripcion
			FROM	CREDITOS cr ,
					CLIENTES c,
					PRODUCTOSCREDITO PC
			WHERE 	cr.ClienteID=c.ClienteID
				AND	c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
				AND (cr.Estatus = Est_Vigente OR
					cr.Estatus = Est_Vencido )
				AND	cr.ProductoCreditoID = PC.ProducCreditoID
				AND cr.EsAgropecuario = StringSI
				ORDER BY cr.CreditoID
			LIMIT 0, 15;

END IF;

-- LISTA PARA PANTALLA CAMBIO DE FUENTE DE FONDEO
IF(Par_NumLis = Lis_CreCambioFondeador) THEN
	SELECT cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
		pro.Descripcion
		FROM CREDITOS cr ,
			CLIENTES c,
			PRODUCTOSCREDITO pro
		WHERE cr.ClienteID=c.ClienteID
			AND c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
				AND cr.ProductoCreditoID = pro.ProducCreditoID
					AND cr.EsAgropecuario = StringSI
					AND  cr.Estatus = Est_Vigente
					AND  cr.GrupoID <= Entero_Cero
		ORDER BY cr.FechaInicio DESC
		LIMIT 0, 50;
END IF;

-- Lista de creditos Vigentes o Vencidos Individuales para pantalla de Pago de Intereses con Cargo a cuenta
IF(Par_NumLis = Lis_CreReacreditados) THEN
	IF(IFNULL(Par_ClienteID,Entero_Cero) = Entero_Cero) THEN
		SELECT	cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
				PC.Descripcion
			FROM	CREDITOS cr ,
					CLIENTES c,
					PRODUCTOSCREDITO PC
			WHERE 	cr.ClienteID=c.ClienteID
				AND	c.NombreCompleto LIKE CONCAT("%", Par_NombCliente, "%")
				AND (cr.Estatus = Est_Vigente )
				AND	cr.ProductoCreditoID = PC.ProducCreditoID
				AND IFNULL(cr.GrupoID,Entero_Cero)=Entero_Cero
				AND cr.EsAgropecuario = Cons_NO
				AND cr.TipoCredito = Cons_NO
				ORDER BY cr.CreditoID
			LIMIT 0, 15;
	ELSE
		SELECT cr.CreditoID, CONCAT(CONVERT(cr.CreditoID,CHAR),'-',SUBSTRING(PC.Descripcion,1,35))
			FROM 	CREDITOS cr ,
					PRODUCTOSCREDITO PC
			WHERE 	cr.ClienteID= Par_ClienteID
				AND (cr.Estatus = Est_Vigente)
				AND cr.ProductoCreditoID = PC.ProducCreditoID
				AND IFNULL(cr.GrupoID,Entero_Cero)=Entero_Cero
				AND cr.EsAgropecuario = Cons_NO
				 AND cr.TipoCredito = Cons_NO
				ORDER BY cr.CreditoID
			LIMIT 0, 15;
	END IF;
END IF;

-- 52.- Lista de creditos Vigentes o Vencidos NO Agropecuarios
IF(Par_NumLis = Lis_CreVigVenciNOAgro) THEN
	IF(IFNULL(Par_ClienteID,Entero_Cero) = Entero_Cero) THEN
		SELECT	Cre.CreditoID,	Cli.NombreCompleto AS ClienteID, Cre.Estatus,	Cre.FechaInicio, Cre.FechaVencimien,
				Pro.Descripcion
			FROM	CREDITOS Cre,
					CLIENTES Cli,
					PRODUCTOSCREDITO Pro
			WHERE 	Cre.ClienteID = Cli.ClienteID
				AND	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
				AND Cre.Estatus IN(Est_Vigente,Est_Vencido,Est_Suspendido)
				AND	Cre.ProductoCreditoID = Pro.ProducCreditoID
				AND Cre.EsAgropecuario = StringNO
				ORDER BY Cre.CreditoID
			LIMIT 0, 15;
	ELSE
		SELECT	Cre.CreditoID,	Cli.NombreCompleto AS ClienteID, Cre.Estatus,	Cre.FechaInicio, Cre.FechaVencimien,
				Pro.Descripcion
			FROM 	CREDITOS Cre,
					CLIENTES Cli,
					PRODUCTOSCREDITO Pro
			WHERE 	Cre.ClienteID = Par_ClienteID
				AND	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
				AND Cre.Estatus IN(Est_Vigente,Est_Vencido,Est_Suspendido)
				AND Cre.ProductoCreditoID = Pro.ProducCreditoID
				AND Cre.EsAgropecuario = StringNO
				AND Cre.ClienteID = Cli.ClienteID
				ORDER BY Cre.CreditoID
			LIMIT 0, 15;
	END IF;
END IF;

IF(Par_NumLis = Lis_CreContingentes) THEN
	SELECT cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
		pro.Descripcion
		FROM CREDITOSCONT cr ,
			CLIENTES c,
			PRODUCTOSCREDITO pro
		WHERE cr.ClienteID=c.ClienteID
		AND c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
		AND cr.ProductoCreditoID = pro.ProducCreditoID
		ORDER BY cr.FechaInicio DESC
	LIMIT 0, 15;
END IF;

-- 54.- Lista Creditos Inactivos que Cobran Accesorios
IF(Par_NumLis = Lis_CreAccesorios)THEN
	SELECT cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
		Cadena_Vacia AS Descripcion
		FROM CREDITOS cr
		INNER JOIN CLIENTES c
			ON cr.ClienteID = c.ClienteID
			AND cr.Estatus = Est_Inactivo
			AND cr.CobraAccesorios = StringSI
		WHERE c.NombreCompleto	LIKE CONCAT("%", Par_NombCliente, "%")
		LIMIT 0,15;
END IF;

IF(Par_NumLis = Lis_CreGarFOGAFI) THEN

	SELECT	CR.CreditoID, CR.ClienteID,	CONCAT(CONVERT(CR.CreditoID,CHAR)," - ",PC.Descripcion,
			" - ",CONVERT(FORMAT(CR.MontoCredito,2),CHAR) ) AS Credito_Descripcion_Monto
			FROM CREDITOS CR
				INNER JOIN PRODUCTOSCREDITO PC
				ON CR.ProductoCreditoID  = PC.ProducCreditoID
				INNER JOIN DETALLEGARLIQUIDA DG
				ON CR.CreditoID = DG.CreditoID
			WHERE CR.ClienteID = Par_ClienteID
			  AND CR.ProductoCreditoID = PC.ProducCreditoID
			   AND (CR.Estatus = Est_Inactivo OR CR.Estatus = Est_Autorizado OR CR.Estatus = Est_Vigente OR CR.Estatus = Est_Vencido)
			  AND DG.RequiereGarFOGAFI = StringSI
			  AND DG.ModalidadFOGAFI = Modalidad_Anticipado
			  AND DG.FechaLiquidaFOGAFI = Fecha_Vacia;
END IF;

    -- Lista de Guarda Valores
	IF(Par_NumLis = Lis_GuardaValores) THEN
		SELECT Cre.CreditoID,	Cli.NombreCompleto,
				CASE WHEN Cre.EsAgropecuario = StringSI THEN 'CREDITO'
					 WHEN Cre.EsAgropecuario = StringNO THEN 'CREDITO AGRO'
				END TipoCredito,
				Cre.MontoCredito AS Monto,    Cre.FechaMinistrado
		FROM CREDITOS Cre
		INNER JOIN CLIENTES Cli ON Cli.ClienteID = Cre.ClienteID
		WHERE Cre.ClienteID = Cli.ClienteID
		  AND Cli.NombreCompleto LIKE CONCAT("%",Par_NombCliente,"%")
		LIMIT 0, 15;
    END IF;

	-- 57.- Numero de Listado de Credito Vigentes A Suspender de Tipo de persona Fisica con actividad empresarial
	IF(Par_NumLis = Lis_CredSuspension) THEN
		SELECT CRED.CreditoID,	CLI.NombreCompleto AS ClienteID , CRED.Estatus,	CRED.FechaInicio, CRED.FechaVencimien,
				PRO.Descripcion
			FROM CREDITOS CRED
				INNER JOIN CLIENTES CLI ON CLI.ClienteID = CRED.ClienteID
				INNER JOIN PRODUCTOSCREDITO PRO ON PRO.ProducCreditoID = CRED.ProductoCreditoID
			WHERE CLI.TipoPersona IN (Cons_TipoPersona,Cons_TipoPersonaFis)
				AND CRED.Estatus NOT IN(Est_Pagado,Est_Cancelado,Est_Inactivo,Est_Castigado,Est_Autorizado)
				AND CRED.EsAgropecuario = StringNO
				AND CLI.NombreCompleto LIKE CONCAT("%", Par_NombCliente, "%")
			LIMIT 0, 15;
	END IF;

	-- 58.- LISTA PARA PANTALLA CAMBIO DE FUENTE DE FONDEO DEL CLIENTE MEXI
	IF(Par_NumLis = Lis_CambioFuentFondCred) THEN
		SELECT cr.CreditoID,	c.NombreCompleto AS ClienteID , cr.Estatus,	cr.FechaInicio, cr.FechaVencimien,
			pro.Descripcion
			FROM CREDITOS cr
				INNER JOIN CLIENTES c ON cr.ClienteID = c.ClienteID
				INNER JOIN PRODUCTOSCREDITO pro ON cr.ProductoCreditoID = pro.ProducCreditoID
			WHERE c.NombreCompleto LIKE CONCAT("%", Par_NombCliente, "%")
				AND cr.EsAgropecuario = StringNO
				AND cr.Estatus IN (Est_Vigente,Est_Vencido,'S')
				AND cr.GrupoID = Entero_Cero
			LIMIT 0, 15;
	END IF;

	-- 59 Cartas de Liquidacion
	IF(Par_NumLis = Lis_CartaLiq) THEN
		SELECT	Cre.CreditoID,
				Cli.NombreCompleto,
				IF(Cre.Estatus=Est_Vigente,'VIGENTE','VENCIDO') AS Estatus,
				Cre.MontoCredito
			FROM CREDITOS Cre
			INNER JOIN CLIENTES Cli ON Cre.ClienteID	= Cli.ClienteID
			INNER JOIN PRODUCTOSCREDITO PCre ON Cre.ProductoCreditoID	= PCre.ProducCreditoID
			WHERE	Cre.Estatus IN(Est_Vigente, Est_Vencido)
			  AND	Cli.NombreCompleto LIKE CONCAT("%", Par_NombCliente , "%")
			LIMIT 0, 15;
	END IF;

	-- 60.- Lista de créditos de cartas de liquidación por cliente  para consolidación de cartas
	IF (Par_NumLis = Lis_ClienteCartas) THEN

		SELECT	Cliq.CreditoID,	Cli.NombreCompleto AS ClienteID , Cre.Estatus,	Cre.FechaInicio, Cre.FechaVencimien,
				PC.Descripcion
			FROM CARTALIQUIDACION AS Cliq
			INNER JOIN CLIENTES AS Cli ON Cliq.ClienteID = Cli.ClienteID
			INNER JOIN CREDITOS AS Cre ON Cre.CreditoID = Cliq.CreditoID
			INNER JOIN PRODUCTOSCREDITO PC ON Cre.ProductoCreditoID = PC.ProducCreditoID
			WHERE	Cliq.ClienteID	= Par_ClienteID
			  AND	Cliq.Estatus	= Est_Autorizado;

	END IF;

	-- 61.- Lista de creditos a los que se les puede aplicar una nota de cargo
	IF (Par_NumLis = Var_LisNotasCargo) THEN

		SELECT
			CRE.CreditoID,	CLI.NombreCompleto,	CRE.Estatus, CRE.FechaInicio,	CRE.FechaVencimien,
			PRO.Descripcion
		FROM CREDITOS CRE
			INNER JOIN PRODUCTOSCREDITO PRO ON PRO.ProducCreditoID = CRE.ProductoCreditoID
			INNER JOIN CLIENTES CLI ON CLI.ClienteID = CRE.ClienteID AND CLI.NombreCompleto LIKE CONCAT("%",Par_NombCliente, "%")
			LEFT JOIN CONVENIOSNOMINA CON ON CON.ConvenioNominaID = CRE.ConvenioNominaID
		WHERE CRE.Estatus IN ( Est_Vigente, Est_Vencido)
			AND CRE.EsAgropecuario = StringNO
			AND CRE.GrupoID = Entero_Cero
			AND CRE.LineaCreditoID = Entero_Cero
			AND (CON.ConvenioNominaID IS NULL OR (CON.ConvenioNominaID IS NOT NULL AND CON.DomiciliacionPagos = StringSI))
		LIMIT 0, 15;

	END IF;

END TerminaStore$$
