-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDCREDITOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDCREDITOREP`;
DELIMITER $$


CREATE PROCEDURE `SOLICITUDCREDITOREP`(
/* SP DE REPORTE PARA LA SOLICITUD DE CREDITO, DEPENDE DEL FORMATO DE CADA CLIENTE */
	Par_SoliCredID      BIGINT(20),   -- Numero de la Solicitud de Credito
    Par_TipoReporte     INT(11),            -- Tipo o Seccion del Reporte de Solicitud de Credito.

  /* Parametros de Auditoria */
    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)

    )

TerminaStore: BEGIN


/* Declaracion de Variables */
DECLARE Var_NombrePromotor    VARCHAR(200);
DECLARE Var_SolCreditoID      BIGINT;
DECLARE Var_ClienteID         BIGINT;
DECLARE Var_ProspectoID       BIGINT;
DECLARE Var_SucursalID        INT;
DECLARE Var_Numcliente        BIGINT;
DECLARE Var_NombreSucurs      VARCHAR(200);
DECLARE Var_NombreCli         VARCHAR(200);
DECLARE Var_NombresCli			VARCHAR(120);
DECLARE Var_ApellidoPaterno		VARCHAR(80);
DECLARE	Var_ApellidoMaterno		VARCHAR(80);
DECLARE Var_NombreCliente	  VARCHAR(200);
DECLARE Var_FecNacCli         DATE;
DECLARE Var_PaisNac           VARCHAR(200);
DECLARE Var_EstadoNac         VARCHAR(200);
DECLARE Var_CliSexo           CHAR(1);
DECLARE Var_CliGenero         VARCHAR(20);
DECLARE Var_Ocupacion         VARCHAR(1000);
DECLARE Var_ClaveNacion       CHAR(1);
DECLARE Var_CliNacion         VARCHAR(50);
DECLARE Var_ClaveEstCiv       CHAR(2);
DECLARE Var_DescriEstCiv      VARCHAR(50);
DECLARE Var_CliCURP           VARCHAR(20);
DECLARE Var_CliRFC            VARCHAR(20);
DECLARE Var_EscoCli           VARCHAR(100);
DECLARE Var_CliCalle          VARCHAR(200);
DECLARE Var_CliSolCalNum      VARCHAR(200);
DECLARE Var_CliNumInt         VARCHAR(20);
DECLARE Var_CliSolNumInt        VARCHAR(20);
DECLARE Var_CliPiso           VARCHAR(20);
DECLARE Var_CliLote           VARCHAR(20);
DECLARE Var_CliManzana        VARCHAR(100);
DECLARE Var_CliColoni         VARCHAR(400);
DECLARE Var_CliSolColonia       VARCHAR(400);
DECLARE Var_CliNumCasa        VARCHAR(20);
DECLARE Var_CliSolExtNum        VARCHAR(30);
DECLARE Var_CliMunici         VARCHAR(200);
DECLARE Var_CliSolMunici        VARCHAR(200);
DECLARE Var_CliColMun         VARCHAR(300);
DECLARE Var_CliCalNum         VARCHAR(300);
DECLARE Var_1aEntreCalle      VARCHAR(200);
DECLARE Var_2aEntreCalle      VARCHAR(200);
DECLARE Var_CliTelTra         VARCHAR(100);
DECLARE Var_CliTelPart        VARCHAR(20);
DECLARE Var_CliValorViv       DECIMAL(12,2);
DECLARE Var_CliTipViv         VARCHAR(100);
DECLARE Var_CliMatViv         VARCHAR(100);
DECLARE Var_DirTrabajo        VARCHAR(500);
DECLARE Var_CliLugTra         VARCHAR(200);
DECLARE Var_CliPuesto         VARCHAR(100);
DECLARE Var_CliAntTra         DECIMAL(12,2);
DECLARE Var_DesCliAntTra      VARCHAR(100);
DECLARE Var_MontoSolici       DECIMAL(14,2);
DECLARE Var_Finalidad         VARCHAR(500);
DECLARE Var_Tasa              DECIMAL(14,2);
DECLARE Var_DesProducto       VARCHAR(200);
DECLARE Var_Plazo             VARCHAR(100);
DECLARE Var_Moneda            VARCHAR(80);
DECLARE Var_Destino           VARCHAR(300);
DECLARE Var_DestinoDes        VARCHAR(300);
DECLARE Var_Frecuencia        VARCHAR(50);
DECLARE Var_DiasXPlazo			INT(10);
DECLARE	Var_FrecuenciaPlazo		VARCHAR(20);
DECLARE Var_TipoGarant        VARCHAR(50);
DECLARE Var_ConyPriNom        VARCHAR(100);           -- Datos del Conyugue
DECLARE Var_ConySegNom        VARCHAR(100);
DECLARE Var_ConyTerNom        VARCHAR(100);
DECLARE Var_ConyApePat        VARCHAR(100);
DECLARE Var_ConyApeMat        VARCHAR(100);
DECLARE Var_ConyFecNac        DATE;
DECLARE Var_ConyPaiNac        VARCHAR(100);
DECLARE Var_ConyEstNac        VARCHAR(100);
DECLARE Var_ConyNomEmp        VARCHAR(200);
DECLARE Var_ConyEstEmp        VARCHAR(100);
DECLARE Var_ConyMunEmp        VARCHAR(150);
DECLARE Var_ConyColEmp        VARCHAR(200);
DECLARE Var_ConyCalEmp        VARCHAR(200);
DECLARE Var_ConyNumExt        VARCHAR(20);
DECLARE Var_ConyNumInt        VARCHAR(20);
DECLARE Var_ConyNumPiso       VARCHAR(20);
DECLARE Var_ConyCodPos        VARCHAR(5);
DECLARE Var_ConyAntAnio       VARCHAR(20);
DECLARE Var_ConyAntMes        VARCHAR(20);
DECLARE Var_ConyTelTra        VARCHAR(20);
DECLARE Var_ConyTelCel        VARCHAR(20);
DECLARE Var_ConyNomCom        VARCHAR(300);
DECLARE Var_DirEmpCony        VARCHAR(300);
DECLARE Var_ConyAntTra        VARCHAR(100);
DECLARE Var_ConyOcupa         VARCHAR(350);
DECLARE Var_ConyNacion        VARCHAR(50);
DECLARE Var_ProducCredID      INT;
DECLARE Var_ClienteEdad       INT;
DECLARE Var_ConyugeEdad       INT;
DECLARE Var_NumCreditos       INT;
DECLARE Var_CicBaseCli        INT;
DECLARE Var_ClienteCiclo      INT;
DECLARE Var_NumCreTra         INT;
DECLARE Var_MonUltCred        DECIMAL(14,2);
DECLARE Var_NumDepend         INT;
DECLARE Var_NumHijos          INT;
DECLARE Var_DireClien         VARCHAR(300);
DECLARE Var_FechaAutoSol      DATE;
DECLARE Var_UsuAutoriza       VARCHAR(200);
DECLARE Var_GarantiaLiq       DECIMAL(14,2);
DECLARE Var_TipoVivienda      VARCHAR(100);
DECLARE VarTiempoHabi         INT;
DECLARE Var_NombreRef         VARCHAR(200);
DECLARE Var_DomicilioRef      VARCHAR(300);
DECLARE Var_TelefonoRef       VARCHAR(20);
DECLARE Var_TelefonoRef1      VARCHAR(20);
DECLARE Var_NombreRef2        VARCHAR(200);
DECLARE Var_DomicilioRef2     VARCHAR(300);
DECLARE Var_TelefonoRef2      VARCHAR(20);
DECLARE Var_TipoGar           VARCHAR(20);
DECLARE Var_ValorGar          DECIMAL(14,2);
DECLARE Var_FechaAvaluo       DATE;
DECLARE Var_AvalID            INT;
DECLARE Var_CreditoID         BIGINT(12);
DECLARE Fecha_Sis             DATE;
DECLARE Var_DirTra            VARCHAR(300);
DECLARE Var_NombreSucur       VARCHAR(100);
DECLARE Var_DirSucur          VARCHAR(500);
DECLARE Var_EstadoSuc         VARCHAR(100);
DECLARE Var_Fecha             VARCHAR(200);
DECLARE Var_Mes               VARCHAR(10);
DECLARE Var_ClienteConyID     INT;
DECLARE Var_TipoGarantiaID    INT;
DECLARE Var_Empleado      	  VARCHAR(20);
DECLARE Var_CliEstado         VARCHAR(200);
DECLARE Var_Restructura       CHAR(1);
DECLARE Var_MontoRenta        DECIMAL(12,2);
DECLARE Var_ExtTelTra         VARCHAR(7);
DECLARE Var_AvaNombre         VARCHAR(150);
DECLARE Var_AvaColonia        VARCHAR(200);
DECLARE Var_AvaEstado         VARCHAR(200);
DECLARE Var_AvaCP             VARCHAR(7);
DECLARE Var_AvaDir        	  VARCHAR(300);
DECLARE Var_AvaCiudad     	  VARCHAR(150);
DECLARE Var_DescVivienda      VARCHAR(500);
DECLARE Var_CliSegmento       VARCHAR(100);
DECLARE Var_AvalCliID         INT (11);
DECLARE Var_AvalProsID        INT (11);
DECLARE Var_TipoPersona		  CHAR(1);
DECLARE Var_NoCtaRefCom		  VARCHAR(50);
DECLARE Var_NoCtaRefCom2	  VARCHAR(50);
DECLARE Var_DirRefCom		  VARCHAR(500);
DECLARE Var_DirRefCom2		  VARCHAR(500);
DECLARE Var_TipCtaRefBan	  VARCHAR(50);
DECLARE Var_TipCtaRefBan2	  VARCHAR(50);
DECLARE Var_SucRefBan		  VARCHAR(50);
DECLARE Var_SucRefBan2		  VARCHAR(50);
DECLARE Var_NoTarRefBan		  VARCHAR(50);
DECLARE Var_NoTarRefBan2	  VARCHAR(50);
DECLARE Var_TarInRefBan		  VARCHAR(50);
DECLARE Var_TarInRefBan2	  VARCHAR(50);
DECLARE Var_CreOtraEnRefBan	  CHAR(1);
DECLARE Var_CreOtraEnRefBan2  CHAR(1);
DECLARE Var_InsOtraEnRefBan	  VARCHAR(50);
DECLARE Var_InsOtraEnRefBan2  VARCHAR(50);

/*Fin social*/
DECLARE Var_EsGrupalFinS    	CHAR(1);
DECLARE Var_DescPlaFinS     	VARCHAR(100);
DECLARE Var_NombresCliFinS		VARCHAR(100);
DECLARE Var_ApellCliPFinS   	VARCHAR(100);
DECLARE Var_ApellCliMFinS   	VARCHAR(100);
DECLARE Var_EstadoCivilFinS 	VARCHAR(100);
DECLARE Var_ClienteIDFinS   	BIGINT;
DECLARE Var_DesProductoFinS 	VARCHAR(200);
DECLARE Var_CliCURPFinS     	VARCHAR(20);
DECLARE Var_CliRFCFinS      	VARCHAR(20);
DECLARE Var_CliNacionFinS   	VARCHAR(50);
DECLARE Var_CliGeneroFinS   	VARCHAR(20);
DECLARE Var_CliCorreoFinS   	VARCHAR(60);
DECLARE Var_OcupacionFinS   	VARCHAR(1000);
DECLARE Var_FechNFinS     		DATE;
DECLARE Var_ClienteIDCFinS  	VARCHAR(12);
DECLARE Var_EmplFormFinS    	CHAR(1);
DECLARE Var_IngresDeclaFinS 	DECIMAL(18,2);
DECLARE Var_GastosDeclaFinS 	DECIMAL(18,2);
DECLARE Var_CliCalleFinS    	VARCHAR(200);
DECLARE Var_CliNumCasaFinS  	VARCHAR(20);
DECLARE Var_CliColoniFinS   	VARCHAR(400);
DECLARE Var_CliColMunFinS   	VARCHAR(300);
DECLARE Var_CliEstadoFinS   	VARCHAR(200);
DECLARE Var_CliCPFinS     		CHAR(10);
DECLARE Var_CliNumIntFinS   	VARCHAR(20);
DECLARE Var_CliCiudadFinS   	VARCHAR(100);
DECLARE Var_CliTelCasaFinS  	VARCHAR(20);
DECLARE Var_CliTelCelFinS  		VARCHAR(30);
DECLARE Var_TipoVivIIDFinS  	INT;
DECLARE Var_TiemHabiDomFinS   	INT;
DECLARE Var_CreditoIDFinS     	BIGINT(12);
DECLARE Var_FechaCorteFinS    	DATE;
DECLARE Var_DestinoCred     	INT;
DECLARE Var_DescripDestFinS   	VARCHAR(500);
DECLARE Var_MontoAutorFinS    	DECIMAL(12,2);
DECLARE Var_MontoSoliciFinS   	DECIMAL(12,2);
DECLARE Var_ComApertFinS    	DECIMAL(12,2);
DECLARE Var_FinSoTotPagar   	DECIMAL(14,2);
DECLARE Var_FinSCuotaPagar    	DECIMAL(14,2);
DECLARE Var_NombreCortInstFiSoC VARCHAR(45);
DECLARE Var_TipoFondeoFinS    	CHAR(1);
DECLARE Var_CuentaIDFinS    	BIGINT(12);
DECLARE Var_MesesFinS     		INT(11);
DECLARE Var_AniosFinS     		INT(11);
DECLARE Var_NomComCliFinS   	VARCHAR(200);
DECLARE Var_PEPsFinS      		CHAR(1);
DECLARE Var_DesPuesTPEPFinS   	VARCHAR(150);
DECLARE Var_ParentPEPSFinS    	CHAR(1);
DECLARE Var_RegisRecaFinS   	VARCHAR(100);
DECLARE Var_FechaDesemFinS    	DATE;
DECLARE Var_IngresNegoFins    	DECIMAL(14,2);
DECLARE Var_GastosNegoFinS    	DECIMAL(14,2);
DECLARE Var_OtrosGastoFinS    	DECIMAL(14,2);
DECLARE Var_OtrosIngreFinS    	DECIMAL(14,2);
DECLARE Var_LugarTrabjFinS    	VARCHAR(100);
DECLARE Var_NumIdeIFEFinS   	VARCHAR(30);
DECLARE Var_FecConBuFinSoc    	DATE;
DECLARE Var_FolConBuFinSoc    	VARCHAR(30);
DECLARE Var_IDConsulFinSoc    	VARCHAR(20);
DECLARE Var_ConseFirmaCFinS   	INT(11);
DECLARE Var_RecurFirmCFinS    	VARCHAR(100);
DECLARE Var_DescripSolFinS    	VARCHAR(50);
DECLARE Var_RecursoPFinSoc    	VARCHAR(10);
DECLARE Var_InstFondFinS    	INT;
DECLARE DescNacional      		VARCHAR(11);
DECLARE DescExtranjero      	VARCHAR(11);

/* ---------- PLAN IDEAL  ---------- */
DECLARE Var_MontoCuota      	VARCHAR(20);
DECLARE Var_NumAmortiza     	INT;
DECLARE Var_ValorCAT      		VARCHAR(10);
DECLARE Var_RegRECA       		VARCHAR(100);
DECLARE Var_FactorMora      	VARCHAR(10);
DECLARE Var_NomInstitu      	VARCHAR(100);
DECLARE Var_NomCortoIns     	VARCHAR(50);
DECLARE Var_ApePaterno      	VARCHAR(50);
DECLARE Var_ApeMaterno      	VARCHAR(50);
DECLARE Var_CliCorreo       	VARCHAR(60);
DECLARE Var_CliTelCel     		VARCHAR(30);
DECLARE Var_CliCiudad     		VARCHAR(100);
DECLARE Var_CliCP       		CHAR(10);
DECLARE Var_CliFechaNac     	VARCHAR(40);
DECLARE Var_CliNomCompl     	VARCHAR(100);
DECLARE Var_InstitNomina    	VARCHAR(200);
DECLARE Var_CalleTra      		VARCHAR(100);
DECLARE Var_ColTra        		VARCHAR(100);
DECLARE Var_CiudadTra     		VARCHAR(35);
DECLARE Var_MuniTra       		VARCHAR(100);
DECLARE Var_EstadoTra     		VARCHAR(100);
DECLARE Var_CPTra       		VARCHAR(10);
DECLARE Var_Ingresos      		VARCHAR(20);
DECLARE Var_ExtRef        		VARCHAR(10);
DECLARE Var_ExtRef2       		VARCHAR(10);
DECLARE Var_Relacion      		VARCHAR(35);
DECLARE Var_Relacion2     		VARCHAR(35);
DECLARE Var_CalcAntiguedad    	CHAR(1);
/* ---------- FIN PLAN I    DEAL  ---------- */

/* Declaracion de Constantes */
DECLARE Fecha_Vacia         	DATE;
DECLARE Decimal_Cero        	DECIMAL(12,2);
DECLARE Entero_Cero         	INT;
DECLARE Cadena_Vacia        	CHAR(1);
DECLARE Seccion_General     	INT;
DECLARE Seccion_EconoIng    	INT;
DECLARE Seccion_EconoEgr      	INT;
DECLARE Seccion_DepEcono      	INT;
DECLARE Seccion_Avales        	INT;
DECLARE Seccion_Garant        	INT;
DECLARE Seccion_GarantAsefimex  INT(11);
DECLARE Seccion_Refere        	INT;
DECLARE Seccion_Benefi        	INT;
DECLARE Seccion_Cuenta        	INT;
DECLARE Seccion_Inversion     	INT;
DECLARE TipoRep_Yanga         	INT;
DECLARE TipoRep_YangaAutor    	INT;
DECLARE TipoRep_FinSocial     	INT;
DECLARE Con_SoliCredito     	INT;
DECLARE TipoRep_TuLanita    	INT;
DECLARE Si_Requiere         	CHAR(1);
DECLARE Es_Beneficiario     	CHAR(1);
DECLARE Tipo_Ingreso        	CHAR(1);
DECLARE Tipo_Egreso         	CHAR(1);
DECLARE Est_Vigente         	CHAR(1);
DECLARE Ava_Autorizado      	CHAR(1);
DECLARE Gar_Autorizado      	CHAR(1);
DECLARE Cue_Activa          	CHAR(1);
DECLARE Rel_Hijo            	INT;
DECLARE Est_Pagado          	CHAR(1);
DECLARE Gen_Masculino       	CHAR(1);
DECLARE Gen_Femenino        	CHAR(1);
DECLARE Des_Masculino       	VARCHAR(20);
DECLARE Des_Femenino        	VARCHAR(20);
DECLARE Nac_Mexicano        	CHAR(1);
DECLARE Nac_Extranjero      	CHAR(1);
DECLARE Des_Mexicano        	VARCHAR(20);
DECLARE Des_Extranjero      	VARCHAR(20);
DECLARE Est_Soltero         	CHAR(2);
DECLARE Est_CasBieSep       	CHAR(2);
DECLARE Est_CasBieMan       	CHAR(2);
DECLARE Est_CasCapitu       	CHAR(2);
DECLARE Est_Viudo           	CHAR(2);
DECLARE Est_Divorciad       	CHAR(2);
DECLARE Est_Seperados       	CHAR(2);
DECLARE Est_UnionLibre      	CHAR(2);
DECLARE Dir_Oficial         	CHAR(1);
DECLARE Dir_Trabajo         	INT;
DECLARE Des_Soltero         	CHAR(50);
DECLARE Des_CasBieSep       	CHAR(50);
DECLARE Des_CasBieMan       	CHAR(50);
DECLARE Des_CasCapitu       	CHAR(50);
DECLARE Des_Viudo           	CHAR(50);
DECLARE Des_Divorciad       	CHAR(50);
DECLARE Des_Seperados       	CHAR(50);
DECLARE Des_UnionLibre      	CHAR(50);
DECLARE TipoDirTrab         	INT;
DECLARE TipoDirCasa         	INT;
DECLARE RepYangaDatCte      	INT;
DECLARE RepYangaDatCony     	INT;
DECLARE SI                  	CHAR(1);
DECLARE esOficial         		CHAR(1);
DECLARE TipoLinaNeg       		INT(11);
DECLARE Var_IngresoMensual    	DECIMAL(14,2);
DECLARE Var_TipoRelacion1     	VARCHAR(50);
DECLARE Var_TipoRelacion2     	VARCHAR(50);
DECLARE Inv_Vigente      		CHAR(1);
DECLARE Ava_Asignado      		CHAR(1);
DECLARE Meses_Anio        		INT(11);
DECLARE Var_SI          		CHAR(1);
DECLARE Var_NO          		CHAR(1);
DECLARE Es_Cliente          	CHAR(1);
DECLARE NoPaisMexi          	CHAR(3);
DECLARE NomMexico           	VARCHAR(10);
DECLARE Var_PaisInsuf			INT(11);
DECLARE Tipo_Accionista			INT(11);


/* ---------- SANA TUS F    INANZAS ---------- */
DECLARE TipoSolCredSTF      	INT;
DECLARE TipoSolCredSTF2     	INT;
DECLARE Var_PaiResi       		VARCHAR(20);
DECLARE Var_BanRef        		VARCHAR(20);
DECLARE Var_NoCuenRef     		VARCHAR(20);
DECLARE Var_ProcRecurso     	VARCHAR(20);
DECLARE Var_IngMens       		INT (11);
DECLARE Var_DestRec       		VARCHAR(300);
DECLARE Var_DiasAnio        	INT;
DECLARE Var_ValUno          	INT;
DECLARE Var_TipoViviendaID    	INT(11);
DECLARE Var_NombreLoc     		VARCHAR(200);
/* ---------- FIN SANA TUS FINANZAS ---------- */

/* ---------- SOFIEXPRESS  ---------- */
DECLARE TipoRep_SofiExp     	INT(11);
DECLARE Prom_Nombre       		VARCHAR(300);
DECLARE Sol_Disposi       		VARCHAR(100);
DECLARE Sol_FechaAut      		VARCHAR(100);
DECLARE Sol_FechaResult     	VARCHAR(100);
DECLARE Sol_Proyecto      		VARCHAR(500);
DECLARE Sol_MontoAut      		DECIMAL(14,2);
DECLARE Sol_MontoSol      		DECIMAL(14,2);
DECLARE Cli_AntigClie     		VARCHAR(100);
DECLARE Cli_Edad        		VARCHAR(100);
DECLARE ConyDirTrabCalle    	VARCHAR(50);
DECLARE ConyDirTrabNum      	VARCHAR(10);
DECLARE ConyDirTrabCol      	VARCHAR(200);
DECLARE ConyTrabAntigu      	VARCHAR(200);
DECLARE ConyTrabTel       		VARCHAR(200);
DECLARE ConyTrabPuesto      	VARCHAR(200);
DECLARE Cli_EsDepend      		CHAR(1);
DECLARE Cli_RepLegal      		VARCHAR(250);
DECLARE Cli_ActBMX        		VARCHAR(200);
DECLARE Var_Dia         		VARCHAR(2);
DECLARE Var_Anio        		VARCHAR(10);
DECLARE Var_BancoRef      		VARCHAR(100);
DECLARE Var_BancoRef2     		VARCHAR(100);
DECLARE Var_NoCtaRef      		VARCHAR(100);
DECLARE Var_NoCtaRef2     		VARCHAR(100);
DECLARE Var_NomRefCom     		VARCHAR(100);
DECLARE Var_TelRefCom     		VARCHAR(30);
DECLARE Var_NomRefCom2      	VARCHAR(100);
DECLARE Var_TelRefCom2      	VARCHAR(30);
DECLARE Cli_SectorGral      	VARCHAR(100);
DECLARE Cli_AntigTra      		VARCHAR(100);
DECLARE Cli_TipoPers      		CHAR(5);
DECLARE Cli_TrabNumExt      	VARCHAR(20);
DECLARE SE_IngOtros       		DECIMAL(12,2);
DECLARE SE_IngDesOtro     		VARCHAR(200);
DECLARE SE_EgrCasa        		DECIMAL(12,2);
DECLARE SE_EgrGastoFa     		DECIMAL(12,2);
DECLARE SE_EgrOtros       		DECIMAL(12,2);
DECLARE SE_EgrDesOtr      		VARCHAR(200);
DECLARE SDV_TipoDom       		VARCHAR(200);
DECLARE SDV_ValorViv      		DECIMAL(14,2);
DECLARE Gar_Observ        		VARCHAR(1200);
DECLARE Cli_FechNacD      		VARCHAR(10);
DECLARE Cli_FechNacM      		VARCHAR(10);
DECLARE Cli_FechNacA      		VARCHAR(10);
DECLARE Var_CliCalle2     		VARCHAR(200);
DECLARE Var_CliNumCasa2     	VARCHAR(20);
DECLARE Var_CliColoni2      	VARCHAR(200);
DECLARE Var_CliColMun2      	VARCHAR(300);
DECLARE Var_CliEstado2      	VARCHAR(200);
DECLARE Var_CliCP2        		VARCHAR(10);
DECLARE ConyAntiguAnios     	VARCHAR(200);
DECLARE ConyAntiguMeses     	VARCHAR(200);
DECLARE Var_TmpHabiDes      	VARCHAR(200);
DECLARE Var_SucMun        		VARCHAR(200);
DECLARE Var_PaisID				INT(11);
DECLARE Var_EstadoID			INT(11);
DECLARE Var_NomPais				VARCHAR(150);
DECLARE Var_NomEstado			VARCHAR(100);
DECLARE Var_FEA					VARCHAR(250);
/* ---------- FIN SOFIEXPRESS ---------- */

/*------------ FEMAZA -------------------*/
DECLARE Var_NombreInstitucion 	VARCHAR(100);
DECLARE Var_DirecCompletSuc		VARCHAR(900);
DECLARE	Var_DirecSucursal		VARCHAR(300);
/*------------ FEMAZA -------------------*/

/*----------ALTERNATIVA 19----------------*/
DECLARE Var_NomDependiente		VARCHAR(200);
DECLARE Var_ApPaternoDep		VARCHAR(50);
DECLARE Var_ApMaternoDep		VARCHAR(50);
DECLARE Var_TipoRelDep			VARCHAR(50);
DECLARE Var_NumDependientes		INT(11);
DECLARE Var_TieneDep			CHAR(1);
DECLARE Var_TieneHijos			CHAR(1);
DECLARE Var_OtrosIngresos		INT(11);
DECLARE Var_OtrosIng			CHAR(1);
DECLARE Var_GarCliente			INT(11);
DECLARE Var_GarAval				INT(11);
DECLARE Var_GarProspecto		INT(11);
DECLARE Var_GarGarante			INT(11);
DECLARE Var_TipoGarantia		INT(11);
DECLARE Var_EsReal				CHAR(1);
DECLARE Valor_Garantia			CHAR(1);
DECLARE Var_FecConBuAlt    		DATE;
DECLARE Var_FolConBuAlt    		VARCHAR(30);
DECLARE Var_ClasProd			CHAR(1);
DECLARE Var_DestCred			CHAR(1);
DECLARE Var_TotalIngresoMens	DECIMAL(14,2);
DECLARE Var_MontoTotalIngFam	VARCHAR(50);
DECLARE Var_MontoTotalIngNeg	VARCHAR(50);

-- Variables Financiera ZAFY

DECLARE Var_MontoSolCred		VARCHAR(50);
DECLARE Var_Renta				VARCHAR(50);
DECLARE Var_GastosMensuales		VARCHAR(50);
DECLARE Var_NomRefFam1			VARCHAR(250);
DECLARE Var_NomRefFam2			VARCHAR(250);
DECLARE Var_NomRefPersonal		VARCHAR(250);
DECLARE Var_NomRefLaboral		VARCHAR(250);
DECLARE Var_TipoRelFam1			VARCHAR(50);
DECLARE Var_TipoRelFam2			VARCHAR(50);
DECLARE Var_TipoRelPer			VARCHAR(50);
DECLARE Var_TipoRelLab			VARCHAR(50);
DECLARE Var_TelRefFam1			VARCHAR(20);
DECLARE Var_TelRefFam2			VARCHAR(20);
DECLARE Var_TelRefPer			VARCHAR(20);
DECLARE Var_TelRefLab			VARCHAR(20);
DECLARE Var_DirRefFam1			VARCHAR(500);
DECLARE Var_DirRefFam2			VARCHAR(500);
DECLARE Var_DirRefPer			VARCHAR(500);
DECLARE Var_DirRefLab			VARCHAR(500);
DECLARE Var_NoEmpleado			VARCHAR(20);
DECLARE Var_DifMeses			INT(11);
DECLARE Var_FechaMinis			DATE;
DECLARE Var_FechaRegistro		DATE;
DECLARE Var_Creditos			CHAR(1);
DECLARE Var_EsNomina			CHAR(1);
-- Variable asefimex solicitud perosna moral
DECLARE Var_CodPostal			VARCHAR(10);
DECLARE Var_DescripDir			VARCHAR(100);
DECLARE Var_RazonSocial			VARCHAR(100);
DECLARE Var_giroCom				VARCHAR(100);
DECLARE Var_FuenteIng			VARCHAR(100);
DECLARE Var_PaisResidencia 		VARCHAR(100);

DECLARE Var_NomFamiliar			VARCHAR(50); 
DECLARE Var_APaternoFam			VARCHAR(50); 
DECLARE Var_AMaternoFam			VARCHAR(50); 
DECLARE Var_OcupacionFam		VARCHAR(150);	
DECLARE Var_PerCarFam			VARCHAR(100);	
DECLARE Var_PerCargoFam			VARCHAR(100);

DECLARE Var_DirPrimerNom		VARCHAR(150);
DECLARE Var_DirApellioPat		VARCHAR(50);
DECLARE Var_DirApellidoMat		VARCHAR(50);
DECLARE Var_DirFechaNac			DATE;
DECLARE Var_Dir_Sexo			VARCHAR(50);
DECLARE Var_DirCurp				VARCHAR(18);
DECLARE Var_DirRfc				VARCHAR(13);
DECLARE Var_DirFea				VARCHAR(250);
DECLARE Var_Dir_EstCivil		VARCHAR(50);
DECLARE Var_Dir_Puesto			VARCHAR(100);
DECLARE Var_DirOcupa			TEXT;
DECLARE Var_DirEstado			VARCHAR(50);
DECLARE Var_DirMunic			VARCHAR(50);
DECLARE Var_DirPais				VARCHAR(50);
DECLARE Var_DirCP				VARCHAR(5);
DECLARE Var_DirDomicilio		VARCHAR(200);
DECLARE	Var_DirTelCas			VARCHAR(20);
DECLARE	Var_DirTelCel			VARCHAR(20);
DECLARE Var_DirEdad				VARCHAR(5);

DECLARE Var_M					CHAR(1);
DECLARE Var_F					CHAR(1);
DECLARE Var_SexoM				VARCHAR(20);
DECLARE Var_SexoF				VARCHAR(20);
DECLARE Var_CP                  VARCHAR(15);
DECLARE Var_EstadoDirect        VARCHAR(80);
DECLARE Var_SolEstadoID         INT(11);
DECLARE Var_TelefonoCelular     VARCHAR(20);
DECLARE Var_NumeroIdent         VARCHAR(40);
DECLARE Var_ActividadBMXDesc    VARCHAR(150);
DECLARE Var_EmpresaLabora       VARCHAR(150);

DECLARE Con_TipoIdentiINE       INT(11);
DECLARE Var_ViviendaDesc        VARCHAR(500);
DECLARE Var_TiempoHabitarDom    INT(11);
DECLARE Var_HorarioVeri         VARCHAR(20);
DECLARE Var_NoEmpleados         VARCHAR(25);
DECLARE Var_NoCuentaRef         VARCHAR(25);
DECLARE Var_BanNoTarjetaRef     VARCHAR(25);

DECLARE Var_NomPeps         VARCHAR(150); 
DECLARE Var_ApePatPeps      VARCHAR(100); 
DECLARE Var_ApeMatPeps      VARCHAR(100); 
DECLARE Var_FechNacPeps     VARCHAR(100); 
DECLARE Var_REFcPeps        VARCHAR(100); 
DECLARE Var_PaisPeps        VARCHAR(100); 
DECLARE Var_OcupPeps        VARCHAR(100); 
DECLARE Var_PeriodIni       VARCHAR(100); 
DECLARE Var_PeridoFin       VARCHAR(100);
DECLARE Var_NumAvales       INT(11);

--  Declaracion de constante
DECLARE     mes1        CHAR(1);
DECLARE     mes2        CHAR(1);
DECLARE     mes3        CHAR(1);
DECLARE     mes4        CHAR(1);
DECLARE     mes5        CHAR(1);
DECLARE     mes6        CHAR(1);
DECLARE     mes7        CHAR(1);
DECLARE     mes8        CHAR(1);
DECLARE     mes9        CHAR(1);
DECLARE     mes10       CHAR(2);
DECLARE     mes11       CHAR(2);
DECLARE     mes12       CHAR(2);

DECLARE TxtEnero        VARCHAR(20);
DECLARE TxtFebrero      VARCHAR(20);
DECLARE TxtMarzo        VARCHAR(20);
DECLARE TxtAbril        VARCHAR(20);
DECLARE TxtMayo         VARCHAR(20);
DECLARE TxtJunio        VARCHAR(20);
DECLARE TxtJulio        VARCHAR(20);
DECLARE TxtAgosto       VARCHAR(20);
DECLARE TxtSeptiembre   VARCHAR(20);
DECLARE TxtOctubre      VARCHAR(20);
DECLARE TxtNoviembre    VARCHAR(20);
DECLARE TxtDiciembre    VARCHAR(20);
DECLARE DescRecursoP    VARCHAR(10);
DECLARE DescRecursoT    VARCHAR(10);

DECLARE FrecSemanal       	CHAR;
DECLARE FrecCatorcenal      CHAR;
DECLARE FrecLibre       	CHAR;
DECLARE FrecQuincenal     	CHAR;
DECLARE FrecMensual       	CHAR;
DECLARE FrecPeriodica     	CHAR;
DECLARE FrecBimestral     	CHAR;
DECLARE FrecTrimestral      CHAR;
DECLARE FrecTetramestral	CHAR;
DECLARE FrecSemestral     	CHAR;
DECLARE FrecAnual       	CHAR;
DECLARE FrecUnico       	CHAR;
DECLARE FrecDecenal       	CHAR;
DECLARE TxtSemanal        	VARCHAR(20);
DECLARE TxtCatorcenal     	VARCHAR(20);
DECLARE TxtQuincenal      	VARCHAR(20);
DECLARE TxtMensual        	VARCHAR(20);
DECLARE TxtPeriodica      	VARCHAR(20);
DECLARE TxtBimestral      	VARCHAR(20);
DECLARE TxtTrimestral     	VARCHAR(20);
DECLARE TxtTetramestral		VARCHAR(20);
DECLARE TxtSemestral      	VARCHAR(20);
DECLARE TxtAnual        	VARCHAR(20);
DECLARE TxtDecenal        	VARCHAR(20);
DECLARE TxtLibres       	VARCHAR(20);
DECLARE TxtUnico        	VARCHAR(40);

-- Alternativa 19

DECLARE Tipo_Alternativa      	INT;
DECLARE Sec_DepAlternativa		INT;
DECLARE Seccion_AvalesAlt		INT;
DECLARE Tipo_IdfElector			INT;
DECLARE Sec_RefAlternativa		INT;
DECLARE Seccion_EgrNegAlt		INT;
DECLARE Seccion_EgrFamAlt		INT;
DECLARE Consumo					CHAR(1);
DECLARE Sec_GarAlternativa		INT(11);
DECLARE OtrosIngresos			INT(11);
DECLARE Presidente				CHAR(10);
DECLARE Tesorero				CHAR(8);
DECLARE Secretario				CHAR(10);
DECLARE Integrante				CHAR(10);
DECLARE Hipotecaria				CHAR(1);
DECLARE GReal					CHAR(1);
DECLARE GOblSolidario			CHAR(1);
DECLARE Habilitacion			CHAR(1);
DECLARE Refaccionario			CHAR(1);
DECLARE GarInmobiliaria			INT(11);

-- Financiera ZAFY

DECLARE Tipo_Zafy               INT(11);
DECLARE ReferenciasZafy			INT(11);
DECLARE Seccion_AvalesAsefimex  INT(11);
DECLARE TxtSemanales			VARCHAR(20);
DECLARE TxtCatorcenales			VARCHAR(20);
DECLARE TxtQuincenales			VARCHAR(20);
DECLARE TxtMensuales			VARCHAR(20);
DECLARE TxtBimestrales			VARCHAR(20);
DECLARE TxtTrimestrales			VARCHAR(20);
DECLARE TxtTetramestrales		VARCHAR(20);
DECLARE TxtSemestrales			VARCHAR(20);
DECLARE TxtAnuales				VARCHAR(20);
DECLARE TxtDecenales			VARCHAR(20);
DECLARE TxtPeriodico			VARCHAR(20);
DECLARE Propia					CHAR(1);
DECLARE Familiar				CHAR(1);
DECLARE Rentada					CHAR(1);
DECLARE Otro					CHAR(1);
DECLARE PersonaMoral			CHAR(1);
DECLARE Egresos					CHAR(1);
DECLARE ActaPoderes				CHAR(1);

DECLARE Seccion_GeneralMoral	INT(11);
DECLARE Tipo_PEPs				INT(11);
DECLARE Seccion_Interesado      INT(11);

-- Asigancion de Constantes
SET Fecha_Vacia         := '1900-01-01';            -- Fecha Vacia
SET Decimal_Cero        := 0.0;                     -- Decimal en Cero
SET Entero_Cero         := 0;                       -- Entero en Cero
SET Cadena_Vacia        := '';                      -- String o Cadena Vacia
SET Seccion_General     := 1;                       -- Seccion Gral, Cliente, Solicitud
SET Seccion_EconoIng    := 2;                       -- Seccion Economica del Cliente Ingreso
SET Seccion_EconoEgr    := 3;                       -- Seccion Economica del Cliente Egreso
SET Seccion_DepEcono    := 4;                       -- Seccion Dependientes Economicos del Cliente
SET Seccion_Avales      := 5;                       -- Seccion Avales
SET Seccion_Garant      := 6;                       -- Seccion Garantia
SET Seccion_Refere      := 7;                       -- Seccion Referencias Personales
SET Seccion_Benefi      := 8;                       -- Seccion Beneficiarios
SET TipoRep_Yanga       := 9;                       -- Reporte Personalizado para Yanga
SET TipoRep_YangaAutor  := 10;            -- Reporte Personalizado para Yanga Autentificacion de firma
SET RepYangaDatCte    	:= 11;            -- Reporte Datos del Cliente para Yanga
SET RepYangaDatCony   	:= 12;            -- Reporte Datos del Conyuge para Yanga
SET Seccion_Cuenta      := 13;                      -- Seccion Haberes Socios(Cuenta)
SET Seccion_Inversion   := 14;                      -- Seccion Haberes Socios(Inversion)
SET Con_SoliCredito     := 15;                      -- Adaptacion del reporte de pagare para plan ideal
SET TipoRep_TuLanita  	:= 16;            -- Reporte personalizado para Tu Lanita Rapida
SET TipoSolCredSTF    	:= 17;            -- Reporte para Solicitud de Credito para SANA TUS FINANZAS (1era Hoja)
SET TipoSolCredSTF2   	:= 18;            -- Reporte para Solicitud de Credito para SANA TUS FINANZAS (2da Hoja)
SET TipoRep_SofiExp   	:= 19;            -- Reporte para SOFIEXPRESS
SET TipoRep_FinSocial 	:= 20;            -- Reporte para FinSocial
SET Var_DiasAnio        := 365;           -- Numero de dias año
SET Var_ValUno          := 1;           -- Valor del numero uno
SET Tipo_Alternativa	:= 21;			-- Reporte Personalizado Alternativa 19
SET Sec_DepAlternativa	:= 22;			-- Seccion Dependientes Economicos Alternativa 19
SET Seccion_AvalesAlt	:= 23;			-- Seccion Avales Alternativa 19
SET Sec_RefAlternativa	:= 24;			-- Seccion Referencias Alternativa 19
SET Seccion_EgrNegAlt	:= 25;			-- Seccion Datos Socioeconomicos(Egresos del Negocio) Alternativa 19
SET Seccion_EgrFamAlt	:= 26;			-- Seccion Datos Socioeconomicos(Egresos Familiares) Alternativa 19
SET Sec_GarAlternativa	:= 27;			-- Seccion Garantias Alternativa 19
SET Tipo_Zafy           := 29;          -- Reporte Personalizado Financiera Zafy
SET ReferenciasZafy		:= 30;			-- Sección Referencias Zafy
SET Seccion_AvalesAsefimex  := 31;      -- Avales Asefimex
SET Seccion_GarantAsefimex  := 32;      -- Garante Asefimex
SET Tipo_PEPs				:= 33;
SET Seccion_GeneralMoral 	:= 34;
SET Tipo_Accionista			:= 35;
SET Seccion_Interesado := 36;
SET Si_Requiere         := 'S';                     -- Si Rquiere Garantia
SET Es_Beneficiario     := 'S';                     -- La Relacion es de Beneficiario
SET Tipo_Ingreso        := 'I';                     -- Tipo de Dato SocioEconomico: Ingreso
SET Tipo_Egreso         := 'E';                     -- Tipo de Dato SocioEconomico: Engreso
SET Gen_Masculino       := 'M';                     -- Genero: Masculino
SET Gen_Femenino        := 'F';                     -- Genero: Femenino
SET Des_Masculino       := 'MASCULINO';             -- Descripcion Genero: Masculino
SET Des_Femenino        := 'FEMENINO';              -- Descripcion Genero: Femenino
SET Nac_Mexicano        := 'N';           -- Nacionalidad: N.- Nacional - Mexicano
SET Nac_Extranjero      := 'E';                     -- Nacionalidad: E.- Nacional - Extranjero
SET Des_Mexicano        := 'MEXICANA';              -- Nacionalidad: Mexicana
SET Des_Extranjero      := 'EXTRANJERA';            -- Nacionalidad: Extranjera
SET Est_Vigente         := 'V';                     -- Estatus del Credito Vigente
SET Est_Pagado          := 'P';                     -- Estatus del Credito Pagado
SET Ava_Autorizado      := 'U';                     -- Estatus del Aval: Autorizado
SET Gar_Autorizado      := 'U';                     -- Asignacion de Garantia: Autorizado
SET Cue_Activa          := 'A';                     -- Estatus de la Cuenta Activa
SET Rel_Hijo            := 3;                       -- Tipo de Relacion: Hijo

SET Est_Soltero       := 'S';        -- Estado Civil Soltero
SET Est_CasBieSep     := 'CS';       -- Casado Bienes Separados
SET Est_CasBieMan     := 'CM';       -- Casado Bienes Mancomunados
SET Est_CasCapitu     := 'CC';       -- Casado Bienes Mancomunados Con Capitulacion
SET Est_Viudo         := 'V';        -- Viudo
SET Est_Divorciad     := 'D';        -- Divorciado
SET Est_Seperados     :='SE';        -- Separado
SET Est_UnionLibre    := 'U';        -- Union Libre
SET Dir_Oficial       := 'S';         -- Tipo de Direccion: Oficial
SET Dir_Trabajo       := 3;           -- Tipo de Direccion: Trabajo

SET Des_Soltero       := 'SOLTERO(A)';                    -- Descripcion para el estado civil de un cliente
SET Des_CasBieSep     := 'CASADO(A) BIENES SEPARADOS';            -- Descripcion para el estado civil de un cliente
SET Des_CasBieMan     := 'CASADO(A) BIENES MANCOMUNADOS';           -- Descripcion para el estado civil de un cliente
SET Des_CasCapitu     := 'CASADO(A) BIENES MANCOMUNADOS CON CAPITULACION';  -- Descripcion para el estado civil de un cliente
SET Des_Viudo         := 'VIUDO(A)';                      -- Descripcion para el estado civil de un cliente
SET Des_Divorciad     := 'DIVORCIADO(A)';                   -- Descripcion para el estado civil de un cliente
SET Des_Seperados     := 'SEPARADO(A)';                   -- Descripcion para el estado civil de un cliente
SET Des_UnionLibre    := 'UNION LIBRE';                   -- Descripcion para el estado civil de un cliente
SET TipoDirTrab       := 3;                         -- Tipo de direccion Laboral o de trabajo
SET TipoDirCasa       := 1;                         -- Tipo de direccion Casa
SET SI                := 'S';                         -- Constante Si
SET esOficial         := 'S';                         -- Cuando la direccion del Cte es Oficial.
SET Var_SI        	  := 'S';                         -- Constante SI
SET Var_NO        	  := 'N';                         -- Constante No
SET TipoLinaNeg       := 1;                         -- Corresponde al catalogo CATLINEANEGOCIO: 1, INDIVIDUAL
SET Inv_Vigente       := 'N';                         -- Estatus de la inversion: N.- Vigente
SET Ava_Asignado      := 'A';                         -- Estatus del aval: A.- Asignado
SET Meses_Anio        := 12;
SET NoPaisMexi        := '700';
SET NomMexico         := 'MEXICO';
SET mes1        := 1; -- correspondiente a enero
SET mes2        := 2; -- correspondiente a febrero
SET mes3        := 3; -- correspondiente a marzo
SET mes4        := 4; -- correspondiente a abril
SET mes5        := 5; -- correspondiente a mayo
SET mes6        := 6; -- correspondiente a junio
SET mes7        := 7; -- correspondiente a julio
SET mes8        := 8; -- correspondiente a agosto
SET mes9        := 9; -- correspondiente a septiembre
SET mes10       := 10; -- correspondiente a octubre
SET mes11       := 11; -- correspondiente a noviembre
SET mes12       := 12; -- correspondiente a diciembre
SET TxtEnero      		:= 'Enero';
SET TxtFebrero      	:= 'Febrero';
SET TxtMarzo      		:= 'Marzo';
SET TxtAbril      		:= 'Abril';
SET TxtMayo       		:= 'Mayo';
SET TxtJunio      		:= 'Junio';
SET TxtJulio      		:= 'Julio';
SET TxtAgosto       	:= 'Agosto';
SET TxtSeptiembre     	:= 'Septiembre';
SET TxtOctubre      	:= 'Octubre';
SET TxtNoviembre    	:= 'Noviembre';
SET TxtDiciembre    	:= 'Diciembre';
SET DescNacional    	:= 'NACIONAL';
SET DescExtranjero    	:= 'EXTRANJERO';
SET DescRecursoP    	:= 'FONDEO';
SET DescRecursoT    	:= 'PROPIOS';
SET TxtLibres     		:= 'Libres';
SET FrecSemanal     	:= 'S';
SET FrecCatorcenal    	:= 'C';
SET FrecQuincenal   	:= 'Q';
SET FrecMensual     	:= 'M';
SET FrecPeriodica   	:= 'P';
SET FrecBimestral   	:= 'B';
SET FrecTrimestral    	:= 'T';
SET FrecTetramestral	:= 'R';
SET FrecSemestral   	:= 'E';
SET FrecAnual     		:= 'A';
SET FrecUnico     		:= 'U';
SET FrecLibre     		:= 'L';
SET FrecDecenal     	:= 'D';
SET TxtSemanal      	:= 'semanal' ;
SET TxtCatorcenal   	:= 'catorcenal' ;
SET TxtQuincenal    	:= 'quincenal' ;
SET TxtMensual      	:= 'mensual' ;
SET TxtPeriodica    	:= 'periodica'   ;
SET TxtBimestral    	:= 'bimestral' ;
SET TxtTrimestral   	:= 'trimestral' ;
SET TxtTetramestral		:= 'tetramestral' ;
SET TxtSemestral    	:= 'semestral';
SET TxtAnual      		:= 'anual';
SET TxtDecenal      	:= 'decenal';
SET TxtUnico        	:= 'PAGO UNICO';
SET Var_CalcAntiguedad := IFNULL((SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'DetLaboralCteConyug'), Var_NO);
SET Var_PaisInsuf		:= 999;

SET Fecha_Sis:= (SELECT FechaSistema  FROM PARAMETROSSIS  WHERE EmpresaID=1);
-- CONSTANTES ALTERNATIVA 19
SET Tipo_IdfElector		:=	1;
SET Consumo				:='O';
SET OtrosIngresos		:= 6;
SET Presidente			:= 'PRESIDENTE';
SET Tesorero			:= 'TESORERO';
SET Secretario			:= 'SECRETARIO';
SET Integrante			:= 'INTEGRANTE';
SET Hipotecaria			:= 'H';
SET GReal				:= 'R';
SET GOblSolidario		:= 'O';
SET Habilitacion		:= 'R';
SET Refaccionario		:= 'H';
SET GarInmobiliaria		:= 3;

SET Con_TipoIdentiINE   := 1;

-- Constantes Financiera Zafy
SET TxtSemanales                :=  'Semanas'  ;
SET TxtCatorcenales             :=  'Catorcenas' ;
SET TxtQuincenales              :=  'Quincenas' ;
SET TxtMensuales                :=  'Meses' ;
SET TxtBimestrales              :=  'Bimestres' ;
SET TxtTrimestrales             := 'Trimestres' ;
SET TxtTetramestrales           := 'Tetramestres' ;
SET TxtSemestrales              := 'Semestres';
SET TxtAnuales                  := 'Años';
SET TxtPeriodico				:= 'Periodos';
SET Propia						:= 'P';
SET Familiar					:= 'F';
SET Rentada						:= 'R';
SET Otro						:= 'O';
SET PersonaMoral				:= 'M';
SET Egresos						:= 'E';
SET ActaPoderes					:= 'P';

SET Var_M						:= 'M';
SET Var_F						:= 'F';
SET Var_SexoM					:= 'Masculino';
SET Var_SexoF					:= 'Femenino';

IF(Par_TipoReporte = Seccion_General) THEN

    SELECT  Sol.SolicitudCreditoID, Sol.ClienteID,      Sol.ProspectoID,    Sol.SucursalID,     Sol.ProductoCreditoID,
            Sol.MontoSolici,    Sol.Proyecto,       Sol.TasaFija,       Pro.Descripcion,
            Crp.Descripcion,    Mon.Descripcion,    Des.Descripcion,
            CASE WHEN IFNULL(Sol.PorcGarLiq, Entero_Cero) != Entero_Cero THEN
                    CONCAT("LIQUIDA ", FORMAT(Sol.PorcGarLiq,2), "%")
                 WHEN IFNULL(Pro.RequiereGarantia, Cadena_Vacia) = Si_Requiere THEN
                    "MOBILIARIA, INMOBILIARIA"
            END,
            CASE Sol.FrecuenciaCap
                WHEN FrecSemanal    THEN UPPER(TxtSemanal)
                WHEN FrecCatorcenal   THEN UPPER(TxtCatorcenal)
                WHEN FrecQuincenal    THEN UPPER(TxtQuincenal)
                WHEN FrecMensual    THEN UPPER(TxtMensual)
                WHEN FrecPeriodica    THEN UPPER(TxtPeriodica)
                WHEN FrecBimestral    THEN UPPER(TxtBimestral)
                WHEN FrecTrimestral   THEN UPPER(TxtTrimestral)
                WHEN FrecTetramestral   THEN UPPER(TxtTetramestral)
                WHEN FrecSemestral    THEN UPPER(TxtSemestral)
                WHEN FrecAnual      THEN UPPER(TxtAnual)
        WHEN FrecUnico      THEN UPPER(TxtUnico)
            END,	Crp.Dias, 	Crp.Frecuencia,
            Sol.HorarioVeri
            
            INTO
            Var_SolCreditoID,   Var_ClienteID,      Var_ProspectoID,    Var_SucursalID, Var_ProducCredID,
            Var_MontoSolici,    Var_Finalidad,      Var_Tasa,       Var_DesProducto,
            Var_Plazo,          Var_Moneda,         Var_Destino,    Var_TipoGarant,
            Var_Frecuencia,		Var_DiasXPlazo,		Var_FrecuenciaPlazo,
            Var_HorarioVeri
        FROM SOLICITUDCREDITO Sol,
             MONEDAS Mon,
             PRODUCTOSCREDITO Pro,
             CREDITOSPLAZOS Crp,
             DESTINOSCREDITO Des
        WHERE Sol.SolicitudCreditoID = Par_SoliCredID
          AND Sol.MonedaID = Mon.MonedaId
          AND Sol.PlazoID = Crp.PlazoID
          AND Sol.DestinoCreID = Des.DestinoCreID
          AND Sol.ProductoCreditoID = Pro.ProducCreditoID
    LIMIT 1;
    
    SET Var_DiasXPlazo = (SELECT Var_DiasXPlazo/Dias FROM CATFRECUENCIAS WHERE FrecuenciaID = Var_FrecuenciaPlazo);
    IF(Var_DiasXPlazo>1)THEN
		SET Var_FrecuenciaPlazo = (SELECT DescPlural FROM CATFRECUENCIAS WHERE FrecuenciaID = Var_FrecuenciaPlazo);
	ELSE
		SET Var_FrecuenciaPlazo = (SELECT DescSingular FROM CATFRECUENCIAS WHERE FrecuenciaID = Var_FrecuenciaPlazo);
    END IF;
    

    SET Var_SolCreditoID   := IFNULL(Var_SolCreditoID, Entero_Cero);
    SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);
    SET Var_ProspectoID := IFNULL(Var_ProspectoID, Entero_Cero);
    SET Var_ProducCredID := IFNULL(Var_ProducCredID, Entero_Cero);

-- ---------------------------------------------------------------------------------
-- SE EVALUA SI LA CONSULTA SE HARA SOBRE UN CLIENTE O PROSPECTO
-- ---------------------------------------------------------------------------------
  IF(Var_ClienteID != Entero_Cero)THEN
    SET Es_Cliente = Var_SI;
  ELSE
    SET Es_Cliente = Var_NO;
  END IF;

    IF(Var_ClienteID != Entero_Cero) THEN           -- Es Cliente
        SELECT  EmpresaLabora
            INTO Var_EmpresaLabora
        FROM     SOCIODEMOCONYUG
        WHERE    ClienteID = Var_ClienteID;

        SELECT  CON.NoEmpleados,    CON.NoCuentaRef,    CON.BanNoTarjetaRef
            INTO Var_NoEmpleados, Var_NoCuentaRef, Var_BanNoTarjetaRef
        FROM    CONOCIMIENTOCTE AS CON 
            INNER JOIN CLIENTES AS CTE ON CON.ClienteID = CTE.ClienteID
        WHERE   CON.ClienteID = Var_ClienteID;
        SELECT Ac.Descripcion
            INTO Var_ActividadBMXDesc
            FROM    SOLICITUDCREDITO Sol
                    INNER JOIN  CLIENTES Cli        ON  Sol.ClienteID=Cli.ClienteID
                    LEFT  JOIN  CONOCIMIENTOCTE Cc  ON  Cli.ClienteID= Cc.ClienteID
                    LEFT JOIN   ACTIVIDADESBMX Ac   ON  Cli.ActividadBancoMX = Ac.ActividadBMXID
                    LEFT JOIN CLIDATSOCIOE  Cl      ON  Cli.ClienteID = Cl.ClienteID
                                                    AND Cl.CatSocioEID = 1
                    LEFT JOIN CATDATSOCIOE Ca       ON  Cl.CatSocioEID = Ca.CatSocioEID
            WHERE Sol.SolicitudCreditoID = Par_SoliCredID LIMIT 1;
        SELECT  Soc.Descripcion,    Soc.TiempoHabitarDom
            INTO Var_ViviendaDesc,  Var_TiempoHabitarDom
        FROM   SOCIODEMOVIVIEN Soc
        LEFT JOIN TIPOVIVIENDA Viv on Viv.TipoViviendaID = Soc.TipoViviendaID
        LEFT JOIN TIPOMATERIALVIV Mat on Mat.TipoMaterialID = Soc.TipoMaterialID
        WHERE    ClienteID = Var_ClienteID;

        SET Var_Numcliente  := Var_ClienteID;

        -- Generales del Cliente
        SELECT  Cli.NombreCompleto, Cli.FechaNacimiento,    Pan.Nombre,         Esr.Nombre, Cli.Sexo,
                Ocu.Descripcion,    Cli.Nacion,             Cli.EstadoCivil,    Cli.CURP,   Cli.RFC,
                Cli.TelTrabajo,     Cli.Telefono,           Cli.LugardeTrabajo, Cli.Puesto,
        CASE WHEN Var_CalcAntiguedad = Var_SI THEN  CASE WHEN IFNULL(Cli.FechaIniTrabajo,Fecha_Vacia) = Fecha_Vacia
                                  THEN Entero_Cero
                                 ELSE
                                  ROUND(DATEDIFF(Fecha_Sis,Cli.FechaIniTrabajo) / 365,1)
                              END
           ELSE Cli.AntiguedadTra
        END,
        CONCAT(Cli.PrimerNombre,' ',Cli.TercerNombre,' ',Cli.TercerNombre) AS Nombres,
        Cli.ApellidoPaterno, Cli.ApellidoMaterno,
        Cli.FEA,    Cli.Correo,         Cli.TelefonoCelular
                INTO Var_NombreCli, Var_FecNacCli,      Var_PaisNac,        Var_EstadoNac,  Var_CliSexo,
                     Var_Ocupacion, Var_ClaveNacion,    Var_ClaveEstCiv,    Var_CliCURP,    Var_CliRFC,
                     Var_CliTelTra, Var_CliTelPart,     Var_CliLugTra,      Var_CliPuesto,  Var_CliAntTra,
                     Var_NombresCli,	Var_ApellidoPaterno,	Var_ApellidoMaterno,	Var_FEA,     Var_CliCorreo,
                     Var_TelefonoCelular
            FROM CLIENTES Cli
        INNER JOIN PAISES Pan ON Cli.LugarNacimiento = Pan.PaisID
        LEFT OUTER JOIN ESTADOSREPUB Esr ON Cli.EstadoID = Esr.EstadoID
        LEFT OUTER JOIN OCUPACIONES Ocu ON Cli.OcupacionID = Ocu.OcupacionID
          WHERE ClienteID = Var_ClienteID LIMIT 1;
        -- Nombre Promotor
        SELECT  P.NombrePromotor INTO Var_NombrePromotor
        FROM
        SOLICITUDCREDITO  C,
        PROMOTORES  P
      WHERE C.SolicitudCreditoID= Par_SoliCredID
      AND C.PromotorID=P.PromotorID LIMIT 1;
        -- Direccion del Cliente
        SELECT Dir.Calle, Dir.NumInterior, Dir.Piso, Dir.Lote, Dir.Manzana,
               Col.Asentamiento, Dir.NumeroCasa, Mun.Nombre,    Dir.PrimeraEntreCalle,
               Dir.SegundaEntreCalle, Dir.CP, Dir.EstadoID
      INTO Var_CliCalle, Var_CliNumInt, Var_CliPiso, Var_CliLote, Var_CliManzana,
         Var_CliColoni, Var_CliNumCasa, Var_CliMunici, Var_1aEntreCalle,
         Var_2aEntreCalle, Var_CP, Var_SolEstadoID
          FROM DIRECCLIENTE Dir,
             COLONIASREPUB Col,
             MUNICIPIOSREPUB Mun
            WHERE ClienteID = Var_ClienteID
              AND Oficial = Dir_Oficial
              AND Dir.EstadoID = Col.EstadoID
              AND Dir.MunicipioID = Col.MunicipioID
              AND Dir.ColoniaID = Col.ColoniaID
              AND Mun.EstadoID  = Col.EstadoID
              AND Mun.MunicipioID = Col.MunicipioID
              LIMIT 1;

        SELECT Nombre
            INTO Var_EstadoDirect
        FROM ESTADOSREPUB 
            WHERE EstadoID = Var_SolEstadoID;

        -- Direccion del Trabajo
        SELECT DireccionCompleta INTO Var_DirTrabajo
            FROM DIRECCLIENTE Dir
        WHERE ClienteID = Var_ClienteID
          AND TipoDireccionID = Dir_Trabajo
            LIMIT 1;

        -- Numero de Creditos
        SELECT SUM(CASE WHEN Cre.ProductoCreditoID =  Var_ProducCredID AND
                             (Cre.Estatus = Est_Vigente OR Cre.Estatus = Est_Pagado) THEN 1
                        ELSE Entero_Cero
                    END),
               SUM(CASE WHEN Cre.Estatus = Est_Pagado THEN 1
                        ELSE Entero_Cero
                    END)
                INTO Var_NumCreditos, Var_NumCreTra
            FROM CREDITOS Cre
        WHERE Cre.ClienteID         = Var_ClienteID
          LIMIT 1;

        SET Var_NumCreTra   := IFNULL(Var_NumCreTra, Entero_Cero);

        -- Se le suma un uno, por si el cliente no tiene creditos o experiencia con la institucion
        -- Entonces decimos que es su 1er ciclo el credito que esta Solicitando
        SET Var_NumCreditos := IFNULL(Var_NumCreditos, Entero_Cero) + 1;

        -- Monto del Ultimo Credito Pagado
        IF(Var_NumCreTra != Entero_Cero) THEN
            SELECT MontoCredito INTO Var_MonUltCred
                FROM CREDITOS Cre
          WHERE ClienteID = Var_ClienteID
            AND Cre.Estatus = Est_Pagado
              ORDER BY FechaInicio DESC
              LIMIT 1;
        END IF;

        SET Var_MonUltCred  := IFNULL(Var_MonUltCred, Entero_Cero);

    ELSE -- EndIf es Cliente

        -- Es Prospecto
        SET Var_Numcliente  := Var_ProspectoID;

        SELECT   EmpresaLabora
            INTO Var_EmpresaLabora
        FROM     SOCIODEMOCONYUG
        WHERE    ProspectoID    =   Var_ProspectoID;

        SELECT      Soc.Descripcion,    Soc.TiempoHabitarDom
            INTO    Var_ViviendaDesc,   Var_TiempoHabitarDom
        FROM     SOCIODEMOVIVIEN Soc
        LEFT JOIN TIPOVIVIENDA Viv on Viv.TipoViviendaID = Soc.TipoViviendaID
        LEFT JOIN TIPOMATERIALVIV Mat on Mat.TipoMaterialID = Soc.TipoMaterialID
        WHERE    ProspectoID = Var_ProspectoID;

        -- Generales del Prospecto
        SELECT  Cli.NombreCompleto, Cli.FechaNacimiento,    Cli.Sexo,           Cli.EstadoCivil,
                Cli.RFC,            Cli.Telefono,           Cli.Calle,          Cli.NumInterior,
                Cli.Lote,           Cli.Manzana,            Col.Asentamiento,   Cli.NumExterior,
                Mun.Nombre,			Cli.CP
      INTO
                Var_NombreCli,  Var_FecNacCli,  Var_CliSexo,    Var_ClaveEstCiv,
                Var_CliRFC,     Var_CliTelPart, Var_CliCalle,   Var_CliNumInt,
                Var_CliLote,    Var_CliManzana, Var_CliColoni,  Var_CliNumCasa,
                Var_CliMunici,	Var_CP
            FROM PROSPECTOS Cli,
                 COLONIASREPUB Col,
                 MUNICIPIOSREPUB Mun
          WHERE Cli.ProspectoID = Var_ProspectoID
            AND Cli.EstadoID = Col.EstadoID
            AND Cli.MunicipioID = Col.MunicipioID
            AND Cli.ColoniaID = Col.ColoniaID
            AND Mun.EstadoID  = Col.EstadoID
            AND Mun.MunicipioID = Col.MunicipioID
          LIMIT 1;

        SET Var_ClaveNacion := Nac_Mexicano;
        -- Si es prospecto entonces no puede tener creditos actuales, le indicamos es su 1er ciclo
        SET Var_NumCreditos := 1;
        SET Var_MonUltCred  := Entero_Cero;
        SET Var_NumCreTra   := Entero_Cero;

    END IF; -- EndIf es Prospecto

    -- Ciclo Base del Cliente-Prospecto
    SELECT  CicloBase INTO Var_CicBaseCli
        FROM CICLOBASECLIPRO Cib
    WHERE (CASE WHEN IFNULL(Es_Cliente,Cadena_Vacia) = Var_SI THEN Cib.ClienteID = Var_ClienteID
          ELSE Cib.ProspectoID = Var_ProspectoID
        END)
    AND Cib.ProductoCreditoID = Var_ProducCredID;

    SET Var_CicBaseCli := IFNULL(Var_CicBaseCli, Entero_Cero);
    SET Var_ClienteCiclo := Var_NumCreditos + Var_CicBaseCli;

    SET Var_CliSexo := IFNULL(Var_CliSexo, Cadena_Vacia);

    IF(Var_CliSexo = Gen_Masculino) THEN
        SET Var_CliGenero   := Des_Masculino;
    ELSE
        SET Var_CliGenero   := Des_Femenino;
    END IF;

    IF (Var_ClaveNacion = Nac_Mexicano) THEN
        SET Var_CliNacion   := Des_Mexicano;
    ELSE
        SET Var_CliNacion   := Des_Extranjero;
    END IF;

  IF (Var_ClaveNacion = Nac_Extranjero) THEN
        SET Var_CliNacion   := Des_Extranjero;
    ELSE
        SET Var_CliNacion   := Des_Mexicano;
    END IF;

    SET Var_DescriEstCiv    := (SELECT CASE Var_ClaveEstCiv
                                    WHEN Est_Soltero  THEN Des_Soltero
                                    WHEN Est_CasBieSep  THEN Des_CasBieSep
                                    WHEN Est_CasBieMan  THEN Des_CasBieMan
                                    WHEN Est_CasCapitu  THEN Des_CasCapitu
                                    WHEN Est_Viudo  THEN Des_Viudo
                                    WHEN Est_Divorciad  THEN Des_Divorciad
                                    WHEN Est_Seperados  THEN Des_Seperados
                                    WHEN Est_UnionLibre  THEN Des_UnionLibre
                                    ELSE Cadena_Vacia
                                END );

    -- Cliente - Prospecto
    SELECT Esc.Descripcion INTO Var_EscoCli
        FROM SOCIODEMOGRAL Soc,
             CATGRADOESCOLAR Esc
    WHERE (CASE WHEN IFNULL(Es_Cliente,Cadena_Vacia) = Var_SI THEN Soc.ClienteID = Var_ClienteID
            ELSE Soc.ProspectoID = Var_ProspectoID
          END)
          AND Soc.GradoEscolarID = Esc.GradoEscolarID;

    SET Var_EscoCli := IFNULL(Var_EscoCli, Cadena_Vacia);

    SET Var_CliCalle      := IFNULL(Var_CliCalle, Cadena_Vacia);
    SET Var_CliNumInt     := IFNULL(Var_CliNumInt, Cadena_Vacia);
    SET Var_CliPiso       := IFNULL(Var_CliPiso, Cadena_Vacia);
    SET Var_CliLote       := IFNULL(Var_CliLote, Cadena_Vacia);
    SET Var_CliManzana    := IFNULL(Var_CliManzana, Cadena_Vacia);
    SET Var_CliColoni     := IFNULL(Var_CliColoni, Cadena_Vacia);
    SET Var_CliNumCasa    := IFNULL(Var_CliNumCasa, Cadena_Vacia);
    SET Var_CliMunici     := IFNULL(Var_CliMunici, Cadena_Vacia);
    SET Var_1aEntreCalle  := IFNULL(Var_1aEntreCalle, Cadena_Vacia);
    SET Var_2aEntreCalle  := IFNULL(Var_2aEntreCalle, Cadena_Vacia);
    SET Var_CliTelTra     := IFNULL(Var_CliTelTra, Cadena_Vacia);
    SET Var_CliTelPart    := IFNULL(Var_CliTelPart, Cadena_Vacia);
    SET Var_CliLugTra     := IFNULL(Var_CliLugTra, Cadena_Vacia);
    SET Var_CliPuesto     := IFNULL(Var_CliPuesto, Cadena_Vacia);
    SET Var_CliAntTra     := IFNULL(Var_CliAntTra, Entero_Cero);

    SET Var_CliCalNum       := Var_CliCalle;
    SET Var_CliSolCalNum	:= Var_CliCalle;
    SET Var_CliSolExtNum	:= Var_CliNumCasa;
    SET Var_CliSolNumInt	:= Var_CliNumInt;
	SET Var_CliSolColonia	:= Var_CliColoni;
    SET Var_CliSolMunici 	:= Var_CliMunici;
    
    IF(Var_CliNumCasa != Cadena_Vacia) THEN
        SET Var_CliCalNum   := CONCAT(Var_CliCalNum, ' No. ', Var_CliNumCasa);
    END IF;

    IF(Var_CliNumInt != Cadena_Vacia) THEN
        SET Var_CliCalNum   := CONCAT(Var_CliCalNum, ' INTERIOR ', Var_CliNumInt);
    END IF;

    IF(Var_CliLote != Cadena_Vacia) THEN
        SET Var_CliCalNum   := CONCAT(Var_CliCalNum, ' LOTE ', Var_CliLote);
    END IF;

    IF(Var_CliManzana != Cadena_Vacia) THEN
        SET Var_CliCalNum   := CONCAT(Var_CliCalNum, ' MANZANA ', Var_CliManzana);
    END IF;

    IF(Var_CliPiso != Cadena_Vacia) THEN
        SET Var_CliCalNum   := CONCAT(Var_CliCalNum, ' PISO ', Var_CliPiso);
    END IF;

    SET Var_CliColMun   := CONCAT(Var_CliColoni, ',', Var_CliMunici);

    SELECT ValorVivienda, Tiv.Descripcion, Tim.Descripcion
    INTO
           Var_CliValorViv, Var_CliTipViv, Var_CliMatViv
        FROM SOCIODEMOVIVIEN Sov,
             TIPOVIVIENDA Tiv,
             TIPOMATERIALVIV Tim
      WHERE (CASE WHEN IFNULL(Es_Cliente,Cadena_Vacia) = Var_SI THEN Sov.ClienteID = Var_ClienteID
              ELSE Sov.ProspectoID = Var_ProspectoID
            END)
          AND Sov.TipoViviendaID = Tiv.TipoViviendaID
          AND Sov.TipoMaterialID = Tim.TipoMaterialID
      LIMIT 1;

    SET Var_CliValorViv := IFNULL(Var_CliValorViv, Entero_Cero);
    SET Var_CliTipViv   := IFNULL(Var_CliTipViv, Cadena_Vacia);
    SET Var_CliMatViv   := IFNULL(Var_CliMatViv, Cadena_Vacia);

    SET Var_DirTrabajo      := IFNULL(Var_DirTrabajo, Cadena_Vacia);
    SET Var_DesCliAntTra    := FORMAT(IFNULL(Var_CliAntTra, Entero_Cero), 2);

    -- Datos del Conyugue

  IF(Var_ClaveEstCiv = Est_CasBieSep OR Var_ClaveEstCiv = Est_CasBieMan OR Var_ClaveEstCiv = Est_CasCapitu OR Var_ClaveEstCiv = Est_UnionLibre )THEN
      SELECT  Coy.PrimerNombre,       Coy.SegundoNombre,      Coy.TercerNombre,       Coy.ApellidoPaterno,
          Coy.ApellidoMaterno,    Coy.FechaNacimiento,    Pan.Nombre,             Esr.Nombre,
          Coy.EmpresaLabora,      Est.Nombre,             Mun.Nombre,             Coy.Colonia,
          Coy.Calle,              Coy.NumeroExterior,     Coy.NumeroInterior,     Coy.NumeroPiso,
          Coy.CodigoPostal,
          CASE WHEN Var_CalcAntiguedad = Var_SI THEN  CASE WHEN IFNULL(Coy.FechaIniTrabajo,Fecha_Vacia) = Fecha_Vacia
                                  THEN Entero_Cero
                                 ELSE
                                  ROUND(DATEDIFF(Fecha_Sis,Coy.FechaIniTrabajo) / 365)
                              END
           ELSE Coy.AntiguedadAnios
          END,
          CASE WHEN Var_CalcAntiguedad = Var_SI THEN Entero_Cero
                                     ELSE IF(IFNULL(Coy.AntiguedadMeses,Cadena_Vacia)=Cadena_Vacia,Entero_Cero,Coy.AntiguedadMeses)
          END,
          TelefonoTrabajo,
          TelCelular,             Ocu.Descripcion,
          CASE WHEN Coy.Nacionalidad = Nac_Mexicano THEN Des_Mexicano
             ELSE Des_Extranjero
          END
          INTO
          Var_ConyPriNom,         Var_ConySegNom,         Var_ConyTerNom,         Var_ConyApePat,
          Var_ConyApeMat,         Var_ConyFecNac,         Var_ConyPaiNac,         Var_ConyEstNac,
          Var_ConyNomEmp,         Var_ConyEstEmp,         Var_ConyMunEmp,         Var_ConyColEmp,
          Var_ConyCalEmp,         Var_ConyNumExt,         Var_ConyNumInt,         Var_ConyNumPiso,
          Var_ConyCodPos,         Var_ConyAntAnio,        Var_ConyAntMes,         Var_ConyTelTra,
          Var_ConyTelCel,         Var_ConyOcupa,          Var_ConyNacion
      FROM SOCIODEMOCONYUG Coy
      LEFT OUTER JOIN PAISES Pan ON Coy.PaisNacimiento = Pan.PaisID
      LEFT OUTER JOIN ESTADOSREPUB Esr ON Coy.EstadoNacimiento = Esr.EstadoID
      LEFT OUTER JOIN ESTADOSREPUB Est ON Coy.EntidadFedTrabajo = Est.EstadoID
      LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON Coy.EntidadFedTrabajo = Mun.EstadoID AND Coy.MunicipioTrabajo  = Mun.MunicipioID
      LEFT OUTER JOIN OCUPACIONES Ocu ON Coy.OcupacionID = Ocu.OcupacionID
      WHERE (CASE WHEN IFNULL(Es_Cliente,Cadena_Vacia) = Var_SI THEN Coy.ClienteID = Var_ClienteID
            ELSE Coy.ProspectoID = Var_ProspectoID
          END);

  END IF;

    -- Total de Dependientes Economicos y Cuantos son Hijos
    SELECT SUM(1),
           SUM(CASE WHEN Dep.TipoRelacionID = Rel_Hijo THEN 1
                        ELSE Entero_Cero
                    END)
                INTO Var_NumDepend, Var_NumHijos
            FROM SOCIODEMODEPEND Dep
            WHERE (CASE WHEN IFNULL(Es_Cliente,Cadena_Vacia) = Var_SI THEN Dep.ClienteID = Var_ClienteID
          ELSE Dep.ProspectoID = Var_ProspectoID
        END)
      LIMIT 1;

    SET Var_ClienteEdad := FLOOR(DATEDIFF(CURDATE(), Var_FecNacCli) / 365);
    SET Var_ConyugeEdad := FLOOR(DATEDIFF(CURDATE(), Var_ConyFecNac) / 365);

    SELECT NombreSucurs INTO Var_NombreSucurs
        FROM SUCURSALES
        WHERE SucursalID = Var_SucursalID
  LIMIT 1;

    SET Var_NombreSucurs := IFNULL(Var_NombreSucurs, Cadena_Vacia);

    SET Var_ConyPriNom      := IFNULL(Var_ConyPriNom, Cadena_Vacia);
    SET Var_ConySegNom      := IFNULL(Var_ConySegNom, Cadena_Vacia);
    SET Var_ConyTerNom      := IFNULL(Var_ConyTerNom, Cadena_Vacia);
    SET Var_ConyApePat      := IFNULL(Var_ConyApePat, Cadena_Vacia);
    SET Var_ConyApeMat      := IFNULL(Var_ConyApeMat, Cadena_Vacia);
    SET Var_ConyFecNac      := IFNULL(Var_ConyFecNac, Fecha_Vacia);
    SET Var_ConyPaiNac      := IFNULL(Var_ConyPaiNac, Cadena_Vacia);
    SET Var_ConyEstNac      := IFNULL(Var_ConyEstNac, Cadena_Vacia);
    SET Var_ConyNomEmp      := IFNULL(Var_ConyNomEmp, Cadena_Vacia);
    SET Var_ConyEstEmp      := IFNULL(Var_ConyEstEmp, Cadena_Vacia);
    SET Var_ConyMunEmp      := IFNULL(Var_ConyMunEmp, Cadena_Vacia);
    SET Var_ConyColEmp      := IFNULL(Var_ConyColEmp, Cadena_Vacia);
    SET Var_ConyCalEmp      := IFNULL(Var_ConyCalEmp, Cadena_Vacia);
    SET Var_ConyNumExt      := IFNULL(Var_ConyNumExt, Entero_Cero);
    SET Var_ConyNumInt      := IFNULL(Var_ConyNumInt, Cadena_Vacia);
    SET Var_ConyNumPiso     := IFNULL(Var_ConyNumPiso, Cadena_Vacia);
    SET Var_ConyCodPos      := IFNULL(Var_ConyCodPos, Cadena_Vacia);
    SET Var_ConyAntAnio     := IFNULL(Var_ConyAntAnio, Cadena_Vacia);
    SET Var_ConyAntMes      := IFNULL(Var_ConyAntMes, Entero_Cero);
    SET Var_ConyTelTra      := IFNULL(Var_ConyTelTra, Cadena_Vacia);
    SET Var_ConyTelCel      := IFNULL(Var_ConyTelCel, Cadena_Vacia);
    SET Var_ConyOcupa       := IFNULL(Var_ConyOcupa, Cadena_Vacia);
    SET Var_ConyNacion      := IFNULL(Var_ConyNacion, Cadena_Vacia);
    SET Var_ConyugeEdad     := IFNULL(Var_ConyugeEdad, Entero_Cero);
    SET Var_PaisNac         := IFNULL(Var_PaisNac, Cadena_Vacia);
    SET Var_EstadoNac       := IFNULL(Var_EstadoNac, Cadena_Vacia);
    SET Var_CliCURP         := IFNULL(Var_CliCURP, Cadena_Vacia);
    SET Var_Ocupacion       := IFNULL(Var_Ocupacion, Cadena_Vacia);
    SET Var_NumDepend       := IFNULL(Var_NumDepend, Entero_Cero);
    SET Var_NumHijos        := IFNULL(Var_NumHijos, Entero_Cero);

    SET Var_ViviendaDesc        := IFNULL(Var_ViviendaDesc, Cadena_Vacia);
    SET Var_TiempoHabitarDom    := IFNULL(Var_TiempoHabitarDom, Entero_Cero);
    SET Var_HorarioVeri         := IFNULL(Var_HorarioVeri, Cadena_Vacia);
    SET Var_NoEmpleados         := IFNULL(Var_NoEmpleados, Cadena_Vacia);
    SET Var_NoCuentaRef         := IFNULL(Var_NoCuentaRef, Cadena_Vacia);
    SET Var_BanNoTarjetaRef     := IFNULL(Var_BanNoTarjetaRef, Cadena_Vacia);
    SET Var_ActividadBMXDesc    := IFNULL(Var_ActividadBMXDesc,Cadena_Vacia);

    SET Var_ConyNomCom  := Var_ConyPriNom;

    IF(Var_ConySegNom != Cadena_Vacia) THEN
        SET Var_ConyNomCom  := CONCAT(Var_ConyNomCom, " ", Var_ConySegNom);
    END IF;

    IF(Var_ConyTerNom != Cadena_Vacia) THEN
        SET Var_ConyNomCom  := CONCAT(Var_ConyNomCom, " ", Var_ConyTerNom);
    END IF;

    SET Var_ConyNomCom  := CONCAT(Var_ConyNomCom, " ", Var_ConyApePat, " ", Var_ConyApeMat);

    SET Var_DirEmpCony  := Var_ConyCalEmp;

    IF(Var_ConyNumExt != Entero_Cero) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, " No ", CONVERT(Var_ConyNumExt, CHAR));
    END IF;

    IF(Var_ConyNumInt != Cadena_Vacia) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, " Interior ", Var_ConyNumInt);
    END IF;

    IF(Var_ConyNumPiso != Cadena_Vacia) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, " Piso ", Var_ConyNumPiso);
    END IF;

    IF(Var_ConyNumInt != Cadena_Vacia) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, " Col. ", Var_ConyColEmp);
    END IF;

    IF(Var_ConyEstEmp != Cadena_Vacia) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, ", ", Var_ConyEstEmp);
    END IF;

    IF(Var_ConyMunEmp != Cadena_Vacia) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, ", ", Var_ConyMunEmp);
    END IF;

    IF(Var_ConyMunEmp != Cadena_Vacia) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, ", CP ", Var_ConyCodPos);
    END IF;

    SET Var_ConyAntTra  := Cadena_Vacia;

    IF(Var_ConyAntAnio != Cadena_Vacia) THEN
        SET Var_ConyAntTra  := CONCAT(CONVERT(Var_ConyAntAnio, CHAR), " Año(s) ");

        IF(Var_ConyAntMes != Entero_Cero) THEN
            SET Var_ConyAntTra  := CONCAT(Var_ConyAntTra, " y ", CONVERT(Var_ConyAntMes, CHAR), " Mes(es)");
        END IF;
    ELSE
        IF(Var_ConyAntMes != Entero_Cero) THEN
            SET Var_ConyAntTra  := CONCAT(CONVERT(Var_ConyAntAnio, CHAR), " Mes(es)");
        END IF;
    END IF;
	-- ===================================
	SELECT I.Nombre
	INTO Var_NombreInstitucion
	FROM PARAMETROSSIS Par
	INNER JOIN INSTITUCIONES I ON Par.InstitucionID = I.InstitucionID;

	SELECT CONCAT(Mun.Nombre,', ',Est.Nombre),Suc.DirecCompleta
	INTO Var_DirecSucursal,Var_DirecCompletSuc
	FROM SOLICITUDCREDITO Sol
	INNER JOIN SUCURSALES Suc ON  Sol.SucursalID = Suc.SucursalID
	INNER JOIN ESTADOSREPUB Est ON Suc.EstadoID = Est.EstadoID
	INNER JOIN MUNICIPIOSREPUB Mun ON Suc.EstadoID = Mun.EstadoID
										AND Suc.MunicipioID= Mun.MunicipioID
	WHERE Sol.SolicitudCreditoID = Var_SolCreditoID;
	-- ==================================

    SELECT NumIdentific 
        INTO  Var_NumeroIdent
    FROM IDENTIFICLIENTE WHERE ClienteID = Var_Numcliente 
                                    AND TipoIdentiID = Con_TipoIdentiINE LIMIT 1;

    SET Var_NumeroIdent := IFNULL(Var_NumeroIdent, Cadena_Vacia);

    SELECT FechaSistema INTO Var_Fecha FROM PARAMETROSSIS LIMIT 1;

    SELECT  Var_SolCreditoID,	Var_NombreSucurs,   Var_Numcliente,     Var_NombreCli,      Var_FecNacCli,      Var_PaisNac,
            Var_EstadoNac,      Var_CliGenero,      Var_Ocupacion,      Var_CliNacion,      Var_DescriEstCiv,
            Var_CliCURP,        Var_CliRFC,         Var_EscoCli,        Var_CliCalNum,      Var_CliColMun,
            Var_1aEntreCalle,   Var_2aEntreCalle,   Var_CliTelTra,      Var_CliTelPart,     Var_CliValorViv,
            Var_CliTipViv,      Var_CliMatViv,      Var_DirTrabajo,     Var_CliLugTra,      Var_CliPuesto,
            FORMAT(Var_DesCliAntTra,1) AS Var_DesCliAntTra,
			Var_ConyNomCom,     Var_ConyFecNac,     Var_ConyPaiNac,     Var_ConyEstNac,
            Var_ConyNomEmp,     Var_ConyTelTra,     Var_ConyTelCel,     Var_DirEmpCony,     Var_ConyAntTra,
            Var_ClienteEdad,    Var_ConyugeEdad,    Var_ConyOcupa,      Var_ConyNacion,     Var_MontoSolici,
            Var_Finalidad,      Var_Tasa,           Var_DesProducto,    Var_Plazo,          Var_Moneda,
            Var_Destino,        Var_Frecuencia,     Var_TipoGarant,     Var_ClienteCiclo,   Var_NumCreTra,
            Var_MonUltCred,     Var_NumDepend,      Var_NumHijos,       Var_NombrePromotor  ,Var_NombreInstitucion,
			Var_DirecCompletSuc,Var_DirecSucursal,	Var_DiasXPlazo,		Var_FrecuenciaPlazo,	Var_NombresCli,	
            Var_ApellidoPaterno,					Var_ApellidoMaterno,	Var_FEA,          Var_CP,
            Var_CliSolCalNum,   Var_CliSolExtNum,   Var_CliSolNumInt,   Var_CliSolColonia,  Var_CliSolMunici,
            Var_EstadoDirect,   Var_CliCorreo,      Var_TelefonoCelular,    Var_NumeroIdent, Var_ViviendaDesc,
            Var_TiempoHabitarDom, Var_HorarioVeri,  Var_NoEmpleados,    Var_NoCuentaRef,    Var_BanNoTarjetaRef,
            Var_ActividadBMXDesc, Var_Fecha;

END IF; -- EndIF de Tipo de Reporte General o Datos del Cte y Solicitud

-- Datos Economicos del Cliente, Ingresos
IF(Par_TipoReporte = Seccion_EconoIng) THEN

    SELECT ClienteID, ProspectoID, SucursalID, ProductoCreditoID INTO
            Var_ClienteID, Var_ProspectoID, Var_SucursalID, Var_ProducCredID
        FROM SOLICITUDCREDITO
        WHERE SolicitudCreditoID = Par_SoliCredID
    LIMIT 1;

    SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);
    SET Var_ProspectoID := IFNULL(Var_ProspectoID, Entero_Cero);
    SET Var_ProducCredID := IFNULL(Var_ProducCredID, Entero_Cero);

    IF(Var_ClienteID != Entero_Cero) THEN
        SELECT Cat.Descripcion, Das.Monto
            FROM LINNEGPRODUCTO Lin,
                 CLIDATSOCIOE Das,
                 CATDATSOCIOE Cat
        WHERE Das.ClienteID = Var_ClienteID
          AND Lin.ProducCreditoID = Var_ProducCredID
          AND Lin.LinNegID = Das.LinNegID
          AND Cat.CatSocioEID = Das.CatSocioEID
          AND Tipo = Tipo_Ingreso;
    ELSE
        SELECT Cat.Descripcion, Das.Monto, 	Tipo, Lin.LinNegID
            FROM LINNEGPRODUCTO Lin,
                 CLIDATSOCIOE Das,
                 CATDATSOCIOE Cat
        WHERE Das.ProspectoID = Var_ProspectoID
          AND Lin.ProducCreditoID = Var_ProducCredID
          AND Lin.LinNegID = Das.LinNegID
          AND Cat.CatSocioEID = Das.CatSocioEID
          AND Tipo = Tipo_Ingreso;
    END IF;
END IF;

-- Datos Economicos del Cliente, Egresos
IF(Par_TipoReporte = Seccion_EconoEgr) THEN

    SELECT ClienteID, ProspectoID, SucursalID, ProductoCreditoID INTO
            Var_ClienteID, Var_ProspectoID, Var_SucursalID, Var_ProducCredID
        FROM SOLICITUDCREDITO
        WHERE SolicitudCreditoID = Par_SoliCredID
    LIMIT 1;

    SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);
    SET Var_ProspectoID := IFNULL(Var_ProspectoID, Entero_Cero);
    SET Var_ProducCredID := IFNULL(Var_ProducCredID, Entero_Cero);

    IF(Var_ClienteID != Entero_Cero) THEN
        SELECT Cat.Descripcion, Das.Monto
            FROM LINNEGPRODUCTO Lin,
                 CLIDATSOCIOE Das,
                 CATDATSOCIOE Cat
        WHERE Das.ClienteID = Var_ClienteID
          AND Lin.ProducCreditoID = Var_ProducCredID
          AND Lin.LinNegID = Das.LinNegID
          AND Cat.CatSocioEID = Das.CatSocioEID
          AND Tipo = Tipo_Egreso;
    ELSE
        SELECT Cat.Descripcion, Das.Monto, Tipo, Lin.LinNegID
            FROM LINNEGPRODUCTO Lin,
                 CLIDATSOCIOE Das,
                 CATDATSOCIOE Cat
        WHERE Das.ProspectoID = Var_ProspectoID
          AND Lin.ProducCreditoID = Var_ProducCredID
          AND Lin.LinNegID = Das.LinNegID
          AND Cat.CatSocioEID = Das.CatSocioEID
          AND Tipo = Tipo_Egreso;
    END IF;
END IF;

-- Datos Dependientes Economicos
IF(Par_TipoReporte = Seccion_DepEcono) THEN

    SELECT ClienteID, ProspectoID, SucursalID, ProductoCreditoID INTO
            Var_ClienteID, Var_ProspectoID, Var_SucursalID, Var_ProducCredID
        FROM SOLICITUDCREDITO
        WHERE SolicitudCreditoID = Par_SoliCredID
    LIMIT 1;

    SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);
    SET Var_ProspectoID := IFNULL(Var_ProspectoID, Entero_Cero);
    SET Var_ProducCredID := IFNULL(Var_ProducCredID, Entero_Cero);


    IF(Var_ClienteID != Entero_Cero) THEN
        SELECT CONCAT(Dep.PrimerNombre,
                        (CASE WHEN IFNULL(Dep.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN
                            CONCAT(" ", Dep.SegundoNombre)
                        ELSE ""
                        END),
                        (CASE WHEN IFNULL(Dep.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN
                            CONCAT(" ", Dep.TercerNombre)
                        ELSE ""
                        END),
                       " ", Dep.ApellidoPaterno,
                       " ", Dep.ApellidoMaterno) AS NombreDepend, Rel.Descripcion AS Relacion
            FROM SOCIODEMODEPEND Dep,
                 TIPORELACIONES Rel
            WHERE ClienteID = Var_ClienteID
              AND Dep.TipoRelacionID = Rel.TipoRelacionID;
    ELSE
        SELECT CONCAT(Dep.PrimerNombre,
                        (CASE WHEN IFNULL(Dep.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN
                            CONCAT(" ", Dep.SegundoNombre)
                        ELSE ""
                        END),
                        (CASE WHEN IFNULL(Dep.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN
                            CONCAT(" ", Dep.TercerNombre)
                        ELSE ""
                        END),
                       " ", Dep.ApellidoPaterno,
                       " ", Dep.ApellidoMaterno), Rel.Descripcion
            FROM SOCIODEMODEPEND Dep,
                 TIPORELACIONES Rel
            WHERE ProspectoID = Var_ProspectoID
              AND Dep.TipoRelacionID = Rel.TipoRelacionID;
    END IF;

END IF; -- EndIf Datos Dependientes Economicos

-- Seccion de Avales
IF(Par_TipoReporte = Seccion_Avales) THEN
      DROP TEMPORARY TABLE IF EXISTS TMPAVALESCREDITO;
      CREATE TEMPORARY TABLE TMPAVALESCREDITO (
        TmpID         		INT(11) AUTO_INCREMENT,
        SolicitudCreditoID	INT(11),      # ID de la solicitud de credito
        ClienteIDAval     	INT(11),      # ID del cliente que es aval
        ProspectoIDAval     INT(11),      # ID del prospecto que es aval
        AvalID          	INT(11),      # ID del aval
        NombreAval        	VARCHAR(300),   # Nombre Completo del aval
        FechaNacimiento     DATE,       # Fecha de nacimiento del aval
        Telefono        	VARCHAR(20),    # Telefono del aval
        EstadoCivil       	VARCHAR(50),    # Descripcion del estado civil del aval
        Ocupacion       	TEXT,       # Ocupacion del Aval
        PaisEstado        	VARCHAR(200),   # Pais y Estado de nacimiento del aval
        Calle         		VARCHAR(200),   # Calle de la direccion del aval
        Colonia         	VARCHAR(200),   # Colonia de la direccion del aval
        Municipio       	VARCHAR(100),   # Municipio de la direccion del aval
        Estado          	VARCHAR(100),   # Estado de la direccion del aval
        CP            		VARCHAR(10),    # Codigo postal de la direccion del cliente
        LugarTrabajo      	VARCHAR(100),   # Lugar de trabajo del aval
        TelTrabajo        	VARCHAR(20),    # Telefono del trabajo del aval
        DirTrabajo        	VARCHAR(500),   # La direccion completa del lugar de trabajo del aval
        AntTrabajo        	VARCHAR(40),    # Antiguedad en su trabajo del aval
        PRIMARY KEY (TmpID),
        INDEX idxCliC(ClienteIDAval),
        INDEX idxCliA(AvalID),
        INDEX idxCliP(ProspectoIDAval)
      );




      INSERT INTO TMPAVALESCREDITO(SolicitudCreditoID,  ClienteIDAval,                ProspectoIDAval,            AvalID,                   NombreAval)
          SELECT         Par_SoliCredID,    IFNULL(AvaSol.ClienteID,Entero_Cero),   IFNULL(AvaSol.ProspectoID,Entero_Cero), IFNULL(AvaSol.AvalID,Entero_Cero),      Ava.NombreCompleto
          FROM AVALESPORSOLICI AvaSol
            LEFT OUTER JOIN AVALES  Ava ON AvaSol.AvalID = Ava.AvalID
          WHERE AvaSol.SolicitudCreditoID  = Par_SoliCredID
            AND AvaSol.Estatus IN (Ava_Asignado,Ava_Autorizado);



      # ===============   SE OBTIENEN DATOS CUANDO EL AVAL ES CLIENTE  ================
      UPDATE TMPAVALESCREDITO Tmp,  CLIENTES Cli
                      LEFT OUTER JOIN OCUPACIONES Ocu ON Cli.OcupacionID = Ocu.OcupacionID
        SET Tmp.NombreAval    = Cli.NombreCompleto,
          Tmp.FechaNacimiento =   Cli.FechaNacimiento,
          Tmp.Telefono    =   Cli.Telefono,
          Tmp.Ocupacion   = Ocu.Descripcion,
          Tmp.LugarTrabajo  =   Cli.LugardeTrabajo,
          Tmp.TelTrabajo    =   Cli.TelTrabajo,
          Tmp.AntTrabajo    =   CONCAT(FORMAT( CONCAT(
                              CASE WHEN Var_CalcAntiguedad = Var_SI THEN  CASE WHEN IFNULL(Cli.FechaIniTrabajo,Fecha_Vacia) = Fecha_Vacia
                                  THEN Entero_Cero
                                 ELSE
                                  FLOOR(DATEDIFF(Fecha_Sis,Cli.FechaIniTrabajo) / 365)
                              END
                               ELSE Cli.AntiguedadTra
                              END, '.',
                              CASE WHEN Var_CalcAntiguedad = Var_SI THEN  CASE WHEN IFNULL(Cli.FechaIniTrabajo,Fecha_Vacia) = Fecha_Vacia
                                                      THEN Entero_Cero
                                                     ELSE
                                                      FLOOR((DATEDIFF(Fecha_Sis,Cli.FechaIniTrabajo) - (FLOOR(DATEDIFF(Fecha_Sis,Cli.FechaIniTrabajo) / 365) * 365)) / 30)
                                                  END
                               ELSE Entero_Cero
                              END)
                      , 1), " Años"),
          Tmp.EstadoCivil   =   CASE Cli.EstadoCivil
                        WHEN Est_Soltero    THEN Des_Soltero
                        WHEN Est_CasBieSep  THEN Des_CasBieSep
                        WHEN Est_CasBieMan  THEN Des_CasBieMan
                        WHEN Est_CasCapitu  THEN Des_CasCapitu
                        WHEN Est_Viudo    THEN Des_Viudo
                        WHEN Est_Divorciad  THEN Des_Divorciad
                        WHEN Est_Seperados  THEN Des_Seperados
                        WHEN Est_UnionLibre THEN Des_UnionLibre
                        ELSE Cadena_Vacia
                      END
        WHERE Tmp.ClienteIDAval = Cli.ClienteID
          AND Tmp.ClienteIDAval > Entero_Cero;




      UPDATE  TMPAVALESCREDITO Tmp LEFT OUTER JOIN DIRECCLIENTE Dir ON Tmp.ClienteIDAval = Dir.ClienteID
                     LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON Dir.EstadoID = Mun.EstadoID AND Dir.MunicipioID = Mun.MunicipioID
                     LEFT OUTER JOIN ESTADOSREPUB Est ON Dir.EstadoID = Est.EstadoID
        SET Tmp.Colonia   = Dir.Colonia,
          Tmp.Municipio =   Mun.Nombre,
          Tmp.Estado    =   Est.Nombre,
          Tmp.CP      =   Dir.CP,
          Tmp.Calle   =   CONCAT(IFNULL(Dir.Calle,Cadena_Vacia),
                    CASE WHEN IFNULL(Dir.NumeroCasa, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", No. ", Dir.NumeroCasa) ELSE Cadena_Vacia END,
                    CASE WHEN IFNULL(Dir.NumInterior, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", INTERIOR ", Dir.NumInterior) ELSE Cadena_Vacia END,
                    CASE WHEN IFNULL(Dir.Lote, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", LOTE ", Dir.Lote) ELSE Cadena_Vacia END,
                    CASE WHEN IFNULL(Dir.Manzana, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", MANZANA ", Dir.Manzana) ELSE Cadena_Vacia END,
                    CASE WHEN IFNULL(Dir.Piso, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", PISO ", Dir.Piso) ELSE Cadena_Vacia END)
      WHERE Dir.Oficial       = Dir_Oficial
         AND Tmp.ClienteIDAval  > Entero_Cero;



      UPDATE  TMPAVALESCREDITO Tmp LEFT OUTER JOIN DIRECCLIENTE Dir ON Tmp.ClienteIDAval = Dir.ClienteID
                                      AND Dir.TipoDireccionID = Dir_Trabajo
        SET Tmp.DirTrabajo  =   Dir.DireccionCompleta
      WHERE Tmp.ClienteIDAval   > Entero_Cero;


      UPDATE  TMPAVALESCREDITO Tmp,  CLIENTES Cli LEFT OUTER JOIN ESTADOSREPUB Est ON Cli.EstadoID = Est.EstadoID
                            LEFT OUTER JOIN PAISES Pai ON Cli.LugarNacimiento = Pai.PaisID
        SET Tmp.PaisEstado  = CONCAT(IFNULL(Pai.Nombre, Cadena_Vacia),' ',IFNULL(Est.Nombre, Cadena_Vacia))
      WHERE Tmp.ClienteIDAval = Cli.ClienteID
         AND Tmp.ClienteIDAval  > Entero_Cero;





      # ============== SE OBTIENEN DATOS CUANDO EL AVAL ES PROSPECTO ================
      UPDATE  TMPAVALESCREDITO Tmp,   PROSPECTOS Pro
                      LEFT OUTER JOIN OCUPACIONES Ocu ON Pro.OcupacionID = Ocu.OcupacionID
                      LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON Pro.EstadoID = Mun.EstadoID AND Pro.MunicipioID  = Mun.MunicipioID
                      LEFT OUTER JOIN ESTADOSREPUB Est ON Pro.EstadoID = Est.EstadoID
        SET Tmp.NombreAval    = Pro.NombreCompleto,
          Tmp.FechaNacimiento =   Pro.FechaNacimiento,
          Tmp.Ocupacion   =   Ocu.Descripcion,
          Tmp.LugarTrabajo  =   Pro.LugardeTrabajo,
          Tmp.TelTrabajo    =   Pro.TelTrabajo,
          Tmp.AntTrabajo    =   CONCAT(FORMAT(Pro.AntiguedadTra, 1), " Años"),
          Tmp.Telefono    =   Pro.Telefono,
          Tmp.Colonia     =   Pro.Colonia,
          Tmp.CP        =   Pro.CP,
          Tmp.Municipio   =   Mun.Nombre,
          Tmp.Estado      =   Est.Nombre,
          Tmp.Calle     = CONCAT(IFNULL(Pro.Calle,Cadena_Vacia),
                       CASE WHEN IFNULL(Pro.NumExterior, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", No. ", Pro.NumExterior) ELSE Cadena_Vacia END,
                      CASE WHEN IFNULL(Pro.NumInterior, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", INTERIOR ", Pro.NumInterior) ELSE Cadena_Vacia END,
                      CASE WHEN IFNULL(Pro.Lote, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", LOTE ", Pro.Lote) ELSE Cadena_Vacia END,
                      CASE WHEN IFNULL(Pro.Manzana, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", MANZANA ", Pro.Manzana) ELSE Cadena_Vacia END),
          Tmp.EstadoCivil   = CASE Pro.EstadoCivil
                        WHEN Est_Soltero    THEN Des_Soltero
                        WHEN Est_CasBieSep  THEN Des_CasBieSep
                        WHEN Est_CasBieMan  THEN Des_CasBieMan
                        WHEN Est_CasCapitu  THEN Des_CasCapitu
                        WHEN Est_Viudo    THEN Des_Viudo
                        WHEN Est_Divorciad  THEN Des_Divorciad
                        WHEN Est_Seperados  THEN Des_Seperados
                        WHEN Est_UnionLibre THEN Des_UnionLibre
                        ELSE Cadena_Vacia
                      END
      WHERE Tmp.ProspectoIDAval   = Pro.ProspectoID
         AND  Tmp.ClienteIDAval = Entero_Cero
         AND  Tmp.AvalID      = Entero_Cero
         AND  Tmp.ProspectoIDAval > Entero_Cero;





      # ============== SE OBTIENEN DATOS CUANDO EL AVAL NO ES CLIENTE NI PROSPECTO ================
      UPDATE  TMPAVALESCREDITO Tmp,  AVALES Ava
                  LEFT OUTER JOIN ESTADOSREPUB Est ON Ava.EstadoID = Est.EstadoID
                  LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON Ava.EstadoID = Mun.EstadoID AND Ava.MunicipioID = Mun.MunicipioID
        SET Tmp.Telefono    = Ava.Telefono,
          Tmp.FechaNacimiento = Ava.FechaNac,
          Tmp.Colonia     = Ava.Colonia,
          Tmp.CP        = Ava.CP,
          Estado        = Est.Nombre,
          Municipio     = Mun.Nombre,
          Tmp.Calle   = CONCAT(IFNULL(Ava.Calle,Cadena_Vacia),
                     CASE WHEN IFNULL(Ava.NumExterior, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", No. ", Ava.NumExterior) ELSE Cadena_Vacia END,
                    CASE WHEN IFNULL(Ava.NumInterior, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", INTERIOR ", Ava.NumInterior) ELSE Cadena_Vacia END,
                    CASE WHEN IFNULL(Ava.Lote, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", LOTE ", Ava.Lote) ELSE Cadena_Vacia END,
                    CASE WHEN IFNULL(Ava.Manzana, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", MANZANA ", Ava.Manzana) ELSE Cadena_Vacia END),
          Tmp.EstadoCivil = CASE Ava.EstadoCivil
                        WHEN Est_Soltero    THEN Des_Soltero
                        WHEN Est_CasBieSep  THEN Des_CasBieSep
                        WHEN Est_CasBieMan  THEN Des_CasBieMan
                        WHEN Est_CasCapitu  THEN Des_CasCapitu
                        WHEN Est_Viudo    THEN Des_Viudo
                        WHEN Est_Divorciad  THEN Des_Divorciad
                        WHEN Est_Seperados  THEN Des_Seperados
                        WHEN Est_UnionLibre THEN Des_UnionLibre
                        ELSE Cadena_Vacia
                      END
      WHERE Tmp.AvalID  = Ava.AvalID
         AND Tmp.ClienteIDAval = Entero_Cero
         AND Tmp.AvalID      > Entero_Cero;




      # ================   SE OBTIENE OBTIENEN LOS DATOS QUE ESPERA EL .PRPT   ================
      SELECT NombreAval     AS NombreCompleto,
           FechaNacimiento  AS FechaNac,
           IFNULL(Ocupacion, Cadena_Vacia)    AS Ocupacion,
           IFNULL(Telefono, Cadena_Vacia)     AS Telefono,
           IFNULL(EstadoCivil, Cadena_Vacia)  AS EstadoCivil,
           IFNULL(PaisEstado,Cadena_Vacia)    AS LugarNac,
           IFNULL(Calle, Cadena_Vacia)      AS CalleAval,
           IFNULL(Colonia,Cadena_Vacia)     AS Colonia,
           IFNULL(Municipio,Cadena_Vacia)     AS MunicAval,
           IFNULL(Estado,Cadena_Vacia)      AS EstadoAval,
           IFNULL(CP,Cadena_Vacia)        AS CodPosAval,
           IFNULL(LugarTrabajo, Cadena_Vacia)   AS LugardeTrabajo,
           IFNULL(TelTrabajo,Cadena_Vacia)    AS TelTrabajo,
           IFNULL(DirTrabajo,Cadena_Vacia)    AS DirTrabajo,
           IFNULL(AntTrabajo, Cadena_Vacia)   AS AntigTra
      FROM TMPAVALESCREDITO Tmp;



      # ===================   SE ELIMINAN LOS DATOS TEMPORALES ====================
      DROP TEMPORARY TABLE IF EXISTS TMPAVALESCREDITO;
END IF; -- EndIf Seccion de Avales

-- Seccion de Garantias
IF(Par_TipoReporte = Seccion_Garant) THEN
    SELECT Gar.GarantiaID,
           CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN Cli.NombreCompleto
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN Pro.NombreCompleto
                ELSE Gar.GaranteNombre
            END AS NombreGarante,
           Tig.Descripcion AS Tipo, Clg.Descripcion AS Clasificacion, Gar.ValorComercial,
           Gar.Observaciones
        FROM ASIGNAGARANTIAS Asi,
             TIPOGARANTIAS Tig,
             CLASIFGARANTIAS Clg,
             GARANTIAS Gar
        LEFT OUTER JOIN CLIENTES Cli ON Cli.ClienteID = IFNULL(Gar.ClienteID, Entero_Cero)
        LEFT OUTER JOIN PROSPECTOS Pro ON Pro.ProspectoID = IFNULL(Gar.ProspectoID, Entero_Cero)
                                      AND IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero
        WHERE Asi.SolicitudCreditoID = Par_SoliCredID
          AND Asi.Estatus = Gar_Autorizado
          AND Asi.GarantiaID = Gar.GarantiaID
          AND Gar.TipoGarantiaID = Tig.TipoGarantiasID
          AND Gar.ClasifGarantiaID = Clg.ClasifGarantiaID
          AND Gar.TipoGarantiaID= Clg.TipoGarantiaID;

END IF; -- EndIf Seccion de Garantias

-- Seccion de Referencias
IF(Par_TipoReporte = Seccion_Refere) THEN

    SELECT ClienteID, ProspectoID, SucursalID, ProductoCreditoID INTO
            Var_ClienteID, Var_ProspectoID, Var_SucursalID, Var_ProducCredID
        FROM SOLICITUDCREDITO
        WHERE SolicitudCreditoID = Par_SoliCredID
  LIMIT 1;

    SELECT NombreRef, DomicilioRef, TelefonoRef,
           NombreRef2, DomicilioRef2, TelefonoRef2
        FROM CONOCIMIENTOCTE
        WHERE ClienteID = Var_ClienteID;

END IF; -- EndIf Seccion de Referencias

-- Seccion de Beneficiarios
IF(Par_TipoReporte = Seccion_Benefi) THEN

    SELECT ClienteID, ProspectoID, SucursalID, ProductoCreditoID INTO
            Var_ClienteID, Var_ProspectoID, Var_SucursalID, Var_ProducCredID
        FROM SOLICITUDCREDITO
        WHERE SolicitudCreditoID = Par_SoliCredID
    LIMIT 1;

    SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);

    SELECT Per.CuentaAhoID AS Cuenta, Per.NombreCompleto, Tip.Descripcion AS Relacion, Per.Porcentaje,
           Per.FechaNac, Per.TelefonoCasa, Per.TelefonoCelular
        FROM CUENTASAHO Cue,
             CUENTASPERSONA Per,
             TIPORELACIONES Tip
      WHERE Cue.ClienteID = Var_ClienteID
        AND Cue.Estatus = Cue_Activa
        AND Cue.CuentaAhoID = Per.CuentaAhoID
        AND Per.EstatusRelacion = Est_Vigente
        AND Per.EsBeneficiario = Es_Beneficiario
        AND Per.ParentescoID = Tip.TipoRelacionID
        AND Per.EstatusRelacion = Est_Vigente;
  END IF; -- EndIf Seccion de Beneficiarios




-- Reporte personalizado Yanga
IF (Par_TipoReporte = TipoRep_Yanga) THEN

SELECT Sol.ClienteID,       Cli.NombreCompleto, DireccionCompleta,  Cli.Telefono,       Cli.EstadoCivil,
       Cli.LugardeTrabajo,  Cli.Puesto,         Cli.TelTrabajo,
    CASE WHEN Var_CalcAntiguedad = Var_SI THEN  CASE WHEN IFNULL(Cli.FechaIniTrabajo,Fecha_Vacia) = Fecha_Vacia
                                  THEN Entero_Cero
                                 ELSE
                                  ROUND(DATEDIFF(Fecha_Sis,Cli.FechaIniTrabajo) / 365)
                              END
           ELSE Cli.AntiguedadTra
    END,
      Sol.FechaAutoriza,
       Sol.MontoAutorizado, Pro.Descripcion,    Usu.NombreCompleto, Sol.AporteCliente,  Sol.NumAmortizacion,
       Sol.ClasiDestinCred, Des.Descripcion,    Cli.FechaNacimiento,Sol.CreditoID
  INTO
       Var_ClienteID,       Var_NombreCli,      Var_DireClien,      Var_CliTelPart,     Var_ClaveEstCiv,
       Var_CliLugTra,       Var_Ocupacion,      Var_CliTelTra,      Var_CliAntTra,      Var_FechaAutoSol,
       Var_MontoSolici,     Var_DesProducto,    Var_UsuAutoriza,    Var_GarantiaLiq,    Var_Plazo,
       Var_Destino,         Var_Finalidad,      Var_FecNacCli,       Var_CreditoID
       FROM DIRECCLIENTE   Dir
       LEFT JOIN CLIENTES Cli
       ON Dir.ClienteID = Cli.ClienteID
       AND Dir.Oficial  = SI
       LEFT JOIN SOLICITUDCREDITO Sol
       ON Cli.ClienteID = Sol.ClienteID
       LEFT JOIN  DESTINOSCREDITO Des
       ON Des.DestinoCreID = Sol.DestinoCreID
       LEFT JOIN  PRODUCTOSCREDITO Pro
       ON Sol.ProductoCreditoID = Pro.ProducCreditoID
       LEFT JOIN USUARIOS Usu
       ON  Sol.UsuarioAutoriza = Usu.UsuarioID
      WHERE Sol.SolicitudCreditoID = Par_SoliCredID LIMIT 1;

    SELECT  CONCAT(PrimerNombre,' ',SegundoNombre,' ', IFNULL(TercerNombre,''),' ',IFNULL(ApellidoPaterno,''),' ',IFNULL(ApellidoMaterno,'')) AS NombreConyuge,
        FechaNacimiento,ClienteConyID
        INTO Var_ConyNomCom, Var_ConyFecNac, Var_ClienteConyID
        FROM SOCIODEMOCONYUG
        WHERE ClienteID=Var_ClienteID
    LIMIT 1;

SELECT Viv.Descripcion, Soc.TiempoHabitarDom , COUNT(Dep.ClienteID)
        INTO
        Var_TipoVivienda, VarTiempoHabi, Var_NumDepend
        FROM SOCIODEMOVIVIEN Soc
      INNER JOIN TIPOVIVIENDA Viv   ON   Soc.TipoViviendaID= Viv.TipoViviendaID
      LEFT JOIN SOCIODEMODEPEND Dep ON Soc.ClienteID = Dep.CLienteID
        WHERE Soc.ClienteID=Var_ClienteID
          LIMIT 1;

 SELECT NombreRef, DomicilioRef, TelefonoRef,
        NombreRef2, DomicilioRef2, TelefonoRef2
        INTO
        Var_NombreRef, Var_DomicilioRef, Var_TelefonoRef,
        Var_NombreRef2,Var_DomicilioRef2,Var_TelefonoRef2
      FROM CONOCIMIENTOCTE
        WHERE ClienteID = Var_ClienteID
          LIMIT 1;



SET Var_ClienteEdad := FLOOR(DATEDIFF(Fecha_Sis, Var_FecNacCli) / 365);
SET Var_ConyugeEdad := FLOOR(DATEDIFF(Fecha_Sis, Var_ConyFecNac) / 365);
 SELECT DireccionCompleta
    INTO
        Var_DirTra
    FROM DIRECCLIENTE
    WHERE ClienteID= Var_ClienteID
    AND   TipoDireccionID= TipoDirTrab LIMIT 1;

    SELECT NombreSucurs,    DirecCompleta, Nombre
    INTO   Var_NombreSucur, Var_DirSucur,  Var_EstadoSuc
    FROM SUCURSALES    Suc,
         ESTADOSREPUB  Est
    WHERE SucursalID=Aud_Sucursal
    AND Suc.EstadoID = Est.EstadoID
  LIMIT 1;

    SET Var_Fecha := CONCAT(Var_NombreSucur,',',' ',Var_EstadoSuc,',',' ',SUBSTRING(Fecha_Sis,9, 10),' ', 'DE','');
    SET Var_Mes   := SUBSTRING(Fecha_Sis,6, 7);
  SET Var_Mes   := SUBSTRING(Var_Mes,1, 2);

    SET Var_Mes :=      CASE Var_Mes
                        WHEN '01' THEN TxtEnero
                        WHEN '02' THEN TxtFebrero
                        WHEN '03' THEN TxtMarzo
                        WHEN '04' THEN TxtAbril
                        WHEN '05' THEN TxtMayo
                        WHEN '06' THEN TxtJunio
                        WHEN '07' THEN TxtJulio
                        WHEN '08' THEN TxtAgosto
                        WHEN '09' THEN TxtSeptiembre
                        WHEN '10' THEN TxtOctubre
                        WHEN '11' THEN TxtNoviembre
                        WHEN '12' THEN TxtDiciembre
                    END ;

    SET Var_Fecha := CONCAT(Var_Fecha,' ',Var_Mes,' ','DE',' ',SUBSTRING(Fecha_Sis,1, 4));


    SET Var_Fecha :=  UPPER(Var_Fecha);

SELECT Var_ClienteID,       Var_NombreCli,      Var_DireClien,      Var_CliTelPart,     Var_ClaveEstCiv,
       Var_CliLugTra,       Var_Ocupacion,      Var_CliTelTra,      Var_CliAntTra,      Var_FechaAutoSol,
       Var_MontoSolici,     Var_DesProducto,    Var_UsuAutoriza,    Var_GarantiaLiq,    Var_Plazo,
       Var_Destino,         Var_Finalidad,      Var_ClienteEdad,    Var_CreditoID,      Var_ConyNomCom,
       Var_ConyugeEdad,     Var_TipoVivienda,   VarTiempoHabi,      Var_NumDepend,      Var_NombreRef,
       Var_DomicilioRef,    Var_TelefonoRef,    Var_NombreRef2,     Var_DomicilioRef2,  Var_TelefonoRef2,
       IFNULL(Var_AvalID,Entero_Cero)AS
       Var_AvalID,          Var_TipoGar,        Var_ValorGar,       Var_FechaAvaluo,    Var_DirTra,
       Var_DirSucur,        Var_Fecha,          Var_ClienteConyID;

END IF;

IF(Par_TipoReporte = TipoRep_YangaAutor) THEN
    SELECT Usu.NombreCompleto
    FROM ESQUEMAAUTFIRMA,
         USUARIOS Usu
        WHERE UsuarioID = UsuarioFirma
        AND SolicitudCreditoID = Par_SoliCredID;

END IF;

IF(Par_TipoReporte = RepYangaDatCte) THEN

  SELECT Sol.ClienteID,       Cli.NombreCompleto,
       Sol.FechaAutoriza,
       Sol.MontoAutorizado, Pro.Descripcion,    Sol.AporteCliente,  Sol.NumAmortizacion,
       Sol.ClasiDestinCred, Des.Descripcion,    Sol.CreditoID
       INTO
       Var_ClienteID,       Var_NombreCli,      Var_FechaAutoSol,
       Var_MontoSolici,     Var_DesProducto,    Var_GarantiaLiq,    Var_Plazo,
       Var_Destino,         Var_Finalidad,      Var_CreditoID
       FROM DIRECCLIENTE   Dir
       LEFT JOIN CLIENTES Cli
       ON Dir.ClienteID = Cli.ClienteID
       AND Dir.Oficial  = 'S'
       LEFT JOIN SOLICITUDCREDITO Sol
       ON Cli.ClienteID = Sol.ClienteID
       LEFT JOIN  DESTINOSCREDITO Des
       ON Des.DestinoCreID = Sol.DestinoCreID
       LEFT JOIN  PRODUCTOSCREDITO Pro
       ON Sol.ProductoCreditoID = Pro.ProducCreditoID
       LEFT JOIN USUARIOS Usu
       ON  Sol.UsuarioAutoriza = Usu.UsuarioID
      WHERE Sol.SolicitudCreditoID = Par_SoliCredID LIMIT 1;

SELECT  CONCAT(PrimerNombre,' ',SegundoNombre,' ', IFNULL(TercerNombre,''),' ',IFNULL(ApellidoPaterno,''),' ',IFNULL(ApellidoMaterno,'')) AS NombreConyuge,
        FechaNacimiento,ClienteConyID
        INTO Var_ConyNomCom, Var_ConyFecNac, Var_ClienteConyID
      FROM SOCIODEMOCONYUG
        WHERE ClienteID=Var_ClienteID LIMIT 1;

SELECT AvalID, Descripcion, ValorComercial, FechaValuacion, Gar.TipoGarantiaID
        INTO
        Var_AvalID, Var_TipoGar,Var_ValorGar,Var_FechaAvaluo, Var_TipoGarantiaID
       FROM GARANTIAS   Gar
       LEFT JOIN  ASIGNAGARANTIAS Gas
       ON Gar.GarantiaID = Gas.GarantiaID AND Gas.Estatus ='U',
       TIPOGARANTIAS    Tga
      WHERE Gar.TipoGarantiaID =  Tga.TipoGarantiasID
         AND Gas.SolicitudCreditoID =Par_SoliCredID
         ORDER BY Descripcion LIMIT 1;

  SET Var_TipoGarantiaID := IFNULL(Var_TipoGarantiaID,Entero_Cero);

  SELECT AvalID, ClienteID,ProspectoID
        INTO
        Var_AvalID, Var_AvalCliID, Var_AvalProsID
      FROM AVALESPORSOLICI
        WHERE SolicitudCreditoID=Par_SoliCredID LIMIT 1;

    CASE  WHEN Var_TipoGarantiaID =2 THEN  SET Var_TipoGar:= 'PRENDARIA';
          WHEN Var_TipoGarantiaID =3 THEN  SET Var_TipoGar:='HIPOTECARIA';
        ELSE
           IF(Var_AvalID > Entero_Cero OR Var_AvalCliID > Entero_Cero OR Var_AvalProsID > Entero_Cero) THEN
                SET Var_TipoGar:= 'QUIROGRAFARIA';
                ELSE
                SET Var_TipoGar:= 'N/A';
            END IF;
    END CASE;
    SET Var_Finalidad :=  UPPER(Var_Finalidad);
  SELECT Var_ClienteID,       Var_NombreCli,      Var_FechaAutoSol,
       Var_MontoSolici,     Var_DesProducto,    Var_GarantiaLiq,    Var_Plazo,
       Var_Destino,         Var_Finalidad,      Var_CreditoID,
    Var_ConyNomCom, Var_ConyFecNac, Var_ClienteConyID
Var_AvalID, Var_TipoGar,Var_ValorGar,Var_FechaAvaluo, Var_TipoGarantiaID, Var_TipoGar ;


END IF; --  END IF Reporte personalizado Yanga

-- Seccion Haberes Socios(Cuenta)
IF(Par_TipoReporte = Seccion_Cuenta) THEN
   SELECT   LPAD(CONVERT(Ca.CuentaAhoID, CHAR),10,0) AS CuentaAhoID,
      LPAD(CONVERT(Ca.ClienteID, CHAR),10,0) AS ClienteID,
        Tip.Descripcion, Ca.Etiqueta,
        FORMAT(Ca.Saldo,2)AS Saldo,   FORMAT(Ca.SaldoDispon,2)AS SaldoDispon,
        FORMAT(Ca.SaldoBloq,2)AS SaldoBloq, FORMAT(Ca.SaldoSBC,2)AS SaldoSBC
          FROM CUENTASAHO Ca
            INNER JOIN TIPOSCUENTAS Tip
              ON(Tip.TipoCuentaID = Ca.TipoCuentaID)
                INNER JOIN SOLICITUDCREDITO Sol
              ON(Sol.ClienteID = Ca.ClienteID)
              WHERE SolicitudCreditoID = Par_SoliCredID;
END IF; -- EndIf Seccion_Cuenta

-- Seccion Haberes Socios(Inversion)
IF(Par_TipoReporte = Seccion_Inversion) THEN
    SELECT  LPAD(CONVERT(Inv.InversionID, CHAR),10,0) AS InversionID,
          LPAD(CONVERT(Cli.ClienteID, CHAR),10,0) AS ClienteID,Cat.Descripcion,
          Inv.Etiqueta, Inv.FechaInicio,    Inv.FechaVencimiento,  Inv.Monto,
          CONVERT(Inv.TasaNeta, CHAR)   AS TasaNeta,
          FORMAT(Inv.InteresGenerado,2)AS InteresGenerado,
          FORMAT(Inv.InteresRetener,2)AS InteresRetener,
          FORMAT(Inv.InteresRecibir,2)AS InteresRecibir
        FROM INVERSIONES Inv
          INNER JOIN CLIENTES Cli
              ON (Cli.ClienteID=Inv.ClienteID)
          INNER JOIN CATINVERSION Cat
              ON (Cat.TipoInversionID=Inv.TipoInversionID)
          INNER JOIN SOLICITUDCREDITO Sol
              ON(Sol.ClienteID = Cli.ClienteID)
          WHERE Sol.SolicitudCreditoID=Par_SoliCredID
            AND Inv.Estatus = Inv_Vigente;
END IF; -- EndIf Seccion_Inversion


-- Reporte personalizado para Plan Ideal

IF(Par_TipoReporte = Con_SoliCredito) THEN

  SELECT
    Sol.ClienteID,    Sol.ProductoCreditoID,  Sol.MontoSolici, CONCAT('$ ', FORMAT(Sol.MontoCuota,2)),
    Sol.NumAmortizacion, FORMAT(Sol.TasaFija, 2) AS TasaFija, Sol.ValorCAT,
    Prod.Descripcion,
    CASE Sol.FrecuenciaCap
        WHEN FrecSemanal    THEN UPPER(TxtSemanal)
                WHEN FrecCatorcenal   THEN UPPER(TxtCatorcenal)
                WHEN FrecQuincenal    THEN UPPER(TxtQuincenal)
                WHEN FrecMensual    THEN UPPER(TxtMensual)
                WHEN FrecPeriodica    THEN UPPER(TxtPeriodica)
                WHEN FrecBimestral    THEN UPPER(TxtBimestral)
                WHEN FrecTrimestral   THEN UPPER(TxtTrimestral)
                WHEN FrecTetramestral   THEN UPPER(TxtTetramestral)
                WHEN FrecSemestral    THEN UPPER(TxtSemestral)
                WHEN FrecAnual      THEN UPPER(TxtAnual)
        WHEN FrecLibre      THEN UPPER(TxtLibres)


      END AS Frecuencia,
    CASE Sol.ProductoCreditoID
    WHEN 1400 THEN 'Pago de Deuda'
    ELSE 'Uso Personal' END AS DestinoCredito,
    IFNULL(Prod.RegistroRECA,'') AS RegistroRECA, IFNULL(FORMAT(Prod.FactorMora, 2), 'NA') AS FactorMora,
    Nom.NombreInstit
  INTO
    Var_ClienteID,  Var_ProducCredID,   Var_MontoSolici,  Var_MontoCuota,
    Var_NumAmortiza,  Var_Tasa,   Var_ValorCAT, Var_DesProducto,  Var_Frecuencia, Var_Destino,
    Var_RegRECA, Var_FactorMora, Var_InstitNomina
  FROM SOLICITUDCREDITO Sol
  INNER JOIN PRODUCTOSCREDITO Prod ON Sol.ProductoCreditoID = Prod.ProducCreditoID
  LEFT JOIN INSTITNOMINA Nom ON Sol.InstitucionNominaID = Nom.InstitNominaID
  WHERE SolicitudCreditoID = Par_SoliCredID
  LIMIT 1;

  SELECT Nombre,  UPPER(NombreCorto) AS NombreCorto
  INTO Var_NomInstitu, Var_NomCortoIns
  FROM INSTITUCIONES Ins
  INNER JOIN PARAMETROSSIS Par ON Ins.InstitucionID = Par.InstitucionID
  LIMIT 1;

  SELECT
    CONCAT(Cli.PrimerNombre, ' ', Cli.SegundoNombre) AS NombreCli,  Cli.ApellidoPaterno, Cli.ApellidoMaterno, Cli.NombreCompleto,
    FUNCIONLETRASFECHA(Cli.FechaNacimiento) AS FechaNac, FUNCIONLETRASFECHA(Cli.FechaAlta) AS FechaAlta,
    Cli.CURP, Cli.Nacion, Cli.Correo, Cli.RFC, Cli.Sexo, Cli.EstadoCivil, Cli.LugarNacimiento,
    Cli.EstadoID, Ocu.Descripcion, Cli.LugardeTrabajo, Cli.Puesto, CONCAT(Cli.TelTrabajo, ' Ext.: ', Cli.ExtTelefonoTrab) AS TelTrabajo,
    CONVERT(Cli.AntiguedadTra, UNSIGNED), Cli.TelefonoCelular,
    Cli.Telefono,  CONCAT(Muni.Nombre, ', ', Edo.Nombre) AS Ciudad, Muni.Nombre,  Dir.Colonia,
    CONCAT(Dir.Calle, ' ', Dir.NumeroCasa) AS Calle,  Dir.CP,

    CONCAT(Tra.Calle, ' No. ', Tra.NumeroCasa) AS CalleTra, IFNULL(Tra.Colonia, '') AS TraColonia,
    CONCAT(EdoTra.Nombre, ', ', MuniTra.Nombre) AS CiudadTra, MuniTra.Nombre, Tra.CP

  INTO Var_NombreCli, Var_ApePaterno, Var_ApeMaterno, Var_CliNomCompl, Var_CliFechaNac, Var_Fecha,
    Var_CliCURP, Var_CliNacion, Var_CliCorreo, Var_CliRFC, Var_CliSexo, Var_ClaveEstCiv, Var_PaisNac,
    Var_EstadoNac, Var_Ocupacion, Var_CliLugTra, Var_CliPuesto, Var_CliTelTra, Var_DesCliAntTra, Var_CliTelCel,
    Var_CliTelPart, Var_CliCiudad, Var_CliMunici, Var_CliColoni,
    Var_CliCalle, Var_CliCP, Var_CalleTra, Var_ColTra, Var_CiudadTra, Var_MuniTra, Var_CPTra

  FROM CLIENTES Cli
  LEFT JOIN DIRECCLIENTE Dir ON Cli.ClienteID = Dir.ClienteID AND Dir.Oficial= Dir_Oficial
  INNER JOIN ESTADOSREPUB Edo ON Dir.EstadoID = Edo.EstadoID
  INNER JOIN MUNICIPIOSREPUB Muni ON Dir.EstadoID = Muni.EstadoID AND Dir.MunicipioID = Muni.MunicipioID
  LEFT JOIN DIRECCLIENTE Tra ON Cli.ClienteID = Tra.ClienteID AND Tra.TipoDireccionID = Dir_Trabajo
  LEFT JOIN ESTADOSREPUB EdoTra ON Tra.EstadoID = EdoTra.EstadoID
  LEFT JOIN MUNICIPIOSREPUB MuniTra ON Tra.EstadoID = MuniTra.EstadoID AND Tra.MunicipioID = MuniTra.MunicipioID
  LEFT JOIN OCUPACIONES Ocu ON Cli.OcupacionID = Ocu.OcupacionID
  WHERE Cli.ClienteID = Var_ClienteID
  LIMIT 1;

  SELECT
    Gral.NumDepenEconomi, Viv.TipoViviendaID, Esc.Descripcion
  INTO Var_NumDepend, Var_TipoVivienda, Var_EscoCli
  FROM SOCIODEMOGRAL Gral
  LEFT JOIN SOCIODEMOVIVIEN Viv ON Gral.ClienteID = Viv.ClienteID
  INNER JOIN CATGRADOESCOLAR Esc ON Gral.GradoEscolarID = Esc.GradoEscolarID
  WHERE Gral.ClienteID = Var_ClienteID
  LIMIT 1;

  SELECT CONCAT('$ ', FORMAT(Monto,2))
    INTO Var_Ingresos
  FROM CLIDATSOCIOE Cli
  WHERE Cli.ClienteID = Var_ClienteID AND LinNegID = TipoLinaNeg AND CatSocioEID = 1
  LIMIT 1;

  SET Var_TipoVivienda=IFNULL(Var_TipoVivienda,0);
  SELECT
    NombreRef, NombreRef2, DomicilioRef, DomicilioRef2, TelefonoRef, TelefonoRef2,
    extTelefonoRefUno, extTelefonoRefDos, Rel.Descripcion, Rel2.Descripcion
  INTO Var_NombreRef, Var_NombreRef2, Var_DomicilioRef, Var_DomicilioRef2, Var_TelefonoRef,
    Var_TelefonoRef2, Var_ExtRef, Var_ExtRef2, Var_Relacion,Var_Relacion2
  FROM CONOCIMIENTOCTE Cono
  LEFT JOIN TIPORELACIONES Rel ON Cono.TipoRelacion1 = Rel.TipoRelacionID
  LEFT JOIN TIPORELACIONES Rel2 ON Cono.TipoRelacion2 = Rel2.TipoRelacionID
  WHERE ClienteID = Var_ClienteID
  LIMIT 1;

  SELECT
    Var_ClienteID,    Var_ProducCredID,   Var_MontoSolici,  Var_MontoCuota, Var_NumAmortiza,
    Var_Tasa,       Var_ValorCAT,     Var_DesProducto,  Var_Frecuencia, Var_Destino,
    Var_RegRECA,    Var_FactorMora,   Var_InstitNomina,   Var_NomInstitu, Var_NomCortoIns,
    Var_NombreCli,    Var_ApePaterno,   Var_ApeMaterno,   Var_CliNomCompl,Var_CliFechaNac,
    Var_Fecha,
    Var_CliCURP,    Var_CliNacion,    Var_CliCorreo,    Var_CliRFC,   Var_CliSexo,
    Var_ClaveEstCiv,  Var_PaisNac,    Var_EstadoNac,    Var_Ocupacion,  Var_CliLugTra,
    Var_CliPuesto,    Var_CliTelTra,    Var_DesCliAntTra,   Var_CliTelCel,  Var_CliTelPart,
    Var_CliCiudad,    Var_CliMunici,    Var_CliColoni,    Var_CliCalle,   Var_CliCP,
    Var_NumDepend,    Var_TipoVivienda,   Var_EscoCli,    Var_CalleTra,   Var_ColTra,
    Var_CiudadTra,    Var_MuniTra,    Var_CPTra,      Var_Ingresos,
    Var_NombreRef,  Var_DomicilioRef, Var_TelefonoRef,  Var_NombreRef2, Var_DomicilioRef2,
    Var_TelefonoRef2, Var_ExtRef, Var_ExtRef2, Var_Relacion,Var_Relacion2;
END IF;



  #  ===================== Reporte personalizado para Tu Lanita Rapida ====================
  IF(Par_TipoReporte = TipoRep_TuLanita) THEN

    SET Var_ProspectoID := (SELECT ProspectoID FROM SOLICITUDCREDITO WHERE  SolicitudCreditoID = Par_SoliCredID AND ClienteID = Entero_Cero);
    IF(IFNULL(Var_ProspectoID, Entero_Cero) = Entero_Cero)THEN

        # ES UN CLIENTE
        SELECT
          Sol.ClienteID,      Sol.MontoSolici,      Sol.NumAmortizacion,  Sol.FolioCtrl,      Est.Nombre,
          CONCAT(Cli.PrimerNombre,' ',Cli.SegundoNombre, ' ',Cli.TercerNombre),   Cli.ApellidoPaterno,    Cli.ApellidoMaterno,  Cli.FechaNacimiento,  Nom.NombreInstit,
          Dir.Calle,        Dir.NumInterior,      Dir.NumeroCasa,     Dir.Colonia,      Mun.Nombre,
          Dir.CP,         Est2.Nombre,        Cli.Telefono,     Cli.TelefonoCelular,  Cli.Correo,
          Cli.NombreCompleto,   Pro.NombrePromotor,     Cli.CURP,       Cli.RFC,        Cli.LugardeTrabajo,
          Cli.TelTrabajo,     Cli.ExtTelefonoTrab,
          CASE WHEN Var_CalcAntiguedad = Var_SI THEN  CASE WHEN IFNULL(Cli.FechaIniTrabajo,Fecha_Vacia) = Fecha_Vacia
                                  THEN Entero_Cero
                                 ELSE
                                  ROUND(DATEDIFF(Fecha_Sis,Cli.FechaIniTrabajo) / 365)
                              END
           ELSE Cli.AntiguedadTra
          END,
          Ocu.Descripcion,    CONCAT('RECA: ',Pcr.RegistroRECA),
          Des.Descripcion,    Cli.TipoEmpleado,     Cli.TipoPuesto,     Sol.MontoCuota,     Loc.NombreLocalidad,
          CASE WHEN Sol.DestinoCreID = 20020 THEN 'RD'  -- Refinanciamientode otras deudas
             WHEN Sol.DestinoCreID = 20021 THEN 'VV'  -- Vivienda
             WHEN Sol.DestinoCreID = 20003 THEN 'GP'  -- Gastos Personales
             WHEN Sol.DestinoCreID = 20005 THEN 'GM'  -- Gastos Medicos
             WHEN Sol.DestinoCreID = 20006 THEN 'GE'  -- Gastos Educativos
             WHEN Sol.DestinoCreID = 20011 THEN 'AM'  -- Automovil
             WHEN Sol.DestinoCreID = 20012 THEN 'VC'  -- Vacaciones
             WHEN Sol.DestinoCreID = 20013 THEN 'NP'  -- Negocio Propio
             WHEN Sol.DestinoCreID = 20014 THEN 'PS'  -- Pago de Servicios
             WHEN Sol.DestinoCreID = 20015 THEN 'ME'  -- Muebles y Electrodomesticos
             WHEN Sol.DestinoCreID = 20016 THEN 'IE'  -- Imprevistos/Emergencias
             WHEN Sol.DestinoCreID = 20017 THEN 'GF'  -- Gastos Familiares
             WHEN Sol.DestinoCreID = 20018 THEN 'LQ'  -- Liquidez
             ELSE 'OT'  -- Otros
          END,
          CASE WHEN Cli.EstadoCivil = Est_CasBieSep  THEN 'C' -- C = casado
             WHEN Cli.EstadoCivil = Est_CasBieMan  THEN 'C' -- C = casado
             WHEN Cli.EstadoCivil = Est_CasCapitu  THEN 'C' -- C = casado
             WHEN Cli.EstadoCivil = Est_Soltero    THEN 'S'  -- S = soltero
             WHEN Cli.EstadoCivil = Est_Viudo    THEN 'V'  -- V = viudo
             WHEN Cli.EstadoCivil = Est_UnionLibre THEN 'U'  -- U = union libre
             ELSE 'O' -- O = Otro
          END,
          CASE WHEN Cli.Nacion = Nac_Mexicano THEN Des_Mexicano
             ELSE Des_Extranjero
          END
        INTO
          Var_ClienteID,      Var_MontoSolici,    Var_Plazo,        Var_Empleado,       Var_EstadoNac,
          Var_NombreCli,      Var_ApePaterno,     Var_ApeMaterno,     Var_CliFechaNac,      Var_InstitNomina,
          Var_CliCalle,     Var_CliNumInt,      Var_CliNumCasa,     Var_CliColoni,        Var_CliMunici,
          Var_CliCP,        Var_CliEstado,      Var_CliTelPart,     Var_CliTelCel,        Var_CliCorreo,
          Var_NombreCliente,    Var_NombrePromotor,   Var_CliCURP,      Var_CliRFC,         Var_CliLugTra,
          Var_CliTelTra,      Var_ExtTelTra,      Var_CliAntTra,      Var_Ocupacion,        Var_RegRECA,
          Var_DestinoDes,     Var_CliSegmento,    Var_CliPuesto,      Var_MontoCuota,       Var_CliCiudad,
          Var_Destino,
          Var_ClaveEstCiv,
          Var_CliNacion
        FROM SOLICITUDCREDITO Sol
          INNER JOIN DESTINOSCREDITO Des ON Sol.DestinoCreID = Des.DestinoCreID
          INNER JOIN CLIENTES Cli ON Sol.ClienteID = Cli.ClienteID
          LEFT OUTER JOIN INSTITNOMINA Nom ON Sol.InstitucionNominaID = Nom.InstitNominaID
          LEFT OUTER JOIN ESTADOSREPUB Est ON Cli.EstadoID = Est.EstadoID -- para el lugar de nacimiento del cliente
          LEFT OUTER JOIN DIRECCLIENTE Dir ON (Cli.ClienteID = Dir.ClienteID AND Oficial = Dir_Oficial)
          LEFT OUTER JOIN LOCALIDADREPUB Loc ON (Dir.EstadoID = Loc.EstadoID AND Dir.MunicipioID = Loc.MunicipioID AND Dir.LocalidadID = Loc.LocalidadID)
          LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON (Dir.EstadoID = Mun.EstadoID AND Dir.MunicipioID = Mun.MunicipioID)
          LEFT OUTER JOIN ESTADOSREPUB Est2 ON Dir.EstadoID = Est2.EstadoID -- para el estado de la direccion oficial del cliente
          LEFT OUTER JOIN PROMOTORES Pro ON Cli.PromotorActual = Pro.PromotorID
          LEFT OUTER JOIN OCUPACIONES Ocu ON Cli.OcupacionID = Ocu.OcupacionID
          LEFT OUTER JOIN PRODUCTOSCREDITO Pcr ON Pcr.ProducCreditoID = Sol.ProductoCreditoID
        WHERE SolicitudCreditoID = Par_SoliCredID
        LIMIT 1;
        SET Var_InstitNomina  := IFNULL(Var_InstitNomina, " ");
        IF(IFNULL(Var_MontoCuota, Decimal_Cero) <= Decimal_Cero)THEN
          SET Var_MontoCuota  := '0.0';
        END IF;

        # Verifica el tipo de vivienda del cliente, propia,rentada, de familiar u otra
        SELECT CASE WHEN Viv.TipoViviendaID = 1 THEN 'P' -- P = Propia
                            WHEN Viv.TipoViviendaID = 5 THEN 'P' -- P = Propia
                            WHEN Viv.TipoViviendaID = 2 THEN 'R' -- R = Rentada
                            WHEN Viv.TipoViviendaID = 6 THEN 'R' -- R = Rentada
                            WHEN Viv.TipoViviendaID = 4 THEN 'F' -- F = De Familiar
                            WHEN Viv.TipoViviendaID = 8 THEN 'F' -- F = De Familiar
                            ELSE 'O'               -- O = Otro
                           END,
             CASE WHEN Viv.TiempoHabitarDom > Entero_Cero THEN Viv.TiempoHabitarDom / Meses_Anio ELSE Entero_Cero END,  Descripcion
        INTO      Var_TipoVivienda, VarTiempoHabi,    Var_DescVivienda
        FROM SOCIODEMOVIVIEN Viv
        WHERE Viv.ClienteID = Var_ClienteID LIMIT 1;

        IF(Var_TipoVivienda = 'R')THEN
          SET Var_MontoRenta  := (SELECT Dat.Monto
                      FROM CLIDATSOCIOE Dat
                      WHERE Dat.ClienteID = Var_ClienteID
                        AND Dat.CatSocioEID = 2); -- 2.- Renta Mensual
        END IF;
        SET Var_MontoRenta  := IFNULL(Var_MontoRenta, Decimal_Cero);

        # Verfica el numero de dependientes que tiene el cliente
        SET Var_NumDepend := IFNULL((SELECT COUNT(DependienteID) FROM SOCIODEMODEPEND WHERE ClienteID = Var_ClienteID), Entero_Cero);

        # Vefica la direccion de trabajo del cliente
        SELECT CONCAT(Dir.Calle, ' No. ',Dir.NumeroCasa, CASE WHEN IFNULL(Dir.NumInterior, Cadena_Vacia) != Cadena_Vacia
                                    THEN CONCAT(', Int. ', Dir.NumInterior)
                                     ELSE Cadena_Vacia
                                 END,
                                 CASE WHEN IFNULL(Dir.Lote, Cadena_Vacia) != Cadena_Vacia
                                    THEN CONCAT(', Lote ', Dir.Lote)
                                     ELSE Cadena_Vacia
                                 END,
                                 CASE WHEN IFNULL(Dir.Manzana, Cadena_Vacia) != Cadena_Vacia
                                    THEN CONCAT(', Mz. ', Dir.Manzana)
                                     ELSE Cadena_Vacia
                                 END),  Col.Asentamiento,
            Mun.Nombre,     Est.Nombre,   Dir.CP
        INTO Var_DirTrabajo,    Var_ColTra,   Var_CiudadTra,    Var_EstadoTra,    Var_CPTra
        FROM DIRECCLIENTE Dir
          LEFT OUTER JOIN COLONIASREPUB Col ON (Dir.ColoniaID = Col.ColoniaID AND Dir.MunicipioID = Col.MunicipioID AND Dir.EstadoID = Col.EstadoID)
          LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON (Dir.MunicipioID = Mun.MunicipioID AND Dir.EstadoID = Mun.EstadoID )
          LEFT OUTER JOIN ESTADOSREPUB  Est ON Dir.EstadoID = Est.EstadoID
        WHERE Dir.ClienteID = Var_ClienteID
          AND Dir.TipoDireccionID = TipoDirTrab
        LIMIT 1;


        # Verifica los datos de las referencias personales
        SELECT Con.NombreRef,   Con.NombreRef2,     Con.DomicilioRef,   Con.DomicilioRef2,    Con.TelefonoRef,
             Con.TelefonoRef2,  Rel.Descripcion,    Rel2.Descripcion
        INTO   Var_NombreRef,   Var_NombreRef2,     Var_DomicilioRef,   Var_DomicilioRef2,    Var_TelefonoRef,
             Var_TelefonoRef2,  Var_Relacion,     Var_Relacion2
        FROM CONOCIMIENTOCTE Con
          LEFT OUTER JOIN TIPORELACIONES Rel ON Con.TipoRelacion1 = Rel.TipoRelacionID
          LEFT OUTER JOIN TIPORELACIONES Rel2 ON Con.TipoRelacion2 = Rel2.TipoRelacionID
        WHERE Con.ClienteID = Var_ClienteID
        LIMIT 1;

    # ES UN PROSPECTO
    ELSE
        SELECT
          Sol.ClienteID,      Sol.MontoSolici,      Sol.NumAmortizacion,  Sol.FolioCtrl,      Est.Nombre,
          CONCAT(Pro.PrimerNombre,' ',Pro.SegundoNombre, ' ',Pro.TercerNombre),   Pro.ApellidoPaterno,  Pro.ApellidoMaterno,  Pro.FechaNacimiento,  Nom.NombreInstit,
          Pro.Calle,        Pro.NumInterior,      Pro.NumExterior,    Pro.Colonia,      Mun.Nombre,
          Pro.CP,         Est.Nombre,         Pro.Telefono,
          Pro.NombreCompleto,   Pro.RFC,          Pro.LugardeTrabajo,
          Pro.TelTrabajo,     Pro.ExtTelefonoTrab,    Pro.AntiguedadTra,    Ocu.Descripcion,    CONCAT('RECA: ',Pcr.RegistroRECA),
          Des.Descripcion,    Pro.TipoEmpleado,     Sol.MontoCuota,     Loc.NombreLocalidad,
          Sol.ProspectoID,
          CASE WHEN Sol.DestinoCreID = 20020 THEN 'RD'  -- Refinanciamientode otras deudas
             WHEN Sol.DestinoCreID = 20021 THEN 'VV'  -- Vivienda
             WHEN Sol.DestinoCreID = 20003 THEN 'GP'  -- Gastos Personales
             WHEN Sol.DestinoCreID = 20005 THEN 'GM'  -- Gastos Medicos
             WHEN Sol.DestinoCreID = 20006 THEN 'GE'  -- Gastos Educativos
             WHEN Sol.DestinoCreID = 20011 THEN 'AM'  -- Automovil
             WHEN Sol.DestinoCreID = 20012 THEN 'VC'  -- Vacaciones
             WHEN Sol.DestinoCreID = 20013 THEN 'NP'  -- Negocio Propio
             WHEN Sol.DestinoCreID = 20014 THEN 'PS'  -- Pago de Servicios
             WHEN Sol.DestinoCreID = 20015 THEN 'ME'  -- Muebles y Electrodomesticos
             WHEN Sol.DestinoCreID = 20016 THEN 'IE'  -- Imprevistos/Emergencias
             WHEN Sol.DestinoCreID = 20017 THEN 'GF'  -- Gastos Familiares
             WHEN Sol.DestinoCreID = 20018 THEN 'LQ'  -- Liquidez
             ELSE 'OT'  -- Otros
          END,
          CASE WHEN Pro.EstadoCivil = Est_CasBieSep  THEN 'C' -- C = casado
             WHEN Pro.EstadoCivil = Est_CasBieMan  THEN 'C' -- C = casado
             WHEN Pro.EstadoCivil = Est_CasCapitu  THEN 'C' -- C = casado
             WHEN Pro.EstadoCivil = Est_Soltero    THEN 'S'  -- S = soltero
             WHEN Pro.EstadoCivil = Est_Viudo    THEN 'V'  -- V = viudo
             WHEN Pro.EstadoCivil = Est_UnionLibre THEN 'U'  -- U = union libre
             ELSE 'O' -- O = Otro
          END
        INTO
          Var_ClienteID,      Var_MontoSolici,    Var_Plazo,        Var_Empleado,       Var_EstadoNac,
          Var_NombreCli,      Var_ApePaterno,     Var_ApeMaterno,     Var_CliFechaNac,      Var_InstitNomina,
          Var_CliCalle,     Var_CliNumInt,      Var_CliNumCasa,     Var_CliColoni,        Var_CliMunici,
          Var_CliCP,        Var_CliEstado,      Var_CliTelPart,
          Var_NombreCliente,    Var_CliRFC,       Var_CliLugTra,
          Var_CliTelTra,      Var_ExtTelTra,      Var_CliAntTra,      Var_Ocupacion,        Var_RegRECA,
          Var_DestinoDes,     Var_CliSegmento,    Var_MontoCuota,     Var_CliCiudad,        Var_ProspectoID,
          Var_Destino,
          Var_ClaveEstCiv
        FROM SOLICITUDCREDITO Sol
          INNER JOIN DESTINOSCREDITO Des ON Sol.DestinoCreID = Des.DestinoCreID
          INNER JOIN PROSPECTOS Pro ON Sol.ProspectoID = Pro.ProspectoID
          LEFT OUTER JOIN INSTITNOMINA Nom ON Sol.InstitucionNominaID = Nom.InstitNominaID
          LEFT OUTER JOIN ESTADOSREPUB Est ON Pro.EstadoID = Est.EstadoID -- para el lugar de nacimiento del cliente
          LEFT OUTER JOIN LOCALIDADREPUB Loc ON (Pro.EstadoID = Loc.EstadoID AND Pro.MunicipioID = Loc.MunicipioID AND Pro.LocalidadID = Loc.LocalidadID)
          LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON (Pro.EstadoID = Mun.EstadoID AND Pro.MunicipioID = Mun.MunicipioID)
          LEFT OUTER JOIN OCUPACIONES Ocu ON Pro.OcupacionID = Ocu.OcupacionID
          LEFT OUTER JOIN PRODUCTOSCREDITO Pcr ON Pcr.ProducCreditoID = Sol.ProductoCreditoID
        WHERE SolicitudCreditoID = Par_SoliCredID LIMIT 1;
        SET Var_InstitNomina  := IFNULL(Var_InstitNomina, " ");
        IF(IFNULL(Var_MontoCuota, Cadena_Vacia) = Cadena_Vacia)THEN
          SET Var_MontoCuota  := '0.0';
        END IF;

    END IF; -- Fin de es cliente o prospecto

        # Verifica si el credito es nuevo o una reestructura
        IF EXISTS(SELECT CreditoID FROM CREDITOS WHERE SolicitudCreditoID = Par_SoliCredID AND Relacionado > Entero_Cero) THEN
          SET Var_Restructura   := 'R'; -- R = Reestructura
        ELSE
          SET Var_Restructura   := 'N'; -- N = Nuevo
        END IF;

        # Verifica los datos del aval
        IF EXISTS(SELECT SolicitudCreditoID
              FROM AVALESPORSOLICI
              WHERE SolicitudCreditoID = Par_SoliCredID
                AND ClienteID > Entero_Cero) THEN
            # El aval es un cliente
            SELECT Cli.NombreCompleto,    CONCAT(Dir.Calle, " No. ",Dir.NumeroCasa, CASE WHEN IFNULL(Dir.NumInterior, Cadena_Vacia) != Cadena_Vacia
                                                      THEN CONCAT(', Int. ', Dir.NumInterior)
                                                       ELSE Cadena_Vacia
                                                   END,
                                                   CASE WHEN IFNULL(Dir.Lote, Cadena_Vacia) != Cadena_Vacia
                                                      THEN CONCAT(', Lote ', Dir.Lote)
                                                       ELSE Cadena_Vacia
                                                   END,
                                                   CASE WHEN IFNULL(Dir.Manzana, Cadena_Vacia) != Cadena_Vacia
                                                      THEN CONCAT(', Mz. ', Dir.Manzana)
                                                       ELSE Cadena_Vacia
                                                   END),CONCAT(Col.Asentamiento),
                Mun.Nombre,     Est.Nombre,
                 Dir.CP
            INTO   Var_AvaNombre,     Var_AvaDir,                Var_AvaColonia,      Var_AvaCiudad,    Var_AvaEstado,
                 Var_AvaCP
            FROM AVALESPORSOLICI Ava,
                CLIENTES Cli
              LEFT OUTER JOIN DIRECCLIENTE Dir ON (Dir.ClienteID = Cli.ClienteID AND Dir.Oficial = Dir_Oficial)
              LEFT OUTER JOIN COLONIASREPUB Col ON (Dir.EstadoID = Col.EstadoID AND Dir.MunicipioID = Col.MunicipioID AND Dir.ColoniaID = Col.ColoniaID)
              LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON (Dir.MunicipioID = Mun.MunicipioID AND Dir.EstadoID = Mun.EstadoID )
              LEFT OUTER JOIN ESTADOSREPUB Est ON Dir.EstadoID = Est.EstadoID
            WHERE Ava.ClienteID = Cli.ClienteID
              AND SolicitudCreditoID = Par_SoliCredID
            LIMIT 1;
        ELSE IF EXISTS(SELECT SolicitudCreditoID
              FROM AVALESPORSOLICI
              WHERE SolicitudCreditoID = Par_SoliCredID
                AND ProspectoID > Entero_Cero) THEN
                # El aval es un prospecto
                SELECT Pro.NombreCompleto,    CONCAT(Pro.Calle, " No. ",Pro.NumExterior, CASE WHEN IFNULL(Pro.NumInterior, Cadena_Vacia) != Cadena_Vacia
                                                          THEN CONCAT(', Int. ', Pro.NumInterior)
                                                           ELSE Cadena_Vacia
                                                       END,
                                                       CASE WHEN IFNULL(Pro.Lote, Cadena_Vacia) != Cadena_Vacia
                                                          THEN CONCAT(', Lote ', Pro.Lote)
                                                           ELSE Cadena_Vacia
                                                       END,
                                                       CASE WHEN IFNULL(Pro.Manzana, Cadena_Vacia) != Cadena_Vacia
                                                          THEN CONCAT(', Mz. ', Pro.Manzana)
                                                           ELSE Cadena_Vacia
                                                       END),
                Pro.Colonia,      Mun.Nombre,     Est.Nombre,
                     Pro.CP
                INTO   Var_AvaNombre,       Var_AvaDir,                 Var_AvaColonia,     Var_AvaCiudad,    Var_AvaEstado,
                    Var_AvaCP
                FROM AVALESPORSOLICI Ava,
                   PROSPECTOS Pro
                   LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON (Pro.MunicipioID = Mun.MunicipioID AND Pro.EstadoID = Mun.EstadoID )
                   LEFT OUTER JOIN ESTADOSREPUB Est ON Pro.EstadoID = Est.EstadoID
                WHERE Ava.ProspectoID = Pro.ProspectoID
                  AND SolicitudCreditoID = Par_SoliCredID
                LIMIT 1;
          ELSE
              # El aval es una persona x
              SELECT Ava.NombreCompleto,    CONCAT(Ava.Calle, " No. ",Ava.NumExterior, CASE WHEN IFNULL(Ava.NumInterior, Cadena_Vacia) != Cadena_Vacia
                                                          THEN CONCAT(', Int. ', Ava.NumInterior)
                                                           ELSE Cadena_Vacia
                                                       END,
                                                       CASE WHEN IFNULL(Ava.Lote, Cadena_Vacia) != Cadena_Vacia
                                                          THEN CONCAT(', Lote ', Ava.Lote)
                                                           ELSE Cadena_Vacia
                                                       END,
                                                       CASE WHEN IFNULL(Ava.Manzana, Cadena_Vacia) != Cadena_Vacia
                                                          THEN CONCAT(', Mz. ', Ava.Manzana)
                                                           ELSE Cadena_Vacia
                                                       END),
                  Ava.Colonia,        Mun.Nombre,     Est.Nombre,
                   Ava.CP
              INTO   Var_AvaNombre,     Var_AvaDir,                  Var_AvaColonia,      Var_AvaCiudad,    Var_AvaEstado,
                   Var_AvaCP
              FROM AVALESPORSOLICI Sol,
                 AVALES Ava
                 LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON (Ava.MunicipioID = Mun.MunicipioID AND Ava.EstadoID = Mun.EstadoID )
                 LEFT OUTER JOIN ESTADOSREPUB Est ON Ava.EstadoID = Est.EstadoID
              WHERE Ava.AvalID = Sol.AvalID
                AND Sol.SolicitudCreditoID = Par_SoliCredID
              LIMIT 1;
          END IF;
        END IF;



    # ================== OBTENEMOS LOS DATOS PARA IMPRIMIR EN EL REPORTE ====================
    SELECT  Var_ClienteID,    Var_MontoSolici,    Var_Plazo,      Var_Empleado,     Var_EstadoNac,
        Var_NombreCli,    Var_ApePaterno,     Var_ApeMaterno,   Var_CliFechaNac,    Var_InstitNomina,
        Var_CliCalle,   Var_CliNumInt,      Var_CliNumCasa,   Var_CliColoni,      Var_CliMunici,
        Var_CliCP,      Var_CliEstado,      Var_TipoVivienda, Var_MontoRenta,     Var_DescVivienda,
        VarTiempoHabi,    Var_CliTelPart,     Var_CliTelCel,    Var_CliCorreo,      Var_ClaveEstCiv,
        Var_NumDepend,    Var_NombreCliente,    Var_NombrePromotor, Var_CliCURP,      Var_CliRFC,
        Var_CliLugTra,    Var_CliTelTra,      Var_ExtTelTra,    Var_CliAntTra,      Var_Ocupacion,
        Var_NombreRef,    Var_NombreRef2,     Var_DomicilioRef, Var_DomicilioRef2,    Var_TelefonoRef,
          Var_TelefonoRef2, Var_Relacion,     Var_Relacion2,    Var_DirTrabajo,     Var_ColTra,
        Var_CiudadTra,    Var_EstadoTra,      Var_CPTra,      Var_AvaNombre,      Var_AvaColonia,
        Var_AvaEstado,    Var_AvaCP,        Var_AvaDir,     Var_AvaCiudad,      Var_CliCiudad,
        Var_CliNacion,    Var_Restructura,    CAST(Var_MontoCuota AS DECIMAL(14,4)) AS Var_MontoCuota,    Var_Destino,      Var_DestinoDes,
        Var_RegRECA,    Var_CliPuesto,      Var_CliSegmento;
  END IF; -- fin de reporte personalizado para Tlr

  -- REPORTE PERSONALIZADO PARA SANA TUS FINANZAS (1ERA HOJA)
    IF (Par_TipoReporte = TipoSolCredSTF) THEN

        -- ID's
        SELECT  Sol.SolicitudCreditoID, Sol.ClienteID,        Sol.SucursalID,   Pro.NombrePromotor, Sol.CreditoID,
        Sol.MontoAutorizado,  (Sol.TasaFija/Meses_Anio),  Sol.FrecuenciaCap
        INTO  Var_SolCreditoID,   Var_ClienteID,        Var_SucursalID,   Var_NombrePromotor, Var_CreditoID,
        Var_MontoSolici,    Var_Tasa,         Var_Frecuencia
      FROM  SOLICITUDCREDITO  Sol,
          PROMOTORES Pro
        WHERE Sol.SolicitudCreditoID  = Par_SoliCredID
          AND   Sol.PromotorID = Pro.PromotorID;

        -- datos sucursal
        SELECT  Suc.NombreSucurs,   EstSuc.Nombre
        INTO  Var_NombreSucurs, Var_EstadoSuc
      FROM  SUCURSALES Suc,
          ESTADOSREPUB EstSuc
        WHERE Suc.SucursalID = Var_SucursalID
          AND Suc.EstadoID = EstSuc.EstadoID;

        -- SI HAY UN CREDITO, OBTENER EL MONTO TOTAL DEL CREDITO
    IF(IFNULL(Var_CreditoID,Entero_Cero)>Entero_Cero)THEN
      SELECT  SUM(Amcr.Capital+ Amcr.Interes + Amcr.IVAInteres),  Cre.NumAmortizacion
      INTO  Var_MonUltCred,                   Var_NumAmortiza
        FROM  SOLICITUDCREDITO  Soli,
            AMORTICREDITO     Amcr,
            CREDITOSPLAZOS    Crp,
            CREDITOS      Cre
          WHERE Soli.SolicitudCreditoID = Par_SoliCredID
            AND   Amcr.CreditoID = Soli.CreditoID
            AND   Soli.PlazoID = Crp.PlazoID
            AND   Cre.CreditoID = Soli.CreditoID;

        ELSE -- SINO HAY CREDITO, OBTENER EL MONTO TOTAL DE LA SOLICITUD
      CALL TOTALSOLCREDPRO(
        Var_SolCreditoID, Var_MonUltCred,  Var_NumAmortiza, Par_EmpresaID,  Aud_Usuario,
                Aud_FechaActual,  Aud_DireccionIP, Aud_ProgramaID,  Aud_Sucursal,   Aud_NumTransaccion);

        END IF;

    SET Var_MontoCuota := ROUND(Var_MonUltCred/Var_NumAmortiza,2);

        -- Datos del cliente
        SELECT  Cli.RFC,      Cli.ApellidoPaterno,  Cli.ApellidoMaterno,  Cli.PrimerNombre ,    Cli.SegundoNombre,
        Cli.TercerNombre, Cli.EstadoCivil,    Cli.Sexo,       Cli.FechaNacimiento,  Est.Nombre,
                Ocu.Descripcion,  Cli.CURP,
                CASE WHEN PaisNac.PaisID = NoPaisMexi THEN CAST(NomMexico  AS CHAR CHARACTER SET UTF8)
          ELSE PaisNac.Nombre
        END,
                CASE WHEN Cli.Nacion = Nac_Mexicano THEN Des_Mexicano
          ELSE Des_Extranjero
        END,
                CASE WHEN PaRe.PaisID = NoPaisMexi THEN CAST(NomMexico  AS CHAR CHARACTER SET UTF8)
          ELSE PaRe.Nombre
        END,
                Cli.Correo,     Cli.Telefono,     Cli.TelefonoCelular,  ConCli.BancoRef,    ConCli.NoCuentaRef

        INTO  Var_CliRFC,     Var_ApePaterno,     Var_ApeMaterno,     Var_ConyPriNom,     Var_ConySegNom,
        Var_ConyTerNom,   Var_ClaveEstCiv,    Var_CliSexo,      Var_FecNacCli ,     Var_EstadoNac,
                Var_Ocupacion,    Var_CliCURP,      Var_PaisNac,      Var_CliNacion,      Var_PaiResi,
                Var_CliCorreo ,   Var_CliTelPart,     Var_CliTelCel,      Var_BanRef,       Var_NoCuenRef

      FROM  CLIENTES Cli,
          ESTADOSREPUB  Est,
          OCUPACIONES Ocu,
          PAISES PaisNac,
          PAISES  PaRe,
          CONOCIMIENTOCTE ConCli
        WHERE Cli.ClienteID = Var_ClienteID
          AND Est.EstadoID  = Cli.EstadoID
          AND Cli.OcupacionID = Ocu.OcupacionID
          AND Cli.LugarNacimiento = PaisNac.PaisID
          AND PaRe.PaisID = Cli.PaisResidencia
          AND ConCli.ClienteID = Var_ClienteID;

            -- direccion cliente
            SELECT  Dir.Calle,        Dir.NumInterior,    Dir.Piso,     Dir.Lote,         Dir.Manzana,
          CONCAT(Col.TipoAsenta," ", Col.Asentamiento)Asentamiento,     Dir.NumeroCasa,     Mun.Nombre,
                    Dir.CP,         Dir.PrimeraEntreCalle,  Dir.SegundaEntreCalle,
                    CASE WHEN SoVi.TiempoHabitarDom > Entero_Cero THEN
              SoVi.TiempoHabitarDom / Meses_Anio
            ELSE Entero_Cero
          END,
                    Est.Nombre,       Dir.DireccionCompleta,  SoVi.TipoViviendaID,  Loc.NombreLocalidad

      INTO  Var_CliCalle,       Var_CliNumInt,      Var_CliPiso,  Var_CliLote,      Var_CliManzana,
          Var_CliColoni,      Var_CliNumCasa,     Var_CliMunici,  Var_CliCP,        Var_1aEntreCalle,
                    Var_2aEntreCalle,   VarTiempoHabi,      Var_CliCiudad,  Var_DireClien,      Var_TipoViviendaID,
                    Var_NombreLoc
        FROM DIRECCLIENTE Dir,
           COLONIASREPUB Col,
           MUNICIPIOSREPUB Mun,
           SOCIODEMOVIVIEN SoVi,
           ESTADOSREPUB Est,
                     LOCALIDADREPUB Loc
          WHERE Dir.ClienteID = Var_ClienteID
            AND Dir.EstadoID = Col.EstadoID
            AND Dir.MunicipioID = Col.MunicipioID
            AND Dir.ColoniaID = Col.ColoniaID
            AND Mun.EstadoID  = Col.EstadoID
            AND Mun.MunicipioID = Col.MunicipioID
            AND SoVi.ClienteID = Var_ClienteID
            AND Dir.EstadoID = Est.EstadoID
                      AND Mun.EstadoID  = Loc.EstadoID
            AND Mun.MunicipioID = Loc.MunicipioID
            AND Dir.LocalidadID = Loc.LocalidadID
            AND IFNULL(Dir.Oficial, Var_NO)  = Dir_Oficial;

    -- informacion laboral
    SELECT  Sol.SolicitudCreditoID, Sol.ClienteID,  Cli.TelTrabajo
        INTO  Var_SolCreditoID,   Var_ClienteID,  Var_CliTelTra
      FROM SOLICITUDCREDITO Sol,  CLIENTES Cli
        WHERE Sol.SolicitudCreditoID = Par_SoliCredID
          AND Cli.ClienteID = Sol.ClienteID;

        SELECT  CP,     EdoRe.Nombre,     MunRep.Nombre,      Dir.Colonia,    CONCAT(Dir.Calle,' ',Dir.NumeroCasa,' ',Dir.Colonia)
    INTO  Var_CPTra,  Var_EstadoTra,      Var_MuniTra,      Var_ColTra,     Var_DirTrabajo
      FROM DIRECCLIENTE Dir, ESTADOSREPUB EdoRe, MUNICIPIOSREPUB MunRep
        WHERE Dir.ClienteID = Var_ClienteID
          AND Dir.TipoDireccionID = TipoDirTrab
          AND Dir.EstadoID = EdoRe.EstadoID
          AND Dir.MunicipioID = MunRep.MunicipioID
          AND MunRep.EstadoID = Dir.EstadoID
                    LIMIT 1;

        SET Var_SolCreditoID:=IFNULL(Var_SolCreditoID,Cadena_Vacia);
        SET Var_ClienteID:=IFNULL(Var_ClienteID,Cadena_Vacia);
        SET Var_SucursalID:=IFNULL(Var_SucursalID,Cadena_Vacia);
        SET Var_NombreSucurs:=IFNULL(Var_NombreSucurs,Cadena_Vacia);
    SET Var_NombrePromotor:=IFNULL(Var_NombrePromotor,Cadena_Vacia);
    SET Var_EstadoSuc :=IFNULL(Var_EstadoSuc,Cadena_Vacia);
    SET Var_MonUltCred :=IFNULL(Var_MonUltCred,Decimal_Cero);
    SET Var_MontoCuota :=IFNULL(Var_MontoCuota,Decimal_Cero);
    SET Var_MontoSolici :=IFNULL(Var_MontoSolici,Decimal_Cero);
    SET Var_Tasa :=IFNULL(Var_Tasa,Decimal_Cero);
    SET Var_Frecuencia :=IFNULL(Var_Frecuencia,Cadena_Vacia);
    SET Var_CliRFC :=IFNULL(Var_CliRFC,Cadena_Vacia);
    SET Var_ApePaterno :=IFNULL(Var_ApePaterno,Cadena_Vacia);
    SET Var_ApeMaterno :=IFNULL(Var_ApeMaterno,Cadena_Vacia);
    SET Var_ConyPriNom :=IFNULL(Var_ConyPriNom ,Cadena_Vacia);
    SET Var_ConySegNom :=IFNULL(Var_ConySegNom,Cadena_Vacia);
    SET Var_ConyTerNom :=IFNULL(Var_ConyTerNom,Cadena_Vacia);
    SET Var_ClaveEstCiv :=IFNULL(Var_ClaveEstCiv,Cadena_Vacia);
    SET Var_CliSexo :=IFNULL(Var_CliSexo,Cadena_Vacia);
    SET Var_FecNacCli :=IFNULL(Var_FecNacCli ,Fecha_Vacia);
    SET Var_EstadoNac :=IFNULL(Var_EstadoNac,Cadena_Vacia);
    SET Var_Ocupacion :=IFNULL(Var_Ocupacion,Cadena_Vacia);
    SET Var_CliCURP :=IFNULL(Var_CliCURP,Cadena_Vacia);
    SET Var_PaisNac :=IFNULL(Var_PaisNac,Cadena_Vacia);
    SET Var_CliNacion :=IFNULL(Var_CliNacion,Cadena_Vacia);
    SET Var_CliCalle :=IFNULL(Var_CliCalle,Cadena_Vacia);
    SET Var_CliNumCasa :=IFNULL(Var_CliNumCasa,Cadena_Vacia);
    SET Var_CliNumInt :=IFNULL(Var_CliNumInt,Cadena_Vacia);
    SET Var_CliPiso :=IFNULL(Var_CliPiso,Cadena_Vacia);
    SET Var_CliLote :=IFNULL(Var_CliLote,Cadena_Vacia);
    SET Var_CliManzana :=IFNULL(Var_CliManzana,Cadena_Vacia);
    SET Var_CliColoni :=IFNULL(Var_CliColoni,Cadena_Vacia);
    SET Var_CliMunici :=IFNULL(Var_CliMunici,Cadena_Vacia);
    SET Var_CliCiudad :=IFNULL(Var_CliCiudad,Cadena_Vacia);
    SET Var_CliCP :=IFNULL(Var_CliCP,Cadena_Vacia);
    SET Var_PaiResi :=IFNULL(Var_PaiResi,Cadena_Vacia);
    SET Var_1aEntreCalle :=IFNULL(Var_1aEntreCalle,Cadena_Vacia);
    SET Var_2aEntreCalle :=IFNULL(Var_2aEntreCalle,Cadena_Vacia);
    SET Var_CliCorreo :=IFNULL(Var_CliCorreo,Cadena_Vacia);
    SET Var_CliTelPart :=IFNULL(Var_CliTelPart,Cadena_Vacia);
    SET Var_CliTelCel :=IFNULL(Var_CliTelCel,Cadena_Vacia);
    SET Var_CliTelPart :=IFNULL(Var_CliTelPart,Cadena_Vacia);
    SET Var_CliTelTra :=IFNULL(Var_CliTelTra,Cadena_Vacia);
    SET Var_CPTra :=IFNULL(Var_CPTra,Cadena_Vacia);
    SET Var_EstadoTra :=IFNULL(Var_EstadoTra,Cadena_Vacia);
    SET Var_MuniTra :=IFNULL(Var_MuniTra,Cadena_Vacia);
    SET Var_ColTra :=IFNULL(Var_ColTra,Cadena_Vacia);
    SET Var_DirTrabajo :=IFNULL(Var_DirTrabajo,Cadena_Vacia);
    SET Var_BanRef :=IFNULL(Var_BanRef,Cadena_Vacia);
    SET Var_NoCuenRef :=IFNULL(Var_NoCuenRef,Cadena_Vacia);
    SET Var_DireClien :=IFNULL(Var_DireClien,Cadena_Vacia);
        SET Var_TipoViviendaID := IFNULL(Var_TipoViviendaID,Entero_Cero);
    SET Var_NombreLoc :=IFNULL(Var_NombreLoc,Cadena_Vacia);

    # ================== OBTENEMOS LOS DATOS PARA IMPRIMIR EN EL REPORTE ====================
    SELECT  Var_SolCreditoID, Var_ClienteID,          Var_SucursalID,         Var_NombreSucurs,       Var_NombrePromotor,
        Var_EstadoSuc,    Var_MonUltCred,         Var_MontoCuota,         Var_MontoSolici,        Var_Tasa,
                Var_Frecuencia,   Var_CliRFC,           Var_ApePaterno,         Var_ApeMaterno,         Var_ConyPriNom ,
                Var_ConySegNom,   Var_ConyTerNom,         Var_ClaveEstCiv,        Var_CliSexo,          Var_FecNacCli ,
                Var_EstadoNac,    Var_Ocupacion,          Var_CliCURP,          Var_PaisNac,          Var_CliNacion,
                Var_CliCalle,   Var_CliNumCasa,         Var_CliNumInt,          Var_CliPiso,          Var_CliLote,
                Var_CliManzana,   Var_CliColoni,          Var_CliMunici,          Var_CliCiudad,          Var_CliCP,
                Var_PaiResi,      Var_1aEntreCalle,       Var_2aEntreCalle,       Var_CliCorreo,          Var_CliTelPart AS TelCasa,
                VarTiempoHabi,      Var_CliTelCel,          Var_CliTelPart AS TelParticular,Var_CliTelTra,          Var_CPTra,
                Var_EstadoTra,      Var_MuniTra,          Var_ColTra,           Var_DirTrabajo,         Var_BanRef,
                Var_NoCuenRef,    Var_DireClien,          Var_TipoViviendaID,       Var_NombreLoc;

    END IF;

  -- REPORTE PERSONALIZADO PARA SANA TUS FINANZAS (2DA HOJA)
  IF  (Par_TipoReporte = TipoSolCredSTF2) THEN

    SELECT SUM(CliDatSoE.Monto)
    INTO  Var_IngMens
      FROM SOLICITUDCREDITO SolCre, CLIDATSOCIOE  CliDatSoE,  CATDATSOCIOE  CatDatSocE
        WHERE SolCre.SolicitudCreditoID = Par_SoliCredID
          AND SolCre.ClienteID = CliDatSoE.ClienteID
          AND CliDatSoE.CatSocioEID = CatDatSocE.CatSocioEID
          AND CatDatSocE.Tipo = 'I';

    SELECT CtoCta.ProcRecursos
    INTO  Var_ProcRecurso
      FROM CONOCIMIENTOCTA  CtoCta, SOLICITUDCREDITO  SolCre, CUENTASAHO  CtaAho
        WHERE SolCre.SolicitudCreditoID = Par_SoliCredID
          AND SolCre.ClienteID = CtaAho.ClienteID
          AND CtoCta.CuentaAhoID = CtaAho.CuentaAhoID
            LIMIT 1;

    SELECT DesCre.Descripcion
    INTO  Var_DestRec
      FROM  SOLICITUDCREDITO  SolCre, DESTINOSCREDITO DesCre
        WHERE SolCre.SolicitudCreditoID = Par_SoliCredID
          AND   SolCre.DestinoCreID = DesCre.DestinoCreID;

    SELECT Cli.NombreCompleto
    INTO  Var_NombreCliente
      FROM SOLICITUDCREDITO SolCre, CLIENTES  Cli
        WHERE SolicitudCreditoID = Par_SoliCredID
          AND SolCre.ClienteID = Cli.ClienteID;

    # ================== OBTENEMOS LOS DATOS PARA IMPRIMIR EN EL REPORTE ====================
    SELECT Var_IngMens,   Var_ProcRecurso,    Var_DestRec,    Var_NombreCliente;

    END IF;

IF(Par_TipoReporte = TipoRep_SofiExp)THEN

  SELECT  pr.NombrePromotor,  pc.Descripcion,   IF(so.FechaAutoriza = '1900-01-01', '',  DATE_FORMAT(so.FechaAutoriza, '%d/%m/%Y')),
                                  IF(so.Estatus IN ('A','L','D'), 'Simple', ''),
                                          so.TasaFija,
      IF(TipCobComMorato = 'N', ROUND(so.TasaFija*so.FactorMora,4), so.FactorMora),
                so.NumAmortizacion, CASE
                            WHEN so.frecuenciaInt = FrecSemanal   THEN TxtSemanal
                            WHEN so.frecuenciaInt =FrecCatorcenal   THEN TxtCatorcenal
                            WHEN so.frecuenciaInt =FrecQuincenal  THEN TxtQuincenal
                            WHEN so.frecuenciaInt =FrecMensual    THEN TxtMensual
                            WHEN so.frecuenciaInt =FrecPeriodica  THEN TxtPeriodica
                            WHEN so.frecuenciaInt =FrecBimestral  THEN TxtBimestral
                            WHEN so.frecuenciaInt =FrecTrimestral   THEN TxtTrimestral
                            WHEN so.frecuenciaInt =FrecTetramestral THEN TxtTetramestral
                            WHEN so.frecuenciaInt =FrecSemestral  THEN TxtSemestral
                            WHEN so.frecuenciaInt =FrecAnual    THEN TxtAnual
                            WHEN so.frecuenciaInt =FrecLibre    THEN TxtLibres
                            ELSE ''
                          END,        so.PorcGarLiq,  so.Proyecto,
      so.MontoAutorizado, so.ClienteID,   IF(so.ClienteID > Entero_Cero,cl.NombreCompleto,ps.NombreCompleto),
                                    IF(so.ClienteID > 0,IF(DATE_ADD(cl.FechaAlta, INTERVAL 1 YEAR) > Fecha_Sis ,CALCDIFFDATE(cl.FechaAlta, Fecha_Sis,2),CALCDIFFDATE(cl.FechaAlta, Fecha_Sis,4)),'1900-01-01'),
                                            cl.FechaNacimiento,
      CALCDIFFDATE(IF(so.ClienteID > Entero_Cero, cl.FechaNacimiento, ps.FechaNacimiento),Fecha_Sis,3),
                IF(so.ClienteID > Entero_Cero,cl.EstadoCivil,ps.EstadoCivil),
                          cl.Nacion,      IF(so.ClienteID > Entero_Cero,cl.Sexo,ps.Sexo),
                                            IF(so.ClienteID > Entero_Cero,cl.Telefono,ps.Telefono),
      IF(so.ClienteID > Entero_Cero,IF(cl.TipoPersona = 'M', cl.RFCpm,cl.RFC ),IF(cl.TipoPersona = 'M', ps.RFCpm,ps.RFC )),
                cl.CURP,      cl.TelefonoCelular, IF(so.ClienteID > Entero_Cero,
                                     IF(cl.TipoPersona = 'M', 'N', IF(cl.OcupacionID = Entero_Cero, 'N', 'S')),
                                     IF(ps.TipoPersona = 'M', 'N', IF(ps.OcupacionID = Entero_Cero, 'N', 'S'))
                                    ),
                                            so.SucursalID,
      oc.Descripcion,   ab.Descripcion,   cl.ActividadINEGI,  IF(so.ClienteID > Entero_Cero,
                                    IF(cl.TipoPersona = 'M', cl.RazonSocial, cl.LugardeTrabajo),
                                    IF(ps.TipoPersona = 'M', ps.RazonSocial, ps.LugardeTrabajo)
                                    ),        IF(so.ClienteID > Entero_Cero,
                                            IF( cl.TipoPersona != 'M',
                                              CALCDIFFDATE(
                                                DATE_SUB(Fecha_Sis, INTERVAL FLOOR(cl.AntiguedadTra * 12) MONTH), Fecha_Sis,
                                                4),
                                              CALCDIFFDATE(
                                                CONCAT(IF(DATE_FORMAT(Fecha_Sis,'%yy')>SUBSTRING(cl.RFCpm,4,2), '20', '19' ),
                                                  SUBSTRING(cl.RFCpm,4,2),
                                                  '-',
                                                  SUBSTRING(cl.RFCpm,6,2),
                                                  '-',
                                                  SUBSTRING(cl.RFCpm,8,2)
                                                ),
                                                Fecha_Sis,
                                                4)
                                            ),
                                            IF( ps.TipoPersona != 'M',
                                              CALCDIFFDATE(
                                                DATE_SUB(Fecha_Sis, INTERVAL FLOOR(ps.AntiguedadTra * 12) MONTH), Fecha_Sis,
                                                4),
                                              CALCDIFFDATE(
                                                CONCAT(IF(DATE_FORMAT(Fecha_Sis,'%yy')>SUBSTRING(ps.RFCpm,4,2), '20', '19' ),
                                                  SUBSTRING(ps.RFCpm,4,2),
                                                  '-',
                                                  SUBSTRING(ps.RFCpm,6,2),
                                                  '-',
                                                  SUBSTRING(ps.RFCpm,8,2)
                                                ),
                                                Fecha_Sis,
                                                4)
                                            )
                                            ),
      IF(so.ClienteID > Entero_Cero,
      IF(cl.TipoPersona = 'M',Cadena_Vacia, cl.Puesto),
      IF(ps.TipoPersona = 'M',Cadena_Vacia, ps.Puesto)),
                IF(so.ClienteID > Entero_Cero,
                IF( cl.TipoPersona = 'M',
                  CONCAT(IFNULL(cl.Telefono, Cadena_Vacia), ' Ext # ', IFNULL(cl.ExtTelefonoPart, Cadena_Vacia)),
                  CONCAT(IFNULL(cl.TelTrabajo, Cadena_Vacia), ' Ext # ',IFNULL(cl.ExtTelefonoTrab, Cadena_Vacia))),
                IF( ps.TipoPersona = 'M',
                  CONCAT(IFNULL(ps.Telefono, Cadena_Vacia), ' Ext # ', IFNULL(ps.ExtTelefonoPart, Cadena_Vacia)),
                  CONCAT(IFNULL(ps.TelTrabajo, Cadena_Vacia), ' Ext # ',IFNULL(ps.ExtTelefonoTrab, Cadena_Vacia)))
                ),
                          IF(so.ClienteID > Entero_Cero,cl.TipoPersona,ps.TipoPersona),
                                    IF(so.ClienteID > Entero_Cero,
                                    CONCAT(IFNULL(cl.PrimerNombre,Cadena_Vacia),' ',IFNULL(cl.SegundoNombre,Cadena_Vacia), ' ',IFNULL(cl.TercerNombre,Cadena_Vacia)),
                                    CONCAT(IFNULL(ps.PrimerNombre,Cadena_Vacia),' ',IFNULL(ps.SegundoNombre,Cadena_Vacia), ' ',IFNULL(ps.TercerNombre,Cadena_Vacia))),
                                            IF(so.ClienteID > Entero_Cero,cl.ApellidoPaterno,ps.ApellidoPaterno),
      IF(so.ClienteID > Entero_Cero,cl.ApellidoMaterno,ps.ApellidoMaterno),
                LPAD(DAY(IF(so.ClienteID > Entero_Cero,cl.FechaNacimiento,ps.FechaNacimiento)),2,'0'),
                          LPAD(MONTH(IF(so.ClienteID > Entero_Cero,cl.FechaNacimiento,ps.FechaNacimiento)),2,'0'),
                                    LPAD(YEAR(IF(so.ClienteID > Entero_Cero,cl.FechaNacimiento,ps.FechaNacimiento)),4,'19'),
                                            so.MontoSolici,
      IF(so.FechaRegistro = '1900-01-01', '',  DATE_FORMAT(so.FechaRegistro, '%d/%m/%Y')),
                ps.ProspectoID
  INTO  Prom_Nombre,    Var_DesProducto,  Sol_FechaAut,   Sol_Disposi,  Var_Tasa,
      Var_FactorMora,   Var_NumAmortiza,  Var_Frecuencia,   Var_GarantiaLiq,Sol_Proyecto,
      Sol_MontoAut,   Var_ClienteID,    Var_NombreCliente,  Cli_AntigClie,  Var_CliFechaNac,
      Cli_Edad,     Var_ClaveEstCiv,  Var_ClaveNacion,  Var_CliSexo,  Var_TelefonoRef,
      Var_CliRFC,     Var_CliCURP,    Var_CliTelCel,    Cli_EsDepend, Var_SucursalID,
      Var_Ocupacion,    Cli_ActBMX,     Cli_SectorGral,   Var_CliLugTra,  Cli_AntigTra,
      Var_CliPuesto,    Var_CliTelTra,    Cli_TipoPers,   Var_NombreCli,  Var_ApePaterno,
      Var_ApeMaterno,   Cli_FechNacD,   Cli_FechNacM,   Cli_FechNacA, Sol_MontoSol,
      Sol_FechaResult,  Var_ProspectoID

  FROM
    SOLICITUDCREDITO so
    LEFT OUTER JOIN PROMOTORES pr       ON so.PromotorID = pr.PromotorID
    LEFT OUTER JOIN PRODUCTOSCREDITO pc   ON so.ProductoCreditoID = pc.ProducCreditoID
    LEFT OUTER JOIN PROSPECTOS ps     ON so.ProspectoID = ps.ProspectoID
    LEFT OUTER JOIN CLIENTES cl       ON so.ClienteID = cl.ClienteID
    LEFT OUTER JOIN OCUPACIONES oc      ON oc.OcupacionID = cl.OcupacionID
    LEFT OUTER JOIN ACTIVIDADESBMX ab   ON ab.ActividadBMXID = cl.ActividadBancoMX
  WHERE so.SolicitudCreditoID = Par_SoliCredID
  LIMIT 1;

  SET Var_DescriEstCiv
    := (
    SELECT
      CASE Var_ClaveEstCiv
        WHEN Est_Soltero  THEN Des_Soltero
        WHEN Est_CasBieSep  THEN Des_CasBieSep
        WHEN Est_CasBieMan  THEN Des_CasBieMan
        WHEN Est_CasCapitu  THEN Des_CasCapitu
        WHEN Est_Viudo  THEN Des_Viudo
        WHEN Est_Divorciad  THEN Des_Divorciad
        WHEN Est_Seperados  THEN Des_Seperados
        WHEN Est_UnionLibre  THEN Des_UnionLibre
        ELSE Cadena_Vacia
      END );

  IF (Var_ClaveNacion = Nac_Mexicano) THEN
        SET Var_CliNacion   := Des_Mexicano;

    END IF;
  IF (Var_ClaveNacion = Nac_Extranjero) THEN
        SET Var_CliNacion   := Des_Extranjero;
    END IF;
  SET Var_CliNacion   := IFNULL(Var_CliNacion,Cadena_Vacia);

  IF(Var_CliSexo = Gen_Masculino) THEN
        SET Var_CliGenero   := Des_Masculino;
    ELSE
        SET Var_CliGenero   := Des_Femenino;
    END IF;

  SELECT
      sd.TipoViviendaID, sd.TiempoHabitarDom
    INTO
      Var_CliTipViv,  VarTiempoHabi
    FROM
      SOCIODEMOVIVIEN sd
      WHERE
        ClienteID = Var_ClienteID AND ProspectoID = Entero_Cero
      OR
        ClienteID = Entero_Cero AND ProspectoID = Var_ProspectoID
  LIMIT 1;

  SET Var_CliTipViv   := IFNULL(Var_CliTipViv,Cadena_Vacia);
  SET VarTiempoHabi   := IFNULL(VarTiempoHabi,Entero_Cero);

  SELECT
    dc.Calle,   dc.NumeroCasa,  dc.Colonia,   mr.Nombre,    er.Nombre,
    dc.CP
  INTO
    Var_CliCalle, Var_CliNumCasa, Var_CliColoni,  Var_CliColMun,  Var_CliEstado,
    Var_CliCP
  FROM
    DIRECCLIENTE dc
    LEFT OUTER JOIN ESTADOSREPUB er   ON  er.EstadoID = dc.EstadoID
    LEFT OUTER JOIN MUNICIPIOSREPUB mr  ON  mr.MunicipioID  = dc.MunicipioID
                      AND mr.EstadoID = dc.EstadoID
  WHERE
    ClienteID = Var_ClienteID
  AND TipoDireccionID = 1
  AND Oficial = 'S' LIMIT 1;

  IF(Var_ClienteID = 0 AND Var_ProspectoID != 0)THEN
    SELECT
      ps.Calle,   ps.NumExterior,   ps.Colonia,   mr.Nombre,    er.Nombre,
      ps.CP
    INTO
      Var_CliCalle, Var_CliNumCasa, Var_CliColoni,  Var_CliColMun,  Var_CliEstado,
      Var_CliCP
    FROM
      PROSPECTOS ps
      LEFT OUTER JOIN ESTADOSREPUB er   ON  er.EstadoID = ps.EstadoID
      LEFT OUTER JOIN MUNICIPIOSREPUB mr  ON  mr.MunicipioID  = ps.MunicipioID
                        AND mr.EstadoID = ps.EstadoID
    WHERE
      ps.ProspectoID = Var_ProspectoID
    LIMIT 1;
  END IF;

  SET Var_CliNumCasa   := IFNULL(Var_CliNumCasa,Cadena_Vacia);
  SET Var_CliColoni   := IFNULL(Var_CliColoni,Cadena_Vacia);
  SET Var_CliColMun   := IFNULL(Var_CliColMun,Cadena_Vacia);
  SET Var_CliEstado   := IFNULL(Var_CliEstado,Cadena_Vacia);
  SET Var_CliCalle   := IFNULL(Var_CliCalle,Cadena_Vacia);
  SET Var_CliCP   := IFNULL(Var_CliCP,Cadena_Vacia);

  SET Var_CliCalle2 := Cadena_Vacia;
  SET Var_CliNumCasa2 := Cadena_Vacia;
  SET Var_CliColoni2  := Cadena_Vacia;
  SET Var_CliColMun2  := Cadena_Vacia;
  SET Var_CliEstado2  := Cadena_Vacia;
  SET Var_CliCP2    := Cadena_Vacia;
  SET VarTiempoHabi   := IFNULL(VarTiempoHabi,Entero_Cero);

  IF( VarTiempoHabi < 24)THEN
    SELECT
      dc.Calle,     dc.NumeroCasa,  dc.Colonia,   mr.Nombre,    er.Nombre,
      CP
    INTO
      Var_CliCalle2,  Var_CliNumCasa2,Var_CliColoni2, Var_CliColMun2, Var_CliEstado2,
      Var_CliCP2
    FROM
      DIRECCLIENTE dc
      LEFT OUTER JOIN ESTADOSREPUB er ON er.EstadoID = dc.EstadoID
      LEFT OUTER JOIN MUNICIPIOSREPUB mr  ON  mr.MunicipioID  = dc.MunicipioID
                        AND mr.EstadoID = dc.EstadoID
    WHERE
      ClienteID = Var_ClienteID
    AND TipoDireccionID = 1
    AND IFNULL(Oficial,'') != 'S' LIMIT 1;
   END IF;

  SET Var_TmpHabiDes := CONCAT(FLOOR(VarTiempoHabi/12) ,'.', MOD(VarTiempoHabi,12) );

  SET Var_CliCalle2 := IFNULL(Var_CliCalle2,Cadena_Vacia);
  SET Var_CliNumCasa2 := IFNULL(Var_CliNumCasa2,Cadena_Vacia);
  SET Var_CliColoni2 := IFNULL(Var_CliColoni2,Cadena_Vacia);
  SET Var_CliColMun2 := IFNULL(Var_CliColMun2,Cadena_Vacia);
  SET Var_CliEstado2 := IFNULL(Var_CliEstado2,Cadena_Vacia);
  SET Var_CliCP2 := IFNULL(Var_CliCP2,Cadena_Vacia);



  IF(Var_ClaveEstCiv = Est_CasBieSep OR Var_ClaveEstCiv = Est_CasBieMan OR Var_ClaveEstCiv = Est_CasCapitu OR Var_ClaveEstCiv = Est_UnionLibre )THEN
    SELECT
      Coy.PrimerNombre,       Coy.SegundoNombre,      Coy.TercerNombre,       Coy.ApellidoPaterno,
      Coy.ApellidoMaterno,    Coy.FechaNacimiento,    Pan.Nombre,             Esr.Nombre,
      Coy.EmpresaLabora,      Est.Nombre,             Mun.Nombre,             col.Asentamiento,
      Coy.Calle,              Coy.NumeroExterior,     Coy.NumeroInterior,     Coy.NumeroPiso,
      Coy.CodigoPostal,       CASE  WHEN Var_CalcAntiguedad = Var_SI THEN
                        CASE WHEN IFNULL(Coy.FechaIniTrabajo,Fecha_Vacia) = Fecha_Vacia THEN
                          Entero_Cero
                        ELSE
                          ROUND(DATEDIFF(Fecha_Sis,Coy.FechaIniTrabajo) / 365)
                        END
                      ELSE
                        Coy.AntiguedadAnios
                  END,          CASE WHEN Var_CalcAntiguedad = Var_SI THEN
                                    Entero_Cero
                                 ELSE   Coy.AntiguedadMeses
                              END,          TelefonoTrabajo,
      TelCelular,             Ocu.Descripcion,    CASE  WHEN  Coy.Nacionalidad = Nac_Mexicano THEN
                                      Des_Mexicano
                                  ELSE  Des_Extranjero
                              END,          Coy.ClienteConyID,
      Coy.AntiguedadAnios,  Coy.AntiguedadMeses,  Coy.TelefonoTrabajo,
            IF(IFNULL(Ocu.OcupacionID,Entero_Cero) = Entero_Cero,Ocu.Descripcion,cl.Puesto)
    INTO
      Var_ConyPriNom,         Var_ConySegNom,         Var_ConyTerNom,         Var_ConyApePat,
      Var_ConyApeMat,         Var_ConyFecNac,         Var_ConyPaiNac,         Var_ConyEstNac,
      Var_ConyNomEmp,         Var_ConyEstEmp,         Var_ConyMunEmp,         Var_ConyColEmp,
      Var_ConyCalEmp,         Var_ConyNumExt,         Var_ConyNumInt,         Var_ConyNumPiso,
      Var_ConyCodPos,         Var_ConyAntAnio,        Var_ConyAntMes,         Var_ConyTelTra,
      Var_ConyTelCel,         Var_ConyOcupa,          Var_ConyNacion,     Var_ClienteConyID,
            ConyAntiguAnios,    ConyAntiguMeses,    ConyTrabTel,      ConyTrabPuesto

    FROM SOCIODEMOCONYUG Coy
    LEFT OUTER JOIN PAISES Pan ON Coy.PaisNacimiento = Pan.PaisID
    LEFT OUTER JOIN ESTADOSREPUB Esr ON Coy.EstadoNacimiento = Esr.EstadoID
    LEFT OUTER JOIN ESTADOSREPUB Est ON Coy.EntidadFedTrabajo = Est.EstadoID
    LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON Coy.EntidadFedTrabajo = Mun.EstadoID AND Coy.MunicipioTrabajo  = Mun.MunicipioID
    LEFT OUTER JOIN COLONIASREPUB col ON Coy.EntidadFedTrabajo = col.EstadoID AND Coy.MunicipioTrabajo  = col.MunicipioID AND col.ColoniaID = Coy.ColoniaTrabajo
    LEFT OUTER JOIN OCUPACIONES Ocu ON Coy.OcupacionID = Ocu.OcupacionID
    LEFT OUTER JOIN CLIENTES cl ON cl.ClienteID = Var_ClienteID
    WHERE (
      CASE
        WHEN IFNULL(Var_ClienteID, Entero_Cero) != Entero_Cero
          THEN Coy.ClienteID
        ELSE Coy.ProspectoID
      END) = (
      CASE
          WHEN IFNULL(Var_ClienteID, Entero_Cero) != Entero_Cero THEN Var_ClienteID
               ELSE Var_ProspectoID
             END)
    LIMIT 1;

    IF(IFNULL(Var_ClienteConyID, Entero_Cero) != Entero_Cero )THEN
      SELECT
        Calle,        NumeroCasa,     Colonia
      INTO
        ConyDirTrabCalle, ConyDirTrabNum,   ConyDirTrabCol
      FROM
        DIRECCLIENTE
      WHERE ClienteID = Var_ClienteConyID
      AND   TipoDireccionID IN (3) LIMIT 1;

      SELECT
        FLOOR(cl.AntiguedadTra*12), cl.TelTrabajo,  IF(IFNULL(oc.OcupacionID,Entero_Cero) = Entero_Cero,oc.Descripcion,cl.Puesto)
      INTO
        ConyTrabAntigu,       ConyTrabTel,  ConyTrabPuesto
      FROM
        CLIENTES cl
        LEFT OUTER JOIN OCUPACIONES oc ON oc.OcupacionID = cl.OcupacionID
      WHERE
        ClienteID = Var_ClienteConyID
      LIMIT 1;
    END IF;
  END IF;

  SET Var_ConyPriNom := IFNULL(Var_ConyPriNom,Cadena_Vacia);
  SET Var_ConySegNom := IFNULL(Var_ConySegNom,Cadena_Vacia);
  SET Var_ConyTerNom := IFNULL(Var_ConyTerNom,Cadena_Vacia);
  SET Var_ConyApePat := IFNULL(Var_ConyApePat,Cadena_Vacia);
  SET Var_ConyFecNac := IFNULL(Var_ConyFecNac,Fecha_Vacia);
  SET Var_ConyPaiNac := IFNULL(Var_ConyPaiNac,Cadena_Vacia);
  SET Var_ConyEstNac := IFNULL(Var_ConyEstNac,Cadena_Vacia);
  SET Var_ConyApeMat := IFNULL(Var_ConyApeMat,Cadena_Vacia);
  SET Var_ConyNomEmp := IFNULL(Var_ConyNomEmp,Cadena_Vacia);
  SET Var_ConyEstEmp := IFNULL(Var_ConyEstEmp,Cadena_Vacia);
  SET Var_ConyMunEmp := IFNULL(Var_ConyMunEmp,Cadena_Vacia);
  SET Var_ConyColEmp := IFNULL(Var_ConyColEmp,Cadena_Vacia);
  SET Var_ConyCalEmp := IFNULL(Var_ConyCalEmp,Cadena_Vacia);
  SET Var_ConyNumExt := IFNULL(Var_ConyNumExt,Cadena_Vacia);
  SET Var_ConyNumInt := IFNULL(Var_ConyNumInt,Cadena_Vacia);
  SET Var_ConyNumPiso := IFNULL(Var_ConyNumPiso,Cadena_Vacia);
  SET Var_ConyCodPos := IFNULL(Var_ConyCodPos,Cadena_Vacia);
  SET Var_ConyAntAnio := IFNULL(Var_ConyAntAnio,Cadena_Vacia);
  SET Var_ConyAntMes := IFNULL(Var_ConyAntMes,Entero_Cero);
  SET Var_ConyTelTra := IFNULL(Var_ConyTelTra,Cadena_Vacia);
  SET Var_ConyTelCel := IFNULL(Var_ConyTelCel,Cadena_Vacia);
  SET Var_ConyOcupa := IFNULL(Var_ConyOcupa,Cadena_Vacia);
  SET Var_ConyNacion := IFNULL(Var_ConyNacion,Cadena_Vacia);
  SET Var_ClienteConyID := IFNULL(Var_ClienteConyID,Entero_Cero);
  SET ConyAntiguAnios := IFNULL(ConyAntiguAnios,Cadena_Vacia);
  SET ConyAntiguMeses := IFNULL(ConyAntiguMeses,Cadena_Vacia);
  SET ConyTrabTel := IFNULL(ConyTrabTel,Cadena_Vacia);
  SET ConyTrabPuesto := IFNULL(ConyTrabPuesto,Cadena_Vacia);
  SET ConyDirTrabCalle := IFNULL(ConyDirTrabCalle,Cadena_Vacia);
  SET ConyDirTrabNum := IFNULL(ConyDirTrabNum,Cadena_Vacia);
  SET ConyDirTrabCol := IFNULL(ConyDirTrabCol,Cadena_Vacia);



  SELECT  NombreSucurs,   DirecCompleta,  Est.Nombre,   Mun.Nombre
    INTO  Var_NombreSucur,  Var_DirSucur, Var_EstadoSuc,  Var_SucMun
    FROM  SUCURSALES    Suc,
      ESTADOSREPUB  Est,
      MUNICIPIOSREPUB   Mun
    WHERE SucursalID    = Var_SucursalID
    AND Suc.EstadoID  = Est.EstadoID
    AND Suc.EstadoID  =   Mun.EstadoID
    AND Suc.MunicipioID = Mun.MunicipioID
  LIMIT 1;



  SET Var_Dia   = DAY(Fecha_Sis);
  SET Var_Mes   = CASE  MONTH(Fecha_Sis)
              WHEN  mes1  THEN  TxtEnero
              WHEN  mes2  THEN  TxtFebrero
              WHEN  mes3  THEN  TxtMarzo
              WHEN  mes4  THEN  TxtAbril
              WHEN  mes5  THEN  TxtMayo
              WHEN  mes6  THEN  TxtJunio
              WHEN  mes7  THEN  TxtJulio
              WHEN  mes8  THEN  TxtAgosto
              WHEN  mes9  THEN  TxtSeptiembre
              WHEN  mes10 THEN  TxtOctubre
              WHEN  mes11 THEN  TxtNoviembre
              WHEN  mes12 THEN  TxtDiciembre
            END;

  SET Var_Anio  = YEAR(Fecha_Sis);

  SELECT NomApoderado INTO Cli_RepLegal FROM ESCRITURAPUB WHERE Esc_Tipo = 'P' AND ClienteID = Var_ClienteID LIMIT 1;

  IF Cli_TipoPers = 'M' THEN
    SELECT  Calle,      NumeroCasa,   Colonia,  mr.Nombre,    er.Nombre
      INTO  Var_CalleTra, Cli_TrabNumExt, Var_ColTra, Var_MuniTra,  Var_EstadoTra
      FROM
          DIRECCLIENTE dc
          LEFT OUTER JOIN MUNICIPIOSREPUB mr
                ON  mr.EstadoID = dc.EstadoID
                AND mr.MunicipioID = dc.MunicipioID
          LEFT OUTER JOIN ESTADOSREPUB er
                ON  er.EstadoID = dc.EstadoID
        WHERE ClienteID = Var_ClienteID AND Fiscal = 'S' LIMIT 1;
  ELSE
    SELECT  Calle,      NumeroCasa,   Colonia,  mr.Nombre,    er.Nombre
      INTO  Var_CalleTra, Cli_TrabNumExt, Var_ColTra, Var_MuniTra,  Var_EstadoTra
      FROM
        DIRECCLIENTE dc
        LEFT OUTER JOIN MUNICIPIOSREPUB mr
              ON  mr.EstadoID = dc.EstadoID
              AND mr.MunicipioID = dc.MunicipioID
        LEFT OUTER JOIN ESTADOSREPUB er
              ON  er.EstadoID = dc.EstadoID
      WHERE ClienteID = Var_ClienteID
        AND TipoDireccionID = 3 LIMIT 1;
  END IF;
SET Var_CalleTra := IFNULL(Var_CalleTra,Cadena_Vacia);
SET Cli_TrabNumExt := IFNULL(Cli_TrabNumExt,Cadena_Vacia);
SET Var_ColTra := IFNULL(Var_ColTra,Cadena_Vacia);
SET Var_MuniTra := IFNULL(Var_MuniTra,Cadena_Vacia);
SET Var_EstadoTra := IFNULL(Var_EstadoTra,Cadena_Vacia);

  SET Var_IngresoMensual := (
                SELECT SUM(Monto)
                  FROM CLIDATSOCIOE
                    WHERE IF(ClienteID > 0 , ClienteID = Var_ClienteID,  ProspectoID = Var_ProspectoID)
                        AND  CatSocioEID = 1 );

SELECT  SUM(cs.Monto), GROUP_CONCAT(cat.Descripcion)
  INTO  SE_IngOtros,  SE_IngDesOtro
    FROM CLIDATSOCIOE cs, CATDATSOCIOE cat
      WHERE  IF(cs.ClienteID > 0 , cs.ClienteID = Var_ClienteID,  cs.ProspectoID = Var_ProspectoID)
        AND cat.CatSocioEID = cs.CatSocioEID
        AND cs.CatSocioEID != 1
        AND cat.Tipo = 'I'
        AND cs.Monto > 0;

SET SE_EgrCasa := (
  SELECT  SUM(cs.Monto)
    FROM CLIDATSOCIOE cs,
      CATDATSOCIOE cat
        WHERE  IF(cs.ClienteID > 0 , cs.ClienteID = Var_ClienteID,  cs.ProspectoID = Var_ProspectoID)
          AND cat.CatSocioEID = cs.CatSocioEID
          AND cs.CatSocioEID IN (2,7));

SET SE_EgrGastoFa := (
  SELECT  SUM(cs.Monto)
    FROM CLIDATSOCIOE cs,
      CATDATSOCIOE cat
        WHERE  IF(cs.ClienteID > 0 , cs.ClienteID = Var_ClienteID,  cs.ProspectoID = Var_ProspectoID)
          AND cat.CatSocioEID = cs.CatSocioEID
          AND cs.CatSocioEID = 8);


  SELECT  SUM(cs.Monto),  GROUP_CONCAT(cat.Descripcion)
    INTO  SE_EgrOtros,  SE_EgrDesOtr
      FROM CLIDATSOCIOE cs,
        CATDATSOCIOE cat
        WHERE  IF(cs.ClienteID > 0 , cs.ClienteID = Var_ClienteID,  cs.ProspectoID = Var_ProspectoID)
          AND cat.CatSocioEID = cs.CatSocioEID
          AND cs.CatSocioEID NOT IN(2,7,8)
          AND cat.Tipo = 'E'
          AND cs.Monto > 0;

SELECT  tv.Descripcion, sd.ValorVivienda
  INTO  SDV_TipoDom,  SDV_ValorViv
    FROM    SOCIODEMOVIVIEN sd
      LEFT OUTER JOIN TIPOVIVIENDA tv ON tv.TipoViviendaID = sd.TipoViviendaID
        WHERE IF(sd.ClienteID > 0 , sd.ClienteID = Var_ClienteID,  sd.ProspectoID = Var_ProspectoID)
        LIMIT 1;

SELECT  gar.Observaciones,  gar.ValorComercial
  INTO  Gar_Observ,     Var_ValorGar
  FROM ASIGNAGARANTIAS asi,
    GARANTIAS gar
    WHERE asi.SolicitudCreditoID = Par_SoliCredID
      AND asi.Estatus = 'U'
      AND gar.GarantiaID = asi.GarantiaID
      AND gar.TipoGarantiaID = 2 LIMIT 1;

SELECT  cte.BancoRef,   cte.NoCuentaRef,    cte.BancoRef2,      cte.NoCuentaRef2,
    cte.NombRefCom,   cte.TelRefCom,      cte.NombRefCom2,    cte.TelRefCom2,
    cte.NombreRef,    cte.DomicilioRef,   cte.TelefonoRef,    rel.Descripcion,
    cte.NombreRef2,   cte.DomicilioRef2,    cte.TelefonoRef2,   rel2.Descripcion,
		NoCuentaRefCom,			NoCuentaRefCom2,		DireccionRefCom,		DireccionRefCom2,		BanTipoCuentaRef,
		BanTipoCuentaRef2,		BanSucursalRef,			BanSucursalRef2,		BanNoTarjetaRef,		BanNoTarjetaRef2,
		BanTarjetaInsRef,		BanTarjetaInsRef2,		BanCredOtraEnt,			BanCredOtraEnt2,		BanInsOtraEnt,
		BanInsOtraEnt2
  INTO  Var_BancoRef,   Var_NoCtaRef,     Var_BancoRef2,      Var_NoCtaRef2,
      Var_NomRefCom,    Var_TelRefCom,      Var_NomRefCom2,     Var_TelRefCom2,
      Var_NombreRef,    Var_DomicilioRef,   Var_TelefonoRef1,   Var_Relacion,
      Var_NombreRef2,   Var_DomicilioRef2,    Var_TelefonoRef2,   Var_Relacion2,
		Var_NoCtaRefCom,		Var_NoCtaRefCom2,		Var_DirRefCom,			Var_DirRefCom2,			Var_TipCtaRefBan,
		Var_TipCtaRefBan2,		Var_SucRefBan,			Var_SucRefBan2,			Var_NoTarRefBan,		Var_NoTarRefBan2,
		Var_TarInRefBan,		Var_TarInRefBan2,		Var_CreOtraEnRefBan,	Var_CreOtraEnRefBan2,	Var_InsOtraEnRefBan,
		Var_InsOtraEnRefBan2
    FROM  CONOCIMIENTOCTE cte
        LEFT OUTER JOIN TIPORELACIONES rel ON cte.TipoRelacion1 = rel.TipoRelacionID
        LEFT OUTER JOIN TIPORELACIONES rel2 ON cte.TipoRelacion2 = rel2.TipoRelacionID
    WHERE cte.ClienteID = Var_ClienteID LIMIT 1;

SET SE_IngOtros := IFNULL(SE_IngOtros, Entero_Cero);
SET SE_EgrCasa := IFNULL(SE_EgrCasa, Entero_Cero);
SET SE_EgrGastoFa := IFNULL(SE_EgrGastoFa, Entero_Cero);
SET SE_EgrOtros := IFNULL(SE_EgrOtros, Entero_Cero);
SET SDV_ValorViv := IFNULL(SDV_ValorViv, Entero_Cero);


IF(Var_ConyAntAnio != Cadena_Vacia) THEN
  SET Var_ConyAntTra  := CONCAT(CONVERT(Var_ConyAntAnio, CHAR), " AÑO(S) ");

  IF(Var_ConyAntMes != Entero_Cero) THEN
    SET Var_ConyAntTra  := CONCAT(Var_ConyAntTra, " Y ", CONVERT(Var_ConyAntMes, CHAR), " MES(ES)");
  END IF;
ELSE
  IF(Var_ConyAntMes != Entero_Cero) THEN
    SET Var_ConyAntTra  := CONCAT(CONVERT(Var_ConyAntAnio, CHAR), " MES(ES)");
  END IF;
END IF;

	SELECT		LugarNacimiento,	EstadoID,		FEA,		TipoPersona
		INTO	Var_PaisID,			Var_EstadoID,	Var_FEA,	Var_TipoPersona
		FROM	CLIENTES
		WHERE	ClienteID = Var_ClienteID;

	SET Var_PaisID		:= IFNULL(Var_PaisID, Var_PaisInsuf);
	SET Var_EstadoID	:= IFNULL(Var_EstadoID, Entero_Cero);
	SET Var_FEA			:= IFNULL(Var_FEA, Cadena_Vacia);

	SELECT		Nombre
		INTO	Var_NomPais
		FROM	PAISES
		WHERE	PaisID = Var_PaisID;

	SELECT		Nombre
		INTO	Var_NomEstado
		FROM	ESTADOSREPUB
		WHERE	EstadoID = Var_EstadoID;

SELECT  Prom_Nombre,    Var_DesProducto,  Sol_FechaAut,   Sol_Disposi,    Var_Tasa,
    Var_FactorMora,   Var_NumAmortiza,  Var_Frecuencia,   Var_GarantiaLiq,  Sol_Proyecto,
    Sol_MontoAut,   Var_ClienteID,    Var_NombreCliente,  Cli_AntigClie,    Var_CliFechaNac,
    Cli_Edad,     Var_DescriEstCiv, Var_CliNacion,    Var_CliGenero,    Var_CliTipViv,
    Var_CliCalle,   Var_CliNumCasa,   Var_CliColoni,    Var_CliColMun,    Var_CliEstado,
    Var_CliCP,      Var_TelefonoRef,  Var_CliRFC,     Var_CliCURP,    Var_CliTelCel,
    VarTiempoHabi,    Var_ConyPriNom,   Var_ConySegNom,   Var_ConyTerNom,   Var_ConyApePat,
    Var_ConyApeMat,   Var_ConyOcupa,    Var_ClaveEstCiv,  Var_ClienteConyID,  ConyDirTrabCalle,
    ConyDirTrabNum,   ConyDirTrabCol,   ConyAntiguAnios,  ConyAntiguMeses,  ConyTrabTel,
    ConyTrabPuesto,   Cli_EsDepend,   Var_Ocupacion,    Cli_ActBMX,     Cli_SectorGral,
    Var_CliLugTra,    Cli_AntigTra,   Var_CliPuesto,    Var_CliTelTra,    Var_CalleTra,
    Cli_TrabNumExt,   Var_ColTra,     Var_MuniTra,    Var_EstadoTra,    Var_IngresoMensual,
    SE_IngOtros,    SE_IngDesOtro,    SE_EgrCasa,     SE_EgrGastoFa,    SE_EgrOtros,
    SE_EgrDesOtr,   SDV_TipoDom,    SDV_ValorViv,   Gar_Observ,     Var_ValorGar,
    Var_NombreRef,    Var_NombreRef2,   Var_DomicilioRef, Var_DomicilioRef2,  Var_Relacion,
    Var_Relacion2,    Var_TelefonoRef1, Var_TelefonoRef2, Var_NomRefCom,    Var_NomRefCom2,
    Var_TelRefCom,    Var_TelRefCom2,   Var_BancoRef,   Var_BancoRef2,    Var_NoCtaRef,
    Var_NoCtaRef2,    Var_SucursalID,   Var_Dia,      Var_Mes,      Var_Anio,
    Var_EstadoSuc,    Var_NombreSucur,  Cli_RepLegal,   Var_NombreCli,    Var_ApePaterno,
    Var_ApeMaterno,   Cli_FechNacD,   Cli_FechNacM,   Cli_FechNacA,   Var_CliSexo,
    Var_CliCalle2,    Var_CliNumCasa2,  Var_CliColoni2,   Var_CliColMun2,   Var_CliEstado2,
    Var_CliCP2,     Var_ConyMunEmp,     Var_ConyColEmp,   Var_ConyCalEmp,     Var_ConyNumExt,
    Var_CliCalle2,    Var_CliNumCasa2,  Var_CliColoni2,   Sol_MontoSol,   Var_TmpHabiDes,
    Var_SucMun,     Sol_FechaResult,  Var_ProspectoID,		Var_NomPais,		Var_NomEstado,
	Var_FEA,				Var_TipoPersona,		Var_NoCtaRefCom,	Var_NoCtaRefCom2,	Var_DirRefCom,
	Var_DirRefCom2,			Var_TipCtaRefBan,		Var_TipCtaRefBan2,	Var_SucRefBan,		Var_SucRefBan2,
	Var_NoTarRefBan,		Var_NoTarRefBan2,		Var_TarInRefBan,	Var_TarInRefBan2,	Var_CreOtraEnRefBan,
	Var_CreOtraEnRefBan2,	Var_InsOtraEnRefBan,	Var_InsOtraEnRefBan2;

END IF;

IF(Par_TipoReporte = TipoRep_FinSocial)THEN

  SELECT  C.ClienteID,    PC.Descripcion,     PC.EsGrupal,    C.FrecuenciaCap,  CreditoID,
      C.FechaVencimien, C.DestinoCreID,     C.MontoComApert,  C.TipoFondeo,   CuentaID,
      PC.RegistroRECA,  C.FechaMinistrado,    C.MontoCuota
  INTO  Var_ClienteIDFinS,  Var_DesProductoFinS,  Var_EsGrupalFinS, Var_DescPlaFinS,  Var_CreditoIDFinS,
      Var_FechaCorteFinS, Var_DestinoCred,    Var_ComApertFinS, Var_TipoFondeoFinS, Var_CuentaIDFinS,
      Var_RegisRecaFinS,  Var_FechaDesemFinS,   Var_FinSCuotaPagar
    FROM CREDITOS C,PRODUCTOSCREDITO PC
      WHERE PC.ProducCreditoID=C.ProductoCreditoID
        AND C.SolicitudCreditoID=Par_SoliCredID;

      SELECT  I.NombreCorto
      INTO  Var_NombreCortInstFiSoc
        FROM PARAMETROSSIS   P,   INSTITUCIONES I
          WHERE   I.InstitucionID=P.InstitucionID;

  SET Var_NombreCortInstFiSoc:=IFNULL(Var_NombreCortInstFiSoc,Cadena_Vacia);
  IF Var_InstFondFinS>0 THEN
      SET Var_RecursoPFinSoc:=DescRecursoP;
      ELSE
      SET Var_RecursoPFinSoc:=DescRecursoT;
  END IF;

  SELECT SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres) INTO Var_FinSoTotPagar
        FROM CREDITOS Cre,
             AMORTICREDITO Amo
        WHERE Cre.CreditoID   = Var_CreditoIDFinS
          AND Amo.CreditoID = Cre.CreditoID;

  SET Var_FinSoTotPagar     := IFNULL(Var_FinSoTotPagar,Entero_Cero);

    SELECT Proyecto,  MontoAutorizado,  MontoSolici   ,InstitFondeoID
    INTO Var_DescripDestFinS,Var_MontoAutorFinS,Var_MontoSoliciFinS, Var_InstFondFinS
    FROM SOLICITUDCREDITO
      WHERE SolicitudCreditoID=Par_SoliCredID;

            SELECT
      CONCAT(Cli.PrimerNombre,(CASE WHEN IFNULL(Cli.SegundoNombre, '')!='' THEN CONCAT(' ',Cli.SegundoNombre) ELSE ' ' END ),
      (CASE WHEN IFNULL(Cli.TercerNombre, '')!='' THEN CONCAT(' ',Cli.TercerNombre) ELSE ' ' END ))AS nombreCLi,
      (CASE WHEN IFNULL(Cli.ApellidoPaterno, '')!='' THEN CONCAT(' ',Cli.ApellidoPaterno) ELSE ' ' END ) AS apelliMat,
      (CASE WHEN IFNULL(Cli.ApellidoMaterno, '')!='' THEN CONCAT(' ',Cli.ApellidoMaterno) ELSE ' ' END )AS apelliPat,
      Cli.CURP,
      Cli.RFC,

            Cli.Nacion,       Cli.EstadoCivil,    Cli.Sexo,     Cli.Correo,      Cli.FechaNacimiento,
      Cli.Telefono,     Cli.TelefonoCelular,  Cli.NombreCompleto, Cli.LugardeTrabajo


      INTO Var_NombresCliFinS,
        Var_ApellCliPFinS,
        Var_ApellCliMFinS,
        Var_CliCURPFinS,
        Var_CliRFCFinS,

        Var_CliNacionFinS,    Var_EstadoCivilFinS,  Var_CliGeneroFinS,  Var_CliCorreoFinS,    Var_FechNFinS,
                Var_CliTelCasaFinS,   Var_CliTelCelFinS,    Var_NomComCliFinS,  Var_LugarTrabjFinS

      FROM CLIENTES Cli
        WHERE  Cli.ClienteID=Var_ClienteIDFinS;



      SELECT  Ocu.Descripcion,Ocu.ImplicaTrabajo
    INTO    Var_OcupacionFinS, Var_EmplFormFinS
      FROM CLIENTES Cli,OCUPACIONES Ocu
               WHERE  Ocu.OcupacionID=Cli.OcupacionID
        AND Cli.ClienteID=Var_ClienteIDFinS;

    SELECT   CCTE.PEPs, FP.Descripcion, CCTE.ParentescoPEP
      INTO  Var_PEPsFinS,     Var_DesPuesTPEPFinS,  Var_ParentPEPSFinS
            FROM CLIENTES Cli,CONOCIMIENTOCTE CCTE,FUNCIONESPUB FP
        WHERE CCTE.FuncionID=FP.FuncionID
          AND CCTE.ClienteID=Cli.ClienteID
                    AND Cli.ClienteID=Var_ClienteIDFinS;


  SET Var_CliCorreoFinS :=IFNULL(Var_CliCorreoFinS,Cadena_Vacia);
  SET Var_CliRFCFinS    :=IFNULL(Var_CliRFCFinS,Cadena_Vacia);
  SET Var_OcupacionFinS :=IFNULL(Var_OcupacionFinS,Cadena_Vacia);
  SET Var_FechNFinS   :=IFNULL(Var_FechNFinS,Fecha_Vacia);
  SET Var_EmplFormFinS  :=IFNULL(Var_EmplFormFinS,Cadena_Vacia);
  SET Var_CliTelCasaFinS  :=IFNULL(Var_CliTelCasaFinS,Cadena_Vacia);
  SET Var_CliTelCelFinS :=IFNULL(Var_CliTelCelFinS,Cadena_Vacia);
  SET Var_NomComCliFinS :=IFNULL(Var_NomComCliFinS,Cadena_Vacia);
  SET Var_PEPsFinS    :=IFNULL(Var_PEPsFinS,'N');
  SET Var_DesPuesTPEPFinS :=IFNULL(Var_DesPuesTPEPFinS,Cadena_Vacia);
  SET Var_ParentPEPSFinS  :=IFNULL(Var_ParentPEPSFinS,'N');
  SET Var_LugarTrabjFinS  :=IFNULL(Var_LugarTrabjFinS,Cadena_Vacia);


    SET Var_CliNacionFinS := CASE WHEN Var_CliNacionFinS =Nac_Mexicano THEN
                      DescNacional
                                        ELSE
                      DescExtranjero END ;

   SET Var_EstadoCivilFinS := CASE  WHEN Var_EstadoCivilFinS =Est_Soltero     THEN Des_Soltero
                  WHEN Var_EstadoCivilFinS =Est_CasBieSep   THEN Des_CasBieSep
                  WHEN Var_EstadoCivilFinS =Est_CasBieMan   THEN Des_CasBieMan
                  WHEN Var_EstadoCivilFinS =Est_CasCapitu   THEN Des_CasCapitu
                  WHEN Var_EstadoCivilFinS =Est_Viudo     THEN Des_Viudo
                  WHEN Var_EstadoCivilFinS =Est_Divorciad   THEN Des_Divorciad
                  WHEN Var_EstadoCivilFinS =Est_Seperados   THEN Des_Seperados
                  WHEN Var_EstadoCivilFinS =Est_UnionLibre  THEN Des_UnionLibre
                  ELSE
                    Cadena_Vacia END ;


  SELECT SUM(Cli.Monto) INTO Var_IngresDeclaFinS
    FROM CLIDATSOCIOE Cli
      INNER JOIN CATDATSOCIOE Cat ON Cli.CatSocioEID = Cat.CatSocioEID
    WHERE  Cli.ClienteID = Var_ClienteIDFinS AND  Cat.Tipo='I';-- INGRESOSS

    SELECT SUM(Cli.Monto) INTO Var_GastosDeclaFinS
    FROM CLIDATSOCIOE Cli
      INNER JOIN CATDATSOCIOE Cat ON Cli.CatSocioEID = Cat.CatSocioEID
    WHERE  Cli.ClienteID = Var_ClienteIDFinS AND  Cat.Tipo='E';-- EGRESOS


    SET Var_ClienteIDCFinS:=Var_ClienteIDFinS ;
  WHILE 12>CHAR_LENGTH(Var_ClienteIDCFinS) DO
    SET Var_ClienteIDCFinS:=CONCAT(Entero_Cero,Var_ClienteIDCFinS);
    END WHILE;


   SELECT
    DC.Calle,     DC.NumeroCasa,    DC.Colonia,     MR.Nombre,      ER.Nombre,
    DC.CP,        DC.NumInterior,   NombreLocalidad
  INTO
    Var_CliCalleFinS, Var_CliNumCasaFinS, Var_CliColoniFinS,  Var_CliColMunFinS,  Var_CliEstadoFinS,
    Var_CliCPFinS,    Var_CliNumIntFinS,  Var_CliCiudadFinS
  FROM DIRECCLIENTE   DC
      LEFT OUTER JOIN ESTADOSREPUB ER   ON  ER.EstadoID = DC.EstadoID
      LEFT OUTER JOIN MUNICIPIOSREPUB MR  ON  MR.MunicipioID  = DC.MunicipioID AND MR.EstadoID  = DC.EstadoID
          LEFT OUTER JOIN LOCALIDADREPUB  LB  ON  LB.LocalidadID  = DC.LocalidadID AND  LB.MunicipioID=DC.MunicipioID AND LB.EstadoID = DC.EstadoID AND LB.EstadoID = DC.EstadoID
    WHERE ClienteID = Var_ClienteIDFinS
      AND TipoDireccionID = 1
      AND Oficial = Var_SI LIMIT 1;

  SELECT TipoViviendaID,TiempoHabitarDom
    INTO  Var_TipoVivIIDFinS,Var_TiemHabiDomFinS
      FROM SOCIODEMOVIVIEN
            WHERE  ClienteID = Var_ClienteIDFinS;

  SET  Var_AniosFinS  :=  IFNULL(Var_AniosFinS,Entero_Cero);
  SET  Var_MesesFinS  :=  IFNULL(Var_MesesFinS,Entero_Cero);
  SET  Var_AniosFinS  :=  Var_TiemHabiDomFinS DIV 12;
  SET  Var_MesesFinS  :=  (Var_MesesFinS)-Var_AniosFinS;
  IF Var_MesesFinS<0 THEN
    SET Var_MesesFinS:=Entero_Cero;
  END IF;



  SET Var_IngresNegoFins:=(SELECT   SUM(Monto)FROM CLIDATSOCIOE Cli
                WHERE Cli.ClienteID = Var_ClienteIDFinS
                  AND CatSocioEID=13);-- negocio

  SET Var_GastosNegoFinS :=(SELECT SUM(Monto)FROM CLIDATSOCIOE Cli
                WHERE Cli.ClienteID = Var_ClienteIDFinS
                  AND CatSocioEID=14);

  SET Var_OtrosGastoFinS:=(SELECT   SUM(Monto)FROM CLIDATSOCIOE Cli
                WHERE Cli.ClienteID = Var_ClienteIDFinS
                  AND CatSocioEID=11);

  SET Var_OtrosIngreFinS:= (SELECT  SUM(Monto)FROM CLIDATSOCIOE Cli
                WHERE Cli.ClienteID = Var_ClienteIDFinS
                  AND CatSocioEID=6);

  IF Var_IngresNegoFins <=0 THEN
    SET Var_LugarTrabjFinS  :=Cadena_Vacia;
    END IF;

    SET Var_IngresNegoFins  :=IFNULL(Var_IngresNegoFins,Entero_Cero);
  SET Var_GastosNegoFinS  :=IFNULL(Var_GastosNegoFinS,Entero_Cero);
  SET Var_OtrosGastoFinS  :=IFNULL(Var_OtrosGastoFinS,Entero_Cero);
  SET Var_OtrosIngreFinS  :=IFNULL(Var_OtrosIngreFinS,Entero_Cero);

   SELECT NumIdentific INTO Var_NumIdeIFEFinS FROM IDENTIFICLIENTE
    WHERE ClienteID=Var_ClienteIDFinS
      AND TipoIdentiID=1 LIMIT 1;
  SET Var_NumIdeIFEFinS=IFNULL(Var_NumIdeIFEFinS,Cadena_Vacia);

  SELECT DATE(MAX(FechaConsulta)),  max(FolioConsulta)
    INTO Var_FecConBuFinSoc,    Var_FolConBuFinSoc
        FROM SOLBUROCREDITO
          WHERE  RFC=Var_CliRFCFinS
            GROUP BY FechaConsulta ORDER BY FechaConsulta  DESC LIMIT 1   ;

    SELECT UsuarioID
    INTO Var_IDConsulFinSoc
      FROM  BUCREPARAMETROS LIMIT 1;

    SET Var_ConseFirmaCFinS := (SELECT MAX(Consecutivo) FROM FIRMAREPLEGAL F
                INNER JOIN PARAMETROSSIS P
                ON F.RepresentLegal =  P.NombreRepresentante);

  SELECT  FRL.Recurso
    INTO Var_RecurFirmCFinS
      FROM PARAMETROSSIS PS
        INNER JOIN FIRMAREPLEGAL FRL ON PS.NombreRepresentante = FRL.RepresentLegal
          AND FRL.Consecutivo       = Var_ConseFirmaCFinS;

    SELECT Descripcion
    INTO Var_DescripSolFinS
      FROM SOLICITUDCREDITO SL,CREDITOSPLAZOS CP
        WHERE SL.PlazoID=CP.PlazoID
          AND SolicitudCreditoID=Par_SoliCredID;
    SET Var_DescripSolFinS:=IFNULL(Var_DescripSolFinS,Cadena_Vacia);
    SET Var_RecurFirmCFinS:=IFNULL(Var_RecurFirmCFinS,Cadena_Vacia);
    SET Var_RecurFirmCFinS := IFNULL(Var_RecurFirmCFinS,Cadena_Vacia);

    SELECT  Var_ClienteIDCFinS,   Var_DesProductoFinS,  Var_EsGrupalFinS, Var_DescPlaFinS,  Var_NombresCliFinS,
      Var_ApellCliPFinS,    Var_ApellCliMFinS,    Var_CliCURPFinS,  Var_CliRFCFinS,   Var_CliNacionFinS,
            Var_EstadoCivilFinS,  Var_CliGeneroFinS,    Var_CliCorreoFinS,  Var_OcupacionFinS,  Var_FechNFinS,
            Var_EmplFormFinS,   Var_IngresDeclaFinS,  Var_CliCalleFinS, Var_CliNumCasaFinS, Var_CliColoniFinS,
            Var_CliColMunFinS,    Var_CliEstadoFinS,    Var_CliCPFinS,    Var_CliNumIntFinS,  Var_CliCiudadFinS,
            Var_CliTelCasaFinS,   Var_CliTelCelFinS,    Var_TipoVivIIDFinS, Var_TiemHabiDomFinS,Var_DesProductoFinS,
            Var_EsGrupalFinS,   Var_DescPlaFinS,    Var_CreditoIDFinS,  Var_FechaCorteFinS, Var_DestinoCred,
            Var_DescripDestFinS,  Var_MontoAutorFinS,   Var_MontoSoliciFinS,Var_ComApertFinS,

       FUNCIONMONTOGARLIQ(Var_CreditoIDFinS) AS MontoGarLiq,
           Var_FinSoTotPagar,
           IFNULL(Var_TipoFondeoFinS,'') AS Var_TipoFondeoFinS,
           Var_CuentaIDFinS,
           Var_NomComCliFinS,
           Var_PEPsFinS,
           Var_DesPuesTPEPFinS, Var_ParentPEPSFinS,   Var_RegisRecaFinS,    Var_FechaDesemFinS, Var_MesesFinS,
           Var_AniosFinS,     Var_IngresNegoFins,   Var_GastosNegoFinS,   Var_OtrosGastoFinS, Var_OtrosIngreFinS,
           Var_LugarTrabjFinS,  Var_GastosDeclaFinS,  Var_NumIdeIFEFinS,    Var_FecConBuFinSoc, Var_FolConBuFinSoc,
           Var_IDConsulFinSoc,  Var_RecurFirmCFinS,   Var_DescripSolFinS,   Var_RecursoPFinSoc, Var_FinSCuotaPagar,
           Var_NombreCortInstFiSoc;
END IF;

-- Sección Alternativa 19
IF(Par_TipoReporte = Tipo_Alternativa)THEN

SELECT Sol.ClienteID,	Sol.ProspectoID,	Sol.SucursalID,		Sol.ProductoCreditoID,	Dc.Clasificacion
     INTO 	Var_ClienteID,	Var_ProspectoID,	Var_SucursalID,	Var_ProducCredID, Var_ClasProd
        FROM SOLICITUDCREDITO Sol
        LEFT JOIN PRODUCTOSCREDITO Pc ON Sol.ProductoCreditoID = Pc.ProducCreditoID
		LEFT JOIN DESTINOSCREDITO Dc ON Sol.DestinoCreID = Dc.DestinoCreID
        WHERE Sol.SolicitudCreditoID = Par_SoliCredID
    LIMIT 1;

    SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);
    SET Var_ProspectoID := IFNULL(Var_ProspectoID, Entero_Cero);
    SET Var_ProducCredID := IFNULL(Var_ProducCredID, Entero_Cero);

-- Nombre Institucion
	SELECT I.Nombre
		INTO Var_NombreInstitucion
		 FROM PARAMETROSSIS Par
		 INNER JOIN INSTITUCIONES I ON Par.InstitucionID = I.InstitucionID;

         -- TABLA TEMPORAL PARA ALMACENAR LOS  DATOS DEL CLIENTE
	DROP TABLE IF EXISTS TMPDATOSCLIENTE;
		CREATE TEMPORARY TABLE TMPDATOSCLIENTE(
			SolicitudCreditoID	BIGINT(12),
			ClienteID			BIGINT(12),
			NombreCompleto		VARCHAR(200),
            ApellidoPaterno		VARCHAR(50),
            ApellidoMaterno 	VARCHAR(50),
			FechaNacimiento		DATE,
			Edad				INT(11),
            CURP				CHAR(18),
            RFC					CHAR(13),
            NumIdentific		VARCHAR(30),
            Sexo				CHAR(1),
            Correo				VARCHAR(50),
			OcupacionID			INT(11),
            DescOcup			TEXT,
            LugarNacimientoID	INT(11),
			LugarNacimiento		VARCHAR(150),
			EstadoNacID			INT(11),
			EstadoNac			VARCHAR(100),
			PaisResID			INT(5),
			PaisRes				VARCHAR(150),
			Nacionalidad		CHAR(1),
			Telefono			VARCHAR(20),
			TelefonoCelular		VARCHAR(20),
			EstadoCivil			CHAR(2),
			Calle				VARCHAR(50),
			NumExt				CHAR(10),
			NumInt				CHAR(10),
			Manz				CHAR(50),
			Lote				CHAR(50),
			EstadoID			INT(11),
			NomEstado			VARCHAR(100),
			MunicipioID			INT(11),
			NomMunicipio		VARCHAR(150),
			LocalidadID			INT(11),
			NomLocalidad		VARCHAR(220),
			ColoniaID			INT(11),
			NomColonia			VARCHAR(400),
			Cp					CHAR(5),
            ApPatConyugue		VARCHAR(30),
			ApMatConyugue		VARCHAR(30),
            NombreConyugue		VARCHAR(200),
			PaisConyugueID		INT(11),
			PaisConyugue		VARCHAR(150),
			FechNacConyugue		DATE,
			EdadConyugue		INT(11),
			NacConyugue			CHAR(1),
			TelCelConyugue		VARCHAR(16),
			OcupacionIDConyugue	INT(11),
			OcupacionConyugue	TEXT,
            FEA					VARCHAR(250)	-- Firma Electronica del Cliente
		);

	IF(Var_ClienteID != Entero_Cero) THEN
		INSERT INTO TMPDATOSCLIENTE (SolicitudCreditoID,	ClienteID,			NombreCompleto,	ApellidoPaterno,	ApellidoMaterno,
									 FechaNacimiento,		Edad,				CURP,			RFC,				NumIdentific,
									 Sexo,					Correo,				OcupacionID,	DescOcup,			LugarNacimientoID,
									 EstadoNacID,			PaisResID,			Nacionalidad,   Telefono,			TelefonoCelular,
									 EstadoCivil,			Calle,				NumExt,        	NumInt,         	Manz,
									 Lote,				 	EstadoID,           MunicipioID,	LocalidadID,    	ColoniaID,
									 Cp,					ApPatConyugue,		ApMatConyugue,	NombreConyugue,		PaisConyugueID,
									 FechNacConyugue,		EdadConyugue,		NacConyugue,	TelCelConyugue,		OcupacionIDConyugue,
									 OcupacionConyugue,		FEA)

		SELECT Sol.SolicitudCreditoID,	Cli.ClienteID,			CONCAT(IFNULL(Cli.PrimerNombre, Cadena_Vacia), ' ', IFNULL(Cli.SegundoNombre,Cadena_Vacia), ' ',
				IFNULL(Cli.TercerNombre, Cadena_Vacia)),				Cli.ApellidoPaterno,	Cli.ApellidoMaterno,	Cli.FechaNacimiento,
                TIMESTAMPDIFF(YEAR, Cli.FechaNacimiento, CURDATE()) AS EdadCliente,		Cli.CURP,               Cli.RFC,
				Idf.NumIdentific,		Cli.Sexo,				Cli.Correo,				O.OcupacionId,         	O.Descripcion,
                Cli.LugarNacimiento,	Cli.EstadoID,			Cli.PaisResidencia,     Cli.Nacion,				Cli.Telefono,
                Cli.TelefonoCelular,	Cli.EstadoCivil,		Dir.Calle,				Dir.NumeroCasa,			Dir.NumInterior,
                Dir.Manzana,			Dir.Lote,				Dir.EstadoID,           Dir.MunicipioID,		Dir.LocalidadID,
                Dir.ColoniaID,			Dir.CP,					Sc.ApellidoPaterno,     Sc.ApellidoMaterno,
                CONCAT(IFNULL(Sc.PrimerNombre,Cadena_Vacia) , ' ', IFNULL(Sc.SegundoNombre,Cadena_Vacia), ' ', IFNULL(Sc.TercerNombre,Cadena_Vacia)),
				Sc.PaisNacimiento,		Sc.FechaNacimiento,		TIMESTAMPDIFF(YEAR, Sc.FechaNacimiento, CURDATE()) AS EdadConyugue,
                Sc.Nacionalidad,		Sc.TelCelular,			Oc.OcupacionID,			Oc.Descripcion,			Cli.FEA
			FROM 	SOLICITUDCREDITO Sol
					INNER JOIN 	CLIENTES Cli		ON	Sol.ClienteID=Cli.ClienteID
					LEFT  JOIN 	DIRECCLIENTE Dir	ON	Cli.ClienteID= Dir.ClienteID
													AND	Dir.Oficial= Dir_Oficial
                    LEFT JOIN IDENTIFICLIENTE Idf   ON  Cli.ClienteID = Idf.ClienteID
					LEFT  JOIN 	SOCIODEMOCONYUG Sc	ON	Cli.ClienteID= Sc.ClienteID
                    LEFT JOIN OCUPACIONES  O		ON	Cli.OcupacionID = O.OcupacionID
                    LEFT JOIN OCUPACIONES  Oc		ON	Sc.OcupacionID = Oc.OcupacionID
			WHERE Sol.SolicitudCreditoID = Par_SoliCredID;
    ELSE
		INSERT INTO TMPDATOSCLIENTE (SolicitudCreditoID,	ClienteID,			NombreCompleto,	ApellidoPaterno,	ApellidoMaterno,
									 FechaNacimiento,		Edad,				CURP,			RFC,				NumIdentific,
									 Sexo,					Correo,				OcupacionID,	DescOcup,			LugarNacimientoID,
									 EstadoNacID,			PaisResID,			Nacionalidad,   Telefono,			TelefonoCelular,
									 EstadoCivil,			Calle,				NumExt,        	NumInt,         	Manz,
									 Lote,				 	EstadoID,           MunicipioID,	LocalidadID,    	ColoniaID,
									 Cp,					ApPatConyugue,		ApMatConyugue,	NombreConyugue,		PaisConyugueID,
									 FechNacConyugue,		EdadConyugue,		NacConyugue,	TelCelConyugue,		OcupacionIDConyugue,
									 OcupacionConyugue,		FEA)

		SELECT Sol.SolicitudCreditoID,	Pro.ProspectoID,		CONCAT(IFNULL(Pro.PrimerNombre,Cadena_Vacia), ' ', IFNULL(Pro.SegundoNombre,Cadena_Vacia), ' ',
				IFNULL(Pro.TercerNombre,Cadena_Vacia)),			Pro.ApellidoPaterno,	Pro.ApellidoMaterno,	Pro.FechaNacimiento,
                TIMESTAMPDIFF(YEAR, Pro.FechaNacimiento, CURDATE()) AS EdadCliente,		Cadena_Vacia,           Pro.RFC,
				Cadena_Vacia,			Pro.Sexo,				Cadena_Vacia,			O.OcupacionId,         	O.Descripcion,
                Entero_Cero,			Entero_Cero,			Entero_Cero,            Cadena_Vacia,			Pro.Telefono,
                Cadena_Vacia,			Pro.EstadoCivil,		Pro.Calle,				Pro.NumExterior,		Pro.NumInterior,
                Pro.Manzana,			Pro.Lote,				Pro.EstadoID,           Pro.MunicipioID,		Pro.LocalidadID,
                Pro.ColoniaID,			Pro.CP,					Sc.ApellidoPaterno,     Sc.ApellidoMaterno,		CONCAT(IFNULL(Sc.PrimerNombre,Cadena_Vacia) , ' ',
                IFNULL(Sc.SegundoNombre,Cadena_Vacia), ' ', IFNULL(Sc.TercerNombre,Cadena_Vacia)),				Sc.PaisNacimiento,
                Sc.FechaNacimiento,		TIMESTAMPDIFF(YEAR, Sc.FechaNacimiento, CURDATE()) AS EdadConyugue,     Sc.Nacionalidad,
                Sc.TelCelular,			Oc.OcupacionID,			Oc.Descripcion,			Cadena_Vacia
			FROM 	SOLICITUDCREDITO Sol
					INNER JOIN 	PROSPECTOS Pro		ON	Sol.ProspectoID=Pro.ProspectoID
					LEFT  JOIN 	SOCIODEMOCONYUG Sc	ON	Pro.ProspectoID= Sc.ProspectoID
                    LEFT JOIN OCUPACIONES  O		ON	Pro.OcupacionID = O.OcupacionID
                    LEFT JOIN OCUPACIONES  Oc		ON	Sc.OcupacionID = Oc.OcupacionID
			WHERE Sol.SolicitudCreditoID = Par_SoliCredID;
    END IF;

		-- SE ACTUALIZAN CAMPOS

    -- LUGAR DE NACIMIENTO
    UPDATE  TMPDATOSCLIENTE T,
			PAISES P
	SET		T.LugarNacimiento=P.Nombre
    WHERE	T.LugarNacimientoID=P.PaisID;

       -- ESTADO NACIMIENTO
    UPDATE  TMPDATOSCLIENTE T,
			ESTADOSREPUB E
	SET		T.EstadoNac=E.Nombre
    WHERE	T.EstadoNacID=E.EstadoID;

       -- PAIS DE RESIDENCIA
    UPDATE  TMPDATOSCLIENTE T,
			PAISES P
	SET		T.PaisRes=P.Nombre
    WHERE	T.PaisResID=P.PaisID;

       -- ESTADO RESIDENCIA
    UPDATE  TMPDATOSCLIENTE T,
			ESTADOSREPUB E
	SET		T.NomEstado=E.Nombre
    WHERE	T.EstadoID=E.EstadoID;

		-- MUNICIPIO RESIDENCIA
    UPDATE  TMPDATOSCLIENTE T,
			MUNICIPIOSREPUB M
	SET		T.NomMunicipio=M.Nombre
    WHERE 	T.MunicipioID=M.MunicipioID
		AND T.EstadoID=M.EstadoID;

		-- LOCALIDAD RESIDENCIA
    UPDATE  TMPDATOSCLIENTE T,
			LOCALIDADREPUB L
	SET		T.NomLocalidad=L.NombreLocalidad
    WHERE	T.EstadoID=L.EstadoID
		AND T.MunicipioID=L.MunicipioID
        AND T.LocalidadID=L.LocalidadID;

    	-- COLONIA RESIDENCIA
    UPDATE  TMPDATOSCLIENTE T,
			COLONIASREPUB C
	SET		T.NomColonia= C.Asentamiento
    WHERE	T.EstadoID=C.EstadoID
		AND T.MunicipioID=C.MunicipioID
        AND T.ColoniaID=C.ColoniaID;

    -- LUGAR DE NACIMIENTO CONYUGUE
    UPDATE  TMPDATOSCLIENTE T,
			PAISES P
	SET		T.PaisConyugue=P.Nombre
    WHERE	T.PaisConyugueID=P.PaisID;

         -- TABLA TEMPORAL PARA ALMACENAR LOS  DATOS SOCIOECONOMICOS DEL CLIENTE
	DROP TABLE IF EXISTS TMPDATOSSOCCLIENTE;
		CREATE TEMPORARY TABLE TMPDATOSSOCCLIENTE(
			SolicitudCreditoID	BIGINT(12),
			CentroTrabajo		VARCHAR(100),
            AntiguedadTrabajo	DECIMAL(12,2),
            CatSueldoMensID		INT(11),
            SueldoMensual		DECIMAL(14,2),
            DescSueldo			VARCHAR(50),
            IngresoMensual		DECIMAL(14,2),
            DescIngreso			VARCHAR(50),
            -- Datos del Negocio
            ActividadNegID		VARCHAR(15),
            DesActividad		VARCHAR(200),
            NomNegocio   		VARCHAR(100),
            NumEmpleados		CHAR(10)


		);


    IF(Var_ClienteID != Entero_Cero) THEN
		INSERT INTO TMPDATOSSOCCLIENTE (SolicitudCreditoID,	CentroTrabajo,	AntiguedadTrabajo,	CatSueldoMensID,	SueldoMensual,
										DescSueldo,			ActividadNegID,	DesActividad,		NomNegocio,			NumEmpleados)

		SELECT Sol.SolicitudCreditoID,	Cli.LugardeTrabajo,	Cli.AntiguedadTra,	Ca.CatSocioEID,	Cl.Monto,
				Ca.Descripcion,			Ac.ActividadBMXID,	Ac.Descripcion,		Cc.NomGrupo,	Cc.NoEmpleados
				FROM 	SOLICITUDCREDITO Sol
						INNER JOIN 	CLIENTES Cli		ON	Sol.ClienteID=Cli.ClienteID
						LEFT  JOIN 	CONOCIMIENTOCTE Cc	ON	Cli.ClienteID= Cc.ClienteID
						LEFT JOIN 	ACTIVIDADESBMX Ac	ON 	Cli.ActividadBancoMX = Ac.ActividadBMXID
						LEFT JOIN CLIDATSOCIOE  Cl		ON	Cli.ClienteID = Cl.ClienteID
														AND Cl.CatSocioEID =1
						LEFT JOIN CATDATSOCIOE Ca		ON 	Cl.CatSocioEID = Ca.CatSocioEID
				WHERE Sol.SolicitudCreditoID = Par_SoliCredID;

		-- Se obtiene el total de Ingresos Mensuales
		SELECT Sum(Cl.Monto) as Monto
			INTO Var_TotalIngresoMens
				FROM 	SOLICITUDCREDITO Sol
						INNER JOIN 	CLIENTES Cli		ON	Sol.ClienteID=Cli.ClienteID
						LEFT JOIN CLIDATSOCIOE  Cl		ON	Cli.ClienteID = Cl.ClienteID
						LEFT JOIN CATDATSOCIOE Ca		ON 	Cl.CatSocioEID = Ca.CatSocioEID
				WHERE Sol.SolicitudCreditoID = Par_SoliCredID
				AND Ca.Tipo = Tipo_Ingreso;
    ELSE

	INSERT INTO TMPDATOSSOCCLIENTE (SolicitudCreditoID,		CentroTrabajo,		AntiguedadTrabajo,	CatSueldoMensID,	SueldoMensual,
										DescSueldo,			ActividadNegID,		DesActividad,		NomNegocio,			NumEmpleados)

    SELECT Sol.SolicitudCreditoID,	Pro.LugardeTrabajo,	Pro.AntiguedadTra,	Ca.CatSocioEID,	Cl.Monto,
			Ca.Descripcion,			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia
			FROM 	SOLICITUDCREDITO Sol
					INNER JOIN 	PROSPECTOS Pro		ON	Sol.ProspectoID=Pro.ProspectoID
                    LEFT JOIN CLIDATSOCIOE  Cl		ON	Pro.ProspectoID = Cl.ProspectoID
													AND Cl.CatSocioEID =1
                    LEFT JOIN CATDATSOCIOE Ca		ON 	Cl.CatSocioEID = Ca.CatSocioEID
			WHERE Sol.SolicitudCreditoID = Par_SoliCredID;

	-- Se obtiene el total de Ingresos Mensuales
		SELECT Sum(Cl.Monto) as Monto
			INTO Var_TotalIngresoMens
				FROM 	SOLICITUDCREDITO Sol
						INNER JOIN 	PROSPECTOS Pro		ON	Sol.ProspectoID=Pro.ProspectoID
						LEFT JOIN CLIDATSOCIOE  Cl		ON	Pro.ProspectoID = Cl.ProspectoID
						LEFT JOIN CATDATSOCIOE Ca		ON 	Cl.CatSocioEID = Ca.CatSocioEID
				WHERE Sol.SolicitudCreditoID = Par_SoliCredID
				AND Ca.Tipo = Tipo_Ingreso;

    END IF;
-- Se consulta si el Cliente tiene Dependientes Economicos y cuantos.
	SELECT COUNT(Soc.DependienteID) INTO Var_NumDependientes
		FROM SOCIODEMODEPEND Soc
		INNER JOIN SOLICITUDCREDITO Sol
					ON Soc.ClienteID = Sol.ClienteID
					AND Soc.ProspectoID = Sol.ProspectoID
		WHERE Sol.SolicitudCreditoID = Par_SoliCredID;

	IF(Var_NumDependientes = Entero_Cero) THEN
		SET Var_TieneDep:= Var_NO;
	ELSE
		SET Var_TieneDep := Var_SI;
	END IF;

-- Se consulta si el Cliente tiene hijo y cuantos tiene
	SELECT COUNT(Soc.TipoRelacionID) INTO Var_NumHijos
		FROM SOCIODEMODEPEND Soc
		INNER JOIN SOLICITUDCREDITO Sol
					ON Soc.ClienteID = Sol.ClienteID
					AND Soc.ProspectoID = Sol.ProspectoID
		WHERE Sol.SolicitudCreditoID = Par_SoliCredID
			AND Soc.TipoRelacionID = Rel_Hijo;

    IF(Var_NumHijos = Entero_Cero) THEN
		SET Var_TieneHijos:= Var_NO;
	ELSE
		SET Var_TieneHijos := Var_SI;
	END IF;

    -- Se consulta si el Cliente tiene otros Ingresos
    SELECT Ca.CatSocioEID INTO Var_OtrosIngresos
			FROM 	SOLICITUDCREDITO Sol
                    LEFT JOIN CLIDATSOCIOE  Cl		ON	Sol.ClienteID = Cl.ClienteID
													AND Sol.ProspectoID = Cl.ProspectoID
                    LEFT JOIN CATDATSOCIOE Ca		ON 	Cl.CatSocioEID = Ca.CatSocioEID
			WHERE Sol.SolicitudCreditoID = Par_SoliCredID
            AND Ca.CatSocioEID = OtrosIngresos
            LIMIT 1;

	IF(Var_OtrosIngresos = OtrosIngresos) THEN
		SET Var_OtrosIng:= Var_SI;
	ELSE
		SET Var_OtrosIng := Var_NO;
	END IF;

	-- TABLA TEMPORAL PARA ALMACENAR LOS  DATOS DE LA SOLICITUD DE CREDITO
	DROP TEMPORARY TABLE IF EXISTS TMPDATOSSOLICITUD;
		CREATE TEMPORARY TABLE TMPDATOSSOLICITUD (
            SolicitudCreditoID	BIGINT(12),
            FechaAutorizacion	DATE,
            SucursalID			INT(11),
            NomSucursal			VARCHAR(50),
            DirSucursal			VARCHAR(200),
            PromotorID			INT(11),
            NomPromotor			VARCHAR(100),
            GrupoID				INT(11),
            NomGrupo			VARCHAR(200),
            MontoAutorizado		DECIMAL(12,2),
            PlazoID				VARCHAR(20),
            DescPlazo			VARCHAR(50),
            FrecuenciaCap		VARCHAR(20),
            CicloActualGrupo	INT(11),
            CargoInteg			VARCHAR(30)
		  );

	IF(Var_ClienteID != Entero_Cero) THEN
		INSERT INTO TMPDATOSSOLICITUD(SolicitudCreditoID,	FechaAutorizacion,	SucursalID,			NomSucursal,		DirSucursal,
											PromotorID,		NomPromotor,    	GrupoID,			NomGrupo,   		MontoAutorizado,
											PlazoID,        DescPlazo,      	FrecuenciaCap,      CicloActualGrupo,	CargoInteg)

		SELECT Sol.SolicitudCreditoID,	Sol.FechaAutoriza, 	Sol.SucursalID, 	Suc.NombreSucurs, 	Suc.DirecCompleta,
					Sol.PromotorID,		P.NombrePromotor,	Sol.GrupoID, 		G.NombreGrupo,		Sol.MontoAutorizado,
					Cp.PlazoID,			Cp.Descripcion,
										CASE Sol.FrecuenciaCap
											WHEN FrecSemanal    	THEN UPPER(TxtSemanal)
											WHEN FrecCatorcenal   	THEN UPPER(TxtCatorcenal)
											WHEN FrecQuincenal    	THEN UPPER(TxtQuincenal)
											WHEN FrecMensual    	THEN UPPER(TxtMensual)
											WHEN FrecPeriodica    	THEN UPPER(TxtPeriodica)
											WHEN FrecBimestral    	THEN UPPER(TxtBimestral)
											WHEN FrecTrimestral   	THEN UPPER(TxtTrimestral)
											WHEN FrecTetramestral	THEN UPPER(TxtTetramestral)
											WHEN FrecSemestral    	THEN UPPER(TxtSemestral)
											WHEN FrecAnual      	THEN UPPER(TxtAnual)
											WHEN FrecUnico      	THEN UPPER(TxtUnico)
										END,G.CicloActual, 		CASE Ig.Cargo
																	WHEN 1      THEN UPPER(Presidente)
																	WHEN 2      THEN UPPER(Tesorero)
																	WHEN 3      THEN UPPER(Secretario)
																	WHEN 4      THEN UPPER(Integrante)
																END
			FROM SOLICITUDCREDITO	Sol
			LEFT OUTER JOIN	SUCURSALES	Suc			ON	Sol.SucursalID 	= 	Suc.SucursalID
			LEFT OUTER JOIN	PROMOTORES	P			ON 	Sol.PromotorID 	= 	P.PromotorID
			LEFT OUTER JOIN	GRUPOSCREDITO	G		ON 	Sol.GrupoID		=	G.GrupoID
			LEFT OUTER JOIN INTEGRAGRUPOSCRE	Ig	ON 	Sol.GrupoID 	= 	Ig.GrupoID
													AND Sol.ClienteID 	= 	Ig.ClienteID
													AND Sol.SolicitudCreditoID	= Ig.SolicitudCreditoID
			LEFT OUTER JOIN CREDITOSPLAZOS		Cp	ON Sol.PlazoID = Cp.PlazoID
			WHERE Sol.SolicitudCreditoID = Par_SoliCredID;
	ELSE

    	INSERT INTO TMPDATOSSOLICITUD(SolicitudCreditoID,	FechaAutorizacion,	SucursalID,			NomSucursal,		DirSucursal,
											PromotorID,		NomPromotor,    	GrupoID,			NomGrupo,   		MontoAutorizado,
											PlazoID,        DescPlazo,      	FrecuenciaCap,      CicloActualGrupo,	CargoInteg)

		SELECT Sol.SolicitudCreditoID,	Sol.FechaAutoriza, 	Sol.SucursalID, 	Suc.NombreSucurs, 	Suc.DirecCompleta,
					Sol.PromotorID,		P.NombrePromotor,	Sol.GrupoID, 		G.NombreGrupo,		Sol.MontoAutorizado,
					Cp.PlazoID,			Cp.Descripcion,
										CASE Sol.FrecuenciaCap
											WHEN FrecSemanal    	THEN UPPER(TxtSemanal)
											WHEN FrecCatorcenal   	THEN UPPER(TxtCatorcenal)
											WHEN FrecQuincenal    	THEN UPPER(TxtQuincenal)
											WHEN FrecMensual    	THEN UPPER(TxtMensual)
											WHEN FrecPeriodica    	THEN UPPER(TxtPeriodica)
											WHEN FrecBimestral    	THEN UPPER(TxtBimestral)
											WHEN FrecTrimestral   	THEN UPPER(TxtTrimestral)
											WHEN FrecTetramestral	THEN UPPER(TxtTetramestral)
											WHEN FrecSemestral    	THEN UPPER(TxtSemestral)
											WHEN FrecAnual      	THEN UPPER(TxtAnual)
											WHEN FrecUnico      	THEN UPPER(TxtUnico)
										END,G.CicloActual, 			CASE Ig.Cargo
																		WHEN 1      THEN UPPER(Presidente)
																		WHEN 2      THEN UPPER(Tesorero)
																		WHEN 3      THEN UPPER(Secretario)
																		WHEN 4      THEN UPPER(Integrante)
																	END
			FROM SOLICITUDCREDITO	Sol
			LEFT OUTER JOIN	SUCURSALES	Suc			ON	Sol.SucursalID 	= 	Suc.SucursalID
			LEFT OUTER JOIN	PROMOTORES	P			ON 	Sol.PromotorID 	= 	P.PromotorID
			LEFT OUTER JOIN	GRUPOSCREDITO	G		ON 	Sol.GrupoID		=	G.GrupoID
			LEFT OUTER JOIN INTEGRAGRUPOSCRE	Ig	ON 	Sol.GrupoID 	= 	Ig.GrupoID
													AND Sol.ProspectoID = 	Ig.ProspectoID
													AND Sol.SolicitudCreditoID	= Ig.SolicitudCreditoID
			LEFT OUTER JOIN CREDITOSPLAZOS		Cp	ON Sol.PlazoID = Cp.PlazoID
			WHERE Sol.SolicitudCreditoID = Par_SoliCredID;

    END IF;
    -- GARANTIAS
    SELECT IFNULL(Gar.ClienteID, Entero_Cero), IFNULL(Gar.AvalID, Entero_Cero), IFNULL(Gar.ProspectoID, Entero_Cero), IFNULL(Gar.GaranteID, Entero_Cero),Tig.TipoGarantiasID,
    Clg.EsGarantiaReal
		INTO Var_GarCliente,Var_GarAval, Var_GarProspecto,Var_GarGarante,Var_TipoGarantia,
        Var_EsReal
        FROM ASIGNAGARANTIAS Asi,
             TIPOGARANTIAS Tig,
             CLASIFGARANTIAS Clg,
             GARANTIAS Gar
        LEFT OUTER JOIN CLIENTES Cli ON Cli.ClienteID = IFNULL(Gar.ClienteID, Entero_Cero)
        LEFT OUTER JOIN PROSPECTOS Pro ON Pro.ProspectoID = IFNULL(Gar.ProspectoID, Entero_Cero)
                                      AND IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero
		LEFT OUTER JOIN AVALES Ava ON Ava.AvalID = IFNULL(Gar.AvalID, Entero_Cero)
                                      AND IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero
        WHERE Asi.SolicitudCreditoID = Par_SoliCredID
          AND Asi.Estatus = Gar_Autorizado
          AND Asi.GarantiaID = Gar.GarantiaID
          AND Gar.TipoGarantiaID = Tig.TipoGarantiasID
          AND Gar.ClasifGarantiaID = Clg.ClasifGarantiaID
          AND Gar.TipoGarantiaID= Clg.TipoGarantiaID
          LIMIT 1;

			IF(Var_TipoGarantia = GarInmobiliaria) THEN
			 SET Valor_Garantia := Hipotecaria;
			 END IF;

			 IF(Var_TipoGarantia != GarInmobiliaria  AND Var_EsReal = Var_SI) THEN
			 SET Valor_Garantia := GReal;
			 END IF;

			  IF(Var_TipoGarantia = GarInmobiliaria  AND Var_GarAval != Entero_Cero) THEN
			 SET Valor_Garantia := GOblSolidario;
			 END IF;

     -- CONSULTA A BURO DE CREDITO
	IF(Var_ClienteID != Entero_Cero) THEN
		SELECT DATE(MAX(B.FechaConsulta)),  max(B.FolioConsulta)
		 INTO Var_FecConBuAlt, Var_FolConBuAlt
			FROM SOLBUROCREDITO B, CLIENTES C
			WHERE  B.RFC= C.RFC
            AND C.ClienteID = Var_ClienteID
            GROUP BY B.FechaConsulta ORDER BY B.FechaConsulta  DESC LIMIT 1  ;
    ELSE
		SELECT DATE(MAX(B.FechaConsulta)),  max(B.FolioConsulta)
			INTO Var_FecConBuAlt, Var_FolConBuAlt
			FROM SOLBUROCREDITO B, PROSPECTOS P
			WHERE  B.RFC= P.RFC
            AND P.ProspectoID = Var_ProspectoID
            GROUP BY B.FechaConsulta ORDER BY B.FechaConsulta  DESC LIMIT 1  ;
    END IF;
    SET Var_FecConBuAlt := IFNULL(Var_FecConBuAlt,Fecha_Vacia);
    IF (Var_FecConBuAlt != Fecha_Vacia) THEN
		 SET Var_Fecha   := FNFECHATEXTO(Var_FecConBuAlt);
    ELSE
		SET Var_Fecha := Cadena_Vacia;
    END IF;

    -- CONSULTA VALOR VIVIENDA
	SELECT Sd.ValorVivienda
	INTO Var_CliValorViv
	 FROM SOCIODEMOVIVIEN Sd
		INNER JOIN SOLICITUDCREDITO Sol
		ON Sd.ProspectoID = Sol.ProspectoID
		AND Sd.ClienteID = Sol.ClienteID
		WHERE Sol.SolicitudCreditoID = Par_SoliCredID;

	-- CONSULTA DESTINO DEL CREDITO
    IF(Var_ProducCredID = 200) then
		IF Var_ClasProd = Consumo THEN
			SET Var_DestCred = Habilitacion;
		ELSE
			SET Var_DestCred = Refaccionario;
		END IF;
	END IF;

	 SELECT	 T1.SolicitudCreditoID,	T1.NombreCompleto,	T1.ApellidoPaterno,		T1.ApellidoMaterno,		T1.FechaNacimiento,
			 T1.Edad,            	T1.CURP,           	T1.RFC,            		T1.NumIdentific,		T1.Sexo,
             T1.Correo,    			T1.DescOcup,       	T1.LugarNacimiento,		T1.EstadoNac,			T1.PaisRes,
			 T1.Nacionalidad,		T1.Telefono, 		T1.TelefonoCelular, 	T1.EstadoCivil,			T1.Calle,
			 T1.NumExt,				T1.NumInt,			T1.Manz,				T1.Lote,				T1.NomEstado,
			 T1.NomMunicipio,		T1.NomLocalidad,	T1.NomColonia,			T1.Cp,             		ApPatConyugue,
             T1.ApMatConyugue,		T1.NombreConyugue,	T1.PaisConyugue,		T1.FechNacConyugue,		T1.EdadConyugue,
             T1.NacConyugue,      	T1.TelCelConyugue,	T1.OcupacionConyugue, 	T2.SolicitudCreditoID,	T2.CentroTrabajo,
             T2.AntiguedadTrabajo,	T2.CatSueldoMensID,	CONCAT('$ ', FORMAT(T2.SueldoMensual,2)) AS SueldoMensual,
             T2.DescSueldo,         T2.ActividadNegID,	T2.DesActividad,		T2.NomNegocio,			T2.NumEmpleados,
             CONCAT('$ ', FORMAT(Var_TotalIngresoMens,2)) AS Var_TotalIngresoMens,T3.FechaAutorizacion,	T3.SucursalID,
             T3.NomSucursal,		T3.PromotorID,		T3.NomPromotor,         T3.GrupoID,	        	T3.NomGrupo,
             CONCAT('$ ', FORMAT(T3.MontoAutorizado,2)) AS MontoAutorizado, 	T3.PlazoID,             T3.DescPlazo,
             T3.FrecuenciaCap,   T3.CicloActualGrupo,	T3.CargoInteg,			Var_NumDependientes,    Var_TieneDep,
             Var_NumHijos,       	Var_TieneHijos,		Var_OtrosIng,			Valor_Garantia,         Var_NombreInstitucion,
             T1.FEA,             	Var_Fecha,    		Var_FolConBuAlt,		T3.DirSucursal,         CONCAT('$ ', FORMAT(Var_CliValorViv,2)) AS Var_CliValorViv,
             Var_DestCred
    FROM	TMPDATOSCLIENTE	T1
    LEFT JOIN TMPDATOSSOCCLIENTE T2
			ON T1.SolicitudCreditoID =T2.SolicitudCreditoID
	LEFT JOIN	TMPDATOSSOLICITUD T3
			ON T1.SolicitudCreditoID = T3.SolicitudCreditoID;

END IF; -- End if Alternativa 19

-- Dependientes Economicos Alternativa 19
IF(Par_TipoReporte = Sec_DepAlternativa) THEN

	SELECT ClienteID,		ProspectoID,		SucursalID, 	ProductoCreditoID
     INTO 	Var_ClienteID,	Var_ProspectoID,	Var_SucursalID,	Var_ProducCredID
        FROM SOLICITUDCREDITO
        WHERE SolicitudCreditoID = Par_SoliCredID
    LIMIT 1;

    SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);
    SET Var_ProspectoID := IFNULL(Var_ProspectoID, Entero_Cero);
    SET Var_ProducCredID := IFNULL(Var_ProducCredID, Entero_Cero);


    IF(Var_ClienteID != Entero_Cero) THEN
        SELECT  @s:=@s+1 AS Num, CONCAT(IFNULL(Dep.PrimerNombre,Cadena_Vacia),
                        (CASE WHEN IFNULL(Dep.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN
                            CONCAT(" ", Dep.SegundoNombre)
                        ELSE Cadena_Vacia
                        END),
                        (CASE WHEN IFNULL(Dep.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN
                            CONCAT(" ", Dep.TercerNombre)
                        ELSE Cadena_Vacia
                        END)) AS Nombre,
                        Dep.ApellidoPaterno as ApellidoPaterno, Dep.ApellidoMaterno as ApellidoMaterno, Rel.Descripcion as Relacion
            FROM SOCIODEMODEPEND Dep,
                 TIPORELACIONES Rel,
                 (SELECT @s:= Entero_Cero) AS s
            WHERE ClienteID = Var_ClienteID
              AND Dep.TipoRelacionID = Rel.TipoRelacionID;
    ELSE
        SELECT @s:=@s+1 AS Num,	CONCAT(IFNULL(Dep.PrimerNombre,Cadena_Vacia),
                        (CASE WHEN IFNULL(Dep.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN
                            CONCAT(" ", Dep.SegundoNombre)
                        ELSE Cadena_Vacia
                        END),
                        (CASE WHEN IFNULL(Dep.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN
                            CONCAT(" ", Dep.TercerNombre)
                        ELSE Cadena_Vacia
                        END)) as Nombre,
                        Dep.ApellidoPaterno AS ApellidoPaterno,Dep.ApellidoMaterno as ApellidoMaterno, Rel.Descripcion as Relacion
            FROM SOCIODEMODEPEND Dep,
                 TIPORELACIONES Rel,
                  (SELECT @s:= Entero_Cero) AS s
            WHERE ProspectoID = Var_ProspectoID
              AND Dep.TipoRelacionID = Rel.TipoRelacionID;
    END IF;

END IF; -- EndIf Dependientes Economicos Alternativa 19

IF(Par_TipoReporte = Seccion_AvalesAlt) THEN

	DROP TEMPORARY TABLE IF EXISTS TMPAVALESCREDITO;
		  CREATE TEMPORARY TABLE TMPAVALESCREDITO (
			TmpID         		INT(11) AUTO_INCREMENT,
			SolicitudCreditoID	INT(11),      	-- ID de la solicitud de credito
			ClienteIDAval     	INT(11),      	-- ID del cliente que es aval
			ProspectoIDAval     INT(11),      	-- ID del prospecto que es aval
			AvalID          	INT(11),      	-- ID del aval
			NombreAval        	VARCHAR(300),	-- Nombre  del aval
			ApellidoPaterno		VARCHAR(50),	-- Apellido Paterno
			ApellidoMaterno		VARCHAR(50),	-- Apellido Materno
			FechaNacimiento     DATE,       	-- Fecha de nacimiento del aval
			EdadAval			INT(11),		-- Edad
			CURPAval			CHAR(18),		-- CURP
			RFCAval				CHAR(13),		-- RFC
			Genero				CHAR(1),		-- Genero
			ClaveElector		VARCHAR(45),	-- Clave  de Elector
			Correo				VARCHAR(50),	-- Correo
			DesActividadBmx		VARCHAR(200),	-- Descripcion de Actividad o Giro
			Ocupacion       	TEXT,       	-- Ocupacion del Aval
			PaisNacimientoID	INT(11),		-- Pais de Nacimiento ID
			PaisNacimiento		VARCHAR(150),	-- Pais de Nacimiento
			EstadoNacimientoID	INT(11),		-- Estado Nacimiento ID
			EstadoNacimiento	VARCHAR(100),	-- Estado de Nacimiento
			PaisResidenciaID	INT(11),		-- Pais de Residencia ID
			PaisResidencia		VARCHAR(150),	-- Pais de Residencia
			Nacionalidad		CHAR(1),		-- Nacionalidad
			TelefonoCasa		VARCHAR(20),	-- Telefono de Casa
			TelefonoCelular		VARCHAR(20),	-- Telefono Celular
			EstadoCivil       	CHAR(2),    	-- Estado Civil
			Calle				VARCHAR(50),	-- Calle
			NoExt				CHAR(10),		-- Num Exterior
			NoInt				CHAR(10),		-- Num Interior
			Manzana				CHAR(50),		-- Manzana
			Lote				CHAR(50),		-- Lote
			Estado				VARCHAR(100),	-- Estado
			Municipio			VARCHAR(150),	-- Municipio
			Localidad			VARCHAR(200),	-- Localidad
			Colonia				VARCHAR(200),	-- Colonia
			CP					CHAR(5),		-- Codigo Postal
			PRIMARY KEY (TmpID),
			INDEX idxCliC(ClienteIDAval),
			INDEX idxCliA(AvalID),
			INDEX idxCliP(ProspectoIDAval)
		  );

			INSERT INTO TMPAVALESCREDITO(SolicitudCreditoID,	ClienteIDAval,	ProspectoIDAval,	AvalID,	PaisNacimientoID,
										EstadoNacimientoID,	PaisResidenciaID)

			SELECT Sol.SolicitudCreditoID,    IFNULL(AvaSol.ClienteID,Entero_Cero),   IFNULL(AvaSol.ProspectoID,Entero_Cero),	IFNULL(AvaSol.AvalID,Entero_Cero),	Cli.LugarNacimiento,
					Cli.EstadoID,	Cli.PaisResidencia
				FROM 	SOLICITUDCREDITO Sol
				INNER JOIN 	AVALESPORSOLICI AvaSol	ON	Sol.SolicitudCreditoID =AvaSol.SolicitudCreditoID
				LEFT OUTER JOIN 	CLIENTES Cli	ON	AvaSol.ClienteID=Cli.ClienteID
				WHERE AvaSol.SolicitudCreditoID  = Par_SoliCredID
				AND AvaSol.Estatus IN (Ava_Asignado,Ava_Autorizado);


		  # ===============   SE OBTIENEN DATOS CUANDO EL AVAL ES CLIENTE  ================
			UPDATE TMPAVALESCREDITO Tmp,  CLIENTES Cli
							  LEFT OUTER JOIN OCUPACIONES Ocu ON Cli.OcupacionID = Ocu.OcupacionID
							  LEFT OUTER JOIN ACTIVIDADESBMX Ac ON Cli.ActividadBancoMx = Ac.ActividadBMXID
							  LEFT OUTER JOIN IDENTIFICLIENTE Id ON Cli.ClienteID = Id.ClienteID
																AND Id.TipoIdentiID = Tipo_IdfElector
				SET	Tmp.NombreAval    	= 	CONCAT(IFNULL(Cli.PrimerNombre,Cadena_Vacia), ' ' , IFNULL(Cli.SegundoNombre,Cadena_Vacia), ' ' , IFNULL(Cli.TercerNombre,Cadena_Vacia)),
					Tmp.ApellidoPaterno	= 	Cli.ApellidoPaterno,
					Tmp.ApellidoMaterno	= 	Cli.ApellidoMaterno,
					Tmp.FechaNacimiento =   Cli.FechaNacimiento,
					Tmp.EdadAval		=	TIMESTAMPDIFF(YEAR, Cli.FechaNacimiento, CURDATE()),
					Tmp.CURPAval		= 	Cli.CURP,
					Tmp.RFCAval			= 	Cli.RFC,
					Tmp.Genero			= 	Cli.Sexo,
					Tmp.ClaveElector	= 	Id.NumIdentific,
					Tmp.Correo			= 	Cli.Correo,
					Tmp.DesActividadBmx	=	 Ac.Descripcion,
					Tmp.Ocupacion		= 	Ocu.Descripcion,
					Tmp.Nacionalidad	= 	Cli.Nacion,
					Tmp.TelefonoCasa    =   Cli.Telefono,
					Tmp.TelefonoCelular	=	Cli.TelefonoCelular,
					Tmp.EstadoCivil  	=   Cli.EstadoCivil
				WHERE Tmp.ClienteIDAval = 	Cli.ClienteID
				  AND Tmp.ClienteIDAval > Entero_Cero;

				-- LUGAR DE NACIMIENTO
			UPDATE  TMPAVALESCREDITO T,
					PAISES P
			SET		T.PaisNacimiento	=	P.Nombre
			WHERE	T.PaisNacimientoID	=	P.PaisID;

			   -- ESTADO NACIMIENTO
			UPDATE  TMPAVALESCREDITO T,
					ESTADOSREPUB E
			SET		T.EstadoNacimiento	=	E.Nombre
			WHERE	T.EstadoNacimientoID=	E.EstadoID;

				-- PAIS RESIDENCIA
			UPDATE  TMPAVALESCREDITO T,
					PAISES P
			SET		T.PaisResidencia	=	P.Nombre
			WHERE	T.PaisResidenciaID	=	P.PaisID;

			UPDATE  TMPAVALESCREDITO Tmp
				LEFT OUTER JOIN DIRECCLIENTE Dir ON Tmp.ClienteIDAval = Dir.ClienteID
				LEFT OUTER JOIN ESTADOSREPUB	E	ON	Dir.EstadoID	= E.EstadoID
				LEFT OUTER JOIN MUNICIPIOSREPUB	M	ON	Dir.EstadoID	= M.EstadoID
													AND Dir.MunicipioID	= M.MunicipioID
				LEFT OUTER JOIN LOCALIDADREPUB	L	ON	Dir.EstadoID	= L.EstadoID
													AND	Dir.MunicipioID	= L.MunicipioID
												AND Dir.LocalidadID = L.LocalidadID
				SET	Tmp.Calle		=	Dir.Calle,
					Tmp.NoExt		=	Dir.NumeroCasa,
					Tmp.NoInt		=	Dir.NumInterior,
					Tmp.Manzana		= 	Dir.Manzana,
					Tmp.Lote		=	Dir.Lote,
					Tmp.Estado		=	E.Nombre,
					Tmp.Municipio	=	M.Nombre,
					Tmp.Localidad	= 	L.NombreLocalidad,
					Tmp.Colonia   	= 	Dir.Colonia,
					Tmp.CP      	=   Dir.CP
				WHERE Dir.Oficial   = Dir_Oficial
					AND Tmp.ClienteIDAval  > Entero_Cero;

			# ============== SE OBTIENEN DATOS CUANDO EL AVAL ES PROSPECTO ================
			UPDATE  TMPAVALESCREDITO Tmp,   PROSPECTOS Pro
						LEFT OUTER JOIN OCUPACIONES Ocu 		ON Pro.OcupacionID	=	Ocu.OcupacionID
						LEFT OUTER JOIN ESTADOSREPUB	Est		ON Pro.EstadoID		=	Est.EstadoID
						LEFT OUTER JOIN MUNICIPIOSREPUB Mun		ON Pro.EstadoID 	= 	Mun.EstadoID
																AND Pro.MunicipioID = 	Mun.MunicipioID
						LEFT OUTER JOIN LOCALIDADREPUB	Loc		ON	Pro.EstadoID	= 	Loc.EstadoID
																AND	Pro.MunicipioID	=	Loc.MunicipioID
																AND	Pro.LocalidadID	=	Loc.LocalidadID

			SET Tmp.NombreAval    = CONCAT(IFNULL(Pro.PrimerNombre,Cadena_Vacia),' ',IFNULL(Pro.SegundoNombre,Cadena_Vacia),' ', IFNULL(Pro.TercerNombre,Cadena_Vacia)),
				Tmp.ApellidoPaterno	= 	Pro.ApellidoPaterno,
				Tmp.ApellidoMaterno	= 	Pro.ApellidoMaterno,
				Tmp.FechaNacimiento =   Pro.FechaNacimiento,
				Tmp.EdadAval		= 	TIMESTAMPDIFF(YEAR, Pro.FechaNacimiento, CURDATE()),
				Tmp.RFCAval			= 	Pro.RFC,
				Tmp.Genero			= 	Pro.Sexo,
				Tmp.Ocupacion   	= 	Ocu.Descripcion,
				Tmp.TelefonoCasa   	= 	Pro.Telefono,
				Tmp.EstadoCivil		= 	Pro.EstadoCivil,
				Tmp.Calle			=	Pro.Calle,
				Tmp.NoExt			= 	Pro.NumExterior,
				Tmp.NoInt			=	Pro.NumInterior,
				Tmp.Manzana			=	Pro.Manzana,
				Tmp.Lote			=	Pro.Lote,
				Tmp.Estado			=	Est.Nombre,
				Tmp.Municipio   	=   Mun.Nombre,
				Tmp.Localidad		=	Loc.NombreLocalidad,
				Tmp.Colonia     	=   Pro.Colonia,
				Tmp.CP        		=   Pro.CP
		  WHERE Tmp.ProspectoIDAval	= 	Pro.ProspectoID
			 AND  Tmp.ClienteIDAval = 	Entero_Cero
			 AND  Tmp.AvalID      	= 	Entero_Cero
			 AND  Tmp.ProspectoIDAval > Entero_Cero;

		  # ============== SE OBTIENEN DATOS CUANDO EL AVAL NO ES CLIENTE NI PROSPECTO ================
		  UPDATE  TMPAVALESCREDITO Tmp,  AVALES Ava
						LEFT OUTER JOIN ESTADOSREPUB	Est		ON Ava.EstadoID		=	Est.EstadoID
						LEFT OUTER JOIN MUNICIPIOSREPUB Mun		ON Ava.EstadoID 	= 	Mun.EstadoID
																AND Ava.MunicipioID = 	Mun.MunicipioID
						LEFT OUTER JOIN LOCALIDADREPUB	Loc		ON	Ava.EstadoID	= 	Loc.EstadoID
																AND	Ava.MunicipioID	=	Loc.MunicipioID
																AND	Ava.LocalidadID	=	Loc.LocalidadID
				SET Tmp.NombreAval		=	CONCAT(IFNULL(Ava.PrimerNombre,Cadena_Vacia),' ',IFNULL(Ava.SegundoNombre,Cadena_Vacia),' ',IFNULL(Ava.TercerNombre,Cadena_Vacia)),
					Tmp.ApellidoPaterno	=	Ava.ApellidoPaterno,
					Tmp.ApellidoMaterno	=	Ava.ApellidoMaterno,
					Tmp.FechaNacimiento	=	Ava.FechaNac,
					Tmp.EdadAval		= 	TIMESTAMPDIFF(YEAR, Ava.FechaNac, CURDATE()),
					Tmp.RFCAval			=	Ava.RFC,
					Tmp.Genero			=	Ava.Sexo,
					Tmp.TelefonoCasa	=	Ava.Telefono,
					Tmp.TelefonoCelular	=	Ava.TelefonoCel,
					Tmp.EstadoCivil		=	Ava.EstadoCivil,
					Tmp.Calle			=	Ava.Calle,
					Tmp.NoExt			=	Ava.NumExterior,
					Tmp.NoInt			=	Ava.NumInterior,
					Tmp.Manzana			= 	Ava.Manzana,
					Tmp.Lote			=	Ava.Lote,
					Tmp.Estado			=	Est.Nombre,
					Tmp.Municipio		=	Mun.Nombre,
					Tmp.Localidad		=	Loc.NombreLocalidad,
					Tmp.Colonia			=	Ava.Colonia,
					Tmp.CP				=	Ava.CP
			WHERE	Tmp.AvalID  		= Ava.AvalID
				AND	Tmp.ClienteIDAval	= Entero_Cero
				AND Tmp.AvalID      	> Entero_Cero;


		  # ================   SE OBTIENE OBTIENEN LOS DATOS QUE ESPERA EL .PRPT   ================

	 SELECT  IFNULL(SolicitudCreditoID, Cadena_Vacia)    AS SolicitudCreditoID,	IFNULL(ClienteIDAval, Cadena_Vacia)    AS ClienteIDAval,
			IFNULL(ProspectoIDAval, Cadena_Vacia)    AS ProspectoIDAval,	IFNULL(AvalID, Cadena_Vacia)    AS AvalID,
			IFNULL(NombreAval, Cadena_Vacia)    AS NombreAval,	IFNULL(ApellidoPaterno, Cadena_Vacia)    AS ApellidoPaterno,
			IFNULL(ApellidoMaterno, Cadena_Vacia)    AS ApellidoMaterno,	IFNULL(FechaNacimiento, Cadena_Vacia)    AS FechaNacimiento,
			IFNULL(EdadAval, Cadena_Vacia)    AS EdadAval,	IFNULL(CURPAval, Cadena_Vacia)    AS CURPAval,
			IFNULL(RFCAval, Cadena_Vacia)    AS RFCAval,	IFNULL(Genero, Cadena_Vacia)    AS Genero,
			IFNULL(ClaveElector, Cadena_Vacia)    AS ClaveElector,	IFNULL(Correo, Cadena_Vacia)    AS Correo,
			IFNULL(DesActividadBmx, Cadena_Vacia)    AS DesActividadBmx,	IFNULL(Ocupacion, Cadena_Vacia)    AS Ocupacion,
			IFNULL(PaisNacimientoID, Cadena_Vacia)    AS PaisNacimientoID,	IFNULL(PaisNacimiento, Cadena_Vacia)    AS PaisNacimiento,
			IFNULL(EstadoNacimientoID, Cadena_Vacia)    AS EstadoNacimientoID,	IFNULL(EstadoNacimiento, Cadena_Vacia)    AS EstadoNacimiento,
			IFNULL(PaisResidenciaID, Cadena_Vacia)    AS PaisResidenciaID,	IFNULL(PaisResidencia, Cadena_Vacia)    AS PaisResidencia,
			IFNULL(Nacionalidad, Cadena_Vacia)    AS Nacionalidad,	IFNULL(TelefonoCasa, Cadena_Vacia)    AS TelefonoCasa,
			IFNULL(TelefonoCelular, Cadena_Vacia)    AS TelefonoCelular,	IFNULL(EstadoCivil, Cadena_Vacia)    AS EstadoCivil,
			IFNULL(Calle, Cadena_Vacia)    AS Calle,	IFNULL(NoExt, Cadena_Vacia)    AS NoExt,
			IFNULL(NoInt, Cadena_Vacia)    AS NoInt,	IFNULL(Manzana, Cadena_Vacia)    AS Manzana,
			IFNULL(Lote, Cadena_Vacia)    AS Lote,	IFNULL(Estado, Cadena_Vacia)    AS Estado,
			IFNULL(Municipio, Cadena_Vacia)    AS Municipio,	IFNULL(Localidad, Cadena_Vacia)    AS Localidad,
			IFNULL(Colonia, Cadena_Vacia)    AS Colonia,	IFNULL(CP, Cadena_Vacia)    AS CP
		  FROM TMPAVALESCREDITO Tmp
          LIMIT 1;

		  # ===================   SE ELIMINAN LOS DATOS TEMPORALES ====================
		  DROP TEMPORARY TABLE IF EXISTS TMPAVALESCREDITO;

END IF; -- EndIf Seccion de Avales

-- Referencias Familiares
IF(Par_TipoReporte = Sec_RefAlternativa) THEN

	DROP TEMPORARY TABLE IF EXISTS TMPREFERENCIASCTE;
		CREATE TEMPORARY TABLE TMPREFERENCIASCTE (
			SolicitudCreditoID	INT(11),      	-- ID de la solicitud de credito
			ClienteID			INT (11),		-- ID del Cliente
            NombreRef1			VARCHAR(150),	-- Nombre Referencia 1
            DomicilioRef1		VARCHAR(150),	-- Domicilio Referencia 1
            TelefonoRef1		VARCHAR(20),	-- Telefono Referencia 1
            TipoRef1ID			INT(11),
            TipoRef1Desc		VARCHAR(50),	-- Relacion Referencia 1
            NombreRef2			VARCHAR(150),	-- Nombre Referencia 2
			DomicilioRef2		VARCHAR(150),	-- Domicilio Referencia 2
            TelefonoRef2		VARCHAR(20),	-- Telefono Referencia 2
            TipoRef2ID			INT(11),
            TipoRef2Desc		VARCHAR(50),	-- Relacion Referencia 2
            NomRefCom1			VARCHAR(50),	-- Nombre Referencia Comercial 1
            TelRefCom1			VARCHAR(20),	-- Telefono Referencia Comercial 1
            NomRefCom2			VARCHAR(50),	-- Nombre Referencia Comercial 2
            TelRefCom2			VARCHAR(20),    -- Telefono Referencia Comercial 2
			INDEX idxCliT(TipoRef1ID),
            INDEX idxCliT2(TipoRef2ID)
		  );

			INSERT INTO TMPREFERENCIASCTE(SolicitudCreditoID,	ClienteID,	NombreRef1,		DomicilioRef1,	TelefonoRef1,
												TipoRef1ID,   	NombreRef2,	DomicilioRef2,	TelefonoRef2,     TipoRef2ID,
												NomRefCom1,		TelRefCom1,	NomRefCom2,		TelRefCom2)

			SELECT Sc.SolicitudCreditoID,	Sc.ClienteID,		C.NombreRef,		C.DomicilioRef,	C.TelefonoRef,
					C.TipoRelacion1,		C.NombreRef2,		C.DomicilioRef2,	C.TelefonoRef2,	C.TipoRelacion2,
					C.NombRefCom,			C.TelRefCom,		C.NombRefCom2,		C.TelRefCom2
			FROM SOLICITUDCREDITO	Sc
			INNER  JOIN CONOCIMIENTOCTE C ON	Sc.ClienteID = C.ClienteID
							WHERE Sc.SolicitudCreditoID = Par_SoliCredID;

         -- Se obtiene el Tipo de Relacion de la Referencia 1
		UPDATE  TMPREFERENCIASCTE Tmp,
				TIPORELACIONES	T
			SET Tmp.TipoRef1Desc	= 	T.Descripcion
			WHERE	Tmp.TipoRef1ID	=	T.TipoRelacionID;

		-- Se obtiene el Tipo de Relacion de la Referencia 2

		UPDATE  TMPREFERENCIASCTE Tmp,
				TIPORELACIONES	T
			SET Tmp.TipoRef2Desc	= 	T.Descripcion
			WHERE	Tmp.TipoRef2ID	=	T.TipoRelacionID;

	SELECT SolicitudCreditoID,	ClienteID,		NombreRef1,		DomicilioRef1,	TelefonoRef1,
			TipoRef1ID,   		TipoRef1Desc,	NombreRef2,		DomicilioRef2,	TelefonoRef2,
            TipoRef2ID,			TipoRef2Desc,	NomRefCom1,		TelRefCom1,		NomRefCom2,
            TelRefCom2
		FROM TMPREFERENCIASCTE;


END IF;

-- Datos SocioEconomicos del Cliente, Egresos Negocio. ALTERNATIVA 19
IF(Par_TipoReporte = Seccion_EgrNegAlt) THEN

 SELECT Sol.ClienteID, Sol.ProspectoID, IF(Sol.ClienteID != Entero_Cero, C.TipoPersona, P.TipoPersona)
	INTO Var_ClienteID, Var_ProspectoID, Cli_TipoPers
        FROM SOLICITUDCREDITO Sol
        INNER JOIN CLIENTES C ON Sol.ClienteID = C.ClienteID
        LEFT OUTER JOIN PROSPECTOS P ON Sol.ProspectoID = P.ProspectoID
        WHERE SolicitudCreditoID = Par_SoliCredID
    LIMIT 1;

    SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);
    SET Var_ProspectoID := IFNULL(Var_ProspectoID, Entero_Cero);
    SET Var_ProducCredID := IFNULL(Var_ProducCredID, Entero_Cero);

    DROP TEMPORARY TABLE IF EXISTS TMPEGRESOSNEGCLIENTE;
		CREATE TEMPORARY TABLE TMPEGRESOSNEGCLIENTE (
			ClienteID			INT(11),      	-- ID del Cliente
            ProspectoID			INT(11),		-- ID del Prospecto
			SolicitudCreditoID	BIGINT(12),		-- ID Solicitud de Credito
            CatNegID			INT(11),		-- ID de Categoria de Egresos Negocio
            DescNegocio			VARCHAR(50),	-- Descripcion de Egresos Negocio
            MontoNegocio		DECIMAL(14,2) 	-- Monto Egresos Negocio
		  );

     IF(Var_ClienteID != Entero_Cero) THEN
		INSERT INTO TMPEGRESOSNEGCLIENTE(ClienteID, 	ProspectoID,	SolicitudCreditoID, CatNegID, DescNegocio,
										MontoNegocio)
			SELECT Var_ClienteID,	Var_ProspectoID,	Par_SoliCredID, Cat.CatSocioEID, Cat.Descripcion,
					Entero_Cero
				FROM CATDATSOCIOE Cat
				WHERE Tipo = Tipo_Egreso
				  AND Cat.Descripcion LIKE '%Negocio%';

		UPDATE  TMPEGRESOSNEGCLIENTE Tmp,
				CLIDATSOCIOE	Dat,
				SOLICITUDCREDITO	Sol
				SET Tmp.MontoNegocio	= 	Dat.Monto
				WHERE	Tmp.CatNegID	=	Dat.CatSocioEID
					AND Dat.ClienteID = Sol.ClienteID
					AND Sol.SolicitudCreditoID = Par_SoliCredID;

		ELSE
			INSERT INTO TMPEGRESOSNEGCLIENTE(ClienteID, 	ProspectoID,	SolicitudCreditoID, CatNegID, DescNegocio,
											MontoNegocio)

				SELECT Var_ClienteID,	Var_ProspectoID,	Par_SoliCredID, Cat.CatSocioEID, Cat.Descripcion,
						Entero_Cero
					FROM CATDATSOCIOE Cat
					WHERE Tipo = Tipo_Egreso
					  AND Cat.Descripcion LIKE '%Negocio%';

			UPDATE  TMPEGRESOSNEGCLIENTE Tmp,
					CLIDATSOCIOE	Dat,
					SOLICITUDCREDITO	Sol
					SET Tmp.MontoNegocio	= 	Dat.Monto
					WHERE	Tmp.CatNegID	=	Dat.CatSocioEID
						AND Dat.ProspectoID = Sol.ProspectoID
						AND Sol.SolicitudCreditoID = Par_SoliCredID;
        END IF;

        SELECT  CONCAT('$ ', FORMAT(SUM(T1.MontoNegocio),2))
			INTO Var_MontoTotalIngNeg
			FROM TMPEGRESOSNEGCLIENTE T1;



	SELECT T1.CatNegID, T1.DescNegocio, CONCAT('$ ', FORMAT(T1.MontoNegocio,2)) AS MontoNegocio,  Var_MontoTotalIngNeg
            FROM TMPEGRESOSNEGCLIENTE T1;
END IF;

-- Datos SocioEconomicos del Cliente, Egresos Familiares. ALTERNATIVA 19
IF(Par_TipoReporte = Seccion_EgrFamAlt) THEN

	SELECT Sol.ClienteID, Sol.ProspectoID, IF(Sol.ClienteID != Entero_Cero, C.TipoPersona, P.TipoPersona)
		INTO Var_ClienteID, Var_ProspectoID, Cli_TipoPers
			FROM SOLICITUDCREDITO Sol
			INNER JOIN CLIENTES C ON Sol.ClienteID = C.ClienteID
			LEFT OUTER JOIN PROSPECTOS P ON Sol.ProspectoID = P.ProspectoID
			WHERE SolicitudCreditoID = Par_SoliCredID
		LIMIT 1;

    SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);
    SET Var_ProspectoID := IFNULL(Var_ProspectoID, Entero_Cero);
    SET Var_ProducCredID := IFNULL(Var_ProducCredID, Entero_Cero);

	DROP TEMPORARY TABLE IF EXISTS TMPEGRESOSFAMCLIENTE;
		CREATE TEMPORARY TABLE TMPEGRESOSFAMCLIENTE (
			ClienteID			INT(11),      	-- ID del Cliente
			ProspectoID			INT(11),		-- ID del Prospecto
			SolicitudCreditoID	BIGINT(12),		-- ID Solicitud de Credito
            CatFamID			INT(11),		-- ID Categoria Egresos Familiar
            DescFam				VARCHAR(50),	-- Descripcion Egresos Familiar
            MontoFam			DECIMAL(14,2)	-- Monto Egresos Familiar
		  );

    IF(Var_ClienteID != Entero_Cero) THEN
		INSERT INTO TMPEGRESOSFAMCLIENTE(ClienteID, 	ProspectoID,	SolicitudCreditoID,	CatFamID, 	DescFam, MontoFam)
			SELECT Var_ClienteID,	Var_ProspectoID,	Par_SoliCredID,	Cat.CatSocioEID, 	Cat.Descripcion, 	Entero_Cero
				FROM CATDATSOCIOE Cat
			WHERE Tipo = Tipo_Egreso
			  AND Cat.Descripcion NOT LIKE '%Negocio%';

		UPDATE  TMPEGRESOSFAMCLIENTE Tmp,
					CLIDATSOCIOE	Dat,
					SOLICITUDCREDITO	Sol
				SET Tmp.MontoFam		= 	Dat.Monto
				WHERE	Tmp.CatFamID	=	Dat.CatSocioEID
				AND Dat.ClienteID = Sol.ClienteID
				AND Sol.SolicitudCreditoID = Par_SoliCredID;
      ELSE
		INSERT INTO TMPEGRESOSFAMCLIENTE(ClienteID, 	ProspectoID,	SolicitudCreditoID,	CatFamID, 	DescFam, MontoFam)
			SELECT Var_ClienteID,	Var_ProspectoID,	Par_SoliCredID,	Cat.CatSocioEID, 	Cat.Descripcion, 	Entero_Cero
			FROM CATDATSOCIOE Cat
			WHERE Tipo = Tipo_Egreso
			  AND Cat.Descripcion NOT LIKE '%Negocio%';

		UPDATE  TMPEGRESOSFAMCLIENTE Tmp,
					CLIDATSOCIOE	Dat,
					SOLICITUDCREDITO	Sol
				SET Tmp.MontoFam		= 	Dat.Monto
				WHERE	Tmp.CatFamID	=	Dat.CatSocioEID
				AND Dat.ProspectoID = Sol.ProspectoID
				AND Sol.SolicitudCreditoID = Par_SoliCredID;
      END IF;
      SELECT  CONCAT('$ ', FORMAT(SUM(T1.MontoFam),2))
			INTO Var_MontoTotalIngFam
      FROM TMPEGRESOSFAMCLIENTE T1;

		SELECT T1.CatFamID, T1.DescFam, CONCAT('$ ', FORMAT(T1.MontoFam,2)) AS MontoFam, Var_MontoTotalIngFam
            FROM TMPEGRESOSFAMCLIENTE T1;
END IF;

-- Seccion de Garantias
IF(Par_TipoReporte = Sec_GarAlternativa) THEN
   SELECT Gar.GarantiaID,
           CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN Cli.NombreCompleto
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN Pro.NombreCompleto
                ELSE Gar.GaranteNombre
            END AS NombreGarante,Doc.Descripcion
        FROM ASIGNAGARANTIAS Asi,
        TIPOSDOCUMENTOS Doc,
             GARANTIAS Gar

        LEFT OUTER JOIN CLIENTES Cli ON Cli.ClienteID = IFNULL(Gar.ClienteID, Entero_Cero)
        LEFT OUTER JOIN PROSPECTOS Pro ON Pro.ProspectoID = IFNULL(Gar.ProspectoID, Entero_Cero)
                                      AND IFNULL(Gar.ClienteID,Entero_Cero) = Entero_Cero
        WHERE Asi.SolicitudCreditoID = Par_SoliCredID
          AND Asi.Estatus = Gar_Autorizado
          AND Asi.GarantiaID = Gar.GarantiaID
          AND Gar.TipoDocumentoID = Doc.TipoDocumentoID;

END IF; -- EndIf Seccion de Garantias

-- Reporte Personalizado Financiera Zafy
IF(Par_TipoReporte = Tipo_Zafy)THEN

  SELECT   pr.NombrePromotor,dc.Descripcion,   IF(so.FechaAutoriza = Fecha_Vacia, Cadena_Vacia,  DATE_FORMAT(so.FechaAutoriza, '%d/%m/%Y')),
                so.NumAmortizacion,
				CASE
					WHEN so.FrecuenciaCap = FrecSemanal   THEN TxtSemanal
					WHEN so.FrecuenciaCap =FrecCatorcenal   THEN TxtCatorcenal
					WHEN so.FrecuenciaCap =FrecQuincenal  THEN TxtQuincenal
					WHEN so.FrecuenciaCap =FrecMensual    THEN TxtMensual
					WHEN so.FrecuenciaCap =FrecPeriodica  THEN TxtPeriodica
					WHEN so.FrecuenciaCap =FrecBimestral  THEN TxtBimestral
					WHEN so.FrecuenciaCap =FrecTrimestral   THEN TxtTrimestral
					WHEN so.FrecuenciaCap =FrecTetramestral THEN TxtTetramestral
					WHEN so.FrecuenciaCap =FrecSemestral  THEN TxtSemestral
					WHEN so.FrecuenciaCap =FrecAnual    THEN TxtAnual
					WHEN so.FrecuenciaCap =FrecLibre    THEN TxtLibres
					ELSE Cadena_Vacia
                END,
				CASE
					WHEN so.FrecuenciaCap = FrecSemanal   THEN TxtSemanales
					WHEN so.FrecuenciaCap =FrecCatorcenal   THEN TxtCatorcenales
					WHEN so.FrecuenciaCap =FrecQuincenal  THEN TxtQuincenales
					WHEN so.FrecuenciaCap =FrecMensual    THEN TxtMensuales
					WHEN so.FrecuenciaCap =FrecPeriodica  THEN TxtPeriodica
                            WHEN so.FrecuenciaCap =FrecBimestral  THEN TxtBimestrales
                            WHEN so.FrecuenciaCap =FrecTrimestral   THEN TxtTrimestrales
                            WHEN so.FrecuenciaCap =FrecTetramestral THEN TxtTetramestrales
                            WHEN so.FrecuenciaCap =FrecSemestral  THEN TxtSemestral
                            WHEN so.FrecuenciaCap =FrecAnual    THEN TxtAnuales
                            WHEN so.FrecuenciaCap =FrecLibre    THEN TxtLibres
                            ELSE Cadena_Vacia
                          END,
			CONCAT('$ ', FORMAT(so.MontoAutorizado ,2)), so.ClienteID,   IF(so.ClienteID > Entero_Cero,cl.NombreCompleto,ps.NombreCompleto),
			IF(so.ClienteID > 0,IF(DATE_ADD(cl.FechaAlta, INTERVAL 1 YEAR) > Fecha_Sis ,CALCDIFFDATE(cl.FechaAlta, Fecha_Sis,2),CALCDIFFDATE(cl.FechaAlta, Fecha_Sis,4)),Fecha_Vacia),
			DATE_FORMAT(cl.FechaNacimiento, '%d/%m/%Y'),
			CALCDIFFDATE(IF(so.ClienteID > Entero_Cero, cl.FechaNacimiento, ps.FechaNacimiento),Fecha_Sis,3),
			IF(so.ClienteID > Entero_Cero,cl.EstadoCivil,ps.EstadoCivil),
			cl.Nacion,
            IF(so.ClienteID > Entero_Cero,cl.Sexo,ps.Sexo),
			IF(so.ClienteID > Entero_Cero,cl.Telefono,ps.Telefono),
			IF(so.ClienteID > Entero_Cero,cl.Correo,Cadena_Vacia),
			IF(so.ClienteID > Entero_Cero,cl.NoEmpleado,ps.NoEmpleado),
			IF(so.ClienteID > Entero_Cero,IF(cl.TipoPersona = PersonaMoral, cl.RFCpm,cl.RFC ),
            IF(cl.TipoPersona = PersonaMoral, ps.RFCpm,ps.RFC )),
			cl.CURP,	cl.TelefonoCelular,	so.SucursalID,	cc.PFuenteIng,	ab.Descripcion,
            cl.ActividadINEGI,	IF(so.ClienteID > Entero_Cero,	IF(cl.TipoPersona = PersonaMoral, cl.RazonSocial, cl.LugardeTrabajo),
																IF(ps.TipoPersona = PersonaMoral, ps.RazonSocial, ps.LugardeTrabajo)),        IF(so.ClienteID > Entero_Cero,
			IF( cl.TipoPersona != PersonaMoral,	CALCDIFFDATE(DATE_SUB(Fecha_Sis, INTERVAL FLOOR(cl.AntiguedadTra * 12) MONTH), Fecha_Sis,4),
										CALCDIFFDATE(CONCAT(IF(DATE_FORMAT(Fecha_Sis,'%yy')>SUBSTRING(cl.RFCpm,4,2), '20', '19' ),
										SUBSTRING(cl.RFCpm,4,2),'-',SUBSTRING(cl.RFCpm,6,2),'-',SUBSTRING(cl.RFCpm,8,2)),Fecha_Sis,4)),
			IF( ps.TipoPersona != PersonaMoral,  CALCDIFFDATE(DATE_SUB(Fecha_Sis, INTERVAL FLOOR(ps.AntiguedadTra * 12) MONTH), Fecha_Sis,4),
										CALCDIFFDATE(CONCAT(IF(DATE_FORMAT(Fecha_Sis,'%yy')>SUBSTRING(ps.RFCpm,4,2), '20', '19' ),
                                        SUBSTRING(ps.RFCpm,4,2),'-',SUBSTRING(ps.RFCpm,6,2),'-',SUBSTRING(ps.RFCpm,8,2)),Fecha_Sis,4))),
			IF(so.ClienteID > Entero_Cero,
			IF(cl.TipoPersona = PersonaMoral,Cadena_Vacia, cl.Puesto),
			IF(ps.TipoPersona = PersonaMoral,Cadena_Vacia, ps.Puesto)),
			IF(so.ClienteID > Entero_Cero,
			IF( cl.TipoPersona = PersonaMoral,
                  CONCAT(IFNULL(cl.Telefono, Cadena_Vacia)),
                  CONCAT(IFNULL(cl.TelTrabajo, Cadena_Vacia))),
			IF( ps.TipoPersona = PersonaMoral,
                  CONCAT(IFNULL(ps.Telefono, Cadena_Vacia)),
                  CONCAT(IFNULL(ps.TelTrabajo, Cadena_Vacia)))),
			IF(so.ClienteID > Entero_Cero,cl.ExtTelefonoTrab,ps.ExtTelefonoTrab),
			IF(so.ClienteID > Entero_Cero,cl.TipoPersona,ps.TipoPersona),
			IF(so.ClienteID > Entero_Cero,
					CONCAT(IFNULL(cl.PrimerNombre,Cadena_Vacia),' ',IFNULL(cl.SegundoNombre,Cadena_Vacia), ' ',IFNULL(cl.TercerNombre,Cadena_Vacia)),
					CONCAT(IFNULL(ps.PrimerNombre,Cadena_Vacia),' ',IFNULL(ps.SegundoNombre,Cadena_Vacia), ' ',IFNULL(ps.TercerNombre,Cadena_Vacia))),
            IF(so.ClienteID > Entero_Cero,cl.ApellidoPaterno,ps.ApellidoPaterno),
			IF(so.ClienteID > Entero_Cero,cl.ApellidoMaterno,ps.ApellidoMaterno),
			IF(so.FechaRegistro = Fecha_Vacia, Cadena_Vacia,  FORMATEAFECHACONTRATO(so.FechaRegistro)),
			IF(so.FechaRegistro = Fecha_Vacia, Cadena_Vacia,  so.FechaRegistro),	ps.ProspectoID
	INTO Var_NombrePromotor,	Var_DestinoDes,		Sol_FechaAut,		Var_NumAmortiza,	Var_Frecuencia,
		Var_Plazo,	     		Var_MontoSolCred,   Var_ClienteID,    	Var_NombreCliente,  Cli_AntigClie,
        Var_CliFechaNac,     	Cli_Edad,     		Var_ClaveEstCiv,  	Var_ClaveNacion,  	Var_CliSexo,
        Var_TelefonoRef,        Var_CliCorreo, 		Var_NoEmpleado,		Var_CliRFC,     	Var_CliCURP,
        Var_CliTelCel,  		Var_SucursalID,     Var_Ocupacion,    	Cli_ActBMX,     	Cli_SectorGral,
        Var_CliLugTra,  		Cli_AntigTra,      	Var_CliPuesto,    	Var_CliTelTra,   	Var_ExtTelTra,
        Cli_TipoPers,   		Var_NombreCli,  	Var_ApePaterno,     Var_ApeMaterno,   	Sol_FechaResult,
        Var_FechaRegistro, 		Var_ProspectoID
  FROM
    SOLICITUDCREDITO so
    LEFT OUTER JOIN PROMOTORES pr       ON so.PromotorID = pr.PromotorID
    LEFT OUTER JOIN DESTINOSCREDITO dc  ON so.DestinoCreID = dc.DestinoCreID
    LEFT OUTER JOIN PROSPECTOS ps     	ON so.ProspectoID = ps.ProspectoID
    LEFT OUTER JOIN CLIENTES cl       	ON so.ClienteID = cl.ClienteID
    LEFT OUTER JOIN CONOCIMIENTOCTE cc  ON so.ClienteID = cc.ClienteID
    LEFT OUTER JOIN ACTIVIDADESBMX ab   ON ab.ActividadBMXID = cl.ActividadBancoMX
  WHERE so.SolicitudCreditoID = Par_SoliCredID
  LIMIT 1;

	IF(Var_ClienteID != Entero_Cero)THEN
		SET Var_NumCliente = Var_ClienteID;
	ELSE
		SET Var_NumCliente = Var_ProspectoID;
	END IF;

	SELECT ProductoNomina, IFNULL(P.RegistroRECA,'') AS RegistroRECA
    INTO Var_EsNomina, Var_RegRECA
	 FROM PRODUCTOSCREDITO P, SOLICITUDCREDITO S
	  WHERE P.ProducCreditoID = ProductoCreditoID
	   AND S.SolicitudCreditoID = Par_SoliCredID;

	SELECT FechaMinistrado INTO Var_FechaMinis
	 FROM CREDITOS
	  WHERE ClienteID = Var_NumCliente
      AND FechaMinistrado <  Var_FechaRegistro
       ORDER BY FechaMinistrado DESC
        LIMIT 1;

	SET Var_DifMeses := (SELECT TIMESTAMPDIFF(MONTH, Var_FechaMinis, Var_FechaRegistro));
    SET Var_DifMeses := IFNULL(Var_DifMeses, Entero_Cero);
    IF(Var_DifMeses<=6 AND Var_DifMeses != Entero_Cero)THEN
		SET Var_Creditos := Var_Si;
        ELSE
        SET Var_Creditos := Var_No;
	END IF;
	SET Var_DescriEstCiv := (SELECT
								CASE Var_ClaveEstCiv
									WHEN Est_Soltero  THEN Des_Soltero
									WHEN Est_CasBieSep  THEN Des_CasBieSep
									WHEN Est_CasBieMan  THEN Des_CasBieMan
									WHEN Est_CasCapitu  THEN Des_CasCapitu
									WHEN Est_Viudo  THEN Des_Viudo
									WHEN Est_Divorciad  THEN Des_Divorciad
									WHEN Est_Seperados  THEN Des_Seperados
									WHEN Est_UnionLibre  THEN Des_UnionLibre
									ELSE Cadena_Vacia
								END );

	IF (Var_ClaveNacion = Nac_Mexicano) THEN
        SET Var_CliNacion   := Des_Mexicano;

    END IF;
	IF (Var_ClaveNacion = Nac_Extranjero) THEN
        SET Var_CliNacion   := Des_Extranjero;
    END IF;
	SET Var_CliNacion   := IFNULL(Var_CliNacion,Cadena_Vacia);

	IF(Var_CliSexo = Gen_Masculino) THEN
		SET Var_CliGenero   := Des_Masculino;
    ELSE
        SET Var_CliGenero   := Des_Femenino;
    END IF;
 # Verifica el tipo de vivienda del cliente, propia,rentada, de familiar u otra
	SELECT CASE WHEN Viv.TipoViviendaID = 1 THEN Propia -- P = Propia
				WHEN Viv.TipoViviendaID = 5 THEN Propia -- P = Propia
				WHEN Viv.TipoViviendaID = 2 THEN Rentada -- R = Rentada
				WHEN Viv.TipoViviendaID = 6 THEN Rentada -- R = Rentada
				WHEN Viv.TipoViviendaID = 4 THEN Familiar -- F = De Familiar
				WHEN Viv.TipoViviendaID = 8 THEN Familiar -- F = De Familiar
				ELSE Otro               -- O = Otro
			END,
		CASE WHEN Viv.TiempoHabitarDom > Entero_Cero THEN Viv.TiempoHabitarDom ELSE Entero_Cero END,  Descripcion
        INTO      Var_TipoVivienda, VarTiempoHabi,    Var_DescVivienda
        FROM SOCIODEMOVIVIEN Viv
        WHERE	Viv.ClienteID = Var_ClienteID AND ProspectoID = Entero_Cero
		OR      Viv.ClienteID = Entero_Cero AND ProspectoID = Var_ProspectoID
         LIMIT 1;

	SET Var_TmpHabiDes := FORMAT((VarTiempoHabi/Meses_Anio),1);
    IF(Var_TipoVivienda = Rentada)THEN
		SET Var_Renta  := (SELECT Dat.Monto	FROM CLIDATSOCIOE Dat
							WHERE IF(Dat.ClienteID > Entero_Cero , Dat.ClienteID = Var_ClienteID,  Dat.ProspectoID = Var_ProspectoID)
							AND Dat.CatSocioEID = 2); -- 2.- Renta Mensual
	END IF;
	SELECT SUM(Cli.Monto) INTO Var_GastosMensuales
	 FROM CLIDATSOCIOE Cli
	  INNER JOIN CATDATSOCIOE Cat ON Cli.CatSocioEID = Cat.CatSocioEID
	   WHERE IF(Cli.ClienteID > Entero_Cero , Cli.ClienteID= Var_ClienteID,  Cli.ProspectoID = Var_ProspectoID)
	    AND  Cat.Tipo= Egresos-- EGRESOS
	     LIMIT 1;

	SELECT CONCAT('$ ', FORMAT(Monto,2))	INTO Var_Ingresos
	 FROM CLIDATSOCIOE Cli
	  WHERE IF(ClienteID > Entero_Cero , ClienteID = Var_ClienteID,  ProspectoID = Var_ProspectoID)
	   AND LinNegID = TipoLinaNeg
	   AND CatSocioEID = 1
	   LIMIT 1;

	SET Var_GastosMensuales	:= IFNULL(CONCAT('$ ', FORMAT(Var_GastosMensuales ,2)),Cadena_Vacia);
	SET Var_Renta  := IFNULL(CONCAT('$ ', FORMAT(Var_Renta ,2)), CONCAT('$ ', FORMAT(Decimal_Cero ,2)));
	SET Var_TipoVivienda   := IFNULL(Var_TipoVivienda,Cadena_Vacia);
	SET Var_DescVivienda   := IFNULL(Var_DescVivienda,Cadena_Vacia);
	SET VarTiempoHabi   := IFNULL(VarTiempoHabi,Entero_Cero);

	SET Var_EstadoNac := (SELECT E.Nombre FROM CLIENTES C
								INNER JOIN ESTADOSREPUB E
                                ON C.EstadoID = E.EstadoID
                                WHERE ClienteID = Var_ClienteID);

	SELECT dc.Calle,   dc.NumeroCasa,  dc.NumInterior, dc.Colonia,   mr.Nombre,
		   er.Nombre,  dc.CP
	INTO Var_CliCalle, Var_CliNumCasa, Var_CliNumInt, Var_CliColoni,  Var_CliColMun,
	   Var_CliEstado,	Var_CliCP
	  FROM DIRECCLIENTE dc
		LEFT OUTER JOIN ESTADOSREPUB er   ON  er.EstadoID = dc.EstadoID
		LEFT OUTER JOIN MUNICIPIOSREPUB mr  ON  mr.MunicipioID  = dc.MunicipioID
											AND mr.EstadoID = dc.EstadoID
		WHERE ClienteID = Var_ClienteID
		AND TipoDireccionID = 1
		AND Oficial = Dir_Oficial LIMIT 1;

	IF(Var_ClienteID = Entero_Cero AND Var_ProspectoID != Entero_Cero)THEN
		SELECT ps.Calle,   ps.NumExterior, ps.NumInterior,  ps.Colonia,   mr.Nombre,
			   er.Nombre,	ps.CP
		INTO Var_CliCalle,	Var_CliNumCasa,	Var_CliNumInt,	Var_CliColoni,	Var_CliColMun,
			 Var_CliEstado,	Var_CliCP
		FROM PROSPECTOS ps
		  LEFT OUTER JOIN ESTADOSREPUB er   ON  er.EstadoID = ps.EstadoID
		  LEFT OUTER JOIN MUNICIPIOSREPUB mr  ON  mr.MunicipioID  = ps.MunicipioID
							AND mr.EstadoID = ps.EstadoID
		WHERE	ps.ProspectoID = Var_ProspectoID
		LIMIT 1;


	SET Var_EstadoNac := (SELECT E.Nombre FROM PROSPECTOS P
								INNER JOIN ESTADOSREPUB E
                                ON P.EstadoID = E.EstadoID
                                WHERE ProspectoID = Var_ProspectoID);
	END IF;

	SET Var_CliNumCasa	:= IFNULL(Var_CliNumCasa,Cadena_Vacia);
	SET Var_CliColoni   := IFNULL(Var_CliColoni,Cadena_Vacia);
	SET Var_CliColMun   := IFNULL(Var_CliColMun,Cadena_Vacia);
	SET Var_CliEstado   := IFNULL(Var_CliEstado,Cadena_Vacia);
	SET Var_CliCalle   	:= IFNULL(Var_CliCalle,Cadena_Vacia);
	SET Var_CliCP   	:= IFNULL(Var_CliCP,Cadena_Vacia);
	SET VarTiempoHabi   := IFNULL(VarTiempoHabi,Entero_Cero);

	IF(Var_ClaveEstCiv = Est_CasBieSep OR Var_ClaveEstCiv = Est_CasBieMan OR Var_ClaveEstCiv = Est_CasCapitu OR Var_ClaveEstCiv = Est_UnionLibre )THEN
		SELECT	Coy.PrimerNombre,	Coy.SegundoNombre,		Coy.TercerNombre,	Coy.ApellidoPaterno,	Coy.ApellidoMaterno,
				Coy.EmpresaLabora,	Coy.TelefonoTrabajo
		INTO	Var_ConyPriNom,		Var_ConySegNom,	Var_ConyTerNom,	Var_ConyApePat,	Var_ConyApeMat,
				Var_ConyNomEmp,		ConyTrabTel

		FROM SOCIODEMOCONYUG Coy
		WHERE (
		  CASE
			WHEN IFNULL(Var_ClienteID, Entero_Cero) != Entero_Cero
			  THEN Coy.ClienteID
			ELSE Coy.ProspectoID
		  END) = (
		  CASE
			  WHEN IFNULL(Var_ClienteID, Entero_Cero) != Entero_Cero THEN Var_ClienteID
				   ELSE Var_ProspectoID
				 END)
		LIMIT 1;

		IF(IFNULL(Var_ClienteConyID, Entero_Cero) != Entero_Cero )THEN
		  SELECT
			Calle,        NumeroCasa,     Colonia
		  INTO
			ConyDirTrabCalle, ConyDirTrabNum,   ConyDirTrabCol
		  FROM
			DIRECCLIENTE
		  WHERE ClienteID = Var_ClienteConyID
		  AND   TipoDireccionID IN (3) LIMIT 1;

		  SELECT
			FLOOR(cl.AntiguedadTra*12), cl.TelTrabajo,  IF(IFNULL(oc.OcupacionID,Entero_Cero) = Entero_Cero,oc.Descripcion,cl.Puesto)
		  INTO
			ConyTrabAntigu,       ConyTrabTel,  ConyTrabPuesto
		  FROM
			CLIENTES cl
			LEFT OUTER JOIN OCUPACIONES oc ON oc.OcupacionID = cl.OcupacionID
		  WHERE
			ClienteID = Var_ClienteConyID
		  LIMIT 1;
		END IF;
	END IF;

	SET Var_ConyPriNom 	:= IFNULL(Var_ConyPriNom,Cadena_Vacia);
	SET Var_ConySegNom 	:= IFNULL(Var_ConySegNom,Cadena_Vacia);
	SET Var_ConyTerNom 	:= IFNULL(Var_ConyTerNom,Cadena_Vacia);
	SET Var_ConyApePat 	:= IFNULL(Var_ConyApePat,Cadena_Vacia);
	SET Var_ConyApeMat 	:= IFNULL(Var_ConyApeMat,Cadena_Vacia);
	SET Var_ConyNomEmp 	:= IFNULL(Var_ConyNomEmp,Cadena_Vacia);
	SET ConyTrabTel		:= IFNULL(ConyTrabTel,Cadena_Vacia);

	SELECT  NombreSucurs,   DirecCompleta,  Est.Nombre,   Mun.Nombre
		INTO  Var_NombreSucur,  Var_DirSucur, Var_EstadoSuc,  Var_SucMun
		FROM  SUCURSALES    Suc,
		  ESTADOSREPUB  Est,
		  MUNICIPIOSREPUB   Mun
		WHERE SucursalID    = Var_SucursalID
		AND Suc.EstadoID  = Est.EstadoID
		AND Suc.EstadoID  =   Mun.EstadoID
		AND Suc.MunicipioID = Mun.MunicipioID
	  LIMIT 1;

	SET Var_Dia   = DAY(Fecha_Sis);
	SET Var_Mes   = CASE  MONTH(Fecha_Sis)
              WHEN  mes1  THEN  TxtEnero
              WHEN  mes2  THEN  TxtFebrero
              WHEN  mes3  THEN  TxtMarzo
              WHEN  mes4  THEN  TxtAbril
              WHEN  mes5  THEN  TxtMayo
              WHEN  mes6  THEN  TxtJunio
              WHEN  mes7  THEN  TxtJulio
              WHEN  mes8  THEN  TxtAgosto
              WHEN  mes9  THEN  TxtSeptiembre
              WHEN  mes10 THEN  TxtOctubre
              WHEN  mes11 THEN  TxtNoviembre
              WHEN  mes12 THEN  TxtDiciembre
            END;

	SET Var_Anio  = YEAR(Fecha_Sis);

	SELECT NomApoderado INTO Cli_RepLegal FROM ESCRITURAPUB WHERE Esc_Tipo = ActaPoderes AND ClienteID = Var_ClienteID LIMIT 1;

	IF Cli_TipoPers = PersonaMoral THEN
		SELECT  Calle,      NumeroCasa,   Colonia,  mr.Nombre,    er.Nombre
		  INTO  Var_CalleTra, Cli_TrabNumExt, Var_ColTra, Var_MuniTra,  Var_EstadoTra
		  FROM
			  DIRECCLIENTE dc
			  LEFT OUTER JOIN MUNICIPIOSREPUB mr
					ON  mr.EstadoID = dc.EstadoID
					AND mr.MunicipioID = dc.MunicipioID
			  LEFT OUTER JOIN ESTADOSREPUB er
					ON  er.EstadoID = dc.EstadoID
			WHERE ClienteID = Var_ClienteID AND Fiscal = SI  LIMIT 1;
	ELSE
		SELECT  Calle,      NumeroCasa,   Colonia,  mr.Nombre,    er.Nombre
		  INTO  Var_CalleTra, Cli_TrabNumExt, Var_ColTra, Var_MuniTra,  Var_EstadoTra
		  FROM
			DIRECCLIENTE dc
			LEFT OUTER JOIN MUNICIPIOSREPUB mr
				  ON  mr.EstadoID = dc.EstadoID
				  AND mr.MunicipioID = dc.MunicipioID
			LEFT OUTER JOIN ESTADOSREPUB er
				  ON  er.EstadoID = dc.EstadoID
		  WHERE ClienteID = Var_ClienteID
			AND TipoDireccionID = 3 LIMIT 1;
	END IF;
	SET Var_CalleTra := IFNULL(Var_CalleTra,Cadena_Vacia);
	SET Cli_TrabNumExt := IFNULL(Cli_TrabNumExt,Cadena_Vacia);
	SET Var_ColTra := IFNULL(Var_ColTra,Cadena_Vacia);
	SET Var_MuniTra := IFNULL(Var_MuniTra,Cadena_Vacia);
	SET Var_EstadoTra := IFNULL(Var_EstadoTra,Cadena_Vacia);

	SELECT  tv.Descripcion, sd.ValorVivienda
	  INTO  SDV_TipoDom,  SDV_ValorViv
		FROM    SOCIODEMOVIVIEN sd
		  LEFT OUTER JOIN TIPOVIVIENDA tv ON tv.TipoViviendaID = sd.TipoViviendaID
			WHERE IF(sd.ClienteID > Entero_Cero, sd.ClienteID = Var_ClienteID,  sd.ProspectoID = Var_ProspectoID)
			LIMIT 1;

	SET SDV_ValorViv := IFNULL(SDV_ValorViv, Entero_Cero);

	IF(Var_ConyAntAnio != Cadena_Vacia) THEN
	  SET Var_ConyAntTra  := CONCAT(CONVERT(Var_ConyAntAnio, CHAR), " AÑO(S) ");

	  IF(Var_ConyAntMes != Entero_Cero) THEN
		SET Var_ConyAntTra  := CONCAT(Var_ConyAntTra, " Y ", CONVERT(Var_ConyAntMes, CHAR), " MES(ES)");
	  END IF;
	ELSE
	  IF(Var_ConyAntMes != Entero_Cero) THEN
		SET Var_ConyAntTra  := CONCAT(CONVERT(Var_ConyAntAnio, CHAR), " MES(ES)");
	  END IF;
	END IF;

  -- Total de Dependientes Economicos y Cuantos son Hijos

	IF(Var_ClienteID != Entero_Cero)THEN
		SET Es_Cliente = Var_SI;
	ELSE
		SET Es_Cliente = Var_NO;
	END IF;
    SELECT SUM(1), SUM(CASE WHEN Dep.TipoRelacionID = Rel_Hijo THEN 1
                        ELSE Entero_Cero
                    END)
                    INTO Var_NumDepend, Var_NumHijos
            FROM SOCIODEMODEPEND Dep
            WHERE (CASE WHEN IFNULL(Es_Cliente,Cadena_Vacia) = Var_SI THEN Dep.ClienteID = Var_ClienteID
          ELSE Dep.ProspectoID = Var_ProspectoID
        END)
    LIMIT 1;

	SELECT SUM(1), SUM(CASE WHEN Dep.TipoRelacionID = Rel_Hijo THEN 1
                        ELSE Entero_Cero
                    END)
                    INTO Var_NumDepend, Var_NumHijos
            FROM SOCIODEMODEPEND Dep
            WHERE (CASE WHEN IFNULL(Es_Cliente,Cadena_Vacia) = Var_SI THEN Dep.ClienteID = Var_ClienteID
          ELSE Dep.ProspectoID = Var_ProspectoID
        END)
      LIMIT 1;

	  -- Cliente - Prospecto
    SELECT Esc.Descripcion INTO Var_EscoCli
        FROM SOCIODEMOGRAL Soc,
             CATGRADOESCOLAR Esc
    WHERE (CASE WHEN IFNULL(Es_Cliente,Cadena_Vacia) = Var_SI THEN Soc.ClienteID = Var_ClienteID
            ELSE Soc.ProspectoID = Var_ProspectoID
          END)
          AND Soc.GradoEscolarID = Esc.GradoEscolarID;

    SET Var_EscoCli := IFNULL(Var_EscoCli, Cadena_Vacia);

SELECT	Var_NombrePromotor,	Var_ClienteID,		Var_ProspectoID,	Var_DestinoDes,		Sol_FechaAut,
		Var_NumAmortiza,	Var_Frecuencia, 	Var_Plazo,			Var_MontoSolCred,	Var_NombreCliente,
        Var_NombreCli,      Var_ApePaterno,     Var_ApeMaterno,   	Var_CliSexo,		Cli_RepLegal,
        Cli_AntigClie,		Var_CliFechaNac,	Cli_Edad,			Var_DescriEstCiv, 	Var_CliNacion,
        Var_CliCorreo, 		Var_NoEmpleado,		Var_EstadoNac,		Var_CliGenero,  	Var_CliCalle,
        Var_CliNumCasa,		Var_CliNumInt,		Var_CliColoni,		Var_CliColMun,		Var_CliEstado,
        Var_CliCP,	        Var_TelefonoRef,	Var_CliRFC,     	Var_CliCURP,    	Var_CliTelCel,
        Var_NumDepend,      Var_NumHijos,		Var_ConyPriNom,   	Var_ConySegNom,   	Var_ConyTerNom,
        Var_ConyApePat,		Var_ConyApeMat,		Var_ConyNomEmp,     ConyTrabTel,	    Var_Ocupacion,
        Cli_ActBMX,        	Var_EscoCli,        Cli_SectorGral,		Var_CliLugTra,    	Cli_AntigTra,
 		Var_CliPuesto,		Var_CliTelTra,      Var_ExtTelTra,		Var_TmpHabiDes,    	Var_TipoVivienda,
        VarTiempoHabi,      Var_DescVivienda,   Var_Renta, 			Var_GastosMensuales,Var_Ingresos,
        Var_SucursalID,     Var_EstadoSuc,		Var_SucMun,      	Var_NombreSucur,	Sol_FechaResult,
        Var_Creditos, 		Var_EsNomina,		Var_RegRECA;

END IF;

-- Seccion de Referencias Zafy
IF(Par_TipoReporte = ReferenciasZafy) THEN

         -- TABLA TEMPORAL PARA ALMACENAR LAS REFERENCIAS DE LA SOLICITUD DE CREDITO
	DROP TABLE IF EXISTS TMPREFERENCIAS;
		CREATE TEMPORARY TABLE TMPREFERENCIAS(
			Num					INT(11),
			SolicitudCreditoID	BIGINT(12),
			NombreReferencia	VARCHAR(250),
            Descripcion			VARCHAR(50),
            Telefono			VARCHAR(20),
            Direccion			VARCHAR(500)
		);


		INSERT INTO TMPREFERENCIAS (Num,	SolicitudCreditoID,	NombreReferencia,	Descripcion,	Telefono,
									Direccion)


		SELECT @s:=@s+1 AS Num,	B.*
			FROM (SELECT @s:= Entero_Cero) AS s,
				(SELECT Par_SoliCredID, R.NombreCompleto, T.Descripcion, R.Telefono,
					R.DireccionCompleta
					 FROM REFERENCIACLIENTE R
					  INNER JOIN TIPORELACIONES T
					   ON R.TipoRelacionID = T.TipoRelacionID
						AND SolicitudCreditoID = Par_SoliCredID
						 ORDER BY T.EsParentesco DESC, R.TipoRelacionID DESC
						  LIMIT 4) B;

        -- Referencia Familiar 1
		SELECT NombreReferencia, Descripcion, Telefono, Direccion
		 INTO Var_NomRefFam1,		Var_TipoRelFam1,	Var_TelRefFam1,	Var_DirRefFam1
          FROM TMPREFERENCIAS
           WHERE Num = 1;

		 -- Referencia Familiar 2
		SELECT NombreReferencia, Descripcion, Telefono, Direccion
		INTO Var_NomRefFam2,		Var_TipoRelFam2,	Var_TelRefFam2,	Var_DirRefFam2
		 FROM TMPREFERENCIAS
		   WHERE Num = 2;

		-- Referencia Personal 1
		SELECT NombreReferencia, Descripcion, Telefono, Direccion
		 INTO Var_NomRefPersonal,		Var_TipoRelPer,	Var_TelRefPer,	Var_DirRefPer
		  FROM TMPREFERENCIAS
		   WHERE Num = 3;

		-- Referencia Laboral 1
		SELECT NombreReferencia,	Descripcion,	Telefono,		Direccion
		 INTO Var_NomRefLaboral,	Var_TipoRelLab,	Var_TelRefLab,	Var_DirRefLab
		  FROM TMPREFERENCIAS
		   WHERE Num = 4;

		SELECT	Var_NomRefFam1,		Var_TipoRelFam1,	Var_TelRefFam1,		Var_DirRefFam1,		Var_NomRefFam2,
				Var_TipoRelFam2,	Var_TelRefFam2,		Var_DirRefFam2,		Var_NomRefPersonal,	Var_TipoRelPer,
                Var_TelRefPer,		Var_DirRefPer,		Var_NomRefLaboral,	Var_TipoRelLab,		Var_TelRefLab,
                Var_DirRefLab;

	 # ===================   SE ELIMINAN LOS DATOS TEMPORALES ====================
		  DROP TEMPORARY TABLE IF EXISTS TMPREFERENCIAS;
END IF; -- EndIf Seccion de Referencias

IF(Par_TipoReporte = Seccion_GeneralMoral) THEN

    SELECT  Sol.SolicitudCreditoID, Sol.ClienteID,      Sol.ProspectoID,    Sol.SucursalID,     Sol.ProductoCreditoID,
            Sol.MontoSolici,    Sol.Proyecto,       Sol.TasaFija,       Pro.Descripcion,
            Crp.Descripcion,    Mon.Descripcion,    Des.Descripcion,
            CASE WHEN IFNULL(Sol.PorcGarLiq, Entero_Cero) != Entero_Cero THEN
                    CONCAT("LIQUIDA ", FORMAT(Sol.PorcGarLiq,2), "%")
                 WHEN IFNULL(Pro.RequiereGarantia, Cadena_Vacia) = Si_Requiere THEN
                    "MOBILIARIA, INMOBILIARIA"
            END,
            CASE Sol.FrecuenciaCap
                WHEN FrecSemanal    THEN UPPER(TxtSemanal)
                WHEN FrecCatorcenal   THEN UPPER(TxtCatorcenal)
                WHEN FrecQuincenal    THEN UPPER(TxtQuincenal)
                WHEN FrecMensual    THEN UPPER(TxtMensual)
                WHEN FrecPeriodica    THEN UPPER(TxtPeriodica)
                WHEN FrecBimestral    THEN UPPER(TxtBimestral)
                WHEN FrecTrimestral   THEN UPPER(TxtTrimestral)
                WHEN FrecTetramestral   THEN UPPER(TxtTetramestral)
                WHEN FrecSemestral    THEN UPPER(TxtSemestral)
                WHEN FrecAnual      THEN UPPER(TxtAnual)
        WHEN FrecUnico      THEN UPPER(TxtUnico)
            END


            INTO
            Var_SolCreditoID,   Var_ClienteID,      Var_ProspectoID,    Var_SucursalID, Var_ProducCredID,
            Var_MontoSolici,    Var_Finalidad,      Var_Tasa,       Var_DesProducto,
            Var_Plazo,          Var_Moneda,         Var_Destino,    Var_TipoGarant,
            Var_Frecuencia
        FROM SOLICITUDCREDITO Sol,
             MONEDAS Mon,
             PRODUCTOSCREDITO Pro,
             CREDITOSPLAZOS Crp,
             DESTINOSCREDITO Des
        WHERE Sol.SolicitudCreditoID = Par_SoliCredID
          AND Sol.MonedaID = Mon.MonedaId
          AND Sol.PlazoID = Crp.PlazoID
          AND Sol.DestinoCreID = Des.DestinoCreID
          AND Sol.ProductoCreditoID = Pro.ProducCreditoID
    LIMIT 1;

  SET Var_SolCreditoID   := IFNULL(Var_SolCreditoID, Entero_Cero);
    SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);
    SET Var_ProspectoID := IFNULL(Var_ProspectoID, Entero_Cero);
    SET Var_ProducCredID := IFNULL(Var_ProducCredID, Entero_Cero);

    
	SET Var_Numcliente  := Var_ClienteID;

	-- Generales del Cliente Moral		
	SELECT  Cli.RazonSocial, Cli.RFCpm, Cli.FEA, Cli.Nacion, Ccte.Giro, Ccte.PFuenteIng, Cli.Telefono, Cli.Correo, PA.Nombre
		INTO Var_RazonSocial, Var_CliRFC, Var_FEA,Var_ClaveNacion, Var_giroCom, Var_FuenteIng, Var_CliTelPart, Var_CliCorreo, Var_PaisResidencia 
		FROM CLIENTES Cli 	
		INNER JOIN PAISES PA ON PA.PaisID = Cli.PaisResidencia
		LEFT OUTER JOIN CONOCIMIENTOCTE Ccte ON Ccte.ClienteID = Cli.ClienteID
		WHERE Cli.ClienteID = Var_ClienteID LIMIT 1;
		
	-- Nombre Promotor
	SELECT  P.NombrePromotor INTO Var_NombrePromotor
	FROM
	SOLICITUDCREDITO  C,
	PROMOTORES  P
	WHERE C.SolicitudCreditoID= Par_SoliCredID
	AND C.PromotorID=P.PromotorID LIMIT 1;
	
	-- Direccion del Cliente
	SELECT Dir.Calle, Dir.NumInterior, Dir.Piso, Dir.Lote, Dir.Manzana,
			Col.Asentamiento, Dir.NumeroCasa, Mun.Nombre,    Dir.PrimeraEntreCalle,
			Dir.SegundaEntreCalle, Dir.CP, Dir.Descripcion
	INTO Var_CliCalle, Var_CliNumInt, Var_CliPiso, Var_CliLote, Var_CliManzana,
		Var_CliColoni, Var_CliNumCasa, Var_CliMunici, Var_1aEntreCalle,
		Var_2aEntreCalle, Var_CodPostal, Var_DescripDir
		FROM DIRECCLIENTE Dir,
			COLONIASREPUB Col,
			MUNICIPIOSREPUB Mun
		WHERE ClienteID = Var_ClienteID
			AND Oficial = Dir_Oficial
			AND Dir.EstadoID = Col.EstadoID
			AND Dir.MunicipioID = Col.MunicipioID
			AND Dir.ColoniaID = Col.ColoniaID
			AND Mun.EstadoID  = Col.EstadoID
			AND Mun.MunicipioID = Col.MunicipioID
			LIMIT 1;


	-- Numero de Creditos
	SELECT SUM(CASE WHEN Cre.ProductoCreditoID =  Var_ProducCredID AND
							(Cre.Estatus = Est_Vigente OR Cre.Estatus = Est_Pagado) THEN 1
					ELSE Entero_Cero
				END),
			SUM(CASE WHEN Cre.Estatus = Est_Pagado THEN 1
					ELSE Entero_Cero
				END)
			INTO Var_NumCreditos, Var_NumCreTra
		FROM CREDITOS Cre
	WHERE Cre.ClienteID         = Var_ClienteID
		LIMIT 1;

	SET Var_NumCreTra   := IFNULL(Var_NumCreTra, Entero_Cero);

	-- Se le suma un uno, por si el cliente no tiene creditos o experiencia con la institucion
	-- Entonces decimos que es su 1er ciclo el credito que esta Solicitando
	SET Var_NumCreditos := IFNULL(Var_NumCreditos, Entero_Cero) + 1;

	-- Monto del Ultimo Credito Pagado
	IF(Var_NumCreTra != Entero_Cero) THEN
		SELECT MontoCredito INTO Var_MonUltCred
			FROM CREDITOS Cre
		WHERE ClienteID = Var_ClienteID
		AND Cre.Estatus = Est_Pagado
			ORDER BY FechaInicio DESC
			LIMIT 1;
	END IF;

	SET Var_MonUltCred  := IFNULL(Var_MonUltCred, Entero_Cero);

    -- Ciclo Base del Cliente-Prospecto
    SELECT  CicloBase INTO Var_CicBaseCli
        FROM CICLOBASECLIPRO Cib
    WHERE (CASE WHEN IFNULL(Es_Cliente,Cadena_Vacia) = Var_SI THEN Cib.ClienteID = Var_ClienteID
          ELSE Cib.ProspectoID = Var_ProspectoID
        END)
    AND Cib.ProductoCreditoID = Var_ProducCredID LIMIT 1;


    IF (Var_ClaveNacion = Nac_Mexicano) THEN
        SET Var_CliNacion   := Des_Mexicano;
    ELSE
        SET Var_CliNacion   := Des_Extranjero;
    END IF;

  IF (Var_ClaveNacion = Nac_Extranjero) THEN
        SET Var_CliNacion   := Des_Extranjero;
    ELSE
        SET Var_CliNacion   := Des_Mexicano;
    END IF;

   

    -- Cliente - Prospecto
    SELECT Esc.Descripcion INTO Var_EscoCli
        FROM SOCIODEMOGRAL Soc,
             CATGRADOESCOLAR Esc
    WHERE (CASE WHEN IFNULL(Es_Cliente,Cadena_Vacia) = Var_SI THEN Soc.ClienteID = Var_ClienteID
            ELSE Soc.ProspectoID = Var_ProspectoID
          END)
          AND Soc.GradoEscolarID = Esc.GradoEscolarID LIMIT 1;

    SET Var_EscoCli := IFNULL(Var_EscoCli, Cadena_Vacia);

    SET Var_CliCalle      := IFNULL(Var_CliCalle, Cadena_Vacia);
    SET Var_CliNumInt     := IFNULL(Var_CliNumInt, Cadena_Vacia);
    SET Var_CliPiso       := IFNULL(Var_CliPiso, Cadena_Vacia);
    SET Var_CliLote       := IFNULL(Var_CliLote, Cadena_Vacia);
    SET Var_CliManzana    := IFNULL(Var_CliManzana, Cadena_Vacia);
    SET Var_CliColoni     := IFNULL(Var_CliColoni, Cadena_Vacia);
    SET Var_CliNumCasa    := IFNULL(Var_CliNumCasa, Cadena_Vacia);
    SET Var_CliMunici     := IFNULL(Var_CliMunici, Cadena_Vacia);
    SET Var_1aEntreCalle  := IFNULL(Var_1aEntreCalle, Cadena_Vacia);
    SET Var_2aEntreCalle  := IFNULL(Var_2aEntreCalle, Cadena_Vacia);
    SET Var_CliTelTra     := IFNULL(Var_CliTelTra, Cadena_Vacia);
    SET Var_CliTelPart    := IFNULL(Var_CliTelPart, Cadena_Vacia);
    SET Var_CliLugTra     := IFNULL(Var_CliLugTra, Cadena_Vacia);
    SET Var_CliPuesto     := IFNULL(Var_CliPuesto, Cadena_Vacia);
    SET Var_CliAntTra     := IFNULL(Var_CliAntTra, Entero_Cero);

    SET Var_CliCalNum   := Var_CliCalle;

    IF(Var_CliNumCasa != Cadena_Vacia) THEN
        SET Var_CliCalNum   := CONCAT(Var_CliCalNum, ' No. ', Var_CliNumCasa);
    END IF;

    IF(Var_CliNumInt != Cadena_Vacia) THEN
        SET Var_CliCalNum   := CONCAT(Var_CliCalNum, ' INTERIOR ', Var_CliNumInt);
    END IF;

    IF(Var_CliLote != Cadena_Vacia) THEN
        SET Var_CliCalNum   := CONCAT(Var_CliCalNum, ' LOTE ', Var_CliLote);
    END IF;

    IF(Var_CliManzana != Cadena_Vacia) THEN
        SET Var_CliCalNum   := CONCAT(Var_CliCalNum, ' MANZANA ', Var_CliManzana);
    END IF;

    IF(Var_CliPiso != Cadena_Vacia) THEN
        SET Var_CliCalNum   := CONCAT(Var_CliCalNum, ' PISO ', Var_CliPiso);
    END IF;

    SET Var_CliColMun   := CONCAT(Var_CliColoni, ',', Var_CliMunici);


    SELECT NombreSucurs INTO Var_NombreSucurs
        FROM SUCURSALES
        WHERE SucursalID = Var_SucursalID
  LIMIT 1;


	-- ===================================
	SELECT I.Nombre, Par.FechaSistema
		INTO Var_NombreInstitucion, Var_Fecha
		FROM PARAMETROSSIS Par
		INNER JOIN INSTITUCIONES I ON Par.InstitucionID = I.InstitucionID;

	SELECT CONCAT(Mun.Nombre,', ',Est.Nombre),Suc.DirecCompleta
	INTO Var_DirecSucursal,Var_DirecCompletSuc
	FROM SOLICITUDCREDITO Sol
	INNER JOIN SUCURSALES Suc ON  Sol.SucursalID = Suc.SucursalID
	INNER JOIN ESTADOSREPUB Est ON Suc.EstadoID = Est.EstadoID
	INNER JOIN MUNICIPIOSREPUB Mun ON Suc.EstadoID = Mun.EstadoID
										AND Suc.MunicipioID= Mun.MunicipioID
	WHERE Sol.SolicitudCreditoID = Var_SolCreditoID;
	-- ==================================

	-- SELECT ClienteID INTO Var_ClienteID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SoliCredID;

	SELECT 	CONCAT( DIR.PrimerNombre,' ',DIR.SegundoNombre,' ', IFNULL(DIR.TercerNombre,'')) AS PrimerNombre, 		
			DIR.ApellidoPaterno, 	DIR.ApellidoMaterno,	DIR.FechaNac, 			CASE WHEN DIR.Sexo = 'M' THEN 'Masculino' WHEN DIR.Sexo = 'F' THEN 'Femenimo' END AS Sexo, 	
			DIR.CURP, 				DIR.RFC, 				DIR.FEA, 				CASE WHEN DIR.EstadoCivil = 'S' THEN  'Soltero' WHEN DIR.EstadoCivil = 'C' THEN  'Casado' WHEN DIR.EstadoCivil = 'V' THEN 'Viudo'  WHEN DIR.EstadoCivil = 'D' THEN 'Divorciado'WHEN DIR.EstadoCivil = 'S'THEN 'Separado' WHEN DIR.EstadoCivil ='U' THEN 'Union Libre' END AS EstadoCivil,
			DIR.PuestoA,	        OCU.Descripcion,		EST.Nombre AS Estado,	MUN.Nombre AS Munic,		P.Nombre AS Pais,	
			DIR.CodigoPostal,		DIR.Domicilio,			DIR.TelefonoCasa,		DIR.TelefonoCelular,		YEAR(CURDATE())-YEAR(DIR.FechaNac) AS Edad
	INTO 	Var_DirPrimerNom,		Var_DirApellioPat,		Var_DirApellidoMat,		Var_DirFechaNac,			Var_Dir_Sexo,
	   		Var_DirCurp,			Var_DirRfc,				Var_DirFea,				Var_Dir_EstCivil,			Var_Dir_Puesto,
	   		Var_DirOcupa,			Var_DirEstado,			Var_DirMunic,			Var_DirPais,				Var_DirCP,
	   		Var_DirDomicilio,		Var_DirTelCas,			Var_DirTelCel,			Var_DirEdad
		FROM DIRECTIVOS DIR 
	    LEFT JOIN OCUPACIONES OCU ON OCU.OcupacionID = DIR.OcupacionID
	    LEFT JOIN ESTADOSREPUB EST ON EST.EstadoID = DIR.EstadoID
	    LEFT JOIN MUNICIPIOSREPUB MUN ON MUN.MunicipioID = DIR.MunicipioID
	    LEFT JOIN PAISES P ON P.PaisID = DIR.PaisResidencia
	    WHERE DIR.EsApoderado = 'S' AND DIR.ClienteID=Var_ClienteID LIMIT 1;

    SELECT  Var_SolCreditoID,		Var_NombreSucurs,   	Var_Numcliente,     	Var_NombreCli,      	Var_FecNacCli,      
			Var_PaisNac,        	Var_EstadoNac,      	Var_CliNacion,      	Var_CliRFC,         	Var_EscoCli,
			Var_CliCalNum,      	Var_CliColMun,      	Var_1aEntreCalle,   	Var_2aEntreCalle,   	Var_CliTelTra,
			Var_CliTelPart,   		Var_MontoSolici,    	Var_Finalidad,      	Var_Tasa,				Var_DesProducto,
			Var_Plazo,          	Var_Moneda,         	Var_Destino,        	Var_Frecuencia,			Var_TipoGarant,
			Var_ClienteCiclo,   	Var_NumCreTra,      	Var_MonUltCred,     	Var_NombrePromotor,		Var_NombreInstitucion,
			Var_DirecCompletSuc,	Var_DirecSucursal,		Var_CodPostal,			Var_DescripDir,			Var_Fecha,
			Var_RazonSocial,		Var_FEA,				Var_giroCom,			Var_CliTelPart, 		Var_CliCorreo, 
			Var_PaisResidencia,		Var_FuenteIng,			Var_CliCalle, 			Var_CliNumInt, 			Var_CliPiso, 
			Var_CliLote, 			Var_CliManzana,			Var_CliColoni, 			Var_CliNumCasa, 		Var_CliMunici,
			Var_DirPrimerNom,		Var_DirApellioPat,		Var_DirApellidoMat,		Var_DirFechaNac,		Var_Dir_Sexo,
	   		Var_DirCurp,			Var_DirRfc,				Var_DirFea,				Var_Dir_EstCivil,		Var_Dir_Puesto,
	   		Var_DirOcupa,			Var_DirEstado,			Var_DirMunic,			Var_DirPais,			Var_DirCP,
	   		Var_DirDomicilio,		Var_DirTelCas,			Var_DirTelCel,			Var_DirEdad;

END IF; -- EndIF de Tipo de Reporte General o Datos del Cte y Solicitud

-- Seccion de Avales Asefimex
IF(Par_TipoReporte = Seccion_AvalesAsefimex) THEN
      DROP TEMPORARY TABLE IF EXISTS TMPAVALESCREDITO;
      CREATE TEMPORARY TABLE TMPAVALESCREDITO (
        TmpID               INT(11) AUTO_INCREMENT,
        SolicitudCreditoID  INT(11),      # ID de la solicitud de credito
        ClienteIDAval       INT(11),      # ID del cliente que es aval
        ProspectoIDAval     INT(11),      # ID del prospecto que es aval
        AvalID              INT(11),      # ID del aval
        NombreAval          VARCHAR(300),   # Nombre Completo del aval
        Nombres             VARCHAR(150),   # Nombres de Aval
        ApellidoPaterno     VARCHAR(50),    # Apellido Paterno
        ApellidoMaterno     VARCHAR(50),    # Apellido Materno
        RFC                 VARCHAR(13),    # RFC
        Sexo                VARCHAR(10),    # Sexo
        FechaNacimiento     DATE,       # Fecha de nacimiento del aval
        Telefono            VARCHAR(20),    # Telefono del aval
        EstadoCivil         VARCHAR(50),    # Descripcion del estado civil del aval
        Ocupacion           TEXT,       # Ocupacion del Aval
        PaisEstado          VARCHAR(200),   # Pais y Estado de nacimiento del aval
        Calle               VARCHAR(200),   # Calle de la direccion del aval
        Colonia             VARCHAR(200),   # Colonia de la direccion del aval
        Municipio           VARCHAR(100),   # Municipio de la direccion del aval
        Estado              VARCHAR(100),   # Estado de la direccion del aval
        CP                  VARCHAR(10),    # Codigo postal de la direccion del cliente
        LugarTrabajo        VARCHAR(100),   # Lugar de trabajo del aval
        TelTrabajo          VARCHAR(20),    # Telefono del trabajo del aval
        DirTrabajo          VARCHAR(500),   # La direccion completa del lugar de trabajo del aval
        AntTrabajo          VARCHAR(40),    # Antiguedad en su trabajo del aval
        PRIMARY KEY (TmpID),
        INDEX idxCliC(ClienteIDAval),
        INDEX idxCliA(AvalID),
        INDEX idxCliP(ProspectoIDAval)
      );


      INSERT INTO TMPAVALESCREDITO(SolicitudCreditoID,  ClienteIDAval,                ProspectoIDAval,            AvalID,                   NombreAval,
                                Nombres,                ApellidoPaterno,              ApellidoMaterno,              RFC,                    Sexo,
                                PaisEstado)
          SELECT         Par_SoliCredID,    IFNULL(AvaSol.ClienteID,Entero_Cero),   IFNULL(AvaSol.ProspectoID,Entero_Cero), IFNULL(AvaSol.AvalID,Entero_Cero),      Ava.NombreCompleto,
                                CONCAT(Ava.PrimerNombre,' ', Ava.SegundoNombre, ' ', Ava.TercerNombre), Ava.ApellidoPaterno, Ava.ApellidoMaterno,   Ava.RFC,
                                CASE WHEN Ava.Sexo = Var_M THEN Var_SexoM WHEN Ava.Sexo = Var_F THEN Var_SexoF END,   
                                Pa.Nombre
          FROM AVALESPORSOLICI AvaSol
            LEFT OUTER JOIN AVALES  Ava ON AvaSol.AvalID = Ava.AvalID
            LEFT JOIN PAISES Pa     ON Pa.PaisID = Ava.LugarNacimiento
          WHERE AvaSol.SolicitudCreditoID  = Par_SoliCredID
            AND AvaSol.Estatus IN (Ava_Asignado,Ava_Autorizado);


      # ===============   SE OBTIENEN DATOS CUANDO EL AVAL ES CLIENTE  ================
      UPDATE TMPAVALESCREDITO Tmp,  CLIENTES Cli
                      LEFT OUTER JOIN OCUPACIONES Ocu ON Cli.OcupacionID = Ocu.OcupacionID
        SET Tmp.NombreAval    = Cli.NombreCompleto,
            Tmp.Nombres         = CONCAT(Cli.PrimerNombre,' ',Cli.SegundoNombre,' ',Cli.TercerNombre),
            Tmp.ApellidoPaterno = Cli.ApellidoPaterno,
            Tmp.ApellidoMaterno = Cli.ApellidoMaterno,
            Tmp.RFC             = Cli.RFC,
            Tmp.Sexo            = CASE WHEN Cli.Sexo = Var_M THEN Var_SexoM WHEN Cli.Sexo = Var_F THEN Var_SexoF END,
          Tmp.FechaNacimiento =   Cli.FechaNacimiento,
          Tmp.Telefono    =   Cli.Telefono,
          Tmp.Ocupacion   = Ocu.Descripcion,
          Tmp.LugarTrabajo  =   Cli.LugardeTrabajo,
          Tmp.TelTrabajo    =   Cli.TelTrabajo,
          Tmp.AntTrabajo    =   CONCAT(FORMAT( CONCAT(
                              CASE WHEN Var_CalcAntiguedad = Var_SI THEN  CASE WHEN IFNULL(Cli.FechaIniTrabajo,Fecha_Vacia) = Fecha_Vacia
                                  THEN Entero_Cero
                                 ELSE
                                  FLOOR(DATEDIFF(Fecha_Sis,Cli.FechaIniTrabajo) / 365)
                              END
                               ELSE Cli.AntiguedadTra
                              END, '.',
                              CASE WHEN Var_CalcAntiguedad = Var_SI THEN  CASE WHEN IFNULL(Cli.FechaIniTrabajo,Fecha_Vacia) = Fecha_Vacia
                                                      THEN Entero_Cero
                                                     ELSE
                                                      FLOOR((DATEDIFF(Fecha_Sis,Cli.FechaIniTrabajo) - (FLOOR(DATEDIFF(Fecha_Sis,Cli.FechaIniTrabajo) / 365) * 365)) / 30)
                                                  END
                               ELSE Entero_Cero
                              END)
                      , 1), " Años"),
          Tmp.EstadoCivil   =   CASE Cli.EstadoCivil
                        WHEN Est_Soltero    THEN Des_Soltero
                        WHEN Est_CasBieSep  THEN Des_CasBieSep
                        WHEN Est_CasBieMan  THEN Des_CasBieMan
                        WHEN Est_CasCapitu  THEN Des_CasCapitu
                        WHEN Est_Viudo    THEN Des_Viudo
                        WHEN Est_Divorciad  THEN Des_Divorciad
                        WHEN Est_Seperados  THEN Des_Seperados
                        WHEN Est_UnionLibre THEN Des_UnionLibre
                        ELSE Cadena_Vacia
                      END
        WHERE Tmp.ClienteIDAval = Cli.ClienteID
          AND Tmp.ClienteIDAval > Entero_Cero;




      UPDATE  TMPAVALESCREDITO Tmp LEFT OUTER JOIN DIRECCLIENTE Dir ON Tmp.ClienteIDAval = Dir.ClienteID
                     LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON Dir.EstadoID = Mun.EstadoID AND Dir.MunicipioID = Mun.MunicipioID
                     LEFT OUTER JOIN ESTADOSREPUB Est ON Dir.EstadoID = Est.EstadoID
        SET Tmp.Colonia   = Dir.Colonia,
          Tmp.Municipio =   Mun.Nombre,
          Tmp.Estado    =   Est.Nombre,
          Tmp.CP      =   Dir.CP,
          Tmp.Calle   =   CONCAT(IFNULL(Dir.Calle,Cadena_Vacia),
                    CASE WHEN IFNULL(Dir.NumeroCasa, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", No. ", Dir.NumeroCasa) ELSE Cadena_Vacia END,
                    CASE WHEN IFNULL(Dir.NumInterior, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", INTERIOR ", Dir.NumInterior) ELSE Cadena_Vacia END,
                    CASE WHEN IFNULL(Dir.Lote, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", LOTE ", Dir.Lote) ELSE Cadena_Vacia END,
                    CASE WHEN IFNULL(Dir.Manzana, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", MANZANA ", Dir.Manzana) ELSE Cadena_Vacia END,
                    CASE WHEN IFNULL(Dir.Piso, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", PISO ", Dir.Piso) ELSE Cadena_Vacia END)
      WHERE Dir.Oficial       = Dir_Oficial
         AND Tmp.ClienteIDAval  > Entero_Cero;



      UPDATE  TMPAVALESCREDITO Tmp LEFT OUTER JOIN DIRECCLIENTE Dir ON Tmp.ClienteIDAval = Dir.ClienteID
                                      AND Dir.TipoDireccionID = Dir_Trabajo
        SET Tmp.DirTrabajo  =   Dir.DireccionCompleta
      WHERE Tmp.ClienteIDAval   > Entero_Cero;


      UPDATE  TMPAVALESCREDITO Tmp,  CLIENTES Cli LEFT OUTER JOIN ESTADOSREPUB Est ON Cli.EstadoID = Est.EstadoID
                            LEFT OUTER JOIN PAISES Pai ON Cli.LugarNacimiento = Pai.PaisID
        SET Tmp.PaisEstado  = CONCAT(IFNULL(Pai.Nombre, Cadena_Vacia),' ',IFNULL(Est.Nombre, Cadena_Vacia))
      WHERE Tmp.ClienteIDAval = Cli.ClienteID
         AND Tmp.ClienteIDAval  > Entero_Cero;





      # ============== SE OBTIENEN DATOS CUANDO EL AVAL ES PROSPECTO ================
      UPDATE  TMPAVALESCREDITO Tmp,   PROSPECTOS Pro
                      LEFT OUTER JOIN OCUPACIONES Ocu ON Pro.OcupacionID = Ocu.OcupacionID
                      LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON Pro.EstadoID = Mun.EstadoID AND Pro.MunicipioID  = Mun.MunicipioID
                      LEFT OUTER JOIN ESTADOSREPUB Est ON Pro.EstadoID = Est.EstadoID
        SET Tmp.NombreAval    = Pro.NombreCompleto,
            Tmp.Nombres         = CONCAT(Pro.PrimerNombre,' ',Pro.SegundoNombre,' ',Pro.TercerNombre),
            Tmp.ApellidoPaterno = Pro.ApellidoPaterno,
            Tmp.ApellidoMaterno = Pro.ApellidoMaterno,
            Tmp.RFC             = Pro.RFC,
            Tmp.Sexo            = CASE WHEN Pro.Sexo = Var_M THEN Var_SexoM WHEN Pro.Sexo = Var_F THEN Var_SexoF END,
          Tmp.FechaNacimiento =   Pro.FechaNacimiento,
          Tmp.Ocupacion   =   Ocu.Descripcion,
          Tmp.LugarTrabajo  =   Pro.LugardeTrabajo,
          Tmp.TelTrabajo    =   Pro.TelTrabajo,
          Tmp.AntTrabajo    =   CONCAT(FORMAT(Pro.AntiguedadTra, 1), " Años"),
          Tmp.Telefono    =   Pro.Telefono,
          Tmp.Colonia     =   Pro.Colonia,
          Tmp.CP        =   Pro.CP,
          Tmp.Municipio   =   Mun.Nombre,
          Tmp.Estado      =   Est.Nombre,
          Tmp.Calle     = CONCAT(IFNULL(Pro.Calle,Cadena_Vacia),
                       CASE WHEN IFNULL(Pro.NumExterior, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", No. ", Pro.NumExterior) ELSE Cadena_Vacia END,
                      CASE WHEN IFNULL(Pro.NumInterior, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", INTERIOR ", Pro.NumInterior) ELSE Cadena_Vacia END,
                      CASE WHEN IFNULL(Pro.Lote, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", LOTE ", Pro.Lote) ELSE Cadena_Vacia END,
                      CASE WHEN IFNULL(Pro.Manzana, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", MANZANA ", Pro.Manzana) ELSE Cadena_Vacia END),
          Tmp.EstadoCivil   = CASE Pro.EstadoCivil
                        WHEN Est_Soltero    THEN Des_Soltero
                        WHEN Est_CasBieSep  THEN Des_CasBieSep
                        WHEN Est_CasBieMan  THEN Des_CasBieMan
                        WHEN Est_CasCapitu  THEN Des_CasCapitu
                        WHEN Est_Viudo    THEN Des_Viudo
                        WHEN Est_Divorciad  THEN Des_Divorciad
                        WHEN Est_Seperados  THEN Des_Seperados
                        WHEN Est_UnionLibre THEN Des_UnionLibre
                        ELSE Cadena_Vacia
                      END
      WHERE Tmp.ProspectoIDAval   = Pro.ProspectoID
         AND  Tmp.ClienteIDAval = Entero_Cero
         AND  Tmp.AvalID      = Entero_Cero
         AND  Tmp.ProspectoIDAval > Entero_Cero;





      # ============== SE OBTIENEN DATOS CUANDO EL AVAL NO ES CLIENTE NI PROSPECTO ================
      UPDATE  TMPAVALESCREDITO Tmp,  AVALES Ava
                  LEFT OUTER JOIN ESTADOSREPUB Est ON Ava.EstadoID = Est.EstadoID
                  LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON Ava.EstadoID = Mun.EstadoID AND Ava.MunicipioID = Mun.MunicipioID
        SET Tmp.Telefono    = Ava.Telefono,
          Tmp.FechaNacimiento = Ava.FechaNac,
          Tmp.Colonia     = Ava.Colonia,
          Tmp.CP        = Ava.CP,
          Estado        = Est.Nombre,
          Municipio     = Mun.Nombre,
          Tmp.Calle   = CONCAT(IFNULL(Ava.Calle,Cadena_Vacia),
                     CASE WHEN IFNULL(Ava.NumExterior, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", No. ", Ava.NumExterior) ELSE Cadena_Vacia END,
                    CASE WHEN IFNULL(Ava.NumInterior, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", INTERIOR ", Ava.NumInterior) ELSE Cadena_Vacia END,
                    CASE WHEN IFNULL(Ava.Lote, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", LOTE ", Ava.Lote) ELSE Cadena_Vacia END,
                    CASE WHEN IFNULL(Ava.Manzana, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", MANZANA ", Ava.Manzana) ELSE Cadena_Vacia END),
          Tmp.EstadoCivil = CASE Ava.EstadoCivil
                        WHEN Est_Soltero    THEN Des_Soltero
                        WHEN Est_CasBieSep  THEN Des_CasBieSep
                        WHEN Est_CasBieMan  THEN Des_CasBieMan
                        WHEN Est_CasCapitu  THEN Des_CasCapitu
                        WHEN Est_Viudo    THEN Des_Viudo
                        WHEN Est_Divorciad  THEN Des_Divorciad
                        WHEN Est_Seperados  THEN Des_Seperados
                        WHEN Est_UnionLibre THEN Des_UnionLibre
                        ELSE Cadena_Vacia
                      END
      WHERE Tmp.AvalID  = Ava.AvalID
         AND Tmp.ClienteIDAval = Entero_Cero
         AND Tmp.AvalID      > Entero_Cero;
      # ================   SE OBTIENE OBTIENEN LOS DATOS QUE ESPERA EL .PRPT   ================
    SELECT count(*) INTO Var_NumAvales FROM TMPAVALESCREDITO;
    IF(Var_NumAvales = 0) THEN
        SELECT  Cadena_Vacia,               Cadena_Vacia,       Cadena_Vacia,       Cadena_Vacia,       Cadena_Vacia,
                Cadena_Vacia,               Cadena_Vacia,       Cadena_Vacia,       Cadena_Vacia,       Cadena_Vacia,
                Cadena_Vacia,               Cadena_Vacia,       Cadena_Vacia,       Cadena_Vacia,       Cadena_Vacia,
                Cadena_Vacia,               Cadena_Vacia,       Cadena_Vacia,       Cadena_Vacia,       Cadena_Vacia,
                Cadena_Vacia,                0 as numero;
    ELSE

      SELECT NombreAval     AS NombreCompleto,
            IFNULL(Nombres, Cadena_Vacia) AS Nombres,
            IFNULL(ApellidoPaterno,Cadena_Vacia) AS ApellidoPaterno,
            IFNULL(ApellidoMaterno,Cadena_Vacia) AS ApellidoMaterno,
            IFNULL(RFC,Cadena_Vacia) AS RFC,
            IFNULL(Sexo,Cadena_Vacia) AS Sexo,
           FechaNacimiento  AS FechaNac,
           FLOOR(DATEDIFF(CURDATE(), FechaNacimiento) / 365) as Edad,
           IFNULL(Ocupacion, Cadena_Vacia)    AS Ocupacion,
           IFNULL(Telefono, Cadena_Vacia)     AS Telefono,
           IFNULL(EstadoCivil, Cadena_Vacia)  AS EstadoCivil,
           IFNULL(PaisEstado,Cadena_Vacia)    AS LugarNac,
           IFNULL(Calle, Cadena_Vacia)      AS CalleAval,
           IFNULL(Colonia,Cadena_Vacia)     AS Colonia,
           IFNULL(Municipio,Cadena_Vacia)     AS MunicAval,
           IFNULL(Estado,Cadena_Vacia)      AS EstadoAval,
           IFNULL(CP,Cadena_Vacia)        AS CodPosAval,
           IFNULL(LugarTrabajo, Cadena_Vacia)   AS LugardeTrabajo,
           IFNULL(TelTrabajo,Cadena_Vacia)    AS TelTrabajo,
           IFNULL(DirTrabajo,Cadena_Vacia)    AS DirTrabajo,
           IFNULL(AntTrabajo, Cadena_Vacia)   AS AntigTra
          
      FROM TMPAVALESCREDITO Tmp;
    END IF;



      # ===================   SE ELIMINAN LOS DATOS TEMPORALES ====================
      DROP TEMPORARY TABLE IF EXISTS TMPAVALESCREDITO;
END IF; -- EndIf Seccion de Avales

IF(Par_TipoReporte = Tipo_Accionista)THEN
	SELECT ClienteID INTO Var_ClienteID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SoliCredID;

	SELECT 	CONCAT( DIR.PrimerNombre,' ',DIR.SegundoNombre,' ', IFNULL(DIR.TercerNombre,'')) AS PrimerNombre, 		
			DIR.ApellidoPaterno, 	DIR.ApellidoMaterno,	DIR.FechaNac, 			CASE WHEN DIR.Sexo = 'M' THEN 'Masculino' WHEN DIR.Sexo = 'F' THEN 'Femenimo' END AS Sexo, 	
			DIR.CURP, 				DIR.RFC, 				DIR.FEA, 				CASE WHEN DIR.EstadoCivil = 'S' THEN  'Soltero' WHEN DIR.EstadoCivil = 'C' THEN  'Casado' WHEN DIR.EstadoCivil = 'V' THEN 'Viudo'  WHEN DIR.EstadoCivil = 'D' THEN 'Divorciado'WHEN DIR.EstadoCivil = 'S'THEN 'Separado' WHEN DIR.EstadoCivil ='U' THEN 'Union Libre' END AS EstadoCivil,
			DIR.PuestoA,	        OCU.Descripcion,		EST.Nombre AS Estado,	MUN.Nombre AS Munic,		P.Nombre AS Pais,	
			DIR.CodigoPostal,		DIR.Domicilio,			DIR.TelefonoCasa,		DIR.TelefonoCelular,		YEAR(CURDATE())-YEAR(DIR.FechaNac) AS Edad
		FROM DIRECTIVOS DIR 
	    LEFT JOIN OCUPACIONES OCU ON OCU.OcupacionID = DIR.OcupacionID
	    LEFT JOIN ESTADOSREPUB EST ON EST.EstadoID = DIR.EstadoID
	    LEFT JOIN MUNICIPIOSREPUB MUN ON MUN.MunicipioID = DIR.MunicipioID
	    LEFT JOIN PAISES P ON P.PaisID = DIR.PaisResidencia
	    WHERE DIR.EsAccionista = 'S' AND DIR.ClienteID=Var_ClienteID;
END IF;

IF(Par_TipoReporte = Tipo_PEPs)THEN 
	SELECT ClienteID INTO Var_ClienteID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SoliCredID;

	SELECT CCTE.NombFamiliar, CCTE.APaternoFam, CCTE.AMaternoFam, FUN.Descripcion,  CCTE.PeriodoCargo, CCTE.PeriodoCargo
		INTO Var_NomFamiliar, Var_APaternoFam, Var_AMaternoFam, Var_OcupacionFam,	Var_PerCarFam,	Var_PerCargoFam
		FROM CONOCIMIENTOCTE CCTE
	    INNER JOIN FUNCIONESPUB FUN ON FUN.FuncionID = CCTE.FuncionID
	    WHERE ParentescoPEP = 'S' AND ClienteID = Var_ClienteID;

	SELECT CONCAT( CLI.PrimerNombre,' ',CLI.SegundoNombre,' ', IFNULL(CLI.TercerNombre,'')) AS Nombres,CLI.ApellidoPaterno, CLI.ApellidoMaterno,
			CLI.FechaNacimiento,		CCTE.RFC,				P.Nombre AS Pais,		FUN.Descripcion AS Ocupacion,       CCTE.FechaNombramiento,	
            SUBSTRING_INDEX(SUBSTRING_INDEX(CCTE.PeriodoCargo,'-',2),'-',-1)
        INTO Var_NomPeps,               Var_ApePatPeps,         Var_ApeMatPeps,         Var_FechNacPeps,                    Var_REFcPeps,
             Var_PaisPeps,              Var_OcupPeps,           Var_PeriodIni,          Var_PeridoFin             
		FROM CONOCIMIENTOCTE CCTE 
	    INNER JOIN CLIENTES CLI ON CLI.ClienteID = CCTE.ClienteID
	    INNER JOIN PAISES P ON CLI.PaisNacionalidad = P.PaisID
	    LEFT JOIN FUNCIONESPUB FUN ON FUN.FuncionID = CCTE.FuncionID
	    WHERE CCTE.PEPs = 'S' AND CCTE.ClienteID = Var_ClienteID;

        SELECT  Var_NomPeps,               Var_ApePatPeps,         Var_ApeMatPeps,         Var_FechNacPeps,                    Var_REFcPeps,
                Var_PaisPeps,              Var_OcupPeps,           Var_PeriodIni,          Var_PeridoFin,                      Var_NomFamiliar,        
                Var_APaternoFam,           Var_AMaternoFam,        Var_OcupacionFam,       Var_PerCarFam,
                Var_PerCargoFam;
        

END IF;

-- Seccion de Garantias Asefimex
IF(Par_TipoReporte = Seccion_GarantAsefimex) THEN
    SELECT Gar.GarantiaID,
            CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN CONCAT(Cli.PrimerNombre,' ',Cli.SegundoNombre,' ',Cli.TercerNombre)
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN CONCAT(Pro.PrimerNombre,' ',Pro.SegundoNombre,' ',Pro.TercerNombre)
                ELSE Gar.GaranteNombre
            END AS Nombres,
            CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN Cli.ApellidoPaterno
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN Pro.ApellidoPaterno
                ELSE Cadena_Vacia
            END AS ApellidoPaterno,
            CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN Cli.ApellidoMaterno
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN Pro.ApellidoMaterno
                ELSE Cadena_Vacia
            END AS ApellidoMaterno,
            CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN Cli.FechaNacimiento
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN Pro.FechaNacimiento
                ELSE Cadena_Vacia
            END AS FechaNacimiento,
            CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN FLOOR(DATEDIFF(CURDATE(), Cli.FechaNacimiento / 365))
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN FLOOR(DATEDIFF(CURDATE(), Pro.FechaNacimiento /365))
                ELSE Cadena_Vacia
            END AS Edad,
            CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN CASE WHEN Cli.Sexo = 'M' THEN 'Masculino' WHEN Cli.Sexo = 'F' THEN 'Femenimo' END
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN CASE WHEN Pro.Sexo = 'M' THEN 'Masculino' WHEN Cli.Sexo = 'F' THEN 'Femenimo' END
                ELSE Cadena_Vacia
            END AS Sexo,
            CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN Cli.RFC
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN Pro.RFC
                ELSE Cadena_Vacia
            END AS RFC,
            CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN CASE Cli.EstadoCivil
                                    WHEN Est_Soltero  THEN Des_Soltero
                                    WHEN Est_CasBieSep  THEN Des_CasBieSep
                                    WHEN Est_CasBieMan  THEN Des_CasBieMan
                                    WHEN Est_CasCapitu  THEN Des_CasCapitu
                                    WHEN Est_Viudo  THEN Des_Viudo
                                    WHEN Est_Divorciad  THEN Des_Divorciad
                                    WHEN Est_Seperados  THEN Des_Seperados
                                    WHEN Est_UnionLibre  THEN Des_UnionLibre
                                    ELSE Cadena_Vacia
                                END
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN CASE Pro.EstadoCivil 
                     WHEN Est_Soltero  THEN Des_Soltero
                            WHEN Est_CasBieSep  THEN Des_CasBieSep
                            WHEN Est_CasBieMan  THEN Des_CasBieMan
                            WHEN Est_CasCapitu  THEN Des_CasCapitu
                            WHEN Est_Viudo  THEN Des_Viudo
                            WHEN Est_Divorciad  THEN Des_Divorciad
                            WHEN Est_Seperados  THEN Des_Seperados
                            WHEN Est_UnionLibre  THEN Des_UnionLibre
                            ELSE Cadena_Vacia
                        END
                ELSE Cadena_Vacia
            END AS EdoCivil,
            CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN
                                    (SELECT Nombre FROM PAISES WHERE PaisID = Cli.LugarNacimiento)
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN 
                                    (SELECT Nombre FROM PAISES WHERE PaisID = Pro.LugarNacimiento)
                ELSE Cadena_Vacia
            END AS LugarNacimiento,
            CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN
                                    (SELECT DireccionCompleta
                                        FROM DIRECCLIENTE Dir
                                    WHERE ClienteID = Gar.ClienteID
                                      AND TipoDireccionID = TipoDirCasa
                                        LIMIT 1)
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN 
                                    (SELECT DireccionCompleta
                                        FROM DIRECCLIENTE Dir
                                    WHERE ClienteID = Gar.ProspectoID
                                      AND TipoDireccionID = TipoDirCasa
                                        LIMIT 1)
                ELSE Cadena_Vacia
            END AS DirecCompleta,

            CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN
                                    (SELECT Calle
                                        FROM DIRECCLIENTE Dir
                                    WHERE ClienteID = Gar.ClienteID
                                      AND TipoDireccionID = TipoDirCasa
                                        LIMIT 1)
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN 
                                    (SELECT Calle
                                        FROM DIRECCLIENTE Dir
                                    WHERE ClienteID = Gar.ProspectoID
                                      AND TipoDireccionID = TipoDirCasa
                                        LIMIT 1)
                ELSE Cadena_Vacia
            END AS Calle,
            CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN
                                    (SELECT NumeroCasa
                                        FROM DIRECCLIENTE Dir
                                    WHERE ClienteID = Gar.ClienteID
                                      AND TipoDireccionID = TipoDirCasa
                                        LIMIT 1)
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN 
                                    (SELECT NumeroCasa
                                        FROM DIRECCLIENTE Dir
                                    WHERE ClienteID = Gar.ProspectoID
                                      AND TipoDireccionID = TipoDirCasa
                                        LIMIT 1)
                ELSE Cadena_Vacia
            END AS NumExterior,
            CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN
                                    (SELECT NumInterior
                                        FROM DIRECCLIENTE Dir
                                    WHERE ClienteID = Gar.ClienteID
                                      AND TipoDireccionID = TipoDirCasa
                                        LIMIT 1)
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN 
                                    (SELECT NumInterior
                                        FROM DIRECCLIENTE Dir
                                    WHERE ClienteID = Gar.ProspectoID
                                      AND TipoDireccionID = TipoDirCasa
                                        LIMIT 1)
                ELSE Cadena_Vacia
            END AS NumInterior,
            CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN
                                    (SELECT NumInterior
                                        FROM DIRECCLIENTE Dir
                                    WHERE ClienteID = Gar.ClienteID
                                      AND TipoDireccionID = TipoDirCasa
                                        LIMIT 1)
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN 
                                    (SELECT Colonia
                                        FROM DIRECCLIENTE Dir
                                    WHERE ClienteID = Gar.ProspectoID
                                      AND TipoDireccionID = TipoDirCasa
                                        LIMIT 1)
                ELSE Cadena_Vacia
            END AS Colonia,
            CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN
                                    (SELECT NumInterior
                                        FROM DIRECCLIENTE Dir
                                    WHERE ClienteID = Gar.ClienteID
                                      AND TipoDireccionID = TipoDirCasa
                                        LIMIT 1)
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN 
                                    (SELECT CP
                                        FROM DIRECCLIENTE Dir
                                    WHERE ClienteID = Gar.ProspectoID
                                      AND TipoDireccionID = TipoDirCasa
                                        LIMIT 1)
                ELSE Cadena_Vacia
            END AS CP,
            CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN
                                    (SELECT M.Nombre
                                        FROM DIRECCLIENTE Dir
                                        INNER JOIN MUNICIPIOSREPUB M ON Dir.MunicipioID = M.MunicipioID
                                    WHERE ClienteID = Gar.ClienteID
                                      AND Dir.TipoDireccionID = TipoDirCasa
                                        LIMIT 1)
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN 
                                    (SELECT M.Nombre
                                        FROM DIRECCLIENTE Dir
                                        INNER JOIN MUNICIPIOSREPUB M ON Dir.MunicipioID = M.MunicipioID
                                    WHERE ClienteID = Gar.ProspectoID
                                      AND Dir.TipoDireccionID = TipoDirCasa
                                        LIMIT 1)
                ELSE Cadena_Vacia
            END AS Municipio,
            CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN
                                    (SELECT E.Nombre
                                        FROM DIRECCLIENTE Dir
                                        INNER JOIN ESTADOSREPUB E ON Dir.EstadoID = E.EstadoID
                                    WHERE ClienteID = Gar.ClienteID
                                      AND Dir.TipoDireccionID = TipoDirCasa
                                        LIMIT 1)
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN 
                                    (SELECT E.Nombre
                                        FROM DIRECCLIENTE Dir
                                        INNER JOIN ESTADOSREPUB E ON Dir.EstadoID = E.EstadoID
                                    WHERE ClienteID = Gar.ProspectoID
                                      AND Dir.TipoDireccionID = TipoDirCasa
                                        LIMIT 1)
                ELSE Cadena_Vacia
            END AS Estado,
            CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN
                                    (SELECT Nombre FROM PAISES WHERE PaisID = Cli.PaisResidencia)
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN 
                                    (SELECT Nombre FROM PAISES WHERE PaisID = Pro.PaisID)
                ELSE Cadena_Vacia
            END AS Pais,
            CASE WHEN IFNULL(Gar.ClienteID, Entero_Cero) != Entero_Cero THEN Cli.Telefono
                WHEN IFNULL(Gar.ProspectoID, Entero_Cero) != Entero_Cero AND
                     IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero  THEN Pro.Telefono
                ELSE Cadena_Vacia
            END AS Telefono,
           Tig.Descripcion AS Tipo, Clg.Descripcion AS Clasificacion, Gar.ValorComercial,
           Gar.Observaciones,
           IFNULL((SELECT A.NumIdentific FROM AVALES A WHERE A.AvalID = Gar.AvalID),Cadena_Vacia) AS NumIdentific
        FROM ASIGNAGARANTIAS Asi,
             TIPOGARANTIAS Tig,
             CLASIFGARANTIAS Clg,
             GARANTIAS Gar
        LEFT OUTER JOIN CLIENTES Cli ON Cli.ClienteID = IFNULL(Gar.ClienteID, Entero_Cero)
        LEFT OUTER JOIN PROSPECTOS Pro ON Pro.ProspectoID = IFNULL(Gar.ProspectoID, Entero_Cero)
                                      AND IFNULL(Gar.ClienteID, Entero_Cero) = Entero_Cero
        WHERE Asi.SolicitudCreditoID = Par_SoliCredID
          AND Asi.Estatus = Gar_Autorizado
          AND Asi.GarantiaID = Gar.GarantiaID
          AND Gar.TipoGarantiaID = Tig.TipoGarantiasID
          AND Gar.ClasifGarantiaID = Clg.ClasifGarantiaID
          AND Gar.TipoGarantiaID= Clg.TipoGarantiaID;

END IF; -- EndIf Seccion de Garantias Asefimex
-- seccion para el reporte de interesados de asefimex
IF(Par_TipoReporte = Seccion_Interesado) THEN 
    SELECT NombreCompleto 
        FROM REFERENCIACLIENTE 
            WHERE SolicitudCreditoID = Par_SoliCredID 
            AND Interesado = 'S';
END IF; -- FIN DE LA SECCION DE INTERESADO

END TerminaStore$$
