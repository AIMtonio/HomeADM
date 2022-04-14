DELIMITER ;
DROP procedure IF EXISTS `FONDEOCLICREWSLIS`;

DELIMITER $$
CREATE  PROCEDURE `FONDEOCLICREWSLIS`(
# ================================================================
# ------ STORE para extraer información general del cliente y del crédito que se enviarán a los diversos fondeadores o administrador.(WS) -------
# ================================================================
    Par_CreditoID			TEXT,				-- Numero de Creditos, separados por coma
    Par_Etiqueta			CHAR(1),			-- Etiqueta del credito
    Par_InstitutFondeoID	INT(11),			-- Numero de la institucion de fondeo 0 en caso de recursos propios, -1 en caso de toda la cartera sin importar el fondeador.
    Par_ProductoCreditoID	TEXT,				-- Numero de Producto de Credito, separados por coma
    Par_InstitNominaID 		INT(11),			-- Id de institucion de fondeo

    Par_FechaCorte			VARCHAR(10),		-- Fecha de Corte
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista

	Aud_EmpresaID       	INT(11),			-- Parametro de Auditoria ID de la Empresa
    Aud_Usuario         	INT(11),			-- Parametro de Auditoria ID del Usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de Auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de Auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de Auditoria ID de la Sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de Auditoria Numero de la Transaccion

	)
TerminaStore: BEGIN


-- Declaracion de Variables
DECLARE Var_Sentencia 		TEXT;	-- Almacena la Sentencia de la Consulta
DECLARE Var_FechaSistema	DATE;			-- Almacena la Fecha del Sistema
DECLARE	Var_FechaCorte		DATE;			-- Fecha corte 

-- Declaracion de Constantes
DECLARE Entero_Cero    		INT(11);		-- Entero Cero
DECLARE Decimal_Cero		DECIMAL(14,2);	-- Decimal Cero
DECLARE Cadena_Vacia   		CHAR(1);		-- Cadena Vacia
DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia

DECLARE Lis_Cliente			INT(11);		-- Lista de clientes
DECLARE Lis_Conyugue		INT(11);		-- Lista de Conyugue
DECLARE Lis_Identifi		INT(11);		-- Lista de Identificaciones
DECLARE Lis_Direc			INT(11);		-- Lista de Direcciones
DECLARE Lis_Creditos		INT(11);		-- Lista de Creditos
DECLARE Lis_expCliente		INT(11);		-- Lista de Exp Cliente
DECLARE Lis_expCuenta		INT(11);		-- Lista de Exp Cuenta
DECLARE Lis_expSolCred		INT(11);		-- Lista de Exp Sol Credito
DECLARE Lis_expCred			INT(11);		-- Lista de Exp Credito
   
DECLARE	Par_NumErr 			INT(11);				
DECLARE	Par_ErrMen 			VARCHAR(400);	
DECLARE Est_Vigente	  		CHAR(1);	
DECLARE Est_Vencido	  		CHAR(1);		
DECLARE Est_Castigado  		CHAR(1);		
DECLARE Est_Suspendido  	CHAR(1);			
DECLARE Est_Pagado		  	CHAR(1);		
DECLARE	Var_AdFiMa			CHAR(1);  -- Valor B  es ADMINISTRADOR DEL FIDEICOMISO MAESTRO	

-- Asignacion de Constantes
SET Entero_Cero				:= 0; 				-- Entero Cero
SET Decimal_Cero        	:= 0.00;			-- Decimal Cero
SET Cadena_Vacia			:= '';    			-- Cadena Vacia
SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia

SET Lis_Cliente				:= 1; 				-- Lista de clientes
SET Lis_Conyugue			:= 2; 				-- Lista de Conyugue
SET Lis_Identifi			:= 3; 				-- Lista de Identificaciones
SET Lis_Direc				:= 4; 				-- Lista de Direcciones
SET Lis_Creditos			:= 5; 				-- Lista de Creditos
SET Lis_expCliente			:= 6; 				-- Lista de Exp Cliente
SET Lis_expCuenta			:= 7; 				-- Lista de Exp Cuenta
SET Lis_expSolCred			:= 8; 				-- Lista de Exp Sol Credito
SET Lis_expCred				:= 9; 				-- Lista de Exp Credito
SET Est_Vigente				:= 'V';    			-- Estatus Vigente 
SET Est_Vencido				:= 'B';    			-- Estatus Vencido
SET Est_Castigado			:= 'K';    			-- Estatus Castigado
SET Est_Suspendido			:= 'S';    			-- Estatus Suspendido
SET Est_Pagado				:= 'P';    			-- Estatus Pagado

