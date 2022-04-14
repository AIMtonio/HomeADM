-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBBITACORAMOVSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBBITACORAMOVSALT`;
DELIMITER $$


CREATE PROCEDURE `TARDEBBITACORAMOVSALT`(
	/* SP QUE INSERTA EN LA TABLA DE BITACORA DE TARJETAS
		USADO EN WS DE OPERACIONES TARJETA*/
	Par_TipoMensaje			CHAR(4),
	Par_TipoOpeID 			CHAR(2),
	Par_TarDebID			CHAR(16),
	Par_OrigenInst 			CHAR(2),
	Par_MontoOpe 			DECIMAL(12,2),

	Par_FechaHrOpe 			VARCHAR(20),
	Par_NumeroTran 			BIGINT(20),
	Par_GiroNegocio 		VARCHAR(5),
	Par_PuntoEntrada 		CHAR(2),
	Par_TerminalID 			VARCHAR(50),

	Par_NombreUbiTer 		VARCHAR(50),
	Par_NIP 				VARCHAR(256),
	Par_CodigoMonOpe 		VARCHAR(10),
	Par_MontosAdi	 		DECIMAL(12,2),
	Par_MonSurcharge 		DECIMAL(12,2),

	Par_MonLoyaltyfee 		DECIMAL(12,2),
	Par_Referencia			VARCHAR(12),
	Par_DatosTiempoAire		VARCHAR(90),
	Par_CheckIn				CHAR(1),
	Par_CodigoAprobacion 	BIGINT(20),

	Par_CompraEnLinea		CHAR(1),
	INOUT Par_TarDebMovID	INT(11),
	Par_Salida				CHAR(1),
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),

    Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)

	)

TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE	Par_NumErr			INT(11);			-- Almacena el numero de error
	DECLARE Par_ErrMen			VARCHAR(150);		-- Almacena la descripcion del error
	DECLARE Var_TarDebMovID		INT(11);			-- Almacena el valor del numero consecutivo

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT;
	DECLARE	DecimalCero			DECIMAL(12,2);
	DECLARE Salida_NO 			CHAR(1);
	DECLARE	Var_Si	 			CHAR(1);

	DECLARE Concilia_NO			CHAR(1);
	DECLARE Est_Registrado		CHAR(1);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Hora_Vacia          TIME;
	-- Asignacion de constantes
	SET	Cadena_Vacia	:= '';		-- Cadena vacia
	SET	Entero_Cero		:= 0;		-- Entero cero
	SET	DecimalCero		:= 0.00;	-- DECIMAL cero
	SET	Salida_NO		:= 'N';		-- Mensaje de salida: NO
	SET	Var_Si			:= 'S';	    -- Mensaje de salida: SI

	SET Concilia_NO		:= 'N';		-- Estatus NO Conciliado
	SET Est_Registrado	:= 'R';		-- Estatus Registrado
	SET Fecha_Vacia     := '1900-01-01';  -- Fecha Vacia
	SET Hora_Vacia      := '00:00:00';


	SET Aud_FechaActual	:= NOW();

		CALL FOLIOSAPLICAACT('TARDEBBITACORAMOVS', Var_TarDebMovID);

		INSERT INTO `TARDEBBITACORAMOVS`
			(`TarDebMovID`,		      `TipoMensaje`,       `TipoOperacionID`,       `TarjetaDebID`,		   `OrigenInst`,
			`MontoOpe`,			      `FechaHrOpe`,		   `NumeroTran`,		    `GiroNegocio`,		   `PuntoEntrada`,
			`TerminalID`,		      `NombreUbicaTer`,	   `NIP`,			        `CodigoMonOpe`,		   `MontosAdiciona`,
			`MontoSurcharge`,	      `MontoLoyaltyfee`,   `Referencia`,		    `DatosTiempoAire`,	   `EstatusConcilia`,
			`TransEnLinea`,		      `CheckIn`,		   `CodigoAprobacion`,      `Estatus`,	           `EmisorID`,
			`MensajeID`,              `ModoEntrada`,       `ResultadoOperacion`,    `EstatusOperacion`,    `FechaOperacion`,
			`HoraOperacion`,          `CodigoRespuesta`,   `CodigoRechazo`,         `NumeroCuenta`,        `MontoRemplazo`,
			`SaldoDisponible`,        `ProDiferimiento`,   `ProNumeroPagos`,        `ProTipoPlan`,         `OriCodigoAutorizacion`,
			`OriFechaTransaccion`,    `OriHoraTransaccion`,`DesNumeroCuenta`,       `DesNumeroTarjeta`,    `TrsClaveRastreo`,
			`TrsInstitucionRemitente`,`TrsNombreEmisor`,   `TrsTipoCuentaRemitente`,`TrsCuentaRemitente`,  `TrsConceptoPago`,
			`TrsReferenciaNumerica`,  `EmpresaID`,         `Usuario`,			    `FechaActual`,         `DireccionIP`,
			`ProgramaID`,		      `Sucursal`,          `NumTransaccion`)
		VALUES(
			Var_TarDebMovID,	       Par_TipoMensaje,	    Par_TipoOpeID, 			Par_TarDebID, 		    Par_OrigenInst,
			Par_MontoOpe,		       Par_FechaHrOpe,		Par_NumeroTran,			Par_GiroNegocio,	    Par_PuntoEntrada,
			Par_TerminalID,		       Par_NombreUbiTer,	Par_NIP,				Par_CodigoMonOpe,	    Par_MontosAdi,
			Par_MonSurcharge,	       Par_MonLoyaltyfee,	Par_Referencia,			Par_DatosTiempoAire,    Concilia_NO,
			Par_CompraEnLinea,	       Par_CheckIn,		    Par_CodigoAprobacion,	Est_Registrado, 	    Entero_Cero,
			Cadena_Vacia,              Entero_Cero,         Entero_Cero,            Entero_Cero,            Fecha_Vacia,
			Hora_Vacia,                Cadena_Vacia,        Entero_Cero ,           Entero_Cero,            DecimalCero,
			DecimalCero,               Entero_Cero,         Entero_Cero,            Entero_Cero,            Cadena_Vacia,
			Fecha_Vacia,               Hora_Vacia,          Entero_Cero,            Cadena_Vacia,           Cadena_Vacia,
			Entero_Cero,               Cadena_Vacia,        Entero_Cero,            Cadena_Vacia,           Cadena_Vacia,
			Entero_Cero,		       Par_EmpresaID,       Aud_Usuario,		    Aud_FechaActual,	    Aud_DireccionIP,
			Aud_ProgramaID,		       Aud_Sucursal,        Aud_NumTransaccion	);

	SET Par_TarDebMovID	:= Var_TarDebMovID;

	IF(Par_Salida =  Var_Si) THEN
		SELECT '00' AS CodigoRespuesta,
				'Operacion Registrada .' AS MensajeRespuesta,
				'numero' AS SaldoActualizado,
				Entero_Cero AS NumeroTransaccion;
	ELSE
		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Operacion Registrada.';
	END IF;

END TerminaStore$$