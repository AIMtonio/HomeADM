-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONCILIADETAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCONCILIADETAALT`;DELIMITER $$

CREATE PROCEDURE `TARDEBCONCILIADETAALT`(
	# =====================================================================================
	# ----- STORED QUE INSERTA LOS DETALLES DE ARCHIVO DE CONCILIACION -------
	# =====================================================================================

	Par_ConciliaID				INT(11),		-- Id de la conciliacion
	Par_BancoEmisor				INT(11),		-- Banco emisor
	Par_NumCuenta				VARCHAR(19),	-- Numero de cuenta
	Par_NaturalezaConta			CHAR(1),		-- Naturaleza conta
	Par_MarcaProducto			CHAR(1),		-- Marca producto

	Par_FechaConsumo			CHAR(6),		-- Fecha de consumo
	Par_FechaProceso			CHAR(6),		-- Fecha de proceso
	Par_TipoTransaccion			CHAR(2),		-- Tiempo de transaccion
	Par_NumLiquidacion			INT(11),		-- Numero de liquidacion
	Par_ImporteOrigenTrans		DECIMAL(12,2),	-- Importe origen de transaccion

	Par_ImporteOrigenCon		DECIMAL(12,2),	-- Importe origen con
	Par_CodigoMonedaOrigen		INT(11),		-- Codigo de moneda de origen
	Par_ImporteDestinoTotal		DECIMAL(12,2),	-- Total del importe de destino
	Par_ImporteDestinoCon		DECIMAL(12,2),	-- Importe Destino conciliacion
	Par_ClaveMonedaDestino		INT(11),		-- Clave de moneda de destino

	Par_ImporteLiquidado		DECIMAL(12,2),	-- Importe liquidado
	Par_ImporteLiquidadoCon		DECIMAL(12,2),	-- Importe liquidado con
	Par_ClaveMonedaLiqui		INT(11),		-- Clave de la moneda de liquidacion
	Par_ClaveComercio			VARCHAR(15),	-- Clave de comercio
	Par_GiroNegocio				VARCHAR(5),		-- Giro de negocio

	Par_NombreComercio			VARCHAR(30),	-- Nombre del comercio
	Par_PaisOrigen				VARCHAR(3),		-- Pais de origen
	Par_RFCComercio				VARCHAR(13),	-- RFC del comercio
	Par_NumeroFuente			INT(11),		-- Numero fuente
	Par_NumAutorizacion			VARCHAR(6),		-- Numero de autorizacion

	Par_BancoReceptor			INT(11),		-- Banco Receptor
	Par_ReferenciaTrans			VARCHAR(23),	-- Refencia de la transaccion
	Par_FIIDEmisor				VARCHAR(4),		-- FIID emisor
	Par_FIIDAdquiriente			VARCHAR(4),		-- FIID aquiriente
	Par_Salida					CHAR(1),		-- Salida del store

	INOUT Par_NumErr			INT(11),		-- Numero de error
	INOUT Par_ErrMen			VARCHAR(150),	-- Mensaje de error

	-- Parametros de auditoria
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(250),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
	)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Num_Movs		INT(11);		-- Numero de movimientos

-- Declaracion de Constantes
DECLARE Cadena_Vacia	CHAR(1);		-- Cadena vacia
DECLARE Entero_Cero		INT(11);		-- Entero cero
DECLARE Salida_SI		CHAR(1);		-- Store Si tiene un valor de salida
DECLARE Var_Control		VARCHAR(100);	-- Variable de control
DECLARE Var_DetalleID	INT(11);		-- Variable de ID de detalle
DECLARE Estatus_NOConci	CHAR(1);		-- Estado No concilia
DECLARE Corresponsales	INT(11);		-- Corresponsales
DECLARE Pago_Corresponsales	INT(11);		-- Corresponsales
DECLARE Desc_Corresp	VARCHAR(50);	-- Descripcion corresponsales

-- Asignacion de constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Entero_Cero			:= 0;				-- Entero cero
SET Salida_SI			:= 'S';				-- Store si tiene valor de salida
SET Estatus_NOConci		:= 'N';				-- Estado No concilia
SET Corresponsales		:= 20;				-- Pago de Corresponsales
SET Pago_Corresponsales	:= 50;				-- Pago de Corresponsales
SET Desc_Corresp	:= 'PAGO CORRESPONSALES'; -- Descripcion corresponsales

	ManejaErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,'estamos trabajando para resolverla.
									Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-TARDEBCONCILIADETAALT');
			SET Var_Control = 'SQLEXCEPTION' ;
		END;

		IF Par_TipoTransaccion = Corresponsales THEN
			SET Par_NumErr = 0;
			SET Par_ErrMen = 'Registro Guardado Correctamente Batch 510';
			SET Var_Control = Cadena_Vacia ;
            LEAVE ManejaErrores;
        END IF;

		SET Par_NumCuenta	:=  TRIM(Par_NumCuenta);

		# SE OBTIENE EL NUMERO DE FOLIO
		CALL FOLIOSAPLICAACT('TARDEBCONCILIADETA', Var_DetalleID);

		# SE INSERTAN LOS REGISTROS A LA TABLA TARDEBCONCILIADETA
		INSERT INTO `TARDEBCONCILIADETA`(
			`ConciliaID`,			`DetalleID`,		`BancoEmisor`,			`NumCuenta`,			`NaturalezaConta`,
			`MarcaProducto`,		`FechaConsumo`,		`FechaProceso`,			`TipoTransaccion`,		`NumLiquidacion`,
			`ImporteOrigenTrans`,	`ImporteOrigenCon`,	`CodigoMonedaOrigen`,	`ImporteDestinoTotal`,	`ImporteDestinoCon`,
			`ClaveMonedaDestino`,	`ImporteLiquidado`,	`ImporteLiquidadoCon`,	`ClaveMonedaLiqui`,		`ClaveComercio`,
			`GiroNegocio`,			`NombreComercio`,	`PaisOrigen`,			`RFCComercio`,			`NumeroFuente`,
			`NumAutorizacion`,		`BancoReceptor`,	`ReferenciaTrans`,		`FIIDEmisor`,			`FIIDAdquiriente`,
			`FolioConcilia`,		`EstatusConci`,		`EmpresaID`,			`Usuario`,				`FechaActual`,
			`DireccionIP`,			`ProgramaID`,		`Sucursal`,				`NumTransaccion`)
		VALUES(
			Par_ConciliaID,			Var_DetalleID,			Par_BancoEmisor,			Par_NumCuenta,				Par_NaturalezaConta,
			Par_MarcaProducto,		Par_FechaConsumo,		Par_FechaProceso,			Par_TipoTransaccion,		Par_NumLiquidacion,
			Par_ImporteOrigenTrans,	Par_ImporteOrigenCon,	Par_CodigoMonedaOrigen,		Par_ImporteDestinoTotal,	Par_ImporteDestinoCon,
			Par_ClaveMonedaDestino,	Par_ImporteLiquidado,	Par_ImporteLiquidadoCon,	Par_ClaveMonedaLiqui,		Par_ClaveComercio,
			Par_GiroNegocio,		Par_NombreComercio,		Par_PaisOrigen,				Par_RFCComercio,			Par_NumeroFuente,
			Par_NumAutorizacion,	Par_BancoReceptor,		Par_ReferenciaTrans	,		Par_FIIDEmisor	,			Par_FIIDAdquiriente,
			Entero_Cero, 			Estatus_NOConci, 		Par_EmpresaID,				Aud_Usuario,				Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion );

		# SE ACTUALIZA EL TIPO DE OPERACION PARA PAGO DE CORRESPONSALES
        IF(Par_TipoTransaccion = Pago_Corresponsales) THEN

			# SE CONSULTA EL NUMERO DE MOVIMIENTOS REGISTRADOS EN TARDEBBITACORAMOVS
			SET Num_Movs := (SELECT COUNT(*) FROM TARDEBBITACORAMOVS
								WHERE TarjetaDebID = Par_NumCuenta
                                AND NumTransaccion = Par_NumAutorizacion
                            AND MontoOpe = Par_ImporteLiquidado);

			# SI NO HAY MOVIMIENTOS EN LA TABLA CORRESPONDEN A CORRESPONSALES
			IF(Num_Movs = Entero_Cero) THEN

				UPDATE TARDEBCONCILIADETA
					SET TipoOperacion	= Desc_Corresp	-- Se actualiza el campo Tipo operacion para identificar los pagos de corresponsales
                WHERE ConciliaID 		= Par_ConciliaID
					AND DetalleID		= Var_DetalleID
					AND NumCuenta 		= Par_NumCuenta
					AND NumTransaccion	= Aud_NumTransaccion
					AND FechaActual		= Aud_FechaActual;

            END IF;
        END IF;


		SET Par_NumErr  := 000;
		SET Par_ErrMen	:= 'Registro Guardado Correctamente';
        SET Var_Control := Cadena_Vacia;
		SET Entero_Cero := Par_ConciliaID;
	END ManejaErrores;

	IF (Par_Salida = Salida_SI) THEN
		    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;
	END IF;
END TerminaStore$$