SET Par_NumErr				:= 000000;
SET Par_ErrMen				:= 'Datos Consultados Exitosamente';
SET Var_Sentencia			:= '';
SET Var_AdFiMa       		:= 'B'; -- Valor B  es ADMINISTRADOR DEL FIDEICOMISO MAESTRO
SET Var_FechaSistema		:= (SELECT FechaSistema  FROM PARAMETROSSIS WHERE EmpresaID=1);

IF(IFNULL(Par_FechaCorte, Cadena_Vacia)) = Cadena_Vacia THEN
	SET Par_FechaCorte 		:= '1900-01-01';
END IF;
SET Var_FechaCorte			:= STR_TO_DATE(Par_FechaCorte,'%Y-%m-%d');
SET Par_CreditoID 			:= IFNULL(Par_CreditoID, Cadena_Vacia);

-- SI SE RECIBE VALOR EN CREDITO SE IGNORAN LOS FILTROS 
IF(IFNULL(Par_CreditoID, Cadena_Vacia)) != Cadena_Vacia THEN
	SET Par_InstitutFondeoID	:= -1;
	SET Par_Etiqueta			:= Cadena_Vacia;
	SET Par_ProductoCreditoID	:= Cadena_Vacia;
	SET Par_InstitNominaID		:= Entero_Cero;
    SET Var_FechaCorte			:= Fecha_Vacia;
END IF;


		
DROP TABLE IF EXISTS TMPFONDEOCLICREWSLIS;
CREATE TEMPORARY TABLE TMPFONDEOCLICREWSLIS(
	-- Datos Cliente
	clienteID 				int(11), 		-- Id del cliente en Safi	,
	primerNombre 			varchar(50), 	-- Primer Nombre del Cliente',
	segundoNombre 			varchar(50), 	-- Segundo Nombre del Cliente\n',
	tercerNombre 			varchar(50), 	-- Tercer nombre del cliente	
	primerApellido 			varchar(50),	-- Apellido paterno del cliente		
	segundoApellido 		varchar(50),	-- Apellido materno del cliente	
	CURP 					char(18), 		-- Clabe unica de registro de población del cliente
	RFC 					char(13),		-- RFC del cliente		
	puestoCliente 			varchar(100),	-- Ultimo puesto de trabajo del cliente		
	correoElectronico 		varchar(50), 	-- Correo electrónico del cliente	

	telefonoDomicilio 		varchar(20), 	-- Teléfono del domicilio del cliente	
	telefonoCelular 		varchar(20), 	-- Teléfono celular del cliente
	fechaNacimiento 		date,			-- Fecha de nacimiento Cliente	
	estadoNacimientoID 		int(11), 		-- Id del estado de nacimiento del cliente, con base en catalogo de Safi.	
	genero 					char(1), 		-- Genero del cliente H=hombre M=Mujer
	estadoCivilID 			char(2),		-- Id del estado civil del cliente		
	numeroDependientes		int(11),		-- Cantidad de personas que dependen del cliente	PENDIENTE
	
	creditoID 				bigint(12), 	-- Número único asignado al crédito por Safi	
	fechaOtorgamiento 		date,			-- Fecha en que se otorgó el crédito, es decir, la fecha en que se desembosó.
	productoID 		 		int(4),			-- Producto al cual pertenece el crédito
	estatusCreditoID		char(1),		-- Estatus del Credito, no se pide en el alta. Nace inactivo\nI .- Inactivo\nA.- Autorizado\nV.- Vigente\nP .- Pagado\nC .- Cancelado\nB.- Vencido\nK.- Castigado\nS.-Suspendido',
	fechaDocumentacion		date,			-- FFecha de la firma del contrato, en el caso de Safi, es la fecha en que se genera el pagaré.
	fechaUltimoPago			date,			-- Es la fecha del último pago teórico que se fija en la tabla de amortización			
	plazo 					int(11),		-- Plazo del crédito en meses (ejemplo si es a 48 meses debe venir: 48)		
    montoOtorgado			decimal(12,2),  	-- Monto real que se entregó al cliente.				
	plazosRestantes			int(11),		-- Plazos restantes que tiene el cliente a la fecha, es decir, Número de cuotas no pagadas o con saldos pendientes.	
	CLABEDomiciliar			varchar(18),	-- CLABE que se tiene registrada del cliente a la cual se le domiciliará el cobro
	saldoRestante			decimal(12,2),	-- Saldo restante que se tiene a la fecha [Saldo total de las cuotas no pagadas con base en calendario ideal (pagaré) y no con relación a tabla de amortizaciones]	
	institucionID	 		int(11), 		--	Id de la institución de nómina a la que pertenece el crédito				
	frecuenciaCapital		char(1),		-- Frecuencia correspondiente al capital				
	
	frecuenciaInteres		char(1),		-- Frecuencia correspondiente al interés				
	montoPagare				decimal(12,2),	-- Monto Total a pagar del crédito (Capital, Intereses, IVAs, Accesorios, Comisiones, Seguros)	
	montoPago				decimal(12,2),	-- Pago que el cliente estará realizando por cuota (Capital, Intereses, IVAs, Accesorios, Comisiones, Seguros)
	tasa					decimal(12,4),	-- Tasa fija anualizada del crédito		
	FondeadorID				int(11),		-- Identificador (ID) del fondeador al que pertenece el crédito	

	CuentaAhoID 			bigint(12),		-- ID de la cuenta
	solicitudCreditoID		bigint(12),		-- ID de la cuenta	
	tipoFondeador			char(1),		-- TIPO DE FONDEADOR 	
	EtiquetaFondeo			char(1),		-- Estatus del Fondeo, nace como No Enviado \nN = No enviado \nE = Envio de cartera etiquetado \nC = Cedido
	EtiquetaAFM				char(1)			-- Etiqueta del Administrador del Fideicomiso Maestro, N = No enviado \nE = Envio de cartera etiquetado
	);
		
