-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSSISMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSSISMOD`;

DELIMITER $$
CREATE PROCEDURE `PARAMETROSSISMOD`(
    # =================================================================
    # ---- SP QUE MODIFICA UN REGISTRO EN LA TABLA PARAMETROSSIS ------
    # =================================================================
    Par_EmpresaID           INT(11),        -- Parametro Empresa ID
    Par_SucMatrizID         INT(11),        -- re fefiere a SucursalMAtrizID
    Par_TelefonoLocal       VARCHAR(20),    -- Parametro TelefonoInt
    Par_TelefonoInt         VARCHAR(12),    -- se refiere a TelefonoInterior
    Par_InstitucionID       INT(11),        -- Parametro Institucion ID

    Par_EmpresaDefault      INT(11),
    Par_NombreRepre         VARCHAR(100),   -- se refiere a NombreRepresentante
    Par_RFCRepre            VARCHAR(13),    -- se refiere a RFCrepresentante
    Par_MonedaBaseID        INT(11),        -- Paramero moneda Base ID
    Par_MonedaExtID         INT(11),        -- MpnedaExtrangeraID

    Par_TasaISR             DECIMAL(12,2),  -- Parametro Tasa ISR
    Par_TasaIDE             DECIMAL(12,2),  -- Parametro Tasa IDE
    Par_MontoExcIDE         DECIMAL(12,2),  -- Parametro Par_MontoExcIDE
    Par_EjercicioVig        INT(11),        -- EjercicioVigente
    Par_PeriodoVigente      INT(11),        -- Parametro Par_PeriodoVigente

    Par_DiasInversion       INT(11),        -- Parametro Par_DiasInversion
    Par_DiasCredito         INT(11),        -- Parametro Par_DiasCredito
    Par_DiasCambioPass      INT(11),        -- Parametro Par_DiasCambioPass
    Par_LonMinCaracPass     CHAR(3),        -- Parametro Par_LonMinCaracPass
    Par_ClienteInst         INT(11),        -- se refiere a ClienteInstitucion

    Par_CuentaInstituc      BIGINT(12),     -- Parametro Par_CuentaInstituc
    Par_ManejaCaptacion     CHAR(1),        -- Parametro Par_ManejaCaptacion
    Par_BancoCaptacion      INT(11),        -- Parametro Par_BancoCaptacion
    Par_TipoCuenta          INT(11),        -- Parametro Par_TipoCuenta
    Par_RutaArchivos        VARCHAR(150),   -- Parametro Par_RutaArchivos

    Par_RolTesoreria        INT(11),        -- Parametro Par_RolTesoreria
    Par_RolAdminTeso        INT(11),        -- Parametro Par_RolAdminTeso
    Par_OficialCumID        INT(11),        -- Parametro Par_OficialCumID
    Par_DirGeneralID        INT(11),        -- Parametro Par_DirGeneralID
    Par_DirOperID           INT(11),        -- Parametro Par_DirOperID

    Par_JefeCobranza        VARCHAR(100),   -- Parametro Par_JefeCobranza
    Par_JefeOperayPromo     VARCHAR(100),   -- Parametro Par_JefeOperayPromo
    Par_TipoCtaGLAdi        INT(11),        -- Parametro Par_TipoCtaGLAdi
    Par_RutaArchivosPLD     VARCHAR(200),   -- Parametro de ruta de archivos pld
    Par_Remitente           VARCHAR(50),    -- Parametro remitente

    Par_ServidorCorreo      VARCHAR(30),    -- Parametro srvidor de correo
    Par_Puerto              VARCHAR(10),    -- Parametro puerto
    Par_UsuarioCorreo       VARCHAR(50),    -- Parametro usuario correo
    Par_Contrasenia         VARCHAR(20),    -- Parametro contrasenia
    Par_CtaIniGastoEmp      VARCHAR(45),    -- Parametro Par_CtaIniGastoEmp

    Par_CtaFinGastoEmp      VARCHAR(45),    -- Parametro Par_CtaFinGastoEmp
    Par_ImpTicket           VARCHAR(50),    -- Parametro Par_ImpTicket
    Par_TipoImpTicket       CHAR(1),        -- Parametro Par_TipoImpTicket
    Par_MontoAportacion     DECIMAL(14,2),  -- Parametro monto de aportacion
    Par_ReqAportacionSo     CHAR(1),        -- Requiere Aportacion Social en apertura de Cuentas

    Par_MontoPolizaSegA     DECIMAL(14,2),  -- Parametro Par_MontoPolizaSegA
    Par_MontoSegAyuda       DECIMAL(14,2),  -- Parametro Par_MontoSegAyuda
    Par_CuentasCapConta     VARCHAR(200),   -- Parametro Par_CuentasCapConta
    Par_LonMinPagRemesa     INT(2),         -- Parametro Par_LonMinPagRemesa
    Par_LonMaxPagRemesa     INT(2),         -- Parametro Par_LonMaxPagRemesa

    Par_LonMinPagOport      INT(2),         -- Parametro Par_LonMinPagOport
    Par_LonMaxPagOport      INT(2),         -- Parametro Par_LonMaxPagOport
    Par_SalMinDF            DECIMAL(12,2),  -- Parametro Par_SalMinDF para guardar valor de la unidad de medida y actualizacion (UMA)
    Par_ImpSaldoCred        CHAR(1),        -- Parametro Par_ImpSaldoCred
    Par_ImpSaldoCta         CHAR(1),        -- Parametro Par_ImpSaldoCta
    /*Para los reportes Financieros*/

    Par_GenrenteGral        VARCHAR(100),   -- Parametro Gerente general
    Par_PresiConsejo        VARCHAR(100),   -- Parametro Par_PresiConsejo
    Par_JefeContabil        VARCHAR(100),   -- Parametro Par_JefeContabil
    Par_VigDiasSeguro       INT(11),        -- Parametro Par_VigDiasSeguro
    Par_VencimAutoSeg       CHAR(1),        -- Parametro Par_VencimAutoSeg

    Par_AplCobPenCieDia     VARCHAR(100),   -- Parametro q indica si se aplica en el cierre de dia los cobros pendientes
    Par_FecUltConsejoAdmon  DATE,           -- Parametro Par_FecUltConsejoAdmon
    Par_FoliosActasComite   CHAR(1),        -- Parametro Par_FoliosActasComite
    Par_ServReactivaCte     INT(11),        -- Indica el numero de servicio(catalogo de servicios)
    Par_CtaContaSobrante    VARCHAR(25),    -- Cuenta contable Sobrante en ventanilla

    Par_CtaContaFaltante    VARCHAR(25),    -- Cuenta Contable Faltante en Ventanilla
    Par_CalifAutoCliente    CHAR(1),        -- Calificacion automatica al cliente en cierre de dia S= SI, N = NO
    Par_CtaContaDocSBCD     VARCHAR(25),    -- Recepcion de Documentos SBC ventanilla
    Par_CtaContaDocSBCA     VARCHAR(25),    -- Recepcion de Documentos SBC ventanilla
    Par_AfectaContaRecSBC   CHAR(1),        -- Recepcion de Documentos SBC ventanilla

    Par_ContabilidadGL      CHAR(1),
    Par_CenCostosCheSBC     VARCHAR(30),    -- Centro de Costos de Cheque SBC
    Par_MostSaldoDispCta    CHAR(1),        -- Campo que sirve para mostrar saldo disponible en cta --
    Par_DiasVigBC           INT(11),        -- Dias de la Vigencia de una Consulta a Buro de Credito
    Par_ValidaAutComite     CHAR(1),        -- especifica si al solicitar un credito se validara que el prod credito sea valido para el cliente

    Par_TipoContaMora        CHAR(1),       -- Parametro Par_TipoContaMora
    Par_DivideIngresoInteres CHAR(1),       -- Parametro Par_DivideIngresoInteres
    Par_ExtTelefonoLocal     VARCHAR(6),        -- Parametro Par_ExtTelefonoLocal
    Par_ExtTelefonoInt       VARCHAR(6),        -- Parametro Par_ExtTelefonoInt
    Par_EstCreAltInvGar      VARCHAR(50),   -- Parametro Par_EstCreAltInvGar

    Par_FuncionHuella       CHAR(1),        -- indica si se haran las validaciones por autentificacion de huella digital o no. No quitar
    Par_ReqHuellaProductos  CHAR(1),        -- Parametro Par_ReqHuellaProductos
    Par_CancelaAutMenor     CHAR(1),        -- Parametro Par_CancelaAutMenor
    Par_PerfilWsVbc         INT(11),        -- PERFIL DE WS VBC
    Par_ZonaHoraria			VARCHAR(10),	-- Zona horaria para el timbrado
    Par_Salida              CHAR(1),        -- Parametro Par_Salida
    INOUT Par_NumErr        INT(11),        -- Parametro Par_NumErr

    INOUT Par_ErrMen        VARCHAR(400),   -- Parametro Par_ErrMen

    /*Parametros para la facturacion*/
    Par_EstadoEmpresa       VARCHAR(50),    -- Parametro estado de empresa
    Par_MunicipioEmpresa    VARCHAR(50),    -- Parametro Municipio empresa
    Par_LocalidadEmpresa    VARCHAR(50),    -- Parametro Localidad empresa
    Par_ColoniaEmpresa      VARCHAR(50),    -- Parametro Colonia Empresa

    Par_CalleEmpresa        VARCHAR(50),    -- Parametro calle empresa
    Par_NumIntEmpresa       VARCHAR(50),    -- Parametro Numero interior empresa
    Par_NumExtEmpresa       VARCHAR(50),    -- Parametro Numero exterior empresa
    Par_CPEmpresa           VARCHAR(6),     -- Parametro CP Empresa
    Par_DirFiscal           VARCHAR(150),   -- Parametro Direccion fiscal

    Par_RFCEmp              VARCHAR(40),
    Par_TimbraEdoCta        CHAR(1),        -- Indica se se desea realizar el timbrado de los estados de cuenta
    Par_GeneraCFDINoReg     CHAR(1),        -- Si desea generar el CFDI de los clientes que muestran los datos de alta en hacienda
    Par_GeneraEdoCtaAuto    CHAR(1),        -- Indicaque va a generar la informacion automatica para los estados de cuenta de mes
    Par_ConBuroCreDefaut    CHAR(1),        -- Indica cual sera la consulta por DEFAULT (Circulo o Buro).

    Par_AbreviaturaCirculo  CHAR(3),        -- Indica cual es la abreviatura para la firma de circulo de credito
    Par_CambiaPromotor      CHAR(1),        -- Indica si se puede cambiar el promotor en Alta de Creditos
    Par_MostrarPrefijo      CHAR(1),        -- Indica mostrar prefijo
    Par_ChecListCte         CHAR(1),        -- CHECK list del cliente
    Par_TarjetaIdentiSocio  CHAR(1),        -- Tarjeta de identificacion del socio

    Par_CancelaAutSolCre     CHAR(1),        -- Indica si se requiere cancelar automaticamente solicitudes de credito
    Par_DiasCancelaAutSolCre INT(11),       -- Indica los dias para cancelar automaticamente solicitudes de credito
    Par_NumTratamienCre      INT(11),        -- Numero de veces que se puede dar renovacion a un credito
    Par_CapitalCubierto      DECIMAL(12,2),  -- Capital pagado de un credito para que le pueda hacer renovacion o reestructura
    Par_PagoIntVertical      CHAR(1),        -- Forma de pago de intereses con cargo a cuenta para Renovacion de credito, S=Total exigible, N= Parciales

    Par_NumMaxDiasMora      INT(11),        -- Numero maximo de dias de mora para la reestructura de un credito
    Par_ImpFomatosInd       CHAR(1),        -- Indica si se imprimen formatos individuales

    Par_ReqValidaCred       CHAR(1),        -- Indica si es necesario validar los creditos antes de ser desembolsados
    Par_SistemasID          INT(11),        -- Clave del Usuario que se encuenta encargado del area de sistemas o t.i.
    Par_RutaNotifiCobranza  VARCHAR(100),   -- Ruta donde se almacenaran Documentos de Notificaciones de Cobranza
    Par_CobraSeguroCuota    VARCHAR(1),     -- Indica si los productos de credito permiten el cobro de seguro por Cuota. S: SI N: NO
    Par_TipoDocumentoFirma  INT(11),        -- Indica el id del tipo de documento que tiene la firma

	Par_ReestCalendarioVen	CHAR(1),		-- Indica si se permite Reestructurar un credito con el Calendario vencido
    Par_EstatusValidaReest	CHAR(1),		-- Indica si se permite Reestructurar un con estatus Vencido y Vigente o solo Vigentes
    Par_TipoDetRecursos		INT(11),		-- Indica el tipo de detalle que se mostrara en el reporte bitacora de accesos 1= mostrara ruta safi, 2= nombre del recurso
	Par_CalculaCURPyRFC		CHAR(1),		-- Indica si mostrara el botón de calcular CURP Y RFC en las pantallas SAFI, S=si Y N=no
	Par_ManejaCarteraAgro	CHAR(1),		-- Indica si se manejara Cartera AgrO  S= si N= nO

    Par_SalMinDFReal        DECIMAL(12,2),  -- Parametro Par_SalMinDFReal para guardar el salario minimo
    Par_EvaluacionMatriz    CHAR(1),        -- Indica si se realizará la Evaluación Periódica. S.- SI N.- NO
    Par_FrecuenciaMensual   INT(11),        -- Indica la frecuencia con la que se realizará la evaluación.
	Par_EvaluaRiesgoComun   CHAR(1),        -- Indica si se realizará la Evaluacion de Riesgo Comun en la Autorizacion de la Solicitud y Alta de Credito. S.- SI N.- NO
	Par_CapitalContNeto		DECIMAL(14,2),	-- Capital Contable Neto, se utiliza para la validacion de riesgo comun

    Par_CobranzaAutCie		CHAR(1),		-- Indica si la cobranza automatica se ejecuta como parte del cierre diario
    Par_CobroCompletoAut	CHAR(1),		-- Indica si se realizaran cobros completos de amortizaciones
    Par_CapitalCubiertoReac	DECIMAL(12,2),	-- Capital Cubierto para la Reacreditacion
    Par_PorcPersonaFisica	DECIMAL(12,2),	--
    Par_PorcPersonaMoral	DECIMAL(12,2),	--

    Par_PermitirMultDisp    CHAR(1),        -- Indica si se han de permitir multiples dispersiones del monto de un credito o no
    Par_FechaConsDisp       CHAR(1),        -- Indica si la fecha de consulta estará disponible en la pantalla Operaciones Dispersión de Recursos

    Par_PerfilAutEspAport	INT(11),		-- Perfil del usuario que autoriza aportaciones especiales
    Par_PerfilCamCarLiqui   INT(11),        -- Perfil que puede realizar cambios en las cartas de liquidacion
    Par_InvPagoPeriodico	CHAR(1),		-- Indica si las Inversiones tendran Pago Periodico
    Par_InstitucionCirculoCredito  CHAR(3), -- Clave de Entidad en Circulo de Credito: \n1 - Entidad Financiera \n2 - Empresa Comercial
    Par_ClaveEntidadCirculo INT(11),        -- Tipo de empresa a la que pertenece el Usuario en Circulo de Credito. Catalogo Tipo de Institucion
    Par_ReportarTotalIntegrantes CHAR(1),   -- Reporta todo los Directivos y Avales del Cliente en Circulo de Creditp

    Par_DirectorFinanzas    VARCHAR(100),   -- Director de Finanzas
    Par_ValidaFactura       CHAR(1),        -- Indica si realizara validacion de las facturas ante el SAT S = SI N = NO
    Par_ValidaFacturaURL    VARCHAR(150),    -- Ruta del WS para la validacion de las facturas
    Par_TiempoEsperaWS      INT(11),         -- Tiempo de espera para el WS de validacion de CFDI
    Par_NumTratamienCreRees INT(11),       -- Numero de veces que se puede reestructurar a un credito

    Par_RestringeReporte	CHAR(1),		-- Restringe reportes de cartera S=si, N=no
    Par_CamFuenFonGarFira   CHAR(1),        -- Cambio de Fuente de Fondeo por Garantia FIRA
	Par_PersonNoDeseadas    CHAR(1),        -- Cambio del proceso de validación de Personas No deseadas
	Par_OcultaBtnRechazoSol	CHAR(1),		-- Campo que indica si debe ocultar el boton de rechazo segun el rol indicado. S = SI, N = NO
    Par_RestringebtnLiberacionSol CHAR(1),  -- Campo que indica si debe restringir la liberacion de solicitud de credito individual segun el rol indicado. S=SI, N =NO
    Par_PrimerRolFlujoSolID	INT(11),		-- Primer rol permitido para la liberacion o rechazo de solicitudes dependiendo de lo parametrizado en OcultaBtnRechazoSol o RestringebtnLiberacionSol
    Par_SegundoRolFlujoSolID INT(11),		-- Segundo rol permitido para la liberacion o rechazo de solicitudes dependiendo de lo parametrizado en OcultaBtnRechazoSol o RestringebtnLiberacionSol

    Par_VecesSalMinVig		INT(11),		-- Veces el Salario Mínimo Vigente
    Par_CaracterMinimo		INT(11),		-- Indicara el numero minimo de caracteres del que se compondra una contrasenia
	Par_ReqCaracterMayus	CHAR(1),		-- Indicará si la Contrasenia requiere caracteres Mayuscula.
	Par_CaracterMayus		INT(11),		-- indica el numero de caracteres mayusculas en una contrasenia
	Par_ReqCaracterMinus	CHAR(1),		 -- Indicará si la Contrasenia requiere caracteres Minuscula.
	Par_CaracterMinus		INT(11),		-- Indica el numero de caracteres minusculas en una contrasenia

	Par_ReqCaracterNumerico	CHAR(1),		-- Indicará si la Contrasenia requiere caracteres Numericos.
	Par_CaracterNumerico	INT(11),		-- Indica la cantidad de numeros en una contrasenia
	Par_ReqCaracterEspecial	CHAR(1),		-- Indicará si la Contrasenia requiere caracteres Especiales.
	Par_CaracterEspecial	INT(11),		-- Indica el numero de caracteres especiales en una contrasenia
	Par_UltimasContra		INT(11),		-- Indica cuantas de las ultimas contrasenias no se pueden utilizar

	Par_DiaMaxCamContra		INT(11),		-- Indica el numero de dias que pasaran hasta que el sistema solicite una nueva contrasenia al usuario
	Par_DiaMaxInterSesion	INT(11),		-- Indica el numero en minutos que la sesion se mantendra activa mientras el usuario no tenga interaccion con el sistema
	Par_NumIntentos			INT(11),		-- Indica el numero de intentos que tendra el usuario antes de que se bloquee el usuario
	Par_NumDiaBloq			INT(11),		-- Incida el numero de dias que pasarán despues del ultimo acceso al sistema para que el usuario se bloquee automaticamente

    Par_AlerVerificaConvenio CHAR(2),		-- Indica si envia alerta de convenios
	Par_NoDiasAntEnvioCorreo INT(11),		-- Indica el numero de dias antes de la fecha de vencimiento a enviar la notificacion de convenios
	Par_CorreoRemitente		VARCHAR(100),	-- Indica el correo del remitente de la notificacion de convenio
	Par_CorreoAdiDestino	VARCHAR(500),	-- Indica los correos alternativos a enviar la notificacions de convenio
    Par_RemitenteID 		INT(11),		-- Indica el ID del remitente del correo
    Par_ClabeInstitBancaria	VARCHAR(10),	-- Clave que asigna el banco a la instotucion

    Par_ValidarEtiqCambFond	CHAR(1),		-- Indica si se valida la etiqueta de cambio de fondeo
    Par_RemCierreID			INT(11),		-- Remitente cierre ID dia
    Par_CorreoRemCierre		VARCHAR(100),	-- Correo Remitente Cierre dia
    Par_EjecDepreAmortiAut  CHAR(1),         -- habilitar o deshabilitar el proceso automático de la aplicación de Depreciación y Amortización. \nN.- NO \nS.-SI
    Par_ValidaReferencia	CHAR(1),		-- Indica si se valida que exista una Referencia relacionada al credito para poder imprimir la tabla de Amortizacion  S= si N= nO
	Par_AplicaGarAdiPagoCre	CHAR(1),		-- Al estar activo el parametro el sistema devolvera el monto excedente al pago exigible del credito en ingreso de operaciones.
    Par_ValidaCapitalConta  CHAR(1),        -- VALIDA CAPITAL CONTABLE S.-SI, N.-NO
    Par_PorMaximoDeposito   VARCHAR(10),    -- PORCENTAJE MAXIMO DE DEPOSITOS
    Par_MostrarBtnResumen   CHAR(1),        -- Muestra el Botón de Impresión de Resumen en las Pantallas de Ventanilla y Envio SPEI. \nN.- NO \nS.-SI
    Par_ValidaCicloGrupo	CHAR(1),		-- Parametro: Indica si se valida el ciclo del grupo

 /* Parametros de Auditoria */
    Aud_Usuario             INT(11),		-- Auditoria
    Aud_FechaActual         DATETIME,		-- Auditoria
    Aud_DireccionIP         VARCHAR(15), 	-- Auditoria
    Aud_ProgramaID          VARCHAR(50), 	-- Auditoria
    Aud_Sucursal            INT(11), 		-- Auditoria
    Aud_NumTransaccion      BIGINT(20)      -- Auditoria
    	)

TerminaStore: BEGIN

    -- Declaracion de constantes
    DECLARE Cadena_Vacia    CHAR(1);    -- Constante de cadena vacia
    DECLARE Fecha_Vacia     DATE;       -- Constante de Fecha vacia
    DECLARE Entero_Cero     INT(11);    -- Constante de Entero cero
    DECLARE Entero_Uno		INT(11);    -- Constante de Entero uno
    DECLARE SalidaSi        CHAR(1);    -- Constante salida si
    DECLARE SalidaNo        CHAR(1);    -- Constante salida no
    DECLARE Decimal_Cero	DECIMAL(14,2);


    DECLARE consecutivo     INT(11);    -- Constante consecutivo
    DECLARE ManejaCaptSi    CHAR(1);    -- Si maneja captacion
    DECLARE ManejaCaptNo    CHAR(1);    -- No maneja captacion
    DECLARE SIContaRecepSBC CHAR(1);    -- Constante SIContaRecepSBC
    DECLARE NoRequiereCte   CHAR(1);    -- Constante NoRequiereCte

    DECLARE Act_SeguroCuota INT(11);    -- Constante Act_SeguroCuota
    DECLARE Str_Si          CHAR(1);    -- Constante Str_Si
    DECLARE Str_No          CHAR(1);    -- Constante Str_No
	DECLARE HabilitaConfPass	VARCHAR(100);	-- Llave Parametro: Indica si la contrasenia requiere configuracion

    -- definicion de variables
    DECLARE Var_Institucion         	VARCHAR(20);    -- Variable Institucion
    DECLARE Var_SucursalMatriz      	INT(11);        -- Variable Sucursal Matriz
    DECLARE Var_MonedaExt           	INT(11);        -- Variable Moneda extranjera
    DECLARE Var_Moneda              	INT(11);        -- Variable Moneda
    DECLARE Var_ClienteInst         	INT(11);        -- Variable Cliente Institucion

    DECLARE Var_CuentaInstituc      	BIGINT(12);     -- Variable Cuenta Institucion
    DECLARE Var_TipoCuenta          	INT(11);        -- Variable Tipo de Cuenta
    DECLARE Var_BancoCaptacion      	INT(11);        -- Variable Banco Captacion
    DECLARE Var_EjercicioVig        	INT(11);        -- Variable Ejercicio Vigente
    DECLARE Var_PeriodoVigente      	INT(11);        -- Variable Periodo Vigente

    DECLARE var_RolTesoreria        	INT(11);        -- Variable Rol Tesoreria
    DECLARE var_RolAdminTeso        	INT(11);        -- Variable Rol Administracion Tesoreria
    DECLARE Var_PerfilWsVbc         	INT(11);
    DECLARE Var_BancoCap            	INT(11);        -- Variable BancoCap
    DECLARE Var_Control             	VARCHAR(100);   -- Variable Control
    DECLARE Var_CobraSeguroCuota    	CHAR(1);        -- Variable CObra Seguro Cuota
    DECLARE Var_FechaSistema			DATE;			-- Fecha del Sistema
    DECLARE Var_FechaEvaluacionMatriz	DATE;			-- Fecha para la evaluacion del Nivel de Riesgo de los Clientes.
    DECLARE Var_PerfilAutEspAport      	INT(11);		-- Perfil de usuario que autoriza aportaciones especiales
    DECLARE Var_PerfilCamCarLiqui       INT(11);         -- Perfil de usaurio que puede realizar cambios en las cartas de liquidacion
	DECLARE Var_HabilitaConfPass		CHAR(1);		-- Variable para Guardar Llave Parametro: Indica si la contrasenia requiere configuracion

    -- Asignacion de constantes
    SET Cadena_Vacia            		:= '';              --  Cadena Vaci­a
    SET Fecha_Vacia             		:= '1900-01-01';    -- Fecha DEFAULT
    SET Entero_Cero             		:= 0;               -- Entero Cero
    SET Entero_Uno	            		:= 1;               -- Entero Uno
    SET SalidaSi                		:= 'S';             -- Salida Si
    SET SalidaNo                		:= 'N';             -- Salida No
    SET Decimal_Cero					:= 0.00;			-- DECIMAL Cero

    SET consecutivo             		:= 0;               -- Consecutivo
    SET ManejaCaptSi            		:='S';              -- Si maneja Captacion
    SET ManejaCaptNo            		:='N';              -- No maneja Captacion
    SET SIContaRecepSBC         		:='S';              -- Si hay afectacion contable en la recepcion de Documentos SBC
    SET NoRequiereCte           		:='N';              -- Cuando un Servicion no Requiere Cliente

    SET NoRequiereCte           		:='N';              -- Cuando un Servicion no Requiere Cliente
    SET Act_SeguroCuota         		:= 2;               -- Tipo de actualizacion de seguro por cuota para prod de creditos
    SET Str_Si                  		:='S';              -- Constante SI
    SET Str_No                  		:='N';              -- Constante No
    SET Var_FechaEvaluacionMatriz		:='1900-01-01';
	SET HabilitaConfPass				:= "HabilitaConfPass";					-- Llave Parametro: Indica si la contrasenia requiere configuracion


    ManejoErrores: BEGIN
       DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr  := 999;
                SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                        'Disculpe las molestias que esto le ocasiona. Ref: SP-PARAMETROSSISMOD');
                SET Var_Control := 'SQLEXCEPTION' ;
            END;

        IF(NOT EXISTS(SELECT EmpresaID FROM PARAMETROSSIS
            WHERE EmpresaID = Par_EmpresaID)) THEN
                SET Par_NumErr  := 1;
                SET Par_ErrMen  := 'La Empresa no Existe.';
                SET Var_Control := 'empresaID' ;
                LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_SucMatrizID, Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 2;
            SET Par_ErrMen  := 'La Sucursal Matriz esta vacia.';
            SET Var_Control := 'sucursalMatrizID' ;
            LEAVE ManejoErrores;
        END IF;
        -- se valida que existe la Sucursal Matriz
        SET Var_SucursalMatriz :=(SELECT IFNULL( SucursalID,Entero_Cero) FROM SUCURSALES
                                    WHERE SucursalID= Par_SucMatrizID );
        IF(IFNULL(Var_SucursalMatriz,Entero_Cero) = Entero_Cero ) THEN
            SET Par_NumErr  := 3;
            SET Par_ErrMen  := 'La Sucursal Matriz No Existe.';
            SET Var_Control := 'sucursalMatrizID';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_InstitucionID, Entero_Cero) = Entero_Cero ) THEN
            SET Par_NumErr  := 4;
            SET Par_ErrMen  := 'El Numero de Institucion esta Vacio.';
            SET Var_Control := 'institucionID';
            LEAVE ManejoErrores;
        END IF;

        SET Var_Institucion := (SELECT IFNULL(InstitucionID,Entero_Cero)
                                    FROM INSTITUCIONES
                                    WHERE InstitucionID= Par_InstitucionID );

        IF(IFNULL(Var_Institucion,Entero_Cero) = Entero_Cero ) THEN
            SET Par_NumErr  := 5;
            SET Par_ErrMen  := 'La Institucion Especificada No Existe.';
            SET Var_Control := 'institucionID';
            LEAVE ManejoErrores;
        END IF;

        SET Var_Moneda := (SELECT IFNULL(MonedaId,Entero_cero) FROM MONEDAS
                                    WHERE MonedaId= Par_MonedaBaseID );

        IF(IFNULL(Var_Moneda,Entero_Cero) = Entero_Cero ) THEN
            SET Par_NumErr  := 5;
            SET Par_ErrMen  := 'La Moneda Especificada No Existe.';
            SET Var_Control := 'monedaBaseID';
            LEAVE ManejoErrores;
        END IF;

        SET Var_MonedaExt := (SELECT IFNULL(MonedaId ,Entero_Cero)FROM MONEDAS
                                    WHERE MonedaId= Par_MonedaExtID);   -- -

        IF(IFNULL(Var_MonedaExt,Entero_Cero) = Entero_Cero ) THEN
            SET Par_NumErr  := 6;
            SET Par_ErrMen  := 'La Moneda Ext. Especificada No Existe.';
            SET Var_Control := 'monedaExtrangeraID';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_TasaISR < Entero_Cero )THEN
            SET Par_NumErr  := 7;
            SET Par_ErrMen  := 'La Tasa del ISR debe ser Mayor de Cero.';
            SET Var_Control := 'tasaISR';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_TasaIDE < Entero_Cero )THEN
            SET Par_NumErr  := 8;
            SET Par_ErrMen  := 'La Tasa IDE debe ser Mayor de Cero.';
            SET Var_Control := 'tasaIDE';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_MontoExcIDE < Entero_Cero)THEN
            SET Par_NumErr  := 9;
            SET Par_ErrMen  := 'El Monto Excedente de Pago debe ser Mayor de Cero.';
            SET Var_Control := 'montoExcIDE';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_DiasInversion <= Entero_Cero )THEN
            SET Par_NumErr  := 10;
            SET Par_ErrMen  := 'Los Dias de Inversion debe ser Mayor de Cero.';
            SET Var_Control := 'diasInversion';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_DiasCredito <= Entero_Cero )THEN
            SET Par_NumErr  := 11;
            SET Par_ErrMen  := 'Los Dias de Credito debe ser Mayor de Cero.';
            SET Var_Control := 'diasCredito';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_DiasCambioPass <= Entero_Cero )THEN
            SET Par_NumErr  := 12;
            SET Par_ErrMen  := 'Los Dias para el Cambio de Password debe ser Mayor de Cero.';
            SET Var_Control := 'diasCambioPass';
            LEAVE ManejoErrores;
        END IF;

        IF(CHARACTER_LENGTH(Par_LonMinCaracPass) = Cadena_Vacia)THEN
            SET Par_NumErr  := 13;
            SET Par_ErrMen  := 'El Password debe Contener Minimo 1 Caracter.';
            SET Var_Control := 'lonMinCaracPass';
            LEAVE ManejoErrores;
        END IF;

        SET Var_ClienteInst := (SELECT IFNULL(ClienteID,Entero_Cero) FROM CLIENTES
                                    WHERE ClienteID= Par_ClienteInst );

        IF(IFNULL(Var_ClienteInst,Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr  := 14;
            SET Par_ErrMen  := 'El Cliente No Existe.';
            SET Var_Control := 'clienteInstitucion';
            LEAVE ManejoErrores;
        END IF;

        SET Var_CuentaInstituc := (SELECT IFNULL(CuentaAhoID,Entero_Cero) FROM CUENTASAHO
                                    WHERE CuentaAhoID= Par_CuentaInstituc );

        IF(IFNULL(Var_CuentaInstituc,Entero_Cero) = Entero_Cero ) THEN
            SET Par_NumErr  := 15;
            SET Par_ErrMen  := 'El Numero de Cuenta No Existe.';
            SET Var_Control := 'cuentaInstituc';
            LEAVE ManejoErrores;
        END IF;

        SET Var_TipoCuenta := (SELECT IFNULL(TipoCuentaID,Entero_Cero) FROM TIPOSCUENTAS
                                    WHERE TipoCuentaID= Par_TipoCuenta );

        IF(IFNULL(Var_TipoCuenta,Entero_Cero) = Entero_Cero ) THEN
            SET Par_NumErr  := 16;
            SET Par_ErrMen  := 'El Tipo de Cuenta Especificado No Existe.';
            SET Var_Control := 'tipoCuenta';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_RutaArchivos,Cadena_Vacia) = Cadena_Vacia ) THEN
            SET Par_NumErr  := 17;
            SET Par_ErrMen  := 'La Ruta de Archivos esta Vacia.';
            SET Var_Control := 'rutaArchivos';
            LEAVE ManejoErrores;
        END IF;

        SET Var_RolTesoreria := (SELECT IFNULL(RolID, Entero_Cero)FROM ROLES
                                    WHERE RolID= Par_RolTesoreria);

        IF(IFNULL(Var_RolTesoreria,Entero_Cero) = Entero_Cero ) THEN
            SET Par_NumErr  := 18;
            SET Par_ErrMen  := 'El Rol Espacificado No Existe.';
            SET Var_Control := 'rolTesoreria';
            LEAVE ManejoErrores;
        END IF;


        SET Var_RolAdminTeso :=(SELECT  IFNULL(RolID,Entero_Cero) FROM ROLES
                                    WHERE RolID= Par_RolAdminTeso LIMIT 1);

        IF(IFNULL(Var_RolAdminTeso,Entero_Cero) = Entero_Cero ) THEN
            SET Par_NumErr  := 19;
            SET Par_ErrMen  := 'El Rol Espacificado No Existe.';
            SET Var_Control := 'rolAdminTeso';
            LEAVE ManejoErrores;
        END IF;


        -- SE VALIDA QUE EXISTA EL PELFIL PARA WS DE VBC SOLO EN CASO DE RECIBIR UN VALOR
        IF(IFNULL(Var_PerfilWsVbc,Entero_Cero) != Entero_Cero )THEN
            SET Var_PerfilWsVbc :=(SELECT  IFNULL(RolID,Entero_Cero) FROM ROLES
                                    WHERE RolID= Par_PerfilWsVbc);

            IF(IFNULL(Var_PerfilWsVbc,Entero_Cero) = Entero_Cero ) THEN
                SET Par_NumErr  := 19;
                SET Par_ErrMen  := 'El Rol Especificado para el Perfil VBC No Existe.';
                SET Var_Control := 'perfilWsVbc';
                LEAVE ManejoErrores;
            END IF;
        END IF;

       -- SE VALIDA QUE EXISTA EL PERFIL AUTORIZAR APORTACIONES ESPECIALES
        IF(IFNULL(Par_PerfilAutEspAport,Entero_Cero) != Entero_Cero )THEN
            SET Var_PerfilAutEspAport :=(SELECT  IFNULL(RolID,Entero_Cero) FROM ROLES
                                    WHERE RolID= Par_PerfilAutEspAport);

            IF(IFNULL(Var_PerfilAutEspAport,Entero_Cero) = Entero_Cero ) THEN
                SET Par_NumErr  := 19;
                SET Par_ErrMen  := 'El Rol Especificado para el Perfil Aut. Especial Aportacion No Existe.';
                SET Var_Control := 'perfilAutEspAport';
                LEAVE ManejoErrores;
            END IF;
        END IF;

        -- SE VALIDA QUE EXISTA EL PERFIL QUE PUEDE HACER CAMBIOS EN LAS CARTAS DE LIQUIDACION

            IF(IFNULL(Par_PerfilCamCarLiqui,Entero_Cero) != Entero_Cero )THEN
            SET Var_PerfilCamCarLiqui :=(SELECT  IFNULL(RolID,Entero_Cero) FROM ROLES WHERE RolID= Par_PerfilCamCarLiqui);

            IF(IFNULL(Var_PerfilCamCarLiqui,Entero_Cero) = Entero_Cero ) THEN
                SET Par_NumErr  := 19;
                SET Par_ErrMen  := 'El Rol Especificado para el Perfil Cambios en Cartas de Liquidacion No Existe.';
                SET Var_Control := 'perfilCamCarLiqui';
                LEAVE ManejoErrores;
            END IF;
        END IF;

        IF(Par_BancoCaptacion !=Entero_Cero )THEN
            SET Var_BancoCap := Par_BancoCaptacion;
        ELSE
            SET Var_BancoCap := NULL;
        END IF;

    -- Validacion de campos facturacion electronica campos

        IF(IFNULL(Par_EstadoEmpresa, Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr  := 20;
            SET Par_ErrMen  := 'El Estado de la Empresa esta Vacio.';
            SET Var_Control := 'estadoEmpresa';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_MunicipioEmpresa, Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr  := 21;
            SET Par_ErrMen  := 'El Municipio de la Empresa esta Vacio.';
            SET Var_Control := 'municipioEmpresa';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_ColoniaEmpresa, Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr  := 21;
            SET Par_ErrMen  := 'La Colonia de la Empresa esta Vacia.';
            SET Var_Control := 'coloniaEmpresa';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_LocalidadEmpresa, Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr  := 22;
            SET Par_ErrMen  := 'La Localidad de la Empresa esta Vacia.';
            SET Var_Control := 'localidadEmpresa';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_CalleEmpresa, Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr  := 23;
            SET Par_ErrMen  := 'La Calle de la Empresa esta Vacia.';
            SET Var_Control := 'calleEmpresa';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_NumIntEmpresa, Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr  := 24;
            SET Par_ErrMen  := 'El Num. INT. de la Empresa esta Vacio.';
            SET Var_Control := 'numIntEmpresa';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_CPEmpresa, Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr  := 25;
            SET Par_ErrMen  := 'El C.P. de la Empresa esta Vacio.';
            SET Var_Control := 'CPEmpresa';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_TimbraEdoCta, Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr  := 26;
            SET Par_ErrMen  := 'Seleccione el Timbrado de Cuenta.';
            SET Var_Control := 'timbraEdoCta';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_GeneraCFDINoReg, Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr  := 27;
            SET Par_ErrMen  := 'Seleccione Generar CFDI.';
            SET Var_Control := 'generaCFDINoReg';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_GeneraEdoCtaAuto, Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr  := 28;
            SET Par_ErrMen  := 'Seleccione Generar Cuenta Automatica.';
            SET Var_Control := 'generaEdoCtaAuto';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_CalifAutoCliente, Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr  := 29;
            SET Par_ErrMen  := 'Calificacion Automatica al Cliente esta Vacio.';
            SET Var_Control := 'califAutoCliente';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_AfectaContaRecSBC,Cadena_Vacia) = SIContaRecepSBC)THEN
            IF(IFNULL(Par_CtaContaDocSBCD, Cadena_Vacia) = Cadena_Vacia)THEN
                SET Par_NumErr  := 30;
                SET Par_ErrMen  := 'Indique una Cuenta Contable de Orden Deudora.';
                SET Var_Control := 'ctaContaDocSBCD';
                LEAVE ManejoErrores;
            END IF;
            IF(IFNULL(Par_CtaContaDocSBCA, Cadena_Vacia) = Cadena_Vacia)THEN
                SET Par_NumErr  := 31;
                SET Par_ErrMen  := 'Indique una Cuenta Contable de Orden Acreedora.';
                SET Var_Control := 'ctaContaDocSBCA';
                LEAVE ManejoErrores;
            END IF;
            -- validacion de Centro de Costos de Cheque SBC --
            IF(IFNULL(Par_CenCostosCheSBC, Cadena_Vacia) = Cadena_Vacia) THEN
                SET Par_NumErr  := 32;
                SET Par_ErrMen  := 'El Centro de Costos esta vacio.';
                SET Var_Control := 'cenCostosChequesSBC';
                LEAVE ManejoErrores;
            END IF;
        END IF;

        -- Valida que Mostrar Saldo Disponible no evenga vacio --
        IF(IFNULL(Par_MostSaldoDispCta, Cadena_Vacia) = Cadena_Vacia ) THEN
            SET Par_NumErr  := 33;
            SET Par_ErrMen  := 'Mostrar Saldo Disp. Y SBC de Cta. En Pantalla esta Vacio.';
            SET Var_Control := 'mostrarSaldDispCta';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_ValidaAutComite, Cadena_Vacia) = Cadena_Vacia ) THEN
            SET Par_NumErr  := 34;
            SET Par_ErrMen  := 'El campo Valida Creditos para Clientes Funcionarios esta Vacio.';
            SET Var_Control := 'validaAutComite';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_CancelaAutSolCre = SalidaSi AND Par_DiasCancelaAutSolCre = Entero_Cero)THEN
            SET Par_NumErr  := 35;
            SET Par_ErrMen  := 'El Dia de Cancelacion debe ser Mayor a Cero.';
            SET Var_Control := 'diasCancelaAutSolCre';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_NumTratamienCre, Entero_Cero) = Entero_Cero ) THEN
            SET Par_NumErr  := 36;
            SET Par_ErrMen  := 'Indique el Numero de Renovaciones o Reestructuras Permitidas a un Credito.';
            SET Var_Control := 'numTratamienCre';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_PagoIntVertical, Cadena_Vacia) = Cadena_Vacia ) THEN
            SET Par_NumErr  := 38;
            SET Par_ErrMen  := 'Indique Forma de Pago de Intereses.';
            SET Var_Control := 'pagoIntVerticalSi';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_NumMaxDiasMora, Entero_Cero) = Entero_Cero ) THEN
            SET Par_NumErr  := 39;
            SET Par_ErrMen  := 'Indique Numero Maximo de Dias Mora.';
            SET Var_Control := 'numMaxDiasMora';
            LEAVE ManejoErrores;
        END IF;


        IF(IFNULL(Par_ImpFomatosInd,Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr  := 42;
            SET Par_ErrMen  := 'Especifique Impresion de Formatos Individuales.';
            SET Var_Control := 'impPagareIndi';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_ReqValidaCred,Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr  := 43;
            SET Par_ErrMen  := 'Especifique Validacion de Creditos para Desembolsar.';
            SET Var_Control := 'reqValidaCred';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_CobraSeguroCuota,Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr  := 44;
            SET Par_ErrMen  := 'Especifique Cobro Seguro por Cuota.';
            SET Var_Control := 'cobraSeguroCuota';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_ReestCalendarioVen,Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr  := 45;
            SET Par_ErrMen  := 'Requiere Valida Calendario Vencido';
            SET Var_Control := 'reestCalendarioVen';
            LEAVE ManejoErrores;
        END IF;

         IF(IFNULL(Par_ReestCalendarioVen,Cadena_Vacia) = 'S') THEN
            IF(IFNULL(Par_EstatusValidaReest,Cadena_Vacia) = Cadena_Vacia) THEN
                SET Par_NumErr  := 46;
                SET Par_ErrMen  := 'Requiere Valida Estatus';
                SET Var_Control := 'validaEstatusRees';
                LEAVE ManejoErrores;
            END IF;
        END IF;

		IF(IFNULL(Par_CobranzaAutCie, Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr  := 47;
            SET Par_ErrMen  := 'Especifique Cobranza Automatica antes del Cierre';
            SET Var_Control := 'cobranzaAutCie';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_CobroCompletoAut, Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr  := 48;
            SET Par_ErrMen  := 'Especifique Cobro Completo de la Amortizacion';
            SET Var_Control := 'cobroCompletoAut';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_PorcPersonaFisica, Decimal_Cero) = Decimal_Cero) THEN
            SET Par_NumErr  := 49;
            SET Par_ErrMen  := 'Especifique Porcentaje Persona Fisica';
            SET Var_Control := 'porcPersonaFisica';
            LEAVE ManejoErrores;
        END IF;

         IF(IFNULL(Par_PorcPersonaMoral, Decimal_Cero) = Decimal_Cero) THEN
            SET Par_NumErr  := 50;
            SET Par_ErrMen  := 'Especifique Porcentaje Persona Moral';
            SET Var_Control := 'porcPersonaMoral';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_NumTratamienCreRees, Entero_Cero) = Entero_Cero ) THEN
            SET Par_NumErr  := 51;
            SET Par_ErrMen  := 'Indique el Numero de Reestructuras Permitidas a un Credito.';
            SET Var_Control := 'numTratamienCre';
            LEAVE ManejoErrores;
        END IF;

		-- Se consulta el parametro de Si requiere configuracion de Contrasenia
		-- Si el Parametro tiene el Valor S=Si se realiza la validacion de los parametros requerido.
		SELECT ValorParametro
			INTO Var_HabilitaConfPass
			FROM PARAMGENERALES
				WHERE LlaveParametro = HabilitaConfPass;

		IF (Var_HabilitaConfPass = Str_Si) THEN

			IF(IFNULL(Par_CaracterMinimo, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr  := 52;
				SET Par_ErrMen  := 'Indicara el numero minimo de caracteres del que se compondra una contraseña.';
				SET Var_Control := 'caracterMinimo';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_ReqCaracterMayus, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr  := 53;
				SET Par_ErrMen  := 'Indicara si la Contraseña Requiere caracteres Mayuscula.';
				SET Var_Control := 'reqCaracterMayus';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_ReqCaracterMayus NOT IN(Str_Si, Str_No)) THEN
				SET Par_NumErr  := 54;
				SET Par_ErrMen  := 'Especifique un Valor de Requiere caracteres Mayuscula Valido : S=Si, N= No.';
				SET Var_Control := 'reqCaracterMayus';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_ReqCaracterMayus = Str_Si)THEN
				IF(IFNULL(Par_CaracterMayus, Entero_Cero) = Entero_Cero ) THEN
					SET Par_NumErr  := 55;
					SET Par_ErrMen  := 'Indica el numero de caracteres mayusculas en una contraseña.';
					SET Var_Control := 'caracterMayus';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_ReqCaracterMinus, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr  := 56;
				SET Par_ErrMen  := 'Indicara si la Contraseña Requiere caracteres Minuscula.';
				SET Var_Control := 'reqCaracterMinus';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_ReqCaracterMinus NOT IN(Str_Si, Str_No)) THEN
				SET Par_NumErr  := 57;
				SET Par_ErrMen  := 'Especifique un Valor de Requiere caracteres Minuscula Valido : S=Si, N= No.';
				SET Var_Control := 'reqCaracterMinus';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_ReqCaracterMinus = Str_Si)THEN
				IF(IFNULL(Par_CaracterMinus, Entero_Cero) = Entero_Cero ) THEN
					SET Par_NumErr  := 58;
					SET Par_ErrMen  := 'Indica el numero de caracteres minusculas en una contraseña.';
					SET Var_Control := 'caracterMinus';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_ReqCaracterNumerico, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr  := 59;
				SET Par_ErrMen  := 'Indicara si la Contraseña Requiere caracteres Numericos.';
				SET Var_Control := 'reqCaracterNumerico';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_ReqCaracterNumerico NOT IN(Str_Si, Str_No)) THEN
				SET Par_NumErr  := 60;
				SET Par_ErrMen  := 'Especifique un Valor de Requiere caracteres Numericos Valido : S=Si, N= No.';
				SET Var_Control := 'reqCaracterNumerico';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_ReqCaracterNumerico = Str_Si)THEN
				IF(IFNULL(Par_CaracterNumerico, Entero_Cero) = Entero_Cero ) THEN
					SET Par_NumErr  := 61;
					SET Par_ErrMen  := 'Indica la cantidad de Caracteres Numericos en una contraseña.';
					SET Var_Control := 'caracterMinus';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_ReqCaracterEspecial, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr  := 62;
				SET Par_ErrMen  := 'Indicara si la Contraseña Requiere caracteres Especiales.';
				SET Var_Control := 'reqCaracterEspecial';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_ReqCaracterEspecial NOT IN(Str_Si, Str_No)) THEN
				SET Par_NumErr  := 63;
				SET Par_ErrMen  := 'Especifique un Valor de Requiere caracteres Especiales Valido : S=Si, N= No.';
				SET Var_Control := 'reqCaracterEspecial';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_ReqCaracterEspecial = Str_Si)THEN
				IF(IFNULL(Par_CaracterEspecial, Entero_Cero) = Entero_Cero ) THEN
					SET Par_NumErr  := 64;
					SET Par_ErrMen  := 'Indica el numero de caracteres especiales en una contraseña.';
					SET Var_Control := 'caracterEspecial';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_UltimasContra, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr  := 65;
				SET Par_ErrMen  := 'Indica cuantas de las ultimas contraseña no se pueden utilizar';
				SET Var_Control := 'ultimasContra';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_DiaMaxCamContra, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr  := 66;
				SET Par_ErrMen  := 'Indica el numero de dias que pasaran hasta que el sistema solicite una nueva contraseña al usuario.';
				SET Var_Control := 'diaMaxCamContra';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_DiaMaxInterSesion, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr  := 67;
				SET Par_ErrMen  := 'Indica el numero en minutos que la sesion se mantendra activa mientras el usuario no tenga interaccion con el sistema.';
				SET Var_Control := 'diaMaxInterSesion';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_NumIntentos, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr  := 68;
				SET Par_ErrMen  := 'Indica el numero de intentos que tendra el usuario antes de que se bloquee el usuario.';
				SET Var_Control := 'numIntentos';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_NumDiaBloq, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr  := 69;
				SET Par_ErrMen  := 'Indica el numero de dias que pasarán despues del ultimo acceso al sistema para que el usuario se bloquee automaticamente.';
				SET Var_Control := 'numDiaBloq';
				LEAVE ManejoErrores;
			END IF;
		END IF;

        IF(IFNULL(Par_AlerVerificaConvenio, Cadena_Vacia) = Cadena_Vacia ) THEN
            SET Par_NumErr  := 70;
            SET Par_ErrMen  := 'Indique Alerta Vencimiento Convenio.';
            SET Var_Control := 'alerVerificaConvenio';
            LEAVE ManejoErrores;
        END IF;

		IF(IFNULL(Par_ValidarEtiqCambFond, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr := 71;
			SET Par_ErrMen := 'Indique validar la etiqueta de cambio de fondeo';
			SET Var_Control:= 'remitenteCierreID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_RemCierreID,Entero_Cero) = Entero_Cero) THEN
			SET	Par_NumErr	:= 72;
			SET Par_ErrMen := 'Se requiere correo para cierre de dia';
			SET Var_Control:= 'correoRemitenteCierre';
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_ZonaHoraria,Cadena_Vacia) = Cadena_Vacia) THEN
			SET	Par_NumErr	:= 73;
			SET Par_ErrMen := 'Se requiere la zona Horaria';
			SET Var_Control:= 'zonaHoraria';
			LEAVE ManejoErrores;
		END IF;

        SET Par_EjecDepreAmortiAut := IFNULL(Par_EjecDepreAmortiAut, Cadena_Vacia);
        IF( Par_EjecDepreAmortiAut = Cadena_Vacia) THEN
            SET Par_NumErr  := 73;
            SET Par_ErrMen := 'El campo Ejecucion de Depreciacion de Amortizacion Automatico esta Vacio.';
            SET Var_Control:= 'ejecDepreAmortiAut';
            LEAVE ManejoErrores;
        END IF;

        IF( Par_EjecDepreAmortiAut NOT IN (Str_Si, Str_No)) THEN
            SET Par_NumErr  := 74;
            SET Par_ErrMen := 'El valor para  Ejecucion de Depreciacion de Amortizacion Automatico no es Valido.';
            SET Var_Control:= 'ejecDepreAmortiAut';
            LEAVE ManejoErrores;
        END IF;

        SET Par_MostrarBtnResumen := IFNULL(Par_MostrarBtnResumen, Cadena_Vacia);
        IF( Par_MostrarBtnResumen = Cadena_Vacia) THEN
            SET Par_NumErr  := 75;
            SET Par_ErrMen  := 'El campo Mostrar Boton Resumen esta Vacio.';
            SET Var_Control := 'mostrarBtnResumen';
            LEAVE ManejoErrores;
        END IF;

        IF( Par_MostrarBtnResumen NOT IN (Str_Si, Str_No)) THEN
            SET Par_NumErr  := 76;
            SET Par_ErrMen  := 'El valor del campo Mostrar Boton Resumen no es Valido.';
            SET Var_Control := 'mostrarBtnResumen';
            LEAVE ManejoErrores;
        END IF;

        -- Validamos datos nulos
		SET Par_ValidaCicloGrupo := IFNULL(Par_ValidaCicloGrupo, Cadena_Vacia);

		IF( Par_ValidaCicloGrupo = Cadena_Vacia) THEN
			SET Par_NumErr	:= 75;
			SET Par_ErrMen	:= 'El Campo para validar el ciclo del grupo se encuentra vacio.';
			SET Var_Control	:= 'validaCicloGrupo';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ReestCalendarioVen='N') THEN
			SET Par_EstatusValidaReest := 'S';
        END IF;
        SET Var_CobraSeguroCuota := (SELECT CobraSeguroCuota
                                        FROM PARAMETROSSIS
                                            WHERE EmpresaID = Par_EmpresaID);
        SET Var_CobraSeguroCuota := IFNULL(Var_CobraSeguroCuota,Str_No);

        IF(Var_CobraSeguroCuota=Str_Si AND Par_CobraSeguroCuota=Str_No)THEN
            CALL PRODUCTOSCREDITOACT(
                Entero_Cero,        Act_SeguroCuota,    Cadena_Vacia,       Entero_Cero,        Cadena_Vacia,
                Cadena_Vacia,       Cadena_Vacia,       Cadena_Vacia,       Cadena_Vacia,       Str_No,
                Par_NumErr,         Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

            IF(Par_NumErr!=Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

        END IF;


        SET Par_InstitucionCirculoCredito := IFNULL(Par_InstitucionCirculoCredito, Cadena_Vacia);
        SET Par_ClaveEntidadCirculo       := IFNULL(Par_ClaveEntidadCirculo, Entero_Cero);
        SET Par_ReportarTotalIntegrantes  := IFNULL(Par_ReportarTotalIntegrantes,Str_No );

        SET Aud_FechaActual := NOW();
        SET Par_TipoDocumentoFirma := IFNULL(Par_TipoDocumentoFirma,Entero_Cero);
        SET Par_CamFuenFonGarFira  := IFNULL(Par_CamFuenFonGarFira, Str_No);
		SET Par_PersonNoDeseadas  := IFNULL(Par_PersonNoDeseadas, Str_No);
		SET Par_VecesSalMinVig := IFNULL(Par_VecesSalMinVig, Entero_Cero);
		SET Par_ValidarEtiqCambFond := IFNULL(Par_ValidarEtiqCambFond, Str_No);
        SET Par_FuncionHuella := IFNULL(Par_FuncionHuella, Str_No);
        SET Par_ValidaCapitalConta := IFNULL(Par_ValidaCapitalConta, Str_No);
        SET Par_PorMaximoDeposito := IFNULL(Par_PorMaximoDeposito, Entero_Cero);

        IF(Par_FuncionHuella=Cadena_Vacia)THEN
			SELECT FuncionHuella INTO Par_FuncionHuella
				FROM PARAMETROSSIS
                WHERE EmpresaID  = Par_EmpresaID;

			SET Par_FuncionHuella :=IFNULL(Par_FuncionHuella, Str_No);
        END IF;

        UPDATE PARAMETROSSIS SET
            EmpresaID               = Par_EmpresaID,
            SucursalMatrizID        = Par_SucMatrizID,
            TelefonoLocal           = Par_TelefonoLocal,
            TelefonoInterior        = Par_TelefonoInt,
            InstitucionID           = Par_InstitucionID,

            EmpresaDefault          = Par_EmpresaDefault,
            NombreRepresentante     = Par_NombreRepre,
            RFCRepresentante        = Par_RFCRepre,
            MonedaBaseID            = Par_MonedaBaseID,
            MonedaExtrangeraID      = Par_MonedaExtID,

            TasaISR                 = Par_TasaISR,
            TasaIDE                 = Par_TasaIDE,
            MontoExcIDE             = Par_MontoExcIDE,
            EjercicioVigente        = Par_EjercicioVig,
            PeriodoVigente          = Par_PeriodoVigente,

            DiasInversion           = Par_DiasInversion,
            DiasCredito             = Par_DiasCredito,
            DiasCambioPass          = Par_DiasCambioPass,
            LonMinCaracPass         = Par_LonMinCaracPass,
            ClienteInstitucion      = Par_ClienteInst,

            CuentaInstituc          = Par_CuentaInstituc,
            ManejaCaptacion         = Par_ManejaCaptacion,
            BancoCaptacion          = Var_BancoCap,
            TipoCuenta              = Par_TipoCuenta,
            RutaArchivos            = Par_RutaArchivos,

            RolTesoreria            = Par_RolTesoreria,
            RolAdminTeso            = Par_RolAdminTeso,
            OficialCumID            = Par_OficialCumID,
            DirGeneralID            = Par_DirGeneralID,
            DirOperID               = Par_DirOperID   ,

            NombreJefeCobranza      = Par_JefeCobranza,
            NomJefeOperayPromo      = Par_JefeOperayPromo,
            TipoCtaGLAdi            = Par_TipoCtaGLAdi,
            RutaArchivosPLD         = Par_RutaArchivosPLD,
            Remitente               = Par_Remitente,

            ServidorCorreo          = Par_ServidorCorreo,
            Puerto                  = Par_Puerto,
            UsuarioCorreo           = Par_UsuarioCorreo,
            Contrasenia             = Par_Contrasenia,
            CtaIniGastoEmp          = Par_CtaIniGastoEmp,

            CtaFinGastoEmp          = Par_CtaFinGastoEmp,
            ImpTicket               = Par_ImpTicket,
            TipoImpTicket           = Par_TipoImpTicket,
            MontoAportacion         = Par_MontoAportacion,
            ReqAportacionSo         = Par_ReqAportacionSo,

            MontoPolizaSegA         = Par_MontoPolizaSegA,
            MontoSegAyuda           = Par_MontoSegAyuda,
            CuentasCapConta         = Par_CuentasCapConta,
            LonMinPagRemesa         = Par_LonMinPagRemesa  ,
            LonMaxPagRemesa         = Par_LonMaxPagRemesa ,

            LonMinPagOport          = Par_LonMinPagOport ,
            LonMaxPagOport          = Par_LonMaxPagOport,
            SalMinDF                = Par_SalMinDF,
            ImpSaldoCred            = Par_ImpSaldoCred,
            ImpSaldoCta             = Par_ImpSaldoCta,

            ImpSaldoCred            = Par_ImpSaldoCred,
            ImpSaldoCta             = Par_ImpSaldoCta,
            GerenteGeneral          = Par_GenrenteGral,
            PresidenteConsejo       = Par_PresiConsejo,
            JefeContabilidad        = Par_JefeContabil,

            VigDiasSeguro           = Par_VigDiasSeguro,
            VencimAutoSeg           = Par_VencimAutoSeg,
            TimbraEdoCta            = Par_TimbraEdoCta,
            GeneraCFDINoReg         = Par_GeneraCFDINoReg,
            GeneraEdoCtaAuto        = Par_GeneraEdoCtaAuto,

            AplCobPenCieDia         = Par_AplCobPenCieDia,
            FecUltConsejoAdmon      = Par_FecUltConsejoAdmon,
            FoliosActasComite       = Par_FoliosActasComite,
            ServReactivaCte         = Par_ServReactivaCte,
            CtaContaSobrante        = Par_CtaContaSobrante,

            CtaContaFaltante        = Par_CtaContaFaltante,
            CalifAutoCliente        = Par_CalifAutoCliente,
            CtaContaDocSBCD         = Par_CtaContaDocSBCD,
            CtaContaDocSBCA         = Par_CtaContaDocSBCA,
            AfectaContaRecSBC       = Par_AfectaContaRecSBC,

            ContabilidadGL          = Par_ContabilidadGL,
            CenCostosChequeSBC      = Par_CenCostosCheSBC,
            MostrarSaldDisCtaYSbc   = Par_MostSaldoDispCta,
            DiasVigenciaBC          = Par_DiasVigBC,
            ValidaAutComite         = Par_ValidaAutComite,

            TipoContaMora           = Par_TipoContaMora,
            DivideIngresoInteres    = Par_DivideIngresoInteres,
            ExtTelefonoLocal        = Par_ExtTelefonoLocal,
            ExtTelefonoInt          = Par_ExtTelefonoInt,
            EstCreAltInvGar         = Par_EstCreAltInvGar,

            FuncionHuella           = Par_FuncionHuella ,
            ReqHuellaProductos      = Par_ReqHuellaProductos,
            ConBuroCreDefaut        = Par_ConBuroCreDefaut,
            AbreviaturaCirculo      = Par_AbreviaturaCirculo,
            CancelaAutMenor         = Par_CancelaAutMenor,

            MostrarPrefijo          = Par_MostrarPrefijo,
            CambiaPromotor          = Par_CambiaPromotor,
            ChecListCte             = Par_ChecListCte,
            TarjetaIdentiSocio      = Par_TarjetaIdentiSocio,
            CancelaAutSolCre        = Par_CancelaAutSolCre,

            DiasCancelaAutSolCre    = Par_DiasCancelaAutSolCre,
            NumTratamienCre         = Par_NumTratamienCre,
            CapitalCubierto         = Par_CapitalCubierto,
            PagoIntVertical         = Par_PagoIntVertical,
            NumMaxDiasMora          = Par_NumMaxDiasMora,

            ImpFomatosInd           = Par_ImpFomatosInd,
            ReqValidaCred           = Par_ReqValidaCred,
            SistemasID              = Par_SistemasID,
            RutaNotifiCobranza      = Par_RutaNotifiCobranza,
            RutaNotifiCobranza      = Par_RutaNotifiCobranza,

            CobraSeguroCuota        = Par_CobraSeguroCuota,
            TipoDocumentoFirma      = Par_TipoDocumentoFirma,
            PerfilWsVbc             = Par_PerfilWsVbc,
            ReestCalVenc			= Par_ReestCalendarioVen,
			EstValReest				= Par_EstatusValidaReest,

			TipoDetRecursos			= Par_TipoDetRecursos,
			CalculaCURPyRFC			= Par_CalculaCURPyRFC,
			ManejaCarteraAgro		= Par_ManejaCarteraAgro,
            SalMinDFReal			= Par_SalMinDFReal,

	  		EvaluaRiesgoComun		= Par_EvaluaRiesgoComun,
			CapitalContableNeto		= Par_CapitalContNeto,
            CobranzaAutCierre		= Par_CobranzaAutCie,
            CobroCompletoAut		= Par_CobroCompletoAut,
		 	CapitalCubiertoReac		= Par_CapitalCubiertoReac,

            PorcPersonaFisica		= Par_PorcPersonaFisica,
            PorcPersonaMoral		= Par_PorcPersonaMoral,
            PermitirMultDisp        = Par_PermitirMultDisp,
            FechaConsDisp           = Par_FechaConsDisp,
            PerfilAutEspAport		= Par_PerfilAutEspAport,
            PerfilCamCarLiqui       = Par_PerfilCamCarLiqui,
            InvPagoPeriodico		= Par_InvPagoPeriodico,
            InstitucionCirculoCredito = Par_InstitucionCirculoCredito,
            ClaveEntidadCirculo     = Par_ClaveEntidadCirculo,
            ReportarTotalIntegrantes = Par_ReportarTotalIntegrantes,

            DirectorFinanzas        = Par_DirectorFinanzas,
            ValidaFactura           = Par_ValidaFactura,
            ValidaFacturaURL        = Par_ValidaFacturaURL,
            TiempoEsperaWS          = Par_TiempoEsperaWS,
            NumTratamienCreRees     = Par_NumTratamienCreRees,

            RestringeReporte		= Par_RestringeReporte,
			CamFuenFonGarFira       = Par_CamFuenFonGarFira,
            PersonNoDeseadas		= Par_PersonNoDeseadas,

            RestringeReporte			= Par_RestringeReporte,
			CamFuenFonGarFira       	= Par_CamFuenFonGarFira,
			OcultaBtnRechazoSol			= Par_OcultaBtnRechazoSol,
			RestringebtnLiberacionSol	= Par_RestringebtnLiberacionSol,
			PrimerRolFlujoSolID 		= Par_PrimerRolFlujoSolID,
			SegundoRolFlujoSolID 		= Par_SegundoRolFlujoSolID,
			VecesSalMinVig			= Par_VecesSalMinVig,
			CaracterMinimo			= Par_CaracterMinimo,
			ReqCaracterMayus		= Par_ReqCaracterMayus,
			CaracterMayus			= Par_CaracterMayus,
			ReqCaracterMinus		= Par_ReqCaracterMinus,
			CaracterMinus			= Par_CaracterMinus,

			ReqCaracterNumerico		= Par_ReqCaracterNumerico,
			CaracterNumerico		= Par_CaracterNumerico,
			ReqCaracterEspecial		= Par_ReqCaracterEspecial,
			CaracterEspecial		= Par_CaracterEspecial,
			UltimasContra			= Par_UltimasContra,

			DiaMaxCamContra			= Par_DiaMaxCamContra,
			DiaMaxInterSesion		= Par_DiaMaxInterSesion,
			NumIntentos				= Par_NumIntentos,
			NumDiaBloq				= Par_NumDiaBloq,

            AlerVerificaConvenio	= Par_AlerVerificaConvenio,
			NoDiasAntEnvioCorreo	= Par_NoDiasAntEnvioCorreo,
			CorreoRemitente			= Par_CorreoRemitente,
			CorreoAdiDestino		= Par_CorreoAdiDestino,
            ClabeInstitBancaria		= Par_ClabeInstitBancaria,
            RemitenteID				= Par_RemitenteID,

			ValidarEtiqCambFond		= Par_ValidarEtiqCambFond,
			RemitenteCierreID		= Par_RemCierreID,
			CorreoRemCierre			= Par_CorreoRemCierre,
            EjecDepreAmortiAut      = Par_EjecDepreAmortiAut,
			ZonaHoraria				= Par_ZonaHoraria,
	        ValidaReferencia        = Par_ValidaReferencia,
            AplicaGarAdiPagoCre		= Par_AplicaGarAdiPagoCre,
            ValidaCapitalConta      = Par_ValidaCapitalConta,
            PorMaximoDeposito       = Par_PorMaximoDeposito,

            MostrarBtnResumen       = Par_MostrarBtnResumen,
            ValidaCicloGrupo		= Par_ValidaCicloGrupo,

            Usuario                 = Aud_Usuario,
            FechaActual             = Aud_FechaActual,
            DireccionIP             = Aud_DireccionIP,
            ProgramaID              = Aud_ProgramaID,
            Sucursal                = Aud_Sucursal,
            NumTransaccion          = Aud_NumTransaccion

        WHERE EmpresaID     = Par_EmpresaID;

        UPDATE  INSTITUCIONES SET
            EstadoEmpresa       = Par_EstadoEmpresa,
            MunicipioEmpresa    = Par_MunicipioEmpresa,
            ColoniaEmpresa      = Par_ColoniaEmpresa,
            LocalidadEmpresa    = Par_LocalidadEmpresa,
            CalleEmpresa        = Par_CalleEmpresa,

            NumIntEmpresa       = Par_NumIntEmpresa,
            NumExtEmpresa       = Par_NumExtEmpresa,
            CPEmpresa           = Par_CPEmpresa,
            DirFiscal           = Par_DirFiscal,
            RFC                 = Par_RFCEmp,

            Usuario             = Aud_Usuario,
            FechaActual         = Aud_FechaActual,
            DireccionIP         = Aud_DireccionIP,
            ProgramaID          = Aud_ProgramaID,
            Sucursal            = Aud_Sucursal,

            NumTransaccion      = Aud_NumTransaccion

        WHERE EmpresaID         = Par_EmpresaID
            AND InstitucionID   = Par_InstitucionID;

        SET Par_NumErr  := 0;
        SET Par_ErrMen  := CONCAT('Parametros del Sistema Modificados Exitosamente:  ',CAST(Par_EmpresaID AS CHAR));
        SET Var_Control := 'empresaID';

    END ManejoErrores;

    IF(Par_Salida = SalidaSi) THEN
        SELECT  Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_Control AS Control,
                Par_EmpresaID AS Consecutivo;
    END IF;

END TerminaStore$$