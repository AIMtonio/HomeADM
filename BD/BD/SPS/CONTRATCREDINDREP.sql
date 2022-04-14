-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTRATCREDINDREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTRATCREDINDREP`;
DELIMITER $$

CREATE PROCEDURE `CONTRATCREDINDREP`(


-- SP utilizado para mostrar la caratula de credito
    Par_CreditoID         BIGINT(12),           -- Numero de Credito
    Par_TipoReporte       INT,                  -- Tipo de Reporte

    Par_EmpresaID         INT(11),              -- Parametro de Auditoria
    Aud_Usuario           INT(11),              -- Parametro de Auditoria
    Aud_FechaActual       DATETIME,             -- Parametro de Auditoria
    Aud_DireccionIP       VARCHAR(15),          -- Parametro de Auditoria
    Aud_ProgramaID        VARCHAR(50),          -- Parametro de Auditoria
    Aud_Sucursal          INT(11),              -- Parametro de Auditoria
    Aud_NumTransaccion    BIGINT(20)            -- Parametro de Auditoria
      )
TerminaStore: BEGIN

-- Declaracion de Variables
-- ------------- VARIABLES PARA PRUEBAS JO ----------------

DECLARE Var_RequiereAvales                      CHAR(1);          -- 'S': Si requiere Aval  'N': No requiere Aval
DECLARE Var_AvalAutorizado                      CHAR(1);          -- 'U': Autorizado, 'A': Asignado, 'N': No definido
DECLARE Var_OrigenAval                          INT;            -- Aval puede ser 100: Cliente, 10: Aval, 1: Prospecto
DECLARE Var_AvalNombreCompleto                  VARCHAR(200);
DECLARE Var_AvalDirCompleta                     VARCHAR(350);

DECLARE Aval_Nombre                             VARCHAR(200);

DECLARE Aval_DirNumExt                          CHAR(10);
DECLARE Aval_DirCalle                           VARCHAR(50);
DECLARE Aval_DirCP                              VARCHAR(15);
DECLARE Aval_DirLocalidad                       VARCHAR(200);
DECLARE Aval_DirEstado                          VARCHAR(100);
DECLARE Aval_DirColonia                         VARCHAR(200);

DECLARE Var_AvalRFC                             CHAR(13);
DECLARE Var_AvalSexo                            VARCHAR(10);
DECLARE Var_AvalFechaNacimiento                 VARCHAR(100);
DECLARE Var_AvalEdo                             VARCHAR(100);
DECLARE Var_AvalPais                            VARCHAR(150);
DECLARE Var_AvalNacion                          CHAR(15);
DECLARE Var_AvalOcupacion                       TEXT;
DECLARE Var_AvalGradoEstudio                    VARCHAR(50);
DECLARE Var_AvalProfesion                       VARCHAR(100);
DECLARE Var_AvalActEco                          VARCHAR(200);
DECLARE Var_AvalEdoCivil                        CHAR(50);
DECLARE Var_AvalTel                             VARCHAR(20);
DECLARE Var_AvalCorreo                          VARCHAR(50);
DECLARE Var_AvalCURP                            CHAR(18);

DECLARE Var_NumeroTransaccion                   BIGINT;
DECLARE Aval_TipoPersona                        CHAR(1);
DECLARE Var_AvalTipoPersona                     VARCHAR(50);
DECLARE Var_AvalRazonSocial                     VARCHAR(150);
DECLARE Aval_EscPub                             VARCHAR(50);
DECLARE Aval_CiudadEscP                         VARCHAR(100);
DECLARE Aval_LocEscPubCons                      VARCHAR(200);
DECLARE Aval_DistEscPubCons                     VARCHAR(100);
DECLARE Aval_FechaEscP                          CHAR(50);
DECLARE Aval_NomNotarioEscP                     VARCHAR(100);
DECLARE Aval_NumNotarioEscP                     VARCHAR(10);
DECLARE Aval_EdoNotario                         VARCHAR(100);
DECLARE Aval_EdoIDReg                           VARCHAR(100);
DECLARE Aval_Proyecto                           VARCHAR(500);
DECLARE Aval_ObjSocEscConstitutiva              VARCHAR(500);
DECLARE Aval_NombreApoderado                    VARCHAR(150);
DECLARE Aval_TituloApoderado                    VARCHAR(150);
DECLARE Aval_NumEscPoder                        VARCHAR(50);
DECLARE Aval_LocEscPoder                        VARCHAR(200);
DECLARE Aval_EdoEscPoder                        VARCHAR(100);
DECLARE Aval_NomNotarioEscPoder                 VARCHAR(100);
DECLARE Aval_EdoNotEscPoder                     VARCHAR(100);
DECLARE Aval_LocNot                             VARCHAR(150);
DECLARE Aval_EdoRegEscPoder                     VARCHAR(100);
DECLARE Aval_DistRegEscPoder                    VARCHAR(100);
DECLARE Aval_NotariaPoder                       VARCHAR(10);



--  ------------------- SANA TUS FINANZAS ------------------- 

--  ------------------- SECCION 17 ------------------- 
DECLARE Var_CreditoFolio                        BIGINT(12);
DECLARE Var_NombreProducto                      VARCHAR(100);
DECLARE Var_TipoCredito                         VARCHAR(50);
DECLARE Var_NombreSucursal                      VARCHAR(50);

--  --- SECCION 19 - CONTRATO SANA TUS FINANZAS --- 
DECLARE Var_PaternoRepre                        VARCHAR(50);
DECLARE Var_MaternoRepre                        VARCHAR(50);
DECLARE Var_RFCOficialRL                        VARCHAR(20);
DECLARE Var_TelefonoRL                          VARCHAR(15);
DECLARE Var_CorreoRL                            VARCHAR(50);
DECLARE Var_FechaNacimiento                     DATE;
DECLARE Var_ApellidoPaterno                     VARCHAR(50);
DECLARE Var_ApellidoMaterno                     VARCHAR(50);
DECLARE Var_Sexo                                VARCHAR(50);
DECLARE Var_FechaNacimientoTxt                  VARCHAR(50);
DECLARE Var_EdadTxt                             VARCHAR(50);
DECLARE Var_Ocupacion                           TEXT;
DECLARE Var_Correo                              VARCHAR(50);
DECLARE Var_Domicilio                           VARCHAR(250);
DECLARE Var_Colonia                             VARCHAR(200);
DECLARE Var_Ciudad                              VARCHAR(200);
DECLARE Var_TiempoRadicar                       INT(11);
DECLARE Var_TiempoRadicarTxt                    VARCHAR(50);
DECLARE Var_Telefono                            VARCHAR(20);
DECLARE Var_NumDepenEconomi                     INT(11);
DECLARE Var_Nacionalidad                        VARCHAR(20);
DECLARE Var_AntiguedadLab                       VARCHAR(10);

DECLARE Var_CalleNegocio                        VARCHAR(200);
DECLARE Var_ColoniaNegocio                      VARCHAR(200);
DECLARE Var_CiudadNegocio                       VARCHAR(200);
DECLARE Var_EstadoNegocio                       VARCHAR(100);
DECLARE Var_CPNegocio                           VARCHAR(200);
DECLARE Var_NumCasaNegocio                      CHAR(10);
DECLARE Var_NumIntNegocio                       CHAR(10);

DECLARE TipoSanaTusFinanzas                     INT;
DECLARE TablaAmortizacionSanaTusFinanzas        INT;
DECLARE TipoContratoSanaTusFinanzas             INT;
DECLARE TipoAvalesSTFc                          INT;  -- Avales Sana Tus Finanzas: Todos sus Datos
DECLARE TipoAvalesSTFs                          INT;  -- Avales Sana Tus Finanzas: Nombre Completo, Direccion Completa
DECLARE Var_TipoPersona                         CHAR(1);

DECLARE Conti                                   INT;  -- Contador
DECLARE Contj                                   INT;  -- Contador

--  ----------------- FIN SANA TUS FINANZAS ----------------- 

DECLARE Var_TasaAnual                           DECIMAL(12,4);
DECLARE Var_TasaAnualConLetra                   VARCHAR(100);   -- Tasa anual con letras
DECLARE Var_TasaMens                            DECIMAL(12,4);
DECLARE Var_TasaMens1                           DECIMAL(12,2);
DECLARE Var_TasaFlat                            DECIMAL(12,4);
DECLARE Var_CAT                                 DECIMAL(12,4);
DECLARE Var_CreditoID                           BIGINT(12);
DECLARE Var_TotInteres                          DECIMAL(14,2);
DECLARE Var_NumAmorti                           INT;
DECLARE Var_MontoCred                           DECIMAL(14,2);
DECLARE Var_SumMonCred                          DECIMAL(14,2);
DECLARE Var_PorcGarLiq                          DECIMAL(12,2);
DECLARE Var_MontoGarLiq                         DECIMAL(14,2);
DECLARE Var_MonGarLiq                           VARCHAR(20);
DECLARE Var_Plazo                               VARCHAR(100);
DECLARE Var_FechaVenc                           DATE;
DECLARE Var_MontoSeguro                         DECIMAL(14,2);
DECLARE Var_PorcCobert                          DECIMAL(12,4);
DECLARE Var_NomRepres                           VARCHAR(300);
DECLARE Var_Periodo                             INT;
DECLARE Var_Frecuencia                          CHAR(1);
DECLARE Var_FrecuenciaInt                       CHAR(1);
DECLARE Var_DesFrec                             VARCHAR(100);
DECLARE Var_FacRiesgo                           DECIMAL(12,6);
DECLARE Var_FrecSeguro                          VARCHAR(100);
DECLARE Var_NumRECA                             VARCHAR(200);
DECLARE Var_DiaVencimiento                      VARCHAR(20);
DECLARE Var_MesVencimiento                      VARCHAR(20);
DECLARE Var_AnioVencimiento                     VARCHAR(20);
DECLARE Var_RepresentanteLegal                  VARCHAR(200);
DECLARE Var_DirccionInstitucion                 VARCHAR(300);
DECLARE Var_SexoRepteLegal                      CHAR(200);
DECLARE Var_TelInstitucion                      VARCHAR(20);
DECLARE Var_NombreEstado                        VARCHAR(100);
DECLARE Var_RFCOficial                          VARCHAR(20);
DECLARE Var_DiaSistema                          INT;
DECLARE Var_AnioSistema                         INT;
DECLARE Var_MesSistema                          VARCHAR(20);
DECLARE Var_NomCortoInstit                      VARCHAR(50);
DECLARE Var_MtoLetra                            VARCHAR(100);
DECLARE Var_GarantiaLetra                       VARCHAR(100);
DECLARE Var_DesFrecLet                          VARCHAR(50);
DECLARE Var_TotPagar                            DECIMAL(14,2);
DECLARE Var_TotPagLetra                         VARCHAR(100);
DECLARE Var_MontoCredito                        VARCHAR(150);
DECLARE Var_MontoCreditoAn                      VARCHAR(150);
DECLARE MontoTotPagar                           VARCHAR(150);
DECLARE Var_NombreEstadom                       VARCHAR(50);
DECLARE Var_NombreMuni                          VARCHAR(50);
DECLARE Var_DescProducto                        VARCHAR(200);
DECLARE Var_CobraMora                           CHAR(1);
DECLARE Var_FactorMora                          DECIMAL(14,4);
DECLARE Var_FactorMora1                         DECIMAL(14,2);
DECLARE Var_ReqGarantia                         CHAR(1);
DECLARE Var_Encabezado                          VARCHAR(400);
DECLARE Var_SolCreditoID                        INT(11);
DECLARE Var_TipDesc                             VARCHAR(200);
DECLARE Var_ClaDesc                             VARCHAR(200);
DECLARE Var_NoIdent                             VARCHAR(40);
DECLARE Var_GarantiaID                          INT(11);
DECLARE Var_TipoGarantiaID                      INT(11);
DECLARE Var_ClasifGarantiaID                    INT(11);
DECLARE Var_NumCuotas                           INT;
DECLARE Var_TipoPagoCap                         CHAR(1);
DECLARE Var_Clasificacion                       VARCHAR(30);
DECLARE Var_ClienteID                           INT(11);
DECLARE Var_DirecCliente                        VARCHAR(200);
DECLARE Var_NomInstit                           VARCHAR(200);
DECLARE Var_DirecInstit                         VARCHAR(200);
DECLARE Var_TelefonoCelular                     VARCHAR(15);
DECLARE Var_NombreRepresentante                 VARCHAR(200);
DECLARE Var_FechaSistema                        DATE;
DECLARE Var_DestinoCredito                      VARCHAR(200);
DECLARE Var_SolicitudCredito                    VARCHAR(200);
DECLARE Var_NombEstado                          VARCHAR(200);
DECLARE Var_NombMunicipio                       VARCHAR(200);
DECLARE Var_Calle                               VARCHAR(200);
DECLARE Var_NumCasa                             VARCHAR(200);
DECLARE Var_NumInterior                         VARCHAR(200);
DECLARE Var_CP                                  VARCHAR(200);
DECLARE Var_Manzana                             VARCHAR(200);
DECLARE Var_NombreColonia                       VARCHAR(200);
DECLARE Var_Lote                                VARCHAR(200);
DECLARE Var_AvalID                              INT(11);
DECLARE Var_ProspectoID                         INT(11);
DECLARE Var_Nombre                              VARCHAR(200);
DECLARE Var_Direc                               VARCHAR(200);
DECLARE Var_RFC                                 VARCHAR(20);
DECLARE Var_LongitudLetras                      INT(11);
DECLARE Var_ConcatenadoMonto                    VARCHAR(200);
DECLARE Var_DireccSucursal                      VARCHAR(200);
DECLARE Var_IntOrdiLetras                       VARCHAR(200);
DECLARE Var_IntMorLetras                        VARCHAR(200);
DECLARE Var_Cliente                             VARCHAR(50);
DECLARE Var_DireccionCompleta                   VARCHAR(250);
DECLARE Var_Credito                             BIGINT(12);
DECLARE Var_CURP                                VARCHAR(20);
DECLARE Var_Edad                                INT(11);
DECLARE Var_NombreIdent                         VARCHAR(100);
DECLARE Var_NumIdent                            VARCHAR(100);
DECLARE Var_EstadoCivil                         VARCHAR(50);
DECLARE Var_EstadoCivilGar                      VARCHAR(80);
DECLARE Var_NumRegTemporal                      INT(11);
DECLARE Var_TipoGarantia                        INT(11);
DECLARE Var_TipoDocumento                       INT(11);
DECLARE Var_TipoDocumentoTxt                    VARCHAR(100);
DECLARE Var_ValorComercial                      DECIMAL(14,2);
DECLARE Var_TasaMoraAnual                       DECIMAL(12,4);
DECLARE Var_TasaMoratoria                       DECIMAL(12,4);
DECLARE Var_TasaMensMora                        DECIMAL(12,4);
DECLARE Var_MontoPolizaSegA                     DECIMAL(14,2);
DECLARE Var_MtoLetraSeguro                      VARCHAR(100);
DECLARE Var_MontoSeguroApoyo                    VARCHAR(150);
DECLARE Var_MontoAsignado                       DECIMAL(12,2);
DECLARE Var_MontoMax                            DECIMAL(14,4);
DECLARE Var_ValorMax                            DECIMAL(14,4);
DECLARE Var_TipoGar                             INT(11);
DECLARE Var_TipoDoc                             INT(11);
DECLARE Var_Monto                               DECIMAL(12,2);
DECLARE Var_Comercial                           DECIMAL(12,2);
DECLARE Var_MontoPago                           DECIMAL(14,2);
DECLARE Var_NombreInstitucion                   VARCHAR(200);
DECLARE Var_NombreCompleto                      VARCHAR(300);
DECLARE Var_FechaHoraServidor                   DATETIME;
DECLARE Var_ComisionApertura                    DECIMAL(14,2);
DECLARE Var_ComisionPrepago                     DECIMAL(14,2);
DECLARE Var_ComisionCobranza                    DECIMAL(14,2);
DECLARE Var_IdentificacionOficial               INT(11);
DECLARE Var_ComprobanteDomicilio                INT(11);
DECLARE Var_ComprobanteIngresos                 INT(11);
DECLARE Var_ServicioFederal                     INT(11);
DECLARE Var_EstadoCuenta                        INT(11);
DECLARE Var_CATLR                               DECIMAL(12,2);
DECLARE Var_SeguroLetra                         VARCHAR(200);
DECLARE Var_PolizaDelSeguro                     DECIMAL(14,2);
DECLARE Var_PolDelSeguroLetra                   VARCHAR(200);
DECLARE Var_CuotasLetra                         VARCHAR(200);
DECLARE Var_RecursoFirma                        VARCHAR(100);
DECLARE Var_ConsecutivoFirma                    INT;
DECLARE Var_TipoCobroMoratorio                  CHAR(1);
DECLARE Var_ProductoCre                         INT;
DECLARE Var_FechaLimPag                         DATE;
DECLARE Var_FechaCorte                          VARCHAR(400);
DECLARE Var_MontoCuota                          DECIMAL(12,2);
DECLARE Var_MontoRetencion                      VARCHAR(200);
DECLARE ValorMoraPC400                          VARCHAR(250);
DECLARE PenaConvtxtPC400                        VARCHAR(250);
DECLARE PenaConvPC400                           DECIMAL(12,2);

--  Declaracion de Variables utilizadas en seccion  14 - PlanPagosYanga
DECLARE Var_CantCuotas                          INT;
DECLARE Var_CantFilas                           INT;
DECLARE Var_Vueltas                             INT;
DECLARE Var_FechaPago                           DATE;
DECLARE Var_Capital                             DECIMAL(18,2);
DECLARE Var_NumFila                             INT;
DECLARE Var_NumColumna                          INT;

-- Declaracion de variables para mas alternativa
-- pc100
DECLARE Cli_TituloPF                            VARCHAR(100);
DECLARE Cli_TipoPersona                         CHAR(1);
DECLARE Cli_Sexo                                VARCHAR(100);
DECLARE Cli_FechaNacimientoFtoTxt               VARCHAR(100);
DECLARE Cli_Nacionalidad                        VARCHAR(100);
DECLARE Cli_Ocupacion                           TEXT;
DECLARE Cli_Profesion                           VARCHAR(100);
DECLARE Cli_GradoEstudios                       VARCHAR(100);
DECLARE Cli_ActividadEconomica                  VARCHAR(100);
DECLARE Cli_EstadoCivil                         VARCHAR(100);
DECLARE Cli_Telefono                            VARCHAR(100);
DECLARE Cli_Correo                              VARCHAR(100);
DECLARE Cli_CURP                                VARCHAR(100);
DECLARE Cli_TipoEmpresa                         VARCHAR(100);
DECLARE Cli_RazonSocial                         VARCHAR(100);
DECLARE Cli_NumEscPConstitutiva                 VARCHAR(100);
DECLARE Cli_LocalidadEscPConstitutiva           VARCHAR(100);
DECLARE Cli_EstadoEscPConstitutiva              VARCHAR(100);
DECLARE Cli_FechaEscPConstitutiva               VARCHAR(100);
DECLARE Cli_NombreNotarioEscPConstitutiva       VARCHAR(100);
DECLARE Cli_NumeroNotarioEscPConstitutiva       VARCHAR(100);
DECLARE Cli_EstadoNotarioEscPConstitutiva       VARCHAR(100);
DECLARE Cli_LocalidadRegistroEscPConstitutiva   VARCHAR(100);
DECLARE Cli_EstadoRegistroEscPConstitutiva      VARCHAR(100);
DECLARE Cli_DistritoRegistroEscPConstitutiva    VARCHAR(100);
DECLARE Cli_ObjetoSocialEscPConstitutiva        VARCHAR(100);
DECLARE Cli_NombreApoderadoEscPPoderes          VARCHAR(100);
DECLARE Cli_TituloApoderadoEscPPoderes          VARCHAR(100);
DECLARE Cli_NumeroEscPPoderes                   VARCHAR(100);
DECLARE Cli_LocalidadEscPPoderes                VARCHAR(100);
DECLARE Cli_EstadoEscPPoderes                   VARCHAR(100);
DECLARE Cli_NombreNotarioEscPPoderes            VARCHAR(100);
DECLARE Cli_NumeroNotarioEscPPoderes            VARCHAR(100);
DECLARE Cli_EstadoNotarioEscPPoderes            VARCHAR(100);
DECLARE Cli_LocalidadRegEscPPoderes             VARCHAR(100);
DECLARE Cli_EstadoRegEscPPoderes                VARCHAR(100);
DECLARE Cli_DistritoRegEscPPoderes              VARCHAR(100);
DECLARE Var_DirFiscalInstitucion                VARCHAR(200);
DECLARE Var_MontoPagotxt                        VARCHAR(100);
DECLARE Var_CATLRtxt                            VARCHAR(100);
DECLARE Var_FechaTerminoMora                    VARCHAR(100);
DECLARE Var_ComReimpresonCantiva                VARCHAR(100);
DECLARE Var_taordinariatxt                      VARCHAR(100);
DECLARE Var_tasaOrdinariaMensualtxt             VARCHAR(100);
DECLARE Var_Titulo                              VARCHAR(100);
DECLARE Var_FechaTerminoMoratxt                 VARCHAR(100);
DECLARE Var_FechaSistematxt                     VARCHAR(100);
DECLARE Var_TasaMoraDiaria                      VARCHAR(100);
DECLARE TipoPersona                             VARCHAR(100);
DECLARE Titulo                                  VARCHAR(100);
DECLARE PrimerNombre                            VARCHAR(100);
DECLARE SegundoNombre                           VARCHAR(100);
DECLARE TercerNombre                            VARCHAR(100);
DECLARE ApellidoPaterno                         VARCHAR(100);
DECLARE ApellidoMaterno                         VARCHAR(100);
DECLARE NombreCompleto                          VARCHAR(100);
DECLARE Sexo                                    VARCHAR(100);
DECLARE FechaNacimiento                         VARCHAR(100);
DECLARE FechaNacimientoFtoTxt                   VARCHAR(100);
DECLARE EstadoNacimiento                        VARCHAR(100);
DECLARE PaisNacimiento                          VARCHAR(100);
DECLARE Nacionalidad                            VARCHAR(100);
DECLARE OcupacionID                             VARCHAR(100);
DECLARE Ocupacion                               TEXT;
DECLARE GradoEstudios                           VARCHAR(100);
DECLARE Profesion                               VARCHAR(100);
DECLARE ActividadEconomica                      VARCHAR(100);
DECLARE EstadoCivil                             VARCHAR(100);
DECLARE Telefono                                VARCHAR(100);
DECLARE Correo                                  VARCHAR(100);
DECLARE CURP                                    VARCHAR(100);
DECLARE TipoEmpresa                             VARCHAR(100);
DECLARE RazonSocial                             VARCHAR(100);
DECLARE NumEscPConstitutiva                     VARCHAR(100);
DECLARE LocalidadEscPConstitutiva               VARCHAR(100);
DECLARE EstadoEscPConstitutiva                  VARCHAR(100);
DECLARE FechaEscPConstitutiva                   VARCHAR(100);
DECLARE NombreNotarioEscPConstitutiva           VARCHAR(100);
DECLARE NumeroNotarioEscPConstitutiva           VARCHAR(100);
DECLARE EstadoNotarioEscPConstitutiva           VARCHAR(100);
DECLARE LocalidadRegistroEscPConstitutiva       VARCHAR(100);
DECLARE EstadoRegistroEscPConstitutiva          VARCHAR(100);
DECLARE DistritoRegistroEscPConstitutiva        VARCHAR(100);
DECLARE ObjetoSocialEscPConstitutiva            VARCHAR(100);
DECLARE NombreApoderadoEscPPoderes              VARCHAR(100);
DECLARE TituloApoderadoEscPPoderes              VARCHAR(100);
DECLARE NumeroEscPPoderes                       VARCHAR(100);
DECLARE LocalidadEscPPoderes                    VARCHAR(100);
DECLARE EstadoEscPPoderes                       VARCHAR(100);
DECLARE NombreNotarioEscPPoderes                VARCHAR(100);
DECLARE NumeroNotarioEscPPoderes                VARCHAR(100);
DECLARE EstadoNotarioEscPPoderes                VARCHAR(100);
DECLARE LocalidadRegEscPPoderes                 VARCHAR(100);
DECLARE EstadoRegEscPPoderes                    VARCHAR(100);
DECLARE DistritoRegEscPPoderes                  VARCHAR(100);
DECLARE RFC                                     VARCHAR(100);
DECLARE anioText                                VARCHAR(100);
DECLARE PlazoCredito                            VARCHAR(100);
DECLARE MontoPagotxt                            VARCHAR(200);
DECLARE CATLRtxt                                VARCHAR(100);
DECLARE TasaMoraDiaria                          VARCHAR(100);
DECLARE ComReimpresonCant                       VARCHAR(100);
DECLARE ComReimpresonCantiva                    VARCHAR(100);
DECLARE taiva                                   VARCHAR(100);
DECLARE tasaOrdinariaMensual                    VARCHAR(100);
DECLARE tasaOrdinariaMensualtxt                 VARCHAR(100);
DECLARE taordinaria                             VARCHAR(100);
DECLARE taordinariatxt                          VARCHAR(100);
DECLARE taOrdCarat                              VARCHAR(100);
DECLARE FechaLimPagtxt                          VARCHAR(100);
DECLARE TasaOrdinaria                           VARCHAR(100);
DECLARE TasaDiariaordinariatxt                  VARCHAR(100);
DECLARE ValorMoraCatorcenalPC200                VARCHAR(100);
DECLARE TasaMoraMensual                         VARCHAR(100);
DECLARE ValorMoraDiaria                         VARCHAR(100);
DECLARE MontoGarantiaLiquida                    VARCHAR(100);
DECLARE NombreAval                              VARCHAR(100);
DECLARE FechaTerminoMora                        VARCHAR(100);
DECLARE FechaTerminoMoratxt                     VARCHAR(100);
DECLARE FechaTerminoMora200                     VARCHAR(100);
DECLARE FechaTerminoMoratxt200                  VARCHAR(100);
DECLARE FechaSistematxt                         VARCHAR(100);
DECLARE Cadena_Default                          VARCHAR(300);
DECLARE Var_RepresentantePM                     VARCHAR (300);
DECLARE Var_FechaGarantia                       DATE;
DECLARE Var_Garantias                           VARCHAR(500);
DECLARE Var_Factura                             VARCHAR(500);
DECLARE Var_SerieFactura                        VARCHAR(100);
DECLARE Var_EsGarantiaReal                      CHAR(1);
DECLARE Var_ExisteGarReal                       INT;
DECLARE Var_DesGarantias                        VARCHAR(1200);
DECLARE GarHip_Mun                              VARCHAR(250);
DECLARE GarHip_Edo                              VARCHAR(250);
DECLARE GarHip_FechaReg                         VARCHAR(250);
DECLARE GarReal_TipDocu                         VARCHAR(250);

--  sofiexpress(orderexpress) 
DECLARE Cre_TipCreClatxt                        VARCHAR(250);
DECLARE Cre_TasaFija                            DECIMAL(12,4);
DECLARE Cre_TasaFijatxt                         VARCHAR(250);
DECLARE PCred_NomComer                          VARCHAR(250);
DECLARE Var_CATtxt                              VARCHAR(250);
DECLARE Avales_Nom1                             VARCHAR(250);
DECLARE Avales_Nom2                             VARCHAR(250);
DECLARE Avales_Nom3                             VARCHAR(250);
DECLARE Avales_RFC1                             VARCHAR(250);
DECLARE Avales_RFC2                             VARCHAR(250);
DECLARE Avales_RFC3                             VARCHAR(250);
DECLARE Avales_Dir1                             VARCHAR(250);
DECLARE Avales_Dir2                             VARCHAR(250);
DECLARE Avales_Dir3                             VARCHAR(250);
DECLARE GarLiq_Desc                             VARCHAR(250);
DECLARE GarLiq_Ref                              VARCHAR(250);
DECLARE GarHip_Hipo                             VARCHAR(250);
DECLARE GarHip_Desc                             VARCHAR(250);
DECLARE Var_GarHipDesc                          VARCHAR(250);
DECLARE GarHip_Ref                              VARCHAR(250);
DECLARE GarReal_Desc                            VARCHAR(250);
DECLARE Var_GarRealDesc                         VARCHAR(250);
DECLARE GarReal_Ref                             VARCHAR(250);
DECLARE AvalSerieFactura                        VARCHAR(250);
DECLARE AvalGarRealDesc                         VARCHAR(250);
DECLARE AvalGarRealRef                          VARCHAR(250);
DECLARE AvalGarRealTipDoc                       VARCHAR(250);
DECLARE AvalGarHipHipo                          VARCHAR(250);
DECLARE AvalGarHipDesc                          VARCHAR(250);
DECLARE AvalGarHipRef                           VARCHAR(250);
DECLARE AvalGarHipMun                           VARCHAR(250);
DECLARE AvalGarHipEdo                           VARCHAR(250);
DECLARE AvalGarHipFecReg                        VARCHAR(250);
DECLARE Var_SolicitudCredID                     BIGINT(20);
DECLARE Var_ProductoCreditoID                   INT(11);
DECLARE Var_PlazoDias                           INT(11);
DECLARE Garantia_Liquida                        INT(11);
DECLARE Var_ReqGarLiq                           CHAR(1);
DECLARE NumRegGarLiq                            INT(11);
DECLARE TipoCredito                             CHAR(1);
DECLARE Var_Estatus                             CHAR(1);
DECLARE Con_Reestructura                        CHAR(1);
DECLARE EstDesembolsada                         CHAR(1);
DECLARE Var_FechaRegistro                       DATE;
--  Finsocial
DECLARE Var_ComisionLiqAntc                     DECIMAL(14,2);
DECLARE Constante_SI                            CHAR(1);
DECLARE Var_TasaAnualFinso                      DECIMAL(12,2);
DECLARE Var_FechaDesem                          DATE;
DECLARE Tipo_AvalesFinSocial                    INT;
DECLARE Tipo_ContratoFinSocial                  INT(11);
DECLARE NumAvales                               INT;
DECLARE CantLetra                               VARCHAR(100);
DECLARE FechaLetra                              VARCHAR(100);
DECLARE FechaSisLetra                           VARCHAR(100);
DECLARE TasaLetra                               VARCHAR(100);
DECLARE TasaMoraLetra                           VARCHAR(100);
DECLARE Var_FinSoCreditoID                      BIGINT;
DECLARE Var_FinSoCATLR                          DECIMAL(12,2);
DECLARE Var_FinSoMontoCred                      DECIMAL(14,2);
DECLARE Var_FinSoTotPagar                       DECIMAL(14,2);
DECLARE Var_FinSoPlazo                          VARCHAR(100);
DECLARE Var_FinSoFechaVenc                      DATE;
DECLARE Var_FinSoComisionApertura               DECIMAL(14,2);
DECLARE Var_FinSoComisionLiqAntc                DECIMAL(14,2);
DECLARE Var_FinSoTipoComAnt                     CHAR(1);
DECLARE Var_FinSoNumRECA                        VARCHAR(200);
DECLARE Var_FinSoNomRepres                      VARCHAR(300);
DECLARE Var_FinSoNombreEstadom                  VARCHAR(50);
DECLARE Var_FinSoNombreMuni                     VARCHAR(50);
DECLARE Var_FinSoDescProducto                   VARCHAR(200);
DECLARE Var_FinSoFechaDesem                     DATE;
DECLARE Var_FinSoNumAmorti                      INT;
DECLARE Var_FinSoFrecuencia                     CHAR(1);
DECLARE Var_FinSoTipoCobMora                    CHAR(1);
DECLARE Var_FinSoComXapert                      CHAR(1);
DECLARE Var_FinSoFactorMora                     DECIMAL(12,4);

-- Variables Alternativa 19

DECLARE Var_RFCInstitucion                      VARCHAR(20);
DECLARE Var_ComAperturaPorc                     VARCHAR(100);   -- Monto de la Comision por Apertura
DECLARE Var_ComisionAperturaTxt                 VARCHAR(100);   -- Porcentaje Comision por Apertura Porcentaje
DECLARE Var_DirecClienteFiscal                  VARCHAR(200);  -- Direccion Fiscal
DECLARE Var_AvalRegimenMat                      VARCHAR(100);  -- Regimen Matrimonial
DECLARE Var_NombreConyugue                      VARCHAR(100);  -- Nombre del Conyugue(Cliente)
DECLARE Var_AvalNombreConyugue                  VARCHAR(100);  -- Nombre del Conyugue(Aval)
DECLARE Var_AvalFolioIden                       VARCHAR(100);  -- Folio de la Credencial para Votar(Aval)
DECLARE Var_AvalMunicipio                       VARCHAR(100);  -- Municipio del Aval
DECLARE Var_FechaMinistrado                     VARCHAR(100);  -- Fecha Ministrado
DECLARE Var_NomInstNomina                       VARCHAR(50);   -- Nombre de Institucion de Nomina
DECLARE Var_Subsidio                            DECIMAL(10,2);  -- Subsidio otorgado
DECLARE Var_SubsidioTxt                         VARCHAR(100);   -- Subsidio otorgado
DECLARE Var_TasaMoratoriaMen                    DECIMAL(10,4);
DECLARE Var_TasaMoratoriaMenTxt                 VARCHAR(100);
DECLARE Var_TasaMoratoriaTxt                    VARCHAR(100);
DECLARE Var_ProductoCredito                     INT(11);        -- Producto de Credito
DECLARE Var_FactorMoraTxt                       VARCHAR(50);
DECLARE Var_EscriPubIns                         VARCHAR(50);    -- Numero de Escritura Publica Institucion
DECLARE Var_LibroEscIns                         VARCHAR(50);    -- Libro en que se encuentra la Escritura Publica Institucion
DECLARE Var_VolEscIns                           VARCHAR(10);    -- Volumen de la Escritura Publica   Institucion
DECLARE Var_FechaEscIns                         DATE;           -- Fecha de la Escritura Publica Institucion
DECLARE Var_EstadoIDEscIns                      VARCHAR(50);        -- Estado de Escritura Publica Institucion
DECLARE Var_LocalEscIns                         INT(11);        -- Municipio de Escritura Publica Institucion
DECLARE Var_NotariaIns                          INT(11);        -- Numero de la Notaria Publica Institucion
DECLARE Var_DirecNotarIns                       VARCHAR(150);   -- Direccion de Notaria Publica Institucion
DECLARE Var_NomNotarioIns                       VARCHAR(100);   -- Nombre del Notario    Institucion
DECLARE Var_RegistroPubIns                      VARCHAR(10);    -- Numero de Registro Publico Institucion
DECLARE Var_FolioRegPubIns                      VARCHAR(10);    -- Folio de Registro Publico Institucion
DECLARE Var_VolRegPubIns                        VARCHAR(10);    -- Volumen de Registro Publico Institucion
DECLARE Var_LibroRegPubIns                      VARCHAR(10);    -- Libro de Registro Publico Institucion
DECLARE Var_AuxiRegPubIns                       VARCHAR(20);    -- Auxiliar de Registro Publico Institucion
DECLARE Var_FechaRegPubIns                      DATE;           -- Fecha de Registro Publico Institucion
DECLARE Var_EstadoIDRegIns                      INT(11);        -- Estado de Registro Publico Institucion
DECLARE Var_LocalRegPubIns                      INT(11);        -- Localidad de Registro Publico Institucion
DECLARE Var_CarProd                             TEXT;           -- Caracteristicas de Producto de Credito

-- Comisiones Relevantes Alternativa 19
DECLARE Var_ComDisposicion                      DECIMAL(10,2);
DECLARE Var_ComAnualidad                        DECIMAL(10,2);
DECLARE Var_ComFactibilidad                     DECIMAL(10,2);
DECLARE Var_ComPenaConvencional                 DECIMAL(10,2);
DECLARE Var_ComPrepagoTxt                       VARCHAR(100);
DECLARE Var_ComPenaConvencionalTxt              VARCHAR(100);
DECLARE Var_ComGastosCobranzaTxt                VARCHAR(100);
DECLARE Var_ComDisposicionTxt                   VARCHAR(100);
DECLARE Var_ComAnualidadTxt                     VARCHAR(100);
DECLARE Var_ComFactibilidadTxt                  VARCHAR(100);

-- Variables Financiera Zafy
DECLARE Var_EstadoIns                           VARCHAR(100);
DECLARE Var_MuniInst                            VARCHAR(150);
DECLARE Var_LocInst                             VARCHAR(200);
DECLARE Var_DirUEAU                             VARCHAR(150);
DECLARE Var_TelefonoUEAU                        VARCHAR(45);
DECLARE Var_TelOtrasCiuUEAU                     VARCHAR(45);
DECLARE Var_TitularUEAU                         VARCHAR(100);
DECLARE Var_FechaInicio                         DATE;
DECLARE Var_FechaTraspVenc                      DATE;
DECLARE Var_PeriodCap           INT(11);
DECLARE Var_PeriodInt           INT(11);
DECLARE Var_FrecCapital         CHAR(1);
DECLARE Var_FrecInteres         CHAR(1);
DECLARE Var_FrecuenciaTxt       VARCHAR(30);
DECLARE Var_ForCobComision      CHAR(1);
DECLARE Var_NumEmpleado         VARCHAR(20);    -- Numero de Empleado de nomina
DECLARE Var_EsNomina            CHAR(1);        -- El producto de es de Nomina  o No
DECLARE Var_TelTrabCliente      VARCHAR(20);    -- Telefono del Trabajo del Cliente
DECLARE Var_ExtTelCliente       VARCHAR(6);     -- Extension del Telefono de trabajo del cliente
DECLARE Var_EmpresaNomina        VARCHAR(200);  -- Nombre de la Empresa de Nomina
DECLARE Var_MontoComAp          DECIMAL(12,2);  -- Monto Comision por Apertura
DECLARE Var_ComRepTarjeta       DECIMAL(14,2);  -- Monto Comision por Reposicion de Tarjeta
DECLARE Var_RecImp              DECIMAL(14,2);  -- Monto Comison Reclamacion Improcedente
DECLARE Var_ComRepTarjetaTxt    VARCHAR(100);   -- Monto Comision Reposicion de Tarjeta Texto
DECLARE Var_RecImpTxt           VARCHAR(100);   -- Monto Comision Reclamacion Improcedente Texto
DECLARE Var_ForCobPrepago       VARCHAR(100);       -- Forma de Cobro de Prepago
DECLARE Var_CobSegCuota         CHAR(1);        -- Cobra seguro por cuotas
DECLARE Var_TelefonoInst        VARCHAR(20);    -- Telefono Institucion
DECLARE Var_BancoCaptacionID    INT(11);        -- ID Banco Captacion
DECLARE Var_BancoCaptacion      VARCHAR(100);   -- Nombre Banco Captacion
DECLARE Var_RFCpm               CHAR(13);       -- RFC Persona Moral
DECLARE Var_MunicipioEscPub     VARCHAR(150);   -- Municipio de la Escritura Publica
DECLARE Var_RazonSocialCli      VARCHAR(150);   -- Razon Social del Cliente
DECLARE Var_MontoSeguroCuota    DECIMAL(12,2);  -- Monto del Seguro por Cuota
DECLARE Var_IVASeguroCuota      DECIMAL(12,2);  -- IVA del Seguro por Cuota
DECLARE Var_CobraFaltaPago      CHAR(1);
DECLARE Var_CriterioComFalPago  CHAR(1);
DECLARE Var_TipCobComFalPago    CHAR(1);
DECLARE Var_PerCobComFalPago    CHAR(1);
DECLARE Var_TipoComision        CHAR(1);
DECLARE Var_MontoComisionFalPag DECIMAL(12,4);
DECLARE Var_ComisionCobranzaTxt VARCHAR(200);
DECLARE Var_FechaTermino        DATE;
DECLARE Var_ValComGarHipo       DECIMAL(14,2);
DECLARE Var_ValComGarReal       DECIMAL(14,2);
DECLARE Var_FolioGarHipo        INT(11);
DECLARE Var_FolioGarReal        INT(11);
--  Accion y evolucion 
DECLARE TipoAccyEvol                            INT;
DECLARE Sol_Proyecto                            VARCHAR(500);
DECLARE ProCre_Monto                            VARCHAR(100);
DECLARE Cre_FechaVenc                           VARCHAR(100);
DECLARE Cre_DescPag                             VARCHAR(300);
DECLARE Cre_Perio                               VARCHAR(100);
DECLARE AmortCre_FechExig                       DATE;
DECLARE Cre_FechaDesem                          VARCHAR(100);
DECLARE Var_PlazoaMeses                         VARCHAR(100);
DECLARE Cli_NumEscP                             VARCHAR(100);
DECLARE Cli_NumEscC                             VARCHAR(100);
DECLARE Var_FechaInicioAmort					DATE;			--  Fecha de inicio de la primer amortizacion
DECLARE Var_MontoDesQuinc						DECIMAL(14,2);
DECLARE Var_MontoDesQuincLetra					VARCHAR(100);
DECLARE Var_EncabezadoUno						VARCHAR(200);
DECLARE Var_EncabezadoDos						VARCHAR(500);
-- Declaracion de Constantes
DECLARE Cadena_Vacia                            CHAR(1);
DECLARE Var_Vacio                               CHAR(1);
DECLARE Entero_Cero                             INT;
DECLARE Decimal_Cero                            DECIMAL(12,2);
DECLARE Fecha_Vacia                             DATE;
DECLARE Est_Activo                              CHAR(1);
DECLARE Int_Presiden                            INT;
DECLARE Tipo_Anexo                              INT;
DECLARE Tipo_EncContrato                        INT;
DECLARE Tipo_PagoLibre                          CHAR(1);
DECLARE Tipo_PagoIgual                          CHAR(1);
DECLARE ReportYanga                             INT(11);
DECLARE CalendarioPagos                         INT(11);
DECLARE Avales                                  INT(11);
DECLARE Contador                                INT(11);
DECLARE asterisco                               VARCHAR(100);
DECLARE DirOficial                              CHAR(1);
DECLARE GarantiaPrendaria                       INT(11);
DECLARE GarantiaHipotecaria                     INT(11);
DECLARE GarantiaDeUso                           INT(11);
DECLARE TipoDocumFactura                        INT(11);
DECLARE TipoGarantiaMob                         INT(11);
DECLARE TipoDocumTestimonio                     INT(11);
DECLARE TipoGarantiaInmob                       INT(11);
DECLARE TipoDocumActa                           INT(11);
DECLARE TipoDocumConstancia                     INT(11);
DECLARE limiteTabla                             INT(11);
DECLARE FirmaAvales                             INT(11);
DECLARE Tipo_AnexoTR                            INT(11);
DECLARE PlanPagosYanga                          INT(11);
DECLARE Tipo_ContratoTLR                        INT(11);
DECLARE CobroAnticipado                         CHAR(1);
DECLARE CobroDeduccion                          CHAR(1);
DECLARE CobroFinanciamiento                     CHAR(1);
DECLARE DocIdentificacion                       INT(11);
DECLARE DocComprobanteDom                       INT(11);
DECLARE DocComprobanteIngr                      INT(11);
DECLARE DocServicioFederal                      INT(11);
DECLARE DocEdoCuenta                            INT(11);
DECLARE NVecesTasaOrd                           CHAR(1);
DECLARE TasaFijaAnualizada                      CHAR(1);
DECLARE DireccionOficial                        CHAR(1);
DECLARE Con_TipoIdenti                          INT;
DECLARE Var_ModalidadSegVid                     CHAR(1);
DECLARE Var_ForCobroSegVida                     CHAR(1);
DECLARE Var_ProducCreditoID                     INT;
DECLARE ModalidadEsquema                        CHAR(1);
DECLARE PersonaFisica                           CHAR(1);
DECLARE PersonaMoral                            CHAR(1);
DECLARE DirOficialSI                            CHAR(1);
DECLARE TipoMasAlternativa                      INT;
DECLARE var_FechaFinMora                        DATE;
DECLARE var_DiasPlazo                           INT;
DECLARE TipoOrderExpress                        INT;
DECLARE CobMoraNVeces                           CHAR(1);
DECLARE Garantia_Hipotecaria                    INT(11);
DECLARE Garantia_Real                           INT(11);
DECLARE Bloqueado                               CHAR(1);
DECLARE TipoBloqueado                           INT(11);
DECLARE Constante_NO                            CHAR(1);
DECLARE Secc_Garante                            INT(11);
DECLARE Est_Pagado                              CHAR(1);

--  CONSTANTES SECCION MAS ALTERNATIVA 
DECLARE RequiereAvales                          CHAR(1);
DECLARE AvalAutorizado                          CHAR(1);
DECLARE Cliente                                 INT;
DECLARE Aval                                    INT;
DECLARE Prospecto                               INT;
--  ---------------------------------- 
-- PARA FEMAZA
DECLARE Tipo_AnexoFEMAZA                        INT(2);
DECLARE Var_TelInst                             VARCHAR(20);
DECLARE Var_DirFis                              VARCHAR(500);
DECLARE Var_TipCobComMorato                     CHAR(1);
DECLARE Var_CorreoUEAU                          VARCHAR(45);
-- Seccion FEMAZA para Banco
DECLARE Var_NombreCorto                         VARCHAR(45);
DECLARE Var_CtaSucursal                         VARCHAR(100);
DECLARE Var_CueClabe                            CHAR(18);
-- Seccion FEMAZA para Datos de la Escritura
DECLARE Var_EscrituraRPP                        VARCHAR(50);
DECLARE Var_LocalidadRegPub                     INT(11);
DECLARE Var_NomLocRP                            VARCHAR(150);
DECLARE Var_FolioRegPub                         VARCHAR(10);
DECLARE Var_EstadoIDReg                         INT(11);
DECLARE Var_FechaRegPub                         DATE;
DECLARE Var_FechaEsc                            DATE;
DECLARE Var_EscrituraPublic                     VARCHAR(50);
DECLARE Var_VolumenEsc                          VARCHAR(20);
DECLARE Var_NomNotario                          VARCHAR(100);
DECLARE Var_Notaria                             INT(11);
DECLARE Var_LocalidadEsc                        VARCHAR(150);
DECLARE Var_NomLocEsc                           VARCHAR(150);
DECLARE Var_EstadoIDEsc                         INT(11);
DECLARE Var_NomEstEsc                           VARCHAR(100);
DECLARE Var_TxtNotaria1                         VARCHAR(200);
DECLARE Var_TxtNotaria2                         VARCHAR(200);
DECLARE Var_TxtFecha1                           VARCHAR(200);
DECLARE Var_TxtFecha2                           VARCHAR(200);
DECLARE Var_CreClienteID                        INT;
DECLARE Var_DirSucursal				VARCHAR(300);
DECLARE Var_tipopro                             VARCHAR(30);

--  vairables frecuencias
DECLARE Masculino                               CHAR;
DECLARE Femenino                                CHAR;
DECLARE TxtMasculino                            VARCHAR(20);
DECLARE TxtFemenino                             VARCHAR(20);
DECLARE DestComercial                           CHAR;
DECLARE DestConsumo                             CHAR;
DECLARE DestHipotecario                         CHAR;
DECLARE TxtMexico                               VARCHAR(10);
DECLARE NoAplica                                VARCHAR(15);
DECLARE TxtComercial                            VARCHAR(15);

DECLARE TxtConsumo                              VARCHAR(15);
DECLARE TxtHipotecario                          VARCHAR(15);
DECLARE CredNuevo                               CHAR;
DECLARE CredReestruct                           CHAR;
DECLARE CredRenovacion                          CHAR;
DECLARE TxtNuevo                                VARCHAR(15);
DECLARE TxtReestruct                            VARCHAR(15);
DECLARE TxtRenovacion                           VARCHAR(15);
DECLARE DiaFinMes                               CHAR;
DECLARE DiaDelMes                               CHAR;

DECLARE PersonaAmbas                            CHAR;
DECLARE EstSoltero                              CHAR;
DECLARE EstCasado                               CHAR;
DECLARE EstCasBienSep                           CHAR(2);
DECLARE EstCasBienMan                           CHAR(2);
DECLARE EstcasBienManCap                        CHAR(2);
DECLARE EstViudo                                CHAR(2);
DECLARE EstDivorciado                           CHAR(2);
DECLARE EstSeparado                             CHAR(2);
DECLARE EsteUnionLibre                          CHAR;

DECLARE TxtSoltero                              VARCHAR(50);
DECLARE TxtCasado                               VARCHAR(50);
DECLARE TxtCasBienSep                           VARCHAR(50);
DECLARE TxtCasBienMan                           VARCHAR(50);
DECLARE TxtcasBienManCap                        VARCHAR(50);
DECLARE TxtViudo                                VARCHAR(50);
DECLARE TxtDivorciado                           VARCHAR(50);
DECLARE TxtSeparado                             VARCHAR(50);
DECLARE TxteUnionLibre                          VARCHAR(50);
DECLARE TxtNum                                  VARCHAR(9);

DECLARE TxtNumInt                               VARCHAR(9);
DECLARE TxtCol                                  VARCHAR(9);
DECLARE TxtCP                                   VARCHAR(9);
DECLARE TxtComaEsp                              VARCHAR(9);
DECLARE TxtAnios                                VARCHAR(9);
DECLARE TxtMixtas                               VARCHAR(9);
DECLARE TipoUnico                               VARCHAR(9);
DECLARE TxtPorPeriodo                           VARCHAR(20);
DECLARE FrecSemanal                             CHAR;
DECLARE FrecCatorcenal                          CHAR;

DECLARE FrecQuincenal                           CHAR;
DECLARE FrecMensual                             CHAR;
DECLARE FrecPeriodica                           CHAR;
DECLARE FrecBimestral                           CHAR;
DECLARE FrecTrimestral                          CHAR;
DECLARE FrecTetramestral                        CHAR;
DECLARE FrecSemestral                           CHAR;
DECLARE FrecAnual                               CHAR;
DECLARE FrecUnico                               CHAR;
DECLARE FrecDecenal                             CHAR;

DECLARE FrecLibre                               CHAR;
DECLARE TxtLibre                                VARCHAR(10);
DECLARE TxtLibres                               VARCHAR(10);
DECLARE TextUnico                               VARCHAR(10);
DECLARE TxtSemanal                              VARCHAR(20);
DECLARE TxtCatorcenal                           VARCHAR(20);
DECLARE TxtQuincenal                            VARCHAR(20);
DECLARE TxtMensual                              VARCHAR(20);
DECLARE TxtPeriodica                            VARCHAR(20);
DECLARE TxtBimestral                            VARCHAR(20);

DECLARE TxtTrimestral                           VARCHAR(20);
DECLARE TxtTetramestral                         VARCHAR(20);
DECLARE TxtSemestral                            VARCHAR(20);
DECLARE TxtAnual                                VARCHAR(20);
DECLARE TxtDecenal                              VARCHAR(20);
DECLARE TxtSemanas                              VARCHAR(20);
DECLARE TxtCatorcenas                           VARCHAR(20);
DECLARE TxtQuincenas                            VARCHAR(20);
DECLARE TxtMeses                                VARCHAR(20);

DECLARE TxtBimestres                            VARCHAR(20);
DECLARE TxtTimestres                            VARCHAR(20);
DECLARE TxtTrimestres                           VARCHAR(20);
DECLARE TxtTetramestres                         VARCHAR(20);
DECLARE TxtSemestres                            VARCHAR(20);
DECLARE TxtUnico                                VARCHAR(40);
DECLARE TxtDecenas                              VARCHAR(20);
DECLARE TxtSemanales                            VARCHAR(20);
DECLARE TxtCatorcenales                         VARCHAR(20);
DECLARE TxtQuincenales                          VARCHAR(20);

DECLARE TxtMensuales                            VARCHAR(20);
DECLARE TxtPeriodos                             VARCHAR(20);
DECLARE TxtBimestrales                          VARCHAR(20);
DECLARE TxtTrimestrales                         VARCHAR(20);
DECLARE TxtTetramestrales                       VARCHAR(20);
DECLARE TxtSemestrales                          VARCHAR(20);
DECLARE TxtAnuales                              VARCHAR(20);
DECLARE TxtDecenales                            VARCHAR(20);
DECLARE TxtSemana                               VARCHAR(20);

DECLARE TxtCatorcena                            VARCHAR(20);
DECLARE TxtQuincena                             VARCHAR(20);
DECLARE TxtMes                                  VARCHAR(20);
DECLARE TxtPeriodo                              VARCHAR(20);
DECLARE TxtBimestre                             VARCHAR(20);
DECLARE TxtTrimestre                            VARCHAR(20);
DECLARE TxtTetramestre                          VARCHAR(20);
DECLARE TxtSemestre                             VARCHAR(20);
DECLARE TxtAnio                                 VARCHAR(20);
DECLARE TxtDecena                               VARCHAR(20);

DECLARE TxtEnero                                VARCHAR(20);
DECLARE TxtFebrero                              VARCHAR(20);
DECLARE TxtMarzo                                VARCHAR(20);
DECLARE TxtAbril                                VARCHAR(20);
DECLARE TxtMayo                                 VARCHAR(20);
DECLARE TxtJunio                                VARCHAR(20);
DECLARE TxtJulio                                VARCHAR(20);
DECLARE TxtAgosto                               VARCHAR(20);
DECLARE TxtSeptiembre                           VARCHAR(20);
DECLARE TxtOctubre                              VARCHAR(20);

DECLARE TxtNoviembre                            VARCHAR(20);
DECLARE TxtDiciembre                            VARCHAR(20);
DECLARE   mes1                                  CHAR(1);
DECLARE     mes2                                CHAR(1);
DECLARE     mes3                                CHAR(1);
DECLARE     mes4                                CHAR(1);
DECLARE     mes5                                CHAR(1);
DECLARE     mes6                                CHAR(1);
DECLARE     mes7                                CHAR(1);
DECLARE     mes8                                CHAR(1);
DECLARE     mes9                                CHAR(1);
DECLARE     mes10                               CHAR(2);
DECLARE     mes11                               CHAR(2);
DECLARE     mes12                               CHAR(2);

DECLARE Des_Soltero                             CHAR(50);
DECLARE Des_CasBieSep                           CHAR(50);
DECLARE Des_CasBieMan                           CHAR(50);
DECLARE Des_CasCapitu                           CHAR(50);
DECLARE Des_Viudo                               CHAR(50);
DECLARE Des_Divorciad                           CHAR(50);
DECLARE Des_Seperados                           CHAR(50);
DECLARE Des_UnionLibre                          CHAR(50);

--  Constantes  Alternativa 19
DECLARE TipoAlternativa                         INT;
DECLARE Tipo_AvalesAlternativa                  INT;
DECLARE Tipo_AvalesContratAlternativa           INT;
DECLARE TxtNacionM                              CHAR(1);
DECLARE TxtNacionE                              CHAR(1);
DECLARE TxtMexicana                             VARCHAR(15);
DECLARE TxtExtranjera                           VARCHAR(15);
DECLARE TextoCasado                             CHAR(6);

-- Constantes Financiera ZAFY

DECLARE TipoZafy                                INT(11);
DECLARE ActaConstitutiva                        CHAR(1);
DECLARE ActaPoderes                             CHAR(1);
DECLARE PagoCapital                             CHAR(1);
DECLARE CuotasInmediatas                        CHAR(1);
DECLARE ProrrateoPago                           CHAR(1);
DECLARE PagoCapitalTxt                          VARCHAR(50);
DECLARE CuotasInmediatasTxt                     VARCHAR(50);
DECLARE ProrrateoPagoTxt                        VARCHAR(50);
DECLARE SiCobraFaltaPago                        CHAR(1);
DECLARE ComisionMonto                           CHAR(1);
DECLARE CuotaCompProyectada                     CHAR(1);
DECLARE CuotaCompProyectadaTxt                  VARCHAR(50);


-- SOFIEXPRESS
DECLARE MontoCredH                              VARCHAR(100);
DECLARE CatDec                                  DECIMAL(5,1);
DECLARE HTasaFija                               DECIMAL(5,2);
DECLARE HNTasa                                  DECIMAL(7,2);
DECLARE HTasaMora                               DECIMAL(5,2);
DECLARE HVar_TipCobComMorato                    CHAR(1);
DECLARE Var_FechaLimitePago                     VARCHAR(20);
DECLARE Var_FechaInicioPago                     VARCHAR(20);

DECLARE TipoAsefimex							INT(11);
DECLARE Var_LugarNacimiento						VARCHAR(110);
DECLARE Var_TasaAnualLetras						VARCHAR(100);
DECLARE Var_TasaMoratoriaLetras					VARCHAR(100);
DECLARE Var_FechaCompleta						VARCHAR(100);
DECLARE Var_MontoPagoLetra						VARCHAR(300);
-- CURSOR para sacar datos de los avales del credito si los tuviera
DECLARE CURSORAVALES CURSOR FOR
SELECT  IFNULL(AP.AvalID,Entero_Cero),
    IFNULL(C.ClienteID,Entero_Cero) AS ClienteID,
    IFNULL(P.ProspectoID,Entero_Cero) AS ProspectoID,

    CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID= Entero_Cero THEN
      A.NombreCompleto
    ELSE
      CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID <> Entero_Cero AND AP.ProspectoID= Entero_Cero  THEN
        C.NombreCompleto
      ELSE
        CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID = Entero_Cero  AND AP.ProspectoID<> Entero_Cero THEN
          P.NombreCompleto
        ELSE
          CASE WHEN  AP.AvalID <> Entero_Cero AND   AP.ClienteID <> Entero_Cero   THEN
            A.NombreCompleto
          ELSE
            CASE WHEN  AP.AvalID <> Entero_Cero AND   AP.ProspectoID <> Entero_Cero THEN
              A.NombreCompleto
              ELSE
                CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID <> Entero_Cero AND AP.ProspectoID != Entero_Cero  THEN
                C.NombreCompleto
              END
            END
          END
        END
      END
    END
    AS Nombre,

    CASE WHEN AP.ClienteID <> Entero_Cero THEN
      (SELECT   DireccionCompleta
        FROM  DIRECCLIENTE
        WHERE ClienteID = AP.ClienteID
        LIMIT 1)
    ELSE
      CASE WHEN AP.AvalID <> Entero_Cero  THEN
        (SELECT   DireccionCompleta
          FROM  AVALES
          WHERE AvalID = AP.AvalID)
            ELSE
                CASE WHEN AP.ProspectoID<> 0 THEN
                    (SELECT CONCAT(IFNULL(Calle,''), ', ', IFNULL(NumExterior,''),', ', IFNULL(Colonia,''),' , ', IFNULL(Mun.Nombre,''),', ',IFNULL(Est.Nombre,'') )
                        FROM PROSPECTOS P ,
                            ESTADOSREPUB Est,
                            MUNICIPIOSREPUB Mun
                        WHERE  P.EstadoID = Est.EstadoID
                        AND P.MunicipioID = Mun.MunicipioID
                        AND Mun.EstadoID= Est.EstadoID
                        AND ProspectoID = AP.ProspectoID
                    )
                END
      END
    END
    AS DireccionCompleta,

    CASE WHEN AP.ClienteID <> Entero_Cero  THEN
      C.RFCOficial
    ELSE
      CASE WHEN AP.ProspectoID <> Entero_Cero THEN
        P.RFC
      ELSE
        CASE WHEN AP.AvalID<>Entero_Cero AND A.TipoPersona=PersonaFisica THEN
          A.RFC
        ELSE
          CASE WHEN AP.AvalID<>Entero_Cero AND A.TipoPersona=PersonaMoral THEN
            A.RFCpm
          END
        END
      END
    END
    AS RFC,

    C.CURP,

    YEAR(CURDATE())-YEAR( CASE WHEN AP.ClienteID <> Entero_Cero THEN
                  C.FechaNacimiento
                ELSE
                  CASE WHEN AP.ProspectoID <> Entero_Cero THEN
                    P.FechaNacimiento
                  ELSE
                    CASE WHEN AP.AvalID<>Entero_Cero THEN
                      A.FechaNac
                    END
                  END
                END)
    AS Edad,
    Descripcion,
    Ide.NumIdentific,

    CASE WHEN AP.ClienteID <> Entero_Cero THEN
      C.EstadoCivil
    ELSE
      CASE WHEN AP.ProspectoID <> Entero_Cero THEN
        P.EstadoCivil
      ELSE
        CASE WHEN AP.AvalID<>Entero_Cero THEN
          A.EstadoCivil
        END
      END
    END
    EstadoCivil
  FROM        AVALESPORSOLICI AP
    LEFT OUTER JOIN AVALES A        ON AP.AvalID = A.AvalID
    LEFT OUTER JOIN CLIENTES C        ON AP.ClienteID = C.ClienteID
    LEFT OUTER JOIN PROSPECTOS P      ON AP.ProspectoID = P.ProspectoID
    INNER JOIN    SOLICITUDCREDITO Sol  ON Sol.SolicitudCreditoID = AP.SolicitudCreditoID
    INNER JOIN    CREDITOS Cre      ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
    LEFT OUTER JOIN IDENTIFICLIENTE Ide   ON Ide.ClienteID = C.ClienteID AND Ide.Oficial = DirOficial
    WHERE Cre.CreditoID = Par_CreditoID;

DECLARE CURSORGARANTIAS CURSOR FOR
SELECT  Gar.TipoGarantiaID,
    Gar.TipoDocumentoID,
    Asi.MontoAsignado,
    Gar.ValorComercial
  FROM      CREDITOS Cre
    INNER JOIN  PRODUCTOSCREDITO Pro  ON Pro.ProducCreditoID = Cre.ProductoCreditoID
        INNER JOIN  CLIENTES Cli      ON Cli.ClienteID = Cre.ClienteID
    INNER JOIN  DIRECCLIENTE Dir    ON Dir.ClienteID = Cre.ClienteID
    INNER JOIN  ASIGNAGARANTIAS Asi   ON Asi.SolicitudCreditoID = Cre.SolicitudCreditoID
    INNER JOIN  GARANTIAS Gar     ON Gar.GarantiaID = Asi.GarantiaID
  WHERE Cre.CreditoID =Par_CreditoID
    AND Dir.Oficial=DirOficialSI;
--  CURSOR PARA OBTENER GARANTIAS MAS ALTERNATIVA
DECLARE CURSORGARANTIASMA CURSOR FOR
SELECT  Gar.Observaciones,
    Gar.TipoDocumentoID,
    Gar.TipoGarantiaID,
    Tip.Descripcion,
    Gar.FechaRegistro,
    Gar.SerieFactura,
    Cla.EsGarantiaReal
FROM GARANTIAS Gar
  INNER JOIN    ASIGNAGARANTIAS   Asi ON Asi.GarantiaID     = Gar.GarantiaID
  INNER JOIN    SOLICITUDCREDITO  Sol ON Sol.SolicitudCreditoID = Asi.SolicitudCreditoID
  INNER JOIN    CREDITOS      Cre ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
  LEFT OUTER JOIN TIPOSDOCUMENTOS   Tip ON Tip.TipoDocumentoID    = Gar.TipoDocumentoID
  LEFT OUTER JOIN CLASIFGARANTIAS   Cla ON  Cla.TipoGarantiaID    = Gar.TipoGarantiaID
                      AND Cla.ClasifGarantiaID  = Gar.ClasifGarantiaID
WHERE Cre.CreditoID   = Par_CreditoID;
DECLARE CURSORAVAL_STF CURSOR FOR
  SELECT
    CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <>  Entero_Cero THEN
            C.NombreCompleto
        ELSE
            CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                    A.NombreCompleto
                ELSE
                    P.NombreCompleto
            END
    END AS  Aval_NombreCompleto,
    CASE  WHEN  IFNULL(AP.ClienteID, Entero_Cero) <>  Entero_Cero THEN
        CONCAT( C.PrimerNombre,
            CASE  WHEN  IFNULL(C.SegundoNombre,Cadena_Vacia) <> Cadena_Vacia  THEN  CONCAT(' ',C.SegundoNombre)
              ELSE  Cadena_Vacia
            END,
            CASE  WHEN  IFNULL(C.TercerNombre,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(' ',C.TercerNombre)
              ELSE  Cadena_Vacia
            END
        )
    ELSE
        CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <>  Entero_Cero THEN
            CONCAT( A.PrimerNombre,
                CASE  WHEN  IFNULL(A.SegundoNombre,Cadena_Vacia) <> Cadena_Vacia  THEN  CONCAT(' ',A.SegundoNombre)
                  ELSE  Cadena_Vacia
                END,
                CASE  WHEN  IFNULL(A.TercerNombre,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(' ',A.TercerNombre)
                  ELSE  Cadena_Vacia
                END
            )
        ELSE
            CONCAT( P.PrimerNombre,
                CASE  WHEN  IFNULL(P.SegundoNombre,Cadena_Vacia) <> Cadena_Vacia  THEN  CONCAT(' ',P.SegundoNombre)
                  ELSE  Cadena_Vacia
                END,
                CASE  WHEN  IFNULL(P.TercerNombre,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(' ',P.TercerNombre)
                  ELSE  Cadena_Vacia
                END
            )
        END
    END AS Aval_Nombres,
    CASE  WHEN Cc.TipoPersona <> PersonaMoral AND IFNULL(Cc.TipoPersona, Cadena_Vacia) <> Cadena_Vacia THEN
      CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          C.ApellidoPaterno
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
              A.ApellidoPaterno
          ELSE
              P.ApellidoPaterno
          END
      END
    ELSE
      Cadena_Vacia
    END AS Aval_ApellidoPaterno,
    CASE  WHEN Cc.TipoPersona <> PersonaMoral AND IFNULL(Cc.TipoPersona, Cadena_Vacia) <> Cadena_Vacia THEN
      CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          C.ApellidoMaterno
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
              A.ApellidoMaterno
          ELSE
              P.ApellidoMaterno
          END
      END
    ELSE
      Cadena_Vacia
    END AS Aval_ApellidoMaterno,
    CASE  WHEN Cc.TipoPersona <> PersonaMoral AND IFNULL(Cc.TipoPersona, Cadena_Vacia) <> Cadena_Vacia THEN
      CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          CASE  WHEN  C.Sexo  = Masculino THEN  TxtMasculino
              ELSE  TxtFemenino
          END
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
              CASE  WHEN  A.Sexo  = Masculino THEN  TxtMasculino
                  ELSE  TxtFemenino
              END
          ELSE
              CASE  WHEN  P.Sexo  = Masculino THEN  TxtMasculino
                  ELSE  TxtFemenino
              END
          END
      END
    ELSE
      Cadena_Vacia
    END AS Aval_Sexo,
    CASE  WHEN Cc.TipoPersona <> PersonaMoral AND IFNULL(Cc.TipoPersona, Cadena_Vacia) <> Cadena_Vacia THEN
      CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          FORMATEAFECHACONTRATO(C.FechaNacimiento)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
              FORMATEAFECHACONTRATO(A.FechaNac)
          ELSE
              FORMATEAFECHACONTRATO(P.FechaNacimiento)
          END
      END
    ELSE
      Cadena_Vacia
    END AS Aval_FechaNacimiento,
    CASE  WHEN Cc.TipoPersona <> PersonaMoral AND IFNULL(Cc.TipoPersona, Cadena_Vacia) <> Cadena_Vacia THEN
      CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          YEAR(Var_FechaSistema) - YEAR(C.FechaNacimiento)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
              YEAR(Var_FechaSistema) - YEAR(A.FechaNac)
          ELSE
              YEAR(Var_FechaSistema) - YEAR(P.FechaNacimiento)
          END
      END
    ELSE
      Cadena_Vacia
    END AS Aval_Edad,
    CASE  WHEN Cc.TipoPersona <> PersonaMoral AND IFNULL(Cc.TipoPersona, Cadena_Vacia) <> Cadena_Vacia THEN
      CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          CASE WHEN IFNULL(C.RFCOficial,Cadena_Vacia) <>  Cadena_Vacia  THEN  C.RFCOficial
          ELSE
            CASE WHEN IFNULL(C.CURP, Cadena_Vacia) <> Cadena_Vacia  THEN  C.CURP
              ELSE  Cadena_Vacia
            END
          END
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
              CASE  WHEN  IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaMoral  THEN
                  CASE  WHEN  IFNULL(A.RFCpm,Cadena_Vacia) <> Cadena_Vacia  THEN  A.RFCpm
                      ELSE  Cadena_Vacia
                  END
              ELSE
                  CASE WHEN IFNULL(A.RFC,Cadena_Vacia) <> Cadena_Vacia  THEN  A.RFC
                    ELSE  Cadena_Vacia
                  END
              END
          ELSE
              CASE  WHEN  IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaMoral  THEN
                  CASE WHEN IFNULL(P.RFCpm,Cadena_Vacia) <> Cadena_Vacia  THEN  P.RFCpm
                    ELSE  Cadena_Vacia
                  END
              ELSE
                  CASE WHEN IFNULL(P.RFC,Cadena_Vacia)  <> Cadena_Vacia THEN  P.RFC
                    ELSE  Cadena_Vacia
                  END
              END
          END
      END
    ELSE
      Cadena_Vacia
    END AS Aval_RFC,
    CASE  WHEN Cc.TipoPersona <> PersonaMoral AND IFNULL(Cc.TipoPersona, Cadena_Vacia) <> Cadena_Vacia THEN
      CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(CAST(Oc.Descripcion AS CHAR),Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
              Cadena_Vacia
          ELSE
              IFNULL(CAST(Op.Descripcion AS CHAR),Cadena_Vacia)
          END
      END
    ELSE
      Cadena_Vacia
    END AS Aval_Ocupacion,
    CASE  WHEN Cc.TipoPersona <> PersonaMoral AND IFNULL(Cc.TipoPersona, Cadena_Vacia) <> Cadena_Vacia THEN
      CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(C.Correo,Cadena_Vacia)
      ELSE
          Cadena_Vacia
      END
    ELSE
      Cadena_Vacia
    END AS Aval_Correo,
    CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
        IFNULL(Dc.DireccionCompleta,Cadena_Vacia)
    ELSE
        CASE  WHEN IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero THEN
                A.DireccionCompleta
            ELSE
                CONCAT(
                    IFNULL(P.Calle,Cadena_Vacia),
                    CASE  WHEN IFNULL(P.NumExterior,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(TxtNum,P.NumExterior)
                        ELSE  Cadena_Vacia
                    END,
                    CASE  WHEN IFNULL(P.NumInterior,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(TxtNumInt,P.NumInterior)
                        ELSE  Cadena_Vacia
                    END,
                    CASE  WHEN IFNULL(P.NumInterior,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(TxtNumInt,P.NumInterior)
                        ELSE  Cadena_Vacia
                    END,
                    CASE  WHEN IFNULL(P.Colonia,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(TxtCol,P.Colonia)
                        ELSE  Cadena_Vacia
                    END,
                    CASE  WHEN IFNULL(P.CP,Cadena_Vacia) <> Cadena_Vacia  THEN  CONCAT(TxtCP,P.CP)
                        ELSE  Cadena_Vacia
                    END,
                    CASE  WHEN IFNULL(LP.NombreLocalidad,Cadena_Vacia) <> Cadena_Vacia  THEN  CONCAT(', ',LP.NombreLocalidad)
                        ELSE  Cadena_Vacia
                    END,
                    CASE  WHEN IFNULL(EP.Nombre,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(', ',EP.Nombre)
                        ELSE  Cadena_Vacia
                    END
                )
        END
    END AS Aval_DomicilioCompleto,
    CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
        CONCAT(
            IFNULL(Dc.Calle,Cadena_Vacia),
            CASE  WHEN IFNULL(Dc.NumeroCasa,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(TxtNum,Dc.NumeroCasa)
                ELSE  Cadena_Vacia
            END,
            CASE  WHEN IFNULL(Dc.NumInterior,Cadena_Vacia) <> Cadena_Vacia  THEN  CONCAT(TxtNumInt,Dc.NumInterior)
                ELSE  Cadena_Vacia
            END
        )
    ELSE
        CASE  WHEN IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero THEN
                CONCAT(
                    IFNULL(A.Calle,Cadena_Vacia),
                    CASE  WHEN IFNULL(A.NumExterior,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(TxtNum,A.NumExterior)
                        ELSE  Cadena_Vacia
                    END,
                    CASE  WHEN IFNULL(A.NumInterior,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(TxtNumInt,A.NumInterior)
                        ELSE  Cadena_Vacia
                    END
                )
            ELSE
                CONCAT(
                    IFNULL(P.Calle,Cadena_Vacia),
                    CASE  WHEN IFNULL(P.NumExterior,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(TxtNum,P.NumExterior)
                        ELSE  Cadena_Vacia
                    END,
                    CASE  WHEN IFNULL(P.NumInterior,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(TxtNumInt,P.NumInterior)
                        ELSE  Cadena_Vacia
                    END
                )
        END
    END AS Aval_Domicilio,
    CASE  WHEN Cc.TipoPersona <> PersonaMoral AND IFNULL(Cc.TipoPersona, Cadena_Vacia) <> Cadena_Vacia THEN
      CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(Dc.Colonia,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(A.Colonia,Cadena_Vacia)
              ELSE
                  IFNULL(P.Colonia,Cadena_Vacia)
          END
      END
    ELSE
      Cadena_Vacia
    END AS Aval_Colonia,
    CASE  WHEN Cc.TipoPersona <> PersonaMoral AND IFNULL(Cc.TipoPersona, Cadena_Vacia) <> Cadena_Vacia THEN
      CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(LC.NombreLocalidad,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(LA.NombreLocalidad,Cadena_Vacia)
              ELSE
                  IFNULL(LP.NombreLocalidad,Cadena_Vacia)
          END
      END
    ELSE
      Cadena_Vacia
    END AS Aval_Ciudad,
    CASE  WHEN Cc.TipoPersona <> PersonaMoral AND IFNULL(Cc.TipoPersona, Cadena_Vacia) <> Cadena_Vacia THEN
      CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(EC.Nombre,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(EA.Nombre,Cadena_Vacia)
              ELSE
                  IFNULL(EP.Nombre,Cadena_Vacia)
          END
      END
    ELSE
      Cadena_Vacia
    END AS Aval_Estado,
    CASE  WHEN Cc.TipoPersona <> PersonaMoral AND IFNULL(Cc.TipoPersona, Cadena_Vacia) <> Cadena_Vacia THEN
      CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(Dc.CP,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(A.CP,Cadena_Vacia)
              ELSE
                  IFNULL(P.CP,Cadena_Vacia)
          END
      END
    ELSE
      Cadena_Vacia
    END AS Aval_CP,
    CASE  WHEN Cc.TipoPersona <> PersonaMoral AND IFNULL(Cc.TipoPersona, Cadena_Vacia) <> Cadena_Vacia THEN
      CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          CONCAT(
              CASE  WHEN IFNULL(CONVERT(SC.TiempoHabitarDom, CHAR),Cadena_Vacia) <> Cadena_Vacia  AND IFNULL(CONVERT(SC.TiempoHabitarDom, CHAR),Cadena_Vacia) <> CONVERT(Entero_Cero,CHAR)
                    THEN  CONCAT(CONVERT(SC.TiempoHabitarDom, CHAR),' AÑOS')
                  ELSE  Cadena_Vacia
              END
          )
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  Cadena_Vacia
              ELSE
                  CONCAT(
                      CASE  WHEN IFNULL(CONVERT(SP.TiempoHabitarDom, CHAR),Cadena_Vacia) <> Cadena_Vacia  AND IFNULL(CONVERT(SP.TiempoHabitarDom, CHAR),Cadena_Vacia) <> CONVERT(Entero_Cero,CHAR)
                              THEN  CONCAT(CONVERT(SP.TiempoHabitarDom, CHAR),' AÑOS')
                          ELSE  Cadena_Vacia
                      END
                  )
          END
      END
    ELSE
      Cadena_Vacia
    END AS Aval_TiempoRadicar,
    CASE  WHEN Cc.TipoPersona <> PersonaMoral AND IFNULL(Cc.TipoPersona, Cadena_Vacia) <> Cadena_Vacia THEN
      CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(C.Telefono,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(A.Telefono,Cadena_Vacia)
              ELSE
                  IFNULL(P.Telefono,Cadena_Vacia)
          END
      END
    ELSE
      Cadena_Vacia
    END AS Aval_TelCasa,
    CASE  WHEN Cc.TipoPersona <> PersonaMoral AND IFNULL(Cc.TipoPersona, Cadena_Vacia) <> Cadena_Vacia THEN
      CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(C.TelefonoCelular,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(A.TelefonoCel,Cadena_Vacia)
              ELSE
                  Cadena_Vacia
          END
      END
    ELSE
      Cadena_Vacia
    END AS Aval_Celular
    FROM  AVALESPORSOLICI AP
        INNER JOIN    CREDITOS      Cre ON  Cre.SolicitudCreditoID  = AP.SolicitudCreditoID
        INNER JOIN    SOLICITUDCREDITO  Sol ON  Sol.SolicitudCreditoID  = AP.SolicitudCreditoID
        LEFT OUTER JOIN CLIENTES      Cc  ON  Cc.ClienteID      = Cre.ClienteID
        LEFT OUTER JOIN CLIENTES      C ON  C.ClienteID       = AP.ClienteID
        LEFT OUTER JOIN AVALES        A ON  A.AvalID        = AP.AvalID
        LEFT OUTER JOIN PROSPECTOS      P ON  P.ProspectoID     = AP.ProspectoID
        LEFT OUTER JOIN OCUPACIONES     Oc  ON  Oc.OcupacionID      = C.OcupacionID
        LEFT OUTER JOIN OCUPACIONES     Op  ON  Op.OcupacionID      = P.OcupacionID
        LEFT OUTER JOIN DIRECCLIENTE    Dc  ON  Dc.ClienteID      = AP.ClienteID
                            AND Dc.Oficial        = DirOficial
        LEFT OUTER JOIN LOCALIDADREPUB    LC  ON  LC.LocalidadID      = Dc.LocalidadID
                            AND LC.MunicipioID      = Dc.MunicipioID
                            AND LC.EstadoID       = Dc.EstadoID
        LEFT OUTER JOIN LOCALIDADREPUB    LA  ON  LA.LocalidadID      = A.LocalidadID
                            AND LA.MunicipioID      = A.MunicipioID
                            AND LA.EstadoID       = A.EstadoID
        LEFT OUTER JOIN LOCALIDADREPUB    LP  ON  LP.LocalidadID      = P.LocalidadID
                            AND LP.MunicipioID      = P.MunicipioID
                            AND LP.EstadoID       = P.EstadoID
        LEFT OUTER JOIN ESTADOSREPUB    EC  ON  EC.EstadoID       = Dc.EstadoID
        LEFT OUTER JOIN ESTADOSREPUB    EA  ON  EA.EstadoID       = A.EstadoID
        LEFT OUTER JOIN ESTADOSREPUB    EP  ON  EP.EstadoID       = P.EstadoID
        LEFT OUTER JOIN SOCIODEMOVIVIEN   SC  ON  SC.ClienteID      = C.ClienteID
        LEFT OUTER JOIN SOCIODEMOVIVIEN   SP  ON  SP.ClienteID      = P.ClienteID
      WHERE Cre.CreditoID = Par_CreditoID;


DECLARE CURSORAVALSTFSIMPLE CURSOR FOR
  SELECT  AvalNombreCompleto, AvalDireccionCompleta
  FROM TMPAVALESSTF
  WHERE TransaccionID = Var_NumeroTransaccion;



-- Asignacion de Constantes
SET Cadena_Vacia                := '';              -- String Vacio
SET Fecha_Vacia                 := '1900-01-01';    -- Fecha Vacia
SET Entero_Cero                 := 0;               -- Entero en Cero
SET Decimal_Cero                := 0.0;       -- DECIMAL en Cero
SET Est_Activo                  := 'A';             -- Estatus del Integrante: Activo
SET TipoDocumFactura            := 12;              -- Tipo Documento FACTURA
SET TipoGarantiaMob             := 2;               -- Tipo Garantia MOBILIARIA
SET TipoDocumTestimonio         := 13;              -- Tipo Documento TESTIMONIO NOTARIAL
SET TipoGarantiaInmob           := 3;               -- Tipo Garantia INMOBILIARIA
SET TipoDocumActa               := 14;              -- Tipo Documento ACTA DE POSESION
SET TipoDocumConstancia         := 77;              -- Tipo Documento CONSTANCIA DE POSESION
SET Int_Presiden                := 1;               -- Tipo de Integrante: Presidente
SET Tipo_Anexo                  := 1;               -- Tipo de Contrato: Anexo
SET Tipo_EncContrato            := 2;       -- Tipo de Contrato: Encabezado de Contrato (datos generaeles)
SET ReportYanga                 := 3;       -- Se ocupa para el reporte de yanga
SET CalendarioPagos             := 4;       -- se muestran las fechas exigibles y el capital
SET Avales                      := 5;       -- se muestran los avales del credito
SET GarantiaPrendaria           := 6;       -- consulta las garantias prendarias
SET GarantiaHipotecaria         := 7;       -- consulta las garantias hipotecarias
SET GarantiaDeUso               := 8;               -- consulta las garantias de uso
SET FirmaAvales                 := 9;               -- consulta de firma de avales
SET Tipo_AnexoTR                := 10;              -- Tipo de Contrato: Anexo Tres Reyes
SET Tipo_AnexoFEMAZA            := 11;        -- Tipo de Contrato: FEMAZA
SET PlanPagosYanga              := 14;        -- Se ocupa para el reporte de yanga donde se muestra el plan de pagos
SET Tipo_ContratoTLR            := 15;        -- Tipo de Contrato: Contrato TLR
SET TipoMasAlternativa          := 16;
SET TipoSanaTusFinanzas         := 17;        -- XPICU
SET TablaAmortizacionSanaTusFinanzas  := 18;        -- XPICU
SET TipoContratoSanaTusFinanzas       := 19;        -- XPICU
SET TipoAvalesSTFc              := 20;        -- XPICU
SET TipoAvalesSTFs              := 21;        -- XPICU
SET TipoOrderExpress            := 22;        -- tipo sofiexpress
SET TipoAccyEvol                := 23;        -- Accion y evolucion
SET Tipo_ContratoFinSocial      := 24;        -- Caratula Contrato fin social
SET Tipo_AvalesFinSocial        := 25;
SET TipoAlternativa             := 26;        -- Reporte Tipo Alternativa 19
SET Tipo_AvalesAlternativa      := 27;         -- Tipo Avales Alternativa 19
SET Tipo_AvalesContratAlternativa   := 28;      -- Tipo Avales para el Contrato Alternativa 19
SET TipoZafy                        := 29;      -- reporte Tipo Financiera Zafy
SET TipoAsefimex					:= 34;
SET Var_Vacio                   := '';
SET Tipo_PagoLibre              := 'L';
SET Tipo_PagoIgual              := 'I';
SET DirOficial                  := 'S';
SET Contador                    := 0;
SET limiteTabla                 := 0;
SET Var_FechaHoraServidor       := NOW();
SET CobroAnticipado             := 'A';             -- Forma Cobro Comision por Anticipado
SET CobroDeduccion              := 'D';       -- Forma Cobro Comision por Deduccion
SET CobroFinanciamiento         := 'F';       -- Forma Cobro Comision por Finaanciamiento
SET DocIdentificacion           := 2;         -- Documento Identificacion
SET DocComprobanteDom           := 3;           -- Documento Comprobante Domicilio
SET DocComprobanteIngr          := 79;              -- Documento Comprobante Ingresos
SET DocServicioFederal          := 80;              -- Documento Servicio Federal
SET DocEdoCuenta                := 81;              -- Documento Estado Cuenta
SET NVecesTasaOrd               := 'N';       -- Tipo Cobro de Moratorios N veces la tasa Ordinaria
SET TasaFijaAnualizada          := 'T';       -- Tipo Cobro de Moratorios Tasa Fija Anualizada
SET Var_FechaSistema            := (SELECT FechaSistema FROM PARAMETROSSIS);
SET DireccionOficial            := 'S';
SET Con_TipoIdenti              := 1;
SET ModalidadEsquema            := 'T';
SET PersonaFisica               := 'F';
SET PersonaMoral                := 'M';
SET DirOficialSI                := 'S';
SET Constante_SI                := 'S';
SET CobMoraNVeces               := 'N';
SET Garantia_Hipotecaria        := 30;
SET Garantia_Real               := 31;
SET Garantia_Liquida            := 32;
SET Bloqueado                   := 'B';
SET TipoBloqueado               := 8;
SET Constante_NO                := 'N';
SET Secc_Garante                := 33;
SET Est_Pagado                  := 'P';         -- Estatus Pagado

-- INICIALIZACION CONSTANTES SECCION MAS ALTERNATIVA 
SET RequiereAvales              := 'S';     -- El tipo de Credito requiere Aval
SET AvalAutorizado              := 'U';     -- Indica que esta AUTORIZADO
SET Cliente                     := 100;
SET Aval                        := 10;
SET Prospecto                   := 1;
SET Cadena_Default              :='NoAplica';
--  ------------------------------------------------ 



SET Masculino                   := 'M';
SET Femenino                    := 'F';
SET TxtMasculino                := 'MASCULINO';
SET TxtFemenino                 := 'FEMENINO';
SET DestComercial               := 'C';
SET DestConsumo                 := 'O';
SET DestHipotecario             := 'H';
SET TxtComercial                := 'COMERCIAL';
SET TxtConsumo                  := 'CONSUMO';
SET TxtHipotecario              := 'HIPOTECARIO';

SET CredNuevo                   := 'N';
SET CredReestruct               := 'R';
SET CredRenovacion              := 'O';
SET TxtNuevo                    := 'Nuevo';
SET TxtReestruct                := 'Reestructura';
SET TxtRenovacion               := 'Renovacion';
SET TxtMexico                   := 'MEXICO';
SET NoAplica                    := 'NO APLICA';
SET DiaFinMes                   := 'F';
SET DiaDelMes                   := 'D';

SET PersonaAmbas                := 'A';
SET TxtLibre                    := 'Libre';
SET TxtLibres                   := 'Libres';
SET TextUnico                   := 'Unico';
SET TxtPorPeriodo               := 'POR PERIODO';
SET EstSoltero                  := 'S';
SET EstCasBienSep               := 'CS';
SET EstCasBienMan               := 'CM';
SET EstcasBienManCap            := 'CC';
SET EstViudo                    := 'V';

SET EstDivorciado               := 'D';
SET EstSeparado                 := 'SE';
SET EsteUnionLibre              := 'U';
SET TxtSoltero                  := 'SOLTERO';
SET TxtCasBienSep               := 'CASADO BIENES SEPARADOS';
SET TxtCasBienMan               := 'CASADO BIENES MANCOMUNADOS';
SET TxtcasBienManCap            := 'CASADO BIENES MANCOMUNADOS CON CAPITULACION';
SET TxtViudo                    := 'VIUDO';
SET TxtDivorciado               := 'DIVORCIADO';
SET TxtSeparado                 := 'SEPARADO';
SET TxteUnionLibre              := 'UNION LIBRE';
SET TxtNum                      :=', NO. ';
SET TxtNumInt                   :=', INT. ';
SET TxtCol                      :=', COL. ';
SET TxtCP                       :=', C.P. ';
SET TxtComaEsp                  :=', ';
SET TxtMixtas                   := 'mixtas';
SET TipoUnico                   := 'unico';
SET FrecSemanal                 :='S' ;

SET FrecCatorcenal              :='C' ;
SET FrecQuincenal               :='Q' ;
SET FrecMensual                 :='M' ;
SET FrecPeriodica               :='P' ;
SET FrecBimestral               :='B' ;
SET FrecTrimestral              :='T' ;
SET FrecTetramestral            :='R' ;
SET FrecSemestral               :='E' ;
SET FrecAnual                   :='A' ;
SET FrecUnico                   :='U' ;

SET FrecLibre                   := 'L';
SET FrecDecenal                 :='D' ;
SET TxtSemanal                  := 'semanal' ;
SET TxtCatorcenal               := 'catorcenal' ;
SET TxtQuincenal                := 'quincenal' ;
SET TxtMensual                  := 'mensual' ;
SET TxtPeriodica                := 'periodica'   ;
SET TxtBimestral                := 'bimestral' ;
SET TxtTrimestral               := 'trimestral' ;
SET TxtTetramestral             := 'tetramestral' ;

SET TxtSemestral                := 'semestral';
SET TxtAnual                    := 'anual';
SET TxtDecenal                  := 'decenal';
SET TxtSemanas                  := 'semanas'  ;
SET TxtCatorcenas               := 'catorcenas' ;
SET TxtQuincenas                := 'quincenas' ;
SET TxtMeses                    := 'meses' ;
SET TxtPeriodos                 := 'periodos';
SET TxtBimestres                := 'bimestres' ;
SET TxtTrimestres               := 'trimestres' ;

SET TxtTetramestres             := 'tetramestres' ;
SET TxtSemestres                := 'semestres';
SET TxtAnios                    := 'años';
SET TxtUnico                    := 'Pago al vencimiento';
SET TxtDecenas                  := 'decenas';
SET TxtSemanales                :=  'semanales'  ;
SET TxtCatorcenales             :=  'catorcenales' ;
SET TxtQuincenales              :=  'quincenales' ;
SET TxtMensuales                :=  'mensuales' ;
SET TxtBimestrales              :=  'bimestrales' ;
SET TxtTrimestrales             := 'trimestrales' ;
SET TxtTetramestrales           := 'tetramestrales' ;
SET TxtSemestrales              := 'semestrales';
SET TxtAnuales                  := 'anuales';
SET TxtDecenales                := 'decenales';
SET TxtSemana                   := 'semana';
SET TxtCatorcena                := 'catorcena';
SET TxtQuincena                 := 'quincena';

SET TxtMes                      := 'mes';
SET TxtPeriodo                  := 'periodo';
SET TxtBimestre                 := 'bimestre';
SET TxtTrimestre                := 'trimestre';
SET TxtTetramestre              := 'tetramestre';
SET TxtSemestre                 := 'semestre';
SET TxtAnio                     := 'año';
SET TxtDecena                   := 'decena';
SET TxtEnero                    := 'Enero';
SET TxtFebrero                  := 'Febrero';

SET TxtMarzo                    := 'Marzo';
SET TxtAbril                    := 'Abril';
SET TxtMayo                     := 'Mayo';
SET TxtJunio                    := 'Junio';
SET TxtJulio                    := 'Julio';
SET TxtAgosto                   := 'Agosto';
SET TxtSeptiembre               := 'Septiembre';
SET TxtOctubre                  := 'Octubre';
SET TxtNoviembre                := 'Noviembre';
SET TxtDiciembre                := 'Diciembre';

SET mes1                := 1; -- correspondiente a enero
SET mes2                := 2; -- correspondiente a febrero
SET mes3                := 3; -- correspondiente a marzo
SET mes4                := 4; -- correspondiente a abril
SET mes5                := 5; -- correspondiente a mayo
SET mes6                := 6; -- correspondiente a junio
SET mes7                := 7; -- correspondiente a julio
SET mes8                := 8; -- correspondiente a agosto
SET mes9                := 9; -- correspondiente a septiembre
SET mes10               := 10; -- correspondiente a octubre
SET mes11               := 11; -- correspondiente a noviembre
SET mes12               := 12; -- correspondiente a diciembre
SET Con_Reestructura    := 'R';
SET EstDesembolsada     := 'D';

-- Constantes Alternativa 19

SET TxtNacionM          := 'N';
SET TxtNacionE          := 'E';
SET TxtMexicana         := 'Mexicana';
SET TxtExtranjera       := 'Extranjera';
SET TextoCasado         := 'CASADO';

-- Asignacion de Constantes Financiera ZAFY
SET ActaConstitutiva        := 'C';
SET ActaPoderes             := 'P';
SET PagoCapital             := 'U';
SET CuotasInmediatas        := 'I';
SET ProrrateoPago           := 'V';
SET PagoCapitalTxt          := 'Pago de capital a ultimas cuotas';
SET CuotasInmediatasTxt     := 'A las cuotas siguientes inmediatas' ;
SET ProrrateoPagoTxt        := 'Prorrateo de pago en cuotas vivas';
SET SiCobraFaltaPago        := 'S';
SET ComisionMonto           := 'M';
SET CuotaCompProyectada     := 'P';
SET CuotaCompProyectadaTxt  := 'Pago Cuotas Completas Proyectadas';



DROP TABLE IF EXISTS TMPAVALES;
CREATE TEMPORARY TABLE TMPAVALES(
  Tmp_AvalID          INT(11),
  Tmp_ClienteID       INT(11),
  Tmp_ProspectoID     INT(11),
  Tmp_Nombre          VARCHAR(400),
  Tmp_Direccion       VARCHAR(400),
  Tmp_RFC             VARCHAR(20),
  Tmp_CURP            VARCHAR(20),
  Tmp_Edad            INT(11),
  Tmp_NombreIdent     VARCHAR(100),
  Tmp_NumIdent        VARCHAR(100),
  Tmp_EstadoCivil     VARCHAR(50)
);

-- Tipo de Reporte Anexi
IF (Par_TipoReporte = Tipo_Anexo) THEN
  SELECT Edo.Nombre ,Mu.Nombre INTO Var_NombreEstadom,Var_NombreMuni
  FROM  SUCURSALES Suc,
  ESTADOSREPUB Edo,
  CREDITOS Cre,
                  MUNICIPIOSREPUB Mu
  WHERE Cre.CreditoID = Par_CreditoID
  AND Cre.SucursalID = Suc.SucursalID
  AND Suc.EstadoID = Edo.EstadoID
  AND Edo.EstadoID = Mu.EstadoID
          AND Mu.MunicipioID=Suc.MunicipioID;

    SET Var_TasaAnual   := Entero_Cero;
    SET Var_TasaMens    := Entero_Cero;
    SET Var_TasaFlat    := Entero_Cero;
    SET Var_MontoSeguro := Entero_Cero;
    SET Var_PorcCobert  := Entero_Cero;


    SELECT  TasaFija, CreditoID,  NumAmortizacion,  MontoCredito,
  PeriodicidadInt,  FrecuenciaInt,  FrecuenciaCap,  MontoSeguroVida
  INTO  Var_TasaAnual,  Var_CreditoID,  Var_NumAmorti,      Var_MontoCred,
  Var_Periodo,        Var_FrecuenciaInt,  Var_Frecuencia,   Var_MontoSeguro
  FROM CREDITOS
  WHERE CreditoID=Par_CreditoID;

    SET Var_TasaAnual   := IFNULL(Var_TasaAnual, Entero_Cero);
    SET Var_CreditoID   := IFNULL(Var_CreditoID, Entero_Cero);
    SET Var_NumAmorti   := IFNULL(Var_NumAmorti, Entero_Cero);

    SET Var_TasaMens    := ROUND(Var_TasaAnual / 12, 4);

    SELECT  SUM(Amo.Interes) INTO Var_TotInteres
        FROM AMORTICREDITO Amo
        WHERE Amo.CreditoID = Par_CreditoID;

    SET Var_TotInteres  := IFNULL(Var_TotInteres, Entero_Cero);
    SET Var_TasaFlat    := ( ( (Var_TotInteres / Var_NumAmorti) / Var_MontoCred ) /
                                Var_Periodo ) * 30 * 100;
    SET Var_TasaFlat    := ROUND(Var_TasaFlat, 4);

    SELECT  Cre.ValorCAT,     ROUND(Cre.PorcGarLiq,2), Pro.FactorRiesgoSeguro,Pro.RegistroRECA,   Cre.FechaVencimien,
      CONCAT(Cli.PrimerNombre,
                    (CASE WHEN IFNULL(Cli.SegundoNombre, '') != '' THEN CONCAT(' ', Cli.SegundoNombre)
                          ELSE Cadena_Vacia
                     END),
                   (CASE WHEN IFNULL(Cli.TercerNombre, '') != '' THEN  CONCAT(' ', Cli.TercerNombre)
                         ELSE Cadena_Vacia
                    END), ' ',Cli.ApellidoPaterno, ' ', Cli.ApellidoMaterno
      ),          Pro.Descripcion,    Pro.CobraMora,      Pro.FactorMora,   Pro.RequiereGarantia,
      Cli.ClienteID,    Pro.MontoPolSegVida,  Cre.TipCobComMorato,  Pro.Modalidad,    Cre.ForCobroSegVida,
      Pro.ProducCreditoID
  INTO  Var_CAT,          Var_PorcGarLiq,     Var_FacRiesgo,      Var_NumRECA,      Var_FechaVenc,
      Var_NomRepres,    Var_DescProducto,   Var_CobraMora,      Var_FactorMora,   Var_ReqGarantia,
      Var_ClienteID,    Var_PolizaDelSeguro,  Var_TipoCobroMoratorio, Var_ModalidadSegVid,Var_ForCobroSegVida,
      Var_ProducCreditoID
        FROM CREDITOS Cre,
             PRODUCTOSCREDITO Pro,
             CLIENTES Cli
        WHERE Cre.CreditoID = Var_CreditoID
          AND Cre.ProductoCreditoID  = Pro.ProducCreditoID
          AND Cre.ClienteID = Cli.ClienteID;

    SET Var_CAT  := IFNULL(Var_CAT, Entero_Cero);
    SET Var_PorcGarLiq  := IFNULL(Var_PorcGarLiq, Entero_Cero);
    SET Var_FacRiesgo  := IFNULL(Var_FacRiesgo, Entero_Cero);

  SELECT TipoPagoCapital INTO Var_TipoPagoCap
  FROM CREDITOS
  WHERE CreditoID=Par_CreditoID;

  SET Var_ClienteID := IFNULL(Var_ClienteID, Entero_Cero);


--  Se obtienen los valores cuando el seguro de vida esta parametrizado por esquemas de cobro
  IF(Var_ModalidadSegVid = ModalidadEsquema) THEN
    SELECT  FactorRiesgoSeguro,      MontoPolSegVida
      INTO    Var_FacRiesgo,   Var_PolizaDelSeguro
        FROM   ESQUEMASEGUROVIDA
          WHERE ProducCreditoID = Var_ProducCreditoID
            AND TipoPagoSeguro = Var_ForCobroSegVida;
  END IF;


  -- SECCION FCAMACHO
  IF(Var_ClienteID <> Entero_Cero) THEN
  SELECT Cli.NombreCompleto, Cli.RFC, Dir.DireccionCompleta, Idf.NumIdentific
      INTO Var_NombreCompleto, Var_RFCOficial,Var_DirecCliente, Var_NumIdent
        FROM CLIENTES Cli
          LEFT JOIN DIRECCLIENTE Dir
          ON Cli.ClienteID = Dir.ClienteID AND Dir.Oficial = DireccionOficial
          LEFT JOIN IDENTIFICLIENTE Idf
          ON Idf.ClienteID = Cli.ClienteID AND Idf.TipoIdentiID = Con_TipoIdenti
  WHERE Cli.ClienteID = Var_ClienteID;


  END IF;
-- -----------

  IF(Var_TipoPagoCap=Tipo_PagoLibre OR Var_FrecuenciaInt != Var_Frecuencia)THEN
  SET Var_DesFrecLet = TxtMixtas;
  ELSE
    SELECT  CASE
                WHEN Var_Frecuencia = FrecSemanal        THEN TxtSemanal
                WHEN Var_Frecuencia = FrecCatorcenal     THEN TxtCatorcenal
                WHEN Var_Frecuencia = FrecQuincenal      THEN TxtQuincenal
                WHEN Var_Frecuencia = FrecMensual        THEN TxtMensual
                WHEN Var_Frecuencia = FrecPeriodica      THEN TxtPeriodica
                WHEN Var_Frecuencia = FrecBimestral      THEN TxtBimestral
                WHEN Var_Frecuencia = FrecTrimestral     THEN TxtTrimestral
                WHEN Var_Frecuencia = FrecTetramestral   THEN TxtTetramestral
                WHEN Var_Frecuencia = FrecSemestral      THEN TxtSemestral
                WHEN Var_Frecuencia = FrecAnual          THEN TxtAnual
        WHEN Var_Frecuencia = FrecDecenal        THEN TxtDecenal
            END INTO Var_DesFrec;

    SET Var_DesFrec     := IFNULL(Var_DesFrec, Cadena_Vacia);

    SELECT  CONCAT(CONVERT(Var_NumAmorti, CHAR), ' ' ,
            CASE
                WHEN Var_Frecuencia = FrecSemanal        THEN TxtSemanas
                WHEN Var_Frecuencia = FrecCatorcenal     THEN TxtCatorcenas
                WHEN Var_Frecuencia = FrecQuincenal      THEN TxtQuincenas
                WHEN Var_Frecuencia = FrecMensual        THEN TxtMeses
                WHEN Var_Frecuencia = FrecPeriodica      THEN TxtPeriodos
                WHEN Var_Frecuencia = FrecBimestral      THEN TxtBimestres
                WHEN Var_Frecuencia = FrecTrimestral     THEN TxtTrimestres
                WHEN Var_Frecuencia = FrecTetramestral   THEN TxtTetramestres
                WHEN Var_Frecuencia = FrecSemestral      THEN TxtSemestres
                WHEN Var_Frecuencia = FrecAnual         THEN TxtAnios
                WHEN Var_Frecuencia = FrecUnico         THEN TxtUnico
        WHEN Var_Frecuencia = FrecDecenal        THEN TxtDecenas

            END ) INTO Var_Plazo;
    SELECT  CASE
                WHEN Var_Frecuencia = FrecSemanal        THEN TxtSemanales
                WHEN Var_Frecuencia = FrecCatorcenal     THEN TxtCatorcenales
                WHEN Var_Frecuencia = FrecQuincenal      THEN TxtQuincenales
                WHEN Var_Frecuencia = FrecMensual        THEN TxtMensuales
                WHEN Var_Frecuencia = FrecPeriodica      THEN TxtPeriodos
                WHEN Var_Frecuencia = FrecBimestral      THEN TxtBimestrales
                WHEN Var_Frecuencia = FrecTrimestral     THEN TxtTrimestrales
                WHEN Var_Frecuencia = FrecTetramestral   THEN TxtTetramestrales
                WHEN Var_Frecuencia = FrecSemestral      THEN TxtSemestrales
                WHEN Var_Frecuencia = FrecAnual         THEN TxtAnuales
                WHEN Var_Frecuencia = FrecUnico            THEN TxtUnico
        WHEN Var_Frecuencia = FrecDecenal        THEN TxtDecenales
  WHEN Var_Frecuencia =FrecLibre THEN TxtMixtas

            END INTO Var_DesFrecLet;
 END IF;
  SELECT COUNT(CreditoID) INTO Var_NumCuotas
  FROM AMORTICREDITO Amo
  WHERE Amo.CreditoID = Par_CreditoID;

    SET Var_MontoSeguro := IFNULL(Var_MontoSeguro, Entero_Cero);
    SET Var_MontoGarLiq := ROUND(Var_MontoCred * Var_PorcGarLiq / 100, 2);
   SET Var_MonGarLiq  := FORMAT(Var_MontoGarLiq,2);

    SELECT SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres) INTO Var_TotPagar
        FROM CREDITOS Cre,
             AMORTICREDITO Amo
        WHERE Cre.CreditoID   = Par_CreditoID
          AND Amo.CreditoID = Cre.CreditoID;

    SET Var_TotPagar    := IFNULL(Var_TotPagar, Entero_Cero);

    SELECT FUNCIONNUMLETRAS(Var_TotPagar)     INTO Var_TotPagLetra;
    SELECT FUNCIONNUMLETRAS(Var_MontoCred)    INTO Var_MtoLetra;
    SELECT FUNCIONNUMLETRAS(Var_MontoGarLiq)  INTO Var_GarantiaLetra;
  SELECT FUNCIONNUMLETRAS(Var_MontoSeguro)  INTO Var_SeguroLetra;
  SELECT FUNCIONNUMLETRAS(Var_PolizaDelSeguro)  INTO Var_PolDelSeguroLetra;
  SELECT FUNCIONNUMEROSLETRAS(Var_NumCuotas)  INTO Var_CuotasLetra;

    SET Var_PorcCobert  :=  ROUND((Var_FacRiesgo / 7 * Var_Periodo * 1000), 4);
    SELECT  CASE
                WHEN Var_Frecuencia = FrecSemanal        THEN TxtSemana
                WHEN Var_Frecuencia = FrecCatorcenal     THEN TxtCatorcena
                WHEN Var_Frecuencia = FrecQuincenal      THEN TxtQuincena
                WHEN Var_Frecuencia = FrecMensual        THEN TxtMes
                WHEN Var_Frecuencia = FrecPeriodica      THEN TxtPeriodo
                WHEN Var_Frecuencia = FrecBimestral      THEN TxtBimestre
                WHEN Var_Frecuencia = FrecTrimestral     THEN TxtTrimestre
                WHEN Var_Frecuencia = FrecTetramestral   THEN TxtTetramestre
                WHEN Var_Frecuencia = FrecSemestral      THEN TxtSemestre
                WHEN Var_Frecuencia = FrecAnual         THEN TxtAnio
        WHEN Var_Frecuencia = FrecDecenal        THEN TxtDecena

            END  INTO Var_FrecSeguro;

  SELECT DAY(Var_FechaVenc) ,   YEAR(Var_FechaVenc) , CASE
  WHEN MONTH(Var_FechaVenc) = mes1  THEN TxtEnero
  WHEN MONTH(Var_FechaVenc) = mes2  THEN TxtFebrero
  WHEN MONTH(Var_FechaVenc) = mes3  THEN TxtMarzo
  WHEN MONTH(Var_FechaVenc) = mes4  THEN TxtAbril
  WHEN MONTH(Var_FechaVenc) = mes5  THEN TxtMayo
  WHEN MONTH(Var_FechaVenc) = mes6  THEN TxtJunio
  WHEN MONTH(Var_FechaVenc) = mes7  THEN TxtJulio
  WHEN MONTH(Var_FechaVenc) = mes8  THEN TxtAgosto
  WHEN MONTH(Var_FechaVenc) = mes9  THEN TxtSeptiembre
  WHEN MONTH(Var_FechaVenc) = mes10 THEN TxtOctubre
  WHEN MONTH(Var_FechaVenc) = mes11 THEN TxtNoviembre
  WHEN MONTH(Var_FechaVenc) = mes12 THEN TxtDiciembre END

  INTO  Var_DiaVencimiento, Var_AnioVencimiento,  Var_MesVencimiento;

    SET Var_MontoCredito := CONCAT('$ ', FORMAT(Var_MontoCred, 2), ', (', Var_MtoLetra, ' M.N.)');
    SET MontoTotPagar := CONCAT('$ ', FORMAT(Var_TotPagar, 2), ', (', Var_TotPagLetra, ' M.N.)');

  SELECT  Descripcion INTO Var_DestinoCredito
    FROM SOLICITUDCREDITO Sol,
      DESTINOSCREDITO Des,
      CREDITOS Cre
      WHERE Cre.CreditoID=Par_CreditoID
        AND Sol.DestinoCreID = Des.DestinoCreID
        AND Cre.SolicitudCreditoID = Sol.SolicitudCreditoID;

SET Var_ConsecutivoFirma := (SELECT MAX(Consecutivo) FROM FIRMAREPLEGAL F
   INNER JOIN PARAMETROSSIS P
   ON F.RepresentLegal =
   P.NombreRepresentante);

SELECT FRL.Recurso INTO Var_RecursoFirma
  FROM PARAMETROSSIS PS
    INNER JOIN FIRMAREPLEGAL FRL
      ON PS.NombreRepresentante = FRL.RepresentLegal
      AND FRL.Consecutivo       = Var_ConsecutivoFirma;

  IF(Var_TipoCobroMoratorio = NVecesTasaOrd) THEN
  SET Var_TasaMensMora := (Var_TasaMens * Var_FactorMora);
  ELSE IF(Var_TipoCobroMoratorio = TasaFijaAnualizada) THEN
  SET Var_TasaMensMora := (Var_FactorMora / 12);
  END IF; END IF;

  SELECT   Var_Plazo,          Var_FechaVenc,      Var_DesFrec,         Var_TasaAnual,      Var_TasaMens,
           Var_TasaFlat,       Var_MontoSeguro,    Var_SeguroLetra,     Var_PorcCobert,     Var_CAT,
       Var_PorcGarLiq,     Var_PolizaDelSeguro,Var_PolDelSeguroLetra, Var_MonGarLiq,      Var_NomRepres,
       Var_RecursoFirma,   Var_FrecSeguro,     Var_NumRECA,       Var_DiaVencimiento, Var_AnioVencimiento,
       Var_MesVencimiento, Var_GarantiaLetra,  Var_MontoCred,     Var_MtoLetra, Var_NumAmorti,
       Var_DesFrecLet,     Var_TotPagar,       Var_TotPagLetra,     Var_NombreEstadom,  Var_NombreMuni,
       Var_DescProducto,   Var_CobraMora,    Var_FactorMora,    Var_TasaMensMora,   Var_ReqGarantia,
       Var_NumCuotas,      Var_CuotasLetra,    Var_NombreCompleto,  Var_RFCOficial,   Var_DirecCliente,
  DAY(Var_FechaSistema) AS Var_Dia, CASE MONTH(Var_FechaSistema)
  WHEN mes1  THEN TxtEnero
  WHEN mes2  THEN TxtFebrero
  WHEN mes3  THEN TxtMarzo
  WHEN mes4  THEN TxtAbril
  WHEN mes5  THEN TxtMayo
  WHEN mes6  THEN TxtJunio
  WHEN mes7  THEN TxtJulio
  WHEN mes8  THEN TxtAgosto
  WHEN mes9  THEN TxtSeptiembre
  WHEN mes10 THEN TxtOctubre
  WHEN mes11 THEN TxtNoviembre
  WHEN mes12 THEN TxtDiciembre END AS Var_Mes,
  YEAR(Var_FechaSistema) AS Var_Ano,  Var_NumIdent;

END IF;

IF (Par_TipoReporte = Tipo_EncContrato) THEN

  SELECT
  UPPER(Par.NombreRepresentante), Suc.DirecCompleta,  Cli.Sexo, Cli.Telefono,
  Est.Nombre ,  Cli.RFCOficial, DAY(Par.FechaSistema), YEAR(Par.FechaSistema),

  CASE
  WHEN MONTH(Par.FechaSistema) = mes1  THEN TxtEnero
  WHEN MONTH(Par.FechaSistema) = mes2  THEN TxtFebrero
  WHEN MONTH(Par.FechaSistema) = mes3  THEN TxtMarzo
  WHEN MONTH(Par.FechaSistema) = mes4  THEN TxtAbril
  WHEN MONTH(Par.FechaSistema) = mes5  THEN TxtMayo
  WHEN MONTH(Par.FechaSistema) = mes6  THEN TxtJunio
  WHEN MONTH(Par.FechaSistema) = mes7  THEN TxtJulio
  WHEN MONTH(Par.FechaSistema) = mes8  THEN TxtAgosto
  WHEN MONTH(Par.FechaSistema) = mes9  THEN TxtSeptiembre
  WHEN MONTH(Par.FechaSistema) = mes10 THEN TxtOctubre
  WHEN MONTH(Par.FechaSistema) = mes11 THEN TxtNoviembre
  WHEN MONTH(Par.FechaSistema) = mes12 THEN TxtDiciembre END AS MesSistema
  INTO
  Var_RepresentanteLegal,     Var_DirccionInstitucion,  Var_SexoRepteLegal, Var_TelInstitucion,
  Var_NombreEstado,   Var_RFCOficial ,  Var_DiaSistema,   Var_AnioSistema,
  Var_MesSistema

  FROM  PARAMETROSSIS  Par
  INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Par.SucursalMatrizID
  INNER JOIN CLIENTES Cli   ON Cli.ClienteID  = Par.ClienteInstitucion
  INNER JOIN ESTADOSREPUB Est ON Est.EstadoID   = Suc.EstadoID;



  SELECT  UPPER(Inst.NombreCorto)   INTO Var_NomCortoInstit
    FROM    INSTITUCIONES Inst,PARAMETROSSIS Par
      WHERE   Inst.InstitucionID  = Par.InstitucionID;

  SELECT  Var_RepresentanteLegal,     Var_DirccionInstitucion,  Var_SexoRepteLegal, Var_TelInstitucion,
      Var_NombreEstado,       Var_RFCOficial ,      Var_DiaSistema,   Var_AnioSistema,
      Var_MesSistema,       Var_NomCortoInstit;



END IF;


  -- Reporte personalizado Yanga
IF (Par_TipoReporte=ReportYanga)THEN

    SET Var_TasaAnual   := Entero_Cero;
    SET Var_TasaMens1    := Entero_Cero;
    SET Var_TasaFlat    := Entero_Cero;
    SET Var_MontoSeguro := Entero_Cero;
    SET Var_PorcCobert  := Entero_Cero;
  SET Var_FactorMora1:=Entero_Cero;
  SET Var_FechaHoraServidor := NOW();

    SELECT  TasaFija, CreditoID,  NumAmortizacion,  MontoCredito,
  PeriodicidadInt,  FrecuenciaInt,  FrecuenciaCap,  MontoSeguroVida
  ,CASE WHEN ClasiDestinCred= DestComercial THEN
  TxtComercial
    WHEN ClasiDestinCred= DestConsumo THEN
  TxtConsumo
        WHEN ClasiDestinCred= DestHipotecario THEN
  TxtHipotecario
       END,ClienteID
  INTO  Var_TasaAnual,  Var_CreditoID,  Var_NumAmorti,      Var_MontoCred,
  Var_Periodo,        Var_FrecuenciaInt,  Var_Frecuencia,   Var_MontoSeguro,
  Var_Clasificacion,  Var_ClienteID
  FROM CREDITOS
  WHERE CreditoID=Par_CreditoID;

    SET Var_TasaAnual   := IFNULL(Var_TasaAnual, Entero_Cero);
    SET Var_CreditoID   := IFNULL(Var_CreditoID, Entero_Cero);
    SET Var_NumAmorti   := IFNULL(Var_NumAmorti, Entero_Cero);
    SET Var_TasaMens1    := ROUND(Var_TasaAnual / 12, 2);

    SELECT  SUM(Amo.Interes) INTO Var_TotInteres
        FROM AMORTICREDITO Amo
  WHERE Amo.CreditoID = Par_CreditoID;

    SET Var_TotInteres  := IFNULL(Var_TotInteres, Entero_Cero);
    SET Var_TasaFlat    := ( ( (Var_TotInteres / Var_NumAmorti) / Var_MontoCred ) /
                                Var_Periodo ) * 30 * 100;
    SET Var_TasaFlat    := ROUND(Var_TasaFlat, 4);

    SELECT  Cre.ValorCAT,     ROUND(Cre.PorcGarLiq,2),    Pro.FactorRiesgoSeguro,     Pro.RegistroRECA,   Cre.FechaVencimien,

      CONCAT(Cli.PrimerNombre,
                    (CASE WHEN IFNULL(Cli.SegundoNombre, '') != '' THEN CONCAT(' ', Cli.SegundoNombre)
                          ELSE Cadena_Vacia
                     END),
                   (CASE WHEN IFNULL(Cli.TercerNombre, '') != '' THEN  CONCAT(' ', Cli.TercerNombre)
                         ELSE Cadena_Vacia
                    END), ' ',  Cli.ApellidoPaterno, ' ',Cli.ApellidoMaterno),
            Pro.Descripcion,
            Pro.CobraMora,
      Pro.FactorMora,
            Pro.RequiereGarantia,


            Cli.TelefonoCelular,    Cli.RFCOficial,    Cli.NombreCompleto
  INTO  Var_CAT,       Var_PorcGarLiq,     Var_FacRiesgo,  Var_NumRECA,     Var_FechaVenc,
      Var_NomRepres,
            Var_DescProducto,
            Var_CobraMora,
            Var_FactorMora,
            Var_ReqGarantia,

      Var_TelefonoCelular,    Var_RFCOficial,   Var_NombreCompleto
        FROM CREDITOS Cre,
             PRODUCTOSCREDITO Pro,
             CLIENTES Cli
      WHERE Cre.CreditoID = Var_CreditoID
        AND Cre.ProductoCreditoID  = Pro.ProducCreditoID
        AND Cre.ClienteID = Cli.ClienteID;

    SET Var_CAT  := IFNULL(Var_CAT, Entero_Cero);
    SET Var_PorcGarLiq  := IFNULL(Var_PorcGarLiq, Entero_Cero);
    SET Var_FacRiesgo  := IFNULL(Var_FacRiesgo, Entero_Cero);

  SELECT TipoPagoCapital INTO Var_TipoPagoCap
  FROM CREDITOS
  WHERE CreditoID=Par_CreditoID;

  IF(Var_TipoPagoCap=Tipo_PagoLibre OR Var_FrecuenciaInt != Var_Frecuencia)THEN
  SELECT  CONCAT(CONVERT(Var_NumAmorti,CHAR),' ',
  CASE
  WHEN Var_NumAmorti ='1' THEN 'Amortizacion Libre'
  ELSE 'Amortizaciones Libres'END ) INTO Var_Plazo;
  ELSE
    SELECT  CASE
                WHEN Var_Frecuencia = FrecSemanal       THEN CONCAT( UPPER(SUBSTR( TxtSemanal  ,1,1)),        SUBSTR( TxtSemanal ,2))
                WHEN Var_Frecuencia = FrecCatorcenal    THEN CONCAT( UPPER(SUBSTR( TxtCatorcenal  ,1,1)),        SUBSTR( TxtCatorcenal ,2))
                WHEN Var_Frecuencia = FrecQuincenal     THEN CONCAT( UPPER(SUBSTR( TxtQuincenal  ,1,1)),        SUBSTR( TxtQuincenal ,2))
                WHEN Var_Frecuencia = FrecMensual       THEN CONCAT( UPPER(SUBSTR( TxtMensual  ,1,1)),        SUBSTR( TxtMensual ,2))
                WHEN Var_Frecuencia = FrecPeriodica     THEN CONCAT( UPPER(SUBSTR( TxtPeriodica  ,1,1)),        SUBSTR( TxtPeriodica ,2))
                WHEN Var_Frecuencia = FrecBimestral     THEN CONCAT( UPPER(SUBSTR( TxtBimestral  ,1,1)),        SUBSTR( TxtBimestral ,2))
                WHEN Var_Frecuencia = FrecTrimestral    THEN CONCAT( UPPER(SUBSTR( TxtTrimestral  ,1,1)),        SUBSTR( TxtTrimestral ,2))
                WHEN Var_Frecuencia = FrecTetramestral  THEN CONCAT( UPPER(SUBSTR( TxtTetramestral  ,1,1)),        SUBSTR( TxtTetramestral ,2))
                WHEN Var_Frecuencia = FrecSemestral     THEN CONCAT( UPPER(SUBSTR( TxtSemestral  ,1,1)),        SUBSTR( TxtSemestral ,2))
                WHEN Var_Frecuencia = FrecAnual         THEN CONCAT( UPPER(SUBSTR( TxtAnual  ,1,1)),        SUBSTR( TxtAnual ,2))
                WHEN Var_Frecuencia = FrecLibre         THEN TxtLibre
        WHEN Var_Frecuencia = FrecDecenal       THEN CONCAT( UPPER(SUBSTR( TxtDecenal  ,1,1)),        SUBSTR( TxtDecenal ,2))
            END INTO Var_DesFrec;

    SET Var_DesFrec     := IFNULL(Var_DesFrec, Cadena_Vacia);

    SELECT  CONCAT(CONVERT(Var_NumAmorti, CHAR), ' ' ,
            CASE
                WHEN Var_Frecuencia = FrecSemanal        THEN CONCAT( UPPER(SUBSTR( TxtSemanas  ,1,1)),        SUBSTR( TxtSemanas ,2))
                WHEN Var_Frecuencia = FrecCatorcenal     THEN CONCAT( UPPER(SUBSTR( TxtCatorcenas  ,1,1)),        SUBSTR( TxtCatorcenas ,2))
                WHEN Var_Frecuencia = FrecQuincenal      THEN CONCAT( UPPER(SUBSTR( TxtQuincenas  ,1,1)),        SUBSTR( TxtQuincenas ,2))
                WHEN Var_Frecuencia = FrecMensual        THEN CONCAT( UPPER(SUBSTR( TxtMeses  ,1,1)),        SUBSTR( TxtMeses ,2))
                WHEN Var_Frecuencia = FrecPeriodica      THEN CONCAT( UPPER(SUBSTR( TxtPeriodos  ,1,1)),        SUBSTR( TxtPeriodos ,2))
                WHEN Var_Frecuencia = FrecBimestral      THEN CONCAT( UPPER(SUBSTR( TxtBimestres  ,1,1)),        SUBSTR( TxtBimestres ,2))
                WHEN Var_Frecuencia = FrecTrimestral     THEN CONCAT( UPPER(SUBSTR( TxtTrimestres  ,1,1)),        SUBSTR( TxtTrimestres ,2))
                WHEN Var_Frecuencia = FrecTetramestral   THEN CONCAT( UPPER(SUBSTR( TxtTetramestres  ,1,1)),        SUBSTR( TxtTetramestres ,2))
                WHEN Var_Frecuencia = FrecSemestral      THEN CONCAT( UPPER(SUBSTR( TxtSemestres  ,1,1)),        SUBSTR( TxtSemestres ,2))
                WHEN Var_Frecuencia = FrecAnual          THEN CONCAT( UPPER(SUBSTR( TxtAnios  ,1,1)),        SUBSTR( TxtAnios ,2))
                WHEN Var_Frecuencia = FrecUnico          THEN TxtUnico
        WHEN Var_Frecuencia = FrecDecenal        THEN CONCAT( UPPER(SUBSTR( TxtDecenas  ,1,1)),        SUBSTR( TxtDecenas ,2))
  WHEN Var_Frecuencia =FrecLibre THEN TxtLibres

            END ) INTO Var_Plazo;
    SELECT  CASE
                WHEN Var_Frecuencia = FrecSemanal    THEN CONCAT( UPPER(SUBSTR( TxtSemanales  ,1,1)),        SUBSTR( TxtSemanales ,2))
                WHEN Var_Frecuencia = FrecCatorcenal     THEN CONCAT( UPPER(SUBSTR( TxtCatorcenales  ,1,1)),        SUBSTR( TxtCatorcenales ,2))
                WHEN Var_Frecuencia = FrecQuincenal  THEN CONCAT( UPPER(SUBSTR( TxtQuincenales  ,1,1)),        SUBSTR( TxtQuincenales ,2))
                WHEN Var_Frecuencia = FrecMensual    THEN CONCAT( UPPER(SUBSTR( TxtMensuales  ,1,1)),        SUBSTR( TxtMensuales ,2))
                WHEN Var_Frecuencia = FrecPeriodica  THEN CONCAT( UPPER(SUBSTR( TxtPeriodos  ,1,1)),        SUBSTR( TxtPeriodos ,2))
                WHEN Var_Frecuencia = FrecBimestral  THEN CONCAT( UPPER(SUBSTR( TxtBimestrales  ,1,1)),        SUBSTR( TxtBimestrales ,2))
                WHEN Var_Frecuencia = FrecTrimestral     THEN CONCAT( UPPER(SUBSTR( TxtTrimestrales  ,1,1)),        SUBSTR( TxtTrimestrales ,2))
                WHEN Var_Frecuencia = FrecTetramestral   THEN CONCAT( UPPER(SUBSTR( TxtTetramestrales  ,1,1)),        SUBSTR( TxtTetramestrales ,2))
                WHEN Var_Frecuencia = FrecSemestral  THEN CONCAT( UPPER(SUBSTR( TxtSemestrales  ,1,1)),        SUBSTR( TxtSemestrales ,2))
                WHEN Var_Frecuencia = FrecAnual  THEN CONCAT( UPPER(SUBSTR( TxtAnuales  ,1,1)),        SUBSTR( TxtAnuales ,2))
        WHEN Var_Frecuencia = FrecDecenal    THEN CONCAT( UPPER(SUBSTR( TxtDecenales  ,1,1)),        SUBSTR( TxtDecenales ,2))
  WHEN Var_Frecuencia =FrecLibre THEN TxtLibres

            END INTO Var_DesFrecLet;
 END IF;
  SELECT COUNT(CreditoID) INTO Var_NumCuotas
  FROM AMORTICREDITO Amo
  WHERE Amo.CreditoID = Par_CreditoID;

    SET Var_MontoSeguro := IFNULL(Var_MontoSeguro, Entero_Cero);
    SET Var_MontoGarLiq := ROUND(Var_MontoCred * Var_PorcGarLiq / 100, 2);
  SET Var_MonGarLiq   := FORMAT(Var_MontoGarLiq,2);

    SELECT SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres) INTO Var_TotPagar
        FROM CREDITOS Cre,
             AMORTICREDITO Amo
        WHERE Cre.CreditoID   = Par_CreditoID
          AND Amo.CreditoID = Cre.CreditoID;

    SET Var_TotPagar    := IFNULL(Var_TotPagar, Entero_Cero);

    SELECT FUNCIONNUMLETRAS(Var_TotPagar) INTO Var_TotPagLetra;
    SELECT FUNCIONNUMLETRAS(Var_MontoCred) INTO Var_MtoLetra;
    SELECT FUNCIONNUMLETRAS(Var_MontoGarLiq) INTO Var_GarantiaLetra;



    SET Var_PorcCobert  :=  ROUND((Var_FacRiesgo / 7 * Var_Periodo * 1000), 4);
    SELECT  CASE
                WHEN Var_Frecuencia = FrecSemanal        THEN CONCAT( UPPER(SUBSTR( TxtSemana  ,1,1)),        SUBSTR( TxtSemana ,2))
                WHEN Var_Frecuencia = FrecCatorcenal     THEN CONCAT( UPPER(SUBSTR( TxtCatorcena  ,1,1)),        SUBSTR( TxtCatorcena ,2))
                WHEN Var_Frecuencia = FrecQuincenal      THEN CONCAT( UPPER(SUBSTR( TxtQuincena  ,1,1)),        SUBSTR( TxtQuincena ,2))
                WHEN Var_Frecuencia = FrecMensual        THEN CONCAT( UPPER(SUBSTR( TxtMes  ,1,1)),        SUBSTR( TxtMes ,2))
                WHEN Var_Frecuencia = FrecPeriodica      THEN CONCAT( UPPER(SUBSTR( TxtPeriodo  ,1,1)),        SUBSTR( TxtPeriodo ,2))
                WHEN Var_Frecuencia = FrecBimestral      THEN CONCAT( UPPER(SUBSTR( TxtBimestre  ,1,1)),        SUBSTR( TxtBimestre ,2))
                WHEN Var_Frecuencia = FrecTrimestral     THEN CONCAT( UPPER(SUBSTR( TxtTrimestre  ,1,1)),        SUBSTR( TxtTrimestre ,2))
                WHEN Var_Frecuencia = FrecTetramestral   THEN CONCAT( UPPER(SUBSTR( TxtTetramestre  ,1,1)),        SUBSTR( TxtTetramestre ,2))
                WHEN Var_Frecuencia = FrecSemestral      THEN CONCAT( UPPER(SUBSTR( TxtSemestre  ,1,1)),        SUBSTR( TxtSemestre ,2))
                WHEN Var_Frecuencia = FrecAnual          THEN CONCAT( UPPER(SUBSTR( TxtAnio  ,1,1)),        SUBSTR( TxtAnio ,2))
        WHEN Var_Frecuencia = FrecDecenal        THEN CONCAT( UPPER(SUBSTR( TxtDecena  ,1,1)),        SUBSTR( TxtDecena ,2))

            END  INTO Var_FrecSeguro;

  SELECT DAY(Var_FechaVenc) ,   YEAR(Var_FechaVenc) , CASE
  WHEN MONTH(Var_FechaVenc) = mes1  THEN TxtEnero
  WHEN MONTH(Var_FechaVenc) = mes2  THEN TxtFebrero
  WHEN MONTH(Var_FechaVenc) = mes3  THEN TxtMarzo
  WHEN MONTH(Var_FechaVenc) = mes4  THEN TxtAbril
  WHEN MONTH(Var_FechaVenc) = mes5  THEN TxtMayo  WHEN Var_Frecuencia =FrecSemanal    THEN TxtSemanal
                WHEN Var_Frecuencia =FrecCatorcenal   THEN TxtCatorcenal
                WHEN Var_Frecuencia =FrecQuincenal    THEN TxtQuincenal
                WHEN Var_Frecuencia =FrecMensual    THEN TxtMensual
                WHEN Var_Frecuencia =FrecPeriodica    THEN TxtPeriodica
                WHEN Var_Frecuencia =FrecBimestral    THEN TxtBimestral
                WHEN Var_Frecuencia =FrecTrimestral   THEN TxtTrimestral
                WHEN Var_Frecuencia =FrecTetramestral   THEN TxtTetramestral
                WHEN Var_Frecuencia =FrecSemestral    THEN TxtSemestral
                WHEN Var_Frecuencia =FrecAnual      THEN TxtAnual
        WHEN Var_Frecuencia =FrecUnico      THEN TxtDecenal
                WHEN Var_Frecuencia =FrecDecenal THEN TxtDecenal
  WHEN MONTH(Var_FechaVenc) = mes6  THEN TxtJunio
  WHEN MONTH(Var_FechaVenc) = mes7  THEN TxtJulio
  WHEN MONTH(Var_FechaVenc) = mes8  THEN TxtAgosto
  WHEN MONTH(Var_FechaVenc) = mes9  THEN TxtSeptiembre
  WHEN MONTH(Var_FechaVenc) = mes10 THEN TxtOctubre
  WHEN MONTH(Var_FechaVenc) = mes11 THEN TxtNoviembre
  WHEN MONTH(Var_FechaVenc) = mes12 THEN TxtDiciembre END

  INTO  Var_DiaVencimiento, Var_AnioVencimiento,  Var_MesVencimiento;

    SET Var_MontoCredito  :=  FORMAT(Var_MontoCred, 2);
  SET Var_MontoCreditoAn  :=  CONCAT(FORMAT(Var_MontoCred, 2),'  ', REPLACE(Var_MtoLetra,' CON',' '), ' M.N.');
    SET MontoTotPagar   :=  FORMAT(Var_TotPagar, 2);
  SET Var_FactorMora1 :=  ROUND(Var_FactorMora / 12, 4);
  SELECT DireccionCompleta
    INTO Var_DirecCliente
      FROM DIRECCLIENTE
        WHERE ClienteID=Var_ClienteID LIMIT 1;


  SELECT Ins.Nombre,Ins.Direccion,Par.FechaSistema
    INTO Var_NomInstit,Var_DirecInstit,Var_FechaSistema
      FROM PARAMETROSSIS Par
        INNER JOIN INSTITUCIONES Ins
                ON Ins.InstitucionID=Par.InstitucionID;
  SELECT Descripcion INTO Var_DestinoCredito
    FROM DESTINOSCREDITO Des
      INNER JOIN CREDITOS Cre ON Cre.DestinoCreID=Des.DestinoCreID
        WHERE CreditoID=Par_CreditoID;
  SELECT CONCAT(Mun.Nombre,', ', Est.Nombre), Suc.DirecCompleta
    INTO Var_DireccSucursal, Var_DirecInstit
      FROM SUCURSALES Suc
        INNER JOIN ESTADOSREPUB Est ON Est.EstadoID=Suc.EstadoID
        INNER JOIN MUNICIPIOSREPUB  Mun ON Mun.MunicipioID=Suc.MunicipioID AND Mun.EstadoID=Suc.EstadoID
          WHERE Suc.SucursalID=Aud_Sucursal;

  SET  Var_MtoLetra:=REPLACE(Var_MtoLetra,' CON',' ');
  SET  Var_MtoLetra := CONCAT(CONCAT('( ',Var_MtoLetra),' M.N )'); -- Se concatenan los caracteres con el monto en letras
  SET  Var_LongitudLetras :=LENGTH(Var_MtoLetra); -- se saca la longitud de los caracteres que tiene la variable
  SET  Var_LongitudLetras:=87-Var_LongitudLetras; -- Se resta el nÃºmero de caracteres con 87 ya que es la longitud en la que caben los datos en Mayuscula, tipo de letra Times New Roman y tamaÃ±o 10 en pentaho
  -- Cuando se trata de margenes 50 y 50 laterales
  SET  Var_LongitudLetras :=Var_LongitudLetras/2; -- Se divide en 2 la resta de la longitud de las letras y 87
  SET  asterisco:=''; -- inicializamos el asterisco con un vacio
  ciclo :LOOP -- se inicia el ciclo
  SET Contador :=Contador+1; -- empezamos con el contador en 1
  IF(Contador<=Var_LongitudLetras) THEN -- se compara el contador con la longitud de los caracteres
  SET asterisco := CONCAT(asterisco,'*'); -- Se concatenan los asteriscos
  ELSE
  LEAVE ciclo; -- Salimos del cliclo
  END IF;
  END LOOP ciclo; -- Cerramos el ciclo
  SET  Var_ConcatenadoMonto:= CONCAT(CONCAT(asterisco,Var_MtoLetra),asterisco);--  concatenamos los asteriscos a los lados de la cantidad en letras

   SET Var_NombreRepresentante= (SELECT Usu.NombreCompleto
                            FROM    SUCURSALES Suc
                            INNER JOIN  USUARIOS Usu
                            ON  Suc.NombreGerente=Usu.UsuarioID
                                WHERE SucursalID=Aud_Sucursal);
    SELECT FUNCIONNUMEROSLETRAS(Var_TasaAnual) INTO Var_IntOrdiLetras;
    SELECT FUNCIONNUMEROSLETRAS(Var_FactorMora) INTO Var_IntMorLetras;

  SELECT     Var_Plazo,           Var_FechaVenc,      Var_DesFrec,          Var_TasaAnual,    Var_TasaMens1,
      Var_TasaFlat,         Var_MontoSeguro,    Var_PorcCobert,       Var_CAT,          Var_PorcGarLiq,
      Var_MonGarLiq,        Var_NomRepres,      Var_FrecSeguro,       Var_NumRECA,    Var_DiaVencimiento,
      Var_AnioVencimiento,  Var_MesVencimiento, Var_GarantiaLetra,    Var_MontoCredito, Var_MtoLetra,
      Var_NumAmorti,        Var_DesFrecLet,     MontoTotPagar,        Var_TotPagLetra,  Var_NombreEstadom,
      Var_NombreMuni,       Var_DescProducto,   Var_CobraMora,      Var_FactorMora,   Var_ReqGarantia,
      Var_NumCuotas,        Var_Clasificacion,  Var_MontoCreditoAn,   Var_ClienteID,    Var_DirecCliente,
      Var_NomInstit,        Var_DirecInstit,  Var_TelefonoCelular,  Var_NombreRepresentante,Var_FechaSistema,
      Var_DestinoCredito,   Var_FactorMora1,  Var_ConcatenadoMonto, Var_RFCOficial,   Var_DireccSucursal,
      Var_IntOrdiLetras,    Var_IntMorLetras,   Var_NombreCompleto,   Var_FechaHoraServidor ;

END IF;



IF (Par_TipoReporte=CalendarioPagos)THEN
  SELECT FechaExigible, FORMAT(Capital,2)
  FROM AMORTICREDITO
  WHERE CreditoID=Par_CreditoID;
END IF;

IF (Par_TipoReporte=Avales)THEN
  OPEN CURSORAVALES;
BEGIN
  DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
  LOOP

    FETCH CURSORAVALES INTO
  Var_AvalID, Var_ClienteID,  Var_ProspectoID,  Var_Nombre, Var_Direc,  Var_RFC,
  Var_CURP, Var_Edad, Var_NombreIdent,  Var_NumIdent, Var_EstadoCivil;

    IF(Var_ProspectoID<>Entero_Cero)THEN
      SELECT  Est.Nombre, Mun.Nombre, IFNULL(P.Calle,Cadena_Vacia),IFNULL(P.NumInterior,Cadena_Vacia),P.CP,
      IFNULL(P.Manzana,Cadena_Vacia), CONCAT(Col.TipoAsenta," ",Col.Asentamiento),IFNULL(P.Lote,Cadena_Vacia)
      INTO Var_NombEstado,Var_NombMunicipio,Var_Calle,Var_NumInterior,Var_CP,Var_Manzana,Var_NombreColonia,Var_Lote
      FROM PROSPECTOS P
        INNER JOIN ESTADOSREPUB Est ON Est.EstadoID=P.EstadoID
        INNER JOIN MUNICIPIOSREPUB Mun  ON Mun.MunicipioID=P.MunicipioID AND Mun.EstadoID=P.EstadoID
        INNER JOIN COLONIASREPUB  Col ON Col.ColoniaID=P.ColoniaID AND Col.MunicipioID=P.MunicipioID AND Col.EstadoID=P.EstadoID
      WHERE ProspectoID = Var_ProspectoID;

    SET Var_Direc := Var_Calle;
    IF(Var_NumInterior != Cadena_Vacia) THEN
      SET Var_Direc := CONCAT(Var_Direc,", INTERIOR ",Var_NumInterior);
    END IF;
    IF(Var_Lote != Cadena_Vacia) THEN
      SET Var_Direc := CONCAT(Var_Direc,", LOTE ",Var_Lote);
    END IF;
    IF(Var_Manzana != Cadena_Vacia) THEN
      SET Var_Direc := CONCAT(Var_Direc,", MANZANA ",Var_Manzana);
    END IF;
      SET Var_Direc := CONCAT(Var_Direc,", COL. ",Var_NombreColonia,", C.P ",Var_CP,", ",Var_NombMunicipio,", ",Var_NombEstado);
    END IF;

    INSERT TMPAVALES
    VALUES(Var_AvalID,Var_ClienteID,Var_ProspectoID,Var_Nombre,Var_Direc,Var_RFC,
       Var_CURP,Var_Edad,Var_NombreIdent,Var_NumIdent,Var_EstadoCivil);
  END LOOP;
END;
CLOSE CURSORAVALES;
  SELECT  @s:=@s+1 AS Num, Tmp_AvalID, Tmp_ClienteID,   Tmp_ProspectoID,Tmp_Nombre,Tmp_Direccion,
  Tmp_RFC, Tmp_CURP,Tmp_Edad,  Tmp_NombreIdent,Tmp_NumIdent,Tmp_EstadoCivil
  FROM TMPAVALES,
(SELECT @s:= Entero_Cero) AS s;
  DROP TABLE TMPAVALES;
END IF;

-- Tipo de Reporte para la consulta de las Garantias Prendarias de un Credito
IF(Par_TipoReporte = GarantiaPrendaria)THEN
  SELECT Descripcion, Observaciones,  FechaCompFactura, RFCEmisor,
     SerieFactura,  Asegurador, NumPoliza,  VencimientoPoliza,
      CASE WHEN (VencimientoPoliza=Fecha_Vacia)
  THEN CONCAT(Cadena_Vacia)
    ELSE CASE WHEN (VencimientoPoliza != Fecha_Vacia)
  THEN CONCAT(VencimientoPoliza)END END VencimientoPoliza,
     Asi.MontoAsignado, ValorComercial, CuentaID,
  Gar.TipoDocumentoID, Gar.TipoGarantiaID
  FROM GARANTIAS Gar
  LEFT JOIN TIPOSDOCUMENTOS Tip   ON Tip.TipoDocumentoID=Gar.TipoDocumentoID
    INNER JOIN ASIGNAGARANTIAS Asi    ON Asi.GarantiaID=Gar.GarantiaID
    INNER JOIN SOLICITUDCREDITO Sol   ON Sol.SolicitudCreditoID = Asi.SolicitudCreditoID
    INNER JOIN CREDITOS Cre       ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
  WHERE Cre.CreditoID=Par_CreditoID
  AND Gar.TipoDocumentoID=TipoDocumFactura
  AND Gar.TipoGarantiaID=TipoGarantiaMob
  ORDER BY ValorComercial DESC
  LIMIT 1;
END IF;

-- Tipo de Reporte para la consulta de las Garantias Hipotecarias de un Credito
IF(Par_TipoReporte = GarantiaHipotecaria)THEN
  SELECT Descripcion, Observaciones,  Calle,  Numero,
    Colonia,  Mun.Nombre AS NombreMunicipio,  Est.Nombre AS NombreEstado,
    M2Terreno,  M2Construccion, Titular,  FolioRegistro,
    Gar.FechaRegistro,  ValorComercial, CuentaID,
    Gar.TipoDocumentoID, Gar.TipoGarantiaID, Asi.MontoAsignado
  FROM GARANTIAS Gar
  LEFT JOIN TIPOSDOCUMENTOS Tip ON Tip.TipoDocumentoID=Gar.TipoDocumentoID
    INNER JOIN ASIGNAGARANTIAS Asi  ON Asi.GarantiaID=Gar.GarantiaID
    INNER JOIN SOLICITUDCREDITO Sol ON Sol.SolicitudCreditoID = Asi.SolicitudCreditoID
    INNER JOIN CREDITOS Cre     ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
    INNER JOIN ESTADOSREPUB Est   ON Est.EstadoID=Gar.EstadoID
  LEFT JOIN MUNICIPIOSREPUB Mun ON Gar.MunicipioID=Mun.MunicipioID
                  AND Mun.EstadoID=Gar.EstadoID
  LEFT JOIN NOTARIAS Nor      ON Nor.NotariaID=Gar.NotarioID
  WHERE Cre.CreditoID=Par_CreditoID
  AND Gar.TipoDocumentoID=TipoDocumTestimonio
  AND Gar.TipoGarantiaID=TipoGarantiaInmob
   ORDER BY ValorComercial DESC
   LIMIT 1;
END IF;

-- Tipo de Reporte para la consulta de las Garantias de Uso de un Credito
IF(Par_TipoReporte = GarantiaDeUso)THEN
  SELECT  Descripcion,  Observaciones,  M2Terreno,  M2Construccion,
    Gar.FechaRegistro,  NombreAutoridad,  CargoAutoridad, ValorComercial,
     CuentaID,Gar.TipoDocumentoID, Gar.TipoGarantiaID, Asi.MontoAsignado
    FROM GARANTIAS Gar
      LEFT JOIN TIPOSDOCUMENTOS Tip   ON Tip.TipoDocumentoID=Gar.TipoDocumentoID
      INNER JOIN ASIGNAGARANTIAS Asi    ON Asi.GarantiaID=Gar.GarantiaID
      INNER JOIN SOLICITUDCREDITO Sol   ON Sol.SolicitudCreditoID =Asi.SolicitudCreditoID
      INNER JOIN CREDITOS Cre       ON Cre.SolicitudCreditoID=Sol.SolicitudCreditoID
    WHERE Cre.CreditoID=Par_CreditoID
      AND Gar.TipoDocumentoID IN (TipoDocumActa,TipoDocumConstancia)
      AND Gar.TipoGarantiaID=TipoGarantiaInmob
       ORDER BY ValorComercial DESC
       LIMIT 1;
END IF;

-- Tipo de Reporte para la consulta de Firma de Avales
IF(Par_TipoReporte = FirmaAvales) THEN
DROP TABLE IF EXISTS  TMFIRMAAVALES;
CREATE TEMPORARY TABLE TMFIRMAAVALES(
  Folio INT AUTO_INCREMENT,
    Tmp_Descripcion   VARCHAR(150),
  Tmp_Descripcion2    VARCHAR(150),
  PRIMARY KEY (Folio)
);

OPEN CURSORAVALES;
BEGIN
  DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
  LOOP

    FETCH CURSORAVALES INTO
    Var_AvalID, Var_ClienteID,  Var_ProspectoID,  Var_Nombre, Var_Direc,  Var_RFC,
    Var_CURP, Var_Edad, Var_NombreIdent,  Var_NumIdent, Var_EstadoCivil;

    SET limiteTabla := (  SELECT  COUNT(*)
    FROM AVALESPORSOLICI AP
    LEFT OUTER JOIN AVALES A ON AP.AvalID= A.AvalID
    LEFT OUTER JOIN CLIENTES C ON AP.ClienteID= C.ClienteID
    LEFT OUTER JOIN PROSPECTOS P ON AP.ProspectoID= P.ProspectoID
    INNER JOIN SOLICITUDCREDITO Sol ON Sol.SolicitudCreditoID=AP.SolicitudCreditoID
    INNER JOIN CREDITOS Cre ON Cre.SolicitudCreditoID=Sol.SolicitudCreditoID
    WHERE  Cre.CreditoID=Par_CreditoID);

    IF contador = 2 THEN
      SET contador = 0;
    END IF;
    IF(contador = 0)THEN
      INSERT INTO TMFIRMAAVALES  (Tmp_Descripcion) VALUES ("_______________________________________");
      INSERT INTO TMFIRMAAVALES  (Tmp_Descripcion) VALUES (CONCAT("C. ",Var_Nombre));
      INSERT INTO TMFIRMAAVALES  (Tmp_Descripcion) VALUES (CONCAT("AVAL"));
      INSERT INTO TMFIRMAAVALES  (Tmp_Descripcion) VALUES (Cadena_Vacia);
      INSERT INTO TMFIRMAAVALES  (Tmp_Descripcion) VALUES (Cadena_Vacia);
      INSERT INTO TMFIRMAAVALES  (Tmp_Descripcion) VALUES (Cadena_Vacia);


      SET Var_NumRegTemporal := (SELECT MAX(Folio) FROM TMFIRMAAVALES);
      SET Var_NumRegTemporal := IFNULL(Var_NumRegTemporal, 0);
    END IF;
    IF(contador = 1)THEN
      UPDATE TMFIRMAAVALES
      SET Tmp_Descripcion2 = "_______________________________________"
      WHERE Folio = Var_NumRegTemporal-5;

      UPDATE TMFIRMAAVALES
      SET Tmp_Descripcion2 = CONCAT("C. ",Var_Nombre)
      WHERE Folio = Var_NumRegTemporal-4;

      UPDATE TMFIRMAAVALES
      SET Tmp_Descripcion2 = CONCAT("AVAL")
      WHERE Folio = Var_NumRegTemporal-3;

      UPDATE TMFIRMAAVALES
      SET Tmp_Descripcion2 = Cadena_Vacia
      WHERE Folio = Var_NumRegTemporal-2;

      UPDATE TMFIRMAAVALES
      SET Tmp_Descripcion2 = Cadena_Vacia
      WHERE Folio = Var_NumRegTemporal-1;

      UPDATE TMFIRMAAVALES
      SET Tmp_Descripcion2 = Cadena_Vacia
      WHERE Folio = Var_NumRegTemporal;
    END IF;
    SET contador = contador + 1;

  END LOOP;
END;

CLOSE CURSORAVALES;

  SELECT Tmp_Descripcion,Tmp_Descripcion2
  FROM TMFIRMAAVALES;
  DROP TABLE IF EXISTS TMFIRMAAVALES;
END IF;

-- Tipo de Reporte Anexo para Tres Reyes
IF (Par_TipoReporte = Tipo_AnexoTR) THEN
  SELECT Edo.Nombre ,Mu.Nombre INTO Var_NombreEstadom,Var_NombreMuni
  FROM  SUCURSALES Suc,
  ESTADOSREPUB Edo,
  USUARIOS  Usu,
                MUNICIPIOSREPUB Mu
  WHERE UsuarioID =Aud_Usuario
  AND Edo.EstadoID  = Suc.EstadoID
  AND Usu.SucursalUsuario= Suc.SucursalID
        AND Mu.MunicipioID=Suc.MunicipioID
        AND Edo.EstadoID = Mu.EstadoID;

    SET Var_TasaAnual   := Entero_Cero;
    SET Var_TasaMens    := Entero_Cero;
    SET Var_TasaFlat    := Entero_Cero;
    SET Var_MontoSeguro := Entero_Cero;
    SET Var_PorcCobert  := Entero_Cero;

	SELECT  TasaFija, CreditoID,  NumAmortizacion,  MontoCredito,
	  PeriodicidadInt,  FrecuenciaInt,  FrecuenciaCap,  MontoSeguroVida,
	  FactorMora,		FechaInicioAmor
  INTO  Var_TasaAnual,  Var_CreditoID,  Var_NumAmorti,      Var_MontoCred,
	  Var_Periodo,        Var_FrecuenciaInt,  Var_Frecuencia,   Var_MontoSeguro,
	  Var_TasaMoraAnual,	Var_FechaInicioAmort
  FROM CREDITOS
  WHERE CreditoID=Par_CreditoID;

    SET Var_TasaAnual   := IFNULL(Var_TasaAnual, Entero_Cero);
    SET Var_CreditoID   := IFNULL(Var_CreditoID, Entero_Cero);
    SET Var_NumAmorti   := IFNULL(Var_NumAmorti, Entero_Cero);
    SET Var_TasaMoraAnual   := IFNULL(Var_TasaMoraAnual, Entero_Cero);
    SET Var_FechaInicioAmort := (IFNULL(Var_FechaInicioAmort, Fecha_Vacia));

    SET Var_TasaAnualConLetra = CONCAT(ROUND(Var_TasaAnual,2),'% (',FUNCIONNUMLETRASPORCENTAJE(Var_TasaAnual),')');
    SET Var_TasaMens    := ROUND(Var_TasaAnual / 12, 4);

	SET Var_TasaMoratoria   := ROUND( Var_TasaAnual * Var_TasaMoraAnual, 2);
    SET Var_TasaMensMora    := ROUND(Var_TasaMoratoria / 12, 4);

    SELECT  SUM(Amo.Interes) INTO Var_TotInteres
        FROM AMORTICREDITO Amo
        WHERE Amo.CreditoID = Par_CreditoID;

    SET  Var_NumAmorti := IFNULL(Var_NumAmorti, Entero_Cero);
    SET  Var_MontoCred := IFNULL(Var_MontoCred, Entero_Cero);

    SET Var_TotInteres  := IFNULL(Var_TotInteres, Entero_Cero);

    SET Var_TasaFlat    := ( ( (Var_TotInteres / Var_NumAmorti) / Var_MontoCred ) /
                                IFNULL(Var_Periodo,0) ) * 30 * 100;

    SET Var_TasaFlat    := ROUND(Var_TasaFlat, 4);

    SELECT Cre.ValorCAT,  ROUND(Cre.PorcGarLiq,2), Pro.FactorRiesgoSeguro, Pro.RegistroRECA, Cre.FechaVencimien,
           CONCAT(Cli.PrimerNombre,
                    (CASE WHEN IFNULL(Cli.SegundoNombre, '') != '' THEN CONCAT(' ', Cli.SegundoNombre)
                          ELSE Cadena_Vacia
                     END),
                   (CASE WHEN IFNULL(Cli.TercerNombre, '') != '' THEN  CONCAT(' ', Cli.TercerNombre)
                         ELSE Cadena_Vacia
                    END), ' ',
                  Cli.ApellidoPaterno, ' ', Cli.ApellidoMaterno),Pro.Descripcion,Pro.CobraMora,
    Pro.FactorMora,Pro.RequiereGarantia,Cli.ClienteID,Dir.DireccionCompleta,
    Cre.CreditoID,Gar.TipoGarantiaID, Gar.TipoDocumentoID,	Pro.ProductoNomina,
    Cli.AntiguedadTra
  INTO Var_CAT,      Var_PorcGarLiq,  Var_FacRiesgo,  Var_NumRECA,    Var_FechaVenc,
   Var_NomRepres,Var_DescProducto,Var_CobraMora,  Var_FactorMora, Var_ReqGarantia,
   Var_Cliente,  Var_DireccionCompleta, Var_Credito, Var_TipoGarantia, Var_TipoDocumento,
   Var_EsNomina,	Var_AntiguedadLab

       FROM CREDITOS Cre
        INNER JOIN PRODUCTOSCREDITO Pro   ON Pro.ProducCreditoID = Cre.ProductoCreditoID
        INNER JOIN CLIENTES Cli       ON Cli.ClienteID = Cre.ClienteID
        INNER JOIN DIRECCLIENTE Dir     ON Dir.ClienteID = Cre.ClienteID
    LEFT JOIN ASIGNAGARANTIAS Asi     ON Asi.SolicitudCreditoID = Cre.SolicitudCreditoID
        LEFT JOIN GARANTIAS Gar       ON Gar.GarantiaID = Asi.GarantiaID
  WHERE Cre.CreditoID =Var_CreditoID
  AND Dir.Oficial=DirOficial
  LIMIT 1;

DROP TABLE IF EXISTS  TMPGARANTIA;
CREATE TEMPORARY TABLE TMPGARANTIA(
  Folio INT AUTO_INCREMENT,
    Tmp_Garantia        INT(11),
  Tmp_TipoDocumento   INT(11),
  Tmp_Monto           DECIMAL(14,2),
  Tmp_Valor     DECIMAL(14,2),
  PRIMARY KEY (Folio)
);

OPEN CURSORGARANTIAS;
BEGIN
  DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
  LOOP

    FETCH CURSORGARANTIAS INTO
  Var_TipoGarantia, Var_TipoDocumento, Var_MontoAsignado, Var_ValorComercial;
  INSERT INTO TMPGARANTIA (Tmp_Garantia,  Tmp_TipoDocumento,  Tmp_Monto,  Tmp_Valor)
  VALUES  (Var_TipoGarantia,  Var_TipoDocumento,  Var_MontoAsignado,  Var_ValorComercial);

  END LOOP;
END;

CLOSE CURSORGARANTIAS;
  SELECT  MAX(Tmp_Monto), MAX(Tmp_Valor) INTO
  Var_MontoMax, Var_ValorMax
  FROM TMPGARANTIA;

IF EXISTS (SELECT MAX(Folio) FROM TMPGARANTIA
  WHERE Tmp_Monto=Var_MontoMax
   HAVING COUNT(Folio) > 1
)THEN

  IF EXISTS (SELECT MAX(Folio) FROM TMPGARANTIA
    WHERE Tmp_Valor=Var_ValorMax
    HAVING COUNT(Folio) > 1
)THEN
    IF EXISTS (SELECT * FROM TMPGARANTIA
      WHERE Tmp_TipoDocumento=TipoDocumConstancia)THEN
      SELECT  Tmp_Garantia, Tmp_TipoDocumento,   Tmp_Monto,   Tmp_Valor
      INTO  Var_TipoGar,  Var_TipoDoc,   Var_Monto,   Var_Comercial
      FROM TMPGARANTIA
      WHERE Tmp_TipoDocumento=TipoDocumConstancia
      LIMIT 1;
    END IF;

    IF EXISTS (SELECT * FROM TMPGARANTIA
      WHERE Tmp_TipoDocumento=TipoDocumActa)THEN
      SELECT Tmp_Garantia,  Tmp_TipoDocumento,  Tmp_Monto,  Tmp_Valor
      INTO   Var_TipoGar, Var_TipoDoc,  Var_Monto,  Var_Comercial
      FROM TMPGARANTIA
      WHERE Tmp_TipoDocumento=TipoDocumActa
      LIMIT 1;
    END IF;

    IF EXISTS (SELECT * FROM TMPGARANTIA
      WHERE Tmp_TipoDocumento=TipoDocumTestimonio)THEN
      SELECT Tmp_Garantia,  Tmp_TipoDocumento,  Tmp_Monto,  Tmp_Valor
      INTO   Var_TipoGar,   Var_TipoDoc,  Var_Monto,  Var_Comercial
      FROM TMPGARANTIA
      WHERE Tmp_TipoDocumento=TipoDocumTestimonio
      LIMIT 1;
    END IF;

    IF (IFNULL(Var_TipoGar,Entero_Cero)=Entero_Cero AND IFNULL(Var_TipoDoc,Entero_Cero)=Entero_Cero)THEN
      SELECT Tmp_Garantia,  Tmp_TipoDocumento,  Tmp_Monto,  Tmp_Valor
      INTO Var_TipoGar, Var_TipoDoc,    Var_Monto,  Var_Comercial
      FROM TMPGARANTIA
      LIMIT 1;
    END IF;

    ELSE
    SELECT Tmp_Garantia,  Tmp_TipoDocumento,  Tmp_Monto,  Tmp_Valor
    INTO   Var_TipoGar,     Var_TipoDoc,  Var_Monto,  Var_Comercial
    FROM TMPGARANTIA
    WHERE Tmp_Valor=Var_ValorMax;
  END IF;
ELSE
  SELECT Tmp_Garantia,  Tmp_TipoDocumento,  Tmp_Monto,  Tmp_Valor
  INTO   Var_TipoGar, Var_TipoDoc,  Var_Monto,  Var_Comercial
  FROM TMPGARANTIA
  WHERE Tmp_Monto=Var_MontoMax;
END IF;

    SET Var_CAT  := IFNULL(Var_CAT, Entero_Cero);
    SET Var_PorcGarLiq  := IFNULL(Var_PorcGarLiq, Entero_Cero);
    SET Var_FacRiesgo  := IFNULL(Var_FacRiesgo, Entero_Cero);

  SELECT TipoPagoCapital INTO Var_TipoPagoCap
  FROM CREDITOS
  WHERE CreditoID=Par_CreditoID;


	 IF(Var_TipoPagoCap = Tipo_PagoIgual) THEN
		SET Var_MontoDesQuinc := (SELECT Capital FROM AMORTICREDITO WHERE AmortizacionID = 1 AND CreditoID = Par_CreditoID);
    ELSE
		SET Var_MontoDesQuinc := (SELECT MAX(Capital) FROM AMORTICREDITO WHERE CreditoID = Par_CreditoID);
    END IF;

    SET Var_MontoDesQuinc := IFNULL(Var_MontoDesQuinc, Decimal_Cero);
    SET Var_MontoDesQuincLetra := (SELECT FUNCIONNUMLETRAS(Var_MontoDesQuinc));
    SET Var_MontoDesQuincLetra := CONCAT('$ ', FORMAT(Var_MontoDesQuinc, 2), ', (', Var_MontoDesQuincLetra, ' M.N.)');

  IF(Var_TipoPagoCap=Tipo_PagoLibre OR Var_FrecuenciaInt != Var_Frecuencia)THEN
  SET Var_DesFrecLet = TxtMixtas;
  ELSE
    SELECT  CASE
                WHEN Var_Frecuencia =FrecSemanal    THEN TxtSemanal
                WHEN Var_Frecuencia =FrecCatorcenal   THEN TxtCatorcenal
                WHEN Var_Frecuencia =FrecQuincenal    THEN TxtQuincenal
                WHEN Var_Frecuencia =FrecMensual    THEN TxtMensual
                WHEN Var_Frecuencia =FrecPeriodica    THEN TxtPeriodica
                WHEN Var_Frecuencia =FrecBimestral    THEN TxtBimestral
                WHEN Var_Frecuencia =FrecTrimestral   THEN TxtTrimestral
                WHEN Var_Frecuencia =FrecTetramestral   THEN TxtTetramestral
                WHEN Var_Frecuencia =FrecSemestral    THEN TxtSemestral
                WHEN Var_Frecuencia =FrecAnual      THEN TxtAnual
        WHEN Var_Frecuencia =FrecDecenal    THEN TxtDecenal
            END INTO Var_DesFrec;

    SET Var_DesFrec     := IFNULL(Var_DesFrec, Cadena_Vacia);

    SELECT  CONCAT(CONVERT(Var_NumAmorti, CHAR), ' ' ,
            CASE
                WHEN Var_Frecuencia =FrecSemanal      THEN TxtSemanas
                WHEN Var_Frecuencia =FrecCatorcenal   THEN TxtCatorcenas
                WHEN Var_Frecuencia =FrecQuincenal    THEN TxtQuincenas
                WHEN Var_Frecuencia =FrecMensual    THEN TxtMeses
                WHEN Var_Frecuencia =FrecPeriodica    THEN TxtPeriodos
                WHEN Var_Frecuencia =FrecBimestral    THEN TxtBimestres
                WHEN Var_Frecuencia =FrecTrimestral   THEN TxtTrimestres
                WHEN Var_Frecuencia =FrecTetramestral   THEN TxtTetramestres
                WHEN Var_Frecuencia =FrecSemestral    THEN TxtSemestres
                WHEN Var_Frecuencia =FrecAnual      THEN TxtAnios
                WHEN Var_Frecuencia =FrecUnico      THEN TxtUnico
        WHEN Var_Frecuencia =FrecDecenal    THEN TxtDecenas
            END ) INTO Var_Plazo;
    SELECT  CASE
                WHEN Var_Frecuencia =FrecSemanal THEN TxtSemanales
                WHEN Var_Frecuencia =FrecCatorcenal   THEN TxtCatorcenales
                WHEN Var_Frecuencia =FrecQuincenal    THEN TxtQuincenales
                WHEN Var_Frecuencia =FrecMensual    THEN TxtMensuales
                WHEN Var_Frecuencia =FrecPeriodica    THEN TxtPeriodos
                WHEN Var_Frecuencia =FrecBimestral    THEN TxtBimestrales
                WHEN Var_Frecuencia =FrecTrimestral   THEN TxtTrimestrales
                WHEN Var_Frecuencia =FrecTetramestral   THEN TxtTetramestrales
                WHEN Var_Frecuencia =FrecSemestral    THEN TxtSemestrales
                WHEN Var_Frecuencia =FrecAnual      THEN TxtAnuales
        WHEN Var_Frecuencia =FrecDecenal    THEN TxtDecenales

            END INTO Var_DesFrecLet;
 END IF;
  SELECT COUNT(CreditoID) INTO Var_NumCuotas
  FROM AMORTICREDITO Amo
  WHERE Amo.CreditoID = Par_CreditoID;

    SET Var_MontoSeguro := IFNULL(Var_MontoSeguro, Entero_Cero);
    SET Var_MontoGarLiq := ROUND(Var_MontoCred * Var_PorcGarLiq / 100, 2);
   SET Var_MonGarLiq  := FORMAT(Var_MontoGarLiq,2);

    SELECT SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres + Amo.MontoOtrasComisiones + Amo.MontoIVAOtrasComisiones + IFNULL(Amo.MontoIntOtrasComis, Entero_Cero) + IFNULL(Amo.MontoIVAIntComisi,Entero_Cero)) INTO Var_TotPagar
        FROM CREDITOS Cre,
             AMORTICREDITO Amo
        WHERE Cre.CreditoID   = Par_CreditoID
          AND Amo.CreditoID = Cre.CreditoID;

    SET Var_TotPagar    := IFNULL(Var_TotPagar, Entero_Cero);

    SELECT FUNCIONNUMLETRAS(Var_TotPagar) INTO Var_TotPagLetra;
    SELECT FUNCIONNUMLETRAS(Var_MontoCred) INTO Var_MtoLetra;
    SELECT FUNCIONNUMLETRAS(Var_MontoGarLiq) INTO Var_GarantiaLetra;

    SELECT  CASE
                WHEN Var_Frecuencia =FrecSemanal THEN TxtSemana
                WHEN Var_Frecuencia =FrecCatorcenal THEN TxtCatorcena
                WHEN Var_Frecuencia =FrecQuincenal THEN TxtQuincena
                WHEN Var_Frecuencia =FrecMensual THEN TxtMes
                WHEN Var_Frecuencia =FrecPeriodica THEN TxtPeriodo
                WHEN Var_Frecuencia =FrecBimestral THEN TxtBimestre
                WHEN Var_Frecuencia =FrecTrimestral THEN TxtTrimestre
                WHEN Var_Frecuencia =FrecTetramestral THEN TxtTetramestre
                WHEN Var_Frecuencia =FrecSemestral THEN TxtSemestre
                WHEN Var_Frecuencia =FrecAnual THEN TxtAnio
        WHEN Var_Frecuencia =FrecDecenal THEN TxtDecenal


            END  INTO Var_FrecSeguro;

  SELECT DAY(Var_FechaVenc) ,   YEAR(Var_FechaVenc) , CASE
  WHEN MONTH(Var_FechaVenc) = mes1  THEN TxtEnero
  WHEN MONTH(Var_FechaVenc) = mes2  THEN TxtFebrero
  WHEN MONTH(Var_FechaVenc) = mes3  THEN TxtMarzo
  WHEN MONTH(Var_FechaVenc) = mes4  THEN TxtAbril
  WHEN MONTH(Var_FechaVenc) = mes5  THEN TxtMayo
  WHEN MONTH(Var_FechaVenc) = mes6  THEN TxtJunio
  WHEN MONTH(Var_FechaVenc) = mes7  THEN TxtJulio
  WHEN MONTH(Var_FechaVenc) = mes8  THEN TxtAgosto
  WHEN MONTH(Var_FechaVenc) = mes9  THEN TxtSeptiembre
  WHEN MONTH(Var_FechaVenc) = mes10 THEN TxtOctubre
  WHEN MONTH(Var_FechaVenc) = mes11 THEN TxtNoviembre
  WHEN MONTH(Var_FechaVenc) = mes12 THEN TxtDiciembre END

  INTO  Var_DiaVencimiento, Var_AnioVencimiento,  Var_MesVencimiento;

    SET Var_MontoCredito := CONCAT('$ ', FORMAT(Var_MontoCred, 2), ', (', Var_MtoLetra, ' M.N.)');
    SET MontoTotPagar := CONCAT('$ ', FORMAT(Var_TotPagar, 2), ', (', Var_TotPagLetra, ' M.N.)');

  SELECT Sol.Proyecto, Cre.SolicitudCreditoID INTO Var_DestinoCredito, Var_SolicitudCredito
  FROM SOLICITUDCREDITO Sol,
  CREDITOS Cre
  WHERE Cre.CreditoID=Par_CreditoID
  AND Cre.SolicitudCreditoID = Sol.SolicitudCreditoID;


	IF(MOD(Var_AntiguedadLab,1) > Entero_Cero) THEN
		SET Var_AntiguedadLab := Var_AntiguedadLab;
    ELSE
		SET Var_AntiguedadLab := ROUND(Var_AntiguedadLab);
    END IF;
  SELECT MontoPolizaSegA INTO Var_MontoPolizaSegA
  FROM PARAMETROSSIS
  WHERE EmpresaID=Par_EmpresaID;

  SET Var_SolicitudCredito   := IFNULL(Var_SolicitudCredito, Entero_Cero);

  SELECT FUNCIONNUMLETRAS(Var_MontoPolizaSegA) INTO Var_MtoLetraSeguro;
      SET Var_MontoSeguroApoyo := CONCAT('$ ', FORMAT(Var_MontoPolizaSegA, 2), ' (', Var_MtoLetraSeguro, ' M.N.)');

  SET  Var_TipoGar :=IFNULL(Var_TipoGar,0);
  SET  Var_TipoDoc :=IFNULL(Var_TipoDoc,0);
   SELECT CASE WHEN ProducCreditoID IN (15,16) THEN 'iniciales'
                WHEN ProducCreditoID NOT IN (15,16) THEN 'insolutos' END INTO Var_tipopro
    FROM PRODUCTOSCREDITO PR INNER JOIN CREDITOS CR ON PR.ProducCreditoID = CR.ProductoCreditoID
    WHERE CR.CreditoID=Par_CreditoID;

SET Var_EncabezadoUno := (SELECT CONCAT(' {\\rtf1 {El que suscribe {\\b C. ', Var_NomRepres, '}, ante ustedes comparezco para exponer lo siguiente: '));
SET Var_EncabezadoDos	:= (SELECT CONCAT(' {\\rtf1 {Por medio de la presente yo {\\b ', Var_NomRepres, '}, en mi caracter de '
'empleado autorizo a la {\\b Cooperativa Los Tres Reyes SC de AP de RL de CV} para que aplique en mi '
'nomina los descuentos quincenales abajo señalados, los cuales seran abonados al credito de nomina que '
'adquiero con esta fecha en dicha Cooperativa. Tomando en cuenta lo siguiente: '));
  SELECT	Var_Plazo,				Var_FechaVenc,			Var_DesFrec,	 		Var_TasaAnual,			Var_TasaMens,
		Var_TasaFlat,			Var_MontoSeguro,		Var_PorcCobert,			Var_CAT,				Var_PorcGarLiq,
        Var_MonGarLiq,			Var_NomRepres,			Var_FrecSeguro,			Var_NumRECA,			Var_DiaVencimiento,
        Var_AnioVencimiento,	Var_MesVencimiento,		Var_GarantiaLetra,		Var_MontoCredito,		Var_MtoLetra,
		Var_NumAmorti,			Var_DesFrecLet,			MontoTotPagar,			Var_TotPagLetra,		Var_NombreEstadom,
        Var_NombreMuni,			Var_DescProducto,		Var_CobraMora,			Var_FactorMora,			Var_ReqGarantia,
        Var_NumCuotas,			Var_Cliente,			Var_DireccionCompleta,  Var_Credito,      		Var_MontoGarLiq,
		Var_DestinoCredito,   	Var_SolicitudCredito,   Var_MontoPolizaSegA,  	Var_MontoSeguroApoyo,	Var_TasaMoratoria,
		Var_TasaMensMora,   	Var_TipoGar,      		Var_TipoDoc,			Var_Monto,       		Var_Comercial,
        Var_EsNomina,			Var_FechaInicioAmort,	Var_AntiguedadLab,		Var_MontoDesQuinc,		Var_MontoDesQuincLetra,
        Var_EncabezadoUno,		Var_EncabezadoDos,      Var_TasaAnualConLetra;

  DROP TABLE IF EXISTS TMPGARANTIA;
END IF;


-- Tipo de Reporte Plan de Pagos de Yanga
IF (Par_TipoReporte = PlanPagosYanga) THEN



  DROP TABLE IF EXISTS tmp_PlanDePagosCartCre;
  CREATE TEMPORARY TABLE tmp_PlanDePagosCartCre ( Fila  INT,
  FechaCol1 DATE,
  CapitalCol1 DECIMAL(18,2),
  FechaCol2 DATE,
  CapitalCol2 DECIMAL(18,2),
  FechaCol3 DATE,
  CapitalCol3 DECIMAL(18,2),
  FechaCol4 DATE,
  CapitalCol4 DECIMAL(18,2),
  PRIMARY KEY (Fila));


  SET Var_CantCuotas  := (SELECT COUNT(AmortizacionID) FROM AMORTICREDITO WHERE CreditoID = Par_CreditoID);
  SET Var_CantFilas := ROUND(Var_CantCuotas/4, 0);

  IF Var_CantCuotas >= 8 THEN
    IF MOD(Var_CantCuotas/4,1) > 0 AND MOD(Var_CantCuotas/4,1) < 0.5 THEN
      SET Var_CantFilas :=  Var_CantFilas + 1;
    END IF;
  ELSE
    SET Var_CantFilas :=  Var_CantCuotas;
  END IF;



  SET Var_Vueltas   := 1;
  SET Var_NumFila := 1;
  SET Var_NumColumna  := 1;
  WHILE Var_Vueltas <= Var_CantCuotas DO

    IF Var_NumColumna = 4 THEN
      UPDATE  tmp_PlanDePagosCartCre
      INNER JOIN AMORTICREDITO ON CreditoID = Par_CreditoID
      AND AmortizacionID = Var_Vueltas
      SET FechaCol4   = FechaExigible,
      CapitalCol4 = Capital
      WHERE Fila = Var_NumFila;
    END IF;

    IF Var_NumColumna = 3 THEN
      UPDATE  tmp_PlanDePagosCartCre
      INNER JOIN AMORTICREDITO ON CreditoID = Par_CreditoID
      AND AmortizacionID = Var_Vueltas
      SET FechaCol3   = FechaExigible,
      CapitalCol3 = Capital
      WHERE Fila = Var_NumFila;

      IF Var_NumFila = Var_CantFilas THEN
        SET Var_NumFila := 0;
        SET Var_NumColumna  := 4;
      END IF;
    END IF;



    IF Var_NumColumna = 2 THEN
      UPDATE  tmp_PlanDePagosCartCre
      INNER JOIN AMORTICREDITO ON CreditoID = Par_CreditoID
      AND AmortizacionID = Var_Vueltas
      SET FechaCol2   = FechaExigible,
      CapitalCol2 = Capital
      WHERE Fila = Var_NumFila;

      IF Var_NumFila = Var_CantFilas THEN
        SET Var_NumFila := 0;
        SET Var_NumColumna  := 3;
      END IF;

    END IF;

    IF Var_NumColumna = 1 THEN
      INSERT INTO tmp_PlanDePagosCartCre (Fila, FechaCol1, CapitalCol1)
      SELECT Var_NumFila, FechaExigible, Capital
      FROM AMORTICREDITO
      WHERE CreditoID = Par_CreditoID
        AND AmortizacionID = Var_Vueltas;

      IF Var_NumFila = Var_CantFilas THEN
        SET Var_NumFila := 0;
        SET Var_NumColumna  := 2;
      END IF;

    END IF;

    SET Var_NumFila = Var_NumFila + 1;

    SET Var_Vueltas = Var_Vueltas + 1;
  END WHILE;


  SELECT * FROM tmp_PlanDePagosCartCre;

  DROP TABLE IF EXISTS tmp_PlanDePagosCartCre;

END IF;

-- Tipo Contrato TLR (Tu Lanita Rapida)
IF (Par_TipoReporte = Tipo_ContratoTLR) THEN
      SELECT CONCAT(UCASE(SUBSTRING(Edo.Nombre,1,1)),LCASE (SUBSTRING(Edo.Nombre,2))),
   CONCAT(UCASE(SUBSTRING(Mu.Nombre,1,1)),LCASE (SUBSTRING(Mu.Nombre,2)))
  INTO Var_NombreEstadom,Var_NombreMuni
  FROM  SUCURSALES Suc,
  ESTADOSREPUB Edo,
  USUARIOS  Usu,
                MUNICIPIOSREPUB Mu
  WHERE UsuarioID =Aud_Usuario
  AND Edo.EstadoID  = Suc.EstadoID
  AND Usu.SucursalUsuario= Suc.SucursalID
        AND Mu.MunicipioID=Suc.MunicipioID
        AND Edo.EstadoID = Mu.EstadoID;

    SET Var_TasaAnual   := Entero_Cero;
    SET Var_TasaMens    := Entero_Cero;
    SET Var_TasaFlat    := Entero_Cero;
    SET Var_MontoSeguro := Entero_Cero;
    SET Var_PorcCobert  := Entero_Cero;

    SELECT  TasaFija, CreditoID,  NumAmortizacion,  MontoCredito,
  PeriodicidadInt,  FrecuenciaInt,  FrecuenciaCap,  FechaVencimien,
  FactorMora,
    CASE  TipoCredito
          WHEN  'N' THEN  'Nuevo'
          WHEN  'R' THEN  'Reestructura'
                    WHEN  'O' THEN  'Renovacion'
        END
  INTO  Var_TasaAnual,  Var_CreditoID,  Var_NumAmorti,      Var_MontoCred,
  Var_Periodo,        Var_FrecuenciaInt,  Var_Frecuencia,   Var_FechaVenc,
  Var_FactorMora, Var_TipoCredito
  FROM CREDITOS
  WHERE CreditoID=Par_CreditoID;

    SET Var_TasaAnual   := IFNULL(Var_TasaAnual, Entero_Cero);
    SET Var_CreditoID   := IFNULL(Var_CreditoID, Entero_Cero);
    SET Var_NumAmorti   := IFNULL(Var_NumAmorti, Entero_Cero);
    SET Var_FactorMora   := IFNULL(Var_FactorMora, Entero_Cero);
    SET Var_TipoCredito     :=  IFNULL(Var_TipoCredito,Cadena_Vacia);

    SELECT  SUM(Amo.Interes) INTO Var_TotInteres
        FROM AMORTICREDITO Amo
        WHERE Amo.CreditoID = Par_CreditoID;

    SET Var_TotInteres  := IFNULL(Var_TotInteres, Entero_Cero);

    SELECT Cre.ValorCAT,  Pro.RegistroRECA,Pro.MontoMinComFalPag,
           CONCAT(Cli.PrimerNombre,
                    (CASE WHEN IFNULL(Cli.SegundoNombre, '') != '' THEN CONCAT(' ', Cli.SegundoNombre)
                          ELSE Cadena_Vacia
                     END),
                   (CASE WHEN IFNULL(Cli.TercerNombre, '') != '' THEN  CONCAT(' ', Cli.TercerNombre)
                         ELSE Cadena_Vacia
                    END), ' ',
                  Cli.ApellidoPaterno, ' ', Cli.ApellidoMaterno),Pro.Descripcion,Cre.CreditoID
  INTO Var_CATLR,      Var_NumRECA, Var_ComisionCobranza,
   Var_NomRepres, Var_DescProducto,Var_Credito

        FROM CREDITOS Cre,
             PRODUCTOSCREDITO Pro,
             CLIENTES Cli
        WHERE Cre.CreditoID = Var_CreditoID
          AND Cre.ProductoCreditoID  = Pro.ProducCreditoID
          AND Cre.ClienteID = Cli.ClienteID;

    SET Var_CATLR  := IFNULL(Var_CATLR, Entero_Cero);

  SELECT TipoPagoCapital INTO Var_TipoPagoCap
  FROM CREDITOS
  WHERE CreditoID=Par_CreditoID;

  IF(Var_TipoPagoCap=Tipo_PagoLibre OR Var_FrecuenciaInt != Var_Frecuencia)THEN
  SET Var_DesFrecLet = TxtMixtas;
  ELSE
    SELECT  CASE
                WHEN Var_Frecuencia = FrecSemanal     THEN TxtSemanal
                WHEN Var_Frecuencia = FrecCatorcenal  THEN TxtCatorcenal
                WHEN Var_Frecuencia = FrecQuincenal   THEN TxtQuincenal
                WHEN Var_Frecuencia = FrecMensual     THEN TxtMensual
                WHEN Var_Frecuencia = FrecPeriodica   THEN TxtPeriodica
                WHEN Var_Frecuencia = FrecBimestral   THEN TxtBimestral
                WHEN Var_Frecuencia = FrecTrimestral  THEN TxtTrimestral
                WHEN Var_Frecuencia = FrecTetramestral  THEN TxtTetramestral
                WHEN Var_Frecuencia = FrecSemestral   THEN TxtSemestral
                WHEN Var_Frecuencia = FrecAnual     THEN TxtAnual
        WHEN Var_Frecuencia = FrecDecenal     THEN TxtDecenal
            END INTO Var_DesFrec;

    SET Var_DesFrec     := IFNULL(Var_DesFrec, Cadena_Vacia);

    SELECT  CONCAT(CONVERT(Var_NumAmorti, CHAR), ' ' ,
            CASE
                WHEN Var_Frecuencia = FrecSemanal     THEN TxtSemanas
                WHEN Var_Frecuencia = FrecCatorcenal    THEN TxtCatorcenas
                WHEN Var_Frecuencia = FrecQuincenal   THEN TxtQuincenas
                WHEN Var_Frecuencia = FrecMensual     THEN TxtMeses
                WHEN Var_Frecuencia = FrecPeriodica   THEN TxtPeriodos
                WHEN Var_Frecuencia = FrecBimestral   THEN TxtBimestres
                WHEN Var_Frecuencia = FrecTrimestral    THEN TxtTrimestres
                WHEN Var_Frecuencia = FrecTetramestral  THEN TxtTetramestres
                WHEN Var_Frecuencia = FrecSemestral   THEN TxtSemestres
                WHEN Var_Frecuencia = FrecAnual     THEN TxtAnios
                WHEN Var_Frecuencia = FrecUnico     THEN TxtUnico
        WHEN Var_Frecuencia = FrecDecenal     THEN TxtDecenales

            END ) INTO Var_Plazo;
    SELECT  CASE
        WHEN Var_Frecuencia ='U' THEN 'unico'
                WHEN Var_Frecuencia = FrecSemanal THEN TxtSemanales
                WHEN Var_Frecuencia = FrecCatorcenal THEN TxtCatorcenales
                WHEN Var_Frecuencia = FrecQuincenal THEN TxtQuincenales
                WHEN Var_Frecuencia = FrecMensual THEN TxtMensuales
                WHEN Var_Frecuencia = FrecPeriodica THEN TxtPeriodos
                WHEN Var_Frecuencia = FrecBimestral THEN TxtBimestrales
                WHEN Var_Frecuencia = FrecTrimestral THEN TxtTrimestrales
                WHEN Var_Frecuencia = FrecTetramestral THEN TxtTetramestrales
                WHEN Var_Frecuencia = FrecSemestral THEN TxtSemestrales
                WHEN Var_Frecuencia = FrecAnual THEN TxtAnuales
        WHEN Var_Frecuencia = FrecDecenal THEN TxtDecenales
  WHEN Var_Frecuencia = FrecLibre THEN TxtMixtas

            END INTO Var_DesFrecLet;
 END IF;

    SELECT SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres) INTO Var_TotPagar
        FROM CREDITOS Cre,
             AMORTICREDITO Amo
        WHERE Cre.CreditoID   = Par_CreditoID
          AND Amo.CreditoID = Cre.CreditoID;

    SET Var_TotPagar    := IFNULL(Var_TotPagar, Entero_Cero);
  SET Var_MontoPago   := IFNULL(Var_MontoPago, Entero_Cero);

    SET Var_PorcCobert  :=  ROUND((Var_FacRiesgo / 7 * Var_Periodo * 1000), 4);
    SELECT  CASE
                WHEN Var_Frecuencia = FrecSemanal THEN TxtSemana
                WHEN Var_Frecuencia = FrecCatorcenal THEN TxtCatorcena
                WHEN Var_Frecuencia = FrecQuincenal THEN TxtQuincena
                WHEN Var_Frecuencia = FrecMensual THEN TxtMes
                WHEN Var_Frecuencia = FrecPeriodica THEN TxtPeriodo
                WHEN Var_Frecuencia = FrecBimestral THEN TxtBimestre
                WHEN Var_Frecuencia = FrecTrimestral THEN TxtTrimestre
                WHEN Var_Frecuencia = FrecTetramestral THEN TxtTetramestre
                WHEN Var_Frecuencia = FrecSemestral THEN TxtSemestre
                WHEN Var_Frecuencia = FrecAnual THEN TxtAnio
        WHEN Var_Frecuencia = FrecDecenal THEN TxtDecena

            END  INTO Var_FrecSeguro;


  SELECT  Cre.SolicitudCreditoID, Ins.NombreInstit
  INTO Var_SolicitudCredito, Var_NombreInstitucion
  FROM SOLICITUDCREDITO Sol
  INNER JOIN CREDITOS Cre
  ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
  LEFT JOIN INSTITNOMINA Ins
  ON Ins.InstitNominaID = Sol.InstitucionNominaID
  WHERE Cre.CreditoID=Par_CreditoID;


  SELECT MontoCuota
  INTO Var_MontoPago
  FROM  CREDITOS Cre
  WHERE Cre.CreditoID=Par_CreditoID;

  SET Var_SolicitudCredito   := IFNULL(Var_SolicitudCredito, Cadena_Vacia);
  SET Var_NombreInstitucion  := IFNULL(Var_NombreInstitucion, Cadena_Vacia);

  SELECT SUM(MontoComApert + IVAComApertura) AS Total
  INTO Var_ComisionApertura
  FROM CREDITOS
  WHERE CreditoID=Par_CreditoID
  AND ForCobroComAper  IN (CobroFinanciamiento, CobroDeduccion);

  SELECT SUM(MontoComApert + IVAComApertura) AS Total
  INTO Var_ComisionPrepago
  FROM CREDITOS
  WHERE CreditoID=Par_CreditoID
  AND ForCobroComAper=CobroAnticipado;

  SELECT  Cla.TipoDocumento INTO Var_IdentificacionOficial
  FROM CREDITOS Cre,
  CLIENTES Cli,
      CLIENTEARCHIVOS Cla
  WHERE Cre.CreditoID=Par_CreditoID
  AND Cre.ClienteID=Cli.ClienteID
  AND Cli.ClienteID=Cla.ClienteID
  AND Cla.TipoDocumento=DocIdentificacion
  LIMIT 1;

  SELECT  Cla.TipoDocumento INTO Var_ComprobanteDomicilio
  FROM CREDITOS Cre,
  CLIENTES Cli,
      CLIENTEARCHIVOS Cla
  WHERE Cre.CreditoID=Par_CreditoID
  AND Cre.ClienteID=Cli.ClienteID
  AND Cli.ClienteID=Cla.ClienteID
  AND Cla.TipoDocumento=DocComprobanteDom
  LIMIT 1;

  SELECT  Cla.TipoDocumento INTO Var_ComprobanteIngresos
  FROM CREDITOS Cre,
  CLIENTES Cli,
      CLIENTEARCHIVOS Cla
  WHERE Cre.CreditoID=Par_CreditoID
  AND Cre.ClienteID=Cli.ClienteID
  AND Cli.ClienteID=Cla.ClienteID
  AND Cla.TipoDocumento=DocComprobanteIngr
  LIMIT 1;

  SELECT  Cla.TipoDocumento INTO Var_ServicioFederal
  FROM CREDITOS Cre,
  CLIENTES Cli,
      CLIENTEARCHIVOS Cla
  WHERE Cre.CreditoID=Par_CreditoID
  AND Cre.ClienteID=Cli.ClienteID
  AND Cli.ClienteID=Cla.ClienteID
  AND Cla.TipoDocumento=DocServicioFederal
  LIMIT 1;

  SELECT  Cla.TipoDocumento INTO Var_EstadoCuenta
  FROM CREDITOS Cre,
  CLIENTES Cli,
      CLIENTEARCHIVOS Cla
  WHERE Cre.CreditoID=Par_CreditoID
  AND Cre.ClienteID=Cli.ClienteID
  AND Cli.ClienteID=Cla.ClienteID
  AND Cla.TipoDocumento=DocEdoCuenta
  LIMIT 1;

  SET Var_ComisionApertura    := IFNULL(Var_ComisionApertura, Entero_Cero);
  SET Var_ComisionPrepago     := IFNULL(Var_ComisionPrepago, Entero_Cero);
  SET Var_IdentificacionOficial   := IFNULL(Var_IdentificacionOficial, Entero_Cero);
  SET Var_ComprobanteDomicilio    := IFNULL(Var_ComprobanteDomicilio, Entero_Cero);
  SET Var_ComprobanteIngresos   := IFNULL(Var_ComprobanteIngresos, Entero_Cero);
  SET Var_ServicioFederal   := IFNULL(Var_ServicioFederal, Entero_Cero);
  SET Var_EstadoCuenta    := IFNULL(Var_EstadoCuenta, Entero_Cero);


  SELECT   Var_Plazo,         Var_DesFrec,            Var_TasaAnual,          Var_CATLR,
     Var_NomRepres,         Var_NumRECA,        Var_ComisionCobranza,     Var_MontoCred,
     Var_NumAmorti,         Var_DesFrecLet,         Var_TotPagar,         Var_NombreEstadom,
     Var_NombreMuni,              Var_DescProducto,       Var_Credito,            Var_SolicitudCredito,
     Var_NombreInstitucion,       Var_MontoPago,              Var_ComisionApertura,       Var_ComisionPrepago,
     Var_IdentificacionOficial,   Var_ComprobanteDomicilio, Var_ComprobanteIngresos,  Var_ServicioFederal,
     Var_EstadoCuenta,      Var_FechaVenc,        Var_TipoCredito,      Var_FactorMora;

END IF;
-- mas alternativa Reporte para Caratula de Credito
IF (Par_TipoReporte = TipoMasAlternativa) THEN
-- estado y municipio  de la sucursal
  SELECT  CONCAT(
        UCASE(SUBSTRING(Edo.Nombre,1,1)),
        LCASE(SUBSTRING(Edo.Nombre,2))
      ),
      CONCAT(
        UCASE(SUBSTRING(Mu.Nombre,1,1)),
        LCASE(SUBSTRING(Mu.Nombre,2))
      )
  INTO  Var_NombreEstadom,
      Var_NombreMuni
  FROM  SUCURSALES Suc,
      ESTADOSREPUB Edo,
      USUARIOS  Usu,
      MUNICIPIOSREPUB Mu
  WHERE UsuarioID     = Aud_Usuario
    AND Edo.EstadoID    = Suc.EstadoID
    AND Usu.SucursalUsuario = Suc.SucursalID
    AND Mu.MunicipioID    = Suc.MunicipioID
    AND Edo.EstadoID    = Mu.EstadoID LIMIT 1;

  SELECT
    ins.Nombre,       UPPER(CIENTOSATEXT(DATE_FORMAT(FechaSistema,'%y'))) ,
                    FORMATEAFECHACONTRATO(FechaSistema),NombreRepresentante,  ins.DirFiscal
  INTO
    Var_NombreInstitucion, anioText,FechaSistematxt,          Var_RepresentanteLegal, Var_DirFiscalInstitucion
  FROM
    INSTITUCIONES ins,
    PARAMETROSSIS par
  WHERE
    par.InstitucionID = ins.InstitucionID
  AND par.EmpresaID = 1  LIMIT 1;

  SELECT
    SUM(Amo.Interes), SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres),
                      CONVPORCANT(ROUND((Amo.Capital + Amo.Interes + Amo.IVAInteres),2),'$','Peso','Nacional')
  INTO
    Var_TotPagar,   Var_TotInteres, Var_MontoRetencion
  FROM
    AMORTICREDITO Amo
  WHERE
    Amo.CreditoID = Par_CreditoID LIMIT 1;

  SELECT
    Cre.MontoCuota,   Cre.TipoPagoCapital,  Cre.TasaFija,   Cre.NumAmortizacion,  Cre.MontoCredito,
    Cre.PeriodicidadInt,Cre.FrecuenciaInt,    Cre.FrecuenciaCap,  Cre.ValorCAT,     Cre.ProductoCreditoID,
    IFNULL(Cre.MontoCuota,0.00),
              cpl.Descripcion,    cpl.Dias,     Cre.ClienteID,      IF(ForCobroComAper IN (CobroFinanciamiento, CobroDeduccion), SUM(MontoComApert + IVAComApertura), 0),
    IF(ForCobroComAper IN (CobroAnticipado), SUM(MontoComApert + IVAComApertura), 0),
    Cre.FechaVencimien, cpl.Descripcion


  INTO
    Var_MontoPago,    Var_TipoPagoCap,    Var_TasaAnual,    Var_NumAmorti,      Var_MontoCred,
    Var_Periodo,      Var_FrecuenciaInt,    Var_Frecuencia,   Var_CATLR,        Var_ProductoCre,
    Var_MontoCuota,   Var_Plazo,        var_DiasPlazo,    Var_ClienteID,
    Var_ComisionApertura,
    Var_ComisionPrepago,
    Var_FechaLimPag,  PlazoCredito
  FROM
    CREDITOS Cre LEFT OUTER JOIN CREDITOSPLAZOS cpl ON Cre.PlazoID = cpl.PlazoID
  WHERE
    CreditoID = Par_CreditoID LIMIT 1;

  SELECT
    Pro.RegistroRECA, Pro.MontoMinComFalPag, Pro.Descripcion, Pro.FactorMora, Pro.RequiereAvales
  INTO
    Var_NumRECA,  Var_ComisionCobranza, Var_DescProducto, Var_FactorMora, Var_RequiereAvales
  FROM
    PRODUCTOSCREDITO Pro
  WHERE
    ProducCreditoID = Var_ProductoCre LIMIT 1;


  SELECT
    cli.NombreCompleto, cli.TipoPersona,  cli.Titulo,     cli.PrimerNombre,   cli.SegundoNombre,
    cli.TercerNombre, cli.ApellidoPaterno,cli.ApellidoMaterno,cli.NombreCompleto,
    CASE cli.Sexo
      WHEN 'M' THEN TxtMasculino
      ELSE TxtFemenino
    END,
    DATE_FORMAT(cli.FechaNacimiento, '%d/%m/%Y'), FORMATEAFECHACONTRATO(cli.FechaNacimiento),   IFNULL(edo.Nombre, NoAplica) ,
    CASE  pais.PaisID
      WHEN  700 THEN  'MEXICO'
      ELSE  IFNULL(pais.Nombre, NoAplica)
    END,
    CASE cli.Nacion
      WHEN 'N' THEN 'MEXICANA'
      WHEN 'E' THEN 'EXTRANJERA'
    END,
    cli.OcupacionID,    CONVERT(ocu.Descripcion, CHAR),   cli.Puesto,   abm.Descripcion,
    CASE cli.EstadoCivil
      WHEN  EstSoltero  THEN  TxtSoltero
      WHEN  EstCasBienSep  THEN  TxtCasBienSep
      WHEN  EstCasBienMan  THEN  TxtCasBienMan
      WHEN  EstcasBienManCap  THEN  TxtcasBienManCap
      WHEN  EstViudo  THEN  TxtViudo
      WHEN  EstDivorciado  THEN  TxtDivorciado
      WHEN  EstSeparado  THEN  TxtSeparado
      WHEN  EsteUnionLibre  THEN  TxteUnionLibre
      ELSE
       NoAplica
    END,

    CASE cli.TelefonoCelular
      WHEN '' THEN cli.Telefono
      WHEN NULL THEN cli.Telefono
      ELSE cli.TelefonoCelular
    END,
    cli.Correo,   cli.CURP,
    CASE cli.TipoPersona
      WHEN 'M' THEN 'PERSONA MORAL'
      ELSE
      NoAplica
    END,
    cli.RazonSocial,

    cli.RFCOficial,
    CONCAT(TRIM(CONCAT(cli.PrimerNombre, ' ', cli.SegundoNombre, ' ', cli.TercerNombre)), ' ', TRIM(CONCAT(cli.ApellidoPaterno, ' ', cli.ApellidoMaterno)))
  INTO
    Var_NomRepres,  TipoPersona,      Titulo,       PrimerNombre,   SegundoNombre,
    TercerNombre, ApellidoPaterno,    ApellidoMaterno,  NombreCompleto, Sexo,
    FechaNacimiento,FechaNacimientoFtoTxt,  EstadoNacimiento, PaisNacimiento, Nacionalidad,
    OcupacionID,  Ocupacion,        Profesion,      ActividadEconomica,EstadoCivil,
    Telefono,   Correo,         CURP,       TipoEmpresa,RazonSocial,
    RFC,      Var_RepresentantePM
  FROM
    CLIENTES cli
    LEFT OUTER JOIN ESTADOSREPUB edo ON cli.EstadoID = edo.EstadoID
    LEFT OUTER JOIN PAISES pais ON cli.LugarNacimiento = pais.PaisID
    LEFT OUTER JOIN OCUPACIONES ocu ON cli.OcupacionID = ocu.OcupacionID
    LEFT OUTER JOIN ACTIVIDADESBMX abm ON cli.ActividadBancoMX = abm.ActividadBMXID
  WHERE
    ClienteID = Var_ClienteID LIMIT 1;

  SELECT
    ge.Descripcion
  INTO
    GradoEstudios
  FROM
    SOCIODEMOGRAL sc, CATGRADOESCOLAR ge
  WHERE
    sc.GradoEscolarID = ge.GradoEscolarID
  AND ClienteID = Var_ClienteID LIMIT 1;

  SELECT
    dc.DireccionCompleta,
    dc.NumeroCasa,  dc.Calle, dc.Colonia, dc.CP,
    Loc.NombreLocalidad, Edo.Nombre
  INTO
    Var_DireccionCompleta,
    Var_NumCasa,  Var_Calle,  Var_NombreColonia,  Var_CP,
    Var_Ciudad, Var_NombreEstado
  FROM
    DIRECCLIENTE dc
  LEFT OUTER JOIN ESTADOSREPUB  Edo ON  Edo.EstadoID  = dc.EstadoID
  LEFT OUTER JOIN LOCALIDADREPUB  Loc ON  Loc.EstadoID  = dc.EstadoID
                    AND Loc.MunicipioID = dc.MunicipioID
                    AND Loc.LocalidadID = dc.LocalidadID
  WHERE
    ClienteID = Var_ClienteID LIMIT 1;

  SELECT
    EscrituraPublic,        Mun.Nombre,           Edo.Nombre,             FORMATEAFECHACONTRATO(FechaEsc) , NomNotario,
    Notaria,            'Chiapas' ,           Mun2.Nombre,            Edo2.Nombre,            'distrito Tuxtla Gutierrez'
  INTO
    NumEscPConstitutiva,      LocalidadEscPConstitutiva,    EstadoEscPConstitutiva,       FechaEscPConstitutiva,        NombreNotarioEscPConstitutiva,
    NumeroNotarioEscPConstitutiva,  EstadoNotarioEscPConstitutiva,  LocalidadRegistroEscPConstitutiva,  EstadoRegistroEscPConstitutiva,   DistritoRegistroEscPConstitutiva

  FROM
    ESCRITURAPUB  escpubC,
    ESTADOSREPUB  Edo,
    MUNICIPIOSREPUB Mun,
    ESTADOSREPUB  Edo2,
    MUNICIPIOSREPUB Mun2
  WHERE
    ClienteID = Var_ClienteID
  AND Esc_Tipo = 'C'
  AND Edo.EstadoID    = escpubC.EstadoIDEsc
  AND Mun.EstadoID    = escpubC.EstadoIDEsc
  AND Mun.MunicipioID   = escpubC.LocalidadEsc
  AND Edo2.EstadoID   = escpubC.EstadoIDReg
  AND Mun2.EstadoID   = escpubC.EstadoIDReg
  AND Mun2.MunicipioID  = escpubC.LocalidadRegPub
  LIMIT 1;

  SELECT
    NomApoderado,       'apoderado legal',      EscrituraPublic,      Mun.Nombre,       Edo.Nombre,
    NomNotario,         Notaria,          'Chiapas',          Mun2.Nombre,    Edo2.Nombre,
    'distrito de Tuxtla Gutierrez'
  INTO
    NombreApoderadoEscPPoderes, TituloApoderadoEscPPoderes, NumeroEscPPoderes,      LocalidadEscPPoderes, EstadoEscPPoderes,
    NombreNotarioEscPPoderes, NumeroNotarioEscPPoderes, EstadoNotarioEscPPoderes, LocalidadRegEscPPoderes,EstadoRegEscPPoderes,
    DistritoRegEscPPoderes
  FROM
    ESCRITURAPUB  escpubP,
    ESTADOSREPUB  Edo,
    MUNICIPIOSREPUB Mun,
    ESTADOSREPUB  Edo2,
    MUNICIPIOSREPUB Mun2
  WHERE
    ClienteID = Var_ClienteID
  AND Esc_Tipo = 'P'
  AND Edo.EstadoID    = escpubP.EstadoIDEsc
  AND Mun.EstadoID    = escpubP.EstadoIDEsc
  AND Mun.MunicipioID   = escpubP.LocalidadEsc
  AND Edo2.EstadoID   = escpubP.EstadoIDReg
  AND Mun2.EstadoID   = escpubP.EstadoIDReg
  AND Mun2.MunicipioID  = escpubP.LocalidadRegPub
  LIMIT 1;


  SELECT
    Proyecto
  INTO
    ObjetoSocialEscPConstitutiva
  FROM
    SOLICITUDCREDITO
  WHERE
    ClienteID = Var_ClienteID
  AND CreditoID = Par_CreditoID;



  SELECT
    Cla.TipoDocumento
  INTO
    Var_IdentificacionOficial
  FROM
      CLIENTEARCHIVOS Cla
  WHERE
    Cla.ClienteID = Var_ClienteID
  AND Cla.TipoDocumento=DocIdentificacion
  LIMIT 1;



  SELECT
    Cla.TipoDocumento
  INTO
    Var_ComprobanteDomicilio
  FROM
      CLIENTEARCHIVOS Cla
  WHERE
    Cla.ClienteID = Var_ClienteID
  AND Cla.TipoDocumento=DocComprobanteDom
  LIMIT 1;



  SELECT
    Cla.TipoDocumento
  INTO
    Var_ComprobanteIngresos
  FROM
      CLIENTEARCHIVOS Cla
  WHERE
    Cla.ClienteID = Var_ClienteID
  AND Cla.TipoDocumento=DocComprobanteIngr
  LIMIT 1;


  SELECT
    Cla.TipoDocumento
  INTO
    Var_ServicioFederal
  FROM
      CLIENTEARCHIVOS Cla
  WHERE
    Cla.ClienteID = Var_ClienteID
  AND Cla.TipoDocumento=DocServicioFederal
  LIMIT 1;



OPEN CURSORGARANTIASMA;
 BEGIN
  DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;

  SET Var_ExisteGarReal := Entero_Cero;
  SET Var_Garantias := Cadena_Vacia;
  SET Var_Factura  := Cadena_Vacia;

  LOOP

  FETCH CURSORGARANTIASMA INTO
  Var_GarantiaLetra, Var_TipoDocumento, Var_TipoGarantiaID,Var_TipoDocumentoTxt, Var_FechaGarantia, Var_SerieFactura, Var_EsGarantiaReal;

  IF(Var_EsGarantiaReal = 'S') THEN
    IF(Var_ExisteGarReal = Entero_Cero) THEN
      SET Var_Garantias  := CONCAT(Var_Garantias, Var_GarantiaLetra);
      SET Var_Factura  := CONCAT(Var_Factura, Var_SerieFactura);
    ELSE
      SET Var_Garantias  := CONCAT(Var_Garantias,', ', Var_GarantiaLetra);
      SET Var_Factura  := CONCAT(Var_Factura,', ', Var_SerieFactura);
    END IF;
    SET Var_ExisteGarReal := Var_ExisteGarReal + 1;
  ELSE
    IF(Var_TipoDocumento = TipoDocumTestimonio AND Var_TipoGarantiaID = TipoGarantiaInmob AND Var_ExisteGarReal = Entero_Cero) THEN
      SET Var_Garantias = IFNULL(Var_GarantiaLetra,Cadena_Vacia);
      SET Var_TipoDocumentoTxt = IFNULL(Var_TipoDocumentoTxt,Cadena_Vacia);
    END IF;
  END IF;

  END LOOP;
  IF(Var_ExisteGarReal<>Entero_Cero) THEN
   SET Var_TipoDocumentoTxt := Cadena_Default;
  END IF;
 END;
 CLOSE CURSORGARANTIASMA;


  SELECT
    Cla.TipoDocumento
  INTO
    Var_EstadoCuenta
  FROM
      CLIENTEARCHIVOS Cla
  WHERE
    Cla.ClienteID = Var_ClienteID
  AND Cla.TipoDocumento=DocEdoCuenta
  LIMIT 1;

    IF(Var_TipoPagoCap=Tipo_PagoLibre OR Var_FrecuenciaInt != Var_Frecuencia)THEN
    SET Var_DesFrecLet = TxtMixtas;
  ELSE
    SELECT  CASE
          WHEN Var_Frecuencia = FrecSemanal THEN TxtSemanal
          WHEN Var_Frecuencia = FrecCatorcenal THEN TxtCatorcenal
          WHEN Var_Frecuencia = FrecQuincenal THEN TxtQuincenal
          WHEN Var_Frecuencia = FrecMensual THEN TxtMensual
          WHEN Var_Frecuencia = FrecPeriodica THEN TxtPeriodica
          WHEN Var_Frecuencia = FrecBimestral THEN TxtBimestral
          WHEN Var_Frecuencia = FrecTrimestral THEN TxtTrimestral
          WHEN Var_Frecuencia = FrecTetramestral THEN TxtTetramestral
          WHEN Var_Frecuencia = FrecSemestral THEN TxtSemestral
          WHEN Var_Frecuencia = FrecAnual THEN TxtAnual
          WHEN Var_Frecuencia = FrecDecenal THEN TxtDecenal
        END
    INTO Var_DesFrec;

  SET Var_DesFrec     := IFNULL(Var_DesFrec, Cadena_Vacia);
    SELECT  CASE
          WHEN Var_Frecuencia = FrecSemanal THEN TxtSemanales
          WHEN Var_Frecuencia = FrecCatorcenal THEN TxtCatorcenales
          WHEN Var_Frecuencia = FrecQuincenal THEN TxtQuincenales
          WHEN Var_Frecuencia = FrecMensual THEN TxtMensuales
          WHEN Var_Frecuencia = FrecPeriodica THEN TxtPeriodos
          WHEN Var_Frecuencia = FrecBimestral THEN TxtBimestrales
          WHEN Var_Frecuencia = FrecTrimestral THEN TxtTrimestrales
          WHEN Var_Frecuencia = FrecTetramestral THEN TxtTetramestrales
          WHEN Var_Frecuencia = FrecSemestral THEN TxtSemestrales
          WHEN Var_Frecuencia = FrecAnual THEN TxtAnuales
          WHEN Var_Frecuencia = FrecLibre THEN TxtMixtas
          WHEN Var_Frecuencia = FrecUnico THEN TxtUnico
          WHEN Var_Frecuencia = FrecDecenal THEN TxtDecenales
      ELSE
        NoAplica
      END
    INTO Var_DesFrecLet;
  END IF;

  SELECT  CASE
                WHEN Var_Frecuencia = FrecSemanal THEN TxtSemana
                WHEN Var_Frecuencia = FrecCatorcenal THEN TxtCatorcena
                WHEN Var_Frecuencia = FrecQuincenal THEN TxtQuincena
                WHEN Var_Frecuencia = FrecMensual THEN TxtMes
                WHEN Var_Frecuencia = FrecPeriodica THEN TxtPeriodo
                WHEN Var_Frecuencia = FrecBimestral THEN TxtBimestre
                WHEN Var_Frecuencia = FrecTrimestral THEN TxtTrimestre
                WHEN Var_Frecuencia = FrecTetramestral THEN TxtTetramestre
                WHEN Var_Frecuencia = FrecSemestral THEN TxtSemestre
                WHEN Var_Frecuencia = FrecAnual THEN  TxtAnio
        WHEN Var_Frecuencia = FrecUnico THEN TxtUnico
        WHEN Var_Frecuencia = FrecDecenal THEN TxtDecena
      ELSE
        NoAplica

            END
  INTO Var_FrecSeguro;



  SET Var_FechaCorte  := IFNULL(
    CASE (Var_Frecuencia)
      WHEN 'U' THEN IFNULL((SELECT MAX(FechaVencim) FROM AMORTICREDITO WHERE CreditoID = Par_CreditoID LIMIT 1), Fecha_Vacia)
      WHEN 'S' THEN 'Lunes  de  cada  semana'
      WHEN 'C' THEN CONCAT( UPPER(SUBSTR( TxtCatorcenal  ,1,1)),        SUBSTR( TxtCatorcenal ,2))
      WHEN 'Q' THEN 'Los  dias  16  y  01  de  cada  mes'
      WHEN 'M' THEN
        CASE (SELECT DiaPagoInteres FROM CREDITOS WHERE CreditoID = Par_CreditoID LIMIT 1)
          WHEN 'F' THEN 'Dia ultimo de cada Mes'
          WHEN 'D' THEN CONCAT(DAY(Aud_FechaActual),' de cada mes')
          ELSE
            'Dia seleccionado en el alta de Credito'
          END
      WHEN 'P' THEN TxtPeriodo
      WHEN 'B' THEN TxtBimestre
      WHEN 'T' THEN TxtTrimestre
      WHEN 'R' THEN TxtTetramestre
      WHEN 'E' THEN TxtSemestre
      WHEN 'A' THEN 'anio'
  END ,Cadena_Vacia);


  -- OBTENIENDO AVALES --

  SET TasaOrdinaria:=CASE (Var_Frecuencia)
    WHEN FrecUnico THEN CONVPORCANT(ROUND((Var_TasaAnual),2),'%','2','')
    WHEN  FrecSemanal  THEN CONVPORCANT(ROUND((Var_TasaAnual)*7/360,2),'%','2','')
    WHEN  FrecCatorcenal  THEN CONVPORCANT(ROUND((Var_TasaAnual)*14/360,2),'%','2','')
    WHEN  FrecQuincenal  THEN CONVPORCANT(ROUND((Var_TasaAnual)/26,2),'%','2','')
    WHEN  FrecMensual  THEN CONVPORCANT(ROUND((Var_TasaAnual)/12,2),'%','2','')
    WHEN  FrecPeriodica  THEN 'No Aplica'
    WHEN  FrecBimestral  THEN CONVPORCANT(ROUND((Var_TasaAnual)/6,2),'%','2','')
    WHEN  FrecTrimestral  THEN CONVPORCANT(ROUND((Var_TasaAnual)/4,2),'%','2','')
    WHEN  FrecTetramestral  THEN CONVPORCANT(ROUND((Var_TasaAnual)/3,2),'%','2','')
    WHEN  FrecSemestral  THEN CONVPORCANT(ROUND((Var_TasaAnual)/2,2),'%','2','')
    WHEN  FrecAnual  THEN CONVPORCANT(ROUND(Var_TasaAnual,2),'%','2','')
    ELSE
    ''
  END ;

  SET Var_TasaAnual         := IFNULL(Var_TasaAnual, Entero_Cero);
  SET Var_MontoCred       := IFNULL(Var_MontoCred, Decimal_Cero);
  SET Var_NumAmorti         := IFNULL(Var_NumAmorti, Entero_Cero);
  SET Var_CATLR           := IFNULL(Var_CATLR, Entero_Cero);
  SET Var_TotPagar          := IFNULL(Var_TotPagar, Entero_Cero);
  SET Var_TotInteres        := IFNULL(Var_TotInteres, Entero_Cero);
  SET Var_MontoPago         := IFNULL(Var_TotInteres, Entero_Cero);
  SET Var_SolicitudCredito    := IFNULL(Var_SolicitudCredito, Cadena_Vacia);
  SET Var_NombreInstitucion     := IFNULL(Var_NombreInstitucion, Cadena_Vacia);
  SET Var_ComisionApertura      := IFNULL(Var_ComisionApertura, Entero_Cero);
  SET Var_ComisionPrepago       := IFNULL(Var_ComisionPrepago, Entero_Cero);
  SET Var_IdentificacionOficial   := IFNULL(Var_IdentificacionOficial, Entero_Cero);
  SET Var_ComprobanteDomicilio    := IFNULL(Var_ComprobanteDomicilio, Entero_Cero);
  SET Var_ComprobanteIngresos   := IFNULL(Var_ComprobanteIngresos, Entero_Cero);
  SET Var_ServicioFederal     := IFNULL(Var_ServicioFederal, Entero_Cero);
  SET Var_EstadoCuenta        := IFNULL(Var_EstadoCuenta, Entero_Cero);
  SET Var_ProductoCre       := IFNULL(Var_ProductoCre, Entero_Cero);
  SET Var_FactorMora        := IFNULL(Var_FactorMora, Entero_Cero);


  -- OBTENIENDO AVALES --
  -- El tipo de Credito requiere AVALES?
  IF( IFNULL(Var_RequiereAvales,'N') = RequiereAvales) THEN

    -- Existe almenos un aval AUTORIZADO para dicho Credito?
    SELECT  AP.Estatus,
        CASE WHEN AP.ClienteID <> Entero_Cero THEN
          Cliente -- AP.ClienteID, Obtener datos de CLIENTES a partir de ClienteID
        ELSE
          CASE WHEN AP.AvalID <> Entero_Cero THEN
            Aval -- AP.AvalID, Obtener datos de AVALES a partir de AvalID
          ELSE
            Prospecto -- AP.ProspectoID, Obtener datos de PROSPECTOS a partir de ProspectoID
          END
        END,
        CASE WHEN AP.ClienteID <> Entero_Cero THEN
          AP.ClienteID                -- Obtengo el ID del Aval a partir de AP.ClienteID
        ELSE
          CASE WHEN AP.AvalID <> Entero_Cero THEN
            AP.AvalID                 -- Obtengo el ID del Aval a partir de AP.AvalID
          ELSE
            AP.ProspectoID              -- Obtengo el ID del Aval a partir de AP.ProspectoID
          END
        END,
        Cre.SolicitudCreditoID
    INTO  Var_AvalAutorizado, Var_OrigenAval, Var_AvalID, Var_SolicitudCredito
    FROM  CREDITOS Cre
    INNER JOIN     AVALESPORSOLICI AP     ON Cre.SolicitudCreditoID = AP.SolicitudCreditoID
    WHERE Cre.CreditoID = Par_CreditoID
      AND AP.Estatus = AvalAutorizado
    ORDER BY AP.ClienteID DESC, AP.AvalID DESC, AP.ProspectoID DESC
    LIMIT 1;

    IF( IFNULL(Var_AvalAutorizado,'N') = AvalAutorizado ) THEN

    -- DEPENDIENDO DEL TIPO DE PERSONA OBTENDRA LOS DATOS NECESARIOS
        IF( Var_OrigenAval = Cliente) THEN
          SELECT  CONCAT( C.PrimerNombre,
                  CASE  WHEN  IFNULL(C.SegundoNombre, Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(' ', C.SegundoNombre)
                      ELSE  Cadena_Vacia
                  END,
                  CASE  WHEN  IFNULL(C.TercerNombre, Cadena_Vacia) <> Cadena_Vacia  THEN  CONCAT(' ', C.TercerNombre)
                      ELSE  Cadena_Vacia
                  END,
                  CASE  WHEN  IFNULL(C.ApellidoPaterno, Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(' ', C.ApellidoPaterno)
                      ELSE  Cadena_Vacia
                  END,
                  CASE  WHEN  IFNULL(C.ApellidoMaterno, Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(' ', C.ApellidoMaterno)
                      ELSE  Cadena_Vacia
                  END
              ),          Dir.DireccionCompleta,  C.RFCOficial, C.Sexo,     CAST(C.FechaNacimiento AS CHAR),
              Edo.Nombre,
              CASE P.PaisID
                WHEN 700 THEN 'MEXICO'
                ELSE IFNULL(P.Nombre, Cadena_Vacia)
              END,
                                    C.Nacion,   CAST(Oc.Descripcion AS CHAR), Cge.Descripcion,
              C.Puesto,     Abm.Descripcion,    C.EstadoCivil,  CASE C.TelefonoCelular
                                              WHEN  ''    THEN  C.Telefono
                                              WHEN  NULL  THEN  C.Telefono
                                              ELSE C.TelefonoCelular
                                            END,      C.Correo,
              C.CURP,       Dir.NumeroCasa,     Dir.Calle,    Dir.CP,     Dir.Colonia,
              Edo.Nombre,     Loc.NombreLocalidad,  C.TipoPersona
          INTO  Var_AvalNombreCompleto, Var_AvalDirCompleta,Var_AvalRFC,  Var_AvalSexo,   Var_AvalFechaNacimiento,
              Var_AvalEdo,      Var_AvalPais,   Var_AvalNacion, Var_AvalOcupacion,  Var_AvalGradoEstudio,
              Var_AvalProfesion,    Var_AvalActEco,   Var_AvalEdoCivil,Var_AvalTel,   Var_AvalCorreo,
              Var_AvalCURP,     Aval_DirNumExt,   Aval_DirCalle,  Aval_DirCP,     Aval_DirColonia,
              Aval_DirEstado,     Aval_DirLocalidad,  Aval_TipoPersona
          FROM        AVALESPORSOLICI AP
            INNER JOIN    CREDITOS    Cre ON    Cre.SolicitudCreditoID  = AP.SolicitudCreditoID
            INNER JOIN    CLIENTES    C ON    C.ClienteID       = AP.ClienteID
            LEFT OUTER JOIN DIRECCLIENTE  Dir ON    Dir.ClienteID     = AP.ClienteID
                                AND Dir.Oficial       = DirOficial
            LEFT OUTER JOIN ESTADOSREPUB  Edo ON    Edo.EstadoID      = Dir.EstadoID
            LEFT OUTER JOIN LOCALIDADREPUB  Loc ON    Loc.LocalidadID     = Dir.LocalidadID
                                AND Loc.EstadoID      = Dir.EstadoID
                                AND Loc.MunicipioID     = Dir.MunicipioID
            LEFT OUTER JOIN PAISES      P ON    P.PaisID        = C.LugarNacimiento
            LEFT OUTER JOIN OCUPACIONES   Oc  ON    Oc.OcupacionID      = C.OcupacionID
            LEFT OUTER JOIN SOCIODEMOGRAL Sc  ON    Sc.ClienteID      = AP.ClienteID
            LEFT OUTER JOIN CATGRADOESCOLAR Cge ON    Cge.GradoEscolarID    = Sc.GradoEscolarID
            LEFT OUTER JOIN ACTIVIDADESBMX  Abm ON    C.ActividadBancoMX    = Abm.ActividadBMXID
          WHERE Cre.CreditoID = Par_CreditoID
            AND AP.Estatus = AvalAutorizado
            LIMIT 1;
        ELSE
          IF( Var_OrigenAval = Aval ) THEN
            SELECT  CONCAT( A.PrimerNombre,
                  CASE  WHEN  IFNULL(A.SegundoNombre, Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(' ', A.SegundoNombre)
                      ELSE  Cadena_Vacia
                  END,
                  CASE  WHEN  IFNULL(A.TercerNombre, Cadena_Vacia) <> Cadena_Vacia  THEN  CONCAT(' ', A.TercerNombre)
                      ELSE  Cadena_Vacia
                  END,
                  CASE  WHEN  IFNULL(A.ApellidoPaterno, Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(' ', A.ApellidoPaterno)
                      ELSE  Cadena_Vacia
                  END,
                  CASE  WHEN  IFNULL(A.ApellidoMaterno, Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(' ', A.ApellidoMaterno)
                      ELSE  Cadena_Vacia
                  END
                ),            A.DireccionCompleta,  A.RFC,      A.Sexo,     CAST(A.FechaNac AS CHAR),
                NULL,         NULL,         NULL,     NULL,     NULL,
                NULL,         NULL,         A.EstadoCivil,  CASE A.TelefonoCel
                                                  WHEN  ''    THEN  A.Telefono
                                                  WHEN  NULL  THEN  A.Telefono
                                                ELSE A.TelefonoCel
                                                END,      NULL,
                NULL,         A.NumExterior,      A.Calle,    A.CP,       A.Colonia,
                Edo.Nombre,       Loc.NombreLocalidad,  A.TipoPersona
            INTO  Var_AvalNombreCompleto, Var_AvalDirCompleta,  Var_AvalRFC,  Var_AvalSexo, Var_AvalFechaNacimiento,
                Var_AvalEdo,      Var_AvalPais,     Var_AvalNacion, Var_AvalOcupacion,Var_AvalGradoEstudio,
                Var_AvalProfesion,    Var_AvalActEco,     Var_AvalEdoCivil,Var_AvalTel, Var_AvalCorreo,
                Var_AvalCURP,     Aval_DirNumExt,     Aval_DirCalle,  Aval_DirCP,   Aval_DirColonia,
                Aval_DirEstado,     Aval_DirLocalidad,    Aval_TipoPersona
            FROM        AVALESPORSOLICI AP
              INNER JOIN    CREDITOS    Cre ON    Cre.SolicitudCreditoID  = AP.SolicitudCreditoID
              INNER JOIN    AVALES      A ON    A.AvalID        = AP.AvalID
              LEFT OUTER JOIN ESTADOSREPUB  Edo ON    Edo.EstadoID      = A.EstadoID
              LEFT OUTER JOIN LOCALIDADREPUB  Loc ON    Loc.LocalidadID     = A.LocalidadID
                                  AND Loc.EstadoID      = A.EstadoID
                                  AND Loc.MunicipioID     = A.MunicipioID
            WHERE Cre.CreditoID = Par_CreditoID
            AND AP.Estatus = AvalAutorizado
            LIMIT 1;
          END IF;
        END IF;

      IF(IFNULL(Aval_TipoPersona,PersonaFisica) = PersonaMoral) THEN
        -- SE TRATA DE UNA PERSONA MORAL

        IF( Var_OrigenAval = Cliente) THEN

            SELECT  Cli.RazonSocial
            INTO  Var_AvalRazonSocial
            FROM  CLIENTES Cli
            WHERE Cli.ClienteID = Var_AvalID;

            SELECT
                EscPub.EscrituraPublic,   EdoEscP.Nombre,   LocEscP.Nombre,       'Distrito Tuxtla Gutierrez',  CAST(EscPub.FechaEsc AS CHAR),
                EscPub.NomNotario,      EscPub.Notaria,   EdoEscP.Nombre,       EdoIDReg.Nombre,      Sol.Proyecto,
                Sol.Proyecto,       EscPubP.NomApoderado,EscPubP.tituloApoderado, EscPubP.EscrituraPublic,  EscPubP.LocEscPoder,
                EscPubP.EdoEscPoder,    EscPubP.NomNotario, EscPubP.EdoNotario,     EscPubP.LocNotario,     EscPubP.EdoReg,
                EscPubP.DistroReg,      EscPubP.Notaria
            INTO  Aval_EscPub,        Aval_CiudadEscP,  Aval_LocEscPubCons,     Aval_DistEscPubCons,    Aval_FechaEscP,
                Aval_NomNotarioEscP,    Aval_NumNotarioEscP,Aval_EdoNotario,      Aval_EdoIDReg,        Aval_Proyecto,
                Aval_ObjSocEscConstitutiva, Aval_NombreApoderado,Aval_TituloApoderado,    Aval_NumEscPoder,       Aval_LocEscPoder,
                Aval_EdoEscPoder,     Aval_NomNotarioEscPoder,Aval_EdoNotEscPoder,  Aval_LocNot,        Aval_EdoRegEscPoder,
                Aval_DistRegEscPoder,   Aval_NotariaPoder
            FROM ESCRITURAPUB EscPub
            LEFT OUTER JOIN ESTADOSREPUB    EdoEscP   ON  EdoEscP.EstadoID    = EscPub.EstadoIDEsc
            LEFT OUTER JOIN ESTADOSREPUB    EdoIDReg  ON  EdoIDReg.EstadoID   = EscPub.EstadoIDReg
            LEFT OUTER JOIN SOLICITUDCREDITO  Sol     ON  Sol.SolicitudCreditoID  = Var_SolicitudCredito
            LEFT OUTER JOIN MUNICIPIOSREPUB   LocEscP   ON  LocEscP.MunicipioID   = EscPub.LocalidadEsc
                                    AND LocEscP.EstadoID    = EscPub.EstadoIDEsc
            LEFT OUTER JOIN (
              SELECT
                EscPubPower.NomApoderado,
                      'APODERADO LEGAL'         AS tituloApoderado,
                            EscPubPower.EscrituraPublic,
                                    LocEscPoder.Nombre    AS  LocEscPoder,
                                          EdoEscPoder.Nombre        AS  EdoEscPoder,
                EscPubPower.NomNotario,
                      EdoNotariaPoder.Nombre      AS  EdoNotario,
                            MunNotariaPoder.Nombre      AS  LocNotario,
                                    EdoIDReg.Nombre         AS  EdoReg,
                                          'Distrito Tuxtla Gutierrez'   AS  DistroReg,
                Notaria
              FROM ESCRITURAPUB EscPubPower
              LEFT OUTER JOIN MUNICIPIOSREPUB LocEscPoder   ON  LocEscPoder.MunicipioID   = EscPubPower.LocalidadEsc
                                      AND LocEscPoder.EstadoID    = EscPubPower.EstadoIDEsc
              LEFT OUTER JOIN ESTADOSREPUB  EdoEscPoder   ON  EdoEscPoder.EstadoID    = EscPubPower.EstadoIDEsc
              LEFT OUTER JOIN NOTARIAS    NotariaPoder  ON  NotariaPoder.NotariaID    = EscPubPower.Notaria
              LEFT OUTER JOIN ESTADOSREPUB  EdoNotariaPoder ON  EdoNotariaPoder.EstadoID  = NotariaPoder.EstadoID
              LEFT OUTER JOIN MUNICIPIOSREPUB MunNotariaPoder ON  MunNotariaPoder.EstadoID  = NotariaPoder.EstadoID
                                      AND MunNotariaPoder.MunicipioID = NotariaPoder.MunicipioID
              LEFT OUTER JOIN ESTADOSREPUB  EdoIDReg    ON  EdoIDReg.EstadoID     = EscPubPower.EstadoIDReg
              WHERE
                  ClienteID = Var_AvalID
                AND Esc_Tipo = 'P'
              LIMIT 1
              ) EscPubP ON EscPub.ClienteID = Var_AvalID

            WHERE
                EscPub.ClienteID      =   Var_AvalID
              AND EscPub.Esc_Tipo       = 'C'
            LIMIT 1;


        ELSE
          IF( Var_OrigenAval = Aval ) THEN
            SELECT  A.RazonSocial
            INTO  Var_AvalRazonSocial
            FROM  AVALES A
            WHERE A.AvalID  = Var_AvalID;

            SELECT
                NULL,           NULL,         NULL,         'Distrito Tuxtla Gutierrez', '1900-01-01',
                NULL,           NULL,         NULL,         NULL,             Sol.Proyecto,
                Sol.Proyecto,       NULL,         NULL,         NULL,             NULL,
                NULL,           NULL,         NULL,         NULL,             NULL,
                NULL,           NULL
            INTO  Aval_EscPub,        Aval_CiudadEscP,    Aval_LocEscPubCons,   Aval_DistEscPubCons,      Aval_FechaEscP,
                Aval_NomNotarioEscP,    Aval_NumNotarioEscP,  Aval_EdoNotario,    Aval_EdoIDReg,          Aval_Proyecto,
                Aval_ObjSocEscConstitutiva, Aval_NombreApoderado, Aval_TituloApoderado, Aval_NumEscPoder,         Aval_LocEscPoder,
                Aval_EdoEscPoder,     Aval_NomNotarioEscPoder,Aval_EdoNotEscPoder,  Aval_LocNot,          Aval_EdoRegEscPoder,
                Aval_DistRegEscPoder,   Aval_NotariaPoder
            FROM AVALES A
            LEFT OUTER JOIN SOLICITUDCREDITO  Sol     ON  Sol.SolicitudCreditoID  = Var_SolicitudCredito
            WHERE
              A.AvalID  = Var_AvalID;


          END IF;
        END IF;
      END IF;
    END IF;
  END IF;


  SET Var_NumCasa       :=  IFNULL(Var_NumCasa,Cadena_Default);
  SET Var_Calle       :=  IFNULL(Var_Calle,Cadena_Default);
  SET Var_NombreColonia   :=  IFNULL(Var_NombreColonia,Cadena_Default);
  SET Var_CP          :=  IFNULL(Var_CP,Cadena_Default);
  SET Var_Ciudad        :=  IFNULL(Var_Ciudad,Cadena_Default);
  SET Var_NombreEstado    :=  IFNULL(Var_NombreEstado,Cadena_Default);
  SET RFC           :=  IFNULL(RFC,Cadena_Default);

  SET Var_AvalNombreCompleto  :=  IFNULL(Var_AvalNombreCompleto, NoAplica);
  SET Var_AvalDirCompleta   :=  IFNULL(Var_AvalDirCompleta, NoAplica);
  SET Var_AvalRFC       :=  IFNULL(Var_AvalRFC, NoAplica);
  SET Var_AvalSexo      :=  (CASE Var_AvalSexo
                    WHEN 'M'  THEN  TxtMasculino
                    WHEN 'F'  THEN  TxtFemenino
                    ELSE        NoAplica
                  END );

  SET Var_AvalFechaNacimiento :=  IF((IFNULL(Var_AvalFechaNacimiento, '1900-01-01') = '1900-01-01'),NoAplica,FORMATEAFECHACONTRATO(Var_AvalFechaNacimiento));

  SET Var_AvalEdo       :=  IFNULL(Var_AvalEdo, NoAplica);
  SET Var_AvalPais      :=  IFNULL(Var_AvalPais, NoAplica);
  SET Var_AvalNacion      :=  (CASE Var_AvalNacion
                    WHEN 'N' THEN 'MEXICANA'
                    WHEN 'E' THEN 'EXTRANJERA'
                    ELSE      NoAplica
                  END);
  SET Var_AvalOcupacion   :=  IFNULL(Var_AvalOcupacion, NoAplica);
  SET Var_AvalGradoEstudio  :=  IFNULL(Var_AvalGradoEstudio, NoAplica);
  SET Var_AvalProfesion   :=  IFNULL(Var_AvalProfesion, NoAplica);
  SET Var_AvalActEco      :=  IFNULL(Var_AvalActEco, NoAplica);
  SET Var_AvalEdoCivil    :=  (CASE Var_AvalEdoCivil
                  WHEN 'S'  THEN  'SOLTERO'
                  WHEN 'CS' THEN  'CASADO BIENES SEPARADOS'
                  WHEN 'CM' THEN  'CASADO BIENES MANCOMUNADOS'
                  WHEN 'CC' THEN  'CASADO BIENES MANCOMUNADOS CON CAPITULACION'
                  WHEN 'V'  THEN  'VIUDO'
                  WHEN 'D'  THEN  'DIVORCIADO'
                  WHEN 'SE' THEN  'SEPARADO'
                  WHEN 'U'  THEN  'UNION LIBRE'
                  ELSE        NoAplica
                END);


  SET Var_AvalTel         :=  IFNULL(Var_AvalTel, NoAplica);
  SET Var_AvalCorreo        :=  IFNULL(Var_AvalCorreo, NoAplica);
  SET Var_AvalCURP        :=  IFNULL(Var_AvalCURP, NoAplica);
  SET Aval_DirNumExt        :=  IFNULL(Aval_DirNumExt,NoAplica);
  SET Aval_DirCalle       :=  IFNULL(Aval_DirCalle,NoAplica);
  SET Aval_DirCP          :=  IFNULL(Aval_DirCP,NoAplica);
  SET Aval_DirColonia       :=  IFNULL(Aval_DirColonia,NoAplica);
  SET Aval_DirEstado        :=  IFNULL(Aval_DirEstado,NoAplica);
  SET Aval_DirLocalidad     :=  IFNULL(Aval_DirLocalidad,NoAplica);
  SET Var_AvalRazonSocial     :=  IFNULL(Var_AvalRazonSocial,NoAplica);
  SET Aval_EscPub         :=  IFNULL(Aval_EscPub,NoAplica);
  SET Aval_CiudadEscP       :=  IFNULL(Aval_CiudadEscP,NoAplica);
  SET Aval_LocEscPubCons      :=  IFNULL(Aval_LocEscPubCons,NoAplica);
  SET Aval_DistEscPubCons     :=  IFNULL(Aval_DistEscPubCons,NoAplica);
  SET Aval_FechaEscP        :=  IF((IFNULL(Aval_FechaEscP, '1900-01-01') = '1900-01-01'),NoAplica, FORMATEAFECHACONTRATO(Aval_FechaEscP));
  SET Aval_NomNotarioEscP     :=  IFNULL(Aval_NomNotarioEscP,NoAplica);
  SET Aval_NumNotarioEscP     :=  IFNULL(Aval_NumNotarioEscP,NoAplica);
  SET Aval_EdoNotario       :=  IFNULL(Aval_EdoNotario,NoAplica);
  SET Aval_EdoIDReg       :=  IFNULL(Aval_EdoIDReg,NoAplica);
  SET Aval_Proyecto       :=  IFNULL(Aval_Proyecto,NoAplica);
  SET Aval_ObjSocEscConstitutiva  :=  IFNULL(Aval_ObjSocEscConstitutiva,NoAplica);
  SET Aval_NombreApoderado    :=  IFNULL(Aval_NombreApoderado,NoAplica);
  SET Aval_TituloApoderado    :=  IFNULL(Aval_TituloApoderado,NoAplica);
  SET Aval_NumEscPoder      :=  IFNULL(Aval_NumEscPoder,NoAplica);
  SET Aval_LocEscPoder      :=  IFNULL(Aval_LocEscPoder,NoAplica);
  SET Aval_EdoEscPoder      :=  IFNULL(Aval_EdoEscPoder,NoAplica);
  SET Aval_NomNotarioEscPoder   :=  IFNULL(Aval_NomNotarioEscPoder,NoAplica);
  SET Aval_EdoNotEscPoder     :=  IFNULL(Aval_EdoNotEscPoder,NoAplica);
  SET Aval_LocNot         :=  IFNULL(Aval_LocNot,NoAplica);
  SET Aval_EdoRegEscPoder     :=  IFNULL(Aval_EdoRegEscPoder,NoAplica);
  SET Aval_DistRegEscPoder    :=  IFNULL(Aval_DistRegEscPoder,NoAplica);
  SET Aval_NotariaPoder     :=  IFNULL(Aval_NotariaPoder,NoAplica);
  SET Var_AvalTipoPersona     :=  CASE Aval_TipoPersona
                      WHEN PersonaMoral THEN  'ES UNA PERSONA MORAL'
                      ELSE 'ES UNA PERSONA FISICA'
                    END;
  SET MontoPagotxt := CONVPORCANT(Var_MontoCred,'$', 'Peso', 'Nacional');
  SET CATLRtxt := CONVPORCANT(Var_CATLR,'%', '2', '');
  SET ComReimpresonCant := CONVPORCANT(ROUND(Var_MontoCred * 0.0198, 2),'$', 'Peso', 'Nacional');
  SET ComReimpresonCantiva := CONVPORCANT(ROUND(Var_MontoCred * 0.023, 2),'$', 'Peso', 'Nacional');
  SET taiva := ROUND(Var_TasaAnual*0.16,2);
  SET tasaOrdinariaMensual := ROUND(Var_TasaAnual/12,2);
  SET tasaOrdinariaMensualtxt := CONVPORCANT(ROUND(Var_TasaAnual/12,2),'%','2','');
  SET taordinaria := ROUND(Var_TasaAnual,2);
  SET taordinariatxt := CONVPORCANT(ROUND(Var_TasaAnual,2),'%','2','');
  SET taOrdCarat  :=  ROUND(Var_TasaAnual - taiva,2);
  SET FechaLimPagtxt := FORMATEAFECHACONTRATO(Var_FechaLimPag);
  SET TasaDiariaordinariatxt := CONVPORCANT(ROUND(Var_TasaAnual/360,2),'%','2','');
  SET TasaMoraDiaria := CONVPORCANT(ROUND((Var_TasaAnual)*3/360,2),'%','2','') ;
  SET ValorMoraCatorcenalPC200 := CONVPORCANT(ROUND(Var_MontoCred*0.05,2),'$','Peso','Nacional') ;
  SET TasaMoraMensual := CONVPORCANT(ROUND((Var_TasaAnual)*3/12,2),'%','2','');
  SET ValorMoraDiaria := CONVPORCANT(ROUND( Var_TasaAnual*3/360*1.16*Var_MontoCred/100,2),'$','Peso','Nacional');
  SET MontoGarantiaLiquida := CONVPORCANT(Var_MontoCred*0.1,'$','Peso','Nacional');
  SET NombreAval := IFNULL(Var_AvalNombreCompleto, NoAplica);

  SET ValorMoraPC400  := CONVPORCANT(ROUND(Var_MontoCred*0.0465*1.16,2),'$','Peso','Nacional') ;

  SET FechaTerminoMora :=
    CASE
      WHEN var_DiasPlazo = 1 THEN ADDDATE(Var_FechaLimPag,2)
      WHEN var_DiasPlazo >= 7 THEN ADDDATE(Var_FechaLimPag,7)
      ELSE NoAplica
    END ;
  SET FechaTerminoMoratxt :=
    CASE
      WHEN var_DiasPlazo = 1 THEN FORMATEAFECHACONTRATO( ADDDATE(Var_FechaLimPag,2) )
      WHEN var_DiasPlazo >= 7 THEN FORMATEAFECHACONTRATO(ADDDATE(Var_FechaLimPag,7) )
      ELSE NoAplica
    END;
  SET FechaTerminoMora200 := ADDDATE(Var_FechaLimPag,14);
  SET FechaTerminoMoratxt200 := FORMATEAFECHACONTRATO(ADDDATE(Var_FechaLimPag,14) );
  SET PenaConvPC400 := ROUND( ROUND(0.07*1.16,2)*Var_MontoCred/100,2);
  SET PenaConvtxtPC400 := CONVPORCANT(PenaConvPC400,'$','Peso','Nacional');


  IF(Var_ProductoCre  = 400)  THEN
    -- Garantia Hipotecaria del ACREDITADO
    SELECT
      Gar.NotarioID, CONCAT(TipoGarantiaID,'-',ClasifGarantiaID,'-',TipoDocumentoID ),
                      FolioRegistro,  mun.Nombre, edo.Nombre,
      Gar.FechaRegistro
    INTO
      GarHip_Hipo,  GarHip_Desc,  GarHip_Ref,   GarHip_Mun, GarHip_Edo,
      GarHip_FechaReg
    FROM
      GARANTIAS     Gar,
      ASIGNAGARANTIAS Asi,
      ESTADOSREPUB  edo,
      MUNICIPIOSREPUB mun
    WHERE   Asi.CreditoID   = Par_CreditoID
      AND Asi.GarantiaID    = Gar.GarantiaID
      AND Gar.ClienteID   = Var_ClienteID
      AND Gar.TipoDocumentoID = TipoDocumTestimonio
      AND Gar.TipoGarantiaID  = TipoGarantiaInmob
      AND Gar.EstadoID    = edo.EstadoID
      AND Gar.EstadoID    = mun.EstadoID
      AND Gar.MunicipioID   = mun.MunicipioID;

    -- Garantia REAL del ACREDITADO
    SELECT
      Gar.SerieFactura, CONCAT(Gar.TipoGarantiaID,'-',Gar.ClasifGarantiaID,'-',Gar.TipoDocumentoID ),
                        Gar.ReferenFactura, td.Descripcion
    INTO
      Var_SerieFactura,   GarReal_Desc,   GarReal_Ref,    GarReal_TipDocu
    FROM
      GARANTIAS Gar,
      ASIGNAGARANTIAS   Asi ,
      CLASIFGARANTIAS   Cla ,
      TIPOSDOCUMENTOS   td
    WHERE
      Asi.CreditoID     = Par_CreditoID
    AND Asi.GarantiaID      = Gar.GarantiaID
    AND Gar.ClienteID     = Var_ClienteID
    AND Cla.TipoGarantiaID    = Gar.TipoGarantiaID
    AND Cla.ClasifGarantiaID  = Gar.ClasifGarantiaID
    AND Gar.TipoDocumentoID   = td.TipoDocumentoID
    AND Cla.EsGarantiaReal    =   'S';


    -- Garantia Hipotecaria del OBLIGADO SOLIDARIO
    SELECT
      Gar.NotarioID, CONCAT(TipoGarantiaID,'-',ClasifGarantiaID,'-',TipoDocumentoID ),
                      FolioRegistro,  mun.Nombre, edo.Nombre,
      Gar.FechaRegistro
    INTO
      AvalGarHipHipo, AvalGarHipDesc,   AvalGarHipRef,  AvalGarHipMun,  AvalGarHipEdo,
      AvalGarHipFecReg
    FROM
      GARANTIAS     Gar,
      ASIGNAGARANTIAS Asi,
      ESTADOSREPUB  edo,
      MUNICIPIOSREPUB mun
    WHERE   Asi.CreditoID   = Par_CreditoID
      AND Asi.GarantiaID    = Gar.GarantiaID
      AND Gar.ClienteID   <>  Var_ClienteID
      AND Gar.TipoDocumentoID = TipoDocumTestimonio
      AND Gar.TipoGarantiaID  = TipoGarantiaInmob
      AND Gar.EstadoID    = edo.EstadoID
      AND Gar.EstadoID    = mun.EstadoID
      AND Gar.MunicipioID   = mun.MunicipioID;

    -- Garantia REAL del OBLIGADO SOLIDARIO
    SELECT
      Gar.SerieFactura, CONCAT(Gar.TipoGarantiaID,'-',Gar.ClasifGarantiaID,'-',Gar.TipoDocumentoID ),
                        Gar.ReferenFactura, td.Descripcion
    INTO
      AvalSerieFactura,   AvalGarRealDesc,  AvalGarRealRef,   AvalGarRealTipDoc
    FROM
      GARANTIAS Gar,
      ASIGNAGARANTIAS   Asi ,
      CLASIFGARANTIAS   Cla ,
      TIPOSDOCUMENTOS   td
    WHERE
      Asi.CreditoID     = Par_CreditoID
    AND Asi.GarantiaID      = Gar.GarantiaID
    AND Gar.ClienteID     <>  Var_ClienteID
    AND Cla.TipoGarantiaID    = Gar.TipoGarantiaID
    AND Cla.ClasifGarantiaID  = Gar.ClasifGarantiaID
    AND Gar.TipoDocumentoID   = td.TipoDocumentoID
    AND Cla.EsGarantiaReal    =   'S';


  ELSE
    -- ojo esta definida que la garantia debe tener un tipo de documento de "Testimonio Notarial"
    -- y el tipo de garantia debe ser "inmobiliaria" para definirla como hipotecaria

    SELECT
      Gar.NotarioID, CONCAT(TipoGarantiaID,'-',ClasifGarantiaID,'-',TipoDocumentoID ),
                      FolioRegistro,  mun.Nombre, edo.Nombre,
      Gar.FechaRegistro
    INTO
      GarHip_Hipo,  GarHip_Desc,  GarHip_Ref,   GarHip_Mun, GarHip_Edo,
      GarHip_FechaReg
    FROM
      GARANTIAS     Gar,
      ASIGNAGARANTIAS Asi,
      ESTADOSREPUB  edo,
      MUNICIPIOSREPUB mun
    WHERE   Asi.CreditoID   =Par_CreditoID
      AND Asi.GarantiaID    =Gar.GarantiaID
      AND Gar.TipoDocumentoID =TipoDocumTestimonio
      AND Gar.TipoGarantiaID  =TipoGarantiaInmob
      AND Gar.EstadoID    =edo.EstadoID
      AND Gar.EstadoID    =mun.EstadoID
      AND Gar.MunicipioID   =mun.MunicipioID;
  -- Garantia REAL
    SELECT
      Gar.SerieFactura, CONCAT(Gar.TipoGarantiaID,'-',Gar.ClasifGarantiaID,'-',Gar.TipoDocumentoID ),
                        Gar.ReferenFactura, td.Descripcion
    INTO
      Var_SerieFactura,   GarReal_Desc,   GarReal_Ref,    GarReal_TipDocu
    FROM
      GARANTIAS Gar,
      ASIGNAGARANTIAS   Asi ,
      CLASIFGARANTIAS   Cla ,
      TIPOSDOCUMENTOS   td
    WHERE
      Asi.CreditoID     = Par_CreditoID
    AND Asi.GarantiaID      = Gar.GarantiaID
    AND Cla.TipoGarantiaID    = Gar.TipoGarantiaID
    AND Cla.ClasifGarantiaID  = Gar.ClasifGarantiaID
    AND Gar.TipoDocumentoID   = td.TipoDocumentoID
    AND Cla.EsGarantiaReal    =   'S';

  END IF;

-- SET IF ------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------

  CASE
    WHEN IFNULL(CAST(Var_ProductoCre AS UNSIGNED),Entero_Cero) BETWEEN 100 AND 199 THEN
      IF TipoPersona = PersonaMoral
        THEN
          SELECT
            Var_ClienteID,
            IF(LENGTH(TRIM(Var_NombreInstitucion)) > 0, Var_NombreInstitucion, Cadena_Default) AS Var_NombreInstitucion,
            IF(LENGTH(TRIM(Var_DirFiscalInstitucion)) > 0, Var_DirFiscalInstitucion, Cadena_Default) AS Var_DirFiscalInstitucion,
            IF(LENGTH(TRIM(Var_RepresentanteLegal)) > 0, Var_RepresentanteLegal, Cadena_Default) AS Var_RepresentanteLegal,
            IF(LENGTH(TRIM(Var_RepresentantePM)) > 0, Var_RepresentantePM, Cadena_Default) AS Var_RepresentantePM,
-- parrafo de Datos del Acreditado como persona fisica
            Cadena_Default AS Cli_TituloPF,
            Cadena_Default AS NombreCompleto,
            Cadena_Default AS Sexo,
            Cadena_Default AS FechaNacimientoFtoTxt,
            Cadena_Default AS EstadoNacimiento,
            Cadena_Default AS PaisNacimiento,
            Cadena_Default AS Nacionalidad,
            Cadena_Default AS Ocupacion,
            Cadena_Default AS GradoEstudios,
            Cadena_Default AS Profesion,
            Cadena_Default AS ActividadEconomica,
            Cadena_Default AS EstadoCivil,
            Cadena_Default AS Telefono,
            Cadena_Default AS Correo,
            Cadena_Default AS CURP,
-- parrafo de Datos del Acreditado como persona moral
            IF(LENGTH(TRIM(TipoEmpresa)) > 0, TipoEmpresa, Cadena_Default) AS TipoEmpresa,
            IF(LENGTH(TRIM(RazonSocial)) > 0, RazonSocial, Cadena_Default) AS RazonSocial,
            IF(LENGTH(TRIM(NumEscPConstitutiva)) > 0, NumEscPConstitutiva, Cadena_Default) AS NumEscPConstitutiva,
            IF(LENGTH(TRIM(LocalidadEscPConstitutiva)) > 0, LocalidadEscPConstitutiva, Cadena_Default) AS LocalidadEscPConstitutiva,
            IF(LENGTH(TRIM(FechaEscPConstitutiva)) > 0, FechaEscPConstitutiva, Cadena_Default) AS FechaEscPConstitutiva,
            IF(LENGTH(TRIM(NombreNotarioEscPConstitutiva)) > 0, NombreNotarioEscPConstitutiva, Cadena_Default) AS NombreNotarioEscPConstitutiva,
            IF(LENGTH(TRIM(NumeroNotarioEscPConstitutiva)) > 0, NumeroNotarioEscPConstitutiva, Cadena_Default) AS NumeroNotarioEscPConstitutiva,
            IF(LENGTH(TRIM(EstadoNotarioEscPConstitutiva)) > 0, EstadoNotarioEscPConstitutiva, Cadena_Default) AS EstadoNotarioEscPConstitutiva,
            IF(LENGTH(TRIM(EstadoRegistroEscPConstitutiva)) > 0, EstadoRegistroEscPConstitutiva, Cadena_Default) AS EstadoRegistroEscPConstitutiva,
            IF(LENGTH(TRIM(DistritoRegistroEscPConstitutiva)) > 0, DistritoRegistroEscPConstitutiva, Cadena_Default) AS DistritoRegistroEscPConstitutiva,
            IF(LENGTH(TRIM(ObjetoSocialEscPConstitutiva)) > 0, ObjetoSocialEscPConstitutiva, Cadena_Default) AS ObjetoSocialEscPConstitutiva,
            IF(LENGTH(TRIM(NombreApoderadoEscPPoderes)) > 0, NombreApoderadoEscPPoderes, Cadena_Default) AS NombreApoderadoEscPPoderes,
            IF(LENGTH(TRIM(TituloApoderadoEscPPoderes)) > 0, TituloApoderadoEscPPoderes, Cadena_Default) AS TituloApoderadoEscPPoderes,
            IF(LENGTH(TRIM(NumeroEscPPoderes)) > 0, NumeroEscPPoderes, Cadena_Default) AS NumeroEscPPoderes,
            IF(LENGTH(TRIM(LocalidadEscPPoderes)) > 0, LocalidadEscPPoderes, Cadena_Default) AS LocalidadEscPPoderes,
            IF(LENGTH(TRIM(EstadoEscPPoderes)) > 0, EstadoEscPPoderes, Cadena_Default) AS EstadoEscPPoderes,
            IF(LENGTH(TRIM(NombreNotarioEscPPoderes)) > 0, NombreNotarioEscPPoderes, Cadena_Default) AS NombreNotarioEscPPoderes,
            IF(LENGTH(TRIM(NumeroNotarioEscPPoderes)) > 0, NumeroNotarioEscPPoderes, Cadena_Default) AS NumeroNotarioEscPPoderes,
            IF(LENGTH(TRIM(EstadoNotarioEscPPoderes)) > 0, EstadoNotarioEscPPoderes, Cadena_Default) AS EstadoNotarioEscPPoderes,
            IF(LENGTH(TRIM(LocalidadRegEscPPoderes)) > 0, LocalidadRegEscPPoderes, Cadena_Default) AS LocalidadRegEscPPoderes,
            IF(LENGTH(TRIM(EstadoRegEscPPoderes)) > 0, EstadoRegEscPPoderes, Cadena_Default) AS EstadoRegEscPPoderes,
            IF(LENGTH(TRIM(DistritoRegEscPPoderes)) > 0, CAST(DistritoRegEscPPoderes AS CHAR CHARACTER SET utf8 ), Cadena_Default) AS DistritoRegEscPPoderes,
-- parrafo de direccion de acreditado
            IF(LENGTH(TRIM(Var_DireccionCompleta)) > 0, Var_DireccionCompleta, Cadena_Default) AS Var_DireccionCompleta,
            IF(LENGTH(TRIM(RFC)) > 0, RFC, Cadena_Default) AS RFC,
            IF(LENGTH(TRIM(MontoPagotxt)) > 0, MontoPagotxt, Cadena_Default) AS MontoPagotxt,
            IF(LENGTH(TRIM(CATLRtxt)) > 0, CATLRtxt, Cadena_Default) AS CATLRtxt,
            IF(LENGTH(TRIM(Var_NumAmorti)) > 0, Var_NumAmorti, Cadena_Default) AS Var_NumAmorti,
            IF(LENGTH(TRIM(Var_FechaCorte)) > 0, CAST(Var_FechaCorte AS CHAR CHARACTER SET utf8 ), Cadena_Default) AS Var_FechaCorte,
            IF(LENGTH(TRIM(FechaTerminoMora)) > 0, FechaTerminoMora, Cadena_Default) AS FechaTerminoMora,
            IF(LENGTH(TRIM(ComReimpresonCantiva)) > 0, ComReimpresonCantiva, Cadena_Default) AS ComReimpresonCantiva,
            IF(LENGTH(TRIM(ValorMoraDiaria)) > 0, ValorMoraDiaria, Cadena_Default) AS ValorMoraDiaria,
            IF(LENGTH(TRIM(TasaMoraDiaria)) > 0, TasaMoraDiaria, Cadena_Default) AS TasaMoraDiaria,
            IF(LENGTH(TRIM(taordinariatxt)) > 0, taordinariatxt, Cadena_Default) AS taordinariatxt,
            IF(LENGTH(TRIM(tasaOrdinariaMensualtxt)) > 0, tasaOrdinariaMensualtxt, Cadena_Default) AS tasaOrdinariaMensualtxt,
            IF(LENGTH(TRIM(Titulo)) > 0, Titulo, Cadena_Default) AS Titulo,
            IF(LENGTH(TRIM(FechaTerminoMoratxt)) > 0, FechaTerminoMoratxt, Cadena_Default) AS FechaTerminoMoratxt,
            IF(LENGTH(TRIM(FechaSistematxt)) > 0, FechaSistematxt, Cadena_Default) AS FechaSistematxt,
            IF(LENGTH(TRIM(Var_NumRECA)) > 0, Var_NumRECA, Cadena_Default) AS Var_NumRECA,
            IF(LENGTH(TRIM(Var_DescProducto)) > 0, Var_DescProducto, Cadena_Default) AS Var_DescProducto,
            IF(LENGTH(TRIM(TipoPersona)) > 0, TipoPersona, Cadena_Default) AS TipoPersona,
            Var_CATLR,
            taordinaria,
            taOrdCarat,
            Var_TasaAnual,
            taiva,
            IFNULL(FORMAT(Var_MontoCred,2),Cadena_Default) AS Var_MontoCred,
            IFNULL(FORMAT(Var_MontoPago,2),Cadena_Default) AS Var_MontoPago,
            Var_Plazo,
            FechaTerminoMora,
            Var_ProductoCre,
            NombreAval,
            Var_NomRepres,
            IFNULL(Var_NombreEstadom,Cadena_Default) AS Var_NombreEstadom,
            IFNULL(Var_NombreMuni,Cadena_Default) AS Var_NombreMuni;
        ELSE
          SELECT
            Var_ClienteID,
            IF(LENGTH(TRIM(Var_NombreInstitucion)) > 0, Var_NombreInstitucion, Cadena_Default) AS Var_NombreInstitucion,
            IF(LENGTH(TRIM(Var_DirFiscalInstitucion)) > 0, Var_DirFiscalInstitucion, Cadena_Default) AS Var_DirFiscalInstitucion,
            IF(LENGTH(TRIM(Var_RepresentanteLegal)) > 0, Var_RepresentanteLegal, Cadena_Default) AS Var_RepresentanteLegal,
            Cadena_Default AS Var_RepresentantePM,
-- parrafo de Datos del Acreditado como persona fisica
            'una persona fisica ' AS Cli_TituloPF,
            IF(LENGTH(TRIM(NombreCompleto)) > 0, NombreCompleto, Cadena_Default) AS NombreCompleto,
            IF(LENGTH(TRIM(Sexo)) > 0, Sexo, Cadena_Default) AS Sexo,
            IF(LENGTH(TRIM(FechaNacimientoFtoTxt)) > 0, FechaNacimientoFtoTxt, Cadena_Default) AS FechaNacimientoFtoTxt,
            IF(LENGTH(TRIM(EstadoNacimiento)) > 0, EstadoNacimiento, Cadena_Default) AS EstadoNacimiento,
            IF(LENGTH(TRIM(PaisNacimiento)) > 0, PaisNacimiento, Cadena_Default) AS PaisNacimiento,
            IF(LENGTH(TRIM(Nacionalidad)) > 0, Nacionalidad, Cadena_Default) AS Nacionalidad,
            IF(LENGTH(TRIM(Ocupacion)) > 0, Ocupacion, Cadena_Default) AS Ocupacion,
            IF(LENGTH(TRIM(GradoEstudios)) > 0, GradoEstudios, Cadena_Default) AS GradoEstudios,
            IF(LENGTH(TRIM(Profesion)) > 0, Profesion, Cadena_Default) AS Profesion,
            IF(LENGTH(TRIM(ActividadEconomica)) > 0, ActividadEconomica, Cadena_Default) AS ActividadEconomica,
            IF(LENGTH(TRIM(EstadoCivil)) > 0, EstadoCivil, Cadena_Default) AS EstadoCivil,
            IF(LENGTH(TRIM(Telefono)) > 0, Telefono, Cadena_Default) AS Telefono,
            IF(LENGTH(TRIM(Correo)) > 0, Correo, Cadena_Default) AS Correo,
            IFNULL(CURP,Cadena_Default) AS CURP,
-- parrafo de Datos del Acreditado como persona moral
            Cadena_Default AS TipoEmpresa,
            Cadena_Default AS RazonSocial,
            Cadena_Default AS NumEscPConstitutiva,
            Cadena_Default AS LocalidadEscPConstitutiva,
            Cadena_Default AS FechaEscPConstitutiva,
            Cadena_Default AS NombreNotarioEscPConstitutiva,
            Cadena_Default AS NumeroNotarioEscPConstitutiva,
            Cadena_Default AS EstadoNotarioEscPConstitutiva,
            Cadena_Default AS EstadoRegistroEscPConstitutiva,
            Cadena_Default AS DistritoRegistroEscPConstitutiva,
            Cadena_Default AS ObjetoSocialEscPConstitutiva,
            Cadena_Default AS NombreApoderadoEscPPoderes,
            Cadena_Default AS TituloApoderadoEscPPoderes,
            Cadena_Default AS NumeroEscPPoderes,
            Cadena_Default AS LocalidadEscPPoderes,
            Cadena_Default AS EstadoEscPPoderes,
            Cadena_Default AS NombreNotarioEscPPoderes,
            Cadena_Default AS NumeroNotarioEscPPoderes,
            Cadena_Default AS EstadoNotarioEscPPoderes,
            Cadena_Default AS LocalidadRegEscPPoderes,
            Cadena_Default AS EstadoRegEscPPoderes,
            Cadena_Default AS DistritoRegEscPPoderes,
-- parrafo de direccion de acreditado
            IF(LENGTH(TRIM(Var_DireccionCompleta)) > 0, Var_DireccionCompleta, Cadena_Default) AS Var_DireccionCompleta,
            IF(LENGTH(TRIM(RFC)) > 0, RFC, Cadena_Default) AS RFC,
            IF(LENGTH(TRIM(MontoPagotxt)) > 0, MontoPagotxt, Cadena_Default) AS MontoPagotxt,
            IF(LENGTH(TRIM(CATLRtxt)) > 0, CATLRtxt, Cadena_Default) AS CATLRtxt,
            IF(LENGTH(TRIM(Var_NumAmorti)) > 0, Var_NumAmorti, Cadena_Default) AS Var_NumAmorti,
            IF(LENGTH(TRIM(Var_FechaCorte)) > 0, CAST(Var_FechaCorte AS CHAR CHARACTER SET utf8 ), Cadena_Default) AS Var_FechaCorte,
            IF(LENGTH(TRIM(FechaTerminoMora)) > 0, FechaTerminoMora, Cadena_Default) AS FechaTerminoMora,
            IF(LENGTH(TRIM(ComReimpresonCantiva)) > 0, ComReimpresonCantiva, Cadena_Default) AS ComReimpresonCantiva,
            IF(LENGTH(TRIM(TasaMoraDiaria)) > 0, TasaMoraDiaria, Cadena_Default) AS TasaMoraDiaria,
            IF(LENGTH(TRIM(taordinariatxt)) > 0, taordinariatxt, Cadena_Default) AS taordinariatxt,
            IF(LENGTH(TRIM(tasaOrdinariaMensualtxt)) > 0, tasaOrdinariaMensualtxt, Cadena_Default) AS tasaOrdinariaMensualtxt,
            IF(LENGTH(TRIM(Titulo)) > 0, Titulo, Cadena_Default) AS Titulo,
            IF(LENGTH(TRIM(FechaTerminoMoratxt)) > 0, FechaTerminoMoratxt, Cadena_Default) AS FechaTerminoMoratxt,
            IF(LENGTH(TRIM(FechaSistematxt)) > 0, FechaSistematxt, Cadena_Default) AS FechaSistematxt,
            IF(LENGTH(TRIM(Var_NumRECA)) > 0, Var_NumRECA, Cadena_Default) AS Var_NumRECA,
            IF(LENGTH(TRIM(Var_DescProducto)) > 0, Var_DescProducto, Cadena_Default) AS Var_DescProducto,
            IF(LENGTH(TRIM(TipoPersona)) > 0, TipoPersona, Cadena_Default) AS TipoPersona,
            Var_CATLR,
            taordinaria,
            taOrdCarat,
            Var_TasaAnual,
            taiva,
            IFNULL(FORMAT(Var_MontoCred,2),Cadena_Default) AS Var_MontoCred,
            IFNULL(FORMAT(Var_MontoPago,2),Cadena_Default) AS Var_MontoPago,
            Var_Plazo,
            FechaTerminoMora,
            Var_ProductoCre,
            IF(LENGTH(TRIM(NombreAval)) > 0, NombreAval, Cadena_Default) AS NombreAval,
            IF(LENGTH(TRIM(Var_NomRepres)) > 0, Var_NomRepres, Cadena_Default) AS Var_NomRepres,
            IF(LENGTH(TRIM(Var_NombreEstadom)) > 0, Var_NombreEstadom, Cadena_Default) AS Var_NombreEstadom,
            IF(LENGTH(TRIM(Var_NombreMuni)) > 0, Var_NombreMuni, Cadena_Default) AS Var_NombreMuni,
            IFNULL(ValorMoraDiaria,Cadena_Default) AS ValorMoraDiaria;
      END IF;
    WHEN IFNULL(CAST(Var_ProductoCre AS UNSIGNED),Entero_Cero) BETWEEN 200 AND 299  THEN
        SELECT  Var_ClienteID,
            IFNULL(Var_ProductoCre,Cadena_Default) AS Var_ProductoCre,
            IF(LENGTH(TRIM(Var_NombreInstitucion)) > 0, Var_NombreInstitucion, Cadena_Default) AS Var_NombreInstitucion,
            IF(LENGTH(TRIM(Var_DirFiscalInstitucion)) > 0, Var_DirFiscalInstitucion, Cadena_Default) AS Var_DirFiscalInstitucion,
            IF(LENGTH(TRIM(Var_RepresentanteLegal)) > 0, Var_RepresentanteLegal, Cadena_Default) AS Var_RepresentanteLegal,
            IF(LENGTH(TRIM(TipoPersona)) > 0, TipoPersona, Cadena_Default) AS TipoPersona,
            IF(LENGTH(TRIM(Titulo)) > 0, Titulo, Cadena_Default) AS Titulo,
            IF(LENGTH(TRIM(NombreCompleto)) > 0,NombreCompleto, Cadena_Default) AS NombreCompleto,
            IF(LENGTH(TRIM(Var_RepresentantePM)) > 0, Var_RepresentantePM, Cadena_Default) AS Var_RepresentantePM,
            IF(LENGTH(TRIM(Sexo)) > 0, Sexo, Cadena_Default) AS Sexo,
            IF(LENGTH(TRIM(FechaNacimientoFtoTxt)) > 0, FechaNacimientoFtoTxt, Cadena_Default) AS FechaNacimientoFtoTxt,
            IF(LENGTH(TRIM(EstadoNacimiento)) > 0, EstadoNacimiento, Cadena_Default) AS EstadoNacimiento,
            IF(LENGTH(TRIM(PaisNacimiento)) > 0, PaisNacimiento, Cadena_Default) AS PaisNacimiento,
            IF(LENGTH(TRIM(Nacionalidad)) > 0, Nacionalidad, Cadena_Default) AS Nacionalidad,
            IF(LENGTH(TRIM(Ocupacion)) > 0, Ocupacion, Cadena_Default) AS Ocupacion,
            IF(LENGTH(TRIM(GradoEstudios)) > 0, GradoEstudios, Cadena_Default) AS GradoEstudios,
            IF(LENGTH(TRIM(Profesion)) > 0, Profesion, Cadena_Default) AS Profesion,
            IF(LENGTH(TRIM(ActividadEconomica)) > 0, ActividadEconomica, Cadena_Default) AS ActividadEconomica,
            IF(LENGTH(TRIM(EstadoCivil)) > 0, EstadoCivil, Cadena_Default) AS EstadoCivil,
            IF(LENGTH(TRIM(Telefono)) > 0, Telefono, Cadena_Default) AS Telefono,
            IF(LENGTH(TRIM(Correo)) > 0, Correo, Cadena_Default) AS Correo,
            IF(LENGTH(TRIM(CURP)) > 0, CURP, Cadena_Default) AS CURP,
            IF(LENGTH(TRIM(RazonSocial)) > 0, RazonSocial, Cadena_Default) AS RazonSocial,
            IF(LENGTH(TRIM(NumEscPConstitutiva)) > 0, NumEscPConstitutiva, Cadena_Default) AS NumEscPConstitutiva,
            IF(LENGTH(TRIM(LocalidadEscPConstitutiva)) > 0, LocalidadEscPConstitutiva, Cadena_Default) AS LocalidadEscPConstitutiva,
            IF(LENGTH(TRIM(FechaEscPConstitutiva)) > 0, FechaEscPConstitutiva, Cadena_Default) AS FechaEscPConstitutiva,
            IF(LENGTH(TRIM(NombreNotarioEscPConstitutiva)) > 0, NombreNotarioEscPConstitutiva, Cadena_Default) AS NombreNotarioEscPConstitutiva,
            IF(LENGTH(TRIM(NumeroNotarioEscPConstitutiva)) > 0, NumeroNotarioEscPConstitutiva, Cadena_Default) AS NumeroNotarioEscPConstitutiva,
            IF(LENGTH(TRIM(EstadoNotarioEscPConstitutiva)) > 0, EstadoNotarioEscPConstitutiva, Cadena_Default) AS EstadoNotarioEscPConstitutiva,
            IF(LENGTH(TRIM(LocalidadRegistroEscPConstitutiva)) > 0, LocalidadRegistroEscPConstitutiva, Cadena_Default) AS LocalidadRegistroEscPConstitutiva,
            IF(LENGTH(TRIM(EstadoRegistroEscPConstitutiva)) > 0, EstadoRegistroEscPConstitutiva, Cadena_Default) AS EstadoRegistroEscPConstitutiva,
            IF(LENGTH(TRIM(DistritoRegistroEscPConstitutiva)) > 0, DistritoRegistroEscPConstitutiva, Cadena_Default) AS DistritoRegistroEscPConstitutiva,
            IF(LENGTH(TRIM(ObjetoSocialEscPConstitutiva)) > 0, ObjetoSocialEscPConstitutiva, Cadena_Default) AS ObjetoSocialEscPConstitutiva,
            IF(LENGTH(TRIM(NombreApoderadoEscPPoderes)) > 0, NombreApoderadoEscPPoderes, Cadena_Default) AS NombreApoderadoEscPPoderes,
            IF(LENGTH(TRIM(TituloApoderadoEscPPoderes)) > 0, TituloApoderadoEscPPoderes, Cadena_Default) AS TituloApoderadoEscPPoderes,
            IF(LENGTH(TRIM(NumeroEscPPoderes)) > 0, NumeroEscPPoderes, Cadena_Default) AS NumeroEscPPoderes,
            IF(LENGTH(TRIM(LocalidadEscPPoderes)) > 0, LocalidadEscPPoderes, Cadena_Default) AS LocalidadEscPPoderes,
            IF(LENGTH(TRIM(EstadoEscPPoderes)) > 0, EstadoEscPPoderes, Cadena_Default) AS EstadoEscPPoderes,
            IF(LENGTH(TRIM(NombreNotarioEscPPoderes)) > 0, NombreNotarioEscPPoderes, Cadena_Default) AS NombreNotarioEscPPoderes,
            IF(LENGTH(TRIM(NumeroNotarioEscPPoderes)) > 0, NumeroNotarioEscPPoderes, Cadena_Default) AS NumeroNotarioEscPPoderes,
            IF(LENGTH(TRIM(EstadoNotarioEscPPoderes)) > 0, EstadoNotarioEscPPoderes, Cadena_Default) AS EstadoNotarioEscPPoderes,
            IF(LENGTH(TRIM(LocalidadRegEscPPoderes)) > 0, LocalidadRegEscPPoderes, Cadena_Default) AS LocalidadRegEscPPoderes,
            IF(LENGTH(TRIM(EstadoRegEscPPoderes)) > 0, EstadoRegEscPPoderes, Cadena_Default) AS EstadoRegEscPPoderes,
            IF(LENGTH(TRIM(DistritoRegEscPPoderes)) > 0, CAST(DistritoRegEscPPoderes AS CHAR CHARACTER SET utf8 ), Cadena_Default) AS DistritoRegEscPPoderes,
            IF(LENGTH(TRIM(Var_DireccionCompleta)) > 0, Var_DireccionCompleta, Cadena_Default) AS Var_DireccionCompleta,
            IF(LENGTH(TRIM(RFC)) > 0, RFC, Cadena_Default) AS RFC,
            IF(LENGTH(TRIM(Aval_TipoPersona)) > 0,Aval_TipoPersona, Cadena_Default) AS Aval_TipoPersona,
            IF(LENGTH(TRIM(Var_AvalNombreCompleto)) > 0, Var_AvalNombreCompleto, Cadena_Default) AS Var_AvalNombreCompleto,
            IF(LENGTH(TRIM(Var_AvalSexo)) > 0, Var_AvalSexo, Cadena_Default) AS Var_AvalSexo,
            IF(LENGTH(TRIM(Var_AvalFechaNacimiento)) > 0, Var_AvalFechaNacimiento, Cadena_Default) AS Var_AvalFechaNacimiento,
            IF(LENGTH(TRIM(Var_AvalEdo)) > 0, Var_AvalEdo, Cadena_Default) AS Var_AvalEdo,
            IF(LENGTH(TRIM(Var_AvalPais)) > 0, Var_AvalPais, Cadena_Default) AS Var_AvalPais,
            IF(LENGTH(TRIM(Var_AvalNacion)) > 0, Var_AvalNacion, Cadena_Default) AS Var_AvalNacion,
            IF(LENGTH(TRIM(Var_AvalOcupacion)) > 0, Var_AvalOcupacion, Cadena_Default) AS Var_AvalOcupacion,
            IF(LENGTH(TRIM(Var_AvalGradoEstudio)) > 0, Var_AvalGradoEstudio, Cadena_Default) AS Var_AvalGradoEstudio,
            IF(LENGTH(TRIM(Var_AvalProfesion)) > 0, Var_AvalProfesion, Cadena_Default) AS Var_AvalProfesion,
            IF(LENGTH(TRIM(Var_AvalActEco)) > 0, Var_AvalActEco, Cadena_Default) AS Var_AvalActEco,
            IF(LENGTH(TRIM(Var_AvalEdoCivil)) > 0, Var_AvalEdoCivil, Cadena_Default) AS Var_AvalEdoCivil,
            IF(LENGTH(TRIM(Var_AvalTel)) > 0, Var_AvalTel, Cadena_Default) AS Var_AvalTel,
            IF(LENGTH(TRIM(Var_AvalCorreo)) > 0, Var_AvalCorreo, Cadena_Default) AS Var_AvalCorreo,
            IF(LENGTH(TRIM(Var_AvalCURP)) > 0, Var_AvalCURP, Cadena_Default) AS Var_AvalCURP,
            IF(LENGTH(TRIM(Var_AvalRazonSocial)) > 0, Var_AvalRazonSocial, Cadena_Default) AS Var_AvalRazonSocial,
            IF(LENGTH(TRIM(Aval_EscPub)) > 0, Aval_EscPub, Cadena_Default) AS Aval_EscPub,
            IF(LENGTH(TRIM(Aval_CiudadEscP)) > 0, Aval_CiudadEscP, Cadena_Default) AS Aval_CiudadEscP,
            IF(LENGTH(TRIM(Aval_FechaEscP)) > 0, Aval_FechaEscP, Cadena_Default) AS Aval_FechaEscP,
            IF(LENGTH(TRIM(Aval_NomNotarioEscP)) > 0, Aval_NomNotarioEscP, Cadena_Default) AS Aval_NomNotarioEscP,
            IF(LENGTH(TRIM(Aval_NumNotarioEscP)) > 0, Aval_NumNotarioEscP, Cadena_Default) AS Aval_NumNotarioEscP,
            IF(LENGTH(TRIM(Aval_EdoNotario)) > 0, Aval_EdoNotario, Cadena_Default) AS Aval_EdoNotario,
            IF(LENGTH(TRIM(Aval_LocEscPubCons)) > 0, Aval_LocEscPubCons, Cadena_Default) AS Aval_LocEscPubCons,
            IF(LENGTH(TRIM(Aval_DistEscPubCons)) > 0, Aval_DistEscPubCons, Cadena_Default) AS Aval_DistEscPubCons,
            IF(LENGTH(TRIM(Aval_ObjSocEscConstitutiva)) > 0, Aval_ObjSocEscConstitutiva, Cadena_Default) AS Aval_ObjSocEscConstitutiva,
            IF(LENGTH(TRIM(Aval_NombreApoderado)) > 0, Aval_NombreApoderado, Cadena_Default) AS Aval_NombreApoderado,
            IF(LENGTH(TRIM(Aval_TituloApoderado)) > 0, Aval_TituloApoderado, Cadena_Vacia) AS Aval_TituloApoderado,
            IF(LENGTH(TRIM(Aval_NumEscPoder)) > 0, Aval_NumEscPoder, Cadena_Default) AS Aval_NumEscPoder,
            IF(LENGTH(TRIM(Aval_LocEscPoder)) > 0, Aval_LocEscPoder, Cadena_Default) AS Aval_LocEscPoder,
            IF(LENGTH(TRIM(Aval_EdoEscPoder)) > 0, Aval_EdoEscPoder, Cadena_Default) AS Aval_EdoEscPoder,
            IF(LENGTH(TRIM(Aval_NomNotarioEscPoder)) > 0, Aval_NomNotarioEscPoder, Cadena_Default) AS Aval_NomNotarioEscPoder,
            IF(LENGTH(TRIM(Aval_NotariaPoder)) > 0, Aval_NotariaPoder, Cadena_Default) AS Aval_NotariaPoder,
            IF(LENGTH(TRIM(Aval_EdoNotEscPoder)) > 0, Aval_EdoNotEscPoder, Cadena_Default) AS Aval_EdoNotEscPoder,
            IF(LENGTH(TRIM(Aval_LocNot)) > 0, Aval_LocNot, Cadena_Default) AS Aval_LocNot,
            IF(LENGTH(TRIM(Aval_EdoRegEscPoder)) > 0, Aval_EdoRegEscPoder, Cadena_Default) AS Aval_EdoRegEscPoder,
            IF(LENGTH(TRIM(Aval_DistRegEscPoder)) > 0, Aval_DistRegEscPoder, Cadena_Default) AS Aval_DistRegEscPoder,
            IF(LENGTH(TRIM(Aval_DirNumExt)) > 0, Aval_DirNumExt, Cadena_Default) AS Aval_DirNumExt,
            IF(LENGTH(TRIM(Aval_DirCalle)) > 0, Aval_DirCalle, Cadena_Default) AS Aval_DirCalle,
            IF(LENGTH(TRIM(Aval_DirColonia)) > 0, Aval_DirColonia, Cadena_Default) AS Aval_DirColonia,
            IF(LENGTH(TRIM(Aval_DirCP)) > 0, Aval_DirCP, Cadena_Default) AS Aval_DirCP,
            IF(LENGTH(TRIM(Aval_DirLocalidad)) > 0, Aval_DirLocalidad, Cadena_Default) AS Aval_DirLocalidad,
            IF(LENGTH(TRIM(Aval_DirEstado)) > 0, Aval_DirEstado, Cadena_Default) AS Aval_DirEstado,
            IF(LENGTH(TRIM(Var_AvalRFC)) > 0, Var_AvalRFC, Cadena_Default) AS Var_AvalRFC,
            IF(LENGTH(TRIM(MontoPagotxt)) > 0, MontoPagotxt, Cadena_Default) AS MontoPagotxt,
            IF(LENGTH(TRIM(CATLRtxt)) > 0, CATLRtxt, Cadena_Default) AS CATLRtxt,
            IF(LENGTH(TRIM(Var_NumAmorti)) > 0, Var_NumAmorti, Cadena_Default) AS Var_NumAmorti,
            IFNULL(FORMAT(Var_MontoPago,2),Cadena_Default) AS Var_MontoPago,
            IF(LENGTH(TRIM(Var_FechaCorte)) > 0, CAST(Var_FechaCorte AS CHAR CHARACTER SET utf8 ), Cadena_Default) AS Var_FechaCorte,
            IF(LENGTH(TRIM(FechaTerminoMora200)) > 0, FechaTerminoMora200, Cadena_Default) AS FechaTerminoMora200,
            IF(LENGTH(TRIM(ValorMoraCatorcenalPC200)) > 0, ValorMoraCatorcenalPC200, Cadena_Default) AS ValorMoraCatorcenalPC200,
            IF(LENGTH(TRIM(taordinariatxt)) > 0, taordinariatxt, Cadena_Default) AS taordinariatxt,
            IF(LENGTH(TRIM(tasaOrdinariaMensualtxt)) > 0, tasaOrdinariaMensualtxt, Cadena_Default) AS tasaOrdinariaMensualtxt,
            IF(LENGTH(TRIM(Var_NombreMuni)) > 0, Var_NombreMuni, Cadena_Default) AS Var_NombreMuni,
            IF(LENGTH(TRIM(Var_NombreEstadom)) > 0, Var_NombreEstadom, Cadena_Default) AS Var_NombreEstadom,
            IF(LENGTH(TRIM(FechaSistematxt)) > 0, FechaSistematxt, Cadena_Default) AS FechaSistematxt,
            IF(LENGTH(TRIM(NombreAval)) > 0, NombreAval, Cadena_Default) AS NombreAval,
            IF(LENGTH(TRIM(Var_NumRECA)) > 0, Var_NumRECA, Cadena_Default) AS Var_NumRECA,

            IF(LENGTH(TRIM(Var_DescProducto)) > 0, Var_DescProducto, Cadena_Default) AS Var_DescProducto,
            Var_CATLR,
            taOrdCarat,
            taiva,
            Var_TasaAnual,
            IFNULL(FORMAT(Var_MontoCred,2),Cadena_Default) AS Var_MontoCred,
            IF(LENGTH(TRIM(Var_Plazo)) > 0, Var_Plazo, Cadena_Default) AS Var_Plazo,
            IF(LENGTH(TRIM(Var_NomRepres)) > 0, Var_NomRepres, Cadena_Default) AS Var_NomRepres
            ;
    WHEN IFNULL(CAST(Var_ProductoCre AS UNSIGNED),Entero_Cero) BETWEEN 300 AND 399  THEN
      SELECT
        IF(LENGTH(TRIM(Var_NombreInstitucion)) > 0, Var_NombreInstitucion, Cadena_Default) AS Var_NombreInstitucion,
        IF(LENGTH(TRIM(Var_DirFiscalInstitucion)) > 0, Var_DirFiscalInstitucion, Cadena_Default) AS Var_DirFiscalInstitucion,
        IF(LENGTH(TRIM(Var_RepresentanteLegal)) > 0, Var_RepresentanteLegal, Cadena_Default) AS Var_RepresentanteLegal,
        IF(LENGTH(TRIM(TipoPersona)) > 0, TipoPersona, Cadena_Default) AS TipoPersona,
        IF(LENGTH(TRIM(RazonSocial)) > 0, RazonSocial, Cadena_Default) AS RazonSocial,
        IF(LENGTH(TRIM(Titulo)) > 0, Titulo, Cadena_Default) AS Titulo,
        IF(LENGTH(TRIM(NombreCompleto)) > 0, NombreCompleto, Cadena_Default) AS NombreCompleto,
        IF(LENGTH(TRIM(Var_RepresentantePM)) > 0, Var_RepresentantePM, Cadena_Default) AS Var_RepresentantePM,
        IF(LENGTH(TRIM(Var_AvalNombreCompleto)) > 0, Var_AvalNombreCompleto, Cadena_Default) AS Var_AvalNombreCompleto,
        IF(LENGTH(TRIM(Sexo)) > 0, Sexo, Cadena_Default) AS Sexo,
        IF(LENGTH(TRIM(FechaNacimientoFtoTxt)) > 0, FechaNacimientoFtoTxt, Cadena_Default) AS FechaNacimientoFtoTxt,
        IF(LENGTH(TRIM(EstadoNacimiento)) > 0, EstadoNacimiento, Cadena_Default) AS EstadoNacimiento,
        IF(LENGTH(TRIM(PaisNacimiento)) > 0, PaisNacimiento, Cadena_Default) AS PaisNacimiento,
        IF(LENGTH(TRIM(Nacionalidad)) > 0, Nacionalidad, Cadena_Default) AS Nacionalidad,
        IF(LENGTH(TRIM(Ocupacion)) > 0, Ocupacion, Cadena_Default) AS Ocupacion,
        IF(LENGTH(TRIM(GradoEstudios)) > 0, GradoEstudios, Cadena_Default) AS GradoEstudios,
        IF(LENGTH(TRIM(Profesion)) > 0, Profesion, Cadena_Default) AS Profesion,
        IF(LENGTH(TRIM(ActividadEconomica)) > 0, ActividadEconomica, Cadena_Default) AS ActividadEconomica,
        IF(LENGTH(TRIM(EstadoCivil)) > 0, EstadoCivil, Cadena_Default) AS EstadoCivil,
        IF(LENGTH(TRIM(Telefono)) > 0, Telefono, Cadena_Default) AS Telefono,
        IF(LENGTH(TRIM(Correo)) > 0, Correo, Cadena_Default) AS Correo,
        IF(LENGTH(TRIM(CURP)) > 0, CURP, Cadena_Default) AS CURP,
        IF(LENGTH(TRIM(Var_DireccionCompleta)) > 0, Var_DireccionCompleta, Cadena_Default) AS Var_DireccionCompleta,
        IF(LENGTH(TRIM(RFC)) > 0, RFC, Cadena_Default) AS RFC,
        IF(LENGTH(TRIM(Aval_TipoPersona)) > 0,Aval_TipoPersona, Cadena_Default) AS Aval_TipoPersona,
        IF(LENGTH(TRIM(Var_AvalNombreCompleto)) > 0, Var_AvalNombreCompleto, Cadena_Default) AS Var_AvalNombreCompleto,
        IF(LENGTH(TRIM(Var_AvalRazonSocial)) > 0, Var_AvalRazonSocial, Cadena_Default) AS Var_AvalRazonSocial,
        IF(LENGTH(TRIM(Var_AvalSexo)) > 0, Var_AvalSexo, Cadena_Default) AS Var_AvalSexo,
        IF(LENGTH(TRIM(Var_AvalFechaNacimiento)) > 0, Var_AvalFechaNacimiento, Cadena_Default) AS Var_AvalFechaNacimiento,
        IF(LENGTH(TRIM(Var_AvalEdo)) > 0, Var_AvalEdo, Cadena_Default) AS Var_AvalEdo,
        IF(LENGTH(TRIM(Var_AvalPais)) > 0, Var_AvalPais, Cadena_Default) AS Var_AvalPais,
        IF(LENGTH(TRIM(Var_AvalNacion)) > 0, Var_AvalNacion, Cadena_Default) AS Var_AvalNacion,
        IF(LENGTH(TRIM(Var_AvalOcupacion)) > 0, Var_AvalOcupacion, Cadena_Default) AS Var_AvalOcupacion,
        IF(LENGTH(TRIM(Var_AvalGradoEstudio)) > 0, Var_AvalGradoEstudio, Cadena_Default) AS Var_AvalGradoEstudio,
        IF(LENGTH(TRIM(Var_AvalProfesion)) > 0, Var_AvalProfesion, Cadena_Default) AS Var_AvalProfesion,
        IF(LENGTH(TRIM(Var_AvalActEco)) > 0, Var_AvalActEco, Cadena_Default) AS Var_AvalActEco,
        IF(LENGTH(TRIM(Var_AvalEdoCivil)) > 0, Var_AvalEdoCivil, Cadena_Default) AS Var_AvalEdoCivil,
        IF(LENGTH(TRIM(Var_AvalTel)) > 0, Var_AvalTel, Cadena_Default) AS Var_AvalTel,
        IF(LENGTH(TRIM(Var_AvalCorreo)) > 0, Var_AvalCorreo, Cadena_Default) AS Var_AvalCorreo,
        IF(LENGTH(TRIM(Var_AvalCURP)) > 0, Var_AvalCURP, Cadena_Default) AS Var_AvalCURP,
        IF(LENGTH(TRIM(Aval_DirCalle)) > 0, Aval_DirCalle, Cadena_Default) AS Aval_DirCalle,
        IF(LENGTH(TRIM(Aval_DirColonia)) > 0, Aval_DirColonia, Cadena_Default) AS Aval_DirColonia,
        IF(LENGTH(TRIM(Aval_DirCP)) > 0, Aval_DirCP, Cadena_Default) AS Aval_DirCP,
        IF(LENGTH(TRIM(Aval_DirLocalidad)) > 0, Aval_DirLocalidad, Cadena_Default) AS Aval_DirLocalidad,
        IF(LENGTH(TRIM(Aval_DirEstado)) > 0, Aval_DirEstado, Cadena_Default) AS Aval_DirEstado,
        IF(LENGTH(TRIM(Var_AvalRFC)) > 0, Var_AvalRFC, Cadena_Default) AS Var_AvalRFC,
        IF(LENGTH(TRIM(MontoPagotxt)) > 0, MontoPagotxt, Cadena_Default) AS MontoPagotxt,
        IF(LENGTH(TRIM(CATLRtxt)) > 0, CATLRtxt, Cadena_Default) AS CATLRtxt,
        IFNULL(Var_NumAmorti,Cadena_Default) AS Var_NumAmorti,
        IF(LENGTH(TRIM(PlazoCredito)) > 0, PlazoCredito, Cadena_Default) AS PlazoCredito,
        IF(LENGTH(TRIM(Var_MontoRetencion)) > 0, Var_MontoRetencion, Cadena_Default) AS Var_MontoRetencion,
        IF(LENGTH(TRIM(taordinaria)) > 0, taordinaria, Cadena_Default) AS taordinaria,
        IF(LENGTH(TRIM(tasaOrdinariaMensual)) > 0, tasaOrdinariaMensual, Cadena_Default) AS tasaOrdinariaMensual,
        IF(LENGTH(TRIM(MontoGarantiaLiquida)) > 0, MontoGarantiaLiquida, Cadena_Default) AS MontoGarantiaLiquida,
        IF(LENGTH(TRIM(Var_NombreMuni)) > 0, Var_NombreMuni, Cadena_Default) AS Var_NombreMuni,
        IF(LENGTH(TRIM(Var_NombreEstadom)) > 0, Var_NombreEstadom, Cadena_Default) AS Var_NombreEstadom,
        IF(LENGTH(TRIM(FechaSistematxt)) > 0, FechaSistematxt, Cadena_Default) AS FechaSistematxt,
        IF(LENGTH(TRIM(NombreAval)) > 0, NombreAval, Cadena_Default) AS NombreAval,
        IF(LENGTH(TRIM(Var_NumRECA)) > 0, Var_NumRECA, Cadena_Default) AS Var_NumRECA,
        IF(LENGTH(TRIM(Var_DescProducto)) > 0, Var_DescProducto, Cadena_Default) AS Var_DescProducto,
        IFNULL(Var_CATLR,Cadena_Default) AS Var_CATLR,
        IF(LENGTH(TRIM(taOrdCarat)) > 0, taOrdCarat, Cadena_Default) AS taOrdCarat,
        IF(LENGTH(TRIM(taiva)) > 0, taiva, Cadena_Default) AS taiva,
        IFNULL(Var_TasaAnual,Cadena_Default) AS Var_TasaAnual,
        IFNULL(FORMAT(Var_MontoCred,2),Cadena_Default) AS Var_MontoCred,
        IFNULL(FORMAT(Var_MontoPago,2),Cadena_Default) AS Var_MontoPago,
        IF(LENGTH(TRIM(Var_Plazo)) > 0, Var_Plazo, Cadena_Default) AS Var_Plazo,
        IF(LENGTH(TRIM(FechaTerminoMora)) > 0, FechaTerminoMora, Cadena_Default) AS FechaTerminoMora,
        IF(LENGTH(TRIM(Var_FechaCorte)) > 0, CAST(Var_FechaCorte AS CHAR CHARACTER SET utf8 ), Cadena_Default) AS Var_FechaCorte,
        IFNULL(Var_ProductoCre,Cadena_Default) AS Var_ProductoCre,
        IF(LENGTH(TRIM(Var_NomRepres)) > 0, Var_NomRepres, Cadena_Default) AS Var_NomRepres,
        IF(LENGTH(TRIM(GarHip_Desc)) > 0, GarHip_Desc, Cadena_Default) AS GarHip_Desc,
        IF(LENGTH(TRIM(GarHip_Ref)) > 0, CONCAT('Testimonio Notarial NÃºmero ',GarHip_Ref), Cadena_Default) AS GarHip_Ref,
        IF(LENGTH(TRIM(GarHip_Mun)) > 0, GarHip_Mun, Cadena_Default)      AS GarHip_Mun,
        IF(LENGTH(TRIM(GarHip_Edo)) > 0, GarHip_Edo, Cadena_Default)      AS GarHip_Edo,
        IF(LENGTH(TRIM(GarHip_FechaReg)) > 0, GarHip_FechaReg, Cadena_Default)  AS GarHip_FechaReg,
        IF(LENGTH(TRIM(GarReal_Desc)) > 0, GarReal_Desc, Cadena_Default)    AS GarReal_Desc,
        IF(LENGTH(TRIM(GarReal_TipDocu)) > 0, GarReal_TipDocu, Cadena_Default)  AS GarReal_TipDocu
        ;

    WHEN IFNULL(CAST(Var_ProductoCre AS UNSIGNED),Entero_Cero) BETWEEN 400 AND 499  THEN
      IF ( TipoPersona  = PersonaMoral )  THEN
        SELECT
            IF(LENGTH(TRIM(Var_NombreInstitucion)) > 0, Var_NombreInstitucion, Cadena_Default) AS Var_NombreInstitucion,
            IF(LENGTH(TRIM(Var_DirFiscalInstitucion)) > 0, Var_DirFiscalInstitucion, Cadena_Default) AS Var_DirFiscalInstitucion,
            Cadena_Default AS Titulo,
            Cadena_Default AS NombreCompleto,
            Cadena_Default AS Var_AvalNombreCompleto,
            Cadena_Default AS Sexo,
            Cadena_Default AS FechaNacimientoFtoTxt,
            Cadena_Default AS EstadoNacimiento,
            Cadena_Default AS PaisNacimiento,
            Cadena_Default AS Nacionalidad,
            Cadena_Default AS Ocupacion,
            Cadena_Default AS GradoEstudios,
            Cadena_Default AS Profesion,
            Cadena_Default AS ActividadEconomica,
            Cadena_Default AS EstadoCivil,
            Cadena_Default AS Telefono,
            Cadena_Default AS Correo,
            Cadena_Default AS CURP,
            Cadena_Default AS Var_NumCasa,
            Cadena_Default AS Var_Calle,
            Cadena_Default AS Var_NombreColonia,
            Cadena_Default AS Var_CP,
            Cadena_Default AS Var_Ciudad,
            Cadena_Default AS Var_NombreEstado,
            Cadena_Default AS RFC,
            Cadena_Default AS NombreAval,
            Cadena_Default AS Var_AvalSexo,
            Cadena_Default AS Var_AvalFechaNacimiento,
            Cadena_Default AS Var_AvalEdo,
            Cadena_Default AS Var_AvalPais,
            Cadena_Default AS Var_AvalNacion,
            Cadena_Default AS Var_AvalOcupacion,
            Cadena_Default AS Var_AvalGradoEstudio,
            Cadena_Default AS Var_AvalProfesion,
            Cadena_Default AS Var_AvalActEco,
            Cadena_Default AS Var_AvalEdoCivil,
            Cadena_Default AS Var_AvalTel,
            Cadena_Default AS Var_AvalCorreo,
            Cadena_Default AS Var_AvalCURP,
            Cadena_Default AS Aval_DirNumExt,
            Cadena_Default AS Aval_DirCalle,
            Cadena_Default AS Aval_DirColonia,
            Cadena_Default AS Aval_DirCP,
            Cadena_Default AS Aval_DirLocalidad,
            Cadena_Default AS Aval_DirEstado,
            Cadena_Default AS Var_AvalRFC,
            IF(LENGTH(TRIM(MontoPagotxt)) > 0, MontoPagotxt, Cadena_Default) AS MontoPagotxt,
            IF(LENGTH(TRIM(CATLRtxt)) > 0, CATLRtxt, Cadena_Default) AS CATLRtxt,
            IF(LENGTH(TRIM(Var_NumAmorti)) > 0, Var_NumAmorti, Cadena_Default) AS Var_NumAmorti,
            IF(LENGTH(TRIM(PlazoCredito)) > 0, PlazoCredito, Cadena_Default) AS PlazoCredito,
            IF(LENGTH(TRIM(Var_MontoRetencion)) > 0, Var_MontoRetencion, Cadena_Default) AS Var_MontoRetencion,
            IF(LENGTH(TRIM(ValorMoraPC400)) > 0, ValorMoraPC400, Cadena_Default) AS ValorMoraPC400,
            IF(LENGTH(TRIM(PenaConvtxtPC400)) > 0, PenaConvtxtPC400, Cadena_Default) AS PenaConvtxtPC400,
            IF(LENGTH(TRIM(taordinariatxt)) > 0, taordinariatxt, Cadena_Default) AS taordinariatxt,
            IF(LENGTH(TRIM(tasaOrdinariaMensualtxt)) > 0, tasaOrdinariaMensualtxt, Cadena_Default) AS tasaOrdinariaMensualtxt,
            IF(LENGTH(TRIM(DescripcionGarantiaRealObligadoSolidario)) > 0, DescripcionGarantiaRealObligadoSolidario, Cadena_Default) AS DescripcionGarantiaRealObligadoSolidario,
            IF(LENGTH(TRIM(factura)) > 0, factura, Cadena_Default) AS factura,
            IF(LENGTH(TRIM(DescripcionGarantiaRealAcreditado)) > 0, DescripcionGarantiaRealAcreditado, Cadena_Default) AS DescripcionGarantiaRealAcreditado,
            IF(LENGTH(TRIM(Var_DireccionCompleta)) > 0, Var_DireccionCompleta, Cadena_Default) AS DireccionCompleta,
            IF(LENGTH(TRIM(Var_ExisteGarReal)) > 0, Var_ExisteGarReal, Cadena_Default) AS Var_ExisteGarReal,
            IF(LENGTH(TRIM(Var_Garantias)) > 0, Var_Garantias, Cadena_Default) AS Var_Garantias,
            IF(LENGTH(TRIM(Var_TipoDocumentoTxt)) > 0, Var_TipoDocumentoTxt, Cadena_Default) AS Var_TipoDocumentoTxt,
            IF(LENGTH(TRIM(LocalidadRegEscPPoderes)) > 0, LocalidadRegEscPPoderes, Cadena_Default) AS LocalidadRegEscPPoderes,
            IF(LENGTH(TRIM(EstadoRegEscPPoderes)) > 0, EstadoRegEscPPoderes, Cadena_Default) AS EstadoRegEscPPoderes,
            IFNULL(Var_FechaGarantia,Cadena_Default) AS Var_FechaGarantia,
            IF(LENGTH(TRIM(Var_NombreMuni)) > 0, Var_NombreMuni, Cadena_Default) AS Var_NombreMuni,
            IF(LENGTH(TRIM(Var_NombreEstadom)) > 0, Var_NombreEstadom, Cadena_Default) AS Var_NombreEstadom,
            IF(LENGTH(TRIM(FechaSistematxt)) > 0, FechaSistematxt, Cadena_Default) AS FechaSistematxt,
            IF(LENGTH(TRIM(Var_NumRECA)) > 0, Var_NumRECA, Cadena_Default) AS Var_NumRECA,

            IF(LENGTH(TRIM(Var_DescProducto)) > 0, Var_DescProducto, Cadena_Default) AS Var_DescProducto,
            IFNULL(Var_CATLR,Cadena_Default) AS Var_CATLR,
            IF(LENGTH(TRIM(taOrdCarat)) > 0, taOrdCarat, Cadena_Default) AS taOrdCarat,
            IF(LENGTH(TRIM(taiva)) > 0, taiva, Cadena_Default) AS taiva,
            IFNULL(Var_TasaAnual,Cadena_Default) AS Var_TasaAnual,
            IFNULL(FORMAT(Var_MontoCred,2),Cadena_Default) AS Var_MontoCred,
            IFNULL(FORMAT(Var_MontoPago,2),Cadena_Default) AS Var_MontoPago,
            IF(LENGTH(TRIM(Var_Plazo)) > 0, Var_Plazo, Cadena_Default) AS Var_Plazo,
            IF(LENGTH(TRIM(FechaTerminoMora)) > 0, FechaTerminoMora, Cadena_Default) AS FechaTerminoMora,
            IF(LENGTH(TRIM(Var_FechaCorte)) > 0, CAST(Var_FechaCorte AS CHAR CHARACTER SET utf8 ), Cadena_Default) AS Var_FechaCorte,
            IFNULL(Var_ProductoCre,Cadena_Default) AS Var_ProductoCre,
            IF(LENGTH(TRIM(Var_NomRepres)) > 0, Var_NomRepres, Cadena_Default) AS Var_NomRepres,
            IF(LENGTH(TRIM(RazonSocial)) > 0, RazonSocial, Cadena_Default) AS RazonSocial,

            Cadena_Default  AS  GarHip_Desc,
            Cadena_Default  AS  GarHip_Ref,
            Cadena_Default  AS  GarHip_Mun,
            Cadena_Default  AS  GarHip_Edo,
            Cadena_Default  AS  GarHip_FechaReg,
            Cadena_Default  AS  GarReal_Desc,
            Cadena_Default  AS  GarReal_TipDocu,
            Cadena_Default  AS  GarReal_Ref,
            Cadena_Default  AS  GarHip_Hipo,
            Cadena_Default  AS  AvalSerieFactura,
            Cadena_Default  AS  AvalGarRealDesc,
            Cadena_Default  AS  AvalGarRealRef,
            Cadena_Default  AS  AvalGarRealTipDoc,
            Cadena_Default  AS  AvalGarHipHipo,
            Cadena_Default  AS  AvalGarHipDesc,
            Cadena_Default  AS  AvalGarHipRef,
            Cadena_Default  AS  AvalGarHipMun,
            Cadena_Default  AS  AvalGarHipDesc,
            Cadena_Default  AS  AvalGarHipEdo,
            Cadena_Default  AS  AvalGarHipFecReg
          ;
      ELSE
        SELECT
            IF(LENGTH(TRIM(Var_NombreInstitucion)) > 0, Var_NombreInstitucion, Cadena_Default) AS Var_NombreInstitucion,
            IF(LENGTH(TRIM(Var_DirFiscalInstitucion)) > 0, Var_DirFiscalInstitucion, Cadena_Default) AS Var_DirFiscalInstitucion,
            IF(LENGTH(TRIM(Titulo)) > 0, Titulo, Cadena_Default) AS Titulo,
            IF(LENGTH(TRIM(NombreCompleto)) > 0, NombreCompleto, Cadena_Default) AS NombreCompleto,
            IF(LENGTH(TRIM(Var_AvalRazonSocial)) > 0, Var_AvalRazonSocial, Cadena_Default) AS Var_AvalRazonSocial,
            IF(LENGTH(TRIM(Var_AvalNombreCompleto)) > 0, Var_AvalNombreCompleto, Cadena_Default) AS Var_AvalNombreCompleto,
            IF(LENGTH(TRIM(Sexo)) > 0, Sexo, Cadena_Default) AS Sexo,
            IF(LENGTH(TRIM(FechaNacimientoFtoTxt)) > 0, FechaNacimientoFtoTxt, Cadena_Default) AS FechaNacimientoFtoTxt,
            IF(LENGTH(TRIM(EstadoNacimiento)) > 0, EstadoNacimiento, Cadena_Default) AS EstadoNacimiento,
            IF(LENGTH(TRIM(PaisNacimiento)) > 0, PaisNacimiento, Cadena_Default) AS PaisNacimiento,
            IF(LENGTH(TRIM(Nacionalidad)) > 0, Nacionalidad, Cadena_Default) AS Nacionalidad,
            IF(LENGTH(TRIM(Ocupacion)) > 0, Ocupacion, Cadena_Default) AS Ocupacion,
            IF(LENGTH(TRIM(GradoEstudios)) > 0, GradoEstudios, Cadena_Default) AS GradoEstudios,
            IF(LENGTH(TRIM(Profesion)) > 0, Profesion, Cadena_Default) AS Profesion,
            IF(LENGTH(TRIM(ActividadEconomica)) > 0, ActividadEconomica, Cadena_Default) AS ActividadEconomica,
            IF(LENGTH(TRIM(EstadoCivil)) > 0, EstadoCivil, Cadena_Default) AS EstadoCivil,
            IF(LENGTH(TRIM(Telefono)) > 0, Telefono, Cadena_Default) AS Telefono,
            IF(LENGTH(TRIM(Correo)) > 0, Correo, Cadena_Default) AS Correo,
            IF(LENGTH(TRIM(CURP)) > 0, CURP, Cadena_Default) AS CURP,
            IF(LENGTH(TRIM(Var_NumCasa)) > 0, Var_NumCasa, Cadena_Default) AS Var_NumCasa,
            IF(LENGTH(TRIM(Var_Calle)) > 0, Var_Calle, Cadena_Default) AS Var_Calle,
            IF(LENGTH(TRIM(Var_NombreColonia)) > 0, Var_NombreColonia, Cadena_Default) AS Var_NombreColonia,
            IF(LENGTH(TRIM(Var_CP)) > 0, Var_CP, Cadena_Default) AS Var_CP,
            IF(LENGTH(TRIM(Var_Ciudad)) > 0, Var_Ciudad, Cadena_Default) AS Var_Ciudad,
            IF(LENGTH(TRIM(Var_NombreEstado)) > 0, Var_NombreEstado, Cadena_Default) AS Var_NombreEstado,
            IF(LENGTH(TRIM(RFC)) > 0, RFC, Cadena_Default) AS RFC,
            IF(LENGTH(TRIM(NombreAval)) > 0, NombreAval, Cadena_Default) AS NombreAval,
            IF(LENGTH(TRIM(Var_AvalSexo)) > 0, Var_AvalSexo, Cadena_Default) AS Var_AvalSexo,
            IF(LENGTH(TRIM(Var_AvalFechaNacimiento)) > 0, Var_AvalFechaNacimiento, Cadena_Default) AS Var_AvalFechaNacimiento,
            IF(LENGTH(TRIM(Var_AvalEdo)) > 0, Var_AvalEdo, Cadena_Default) AS Var_AvalEdo,
            IF(LENGTH(TRIM(Var_AvalPais)) > 0, Var_AvalPais, Cadena_Default) AS Var_AvalPais,
            IF(LENGTH(TRIM(Var_AvalNacion)) > 0, Var_AvalNacion, Cadena_Default) AS Var_AvalNacion,
            IF(LENGTH(TRIM(Var_AvalOcupacion)) > 0, Var_AvalOcupacion, Cadena_Default) AS Var_AvalOcupacion,
            IF(LENGTH(TRIM(Var_AvalGradoEstudio)) > 0, Var_AvalGradoEstudio, Cadena_Default) AS Var_AvalGradoEstudio,
            IF(LENGTH(TRIM(Var_AvalProfesion)) > 0, Var_AvalProfesion, Cadena_Default) AS Var_AvalProfesion,
            IF(LENGTH(TRIM(Var_AvalActEco)) > 0, Var_AvalActEco, Cadena_Default) AS Var_AvalActEco,
            IF(LENGTH(TRIM(Var_AvalEdoCivil)) > 0, Var_AvalEdoCivil, Cadena_Default) AS Var_AvalEdoCivil,
            IF(LENGTH(TRIM(Var_AvalTel)) > 0, Var_AvalTel, Cadena_Default) AS Var_AvalTel,
            IF(LENGTH(TRIM(Var_AvalCorreo)) > 0, Var_AvalCorreo, Cadena_Default) AS Var_AvalCorreo,
            IF(LENGTH(TRIM(Var_AvalCURP)) > 0, Var_AvalCURP, Cadena_Default) AS Var_AvalCURP,
            IF(LENGTH(TRIM(Aval_DirNumExt)) > 0, Aval_DirNumExt, Cadena_Default) AS Aval_DirNumExt,
            IF(LENGTH(TRIM(Aval_DirCalle)) > 0, Aval_DirCalle, Cadena_Default) AS Aval_DirCalle,
            IF(LENGTH(TRIM(Aval_DirColonia)) > 0, Aval_DirColonia, Cadena_Default) AS Aval_DirColonia,
            IF(LENGTH(TRIM(Aval_DirCP)) > 0, Aval_DirCP, Cadena_Default) AS Aval_DirCP,
            IF(LENGTH(TRIM(Aval_DirLocalidad)) > 0, Aval_DirLocalidad, Cadena_Default) AS Aval_DirLocalidad,
            IF(LENGTH(TRIM(Aval_DirEstado)) > 0, Aval_DirEstado, Cadena_Default) AS Aval_DirEstado,
            IF(LENGTH(TRIM(Var_AvalRFC)) > 0, Var_AvalRFC, Cadena_Default) AS Var_AvalRFC,
            IF(LENGTH(TRIM(MontoPagotxt)) > 0, MontoPagotxt, Cadena_Default) AS MontoPagotxt,
            IF(LENGTH(TRIM(CATLRtxt)) > 0, CATLRtxt, Cadena_Default) AS CATLRtxt,
            IF(LENGTH(TRIM(Var_NumAmorti)) > 0, Var_NumAmorti, Cadena_Default) AS Var_NumAmorti,
            IF(LENGTH(TRIM(PlazoCredito)) > 0, PlazoCredito, Cadena_Default) AS PlazoCredito,
            IF(LENGTH(TRIM(Var_MontoRetencion)) > 0, Var_MontoRetencion, Cadena_Default) AS Var_MontoRetencion,
            IF(LENGTH(TRIM(ValorMoraPC400)) > 0, ValorMoraPC400, Cadena_Default) AS ValorMoraPC400,
            IF(LENGTH(TRIM(PenaConvtxtPC400)) > 0, PenaConvtxtPC400, Cadena_Default) AS PenaConvtxtPC400,
            IF(LENGTH(TRIM(taordinariatxt)) > 0, taordinariatxt, Cadena_Default) AS taordinariatxt,
            IF(LENGTH(TRIM(tasaOrdinariaMensualtxt)) > 0, tasaOrdinariaMensualtxt, Cadena_Default) AS tasaOrdinariaMensualtxt,
            IF(LENGTH(TRIM(Var_Factura)) > 0, Var_Factura, Cadena_Default) AS factura,
            IF(LENGTH(TRIM(Var_DireccionCompleta)) > 0, Var_DireccionCompleta, Cadena_Default) AS DireccionCompleta,
            IF(LENGTH(TRIM(Var_ExisteGarReal)) > 0, Var_ExisteGarReal, Cadena_Default) AS Var_ExisteGarReal,
            IF(LENGTH(TRIM(Var_Garantias)) > 0, Var_Garantias, Cadena_Default) AS Var_Garantias,
            IF(LENGTH(TRIM(Var_TipoDocumentoTxt)) > 0, Var_TipoDocumentoTxt, Cadena_Default) AS Var_TipoDocumentoTxt,
            IF(LENGTH(TRIM(LocalidadRegEscPPoderes)) > 0, LocalidadRegEscPPoderes, Cadena_Default) AS LocalidadRegEscPPoderes,
            IF(LENGTH(TRIM(EstadoRegEscPPoderes)) > 0, EstadoRegEscPPoderes, Cadena_Default) AS EstadoRegEscPPoderes,
            IFNULL(Var_FechaGarantia,Cadena_Default) AS Var_FechaGarantia,
            IF(LENGTH(TRIM(Var_NombreMuni)) > 0, Var_NombreMuni, Cadena_Default) AS Var_NombreMuni,
            IF(LENGTH(TRIM(Var_NombreEstadom)) > 0, Var_NombreEstadom, Cadena_Default) AS Var_NombreEstadom,
            IF(LENGTH(TRIM(FechaSistematxt)) > 0, FechaSistematxt, Cadena_Default) AS FechaSistematxt,
            IF(LENGTH(TRIM(Var_NumRECA)) > 0, Var_NumRECA, Cadena_Default) AS Var_NumRECA,
            IF(LENGTH(TRIM(Aval_TipoPersona)) > 0,Aval_TipoPersona, Cadena_Default) AS Aval_TipoPersona,
            IF(LENGTH(TRIM(TipoPersona)) > 0, TipoPersona, Cadena_Default) AS TipoPersona,

            IF(LENGTH(TRIM(Var_DescProducto)) > 0, Var_DescProducto, Cadena_Default) AS Var_DescProducto,
            IFNULL(Var_CATLR,Cadena_Default) AS Var_CATLR,
            IF(LENGTH(TRIM(taOrdCarat)) > 0, taOrdCarat, Cadena_Default) AS taOrdCarat,
            IF(LENGTH(TRIM(taiva)) > 0, taiva, Cadena_Default) AS taiva,
            IFNULL(Var_TasaAnual,Cadena_Default) AS Var_TasaAnual,
            IFNULL(FORMAT(Var_MontoCred,2),Cadena_Default) AS Var_MontoCred,
            IFNULL(FORMAT(Var_MontoPago,2),Cadena_Default) AS Var_MontoPago,
            IF(LENGTH(TRIM(Var_Plazo)) > 0, Var_Plazo, Cadena_Default) AS Var_Plazo,
            IF(LENGTH(TRIM(FechaTerminoMora)) > 0, FechaTerminoMora, Cadena_Default) AS FechaTerminoMora,
            IF(LENGTH(TRIM(Var_FechaCorte)) > 0, CAST(Var_FechaCorte AS CHAR CHARACTER SET utf8 ), Cadena_Default) AS Var_FechaCorte,
            IFNULL(Var_ProductoCre,Cadena_Default) AS Var_ProductoCre,
            IF(LENGTH(TRIM(Var_NomRepres)) > 0, Var_NomRepres, Cadena_Default) AS Var_NomRepres,

            IF(LENGTH(TRIM(GarHip_Desc)) > 0, GarHip_Desc, Cadena_Default) AS GarHip_Desc,
            IF(LENGTH(TRIM(GarHip_Ref)) > 0, CONCAT('Testimonio Notarial NÃºmero ',GarHip_Ref), Cadena_Default) AS GarHip_Ref,
            IF(LENGTH(TRIM(GarHip_Mun)) > 0, GarHip_Mun, Cadena_Default)      AS GarHip_Mun,
            IF(LENGTH(TRIM(GarHip_Edo)) > 0, GarHip_Edo, Cadena_Default)      AS GarHip_Edo,
            IF(LENGTH(TRIM(GarHip_FechaReg)) > 0, GarHip_FechaReg, Cadena_Default)  AS GarHip_FechaReg,
            IF(LENGTH(TRIM(GarReal_Desc)) > 0, GarReal_Desc, Cadena_Default)    AS GarReal_Desc,
            IF(LENGTH(TRIM(GarReal_TipDocu)) > 0, GarReal_TipDocu, Cadena_Default)  AS GarReal_TipDocu,
            IF(LENGTH(TRIM(GarReal_Ref)) > 0, GarReal_Ref, Cadena_Default)  AS GarReal_Ref,
            IF(LENGTH(TRIM(GarHip_Hipo)) > 0, GarHip_Hipo, Cadena_Default)  AS GarHip_Hipo,
            IF(LENGTH(TRIM(AvalSerieFactura)) > 0, AvalSerieFactura, Cadena_Default)  AS AvalSerieFactura,
            IF(LENGTH(TRIM(AvalGarRealDesc)) > 0, AvalGarRealDesc, Cadena_Default)  AS AvalGarRealDesc,
            IF(LENGTH(TRIM(AvalGarRealRef)) > 0, AvalGarRealRef, Cadena_Default)  AS AvalGarRealRef,
            IF(LENGTH(TRIM(AvalGarRealTipDoc)) > 0, AvalGarRealTipDoc, Cadena_Default)  AS AvalGarRealTipDoc,
            IF(LENGTH(TRIM(AvalGarHipHipo)) > 0, AvalGarHipHipo, Cadena_Default)  AS AvalGarHipHipo,
            IF(LENGTH(TRIM(AvalGarHipDesc)) > 0, AvalGarHipDesc, Cadena_Default)  AS AvalGarHipDesc,
            IF(LENGTH(TRIM(AvalGarHipRef)) > 0, CONCAT('Testimonio Notarial NÃºmero ',AvalGarHipRef), Cadena_Default) AS AvalGarHipRef,
            IF(LENGTH(TRIM(AvalGarHipMun)) > 0, AvalGarHipMun, Cadena_Default)  AS AvalGarHipMun,
            IF(LENGTH(TRIM(AvalGarHipDesc)) > 0, AvalGarHipDesc, Cadena_Default)  AS AvalGarHipDesc,
            IF(LENGTH(TRIM(AvalGarHipEdo)) > 0, AvalGarHipEdo, Cadena_Default)  AS AvalGarHipEdo,
            IF(LENGTH(TRIM(AvalGarHipFecReg)) > 0, AvalGarHipFecReg, Cadena_Default)  AS AvalGarHipFecReg
          ;
      END IF;
    WHEN IFNULL(CAST(Var_ProductoCre AS UNSIGNED),Entero_Cero) BETWEEN 500 AND 599  THEN
      IF ( TipoPersona  = PersonaMoral )  THEN
        SELECT
            Cadena_Default AS Var_NombreInstitucion,
            Cadena_Default AS Var_DirFiscalInstitucion,
            Cadena_Default AS Titulo,
            Cadena_Default AS NombreCompleto,
            Cadena_Default AS Var_AvalNombreCompleto,
            Cadena_Default AS Sexo,
            Cadena_Default AS FechaNacimientoFtoTxt,
            Cadena_Default AS EstadoNacimiento,
            Cadena_Default AS PaisNacimiento,
            Cadena_Default AS Nacionalidad,
            Cadena_Default AS Ocupacion,
            Cadena_Default AS GradoEstudios,
            Cadena_Default AS Profesion,
            Cadena_Default AS ActividadEconomica,
            Cadena_Default AS EstadoCivil,
            Cadena_Default AS Telefono,
            Cadena_Default AS Correo,
            Cadena_Default AS CURP,
            Cadena_Default AS Var_NumCasa,
            Cadena_Default AS Var_Calle,
            Cadena_Default AS Var_NombreColonia,
            Cadena_Default AS Var_CP,
            Cadena_Default AS Var_Ciudad,
            Cadena_Default AS Var_NombreEstado,
            Cadena_Default AS RFC,
            Cadena_Default AS NombreAval,
            Cadena_Default AS Var_AvalSexo,
            Cadena_Default AS Var_AvalFechaNacimiento,
            Cadena_Default AS Var_AvalPais,
            Cadena_Default AS Var_AvalNacion,
            Cadena_Default AS Var_AvalOcupacion,
            Cadena_Default AS Var_AvalGradoEstudio,
            Cadena_Default AS Var_AvalEdoCivil,
            Cadena_Default AS Var_AvalTel,
            Cadena_Default AS Var_AvalCorreo,
            Cadena_Default AS Var_AvalCURP,
            Cadena_Default AS Aval_DirNumExt,
            Cadena_Default AS Aval_DirCalle,
            Cadena_Default AS Aval_DirColonia,
            Cadena_Default AS Aval_DirCP,
            Cadena_Default AS Aval_DirLocalidad,
            Cadena_Default AS Aval_DirEstado,
            Cadena_Default AS Var_AvalRFC,
            IF(LENGTH(TRIM(MontoPagotxt)) > 0, MontoPagotxt, Cadena_Default) AS MontoPagotxt,
            IF(LENGTH(TRIM(CATLRtxt)) > 0, CATLRtxt, Cadena_Default) AS CATLRtxt,
            IF(LENGTH(TRIM(Var_NumAmorti)) > 0, Var_NumAmorti, Cadena_Default) AS Var_NumAmorti,
            IF(LENGTH(TRIM(PlazoCredito)) > 0, PlazoCredito, Cadena_Default) AS PlazoCredito,
            IF(LENGTH(TRIM(Var_MontoRetencion)) > 0, Var_MontoRetencion, Cadena_Default) AS Var_MontoRetencion,
            IF(LENGTH(TRIM(taordinariatxt)) > 0, taordinariatxt, Cadena_Default) AS taordinariatxt,
            IF(LENGTH(TRIM(tasaOrdinariaMensualtxt)) > 0, tasaOrdinariaMensualtxt, Cadena_Default) AS tasaOrdinariaMensualtxt,
            IF(LENGTH(TRIM(Var_Factura)) > 0, Var_Factura, Cadena_Default) AS Var_Factura,
            IF(LENGTH(TRIM(Var_DireccionCompleta)) > 0, Var_DireccionCompleta, Cadena_Default) AS DireccionCompleta,
            IF(LENGTH(TRIM(Var_ExisteGarReal)) > 0, Var_ExisteGarReal, Cadena_Default) AS Var_ExisteGarReal,
            IF(LENGTH(TRIM(Var_Garantias)) > 0, Var_Garantias, Cadena_Default) AS Var_Garantias,
            IF(LENGTH(TRIM(Var_TipoDocumentoTxt)) > 0, Var_TipoDocumentoTxt, Cadena_Default) AS Var_TipoDocumentoTxt,
            IF(LENGTH(TRIM(LocalidadRegEscPPoderes)) > 0, LocalidadRegEscPPoderes, Cadena_Default) AS LocalidadRegEscPPoderes,
            IF(LENGTH(TRIM(EstadoRegEscPPoderes)) > 0, EstadoRegEscPPoderes, Cadena_Default) AS EstadoRegEscPPoderes,
            IFNULL(Var_FechaGarantia,Cadena_Default) AS Var_FechaGarantia,
            IF(LENGTH(TRIM(Var_NombreMuni)) > 0, Var_NombreMuni, Cadena_Default) AS Var_NombreMuni,
            IF(LENGTH(TRIM(Var_NombreEstadom)) > 0, Var_NombreEstadom, Cadena_Default) AS Var_NombreEstadom,
            IF(LENGTH(TRIM(FechaSistematxt)) > 0, FechaSistematxt, Cadena_Default) AS FechaSistematxt,
            IF(LENGTH(TRIM(Var_NumRECA)) > 0, Var_NumRECA, Cadena_Default) AS Var_NumRECA,

            IF(LENGTH(TRIM(Var_DescProducto)) > 0, Var_DescProducto, Cadena_Default) AS Var_DescProducto,
            IFNULL(Var_CATLR,Cadena_Default) AS Var_CATLR,
            IF(LENGTH(TRIM(taOrdCarat)) > 0, taOrdCarat, Cadena_Default) AS taOrdCarat,
            IF(LENGTH(TRIM(taiva)) > 0, taiva, Cadena_Default) AS taiva,
            IFNULL(Var_TasaAnual,Cadena_Default) AS Var_TasaAnual,
            IFNULL(FORMAT(Var_MontoCred,2),Cadena_Default) AS Var_MontoCred,
            IFNULL(FORMAT(Var_MontoPago,2),Cadena_Default) AS Var_MontoPago,
            IF(LENGTH(TRIM(Var_Plazo)) > 0, Var_Plazo, Cadena_Default) AS Var_Plazo,
            IF(LENGTH(TRIM(FechaTerminoMora)) > 0, FechaTerminoMora, Cadena_Default) AS FechaTerminoMora,
            IF(LENGTH(TRIM(Var_FechaCorte)) > 0, CAST(Var_FechaCorte AS CHAR CHARACTER SET utf8 ), Cadena_Default) AS Var_FechaCorte,
            IFNULL(Var_ProductoCre,Cadena_Default) AS Var_ProductoCre,
            IF(LENGTH(TRIM(Var_NomRepres)) > 0, Var_NomRepres, Cadena_Default) AS Var_NomRepres
          ;
      ELSE
        SELECT
            IF(LENGTH(TRIM(Var_NombreInstitucion)) > 0, Var_NombreInstitucion, Cadena_Default) AS Var_NombreInstitucion,
            IF(LENGTH(TRIM(Var_DirFiscalInstitucion)) > 0, Var_DirFiscalInstitucion, Cadena_Default) AS Var_DirFiscalInstitucion,
            IF(LENGTH(TRIM(Titulo)) > 0, Titulo, Cadena_Default) AS Titulo,
            IF(LENGTH(TRIM(NombreCompleto)) > 0, NombreCompleto, Cadena_Default) AS NombreCompleto,
            IF(LENGTH(TRIM(Var_AvalNombreCompleto)) > 0, Var_AvalNombreCompleto, Cadena_Default) AS Var_AvalNombreCompleto,
            IF(LENGTH(TRIM(Sexo)) > 0, Sexo, Cadena_Default) AS Sexo,
            IF(LENGTH(TRIM(FechaNacimientoFtoTxt)) > 0, FechaNacimientoFtoTxt, Cadena_Default) AS FechaNacimientoFtoTxt,
            IF(LENGTH(TRIM(EstadoNacimiento)) > 0, EstadoNacimiento, Cadena_Default) AS EstadoNacimiento,
            IF(LENGTH(TRIM(PaisNacimiento)) > 0, PaisNacimiento, Cadena_Default) AS PaisNacimiento,
            IF(LENGTH(TRIM(Nacionalidad)) > 0, Nacionalidad, Cadena_Default) AS Nacionalidad,
            IF(LENGTH(TRIM(Ocupacion)) > 0, Ocupacion, Cadena_Default) AS Ocupacion,
            IF(LENGTH(TRIM(GradoEstudios)) > 0, GradoEstudios, Cadena_Default) AS GradoEstudios,
            IF(LENGTH(TRIM(Profesion)) > 0, Profesion, Cadena_Default) AS Profesion,
            IF(LENGTH(TRIM(ActividadEconomica)) > 0, ActividadEconomica, Cadena_Default) AS ActividadEconomica,
            IF(LENGTH(TRIM(EstadoCivil)) > 0, EstadoCivil, Cadena_Default) AS EstadoCivil,
            IF(LENGTH(TRIM(Telefono)) > 0, Telefono, Cadena_Default) AS Telefono,
            IF(LENGTH(TRIM(Correo)) > 0, Correo, Cadena_Default) AS Correo,
            IF(LENGTH(TRIM(CURP)) > 0, CURP, Cadena_Default) AS CURP,
            IF(LENGTH(TRIM(Var_NumCasa)) > 0, Var_NumCasa, Cadena_Default) AS Var_NumCasa,
            IF(LENGTH(TRIM(Var_Calle)) > 0, Var_Calle, Cadena_Default) AS Var_Calle,
            IF(LENGTH(TRIM(Var_NombreColonia)) > 0, Var_NombreColonia, Cadena_Default) AS Var_NombreColonia,
            IF(LENGTH(TRIM(Var_CP)) > 0, Var_CP, Cadena_Default) AS Var_CP,
            IF(LENGTH(TRIM(Var_Ciudad)) > 0, Var_Ciudad, Cadena_Default) AS Var_Ciudad,
            IF(LENGTH(TRIM(Var_NombreEstado)) > 0, Var_NombreEstado, Cadena_Default) AS Var_NombreEstado,
            IF(LENGTH(TRIM(RFC)) > 0, RFC, Cadena_Default) AS RFC,
            IF(LENGTH(TRIM(NombreAval)) > 0, NombreAval, Cadena_Default) AS NombreAval,
            IF(LENGTH(TRIM(Var_AvalSexo)) > 0, Var_AvalSexo, Cadena_Default) AS Var_AvalSexo,
            IF(LENGTH(TRIM(Var_AvalFechaNacimiento)) > 0, Var_AvalFechaNacimiento, Cadena_Default) AS Var_AvalFechaNacimiento,
            IF(LENGTH(TRIM(Var_AvalPais)) > 0, Var_AvalPais, Cadena_Default) AS Var_AvalPais,
            IF(LENGTH(TRIM(Var_AvalNacion)) > 0, Var_AvalNacion, Cadena_Default) AS Var_AvalNacion,
            IF(LENGTH(TRIM(Var_AvalOcupacion)) > 0, Var_AvalOcupacion, Cadena_Default) AS Var_AvalOcupacion,
            IF(LENGTH(TRIM(Var_AvalGradoEstudio)) > 0, Var_AvalGradoEstudio, Cadena_Default) AS Var_AvalGradoEstudio,
            IF(LENGTH(TRIM(Var_AvalEdoCivil)) > 0, Var_AvalEdoCivil, Cadena_Default) AS Var_AvalEdoCivil,
            IF(LENGTH(TRIM(Var_AvalTel)) > 0, Var_AvalTel, Cadena_Default) AS Var_AvalTel,
            IF(LENGTH(TRIM(Var_AvalCorreo)) > 0, Var_AvalCorreo, Cadena_Default) AS Var_AvalCorreo,
            IF(LENGTH(TRIM(Var_AvalCURP)) > 0, Var_AvalCURP, Cadena_Default) AS Var_AvalCURP,
            IF(LENGTH(TRIM(Aval_DirNumExt)) > 0, Aval_DirNumExt, Cadena_Default) AS Aval_DirNumExt,
            IF(LENGTH(TRIM(Aval_DirCalle)) > 0, Aval_DirCalle, Cadena_Default) AS Aval_DirCalle,
            IF(LENGTH(TRIM(Aval_DirColonia)) > 0, Aval_DirColonia, Cadena_Default) AS Aval_DirColonia,
            IF(LENGTH(TRIM(Aval_DirCP)) > 0, Aval_DirCP, Cadena_Default) AS Aval_DirCP,
            IF(LENGTH(TRIM(Aval_DirLocalidad)) > 0, Aval_DirLocalidad, Cadena_Default) AS Aval_DirLocalidad,
            IF(LENGTH(TRIM(Aval_DirEstado)) > 0, Aval_DirEstado, Cadena_Default) AS Aval_DirEstado,
            IF(LENGTH(TRIM(Var_AvalRFC)) > 0, Var_AvalRFC, Cadena_Default) AS Var_AvalRFC,
            IF(LENGTH(TRIM(MontoPagotxt)) > 0, MontoPagotxt, Cadena_Default) AS MontoPagotxt,
            IF(LENGTH(TRIM(CATLRtxt)) > 0, CATLRtxt, Cadena_Default) AS CATLRtxt,
            IF(LENGTH(TRIM(Var_NumAmorti)) > 0, Var_NumAmorti, Cadena_Default) AS Var_NumAmorti,
            IF(LENGTH(TRIM(PlazoCredito)) > 0, PlazoCredito, Cadena_Default) AS PlazoCredito,
            IF(LENGTH(TRIM(Var_MontoRetencion)) > 0, Var_MontoRetencion, Cadena_Default) AS Var_MontoRetencion,
            IF(LENGTH(TRIM(taordinariatxt)) > 0, taordinariatxt, Cadena_Default) AS taordinariatxt,
            IF(LENGTH(TRIM(tasaOrdinariaMensualtxt)) > 0, tasaOrdinariaMensualtxt, Cadena_Default) AS tasaOrdinariaMensualtxt,
            IF(LENGTH(TRIM(Var_Factura)) > 0, Var_Factura, Cadena_Default) AS Var_Factura,
            IF(LENGTH(TRIM(Var_DireccionCompleta)) > 0, Var_DireccionCompleta, Cadena_Default) AS DireccionCompleta,
            IF(LENGTH(TRIM(Var_ExisteGarReal)) > 0, Var_ExisteGarReal, Cadena_Default) AS Var_ExisteGarReal,
            IF(LENGTH(TRIM(Var_Garantias)) > 0, Var_Garantias, Cadena_Default) AS Var_Garantias,
            IF(LENGTH(TRIM(Var_TipoDocumentoTxt)) > 0, Var_TipoDocumentoTxt, Cadena_Default) AS Var_TipoDocumentoTxt,
            IF(LENGTH(TRIM(LocalidadRegEscPPoderes)) > 0, LocalidadRegEscPPoderes, Cadena_Default) AS LocalidadRegEscPPoderes,
            IF(LENGTH(TRIM(EstadoRegEscPPoderes)) > 0, EstadoRegEscPPoderes, Cadena_Default) AS EstadoRegEscPPoderes,
            IFNULL(Var_FechaGarantia,Cadena_Default) AS Var_FechaGarantia,
            IF(LENGTH(TRIM(Var_NombreMuni)) > 0, Var_NombreMuni, Cadena_Default) AS Var_NombreMuni,
            IF(LENGTH(TRIM(Var_NombreEstadom)) > 0, Var_NombreEstadom, Cadena_Default) AS Var_NombreEstadom,
            IF(LENGTH(TRIM(FechaSistematxt)) > 0, FechaSistematxt, Cadena_Default) AS FechaSistematxt,
            IF(LENGTH(TRIM(Var_NumRECA)) > 0, Var_NumRECA, Cadena_Default) AS Var_NumRECA,

            IF(LENGTH(TRIM(Var_DescProducto)) > 0, Var_DescProducto, Cadena_Default) AS Var_DescProducto,
            IFNULL(Var_CATLR,Cadena_Default) AS Var_CATLR,
            IF(LENGTH(TRIM(taOrdCarat)) > 0, taOrdCarat, Cadena_Default) AS taOrdCarat,
            IF(LENGTH(TRIM(taiva)) > 0, taiva, Cadena_Default) AS taiva,
            IFNULL(Var_TasaAnual,Cadena_Default) AS Var_TasaAnual,
            IFNULL(FORMAT(Var_MontoCred,2),Cadena_Default) AS Var_MontoCred,
            IFNULL(FORMAT(Var_MontoPago,2),Cadena_Default) AS Var_MontoPago,
            IF(LENGTH(TRIM(Var_Plazo)) > 0, Var_Plazo, Cadena_Default) AS Var_Plazo,
            IF(LENGTH(TRIM(FechaTerminoMora)) > 0, FechaTerminoMora, Cadena_Default) AS FechaTerminoMora,
            IF(LENGTH(TRIM(Var_FechaCorte)) > 0, CAST(Var_FechaCorte AS CHAR CHARACTER SET utf8 ), Cadena_Default) AS Var_FechaCorte,
            IFNULL(Var_ProductoCre,Cadena_Default) AS Var_ProductoCre,
            IF(LENGTH(TRIM(Var_NomRepres)) > 0, Var_NomRepres, Cadena_Default) AS Var_NomRepres
          ;
      END IF;
    ELSE
      SELECT
        IF(LENGTH(TRIM(Var_NombreInstitucion)) > 0, Var_NombreInstitucion, Cadena_Default) AS Var_NombreInstitucion,
        IF(LENGTH(TRIM(Var_DirFiscalInstitucion)) > 0, Var_DirFiscalInstitucion, Cadena_Default) AS Var_DirFiscalInstitucion,
        IF(LENGTH(TRIM(Var_NombreEstadom)) > 0, Var_NombreEstadom, Cadena_Default) AS Var_NombreEstadom,
        IF(LENGTH(TRIM(Var_NombreMuni)) > 0, Var_NombreMuni, Cadena_Default) AS Var_NombreMuni,
        IF(LENGTH(TRIM(anioText)) > 0, anioText, Cadena_Default) AS anioText,
        IF(LENGTH(TRIM(FechaSistematxt)) > 0, FechaSistematxt, Cadena_Default) AS FechaSistematxt,
        IF(LENGTH(TRIM(Var_RepresentanteLegal)) > 0, Var_RepresentanteLegal, Cadena_Default) AS Var_RepresentanteLegal,
        IFNULL(Var_TotPagar,Cadena_Default) AS Var_TotPagar,
        IFNULL(Var_TotInteres,Cadena_Default) AS Var_TotInteres,
        IFNULL(FORMAT(Var_MontoPago,2),Cadena_Default) AS Var_MontoPago,
        IF(LENGTH(TRIM(Var_TipoPagoCap)) > 0, Var_TipoPagoCap, Cadena_Default) AS Var_TipoPagoCap,
        IFNULL(Var_TasaAnual,Cadena_Default) AS Var_TasaAnual,
        IFNULL(Var_NumAmorti,Cadena_Default) AS Var_NumAmorti,
        IFNULL(FORMAT(Var_MontoCred,2),Cadena_Default) AS Var_MontoCred,
        IFNULL(Var_Periodo,Cadena_Default) AS Var_Periodo,
        IF(LENGTH(TRIM(Var_FrecuenciaInt)) > 0, Var_FrecuenciaInt, Cadena_Default) AS Var_FrecuenciaInt,
        IF(LENGTH(TRIM(Var_Frecuencia)) > 0, Var_Frecuencia, Cadena_Default) AS Var_Frecuencia,
        IFNULL(Var_CATLR,Cadena_Default) AS Var_CATLR,
        IFNULL(Var_ProductoCre,Cadena_Default) AS Var_ProductoCre,
        IFNULL(Var_MontoCuota,Cadena_Default) AS Var_MontoCuota,
        IF(LENGTH(TRIM(Var_Plazo)) > 0, Var_Plazo, Cadena_Default) AS Var_Plazo,
        IFNULL(Var_DiasPlazo,Cadena_Default) AS Var_DiasPlazo,
        IFNULL(Var_ClienteID,Cadena_Default) AS Var_ClienteID,
        IFNULL(Var_ComisionApertura,Cadena_Default) AS Var_ComisionApertura,
        IFNULL(Var_ComisionPrepago,Cadena_Default) AS Var_ComisionPrepago,
        IFNULL(Var_FechaLimPag,Cadena_Default) AS Var_FechaLimPag,
        IF(LENGTH(TRIM(PlazoCredito)) > 0, PlazoCredito, Cadena_Default) AS PlazoCredito,
        IF(LENGTH(TRIM(Var_NumRECA)) > 0, Var_NumRECA, Cadena_Default) AS Var_NumRECA,
        IFNULL(Var_ComisionCobranza,Cadena_Default) AS Var_ComisionCobranza,
        IF(LENGTH(TRIM(Var_DescProducto)) > 0, Var_DescProducto, Cadena_Default) AS Var_DescProducto,
        IFNULL(Var_FactorMora,Cadena_Default) AS Var_FactorMora,
        IF(LENGTH(TRIM(Var_RequiereAvales)) > 0, Var_RequiereAvales, Cadena_Default) AS Var_RequiereAvales,
        IF(LENGTH(TRIM(Var_NomRepres)) > 0, Var_NomRepres, Cadena_Default) AS Var_NomRepres,
        IF(LENGTH(TRIM(TipoPersona)) > 0, TipoPersona, Cadena_Default) AS TipoPersona,
        IF(LENGTH(TRIM(Titulo)) > 0, Titulo, Cadena_Default) AS Titulo,
        IF(LENGTH(TRIM(PrimerNombre)) > 0, PrimerNombre, Cadena_Default) AS PrimerNombre,
        IF(LENGTH(TRIM(SegundoNombre)) > 0, SegundoNombre, Cadena_Default) AS SegundoNombre,
        IF(LENGTH(TRIM(TercerNombre)) > 0, TercerNombre, Cadena_Default) AS TercerNombre,
        IF(LENGTH(TRIM(ApellidoPaterno)) > 0, ApellidoPaterno, Cadena_Default) AS ApellidoPaterno,
        IF(LENGTH(TRIM(ApellidoMaterno)) > 0, ApellidoMaterno, Cadena_Default) AS ApellidoMaterno,
        IF(LENGTH(TRIM(NombreCompleto)) > 0, NombreCompleto, Cadena_Default) AS NombreCompleto,
        IF(LENGTH(TRIM(Sexo)) > 0, Sexo, Cadena_Default) AS Sexo,
        IF(LENGTH(TRIM(FechaNacimiento)) > 0, FechaNacimiento, Cadena_Default) AS FechaNacimiento,
        IF(LENGTH(TRIM(FechaNacimientoFtoTxt)) > 0, FechaNacimientoFtoTxt, Cadena_Default) AS FechaNacimientoFtoTxt,
        IF(LENGTH(TRIM(EstadoNacimiento)) > 0, EstadoNacimiento, Cadena_Default) AS EstadoNacimiento,
        IF(LENGTH(TRIM(PaisNacimiento)) > 0, PaisNacimiento, Cadena_Default) AS PaisNacimiento,
        IF(LENGTH(TRIM(Nacionalidad)) > 0, Nacionalidad, Cadena_Default) AS Nacionalidad,

        IF(LENGTH(TRIM(Var_NumCasa)) > 0, Var_NumCasa, Cadena_Default) AS Var_NumCasa,
        IF(LENGTH(TRIM(Var_Calle)) > 0, Var_Calle, Cadena_Default) AS Var_Calle,
        IF(LENGTH(TRIM(Var_NombreColonia)) > 0, Var_NombreColonia, Cadena_Default) AS Var_NombreColonia,
        IF(LENGTH(TRIM(Var_CP)) > 0, Var_CP, Cadena_Default) AS Var_CP,
        IF(LENGTH(TRIM(Var_Ciudad)) > 0, Var_Ciudad, Cadena_Default) AS Var_Ciudad,
        IF(LENGTH(TRIM(Var_NombreEstado)) > 0, Var_NombreEstado, Cadena_Default) AS Var_NombreEstado,
        IF(LENGTH(TRIM(RFC)) > 0, RFC, Cadena_Default) AS RFC,

        IF(LENGTH(TRIM(OcupacionID)) > 0, OcupacionID, Cadena_Default) AS OcupacionID,
        IF(LENGTH(TRIM(Ocupacion)) > 0, Ocupacion, Cadena_Default) AS Ocupacion,
        IF(LENGTH(TRIM(GradoEstudios)) > 0, GradoEstudios, Cadena_Default) AS GradoEstudios,
        IF(LENGTH(TRIM(Profesion)) > 0, Profesion, Cadena_Default) AS Profesion,
        IF(LENGTH(TRIM(ActividadEconomica)) > 0, ActividadEconomica, Cadena_Default) AS ActividadEconomica,
        IF(LENGTH(TRIM(EstadoCivil)) > 0, EstadoCivil, Cadena_Default) AS EstadoCivil,
        IF(LENGTH(TRIM(Telefono)) > 0, Telefono, Cadena_Default) AS Telefono,
        IF(LENGTH(TRIM(Correo)) > 0, Correo, Cadena_Default) AS Correo,
        IF(LENGTH(TRIM(CURP)) > 0, CURP, Cadena_Default) AS CURP,
        IF(LENGTH(TRIM(CURP)) > 0, CURP, Cadena_Default) AS CURP,
        IF(LENGTH(TRIM(TipoEmpresa)) > 0, TipoEmpresa, Cadena_Default) AS TipoEmpresa,
        IF(LENGTH(TRIM(RazonSocial)) > 0, RazonSocial, Cadena_Default) AS RazonSocial,
        IF(LENGTH(TRIM(NumEscPConstitutiva)) > 0, NumEscPConstitutiva, Cadena_Default) AS NumEscPConstitutiva,
        IF(LENGTH(TRIM(LocalidadEscPConstitutiva)) > 0, LocalidadEscPConstitutiva, Cadena_Default) AS LocalidadEscPConstitutiva,
        IF(LENGTH(TRIM(EstadoEscPConstitutiva)) > 0, EstadoEscPConstitutiva, Cadena_Default) AS EstadoEscPConstitutiva,
        IF(LENGTH(TRIM(FechaEscPConstitutiva)) > 0, FechaEscPConstitutiva, Cadena_Default) AS FechaEscPConstitutiva,
        IF(LENGTH(TRIM(NombreNotarioEscPConstitutiva)) > 0, NombreNotarioEscPConstitutiva, Cadena_Default) AS NombreNotarioEscPConstitutiva,
        IF(LENGTH(TRIM(NumeroNotarioEscPConstitutiva)) > 0, NumeroNotarioEscPConstitutiva, Cadena_Default) AS NumeroNotarioEscPConstitutiva,
        IF(LENGTH(TRIM(EstadoNotarioEscPConstitutiva)) > 0, EstadoNotarioEscPConstitutiva, Cadena_Default) AS EstadoNotarioEscPConstitutiva,
        IF(LENGTH(TRIM(LocalidadRegistroEscPConstitutiva)) > 0, LocalidadRegistroEscPConstitutiva, Cadena_Default) AS LocalidadRegistroEscPConstitutiva,
        IF(LENGTH(TRIM(EstadoRegistroEscPConstitutiva)) > 0, EstadoRegistroEscPConstitutiva, Cadena_Default) AS EstadoRegistroEscPConstitutiva,
        IF(LENGTH(TRIM(DistritoRegistroEscPConstitutiva)) > 0, DistritoRegistroEscPConstitutiva, Cadena_Default) AS DistritoRegistroEscPConstitutiva,
        IF(LENGTH(TRIM(NombreApoderadoEscPPoderes)) > 0, NombreApoderadoEscPPoderes, Cadena_Default) AS NombreApoderadoEscPPoderes,
        IF(LENGTH(TRIM(TituloApoderadoEscPPoderes)) > 0, TituloApoderadoEscPPoderes, Cadena_Default) AS TituloApoderadoEscPPoderes,
        IF(LENGTH(TRIM(NumeroEscPPoderes)) > 0, NumeroEscPPoderes, Cadena_Default) AS NumeroEscPPoderes,
        IF(LENGTH(TRIM(LocalidadEscPPoderes)) > 0, LocalidadEscPPoderes, Cadena_Default) AS LocalidadEscPPoderes,
        IF(LENGTH(TRIM(EstadoEscPPoderes)) > 0, EstadoEscPPoderes, Cadena_Default) AS EstadoEscPPoderes,
        IF(LENGTH(TRIM(NombreNotarioEscPPoderes)) > 0, NombreNotarioEscPPoderes, Cadena_Default) AS NombreNotarioEscPPoderes,
        IF(LENGTH(TRIM(NumeroNotarioEscPPoderes)) > 0, NumeroNotarioEscPPoderes, Cadena_Default) AS NumeroNotarioEscPPoderes,
        IF(LENGTH(TRIM(EstadoNotarioEscPPoderes)) > 0, EstadoNotarioEscPPoderes, Cadena_Default) AS EstadoNotarioEscPPoderes,
        IF(LENGTH(TRIM(LocalidadRegEscPPoderes)) > 0, LocalidadRegEscPPoderes, Cadena_Default) AS LocalidadRegEscPPoderes,
        IF(LENGTH(TRIM(EstadoRegEscPPoderes)) > 0, EstadoRegEscPPoderes, Cadena_Default) AS EstadoRegEscPPoderes,
        IF(LENGTH(TRIM(DistritoRegEscPPoderes)) > 0, CAST(DistritoRegEscPPoderes AS CHAR CHARACTER SET utf8 ), Cadena_Default) AS DistritoRegEscPPoderes,
        IF(LENGTH(TRIM(ObjetoSocialEscPConstitutiva)) > 0, ObjetoSocialEscPConstitutiva, Cadena_Default) AS ObjetoSocialEscPConstitutiva,
        IFNULL(Var_IdentificacionOficial,Cadena_Default) AS Var_IdentificacionOficial,
        IFNULL(Var_ComprobanteDomicilio,Cadena_Default) AS Var_ComprobanteDomicilio,
        IFNULL(Var_ComprobanteIngresos,Cadena_Default) AS Var_ComprobanteIngresos,
        IFNULL(Var_ServicioFederal,Cadena_Default) AS Var_ServicioFederal,
        IFNULL(Var_EstadoCuenta,Cadena_Default) AS Var_EstadoCuenta,
        IF(LENGTH(TRIM(Var_DesFrec)) > 0, Var_DesFrec, Cadena_Default) AS Var_DesFrec,
        IF(LENGTH(TRIM(Var_DesFrecLet)) > 0, Var_DesFrecLet, Cadena_Default) AS Var_DesFrecLet,
        IF(LENGTH(TRIM(Var_FrecSeguro)) > 0, Var_FrecSeguro, Cadena_Default) AS Var_FrecSeguro,
        IF(LENGTH(TRIM(Var_FechaCorte)) > 0, CAST(Var_FechaCorte AS CHAR CHARACTER SET utf8 ), Cadena_Default) AS Var_FechaCorte,
        IF(LENGTH(TRIM(TasaOrdinaria)) > 0, TasaOrdinaria, Cadena_Default) AS TasaOrdinaria,
        IF(LENGTH(TRIM(MontoPagotxt)) > 0, MontoPagotxt, Cadena_Default) AS MontoPagotxt,
        IF(LENGTH(TRIM(CATLRtxt)) > 0, CATLRtxt, Cadena_Default) AS CATLRtxt,
        IF(LENGTH(TRIM(ComReimpresonCant)) > 0, ComReimpresonCant, Cadena_Default) AS ComReimpresonCant,
        IF(LENGTH(TRIM(ComReimpresonCantiva)) > 0, ComReimpresonCantiva, Cadena_Default) AS ComReimpresonCantiva,
        IF(LENGTH(TRIM(taiva)) > 0, taiva, Cadena_Default) AS taiva,
        IF(LENGTH(TRIM(tasaOrdinariaMensual)) > 0, tasaOrdinariaMensual, Cadena_Default) AS tasaOrdinariaMensual,
        IF(LENGTH(TRIM(tasaOrdinariaMensualtxt)) > 0, tasaOrdinariaMensualtxt, Cadena_Default) AS tasaOrdinariaMensualtxt,
        IF(LENGTH(TRIM(taordinaria)) > 0, taordinaria, Cadena_Default) AS taordinaria,
        IF(LENGTH(TRIM(taOrdCarat)) > 0, taOrdCarat, Cadena_Default) AS taOrdCarat,
        IF(LENGTH(TRIM(taordinariatxt)) > 0, taordinariatxt, Cadena_Default) AS taordinariatxt,
        IF(LENGTH(TRIM(FechaLimPagtxt)) > 0, FechaLimPagtxt, Cadena_Default) AS FechaLimPagtxt,
        IF(LENGTH(TRIM(TasaDiariaordinariatxt)) > 0, TasaDiariaordinariatxt, Cadena_Default) AS TasaDiariaordinariatxt,
        IF(LENGTH(TRIM(TasaMoraDiaria)) > 0, TasaMoraDiaria, Cadena_Default) AS TasaMoraDiaria,
        IF(LENGTH(TRIM(ValorMoraCatorcenalPC200)) > 0, ValorMoraCatorcenalPC200, Cadena_Default) AS ValorMoraCatorcenalPC200,
        IF(LENGTH(TRIM(TasaMoraMensual)) > 0, TasaMoraMensual, Cadena_Default) AS TasaMoraMensual,
        IF(LENGTH(TRIM(ValorMoraDiaria)) > 0, ValorMoraDiaria, Cadena_Default) AS ValorMoraDiaria,
        IF(LENGTH(TRIM(MontoGarantiaLiquida)) > 0, MontoGarantiaLiquida, Cadena_Default) AS MontoGarantiaLiquida,
        IF(LENGTH(TRIM(NombreAval)) > 0, NombreAval, Cadena_Default) AS NombreAval,
        IF(LENGTH(TRIM(Aval_DirNumExt)) > 0, Aval_DirNumExt, Cadena_Default) AS Aval_DirNumExt,
        IF(LENGTH(TRIM(Aval_DirCalle)) > 0, Aval_DirCalle, Cadena_Default) AS Aval_DirCalle,
        IF(LENGTH(TRIM(Aval_DirColonia)) > 0, Aval_DirColonia, Cadena_Default) AS Aval_DirColonia,
        IF(LENGTH(TRIM(Aval_DirCP)) > 0, Aval_DirCP, Cadena_Default) AS Aval_DirCP,
        IF(LENGTH(TRIM(Aval_DirLocalidad)) > 0, Aval_DirLocalidad, Cadena_Default) AS Aval_DirLocalidad,
        IF(LENGTH(TRIM(Aval_DirEstado)) > 0, Aval_DirEstado, Cadena_Default) AS Aval_DirEstado,
        IF(LENGTH(TRIM(Var_AvalRFC)) > 0, Var_AvalRFC, Cadena_Default) AS Var_AvalRFC,
        IF(LENGTH(TRIM(Var_AvalSexo)) > 0, Var_AvalSexo, Cadena_Default) AS Var_AvalSexo,
        IF(LENGTH(TRIM(Var_AvalFechaNacimiento)) > 0, Var_AvalFechaNacimiento, Cadena_Default) AS Var_AvalFechaNacimiento,
        IF(LENGTH(TRIM(Var_AvalEdo)) > 0, Var_AvalEdo, Cadena_Default) AS Var_AvalEdo,
        IF(LENGTH(TRIM(Var_AvalPais)) > 0, Var_AvalPais, Cadena_Default) AS Var_AvalPais,
        IF(LENGTH(TRIM(Var_AvalNacion)) > 0, Var_AvalNacion, Cadena_Default) AS Var_AvalNacion,
        IF(LENGTH(TRIM(Var_AvalOcupacion)) > 0, Var_AvalOcupacion, Cadena_Default) AS Var_AvalOcupacion,
        IF(LENGTH(TRIM(Var_AvalGradoEstudio)) > 0, Var_AvalGradoEstudio, Cadena_Default) AS Var_AvalGradoEstudio,
        IF(LENGTH(TRIM(Var_AvalProfesion)) > 0, Var_AvalProfesion, Cadena_Default) AS Var_AvalProfesion,
        IF(LENGTH(TRIM(Var_AvalActEco)) > 0, Var_AvalActEco, Cadena_Default) AS Var_AvalActEco,
        IF(LENGTH(TRIM(Var_AvalEdoCivil)) > 0, Var_AvalEdoCivil, Cadena_Default) AS Var_AvalEdoCivil,
        IF(LENGTH(TRIM(Var_AvalTel)) > 0, Var_AvalTel, Cadena_Default) AS Var_AvalTel,
        IF(LENGTH(TRIM(Var_AvalCorreo)) > 0, Var_AvalCorreo, Cadena_Default) AS Var_AvalCorreo,
        IF(LENGTH(TRIM(Var_AvalCURP)) > 0, Var_AvalCURP, Cadena_Default) AS Var_AvalCURP,
        IF(LENGTH(TRIM(FechaTerminoMora)) > 0, FechaTerminoMora, Cadena_Default) AS FechaTerminoMora,
        IF(LENGTH(TRIM(FechaTerminoMoratxt)) > 0, FechaTerminoMoratxt, Cadena_Default) AS FechaTerminoMoratxt,
        IF(LENGTH(TRIM(FechaTerminoMora200)) > 0, FechaTerminoMora200, Cadena_Default) AS FechaTerminoMora200,
        IF(LENGTH(TRIM(FechaTerminoMoratxt200)) > 0, FechaTerminoMoratxt200, Cadena_Default) AS FechaTerminoMoratxt200,
        IF(LENGTH(TRIM(Var_DireccionCompleta)) > 0, Var_DireccionCompleta, Cadena_Default) AS Var_DireccionCompleta,
        IF(LENGTH(TRIM(Var_AvalNombreCompleto)) > 0, Var_AvalNombreCompleto, Cadena_Default) AS Var_AvalNombreCompleto,
        IF(LENGTH(TRIM(Var_AvalDirCompleta)) > 0, Var_AvalDirCompleta, Cadena_Default) AS Var_AvalDirCompleta,
        IF(LENGTH(TRIM(Var_AvalTipoPersona)) > 0, Var_AvalTipoPersona, Cadena_Default) AS Var_AvalTipoPersona,
        IF(LENGTH(TRIM(Var_AvalRazonSocial)) > 0, Var_AvalRazonSocial, Cadena_Default) AS Var_AvalRazonSocial,
        IF(LENGTH(TRIM(Aval_EscPub)) > 0, Aval_EscPub, Cadena_Default) AS Aval_EscPub,
        IF(LENGTH(TRIM(Aval_CiudadEscP)) > 0, Aval_CiudadEscP, Cadena_Default) AS Aval_CiudadEscP,
        IF(LENGTH(TRIM(Aval_LocEscPubCons)) > 0, Aval_LocEscPubCons, Cadena_Default) AS Aval_LocEscPubCons,
        IF(LENGTH(TRIM(Aval_DistEscPubCons)) > 0, Aval_DistEscPubCons, Cadena_Default) AS Aval_DistEscPubCons,
        IF(LENGTH(TRIM(Aval_FechaEscP)) > 0, Aval_FechaEscP, Cadena_Default) AS Aval_FechaEscP,
        IF(LENGTH(TRIM(Aval_NomNotarioEscP)) > 0, Aval_NomNotarioEscP, Cadena_Default) AS Aval_NomNotarioEscP,
        IF(LENGTH(TRIM(Aval_NumNotarioEscP)) > 0, Aval_NumNotarioEscP, Cadena_Default) AS Aval_NumNotarioEscP,
        IF(LENGTH(TRIM(Aval_EdoNotario)) > 0, Aval_EdoNotario, Cadena_Default) AS Aval_EdoNotario,
        IF(LENGTH(TRIM(Aval_EdoIDReg)) > 0, Aval_EdoIDReg, Cadena_Default) AS Aval_EdoIDReg,
        IF(LENGTH(TRIM(Aval_Proyecto)) > 0, Aval_Proyecto, Cadena_Default) AS Aval_Proyecto,
        IF(LENGTH(TRIM(Aval_ObjSocEscConstitutiva)) > 0, Aval_ObjSocEscConstitutiva, Cadena_Default) AS Aval_ObjSocEscConstitutiva,
        IF(LENGTH(TRIM(Aval_NombreApoderado)) > 0, Aval_NombreApoderado, Cadena_Default) AS Aval_NombreApoderado,
        IF(LENGTH(TRIM(Aval_TituloApoderado)) > 0, Aval_TituloApoderado, Cadena_Vacia) AS Aval_TituloApoderado,
        IF(LENGTH(TRIM(Aval_NumEscPoder)) > 0, Aval_NumEscPoder, Cadena_Default) AS Aval_NumEscPoder,
        IF(LENGTH(TRIM(Aval_LocEscPoder)) > 0, Aval_LocEscPoder, Cadena_Default) AS Aval_LocEscPoder,
        IF(LENGTH(TRIM(Aval_EdoEscPoder)) > 0, Aval_EdoEscPoder, Cadena_Default) AS Aval_EdoEscPoder,
        IF(LENGTH(TRIM(Aval_NomNotarioEscPoder)) > 0, Aval_NomNotarioEscPoder, Cadena_Default) AS Aval_NomNotarioEscPoder,
        IF(LENGTH(TRIM(Aval_EdoNotEscPoder)) > 0, Aval_EdoNotEscPoder, Cadena_Default) AS Aval_EdoNotEscPoder,
        IF(LENGTH(TRIM(Aval_LocNot)) > 0, Aval_LocNot, Cadena_Default) AS Aval_LocNot,
        IF(LENGTH(TRIM(Aval_EdoRegEscPoder)) > 0, Aval_EdoRegEscPoder, Cadena_Default) AS Aval_EdoRegEscPoder,
        IF(LENGTH(TRIM(Aval_DistRegEscPoder)) > 0, Aval_DistRegEscPoder, Cadena_Default) AS Aval_DistRegEscPoder,
        IF(LENGTH(TRIM(Aval_NotariaPoder)) > 0, Aval_NotariaPoder, Cadena_Default) AS Aval_NotariaPoder,
        IF(LENGTH(TRIM(Var_MontoRetencion)) > 0, Var_MontoRetencion, Cadena_Default) AS Var_MontoRetencion,
        IF(LENGTH(TRIM(Var_Garantias)) > 0, Var_Garantias, Cadena_Default) AS Var_Garantias,
        IF(LENGTH(TRIM(Var_Factura)) > 0, Var_Factura, Cadena_Default) AS Var_Factura,
        IF(LENGTH(TRIM(Var_TipoDocumentoTxt)) > 0, Var_TipoDocumentoTxt, Cadena_Default) AS Var_TipoDocumentoTxt,
        IF(LENGTH(TRIM(ValorMoraPC400)) > 0, ValorMoraPC400, Cadena_Default) AS ValorMoraPC400,
        IF(LENGTH(TRIM(PenaConvtxtPC400)) > 0, PenaConvtxtPC400, Cadena_Default) AS PenaConvtxtPC400,
        IFNULL(Var_FechaGarantia,Cadena_Default) AS Var_FechaGarantia,
        IFNULL(Var_ExisteGarReal,Entero_Cero) AS Var_ExisteGarReal,
        PenaConvPC400;
  END CASE;
END IF;

IF (Par_TipoReporte = TipoSanaTusFinanzas)  THEN
  --  SECCION 17. CARATULA PERSONA FISICA Y MORAL 
  SELECT    Cre.CreditoID,
        Pro.Descripcion,
        CASE  Cli.TipoPersona
          WHEN  'M' THEN  'Credito Simple.'
          ELSE        'Credito Personal.'
        END,
        Cre.ValorCAT,
        Cre.TasaFija,
        Cre.TipCobComMorato,
        Cre.FactorMora,
        Cpl.Descripcion,
        Cre.MontoCredito,
        SUM(Amo.Interes),
        SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres),
        Cre.FechaVencimien,
        Cre.FechaMinistrado,
        Pro.RegistroRECA,
        CASE  Cli.TipoPersona
          WHEN  'F' THEN  Cli.NombreCompleto
          WHEN  'A' THEN  Cli.NombreCompleto
          WHEN  'M' THEN  Cli.RazonSocial
          ELSE  'TIPO PERSONA NO DEFINIDO'
        END,
        Cli.RFCOficial,
        MAX(Dir.DireccionCompleta),
        Suc.NombreSucurs
  INTO    Var_CreditoFolio,
        Var_NombreProducto,
        Var_TipoCredito,
        Var_CAT,
        Var_TasaAnual,
        Var_TipoCobroMoratorio,
        Var_FactorMora,
        Var_Plazo,
        Var_MontoCred,
        Var_TotInteres,
        Var_TotPagar,
        Var_FechaVenc,
        Var_FechaCorte,
        Var_NumRECA,
        Var_Nombre,
        Var_RFC,
        Var_Direc,
        Var_NombreSucursal
  FROM      CREDITOS      Cre
  INNER JOIN    PRODUCTOSCREDITO  Pro ON    Pro.ProducCreditoID = Cre.ProductoCreditoID
  INNER JOIN    CLIENTES      Cli ON    Cli.ClienteID   = Cre.ClienteID
  LEFT OUTER JOIN AMORTICREDITO   Amo ON    Amo.CreditoID   = Cre.CreditoID
  LEFT OUTER JOIN DIRECCLIENTE    Dir ON    Dir.ClienteID   = Cre.ClienteID
                        AND Dir.Oficial     = DirOficialSI
  LEFT OUTER JOIN CREDITOSPLAZOS    Cpl ON    Cpl.PlazoID     = Cre.PlazoID
  LEFT OUTER JOIN SUCURSALES      Suc ON    Suc.SucursalID    = Cre.SucursalID
  WHERE     Cre.CreditoID = Par_CreditoID;

  SELECT DirecCompleta INTO Var_DirSucursal
  FROM SUCURSALES
  WHERE EmpresaID = Par_EmpresaID
  AND SucursalID = Aud_Sucursal;

  SET Var_CreditoFolio    :=  IFNULL(Var_CreditoFolio,Entero_Cero);
  SET Var_NombreProducto    :=  IFNULL(Var_NombreProducto,Cadena_Vacia);
  SET Var_TipoCredito     :=  IFNULL(Var_TipoCredito,Cadena_Vacia);
  SET Var_CAT         :=  IFNULL(Var_CAT, Entero_Cero);
  SET Var_TasaAnual     :=  IFNULL(Var_TasaAnual, Entero_Cero);
  SET Var_TipoCobroMoratorio  :=  IFNULL(Var_TipoCobroMoratorio, Cadena_Vacia);
  SET Var_FactorMora      :=  IFNULL(Var_FactorMora, Entero_Cero);
  SET Var_Plazo       :=  IFNULL(Var_Plazo, Cadena_Vacia);
  SET Var_MontoCred     :=  IFNULL(Var_MontoCred, Entero_Cero);
  SET Var_TotInteres      :=  IFNULL(Var_TotInteres, Entero_Cero);
  SET Var_TotPagar      :=  IFNULL(Var_TotPagar, Entero_Cero);
  SET Var_NumRECA       :=  IFNULL(Var_NumRECA, Entero_Cero);
  SET Var_Nombre        :=  IFNULL(Var_Nombre,Cadena_Vacia);
  SET Var_RFC         :=  IFNULL(Var_RFC, Cadena_Vacia);
  SET Var_Direc       :=  IFNULL(Var_Direc, Cadena_Vacia);
  SET Var_NombreSucursal    :=  IFNULL(Var_NombreSucursal, Cadena_Vacia);
  SET Var_DirSucursal	:= IFNULL(Var_DirSucursal, Cadena_Vacia);



  SELECT  Var_CreditoFolio,
      Var_NombreProducto,
      Var_TipoCredito,
      CONCAT(ROUND(Var_CAT,2),'%')  AS  Var_CAT,
      CONCAT(ROUND(Var_TasaAnual,2),'%')  AS  Var_TasaOrdinaria,
      CASE  Var_TipoCobroMoratorio
        WHEN  NVecesTasaOrd   THEN  CONCAT(ROUND(Var_FactorMora*Var_TasaAnual,2),'%')
        WHEN  TasaFijaAnualizada  THEN  CONCAT(ROUND(Var_FactorMora,2),'%')
        ELSE  CONCAT(ROUND(Var_FactorMora,2),'%')
      END AS  Var_TasaMoratoria,
      Var_Plazo,
      CONCAT('$',ROUND(Var_MontoCred,2), ' M.N.')     AS  Var_MontoCredito,
      CONVPORCANT(Var_MontoCred,'T', 'Peso', 'Nacional')  AS  Var_MontoCreditoTxt,
      CONCAT('$',ROUND(Var_TotPagar,2), ' M.N.')      AS  Var_MontoTotalPagar,
      CONVPORCANT(Var_TotPagar,'T', 'Peso', 'Nacional') AS  Var_MontoTotalPagarTxt,
      FORMATEAFECHACONTRATO(Var_FechaVenc)        AS  Var_FechaLimitePago,
      FORMATEAFECHACONTRATO(Var_FechaCorte)       AS  Var_FechaCorte,
      Var_NumRECA,
      Var_Nombre,
      Var_RFC,
      Var_Direc,
      Var_NombreSucursal,
      CONCAT('$',Var_MontoCred)             AS  Var_ImporteOriginal,
      Var_DirSucursal
      ;
END IF;

IF(Par_TipoReporte  = TablaAmortizacionSanaTusFinanzas) THEN
  --  SECCION 18. TABLA DE AMORTIZACIONES PERSONA FISICA Y MORAL 
  SELECT
      Amo.AmortizacionID,
      DATE_FORMAT(FechaVencim,'%d/%m/%Y')         AS  FechaDePago,
      CONCAT('$',IFNULL(Amo.SaldoCapital,Entero_Cero))  AS  SaldoInsoluto,
      CONCAT('$',IFNULL(Amo.Capital,Entero_Cero))     AS  PagoCapital,
      CONCAT('$','0.00')                  AS  PagoInteresMoratorio,
      CONCAT('$',IFNULL(Amo.Interes,Entero_Cero))     AS  PagoInteresOrd,
      CONCAT('$',IFNULL(Amo.IVAInteres,Entero_Cero))    AS  PagoIVAInteres,
      CONCAT('$','0.00')                  AS  Comisiones,
      CONCAT('$',IFNULL(
                (Amo.Capital +
                Amo.Interes +
                Amo.IVAInteres),Entero_Cero
                ))                AS  PagoMensualTotal,
      CONCAT('$',IFNULL(
                (Amo.Capital +
                Amo.Interes +
                Amo.IVAInteres),Entero_Cero
                ))                AS  PagoFijo
  FROM  AMORTICREDITO Amo , CREDITOS Cre
  WHERE Amo.CreditoID =   Par_CreditoID
    AND Amo.CreditoID = Cre.CreditoID;

END IF;

IF (Par_TipoReporte = TipoContratoSanaTusFinanzas) THEN
  --  SECCION 19. CONTRATO PERSONA FISICA Y MORAL 
  SELECT  Cli.TipoPersona
  INTO  Var_TipoPersona
  FROM  CREDITOS Cre, CLIENTES Cli
  WHERE Cre.CreditoID = Par_CreditoID
    AND Cre.ClienteID = Cli.ClienteID;

  SELECT DirecCompleta INTO Var_DirSucursal
  FROM SUCURSALES
  WHERE EmpresaID = Par_EmpresaID
  AND SucursalID = Aud_Sucursal;

  IF(Var_TipoPersona = PersonaMoral)  THEN

    SELECT  Cre.CreditoID,
        Cli.RazonSocial,
        Esc.FechaEsc,
        SEco.Descripcion,
        Cli.RFCOficial,
        Cli.NombreCompleto,
        Dir.DireccionCompleta
    INTO  Var_CreditoFolio,
        Var_NombreInstitucion,
        Aval_FechaEscP,
        Var_AvalActEco,
        Var_RFC,
        Var_Nombre,
        Var_Direc
    FROM  CREDITOS Cre
    INNER JOIN    CLIENTES    Cli   ON  Cli.ClienteID   = Cre.ClienteID
    LEFT OUTER JOIN ESCRITURAPUB  Esc   ON  Esc.ClienteID   = Cre.ClienteID
    LEFT OUTER JOIN SECTORESECONOM  SEco  ON  SEco.SectorEcoID  = Cli.SectorEconomico
    LEFT OUTER JOIN DIRECCLIENTE  Dir   ON  Dir.ClienteID   = Cre.ClienteID
    WHERE   Cre.CreditoID = Par_CreditoID
    LIMIT 1;

    -- Preguntar si Par.ClienteInstitucion hace referencia al representante legal?
    --  Pregunta fundamentada en (Par_TipoReporte = Tipo_EncContrato)
    SELECT  CONCAT(Cli.PrimerNombre,(CASE   WHEN IFNULL(Cli.SegundoNombre, '') != '' THEN
                  CONCAT(' ', Cli.SegundoNombre)
                ELSE Cadena_Vacia
             END),
             (CASE  WHEN IFNULL(Cli.TercerNombre, '') != '' THEN
                  CONCAT(' ', Cli.TercerNombre)
                ELSE Cadena_Vacia
            END)),
        Cli.ApellidoPaterno,
        Cli.ApellidoMaterno,
        Cli.FechaNacimiento,
        Cli.RFCOficial,
        CASE Cli.Telefono
          WHEN  ''    THEN  Cli.TelefonoCelular
          WHEN  NULL  THEN  Cli.TelefonoCelular
          ELSE Cli.Telefono
        END,
        Cli.Correo
    INTO  Var_NombreRepresentante,
        Var_PaternoRepre,
        Var_MaternoRepre,
        Var_FechaNacimiento,
        Var_RFCOficialRL,
        Var_TelefonoRL,
        Var_CorreoRL
    FROM    CREDITOS    Cre
    INNER JOIN  CLIENTES    Cli ON  Cli.ClienteID = Cre.ClienteID
    WHERE Cre.CreditoID = Par_CreditoID;

    SELECT  Cre.TasaFija, Cre.CreditoID,  Cre.NumAmortizacion,Cre.MontoCredito,
        Cre.PeriodicidadInt,  Cre.FrecuenciaInt,  Cre.FrecuenciaCap,  Cre.MontoSeguroVida,
        Cre.FechaVencimien,   Cre.FechaMinistrado,  Cpl.Descripcion,  Cre.MontoCuota
    INTO  Var_TasaAnual,  Var_CreditoID,    Var_NumAmorti,  Var_MontoCred,
        Var_Periodo,  Var_FrecuenciaInt,  Var_Frecuencia, Var_MontoSeguro,
        Var_FechaVenc,  Var_FechaCorte, Var_Plazo,  Var_MontoCuota
    FROM  CREDITOS Cre
    LEFT OUTER JOIN CREDITOSPLAZOS    Cpl ON    Cpl.PlazoID     = Cre.PlazoID
    WHERE CreditoID = Par_CreditoID;

    SELECT  SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres),
        SUM(Amo.Interes),
        MAX(Amo.FechaVencim)
    INTO  Var_TotPagar,
        Var_TotInteres,
        Var_FechaLimPag
    FROM  AMORTICREDITO Amo
    WHERE Amo.CreditoID = Par_CreditoID;

    SELECT  RegistroRECA,
        Pro.FactorMora,
        Cre.TipCobComMorato
    INTO  Var_NumRECA,
        Var_FactorMora,
        Var_TipoCobroMoratorio
    FROM  PRODUCTOSCREDITO Pro, CREDITOS Cre
    WHERE ProducCreditoID = Cre.ProductoCreditoID
    AND   Cre.CreditoID = Par_CreditoID;

    SET Var_NumRECA       :=  IFNULL(Var_NumRECA,'INDEFINIDO');
    SET Var_FactorMora      :=  IFNULL(Var_FactorMora,Entero_Cero);
    SET Var_TipoCobroMoratorio  :=  IFNULL(Var_TipoCobroMoratorio,TasaFijaAnualizada);

    SELECT  Mun.Nombre,
        Edo.Nombre
    INTO  Var_NombMunicipio,
        Var_NombEstado
    FROM      SUCURSALES  Suc
    INNER JOIN    CREDITOS Cre    ON  Cre.SucursalID  = Suc.SucursalID
    LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON  Mun.EstadoID  = Suc.EstadoID
                      AND Mun.MunicipioID = Suc.MunicipioID
    LEFT OUTER JOIN ESTADOSREPUB  Edo ON  Edo.EstadoID  = Suc.EstadoID
    WHERE Cre.CreditoID = Par_CreditoID;

    SELECT  Ins.Nombre,
        Ins.NombreCorto
    INTO  Var_NomInstit,
        Var_NomCortoInstit
    FROM  INSTITUCIONES Ins, CREDITOS Cre, PARAMETROSSIS Par
    WHERE Cre.CreditoID = Par_CreditoID
    AND   Par.EmpresaID   = Cre.EmpresaID
    AND   Ins.InstitucionID = Par.InstitucionID;

    SET Var_TasaAnual   := IFNULL(Var_TasaAnual, Entero_Cero);
    SET Var_CreditoID   := IFNULL(Var_CreditoID, Entero_Cero);
    SET Var_NumAmorti   := IFNULL(Var_NumAmorti, Entero_Cero);
    SET Var_TasaMens    := ROUND(Var_TasaAnual / 12, 2);
    SET Var_TotInteres  := IFNULL(Var_TotInteres, Entero_Cero);
    SET Var_TasaFlat    := ( ( (Var_TotInteres / Var_NumAmorti) / Var_MontoCred ) /
                  Var_Periodo ) * 30 * 100;
    SET Var_TasaFlat    := ROUND(Var_TasaFlat, 4);

    SET Aval_FechaEscP  :=  CAST(Aval_FechaEscP AS CHAR);

    SELECT
        Var_CreditoFolio,     Var_NombreInstitucion,    Aval_FechaEscP,   Var_AvalActEco,     Var_RFC,
        Var_NombreRepresentante,  Var_PaternoRepre,     Var_MaternoRepre, Var_FechaNacimiento,
        Var_RFCOficialRL,     Var_TelefonoRL,       Var_CorreoRL,
        CONCAT(ROUND(Var_TasaMens,2),'%') AS  Var_TasaMens,
        CONCAT(ROUND(Var_TasaAnual,2),'%')  AS  Var_TasaAnual,
        Var_TotPagar,CONVPORCANT(Var_TotPagar,'T', 'Peso', 'Nacional') AS Var_TotPagarTxt,    Var_NumAmorti,      Var_Plazo,
        Var_MontoCred,        FORMATEAFECHACONTRATO(Var_FechaLimPag) AS Var_FechaLimPag,        Var_NumRECA,
        FORMATEAFECHACONTRATO(Var_FechaVenc) AS Var_FechaVenc,  CONCAT(Var_NombMunicipio,', ',Var_NombEstado) AS Var_dirSuc,
        FORMATEAFECHACONTRATO(Var_FechaCorte) AS Var_FechaCorte, Var_NomInstit,
        CASE  Var_TipoCobroMoratorio
          WHEN  NVecesTasaOrd   THEN  CONCAT(ROUND(Var_FactorMora*Var_TasaAnual,2),'%')
          WHEN  TasaFijaAnualizada  THEN  CONCAT(ROUND(Var_FactorMora,2),'%')
        END AS  Var_TasaMoratoria,
        CASE  Var_TipoCobroMoratorio
          WHEN  NVecesTasaOrd   THEN  CONVPORCANT(ROUND(Var_FactorMora*Var_TasaAnual,2),'%', 0, 0)
          WHEN  TasaFijaAnualizada  THEN  CONVPORCANT(ROUND(Var_FactorMora,2),'%', 0, 0)
        END AS  Var_TasaMoratoriaTxt,
        CASE  Var_TipoCobroMoratorio
          WHEN  NVecesTasaOrd   THEN  CONCAT(ROUND(Var_FactorMora*Var_TasaAnual/12,2),'%')
          WHEN  TasaFijaAnualizada  THEN  CONCAT(ROUND(Var_FactorMora/12,2),'%')
        END AS  Var_TasaMoratoriaMen,
        Var_Nombre, Var_Direc,  Var_NomCortoInstit, Var_MontoCuota, Var_FechaSistema, Var_DirSucursal;

  ELSE

    SELECT  CONCAT( Cli.PrimerNombre,
            CASE
              WHEN  IFNULL(Cli.SegundoNombre,Cadena_Vacia) != Cadena_Vacia  THEN
                  CONCAT(' ', Cli.SegundoNombre)
              ELSE
                  Cadena_Vacia
            END,
            CASE
              WHEN  IFNULL(Cli.TercerNombre,Cadena_Vacia) != Cadena_Vacia THEN
                  CONCAT(' ', Cli.TercerNombre)
              ELSE
                  Cadena_Vacia
            END
        ),
        Cli.ApellidoPaterno,  Cli.ApellidoMaterno,
        CASE  Cli.Sexo
          WHEN  'M' THEN  TxtMasculino
          WHEN  'F' THEN  TxtFemenino
          ELSE        Cadena_Vacia
        END,
        FORMATEAFECHACONTRATO(Cli.FechaNacimiento),
        YEAR(Var_FechaSistema) - YEAR( Cli.FechaNacimiento),
        CASE
          WHEN  IFNULL(Cli.RFC,Cadena_Vacia) != Cadena_Vacia  THEN  Cli.RFC
          ELSE  Cli.CURP
        END,
        CONVERT(Oc.Descripcion, CHAR),
        Cli.Correo,
        Dir.Calle, Dir.NumeroCasa,  Dir.NumInterior, Dir.Colonia,
        Loc.NombreLocalidad, Edo.Nombre, Dir.CP,
        Cli.Telefono, Cli.TelefonoCelular,
        CASE Cli.EstadoCivil
          WHEN 'S' THEN 'SOLTERO'
          WHEN 'CS' THEN 'CASADO CON BIENES SEPARADOS'
          WHEN 'CM' THEN 'CASADO CON BIENES MANCOMUNADOS'
          WHEN 'CM' THEN 'CASADO CON BIENES MANCOMUNADOS CON CAPITULACION'
          WHEN 'V' THEN 'VIUDO'
          WHEN 'D' THEN 'DIVORCIADO'
          WHEN 'SE' THEN 'SEPARADO'
          WHEN 'U' THEN 'UNION LIBRE'
          ELSE  'SE IGNORA'
        END,
        Cre.MontoCuota,
        CASE  WHEN Cli.Nacion = 'N' THEN  'MEXICANA'
            ELSE  'EXTRANJERA'
        END

    INTO  Var_Nombre, Var_ApellidoPaterno, Var_ApellidoMaterno, Var_Sexo, Var_FechaNacimientoTxt,
        Var_Edad, Var_RFC, Var_Ocupacion, Var_Correo, Var_Calle, Var_NumCasa, Var_NumInterior, Var_NombreColonia,
        Var_Ciudad, Var_NombreEstado, Var_CP, Var_Telefono, Var_TelefonoCelular,
        Var_EstadoCivil, Var_MontoCuota, Var_Nacionalidad
    FROM  CREDITOS  Cre
    INNER JOIN    CLIENTES    Cli ON  Cli.ClienteID   = Cre.ClienteID
    LEFT OUTER JOIN OCUPACIONES   Oc  ON  Oc.OcupacionID    = Cli.OcupacionID
    LEFT OUTER JOIN DIRECCLIENTE  Dir ON  Dir.ClienteID   = Cre.ClienteID
                      AND Dir.Oficial     = DirOficial
                      AND Dir.TipoDireccionID = 1
    LEFT OUTER JOIN LOCALIDADREPUB  Loc ON  Loc.LocalidadID   = Dir.LocalidadID
                      AND Loc.EstadoID    = Dir.EstadoID
                      AND Loc.MunicipioID   = Dir.MunicipioID
    LEFT OUTER JOIN ESTADOSREPUB  Edo ON  Edo.EstadoID    = Dir.EstadoID
    WHERE Cre.CreditoID = Par_CreditoID;

    SELECT  CONCAT( Var_Calle,
          CASE
            WHEN  IFNULL(Var_NumCasa, Entero_Cero)  != Entero_Cero  THEN  CONCAT(' ',Var_NumCasa)
            ELSE  Cadena_Vacia
          END,
          CASE
            WHEN  IFNULL(Var_NumInterior, Entero_Cero)  != Entero_Cero  THEN  CONCAT(', INT. ',Var_NumInterior)
            ELSE  Cadena_Vacia
          END
        )
    INTO  Var_Calle;

    SELECT  Dir.Calle, Dir.NumeroCasa, Dir.NumInterior,
        Dir.Colonia, Loc.NombreLocalidad, Edo.Nombre, Dir.CP
    INTO  Var_CalleNegocio, Var_NumCasaNegocio, Var_NumIntNegocio,
        Var_ColoniaNegocio, Var_CiudadNegocio, Var_EstadoNegocio, Var_CPNegocio
    FROM  CREDITOS Cre
    INNER JOIN    DIRECCLIENTE  Dir ON  Dir.ClienteID = Cre.ClienteID
                    AND Dir.TipoDireccionID = 2
    LEFT OUTER JOIN LOCALIDADREPUB  Loc ON  Loc.LocalidadID = Dir.LocalidadID
                      AND Loc.MunicipioID = Dir.MunicipioID
                      AND Loc.EstadoID  = Dir.EstadoID
    LEFT OUTER JOIN ESTADOSREPUB  Edo ON  Edo.EstadoID  = Dir.EstadoID
    WHERE Cre.CreditoID = Par_CreditoID;

    SELECT  SocV.TiempoHabitarDom
    INTO  Var_TiempoRadicar
    FROM  CREDITOS Cre, SOCIODEMOVIVIEN SocV
    WHERE Cre.CreditoID = Par_CreditoID
      AND SocV.ClienteID  = Cre.ClienteID;

    SELECT  SocD.NumDepenEconomi, SocD.AntiguedadLab
    INTO  Var_NumDepenEconomi, Var_AntiguedadLab
    FROM  CREDITOS Cre, SOCIODEMOGRAL SocD
    WHERE Cre.CreditoID = Par_CreditoID
      AND SocD.ClienteID  = Cre.ClienteID;

    SELECT  RegistroRECA,
        Pro.FactorMora,
        Cre.TipCobComMorato
    INTO  Var_NumRECA,
        Var_FactorMora,
        Var_TipoCobroMoratorio
    FROM  PRODUCTOSCREDITO Pro, CREDITOS Cre
    WHERE ProducCreditoID = Cre.ProductoCreditoID
    AND   Cre.CreditoID = Par_CreditoID;


    SELECT  Cre.TasaFija, Cre.CreditoID,  Cre.NumAmortizacion,Cre.MontoCredito,
        Cre.PeriodicidadInt,  Cre.FrecuenciaInt,  Cre.FrecuenciaCap,  Cre.MontoSeguroVida,
        Cre.FechaVencimien,   Cre.FechaMinistrado,  Cpl.Descripcion
    INTO  Var_TasaAnual,  Var_CreditoID,    Var_NumAmorti,  Var_MontoCred,
        Var_Periodo,  Var_FrecuenciaInt,  Var_Frecuencia, Var_MontoSeguro,
        Var_FechaVenc,  Var_FechaCorte, Var_Plazo
    FROM  CREDITOS Cre
    LEFT OUTER JOIN CREDITOSPLAZOS    Cpl ON    Cpl.PlazoID     = Cre.PlazoID
    WHERE CreditoID = Par_CreditoID;

    SELECT  SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres),
        SUM(Amo.Interes),
        MAX(Amo.FechaVencim)
    INTO  Var_TotPagar,
        Var_TotInteres,
        Var_FechaLimPag
    FROM  AMORTICREDITO Amo
    WHERE Amo.CreditoID = Par_CreditoID;

    SELECT  Ins.Nombre,
        Ins.NombreCorto
    INTO  Var_NomInstit,
        Var_NomCortoInstit
    FROM  INSTITUCIONES Ins, CREDITOS Cre, PARAMETROSSIS Par
    WHERE Cre.CreditoID = Par_CreditoID
    AND   Par.EmpresaID   = Cre.EmpresaID
    AND   Ins.InstitucionID = Par.InstitucionID;

    SELECT  Mun.Nombre,
        Edo.Nombre
    INTO  Var_NombMunicipio,
        Var_NombEstado
    FROM      SUCURSALES  Suc
    INNER JOIN    CREDITOS Cre    ON  Cre.SucursalID  = Suc.SucursalID
    LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON  Mun.EstadoID  = Suc.EstadoID
                      AND Mun.MunicipioID = Suc.MunicipioID
    LEFT OUTER JOIN ESTADOSREPUB  Edo ON  Edo.EstadoID  = Suc.EstadoID
    WHERE Cre.CreditoID = Par_CreditoID;

    SET Var_TasaAnual   := IFNULL(Var_TasaAnual, Entero_Cero);
    SET Var_CreditoID   := IFNULL(Var_CreditoID, Entero_Cero);
    SET Var_NumAmorti   := IFNULL(Var_NumAmorti, Entero_Cero);
    SET Var_TasaMens    := ROUND(Var_TasaAnual / 12, 2);
    SET Var_TotInteres  := IFNULL(Var_TotInteres, Entero_Cero);
    SET Var_TasaFlat    := ( ( (Var_TotInteres / Var_NumAmorti) / Var_MontoCred ) /
                  Var_Periodo ) * 30 * 100;
    SET Var_TasaFlat    := ROUND(Var_TasaFlat, 4);


    SET Var_Nombre        :=  IFNULL(Var_Nombre,Cadena_Vacia);
    SET Var_ApellidoPaterno   :=  IFNULL(Var_ApellidoPaterno,Cadena_Vacia);
    SET Var_ApellidoMaterno   :=  IFNULL(Var_ApellidoMaterno,Cadena_Vacia);
    SET Var_Sexo        :=  IFNULL(Var_Sexo,Cadena_Vacia);
    SET Var_FechaNacimientoTxt  :=  IFNULL(Var_FechaNacimientoTxt,Cadena_Vacia);
    SET Var_Edad        :=  IFNULL(Var_Edad,Entero_Cero);
    SET Var_RFC         :=  IFNULL(Var_RFC,Cadena_Vacia);
    SET Var_Ocupacion     :=  IFNULL(Var_Ocupacion,Cadena_Vacia);
    SET Var_Correo        :=  IFNULL(Var_Correo,Cadena_Vacia);
    SET Var_Calle       :=  IFNULL(Var_Calle,Cadena_Vacia);
    SET Var_NumCasa       :=  IFNULL(Var_NumCasa, Cadena_Vacia);
    SET Var_NumInterior     :=  IFNULL(Var_NumInterior, Cadena_Vacia);
    SET Var_NombreColonia   :=  IFNULL(Var_NombreColonia,Cadena_Vacia);
    SET Var_Ciudad        :=  IFNULL(Var_Ciudad,Cadena_Vacia);
    SET Var_NombreEstado    :=  IFNULL(Var_NombreEstado,Cadena_Vacia);
    SET Var_CP          :=  IFNULL(Var_CP,Cadena_Vacia);
    SET Var_TiempoRadicar   :=  IFNULL(Var_TiempoRadicar,Entero_Cero);
    SET Var_Telefono      :=  IFNULL(Var_Telefono,Cadena_Vacia);
    SET Var_TelefonoCelular   :=  IFNULL(Var_TelefonoCelular,Cadena_Vacia);
    SET Var_EstadoCivil     :=  IFNULL(Var_EstadoCivil,Cadena_Vacia);
    SET Var_NumDepenEconomi   :=  IFNULL(Var_NumDepenEconomi,Entero_Cero);
    SET Var_MontoCuota      :=  IFNULL(Var_MontoCuota,Entero_Cero);
    SET Var_Nacionalidad    :=  IFNULL(Var_Nacionalidad,Cadena_Vacia);
    SET Var_AntiguedadLab   :=  IFNULL(Var_AntiguedadLab,Entero_Cero);
    SET Var_CalleNegocio    :=  IFNULL(Var_CalleNegocio,Cadena_Vacia);
    SET Var_NumCasaNegocio    :=  IFNULL(Var_NumCasaNegocio,Entero_Cero);
    SET Var_NumIntNegocio   :=  IFNULL(Var_NumIntNegocio,Entero_Cero);
    SET Var_ColoniaNegocio    :=  IFNULL(Var_ColoniaNegocio,Cadena_Vacia);
    SET Var_CiudadNegocio   :=  IFNULL(Var_CiudadNegocio,Cadena_Vacia);
    SET Var_EstadoNegocio   :=  IFNULL(Var_EstadoNegocio,Cadena_Vacia);
    SET Var_CPNegocio     :=  IFNULL(Var_CPNegocio,Cadena_Vacia);
    SET Var_NumRECA       :=  IFNULL(Var_NumRECA,Cadena_Vacia);
    SET Var_DirSucursal		:= IFNULL(Var_DirSucursal,Cadena_Vacia);
    SELECT  Var_Nombre, Var_ApellidoPaterno, Var_ApellidoMaterno, Var_Sexo, Var_FechaNacimientoTxt,
        Var_Edad,Var_RFC, Var_Ocupacion, Var_Correo, Var_Calle, Var_NumCasa, Var_NumInterior, Var_NombreColonia,
        Var_Ciudad, Var_NombreEstado, Var_CP,
        CASE  WHEN  IFNULL(Var_TiempoRadicar, Entero_Cero)  <> Entero_Cero  THEN  CONCAT(ROUND(Var_TiempoRadicar/12,1), ' AÑOS')
            ELSE  Cadena_Vacia
        END AS  Var_TiempoRadicar,
        Var_Telefono, Var_TelefonoCelular, Var_EstadoCivil,
        CASE  WHEN  IFNULL(Var_NumDepenEconomi,Entero_Cero) > 0 THEN  Var_NumDepenEconomi
            ELSE  'NA'
        END AS  Var_NumDepenEconomi,
        Var_MontoCuota, Var_Nacionalidad,
        CASE
          WHEN  IFNULL(Var_AntiguedadLab,Entero_Cero) > 0 THEN  Var_AntiguedadLab
          ELSE  'NA'
        END AS  Var_AntiguedadLab,
        CONCAT( Var_CalleNegocio,
            CASE  WHEN  IFNULL(Var_NumCasaNegocio,Entero_Cero)  <> Entero_Cero  THEN  CONCAT(' ',Var_NumCasaNegocio)
                ELSE  Cadena_Vacia
            END,
            CASE  WHEN  IFNULL(Var_NumIntNegocio,Entero_Cero) <> Entero_Cero  THEN  CONCAT(', INT. ', Var_NumIntNegocio)
                ELSE  Cadena_Vacia
            END
        ) AS Var_DireccionNegocio,
        Var_ColoniaNegocio, Var_CiudadNegocio, Var_EstadoNegocio, Var_CPNegocio,
        Var_NumRECA,
        CONCAT(ROUND(Var_TasaMens,2),'%') AS  Var_TasaMens,
        CONCAT(ROUND(Var_TasaAnual,2),'%')  AS  Var_TasaAnual,
        Var_TotPagar,CONVPORCANT(Var_TotPagar,'$', 'Peso', 'Nacional') AS Var_TotPagarTxt,    Var_NumAmorti,      Var_Plazo,
        Var_MontoCred,        FORMATEAFECHACONTRATO(Var_FechaLimPag) AS Var_FechaLimPag,
        FORMATEAFECHACONTRATO(Var_FechaVenc) AS Var_FechaVenc,  CONCAT(Var_NombMunicipio,', ',Var_NombEstado) AS Var_dirSuc,
        FORMATEAFECHACONTRATO(Var_FechaCorte) AS Var_FechaCorte, Var_NomInstit,
        CASE  Var_TipoCobroMoratorio
          WHEN  NVecesTasaOrd   THEN  CONCAT(ROUND(Var_FactorMora*Var_TasaAnual,2),'%')
          WHEN  TasaFijaAnualizada  THEN  CONCAT(ROUND(Var_FactorMora,2),'%')
        END AS  Var_TasaMoratoria,
        CASE  Var_TipoCobroMoratorio
          WHEN  NVecesTasaOrd   THEN  CONVPORCANT(ROUND(Var_FactorMora*Var_TasaAnual,2),'%', 0, 0)
          WHEN  TasaFijaAnualizada  THEN  CONVPORCANT(ROUND(Var_FactorMora,2),'%', 0, 0)
        END AS  Var_TasaMoratoriaTxt,
        CASE  Var_TipoCobroMoratorio
          WHEN  NVecesTasaOrd   THEN  CONCAT(ROUND(Var_FactorMora*Var_TasaAnual/12,2),'%')
          WHEN  TasaFijaAnualizada  THEN  CONCAT(ROUND(Var_FactorMora/12,2),'%')
        END AS  Var_TasaMoratoriaMen, Var_FechaSistema, Var_DirSucursal
    ;

  END IF;

END IF;

IF (Par_TipoReporte = TipoAvalesSTFc) THEN

  CALL TRANSACCIONESPRO(Var_NumeroTransaccion);

  OPEN CURSORAVAL_STF;
  BEGIN
    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
    LOOP

    FETCH CURSORAVAL_STF INTO
    Var_AvalNombreCompleto, Var_Nombre, Var_ApellidoPaterno,  Var_ApellidoMaterno,  Var_Sexo, Var_FechaNacimientoTxt, Var_EdadTxt,
    Var_RFC,  Var_Ocupacion,  Var_Correo, Var_AvalDirCompleta,  Var_Domicilio,  Var_Colonia,  Var_Ciudad, Var_NombEstado,
    Var_CP, Var_TiempoRadicarTxt, Var_Telefono, Var_TelefonoCelular;

    INSERT INTO TMPAVALESSTF
    VALUES (
      Var_NumeroTransaccion,  Var_AvalNombreCompleto,   Var_Nombre, Var_ApellidoPaterno,  Var_ApellidoMaterno,
      Var_Sexo,   Var_FechaNacimientoTxt,   Var_EdadTxt,  Var_RFC,    Var_Ocupacion,
      Var_Correo,   Var_AvalDirCompleta,    Var_Domicilio,  Var_Colonia,    Var_Ciudad,
      Var_NombEstado,   Var_CP,       Var_TiempoRadicarTxt, Var_Telefono, Var_TelefonoCelular);
    END LOOP;
  END;
  CLOSE CURSORAVAL_STF;


  SELECT TransaccionID,
    AvalNombreCompleto  AS Aval_NombreCompleto,
    AvalNombres     AS Aval_Nombre,
    AvalApellidoPaterno   AS Aval_ApellidoPaterno,
    AvalApellidoMaterno   AS Aval_ApellidoMaterno,
    AvalSexo    AS Aval_Sexo,
    AvalFechaNacimiento   AS Aval_FechaNacimiento,
    AvalEdad    AS Aval_Edad,
    AvalRFC     AS Aval_RFC,
    AvalOcupacion   AS Aval_Ocupacion,
    AvalCorreo    AS Aval_Correo,
    AvalDireccionCompleta AS Aval_DireccionCompleta,
    AvalDomicilio   AS Aval_Domicilio,
    AvalColonia     AS Aval_Colonia,
    AvalCiudad    AS Aval_Ciudad,
    AvalEstado    AS Aval_Estado,
    AvalCP    AS Aval_CP,
    AvalRadicar     AS Aval_Radicar,
    AvalTelCasa     AS Aval_TelCasa,
    AvalCelular     AS Aval_Celular
   FROM TMPAVALESSTF
   WHERE TransaccionID = Var_NumeroTransaccion;


  DELETE FROM TMPAVALESSTF  WHERE TransaccionID = Var_NumeroTransaccion;

END IF;

IF (Par_TipoReporte = TipoAvalesSTFs) THEN

  CALL TRANSACCIONESPRO(Var_NumeroTransaccion);

  OPEN CURSORAVAL_STF;
  BEGIN
    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
    LOOP

    FETCH CURSORAVAL_STF INTO
    Var_AvalNombreCompleto, Var_Nombre, Var_ApellidoPaterno,  Var_ApellidoMaterno,  Var_Sexo, Var_FechaNacimientoTxt, Var_EdadTxt,
    Var_RFC,  Var_Ocupacion,  Var_Correo, Var_AvalDirCompleta,  Var_Domicilio,  Var_Colonia,  Var_Ciudad, Var_NombEstado,
    Var_CP, Var_TiempoRadicarTxt, Var_Telefono, Var_TelefonoCelular;

    INSERT INTO TMPAVALESSTF
    VALUES (Var_NumeroTransaccion,Var_AvalNombreCompleto, Var_Nombre, Var_ApellidoPaterno,  Var_ApellidoMaterno,  Var_Sexo, Var_FechaNacimientoTxt, Var_EdadTxt,
    Var_RFC,  Var_Ocupacion,  Var_Correo, Var_AvalDirCompleta,  Var_Domicilio,  Var_Colonia,  Var_Ciudad, Var_NombEstado,
    Var_CP, Var_TiempoRadicarTxt, Var_Telefono, Var_TelefonoCelular);
    END LOOP;
  END;
  CLOSE CURSORAVAL_STF;

  SELECT  Cli.NombreCompleto, D.DireccionCompleta
  INTO  Var_Nombre, Var_Domicilio
  FROM      CLIENTES Cli
  INNER JOIN    CREDITOS Cre  ON  Cre.ClienteID = Cli.ClienteID
  LEFT OUTER JOIN DIRECCLIENTE D  ON  D.ClienteID   = Cre.ClienteID
                  AND D.Oficial   = DirOficial
  WHERE Cre.CreditoID = Par_CreditoID;

  SET Conti :=  0;
  SET Contj :=  1;


  OPEN  CURSORAVALSTFSIMPLE;
  BEGIN
    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
    LOOP

      FETCH CURSORAVALSTFSIMPLE INTO
      Var_AvalNombreCompleto, Var_AvalDirCompleta;

      IF  (Conti = 0) THEN
        INSERT  INTO  TMPAVALESSTFL
        VALUES  (Var_NumeroTransaccion, Contj,  Var_Nombre, Var_Domicilio,  Var_AvalNombreCompleto, Var_AvalDirCompleta);

        SET Contj = Contj + 1;
      ELSE
        IF  (Conti % 2 = 1) THEN
            INSERT INTO TMPAVALESSTFL
            VALUES(Var_NumeroTransaccion, Contj,  Var_AvalNombreCompleto, Var_AvalDirCompleta,  '', '');
        ELSE
            UPDATE  TMPAVALESSTFL
            SET   AvalNombre2 = Var_AvalNombreCompleto, AvalDomicilio2 =  Var_AvalDirCompleta
            WHERE TransaccionID = Var_NumeroTransaccion
            AND   Consecutivo   = Contj;

            SET Contj = Contj + 1;
        END IF;
      END IF;

      SET Conti = Conti + 1;

    END LOOP;
  END;
  CLOSE CURSORAVALSTFSIMPLE;

  SELECT  TransaccionID, Consecutivo, AvalNombre1 AS Aval_Nombre1, AvalDomicilio1 AS Aval_Domicilio1, AvalNombre2 AS Aval_Nombre2, AvalDomicilio2 AS Aval_Domicilio2,
      Conti AS  NumAvales
  FROM  TMPAVALESSTFL
  WHERE TransaccionID = Var_NumeroTransaccion;

  DELETE FROM TMPAVALESSTF  WHERE TransaccionID = Var_NumeroTransaccion;
  DELETE FROM TMPAVALESSTFL WHERE TransaccionID = Var_NumeroTransaccion;

END IF;

IF (Par_TipoReporte = TipoOrderExpress) THEN

 SET TipoCredito :=(SELECT TipoCredito FROM CREDITOS WHERE CreditoID=Par_CreditoID);
-- datos del credito
    SELECT  pc.Descripcion,  pc.NombreComercial,CASE
                        WHEN pc.Tipo =  DestComercial THEN  TxtComercial
                        WHEN pc.Tipo =  DestConsumo THEN  TxtConsumo
                        WHEN pc.Tipo =  DestHipotecario THEN  TxtHipotecario
                                                    ELSE NoAplica
                                                  END ,
            CONCAT(CAST(cr.ValorCAT AS CHAR), '%' ), CONCAT(CAST(cr.TasaFija AS CHAR), '%' ),
        CONCAT( '$',CAST(FORMAT(cr.MontoCredito,2) AS CHAR)),
        cp.Descripcion,     pc.RegistroRECA,IF( cl.TipoPersona = PersonaMoral,  cl.RazonSocial, cl.NombreCompleto),
        cl.RFCOficial,      dc.DireccionCompleta,   pc.RequiereAvales,  pc.RequiereGarantia,  cr.PeriodicidadInt,
        cr.FrecuenciaInt,   cr.FrecuenciaCap,       cr.TipoPagoCapital, cr.NumAmortizacion,   (cr.MontoComApert+cr.IVAComApertura),
        cr.ClienteID,       FORMATEAFECHACONTRATO(cr.FechaMinistrado),  cr.ProductoCreditoID,   cp.dias,
        cr.FechaVencimien,  cr.TipoCredito, cr.SolicitudCreditoID,
        cr.FactorMora,		cr.TipCobComMorato,
		cr.TasaFija,		cr.FechaMinistrado,
		pc.FactorMora
    INTO    Var_NombreProducto, PCred_NomComer,     Cre_TipCreClatxt,   Var_CATtxt,             Cre_TasaFijatxt,
    Var_MontoCredito,   Var_Plazo,      Var_NumRECA,      Var_Nombre,       Var_RFC,
    Var_Direc,        Var_RequiereAvales, Var_ReqGarantia,    Var_Periodo,          Var_FrecuenciaInt,
    Var_Frecuencia,     Var_TipoPagoCap,  Var_NumAmorti,      Var_ComisionApertura, Var_CreClienteID,
	Cre_FechaDesem,     Var_ProductoCreditoID,  Var_PlazoDias,  Var_FechaVenc,TipoCredito,Var_SolicitudCredID,
	Var_TasaMoraAnual,Var_TipCobComMorato,Var_TasaAnual,		Var_FechaCorte, Var_FactorMora
    FROM    CREDITOS cr
    LEFT OUTER JOIN PRODUCTOSCREDITO  pc  ON pc.ProducCreditoID = cr.ProductoCreditoID
    LEFT OUTER JOIN CREDITOSPLAZOS    cp  ON cr.PlazoID     = cp.PlazoID
    LEFT OUTER JOIN CLIENTES      cl  ON cr.ClienteID   = cl.ClienteID
    LEFT OUTER JOIN DIRECCLIENTE    dc  ON cr.ClienteID   = dc.ClienteID
                        AND Oficial     = DirOficialSI
  WHERE Par_CreditoID = cr.CreditoID  LIMIT 1;

  SELECT  C.NombreCompleto, C.RFCOficial
  INTO  Var_NombreCompleto, Var_RFCOficial
  FROM  CLIENTES  C
  WHERE C.ClienteID = Var_CreClienteID
  LIMIT 1;

  SELECT CONCAT(D.Calle,' No. ',D.NumeroCasa,' ',D.Colonia,', ',M.Nombre,TxtCP,D.CP,', ',E.Nombre)
  INTO  Var_DirecCliente
  FROM  DIRECCLIENTE D
  LEFT OUTER JOIN ESTADOSREPUB  E ON    E.EstadoID    = D.EstadoID
  LEFT OUTER JOIN MUNICIPIOSREPUB M ON    M.EstadoID    = D.EstadoID
                      AND M.MunicipioID = D.MunicipioID
  WHERE D.ClienteID = Var_CreClienteID
    AND   D.Oficial = DirOficialSI
  LIMIT 1;
	-- plazos de la reestructura
  -- Calculo Tasa Moratoria 
	IF (Var_TipCobComMorato='T') THEN
		SET Var_TasaMoratoria   := ROUND(Var_TasaMoraAnual, 2);
	  ELSE
		SET Var_TasaMoratoria   := ROUND( Var_TasaAnual * Var_TasaMoraAnual, 2);
	END IF;

	IF (TipoCredito = Con_Reestructura) THEN

    SELECT FechaRegistro  INTO Var_FechaRegistro
            FROM REESTRUCCREDITO Res,
                CREDITOS Cre
            WHERE Res.CreditoOrigenID= Par_CreditoID
            AND Res.CreditoDestinoID = Par_CreditoID
            AND Cre.CreditoID = Res.CreditoDestinoID
            AND Res.EstatusReest = EstDesembolsada
            AND Res.Origen= Con_Reestructura;

    SELECT COUNT(Amo.CreditoID) INTO Var_NumAmorti
					FROM SOLICITUDCREDITO Sol
					INNER JOIN CREDITOS Cre
						ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
					AND Sol.Estatus= EstDesembolsada
					AND Sol.TipoCredito= Con_Reestructura
					INNER JOIN REESTRUCCREDITO Res
						ON Res.CreditoOrigenID = Cre.CreditoID
					AND Res.CreditoDestinoID = Cre.CreditoID
					AND Cre.TipoCredito = Con_Reestructura
					INNER JOIN AMORTICREDITO Amo
						ON Amo.CreditoID = Cre.CreditoID
					WHERE Amo.CreditoID = Par_CreditoID
					AND (Amo.FechaLiquida > Var_FechaRegistro
						OR Amo.FechaLiquida = Fecha_Vacia);
	END IF;

  IF(Var_TipoPagoCap=Tipo_PagoLibre OR Var_FrecuenciaInt != Var_Frecuencia)THEN
    SET Var_DesFrecLet = TxtMixtas;
    SELECT  CONCAT(CONVERT(Var_NumAmorti,CHAR),' ',
    CASE
      WHEN Var_NumAmorti ='1' THEN 'Amortizacion Libre'
      ELSE 'Amortizaciones Libres'
    END ) INTO Var_Plazo;
  ELSE
    SELECT  CASE
          WHEN Var_Frecuencia = FrecSemanal THEN CONCAT( UPPER(SUBSTR( TxtSemanal  ,1,1)),        SUBSTR( TxtSemanal ,2))
          WHEN Var_Frecuencia = FrecCatorcenal THEN CONCAT( UPPER(SUBSTR( TxtCatorcenal  ,1,1)),        SUBSTR( TxtCatorcenal ,2))
          WHEN Var_Frecuencia = FrecQuincenal THEN CONCAT( UPPER(SUBSTR( TxtQuincenal  ,1,1)),        SUBSTR( TxtQuincenal ,2))
          WHEN Var_Frecuencia = FrecMensual THEN CONCAT( UPPER(SUBSTR( TxtMensual  ,1,1)),        SUBSTR( TxtMensual ,2))
          WHEN Var_Frecuencia = FrecPeriodica THEN CONCAT( UPPER(SUBSTR( TxtPeriodica  ,1,1)),        SUBSTR( TxtPeriodica ,2))
          WHEN Var_Frecuencia = FrecBimestral THEN CONCAT( UPPER(SUBSTR( TxtBimestral  ,1,1)),        SUBSTR( TxtBimestral ,2))
          WHEN Var_Frecuencia = FrecTrimestral THEN CONCAT( UPPER(SUBSTR( TxtTrimestral  ,1,1)),        SUBSTR( TxtTrimestral ,2))
          WHEN Var_Frecuencia = FrecTetramestral THEN CONCAT( UPPER(SUBSTR( TxtTetramestral  ,1,1)),        SUBSTR( TxtTetramestral ,2))
          WHEN Var_Frecuencia = FrecSemestral THEN CONCAT( UPPER(SUBSTR( TxtSemestral  ,1,1)),        SUBSTR( TxtSemestral ,2))
          WHEN Var_Frecuencia = FrecAnual THEN CONCAT( UPPER(SUBSTR( TxtAnual  ,1,1)),        SUBSTR( TxtAnual ,2))
          WHEN Var_Frecuencia = FrecLibre THEN TxtLibre
          WHEN Var_Frecuencia = FrecDecenal THEN CONCAT( UPPER(SUBSTR( TxtDecenal  ,1,1)),        SUBSTR( TxtDecenal ,2))
        END INTO Var_DesFrec;

    SET Var_DesFrec     := IFNULL(Var_DesFrec, Cadena_Vacia);

    SELECT  CONCAT(CONVERT(Var_NumAmorti, CHAR), ' ' ,
        CASE
          WHEN Var_Frecuencia = FrecSemanal THEN CONCAT( UPPER(SUBSTR( TxtSemanas  ,1,1)),        SUBSTR( TxtSemanas ,2))
          WHEN Var_Frecuencia = FrecCatorcenal THEN CONCAT( UPPER(SUBSTR( TxtCatorcenas  ,1,1)),        SUBSTR( TxtCatorcenas ,2))
          WHEN Var_Frecuencia = FrecQuincenal THEN CONCAT( UPPER(SUBSTR( TxtQuincenas  ,1,1)),        SUBSTR( TxtQuincenas ,2))
          WHEN Var_Frecuencia = FrecMensual THEN CONCAT( UPPER(SUBSTR( TxtMeses  ,1,1)),        SUBSTR( TxtMeses ,2))
          WHEN Var_Frecuencia = FrecPeriodica THEN CONCAT( UPPER(SUBSTR( TxtPeriodos  ,1,1)),        SUBSTR( TxtPeriodos ,2))
          WHEN Var_Frecuencia = FrecBimestral THEN CONCAT( UPPER(SUBSTR( TxtBimestres  ,1,1)),        SUBSTR( TxtBimestres ,2))
          WHEN Var_Frecuencia = FrecTrimestral THEN CONCAT( UPPER(SUBSTR( TxtTrimestres  ,1,1)),        SUBSTR( TxtTrimestres ,2))
          WHEN Var_Frecuencia = FrecTetramestral THEN CONCAT( UPPER(SUBSTR( TxtTetramestres  ,1,1)),        SUBSTR( TxtTetramestres ,2))
          WHEN Var_Frecuencia = FrecSemestral THEN CONCAT( UPPER(SUBSTR( TxtSemestres  ,1,1)),        SUBSTR( TxtSemestres ,2))
          WHEN Var_Frecuencia = FrecAnual THEN CONCAT( UPPER(SUBSTR( TxtAnios  ,1,1)),        SUBSTR( TxtAnios ,2))
          WHEN Var_Frecuencia = FrecLibre THEN TxtLibres
                    WHEN Var_Frecuencia = FrecUnico THEN TxtUnico
          WHEN Var_Frecuencia = FrecDecenal THEN CONCAT( UPPER(SUBSTR( TxtDecenas  ,1,1)),        SUBSTR( TxtDecenas ,2))

        END ) INTO Var_Plazo;
        SELECT
            CASE
          WHEN Var_Frecuencia = FrecUnico THEN CAST(TextUnico AS CHAR CHARACTER SET utf8)
          WHEN Var_Frecuencia = FrecSemanal THEN CONCAT( UPPER(SUBSTR( TxtSemanales  ,1,1)),        SUBSTR( TxtSemanales ,2))
          WHEN Var_Frecuencia = FrecCatorcenal THEN CONCAT( UPPER(SUBSTR( TxtCatorcenales  ,1,1)),        SUBSTR( TxtCatorcenales ,2))
          WHEN Var_Frecuencia = FrecQuincenal THEN CONCAT( UPPER(SUBSTR( TxtQuincenales  ,1,1)),        SUBSTR( TxtQuincenales ,2))
          WHEN Var_Frecuencia = FrecMensual THEN CONCAT( UPPER(SUBSTR( TxtMensuales  ,1,1)),        SUBSTR( TxtMensuales ,2))
          WHEN Var_Frecuencia = FrecPeriodica THEN CONCAT( UPPER(SUBSTR( TxtPeriodos  ,1,1)),        SUBSTR( TxtPeriodos ,2))
          WHEN Var_Frecuencia = FrecBimestral THEN CONCAT( UPPER(SUBSTR( TxtBimestrales  ,1,1)),        SUBSTR( TxtBimestrales ,2))
          WHEN Var_Frecuencia = FrecTrimestral THEN CONCAT( UPPER(SUBSTR( TxtTrimestrales  ,1,1)),        SUBSTR( TxtTrimestrales ,2))
          WHEN Var_Frecuencia = FrecTetramestral THEN CONCAT( UPPER(SUBSTR( TxtTetramestrales  ,1,1)),        SUBSTR( TxtTetramestrales ,2))
          WHEN Var_Frecuencia = FrecSemestral THEN CONCAT( UPPER(SUBSTR( TxtSemestrales  ,1,1)),        SUBSTR( TxtSemestrales ,2))
          WHEN Var_Frecuencia = FrecAnual THEN CONCAT( UPPER(SUBSTR( TxtAnuales  ,1,1)),        SUBSTR( TxtAnuales ,2))
          WHEN Var_Frecuencia = FrecLibre THEN TxtLibres
          WHEN Var_Frecuencia = FrecDecenal THEN CONCAT( UPPER(SUBSTR( TxtDecenales  ,1,1)),        SUBSTR( TxtDecenales ,2))
        END INTO Var_DesFrecLet;
  END IF;

-- Nombre completo y corto de la institucion
  SELECT
    ins.Nombre, ins.NombreCorto
  INTO
    Var_NombreInstitucion, Var_NomCortoInstit
  FROM
    PARAMETROSSIS ps,
    INSTITUCIONES ins
  WHERE
    ps.InstitucionID = ins.InstitucionID
  LIMIT 1;

    -- Monto total a pagar  o minimo a pagar
  IF (EXISTS (SELECT CreditoID FROM PAGARECREDITO WHERE CreditoID = Par_CreditoID )) THEN
     SELECT
        CONCAT( '$',CAST(FORMAT(SUM(Capital) + SUM(Interes) + SUM(IVAInteres),2) AS CHAR) )
            INTO MontoTotPagar
            FROM PAGARECREDITO
        WHERE
        CreditoID = Par_CreditoID;
  ELSE
    SELECT
      CONCAT( '$',CAST(FORMAT(SUM(Capital) + SUM(Interes) + SUM(IVAInteres) + SUM(MontoOtrasComisiones) + SUM(MontoIVAOtrasComisiones) + IFNULL(SUM(Amo.MontoIntOtrasComis), Entero_Cero) + IFNULL(SUM(Amo.MontoIVAIntComisi),Entero_Cero),2) AS CHAR) )
    INTO
      MontoTotPagar
    FROM
      AMORTICREDITO
    WHERE
      CreditoID = Par_CreditoID;
  END IF;



  IF TipoCredito = Con_Reestructura THEN

        SELECT FechaRegistro  INTO Var_FechaRegistro
            FROM REESTRUCCREDITO Res,
                CREDITOS Cre
            WHERE Res.CreditoOrigenID= Par_CreditoID
            AND Res.CreditoDestinoID = Par_CreditoID
            AND Cre.CreditoID = Res.CreditoDestinoID
            AND Res.EstatusReest = EstDesembolsada
            AND Res.Origen= Con_Reestructura;

            SELECT CONCAT( '$',CAST(FORMAT(SUM(Amo.Capital) + SUM(Amo.Interes) + SUM(Amo.IVAInteres)+ IFNULL(SUM(Amo.MontoOtrasComisiones),Entero_Cero) + IFNULL(SUM(Amo.MontoIVAOtrasComisiones),Entero_Cero) + IFNULL(SUM(Amo.MontoIntOtrasComis), Entero_Cero) + IFNULL(SUM(Amo.MontoIVAIntComisi),Entero_Cero),2) AS CHAR) ) INTO MontoTotPagar
            FROM SOLICITUDCREDITO Sol
            INNER JOIN CREDITOS Cre
                ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
                AND Sol.Estatus= EstDesembolsada
                AND Sol.TipoCredito= Con_Reestructura
            INNER JOIN REESTRUCCREDITO Res
                ON Res.CreditoOrigenID = Cre.CreditoID
                AND Res.CreditoDestinoID = Cre.CreditoID
                AND Cre.TipoCredito = Con_Reestructura
            INNER JOIN AMORTICREDITO Amo
                ON Amo.CreditoID = Cre.CreditoID
            WHERE Amo.CreditoID = Par_CreditoID
            AND (Amo.FechaLiquida > Var_FechaRegistro
                OR Amo.FechaLiquida = Fecha_Vacia);
  END IF;
-- nombre del representante de la sucursal
  SELECT
    CONCAT(su.TituloGte,' ',us.NombreCompleto), CONCAT(Mun.Nombre,', ', Est.Nombre)
  INTO
    Var_NomRepres, Var_DireccSucursal
  FROM
    SUCURSALES su
    LEFT OUTER JOIN ESTADOSREPUB Est  ON Est.EstadoID =su.EstadoID
    LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON Mun.MunicipioID  =su.MunicipioID
                      AND Mun.EstadoID  =su.EstadoID
    LEFT OUTER JOIN USUARIOS us     ON su.NombreGerente = us.UsuarioID
  WHERE su.SucursalID = Aud_Sucursal;

-- CURSOR para obtener los primeros 3 avales
  IF (Var_RequiereAvales = 'S' OR Var_RequiereAvales = 'I') THEN
    SET Conti := 1;
    OPEN CURSORAVALES;
      BEGIN
        DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        LOOP
          FETCH CURSORAVALES INTO
          Var_AvalID, Var_ClienteID,  Var_ProspectoID,  Var_Nombre,   Var_Direc,  Var_RFC,
          Var_CURP, Var_Edad,   Var_NombreIdent,  Var_NumIdent, Var_EstadoCivil;
          CASE Conti
            WHEN 1 THEN
              SET Avales_Nom1 := Var_Nombre;
              SET Avales_RFC1 := Var_RFC;
              SET Avales_Dir1 := Var_Direc;
            WHEN 2 THEN
              SET Avales_Nom2 := Var_Nombre;
              SET Avales_RFC2 := Var_RFC;
              SET Avales_Dir2 := Var_Direc;
            WHEN 3 THEN
              SET Avales_Nom3 := Var_Nombre;
              SET Avales_RFC3 := Var_RFC;
              SET Avales_Dir3 := Var_Direc;
                ELSE SELECT Cadena_Vacia;
          END CASE;
          SET Conti := Conti + 1;
        END LOOP;
      END;
    CLOSE CURSORAVALES;
  END IF;

-- Garantia liquida
 SELECT COUNT(ProducCreditoID) INTO NumRegGarLiq
    FROM ESQUEMAGARANTIALIQ
    WHERE ProducCreditoID = Var_ProductoCreditoID;

    IF (NumRegGarLiq > Entero_Cero) THEN
        SET Var_ReqGarLiq := Constante_SI;
    ELSE
        SET Var_ReqGarLiq := Constante_NO;
    END IF;

  IF (Var_ReqGarLiq = Constante_SI) THEN
    SELECT SUM(CASE WHEN Blo.NatMovimiento = Bloqueado
                        THEN IFNULL(Blo.MontoBloq,Decimal_Cero)
                    ELSE IFNULL(Blo.MontoBloq,Decimal_Cero)  * -1
                END) AS MontoGa,  tc.Descripcion,   Blo.CuentaAhoID
                    INTO  Var_MontoGarLiq,GarLiq_Desc,  GarLiq_Ref
        FROM  BLOQUEOS    Blo
        INNER JOIN CUENTASAHO Cu
            ON Blo.CuentaAhoID = Cu.CuentaAhoID
        INNER JOIN TIPOSCUENTAS tc
            ON Cu.TipoCuentaID = tc.TipoCuentaID
        WHERE   Blo.TiposBloqID = TipoBloqueado
            AND   Blo.Referencia  = Par_CreditoID
        GROUP BY Blo.Referencia,  tc.Descripcion,   Blo.CuentaAhoID;


    IF(Var_MontoGarLiq <= Entero_Cero) THEN
        SET Var_MonGarLiq := Cadena_Vacia;
        SET GarLiq_Desc := Cadena_Vacia;
        SET GarLiq_Ref := Cadena_Vacia;
    ELSE
        SET Var_MonGarLiq := CONCAT('$ ',FORMAT(Var_MontoGarLiq,2));
    END IF;


    SET Var_MontoGarLiq := IFNULL(Var_MontoGarLiq,Decimal_Cero) + IFNULL((SELECT SUM(MontoEnGar) FROM CREDITOINVGAR  WHERE CreditoID = Par_CreditoID),Decimal_Cero);
    SET Var_MonGarLiq := CONCAT('$ ',FORMAT(Var_MontoGarLiq,2));

    IF(IFNULL(GarLiq_Desc,Cadena_Vacia) = Cadena_Vacia AND Var_MontoGarLiq > Entero_Cero) THEN
        SET GarLiq_Desc :='INVERSION EN GARANTIA';
        SET GarLiq_Ref := (SELECT InversionID FROM CREDITOINVGAR  WHERE CreditoID = Par_CreditoID LIMIT 1);
    END IF;
END IF;
-- ojo esta definida que la garantia debe tener un tipo de documento de "Testimonio Notarial"
-- y el tipo de garantia debe ser "inmobiliaria" para definirla como hipotecaria

  SELECT
    Gar.NotarioID, CONCAT(Gar.TipoGarantiaID,'-',Gar.ClasifGarantiaID,'-',Gar.TipoDocumentoID ), Gar.FolioRegistro,
    CONCAT(Cg.Descripcion,'-',Tg.Descripcion), Gar.ValorComercial, Gar.GarantiaID
  INTO
    GarHip_Hipo,  GarHip_Desc,  GarHip_Ref,
    Var_GarHipDesc, Var_ValComGarHipo,  Var_FolioGarHipo
  FROM
    GARANTIAS     Gar,
    ASIGNAGARANTIAS Asi,
    CLASIFGARANTIAS Cg,
    TIPOGARANTIAS Tg
      WHERE (CASE WHEN IFNULL( Asi.CreditoID, Entero_Cero) = Entero_Cero
            THEN Asi.SolicitudCreditoID = Var_SolicitudCredID
              ELSE  Asi.CreditoID = Par_CreditoID
            END)
    AND Asi.GarantiaID    =Gar.GarantiaID
    AND Gar.TipoDocumentoID =TipoDocumTestimonio
    AND Gar.TipoGarantiaID  =TipoGarantiaInmob

    AND Cg.ClasifGarantiaID = Gar.ClasifGarantiaID
    AND Cg.TipoGarantiaID = Gar.TipoGarantiaID
    AND Tg.TipoGarantiasID  = Gar.TipoGarantiaID
    LIMIT 1;
-- Garantia REAL
  SELECT
    Gar.SerieFactura, CONCAT(Gar.TipoGarantiaID,'-',Gar.ClasifGarantiaID,'-',Gar.TipoDocumentoID ),
                      Gar.ReferenFactura,
    Cla.Descripcion,    Gar.ValorComercial, Gar.GarantiaID
  INTO
    Var_SerieFactura,   GarReal_Desc,   GarReal_Ref,
    Var_GarRealDesc,    Var_ValComGarReal,  Var_FolioGarReal
  FROM
    GARANTIAS Gar,
    ASIGNAGARANTIAS   Asi ,
    CLASIFGARANTIAS   Cla
  WHERE
    Asi.CreditoID     = Par_CreditoID
  AND Asi.GarantiaID      = Gar.GarantiaID
  AND Cla.TipoGarantiaID    = Gar.TipoGarantiaID
  AND Cla.ClasifGarantiaID  = Gar.ClasifGarantiaID
      AND Cla.EsGarantiaReal    =   Constante_SI
      LIMIT 1;


  SELECT  U.NombreCompleto
  INTO  Var_Nombre
  FROM  USUARIOS U
  WHERE U.UsuarioID = Aud_Usuario;

  SET Var_FechaSistematxt:= FORMATEAFECHACONTRATO(Var_FechaSistema);
--  valida que no halla nullos 
  SET Var_NombreProducto    := IFNULL(Var_NombreProducto, Cadena_Vacia);
  SET Var_NombreInstitucion   := IFNULL(Var_NombreInstitucion, Cadena_Vacia);
  SET Var_NomCortoInstit    := IFNULL(Var_NomCortoInstit, Cadena_Vacia);
  SET PCred_NomComer      := IFNULL(PCred_NomComer, Cadena_Vacia);
  SET Cre_TipCreClatxt    := IFNULL(Cre_TipCreClatxt, Cadena_Vacia);
  SET Var_CATtxt        := IFNULL(Var_CATtxt, Cadena_Vacia);
  SET Cre_TasaFijatxt     := IFNULL(Cre_TasaFijatxt, Cadena_Vacia);
  SET Var_MontoCredito    := IFNULL(Var_MontoCredito, Cadena_Vacia);
  SET MontoTotPagar       := IFNULL(MontoTotPagar, Cadena_Vacia);
  SET Var_Plazo         := IFNULL(Var_Plazo, Cadena_Vacia);
  SET Var_NumRECA       := IFNULL(Var_NumRECA, Cadena_Vacia);
  SET Var_NomRepres       := IFNULL(Var_NomRepres, Cadena_Vacia);
  SET Var_Nombre        := IFNULL(Var_Nombre, Cadena_Vacia);
  SET Var_RFC         := IFNULL(Var_RFC, Cadena_Vacia);
  SET Var_Direc         := IFNULL(Var_Direc, Cadena_Vacia);
  SET Avales_Nom1       := IFNULL(Avales_Nom1, Cadena_Vacia);
  SET Avales_RFC1       := IFNULL(Avales_RFC1, Cadena_Vacia);
  SET Avales_Dir1       := IFNULL(Avales_Dir1, Cadena_Vacia);
  SET Avales_Nom2       := IFNULL(Avales_Nom2, Cadena_Vacia);
  SET Avales_RFC2       := IFNULL(Avales_RFC2, Cadena_Vacia);
  SET Avales_Dir2       := IFNULL(Avales_Dir2, Cadena_Vacia);
  SET Avales_Nom3       := IFNULL(Avales_Nom3, Cadena_Vacia);
  SET Avales_RFC3       := IFNULL(Avales_RFC3, Cadena_Vacia);
  SET Avales_Dir3       := IFNULL(Avales_Dir3, Cadena_Vacia);
  SET Var_MonGarLiq       := IFNULL(Var_MonGarLiq, Cadena_Vacia);
  SET GarLiq_Desc       := IFNULL(GarLiq_Desc, Cadena_Vacia);
  SET GarLiq_Ref        := IFNULL(GarLiq_Ref, Cadena_Vacia);
  SET GarHip_Hipo       := IFNULL(GarHip_Hipo, Cadena_Vacia);
  SET GarHip_Desc       := IFNULL(GarHip_Desc, Cadena_Vacia);
  SET GarHip_Ref        := IFNULL(GarHip_Ref, Cadena_Vacia);
  SET Var_SerieFactura    := IFNULL(Var_SerieFactura, Cadena_Vacia);
  SET GarReal_Desc      := IFNULL(GarReal_Desc, Cadena_Vacia);
  SET GarReal_Ref       := IFNULL(GarReal_Ref, Cadena_Vacia);
  SET Var_DireccSucursal    := IFNULL(Var_DireccSucursal, Cadena_Vacia);
  SET Var_FechaSistematxt   := IFNULL(Var_FechaSistematxt, Cadena_Vacia);
  SET Var_ComisionApertura  := IFNULL(Var_ComisionApertura, Decimal_Cero);
  SET Var_NombreCompleto    := IFNULL(Var_NombreCompleto, Cadena_Vacia);
  SET Var_RFCOficial      := IFNULL(Var_RFCOficial, Cadena_Vacia);
  SET Var_DirecCliente    := IFNULL(Var_DirecCliente,Cadena_Vacia);
  SET Var_GarHipDesc      := IFNULL(Var_GarHipDesc, Cadena_Vacia);
  SET Var_GarRealDesc     := IFNULL(Var_GarRealDesc,Cadena_Vacia);
  SET Cre_FechaDesem      := IFNULL(Cre_FechaDesem,Cadena_Vacia);
  SET Var_ClienteID     := IFNULL(Var_CreClienteID, Entero_Cero);
  SET Var_ProductoCreditoID := IFNULL(Var_ProductoCreditoID, Entero_Cero);

  SET MontoCredH :=(SELECT MontoCredito FROM CREDITOS WHERE CreditoID=Par_CreditoID);

    SELECT ValorCAT
        INTO CatDec
    FROM CREDITOS
    WHERE CreditoID = Par_CreditoID;

    SELECT TasaFija
        INTO HTasaFija
    FROM CREDITOS
    WHERE CreditoID = Par_CreditoID;

    SELECT ROUND(Pro.FactorMora*TasaFija)
        INTO HNTasa
    FROM CREDITOS Cre
        INNER JOIN PRODUCTOSCREDITO Pro ON Pro.ProducCreditoID = Cre.ProductoCreditoID
        WHERE CreditoID = Par_CreditoID AND Pro.ProducCreditoID = Cre.ProductoCreditoID;

    SELECT TipCobComMorato
        INTO HVar_TipCobComMorato
    FROM CREDITOS
    WHERE CreditoID = Par_creditoID;

    IF (HVar_TipCobComMorato = 'N') THEN
        SET HTasaMora = HNTasa;
    ELSE
        SET HTasaMora = HTasaFija;
    END IF;

  SET Var_FechaLimitePago:=(SELECT date_format(min(FechaExigible),'%d-%m-%Y')FROM AMORTICREDITO WHERE CreditoID = Par_CreditoID);
  SET Var_FechaInicioPago:=(SELECT date_format(min(FechaVencim),'%d-%m-%Y')FROM AMORTICREDITO WHERE CreditoID = Par_CreditoID);

  SELECT
    Var_NombreProducto,     Var_NombreInstitucion,  Var_NomCortoInstit, PCred_NomComer,     Cre_TipCreClatxt,
    Var_CATtxt,             Cre_TasaFijatxt,        Var_MontoCredito,   MontoTotPagar,      Var_Plazo,
    Var_NumRECA,            Var_NomRepres,          Var_Nombre,         Var_RFC,            Var_Direc,
    Avales_Nom1,            Avales_RFC1,            Avales_Dir1,        Avales_Nom2,        Avales_RFC2,
    Avales_Dir2,            Avales_Nom3,            Avales_RFC3,        Avales_Dir3,        Var_MonGarLiq AS Var_MontoGarLiq,
    GarLiq_Desc,            GarLiq_Ref,             GarHip_Hipo,        GarHip_Desc,        GarHip_Ref,
    Var_SerieFactura,       GarReal_Desc,           GarReal_Ref,        Var_DireccSucursal, Var_FechaSistematxt,
    Var_ComisionApertura,   Var_NombreCompleto,     Var_RFCOficial,     Var_DirecCliente,   Var_GarHipDesc,
    Var_GarRealDesc,        Cre_FechaDesem,         Var_FechaSistema,   Var_ClienteID,      Var_ProductoCreditoID,
    Var_PlazoDias,          Var_FechaVenc,          TipoCredito,        Var_ValComGarHipo,  Var_ValComGarReal,
    Var_FolioGarReal,       Var_FolioGarHipo, CONVPORCANT(MontoCredH, '$', 'Peso', 'Nacional') AS MontoCredito, CatDec, HTasaMora,
     FORMATEAFECHACONTRATO(Var_FechaVenc)        AS  Var_FechaLimitePago,Var_FechaInicioPago,
      Var_TasaMoratoria,FORMATEAFECHACONTRATO(Var_FechaCorte) AS Var_FechaCorte;

END IF;
IF  Par_TipoReporte = TipoAccyEvol THEN
  SELECT
    CONCAT(mr.Nombre, ', ', er.Nombre)
  INTO
    Var_DireccSucursal
  FROM SUCURSALES sc
  LEFT OUTER JOIN ESTADOSREPUB er ON er.EstadoID = sc.EstadoID
  LEFT OUTER JOIN MUNICIPIOSREPUB mr  ON  mr.EstadoID = sc.EstadoID
                    AND mr.MunicipioID = sc.MunicipioID
  WHERE sc.SucursalID = 1;

  SELECT
    c.ClienteID,  c.ValorCAT,   c.MontoCredito, sc.Proyecto,  IF(pc.TipoComXapert= 'P', CONVPORCANT(pc.MontoComXapert, '%', 2, ''), CONVPORCANT(pc.MontoComXapert, '$', 'Peso', 'Nacional')),
    FORMATEAFECHACONTRATO(c.FechaVencimien),
            cp.Descripcion, CONCAT(c.NumAmortizacion,' PAGOS ',
                      CASE
                        WHEN c.FrecuenciaCap =  FrecSemanal
                          THEN 'SEMANALES'
                        WHEN c.FrecuenciaCap =  FrecCatorcenal
                          THEN 'CATORCENALES'
                        WHEN c.FrecuenciaCap =  FrecQuincenal
                          THEN 'QUINCENALES'
                        WHEN c.FrecuenciaCap =  FrecMensual
                          THEN 'MENSUALES'
                        WHEN c.FrecuenciaCap =  FrecPeriodica
                          THEN 'POR PERIODO'
                        WHEN c.FrecuenciaCap =  FrecBimestral
                          THEN 'BIMESTRALES'
                        WHEN c.FrecuenciaCap =  FrecTrimestral
                          THEN 'TRIMESTRALES'
                        WHEN c.FrecuenciaCap =  FrecTetramestral
                          THEN 'TETRAMESTRALES'
                        WHEN c.FrecuenciaCap =  FrecSemestral
                          THEN 'SEMESTRALES'
                        WHEN c.FrecuenciaCap =  FrecAnual
                          THEN 'ANUALES'
                        WHEN c.FrecuenciaCap =  FrecLibre
                          THEN 'LIBRES'
                        WHEN c.FrecuenciaCap =  FrecDecenal
                          THEN 'DECENALES'
                        ELSE NoAplica
                      END, ' DE CAPITAL E INTERESES'),
                            c.TasaFija,   IF(pc.TipCobComMorato = 'N', ROUND(pc.FactorMora * c.TasaFija,2) , pc.FactorMora),
    CONCAT(c.NumAmortizacion,' PAGOS DE ',FORMAT(c.MontoCuota,2), ' PESOS, HACIENDO UN TOTAL A PAGAR DE ',FORMAT(c.MontoCredito ,2), ' PESOS'),
            CASE
              WHEN c.FrecuenciaCap = FrecSemanal
                THEN CONCAT( UPPER(SUBSTR( TxtSemanal  ,1,1)),        SUBSTR( TxtSemanal ,2))
              WHEN c.FrecuenciaCap = FrecCatorcenal
                THEN CONCAT( UPPER(SUBSTR( TxtCatorcenal  ,1,1)),        SUBSTR( TxtCatorcenal ,2))
              WHEN c.FrecuenciaCap = FrecQuincenal
                THEN CONCAT( UPPER(SUBSTR( TxtQuincenal  ,1,1)),        SUBSTR( TxtQuincenal ,2))
              WHEN c.FrecuenciaCap = FrecMensual
                THEN CONCAT( UPPER(SUBSTR( TxtMensual  ,1,1)),        SUBSTR( TxtMensual ,2))
              WHEN c.FrecuenciaCap = FrecPeriodica
                THEN 'por Periodo'
              WHEN c.FrecuenciaCap = FrecBimestral
                THEN CONCAT( UPPER(SUBSTR( TxtBimestral  ,1,1)),        SUBSTR( TxtBimestral ,2))
              WHEN c.FrecuenciaCap = FrecTrimestral
                THEN CONCAT( UPPER(SUBSTR( TxtTrimestral  ,1,1)),        SUBSTR( TxtTrimestral ,2))
              WHEN c.FrecuenciaCap = FrecTetramestral
                THEN CONCAT( UPPER(SUBSTR( TxtTetramestral  ,1,1)),        SUBSTR( TxtTetramestral ,2))
              WHEN c.FrecuenciaCap = FrecSemestral
                THEN CONCAT( UPPER(SUBSTR( TxtSemestral  ,1,1)),        SUBSTR( TxtSemestral ,2))
              WHEN c.FrecuenciaCap = FrecAnual
                THEN CONCAT( UPPER(SUBSTR( TxtAnual  ,1,1)),        SUBSTR( TxtAnual ,2))
              WHEN c.FrecuenciaCap = FrecLibre
                THEN 'Libre'
              WHEN c.FrecuenciaCap = FrecDecenal
                THEN CONCAT( UPPER(SUBSTR( TxtDecenal  ,1,1)),        SUBSTR( TxtDecenal ,2))
              ELSE 'No aplica'
            END,      RegistroRECA, c.PorcGarLiq, pc.ProducCreditoID,
    FORMATEAFECHACONTRATO(c.FechaMinistrado),
            CONVPORCANT(c.MontoCredito, '$', 'Peso', 'Nacional'),
                    CONVPLAZOAMESES(c.NumAmortizacion, c.FrecuenciaCap)
  INTO
    Var_ClienteID,  Var_CAT,    Var_MontoCred,  Sol_Proyecto, ProCre_Monto,
    Cre_FechaVenc,  Var_Plazo,    Var_DesFrec,  Cre_TasaFija, Var_FactorMora,
    Cre_DescPag,  Cre_Perio,    Var_NumRECA,  Var_PorcGarLiq, Var_ProductoCre,
    Cre_FechaDesem, Var_MontoCredito,
                    Var_PlazoaMeses
  FROM
    CREDITOS c
    LEFT OUTER JOIN SOLICITUDCREDITO  sc ON sc.SolicitudCreditoID = c.SolicitudCreditoID
    LEFT OUTER JOIN PRODUCTOSCREDITO  pc ON c.ProductoCreditoID   = pc.ProducCreditoID
    LEFT OUTER JOIN CREDITOSPLAZOS    cp ON c.PlazoID       = cp.PlazoID
  WHERE c.CreditoID = Par_CreditoID;

  SELECT  cl.TipoPersona,   cl.RFCOficial,
    IF(cl.TipoPersona = 'M',
      cl.RazonSocial,
      cl.NombreCompleto),
    IF(cl.TipoPersona = 'M',
      CONCAT(TRIM(CONCAT(cl.PrimerNombre, ' ',cl.SegundoNombre, ' ',cl.TercerNombre)), ' ', TRIM(CONCAT(cl.ApellidoPaterno, ' ',cl.ApellidoMaterno))),
      NoAplica)
  INTO
    Cli_TipoPersona,    Var_RFCOficial, NombreCompleto, Var_NombreRepresentante
  FROM
    CLIENTES cl
  WHERE
    cl.ClienteID = Var_ClienteID;

  SELECT
    dc.Calle,   dc.NumeroCasa,  dc.Colonia, mr.Nombre,    er.Nombre,
    dc.CP
  INTO
    Var_Calle,  Var_NumCasa,  Var_Colonia,Var_NombreMuni, Var_NombreEstado,
    Var_CP
  FROM
    DIRECCLIENTE dc
    LEFT OUTER JOIN MUNICIPIOSREPUB mr  ON  dc.EstadoID = mr.EstadoID
                      AND dc.MunicipioID = mr.MunicipioID
    LEFT OUTER JOIN ESTADOSREPUB er ON dc.EstadoID = er.EstadoID
  WHERE
    dc.ClienteID = Var_ClienteID
  AND Oficial = 'S';

  SELECT
    MAX(FechaExigible)
  INTO
    AmortCre_FechExig
  FROM
    AMORTICREDITO
  WHERE
    CreditoID = Par_CreditoID;

  SELECT
    ps.NombreRepresentante, ins.Nombre,   ins.DirFiscal,        FORMATEAFECHACONTRATO(ps.FechaSistema)
  INTO
    Var_RepresentanteLegal, Var_NomInstit,  Var_DirFiscalInstitucion, Var_FechaSistematxt
  FROM
    PARAMETROSSIS ps
    LEFT OUTER JOIN INSTITUCIONES ins ON ins.InstitucionID = ps.InstitucionID
  LIMIT 1;

  SELECT  EscP.EscrituraPublic, EscP.NomNotario
  INTO  NumEscPConstitutiva,  NombreNotarioEscPConstitutiva
  FROM  ESCRITURAPUB EscP,
      PARAMETROSSIS Par
  WHERE EscP.ClienteID = Par.ClienteInstitucion;

  SELECT  EscP.EscrituraPublic
  INTO  Cli_NumEscC
  FROM  ESCRITURAPUB EscP
  WHERE EscP.ClienteID  = Var_ClienteID
  AND   EscP.Esc_Tipo = 'C'
  LIMIT 1;

  SELECT  EscP.EscrituraPublic
  INTO  Cli_NumEscP
  FROM  ESCRITURAPUB EscP
  WHERE EscP.ClienteID  = Var_ClienteID
  AND   EscP.Esc_Tipo = 'P'
  LIMIT 1;

  SET NumEscPConstitutiva :=  IFNULL(NumEscPConstitutiva,Cadena_Default);
  SET NombreNotarioEscPConstitutiva :=  IFNULL(NombreNotarioEscPConstitutiva,Cadena_Default);
  SET Cli_NumEscC :=  IFNULL(Cli_NumEscC,Cadena_Default);
  SET Cli_NumEscP :=  IFNULL(Cli_NumEscP,Cadena_Default);

  SELECT
    Var_DireccSucursal, Var_ClienteID,    NombreCompleto,   Var_Calle,    Var_NumCasa,
    Var_Colonia,    Var_NombreMuni,   Var_NombreEstado, Var_CP,     Var_CAT,
    Var_MontoCred,    Sol_Proyecto,   ProCre_Monto,   Cre_FechaVenc,  Var_Plazo,
    Var_DesFrec,    Cre_TasaFija,   Var_FactorMora,   Cre_DescPag,  AmortCre_FechExig,
    Var_NumRECA,    Var_RepresentanteLegal,
                        Var_NomInstit,    Var_PorcGarLiq, Var_DirFiscalInstitucion,
    Var_NombreRepresentante,
              Var_ProductoCre,  Cre_FechaDesem,   Var_FechaSistematxt,
                                          Var_MontoCredito,
    Var_PlazoaMeses,  Cre_Perio,      NumEscPConstitutiva,NombreNotarioEscPConstitutiva,
                                          Cli_TipoPersona,
    Cli_NumEscC,    Cli_NumEscP,    Var_RFCOficial;
END IF;


-- SECCION PARA FEMAZA
IF (Par_TipoReporte = Tipo_AnexoFEMAZA) THEN
    -- Seccion para obtener los datos del banco
    SET Var_NombreCorto = '';
    SET Var_CtaSucursal := '';
    SET Var_cueClabe := '';

    SELECT INST.NombreCorto,CONCAT(CTASTESO.NumCtaInstit, ' SUC. ', CTASTESO.SucursalInstit) AS CtaSucursal, CTASTESO.CueClave
    INTO  Var_NombreCorto, Var_CtaSucursal, Var_CueClabe
    FROM CUENTASAHOTESO AS CTASTESO INNER JOIN INSTITUCIONES AS INST ON CTASTESO.InstitucionID = INST.InstitucionID
    WHERE CTASTESO.Sucursal = (SELECT CRED.Sucursal
                                                                FROM CREDITOS AS CRED
                                                                WHERE CRED.CreditoID = Par_CreditoID)  LIMIT 1;
    -- Termina seccion datos banco

    -- SECCION PARA OBTENER DATOS DE LA ESCRITURA
    SELECT RPP.EscrituraPublic, RPP.LocalidadRegPub, MPIOSRPP.Nombre AS NomLocRP, RPP.FolioRegPub, RPP.EstadoIDReg, RPP.FechaRegPub
    INTO Var_EscrituraRPP, Var_LocalidadRegPub, Var_NomLocRP, Var_FolioRegPub, Var_EstadoIDReg, Var_FechaRegPub
    FROM ESCRITURAPUB AS RPP
        INNER JOIN MUNICIPIOSREPUB AS MPIOSRPP ON (MPIOSRPP.MunicipioID = RPP.LocalidadRegPub AND MPIOSRPP.EstadoID = RPP.EstadoIDReg)
    WHERE RPP.EmpresaID = Par_EmpresaID AND RPP.Esc_Tipo = 'C'  LIMIT 1;

    SELECT ESC.FechaEsc, ESC.EscrituraPublic, ESC.VolumenEsc, ESC.Notaria, ESC.LocalidadEsc, MPIOSESC.Nombre AS NomLocEsc,
        ESC.EstadoIDEsc, EDOESC.Nombre AS NomEstEsc, DES.Titular AS NomNotario
    INTO Var_FechaEsc, Var_EscrituraPublic, Var_VolumenEsc, Var_Notaria, Var_LocalidadEsc, Var_NomLocEsc,
        Var_EstadoIDEsc, Var_NomEstEsc, Var_NomNotario
    FROM ESCRITURAPUB AS ESC
        INNER JOIN MUNICIPIOSREPUB AS MPIOSESC ON (MPIOSESC.MunicipioID = ESC.LocalidadEsc AND MPIOSESC.EstadoID = ESC.EstadoIDReg)
        INNER JOIN ESTADOSREPUB AS EDOESC ON (EDOESC.EstadoID = ESC.EstadoIDEsc)
        INNER JOIN NOTARIAS AS DES ON DES.NotariaID = ESC.Notaria
    WHERE ESC.EmpresaID = Par_EmpresaID AND ESC.Esc_Tipo = 'C'  LIMIT 1;

    SET Var_TxtNotaria1 := TRIM(FUNCIONNUMEROSLETRAS(Var_EscrituraRPP));
    SET Var_TxtNotaria2 := TRIM(FUNCIONNUMEROSLETRAS(Var_EscrituraPublic));

    SET Var_TxtFecha1 := FNFECHATEXTO(Var_FechaRegPub);
    SET Var_TxtFecha2 := FNFECHATEXTO(Var_FechaEsc);

    -- TERMINA SECCION PARA OBTENER DATOS DE LA ESCRITURA

    SELECT Edo.Nombre ,Mu.Nombre INTO Var_NombreEstadom,Var_NombreMuni
  FROM  SUCURSALES Suc,
    ESTADOSREPUB Edo,
    USUARIOS  Usu,
                MUNICIPIOSREPUB Mu
  WHERE UsuarioID   =Aud_Usuario
    AND Edo.EstadoID  = Suc.EstadoID
    AND Usu.SucursalUsuario= Suc.SucursalID
          AND Mu.MunicipioID=Suc.MunicipioID
          AND Edo.EstadoID = Mu.EstadoID;

  SET Var_TasaAnual   := Entero_Cero;
  SET Var_TasaMens    := Entero_Cero;
  SET Var_TasaFlat    := Entero_Cero;
  SET Var_MontoSeguro := Entero_Cero;
  SET Var_PorcCobert  := Entero_Cero;

  SELECT  Cre.TasaFija,     Cre.CreditoID,      Cre.NumAmortizacion,  Cre.MontoCredito,
    Cre.PeriodicidadInt,  Cre.FrecuenciaInt,    Cre.FrecuenciaCap,    Cre.MontoSeguroVida,
    Cre.FactorMora,Cre.TipCobComMorato
  INTO  Var_TasaAnual,    Var_CreditoID,    Var_NumAmorti,      Var_MontoCred,
    Var_Periodo,        Var_FrecuenciaInt,  Var_Frecuencia,   Var_MontoSeguro,
    Var_TasaMoraAnual,Var_TipCobComMorato
  FROM CREDITOS Cre
  INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
  WHERE Cre.CreditoID=Par_CreditoID;

  SET Var_TasaAnual   := IFNULL(Var_TasaAnual, Entero_Cero);
  SET Var_CreditoID   := IFNULL(Var_CreditoID, Entero_Cero);
  SET Var_NumAmorti   := IFNULL(Var_NumAmorti, Entero_Cero);
  SET Var_TasaMens    := ROUND(Var_TasaAnual / 12, 4);

  IF (Var_TipCobComMorato='T') THEN
    SET Var_TasaMoratoria   := ROUND(Var_TasaMoraAnual, 2);
  ELSE
    SET Var_TasaMoratoria   := ROUND( Var_TasaAnual * Var_TasaMoraAnual, 2);
  END IF;



  SELECT  SUM(Amo.Interes) INTO Var_TotInteres
        FROM AMORTICREDITO Amo
        WHERE Amo.CreditoID = Par_CreditoID;

  SET Var_TotInteres  := IFNULL(Var_TotInteres, Entero_Cero);
  SET Var_TasaFlat    := ( ( (Var_TotInteres / Var_NumAmorti) / Var_MontoCred ) /
                                Var_Periodo ) * 30 * 100;
  SET Var_TasaFlat    := ROUND(Var_TasaFlat, 4);

  SELECT Cre.ValorCAT,  ROUND(Cre.PorcGarLiq,2), Pro.FactorRiesgoSeguro, Pro.RegistroRECA, Cre.FechaVencimien,
    Cli.NombreCompleto ,Pro.Descripcion,Pro.CobraMora,
    Pro.FactorMora,Pro.RequiereGarantia,Cli.ClienteID,Dir.DireccionCompleta,
    Cre.CreditoID,Gar.TipoGarantiaID, Gar.TipoDocumentoID
  INTO Var_CAT,      Var_PorcGarLiq,  Var_FacRiesgo,  Var_NumRECA,    Var_FechaVenc,
     Var_NomRepres,Var_DescProducto,Var_CobraMora,  Var_FactorMora, Var_ReqGarantia,
     Var_Cliente,  Var_DireccionCompleta, Var_Credito, Var_TipoGarantia, Var_TipoDocumento
  FROM CREDITOS Cre
        INNER JOIN PRODUCTOSCREDITO Pro ON Pro.ProducCreditoID = Cre.ProductoCreditoID
        INNER JOIN CLIENTES Cli ON Cli.ClienteID = Cre.ClienteID
        INNER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cre.ClienteID
        LEFT JOIN ASIGNAGARANTIAS Asi ON Asi.SolicitudCreditoID = Cre.SolicitudCreditoID
        LEFT JOIN GARANTIAS Gar ON Gar.GarantiaID = Asi.GarantiaID
  WHERE Cre.CreditoID =Var_CreditoID
    AND Dir.Oficial=DirOficial
    LIMIT 1;

  DROP TABLE IF EXISTS  TMPGARANTIA;

  CREATE TEMPORARY TABLE TMPGARANTIA(
  Folio               INT AUTO_INCREMENT,
  Tmp_Garantia        INT(11),
  Tmp_TipoDocumento   INT(11),
  Tmp_Monto           DECIMAL(14,2),
  Tmp_Valor           DECIMAL(14,2),
  PRIMARY KEY (Folio)
  );

  OPEN CURSORGARANTIAS;
  BEGIN
    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
    LOOP
      FETCH CURSORGARANTIAS INTO Var_TipoGarantia, Var_TipoDocumento, Var_MontoAsignado, Var_ValorComercial;
      INSERT INTO TMPGARANTIA (Tmp_Garantia,Tmp_TipoDocumento,Tmp_Monto,Tmp_Valor)
      VALUES (Var_TipoGarantia, Var_TipoDocumento, Var_MontoAsignado, Var_ValorComercial);
    END LOOP;
  END;
  CLOSE CURSORGARANTIAS;

  SELECT  MAX(Tmp_Monto), MAX(Tmp_Valor)
  INTO Var_MontoMax, Var_ValorMax
  FROM TMPGARANTIA;

  IF EXISTS (SELECT MAX(Folio) FROM TMPGARANTIA WHERE Tmp_Monto=Var_MontoMax HAVING COUNT(*) > 1 )THEN
     IF EXISTS(SELECT MAX(Folio) FROM TMPGARANTIA WHERE Tmp_Valor=Var_ValorMax HAVING COUNT(*) > 1)THEN
      IF EXISTS (SELECT MAX(Folio) FROM TMPGARANTIA WHERE Tmp_TipoDocumento=TipoDocumConstancia)THEN
        SELECT   Tmp_Garantia,  Tmp_TipoDocumento, Tmp_Monto, Tmp_Valor
        INTO Var_TipoGar,Var_TipoDoc, Var_Monto, Var_Comercial
        FROM TMPGARANTIA
        WHERE Tmp_TipoDocumento=TipoDocumConstancia LIMIT 1;
      END IF;
      IF EXISTS (SELECT MAX(Folio) FROM TMPGARANTIA WHERE Tmp_TipoDocumento=TipoDocumActa)THEN
        SELECT   Tmp_Garantia,  Tmp_TipoDocumento, Tmp_Monto, Tmp_Valor
        INTO Var_TipoGar,Var_TipoDoc, Var_Monto, Var_Comercial
        FROM TMPGARANTIA
        WHERE Tmp_TipoDocumento=TipoDocumActa LIMIT 1;
      END IF;
      IF EXISTS (SELECT MAX(Folio) FROM TMPGARANTIA WHERE Tmp_TipoDocumento=TipoDocumTestimonio)THEN
        SELECT   Tmp_Garantia,  Tmp_TipoDocumento, Tmp_Monto, Tmp_Valor
        INTO Var_TipoGar,Var_TipoDoc, Var_Monto, Var_Comercial
        FROM TMPGARANTIA
        WHERE Tmp_TipoDocumento=TipoDocumTestimonio LIMIT 1;
      END IF;
      IF (IFNULL(Var_TipoGar,Entero_Cero)=Entero_Cero AND IFNULL(Var_TipoDoc,Entero_Cero)=Entero_Cero)THEN
        SELECT   Tmp_Garantia,  Tmp_TipoDocumento,Tmp_Monto, Tmp_Valor
        INTO Var_TipoGar,Var_TipoDoc, Var_Monto, Var_Comercial
        FROM TMPGARANTIA LIMIT 1;
      END IF;

    ELSE
      SELECT   Tmp_Garantia,  Tmp_TipoDocumento, Tmp_Monto, Tmp_Valor
      INTO Var_TipoGar,Var_TipoDoc, Var_Monto, Var_Comercial
      FROM TMPGARANTIA
      WHERE Tmp_Valor=Var_ValorMax;
    END IF;
  ELSE
    SELECT   Tmp_Garantia,  Tmp_TipoDocumento, Tmp_Monto, Tmp_Valor
    INTO     Var_TipoGar,Var_TipoDoc, Var_Monto, Var_Comercial
    FROM TMPGARANTIA
    WHERE Tmp_Monto=Var_MontoMax;
  END IF;

  SET Var_CAT  := IFNULL(Var_CAT, Entero_Cero);
  SET Var_PorcGarLiq  := IFNULL(Var_PorcGarLiq, Entero_Cero);
  SET Var_FacRiesgo  := IFNULL(Var_FacRiesgo, Entero_Cero);

  SELECT TipoPagoCapital INTO Var_TipoPagoCap
  FROM CREDITOS
  WHERE CreditoID=Par_CreditoID;

  IF(Var_TipoPagoCap=Tipo_PagoLibre OR Var_FrecuenciaInt != Var_Frecuencia)THEN
    SET Var_DesFrecLet = TxtMixtas;
  ELSE
    SELECT CASE
                  WHEN Var_Frecuencia =FrecSemanal    THEN TxtSemanal
                  WHEN Var_Frecuencia =FrecCatorcenal   THEN TxtCatorcenal
                  WHEN Var_Frecuencia =FrecQuincenal    THEN TxtQuincenal
                  WHEN Var_Frecuencia =FrecMensual    THEN TxtMensual
                  WHEN Var_Frecuencia =FrecPeriodica    THEN TxtPeriodica
                  WHEN Var_Frecuencia =FrecBimestral    THEN TxtBimestral
                  WHEN Var_Frecuencia =FrecTrimestral   THEN TxtTrimestral
                  WHEN Var_Frecuencia =FrecTetramestral THEN TxtTetramestral
                  WHEN Var_Frecuencia =FrecSemestral    THEN TxtSemestral
                  WHEN Var_Frecuencia =FrecAnual      THEN TxtAnual
          WHEN Var_Frecuencia =FrecDecenal    THEN TxtDecenal
      END INTO Var_DesFrec;

    SET Var_DesFrec     := IFNULL(Var_DesFrec, Cadena_Vacia);

    SELECT  CONCAT(CONVERT(Var_NumAmorti, CHAR), ' ' ,
    CASE
                  WHEN Var_Frecuencia =FrecSemanal    THEN TxtSemanas
                  WHEN Var_Frecuencia =FrecCatorcenal   THEN TxtCatorcenas
                  WHEN Var_Frecuencia =FrecQuincenal    THEN TxtQuincenas
                  WHEN Var_Frecuencia =FrecMensual    THEN TxtMeses
                  WHEN Var_Frecuencia =FrecPeriodica    THEN TxtPeriodos
                  WHEN Var_Frecuencia =FrecBimestral    THEN TxtBimestres
                  WHEN Var_Frecuencia =FrecTrimestral   THEN TxtTrimestres
                  WHEN Var_Frecuencia =FrecTetramestral   THEN TxtTetramestres
                  WHEN Var_Frecuencia =FrecSemestral    THEN TxtSemestres
                  WHEN Var_Frecuencia =FrecAnual      THEN TxtAnios
          WHEN Var_Frecuencia =FrecUnico      THEN TxtUnico
          WHEN Var_Frecuencia =FrecDecenal    THEN TxtDecenales


    END ) INTO Var_Plazo;

    SELECT  CASE
                  WHEN Var_Frecuencia =FrecSemanal THEN TxtSemanales
                  WHEN Var_Frecuencia =FrecCatorcenal THEN TxtCatorcenales
                  WHEN Var_Frecuencia =FrecQuincenal THEN TxtQuincenales
                  WHEN Var_Frecuencia =FrecMensual THEN TxtMensuales
                  WHEN Var_Frecuencia =FrecPeriodica THEN TxtPeriodos
                  WHEN Var_Frecuencia =FrecBimestral THEN TxtBimestrales
                  WHEN Var_Frecuencia =FrecTrimestral THEN TxtTrimestrales
                  WHEN Var_Frecuencia =FrecTetramestral THEN TxtTetramestrales
                  WHEN Var_Frecuencia =FrecSemestral THEN TxtSemestrales
                  WHEN Var_Frecuencia =FrecAnual THEN TxtAnuales
          WHEN Var_Frecuencia =FrecDecenal THEN TxtDecenales
          WHEN Var_Frecuencia =FrecLibre THEN TxtMixtas

              END INTO Var_DesFrecLet;
  END IF;

  SELECT COUNT(CreditoID) INTO Var_NumCuotas
  FROM AMORTICREDITO Amo
  WHERE Amo.CreditoID = Par_CreditoID;

  SET Var_MontoSeguro := IFNULL(Var_MontoSeguro, Entero_Cero);
  SET Var_MontoGarLiq := ROUND(Var_MontoCred * Var_PorcGarLiq / 100, 2);
  SET Var_MonGarLiq     := FORMAT(Var_MontoGarLiq,2);

  SELECT SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres) INTO Var_TotPagar
  FROM CREDITOS Cre, AMORTICREDITO Amo
        WHERE Cre.CreditoID   = Par_CreditoID
    AND Amo.CreditoID = Cre.CreditoID;

  SET Var_TotPagar    := IFNULL(Var_TotPagar, Entero_Cero);

  SELECT FUNCIONNUMLETRAS(Var_TotPagar) INTO Var_TotPagLetra;
  SELECT FUNCIONNUMLETRAS(Var_MontoCred) INTO Var_MtoLetra;
  SELECT FUNCIONNUMLETRAS(Var_MontoGarLiq) INTO Var_GarantiaLetra;

  SET Var_PorcCobert  :=  ROUND((Var_FacRiesgo / 7 * Var_Periodo * 1000), 4);
  SELECT  CASE
        WHEN Var_Frecuencia =FrecSemanal    THEN TxtSemana
                WHEN Var_Frecuencia =FrecCatorcenal   THEN TxtCatorcena
                WHEN Var_Frecuencia =FrecQuincenal    THEN TxtQuincena
                WHEN Var_Frecuencia =FrecMensual    THEN TxtMes
                WHEN Var_Frecuencia =FrecPeriodica    THEN TxtPeriodo
                WHEN Var_Frecuencia =FrecBimestral    THEN TxtBimestre
                WHEN Var_Frecuencia =FrecTrimestral   THEN TxtTrimestre
                WHEN Var_Frecuencia =FrecTetramestral   THEN TxtTetramestre
                WHEN Var_Frecuencia =FrecSemestral    THEN TxtSemestre
                WHEN Var_Frecuencia =FrecAnual      THEN TxtAnio
        WHEN Var_Frecuencia =FrecDecenal    THEN TxtDecena

  END  INTO Var_FrecSeguro;

  SELECT DAY(Var_FechaVenc) ,   YEAR(Var_FechaVenc) , CASE
    WHEN MONTH(Var_FechaVenc) = mes1  THEN TxtEnero
    WHEN MONTH(Var_FechaVenc) = mes2  THEN TxtFebrero
    WHEN MONTH(Var_FechaVenc) = mes3  THEN TxtMarzo
    WHEN MONTH(Var_FechaVenc) = mes4  THEN TxtAbril
    WHEN MONTH(Var_FechaVenc) = mes5  THEN TxtMayo
    WHEN MONTH(Var_FechaVenc) = mes6  THEN TxtJunio
    WHEN MONTH(Var_FechaVenc) = mes7  THEN TxtJulio
    WHEN MONTH(Var_FechaVenc) = mes8  THEN TxtAgosto
    WHEN MONTH(Var_FechaVenc) = mes9  THEN TxtSeptiembre
    WHEN MONTH(Var_FechaVenc) = mes10 THEN TxtOctubre
    WHEN MONTH(Var_FechaVenc) = mes11 THEN TxtNoviembre
    WHEN MONTH(Var_FechaVenc) = mes12 THEN TxtDiciembre END
  INTO  Var_DiaVencimiento, Var_AnioVencimiento,  Var_MesVencimiento;

  SET Var_MontoCredito := CONCAT('$ ', FORMAT(Var_MontoCred, 2), ', (', Var_MtoLetra, ' M.N.)');
  SET MontoTotPagar := CONCAT('$ ', FORMAT(Var_TotPagar, 2), ', (', Var_TotPagLetra, ' M.N.)');

  SELECT Sol.Proyecto, Cre.SolicitudCreditoID INTO Var_DestinoCredito, Var_SolicitudCredito
  FROM SOLICITUDCREDITO Sol,
    CREDITOS Cre
  WHERE Cre.CreditoID=Par_CreditoID
    AND Cre.SolicitudCreditoID = Sol.SolicitudCreditoID;

  SELECT MontoPolizaSegA INTO Var_MontoPolizaSegA
  FROM PARAMETROSSIS
  WHERE EmpresaID=Par_EmpresaID;

  SET Var_SolicitudCredito   := IFNULL(Var_SolicitudCredito, Entero_Cero);

  SELECT FUNCIONNUMLETRAS(Var_MontoPolizaSegA) INTO Var_MtoLetraSeguro;

  SET Var_MontoSeguroApoyo := CONCAT('$ ', FORMAT(Var_MontoPolizaSegA, 2), ' (', Var_MtoLetraSeguro, ' M.N.)');

    -- Se CAMBIA LA CONSULTA PARA OBTENER EL CORREO ELECTRONICO
    SELECT  Par.TelefonoInterior, Ins.DirFiscal, Edo.CorreoUEAU
  INTO  Var_TelInst, Var_DirFis, Var_CorreoUEAU
  FROM PARAMETROSSIS Par
        INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID
        INNER JOIN EDOCTAPARAMS Edo ON Edo.EmpresaID = Par.EmpresaID;

  SET Var_TelInst:= IFNULL(Var_TelInst,'');
  SET Var_DirFis := IFNULL(Var_DirFis,'');
    SET Var_CorreoUEAU := IFNULL(Var_CorreoUEAU,'');

  SET  Var_TipoGar :=IFNULL(Var_TipoGar,0);
  SET  Var_TipoDoc :=IFNULL(Var_TipoDoc,0);

  SELECT  Var_Plazo,          Var_FechaVenc,        Var_DesFrec,          Var_TasaAnual,
    Var_TasaMens,       Var_TasaFlat,         Var_MontoSeguro,      Var_PorcCobert,
    Var_CAT,              Var_PorcGarLiq,     Var_MonGarLiq,        Var_NomRepres,
    Var_FrecSeguro,       Var_NumRECA,        Var_DiaVencimiento,   Var_AnioVencimiento,
    Var_MesVencimiento,   Var_GarantiaLetra,    Var_MontoCredito,     Var_MtoLetra,
    Var_NumAmorti,      Var_DesFrecLet,       MontoTotPagar,        Var_TotPagLetra,
    Var_NombreEstadom,    Var_NombreMuni,       Var_DescProducto,     Var_CobraMora,
    Var_FactorMora,       Var_ReqGarantia,    Var_NumCuotas,        Var_Cliente,
    Var_DireccionCompleta,  Var_Credito,      Var_MontoGarLiq,
    Var_DestinoCredito,   Var_SolicitudCredito,   Var_MontoPolizaSegA,  Var_MontoSeguroApoyo,
    Var_TasaMoratoria,    Var_TasaMensMora,     Var_TipoGar,      Var_TipoDoc,
    Var_Monto,        Var_Comercial, Var_TelInst, Var_DirFis,
        Var_NombreCorto, Var_CtaSucursal, Var_CueClabe, Var_EscrituraRPP,
        Var_LocalidadRegPub, Var_NomLocRP, Var_FolioRegPub, Var_EstadoIDReg, Var_FechaRegPub,
        Var_FechaEsc, Var_EscrituraPublic, Var_VolumenEsc, Var_NomNotario, Var_Notaria, Var_LocalidadEsc,
        Var_NomLocEsc, Var_EstadoIDEsc, Var_NomEstEsc, Var_TxtNotaria1, Var_TxtNotaria2, Var_TxtFecha1, Var_TxtFecha2, Var_CorreoUEAU;

  DROP TABLE IF EXISTS TMPGARANTIA;
END IF;
-- TERMINA SECCION FEMAZA


-- Tipo Contrato finsocial
IF (Par_TipoReporte = Tipo_ContratoFinSocial) THEN

  SELECT  CONCAT(UCASE(SUBSTRING(Edo.Nombre,1,1)),LCASE (SUBSTRING(Edo.Nombre,2))),
      CONCAT(UCASE(SUBSTRING(Mu.Nombre,1,1)),LCASE (SUBSTRING(Mu.Nombre,2)))
    INTO Var_FinSoNombreEstadom,Var_FinSoNombreMuni
      FROM  SUCURSALES Suc,
          ESTADOSREPUB Edo,
          USUARIOS  Usu,
          MUNICIPIOSREPUB Mu
        WHERE UsuarioID =Aud_Usuario
          AND Edo.EstadoID  = Suc.EstadoID
          AND Usu.SucursalUsuario= Suc.SucursalID
          AND Mu.MunicipioID=Suc.MunicipioID
          AND Edo.EstadoID = Mu.EstadoID;

    SET Var_TasaAnualFinso   := Entero_Cero;
  SET Var_ComisionLiqAntc:=Entero_Cero;

    SELECT  TasaFija, CreditoID,  NumAmortizacion,  MontoCredito,
      FrecuenciaCap,  FechaVencimien
    INTO  Var_TasaAnualFinso, Var_FinSoCreditoID, Var_FinSoNumAmorti,      Var_FinSoMontoCred,
        Var_FinSoFrecuencia,    Var_FinSoFechaVenc
      FROM CREDITOS
        WHERE CreditoID=Par_CreditoID;


    SET Var_TasaAnualFinso   := IFNULL(Var_TasaAnualFinso, Entero_Cero);
    SET Var_FinSoCreditoID   := IFNULL(Var_FinSoCreditoID, Entero_Cero);
    SET Var_FinSoNumAmorti   := IFNULL(Var_FinSoNumAmorti, Entero_Cero);
    SET CantLetra   :=  FUNCIONNUMLETRAS(Var_FinSoMontoCred);
  SET TasaLetra   :=  FUNCIONNUMEROSLETRAS(Var_TasaAnualFinso);

    SELECT  CONCAT(CONVERT(Var_FinSoNumAmorti, CHAR), ' ' ,
            CASE
                WHEN Var_FinSoFrecuencia =TxtSemanales THEN TxtSemanas
                WHEN Var_FinSoFrecuencia =FrecCatorcenal THEN TxtCatorcenas
                WHEN Var_FinSoFrecuencia =FrecQuincenal THEN TxtQuincenas
                WHEN Var_FinSoFrecuencia =FrecMensual THEN TxtMeses
                WHEN Var_FinSoFrecuencia =FrecPeriodica THEN TxtPeriodos
                WHEN Var_FinSoFrecuencia =FrecBimestral THEN TxtBimestres
                WHEN Var_FinSoFrecuencia =FrecTrimestral THEN TxtTrimestres
                WHEN Var_FinSoFrecuencia =FrecTetramestral THEN TxtTetramestres
                WHEN Var_FinSoFrecuencia =FrecSemestral THEN TxtSemestres
                WHEN Var_FinSoFrecuencia =FrecAnual THEN TxtAnios
                WHEN Var_FinSoFrecuencia =FrecUnico THEN TxtUnico


            END ) INTO Var_Plazo;

    SELECT  Cre.ValorCAT,
      Pro.RegistroRECA,
            Pro.MontoComXapert,
      CONCAT(Cli.PrimerNombre,
                    (CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(' ', Cli.SegundoNombre)
                          ELSE Cadena_Vacia
                     END),
                   (CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN  CONCAT(' ', Cli.TercerNombre)
                         ELSE Cadena_Vacia
                    END), ' ',  IFNULL(Cli.ApellidoPaterno, Cadena_Vacia), ' ', IFNULL(Cli.ApellidoMaterno, Cadena_Vacia)),
        Cre.CreditoID,

        Pro.Descripcion,  Cre.FechaMinistrado,  Cre.TipCobComMorato,  Cre.FactorMora,       Pro.TipoComXapert
    INTO Var_FinSoCATLR,
       Var_FinSoNumRECA,
             Var_FinSoComisionApertura,
       Var_FinSoNomRepres,
             Var_FinSoCreditoID,

             Var_FinSoDescProducto,   Var_FinSoFechaDesem,  Var_FinSoTipoCobMora,   Var_FinSoFactorMora,Var_FinSoComXapert

      FROM CREDITOS Cre,
         PRODUCTOSCREDITO Pro,
         CLIENTES Cli
        WHERE Cre.CreditoID = Var_FinSoCreditoID
          AND Cre.ProductoCreditoID  = Pro.ProducCreditoID
          AND Cre.ClienteID = Cli.ClienteID;

    SET Var_FinSoCATLR  := IFNULL(Var_FinSoCATLR, Entero_Cero);
    SET Var_FinSoFechaDesem:= IFNULL(Var_FinSoFechaDesem,Fecha_Vacia);
    SET Var_FechaSistema:=IFNULL(Var_FechaSistema,Fecha_Vacia);
    SET Var_FinSoDescProducto:= IFNULL(Var_FinSoDescProducto,Cadena_Vacia );
    SET Var_FinSoFactorMora:=IFNULL(Var_FinSoFactorMora,Entero_Cero) ;
    SET TasaMoraLetra :=  FUNCIONNUMEROSLETRAS(Var_FinSoFactorMora);

   SELECT ComisionLiqAntici,TipComLiqAntici
    INTO Var_FinSoComisionLiqAntc,Var_FinSoTipoComAnt
    FROM CREDITOS Cli, ESQUEMACOMPRECRE Esq
      WHERE Cli.ProductoCreditoID=Esq.ProductoCreditoID
      AND CreditoID = Var_FinSoCreditoID
      AND CobraComLiqAntici=Constante_SI;

    SELECT SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres)
    INTO Var_FinSoTotPagar
      FROM CREDITOS Cre,
        AMORTICREDITO Amo
        WHERE Cre.CreditoID   = Par_CreditoID
          AND Amo.CreditoID = Cre.CreditoID;

    SET Var_FinSoTotPagar       := IFNULL(Var_FinSoTotPagar, Entero_Cero);
  SET Var_FinSoComisionApertura   := IFNULL(Var_FinSoComisionApertura, Entero_Cero);
    SET Var_FinSoTipoComAnt := IFNULL(Var_FinSoTipoComAnt, Cadena_Vacia);
   SELECT CONCAT(DAY(Var_FinSoFechaVenc) ,' de ', CASE
  WHEN MONTH(Var_FinSoFechaVenc) = mes1  THEN TxtEnero
  WHEN MONTH(Var_FinSoFechaVenc) = mes2  THEN TxtFebrero
  WHEN MONTH(Var_FinSoFechaVenc) = mes3  THEN TxtMarzo
  WHEN MONTH(Var_FinSoFechaVenc) = mes4  THEN TxtAbril
  WHEN MONTH(Var_FinSoFechaVenc) = mes5  THEN TxtMayo
  WHEN MONTH(Var_FinSoFechaVenc) = mes6  THEN TxtJunio
  WHEN MONTH(Var_FinSoFechaVenc) = mes7  THEN TxtJulio
  WHEN MONTH(Var_FinSoFechaVenc) = mes8  THEN TxtAgosto
  WHEN MONTH(Var_FinSoFechaVenc) = mes9  THEN TxtSeptiembre
  WHEN MONTH(Var_FinSoFechaVenc) = mes10 THEN TxtOctubre
  WHEN MONTH(Var_FinSoFechaVenc) = mes11 THEN TxtNoviembre
  WHEN MONTH(Var_FinSoFechaVenc) = mes12 THEN TxtDiciembre END,' de ',YEAR(Var_FinSoFechaVenc))

  INTO FechaLetra;

  SELECT CONCAT(DAY(Var_FechaSistema) ,' de ', CASE
  WHEN MONTH(Var_FechaSistema) = mes1  THEN TxtEnero
  WHEN MONTH(Var_FechaSistema) = mes2  THEN TxtFebrero
  WHEN MONTH(Var_FechaSistema) = mes3  THEN TxtMarzo
  WHEN MONTH(Var_FechaSistema) = mes4  THEN TxtAbril
  WHEN MONTH(Var_FechaSistema) = mes5  THEN TxtMayo
  WHEN MONTH(Var_FechaSistema) = mes6  THEN TxtJunio
  WHEN MONTH(Var_FechaSistema) = mes7  THEN TxtJulio
  WHEN MONTH(Var_FechaSistema) = mes8  THEN TxtAgosto
  WHEN MONTH(Var_FechaSistema) = mes9  THEN TxtSeptiembre
  WHEN MONTH(Var_FechaSistema) = mes10 THEN TxtOctubre
  WHEN MONTH(Var_FechaSistema) = mes11 THEN TxtNoviembre
  WHEN MONTH(Var_FechaSistema) = mes12 THEN TxtDiciembre END,' de ',YEAR(Var_FechaSistema))

  INTO FechaSisLetra;

  IF Var_FinSoTipoCobMora=CobMoraNVeces THEN --  si cobra mora n veces
    SET Var_FinSoFactorMora :=Var_FinSoFactorMora * Var_TasaAnualFinso;
        SET TasaMoraLetra :=  FUNCIONNUMEROSLETRAS(Var_FinSoFactorMora);
  END  IF;

  SELECT  IFNULL(Var_TasaAnualFinso,Entero_Cero)  AS Var_TasaAnualFinso,
      IFNULL(Var_FinSoCreditoID,Entero_Cero) AS Var_CreditoID,
            IFNULL(Var_FinSoCATLR,Entero_Cero) AS Var_CATLR,
            IFNULL(Var_FinSoMontoCred,Entero_Cero)AS Var_MontoCred,
            IFNULL(Var_FinSoTotPagar,Entero_Cero)AS Var_TotPagar,

      IFNULL(Var_Plazo,Cadena_Vacia) AS Var_Plazo,
            Var_FinSoFechaVenc AS Var_FechaVenc,
            IFNULL(Var_FinSoComisionApertura,Entero_Cero) AS Var_ComisionApertura,
            IFNULL(Var_FinSoComisionLiqAntc,Entero_Cero) AS Var_ComisionLiqAntc,
            IFNULL(Var_FinSoNumRECA,Cadena_Vacia) AS Var_NumRECA,

            IFNULL(Var_FinSoNomRepres,Cadena_Vacia) AS Var_NomRepres,
            IFNULL(Var_FinSoNombreEstadom,Cadena_Vacia) AS Var_NombreEstadom,
            IFNULL(Var_FinSoNombreMuni,Cadena_Vacia) AS Var_NombreMuni,
            IFNULL(Var_FinSoDescProducto,Cadena_Vacia) AS Var_DescProducto,
            IFNULL(Var_FinSoFechaDesem,Cadena_Vacia) AS Var_FechaDesem,

            IFNULL(CantLetra,Cadena_Vacia) AS CantLetra,
      IFNULL(FechaLetra,Cadena_Vacia) AS FechaLetra,
            IFNULL(TasaLetra,Cadena_Vacia)AS TasaLetra,
            IFNULL(FechaSisLetra,Cadena_Vacia) AS FechaSisLetra,
            Var_FinSoTipoComAnt,
            Var_FinSoFactorMora,
            TasaMoraLetra,
            IFNULL(Var_FinSoComXapert,Cadena_Vacia) AS Var_FinSoComXapert;

END IF;

-- Tipo avales finsocial
IF (Par_TipoReporte = Tipo_AvalesFinSocial) THEN

  SELECT
    COUNT(*) INTO NumAvales
    FROM AVALES  A,AVALESPORSOLICI Asol ,CREDITOS Cre
      WHERE  A.AvalID=Asol.AvalID
        AND  Asol.SolicitudCreditoID=Cre.SolicitudCreditoID
        AND  Cre.CreditoID=Par_CreditoID;

  SET  NumAvales :=IFNULL(NumAvales,Entero_Cero);
  IF NumAvales=Entero_Cero  THEN
    SELECT Cadena_Vacia AS nomAval;
  ELSE
    SELECT
      CONCAT(A.PrimerNombre,
      (CASE WHEN IFNULL(A.SegundoNombre, Cadena_Vacia)!=Cadena_Vacia THEN CONCAT(' ',A.SegundoNombre) ELSE ' ' END ),
      (CASE WHEN IFNULL(A.TercerNombre, Cadena_Vacia)!=Cadena_Vacia THEN CONCAT(' ',A.TercerNombre) ELSE ' ' END ),
      (CASE WHEN IFNULL(A.ApellidoPaterno, Cadena_Vacia)!=Cadena_Vacia THEN CONCAT(' ',A.ApellidoPaterno) ELSE ' ' END ),
      (CASE WHEN IFNULL(A.ApellidoMaterno, Cadena_Vacia)!=Cadena_Vacia THEN CONCAT(' ',A.TercerNombre)  ELSE ' ' END )
      )AS nomAval
      FROM AVALES  A,AVALESPORSOLICI Asol ,CREDITOS Cre
        WHERE  A.AvalID=Asol.AvalID
          AND  Asol.SolicitudCreditoID=Cre.SolicitudCreditoID
          AND  Cre.CreditoID=Par_CreditoID;
  END IF;


END IF;

-- Seccion Alternativa 19

IF (Par_TipoReporte = TipoAlternativa) THEN
-- estado y municipio  de la sucursal
  SELECT  CONCAT(
        UCASE(SUBSTRING(Edo.Nombre,1,1)),
        LCASE(SUBSTRING(Edo.Nombre,2))
      ),
      CONCAT(
        UCASE(SUBSTRING(Mu.Nombre,1,1)),
        LCASE(SUBSTRING(Mu.Nombre,2))
        ),
      Suc.NombreSucurs
        INTO  Var_NombreEstadom,    Var_NombreMuni, Var_NombreSucursal
  FROM  SUCURSALES Suc,
      ESTADOSREPUB Edo,
      USUARIOS  Usu,
      MUNICIPIOSREPUB Mu
  WHERE UsuarioID     = Aud_Usuario
    AND Edo.EstadoID    = Suc.EstadoID
    AND Usu.SucursalUsuario = Suc.SucursalID
    AND Mu.MunicipioID    = Suc.MunicipioID
    AND Edo.EstadoID    = Mu.EstadoID LIMIT 1;

    -- Datos de la institucion
  SELECT
    ins.Nombre,       UPPER(CIENTOSATEXT(DATE_FORMAT(FechaSistema,'%y'))) ,
                    FORMATEAFECHACONTRATO(FechaSistema),NombreRepresentante,  ins.DirFiscal, ins.RFC
  INTO
    Var_NombreInstitucion, anioText,FechaSistematxt, Var_RepresentanteLegal, Var_DirFiscalInstitucion,Var_RFCInstitucion
  FROM
    INSTITUCIONES ins,
    PARAMETROSSIS par
  WHERE
    par.InstitucionID = ins.InstitucionID
  AND par.EmpresaID = 1  LIMIT 1;

    -- Datos de la Escritura Publica de la Institucion
    SELECT  Ep.EscrituraPublic, Ep.VolumenEsc,      Ep.FechaEsc,        Es.Nombre,          Ep.NomNotario,
            Ep.Notaria,         Ep.DirecNotaria,    Ep.RegistroPub,     Ep.FechaRegPub

    INTO    Var_EscriPubIns,    Var_VolEscIns,      Var_FechaEscIns,    Var_EstadoIDEscIns, Var_NomNotarioIns,
            Var_NotariaIns,     Var_DirecNotarIns,  Var_RegistroPubIns, Var_FechaRegPubIns
    FROM ESCRITURAPUB Ep
    INNER JOIN ESTADOSREPUB Es
    ON Es.EstadoID = Ep.EstadoIDEsc
    WHERE ClienteID = 1
    LIMIT 1;

-- Datos del credito
  SELECT
    Cre.MontoCuota,   Cre.TipoPagoCapital,  Cre.TasaFija,   Cre.NumAmortizacion,  Cre.MontoCredito,
    Cre.PeriodicidadInt,Cre.FrecuenciaInt,    Cre.FrecuenciaCap,  Cre.ValorCAT,     Cre.ProductoCreditoID,
        IFNULL(Cre.MontoCuota,Decimal_Cero),            cpl.Descripcion,    cpl.Dias,               Cre.ClienteID,
        SUM(Cre.MontoComApert),    IF(ForCobroComAper IN (CobroAnticipado),    SUM(MontoComApert + IVAComApertura), Entero_Cero),
        Cre.FechaVencimien,     cpl.Descripcion,        FORMATEAFECHACONTRATO(Cre.FechaMinistrado)

  INTO
    Var_MontoPago,    Var_TipoPagoCap,    Var_TasaAnual,    Var_NumAmorti,      Var_MontoCred,
    Var_Periodo,      Var_FrecuenciaInt,    Var_Frecuencia,   Var_CATLR,        Var_ProductoCre,
        Var_MontoCuota,     Var_Plazo,          var_DiasPlazo,    Var_ClienteID,    Var_ComisionApertura,
        Var_ComisionPrepago,Var_FechaLimPag,    PlazoCredito,     Var_FechaMinistrado
  FROM
    CREDITOS Cre LEFT OUTER JOIN CREDITOSPLAZOS cpl ON Cre.PlazoID = cpl.PlazoID
  WHERE
    CreditoID = Par_CreditoID LIMIT 1;

    -- Intereses Moratorios

     SELECT  Pro.FactorMora,     Cre.TipCobComMorato, Pro.ProducCreditoID
        INTO Var_FactorMora,     Var_TipoCobroMoratorio, Var_ProductoCredito
        FROM  PRODUCTOSCREDITO Pro, CREDITOS Cre
        WHERE ProducCreditoID = Cre.ProductoCreditoID
        AND   Cre.CreditoID = Par_CreditoID;


-- Destino del credito

 SELECT  Descripcion INTO Var_DestinoCredito
    FROM SOLICITUDCREDITO Sol,
      DESTINOSCREDITO Des,
      CREDITOS Cre
      WHERE Cre.CreditoID=Par_CreditoID
        AND Sol.DestinoCreID = Des.DestinoCreID
        AND Cre.SolicitudCreditoID = Sol.SolicitudCreditoID;
-- Producto de credito
        SELECT    Pro.RegistroRECA, Pro.MontoMinComFalPag, Pro.Descripcion, Pro.FactorMora, Pro.RequiereAvales,
                    Pro.Caracteristicas
          INTO      Var_NumRECA,  Var_ComisionCobranza, Var_DescProducto, Var_FactorMora, Var_RequiereAvales,
                    Var_CarProd
          FROM      PRODUCTOSCREDITO Pro
          WHERE     ProducCreditoID = Var_ProductoCre LIMIT 1;

-- Datos del cliente
  SELECT
    cli.NombreCompleto, cli.TipoPersona,  cli.Titulo,     cli.PrimerNombre,   cli.SegundoNombre,
    cli.TercerNombre, cli.ApellidoPaterno,cli.ApellidoMaterno,cli.NombreCompleto,
    CASE cli.Sexo
          WHEN Masculino THEN TxtMasculino
      ELSE TxtFemenino
    END,
    DATE_FORMAT(cli.FechaNacimiento, '%d/%m/%Y'), FORMATEAFECHACONTRATO(cli.FechaNacimiento),   IFNULL(edo.Nombre, NoAplica) ,
    CASE  pais.PaisID
      WHEN  700 THEN  'MEXICO'
          ELSE  IFNULL(pais.Nombre, Cadena_Vacia)
    END,
    CASE cli.Nacion
      WHEN 'N' THEN 'MEXICANA'
      WHEN 'E' THEN 'EXTRANJERA'
    END,
    cli.OcupacionID,    CONVERT(ocu.Descripcion, CHAR),   cli.Puesto,   abm.Descripcion,
    CASE cli.EstadoCivil
      WHEN  EstSoltero  THEN  TxtSoltero
      WHEN  EstCasBienSep  THEN  TxtCasBienSep
      WHEN  EstCasBienMan  THEN  TxtCasBienMan
      WHEN  EstcasBienManCap  THEN  TxtcasBienManCap
      WHEN  EstViudo  THEN  TxtViudo
      WHEN  EstDivorciado  THEN  TxtDivorciado
      WHEN  EstSeparado  THEN  TxtSeparado
      WHEN  EsteUnionLibre  THEN  TxteUnionLibre
      ELSE
       NoAplica
    END,

    CASE cli.TelefonoCelular
          WHEN Cadena_Vacia THEN cli.Telefono
      WHEN NULL THEN cli.Telefono
      ELSE cli.TelefonoCelular
    END,
    cli.Correo,   cli.CURP,
    CASE cli.TipoPersona
      WHEN 'M' THEN 'PERSONA MORAL'
      ELSE
      NoAplica
    END,
        cli.RazonSocial,    cli.RFCOficial,    CONCAT(TRIM(CONCAT(cli.PrimerNombre, ' ', cli.SegundoNombre, ' ', cli.TercerNombre)), ' ',
        TRIM(CONCAT(cli.ApellidoPaterno, ' ', cli.ApellidoMaterno)))
  INTO
    Var_NomRepres,  TipoPersona,      Titulo,       PrimerNombre,   SegundoNombre,
    TercerNombre, ApellidoPaterno,    ApellidoMaterno,  NombreCompleto, Sexo,
    FechaNacimiento,FechaNacimientoFtoTxt,  EstadoNacimiento, PaisNacimiento, Nacionalidad,
    OcupacionID,  Ocupacion,        Profesion,      ActividadEconomica,EstadoCivil,
    Telefono,   Correo,         CURP,       TipoEmpresa,RazonSocial,
    RFC,      Var_RepresentantePM
  FROM
    CLIENTES cli
    LEFT OUTER JOIN ESTADOSREPUB edo ON cli.EstadoID = edo.EstadoID
    LEFT OUTER JOIN PAISES pais ON cli.LugarNacimiento = pais.PaisID
    LEFT OUTER JOIN OCUPACIONES ocu ON cli.OcupacionID = ocu.OcupacionID
    LEFT OUTER JOIN ACTIVIDADESBMX abm ON cli.ActividadBancoMX = abm.ActividadBMXID
  WHERE
    ClienteID = Var_ClienteID LIMIT 1;

-- Grado de estudios
    SELECT ge.Descripcion
          INTO   GradoEstudios
          FROM   SOCIODEMOGRAL sc, CATGRADOESCOLAR ge
          WHERE  sc.GradoEscolarID = ge.GradoEscolarID
  AND ClienteID = Var_ClienteID LIMIT 1;

  -- Direccion cliente ***Consultar si es una direccion oficial
    SELECT  dc.DireccionCompleta,   dc.NumeroCasa,  dc.Calle,   dc.Colonia,         dc.CP,
    Loc.NombreLocalidad, Edo.Nombre
      INTO      Var_DireccionCompleta,  Var_NumCasa,    Var_Calle,  Var_NombreColonia,  Var_CP,
    Var_Ciudad, Var_NombreEstado
  FROM
    DIRECCLIENTE dc
  LEFT OUTER JOIN ESTADOSREPUB  Edo ON  Edo.EstadoID  = dc.EstadoID
  LEFT OUTER JOIN LOCALIDADREPUB  Loc ON  Loc.EstadoID  = dc.EstadoID
                    AND Loc.MunicipioID = dc.MunicipioID
                    AND Loc.LocalidadID = dc.LocalidadID
  WHERE
    ClienteID = Var_ClienteID LIMIT 1;


-- Direccion Fiscal si es una persona moral

SELECT dc.DireccionCompleta
 INTO Var_DirecClienteFiscal
  FROM
    DIRECCLIENTE dc
  LEFT OUTER JOIN ESTADOSREPUB  Edo ON  Edo.EstadoID  = dc.EstadoID
  LEFT OUTER JOIN LOCALIDADREPUB  Loc ON  Loc.EstadoID  = dc.EstadoID
                    AND Loc.MunicipioID = dc.MunicipioID
                    AND Loc.LocalidadID = dc.LocalidadID
      LEFT OUTER JOIN CLIENTES c ON c.ClienteID = dc.ClienteID
      WHERE c.ClienteID = Var_ClienteID AND c.TipoPersona = PersonaMoral AND dc.fiscal = DirOficial LIMIT 1;

-- Identificacion del cliente

 SELECT Cli.NombreCompleto, Cli.RFC, Dir.DireccionCompleta, Idf.NumIdentific
      INTO Var_NombreCompleto, Var_RFCOficial,Var_DirecCliente, Var_NumIdent
        FROM CLIENTES Cli
          LEFT JOIN DIRECCLIENTE Dir
          ON Cli.ClienteID = Dir.ClienteID AND Dir.Oficial = DireccionOficial
          LEFT JOIN IDENTIFICLIENTE Idf
          ON Idf.ClienteID = Cli.ClienteID AND Idf.TipoIdentiID = Con_TipoIdenti
  WHERE Cli.ClienteID = Var_ClienteID LIMIT 1;

    -- Garantias
    SELECT  Gar.Observaciones INTO Var_Garantias
      FROM      CREDITOS Cre
        INNER JOIN  PRODUCTOSCREDITO Pro  ON Pro.ProducCreditoID = Cre.ProductoCreditoID
            INNER JOIN  CLIENTES Cli      ON Cli.ClienteID = Cre.ClienteID
        INNER JOIN  DIRECCLIENTE Dir    ON Dir.ClienteID = Cre.ClienteID
        INNER JOIN  ASIGNAGARANTIAS Asi   ON Asi.SolicitudCreditoID = Cre.SolicitudCreditoID
        INNER JOIN  GARANTIAS Gar     ON Gar.GarantiaID = Asi.GarantiaID
      WHERE Cre.CreditoID =Par_CreditoID
        AND Dir.Oficial=DirOficialSI
        LIMIT 1;

 -- Datos de la escritura publica
  SELECT
    EscrituraPublic,        Mun.Nombre,           Edo.Nombre,             FORMATEAFECHACONTRATO(FechaEsc) , NomNotario,
    Notaria,            'Chiapas' ,           Mun2.Nombre,            Edo2.Nombre,            'distrito Tuxtla Gutierrez'
  INTO
    NumEscPConstitutiva,      LocalidadEscPConstitutiva,    EstadoEscPConstitutiva,       FechaEscPConstitutiva,        NombreNotarioEscPConstitutiva,
    NumeroNotarioEscPConstitutiva,  EstadoNotarioEscPConstitutiva,  LocalidadRegistroEscPConstitutiva,  EstadoRegistroEscPConstitutiva,   DistritoRegistroEscPConstitutiva

  FROM
    ESCRITURAPUB  escpubC,
    ESTADOSREPUB  Edo,
    MUNICIPIOSREPUB Mun,
    ESTADOSREPUB  Edo2,
    MUNICIPIOSREPUB Mun2
  WHERE
    ClienteID = Var_ClienteID
  AND Esc_Tipo = 'C'
  AND Edo.EstadoID    = escpubC.EstadoIDEsc
  AND Mun.EstadoID    = escpubC.EstadoIDEsc
  AND Mun.MunicipioID   = escpubC.LocalidadEsc
  AND Edo2.EstadoID   = escpubC.EstadoIDReg
  AND Mun2.EstadoID   = escpubC.EstadoIDReg
  AND Mun2.MunicipioID  = escpubC.LocalidadRegPub
  LIMIT 1;

  SELECT
    NomApoderado,       'apoderado legal',      EscrituraPublic,      Mun.Nombre,       Edo.Nombre,
    NomNotario,         Notaria,          'Chiapas',          Mun2.Nombre,    Edo2.Nombre,
    'distrito de Tuxtla Gutierrez'
  INTO
    NombreApoderadoEscPPoderes, TituloApoderadoEscPPoderes, NumeroEscPPoderes,      LocalidadEscPPoderes, EstadoEscPPoderes,
    NombreNotarioEscPPoderes, NumeroNotarioEscPPoderes, EstadoNotarioEscPPoderes, LocalidadRegEscPPoderes,EstadoRegEscPPoderes,
    DistritoRegEscPPoderes
  FROM
    ESCRITURAPUB  escpubP,
    ESTADOSREPUB  Edo,
    MUNICIPIOSREPUB Mun,
    ESTADOSREPUB  Edo2,
    MUNICIPIOSREPUB Mun2
  WHERE
    ClienteID = Var_ClienteID
  AND Esc_Tipo = 'P'
  AND Edo.EstadoID    = escpubP.EstadoIDEsc
  AND Mun.EstadoID    = escpubP.EstadoIDEsc
  AND Mun.MunicipioID   = escpubP.LocalidadEsc
  AND Edo2.EstadoID   = escpubP.EstadoIDReg
  AND Mun2.EstadoID   = escpubP.EstadoIDReg
  AND Mun2.MunicipioID  = escpubP.LocalidadRegPub
  LIMIT 1;

-- Documentos del cliente
      SELECT    Proyecto
  INTO
    ObjetoSocialEscPConstitutiva
  FROM
    SOLICITUDCREDITO
  WHERE
    ClienteID = Var_ClienteID
  AND CreditoID = Par_CreditoID;


      -- Institucion Nomina del Cliente

      SELECT INS.NombreInstit
        INTO Var_NomInstNomina
        FROM INSTITNOMINA INS
        INNER JOIN SOLICITUDCREDITO SC
        ON SC.InstitucionNominaID = INS.InstitNominaID
        INNER JOIN  CREDITOS C
        ON C.SolicitudCreditoID = SC.SolicitudCreditoID
        WHERE C.CreditoID = Par_CreditoID;

    IF(Var_TipoPagoCap=Tipo_PagoLibre OR Var_FrecuenciaInt != Var_Frecuencia)THEN
    SET Var_DesFrecLet = TxtMixtas;
  ELSE
    SELECT  CASE
          WHEN Var_Frecuencia = FrecSemanal THEN TxtSemanal
          WHEN Var_Frecuencia = FrecCatorcenal THEN TxtCatorcenal
          WHEN Var_Frecuencia = FrecQuincenal THEN TxtQuincenal
          WHEN Var_Frecuencia = FrecMensual THEN TxtMensual
          WHEN Var_Frecuencia = FrecPeriodica THEN TxtPeriodica
          WHEN Var_Frecuencia = FrecBimestral THEN TxtBimestral
          WHEN Var_Frecuencia = FrecTrimestral THEN TxtTrimestral
          WHEN Var_Frecuencia = FrecTetramestral THEN TxtTetramestral
          WHEN Var_Frecuencia = FrecSemestral THEN TxtSemestral
          WHEN Var_Frecuencia = FrecAnual THEN TxtAnual
          WHEN Var_Frecuencia = FrecDecenal THEN TxtDecenal
        END
    INTO Var_DesFrec;

  SET Var_DesFrec     := IFNULL(Var_DesFrec, Cadena_Vacia);
    SELECT  CASE
          WHEN Var_Frecuencia = FrecSemanal THEN TxtSemanales
          WHEN Var_Frecuencia = FrecCatorcenal THEN TxtCatorcenales
          WHEN Var_Frecuencia = FrecQuincenal THEN TxtQuincenales
          WHEN Var_Frecuencia = FrecMensual THEN TxtMensuales
          WHEN Var_Frecuencia = FrecPeriodica THEN TxtPeriodos
          WHEN Var_Frecuencia = FrecBimestral THEN TxtBimestrales
          WHEN Var_Frecuencia = FrecTrimestral THEN TxtTrimestrales
          WHEN Var_Frecuencia = FrecTetramestral THEN TxtTetramestrales
          WHEN Var_Frecuencia = FrecSemestral THEN TxtSemestrales
          WHEN Var_Frecuencia = FrecAnual THEN TxtAnuales
          WHEN Var_Frecuencia = FrecLibre THEN TxtMixtas
          WHEN Var_Frecuencia = FrecUnico THEN TxtUnico
          WHEN Var_Frecuencia = FrecDecenal THEN TxtDecenales
      ELSE
        NoAplica
      END
    INTO Var_DesFrecLet;
  END IF;

  SELECT  CASE
                WHEN Var_Frecuencia = FrecSemanal THEN TxtSemana
                WHEN Var_Frecuencia = FrecCatorcenal THEN TxtCatorcena
                WHEN Var_Frecuencia = FrecQuincenal THEN TxtQuincena
                WHEN Var_Frecuencia = FrecMensual THEN TxtMes
                WHEN Var_Frecuencia = FrecPeriodica THEN TxtPeriodo
                WHEN Var_Frecuencia = FrecBimestral THEN TxtBimestre
                WHEN Var_Frecuencia = FrecTrimestral THEN TxtTrimestre
                WHEN Var_Frecuencia = FrecTetramestral THEN TxtTetramestre
                WHEN Var_Frecuencia = FrecSemestral THEN TxtSemestre
                WHEN Var_Frecuencia = FrecAnual THEN  TxtAnio
        WHEN Var_Frecuencia = FrecUnico THEN TxtUnico
        WHEN Var_Frecuencia = FrecDecenal THEN TxtDecena
      ELSE
        NoAplica

            END
  INTO Var_FrecSeguro;



  SET Var_FechaCorte  := IFNULL(
    CASE (Var_Frecuencia)
      WHEN 'U' THEN IFNULL((SELECT MAX(FechaVencim) FROM AMORTICREDITO WHERE CreditoID = Par_CreditoID LIMIT 1), Fecha_Vacia)
      WHEN 'S' THEN 'Lunes  de  cada  semana'
      WHEN 'C' THEN CONCAT( UPPER(SUBSTR( TxtCatorcenal  ,1,1)),        SUBSTR( TxtCatorcenal ,2))
      WHEN 'Q' THEN 'Los  dias  16  y  01  de  cada  mes'
      WHEN 'M' THEN
        CASE (SELECT DiaPagoInteres FROM CREDITOS WHERE CreditoID = Par_CreditoID LIMIT 1)
          WHEN 'F' THEN 'Dia ultimo de cada Mes'
          WHEN 'D' THEN CONCAT(DAY(Aud_FechaActual),' de cada mes')
          ELSE
            'Dia seleccionado en el alta de Credito'
          END
      WHEN 'P' THEN TxtPeriodo
      WHEN 'B' THEN TxtBimestre
      WHEN 'T' THEN TxtTrimestre
      WHEN 'R' THEN TxtTetramestre
      WHEN 'E' THEN TxtSemestre
      WHEN 'A' THEN 'anio'
  END ,Cadena_Vacia);


 -- Calculo de tasa de interes

  SET TasaOrdinaria:=CASE (Var_Frecuencia)
    WHEN FrecUnico THEN CONVPORCANT(ROUND((Var_TasaAnual),2),'%','2','')
    WHEN  FrecSemanal  THEN CONVPORCANT(ROUND((Var_TasaAnual)*7/360,2),'%','2','')
    WHEN  FrecCatorcenal  THEN CONVPORCANT(ROUND((Var_TasaAnual)*14/360,2),'%','2','')
    WHEN  FrecQuincenal  THEN CONVPORCANT(ROUND((Var_TasaAnual)/26,2),'%','2','')
    WHEN  FrecMensual  THEN CONVPORCANT(ROUND((Var_TasaAnual)/12,2),'%','2','')
        WHEN  FrecPeriodica  THEN NoAplica
    WHEN  FrecBimestral  THEN CONVPORCANT(ROUND((Var_TasaAnual)/6,2),'%','2','')
    WHEN  FrecTrimestral  THEN CONVPORCANT(ROUND((Var_TasaAnual)/4,2),'%','2','')
    WHEN  FrecTetramestral  THEN CONVPORCANT(ROUND((Var_TasaAnual)/3,2),'%','2','')
    WHEN  FrecSemestral  THEN CONVPORCANT(ROUND((Var_TasaAnual)/2,2),'%','2','')
    WHEN  FrecAnual  THEN CONVPORCANT(ROUND(Var_TasaAnual,2),'%','2','')
    ELSE
        Cadena_Vacia
  END ;


    SELECT SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres) INTO Var_TotPagar
      FROM CREDITOS Cre, AMORTICREDITO Amo
            WHERE Cre.CreditoID   = Par_CreditoID
        AND Amo.CreditoID = Cre.CreditoID;

  SET Var_TotPagar    := IFNULL(Var_TotPagar, Entero_Cero);
  SET Var_TasaAnual         := IFNULL(Var_TasaAnual, Entero_Cero);
  SET Var_MontoCred       := IFNULL(Var_MontoCred, Decimal_Cero);
  SET Var_NumAmorti         := IFNULL(Var_NumAmorti, Entero_Cero);
  SET Var_CATLR           := IFNULL(Var_CATLR, Entero_Cero);
  SET Var_TotPagar          := IFNULL(Var_TotPagar, Entero_Cero);
  SET Var_TotInteres        := IFNULL(Var_TotInteres, Entero_Cero);
  SET Var_MontoPago         := IFNULL(Var_MontoPago, Entero_Cero);
  SET Var_SolicitudCredito    := IFNULL(Var_SolicitudCredito, Cadena_Vacia);
  SET Var_NombreInstitucion     := IFNULL(Var_NombreInstitucion, Cadena_Vacia);
  SET Var_ComisionApertura      := IFNULL(Var_ComisionApertura, Entero_Cero);
  SET Var_ComisionPrepago       := IFNULL(Var_ComisionPrepago, Entero_Cero);
  SET Var_IdentificacionOficial   := IFNULL(Var_IdentificacionOficial, Entero_Cero);
  SET Var_ComprobanteDomicilio    := IFNULL(Var_ComprobanteDomicilio, Entero_Cero);
  SET Var_ComprobanteIngresos   := IFNULL(Var_ComprobanteIngresos, Entero_Cero);
  SET Var_ServicioFederal     := IFNULL(Var_ServicioFederal, Entero_Cero);
  SET Var_EstadoCuenta        := IFNULL(Var_EstadoCuenta, Entero_Cero);
  SET Var_ProductoCre       := IFNULL(Var_ProductoCre, Entero_Cero);
  SET Var_DestinoCredito      := IFNULL(Var_DestinoCredito, Entero_Cero);
  SET Var_FactorMora        := IFNULL(Var_FactorMora, Entero_Cero);
  SET Var_FechaMinistrado       := IFNULL(Var_FechaMinistrado, Cadena_Vacia);
  SET Var_NumCasa       :=  IFNULL(Var_NumCasa,Cadena_Default);
  SET Var_Calle       :=  IFNULL(Var_Calle,Cadena_Default);
  SET Var_NombreColonia   :=  IFNULL(Var_NombreColonia,Cadena_Default);
  SET Var_CP          :=  IFNULL(Var_CP,Cadena_Default);
  SET Var_Ciudad        :=  IFNULL(Var_Ciudad,Cadena_Default);
  SET Var_NombreEstado    :=  IFNULL(Var_NombreEstado,Cadena_Default);
  SET RFC           :=  IFNULL(RFC,Cadena_Default);
  SET Var_RFCInstitucion  := IFNULL(Var_RFCInstitucion , Cadena_Vacia);




  SET MontoPagotxt := CONVPORCANT(Var_MontoCred,'$', 'Peso', 'Nacional');
  SET CATLRtxt := CONVPORCANT(Var_CATLR,'%', '2', '');
  SET Var_CATtxt  := ROUND(Var_CATLR, 1);
  SET ComReimpresonCant := CONVPORCANT(ROUND(Var_MontoCred * 0.0198, 2),'$', 'Peso', 'Nacional');
  SET ComReimpresonCantiva := CONVPORCANT(ROUND(Var_MontoCred * 0.023, 2),'$', 'Peso', 'Nacional');
  SET taiva := ROUND(Var_TasaAnual*0.16,2);
  SET tasaOrdinariaMensual := ROUND(Var_TasaAnual/12,2);
  SET tasaOrdinariaMensualtxt := CONVPORCANT(ROUND(Var_TasaAnual/12,2),'%','2','');
  SET taordinaria := ROUND(Var_TasaAnual,2);
  SET taordinariatxt := CONVPORCANT(ROUND(Var_TasaAnual,2),'%','2','');
  SET taOrdCarat  :=  ROUND(Var_TasaAnual - taiva,2);
  SET FechaLimPagtxt := FORMATEAFECHACONTRATO(Var_FechaLimPag);
  SET TasaDiariaordinariatxt := CONVPORCANT(ROUND(Var_TasaAnual/360,2),'%','2','');
  SET TasaMoraDiaria := CONVPORCANT(ROUND((Var_TasaAnual)*3/360,2),'%','2','') ;
  SET ValorMoraCatorcenalPC200 := CONVPORCANT(ROUND(Var_MontoCred*0.05,2),'$','Peso','Nacional') ;
  SET TasaMoraMensual := CONVPORCANT(ROUND((Var_TasaAnual)*3/12,2),'%','2','');
  SET ValorMoraDiaria := CONVPORCANT(ROUND( Var_TasaAnual*3/360*1.16*Var_MontoCred/100,2),'$','Peso','Nacional');
  SET MontoGarantiaLiquida := CONVPORCANT(Var_MontoCred*0.1,'$','Peso','Nacional');
  SET NombreAval := IFNULL(Var_AvalNombreCompleto, NoAplica);
  SET Var_FactorMoraTxt := FUNCIONNUMEROSLETRAS(Var_FactorMora);

  SET Var_ComAperturaPorc       := CONVPORCANT(ROUND(Var_ComisionApertura/Var_MontoCred*100,2),'%','2','');
  SET Var_ComDisposicion            := Decimal_Cero;
  SET Var_ComAnualidad              := Decimal_Cero;
  SET Var_ComFactibilidad           := Decimal_Cero;
  SET Var_ComisionPrepago           := Decimal_Cero;
  SET Var_ComisionCobranza          := Decimal_Cero;
  SET Var_ComPenaConvencional       := Decimal_Cero;
  SET Var_Subsidio                  := Decimal_Cero;
  SET Var_SubsidioTxt               := CONVPORCANT(Var_Subsidio,'%','2','');
  SET Var_ComisionAperturaTxt       := CONVPORCANT(Var_ComisionApertura,'$','Peso','Nacional');
  SET Var_ComDisposicionTxt         := CONVPORCANT(Var_ComDisposicion,'%','2','');
  SET Var_ComAnualidadTxt           := CONVPORCANT(Var_ComAnualidad,'%','2','');
  SET Var_ComFactibilidadTxt        := CONVPORCANT(Var_ComFactibilidad,'%','2','');
  SET Var_ComPrepagoTxt             := CONVPORCANT(Var_ComisionPrepago,'%','2','');
  SET Var_ComGastosCobranzaTxt      := CONVPORCANT(Var_ComisionCobranza,'$','Peso','Nacional');
  SET Var_ComPenaConvencionalTxt    := CONVPORCANT(Var_ComPenaConvencional,'%','2','');

      IF(Var_TipoCobroMoratorio = NVecesTasaOrd) THEN
        SET Var_TasaMoratoria   :=  ROUND(Var_FactorMora*Var_TasaAnual,2);
        ELSE
            SET Var_TasaMoratoria   :=  ROUND(Var_FactorMora,2);
      END IF;
      IF(Var_TipoCobroMoratorio = NVecesTasaOrd) THEN
        SET Var_TasaMoratoriaTxt    :=  CONVPORCANT(ROUND(Var_FactorMora*Var_TasaAnual,2),'%', '2', '');
        ELSE
            SET Var_TasaMoratoriaTxt    :=  CONVPORCANT(ROUND(Var_FactorMora,2),'%', '2', '');
      END IF;
      IF(Var_TipoCobroMoratorio = NVecesTasaOrd) THEN
        SET Var_TasaMoratoriaMen    :=  ROUND(Var_FactorMora*Var_TasaAnual/12,2);
        ELSE
            SET Var_TasaMoratoriaMen    :=  ROUND(Var_FactorMora/12,2);
      END IF;
       IF(Var_TipoCobroMoratorio = NVecesTasaOrd) THEN
        SET Var_TasaMoratoriaMenTxt :=  CONVPORCANT(ROUND(Var_FactorMora*Var_TasaAnual/12,2),'%', '2', '');
        ELSE
            SET Var_TasaMoratoriaMenTxt :=  CONVPORCANT(ROUND(Var_FactorMora/12,2),'%', '2', '');
      END IF;

      DROP TABLE IF EXISTS TMPDATOSAVALESALT;
        CREATE TEMPORARY TABLE TMPDATOSAVALESALT
        SELECT
            CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <>  Entero_Cero THEN
                    C.NombreCompleto
                ELSE
                    CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                            A.NombreCompleto
                        ELSE
                            P.NombreCompleto
                    END
            END AS  AvalNombreCompleto

            FROM  AVALESPORSOLICI AP
                INNER JOIN    CREDITOS      Cre ON  Cre.SolicitudCreditoID  = AP.SolicitudCreditoID
                INNER JOIN    SOLICITUDCREDITO  Sol ON  Sol.SolicitudCreditoID  = AP.SolicitudCreditoID
                LEFT OUTER JOIN CLIENTES      Cc  ON  Cc.ClienteID      = Cre.ClienteID
                LEFT OUTER JOIN CLIENTES      C ON  C.ClienteID       = AP.ClienteID
                LEFT OUTER JOIN AVALES        A ON  A.AvalID        = AP.AvalID
                LEFT OUTER JOIN PROSPECTOS      P ON  P.ProspectoID     = AP.ProspectoID
              WHERE Cre.CreditoID = Par_CreditoID
              LIMIT 1;

              SET NombreAval := (SELECT AvalNombreCompleto FROM TMPDATOSAVALESALT);
            DROP TABLE IF EXISTS TMPDATOSAVALESALT;


      IF ( TipoPersona  = PersonaMoral )  THEN
        SELECT
            IFNULL(Var_NombreSucursal,Cadena_Vacia) AS Var_NombreSucursal,
            IFNULL(Var_NombreInstitucion,Cadena_Vacia) AS Var_NombreInstitucion,
            IFNULL(Var_DirFiscalInstitucion,Cadena_Vacia) AS Var_DirFiscalInstitucion,
            Var_RFCInstitucion ,     Var_EscriPubIns,   Var_VolEscIns,      Var_FechaEscIns,    Var_EstadoIDEscIns,
            Var_NomNotarioIns,       Var_NotariaIns,    Var_DirecNotarIns,  Var_RegistroPubIns, Var_FechaRegPubIns,
            Cadena_Default AS Titulo,
            IFNULL(TipoPersona,Cadena_Vacia) AS TipoPersona,
            IFNULL(NombreCompleto,Cadena_Vacia) AS NombreCompleto,
            Cadena_Default AS Sexo,
            Cadena_Default AS FechaNacimientoFtoTxt,
            Cadena_Default AS EstadoNacimiento,
            Cadena_Default AS PaisNacimiento,
            IFNULL(Nacionalidad,Cadena_Vacia) AS Nacionalidad,
            IFNULL(Var_DirecClienteFiscal,Cadena_Vacia) AS Var_DirecClienteFiscal,
            Cadena_Default AS Ocupacion,
            Cadena_Default AS GradoEstudios,
            Cadena_Default AS Profesion,
            Cadena_Default AS ActividadEconomica,
            Cadena_Default AS EstadoCivil,
            Cadena_Default AS Telefono,
            Cadena_Default AS Correo,
            Cadena_Default AS CURP,
            Cadena_Default AS Var_NumCasa,
            IFNULL(Var_Calle,Cadena_Vacia) AS Var_Calle,
            IFNULL(Var_CP,Cadena_Vacia) AS Var_CP,
            IFNULL(Var_Ciudad,Cadena_Vacia) AS Var_Ciudad,
            IFNULL(Var_NombreEstado,Cadena_Vacia) AS Var_NombreEstado,
            IFNULL(RFC,Cadena_Vacia) AS RFC,
            IFNULL(TipoEmpresa,Cadena_Vacia) AS TipoEmpresa,
            IFNULL(RazonSocial,Cadena_Vacia) AS RazonSocial,
            IFNULL(NumEscPConstitutiva,Cadena_Vacia) AS NumEscPConstitutiva,
            IFNULL(LocalidadEscPConstitutiva,Cadena_Vacia) AS LocalidadEscPConstitutiva,
            IFNULL(FechaEscPConstitutiva,Cadena_Vacia) AS FechaEscPConstitutiva,
            IFNULL(NombreNotarioEscPConstitutiva,Cadena_Vacia) AS NombreNotarioEscPConstitutiva,
            IFNULL(NumeroNotarioEscPConstitutiva,Cadena_Vacia) AS NumeroNotarioEscPConstitutiva,
            IFNULL(EstadoNotarioEscPConstitutiva,Cadena_Vacia) AS EstadoNotarioEscPConstitutiva,
            IFNULL(EstadoRegistroEscPConstitutiva,Cadena_Vacia) AS EstadoRegistroEscPConstitutiva,
            IFNULL(DistritoRegistroEscPConstitutiva,Cadena_Vacia) AS DistritoRegistroEscPConstitutiva,
            IFNULL(ObjetoSocialEscPConstitutiva,Cadena_Vacia) AS ObjetoSocialEscPConstitutiva,
            IFNULL(NombreApoderadoEscPPoderes,Cadena_Vacia) AS NombreApoderadoEscPPoderes,
            IFNULL(TituloApoderadoEscPPoderes,Cadena_Vacia) AS TituloApoderadoEscPPoderes,
            IFNULL(NumeroEscPPoderes,Cadena_Vacia) AS NumeroEscPPoderes,
            IFNULL(LocalidadEscPPoderes,Cadena_Vacia) AS LocalidadEscPPoderes,
            IFNULL(EstadoEscPPoderes, Cadena_Vacia) AS EstadoEscPPoderes,
            IFNULL(NombreNotarioEscPPoderes, Cadena_Vacia) AS NombreNotarioEscPPoderes,
            IFNULL(NumeroNotarioEscPPoderes, Cadena_Vacia) AS NumeroNotarioEscPPoderes,
            IFNULL(EstadoNotarioEscPPoderes, Cadena_Vacia) AS EstadoNotarioEscPPoderes,
            IFNULL(LocalidadRegEscPPoderes, Cadena_Vacia) AS LocalidadRegEscPPoderes,
            IFNULL(EstadoRegEscPPoderes, Cadena_Vacia) AS EstadoRegEscPPoderes,
            IFNULL(CAST(DistritoRegEscPPoderes AS CHAR CHARACTER SET utf8 ), Cadena_Vacia) AS DistritoRegEscPPoderes,
            IFNULL(MontoPagotxt, Cadena_Vacia) AS MontoPagotxt,
            IFNULL(CATLRtxt, Cadena_Vacia) AS CATLRtxt,
            IFNULL(Var_NumAmorti, Cadena_Vacia) AS Var_NumAmorti,
            IFNULL(PlazoCredito, Cadena_Vacia) AS PlazoCredito,
            IFNULL(Var_DesFrecLet, Cadena_Vacia) AS Var_DesFrecLet,
            IFNULL(Var_MontoRetencion, Cadena_Vacia) AS Var_MontoRetencion,
            IFNULL(ValorMoraPC400, Cadena_Vacia) AS ValorMoraPC400,
            IFNULL(PenaConvtxtPC400, Cadena_Vacia) AS PenaConvtxtPC400,
            IFNULL(taordinariatxt, Cadena_Vacia) AS taordinariatxt,
            IFNULL(tasaOrdinariaMensualtxt, Cadena_Vacia) AS tasaOrdinariaMensualtxt,
            IFNULL(Var_DireccionCompleta, Cadena_Vacia) AS DireccionCompleta,
            IFNULL(Var_ExisteGarReal, Cadena_Vacia) AS Var_ExisteGarReal,
            IFNULL(Var_Garantias, Cadena_Vacia) AS Var_Garantias,
            IFNULL(Var_TipoDocumentoTxt, Cadena_Vacia) AS Var_TipoDocumentoTxt,
            IFNULL(LocalidadRegEscPPoderes, Cadena_Vacia) AS LocalidadRegEscPPoderes,
            IFNULL(EstadoRegEscPPoderes, Cadena_Vacia) AS EstadoRegEscPPoderes,
            IFNULL(Var_FechaGarantia,Cadena_Vacia) AS Var_FechaGarantia,
            IFNULL(Var_NombreMuni, Cadena_Vacia) AS Var_NombreMuni,
            IFNULL(Var_NombreEstadom, Cadena_Vacia) AS Var_NombreEstadom,
            IFNULL(FechaSistematxt, Cadena_Vacia) AS FechaSistematxt,
            IFNULL(Var_NumRECA, Cadena_Vacia) AS Var_NumRECA,
            IFNULL(Var_DescProducto, Cadena_Vacia) AS Var_DescProducto,
            IFNULL(Var_CarProd, Cadena_Vacia) AS Var_CarProd,
            IFNULL(Var_DestinoCredito, Cadena_Vacia) AS Var_DestinoCredito,
            IFNULL(Var_CATtxt,Cadena_Vacia) AS Var_CATtxt,
            IFNULL(taOrdCarat, Cadena_Vacia) AS taOrdCarat,
            IFNULL(taiva, Cadena_Vacia) AS taiva,
            Var_FactorMoraTxt,
            ROUND(Var_FactorMora,2) AS Var_FactorMora,
            FNDECIMALALETRA(Var_FactorMora,1) AS FactorMoraLetra,
            IFNULL(ROUND(Var_TasaAnual,2),Cadena_Vacia) AS Var_TasaAnual,
            IFNULL(ROUND(Var_TasaMoratoria,2),Cadena_Vacia) AS Var_TasaMoratoria,
            IFNULL(Var_TasaMoratoriaTxt,Cadena_Vacia) AS Var_TasaMoratoriaTxt,
            IFNULL(Var_TasaMoratoriaMen,Cadena_Vacia) AS Var_TasaMoratoriaMen,
            IFNULL(Var_TasaMoratoriaMenTxt,Cadena_Vacia) AS Var_TasaMoratoriaMenTxt,
            IFNULL(FORMAT(Var_MontoCred,2),Cadena_Vacia) AS Var_MontoCred,
            IFNULL(FORMAT(Var_MontoPago,2),Cadena_Vacia) AS Var_MontoPago,
            IFNULL(FORMAT(Var_TotPagar,2),Cadena_Vacia) AS Var_TotPagar,
            IFNULL(Var_SubsidioTxt,Cadena_Vacia) AS Var_SubsidioTxt,
            IFNULL(Var_ComAperturaPorc,Cadena_Vacia) AS Var_ComAperturaPorc,
            IFNULL(FORMAT(Var_ComisionApertura,2),Cadena_Vacia) AS Var_ComisionApertura,
            IFNULL(FORMAT(Var_ComDisposicion,2),Cadena_Vacia) AS Var_ComDisposicion,
            IFNULL(FORMAT(Var_ComAnualidad,2),Cadena_Vacia) AS Var_ComAnualidad,
            IFNULL(FORMAT(Var_ComFactibilidad,2),Cadena_Vacia) AS Var_ComFactibilidad,
            IFNULL(FORMAT(Var_ComisionPrepago,2),Cadena_Vacia) AS Var_ComisionPrepago,
            IFNULL(FORMAT(Var_ComisionCobranza,2),Cadena_Vacia) AS Var_ComisionCobranza,
            IFNULL(FORMAT(Var_ComPenaConvencional,2),Cadena_Vacia) AS Var_ComPenaConvencional,
            IFNULL(Var_ComisionAperturaTxt, Cadena_Vacia) AS Var_ComisionAperturaTxt,
            IFNULL(Var_ComDisposicionTxt, Cadena_Vacia) AS Var_ComDisposicionTxt,
            IFNULL(Var_ComAnualidadTxt, Cadena_Vacia) AS Var_ComAnualidadTxt,
            IFNULL(Var_ComFactibilidadTxt, Cadena_Vacia) AS Var_ComFactibilidadTxt,
            IFNULL(Var_ComPrepagoTxt, Cadena_Vacia) AS Var_ComPrepagoTxt,
            IFNULL(Var_ComGastosCobranzaTxt, Cadena_Vacia) AS Var_ComGastosCobranzaTxt,
            IFNULL(Var_ComPenaConvencionalTxt, Cadena_Vacia) AS Var_ComPenaConvencionalTxt,
            IFNULL(Var_Plazo, Cadena_Vacia) AS Var_Plazo,
            IFNULL(Var_FechaLimPag, Cadena_Vacia) AS Var_FechaLimPag,
            IFNULL(FechaTerminoMora, Cadena_Vacia) AS FechaTerminoMora,
            IFNULL(CAST(Var_FechaCorte AS CHAR CHARACTER SET utf8 ), Cadena_Vacia) AS Var_FechaCorte,
            IFNULL(Var_ProductoCre,Cadena_Vacia) AS Var_ProductoCre,
            IFNULL(Var_RepresentanteLegal, Cadena_Vacia) AS Var_RepresentanteLegal,
            Cadena_Vacia  AS  GarHip_Desc,
            Cadena_Vacia  AS  GarHip_Ref,
            Cadena_Vacia  AS  GarHip_Mun,
            Cadena_Vacia  AS  GarHip_Edo,
            Cadena_Vacia  AS  GarHip_FechaReg,
            Cadena_Vacia  AS  GarReal_Desc,
            Cadena_Vacia  AS  GarReal_TipDocu,
            Cadena_Vacia  AS  GarReal_Ref,
            Cadena_Vacia  AS  GarHip_Hipo,
            Var_FechaMinistrado,
            Var_NomInstNomina,
            Avales_Nom1,
            NombreAval,
            Var_ProductoCredito

          ;
      ELSE
        SELECT
            IFNULL(Var_NombreSucursal, Cadena_Vacia) AS Var_NombreSucursal,
            IFNULL(Var_NombreInstitucion, Cadena_Vacia) AS Var_NombreInstitucion,
            IFNULL(Var_DirFiscalInstitucion, Cadena_Vacia) AS Var_DirFiscalInstitucion,
             Var_RFCInstitucion ,     Var_EscriPubIns,  Var_VolEscIns,      Var_FechaEscIns,    Var_EstadoIDEscIns,
            Var_NomNotarioIns,       Var_NotariaIns,    Var_DirecNotarIns,  Var_RegistroPubIns, Var_FechaRegPubIns,
            IFNULL(Titulo, Cadena_Vacia) AS Titulo,
            IFNULL(TipoPersona, Cadena_Vacia) AS TipoPersona,
            IFNULL(NombreCompleto, Cadena_Vacia) AS NombreCompleto,
            IFNULL(Sexo, Cadena_Vacia) AS Sexo,
            IFNULL(FechaNacimientoFtoTxt, Cadena_Vacia) AS FechaNacimientoFtoTxt,
            IFNULL(EstadoNacimiento, Cadena_Vacia) AS EstadoNacimiento,
            IFNULL(PaisNacimiento, Cadena_Vacia) AS PaisNacimiento,
            IFNULL(Nacionalidad, Cadena_Vacia) AS Nacionalidad,
            IFNULL(Ocupacion, Cadena_Vacia) AS Ocupacion,
            IFNULL(GradoEstudios, Cadena_Vacia) AS GradoEstudios,
            IFNULL(Profesion, Cadena_Vacia) AS Profesion,
            IFNULL(ActividadEconomica, Cadena_Vacia) AS ActividadEconomica,
            IFNULL(EstadoCivil, Cadena_Vacia) AS EstadoCivil,
            IFNULL(Telefono, Cadena_Vacia) AS Telefono,
            IFNULL(Correo, Cadena_Vacia) AS Correo,
            IFNULL(Var_NumIdent, Cadena_Vacia) AS Var_NumIdent,
            IFNULL(CURP, Cadena_Vacia) AS CURP,
            IFNULL(Var_NumCasa, Cadena_Vacia) AS Var_NumCasa,
            IFNULL(Var_Calle, Cadena_Vacia) AS Var_Calle,
            IFNULL(Var_NombreColonia, Cadena_Vacia) AS Var_NombreColonia,
            IFNULL(Var_CP, Cadena_Vacia) AS Var_CP,
            IFNULL(Var_Ciudad, Cadena_Vacia) AS Var_Ciudad,
            IFNULL(Var_NombreEstado, Cadena_Vacia) AS Var_NombreEstado,
            IFNULL(RFC, Cadena_Vacia) AS RFC,
            IFNULL(MontoPagotxt, Cadena_Vacia) AS MontoPagotxt,
            IFNULL(CATLRtxt, Cadena_Vacia) AS CATLRtxt,
            IFNULL(Var_NumAmorti, Cadena_Vacia) AS Var_NumAmorti,
            IFNULL(PlazoCredito, Cadena_Vacia) AS PlazoCredito,
            IFNULL(Var_DesFrecLet, Cadena_Vacia) AS Var_DesFrecLet,
            IFNULL(Var_MontoRetencion, Cadena_Vacia) AS Var_MontoRetencion,
            IFNULL(ValorMoraPC400, Cadena_Vacia) AS ValorMoraPC400,
            IFNULL(PenaConvtxtPC400, Cadena_Vacia) AS PenaConvtxtPC400,
            IFNULL(taordinariatxt, Cadena_Vacia) AS taordinariatxt,
            IFNULL(tasaOrdinariaMensualtxt, Cadena_Vacia) AS tasaOrdinariaMensualtxt,
            IFNULL(Var_DireccionCompleta, Cadena_Vacia) AS DireccionCompleta,
            IFNULL(Var_ExisteGarReal, Cadena_Vacia) AS Var_ExisteGarReal,
            IFNULL(Var_Garantias, Cadena_Vacia) AS Var_Garantias,
            IFNULL(Var_TipoDocumentoTxt, Cadena_Vacia) AS Var_TipoDocumentoTxt,
            IFNULL(LocalidadRegEscPPoderes, Cadena_Vacia) AS LocalidadRegEscPPoderes,
            IFNULL(EstadoRegEscPPoderes, Cadena_Vacia) AS EstadoRegEscPPoderes,
            IFNULL(Var_FechaGarantia,Cadena_Vacia) AS Var_FechaGarantia,
            IFNULL(Var_NombreMuni, Cadena_Vacia) AS Var_NombreMuni,
            IFNULL(Var_NombreEstadom, Cadena_Vacia) AS Var_NombreEstadom,
            IFNULL(FechaSistematxt, Cadena_Vacia) AS FechaSistematxt,
            IFNULL(Var_NumRECA, Cadena_Vacia) AS Var_NumRECA,
            IFNULL(Var_DestinoCredito, Cadena_Vacia) AS Var_DestinoCredito,
            IFNULL(Var_DescProducto, Cadena_Vacia) AS Var_DescProducto,
            IFNULL(Var_CarProd, Cadena_Vacia) AS Var_CarProd,
            IFNULL(Var_CATtxt,Cadena_Vacia) AS Var_CATtxt,
            IFNULL(taOrdCarat, Cadena_Vacia) AS taOrdCarat,
            IFNULL(taiva, Cadena_Vacia) AS taiva,
            Var_FactorMoraTxt,
            FNDECIMALALETRA(Var_FactorMora,1) AS FactorMoraLetra,
            ROUND(Var_FactorMora,2) AS Var_FactorMora,
            IFNULL(ROUND(Var_TasaAnual,2),Cadena_Vacia) AS Var_TasaAnual,
            IFNULL(ROUND(Var_TasaMoratoria,2),Cadena_Vacia) AS Var_TasaMoratoria,
            IFNULL(Var_TasaMoratoriaTxt,Cadena_Vacia) AS Var_TasaMoratoriaTxt,
            IFNULL(Var_TasaMoratoriaMen,Cadena_Vacia) AS Var_TasaMoratoriaMen,
            IFNULL(Var_TasaMoratoriaMenTxt,Cadena_Vacia) AS Var_TasaMoratoriaMenTxt,
            IFNULL(FORMAT(Var_MontoCred,2),Cadena_Vacia) AS Var_MontoCred,
            IFNULL(FORMAT(Var_MontoPago,2),Cadena_Vacia) AS Var_MontoPago,
            IFNULL(FORMAT(Var_TotPagar,2),Cadena_Vacia) AS Var_TotPagar,
            IFNULL(Var_SubsidioTxt,Cadena_Vacia) AS Var_SubsidioTxt,
            IFNULL(Var_ComAperturaPorc,Cadena_Vacia) AS Var_ComAperturaPorc,
            IFNULL(FORMAT(Var_ComisionApertura,2),Cadena_Vacia) AS Var_ComisionApertura,
            IFNULL(FORMAT(Var_ComDisposicion,2),Cadena_Vacia) AS Var_ComDisposicion,
            IFNULL(FORMAT(Var_ComAnualidad,2),Cadena_Vacia) AS Var_ComAnualidad,
            IFNULL(FORMAT(Var_ComFactibilidad,2),Cadena_Vacia) AS Var_ComFactibilidad,
            IFNULL(FORMAT(Var_ComisionPrepago,2),Cadena_Vacia) AS Var_ComisionPrepago,
            IFNULL(FORMAT(Var_ComisionCobranza,2),Cadena_Vacia) AS Var_ComisionCobranza,
            IFNULL(FORMAT(Var_ComPenaConvencional,2),Cadena_Vacia) AS Var_ComPenaConvencional,
            IFNULL(Var_ComisionAperturaTxt, Cadena_Vacia) AS Var_ComisionAperturaTxt,
            IFNULL(Var_ComDisposicionTxt, Cadena_Vacia) AS Var_ComDisposicionTxt,
            IFNULL(Var_ComAnualidadTxt, Cadena_Vacia) AS Var_ComAnualidadTxt,
            IFNULL(Var_ComFactibilidadTxt, Cadena_Vacia) AS Var_ComFactibilidadTxt,
            IFNULL(Var_ComPrepagoTxt, Cadena_Vacia) AS Var_ComPrepagoTxt,
            IFNULL(Var_ComGastosCobranzaTxt, Cadena_Vacia) AS Var_ComGastosCobranzaTxt,
            IFNULL(Var_ComPenaConvencionalTxt, Cadena_Vacia) AS Var_ComPenaConvencionalTxt,
            IFNULL(Var_Plazo, Cadena_Vacia) AS Var_Plazo,
            IFNULL(Var_FechaLimPag, Cadena_Vacia) AS Var_FechaLimPag,
            IFNULL(FechaTerminoMora, Cadena_Vacia) AS FechaTerminoMora,
            IFNULL(CAST(Var_FechaCorte AS CHAR CHARACTER SET utf8 ), Cadena_Vacia) AS Var_FechaCorte,
            IFNULL(Var_ProductoCre,Cadena_Vacia) AS Var_ProductoCre,
            IFNULL(Var_RepresentanteLegal, Cadena_Vacia) AS Var_RepresentanteLegal,
            Var_FechaMinistrado,
            Var_NomInstNomina,
            NombreAval,
            Avales_Nom1,
            Avales_RFC1,
            Avales_Dir1,
            Var_ProductoCredito
          ;
      END IF;
END IF;



IF(Par_TipoReporte = Tipo_AvalesAlternativa) THEN
       SELECT
    CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <>  Entero_Cero THEN
            C.NombreCompleto
        ELSE
            CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                    A.NombreCompleto
                ELSE
                    P.NombreCompleto
            END
    END AS  Var_AvalNombreCompleto,
     CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
           C.TipoPersona

      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
              A.TipoPersona
          ELSE
           P.TipoPersona
      END
    END AS Var_TipoPersona,
    CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
        CASE WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
            CASE  WHEN  C.Sexo  = Masculino THEN  TxtMasculino
                WHEN C.Sexo = Femenino THEN TxtFemenino
            END
        WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
              CASE  WHEN  A.Sexo  = Masculino THEN  TxtMasculino
                    WHEN A.Sexo = Femenino THEN TxtFemenino
                    ELSE Cadena_Vacia
              END
        ELSE
            CASE  WHEN  P.Sexo  = Masculino THEN  TxtMasculino
                  ELSE  TxtFemenino
            END
        END
    ELSE
      Cadena_Vacia
    END AS Var_AvalSexo,

    CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
        CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
              FORMATEAFECHACONTRATO(C.FechaNacimiento)
          ELSE
              CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  FORMATEAFECHACONTRATO(A.FechaNac)
              ELSE
                  FORMATEAFECHACONTRATO(P.FechaNacimiento)
              END
          END
    ELSE
      Cadena_Vacia
    END AS Var_AvalFechaNacimiento,
  CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
        CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(EC.Nombre,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(EA.Nombre,Cadena_Vacia)
              ELSE
                  IFNULL(EP.Nombre,Cadena_Vacia)
          END
      END
    ELSE
      Cadena_Vacia
    END AS Var_AvalEdo,
  CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
         CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(PC.Nombre,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  Cadena_Vacia
              ELSE
                  Cadena_Vacia
          END
      END
    ELSE
      Cadena_Vacia
    END AS Var_AvalLugarNacimiento,

  CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
        CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
         CASE C.Nacion
            WHEN TxtNacionM THEN TxtMexicana
            WHEN TxtNacionE THEN TxtExtranjera
        END

      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
           Cadena_Vacia
          ELSE
           Cadena_Vacia
          END
      END
    ELSE
      CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
         CASE C.Nacion
            WHEN TxtNacionM THEN TxtMexicana
            WHEN TxtNacionE THEN TxtExtranjera
        END

      ELSE
           Cadena_Vacia
      END
    END AS Var_AvalNacion,

     CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
        CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(CAST(Oc.Descripcion AS CHAR),Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
              Cadena_Vacia
          ELSE
              IFNULL(CAST(Op.Descripcion AS CHAR),Cadena_Vacia)
          END
      END
    ELSE
      Cadena_Vacia
    END AS Var_AvalOcupacion,

      CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
           CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
         IFNULL(C.Puesto,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
              Cadena_Vacia
          ELSE
              IFNULL(P.Puesto,Cadena_Vacia)
          END
      END
    ELSE
      Cadena_Vacia
    END AS Var_AvalProfesion,

    CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
          CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(Abm.Descripcion,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  Cadena_Vacia
              ELSE
                 Cadena_Vacia
          END
      END
    ELSE
      Cadena_Vacia
    END AS Var_AvalActEco,

    CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
        CASE WHEN IFNULL(AP.ClienteID, Entero_Cero)  <> Entero_Cero THEN
            CASE C.EstadoCivil
                WHEN EstSoltero THEN TxtSoltero
                WHEN EstCasBienSep THEN TextoCasado
                WHEN EstCasBienMan THEN TextoCasado
                WHEN EstcasBienManCap THEN TextoCasado
                WHEN EstViudo THEN TxtViudo
                WHEN EstDivorciado THEN TxtDivorciado
                WHEN EstSeparado THEN TxtSeparado
                WHEN EsteUnionLibre THEN TxteUnionLibre
            END
        ELSE
            CASE WHEN IFNULL(AP.AvalID, Entero_Cero) <> Entero_Cero THEN
                CASE A.EstadoCivil
                    WHEN EstSoltero THEN TxtSoltero
                    WHEN EstCasBienSep THEN TextoCasado
                    WHEN EstCasBienMan THEN TextoCasado
                    WHEN EstcasBienManCap THEN TextoCasado
                    WHEN EstViudo THEN TxtViudo
                    WHEN EstDivorciado THEN TxtDivorciado
                    WHEN EstSeparado THEN TxtSeparado
                    WHEN EsteUnionLibre THEN TxteUnionLibre
                END

                ELSE
                    CASE P.EstadoCivil
                        WHEN EstSoltero THEN TxtSoltero
                        WHEN EstCasBienSep THEN TextoCasado
                        WHEN EstCasBienMan THEN TextoCasado
                        WHEN EstcasBienManCap THEN TextoCasado
                        WHEN EstViudo THEN TxtViudo
                        WHEN EstDivorciado THEN TxtDivorciado
                        WHEN EstSeparado THEN TxtSeparado
                        WHEN EsteUnionLibre THEN TxteUnionLibre
                    END
                 END
             END
    ELSE
      Cadena_Vacia
    END AS Var_AvalEdoCivil,

    CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
     CASE WHEN IFNULL(AP.ClienteID, Entero_Cero)  <> Entero_Cero THEN
            CASE C.EstadoCivil
                WHEN EstSoltero THEN Cadena_Vacia
                WHEN EstCasBienSep THEN TxtCasBienSep
                WHEN EstCasBienMan THEN TxtCasBienMan
                WHEN EstcasBienManCap THEN TxtcasBienManCap
                WHEN EstViudo THEN TxtViudo
                WHEN EstDivorciado THEN TxtDivorciado
                WHEN EstSeparado THEN TxtSeparado
                WHEN EsteUnionLibre THEN Cadena_Vacia
            END
        ELSE
            CASE WHEN IFNULL(AP.AvalID, Entero_Cero) <> Entero_Cero THEN
                CASE A.EstadoCivil
                    WHEN EstSoltero THEN Cadena_Vacia
                    WHEN EstCasBienSep THEN TxtCasBienSep
                    WHEN EstCasBienMan THEN TxtCasBienMan
                    WHEN EstcasBienManCap THEN TxtcasBienManCap
                    WHEN EstViudo THEN TxtViudo
                    WHEN EstDivorciado THEN TxtDivorciado
                    WHEN EstSeparado THEN TxtSeparado
                    WHEN EsteUnionLibre THEN Cadena_Vacia
                END

                ELSE
                    CASE P.EstadoCivil
                        WHEN EstSoltero THEN Cadena_Vacia
                        WHEN EstCasBienSep THEN TxtCasBienSep
                        WHEN EstCasBienMan THEN TxtCasBienMan
                        WHEN EstcasBienManCap THEN TxtcasBienManCap
                        WHEN EstViudo THEN TxtViudo
                        WHEN EstDivorciado THEN TxtDivorciado
                        WHEN EstSeparado THEN TxtSeparado
                        WHEN EsteUnionLibre THEN Cadena_Vacia
                    END
                 END
             END
    ELSE
      Cadena_Vacia
    END AS Var_AvalRegimenMat,

    CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
     CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(CONCAT(SdcC.PrimerNombre,' ', SdcC.SegundoNombre,' ',SdcC.TercerNombre,' ',SdcC.ApellidoPaterno,' ',SdcC.ApellidoMaterno),Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                 Cadena_Vacia
              ELSE
                  IFNULL(CONCAT(SdcP.PrimerNombre,' ', SdcP.SegundoNombre,' ',SdcP.TercerNombre,' ',SdcP.ApellidoPaterno,' ',SdcP.ApellidoMaterno),Cadena_Vacia)
          END
      END
    ELSE
      Cadena_Vacia
    END AS Var_AvalNombreConyugue,

  CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
    CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
        IFNULL(Dc.DireccionCompleta,Cadena_Vacia)
    ELSE
        CASE  WHEN IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero THEN
                A.DireccionCompleta
            ELSE
                CONCAT(
                    IFNULL(P.Calle,Cadena_Vacia),
                    CASE  WHEN IFNULL(P.NumExterior,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(TxtNum,P.NumExterior)
                        ELSE  Cadena_Vacia
                    END,
                    CASE  WHEN IFNULL(P.NumInterior,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(TxtNumInt,P.NumInterior)
                        ELSE  Cadena_Vacia
                    END,
                    CASE  WHEN IFNULL(P.NumInterior,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(TxtNumInt,P.NumInterior)
                        ELSE  Cadena_Vacia
                    END,
                    CASE  WHEN IFNULL(P.Colonia,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(TxtCol,P.Colonia)
                        ELSE  Cadena_Vacia
                    END,
                    CASE  WHEN IFNULL(P.CP,Cadena_Vacia) <> Cadena_Vacia  THEN  CONCAT(TxtCP,P.CP)
                        ELSE  Cadena_Vacia
                    END,
                    CASE  WHEN IFNULL(LP.NombreLocalidad,Cadena_Vacia) <> Cadena_Vacia  THEN  CONCAT(', ',LP.NombreLocalidad)
                        ELSE  Cadena_Vacia
                    END,
                    CASE  WHEN IFNULL(EP.Nombre,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(', ',EP.Nombre)
                        ELSE  Cadena_Vacia
                    END
                )
        END
    END
    ELSE
   CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
        IFNULL(Df.DireccionCompleta,Cadena_Vacia)
    ELSE
        CASE  WHEN IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero THEN
                A.DireccionCompleta
            ELSE
                CONCAT(
                    IFNULL(P.Calle,Cadena_Vacia),
                    CASE  WHEN IFNULL(P.NumExterior,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(TxtNum,P.NumExterior)
                        ELSE  Cadena_Vacia
                    END,
                    CASE  WHEN IFNULL(P.NumInterior,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(TxtNumInt,P.NumInterior)
                        ELSE  Cadena_Vacia
                    END,
                    CASE  WHEN IFNULL(P.NumInterior,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(TxtNumInt,P.NumInterior)
                        ELSE  Cadena_Vacia
                    END,
                    CASE  WHEN IFNULL(P.Colonia,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(TxtCol,P.Colonia)
                        ELSE  Cadena_Vacia
                    END,
                    CASE  WHEN IFNULL(P.CP,Cadena_Vacia) <> Cadena_Vacia  THEN  CONCAT(TxtCP,P.CP)
                        ELSE  Cadena_Vacia
                    END,
                    CASE  WHEN IFNULL(LP.NombreLocalidad,Cadena_Vacia) <> Cadena_Vacia  THEN  CONCAT(', ',LP.NombreLocalidad)
                        ELSE  Cadena_Vacia
                    END,
                    CASE  WHEN IFNULL(EP.Nombre,Cadena_Vacia) <> Cadena_Vacia THEN  CONCAT(', ',EP.Nombre)
                        ELSE  Cadena_Vacia
                    END
                )
        END
    END
    END AS Var_AvalDirCompleta,

CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
    CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(Dc.NumeroCasa,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(A.NumExterior,Cadena_Vacia)
              ELSE
                  IFNULL(P.NumExterior,Cadena_Vacia)
          END
      END
    ELSE
    CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(Df.NumeroCasa,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(A.NumExterior,Cadena_Vacia)
              ELSE
                  IFNULL(P.NumExterior,Cadena_Vacia)
          END
      END
    END AS Aval_DirNumExt,
CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
    CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(Dc.Calle,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(A.Calle,Cadena_Vacia)
              ELSE
                  IFNULL(P.Calle,Cadena_Vacia)

          END
      END
    ELSE
    CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(Df.Calle,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(A.Calle,Cadena_Vacia)
              ELSE
                  IFNULL(P.Calle,Cadena_Vacia)

          END
      END
    END AS Aval_DirCalle,
CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
 CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(Dc.CP,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(A.CP,Cadena_Vacia)
              ELSE
                  IFNULL(P.CP,Cadena_Vacia)
          END
      END
    ELSE
     CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(Df.CP,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(A.CP,Cadena_Vacia)
              ELSE
                  IFNULL(P.CP,Cadena_Vacia)
          END
      END
    END AS Aval_DirCP,
CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
 CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(Dc.Colonia,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(A.Colonia,Cadena_Vacia)
              ELSE
                  IFNULL(P.Colonia,Cadena_Vacia)
          END
      END
    ELSE
    CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(Df.Colonia,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(A.Colonia,Cadena_Vacia)
              ELSE
                  IFNULL(P.Colonia,Cadena_Vacia)
          END
      END
    END AS Aval_DirColonia,
CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
 CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(LC.NombreLocalidad,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(LA.NombreLocalidad,Cadena_Vacia)
              ELSE
                  IFNULL(LP.NombreLocalidad,Cadena_Vacia)
          END
      END
    ELSE
    CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(LF.NombreLocalidad,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(LA.NombreLocalidad,Cadena_Vacia)
              ELSE
                  IFNULL(LP.NombreLocalidad,Cadena_Vacia)
          END
      END
    END AS Aval_DirLocalidad,

CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
  CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(MC.Nombre,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(MA.Nombre,Cadena_Vacia)
              ELSE
                  IFNULL(MP.Nombre,Cadena_Vacia)
          END
      END
    ELSE
     CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(MF.Nombre,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(MA.Nombre,Cadena_Vacia)
              ELSE
                  IFNULL(MP.Nombre,Cadena_Vacia)
          END
      END
    END AS Var_AvalMunicipio,
CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
  CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(EC.Nombre,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(EA.Nombre,Cadena_Vacia)
              ELSE
                  IFNULL(EP.Nombre,Cadena_Vacia)
          END
      END
    ELSE
     CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(EF.Nombre,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(EA.Nombre,Cadena_Vacia)
              ELSE
                  IFNULL(EP.Nombre,Cadena_Vacia)
          END
      END
    END AS Aval_DirEstado,

    CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
          CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(C.Correo,Cadena_Vacia)
      ELSE
          Cadena_Vacia
      END
    ELSE
      Cadena_Vacia
    END AS Var_AvalCorreo,

CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
    CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(C.CURP,Cadena_Vacia)
      ELSE
          Cadena_Vacia
      END
    ELSE
      CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(C.CURP,Cadena_Vacia)
      ELSE
          Cadena_Vacia
      END
    END AS Var_AvalCURP,

  CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
        CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(C.RFCOficial,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(A.RFC,Cadena_Vacia)
              ELSE
                  IFNULL(P.RFC,Cadena_Vacia)
          END
      END
    ELSE
    CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(C.RFCpm,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(A.RFCpm,Cadena_Vacia)
              ELSE
                  Cadena_Vacia
          END
      END
    END AS Var_AvalRFC,

CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
 CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(Idf.NumIdentific,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  Entero_Cero
              ELSE
                  Entero_Cero
          END
      END
    ELSE
     CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(Idf.NumIdentific,Cadena_Vacia)
      ELSE
            Entero_Cero

      END
    END AS Var_AvalFolioIden,

CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaFisica OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaFisica) OR (IFNULL(P.TipoPersona,Cadena_Vacia)  = PersonaFisica) THEN
 CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(C.Telefono,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(A.Telefono,Cadena_Vacia)
              ELSE
                  IFNULL(P.Telefono,Cadena_Vacia)
          END
      END
    ELSE
    Cadena_Vacia
    END AS Var_AvalTel,

CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaMoral OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaMoral) THEN
 CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(ECl.EscrituraPublic,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(EAv.EscrituraPublic,Cadena_Vacia)
              ELSE
                  Cadena_Vacia
          END
      END
    ELSE
    Cadena_Vacia
    END AS Var_EscrituraPublica,

CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaMoral OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaMoral) THEN
 CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(ECl.LibroEscritura,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(EAv.EscrituraPublic,Cadena_Vacia)
              ELSE
                  Cadena_Vacia
          END
      END
    ELSE
    Cadena_Vacia
    END AS Var_LibroEscritura,

CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaMoral OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaMoral) THEN
 CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(ECl.VolumenEsc,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(EAv.VolumenEsc,Cadena_Vacia)
              ELSE
                  Cadena_Vacia
          END
      END
    ELSE
    Cadena_Vacia
    END AS Var_VolumenEsc,
    CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaMoral OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaMoral) THEN
 CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(ECl.EstadoIDEsc,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(EAv.EstadoIDEsc,Cadena_Vacia)
              ELSE
                  Cadena_Vacia
          END
      END
    ELSE
    Cadena_Vacia
    END AS Var_EstadoEsc,
    CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaMoral OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaMoral) THEN
 CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(ECl.LocalidadEsc,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(EAv.LocalidadEsc,Cadena_Vacia)
              ELSE
                  Cadena_Vacia
          END
      END
    ELSE
    Cadena_Vacia
    END AS Var_LocalidadEsc,
    CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaMoral OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaMoral) THEN
 CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(ECl.FechaEsc,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(EAv.FechaEsc,Cadena_Vacia)
              ELSE
                  Cadena_Vacia
          END
      END
    ELSE
    Cadena_Vacia
    END AS Var_FechaEsc,
    CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaMoral OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaMoral) THEN
 CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(ECl.Notaria,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(EAv.Notaria,Cadena_Vacia)
              ELSE
                  Cadena_Vacia
          END
      END
    ELSE
    Cadena_Vacia
    END AS Var_Notaria,
    CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaMoral OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaMoral) THEN
 CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(ECl.DirecNotaria,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(EAv.DirecNotaria,Cadena_Vacia)
              ELSE
                  Cadena_Vacia
          END
      END
    ELSE
    Cadena_Vacia
    END AS Var_DirecNotaria,
    CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaMoral OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaMoral) THEN
 CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(ECl.NomNotario,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(EAv.NomNotario,Cadena_Vacia)
              ELSE
                  Cadena_Vacia
          END
      END
    ELSE
    Cadena_Vacia
    END AS Var_NomNotario,
CASE WHEN IFNULL(A.TipoPersona,Cadena_Vacia)  = PersonaMoral OR (IFNULL(C.TipoPersona,Cadena_Vacia)  = PersonaMoral) THEN
 CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <> Entero_Cero  THEN
          IFNULL(C.RazonSocial,Cadena_Vacia)
      ELSE
          CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                  IFNULL(A.RazonSocial,Cadena_Vacia)
              ELSE
                    IFNULL(P.RazonSocial,Cadena_Vacia)
          END
      END
    ELSE
    Cadena_Vacia
    END AS Var_RazonSocial

    FROM  AVALESPORSOLICI AP
        INNER JOIN    CREDITOS      Cre ON  Cre.SolicitudCreditoID  = AP.SolicitudCreditoID
        INNER JOIN    SOLICITUDCREDITO  Sol ON  Sol.SolicitudCreditoID  = AP.SolicitudCreditoID
        LEFT OUTER JOIN CLIENTES      Cc  ON  Cc.ClienteID      = Cre.ClienteID
        LEFT OUTER JOIN CLIENTES      C ON  C.ClienteID       = AP.ClienteID
        LEFT OUTER JOIN AVALES        A ON  A.AvalID        = AP.AvalID
        LEFT OUTER JOIN PROSPECTOS      P ON  P.ProspectoID     = AP.ProspectoID
        LEFT OUTER JOIN OCUPACIONES     Oc  ON  Oc.OcupacionID      = C.OcupacionID
        LEFT OUTER JOIN OCUPACIONES     Op  ON  Op.OcupacionID      = P.OcupacionID
        LEFT OUTER JOIN ACTIVIDADESBMX Abm ON Cc.ActividadBancoMX = Abm.ActividadBMXID
        LEFT OUTER JOIN SOCIODEMOCONYUG SdcC ON C.ClienteID        = SdcC.ClienteID
        LEFT OUTER JOIN SOCIODEMOCONYUG SdcP ON P.ProspectoID        = SdcP.ProspectoID
        LEFT OUTER JOIN IDENTIFICLIENTE Idf  ON C.ClienteID         =  Idf.ClienteID
        LEFT OUTER JOIN ESCRITURAPUB    ECl ON C.ClienteID  = ECl.ClienteID
        LEFT OUTER JOIN ESCPUBAVALES    EAv ON A.AvalID = EAv. AvalID
        LEFT OUTER JOIN DIRECCLIENTE    Dc  ON  Dc.ClienteID      = AP.ClienteID
                            AND Dc.Oficial        = DirOficial
        LEFT OUTER JOIN DIRECCLIENTE    Df  ON  Df.ClienteID      = AP.ClienteID
                            AND Df.Fiscal        = DirOficial
        LEFT OUTER JOIN LOCALIDADREPUB    LC  ON  LC.LocalidadID      = Dc.LocalidadID
                            AND LC.MunicipioID      = Dc.MunicipioID
                            AND LC.EstadoID       = Dc.EstadoID
        LEFT OUTER JOIN LOCALIDADREPUB    LA  ON  LA.LocalidadID      = A.LocalidadID
                            AND LA.MunicipioID      = A.MunicipioID
                            AND LA.EstadoID       = A.EstadoID
        LEFT OUTER JOIN LOCALIDADREPUB    LP  ON  LP.LocalidadID      = P.LocalidadID
                            AND LP.MunicipioID      = P.MunicipioID
                            AND LP.EstadoID       = P.EstadoID
        LEFT OUTER JOIN LOCALIDADREPUB LF ON LF.LocalidadID = Df.LocalidadID
                            AND LF.MunicipioID = Df.MunicipioID
                            AND LF.EstadoID =Df.EstadoID
        LEFT OUTER JOIN MUNICIPIOSREPUB    MC  ON  MC.MunicipioID      = Dc.MunicipioID
                            AND MC.EstadoID       = Dc.EstadoID
        LEFT OUTER JOIN MUNICIPIOSREPUB    MA  ON  MA.MunicipioID      = A.MunicipioID
                            AND MA.EstadoID       = A.EstadoID
        LEFT OUTER JOIN MUNICIPIOSREPUB    MP  ON  MP.MunicipioID      = P.MunicipioID
                            AND MP.EstadoID       = P.EstadoID
        LEFT OUTER JOIN MUNICIPIOSREPUB    MF  ON  MF.MunicipioID      = Df.MunicipioID
                            AND MF.EstadoID       = Df.EstadoID
        LEFT OUTER JOIN ESTADOSREPUB    EF  ON  EF.EstadoID       = Df.EstadoID
        LEFT OUTER JOIN ESTADOSREPUB    EC  ON  EC.EstadoID       = Dc.EstadoID
        LEFT OUTER JOIN ESTADOSREPUB    EA  ON  EA.EstadoID       = A.EstadoID
        LEFT OUTER JOIN ESTADOSREPUB    EP  ON  EP.EstadoID       = P.EstadoID
        LEFT OUTER JOIN PAISES          PC  ON  PC.PaisID = C.LugarNacimiento
      WHERE Cre.CreditoID = Par_CreditoID;


END IF;


IF(Par_TipoReporte = Tipo_AvalesContratAlternativa) THEN

DROP TABLE IF EXISTS TMPDATOSAVALESALTERNATIVA;
CREATE TEMPORARY TABLE TMPDATOSAVALESALTERNATIVA

SELECT
    CASE  WHEN  IFNULL(AP.ClienteID,Entero_Cero)  <>  Entero_Cero THEN
            C.NombreCompleto
        ELSE
            CASE  WHEN  IFNULL(AP.AvalID,Entero_Cero) <> Entero_Cero  THEN
                    A.NombreCompleto
                ELSE
                    P.NombreCompleto
            END
    END AS  AvalNombreCompleto

    FROM  AVALESPORSOLICI AP
        INNER JOIN    CREDITOS      Cre ON  Cre.SolicitudCreditoID  = AP.SolicitudCreditoID
        INNER JOIN    SOLICITUDCREDITO  Sol ON  Sol.SolicitudCreditoID  = AP.SolicitudCreditoID
        LEFT OUTER JOIN CLIENTES      Cc  ON  Cc.ClienteID      = Cre.ClienteID
        LEFT OUTER JOIN CLIENTES      C ON  C.ClienteID       = AP.ClienteID
        LEFT OUTER JOIN AVALES        A ON  A.AvalID        = AP.AvalID
        LEFT OUTER JOIN PROSPECTOS      P ON  P.ProspectoID     = AP.ProspectoID
      WHERE Cre.CreditoID = Par_CreditoID;


    SELECT GROUP_CONCAT(DISTINCT AvalNombreCompleto SEPARATOR ', ') AS AvalesNombre
    FROM TMPDATOSAVALESALTERNATIVA;



END IF;

IF(Par_TipoReporte = TipoZafy) THEN
    -- Datos de la Institucion
    SELECT I.Nombre,    I.NombreCorto,      I.DirFiscal,            I.RFC,              E.Nombre,
           M.Nombre,    L.NombreLocalidad,  P.NombreRepresentante,  P.TelefonoLocal,    P.BancoCaptacion

    INTO Var_NombreInstitucion, Var_NombreCorto,    Var_DirFiscalInstitucion, Var_RFCInstitucion,   Var_EstadoIns,
        Var_MuniInst,           Var_LocInst,        Var_RepresentanteLegal,     Var_TelefonoInst,   Var_BancoCaptacionID
        FROM PARAMETROSSIS P, INSTITUCIONES I
        LEFT OUTER JOIN ESTADOSREPUB E
        ON I.EstadoEmpresa = E.EstadoID
        LEFT OUTER JOIN MUNICIPIOSREPUB M
        ON E.EstadoID = M.EstadoID
            AND I.MunicipioEmpresa = M.MunicipioID
        LEFT OUTER JOIN LOCALIDADREPUB L
        ON E.EstadoID = L.EstadoID
            AND M.MunicipioID = L.MunicipioID
            AND I.LocalidadEmpresa = L.LocalidadID
        WHERE I.InstitucionID = P.InstitucionID;

        SET Var_BancoCaptacion := (SELECT Nombre
                                    FROM INSTITUCIONES
                                    WHERE InstitucionID = Var_BancoCaptacionID);

-- Datos unidad Especializada

SELECT E.DireccionUEAU, E.TelefonoUEAU, E.OtrasCiuUEAU, E.CorreoUEAU
    INTO Var_DirUEAU,   Var_TelefonoUEAU,   Var_TelOtrasCiuUEAU,    Var_CorreoUEAU
FROM EDOCTAPARAMS E, INSTITUCIONES I
WHERE E.InstitucionID = I.InstitucionID;

SET Var_TelefonoUEAU := CONCAT('(',SUBSTRING(Var_TelefonoUEAU,1,3),') ', SUBSTRING(Var_TelefonoUEAU,4,3),' ',SUBSTRING(Var_TelefonoUEAU,7,4));
SET Var_TelOtrasCiuUEAU := CONCAT('(01 ',SUBSTRING(Var_TelOtrasCiuUEAU,1,3),') ', SUBSTRING(Var_TelOtrasCiuUEAU,4,3),' ',SUBSTRING(Var_TelOtrasCiuUEAU,7,2),' ',SUBSTRING(Var_TelOtrasCiuUEAU,9,2));
SET Var_TelefonoInst := CONCAT('(',SUBSTRING(Var_TelefonoInst,1,3),') ', SUBSTRING(Var_TelefonoInst,4,3),' ',SUBSTRING(Var_TelefonoInst,7,4));


-- Datos del Credito

SELECT C.CreditoID,         C.ProductoCreditoID,    P.Descripcion,          P.Caracteristicas,      P.RegistroRECA,
       C.MontoCredito,      C.MontoComApert,        C.FechaInicio,          C.FechaMinistrado,      C.TasaFija,
       C.FactorMora,        C.TipCobComMorato,      P.TipoComXapert,        P.ProductoNomina,
       CASE P.TipoPrepago
                WHEN PagoCapital THEN PagoCapitalTxt
                WHEN CuotasInmediatas THEN CuotasInmediatasTxt
                WHEN ProrrateoPago THEN ProrrateoPagoTxt
                WHEN CuotaCompProyectada THEN CuotaCompProyectadaTxt

        END,
         P.MontoComXapert,  C.CobraSeguroCuota, C.PlazoID,          C.ValorCAT,         C.NumAmortizacion,
         C.FechaVencimien,  C.FechTraspasVenc,  C.MontoSeguroCuota, C.IVASeguroCuota

    INTO Var_CreditoID,     Var_ProducCreditoID,    Var_DescProducto,   Var_CarProd,            Var_NumRECA,
        Var_MontoCred,      Var_MontoComAp ,        Var_FechaInicio,    Var_FechaMinistrado,    TasaOrdinaria,
        Var_FactorMora,     Var_TipoCobroMoratorio, Var_ForCobComision, Var_EsNomina,            Var_ForCobPrepago,
        Var_ComisionApertura, Var_CobSegCuota,      Var_Plazo,          Var_CAT,                    Var_NumAmorti,
        Var_FechaVenc,      Var_FechaTraspVenc, Var_MontoSeguroCuota,   Var_IVASeguroCuota
        FROM CREDITOS C
        LEFT OUTER JOIN PRODUCTOSCREDITO P
        ON C.ProductoCreditoID = P.ProducCreditoID
        LEFT OUTER JOIN CREDITOSPLAZOS CP
        ON C.PlazoID = CP.PlazoID
        WHERE CreditoID = Par_CreditoID;

        -- Plazo Dias
        SET var_DiasPlazo := (SELECT DATEDIFF(Var_FechaVenc,Var_FechaInicio));

        -- COMISIONES

        SET Var_ComAnualidad        := IFNULL(Var_ComAnualidad, Entero_Cero);
        SET Var_ComRepTarjeta       := IFNULL(Var_ComRepTarjeta, Entero_Cero);
        SET Var_RecImp              := IFNULL(Var_RecImp, Entero_Cero);
        SET Var_ComAnualidadTxt     := IFNULL(Var_ComAnualidadTxt, Cadena_Vacia);
        SET Var_ComRepTarjetaTxt    := IFNULL('-', Cadena_Vacia);
        SET Var_RecImpTxt           := IFNULL(Var_RecImpTxt, Cadena_Vacia);
        SET Var_MontoSeguroCuota    := IFNULL(Var_MontoSeguroCuota, Decimal_Cero);
        SET Var_IVASeguroCuota      := IFNULL(Var_IVASeguroCuota, Decimal_Cero);

        SET Var_MontoSeguroCuota    := Var_MontoSeguroCuota*Var_NumAmorti;
        SET Var_IVASeguroCuota      := Var_IVASeguroCuota*Var_NumAmorti;

        IF(Var_ForCobComision = 'P')THEN
            SET Var_ComisionAperturaTxt := CONCAT(Var_ComisionApertura, ' %');
            ELSE
            SET Var_ComisionAperturaTxt := CONCAT('$ ', FORMAT(Var_ComisionApertura,2));
        END IF;
        SELECT SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres + IFNULL(Amo.MontoOtrasComisiones, Entero_Cero) + IFNULL(Amo.MontoIVAOtrasComisiones, Entero_Cero) + IFNULL(Amo.MontoIntOtrasComis, Entero_Cero) + IFNULL(Amo.MontoIVAIntComisi,Entero_Cero)) INTO Var_TotPagar
        FROM CREDITOS Cre,
             AMORTICREDITO Amo
        WHERE Cre.CreditoID   = Par_CreditoID
          AND Amo.CreditoID = Cre.CreditoID;

        SET Var_TotPagar := Var_TotPagar+Var_MontoSeguroCuota+Var_IVASeguroCuota;

        SET MontoPagotxt := CONVPORCANT(Var_TotPagar,'$', 'Peso', 'Nacional');
        SET Var_MontoCredito := CONVPORCANT(Var_MontoCred,'$', 'Peso', 'Nacional');

         IF(Var_TipoCobroMoratorio = NVecesTasaOrd) THEN
            SET Var_TasaMoratoria   :=  ROUND(Var_FactorMora*TasaOrdinaria,2);
            ELSE
            SET Var_TasaMoratoria   :=  ROUND(Var_FactorMora,2);
        END IF;

         SELECT  prod.CobraFaltaPago, prod.CriterioComFalPag, prod.TipCobComFalPago, prod.PerCobComFalPag
          INTO Var_CobraFaltaPago, Var_CriterioComFalPago, Var_TipCobComFalPago, Var_PerCobComFalPago
          FROM PRODUCTOSCREDITO AS prod, CREDITOS cr
          WHERE prod.ProducCreditoID=cr.ProductoCreditoID
            AND cr.CreditoID = Var_CreditoID;

        IF (Var_CobraFaltaPago = SiCobraFaltaPago) THEN

            SELECT  COM.TipoComision, COM.Comision
            INTO Var_TipoComision, Var_MontoComisionFalPag
            FROM ESQUEMACOMISCRE AS COM
            INNER JOIN CREDITOS AS CRE ON CRE.ProductoCreditoID = COM.ProducCreditoID
            WHERE Var_MontoCred BETWEEN COM.MontoInicial    AND COM.MontoFinal
                                    AND CRE.ProductoCreditoID = Var_ProducCreditoID
                                    AND CRE.CreditoID = Var_CreditoID;

            IF (Var_TipoComision = ComisionMonto) THEN
              SET Var_ComisionCobranzaTxt := CONCAT('$ ', CAST(FORMAT(Var_MontoComisionFalPag,2) AS CHAR), ' (', TRIM(FUNCIONNUMLETRAS(Var_MontoComisionFalPag)), ')');
            ELSE
              SET Var_ComisionCobranzaTxt := CONCAT(CAST(Var_MontoComisionFalPag AS CHAR), ' % (', FUNCIONNUMEROSLETRAS(Var_MontoComisionFalPag), ' Porciento)');
            END IF;

        END IF;


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
                WHEN Var_Frecuencia = FrecSemanal   THEN TxtSemanas
                WHEN Var_Frecuencia =FrecCatorcenal   THEN TxtCatorcenas
                WHEN Var_Frecuencia =FrecQuincenal  THEN TxtQuincenas
                WHEN Var_Frecuencia =FrecMensual    THEN TxtMeses
                WHEN Var_Frecuencia =FrecPeriodica  THEN TxtPeriodos
                WHEN Var_Frecuencia =FrecBimestral  THEN TxtBimestres
                WHEN Var_Frecuencia =FrecTrimestral   THEN TxtTrimestres
                WHEN Var_Frecuencia =FrecTetramestral THEN TxtTetramestres
                WHEN Var_Frecuencia =FrecSemestral  THEN TxtSemestres
                WHEN Var_Frecuencia =FrecAnual    THEN TxtAnios
                WHEN Var_Frecuencia =FrecLibre    THEN TxtLibres
                WHEN Var_Frecuencia =FrecUnico    THEN TxtUnico
                WHEN Var_Frecuencia =FrecDecenal    THEN TxtDecenas
                ELSE Cadena_Vacia
            END
            INTO Var_FrecuenciaTxt
            FROM CREDITOS
           WHERE CreditoID = Par_CreditoID;

        -- Datos del Cliente
        SELECT CL.ClienteID,    CL.NombreCompleto,  CL.TipoPersona,     CL.TelTrabajo,      CL.ExtTelefonoTrab
            INTO Var_ClienteID, Var_NombreCompleto, Var_TipoPersona,    Var_TelTrabCliente, Var_ExtTelCliente
                    FROM CLIENTES CL
                    INNER JOIN CREDITOS C ON CL.ClienteID = C.ClienteID
                    WHERE C.CreditoID = Par_CreditoID;

        IF(Var_TipoPersona = PersonaMoral)THEN
            SELECT C.RazonSocial, C.RFCpm, E.EscrituraPublic, M.Nombre, E.Notaria,
                    E.NomNotario
                    INTO Var_RazonSocialCli ,Var_RFCpm, Cli_NumEscPConstitutiva, Var_MunicipioEscPub,Cli_NumeroNotarioEscPConstitutiva,
                        Cli_NombreNotarioEscPConstitutiva
            FROM CLIENTES C
            INNER JOIN ESCRITURAPUB E ON C.ClienteID = E.ClienteID
            INNER JOIN MUNICIPIOSREPUB M ON E.EstadoIDEsc = M.EstadoID AND E.LocalidadEsc = M.MunicipioID
                WHERE C.ClienteID = Var_ClienteID
                AND E.Esc_Tipo = ActaConstitutiva
                LIMIT 1;

       SELECT E.RegistroPub INTO Cli_NumeroEscPPoderes
        FROM CLIENTES C
        INNER JOIN ESCRITURAPUB E ON C.ClienteID = E.ClienteID
        WHERE C.ClienteID = Var_ClienteID
        AND E.Esc_Tipo = ActaPoderes
        LIMIT 1;

        END  IF;

        IF(Var_EsNomina = Constante_SI)THEN
            SELECT CL.NoEmpleado, I.NombreInstit
                INTO Var_NumEmpleado,Var_EmpresaNomina
                    FROM CLIENTES CL
                    INNER JOIN CREDITOS C ON CL.ClienteID = C.ClienteID
                    INNER JOIN SOLICITUDCREDITO S ON C.SolicitudCreditoID = S.SolicitudCreditoID
                    INNER JOIN INSTITNOMINA I ON S.InstitucionNominaID = I.InstitNominaID
                    WHERE C.CreditoID = Par_CreditoID;
        ELSE
            SET Var_NumEmpleado:= IFNULL(Var_NumEmpleado, Cadena_Vacia);
            SET Var_EmpresaNomina:= IFNULL(Var_EmpresaNomina, Cadena_Vacia);
        END IF;
        SET Var_TitularUEAU:= IFNULL(Var_TitularUEAU,Cadena_Vacia);

        SELECT Var_ClienteID,       Var_NombreCompleto,     Var_TipoPersona,            Var_NumEmpleado,        Var_TelTrabCliente,
            Var_ExtTelCliente,      Var_EmpresaNomina,      Var_NombreInstitucion,      Var_NombreCorto,        Var_DirFiscalInstitucion,
            Var_RFCInstitucion,     Var_EstadoIns,          Var_MuniInst,               Var_LocInst,            Var_RepresentanteLegal,
            Var_TelefonoInst,       Var_BancoCaptacion,     Var_TitularUEAU,            Var_DirUEAU,            Var_TelefonoUEAU,
            Var_TelOtrasCiuUEAU,    Var_CorreoUEAU,         Var_CreditoID,              Var_ProducCreditoID,    Var_EsNomina,
            Var_DescProducto,       Var_CarProd,            Var_NumRECA,                Var_MontoCredito,       Var_MontoCred,
            Var_TotPagar,           MontoPagotxt,           Var_FechaInicio,            Var_FechaMinistrado,    FORMAT(TasaOrdinaria,2) AS TasaOrdinaria,
            Var_FactorMora,         ROUND(Var_TasaMoratoria) AS Var_TasaMoratoria,      Var_ComisionAperturaTxt,
            CONVPORCANT(Var_MontoComAp,'$', 'Peso', 'Nacional') AS MontoComApTxt,
            Var_ComAnualidad,       Var_ComRepTarjeta,      Var_ComRepTarjetaTxt,       Var_RecImp,             Var_ForCobPrepago,
            Var_CobSegCuota,        CONCAT('$ ',FORMAT(Var_ComisionCobranza,2)) AS Var_ComisionCobranza,
            Var_ComisionCobranzaTxt,
            Var_Plazo,              var_DiasPlazo, ROUND(Var_CAT,2) AS Var_CAT,         Var_NumAmorti,          Var_FrecuenciaTxt,
            Var_FechaVenc,          Var_FechaTraspVenc,     Var_RazonSocialCli ,        Var_RFCpm,              Cli_NumEscPConstitutiva,
            Var_MunicipioEscPub,    Cli_NumeroNotarioEscPConstitutiva,                  Cli_NombreNotarioEscPConstitutiva,
            Cli_NumeroEscPPoderes;
END IF;


IF(Par_TipoReporte = Garantia_Hipotecaria) THEN
    SELECT SolicitudCreditoID  INTO  Var_SolicitudCredID
      FROM CREDITOS
      WHERE Par_CreditoID = CreditoID;

    SELECT  Gar.NotarioID AS GarHip_Hipo, CONCAT(Tg.Descripcion) AS GarHip_Desc, Gar.FolioRegistro AS GarHip_Ref,
            CONCAT(Tg.Descripcion) AS Var_GarHipDesc, Gar.ValorComercial AS Var_ValComGarHipo,
            Gar.GarantiaID AS Var_FolioGarHipo

      FROM
        GARANTIAS     Gar,
        ASIGNAGARANTIAS Asi,
        CLASIFGARANTIAS Cg,
        TIPOGARANTIAS Tg,
        TIPOSDOCUMENTOS Td
           WHERE (CASE WHEN IFNULL( Asi.CreditoID, Entero_Cero) = Entero_Cero
            THEN Asi.SolicitudCreditoID = Var_SolicitudCredID
              ELSE  Asi.CreditoID = Par_CreditoID
            END)
        AND Asi.GarantiaID    =Gar.GarantiaID

        AND Gar.TipoDocumentoID = Td.TipoDocumentoID
        AND Gar.TipoGarantiaID  =TipoGarantiaInmob
        AND Cg.ClasifGarantiaID = Gar.ClasifGarantiaID
        AND Cg.TipoGarantiaID = Gar.TipoGarantiaID
        AND Tg.TipoGarantiasID  = Gar.TipoGarantiaID;

END IF;
IF(Par_TipoReporte = Garantia_Real) THEN
    SELECT SolicitudCreditoID  INTO  Var_SolicitudCredID
      FROM CREDITOS
      WHERE Par_CreditoID = CreditoID;
    SELECT  Gar.SerieFactura AS Var_SerieFactura , CONCAT(Tg.Descripcion) AS GarReal_Desc,
            Gar.ReferenFactura AS GarReal_Ref,  Cla.Descripcion AS Var_GarRealDesc,
            Gar.ValorComercial AS Var_ValComGarReal, Gar.GarantiaID AS Var_FolioGarReal
      FROM
        GARANTIAS Gar,
        ASIGNAGARANTIAS   Asi ,
        CLASIFGARANTIAS   Cla,
         TIPOGARANTIAS Tg
         WHERE (CASE WHEN IFNULL( Asi.CreditoID, Entero_Cero) = Entero_Cero
            THEN Asi.SolicitudCreditoID = Var_SolicitudCredID
              ELSE  Asi.CreditoID = Par_CreditoID
            END)
      AND Asi.GarantiaID      = Gar.GarantiaID
      AND Gar.TipoGarantiaID  =TipoGarantiaMob
      AND Cla.TipoGarantiaID    = Gar.TipoGarantiaID
      AND Cla.ClasifGarantiaID  = Gar.ClasifGarantiaID
      AND Cla.TipoGarantiaID = Gar.TipoGarantiaID
      AND Tg.TipoGarantiasID  = Gar.TipoGarantiaID
      AND Cla.EsGarantiaReal    =  Constante_SI;

END IF;

IF(Par_TipoReporte = Garantia_Liquida) THEN

    SELECT ProductoCreditoID, Estatus INTO Var_ProductoCreditoID, Var_Estatus
     FROM CREDITOS
     WHERE CreditoID = Par_CreditoID;

    SELECT COUNT(ProducCreditoID) INTO NumRegGarLiq
     FROM ESQUEMAGARANTIALIQ
      WHERE ProducCreditoID = Var_ProductoCreditoID;

    IF (NumRegGarLiq > Entero_Cero) THEN
        SET Var_ReqGarLiq := Constante_SI;
    ELSE
        SET Var_ReqGarLiq := Constante_NO;
    END IF;

    IF (Var_ReqGarLiq = Constante_SI) THEN
        SELECT SUM(CASE WHEN Blo.NatMovimiento = Bloqueado
                        THEN IFNULL(Blo.MontoBloq,Decimal_Cero)
                    ELSE IFNULL(Blo.MontoBloq,Decimal_Cero)  * -1
                END) AS MontoGa,  tc.Descripcion,   Blo.CuentaAhoID
                    INTO  Var_MontoGarLiq,GarLiq_Desc,  GarLiq_Ref
        FROM  BLOQUEOS    Blo
        INNER JOIN CUENTASAHO Cu
            ON Blo.CuentaAhoID = Cu.CuentaAhoID
        INNER JOIN TIPOSCUENTAS tc
            ON Cu.TipoCuentaID = tc.TipoCuentaID
        WHERE   Blo.TiposBloqID = TipoBloqueado
            AND   Blo.Referencia  = Par_CreditoID
        GROUP BY Blo.Referencia,  tc.Descripcion,   Blo.CuentaAhoID;


        IF(Var_MontoGarLiq <= Entero_Cero) THEN
            SET Var_MonGarLiq := Cadena_Vacia;
            SET GarLiq_Desc := Cadena_Vacia;
            SET GarLiq_Ref := Cadena_Vacia;
        ELSE
            SET Var_MonGarLiq := CONCAT('$ ',FORMAT(Var_MontoGarLiq,2));
        END IF;


        IF(Var_Estatus != Est_Pagado) THEN
            SET Var_MontoGarLiq := IFNULL(Var_MontoGarLiq,Decimal_Cero) + IFNULL((SELECT SUM(MontoEnGar) FROM CREDITOINVGAR  WHERE CreditoID = Par_CreditoID),Decimal_Cero);
        ELSE
            SET Var_MontoGarLiq := IFNULL(Var_MontoGarLiq,Decimal_Cero) + IFNULL((SELECT SUM(MontoEnGar) FROM HISCREDITOINVGAR  WHERE CreditoID = Par_CreditoID),Decimal_Cero);
        END IF;

        SET Var_MonGarLiq := CONCAT('$ ',FORMAT(Var_MontoGarLiq,2));

        IF(IFNULL(GarLiq_Desc,Cadena_Vacia) = Cadena_Vacia AND Var_MontoGarLiq > Entero_Cero) THEN
            SET GarLiq_Desc :='INVERSION EN GARANTIA';
            IF(Var_Estatus != Est_Pagado) THEN
                SET GarLiq_Ref := (SELECT InversionID FROM CREDITOINVGAR  WHERE CreditoID = Par_CreditoID LIMIT 1);
            ELSE
                SET GarLiq_Ref := (SELECT InversionID FROM HISCREDITOINVGAR  WHERE CreditoID = Par_CreditoID LIMIT 1);
            END IF;
        END IF;
    END IF;
    SELECT Var_MonGarLiq,GarLiq_Desc,  GarLiq_Ref;
END IF;
IF(Par_TipoReporte = Secc_Garante) THEN

    DROP TABLE IF EXISTS TEMP_GARANTES;
    CREATE TEMPORARY TABLE TEMP_GARANTES(
        Garante         VARCHAR(300),
        ClienteID       INT(11),
        KEY(ClienteID)
    );

    -- INSERTA GARANTES QUE SON CLIENTES
    INSERT INTO TEMP_GARANTES(
    SELECT Cli.NombreCompleto, IFNULL(Gar.ClienteID,Entero_Cero)
        FROM    ASIGNAGARANTIAS Asi
        INNER JOIN SOLICITUDCREDITO Sol ON Asi.SolicitudCreditoID = Sol.SolicitudCreditoID
        INNER JOIN GARANTIAS Gar ON Asi.GarantiaID = Gar.GarantiaID
        INNER JOIN CLIENTES Cli ON Cli.ClienteID = Gar.ClienteID
        WHERE   Sol.CreditoID = Par_CreditoID);


    -- INSERTA GARANTES QUE SON AVALES
    INSERT INTO TEMP_GARANTES(
    SELECT Ava.NombreCompleto, Entero_Cero
        FROM    ASIGNAGARANTIAS Asi
        INNER JOIN SOLICITUDCREDITO Sol ON Asi.SolicitudCreditoID = Sol.SolicitudCreditoID
        INNER JOIN GARANTIAS Gar ON Asi.GarantiaID = Gar.GarantiaID
        INNER JOIN AVALES Ava ON Ava.AvalID = Gar.AvalID
        WHERE Sol.CreditoID = Par_CreditoID);


    -- GARANTES QUE SON PROSPECTOS
    INSERT INTO TEMP_GARANTES(
    SELECT Pro.NombreCompleto,IFNULL(Pro.ClienteID,Entero_Cero)
        FROM    ASIGNAGARANTIAS Asi
        INNER JOIN SOLICITUDCREDITO Sol ON Asi.SolicitudCreditoID = Sol.SolicitudCreditoID
        INNER JOIN GARANTIAS Gar ON Asi.GarantiaID = Gar.GarantiaID
        INNER JOIN PROSPECTOS Pro ON Gar.ProspectoID = Pro.ProspectoID AND Gar.ClienteID = Entero_Cero
        WHERE Sol.CreditoID = Par_CreditoID);

    -- GARANTES QUE NO SON CLIENTE NI PROPSECTOS
    INSERT INTO TEMP_GARANTES(
    SELECT Gar.GaranteNombre,Entero_Cero
        FROM    ASIGNAGARANTIAS Asi
        INNER JOIN SOLICITUDCREDITO Sol ON Asi.SolicitudCreditoID = Sol.SolicitudCreditoID
        INNER JOIN GARANTIAS Gar ON Asi.GarantiaID = Gar.GarantiaID
        AND Gar.ClienteID = Entero_Cero AND Gar.AvalID = Entero_Cero
        AND Gar.ProspectoID = Entero_Cero
        WHERE Sol.CreditoID = Par_CreditoID);


    SELECT  @s:=@s+1 AS Num, Garante AS GaranteNombre
    FROM TEMP_GARANTES tmp,
    (SELECT @s:= Entero_Cero) AS s;

END IF;
IF(Par_TipoReporte = TipoAsefimex) THEN
	SELECT Edo.Nombre ,Mu.Nombre INTO Var_NombreEstadom,Var_NombreMuni
  FROM  SUCURSALES Suc,
  ESTADOSREPUB Edo,
  USUARIOS  Usu,
                MUNICIPIOSREPUB Mu
  WHERE UsuarioID =Aud_Usuario
  AND Edo.EstadoID  = Suc.EstadoID
  AND Usu.SucursalUsuario= Suc.SucursalID
        AND Mu.MunicipioID=Suc.MunicipioID
        AND Edo.EstadoID = Mu.EstadoID;

    SET Var_TasaAnual   := Entero_Cero;
    SET Var_TasaMens    := Entero_Cero;
    SET Var_TasaFlat    := Entero_Cero;
    SET Var_MontoSeguro := Entero_Cero;
    SET Var_PorcCobert  := Entero_Cero;

	SELECT  TasaFija, CreditoID,  NumAmortizacion,  MontoCredito,
	  PeriodicidadInt,  FrecuenciaInt,  FrecuenciaCap,  MontoSeguroVida,
	  FactorMora,		FechaInicioAmor
  INTO  Var_TasaAnual,  Var_CreditoID,  Var_NumAmorti,      Var_MontoCred,
	  Var_Periodo,        Var_FrecuenciaInt,  Var_Frecuencia,   Var_MontoSeguro,
	  Var_TasaMoraAnual,	Var_FechaInicioAmort
  FROM CREDITOS
  WHERE CreditoID=Par_CreditoID;

    SET Var_TasaAnual   := IFNULL(Var_TasaAnual, Entero_Cero);
    SET Var_CreditoID   := IFNULL(Var_CreditoID, Entero_Cero);
    SET Var_NumAmorti   := IFNULL(Var_NumAmorti, Entero_Cero);
    SET Var_TasaMoraAnual   := IFNULL(Var_TasaMoraAnual, Entero_Cero);
    SET Var_FechaInicioAmort := (IFNULL(Var_FechaInicioAmort, Fecha_Vacia));

    SET Var_TasaMens    := ROUND(Var_TasaAnual / 12, 4);

	SET Var_TasaMoratoria   := ROUND( Var_TasaAnual * Var_TasaMoraAnual, 2);
    SET Var_TasaMensMora    := ROUND(Var_TasaMoratoria / 12, 4);

    SELECT  SUM(Amo.Interes) INTO Var_TotInteres
        FROM AMORTICREDITO Amo
        WHERE Amo.CreditoID = Par_CreditoID;

    SET  Var_NumAmorti := IFNULL(Var_NumAmorti, Entero_Cero);
    SET  Var_MontoCred := IFNULL(Var_MontoCred, Entero_Cero);

    SET Var_TotInteres  := IFNULL(Var_TotInteres, Entero_Cero);

    SELECT Cre.ValorCAT,  ROUND(Cre.PorcGarLiq,2), Pro.FactorRiesgoSeguro, Pro.RegistroRECA, Cre.FechaVencimien,
           CONCAT(Cli.PrimerNombre,
                    (CASE WHEN IFNULL(Cli.SegundoNombre, '') != '' THEN CONCAT(' ', Cli.SegundoNombre)
                          ELSE Cadena_Vacia
                     END),
                   (CASE WHEN IFNULL(Cli.TercerNombre, '') != '' THEN  CONCAT(' ', Cli.TercerNombre)
                         ELSE Cadena_Vacia
                    END), ' ',
                  Cli.ApellidoPaterno, ' ', Cli.ApellidoMaterno),Pro.Descripcion,Pro.CobraMora,
    Pro.FactorMora,Pro.RequiereGarantia,Cli.ClienteID,Dir.DireccionCompleta,
    Cre.CreditoID,Gar.TipoGarantiaID, Gar.TipoDocumentoID,	Pro.ProductoNomina,
    Cli.AntiguedadTra
  INTO Var_CAT,      Var_PorcGarLiq,  Var_FacRiesgo,  Var_NumRECA,    Var_FechaVenc,
   Var_NomRepres,Var_DescProducto,Var_CobraMora,  Var_FactorMora, Var_ReqGarantia,
   Var_Cliente,  Var_DireccionCompleta, Var_Credito, Var_TipoGarantia, Var_TipoDocumento,
   Var_EsNomina,	Var_AntiguedadLab

       FROM CREDITOS Cre
        INNER JOIN PRODUCTOSCREDITO Pro   ON Pro.ProducCreditoID = Cre.ProductoCreditoID
        INNER JOIN CLIENTES Cli       ON Cli.ClienteID = Cre.ClienteID
        INNER JOIN DIRECCLIENTE Dir     ON Dir.ClienteID = Cre.ClienteID
    LEFT JOIN ASIGNAGARANTIAS Asi     ON Asi.SolicitudCreditoID = Cre.SolicitudCreditoID
        LEFT JOIN GARANTIAS Gar       ON Gar.GarantiaID = Asi.GarantiaID
  WHERE Cre.CreditoID =Var_CreditoID
  AND Dir.Oficial=DirOficial
  LIMIT 1;

  SELECT P.Nombre
  INTO Var_LugarNacimiento
  FROM CLIENTES C, PAISES P
  WHERE C.LugarNacimiento = P.PaisID AND C.ClienteID = Var_Cliente;

  SELECT P.Nombre,C.FechaNacimiento, O.Descripcion, C.RFC,
            CASE C.EstadoCivil
                WHEN EstSoltero THEN TxtSoltero
                WHEN EstCasBienSep THEN TextoCasado
                WHEN EstCasBienMan THEN TextoCasado
                WHEN EstcasBienManCap THEN TextoCasado
                WHEN EstViudo THEN TxtViudo
                WHEN EstDivorciado THEN TxtDivorciado
                WHEN EstSeparado THEN TxtSeparado
                WHEN EsteUnionLibre THEN TxteUnionLibre
            END
    INTO Var_LugarNacimiento, Var_FechaNacimiento, Var_Ocupacion, Var_RFC, Var_EstadoCivil
  FROM CLIENTES C, PAISES P, OCUPACIONES O
  WHERE C.LugarNacimiento = P.PaisID AND O.OcupacionID = C.OcupacionID AND C.ClienteID =Var_Cliente;

DROP TABLE IF EXISTS  TMPGARANTIA;
CREATE TEMPORARY TABLE TMPGARANTIA(
  Folio INT AUTO_INCREMENT,
    Tmp_Garantia        INT(11),
  Tmp_TipoDocumento   INT(11),
  Tmp_Monto           DECIMAL(14,2),
  Tmp_Valor     DECIMAL(14,2),
  PRIMARY KEY (Folio)
);

OPEN CURSORGARANTIAS;
BEGIN
  DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
  LOOP

    FETCH CURSORGARANTIAS INTO
  Var_TipoGarantia, Var_TipoDocumento, Var_MontoAsignado, Var_ValorComercial;
  INSERT INTO TMPGARANTIA (Tmp_Garantia,  Tmp_TipoDocumento,  Tmp_Monto,  Tmp_Valor)
  VALUES  (Var_TipoGarantia,  Var_TipoDocumento,  Var_MontoAsignado,  Var_ValorComercial);

  END LOOP;
END;

CLOSE CURSORGARANTIAS;
  SELECT  MAX(Tmp_Monto), MAX(Tmp_Valor) INTO
  Var_MontoMax, Var_ValorMax
  FROM TMPGARANTIA;

IF EXISTS (SELECT MAX(Folio) FROM TMPGARANTIA
  WHERE Tmp_Monto=Var_MontoMax
   HAVING COUNT(Folio) > 1
)THEN

  IF EXISTS (SELECT MAX(Folio) FROM TMPGARANTIA
    WHERE Tmp_Valor=Var_ValorMax
    HAVING COUNT(Folio) > 1
)THEN
    IF EXISTS (SELECT * FROM TMPGARANTIA
      WHERE Tmp_TipoDocumento=TipoDocumConstancia)THEN
      SELECT  Tmp_Garantia, Tmp_TipoDocumento,   Tmp_Monto,   Tmp_Valor
      INTO  Var_TipoGar,  Var_TipoDoc,   Var_Monto,   Var_Comercial
      FROM TMPGARANTIA
      WHERE Tmp_TipoDocumento=TipoDocumConstancia
      LIMIT 1;
    END IF;

    IF EXISTS (SELECT * FROM TMPGARANTIA
      WHERE Tmp_TipoDocumento=TipoDocumActa)THEN
      SELECT Tmp_Garantia,  Tmp_TipoDocumento,  Tmp_Monto,  Tmp_Valor
      INTO   Var_TipoGar, Var_TipoDoc,  Var_Monto,  Var_Comercial
      FROM TMPGARANTIA
      WHERE Tmp_TipoDocumento=TipoDocumActa
      LIMIT 1;
    END IF;

    IF EXISTS (SELECT * FROM TMPGARANTIA
      WHERE Tmp_TipoDocumento=TipoDocumTestimonio)THEN
      SELECT Tmp_Garantia,  Tmp_TipoDocumento,  Tmp_Monto,  Tmp_Valor
      INTO   Var_TipoGar,   Var_TipoDoc,  Var_Monto,  Var_Comercial
      FROM TMPGARANTIA
      WHERE Tmp_TipoDocumento=TipoDocumTestimonio
      LIMIT 1;
    END IF;

    IF (IFNULL(Var_TipoGar,Entero_Cero)=Entero_Cero AND IFNULL(Var_TipoDoc,Entero_Cero)=Entero_Cero)THEN
      SELECT Tmp_Garantia,  Tmp_TipoDocumento,  Tmp_Monto,  Tmp_Valor
      INTO Var_TipoGar, Var_TipoDoc,    Var_Monto,  Var_Comercial
      FROM TMPGARANTIA
      LIMIT 1;
    END IF;

    ELSE
    SELECT Tmp_Garantia,  Tmp_TipoDocumento,  Tmp_Monto,  Tmp_Valor
    INTO   Var_TipoGar,     Var_TipoDoc,  Var_Monto,  Var_Comercial
    FROM TMPGARANTIA
    WHERE Tmp_Valor=Var_ValorMax;
  END IF;
ELSE
  SELECT Tmp_Garantia,  Tmp_TipoDocumento,  Tmp_Monto,  Tmp_Valor
  INTO   Var_TipoGar, Var_TipoDoc,  Var_Monto,  Var_Comercial
  FROM TMPGARANTIA
  WHERE Tmp_Monto=Var_MontoMax;
END IF;

    SET Var_CAT  := IFNULL(Var_CAT, Entero_Cero);
    SET Var_PorcGarLiq  := IFNULL(Var_PorcGarLiq, Entero_Cero);
    SET Var_FacRiesgo  := IFNULL(Var_FacRiesgo, Entero_Cero);

  SELECT TipoPagoCapital INTO Var_TipoPagoCap
  FROM CREDITOS
  WHERE CreditoID=Par_CreditoID;


	 IF(Var_TipoPagoCap = Tipo_PagoIgual) THEN
		SET Var_MontoDesQuinc := (SELECT Capital FROM AMORTICREDITO WHERE AmortizacionID = 1 AND CreditoID = Par_CreditoID);
    ELSE
		SET Var_MontoDesQuinc := (SELECT MAX(Capital) FROM AMORTICREDITO WHERE CreditoID = Par_CreditoID);
    END IF;

    SET Var_MontoDesQuinc := IFNULL(Var_MontoDesQuinc, Decimal_Cero);
    SET Var_MontoDesQuincLetra := (SELECT FUNCIONNUMLETRAS(Var_MontoDesQuinc));
    SET Var_MontoDesQuincLetra := CONCAT('$ ', FORMAT(Var_MontoDesQuinc, 2), ', (', Var_MontoDesQuincLetra, ' M.N.)');

  IF(Var_TipoPagoCap=Tipo_PagoLibre OR Var_FrecuenciaInt != Var_Frecuencia)THEN
  SET Var_DesFrecLet = TxtMixtas;
  ELSE
    SELECT  CASE
                WHEN Var_Frecuencia =FrecSemanal    THEN TxtSemanal
                WHEN Var_Frecuencia =FrecCatorcenal   THEN TxtCatorcenal
                WHEN Var_Frecuencia =FrecQuincenal    THEN TxtQuincenal
                WHEN Var_Frecuencia =FrecMensual    THEN TxtMensual
                WHEN Var_Frecuencia =FrecPeriodica    THEN TxtPeriodica
                WHEN Var_Frecuencia =FrecBimestral    THEN TxtBimestral
                WHEN Var_Frecuencia =FrecTrimestral   THEN TxtTrimestral
                WHEN Var_Frecuencia =FrecTetramestral   THEN TxtTetramestral
                WHEN Var_Frecuencia =FrecSemestral    THEN TxtSemestral
                WHEN Var_Frecuencia =FrecAnual      THEN TxtAnual
        WHEN Var_Frecuencia =FrecDecenal    THEN TxtDecenal
            END INTO Var_DesFrec;

    SET Var_DesFrec     := IFNULL(Var_DesFrec, Cadena_Vacia);

    SELECT  CONCAT(CONVERT(Var_NumAmorti, CHAR), ' ' ,
            CASE
                WHEN Var_Frecuencia =FrecSemanal      THEN TxtSemanas
                WHEN Var_Frecuencia =FrecCatorcenal   THEN TxtCatorcenas
                WHEN Var_Frecuencia =FrecQuincenal    THEN TxtQuincenas
                WHEN Var_Frecuencia =FrecMensual    THEN TxtMeses
                WHEN Var_Frecuencia =FrecPeriodica    THEN TxtPeriodos
                WHEN Var_Frecuencia =FrecBimestral    THEN TxtBimestres
                WHEN Var_Frecuencia =FrecTrimestral   THEN TxtTrimestres
                WHEN Var_Frecuencia =FrecTetramestral   THEN TxtTetramestres
                WHEN Var_Frecuencia =FrecSemestral    THEN TxtSemestres
                WHEN Var_Frecuencia =FrecAnual      THEN TxtAnios
                WHEN Var_Frecuencia =FrecUnico      THEN TxtUnico
        WHEN Var_Frecuencia =FrecDecenal    THEN TxtDecenas
            END ) INTO Var_Plazo;
    SELECT  CASE
                WHEN Var_Frecuencia =FrecSemanal THEN TxtSemanales
                WHEN Var_Frecuencia =FrecCatorcenal   THEN TxtCatorcenales
                WHEN Var_Frecuencia =FrecQuincenal    THEN TxtQuincenales
                WHEN Var_Frecuencia =FrecMensual    THEN TxtMensuales
                WHEN Var_Frecuencia =FrecPeriodica    THEN TxtPeriodos
                WHEN Var_Frecuencia =FrecBimestral    THEN TxtBimestrales
                WHEN Var_Frecuencia =FrecTrimestral   THEN TxtTrimestrales
                WHEN Var_Frecuencia =FrecTetramestral   THEN TxtTetramestrales
                WHEN Var_Frecuencia =FrecSemestral    THEN TxtSemestrales
                WHEN Var_Frecuencia =FrecAnual      THEN TxtAnuales
        WHEN Var_Frecuencia =FrecDecenal    THEN TxtDecenales

            END INTO Var_DesFrecLet;
 END IF;
  SELECT COUNT(CreditoID) INTO Var_NumCuotas
  FROM AMORTICREDITO Amo
  WHERE Amo.CreditoID = Par_CreditoID;

    SET Var_MontoSeguro := IFNULL(Var_MontoSeguro, Entero_Cero);
    SET Var_MontoGarLiq := ROUND(Var_MontoCred * Var_PorcGarLiq / 100, 2);
   SET Var_MonGarLiq  := FORMAT(Var_MontoGarLiq,2);

    SELECT SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres) INTO Var_TotPagar
        FROM CREDITOS Cre,
             AMORTICREDITO Amo
        WHERE Cre.CreditoID   = Par_CreditoID
          AND Amo.CreditoID = Cre.CreditoID;

    SET Var_TotPagar    := IFNULL(Var_TotPagar, Entero_Cero);

    SELECT FUNCIONNUMLETRAS(Var_TotPagar) INTO Var_TotPagLetra;
    SELECT FUNCIONNUMLETRAS(Var_MontoCred) INTO Var_MtoLetra;
    SELECT FUNCIONNUMLETRAS(Var_MontoGarLiq) INTO Var_GarantiaLetra;

    SELECT  CASE
                WHEN Var_Frecuencia =FrecSemanal THEN TxtSemana
                WHEN Var_Frecuencia =FrecCatorcenal THEN TxtCatorcena
                WHEN Var_Frecuencia =FrecQuincenal THEN TxtQuincena
                WHEN Var_Frecuencia =FrecMensual THEN TxtMes
                WHEN Var_Frecuencia =FrecPeriodica THEN TxtPeriodo
                WHEN Var_Frecuencia =FrecBimestral THEN TxtBimestre
                WHEN Var_Frecuencia =FrecTrimestral THEN TxtTrimestre
                WHEN Var_Frecuencia =FrecTetramestral THEN TxtTetramestre
                WHEN Var_Frecuencia =FrecSemestral THEN TxtSemestre
                WHEN Var_Frecuencia =FrecAnual THEN TxtAnio
        WHEN Var_Frecuencia =FrecDecenal THEN TxtDecenal


            END  INTO Var_FrecSeguro;

  SELECT DAY(Var_FechaVenc) ,   YEAR(Var_FechaVenc) , CASE
  WHEN MONTH(Var_FechaVenc) = mes1  THEN TxtEnero
  WHEN MONTH(Var_FechaVenc) = mes2  THEN TxtFebrero
  WHEN MONTH(Var_FechaVenc) = mes3  THEN TxtMarzo
  WHEN MONTH(Var_FechaVenc) = mes4  THEN TxtAbril
  WHEN MONTH(Var_FechaVenc) = mes5  THEN TxtMayo
  WHEN MONTH(Var_FechaVenc) = mes6  THEN TxtJunio
  WHEN MONTH(Var_FechaVenc) = mes7  THEN TxtJulio
  WHEN MONTH(Var_FechaVenc) = mes8  THEN TxtAgosto
  WHEN MONTH(Var_FechaVenc) = mes9  THEN TxtSeptiembre
  WHEN MONTH(Var_FechaVenc) = mes10 THEN TxtOctubre
  WHEN MONTH(Var_FechaVenc) = mes11 THEN TxtNoviembre
  WHEN MONTH(Var_FechaVenc) = mes12 THEN TxtDiciembre END

  INTO  Var_DiaVencimiento, Var_AnioVencimiento,  Var_MesVencimiento;

    SET Var_MontoCredito := CONCAT('$ ', FORMAT(Var_MontoCred, 2), ', (', Var_MtoLetra, ' M.N.)');
    SET MontoTotPagar := CONCAT('$ ', FORMAT(Var_TotPagar, 2), ', (', Var_TotPagLetra, ' M.N.)');
	SET Var_TasaAnualLetras := CONCAT(FORMAT(Var_TasaAnual,2),'% (',FUNCIONNUMEROSLETRAS(Var_TasaAnual),' POR CIENTO)');
	SET Var_TasaMoratoriaLetras := CONCAT(FORMAT(Var_TasaMoratoria,2),'% (',FUNCIONNUMEROSLETRAS(Var_TasaMoratoria),' POR CIENTO)');
  SELECT Sol.Proyecto, Cre.SolicitudCreditoID INTO Var_DestinoCredito, Var_SolicitudCredito
  FROM SOLICITUDCREDITO Sol,
  CREDITOS Cre
  WHERE Cre.CreditoID=Par_CreditoID
  AND Cre.SolicitudCreditoID = Sol.SolicitudCreditoID;


	IF(MOD(Var_AntiguedadLab,1) > Entero_Cero) THEN
		SET Var_AntiguedadLab := Var_AntiguedadLab;
    ELSE
		SET Var_AntiguedadLab := ROUND(Var_AntiguedadLab);
    END IF;
  SELECT MontoPolizaSegA INTO Var_MontoPolizaSegA
  FROM PARAMETROSSIS
  WHERE EmpresaID=Par_EmpresaID;

  SET Var_SolicitudCredito   := IFNULL(Var_SolicitudCredito, Entero_Cero);

  SELECT FUNCIONNUMLETRAS(Var_MontoPolizaSegA) INTO Var_MtoLetraSeguro;
      SET Var_MontoSeguroApoyo := CONCAT('$ ', FORMAT(Var_MontoPolizaSegA, 2), ' (', Var_MtoLetraSeguro, ' M.N.)');

  SET  Var_TipoGar :=IFNULL(Var_TipoGar,0);
  SET  Var_TipoDoc :=IFNULL(Var_TipoDoc,0);
   SELECT CASE WHEN ProducCreditoID IN (15,16) THEN 'iniciales'
                WHEN ProducCreditoID NOT IN (15,16) THEN 'insolutos' END INTO Var_tipopro
    FROM PRODUCTOSCREDITO PR INNER JOIN CREDITOS CR ON PR.ProducCreditoID = CR.ProductoCreditoID
    WHERE CR.CreditoID=Par_CreditoID;

    SELECT FNFECHACOMPLETA(FechaSistema,3) INTO Var_FechaCompleta FROM PARAMETROSSIS;

    OPEN CURSORAVALES;
    BEGIN
      DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
      LOOP

        FETCH CURSORAVALES INTO
      Var_AvalID, Var_ClienteID,  Var_ProspectoID,  Var_Nombre, Var_Direc,  Var_RFC,
      Var_CURP, Var_Edad, Var_NombreIdent,  Var_NumIdent, Var_EstadoCivilGar;

        IF(Var_ProspectoID<>Entero_Cero)THEN
          SELECT  Est.Nombre, Mun.Nombre, IFNULL(P.Calle,Cadena_Vacia),IFNULL(P.NumInterior,Cadena_Vacia),P.CP,
          IFNULL(P.Manzana,Cadena_Vacia), CONCAT(Col.TipoAsenta," ",Col.Asentamiento),IFNULL(P.Lote,Cadena_Vacia)
          INTO Var_NombEstado,Var_NombMunicipio,Var_Calle,Var_NumInterior,Var_CP,Var_Manzana,Var_NombreColonia,Var_Lote
          FROM PROSPECTOS P
            INNER JOIN ESTADOSREPUB Est ON Est.EstadoID=P.EstadoID
            INNER JOIN MUNICIPIOSREPUB Mun  ON Mun.MunicipioID=P.MunicipioID AND Mun.EstadoID=P.EstadoID
            INNER JOIN COLONIASREPUB  Col ON Col.ColoniaID=P.ColoniaID AND Col.MunicipioID=P.MunicipioID AND Col.EstadoID=P.EstadoID
          WHERE ProspectoID = Var_ProspectoID;

        SET Var_Direc := Var_Calle;
        IF(Var_NumInterior != Cadena_Vacia) THEN
          SET Var_Direc := CONCAT(Var_Direc,", INTERIOR ",Var_NumInterior);
        END IF;
        IF(Var_Lote != Cadena_Vacia) THEN
          SET Var_Direc := CONCAT(Var_Direc,", LOTE ",Var_Lote);
        END IF;
        IF(Var_Manzana != Cadena_Vacia) THEN
          SET Var_Direc := CONCAT(Var_Direc,", MANZANA ",Var_Manzana);
        END IF;
          SET Var_Direc := CONCAT(Var_Direc,", COL. ",Var_NombreColonia,", C.P ",Var_CP,", ",Var_NombMunicipio,", ",Var_NombEstado);
        END IF;

        INSERT TMPAVALES
        VALUES(Var_AvalID,Var_ClienteID,Var_ProspectoID,Var_Nombre,Var_Direc,Var_RFC,
           Var_CURP,Var_Edad,Var_NombreIdent,Var_NumIdent,Var_EstadoCivilGar);
      END LOOP;
    END;
    CLOSE CURSORAVALES;
      SELECT  	Tmp_AvalID, Tmp_ClienteID,   Tmp_ProspectoID,Tmp_Nombre,Tmp_Direccion,
				Tmp_RFC, Tmp_CURP,Tmp_Edad,  Tmp_NombreIdent,Tmp_NumIdent,Tmp_EstadoCivil
		INTO	Var_AvalID,Var_ClienteID,Var_ProspectoID,Var_Nombre,Var_Direc,Var_RFC,
				Var_CURP,Var_Edad,Var_NombreIdent,Var_NumIdent,Var_EstadoCivilGar
      FROM TMPAVALES LIMIT 1;
    -- (SELECT @s:= Entero_Cero) AS s;
      DROP TABLE TMPAVALES;

      SELECT G.Observaciones INTO Var_DesGarantias
		FROM ASIGNAGARANTIAS A
		INNER JOIN GARANTIAS G ON A.GarantiaID = G.GarantiaID WHERE  A.CreditoID = Par_CreditoID AND A.Estatus ='U' LIMIT 1;


		SELECT MontoCuota
				INTO Var_MontoPago
			FROM  CREDITOS Cre
			WHERE Cre.CreditoID=Par_CreditoID;

		SET Var_MontoPagoLetra  := CONCAT('$ ', FORMAT(Var_MontoPago, 2), ', (', FUNCIONNUMLETRAS(Var_MontoPago), ' M.N.)');


  SELECT	Var_Plazo,				Var_FechaVenc,			Var_DesFrec,	 		Var_TasaAnual,			Var_TasaMens,
			Var_TasaFlat,			Var_MontoSeguro,		Var_PorcCobert,			Var_CAT,				Var_PorcGarLiq,
			Var_MonGarLiq,			Var_NomRepres,			Var_FrecSeguro,			Var_NumRECA,			Var_DiaVencimiento,
			Var_AnioVencimiento,	Var_MesVencimiento,		Var_GarantiaLetra,		Var_MontoCredito,		Var_MtoLetra,
			Var_NumAmorti,			Var_DesFrecLet,			MontoTotPagar,			Var_TotPagLetra,		Var_NombreEstadom,
			Var_NombreMuni,			Var_DescProducto,		Var_CobraMora,			Var_FactorMora,			Var_ReqGarantia,
			Var_NumCuotas,			Var_Cliente,			Var_DireccionCompleta,  Var_Credito,      		Var_MontoGarLiq,
			Var_DestinoCredito,   	Var_SolicitudCredito,   Var_MontoPolizaSegA,  	Var_MontoSeguroApoyo,	Var_TasaMoratoria,
			Var_TasaMensMora,   	Var_TipoGar,      		Var_TipoDoc,			Var_Monto,       		Var_Comercial,
			Var_EsNomina,			Var_FechaInicioAmort,	Var_AntiguedadLab,		Var_MontoDesQuinc,		Var_MontoDesQuincLetra,
			Var_LugarNacimiento,	Var_FechaNacimiento,	Var_Ocupacion, 			Var_RFC,				Var_EstadoCivil,
			Var_FechaCompleta,		Var_TasaAnualLetras,	Var_TasaMoratoriaLetras, Var_Nombre,            Var_Direc,
            Var_CURP,               Var_RFC,                Var_DesGarantias,		Var_MontoPago,           Var_MontoPagoLetra,
            CASE Var_EstadoCivilGar
                WHEN EstSoltero THEN TxtSoltero
                WHEN EstCasBienSep THEN TextoCasado
                WHEN EstCasBienMan THEN TextoCasado
                WHEN EstcasBienManCap THEN TextoCasado
                WHEN EstViudo THEN TxtViudo
                WHEN EstDivorciado THEN TxtDivorciado
                WHEN EstSeparado THEN TxtSeparado
                WHEN EsteUnionLibre THEN TxteUnionLibre
            END AS Var_EstadoCivilGar;

  DROP TABLE IF EXISTS TMPGARANTIA;
END IF;



END TerminaStore$$