DROP TABLE IF EXISTS TMPFONDEOCLICREWSLIS_0;
CREATE TEMPORARY TABLE TMPFONDEOCLICREWSLIS_0(
	-- Datos Cliente
	clienteID 				int(11), 		-- Id del cliente en Safi	,
	primerNombre 			varchar(50), 	-- Primer Nombre del Cliente',
	segundoNombre 			varchar(50), 	-- Segundo Nombre del Cliente\n',
	tercerNombre 			varchar(50), 	-- Tercer nombre del cliente	
	primerApellido 			varchar(50),	-- Apellido paterno del cliente		
	segundoApellido 		varchar(50),	-- Apellido materno del cliente	
	CURP 					char(18), 		-- Clabe unica de registro de población del cliente
	RFC 					char(13),		-- RFC del cliente		
	puestoCliente 			varchar(100),	-- Ultimo puesto de trabajo del cliente		
	correoElectronico 		varchar(50), 	-- Correo electrónico del cliente	

	telefonoDomicilio 		varchar(20), 	-- Teléfono del domicilio del cliente	
	telefonoCelular 		varchar(20), 	-- Teléfono celular del cliente
	fechaNacimiento 		date,			-- Fecha de nacimiento Cliente	
	estadoNacimientoID 		int(11), 		-- Id del estado de nacimiento del cliente, con base en catalogo de Safi.	
	genero 					char(1), 		-- Genero del cliente H=hombre M=Mujer
	estadoCivilID 			char(2),		-- Id del estado civil del cliente		
	numeroDependientes		int(11),		-- Cantidad de personas que dependen del cliente	PENDIENTE
	
	creditoID 				bigint(12), 	-- Número único asignado al crédito por Safi	
	fechaOtorgamiento 		date,			-- Fecha en que se otorgó el crédito, es decir, la fecha en que se desembosó.
	productoID 		 		int(4),			-- Producto al cual pertenece el crédito
	estatusCreditoID		char(1),		-- Estatus del Credito, no se pide en el alta. Nace inactivo\nI .- Inactivo\nA.- Autorizado\nV.- Vigente\nP .- Pagado\nC .- Cancelado\nB.- Vencido\nK.- Castigado\nS.-Suspendido',
	fechaDocumentacion		date,			-- FFecha de la firma del contrato, en el caso de Safi, es la fecha en que se genera el pagaré.
	fechaUltimoPago			date,			-- Es la fecha del último pago teórico que se fija en la tabla de amortización			
	plazo 					int(11),		-- Plazo del crédito en meses (ejemplo si es a 48 meses debe venir: 48)		
    montoOtorgado			decimal(12,2),  	-- Monto real que se entregó al cliente.				
	plazosRestantes			int(11),		-- Plazos restantes que tiene el cliente a la fecha, es decir, Número de cuotas no pagadas o con saldos pendientes.	
	CLABEDomiciliar			varchar(18),	-- CLABE que se tiene registrada del cliente a la cual se le domiciliará el cobro
	saldoRestante			decimal(12,2),	-- Saldo restante que se tiene a la fecha [Saldo total de las cuotas no pagadas con base en calendario ideal (pagaré) y no con relación a tabla de amortizaciones]	
	institucionID	 		int(11), 		--	Id de la institución de nómina a la que pertenece el crédito				
	frecuenciaCapital		char(1),		-- Frecuencia correspondiente al capital				
	
	frecuenciaInteres		char(1),		-- Frecuencia correspondiente al interés				
	montoPagare				decimal(12,2),	-- Monto Total a pagar del crédito (Capital, Intereses, IVAs, Accesorios, Comisiones, Seguros)	
	montoPago				decimal(12,2),	-- Pago que el cliente estará realizando por cuota (Capital, Intereses, IVAs, Accesorios, Comisiones, Seguros)
	tasa					decimal(12,4),	-- Tasa fija anualizada del crédito		
	FondeadorID				int(11),		-- Identificador (ID) del fondeador al que pertenece el crédito	

	CuentaAhoID 			bigint(12),		-- ID de la cuenta
	solicitudCreditoID		bigint(12),		-- ID de la cuenta	
	tipoFondeador			char(1),		-- TIPO DE FONDEADOR 	
	EtiquetaFondeo			char(1),		-- Estatus del Fondeo, nace como No Enviado \nN = No enviado \nE = Envio de cartera etiquetado \nC = Cedido
	EtiquetaAFM				char(1)			-- Etiqueta del Administrador del Fideicomiso Maestro, N = No enviado \nE = Envio de cartera etiquetado
	);


