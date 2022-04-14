-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEASCREDITOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINEASCREDITOALT`;

DELIMITER $$
CREATE PROCEDURE `LINEASCREDITOALT`(
	-- Store procedure para el alta de lineas de credito
	-- Modulo Cartera --> Registro --> Lineas Credito
	Par_ClienteID				INT(11),		-- Numero de Cliente
	Par_CuentaID				BIGINT(12),		-- Numero de Cuenta de Ahorro
	Par_MonedaID				INT(11),		-- Numero de Moneda
	Par_SucursalID				INT(11),		-- Numero de Sucursal
	Par_FolioContrato			VARCHAR(15),	-- Folio de Contrato

	Par_FechaInicio				DATE,			-- Fecha de inicio de Liena de Credito
	Par_FechaVencimiento		DATE,			-- Fecha de Vencimiento
	Par_ProductoCreditoID		INT(11),		-- Numero de Producto de Credito
	Par_Solicitado				DECIMAL(12,2),	-- Monto Solicitado
	Par_EsAgropecuario			CHAR(1),		-- Es Agropecuario \nN.- NO \nS.- SI

	Par_TipoLineaAgroID			INT(11),		-- Numero de Tipo de Linea Agropecuaria
	Par_ManejaComAdmon			CHAR(1),		-- Maneja Comision Administración \nS.- SI \nN.- NO
	Par_ForCobComAdmon			CHAR(1),		-- Forma Cobro Comision Administración \nD.- Disposicion \nT.- Total en primera Disposicion \nC.- Cada Cuota \nP.- Porcentaje
												-- porcentaje podrá ser financiada, deducida o anticipada (liquidada previamente)
	Par_PorcentajeComAdmon		DECIMAL(6,2),	-- permite un valor de 0% a 100%
	Par_ManejaComGarantia		CHAR(1),		-- Maneja Comision por Garantia \nS.- SI \nN.- NO

	Par_ForCobComGarantia		CHAR(1),		-- Forma Cobro Comision Garantia \nC.- Cada Cuota
	Par_PorcentajeComGarantia	DECIMAL(6,2),	-- permite un valor de 0% a 100%

	Par_Salida					CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error

	Par_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Parametros
	DECLARE Par_EsRevolvente	CHAR(1);		-- Es Revolvente \nS.- SI \nN.- NO
	DECLARE Par_LineaCreditoID	BIGINT(20);		-- Numero de Linea de Credito

	-- Declaracion de Variables
	DECLARE NumLineaCredito		CHAR(11);		-- Numero de Linea de Credito por Sucursal
	DECLARE NumLineaCreditoID	BIGINT(20);		-- Numero de Linea de Credito
	DECLARE Verifica			INT(11);		-- Codigo verificador
	DECLARE Var_i				INT(11);		-- Variable I
	DECLARE Var_j				INT(11);		-- Variable J

	DECLARE Modulo2				INT(11);		-- Variable Modulo 2
	DECLARE consecutivo			INT(11);		-- Numero Consecutivo
	DECLARE NumVerificador		CHAR(1);		-- Numero de Verificacion
	DECLARE Var_ManejaLinea		CHAR(1);		-- Maneja Linea
	DECLARE Var_CobraComAnual	CHAR(1);		-- Variable que indica si cobra comisión anual

	DECLARE Var_TipoComAnual	CHAR(1);		-- Variable que indica el tipo de cobro de comisión anual
	DECLARE	Var_ValorComAnual	DECIMAL(14,2);	-- Variable para el valor monto o porcentaje de la comisión anual
	DECLARE Var_Control			VARCHAR(100);	-- Variable de Retorno en Pantalla
	DECLARE Var_MontoMinimo		DECIMAL(12,2);	-- Constante Monto Minimo
	DECLARE Var_MontoMaximo		DECIMAL(12,2);	-- Constante Monto Maximo

	DECLARE Var_ClienteID		INT(11);		-- Numero de Cliente
	DECLARE Var_SucursalID		INT(11);		-- Numero de Sucursal
	DECLARE Var_TipoLineaAgroID	INT(11);		-- Numero de Tipo Linea Agro
	DECLARE Var_ProducCreditoID	INT(11);		-- Numero de Producto de Credito
	DECLARE Var_FechaMaxima		DATE;			-- Fecha Maxima de Vencimiento

	DECLARE Var_Plazo			INT(11);		-- Plazo Maximo por Tipo de Linea de Credito
	DECLARE Var_FechaSistema	DATE;			-- Fecha de Sistema

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante Cadena Vacia
	DECLARE Entero_Cero			INT(11);		-- Constante Entero Cero
	DECLARE Estatus_Inactiva	CHAR(1);		-- Constante Estatus Inactivo
	DECLARE Decimal_Cero		DECIMAL(12,2);	-- Constante Decimal Cero
	DECLARE NoManejaLinea		CHAR(1);		-- Constante No Maneja Linea de Credito

	DECLARE MenorEdad			CHAR(1);		-- Constante Es Menor de Edad
	DECLARE Con_NO				CHAR(1);		-- Constante NO
	DECLARE Con_SI				CHAR(1);		-- Constante SI
	DECLARE Salida_NO			CHAR(1);		-- Constante Salida NO
	DECLARE Salida_SI			CHAR(1);		-- Constante Salida SI

	DECLARE Fecha_Vacia			DATE;			-- Constante Fecha Vacia
	DECLARE Tip_Disposicion		CHAR(1);		-- Constante Tipo Dispocision
	DECLARE Tip_Total			CHAR(1);		-- Constante Total en primera Disposicion
	DECLARE Tip_Cuota			CHAR(1);		-- Constante Cada Cuota
	DECLARE Con_DecimalCien		DECIMAL(12,2);	-- Constante Decimal Cien

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';
	SET	Entero_Cero			:= 0;
	SET	Estatus_Inactiva	:= 'I';
	SET	Decimal_Cero		:= 0.0;
	SET NoManejaLinea		:= 'N';

	SET MenorEdad			:= 'S';
	SET Con_NO				:= 'N';
	SET Con_SI				:= 'S';
	SET Salida_NO			:= 'N';
	SET Salida_SI			:= 'S';

	SET Fecha_Vacia			:= '1900-01-01';
	SET Tip_Disposicion		:= 'D';
	SET Tip_Total			:= 'T';
	SET Tip_Cuota			:= 'C';
	SET Con_DecimalCien		:= 100.00;

	SET Verifica			:= Entero_Cero;
	SET Var_i				:= 1;
	SET Var_j				:= 5;
	SET NumLineaCreditoID	:= Entero_Cero;
	SET Var_Control			:= Cadena_Vacia;
	SET Par_LineaCreditoID	:= Entero_Cero;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-LINEASCREDITOALT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		SET Aud_Usuario					:= IFNULL(Aud_Usuario, Entero_Cero);
		SET Par_ClienteID				:= IFNULL(Par_ClienteID, Entero_Cero);
		SET Par_SucursalID				:= IFNULL(Par_SucursalID, Entero_Cero);
		SET Par_Solicitado				:= IFNULL(Par_Solicitado, Decimal_Cero);
		SET Par_ProductoCreditoID		:= IFNULL(Par_ProductoCreditoID, Entero_Cero);
		SET Par_FolioContrato			:= IFNULL(Par_FolioContrato, Cadena_Vacia);
		SET Par_FechaInicio				:= IFNULL(Par_FechaInicio, Fecha_Vacia);
		SET Par_FechaVencimiento		:= IFNULL(Par_FechaVencimiento, Fecha_Vacia);
		SET Par_EsAgropecuario			:= IFNULL(Par_EsAgropecuario, Con_NO);
		SET Par_TipoLineaAgroID			:= IFNULL(Par_TipoLineaAgroID, Entero_Cero);
		SET Par_ManejaComAdmon			:= IFNULL(Par_ManejaComAdmon, Cadena_Vacia);
		SET Par_ForCobComAdmon			:= IFNULL(Par_ForCobComAdmon, Cadena_Vacia);
		SET Par_PorcentajeComAdmon		:= IFNULL(Par_PorcentajeComAdmon, Entero_Cero);
		SET Par_ManejaComGarantia		:= IFNULL(Par_ManejaComGarantia, Cadena_Vacia);
		SET Par_ForCobComGarantia		:= IFNULL(Par_ForCobComGarantia, Cadena_Vacia);
		SET Par_PorcentajeComGarantia	:= IFNULL(Par_PorcentajeComGarantia, Entero_Cero);

		IF( Aud_Usuario = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El Usuario no esta logueado.';
			SET Var_Control	:= 'usuarioID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_ClienteID = Entero_Cero ) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= 'El Numero de Cliente esta Vacio.';
			SET Var_Control	:= 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		SELECT ClienteID
		INTO Var_ClienteID
		FROM CLIENTES
		WHERE ClienteID = Par_ClienteID;

		IF( IFNULL( Var_ClienteID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:= 'El Cliente no Existe.';
			SET Var_Control	:= 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_SucursalID = Entero_Cero ) THEN
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= 'El numero de Sucursal esta Vacia.';
			SET Var_Control	:= 'sucursalID';
			LEAVE ManejoErrores;
		END IF;

		SELECT SucursalID
		INTO Var_SucursalID
		FROM SUCURSALES
		WHERE SucursalID = Par_SucursalID;

		IF( IFNULL( Var_SucursalID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 005;
			SET Par_ErrMen	:= 'La Sucursal no Existe.';
			SET Var_Control	:= 'sucursalID';
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL( Par_ProductoCreditoID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 006;
			SET Par_ErrMen	:= 'El Producto de Credito esta Vacio.';
			SET Var_Control	:= 'productoCreditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT ProducCreditoID
		INTO Var_ProducCreditoID
		FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID = Par_ProductoCreditoID;

		IF( IFNULL( Var_ProducCreditoID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 007;
			SET Par_ErrMen	:= 'El Producto de Credito no Existe.';
			SET Var_Control	:= 'productoCreditoID';
			LEAVE ManejoErrores;
		END IF;

		/* valida que el cliente no sea menor de edad */
		IF EXISTS (SELECT ClienteID FROM CLIENTES WHERE ClienteID = Par_ClienteID AND EsMenorEdad = MenorEdad) THEN
			SET Par_NumErr	:= 008;
			SET Par_ErrMen	:= 'El Cliente es Menor de Edad.';
			SET Var_Control	:= 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_Solicitado = Decimal_Cero ) THEN
			SET Par_NumErr	:= 009;
			SET Par_ErrMen	:= 'El Monto solicitado esta Vacio.';
			SET Var_Control	:= 'solicitado';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_Solicitado < Decimal_Cero ) THEN
			SET Par_NumErr	:= 010;
			SET Par_ErrMen	:= 'El monto solicitado no debe ser negativo.';
			SET Var_Control	:= 'solicitado';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_EsAgropecuario = Con_NO ) THEN
			-- Obtiene los parametros de la linea de crédito parametrizada en el producto de crédito
			SELECT	ManejaLinea,		MontoMaximo,		MontoMinimo
			INTO 	Var_ManejaLinea,	Var_MontoMaximo,	Var_MontoMinimo
			FROM PRODUCTOSCREDITO
			WHERE ProducCreditoID = Par_ProductoCreditoID;

			SET Var_ManejaLinea		:= IFNULL(Var_ManejaLinea, Con_NO);
			SET Var_MontoMaximo		:= IFNULL(Var_MontoMaximo, Entero_Cero);
			SET Var_MontoMinimo		:= IFNULL(Var_MontoMinimo, Entero_Cero);
			SET Par_EsRevolvente	:= Con_NO;

			IF( Var_ManejaLinea = NoManejaLinea ) THEN
				SET Par_NumErr	:= 011;
				SET Par_ErrMen	:= 'El producto de credito no meneja linea de credito.';
				SET Var_Control	:= 'productoCreditoID';
				LEAVE ManejoErrores;
			END IF;

			/* Valida que lo solicitado no sobrepase el maximo del producto de credito*/
			IF( Par_Solicitado > Var_MontoMaximo ) THEN
				SET Par_NumErr	:= 012;
				SET Par_ErrMen	:= 'El monto solicitado sobre pasa al monto maximo del producto de credito.';
				SET Var_Control	:= 'solicitado';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_Solicitado < Var_MontoMinimo) THEN
				SET Par_NumErr	:= 013;
				SET Par_ErrMen	:= 'El monto solicitado es menor al monto minimo del producto de credito.';
				SET Var_Control	:= 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF( Par_EsAgropecuario = Con_SI ) THEN
			IF( IFNULL( Par_TipoLineaAgroID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 014;
				SET Par_ErrMen	:= 'El Tipo de Linea Agropecuaria esta Vacia.';
				SET Var_Control	:= 'tipoLineaAgroID';
				LEAVE ManejoErrores;
			END IF;

			SELECT TipoLineaAgroID,		EsRevolvente,		MontoLimite,		PlazoLimite
			INTO Var_TipoLineaAgroID,	Par_EsRevolvente,	Var_MontoMaximo,	Var_Plazo
			FROM TIPOSLINEASAGRO
			WHERE TipoLineaAgroID = Par_TipoLineaAgroID;

			SET Par_EsRevolvente := IFNULL(Par_EsRevolvente, Con_SI);
			SET Var_Plazo		 := IFNULL(Var_Plazo, Entero_Cero);

			SET Par_EsRevolvente := IFNULL(Par_EsRevolvente, Cadena_Vacia);

			IF( IFNULL( Var_TipoLineaAgroID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 015;
				SET Par_ErrMen	:= 'El Tipo de Linea Agropecuaria no existe.';
				SET Var_Control	:= 'tipoLineaAgroID';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_EsRevolvente = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 016;
				SET Par_ErrMen	:= 'El Tipo Revolvente asignado al tipo de Linea Agropecuaria esta vacio.';
				SET Var_Control	:= 'tipoLineaAgroID';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_EsRevolvente NOT IN (Con_SI)) THEN
				SET Par_NumErr	:= 017;
				SET Par_ErrMen	:= 'El Tipo Revolvente no es valido.';
				SET Var_Control	:= 'tipoLineaAgroID';
				LEAVE ManejoErrores;
			END IF;

			/* Valida que lo solicitado no sobrepase el maximo del producto de credito*/
			IF( Par_Solicitado > Var_MontoMaximo ) THEN
				SET Par_NumErr	:= 018;
				SET Par_ErrMen	:= 'El monto solicitado sobre pasa al monto maximo del Tipo de Linea de credito.';
				SET Var_Control	:= 'solicitado';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_ManejaComAdmon = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 019;
				SET Par_ErrMen	:= 'El Tipo de Comision por Administracion esta vacio.';
				SET Var_Control	:= 'manejaComAdmon';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_ManejaComAdmon NOT IN (Con_SI, Con_NO)) THEN
				SET Par_NumErr	:= 020;
				SET Par_ErrMen	:= 'El Tipo de Comision por Administracion no es valido.';
				SET Var_Control	:= 'manejaComAdmon';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_ManejaComAdmon = Con_SI ) THEN

				IF( Par_ForCobComAdmon = Cadena_Vacia ) THEN
					SET Par_NumErr	:= 021;
					SET Par_ErrMen	:= 'El Tipo de cobro de Comision por Administracion esta vacio.';
					SET Var_Control	:= 'forCobComAdmon';
					LEAVE ManejoErrores;
				END IF;

				IF( Par_ForCobComAdmon NOT IN (Tip_Disposicion, Tip_Total)) THEN
					SET Par_NumErr	:= 022;
					SET Par_ErrMen	:= 'El Tipo de cobro de Comision por Administracion no es valido.';
					SET Var_Control	:= 'forCobComAdmon';
					LEAVE ManejoErrores;
				END IF;

				IF( Par_PorcentajeComAdmon <= Decimal_Cero ) THEN
					SET Par_NumErr	:= 023;
					SET Par_ErrMen	:= 'El Porcentaje de Comision por Administracion es menor o igual a cero.';
					SET Var_Control	:= 'porcentajeComAdmon';
					LEAVE ManejoErrores;
				END IF;

				IF( Par_PorcentajeComAdmon > Con_DecimalCien ) THEN
					SET Par_NumErr	:= 024;
					SET Par_ErrMen	:= 'El Porcentaje de Comision por Administracion es mayor al 100%.';
					SET Var_Control	:= 'porcentajeComAdmon';
					LEAVE ManejoErrores;
				END IF;
			ELSE
				SET Par_ForCobComAdmon		:= Cadena_Vacia;
				SET Par_PorcentajeComAdmon	:= Decimal_Cero;
			END IF;

			IF( Par_ManejaComGarantia = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 025;
				SET Par_ErrMen	:= 'El Tipo de Comision por Servicio de Garantia esta vacio.';
				SET Var_Control	:= 'manejaComAdmon';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_ManejaComGarantia NOT IN (Con_SI, Con_NO)) THEN
				SET Par_NumErr	:= 026;
				SET Par_ErrMen	:= 'El Tipo de Comision por Servicio de Garantia no es valido.';
				SET Var_Control	:= 'manejaComAdmon';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_ManejaComGarantia = Con_SI ) THEN

				IF( Par_ForCobComGarantia = Cadena_Vacia ) THEN
					SET Par_NumErr	:= 027;
					SET Par_ErrMen	:= 'El Tipo de cobro de Comision por Servicio de Garantia esta vacio.';
					SET Var_Control	:= 'forCobComGarantia';
					LEAVE ManejoErrores;
				END IF;

				IF( Par_ForCobComGarantia NOT IN (Tip_Cuota)) THEN
					SET Par_NumErr	:= 028;
					SET Par_ErrMen	:= 'El Tipo de cobro de Comision por Servicio de Garantia no es valido.';
					SET Var_Control	:= 'forCobComGarantia';
					LEAVE ManejoErrores;
				END IF;

				IF( Par_PorcentajeComGarantia <= Decimal_Cero ) THEN
					SET Par_NumErr	:= 029;
					SET Par_ErrMen	:= 'El Porcentaje de Comision por Servicio de Garantia es menor o igual a cero.';
					SET Var_Control	:= 'porcentajeComGarantia';
					LEAVE ManejoErrores;
				END IF;

				IF( Par_PorcentajeComGarantia > Con_DecimalCien ) THEN
					SET Par_NumErr	:= 030;
					SET Par_ErrMen	:= 'El Porcentaje de Comision por Servicio de Garantia es mayor al 100%.';
					SET Var_Control	:= 'porcentajeComGarantia';
					LEAVE ManejoErrores;
				END IF;
			ELSE
				SET Par_ForCobComGarantia		:= Cadena_Vacia;
				SET Par_PorcentajeComGarantia	:= Decimal_Cero;
			END IF;

			SET Var_FechaMaxima := DATE_ADD(Par_FechaInicio ,INTERVAL Var_Plazo MONTH);
			IF( Par_FechaVencimiento > Var_FechaMaxima ) THEN
				SET Par_NumErr	:= 031;
				SET Par_ErrMen	:= CONCAT('La Fecha de Vencimento supera la fecha Máxima parametrizada: ' , Var_FechaMaxima);
				SET Var_Control	:= 'fechaVencimiento';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SELECT FechaSistema
		INTO Var_FechaSistema
		FROM PARAMETROSSIS
		LIMIT 1;

		IF( Par_FechaInicio < Var_FechaSistema ) THEN
			SET Par_NumErr	:= 032;
			SET Par_ErrMen	:= 'La Fecha de Inicio no puede ser inferior a la del sistema.';
			SET Var_Control	:= 'fechaInicio';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_FechaVencimiento < Var_FechaSistema ) THEN
			SET Par_NumErr	:= 033;
			SET Par_ErrMen	:= 'La Fecha de Vencimento no puede ser inferior a la del sistema.';
			SET Var_Control	:= 'fechaVencimiento';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_FechaVencimiento < Par_FechaInicio) THEN
			SET Par_NumErr	:= 034;
			SET Par_ErrMen	:= CONCAT('La Fecha de Vencimento no puede ser inferior a la fecha de Inicio.');
			SET Var_Control	:= 'fechaVencimiento';
			LEAVE ManejoErrores;
		END IF;

		-- Obtiene los parametros de la linea de crédito parametrizada en el producto de crédito
		SELECT	CobraComAnual,		TipoComAnual, 		ValorComAnual
		INTO 	Var_CobraComAnual,	Var_TipoComAnual,	Var_ValorComAnual
		FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID = Par_ProductoCreditoID;

		-- Si es una linea de credito Agropecuaria los parametro de comisiones del producto de credito no aplica(Segunda Fase)
		IF( Par_EsAgropecuario = Con_SI ) THEN
			SET Var_CobraComAnual	:= Con_NO;
			SET Var_TipoComAnual	:= Cadena_Vacia;
			SET Var_ValorComAnual	:= Entero_Cero;
		END IF;

		SET Var_CobraComAnual	:= IFNULL(Var_CobraComAnual, Con_NO);
		SET Var_TipoComAnual	:= IFNULL(Var_TipoComAnual, Cadena_Vacia);
		SET Var_ValorComAnual	:= IFNULL(Var_ValorComAnual, Entero_Cero);

		SET consecutivo		:= (SELECT IFNULL(COUNT(*),0)+1 FROM LINEASCREDITO);
		SET NumLineaCredito	:= CONCAT((SELECT LPAD(Par_SucursalID,3,0)),(SELECT LPAD(consecutivo,7,0)));

		WHILE Var_i <= 10 DO
			SET Verifica :=  Verifica +  (CONVERT((SUBSTRING(NumLineaCredito,Var_i,1)),UNSIGNED INT)* Var_j);
			SET Var_j := Var_j - 1;
			SET Var_i := Var_i + 1;
			IF (Var_j = 1) THEN
				SET Var_j := 7;
			END IF;
		END WHILE;

		SET Modulo2 := Verifica % 11;

		IF (Modulo2 = 0) THEN
			SET Verifica := 1;
		ELSE
			IF (Modulo2 = 1) THEN
				SET Verifica := 0;
			ELSE
				SET Verifica := 11 - Modulo2;
			END IF;
		END IF;

		SET NumVerificador		:= LTRIM(RTRIM(CONVERT(Verifica, CHAR)));
		SET NumLineaCreditoID	:= CONCAT(NumLineaCredito,NumVerificador);

		SET Aud_FechaActual := NOW();
		INSERT LINEASCREDITO (
			LineaCreditoID,		ClienteID,				CuentaID, 				MonedaID, 				SucursalID,
			FolioContrato,		FechaInicio,			FechaVencimiento,		ProductoCreditoID,		Solicitado,
			Autorizado,			Dispuesto,				Pagado,					SaldoDisponible,		SaldoDeudor,
			Estatus,			NumeroCreditos,			CobraComAnual,			TipoComAnual,			ValorComAnual,
			ComisionCobrada,	EsAgropecuario,			TipoLineaAgroID,		EsRevolvente,			ManejaComAdmon,
			ForCobComAdmon,		PorcentajeComAdmon,		ManejaComGarantia,		ForCobComGarantia,		PorcentajeComGarantia,
			FechaRechazo,		UsuarioRechazo,			MontoUltimoIncremento,	FechaReactivacion,		UsuarioReactivacion,
			SaldoComAnual,		FechaCancelacion,		FechaBloqueo,			FechaDesbloqueo,		FechaAutoriza,
			UsuarioAutoriza,	UsuarioBloqueo,			UsuarioDesbloq,			UsuarioCancela,			MotivoBloqueo,
			MotivoDesbloqueo,	MotivoCancela,			IdenCreditoCNBV,		UltFechaDisposicion,	UltMontoDisposicion,
			EmpresaID,			Usuario,				FechaActual,			DireccionIP,			ProgramaID,
			Sucursal,			NumTransaccion)
		VALUES (
			NumLineaCreditoID,	Par_ClienteID,			Par_CuentaID,			Par_MonedaID,			Par_SucursalID,
			Par_FolioContrato,	Par_FechaInicio,		Par_FechaVencimiento,	Par_ProductoCreditoID,	Par_Solicitado,
			Decimal_Cero,		Decimal_Cero,			Decimal_Cero,			Decimal_Cero,			Decimal_Cero,
			Estatus_Inactiva,	Entero_Cero,			Var_CobraComAnual,		Var_TipoComAnual,		Var_ValorComAnual,
			Con_NO,				Par_EsAgropecuario,		Par_TipoLineaAgroID,	Par_EsRevolvente,		Par_ManejaComAdmon,
			Par_ForCobComAdmon,	Par_PorcentajeComAdmon,	Par_ManejaComGarantia,	Par_ForCobComGarantia,	Par_PorcentajeComGarantia,
			Fecha_Vacia,		Entero_Cero,			Decimal_Cero,			Fecha_Vacia,			Entero_Cero,
			Entero_Cero,		Fecha_Vacia,			Fecha_Vacia,			Fecha_Vacia,			Fecha_Vacia,
			Entero_Cero,		Entero_Cero,			Entero_Cero,			Entero_Cero,			Cadena_Vacia,
			Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,			Fecha_Vacia,			Decimal_Cero,
			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_LineaCreditoID	:= NumLineaCreditoID;
		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT("Linea de Credito Agregada Exitosamente: ", CONVERT(Par_LineaCreditoID, CHAR));
		SET Var_Control	:= 'lineaCreditoID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF( Par_Salida = Salida_SI ) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_LineaCreditoID AS Consecutivo;
	END IF;

END TerminaStore$$