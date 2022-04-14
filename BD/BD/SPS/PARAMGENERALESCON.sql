
-- SP PARAMGENERALESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS PARAMGENERALESCON;

DELIMITER $$
CREATE PROCEDURE `PARAMGENERALESCON`(
/* SP QUE CONSULTA LOS PARAMETROS GENERALES DEL SISTEMA */
	Par_NumConsulta			TINYINT UNSIGNED,	-- Numero de Consulta
	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT
)
TerminaStore : BEGIN

	# DECLARACION DE CONSTANTES
	DECLARE ConHabilitaFechaDisp 		INT(10);
	DECLARE ConDetLaboralCteConyug		INT(10);
	DECLARE ConRutaKtrPLD				INT(11);
	DECLARE ConRutaKtrListas			INT(11);
	DECLARE ConRutaJobBusqListas		INT(11);
	DECLARE Con_KtrMovil				INT(11);
    DECLARE ConRutaJobLoteTar			INT(11);
    DECLARE ConTipoRegulatorios			INT(11);
    DECLARE ConTipoConexionTD			INT(11);
    DECLARE ConSaldoFega				INT(11);
    DECLARE ConSaldoFonaga				INT(11);
    DECLARE ConCteEspecifico			INT(11);
	DECLARE ConOrigenDatosEdoCta		INT(11);			-- Numero de consulta para origen de datos de estado de cuenta. Cardinal Sistemas Inteligentes
	DECLARE ConArchivosPerdida			INT(11);			-- Numero de consulta para el job de Perdida Esperada
	DECLARE ConRutaPropConexSAFI		INT(11);			-- Numero de consulta para obtener la ruta del archivo de conexiones safi
	DECLARE ConArchivosMonitoreo		INT(11);			-- Numero de consulta para el job de Archivo de Monitoreo
	DECLARE ConIPServGenEdoCta			INT(11);			-- Numero de consulta para obtener la IP del Servidor de Generacion de estados de Cuenta
	DECLARE ConUsuServGenEdoCta			INT(11);			-- Numero de consulta para obtener el Usuario para  archivo de conexiones safi
    DECLARE ConNumeroHabitantes			INT(11);
    DECLARE ConRecupMasivaCondona		INT(11);
    DECLARE ConCastigoMasivaCondona		INT(11);
    DECLARE ConPagosXRef				INT(11);			-- Numero de consulta para obtener si permite pago por referencia o no
    DECLARE ConCobroAccesorios			INT(11);			-- Numero de consulta para obtener si se realiza el cobro de accesorios
    DECLARE ConPorcCredAut				INT(11);			-- Numero de consulta para obtener el porcentaje maximo para creditos automaticos
	DECLARE ConGarFinanciadas			INT(11);			--  Numero de consulta para obtener si la garantia liquida se cobran o no de manera financiada
    DECLARE ConValidaHuellaUsuario		INT(11);
	DECLARE ConScriptShListasPLD		INT(11);
	DECLARE ConEncodeListasPLD			INT(11);
	DECLARE ConModificaMontoCred		INT(11);			-- Consulta si si se realiza modificacion del Monto de Credito
	DECLARE ConPermiteResidentesExt		INT(11);			-- Consulta si la institucion podra registrar personas residentes en el extranjero
	DECLARE ConPermiteBotonExcel 		INT(11);			-- Consulta si se permite ver el boton excel en la pantalla de reportes financieros
	DECLARE ConHabilitaConfPass			INT(11);			-- Consulta para  verificar si requiere configuracion de contrasenia
	DECLARE ConTipoRepXMLPLD			INT(11);
	DECLARE Con_AutorizaHuellaCliente 	TINYINT UNSIGNED;	-- Consulta para validar la Autorizacion de Huella de Cliente
    DECLARE ConPerfilExpediente			INT(11);            -- Consulta para extraer el Perfil del Analista de credito General
    DECLARE Con_ManejaConvenio			INT(11);
    DECLARE Con_AplicaTabla				INT(11);
    DECLARE Con_Crowdfunding			INT(11);
    DECLARE ConAplicaCalculoCAT			INT(2);				-- Consulta si se uestra el campo Aplica Cálculo CAT
    DECLARE ConDispersionSantander		INT(11);			-- Consulta el parametro para indicar si se vizualizan secciones especiales
    DECLARE ConRutaConexionKTRSan		INT(11);			-- Consulta el parametro para indicar la ruta de conexion a la base de datos
    DECLARE Con_ManejaSPEI				INT(11);
	DECLARE ConRutaJobLoteTarSAFI		INT(11);
    DECLARE Con_RutaWSFC				TINYINT;
	DECLARE Con_HeaderWSFC				TINYINT;
	DECLARE Con_LlaveWS							VARCHAR(100);
	DECLARE Con_LlaveHeader						VARCHAR(100);
	DECLARE Con_EjecucionBalanzaContable	 TINYINT UNSIGNED;-- Consulta si existe una Ejecucion de Balanza Contable
	DECLARE Con_UserEjecucionBalanzaContable TINYINT UNSIGNED;-- Consulta el Usuario que ejecuta la Balanza Contable

	DECLARE Var_ConCajaPDM					INT(11);
    DECLARE Con_RutaCarpetaEjecutablesETL	INT(11);	-- Consulta de La ruta de los ejecutables de los ETL.
	DECLARE Con_RutaCarpetaArchivosETL		INT(11);	-- consultar de La ruta de los Archivos a cargar de los ETL.
	DECLARE Var_ConUrlRemesas				INT(11);	-- Consulta de la ruta del WS para el consumo remesas SPEI
	DECLARE Var_ConPortNamRem				INT(11);	-- Consulta del nombre del WS de Remesas
	DECLARE Var_ConTimeOutRem				INT(11);	-- Consulta del tiempo limite de espera para el consumo del WS de remesas
	DECLARE Var_ConTimeOutDesRem			INT(11);	-- Consulta del tiempo de espera para la descarga de remesas SPEI
	DECLARE Con_EditaSucursal				INT(11);
	DECLARE ConRutaArchivosFact		INT(11);
    DECLARE ConRutaEjecutablesFact	INT(11);
    DECLARE Con_InstitucionBanorte			INT(11);	-- Consulta la institucion que corresponde a Banorte(Valor del catalogo de INSTITUCIONES)
    DECLARE Con_InstitucionTelecom			INT(11);	-- Consulta la institucion que corresponde a Telecom(Valor del catalogo de INSTITUCIONES)

	DECLARE Var_ConTokFirebase			INT(11);		-- Consulta el token de firebase
	DECLARE Var_ConCodPaisSMS			INT(11);		-- Consulta el codigo de pais para los SMS.
	DECLARE Var_ConPublicKeySNS			INT(11);		-- Consulta la clave de acceso para SNS.
	DECLARE Var_ConSecretKeySNS			INT(11);		-- Consulta la clave secreta para SNS.
	DECLARE Var_ConEnvioSMSActivo		INT(11);		-- Consulta si el servicio de SMS esta  habilitado.
	DECLARE Var_ConLlavAutenWSPixel		INT(11);		-- Consulta la cadena b64 para la autenticación WS pixel
	DECLARE Var_ConRutaWSCardSecur		INT(11);		-- Consulta la ruta del WS de seguridad de tarjetas para NIP.

	DECLARE Var_ConWSBancas				INT(11);		-- Consulta si el servicio de SMS esta  habilitado.
	DECLARE Var_ConTokenWSBancas		INT(11);		-- Consulta si el servicio de SMS esta  habilitado.
	DECLARE Con_DepRefMesAnterior		INT(11);
	DECLARE Con_BusqListasLV			INT(11);
	DECLARE Con_PorcMinLVPLD			INT(11);

    DECLARE Var_LlaveCajaPDM 			VARCHAR(100);
	DECLARE Var_LlavePrinPDM 			VARCHAR(100);
	DECLARE Var_LlaveSucPDM 			VARCHAR(100);
	DECLARE Var_LlaveKtrListas			VARCHAR(100);
	DECLARE Var_LlaveKtrBusqListas		VARCHAR(100);
	DECLARE Var_LlaveKtrMovil			VARCHAR(100);
	DECLARE Var_LlaveJobLoteTar			VARCHAR(100);
	DECLARE Var_LlaveJobLoteTarSAFI		VARCHAR(100);
	DECLARE Var_LlaveTipoRegula			VARCHAR(100);
	DECLARE Var_LlaveTipoConTD			VARCHAR(100);
    DECLARE Var_LlaveSaldoFega			VARCHAR(100);
    DECLARE Var_LlaveSaldoFonaga		VARCHAR(100);
    DECLARE Var_LlaveCteEspecifico		VARCHAR(100);
    DECLARE Var_LlaveODEdoCta	 		VARCHAR(100);	-- Valor para consulta de origen de datos de estado de cuenta. Cardinal Sistemas Inteligentes
    DECLARE Var_LlaveArchivosPerdida 	VARCHAR(100);	-- Llave para consultar l ruta de KTR de Archivos de Perdoda Esperada
    DECLARE Var_RutaPropConexionesSAFI	VARCHAR(100);	-- Ruta del Propertes de ConexionesSAFI ConexionesSAFI.properties
    DECLARE Var_LlaveArchivosMonitoreo 	VARCHAR(100);	-- Llave para consultar l ruta de KTR de Archivos de Perdoda Esperada
    DECLARE Var_LlaveNumHabitantes		VARCHAR(100);	-- Indica el minimo numero de habitantes de una localidad(Financiamiento Rural)
    DECLARE Var_LlaveIPServGenEdoCta 	VARCHAR(100);	-- Llave para consultar la IP del Servidor de Generacion de estados de Cuenta
	DECLARE Var_LlaveUsuServGenEdoCta 	VARCHAR(100);	-- Llave para consultar el Usuario para  archivo de conexiones safi
	DECLARE Var_RecupMasivaCarteraKTR 	VARCHAR(100);	-- Llave para consultar la ruta del KTR del proceso de Recuperacion Masiva de cartera castigada
	DECLARE Var_CastMasivoCarteraKTR 	VARCHAR(100);	-- Llave para consultar la ruta del KTR del proceso de Castigo Masivo de cartera castigada
    DECLARE Var_PagosXRef				VARCHAR(100); 	-- Llave para consulta el valor de PagoXReferencia
	DECLARE Var_CobraAccesorios			VARCHAR(100); 	-- Llave para consulta el valor de Cobro de Accesorios
    DECLARE Var_PorceMaxCrediAutomatico	VARCHAR(100);	-- Llave para consultar el valor maximo para creditos automaticos.
	DECLARE Var_LlaveSHListas			VARCHAR(100);
	DECLARE Var_LlaveEncodeListas		VARCHAR(100);
	DECLARE Var_ModificaMontoCred		VARCHAR(100);
	DECLARE Var_PermiteResidentesExt	VARCHAR(100);
	DECLARE Var_PermiteBotonExcel		VARCHAR(100);
	DECLARE Var_HabilitaConfPass		VARCHAR(100);	-- Llave Parametro: Indica si la contrasenia requiere configuracion
	DECLARE Llave_AutorizaHuellaCliente VARCHAR(100);	-- Llave Parametro: Indica si requiere Autorizacion de Huella de Cliente
	DECLARE Var_TipoRepXMLPLD			VARCHAR(100);	-- Llave tipo Formato Reportes PLD.
	DECLARE Var_PerfilEdicionExpediente VARCHAR(100);   -- Llave para Perfil Analista de Credito
    DECLARE Var_ManejaConvenio          VARCHAR(100);	-- Variable para saber si se maneja convenio
    DECLARE Var_AplicaTabla             VARCHAR(100);
	DECLARE Var_AplicaCalculoCAT		VARCHAR(100);	-- Llave aplica cálculo CAT
	DECLARE Var_ManejaSPEI				VARCHAR(100);
    DECLARE Var_RutaEjecutablesFact		VARCHAR(100);
    DECLARE Var_RutaArchCargaFact		VARCHAR(100);

	# DECARACION DE VARIABLES
	DECLARE Var_Valor					VARCHAR(100);
    DECLARE Var_GarFinanciada			VARCHAR(100);		-- Llave para consultar el valor de GarantiasFinanciadas
    DECLARE Var_DispersionSantander		VARCHAR(100);
    DECLARE Var_ConexionKTRSantander	VARCHAR(100);

	DECLARE Var_RutaCarpetaEjecutablesETL	VARCHAR(100);	-- Llave para consultar La ruta de los ejecutables de los ETL.
	DECLARE Var_RutaCarpetaArchivosETL		VARCHAR(100);	-- Llave para consultar La ruta de los Archivos a cargar de los ETL.
	DECLARE Var_LlavUrlRemesas			VARCHAR(100);	-- Llave para consulta de la ruta del WS para el consumo de remesas SPEI
	DECLARE Var_LlavPortNamRem			VARCHAR(100);	-- Llave para consulta del nombre del WS de Remesas
	DECLARE Var_LlavTimeOutRem			VARCHAR(100);	-- Llave para consulta del tiempo limite de espera para el consumo del WS de remesas
	DECLARE Var_LlavTimeOutDesRem		VARCHAR(100);	-- Llave para consulta del tiempo de espera para la descarga de remesas SPEI
	DECLARE Llave_EjecucionBalanzaContable		VARCHAR(50);-- Llave de Ejecucion de Balanza Contable
	DECLARE Llave_UserEjecucionBalanzaContable	VARCHAR(50);-- Llave de Usuario que  Ejecuta la Balanza Contable
	DECLARE Con_LlaveEditSuc				VARCHAR(100);

	DECLARE Var_LlavTokFirebase			VARCHAR(100);	-- Llave para consulta del token de firebase.
	DECLARE Var_LlavCodPaisSMS			VARCHAR(100);	-- Llave para consulta del codigo de pais para los SMS.
	DECLARE Var_LlavPublicKeySNS		VARCHAR(100);	-- Llave para consulta de la llave de acceso lara SNS.
	DECLARE Var_LlavSecretKeySNS		VARCHAR(100);	-- Llave para consulta de a llave secreta de SNS.
	DECLARE Var_LlavEnvioSMSActivo		VARCHAR(100);	-- Llave para consulta si esta habilitado el servicio de SMS.
	DECLARE Var_LlavAutenWSPixel		VARCHAR(100);	-- Llave para la consulta de cadena en base64 de autenticación para ws pixel
	DECLARE Var_LlavRutWSSegTarjeta		VARCHAR(100);	-- Llave para consulta la ruta del WS de seguridad de tarjetas.

    DECLARE Con_LlaveInstitucionBanorte		VARCHAR(100);	-- Llave para consultar la institucion que corresponde a Barnorte(Valor del catalogo de INSTITUCIONES)
    DECLARE Con_LlaveInstitucionTelecom		VARCHAR(100);	-- Llave para consultar la institucion que corresponde a Telecom(Valor del catalogo de INSTITUCIONES)

	DECLARE Var_LlavWSBancas			VARCHAR(100);	-- Llave para consulta de la ruta del WS de bancas.
	DECLARE Var_LlavTokWSBan			VARCHAR(100);	-- Llave para consulta del token de ruta de ws de bancas.

	# ASIGNACION DE CONSTANTES
	SET ConHabilitaFechaDisp 		:= 1;				-- Consulta para habilitar la fecha en Dispersiones
	SET ConDetLaboralCteConyug		:= 2;				-- Muestra campo para especificar fecha de antiguedad laboral en pantalla de cliente y datos socioeconomicos
	SET ConRutaKtrPLD				:= 3;				-- Consulta para Obtener la ruta de KTR de Envio de Correos de PLD
    SET Var_ConCajaPDM				:= 4;				-- Consulta de Caja para Pademobile
    SET Con_KtrMovil				:= 5;				-- Consulta para KTR de Envio correo de Banca Movil
	SET ConRutaKtrListas			:= 6;				-- Consulta para JOB de Carga de Listas PLD
	SET ConRutaJobBusqListas		:= 7;				-- Consulta para JOB de Busqueda en Listas PLD
    SET ConRutaJobLoteTar			:= 8;				-- Consulta para job de Carga de Lote de Tarjetas
    SET ConTipoRegulatorios			:= 9;				-- Consulta para tipo de regulatorios a Generar
    SET ConTipoConexionTD			:= 10;				-- Consulta para tipo de conexion de tarjeta de debito
    SET ConSaldoFega				:= 11;				-- Consulta para saldo de aplicacion garantia FEGA
    SET ConSaldoFonaga				:= 12;				-- Consulta para saldo de aplicacion garantia FONAGA
    SET ConCteEspecifico			:= 13;				-- Consulta para Obtener el Cliente Específico
	SET ConOrigenDatosEdoCta 		:= 14;				-- Consulta para origen de datos de estado de cuenta. Cardinal Sistemas Inteligentes
	SET ConArchivosPerdida	 		:= 15;
	SET ConRutaPropConexSAFI 		:= 16;
	SET ConArchivosMonitoreo		:= 17;
	SET ConIPServGenEdoCta	 		:= 18;				-- Numero de consulta para obtener la IP del Servidor de Generacion de estados de Cuenta
	SET ConUsuServGenEdoCta 		:= 19;				-- Numero de consulta para obtener el Usuario para  archivo de conexiones safi
    SET ConNumeroHabitantes			:= 20;				-- Numero de consulta que devuelve el numero de habitantes
    SET ConRecupMasivaCondona		:= 21;				-- Numero de consulta que devuelve la ruta del KTR de Condonacion masiva
    SET ConCastigoMasivaCondona		:= 22;				-- Numero de consulta que devuelve la ruta del KTR de Castigo masivo
    SET ConPagosXRef				:= 23;				-- Numero de consulta para obtener si permite pago por referencia o no
	SET ConCobroAccesorios			:= 24;				-- Numero de consulta para obtener si se realiza el cobro de accesorios
    SET ConPorcCredAut				:= 25;				-- Numero de consulta para obtener el porcentaje a utilizar por creditos automaticos
    SET ConGarFinanciadas			:= 26;				-- Numero de consulta para obtener si la garantia liquida se cobran o no de manera financiada
    SET ConValidaHuellaUsuario		:= 27;				-- Consulta para Huella Digital, indica si se valida la huella de usuarios alregistrar socios
	SET ConScriptShListasPLD		:= 28;				-- Consulta Script Shell para codificación del archivo de carga PLD.
	SET ConEncodeListasPLD			:= 29;				-- Consulta si el archivo de carga deberá codificarse en UTF8.
	SET ConModificaMontoCred		:= 30;				-- Consulta si se realiza modificacion del Monto de Credito
	SET ConPermiteResidentesExt		:= 31;				-- Consulta si la institucion podra registrar personas residentes en el extranjero
	SET ConPermiteBotonExcel		:= 32;				-- Consulta si permite ver el boton excel en la pantalla de reportes financieros
	SET ConHabilitaConfPass			:= 33;				-- Consulta para  verificar si requiere configuracion de contrasenia
	SET Con_AutorizaHuellaCliente	:= 35;
	SET ConTipoRepXMLPLD			:= 34;				-- Consulta Tipo de Formato Reportes PLD.
	SET ConPerfilExpediente			:= 40;				-- Consulta el Perfil del Expediente de analisis de credito
    SET Con_ManejaConvenio			:= 36;
    SET Con_AplicaTabla             := 37;              -- Consulta aplica tabla real
    SET Con_Crowdfunding			:= 38;
    SET ConAplicaCalculoCAT			:= 39;				-- Consulta Aplica Cálculo CAT
    SET ConDispersionSantander		:= 43;				-- Consulta parametros santander
    SET ConRutaConexionKTRSan		:= 44;				-- Consulta parametros santander
    SET Con_RutaCarpetaEjecutablesETL	:= 41;
    SET Con_RutaCarpetaArchivosETL		:= 42;
    SET Con_ManejaSPEI					:= 45;			-- Consulta Maneja SPEI
	SET Var_ConUrlRemesas			:= 47;				-- Consulta de la ruta del WS para el consumo de remesas SPEI
	SET Var_ConPortNamRem			:= 48;				-- Consulta del nombre del WS de Remesas
	SET Var_ConTimeOutRem			:= 49;				-- Consulta del tiempo limite de espera para el consumo del WS de remesas
	SET ConRutaJobLoteTarSAFI		:= 60;				-- Consulta la Ruta de KTR de generación de tarjetas SAFI
	SET Con_RutaWSFC				:= 50;				-- Ruta WS de FC
	SET Con_HeaderWSFC				:= 51;				-- Header de autorizacion para el WS de FC
	SET Var_ConTimeOutDesRem		:= 52;				-- Consulta del tiempo de espera para la descarga de remesas SPEI
	SET Con_EditaSucursal			:= 58;				-- Consulta si permite la editar la sucursal del cliente
	SET Con_EjecucionBalanzaContable		:= 53;		-- Consulta si existe una Ejecucion de Balanza Contable
	SET Con_UserEjecucionBalanzaContable	:= 54;		-- Consulta el Usuario que ejecuta la Balanza Contable
    SET Con_InstitucionBanorte		:= 59;				-- Consulta la institucion que corresponde a Banorte(Valor del catalogo de INSTITUCIONES)
    SET Con_InstitucionTelecom		:= 60;				-- Consulta la institucion que corresponde a Telecom(Valor del catalogo de INSTITUCIONES)

	SET Var_ConTokFirebase			:= 53;				-- Consulta el token de firebase
	SET Var_ConCodPaisSMS			:= 54;				-- Consulta el codigo de pais para los SMS.
	SET Var_ConPublicKeySNS			:= 55;				-- Consulta la clave de acceso para SNS.
	SET Var_ConSecretKeySNS			:= 56;				-- Consulta la clave secreta para SNS.
	SET Var_ConEnvioSMSActivo		:= 57;				-- Consulta si el servicio de SMS esta  habilitado.
	SET Var_ConLlavAutenWSPixel		:= 58;				-- Consulta la cadenab64 de la autenticación ws pixel
	SET Var_ConRutaWSCardSecur		:= 59;				-- Consulta la ruta del WS de seguridad de tarjetas para NIP.
	SET ConRutaJobLoteTarSAFI		:= 61;				-- Consulta la Ruta de KTR de generación de tarjetas SAFI
    SET ConRutaArchivosFact				:= 100;			-- Numero de consulta para obtener la ruta donde se almacenan los archivos para carga masiva de facturas
    SET ConRutaEjecutablesFact			:= 101;
	SET Var_ConWSBancas				:= 55;
	SET Var_ConTokenWSBancas		:= 56;
	SET Con_DepRefMesAnterior		:= 103;				-- Consulta si se encuentra habilitado la busqueda de coincidencias en listas desde java.
	SET Con_BusqListasLV			:= 104;				-- Consulta si se encuentra habilitado la busqueda de coincidencias en listas desde java.
	SET Con_PorcMinLVPLD			:= 105;				-- Consulta el porcentaje de la busqueda de coincidencias en listas desde java.

    SET Var_LlaveCajaPDM 			:= "CajaPDM";		-- Llave Parámetro: CajaPDM
	SET Var_LlavePrinPDM 			:= "CajaPrinPDM";	-- Llave Parámetro: CajaPrinPDM
	SET Var_LlaveSucPDM 			:= "SucursalPDM";	-- Llave Parámetro: CajaPDM
	SET Var_LlaveKtrMovil 			:= "RutaCorreosBancaMovil";	-- Llave Parámetro: KTR de Envio correo de Banca Movil
	SET Var_LlaveJobLoteTar			:= "LoteTarjetasDeb";		-- Llave Parametro: Lote tarjetas
	SET Var_LlaveJobLoteTarSAFI 	:= "LoteTarjetasDebSAFI";	-- Llave Parametro: Lote tarjetas SAFI
	SET Var_LlaveTipoRegula			:= "TipoRegulatorios";		-- Llave Parametro: tipo de regulatorios a Generar
	SET Var_LlaveKtrListas			:= "RutaCargaListasPLD";	-- Llave Parámetro: JOB de Carga de Listas PLD
	SET Var_LlaveKtrBusqListas		:= "BusquedaListasPLD";		-- Llave Parámetro: JOB de Busqueda en Listas PLD
	SET Var_LlaveTipoConTD			:= "ConexionTarjetas";		-- Llave Parámetro: Tipo de Conexión de Tarjeta de Debito
    SET Var_LlaveSaldoFega			:= "SaldoFega";				-- Llave Parámetro: Saldo para garantia FEGA
    SET Var_LlaveSaldoFonaga		:= "SaldoFonaga";			-- Llave Parámetro: Saldo para garantia FONAGA
    SET Var_LlaveCteEspecifico		:= "CliProcEspecifico";		-- Llave Parámetro: Obtener el Cliente Específico
	SET Var_LlaveODEdoCta 			:= "OrigenDatosEdoCta";		-- Consulta para origen de datos de estado de cuenta. Cardinal Sistemas Inteligentes
	SET Var_LlaveArchivosPerdida	:= "ArchivosPerdidaEsp";
	SET Var_RutaPropConexionesSAFI	:= "RutaPropConexionesSAFI";
	SET Var_LlaveArchivosMonitoreo	:= "ArchivosMonitorAgro";
    SET Var_LlaveNumHabitantes 		:= "NumHabitantesLocalidad";
    SET Var_LlaveIPServGenEdoCta 	:= "IPServidorGeneracionEdoCta";		-- Llave para consultar la IP del Servidor de Generacion de estados de Cuenta
	SET Var_LlaveUsuServGenEdoCta 	:= "UsuarioServidorGeneracionEdoCta";	-- Llave para consultar el Usuario para  archivo de conexiones safi
	SET Var_RecupMasivaCarteraKTR 	:= "CondonaMasivoKTR";					-- Llave para consultar la ruta del archivo ktr de recuperacion masiva de cartera castigada
	SET Var_CastMasivoCarteraKTR 	:= "CastigoMasivoKTR";					-- Llave para consultar la ruta del archivo ktr de Castigo masivo de cartera castigada
    SET Var_PagosXRef				:= "PagosXReferencia"; 					-- Llave para consulta el valor de PagoXReferencia
    SET Var_CobraAccesorios			:= "CobraAccesorios"; 					-- Llave para consulta el valor de Cobro de Accesorios
    SET Var_PorceMaxCrediAutomatico	:= "PorceMaxCrediAutomatico";			-- Llave para consulta el valor de porcentaje a utilizar por creditos automaticos
    SET Var_GarFinanciada			:= "CobraGarantiaFinanciada";			-- Llave para consultar el valor de Garantias Financiadas
	SET Var_LlaveSHListas			:= "SHListasPLD";						-- Llave Parámetro: Script Shell para codificación del archivo de carga.
	SET Var_LlaveEncodeListas		:= "EncodeListasPLD";					-- Llave Parámetro: Indica si el archivo de carga deberá codificarse en UTF8.
	SET Var_ModificaMontoCred		:= "ModificaMontoCred";					-- Llave Parametro: Indica si se realiza modificacion del Monto de Credito
	SET Var_PermiteResidentesExt	:= "PermiteResidentesExt";				-- Llave Parametro: Indica si la institucion podra registrar personas residentes en el extranjero
	SET Var_PermiteBotonExcel		:= "PermiteBotonExcel";					-- Llave Parametro: Indica si se permite ver el boton excel en la pantalla de reportes financieros
	SET Var_HabilitaConfPass		:= "HabilitaConfPass";					-- Llave Parametro: Indica si la contrasenia requiere configuracion
	SET Llave_AutorizaHuellaCliente := 'AutorizaHuellaCliente';
	SET Var_TipoRepXMLPLD			:= 'TipoRepXMLPLD';						-- Llave Parámetro: Tipo de Formato Reportes PLD.
	SET Var_PerfilEdicionExpediente	:= 'PerfilEdicionExpediente';			-- Llave Parámetro: Perfil de Edicion Expediente para Analisis de credito
    SET Var_ManejaConvenio			:= 'ManejaCovenioNomina';				--
    SET Var_AplicaTabla             := 'AplicaTablaReal';                   -- Llave Parametro: Indica si aplica tabla real
	SET Var_AplicaCalculoCAT		:= "AplicaCalculoCAT";
	SET Var_DispersionSantander		:= 'DispersionSantander';				-- Llave Parametros Para dipersion Santander
	SET Var_ConexionKTRSantander	:= 'ArchivConexionKTRSan';				-- Llave Parametros Para las conexiones de proceso de archivos de repuesta de Santander
	SET Var_ManejaSPEI				:= 'ManejaSPEI';

	SET Var_RutaCarpetaEjecutablesETL	:= 'RutaCarpetaEjecutablesETL';	-- Llave para consultar La ruta de los ejecutables de los ETL.
	SET Var_RutaCarpetaArchivosETL		:= 'RutaCarpetaArchivosETL';	-- Llave para consultar La ruta de los Archivos a cargar de los ETL.
	SET Var_LlavUrlRemesas			:= 'UrlWSRemesas';		-- Llave para consulta de la ruta del WS para el consumo de remesas SPEI
	SET Var_LlavPortNamRem			:= 'PortNameRemesas';	-- Llave para consulta del nombre del WS de Remesas
	SET Var_LlavTimeOutRem			:= 'TimeOutWSRemesas';	-- Llave para consulta del tiempo limite de espera para el consumo del WS de remesas
	SET Con_LlaveWS						 := "UrlServerWSFC";			-- LLave para la ruta de WS de FC
	SET Con_LlaveHeader				     := "TokenWS_FC";				-- LLave para los header del WS de FC
	SET Var_LlavTimeOutDesRem		:= 'TimeOutWSDescargaRemesas';			-- Llave para consulta del tiempo de espera para la descarga de remesas SPEI
	SET Llave_EjecucionBalanzaContable		:= 'EjecucionBalanzaContable';
	SET Llave_UserEjecucionBalanzaContable	:= 'UserEjecucionBalanzaContable';
	SET Con_LlaveEditSuc				:= 'EdicionBusquedaSucursal';	-- Llave para la consulta de Edita sucursal del cliente
    SET Var_RutaArchCargaFact		:= 'RutaCarpetaArchivosFacturas';		-- Llave parametro: Ruta de archivos de carga masiva de facturas
    SET Var_RutaEjecutablesFact		:= 'RutaCarpetaEjecutablesFacturas';	-- Llave parametro: Indica la ruta donde se encuentran los ETL's para carga masiva de facturas.

	SET Con_LlaveInstitucionBanorte		:= 'InstitucionBanorte';		-- Lave para consultar la institucion que corresponde a Barnorte(Valor del catalogo de INSTITUCIONES)
    SET Con_LlaveInstitucionTelecom		:= 'InstitucionTelecom';			-- Lave para consultar la institucion que corresponde a Telecom(Valor del catalogo de INSTITUCIONES)

	SET Var_LlavAutenWSPixel		:= 'TarAutenWSPixel';		-- Llave para autenticación en cadena base64 a los servicios de Pixel
	SET Var_LlavRutWSSegTarjeta		:= 'TarRutaWSCardSecurity';	-- Llave para consulta del WS de seguridad de tarjetas NIP.

	SET Var_LlavTokFirebase			:= 'BanTokenFirebase';		-- Llave para consulta del token de firebase.
	SET Var_LlavCodPaisSMS			:= 'BanCodPaisSMS';			-- Llave para consulta del codigo de pais para el envio de SMS.
	SET Var_LlavPublicKeySNS		:= 'BanPublicKeySNS';		-- Llave para consulta de la llave de acceso para el servicio de SNS.
	SET Var_LlavSecretKeySNS		:= 'BanSecretKeySNS';		-- Llave para consulta de la llave secreta para el servicio de SNS.
	SET Var_LlavEnvioSMSActivo		:= 'BanServicioSMS_SNS';	-- Llave para consulta del estatus del servicio de envio de SMS.
	SET Var_LlavWSBancas			:= 'BanRutaWS';				-- Llave para consulta de la ruta del WS de bancas.
	SET Var_LlavTokWSBan			:= 'BanTokenWS';			-- Llave para consulta del token del WS de bancas.

	# 1.- Campo para habilitar/deshabilitar Fecha en Dispersiones
	IF (Par_NumConsulta = ConHabilitaFechaDisp) THEN
		SET  Var_Valor := "HabilitaFechaDisp";
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Var_Valor;
	END IF;

	# 2.- Muestra campo para especificar fecha de antiguedad laboral en pantalla de cliente y datos socioeconomicos
	IF (Par_NumConsulta = ConDetLaboralCteConyug) THEN
		SET  Var_Valor := "DetLaboralCteConyug";
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
            WHERE	LlaveParametro	= Var_Valor;
	END IF;

	-- 3.-Consulta para Obtener la ruta de KTR de Envio de Correos de PLD
	IF (Par_NumConsulta = ConRutaKtrPLD) THEN
		SET  Var_Valor := "RutaCorreosPLD";
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
            WHERE	LlaveParametro	= Var_Valor;
	END IF;

    -- 4.-Consulta para los Parametros de Apertura de las Cajas Automaticas, Pademobile
    IF (Par_NumConsulta = Var_ConCajaPDM) THEN
		SELECT	LlaveParametro,ValorParametro
		  FROM PARAMGENERALES
			WHERE	LlaveParametro	= Var_LlaveCajaPDM
		      OR	LlaveParametro	= Var_LlavePrinPDM
		      OR	LlaveParametro	= Var_LlaveSucPDM;
	END IF;

	-- 5.-Consulta para Obtener la ruta de KTR de Envio de Correos de Banca Movil
	IF (Par_NumConsulta = Con_KtrMovil) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
            WHERE	LlaveParametro	= Var_LlaveKtrMovil;
	END IF;

	-- 6.-Consulta para Obtener la ruta de JOB de Carga de Listas
	IF (Par_NumConsulta = ConRutaKtrListas) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
            WHERE	LlaveParametro	= Var_LlaveKtrListas;
	END IF;

	-- 7.-Consulta para Obtener la ruta de JOB de Busqueda en Listas
	IF (Par_NumConsulta = ConRutaJobBusqListas) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
            WHERE	LlaveParametro	= Var_LlaveKtrBusqListas;
	END IF;

    -- 8.-Consulta para Obtener la ruta de JOB de Carga de Lote de Tarjetas
	IF (Par_NumConsulta = ConRutaJobLoteTar) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
            WHERE	LlaveParametro	= Var_LlaveJobLoteTar;
	END IF;

    -- 9 .- Consulta para obtener el tipo de regulatorios a Generar
    IF (Par_NumConsulta = ConTipoRegulatorios ) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
            WHERE	LlaveParametro	= Var_LlaveTipoRegula;
    END IF;

    -- 10 .- Consulta para obtener el tipo de conexión de Tarjeta de Debito
    IF (Par_NumConsulta = ConTipoConexionTD ) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
            WHERE	LlaveParametro	= Var_LlaveTipoConTD;
    END IF;

        -- 11 .- Consulta para obtener el saldo para aplicacion de garantia FEGA
    IF (Par_NumConsulta = ConSaldoFega ) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
            WHERE	LlaveParametro	= Var_LlaveSaldoFega;
    END IF;

        -- 12 .- Consulta para obtener el saldo para aplicacion de garantia FONAGA
    IF (Par_NumConsulta = ConSaldoFonaga ) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
            WHERE	LlaveParametro	= Var_LlaveSaldoFonaga;
    END IF;

	-- 13 .- Consulta para Obtener el Cliente Específico
	IF (Par_NumConsulta = ConCteEspecifico ) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE LlaveParametro = Var_LlaveCteEspecifico;
	END IF;

	-- 14. Consulta para origen de datos de estado de cuenta. Cardinal Sistemas Inteligentes
	IF (Par_NumConsulta = ConOrigenDatosEdoCta) THEN
		SELECT	LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Var_LlaveODEdoCta;
	END IF;
	# 15.- FIRA - Archivos de Perdida
	IF (Par_NumConsulta = ConArchivosPerdida) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Var_LlaveArchivosPerdida;
	END IF;

	# 16.- Ruta del Properties de las Conexiones SAFI
	IF (Par_NumConsulta = ConRutaPropConexSAFI) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Var_RutaPropConexionesSAFI;
	END IF;

	# 17.- FIRA - Archivos de Monitoreo
	IF (Par_NumConsulta = ConArchivosMonitoreo) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Var_LlaveArchivosMonitoreo;
	END IF;


	-- 18.- Consulta para obtener la IP del Servidor de Generacion de estados de Cuenta
	IF (Par_NumConsulta = ConIPServGenEdoCta) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Var_LlaveIPServGenEdoCta;
	END IF;

	-- 19.- Consulta para obtener el Usuario del Servidor de Generacion de estados de Cuenta
	IF (Par_NumConsulta = ConUsuServGenEdoCta) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Var_LlaveUsuServGenEdoCta;
	END IF;

     # 20.- Numero de Habitantes de una Localidad
	IF (Par_NumConsulta = ConNumeroHabitantes) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Var_LlaveNumHabitantes;
	END IF;
     # 21.- Consulta para obtener la ruta del KTR de Recuperación Masiva de Cartera Castigada
	IF (Par_NumConsulta = ConRecupMasivaCondona) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Var_RecupMasivaCarteraKTR;
	END IF;
     # 22.- Consulta para obtener la ruta del KTR de Castigo Masivo de Cartera Castigada
	IF (Par_NumConsulta = ConCastigoMasivaCondona) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Var_CastMasivoCarteraKTR;
	END IF;

    # 23.- Consulta para obtener si permite Pagos por Referencia
    IF(Par_NumConsulta = ConPagosXRef)THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
            WHERE LlaveParametro = Var_PagosXRef;
    END IF;

    # 24.- Consulta para obtener si permite el cobro de accesorios
    IF(Par_NumConsulta = ConCobroAccesorios)THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
            WHERE LlaveParametro = Var_CobraAccesorios;
    END IF;

     # 25.- Consulta para obtener el porcentaje maximo a utilizar por creditos automaticos
    IF(Par_NumConsulta = ConPorcCredAut)THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
            WHERE LlaveParametro = Var_PorceMaxCrediAutomatico;
    END IF;

     # 26.- Consulta para obtener si la garantia liquida se cobro o no de manera financiada
    IF(Par_NumConsulta = ConGarFinanciadas)THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
            WHERE LlaveParametro = Var_GarFinanciada;
    END IF;
    -- 27.-Consulta para Valida Huella Usuario
	IF (Par_NumConsulta = ConValidaHuellaUsuario) THEN
		SET  Var_Valor := "ValidaHuellaUsuario";
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
            WHERE	LlaveParametro	= Var_Valor;
	END IF;

	-- 28.-Consulta para Obtener la Ruta del Script Shell para codificación del archivo de carga PLD.
	IF (Par_NumConsulta = ConScriptShListasPLD) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE LlaveParametro	= Var_LlaveSHListas;
	END IF;

	-- 29.-Consulta si el archivo de carga PLD deberá codificarse en UTF8.
	IF (Par_NumConsulta = ConEncodeListasPLD) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE LlaveParametro	= Var_LlaveEncodeListas;
	END IF;

    -- 30.- Consulta si se realiza modificacion del Monto de Credito
	IF (Par_NumConsulta = ConModificaMontoCred) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE LlaveParametro	= Var_ModificaMontoCred;
	END IF;

	-- 31.- Consulta si la institucion podra registrar personas residentes en el extranjero
	IF (Par_NumConsulta = ConPermiteResidentesExt) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE LlaveParametro	= Var_PermiteResidentesExt;
	END IF;

	-- 32.- Consulta si permite ver el boton de excel en la pantalla de reportes financieros
	IF (Par_NumConsulta = ConPermiteBotonExcel) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE LlaveParametro	= Var_PermiteBotonExcel;
	END IF;

	-- 33.- Consulta para  verificar si requiere configuracion de contrasenia
	IF (Par_NumConsulta = ConHabilitaConfPass) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE LlaveParametro	= Var_HabilitaConfPass;
	END IF;

	-- 34.- Consulta para verificar si los reportes PLD se generan en XML.
	IF (Par_NumConsulta = ConTipoRepXMLPLD) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE LlaveParametro = Var_TipoRepXMLPLD;
	END IF;

	--  35 Consulta para validar la Autorizacion de Huella de Cliente
	IF (Par_NumConsulta = Con_AutorizaHuellaCliente) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE LlaveParametro = Llave_AutorizaHuellaCliente;
	END IF;

	-- 40.- Consulta el Perfil Expediente de Analisis
	IF (Par_NumConsulta = ConPerfilExpediente) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE LlaveParametro = Var_PerfilEdicionExpediente;
	END IF;

    -- 36.- Consulta para verificar si los reportes PLD se generan en XML.
	IF (Par_NumConsulta = Con_ManejaConvenio) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE LlaveParametro = Var_ManejaConvenio;
	END IF;

	-- 37.- Consulta para verificar si aplica tabla real a los creditos de nomina.
    IF (Par_NumConsulta = Con_AplicaTabla) THEN
        SELECT LlaveParametro,  ValorParametro
            FROM PARAMGENERALES
            WHERE LlaveParametro = Var_AplicaTabla;
    END IF;

    -- 38.- Consulta para validar si Crowdfunding está activo.
	IF (Par_NumConsulta = Con_Crowdfunding) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE LlaveParametro = 'ActivoModCrowd';
	END IF;

	-- 39.- Consulta si se muestra el campo Aplica Cálculo CAT
	IF (Par_NumConsulta = ConAplicaCalculoCAT) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE LlaveParametro = Var_AplicaCalculoCAT;
	END IF;

	-- 43.- Consulta si dispersa SANTANDER
	IF (Par_NumConsulta = ConDispersionSantander) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE LlaveParametro = Var_DispersionSantander;
	END IF;

    -- 44.- Consulta de conexiones de ktr para procesar archivos de respuesta SANTANDER
	IF (Par_NumConsulta = ConRutaConexionKTRSan) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE LlaveParametro = Var_ConexionKTRSantander;
	END IF;

	-- 41. Consulta de La ruta de los ejecutables de los ETL.
	IF (Par_NumConsulta = Con_RutaCarpetaEjecutablesETL) THEN
		SELECT	LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Var_RutaCarpetaEjecutablesETL;
	END IF;

	-- 42. Consultar de La ruta de los Archivos a cargar de los ETL.
	IF (Par_NumConsulta = Con_RutaCarpetaArchivosETL) THEN
		SELECT	LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Var_RutaCarpetaArchivosETL;
	END IF;

	-- 45. Consultar de La ruta de los Archivos a cargar de los ETL.
	IF (Par_NumConsulta = Con_ManejaSPEI) THEN
		SELECT	LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Var_ManejaSPEI;
	END IF;

	-- 47. Consulta de la ruta del WS para el consumo de remesas SPEI
	IF (Par_NumConsulta = Var_ConUrlRemesas) THEN
		SELECT	LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Var_LlavUrlRemesas;
	END IF;

	-- 48. -- Consulta del nombre del WS de Remesas
	IF (Par_NumConsulta = Var_ConPortNamRem) THEN
		SELECT	LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Var_LlavPortNamRem;
	END IF;

	-- 49. Consulta del tiempo limite de espera para el consumo del WS de remesas
	IF (Par_NumConsulta = Var_ConTimeOutRem) THEN
		SELECT	LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Var_LlavTimeOutRem;
	END IF;

	-- 50. Ruta WS FC
	IF (Par_NumConsulta = Con_RutaWSFC) THEN
		SELECT LlaveParametro,	ValorParametro
		FROM PARAMGENERALES
		WHERE LlaveParametro = Con_LlaveWS;
	END IF;

	-- 51. Autorization WS FC
	IF (Par_NumConsulta = Con_HeaderWSFC) THEN
		SELECT LlaveParametro,	ValorParametro
		FROM PARAMGENERALES
		WHERE LlaveParametro = Con_LlaveHeader;
	END IF;
	-- 52. Consulta del tiempo de espera para la descarga de remesas SPEI
	IF (Par_NumConsulta = Var_ConTimeOutDesRem) THEN
		SELECT	LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Var_LlavTimeOutDesRem;
	END IF;

    -- 58. Consulta si permite la editar la sucursal del cliente
	IF (Par_NumConsulta = Con_EditaSucursal) THEN
		SELECT	LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Con_LlaveEditSuc;
	END IF;

	-- 53.- Consulta si existe una Ejecucion de Balanza Contable
	IF (Par_NumConsulta = Con_EjecucionBalanzaContable) THEN
		SELECT	LlaveParametro,	ValorParametro
		FROM PARAMGENERALES
		WHERE LlaveParametro = Llave_EjecucionBalanzaContable;
	END IF;

	-- 54.- Consulta si existe una Ejecucion de Balanza Contable
	IF (Par_NumConsulta = Con_UserEjecucionBalanzaContable) THEN
		SELECT	LlaveParametro,	ValorParametro
		FROM PARAMGENERALES
		WHERE LlaveParametro = Llave_UserEjecucionBalanzaContable;
	END IF;

    -- 100.- Ruta donde se almacenan los archivos para carga masiva de facturas
	IF (Par_NumConsulta = ConRutaArchivosFact) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE LlaveParametro = Var_RutaArchCargaFact;
	END IF;

	-- 57.- Consulta variable de servicio SMS
	IF (Par_NumConsulta = Var_ConEnvioSMSActivo) THEN
		SELECT	LlaveParametro,	ValorParametro
		FROM PARAMGENERALES
		WHERE LlaveParametro = Var_LlavEnvioSMSActivo;
	END IF;

	-- 58.- Ruta de los ejecutables para la carga masiva de facturas (ETLs,SHs)
	IF (Par_NumConsulta = ConRutaEjecutablesFact) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE LlaveParametro = Var_RutaEjecutablesFact;
	END IF;

    -- 59. Consulta la institucion que corresponde a Banorte(Valor del catalogo de INSTITUCIONES)
	IF (Par_NumConsulta = Con_InstitucionBanorte) THEN
		SELECT	LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Con_LlaveInstitucionBanorte;
	END IF;

    -- 60. Consulta la institucion que corresponde a Telecom(Valor del catalogo de INSTITUCIONES)
	IF (Par_NumConsulta = Con_InstitucionTelecom) THEN
		SELECT	LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Con_LlaveInstitucionTelecom;
	END IF;

	-- 61.-Consulta para Obtener la ruta de JOB de Carga de Lote de Tarjetas TGS
	IF (Par_NumConsulta = ConRutaJobLoteTarSAFI) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
            WHERE	LlaveParametro	= Var_LlaveJobLoteTarSAFI;
	END IF;

	IF (Par_NumConsulta = Var_ConWSBancas) THEN
		SELECT	LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Var_LlavWSBancas;
	END IF;


	IF (Par_NumConsulta = Var_ConTokenWSBancas) THEN
		SELECT	LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE	LlaveParametro = Var_LlavTokWSBan;
	END IF;

	# 103.- Parámetro que indica si los Depósitos Referenciados se pueden aplicar o no en Meses Anteriores al Mes de la Fecha del Sistema.
	IF (Par_NumConsulta = Con_DepRefMesAnterior) THEN
		SET Var_Valor := "DepRefMesAnterior";
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE LlaveParametro = Var_Valor;
	END IF;

	# 104.-Parámetro que indica si la busqueda desde java se encuentra habilitado o no.
	IF (Par_NumConsulta = Con_BusqListasLV) THEN
		SET Var_Valor := "PLD_BusqListasLV";
		SELECT LlaveParametro,	ValorParametro
			FROM PARAMGENERALES
			WHERE LlaveParametro = Var_Valor;
	END IF;

	# 105.-Parámetro que indica el porcentaje minimo de búsqueda en java.
	IF (Par_NumConsulta = Con_PorcMinLVPLD) THEN
		SELECT
			'PorcCoincidencias' AS LlaveParametro,PorcCoincidencias AS ValorParametro
		FROM PARAMETROSSIS LIMIT 1;
	END IF;
END TerminaStore$$