DROP TABLE IF EXISTS TMPFONDEOCLICREWSLIS_1;
CREATE TEMPORARY TABLE TMPFONDEOCLICREWSLIS_1(
	-- Datos Cliente
	numeroDependientes		int(11),	-- Cantidad de personas que dependen del cliente	
	clienteID 				int(11) 	-- Id del cliente en Safi	,
	);


DROP TABLE IF EXISTS TMPFONDEOCLICREWSLIS_2;
CREATE TEMPORARY TABLE TMPFONDEOCLICREWSLIS_2(
	creditoID 				bigint(12), 
	fechaUltimoPago			date
);

DROP TABLE IF EXISTS TMPFONDEOCLICREWSLIS_3;
CREATE TEMPORARY TABLE TMPFONDEOCLICREWSLIS_3(
	plazosRestantes			INT(11),
	creditoID 				bigint(12)
);

DROP TABLE IF EXISTS TMPFONDEOCLICREWSLIS_4;
CREATE TEMPORARY TABLE TMPFONDEOCLICREWSLIS_4(
	saldoRestante			decimal(12,2),
	creditoID 				bigint(12)
);

SET Var_Sentencia := CONCAT(Var_Sentencia, ' INSERT INTO TMPFONDEOCLICREWSLIS_0 ');
SET Var_Sentencia := CONCAT(Var_Sentencia, ' SELECT  ');
	-- Seccion de Cliente
SET Var_Sentencia := CONCAT(Var_Sentencia, ' CLI.ClienteID,				CLI.PrimerNombre,		CLI.SegundoNombre,		CLI.TercerNombre,		CLI.ApellidoPaterno, ' );
SET Var_Sentencia := CONCAT(Var_Sentencia, ' CLI.ApellidoMaterno,		CLI.CURP,				CLI.RFCOficial,			CLI.Puesto,				CLI.Correo, ' );
SET Var_Sentencia := CONCAT(Var_Sentencia, ' CLI.Telefono,				CLI.TelefonoCelular,	CLI.FechaNacimiento,	CLI.EstadoID, 			' );
SET Var_Sentencia := CONCAT(Var_Sentencia, " CASE WHEN CLI.Sexo = 'M' THEN 'H' WHEN CLI.Sexo = 'F' THEN 'M' ELSE CLI.Sexo END ,  " );

