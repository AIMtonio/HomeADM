-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTRATOSOFINICREDREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTRATOSOFINICREDREP`;DELIMITER $$

CREATE PROCEDURE `CONTRATOSOFINICREDREP`(
-- SP PARA OBTENER INFORMACION DEL CONTRATO DE CREDITOS PARA EL CLIENTE SOFINI
	Par_CreditoID			BIGINT(12),				-- Parametro identificador del credito
	Par_TipoReporte			TINYINT UNSIGNED,		-- Parametro tipo de reporte

	Par_EmpresaID			INT(11),				-- Parametro de Auditoria
	Aud_Usuario				INT(11),				-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal			INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Fecha			VARCHAR(100);			-- Fecha en que se imprime contrato
	DECLARE Var_FechaSistema	DATE;					-- Fecha del sistema
	DECLARE Var_NumEscritura	VARCHAR(100);			-- Numero de escritura con formato
	DECLARE Var_FechaEscPub		DATE;					-- Fecha escritura publica
	DECLARE Var_FechaEscritura	VARCHAR(100);			-- Fecha escritura publica con formato
	DECLARE Var_NomNotario		VARCHAR(200);			-- Nombre notario
	DECLARE Var_NotariaID		INT(11);				-- Identificador de notaria
	DECLARE Var_NumNotario		VARCHAR(500);			-- Numero de notario
	DECLARE Var_EdoNotario		VARCHAR(100);			-- Estado del notario con formato
	DECLARE Var_ApoderadoLegal	VARCHAR(200);			-- Apoderado legal del notario
	DECLARE Var_Domicilio		VARCHAR(250);			-- Direccion de la empresa
	DECLARE Var_TasaCred		DECIMAL(12,4);			-- Tasa fija del credito
	DECLARE Var_TasaFija		VARCHAR(400);			-- Tasa fija con formato
	DECLARE Var_RFC				VARCHAR(20);			-- RFC facturacion electronica
	DECLARE Var_Telefono		VARCHAR(50);			-- Telefono local de la empresa
	DECLARE Var_FechaContrato	VARCHAR(500);			-- Fecha de impresion del contrato
	DECLARE Var_ProComercial	VARCHAR(100);			-- Nombre comercial del producto
	DECLARE Var_TipoClasific	CHAR(1);				-- Tipo de clasificacion
	DECLARE Var_TipoCredito		VARCHAR(100);			-- Tipo de credito
	DECLARE Var_ClienteID		INT(11);				-- Numero del cliente
	DECLARE Var_Acreditado		VARCHAR(200);			-- Nombre completo acreditado
	DECLARE Var_NumEmpleado		VARCHAR(20);			-- Numero de empleado del acreditado
	DECLARE Var_DomAcreditado	VARCHAR(500);			-- Direccion completa del acreditado
	DECLARE Var_MontoAutori		DECIMAL(12,4);			-- Monto autorizado del credito
	DECLARE Var_ValorCAT		DECIMAL(14,4);			-- Valor CAT del credito
	DECLARE Var_CAT				VARCHAR(100);			-- Valor CAT con formato
	DECLARE Var_MontoTotal		VARCHAR(100);			-- Monto total del credito
	DECLARE Var_DestinoCredito	VARCHAR(300);			-- Destino del credito
	DECLARE Var_Plazo			VARCHAR(50);			-- Plazo del credito
	DECLARE Var_RECA			VARCHAR(100);			-- Numero de registro RECA
	DECLARE Var_MontoXApert		DECIMAL(12,2);			-- Comision de apertura del credito
	DECLARE Var_EmpresaNomina	VARCHAR(200);			-- Nombre completo de la empresa de nomina
	DECLARE Var_FactorMora		DECIMAL(12,4);			-- Tasa mora del credito
	DECLARE Var_NumCuenta 		BIGINT(12);				-- Numero de cuenta de la empresa
	DECLARE Var_FechaVence		DATE;					-- Fecha de vencimiento del credito
	DECLARE Var_MontoCuota 		DECIMAL(12,2);			-- Monto de cuota
	DECLARE Var_FechaPrimerAmor	DATE;					-- Fecha de la primer amortizacion
	DECLARE Var_DiaPagoCapi		INT(11);				-- Dia del mes de pago de amortizacion
	DECLARE Var_NomPromotor		VARCHAR(160);			-- Nombre del promotor
	DECLARE Var_FechaMinistra	DATE;					-- Fecha de desembolso del credito
	DECLARE Var_TipoPagoCap		CHAR(1);				-- Tipo pago capital del credito
	DECLARE Var_FrecuenCap		CHAR(1);				-- Frecuencia del pago de credito
	DECLARE Var_DescripFrec		VARCHAR(20);			-- Descripcion de la frecuencia del pago de credito
	DECLARE Var_Cuotas 			INT(11);				-- Numero total de cuotas
	DECLARE Var_SolicitudID		BIGINT(20);				-- SolicitudCreditoID
	DECLARE Var_DiaPago			VARCHAR(100);			-- Dia de pago con formato
	DECLARE Var_PrimerAmorti	VARCHAR(100);			-- Primera amortizacion con formato
	DECLARE Var_CuotaLetra		VARCHAR(500);			-- Numero de cuotas con formato
	DECLARE Var_Monto			VARCHAR(400);			-- Monto del credito con formato
	DECLARE Var_TasaMorAnual	DECIMAL(12,2);			-- Tasa moral anual del credito
	DECLARE Var_TasaMora		VARCHAR(400);			-- Tasa mora de credito con formato
	DECLARE Var_FechaVenciCred	VARCHAR(100);			-- Fecha de vencimiento con formato
	DECLARE Var_SucursalMatriz	INT(11);				-- Sucursal matriz
	DECLARE Var_ClienteInstit	INT(11);				-- Cliente institucion
	DECLARE Var_DomUEAU			VARCHAR(250);			-- Domicilio UEAU
	DECLARE Var_TelUEAU			VARCHAR(45);			-- Telefono UEAU
	DECLARE Var_EmailUEAU		VARCHAR(45);			-- Email UEAU
	DECLARE Var_ComisionApertu	VARCHAR(100);			-- Comision por apertura del credito con formato
	DECLARE Var_ProductoID		INT(11);				-- Producto de credito
	DECLARE Var_SucursalID		INT(11);				-- Sucursal del credito
	DECLARE Var_TipoPrestamo	VARCHAR(50);			-- Tipo de prestamo
	DECLARE Var_PagoCapital		VARCHAR(50);			-- Tipo de pago capital
	DECLARE Var_Sucursal		VARCHAR(50);			-- Nombre de sucursal
	DECLARE Var_CreditoIDAnte	BIGINT(12);				-- Numero del credito anterior
	DECLARE Var_CredAnterior	VARCHAR(50);			-- Numero de credito anterior con formato
	DECLARE Var_MontoCredAnte	DECIMAL(12,4);			-- Monto del credito anterior
	DECLARE Var_MontoAnterior	VARCHAR(30);			-- Monto del credito anterior con formato
	DECLARE Var_ProdAnterior	VARCHAR(100);			-- Producto del credito anterior
	DECLARE Var_SumaAmorti		DECIMAL(14,2);			-- Suma de todas las amortizaciones
	DECLARE Var_RelacionadoID	INT(11);				-- RelacionadoID del directivo
	DECLARE Var_CobraMora		CHAR(1);				-- Indica si el Producto cobra mora
	DECLARE Var_TipoCobMora		CHAR(1);				-- Tipo de comision moratorio
	DECLARE Var_Instituto		INT(11);				-- institucion id de la empresa

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);				-- Entero cero
	DECLARE Cadena_Vacia		CHAR(1);				-- Cadena vacia
	DECLARE Decimal_Cero		DECIMAL(12,4);			-- Decimal cero
	DECLARE Var_CadenaSi		CHAR(1);				-- Cadena si
	DECLARE Var_CadenaNo		CHAR(1);				-- Cadena no
	DECLARE Fecha_Vacia			DATE;					-- Fecha vacia
	DECLARE Var_TipoPagIguales	CHAR(1);				-- Tipo de pago capital iguales
	DECLARE Var_TipoPagCrecie	CHAR(1);				-- Tipo de pago capital crecientes
	DECLARE Var_TipoPagLibre	CHAR(1);				-- Tipo de pago capital libres
	DECLARE Var_TipoConsumo		CHAR(1);				-- Tipo de credito consumo
	DECLARE Var_TipoComercial	CHAR(1);				-- Tipo de credito comercial
	DECLARE Var_TipoHipote		CHAR(1);				-- Tipo de credito hipotecario
	DECLARE Var_DescPagoIgual	VARCHAR(30);			-- Descripcion tipo de pago capital iguales
	DECLARE Var_DescPagCrecie	VARCHAR(30);			-- Descripcion tipo de pago capital crecientes
	DECLARE Var_DescPagLibre	VARCHAR(30);			-- Descripcion tipo de pago capital libres
	DECLARE Var_DescConsumo		VARCHAR(30);			-- Descricion tipo credito consumo
	DECLARE Var_DescComercial	VARCHAR(30);			-- Descricion tipo credito comercial
	DECLARE Var_DesHipote		VARCHAR(30);			-- Descricion tipo credito hipotecario
	DECLARE Var_DescIndivi		VARCHAR(30);			-- Descripcion de tipo credito individual
	DECLARE Var_DescGrupal		VARCHAR(30);			-- Descripcion de tipo credito grupal
	DECLARE Est_CredPagado		CHAR(1);				-- Estatus Pagado del credito
	DECLARE Est_CredCastigado	CHAR(1);				-- Estatus Castigado del credito
	DECLARE Est_CredVencido		CHAR(1);				-- Estatus Vencido del credito
	DECLARE Est_CredVigente		CHAR(1);				-- Estatus Vigente del credito
	DECLARE Var_TasaAnual		CHAR(1);				-- Tipo cobro comision mora tasa fija anualizada
	DECLARE Var_RepPagare		TINYINT UNSIGNED;		-- Tipo reporte pagare
	DECLARE Var_RepContrato		TINYINT UNSIGNED;		-- Tipo reporte contrato
	DECLARE Var_RepCaratula		TINYINT UNSIGNED;		-- Tipo reporte caratula del contrato
	DECLARE Var_RepCartaAuto	TINYINT UNSIGNED;		-- Tipo reporte carta de autorizacion
	DECLARE Var_RepEncabePagos	TINYINT UNSIGNED;		-- Tipo reporte encabezado tabla de pagos
	DECLARE Var_RepTablaPagos	TINYINT UNSIGNED;		-- Tipo reporte tabla de pagos
	DECLARE Var_RepAvalesCred	TINYINT UNSIGNED;		-- Tipo reporte avales del credito
	DECLARE Var_RepPrivacidad	TINYINT UNSIGNED;		-- Tipo reporte aviso de privacidad

	-- Asignacion de constantes
	SET Entero_Cero				:= 0;					-- Entero cero
	SET Cadena_Vacia			:= '';					-- Cadena vacia
	SET Decimal_Cero			:= 0.0;					-- Decimal cero
	SET Var_CadenaSi			:= 'S';					-- Cadena si
	SET Var_CadenaNo			:= 'N';					-- Cadena no
	SET Fecha_Vacia				:= '1900-01-01';		-- Fecha vacia
	SET Var_TipoPagIguales		:= 'I';					-- Tipo de pago capital iguales
	SET Var_TipoPagCrecie		:= 'C';					-- Tipo de pago capital crecientes
	SET Var_TipoPagLibre		:= 'L';					-- Tipo de pago capital libres
	SET Var_TipoConsumo			:= 'O';					-- Tipo de credito consumo
	SET Var_TipoComercial		:= 'C';					-- Tipo de credito comercial
	SET Var_TipoHipote			:= 'H';					-- Tipo de credito hipotecario
	SET Var_DescPagoIgual		:= 'IGUALES';			-- Descripcion tipo de pago capital iguales
	SET Var_DescPagCrecie		:= 'CRECIENTES';		-- Descripcion tipo de pago capital crecientes
	SET Var_DescPagLibre		:= 'LIBRES';			-- Descripcion tipo de pago capital libres
	SET Var_DescConsumo			:= 'CONSUMO';			-- Descricion tipo credito consumo
	SET Var_DescComercial		:= 'COMERCIAL';			-- Descricion tipo credito comercial
	SET Var_DesHipote			:= 'HIPOTECARIO';		-- Descricion tipo credito hipotecario
	SET Var_DescIndivi			:= 'INDIVIDUAL';		-- Descripcion de tipo credito individual
	SET Var_DescGrupal			:= 'GRUPAL';			-- Descripcion de tipo credito grupal
	SET Est_CredPagado			:= 'P';					-- Estatus Pagado del credito
	SET Est_CredCastigado		:= 'K';					-- Estatus Castigado del credito
	SET Est_CredVencido			:= 'B';					-- Estatus Vencido del credito
	SET Est_CredVigente			:= 'V';					-- Estatus Vigente del credito
	SET Var_TasaAnual			:= 'T';					-- Tipo cobro comision mora tasa fija anualizada
	SET Var_RepPagare			:= 1;					-- Tipo reporte pagare
	SET Var_RepContrato			:= 2;					-- Tipo reporte contrato
	SET Var_RepCaratula			:= 3;					-- Tipo reporte caratula del contrato
	SET Var_RepCartaAuto		:= 4;					-- Tipo reporte carta de autorizacion
	SET Var_RepEncabePagos		:= 5;					-- Tipo reporte encabezado tabla de pagos
	SET Var_RepTablaPagos		:= 6;					-- Tipo reporte tabla de pagos
	SET Var_RepAvalesCred		:= 7;					-- Tipo reporte avales del credito
	SET Var_RepPrivacidad		:= 8;					-- Tipo reporte aviso de privacidad

	SET Par_CreditoID := IFNULL(Par_CreditoID, Entero_Cero);

	-- se obtiene la informacion principal de la empresa
	SELECT  CuentaInstituc, 		FechaSistema,			SucursalMatrizID,		ClienteInstitucion,		TelefonoLocal,
			InstitucionID
		INTO Var_NumCuenta,			Var_FechaSistema,		Var_SucursalMatriz,		Var_ClienteInstit,		Var_Telefono,
			Var_Instituto
		FROM PARAMETROSSIS
		WHERE EmpresaID = Par_EmpresaID
		LIMIT 1;

	SET Var_NumCuenta		:= IFNULL(Var_NumCuenta, Entero_Cero);
	SET Var_FechaSistema	:= IFNULL(Var_FechaSistema, Fecha_Vacia);
	SET Var_SucursalMatriz 	:= IFNULL(Var_SucursalMatriz, Entero_Cero);
	SET Var_ClienteInstit 	:= IFNULL(Var_ClienteInstit, Entero_Cero);
	SET Var_Telefono		:= IFNULL(Var_Telefono, Cadena_Vacia);
	SET Var_Instituto		:= IFNULL(Var_Instituto, Entero_Cero);

	IF (Par_TipoReporte = Var_RepPagare) THEN

		-- se obtiene la direccion de la empresa
		SELECT  DirecCompleta
			INTO Var_Domicilio
			FROM SUCURSALES
			WHERE SucursalID = Var_SucursalMatriz
			LIMIT 1;

		SET Var_Domicilio		:= IFNULL(Var_Domicilio, Cadena_Vacia);

		-- se obtiene informacion del credito
		SELECT TasaFija, 			MontoCredito, 			FactorMora, 		FechaVencimien, 	MontoCuota,
				DiaMesCapital,	 	FechaInicioAmor,		FrecuenciaCap, 		NumAmortizacion,	ClienteID,
				SolicitudCreditoID, ProductoCreditoID
			INTO Var_TasaCred,		Var_MontoAutori,		Var_FactorMora,	 	Var_FechaVence,		Var_MontoCuota,
				Var_DiaPagoCapi,	Var_FechaPrimerAmor,	Var_FrecuenCap,		Var_Cuotas, 		Var_ClienteID,
				Var_SolicitudID,	Var_ProductoID
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID
		LIMIT 1;

		SET Var_TasaCred 		:= IFNULL(Var_TasaCred, Decimal_Cero);
		SET Var_MontoAutori 	:= IFNULL(Var_MontoAutori, Decimal_Cero);
		SET Var_FactorMora 		:= IFNULL(Var_FactorMora, Decimal_Cero);
		SET Var_FechaVence 		:= IFNULL(Var_FechaVence, Fecha_Vacia);
		SET Var_MontoCuota 		:= IFNULL(Var_MontoCuota, Decimal_Cero);
		SET Var_DiaPagoCapi		:= IFNULL(Var_DiaPagoCapi, Entero_Cero);
		SET Var_FechaPrimerAmor := IFNULL(Var_FechaPrimerAmor, Fecha_Vacia);
		SET Var_FrecuenCap 		:= IFNULL(Var_FrecuenCap, Cadena_Vacia);
		SET Var_Cuotas 			:= IFNULL(Var_Cuotas, Entero_Cero);
		SET Var_ClienteID 		:= IFNULL(Var_ClienteID, Entero_Cero);
		SET Var_SolicitudID 	:= IFNULL(Var_SolicitudID, Entero_Cero);
		SET Var_ProductoID		:= IFNULL(Var_ProductoID, Entero_Cero);

		-- se obtiene la tasa mora
		SELECT CobraMora,			TipCobComMorato
			INTO Var_CobraMora,		Var_TipoCobMora
			FROM PRODUCTOSCREDITO
			WHERE ProducCreditoID = Var_ProductoID
			LIMIT 1;

		SET Var_CobraMora   := IFNULL(Var_CobraMora, Cadena_Vacia);
		SET Var_TipoCobMora := IFNULL(Var_TipoCobMora, Cadena_Vacia);

		IF (Var_CobraMora = Var_CadenaSi) THEN
			IF (Var_TipoCobMora = Var_TasaAnual) THEN
				SET Var_TasaMorAnual := ROUND(Var_FactorMora, 2);
			ELSE
				SET Var_TasaMorAnual := ROUND(Var_FactorMora * Var_TasaCred,2);
			END IF;
		ELSE
			SET Var_TasaMorAnual := Decimal_Cero;
		END IF;

		SELECT UPPER(DescInfinitivo)
			INTO Var_DescripFrec
			FROM CATFRECUENCIAS
			WHERE FrecuenciaID = Var_FrecuenCap
			LIMIT 1;

		SET Var_DescripFrec := IFNULL(Var_DescripFrec, Cadena_Vacia);

		-- informacion del cliente
		SELECT Cli.NombreCompleto,		Dir.DireccionCompleta
			INTO Var_Acreditado,		Var_DomAcreditado
			FROM CLIENTES Cli
			LEFT JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID AND Dir.Oficial = Var_CadenaSi
			WHERE Cli.ClienteID = Var_ClienteID;

		SET Var_Acreditado 		:= IFNULL(Var_Acreditado, Cadena_Vacia);
		SET Var_DomAcreditado 	:= IFNULL(Var_DomAcreditado, Cadena_Vacia);

		-- se formatea los valores
		SET Var_TasaFija	  	:= CONVPORCANT(Var_TasaCred,'%',2,'');
		SET Var_FechaContrato 	:= FNFECHACONTRATOSOFINI(Var_FechaSistema);
		SET Var_DiaPago			:= CONCAT(Var_DiaPagoCapi, ' de cada mes');
		SET Var_PrimerAmorti	:= FUNCIONLETRASFECHA(Var_FechaPrimerAmor);
		SET Var_CuotaLetra		:= CONCAT('$',Var_MontoCuota,' (',FUNCIONNUMEROSLETRAS(Var_MontoCuota),')');
		SET Var_TasaMora		:= CONVPORCANT(Var_TasaMorAnual,'%',2,'');
		SET Var_Monto			:= CONVPORCANT(Var_MontoAutori,'$','Peso','N.');
		SET Var_FechaVenciCred  := FUNCIONLETRASFECHA(Var_FechaVence);


		SELECT Var_Domicilio, 		Var_NumCuenta,			Var_Monto,			 	Var_FechaVenciCred,			Var_TasaFija,
				Var_Cuotas,			Var_DiaPago,			Var_DescripFrec,  		Var_PrimerAmorti,			Var_CuotaLetra,
				Var_TasaMora,		Var_FechaContrato,		Var_Acreditado,			Var_DomAcreditado;
	END IF;

	IF (Par_TipoReporte = Var_RepContrato) THEN

		SET Var_Fecha := FUNCIONLETRASFECHA(Var_FechaSistema);

		-- se obtiene informacion de la escritura publica de la empresa

		SELECT RelacionadoID,			Dir.NumEscPub, 		Dir.FechaEscPub,		Dir.TitularNotaria, 		Dir.NotariaID,
				Dir.NombreCompleto,		Edo.Nombre
		INTO 	Var_RelacionadoID,		Var_NumEscritura,	Var_FechaEscPub,		Var_NomNotario,				Var_NotariaID,
				Var_ApoderadoLegal,		Var_EdoNotario
		FROM DIRECTIVOS Dir
		LEFT JOIN ESTADOSREPUB Edo ON Dir.EstadoID = Edo.EstadoID
		WHERE Dir.ClienteID = Var_ClienteInstit
		AND Dir.EsApoderado = Var_CadenaSi
		LIMIT 1;

		SET Var_RelacionadoID := IFNULL(Var_RelacionadoID, Entero_Cero);

		-- Si el apoderado legal es relacionado
		IF (Var_RelacionadoID <> Entero_Cero) THEN
			SET Var_NumEscritura := Cadena_Vacia;
			SET Var_FechaEscPub := Fecha_Vacia;
			SET Var_NotariaID := Entero_Cero;
			SET Var_ApoderadoLegal := Cadena_Vacia;
			SET Var_EdoNotario := Cadena_Vacia;

			SELECT Esc.EscrituraPublic,		Esc.FechaEsc,			Esc.NomNotario,			Esc.Notaria,			Esc.NomApoderado,
					Edo.Nombre
			INTO Var_NumEscritura,			Var_FechaEscPub,		Var_NomNotario,				Var_NotariaID,			Var_ApoderadoLegal,
				Var_EdoNotario
			FROM ESCRITURAPUB Esc
			LEFT JOIN ESTADOSREPUB Edo ON Esc.EstadoIDEsc = Edo.EstadoID
			WHERE Esc.ClienteID = Var_RelacionadoID
			LIMIT 1;

		END IF;

		SET Var_NumEscritura 	:= IFNULL(Var_NumEscritura, Cadena_Vacia);
		SET Var_FechaEscPub 	:= IFNULL(Var_FechaEscPub, Fecha_Vacia);
		SET Var_NomNotario 		:= IFNULL(Var_NomNotario, Cadena_Vacia);
		SET Var_NotariaID 		:= IFNULL(Var_NotariaID, Entero_Cero);
		SET Var_ApoderadoLegal 	:= IFNULL(Var_ApoderadoLegal, Cadena_Vacia);
		SET Var_EdoNotario 		:= IFNULL(Var_EdoNotario, Cadena_Vacia);

		-- se obtiene la direccion de la empresa
		SELECT  DirecCompleta
			INTO Var_Domicilio
			FROM SUCURSALES
			WHERE SucursalID = Var_SucursalMatriz
			LIMIT 1;

		SET Var_Domicilio := IFNULL(Var_Domicilio, Cadena_Vacia);

		-- se obtiene el rfc de la institucion
		SELECT RFC
			INTO Var_RFC
			FROM INSTITUCIONES
			WHERE InstitucionID = Var_Instituto
			LIMIT 1;

		SET Var_RFC := IFNULL(Var_RFC, Cadena_Vacia);

		SELECT Cred.TasaFija,	Cli.NombreCompleto
			INTO Var_TasaCred,	Var_Acreditado
			FROM CREDITOS Cred
			LEFT JOIN CLIENTES Cli ON Cred.ClienteID = Cli.ClienteID
			WHERE Cred.CreditoID =  Par_CreditoID
			LIMIT 1;

		SET Var_TasaCred 	:= IFNULL(Var_TasaCred, Decimal_Cero);
		SET Var_Acreditado	:= IFNULL(Var_Acreditado, Cadena_Vacia);

		-- Se formatea los valores
		SET Var_FechaEscritura	:= FUNCIONLETRASFECHA(Var_FechaEscPub);
		SET Var_NumNotario		:= CONCAT(Var_NotariaID,' (',FUNCIONNUMEROSLETRAS(Var_NotariaID), ')');
		SET Var_TasaFija	  	:= CONVPORCANT(Var_TasaCred,'%',2,'');
		SET Var_FechaContrato 	:= FNFECHACONTRATOSOFINI(Var_FechaSistema);
		SET Var_NomNotario		:= CONCAT('Lic. ', Var_NomNotario);

		SELECT Var_Fecha,			Var_NumEscritura,		Var_FechaEscritura,		Var_NumNotario,		Var_NomNotario,
				Var_EdoNotario,		Var_ApoderadoLegal,		Var_RFC,				Var_Domicilio,		Var_TasaFija,
				Var_Telefono,		Var_FechaContrato,		Var_Acreditado;

	END IF;

	IF (Par_TipoReporte = Var_RepCaratula) THEN

		SELECT Cred.ValorCAT,			Cred.MontoCredito,		Cred.MontoComApert,		Cred.ClienteID,			Cred.TasaFija,
				Cred.FactorMora,		Dest.Descripcion,		Dest.Clasificacion,		Plazo.Descripcion,		Sol.FolioCtrl,
				Cred.ProductoCreditoID
			INTO Var_ValorCAT,			Var_MontoAutori,		Var_MontoXApert,		Var_ClienteID,			Var_TasaCred,
				Var_FactorMora,			Var_DestinoCredito,		Var_TipoClasific,		Var_Plazo,				Var_NumEmpleado,
				Var_ProductoID
			FROM CREDITOS Cred
			LEFT JOIN DESTINOSCREDITO Dest ON Cred.DestinoCreID = Dest.DestinoCreID
			LEFT JOIN CREDITOSPLAZOS Plazo ON Cred.PlazoID = Plazo.PlazoID
			LEFT JOIN SOLICITUDCREDITO Sol ON Cred.SolicitudCreditoID = Sol.SolicitudCreditoID
			WHERE Cred.CreditoID =  Par_CreditoID
			LIMIT 1;

		SET Var_ValorCAT 		:= IFNULL(Var_ValorCAT,Decimal_Cero);
		SET Var_MontoAutori 	:= IFNULL(Var_MontoAutori,Decimal_Cero);
		SET Var_MontoXApert		:= IFNULL(Var_MontoXApert,Decimal_Cero);
		SET Var_ClienteID		:= IFNULL(Var_ClienteID,Entero_Cero);
		SET Var_TasaCred		:= IFNULL(Var_TasaCred, Decimal_Cero);
		SET Var_FactorMora		:= IFNULL(Var_FactorMora, Decimal_Cero);
		SET Var_TipoClasific 	:= IFNULL(Var_TipoClasific,Cadena_Vacia);
		SET Var_DestinoCredito	:= IFNULL(Var_DestinoCredito,Cadena_Vacia);
		SET Var_Plazo 			:= IFNULL(Var_Plazo,Cadena_Vacia);
		SET Var_NumEmpleado 	:= IFNULL(Var_NumEmpleado,Cadena_Vacia);
		SET Var_ProductoID 		:= IFNULL(Var_ProductoID,Cadena_Vacia);


		-- informacion del cliente
		SELECT Cli.NombreCompleto,		Dir.DireccionCompleta
			INTO Var_Acreditado,		Var_DomAcreditado
			FROM CLIENTES Cli
			LEFT JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID AND Dir.Oficial = Var_CadenaSi
			WHERE Cli.ClienteID = Var_ClienteID
			LIMIT 1;

		SET Var_Acreditado 		:= IFNULL(Var_Acreditado, Cadena_Vacia);
		SET Var_DomAcreditado 	:= IFNULL(Var_DomAcreditado, Cadena_Vacia);

		-- se obtiene la informacion del producto
		SELECT CobraMora,			TipCobComMorato,		NombreComercial,			RegistroRECA
			INTO Var_CobraMora,		Var_TipoCobMora,		Var_ProComercial,			Var_RECA
			FROM PRODUCTOSCREDITO
			WHERE ProducCreditoID = Var_ProductoID
			LIMIT 1;

		SET Var_CobraMora   	:= IFNULL(Var_CobraMora, Cadena_Vacia);
		SET Var_TipoCobMora 	:= IFNULL(Var_TipoCobMora, Cadena_Vacia);
		SET Var_ProComercial 	:= IFNULL(Var_ProComercial, Cadena_Vacia);
		SET Var_RECA 			:= IFNULL(Var_RECA, Cadena_Vacia);

		IF (Var_CobraMora = Var_CadenaSi) THEN
			IF (Var_TipoCobMora = Var_TasaAnual) THEN
				SET Var_TasaMorAnual := ROUND(Var_FactorMora, 2);
			ELSE
				SET Var_TasaMorAnual := ROUND(Var_FactorMora * Var_TasaCred,2);
			END IF;
		ELSE
			SET Var_TasaMorAnual := Decimal_Cero;
		END IF;

		-- se obtiene informacion de la atencion de usuarios
		SELECT DireccionUEAU,	TelefonoUEAU,		CorreoUEAU
			INTO Var_DomUEAU, 	Var_TelUEAU,		Var_EmailUEAU
			FROM EDOCTAPARAMS
			WHERE EmpresaID = Par_EmpresaID
			LIMIT 1;

		SET Var_DomUEAU 	:= IFNULL(Var_DomUEAU, Cadena_Vacia);
		SET Var_TelUEAU 	:= IFNULL(Var_TelUEAU, Cadena_Vacia);
		SET Var_EmailUEAU 	:= IFNULL(Var_EmailUEAU, Cadena_Vacia);

		-- Se obtiene la suma de todas las amortizaciones
		SELECT SUM(Capital) + SUM(Interes) + SUM(IVAInteres)
			INTO Var_SumaAmorti
			FROM AMORTICREDITO
			WHERE CreditoID =  Par_CreditoID;

		SET Var_SumaAmorti	:= IFNULL(Var_SumaAmorti, Decimal_Cero);

		-- se formata los valores
		SET Var_CAT 		:= CONVPORCANT(Var_ValorCAT,'%',2,'');
		SET Var_TasaFija 	:= CONVPORCANT(Var_TasaCred,'%',2,'');
		SET Var_TasaMora 	:= CONVPORCANT(Var_TasaMorAnual,'%',2,'');
		SET Var_Monto		:= CONVPORCANT(Var_MontoAutori,'$','Peso','N.');
		SET Var_MontoTotal 	:= CONVPORCANT(Var_SumaAmorti,'$','Peso','N.');
		SET Var_TipoCredito := CASE WHEN Var_TipoClasific = Var_TipoComercial THEN Var_DescComercial
									WHEN Var_TipoClasific = Var_TipoConsumo THEN Var_DescConsumo
									WHEN Var_TipoClasific = Var_TipoHipote THEN Var_DesHipote
									ELSE Cadena_Vacia
								END;

		SET Var_ComisionApertu := CONVPORCANT(Var_MontoXApert,'$','Peso','N.');

		SELECT Var_ProComercial,		Var_TipoCredito,			Var_Acreditado,				Var_NumEmpleado,		Var_DomAcreditado,
				Var_CAT,				Var_Monto,					Var_MontoTotal,				Var_DestinoCredito,		Var_Plazo,
				Var_ComisionApertu,		Var_RECA,					Var_TasaFija,				Var_TasaMora,			Var_DomUEAU,
				Var_TelUEAU,			Var_EmailUEAU;
	END IF;

	IF (Par_TipoReporte = Var_RepCartaAuto) THEN

		-- informacion del credito
		SELECT Cli.NombreCompleto,		Inst.NombreInstit
			INTO Var_Acreditado,		Var_EmpresaNomina
			FROM CREDITOS Cred
			LEFT JOIN CLIENTES Cli ON Cred.ClienteID = Cli.ClienteID
			LEFT JOIN SOLICITUDCREDITO Sol ON Cred.SolicitudCreditoID = Sol.SolicitudCreditoID
			LEFT JOIN INSTITNOMINA	Inst ON Sol.InstitucionNominaID = Inst.InstitNominaID
			WHERE Cred.CreditoID = Par_CreditoID
			LIMIT 1;

		SET Var_Acreditado 		:= IFNULL(Var_Acreditado, Cadena_Vacia);
		SET Var_EmpresaNomina	:= IFNULL(Var_EmpresaNomina, Cadena_Vacia);

		-- Se formatea los valores
		SET Var_FechaContrato 	:= FNFECHACONTRATOSOFINI(Var_FechaSistema);

		SELECT Var_FechaContrato,		Var_Acreditado,			Var_EmpresaNomina;

	END IF;

	IF (Par_TipoReporte = Var_RepEncabePagos) THEN

		SELECT ClienteID,			TasaFija,			NumAmortizacion,		ValorCAT,				MontoCredito,
				ProductoCreditoID,	TipoPagoCapital,	FechaMinistrado,		SolicitudCreditoID,		FrecuenciaCap,
				SucursalID
			INTO Var_ClienteID,		Var_TasaCred, 		Var_Cuotas,				Var_ValorCAT,			Var_MontoAutori,
				Var_ProductoID,		Var_TipoPagoCap,	Var_FechaMinistra,		Var_SolicitudID,		Var_FrecuenCap,
				Var_SucursalID
			FROM CREDITOS
			WHERE CreditoID = Par_CreditoID
			LIMIT 1;

		SET Var_ClienteID 		:= IFNULL(Var_ClienteID, Entero_Cero);
		SET Var_TasaCred 		:= IFNULL(Var_TasaCred, Decimal_Cero);
		SET Var_Cuotas 			:= IFNULL(Var_Cuotas, Entero_Cero);
		SET Var_ValorCAT 		:= IFNULL(Var_ValorCAT, Decimal_Cero);
		SET Var_MontoAutori 	:= IFNULL(Var_MontoAutori, Decimal_Cero);
		SET Var_ProductoID 		:= IFNULL(Var_ProductoID, Entero_Cero);
		SET Var_TipoPagoCap 	:= IFNULL(Var_TipoPagoCap, Cadena_Vacia);
		SET Var_FechaMinistra 	:= IFNULL(Var_FechaMinistra, Fecha_Vacia);
		SET Var_SolicitudID 	:= IFNULL(Var_SolicitudID, Entero_Cero);
		SET Var_FrecuenCap 		:= IFNULL(Var_FrecuenCap, Cadena_Vacia);
		SET Var_SucursalID 		:= IFNULL(Var_SucursalID, Entero_Cero);

		-- informacion del cliente
		SELECT NombreCompleto
			INTO Var_Acreditado
			FROM CLIENTES
			WHERE ClienteID = Var_ClienteID
			LIMIT 1;

		SET Var_Acreditado := IFNULL(Var_Acreditado, Cadena_Vacia);

		-- informacion del tipo de credito
		SELECT CASE EsGrupal
					WHEN Var_CadenaSi THEN Var_DescGrupal
					WHEN Var_CadenaNo THEN Var_DescIndivi
				END
			INTO Var_TipoPrestamo
			FROM PRODUCTOSCREDITO
			WHERE ProducCreditoID = Var_ProductoID
			LIMIT 1;

		SET Var_TipoPrestamo := IFNULL(Var_TipoPrestamo, Cadena_Vacia);

		-- informacion de la sucursal
		SELECT NombreSucurs
			INTO Var_Sucursal
			FROM SUCURSALES
			WHERE SucursalID = Var_SucursalID;

		SET Var_Sucursal := IFNULL(Var_Sucursal, Cadena_Vacia);

		-- informacion del promotor
		SELECT Usu.NombreCompleto
			INTO Var_NomPromotor
			FROM SOLICITUDCREDITO Sol
			LEFT JOIN USUARIOS Usu ON Sol.UsuarioAltaSol = Usu.UsuarioID
			WHERE Sol.SolicitudCreditoID = Var_SolicitudID
			LIMIT 1;

		SET Var_NomPromotor := IFNULL(Var_NomPromotor, Cadena_Vacia);

		-- informacion de la frecuencia
		SELECT UPPER(DescInfinitivo)
			INTO Var_DescripFrec
			FROM CATFRECUENCIAS
			WHERE FrecuenciaID = Var_FrecuenCap
			LIMIT 1;

		SET Var_DescripFrec := IFNULL(Var_DescripFrec, Cadena_Vacia);

		-- informacion del credito anterior
		SELECT  Cred.CreditoID,			Cred.MontoCredito, 		Prod.Descripcion
			INTO Var_CreditoIDAnte,		Var_MontoCredAnte,		Var_ProdAnterior
			FROM CREDITOS Cred
			LEFT JOIN PRODUCTOSCREDITO Prod ON Cred.ProductoCreditoID = Prod.ProducCreditoID
			WHERE Cred.ClienteID = Var_ClienteID
			AND FechaMinistrado < Var_FechaMinistra
			ORDER BY Cred.FechaMinistrado DESC
			LIMIT 1;

		SET Var_CreditoIDAnte := IFNULL(Var_CreditoIDAnte, Entero_Cero);
		SET Var_MontoCredAnte := IFNULL(Var_MontoCredAnte, Decimal_Cero);
		SET Var_ProdAnterior  := IFNULL(Var_ProdAnterior, Cadena_Vacia);


		SET Var_CredAnterior	:= CASE WHEN Var_CreditoIDAnte != Entero_Cero THEN CONCAT('No- ', Var_CreditoIDAnte)  ELSE Cadena_Vacia END;
		SET Var_MontoAnterior	:= CASE WHEN Var_CreditoIDAnte != Entero_Cero THEN CONCAT('$ ',FORMAT(Var_MontoCredAnte, 2)) ELSE Cadena_Vacia END;
		SET Var_ProdAnterior	:= CASE WHEN Var_CreditoIDAnte != Entero_Cero THEN Var_ProdAnterior ELSE Cadena_Vacia END;

		-- Se formatea valores
		SET Var_FechaContrato 	:= FNFECHACONTRATOSOFINI(Var_FechaSistema);
		SET Var_CAT 			:= CONVPORCANT(Var_ValorCAT,'%',2,'');
		SET Var_Monto			:= CONVPORCANT(Var_MontoAutori,'$','Peso','N.');
		SET Var_TasaFija	  	:= CONVPORCANT(Var_TasaCred,'%',2,'');
		SET Var_PagoCapital		:= CASE
										WHEN Var_TipoPagoCap = Var_TipoPagIguales THEN Var_DescPagoIgual
										WHEN Var_TipoPagoCap = Var_TipoPagCrecie THEN Var_DescPagCrecie
										WHEN Var_TipoPagoCap = Var_TipoPagLibre THEN Var_DescPagLibre
										ELSE Cadena_Vacia
									END;

		SELECT Var_FechaContrato,	Var_Sucursal,			Var_NomPromotor,		Var_Acreditado,			Var_FechaMinistra,
				Var_Monto,			Var_TipoPrestamo,		Var_TasaFija,			Var_CAT,				Var_PagoCapital,
				Var_DescripFrec,	Var_Cuotas,				Var_CredAnterior,		Var_MontoAnterior,		Var_ProdAnterior;

	END IF;

	IF (Par_TipoReporte = Var_RepTablaPagos) THEN

		  SELECT AmortizacionID,	 	FechaExigible, 		CONCAT('$ ',Capital) AS Capital, 	CONCAT('$ ',Interes) AS Interes, 	CONCAT('$ ', IVAInteres) AS IVAInteres,
				CONCAT('$ ',(Capital + Interes + IVAInteres)) AS Var_TotalAmorti
			FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID;
	END IF;

	IF (Par_TipoReporte = Var_RepAvalesCred) THEN
		SELECT SolicitudCreditoID
			INTO Var_SolicitudID
			FROM CREDITOS
			WHERE CreditoID = Par_CreditoID
			LIMIT 1;
		SET Var_SolicitudID := IFNULL(Var_SolicitudID, Entero_Cero);

		SELECT CASE
			WHEN AvalSol.AvalID > Entero_Cero THEN Aval.NombreCompleto
            WHEN AvalSol.ClienteID > Entero_Cero THEN Cli.NombreCompleto
            WHEN AvalSol.ProspectoID > Entero_Cero THEN Pros.NombreCompleto
            ELSE '' END AS Var_NombreAval,
            Dir.DireccionCompleta AS Var_DomAval
		FROM AVALESPORSOLICI AvalSol
		LEFT JOIN AVALES Aval ON AvalSol.AvalID = Aval.AvalID
		LEFT JOIN CLIENTES Cli ON AvalSol.ClienteID = Cli.ClienteID
		LEFT JOIN PROSPECTOS Pros ON AvalSol.ProspectoID = Pros.ProspectoID
		LEFT JOIN DIRECCLIENTE Dir ON CASE WHEN AvalSol.ClienteID > Entero_Cero THEN Cli.ClienteID = Dir.ClienteID END
		WHERE AvalSol.SolicitudCreditoID = Var_SolicitudID;

	END IF;

	IF (Par_TipoReporte = Var_RepPrivacidad) THEN

		-- se obtiene la direccion de la empresa
		SELECT  DirecCompleta
			INTO Var_Domicilio
			FROM SUCURSALES
			WHERE SucursalID = Var_SucursalMatriz
			LIMIT 1;

		SET Var_Domicilio := IFNULL(Var_Domicilio, Cadena_Vacia);

		-- se obtiene la informacion del acreditado

		SELECT Cli.NombreCompleto
			INTO Var_Acreditado
			FROM CREDITOS Cred
			LEFT JOIN CLIENTES Cli ON Cred.ClienteID = Cli.ClienteID
			WHERE Cred.CreditoID = Par_CreditoID
			LIMIT 1;

		SET Var_Acreditado := IFNULL(Var_Acreditado, Cadena_Vacia);

		SELECT Var_Domicilio,		Var_Telefono,			Var_Acreditado;

	END IF;

END TerminaStore$$