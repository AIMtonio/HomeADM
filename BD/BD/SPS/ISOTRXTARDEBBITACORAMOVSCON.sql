DELIMITER ;
DROP PROCEDURE IF EXISTS ISOTRXTARDEBBITACORAMOVSCON;
DELIMITER $$

CREATE PROCEDURE ISOTRXTARDEBBITACORAMOVSCON(
	-- Descripcion: Proceso operativo que realiza la consulta del movimiento de la bitacora de isotrx
	-- Modulo: Procesos de ISOTRX
	Par_TarDebMovID				INT(11),		-- Consecutivo del movimiento de tarjeta
	Par_NumeroTarjeta			VARCHAR(16),	-- Numero de Tarjeta del SAFI
	Par_TipoOperacionID			INT(11),		-- Catalogo CATTIPOPERACIONISOTRX
	Par_NumCon					INT(11),		-- Numero de consulta

	Par_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore:BEGIN

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

	-- Declaracion de numero de consultas
	DECLARE Con_Principal		INT(11);			-- Numero de consulta principal

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';				-- Cadena vacia
	SET	Entero_Cero				:= 0;				-- Entero cero
	SET	DecimalCero				:= 0.00;			-- DECIMAL cero
	SET	Salida_NO				:= 'N';				-- Mensaje de salida: NO
	SET	Var_Si					:= 'S';	    		-- Mensaje de salida: SI
	SET Concilia_NO				:= 'N';				-- Estatus NO Conciliado
	SET Est_Registrado			:= 'R';				-- Estatus Registrado
	SET Fecha_Vacia     		:= '1900-01-01'; 	-- Fecha Vacia
	SET Hora_Vacia      		:= '00:00:00';		-- Hora vacia

	-- Asignacion de numero de consulta
	SET Con_Principal			:= 1;

	-- 1.- Consulta principal
	IF(Par_NumCon = Con_Principal)THEN
		SELECT
			TarDebMovID,			TipoMensaje,					TipoOperacionID,		TarjetaDebID,				OrigenInst,
			MontoOpe,
			DATE_FORMAT(FechaHrOpe, "%m%d") AS FechaTransaccion,	DATE_FORMAT(FechaHrOpe, "%H%i%s") AS HoraTransaccion,
			NumeroTran,				GiroNegocio,					PuntoEntrada,
			TerminalID,				NombreUbicaTer,					NIP,					CodigoMonOpe,				MontosAdiciona,
			MontoSurcharge,			MontoLoyaltyfee,				Referencia,				DatosTiempoAire,			EstatusConcilia,
			FolioConcilia,			DetalleConciliaID,				TransEnLinea,			CheckIn,					CodigoAprobacion,
			Estatus,				EmisorID,						MensajeID,				ModoEntrada,
			ResultadoOperacion,		EstatusOperacion,
			REPLACE(FechaOperacion, '-', Cadena_Vacia) AS FechaOperacion, REPLACE(HoraOperacion, ':',Cadena_Vacia) AS HoraOperacion,
			DATE_FORMAT(FechaOperacion, "%m%d") AS OriFechaTransaccion,
			CodigoRespuesta,		CodigoRechazo,					NumeroCuenta,			MontoRemplazo,				SaldoDisponible,
			ProDiferimiento,		ProNumeroPagos,					ProTipoPlan,			OriCodigoAutorizacion,
			OriHoraTransaccion,		DesNumeroCuenta,				DesNumeroTarjeta,		TrsClaveRastreo,			TrsInstitucionRemitente,
			TrsNombreEmisor,		TrsTipoCuentaRemitente,			TrsCuentaRemitente,		TrsConceptoPago,			EmpresaID,
			Usuario,				FechaActual,					DireccionIP,			ProgramaID,					Sucursal,
			NumTransaccion
		FROM TARDEBBITACORAMOVS
		WHERE TarDebMovID = Par_TarDebMovID;
	END IF;

END TerminaStore$$