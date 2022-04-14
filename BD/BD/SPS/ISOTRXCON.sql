-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ISOTRXCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ISOTRXCON`;

DELIMITER $$
CREATE PROCEDURE `ISOTRXCON`(
	-- Store Procedure para obtener los Elementos de la peticion JSON para ISOTRX
	-- Modulo Tarjetas de Debido WS ISOTRX
	Par_TarjetaDebitoID			CHAR(16),			-- Numero de Tarjeta de Debito
	Par_MontoOperacion			DECIMAL(14,2),		-- Monto de Operacion
	Par_TipoInstrumento			INT(11),			-- Tipo de Instrumento (Cuenta de Ahorro, Inversion, Cede, Credito)
	Par_NumeroInstrumento		BIGINT(20),			-- Numero de Instrumento (CuentaAhoID, InversionID, CedeID, CreditoID)
	Par_TipoProceso				TINYINT UNSIGNED,	-- ID de Proceso(JAVA)

	Par_TipoConsulta			TINYINT UNSIGNED,	-- Numero de Consulta

	Aud_EmpresaID 				INT(11),			-- Parametro de Auditoria Empresa ID
	Aud_Usuario 				INT(11),			-- Parametro de Auditoria Usuario ID
	Aud_FechaActual 			DATE,				-- Parametro de Auditoria Fecha Actual
	Aud_DireccionIP 			VARCHAR(15),		-- Parametro de Auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de Auditoria Programa ID
	Aud_Sucursal				INT(11),			-- Parametro de Auditoria Sucursal ID
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de Auditoria Numero Transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaSistema				DATE;				-- Fecha de Sistema
	DECLARE Var_EsReinversion				INT(11);			-- Es Reinversion
	DECLARE Var_EsReinversionCede			INT(11);			-- Es Reinversion Cede
	DECLARE Var_EsTarjetaDebito				INT(11);			-- Es Tarjeta Debito
	DECLARE Var_Movimientos					INT(11);			-- Movimiento Operativo

	DECLARE Var_DisposicionesDia			INT(11);			-- Numero de Disposiciones Diarias
	DECLARE Var_Notificar					CHAR(1);			-- Bandera para notificar
	DECLARE Var_NotificarOperaciones		CHAR(1);			-- Bandera para notificar operaciones
	DECLARE Var_EstatusInversion			CHAR(1);			-- Estatus de Inversion

	DECLARE Var_EstatusTarjeta				CHAR(1);			-- Variable para el Estatus de la Tarjeta de debito
	DECLARE Var_TarjetaDebitoID				CHAR(16);			-- Tarjeta de Debito
	DECLARE Var_CuentaAhoID					BIGINT(12);			-- Variable Cuenta de Ahorro
	DECLARE Var_DescripcionMov				VARCHAR(200);		-- Variable para almacenar la Descripcion de la operacion
	DECLARE Var_PrefijoEmisor				VARCHAR(200);		-- Variable para almacenar el valor del campo PrefijoEmisor

	DECLARE Var_IDEmisor					VARCHAR(200);		-- Variable para almacenar el valor del campo IDEmisor
	DECLARE Var_NombreCompleto				VARCHAR(200);		-- Variable para almacenar el Nombre completo
	DECLARE Var_AutorizaTerceroTranTD		VARCHAR(200);		-- Variable para almacenar el valor del campo AutorizaTerceroTranTD
	DECLARE Var_RutaConWSAutoriza			VARCHAR(200);		-- Variable para almacenar el valor del campo RutaConWSAutoriza
	DECLARE Var_TimeOutConWSAutoriza		VARCHAR(200);		-- Variable para almacenar el valor del campo TimeOutConWSAutoriza

	DECLARE Var_UsuarioConWSAutoriza		VARCHAR(200);		-- Variable para almacenar el valor del campo UsuarioConWSAutoriza
	DECLARE Var_OperacionPeticion			VARCHAR(200);		-- Variable para almacenar el valor del campo OperacionPeticion
	DECLARE Var_TarjetaPeticion				VARCHAR(200);		-- Variable para almacenar el valor del campo TarjetaPeticion

	DECLARE Var_EjecucionCierreDia			VARCHAR(200);		-- Variable para almacenar el valor del campo EjecucionCierreDia
	DECLARE Var_ProVencMasivoCedes			VARCHAR(200);		-- Variable para almacenar el valor del campo ProVencMasivoCedes
	DECLARE Var_EjecucionCobAut 			VARCHAR(200);		-- Variable para almacenar el valor del campo EjecucionCobAut
	DECLARE Var_EjecucionCobAutRef			VARCHAR(200);		-- Variable para almacenar el valor del campo EjecucionCobAutRef
	DECLARE Var_NotificacionTarCierreDia	VARCHAR(200);		-- Variable para almacenar el valor del campo NotificacionTarCierreDia

	DECLARE Var_SaldoDisponible				DECIMAL(12,2);		-- Saldo Disponible de la Cuenta de Ahorro
	DECLARE Var_MontoMaxDia					DECIMAL(14,2);		-- Monto Maximo del Dia
	DECLARE Var_MontoMaxCompraDia			DECIMAL(14,2);		-- Monto Maximo Compra Diario
	DECLARE Var_MontoMaxMes					DECIMAL(14,2);		-- Monto Maximo Mensual
	DECLARE Var_MontoMaxComprasMensual		DECIMAL(14,2);		-- Monto Maximo Compras Mensual

	DECLARE Var_MontoInversion				DECIMAL(14,2);		-- Monto de Inversion
	DECLARE Var_MontoCede					DECIMAL(14,2);		-- Monto de Cede
	DECLARE Var_MontoCredito				DECIMAL(14,2);		-- Monto del Credito
	DECLARE Var_ComandoID					TINYINT UNSIGNED;	-- Numero de Comando
	DECLARE Var_TipoOperacion				TINYINT UNSIGNED;	-- Tipo de Operacion

	DECLARE Var_RutaConSAFIWS				VARCHAR(200);		-- Variable para almacenar el valor del campo RutaConSAFIWS
	DECLARE Var_UsuarioConSAFIWS			VARCHAR(200);		-- Variable para almacenar el valor del campo UsuarioConSAFIWS
	DECLARE Var_TarjetaPeticionSAFI			VARCHAR(200);		-- Variable para almacenar el valor del campo TarjetaPeticionSAFI
	DECLARE Var_OperacionPeticionSAFI		VARCHAR(200);		-- Variable para almacenar el valor del campo OperacionPeticionSAFI

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia					CHAR(1);			-- Constante Cadena Vacia
	DECLARE Entero_Cero						INT(11);			-- Constante Entero Vacio
	DECLARE Decimal_Cero					DECIMAL(12,2);		-- Constante Decimal Vacio
	DECLARE Fecha_Vacia						DATE;				-- Constante Fecha Vacia
	DECLARE Est_Activada					INT(11);			-- Constante Estatus Activada

	DECLARE Default_TimeOut					INT(11);			-- Constante Time out Default
	DECLARE Con_TarjetaDebito				INT(11);			-- Tipo Tarjeta Debito
	DECLARE Entero_Uno						INT(11);			-- Constante Entero Uno
	DECLARE TipMov_AperturaInversion		INT(11);			-- APERTURA INVERSION
	DECLARE TipMov_Reinversion				INT(11);			-- REINVERSION MANUAL

	DECLARE TipMov_IntGraInversion			INT(11);			-- PAGO INVERSION. INTERES GRAVADO
	DECLARE TipMov_IntExtInversion			INT(11);			-- PAGO INVERSION. INTERES EXCENTO
	DECLARE TipMov_ISRInversion				INT(11);			-- RETENCION ISR INVERSION
	DECLARE TipMov_VenAnticInversion		INT(11);			-- VENCIMIENTO ANTICIPADO INVERSION
	DECLARE TipMov_AperturaCede				INT(11);			-- APERTURA CEDE

	DECLARE TipMov_CapitalCede				INT(11);			-- PAGO CEDE. CAPITAL
	DECLARE TipMov_IntGraCede 				INT(11);			-- PAGO CEDE. INTERES GRAVADO
	DECLARE TipMov_IntExcCede 				INT(11);			-- PAGO CEDE. INTERES EXCENTO
	DECLARE TipMov_ISRCede 					INT(11);			-- RETENCION ISR CEDE
	DECLARE TipMov_VenActicCede 			INT(11);			-- VENCIMIENTO ANTICIPADO CEDE

	DECLARE Nat_Abono 						CHAR(1);			-- Constante Naturaleza Abono
	DECLARE Nat_Cargo 						CHAR(1);			-- Constante Naturaleza Cargo
	DECLARE Tipo_Titular					CHAR(1);			-- Tipo Tarjeta Titular
	DECLARE Tipo_Adicional					CHAR(1);			-- Tipo Tarjeta Adicional
	DECLARE Con_NO 							CHAR(1);			-- Constante NO

	DECLARE Con_SI							CHAR(1);			-- Constante SI
	DECLARE Con_EstInvRegistrada			CHAR(1);			-- Estatus de Inversion Registrada
	DECLARE Con_EstInvCancelada				CHAR(1);			-- Estatus de Cancelada Vigente
	DECLARE Con_MonedaMX					CHAR(3);			-- Moneda Mexicana
	DECLARE Est_Registrado					CHAR(1);			-- Estatus Registrado

	DECLARE Llave_IDEmisor					VARCHAR(50);		-- Llave IDEmisor
	DECLARE Llave_PrefijoEmisor				VARCHAR(50);		-- Llave PrefijoEmisor
	DECLARE Llave_AutorizaTerceroTranTD		VARCHAR(50);		-- Llave AutorizaTerceroTranTD
	DECLARE Llave_RutaConWSAutoriza			VARCHAR(50);		-- Llave RutaConWSAutoriza
	DECLARE Llave_TimeOutConWSAutoriza		VARCHAR(50);		-- Llave TimeOutConWSAutoriza

	DECLARE Llave_UsuarioConWSAutoriza		VARCHAR(50);		-- Llave UsuarioConWSAutoriza
	DECLARE Llave_OperacionPeticion			VARCHAR(50);		-- Llave OperacionPeticion
	DECLARE Llave_TarjetaPeticion			VARCHAR(50);		-- Llave TarjetaPeticion

	DECLARE Llave_EjecucionCierreDia		VARCHAR(50);		-- Llave EjecucionCierreDia
	DECLARE Llave_ProVencMasivoCedes		VARCHAR(50);		-- Llave ProVencMasivoCedes
	DECLARE Llave_EjecucionCobAut 			VARCHAR(50);		-- Llave EjecucionCobAut
	DECLARE Llave_EjecucionCobAutRef		VARCHAR(50);		-- Llave EjecucionCobAutRef
	DECLARE Llave_NotificacionTarCierreDia 	VARCHAR(50);		-- Llave NotificacionCierreDia

	DECLARE Llave_RutaConSAFIWS				VARCHAR(50);		-- Llave RutaConSAFIWS
	DECLARE Llave_UsuarioConSAFIWS			VARCHAR(50);		-- Llave UsuarioConSAFIWS
	DECLARE Llave_TarjetaPeticionSAFI		VARCHAR(50);		-- Llave TarjetaPeticionSAFI
	DECLARE Llave_OperacionPeticionSAFI		VARCHAR(50);		-- Llave OperacionPeticionSAFI

	-- Declaracion de Consultas
	DECLARE Con_TarjetaPeticion				TINYINT UNSIGNED;	-- Consulta Tarjeta Peticion
	DECLARE Con_OperacionPeticion			TINYINT UNSIGNED;	-- Consulta Operacion Peticion
	DECLARE Con_ProcesosAutomaticos			TINYINT UNSIGNED;	-- Consulta Procesos Automaticos

	-- Asignacion de Catalogos de Tarjeta Operacion
	DECLARE Pro_ActivacionTarjeta			TINYINT UNSIGNED;	-- Proceso de Activacion de Tarjeta
	DECLARE Pro_CancelacionTarjeta			TINYINT UNSIGNED;	-- Proceso de Cancelacion de Tarjeta
	DECLARE Pro_BloqueoTarjeta				TINYINT UNSIGNED;	-- Proceso de Boqueo de Tarjeta
	DECLARE Pro_DesbloqueoTarjeta			TINYINT UNSIGNED;	-- Proceso de Desbloqueo de Tarjeta
	DECLARE Pro_LimitesTarjeta				TINYINT UNSIGNED;	-- Proceso de Limites Tarjetas de Tarjeta

	-- Declaracion de Catalogo de Comandos (Tabla CATCOMTARPETICIONISOTRX)
	DECLARE Comando_AjustarEstatus			TINYINT UNSIGNED;	-- Comando Ajustar Estatus
	DECLARE Comando_AjustarLimites			TINYINT UNSIGNED;	-- Comando Ajustar Limites

	-- Declaracion de Catalogos de Estatus (Tabla CATESTTARJETAISOTRX)
	DECLARE Est_Activa 						TINYINT UNSIGNED;	-- Estatus de Tarjeta Activa
	DECLARE Est_Bloqueo 					TINYINT UNSIGNED;	-- Estatus de Bloqueo
	DECLARE Est_Cancelada 					TINYINT UNSIGNED;	-- Estatus de Tarjeta Cancelada

	-- Declaracion de Catalogos Tipos Operacion (Tabla CATTIPOPERACIONISOTRX)
	DECLARE Cat_FijarSaldoDisponible		TINYINT UNSIGNED;	-- Fijar Saldo Disponible

	-- Asignacion de Instrumentos
	DECLARE Inst_CuentaAhorro				TINYINT UNSIGNED;	-- Proceso de Cuenta Ahorro
	DECLARE Inst_Inversion					TINYINT UNSIGNED;	-- Proceso de Inversion
	DECLARE Inst_Cede						TINYINT UNSIGNED;	-- Proceso de Cede
	DECLARE Inst_Credito					TINYINT UNSIGNED;	-- Proceso de Credito

	-- Asignacion de Procesos
	DECLARE Pro_DesembolsoCredito			TINYINT UNSIGNED;	-- Desembolso de credito
	DECLARE Pro_CancelaInversion			TINYINT UNSIGNED;	-- Cancelacion de inversion
	DECLARE Pro_VencAnticipadoInversion		TINYINT UNSIGNED;	-- Vencimiento Anticipada de inversion
	DECLARE Pro_CancelaCede					TINYINT UNSIGNED;	-- Cancelacion de Cede
	DECLARE Pro_VenAnticipadoCede 			TINYINT UNSIGNED;	-- Vencimiento Anticipada de Cede

	DECLARE Pro_Reinversion					TINYINT UNSIGNED;	-- Proceso de Reinversion
	DECLARE Pro_ReinversionCede				TINYINT UNSIGNED;	-- Proceso de Reinversion Cede

	-- Asginacion de Constantes
	SET Cadena_Vacia					:= '';
	SET Entero_Cero						:= 0;
	SET Decimal_Cero					:= 0.00;
	SET Fecha_Vacia						:= '1900-01-01';
	SET Est_Activada					:= 7;

	SET Con_TarjetaDebito				:= 1;
	SET Entero_Uno						:= 1;
	SET Default_TimeOut					:= 60000;
	SET TipMov_AperturaInversion		:= 60;
	SET TipMov_Reinversion 				:= 61;

	SET TipMov_IntGraInversion			:= 62;
	SET TipMov_IntExtInversion			:= 63;
	SET TipMov_ISRInversion				:= 64;
	SET TipMov_VenAnticInversion		:= 68;
	SET TipMov_AperturaCede				:= 501;

	SET TipMov_CapitalCede				:= 502;
	SET TipMov_IntGraCede 				:= 503;
	SET TipMov_IntExcCede 				:= 504;
	SET TipMov_ISRCede 					:= 505;
	SET TipMov_VenActicCede 			:= 509;

	SET Nat_Abono 						:= 'A';
	SET Nat_Cargo 						:= 'C';
	SET Tipo_Titular					:= 'T';
	SET Tipo_Adicional					:= 'A';
	SET Con_NO 							:= 'N';

	SET Con_SI							:= 'S';
	SET Con_EstInvRegistrada			:= 'A';
	SET Con_EstInvCancelada				:= 'C';
	SET Est_Registrado					:= 'R';
	SET Con_MonedaMX					:= '484';

	SET Llave_IDEmisor					:= 'IDEmisor';
	SET Llave_PrefijoEmisor				:= 'PrefijoEmisor';
	SET Llave_AutorizaTerceroTranTD		:= 'AutorizaTerceroTranTD';
	SET Llave_RutaConWSAutoriza			:= 'RutaConWSAutoriza';
	SET Llave_TimeOutConWSAutoriza		:= 'TimeOutConWSAutoriza';

	SET Llave_UsuarioConWSAutoriza		:= 'UsuarioConWSAutoriza';
	SET Llave_OperacionPeticion			:= 'OperacionPeticion';
	SET Llave_TarjetaPeticion			:= 'TarjetaPeticion';

	SET Llave_EjecucionCierreDia		:= 'EjecucionCierreDia';
	SET Llave_ProVencMasivoCedes		:= 'ProVencMasivoCedes';
	SET Llave_EjecucionCobAut 			:= 'EjecucionCobAut';
	SET Llave_EjecucionCobAutRef		:= 'EjecucionCobAutRef';
	SET Llave_NotificacionTarCierreDia	:= 'NotificacionTarCierreDia';

	SET Llave_RutaConSAFIWS				:= 'RutaConSAFIWS';
	SET Llave_UsuarioConSAFIWS			:= 'UsuarioConSAFIWS';
	SET Llave_TarjetaPeticionSAFI		:= 'TarjetaPeticionSAFI';
	SET Llave_OperacionPeticionSAFI		:= 'OperacionPeticionSAFI';

	-- Investigar como colocar el time out y desarrollar el metodo y si no se inicializa colocar un timeout por defecto (60 segundo)
	-- Asignacion de Consultas
	SET Con_TarjetaPeticion				:= 1;
	SET Con_OperacionPeticion			:= 2;
	SET Con_ProcesosAutomaticos			:= 3;

	-- Asignacion de Catalogos de Tarjeta Operacion
	SET Pro_ActivacionTarjeta			:= 1;
	SET Pro_CancelacionTarjeta			:= 2;
	SET Pro_BloqueoTarjeta				:= 3;
	SET Pro_DesbloqueoTarjeta			:= 4;
	SET Pro_LimitesTarjeta				:= 5;

	-- Asignacion de Catalogo de Comandos
	SET Comando_AjustarEstatus			:= 5;
	SET Comando_AjustarLimites			:= 6;

	-- Asignacion de Catalogos de Estatus
	SET Est_Activa 						:= 2;
	SET Est_Bloqueo 					:= 4;
	SET Est_Cancelada 					:= 6;

	-- Asignacion de Catalogos Tipos Operacion
	SET Cat_FijarSaldoDisponible		:= 100;

	-- Asignacion de Instrumentos
	SET Inst_CuentaAhorro				:= 1;
	SET Inst_Inversion					:= 2;
	SET Inst_Cede						:= 3;
	SET Inst_Credito					:= 4;

	-- Procesos de SAFI
	SET Pro_DesembolsoCredito			:= 5;
	SET Pro_CancelaInversion			:= 7;
	SET Pro_VencAnticipadoInversion		:= 8;
	SET Pro_CancelaCede					:= 10;
	SET Pro_VenAnticipadoCede 			:= 11;
	SET Pro_Reinversion					:= 22;
	SET Pro_ReinversionCede				:= 23;

	-- Seteo de Parametros
	SET Par_TarjetaDebitoID				:= IFNULL(Par_TarjetaDebitoID, Cadena_Vacia);
	SET Par_TipoInstrumento				:= IFNULL(Par_TipoInstrumento, Entero_Cero);
	SET Par_NumeroInstrumento			:= IFNULL(Par_NumeroInstrumento, Entero_Cero);

	-- Declaracion de Variables
	SET Var_IDEmisor					:= IFNULL( FNPARAMTARJETAS(Llave_IDEmisor), Entero_Cero);
	SET Var_PrefijoEmisor				:= IFNULL( FNPARAMTARJETAS(Llave_PrefijoEmisor), Cadena_Vacia);
	SET Var_AutorizaTerceroTranTD 		:= IFNULL( FNPARAMTARJETAS(Llave_AutorizaTerceroTranTD), Con_NO);
	SET Var_RutaConWSAutoriza 			:= IFNULL( FNPARAMTARJETAS(Llave_RutaConWSAutoriza), Cadena_Vacia);
	SET Var_TimeOutConWSAutoriza 		:= IFNULL( FNPARAMTARJETAS(Llave_TimeOutConWSAutoriza), Default_TimeOut);
	SET Var_UsuarioConWSAutoriza 		:= IFNULL( FNPARAMTARJETAS(Llave_UsuarioConWSAutoriza), Cadena_Vacia);
	SET Var_OperacionPeticion			:= IFNULL( FNPARAMTARJETAS(Llave_OperacionPeticion), Cadena_Vacia);
	SET Var_TarjetaPeticion				:= IFNULL( FNPARAMTARJETAS(Llave_TarjetaPeticion), Cadena_Vacia);

	SET Var_RutaConSAFIWS 				:= IFNULL( FNPARAMTARJETAS(Llave_RutaConSAFIWS), Cadena_Vacia);
	SET Var_UsuarioConSAFIWS 			:= IFNULL( FNPARAMTARJETAS(Llave_UsuarioConSAFIWS), Cadena_Vacia);
	SET Var_TarjetaPeticionSAFI			:= IFNULL( FNPARAMTARJETAS(Llave_TarjetaPeticionSAFI), Cadena_Vacia);
	SET Var_OperacionPeticionSAFI		:= IFNULL( FNPARAMTARJETAS(Llave_OperacionPeticionSAFI), Cadena_Vacia);

	IF( Par_TipoConsulta = Con_TarjetaPeticion ) THEN
		SET Var_EsTarjetaDebito 		:= Entero_Cero;
		SET Var_ComandoID 				:= Entero_Cero;
		SET Var_CuentaAhoID 			:= Entero_Cero;
		SET Var_NombreCompleto 			:= Cadena_Vacia;
		SET Var_EstatusTarjeta 			:= Entero_Cero;
		SET Var_MontoMaxDia				:= Decimal_Cero;
		SET Var_MontoMaxCompraDia		:= Decimal_Cero;
		SET Var_MontoMaxMes				:= Decimal_Cero;
		SET Var_MontoMaxComprasMensual	:= Decimal_Cero;
		SET Var_DisposicionesDia		:= Entero_Cero;

		IF( Var_AutorizaTerceroTranTD = Con_SI ) THEN

			IF EXISTS (SELECT TarjetaDebID FROM  TARJETADEBITO WHERE TarjetaDebID = Par_TarjetaDebitoID ) THEN
				SET Var_EsTarjetaDebito := Con_TarjetaDebito;
			END IF;

			SET Var_ComandoID := Comando_AjustarLimites;
			IF( Par_TipoProceso IN (Pro_ActivacionTarjeta, 	Pro_CancelacionTarjeta,
									Pro_BloqueoTarjeta,		Pro_DesbloqueoTarjeta) ) THEN
				SET Var_ComandoID := Comando_AjustarEstatus;
			END IF;

			SELECT Tar.CuentaAhoID, Cli.NombreCompleto
			INTO Var_CuentaAhoID, 	Var_NombreCompleto
			FROM TARJETADEBITO Tar
			INNER JOIN CUENTASAHO Cue ON Tar.CuentaAhoID = Cue.CuentaAhoID
			INNER JOIN CLIENTES Cli ON Cue.ClienteID = Cli.ClienteID
			WHERE Tar.TarjetaDebID = Par_TarjetaDebitoID;

			IF( Par_TipoProceso IN (Pro_ActivacionTarjeta, Pro_DesbloqueoTarjeta, Pro_LimitesTarjeta)) THEN
				SET Var_EstatusTarjeta := Est_Activa;
			END IF;

			IF( Par_TipoProceso = Pro_CancelacionTarjeta ) THEN
				SET Var_EstatusTarjeta := Est_Cancelada;
			END IF;

			IF( Par_TipoProceso = Pro_BloqueoTarjeta ) THEN
				SET Var_EstatusTarjeta := Est_Bloqueo;
			END IF;

			IF( Par_TipoProceso = Pro_LimitesTarjeta ) THEN

				SELECT	DisposiDiaNac,				ComprasDiaNac,			DisposiMesNac,
						ComprasMesNac,				NoDisposiDia
				INTO 	Var_MontoMaxDia,			Var_MontoMaxCompraDia,	Var_MontoMaxMes,
						Var_MontoMaxComprasMensual,	Var_DisposicionesDia
				FROM TARDEBLIMITES
				WHERE TarjetaDebID = Par_TarjetaDebitoID;

				SET Var_MontoMaxDia				:= IFNULL(Var_MontoMaxDia, Decimal_Cero);
				SET Var_MontoMaxCompraDia		:= IFNULL(Var_MontoMaxCompraDia, Decimal_Cero);
				SET Var_MontoMaxMes				:= IFNULL(Var_MontoMaxMes, Decimal_Cero);
				SET Var_MontoMaxComprasMensual	:= IFNULL(Var_MontoMaxComprasMensual, Decimal_Cero);
				SET Var_DisposicionesDia 		:= IFNULL(Var_DisposicionesDia, Entero_Cero);

			END IF;
		ELSE
			SET Par_TarjetaDebitoID			:= Cadena_Vacia;
		END IF;

		SELECT
			Var_EsTarjetaDebito								AS TipoTarjeta,
			Var_AutorizaTerceroTranTD 						AS AutorizaTerceroTranTD,
			CONCAT(Var_RutaConWSAutoriza,Var_TarjetaPeticion) AS RutaConWSAutoriza,
			Var_TimeOutConWSAutoriza 						AS TimeOutConWSAutoriza,
			Var_UsuarioConWSAutoriza 						AS UsuarioConWSAutoriza,

			Var_IDEmisor 									AS IDEmisor,
			CONCAT(Var_PrefijoEmisor,Aud_NumTransaccion)	AS PrefijoEmisor,
			Var_ComandoID 									AS ComandoID,
			REPLACE(DATE(NOW()), '-','')					AS FechaPeticion,
			REPLACE(TIME(NOW()), ':','')					AS HoraPeticion,

			Par_TarjetaDebitoID								AS NumeroTarjeta,
			Entero_Cero 									AS NumeroProxy,
			Var_CuentaAhoID 								AS NumeroCuenta,
			Var_NombreCompleto 								AS NombreTarjeta,
			Var_EstatusTarjeta 								AS EstatusTarjeta,

			Var_MontoMaxDia									AS LimiteDisposicionDiario,
			Var_MontoMaxCompraDia							AS LimiteComprasDiario,
			Var_MontoMaxMes									AS LimiteDisposicionMensual,
			Var_MontoMaxComprasMensual						AS LimiteComprasMensual,
			Var_DisposicionesDia							AS NumeroDisposicionesXDia,
			CONCAT(Var_RutaConSAFIWS,Var_TarjetaPeticionSAFI) AS RutaConSAFIWS,
			Var_UsuarioConSAFIWS 							AS UsuarioConSAFIWS;
	END IF;

	IF( Par_TipoConsulta = Con_OperacionPeticion ) THEN

		SET Var_EsTarjetaDebito	:= Entero_Cero;
		SET Var_TipoOperacion 	:= Entero_Cero;
		SET Var_DescripcionMov 	:= Cadena_Vacia;
		SET Var_CuentaAhoID		:= Entero_Cero;
		SET Var_SaldoDisponible	:= Decimal_Cero;
		SET Var_Notificar		:= Con_NO;

		IF( Var_AutorizaTerceroTranTD = Con_SI ) THEN

			SELECT FechaSistema
			INTO Var_FechaSistema
			FROM PARAMETROSSIS LIMIT 1;

			SET Var_Notificar := Con_SI;
			IF EXISTS (SELECT TarjetaDebID FROM  TARJETADEBITO WHERE TarjetaDebID = Par_TarjetaDebitoID ) THEN
				SET Var_EsTarjetaDebito := Con_TarjetaDebito;
			END IF;

			SELECT	CodigoOperacion,	Descripcion
			INTO	Var_TipoOperacion,	Var_DescripcionMov
			FROM RELOPERAPETICIONISOTRX
			WHERE OperacionPeticionID = Par_TipoProceso;

			-- Si el Numero de Tarjeta es Vacio busco si Existe alguna tarjeta que se pueda notificar
			IF( Par_TarjetaDebitoID = Cadena_Vacia ) THEN
				IF( Par_TipoInstrumento = Inst_CuentaAhorro ) THEN
					SELECT  TarjetaDebID
					INTO Var_TarjetaDebitoID
					FROM TARJETADEBITO
					WHERE CuentaAhoID = Par_NumeroInstrumento
					  AND Estatus = Est_Activada
					ORDER BY FIELD(Relacion ,Tipo_Titular, Tipo_Adicional)
					LIMIT 1;

					SET Var_CuentaAhoID	:= Par_NumeroInstrumento;
				END IF;

				IF( Par_TipoInstrumento = Inst_Inversion ) THEN

					SELECT 	CuentaAhoID,		Monto
					INTO 	Var_CuentaAhoID,	Var_MontoInversion
					FROM INVERSIONES
					WHERE InversionID = Par_NumeroInstrumento;

					IF( Par_TipoProceso = Pro_CancelaInversion ) THEN

						SELECT IFNULL(COUNT(InversionID), Entero_Cero)
						INTO Var_EsReinversion
						FROM INVERSIONESMOV
						WHERE InversionID = Par_NumeroInstrumento;

						SELECT IFNULL(COUNT(CuentaAhoID), Entero_Cero)
						INTO Var_Movimientos
						FROM CUENTASAHOMOV
						WHERE CuentaAhoID = Var_CuentaAhoID
						  AND Fecha = Var_FechaSistema
						  AND NatMovimiento = CASE WHEN IFNULL(Var_EsReinversion, Entero_Cero) = Entero_Cero THEN Nat_Cargo
						  						   ELSE Nat_Abono
						  					  END
						  AND ReferenciaMov = Par_NumeroInstrumento
						  AND TipoMovAhoID IN( TipMov_AperturaInversion, TipMov_Reinversion, TipMov_IntGraInversion, TipMov_IntExtInversion, TipMov_ISRInversion );

						IF( IFNULL(Var_EsReinversion, Entero_Cero) > Entero_Cero ) THEN

							SELECT SUM( CASE WHEN NatMovimiento = Nat_Abono THEN IFNULL(CantidadMov, Decimal_Cero)
											 WHEN NatMovimiento = Nat_Cargo THEN (IFNULL(CantidadMov, Decimal_Cero) * -Entero_Uno)
										END)
							INTO Var_MontoInversion
							FROM CUENTASAHOMOV
							WHERE CuentaAhoID = Var_CuentaAhoID
							  AND Fecha = Var_FechaSistema
							  AND NatMovimiento = Nat_Abono
							  AND ReferenciaMov = Par_NumeroInstrumento
							  AND TipoMovAhoID IN( TipMov_Reinversion, TipMov_IntGraInversion, TipMov_IntExtInversion, TipMov_ISRInversion );

						END IF;

						IF( Var_Movimientos = Entero_Cero) THEN
							SET Var_Notificar := Con_NO;
						END IF;

						SET Par_MontoOperacion := IFNULL(Var_MontoInversion, Decimal_Cero);
					END IF;

					IF( Par_TipoProceso IN (Pro_VencAnticipadoInversion, Pro_Reinversion) ) THEN
						SELECT SUM( CASE WHEN NatMovimiento = Nat_Abono THEN IFNULL(CantidadMov, Decimal_Cero)
										 WHEN NatMovimiento = Nat_Cargo THEN (IFNULL(CantidadMov, Decimal_Cero) * -Entero_Uno)
									END)
						INTO Var_MontoInversion
						FROM CUENTASAHOMOV
						WHERE CuentaAhoID = Var_CuentaAhoID
						  AND NumeroMov = Aud_NumTransaccion
						  AND Fecha = Var_FechaSistema
						  AND ReferenciaMov = Par_NumeroInstrumento
						  AND TipoMovAhoID IN (TipMov_Reinversion, TipMov_IntGraInversion, TipMov_IntExtInversion, TipMov_ISRInversion, TipMov_VenAnticInversion);

						IF( IFNULL(Var_MontoInversion, Decimal_Cero) = Entero_Cero) THEN
							SET Var_Notificar := Con_NO;
						END IF;

						SET Par_MontoOperacion := IFNULL(Var_MontoInversion, Decimal_Cero);
					END IF;
				END IF;

				IF( Par_TipoInstrumento = Inst_Cede ) THEN
					SELECT 	CuentaAhoID
					INTO 	Var_CuentaAhoID
					FROM CEDES
					WHERE CedeID = Par_NumeroInstrumento;

					SELECT 	CuentaAhoID,		Monto
					INTO 	Var_CuentaAhoID,	Var_MontoCede
					FROM CEDES
					WHERE CedeID = Par_NumeroInstrumento;

					IF( Par_TipoProceso = Pro_CancelaCede ) THEN

						SELECT IFNULL(COUNT(CedeID), Entero_Cero)
						INTO Var_EsReinversionCede
						FROM CEDESMOV
						WHERE CedeID = Par_NumeroInstrumento;

						SELECT IFNULL(COUNT(CuentaAhoID), Entero_Cero)
						INTO Var_Movimientos
						FROM CUENTASAHOMOV
						WHERE CuentaAhoID = Var_CuentaAhoID
						  AND Fecha = Var_FechaSistema
						  AND NatMovimiento = CASE WHEN IFNULL(Var_EsReinversionCede, Entero_Cero) = Entero_Cero THEN Nat_Cargo
						  						   ELSE Nat_Abono
						  					  END
						  AND ReferenciaMov = Par_NumeroInstrumento
						  AND TipoMovAhoID IN (TipMov_AperturaCede, TipMov_CapitalCede, TipMov_IntGraCede, TipMov_IntExcCede,TipMov_ISRCede);

						IF( IFNULL(Var_EsReinversionCede, Entero_Cero) > Entero_Cero ) THEN

							SELECT SUM( CASE WHEN NatMovimiento = Nat_Abono THEN IFNULL(CantidadMov, Decimal_Cero)
											 WHEN NatMovimiento = Nat_Cargo THEN (IFNULL(CantidadMov, Decimal_Cero) * -Entero_Uno)
										END)
							INTO Var_MontoCede
							FROM CUENTASAHOMOV
							WHERE CuentaAhoID = Var_CuentaAhoID
							  AND Fecha = Var_FechaSistema
							  AND NatMovimiento = Nat_Abono
							  AND ReferenciaMov = Par_NumeroInstrumento
							  AND TipoMovAhoID IN( TipMov_CapitalCede, TipMov_IntGraCede, TipMov_IntExcCede,TipMov_ISRCede );

						END IF;

						IF( Var_Movimientos = Entero_Cero) THEN
							SET Var_Notificar := Con_NO;
						END IF;

						SET Par_MontoOperacion := IFNULL(Var_MontoCede, Decimal_Cero);
					END IF;

					IF( Par_TipoProceso IN (Pro_VenAnticipadoCede, Pro_ReinversionCede) ) THEN
						SELECT SUM( CASE WHEN NatMovimiento = Nat_Abono THEN IFNULL(CantidadMov, Decimal_Cero)
										 WHEN NatMovimiento = Nat_Cargo THEN (IFNULL(CantidadMov, Decimal_Cero) * -Entero_Uno)
									END)
						INTO Var_MontoCede
						FROM CUENTASAHOMOV
						WHERE CuentaAhoID = Var_CuentaAhoID
						  AND NumeroMov = Aud_NumTransaccion
						  AND Fecha = Var_FechaSistema
						  AND ReferenciaMov = Par_NumeroInstrumento
						  AND TipoMovAhoID IN (TipMov_CapitalCede, TipMov_IntGraCede, TipMov_IntExcCede, TipMov_ISRCede, TipMov_VenActicCede);

						IF( IFNULL(Var_MontoCede, Decimal_Cero) = Entero_Cero) THEN
							SET Var_Notificar := Con_NO;
						END IF;

						SET Par_MontoOperacion := IFNULL(Var_MontoCede, Decimal_Cero);
					END IF;

				END IF;

				IF( Par_TipoInstrumento = Inst_Credito ) THEN
					SELECT 	CuentaID,			MontoCredito
					INTO 	Var_CuentaAhoID,	Var_MontoCredito
					FROM CREDITOS
					WHERE CreditoID = Par_NumeroInstrumento;

					IF( Par_TipoProceso = Pro_DesembolsoCredito ) THEN
						SET Par_MontoOperacion := IFNULL(Var_MontoCredito, Decimal_Cero );
					END IF;

				END IF;

				SET Var_CuentaAhoID	:= IFNULL(Var_CuentaAhoID, Entero_Cero);

				IF( Par_TipoInstrumento IN (Inst_Inversion, Inst_Cede,Inst_Credito) ) THEN

					SELECT  TarjetaDebID
					INTO Var_TarjetaDebitoID
					FROM TARJETADEBITO
					WHERE CuentaAhoID = Var_CuentaAhoID
					  AND Estatus = Est_Activada
					ORDER BY FIELD(Relacion ,Tipo_Titular, Tipo_Adicional)
					LIMIT 1;

				END IF;

				IF( IFNULL(Var_TarjetaDebitoID, Cadena_Vacia) = Cadena_Vacia) THEN
					SET Var_Notificar := Con_NO;
				ELSE
					SET Par_TarjetaDebitoID := IFNULL(Var_TarjetaDebitoID, Cadena_Vacia);
					SET Var_EsTarjetaDebito := Con_TarjetaDebito;

				END IF;
			ELSE
				-- En caso Contratio obtengo el numero de Cuenta que esta asociado a la tarjeta
				SELECT	Tar.CuentaAhoID
				INTO 	Var_CuentaAhoID
				FROM TARJETADEBITO Tar
				WHERE Tar.TarjetaDebID = Par_TarjetaDebitoID;
			END IF;

			IF( Var_TipoOperacion = Cat_FijarSaldoDisponible ) THEN
				SELECT 	IFNULL(Cue.SaldoDispon, Decimal_Cero)
				INTO 	Var_SaldoDisponible
				FROM CUENTASAHO Cue
				WHERE Cue.CuentaAhoID = Var_CuentaAhoID;
				SET Par_MontoOperacion := Var_SaldoDisponible;
			END IF;
		END IF;

		-- Si la Bandera de Notificacion es no, Se envia todo vacio
		IF( Var_Notificar = Con_NO ) THEN
			SET Var_EsTarjetaDebito	:= Entero_Cero;
			SET Var_DescripcionMov 	:= Cadena_Vacia;
			SET Var_CuentaAhoID		:= Entero_Cero;
			SET Par_TarjetaDebitoID := Cadena_Vacia;
			SET Con_MonedaMX		:= Cadena_Vacia;
			SET Par_MontoOperacion	:= Decimal_Cero;
		END IF;

		SELECT
			Var_EsTarjetaDebito								AS TipoTarjeta,
			Var_AutorizaTerceroTranTD 						AS AutorizaTerceroTranTD,
			CONCAT(Var_RutaConWSAutoriza,Var_OperacionPeticion) AS RutaConWSAutoriza,
			Var_TimeOutConWSAutoriza 						AS TimeOutConWSAutoriza,
			Var_UsuarioConWSAutoriza 						AS UsuarioConWSAutoriza,

			Var_IDEmisor 									AS IDEmisor,
			CONCAT(Var_PrefijoEmisor,Aud_NumTransaccion)	AS PrefijoEmisor,
			Var_TipoOperacion								AS TipoOperacion,
			REPLACE(DATE(NOW()), '-','')					AS FechaPeticion,
			REPLACE(TIME(NOW()), ':','')					AS HoraPeticion,

			Entero_Cero 									AS NumeroAfiliacion,
			Var_DescripcionMov 								AS NombreComercio,
			Var_CuentaAhoID 								AS NumeroCuenta,
			Par_TarjetaDebitoID								AS NumeroTarjeta,
			Con_MonedaMX									AS CodigoMoneda,

			Par_MontoOperacion								AS MontoTransaccion,
			Decimal_Cero									AS MontoAdicional,
			Decimal_Cero									AS MontoComision,
			Cadena_Vacia									AS OriCodigoAutorizacion,
			CONCAT(Var_RutaConSAFIWS,Var_OperacionPeticionSAFI) AS RutaConSAFIWS,
			Var_UsuarioConSAFIWS 							AS UsuarioConSAFIWS;

	END IF;

	IF( Par_TipoConsulta = Con_ProcesosAutomaticos ) THEN

		SET Var_AutorizaTerceroTranTD 	:= IFNULL( FNPARAMTARJETAS(Llave_AutorizaTerceroTranTD), Con_NO);
		SET Var_EjecucionCierreDia		:= IFNULL(FNPARAMGENERALES(Llave_EjecucionCierreDia), Con_NO);
		SET Var_ProVencMasivoCedes		:= IFNULL(FNPARAMGENERALES(Llave_ProVencMasivoCedes), Con_NO);
		SET Var_EjecucionCobAut 		:= IFNULL(FNPARAMGENERALES(Llave_EjecucionCobAut), Con_NO);
		SET Var_EjecucionCobAutRef		:= IFNULL(FNPARAMGENERALES(Llave_EjecucionCobAutRef), Con_NO);
		SET Var_NotificacionTarCierreDia := IFNULL( FNPARAMTARJETAS(Llave_NotificacionTarCierreDia), Con_NO);

		SET Var_NotificarOperaciones	:= Con_SI;

		IF(	Var_AutorizaTerceroTranTD = Con_NO ) THEN
			SET Var_NotificarOperaciones	:= Con_NO;
		END IF;

		SELECT 	Var_AutorizaTerceroTranTD	AS AutorizaTerceroTranTD,
				Var_EjecucionCierreDia 		AS EjecucionCierreDia,
				Var_ProVencMasivoCedes 		AS ProVencMasivoCedes,
				Var_EjecucionCobAut 		AS EjecucionCobAut,
				Var_EjecucionCobAutRef 		AS EjecucionCobAutRef,
				Var_NotificarOperaciones	AS NotificarOperaciones,
				Var_NotificacionTarCierreDia AS NotificacionTarCierreDia;
	END IF;
END TerminaStore$$