SET Var_Sentencia := CONCAT(Var_Sentencia, ' CLI.EstadoCivil, 			0, ' );
-- datos de credito
SET Var_Sentencia := CONCAT(Var_Sentencia, ' CRE.CreditoID,				CRE.FechaMinistrado,	CRE.ProductoCreditoID,	CRE.Estatus,			CRE.FechaAutoriza, ' );
SET Var_Sentencia := CONCAT(Var_Sentencia, " '1900-01-01',				CRE.NumAmortizacion,	CRE.MontoCredito,		0,						CRE.Clabe, ");
SET Var_Sentencia := CONCAT(Var_Sentencia, '  0,						CRE.InstitNominaID,		CRE.FrecuenciaCap,		CRE.FrecuenciaInt,		0 as 	montoPagare, ' );
SET Var_Sentencia := CONCAT(Var_Sentencia, ' CRE.MontoCuota,			CRE.TasaFija,			CRE.InstitFondeoID,		CRE.CuentaID,			CRE.SolicitudCreditoID, ' );
SET Var_Sentencia := CONCAT(Var_Sentencia, ' INS.TipoFondeador,			EtiquetaFondeo,			EtiquetaAFM' );
SET Var_Sentencia := CONCAT(Var_Sentencia, ' FROM CLIENTES	CLI ' );
SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN CREDITOS CRE ON CLI.ClienteID  = CRE.ClienteID ' );
SET Var_Sentencia := CONCAT(Var_Sentencia, '  AND CRE.Estatus in ( "', Est_Vigente,'","',Est_Vencido,'","',Est_Castigado,'","',Est_Suspendido,'") ' );
SET Var_Sentencia := CONCAT(Var_Sentencia, ' LEFT OUTER JOIN INSTITUTFONDEO INS ON INS.InstitutFondID  = CRE.InstitFondeoID ' );

-- Numero de la institucion de fondeo 0 en caso de recursos propios, -1 en caso de toda la cartera sin importar el fondeador.
IF ( Par_InstitutFondeoID = -1) THEN
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHERE ' );
else 
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHERE  CRE.InstitFondeoID = ', Par_InstitutFondeoID , ' AND ');
END IF;

IF( IFNULL(Var_FechaCorte, Fecha_Vacia) != Fecha_Vacia) THEN
	SET Var_Sentencia := CONCAT(Var_Sentencia, '  CRE.FechaMinistrado <= "', Var_FechaCorte  ,'" ');
ELSE
	SET Var_Sentencia := CONCAT(Var_Sentencia, '  CRE.FechaMinistrado <= "', Var_FechaSistema  ,'" ');
END IF;

IF( IFNULL(Par_CreditoID, Cadena_Vacia) != Cadena_Vacia) THEN
	SET Par_CreditoID := concat(REPLACE(Par_CreditoID,',',"','"));
	SET Var_Sentencia := CONCAT(Var_Sentencia, " AND CRE.CreditoID in ('", Par_CreditoID ,"')");
END IF;

IF( IFNULL(Par_ProductoCreditoID, Cadena_Vacia) != Cadena_Vacia) THEN
	SET Par_ProductoCreditoID := concat(REPLACE(Par_ProductoCreditoID,',',"','"));
	SET Var_Sentencia		  := CONCAT(Var_Sentencia, " AND CRE.ProductoCreditoID in ('", Par_ProductoCreditoID ,"')");
END IF;


IF( IFNULL(Par_InstitNominaID, Entero_Cero) != Entero_Cero) THEN
	SET Var_Sentencia := CONCAT(Var_Sentencia, " AND CRE.InstitNominaID = ", Par_InstitNominaID  );
END IF;

 
SET Var_Sentencia := CONCAT(Var_Sentencia,' ; ');

SET @Sentencia	= (Var_Sentencia);
PREPARE Ejecuta FROM @Sentencia;
EXECUTE Ejecuta;
DEALLOCATE PREPARE Ejecuta;

-- SE REALIZA EL FILTRADO POR ETIQUETA 
IF( IFNULL(Par_Etiqueta, Cadena_Vacia) != Cadena_Vacia) THEN
	INSERT INTO TMPFONDEOCLICREWSLIS
		SELECT * FROM TMPFONDEOCLICREWSLIS_0 
			WHERE TipoFondeador = Var_AdFiMa
				AND EtiquetaAFM = Par_Etiqueta;
	INSERT INTO TMPFONDEOCLICREWSLIS
		SELECT * FROM TMPFONDEOCLICREWSLIS_0 
			WHERE TipoFondeador != Var_AdFiMa
				AND  EtiquetaFondeo = Par_Etiqueta;
ELSE 
	INSERT INTO TMPFONDEOCLICREWSLIS
		SELECT * FROM TMPFONDEOCLICREWSLIS_0;
END IF;

IF(Par_NumLis = Lis_Cliente) THEN -- 1
	-- SE ACTUALIZAN LOS VALORES PARA LOS DEPENDIENTES DEL CLIENTE 
	INSERT INTO TMPFONDEOCLICREWSLIS_1 
	select count(SOC.ClienteID), SOC.ClienteID 
		from SOCIODEMODEPEND SOC
			inner join TMPFONDEOCLICREWSLIS TMP on SOC.ClienteID = TMP.ClienteID 
	group by ClienteID;

	UPDATE 	TMPFONDEOCLICREWSLIS CLI, 
			TMPFONDEOCLICREWSLIS_1 TMP SET 
		CLI.numeroDependientes = TMP.numeroDependientes 
	WHERE CLI.ClienteID = TMP.ClienteID;

	select 	Par_NumErr AS codigoRespuesta,					Par_ErrMen as mensajeRespuesta,				max(clienteID)as clienteID,					max(primerNombre)as primerNombre,		max(segundoNombre)as segundoNombre,
			max(TercerNombre)as TercerNombre,				max(primerApellido)as primerApellido,		max(segundoApellido)as segundoApellido,		max(CURP)as CURP,						max(RFC)as RFC,
			max(puestoCliente)as puestoCliente,				max(correoElectronico)as correoElectronico,	max(telefonoDomicilio)as telefonoDomicilio,	max(telefonoCelular)as telefonoCelular,	max(fechaNacimiento)as fechaNacimiento,
			max(estadoNacimientoID)as estadoNacimientoID,	max(genero)as genero,						max(estadoCivilID)as estadoCivilID,			max(numeroDependientes)	as numeroDependientes	
		FROM TMPFONDEOCLICREWSLIS TMP
		group by clienteID;
END IF;

IF(Par_NumLis = Lis_Conyugue) THEN -- 2
	select 	Par_NumErr AS codigoRespuesta,			Par_ErrMen AS mensajeRespuesta,				max(SOC.ClienteID)as ClienteID , 			max(SOC.PrimerNombre) as PrimerNombre,	max(SOC.SegundoNombre) as SegundoNombre, 	
			max(SOC.TercerNombre)as TercerNombre,	max(SOC.ApellidoPaterno)as ApellidoPaterno,	max(SOC.ApellidoMaterno)as ApellidoMaterno
		from SOCIODEMOCONYUG SOC
		INNER JOIN TMPFONDEOCLICREWSLIS TMP ON TMP.ClienteID = SOC.ClienteID
		group by TMP.ClienteID, ClienteConyID;

END IF;

IF(Par_NumLis = Lis_Identifi) THEN -- 3
	SELECT 	Par_NumErr AS codigoRespuesta,			Par_ErrMen AS mensajeRespuesta,	max(IDE.ClienteID) as ClienteID,	max(IDE.IdentificID)as IdentificID, 		max(IDE.TipoIdentiID)as TipoIdentiID,
			max(IDE.NumIdentific)as NumIdentific,	max(IDE.FecExIden)as FecExIden,	max(IDE.FecVenIden)as FecVenIden
		FROM TMPFONDEOCLICREWSLIS TMP
		INNER JOIN IDENTIFICLIENTE IDE  ON TMP.ClienteID = IDE.ClienteID
		group by  IDE.ClienteID,	IDE.IdentificID;
END IF;

IF(Par_NumLis = Lis_Direc) THEN -- 4 
	SELECT 	Par_NumErr AS codigoRespuesta,	Par_ErrMen AS mensajeRespuesta,				max(DIR.ClienteID)as ClienteID,		max(DIR.DireccionID)as DireccionID,	max(DIR.TipoDireccionID)as TipoDireccionID,
			max(DIR.EstadoID)as EstadoID,	max(EST.AbreviaEntidad)as AbreviaEntidad,	max(DIR.MunicipioID)as MunicipioID,	max(DIR.LocalidadID)as LocalidadID,	max(DIR.Colonia)as Colonia,
			max(loc.NombreLocalidad)as Ciudad,		max(DIR.Calle)as Calle,						max(DIR.NumeroCasa)as NumeroCasa,	max(DIR.NumInterior)as NumInterior,	max(DIR.CP)as CP
		FROM TMPFONDEOCLICREWSLIS	CLI
	LEFT  JOIN DIRECCLIENTE 	DIR ON CLI.ClienteID 	= DIR.ClienteID
	INNER JOIN ESTADOSREPUB 	EST	ON DIR.EstadoID 	= EST.EstadoID 
	INNER JOIN MUNICIPIOSREPUB	MUN ON EST.EstadoID 	= MUN.EstadoID AND  DIR.MunicipioID = MUN.MunicipioID
	INNER JOIN LOCALIDADREPUB 	loc ON DIR.LocalidadID	= loc.LocalidadID 	AND loc.EstadoID=DIR.EstadoID AND loc.MunicipioID =DIR.MunicipioID
	group by  DIR.ClienteID,	DIR.DireccionID;
END IF;

IF(Par_NumLis = Lis_Creditos) THEN -- 5
    -- se obtiene la ultima fecha de pago 
    INSERT INTO TMPFONDEOCLICREWSLIS_2 
    	SELECT  Pag.CreditoID, MAX(Pag.FechaPago)
         FROM  DETALLEPAGCRE Pag
			inner join TMPFONDEOCLICREWSLIS TMP on Pag.CreditoID = TMP.creditoID 
	      GROUP BY Pag.CreditoID;

	UPDATE 	TMPFONDEOCLICREWSLIS CLI, 
			TMPFONDEOCLICREWSLIS_2 TMP SET 
		CLI.fechaUltimoPago = TMP.fechaUltimoPago   
	WHERE CLI.CreditoID = TMP.creditoID;

	-- se obtiene el numero de cuotas pendientes de pago
	INSERT INTO TMPFONDEOCLICREWSLIS_3
		SELECT count(AMO.CreditoID), AMO.CreditoID 
			FROM AMORTICREDITO AMO 
			INNER JOIN TMPFONDEOCLICREWSLIS TMP on AMO.CreditoID = TMP.creditoID AND AMO.Estatus != Est_Pagado 
		group by AMO.CreditoID;

	UPDATE 	TMPFONDEOCLICREWSLIS CLI, 
			TMPFONDEOCLICREWSLIS_3 TMP SET 
		CLI.plazosRestantes = TMP.plazosRestantes   
	WHERE CLI.CreditoID = TMP.creditoID;

	-- SE OBTIENE EL SALDO RESTANTE 
	INSERT INTO TMPFONDEOCLICREWSLIS_4
		SELECT SUM(PAG.Capital + PAG.Interes + PAG.IVAInteres), PAG.CreditoID
	FROM PAGARECREDITO PAG 
		INNER JOIN   AMORTICREDITO AMO  ON PAG.CreditoID = AMO.CreditoID 
				AND PAG.AmortizacionID = AMO.AmortizacionID  AND AMO.Estatus !=Est_Pagado
		INNER JOIN TMPFONDEOCLICREWSLIS TMP on PAG.CreditoID = TMP.creditoID 
	group by PAG.CreditoID;

	UPDATE 	TMPFONDEOCLICREWSLIS CLI, 
			TMPFONDEOCLICREWSLIS_4 TMP SET 
		CLI.saldoRestante 	= TMP.saldoRestante   
		WHERE CLI.CreditoID = TMP.creditoID;

		-- SE OBTIENE EL MONTO PAGARE
	INSERT INTO TMPFONDEOCLICREWSLIS_4
		SELECT SUM(PAG.Capital + PAG.Interes + PAG.IVAInteres), PAG.CreditoID
	FROM PAGARECREDITO PAG 
		INNER JOIN TMPFONDEOCLICREWSLIS TMP on PAG.CreditoID = TMP.creditoID 
	group by PAG.CreditoID;

	UPDATE 	TMPFONDEOCLICREWSLIS CLI, 
			TMPFONDEOCLICREWSLIS_4 TMP SET 
		CLI.montoPagare 	= TMP.saldoRestante   
		WHERE CLI.CreditoID = TMP.creditoID;


	select 	Par_NumErr AS codigoRespuesta,	Par_ErrMen as mensajeRespuesta,	clienteID,			creditoID,			fechaOtorgamiento,
			productoID,						estatusCreditoID,				fechaDocumentacion,	fechaUltimoPago, 	plazo,
    		montoOtorgado,					plazosRestantes,				CLABEDomiciliar,	saldoRestante,		institucionID,	
			frecuenciaCapital,				frecuenciaInteres,				montoPagare,		montoPago,			tasa,
			FondeadorID		
		FROM TMPFONDEOCLICREWSLIS TMP;
END IF;

IF(Par_NumLis = Lis_expCliente) THEN -- 6
	select 	Par_NumErr AS codigoRespuesta,				Par_ErrMen AS mensajeRespuesta,	MAX(ARC.ClienteID)as ClienteID,	MAX(ARC.ClienteArchivosID)as ClienteArchivosID, MAX(ARC.TipoDocumento) as TipoDocumento, 
			MAX(ARC.FechaRegistro) as FechaRegistro,	MAX(ARC.Recurso)as Recurso
	from CLIENTEARCHIVOS ARC
	INNER JOIN TMPFONDEOCLICREWSLIS TMP ON TMP.ClienteID = ARC.ClienteID
	GROUP BY ARC.ClienteID,	ARC.ClienteArchivosID;
END IF;

IF(Par_NumLis = Lis_expCuenta) THEN -- 7
	SELECT 	Par_NumErr AS codigoRespuesta,			Par_ErrMen AS mensajeRespuesta,		MAX(TMP.ClienteID)AS ClienteID,	MAX(ARC.ArchivoCtaID)AS ArchivoCtaID,	MAX(ARC.CuentaAhoID)AS CuentaAhoID,	
			MAX(ARC.TipoDocumento)AS TipoDocumento,	MAX(ARC.FechaActual)AS FechaActual,	MAX(ARC.Recurso)AS Recurso
		from CUENTAARCHIVOS ARC
		INNER JOIN TMPFONDEOCLICREWSLIS TMP ON TMP.CuentaAhoID = ARC.CuentaAhoID
		GROUP BY ARC.CuentaAhoID,	ARC.ArchivoCtaID;
END IF;

IF(Par_NumLis = Lis_expSolCred) THEN -- 8
	SELECT 	Par_NumErr AS codigoRespuesta,				Par_ErrMen AS mensajeRespuesta,		MAX(TMP.ClienteID)AS ClienteID,	MAX(ARC.DigSolID)AS DigSolID,	MAX(ARC.SolicitudCreditoID)AS SolicitudCreditoID, 
			MAX(ARC.TipoDocumentoID)AS TipoDocumentoID,	MAX(ARC.FechaActual)AS FechaActual,	MAX(ARC.Recurso)AS Recurso,		MAX(creditoID) AS creditoID
	from SOLICITUDARCHIVOS ARC
			INNER JOIN TMPFONDEOCLICREWSLIS TMP ON TMP.solicitudCreditoID = ARC.SolicitudCreditoID
		GROUP BY ARC.SolicitudCreditoID,	ARC.DigSolID;
END IF;

IF(Par_NumLis = Lis_expCred) THEN -- 9
	SELECT  Par_NumErr AS codigoRespuesta,				Par_ErrMen AS mensajeRespuesta,		MAX(TMP.ClienteID)AS ClienteID,	MAX(ARC.DigCreaID)AS DigCreaID,	MAX(ARC.CreditoID)AS CreditoID,
			MAX(ARC.TipoDocumentoID)AS TipoDocumentoID,	MAX(ARC.FechaActual)AS FechaActual,	MAX(ARC.Recurso)AS Recurso
		from CREDITOARCHIVOS ARC
			INNER JOIN TMPFONDEOCLICREWSLIS TMP ON TMP.creditoID = ARC.CreditoID
		GROUP BY ARC.CreditoID,	ARC.DigCreaID;

END IF;

		

-- SE ELIMINAN LAS TABLAS TEMPORALES
DROP TABLE IF EXISTS TMPFONDEOCLICREWSLIS;
DROP TABLE IF EXISTS TMPFONDEOCLICREWSLIS_0;
DROP TABLE IF EXISTS TMPFONDEOCLICREWSLIS_1;
DROP TABLE IF EXISTS TMPFONDEOCLICREWSLIS_2;
DROP TABLE IF EXISTS TMPFONDEOCLICREWSLIS_3;
DROP TABLE IF EXISTS TMPFONDEOCLICREWSLIS_4;

END TerminaStore$$