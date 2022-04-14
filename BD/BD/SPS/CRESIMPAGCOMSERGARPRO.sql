-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRESIMPAGCOMSERGARPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRESIMPAGCOMSERGARPRO`;

DELIMITER $$
CREATE PROCEDURE `CRESIMPAGCOMSERGARPRO`(
	-- Store Procedure para realizar la simulacion del pago de comisiones de servicios de Garantias
	-- Solicitud de Credito Agro y Cartera Agro
	Par_LineaCreditoID 			BIGINT(20),		-- Numero de Linea de Credito
	Par_SolicitudCreditoID		BIGINT(12),		-- Numero de Solicitud de Credito
	Par_CreditoID				BIGINT(20),		-- Numero de Credito
	Par_MinistracionID			INT(11),		-- Numero de Ministracion
	Par_TransaccionID			BIGINT(20),		-- Numero de Transaccion

	INOUT Par_MontoComisionPago	DECIMAL(14,2),	-- Monto de Comision de Pago
	INOUT Par_PolizaID			BIGINT(20),		-- Numero de poliza para registrar los detalles contables
	Par_MontoCredito			DECIMAL(14,2),	-- Monto de Desembolso
	Par_FechaVencimiento		DATE,			-- Fecha de Vencimiento

	Par_Salida					CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_PorcentajeComGarantia	DECIMAL(6,2);	-- permite un valor de 0% a 100%
	DECLARE Var_IVASucursal				DECIMAL(12,2);	-- IVA de Sucursal
	DECLARE Var_BaseCalculo 			DECIMAL(14,2);	-- Base del Calculo
	DECLARE Var_NuevaBaseCalculo		DECIMAL(14,2);	-- Nueva Base del Calculo
	DECLARE Var_Capital					DECIMAL(14,2);	-- Monto de Capital

	DECLARE Var_Desembolso				DECIMAL(14,2);	-- Monto de Desembolso
	DECLARE Var_SaldoDescontar			DECIMAL(14,2);	-- Saldo a Descontar de la Case de Calculo
	DECLARE Var_ComisionPago			DECIMAL(14,2);	-- Monto de Comision de Pago
	DECLARE Var_IVAComisionPago			DECIMAL(14,2);	-- Monto de IVA Comision de Pago
	DECLARE Var_Control					VARCHAR(50);	-- Variable con el ID del control de Pantalla

	DECLARE Var_CuentaAhoStr			VARCHAR(20);	-- Cuenta de Ahorro en Cadena
	DECLARE Var_Consecutivo				BIGINT(20);		-- Numero de Consecutivo
	DECLARE Var_CreditoID				BIGINT(20);		-- Numero de Credito
	DECLARE Var_TransaccionID			BIGINT(20);		-- Numero de Transaccion
	DECLARE Var_CuentaAhoID				BIGINT(12);		-- Cuenta de Ahorro
	DECLARE Var_DiasCredito				INT(11);		-- Dias de Credito

	DECLARE Var_RegistroID				INT(11);		-- Numero de Amortizaciones
	DECLARE Var_MaxRegistroID			INT(11);		-- Numero Maximo de Registros
	DECLARE Var_MaxNumero				INT(11);		-- Numero Maximo de Registros
	DECLARE Var_Numero					INT(11);		-- Numero de ministraciones
	DECLARE Var_Dias 					INT(11);		-- Diferencia de Dias

	DECLARE Var_LlavePrimaria			INT(11);		-- Llave Primaria
	DECLARE Var_AmortizacionID			INT(11);		-- Numero de Amortizacion
	DECLARE Var_AmortizacionAfecID		INT(11);		-- Numero de Amortizacion Afectada
	DECLARE Var_MinistracionID			INT(11);		-- Numero de Credito
	DECLARE Var_MinRegistroID			INT(11);		-- Numero Maximo de Registros
	DECLARE Var_SucursalID				INT(11);		-- Sucursal del Credito

	DECLARE Var_ClienteID				INT(11);		-- Numero de Cliente
	DECLARE Var_MonedaID				INT(11);		-- Numero de Moneda
	DECLARE Var_ProdCreID				INT(11);		-- Clave del Producto de Credito
	DECLARE Var_SubClasifID				INT(11);		-- Subclasificion
	DECLARE Var_SucCliente				INT(11);		-- Sucursal del Cliente
	DECLARE Var_AmortizacionInicial		INT(11);		-- Amortizacion Original

	DECLARE Var_PagaIVA					CHAR(1);		-- Si el cliente paga IVA
	DECLARE Var_ClasifCre				CHAR(1);		-- Clasificacion del Producto de Credito
	DECLARE Var_ForPagComGarantia		CHAR(1);		-- Forma de Pago por comision de Garantia
	DECLARE Var_FechaInicio				DATE;			-- Fecha de Inicio de la Amortizacion
	DECLARE Var_FechaFin				DATE;			-- Fecha de Final de la Amortizacion

	DECLARE Var_FechaDesembolso			DATE;			-- Fecha de Desembolso de la Ministracion
	DECLARE Var_FechaOper				DATE;			-- Fecha de operacion
	DECLARE Var_FechaApl				DATE;			-- Fecha de Aplicacion
	DECLARE Var_FechaSistema			DATE;			-- Fecha de Sistema
	DECLARE Var_Simulacion				INT(11);		-- Numero de Simulacion

	-- Declaracion de Constantes
	DECLARE Entero_Cero					INT(11);		-- Constante Entero Cero
	DECLARE Entero_Uno					INT(11);		-- Constante Entero Uno
	DECLARE Con_ContDesem				INT(11);		-- Concepto Contable de Desembolso (CONCEPTOSCONTA)
	DECLARE Tip_MovComGarDisLinCred		INT(11);		-- Tipo Movimiento Credito Comision por Garantia por Disposicion de Linea Credito Agro
	DECLARE Tip_MovIVAComGarDisLinCred	INT(11);		-- Tipo Movimiento Credito IVA Comision por Garantia por Disposicion de Linea Credito Agro

	DECLARE Con_CarCtaOrdenDeuAgro		INT(11);		-- Concepto Cuenta Ordenante Deudor Agro
	DECLARE Con_CarCtaOrdenCorAgro		INT(11);		-- Concepto Cuenta Ordenante Corte Agro
	DECLARE Con_CarComGarDisLinCred		INT(11);		-- Concepto Cartera Comision por Garantia por Disposicion de Linea Credito Agro
	DECLARE Con_CarIVAComGarDisLinCred	INT(11);		-- Concepto Cartera IVA Comision por Garantia por Disposicion de Linea Credito Agro
	DECLARE Cadena_Vacia				CHAR(1);		-- Constante Cadena Vacia

	DECLARE Salida_SI					CHAR(1);		-- Constante Salida SI
	DECLARE Salida_NO					CHAR(1);		-- Constante Salida NO
	DECLARE Con_SI						CHAR(1);		-- Constante SI
	DECLARE Con_NO						CHAR(1);		-- Constante NO
	DECLARE AltaPoliza_SI				CHAR(1);		-- Alta de Poliza Contable General: SI

	DECLARE AltaPoliza_NO				CHAR(1);		-- Alta de Poliza Contable General: NO
	DECLARE AltaPolCre_SI				CHAR(1);		-- Alta de Poliza Contable de Credito: SI
	DECLARE AltaPolCre_NO				CHAR(1);		-- Alta de Poliza Contable de Credito: NO
	DECLARE AltaMovCre_SI				CHAR(1);		-- Alta de Movimiento de Credito: SI
	DECLARE AltaMovCre_NO				CHAR(1);		-- Alta de Movimiento de Credito: NO

	DECLARE AltaMovAho_SI				CHAR(1);		-- Alta de Movimiento de Ahorro: SI
	DECLARE AltaMovAho_NO				CHAR(1);		-- Alta de Movimiento de Ahorro: NO
	DECLARE Nat_Abono					CHAR(1);		-- Naturaleza de Abono.
	DECLARE Nat_Cargo					CHAR(1);		-- Naturaleza de Cargo.
	DECLARE Con_Origen					CHAR(1);		-- Constante Origen donde se llama el SP (S= safy, W=WS)

	DECLARE Con_PagComLiqPrev			CHAR(1);		-- Fomar de Cobro Anticipada (A)
	DECLARE Con_PagComDeducida			CHAR(1);		-- Fomar de Cobro Deducida (D)
	DECLARE Con_PagComVencimiento		CHAR(1);		-- Fomar de Cobro Al Vencimiento (V)
	DECLARE EstatusInactivo				CHAR(1);		-- Estatus inactivo
	DECLARE Tip_MovAhoDesem				CHAR(3);		-- Tipo de Movimiento en Cta de Ahorro: Desembsolso (TIPOSMOVSAHO)
	DECLARE Con_DesForCobCom			VARCHAR(100);	-- Constante Descripcion Forma de Cobro por Comision

	DECLARE Con_DesIvaForCarCom			VARCHAR(100);	-- Constante Descripcion IVA Forma de Cobro por Comision
	DECLARE Con_DesIvaForCobCom			VARCHAR(100);	-- Constante Descripcion IVA Forma de Cobro por Comision
	DECLARE Con_DesForCarCom			VARCHAR(100);	-- Constante Descripcion Forma de Cobro por Comision
	DECLARE Fecha_Vacia 				DATE;			-- Fecha Vacia

	-- Asignacion de Constantes
	SET	Entero_Cero						:= 0;
	SET Entero_Uno						:= 1;
	SET Con_ContDesem					:= 50;
	SET Tip_MovComGarDisLinCred			:= 59;
	SET Tip_MovIVAComGarDisLinCred		:= 60;

	SET Con_CarCtaOrdenDeuAgro			:= 138;
	SET Con_CarCtaOrdenCorAgro			:= 139;
	SET Con_CarComGarDisLinCred 		:= 143;
	SET Con_CarIVAComGarDisLinCred		:= 145;
	SET	Cadena_Vacia					:= '';

	SET	Salida_SI						:= 'S';
	SET Salida_NO						:= 'N';
	SET Con_SI							:= 'S';
	SET Con_NO							:= 'N';
	SET AltaPoliza_SI					:= 'S';

	SET AltaPoliza_NO					:= 'N';
	SET AltaPolCre_SI					:= 'S';
	SET AltaPolCre_NO					:= 'N';
	SET AltaMovCre_SI					:= 'S';
	SET AltaMovCre_NO					:= 'N';

	SET AltaMovAho_SI					:= 'S';
	SET AltaMovAho_NO					:= 'N';
	SET Nat_Abono						:= 'A';
	SET Nat_Cargo						:= 'C';
	SET Con_Origen						:= 'E';

	SET Con_PagComLiqPrev				:= 'A';
	SET Con_PagComDeducida				:= 'D';
	SET Con_PagComVencimiento			:= 'V';
	SET EstatusInactivo					:= 'I';
	SET Tip_MovAhoDesem					:= '100';
	SET Con_DesForCarCom				:= 'CARGO DE COMISION POR LINEA DE CREDITO';

	SET Con_DesIvaForCarCom				:= 'CARGO DE IVA COMISION POR LINEA DE CREDITO';
	SET Con_DesForCobCom				:= 'COBRO DE COMISION POR LINEA DE CREDITO';
	SET Con_DesIvaForCobCom				:= 'COBRO DE IVA COMISION POR LINEA DE CREDITO';
	SET Fecha_Vacia						:= '1900-01-01';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-CRESIMPAGCOMSERGARPRO');
			SET Var_Control	:= 'SQLEXCEPTION';
			SET Par_MontoComisionPago := Entero_Cero;
		END;

		SET Par_MontoComisionPago := Entero_Cero;

		SELECT DiasCredito,		FechaSistema
		INTO Var_DiasCredito,	Var_FechaApl
		FROM PARAMETROSSIS
		LIMIT 1;

		SET Par_MinistracionID := IFNULL(Par_MinistracionID, Entero_Cero);

		IF( Par_MinistracionID = Entero_Cero ) THEN

			DELETE FROM TMPBASESERCOMGARANTIA WHERE TransaccionID = Aud_NumTransaccion;
			-- Se obtiene el Porcentaje de Comision por Servicio de Garantia de la Linea de Credito en caso de que la solicitud y el credito no existan
			IF( Par_LineaCreditoID > Entero_Cero ) THEN
				SELECT 	PorcentajeComGarantia
				INTO 	Var_PorcentajeComGarantia
				FROM LINEASCREDITO
				WHERE LineaCreditoID = Par_LineaCreditoID;
			END IF;

			-- Se obtiene el Porcentaje de Comision por Servicio de Garantia de la Solicitud de Credito
			IF( Par_SolicitudCreditoID > Entero_Cero AND Par_CreditoID = Entero_Cero ) THEN
				SELECT 	PorcentajeComGarantia
				INTO 	Var_PorcentajeComGarantia
				FROM SOLICITUDCREDITO
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID;
			END IF;

			-- Se obtiene el Porcentaje de Comision por Servicio de Garantia del Credito
			IF( Par_SolicitudCreditoID > Entero_Cero AND Par_CreditoID > Entero_Cero ) THEN
				SELECT PorcentajeComGarantia
				INTO 	Var_PorcentajeComGarantia
				FROM CREDITOS
				WHERE CreditoID = Par_CreditoID;
			END IF;

			SELECT COUNT(TransaccionID)
			INTO Var_TransaccionID
			FROM MINISTRACREDAGRO
			WHERE TransaccionID = Par_TransaccionID
			  AND IFNULL(SolicitudCreditoID, Entero_Cero) = Par_SolicitudCreditoID
			  AND IFNULL(CreditoID, Entero_Cero) = Par_CreditoID;

			SELECT COUNT(Tmp_Consecutivo)
			INTO Var_Simulacion
			FROM TMPPAGAMORSIM
			WHERE NumTransaccion = Par_TransaccionID;

			IF( Var_Simulacion = Entero_Cero AND Par_TransaccionID = Entero_Cero ) THEN
				DELETE FROM TMPPAGAMORSIM WHERE NumTransaccion = Aud_NumTransaccion;

				INSERT INTO TMPPAGAMORSIM(
					Tmp_Consecutivo,		Tmp_FecIni,			Tmp_FecFin,				Tmp_FecVig,				Tmp_Dias,
					NumTransaccion,			Tmp_Capital)
				VALUES (
					Entero_Uno,				Var_FechaSistema,	Par_FechaVencimiento,	Par_FechaVencimiento,	Entero_Cero,
					Aud_NumTransaccion,		Par_MontoCredito);
			END IF;

			SET Aud_FechaActual = NOW();
			SET Var_TransaccionID := IFNULL(Var_TransaccionID, Entero_Cero);
			IF( Var_TransaccionID = Entero_Cero ) THEN

				IF(Par_TransaccionID = Entero_Cero) THEN
					SET Par_TransaccionID := Aud_NumTransaccion;
				END IF;
				DELETE FROM MINISTRACREDAGRO
				WHERE TransaccionID = Par_TransaccionID
				  AND IFNULL(SolicitudCreditoID, Entero_Cero) = Par_SolicitudCreditoID
				  AND IFNULL(CreditoID, Entero_Cero) = Par_CreditoID;
				SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
				INSERT INTO MINISTRACREDAGRO(
					TransaccionID, 				Numero,
					SolicitudCreditoID,			CreditoID,				ClienteID,				ProspectoID,				FechaPagoMinis,
					Capital,					FechaMinistracion, 		Estatus, 				UsuarioAutoriza, 			FechaAutoriza,
					ComentariosAutoriza,		ForPagComGarantia,
					EmpresaID,					Usuario,				FechaActual,			DireccionIP,				ProgramaID,
					Sucursal,					NumTransaccion)
				VALUES(
					Par_TransaccionID,			Entero_Uno,
					NULL,						NULL,					Entero_Cero,			Entero_Cero,				Var_FechaSistema,
					Par_MontoCredito,			Fecha_Vacia,			EstatusInactivo,		Aud_Usuario,				Fecha_Vacia,
					Cadena_Vacia,				Cadena_Vacia,
					Aud_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,				Aud_NumTransaccion);

					SET Par_SolicitudCreditoID := Entero_Cero;
					SET Par_CreditoID := Entero_Cero;
			END IF;

			-- Se obtiene el numero maximo de Ministraciones
			SELECT MAX(Numero)
			INTO Var_MaxNumero
			FROM MINISTRACREDAGRO
			WHERE TransaccionID = Par_TransaccionID
			  AND IFNULL(SolicitudCreditoID, Entero_Cero) = Par_SolicitudCreditoID
			  AND IFNULL(CreditoID, Entero_Cero) = Par_CreditoID;

			-- Se obtiene el Numero Maximo de Amortizaciones
			SELECT MAX(Tmp_Consecutivo)
			INTO Var_MaxRegistroID
			FROM TMPPAGAMORSIM
			WHERE NumTransaccion = Par_TransaccionID;

			SET Var_Numero := Entero_Uno;

			-- Recorro las ministraciones para calcular el porcentaje de comision por de acuerdo a la diferencia de dias entre las amortizaciones
			-- contra la fechas de desembolso de las ministraciones
			WHILE ( Var_Numero <= Var_MaxNumero) DO

				SET Var_RegistroID := Entero_Uno;

				-- Se obtiene la Base de Calculo (monto de la Ministracion) y la Fecha de Pago de la Ministracion(Fecha Desembolso)
				SELECT Capital,			FechaPagoMinis
				INTO Var_BaseCalculo,	Var_FechaDesembolso
				FROM MINISTRACREDAGRO
				WHERE TransaccionID = Par_TransaccionID
				  AND Numero = Var_Numero
				  AND IFNULL(SolicitudCreditoID, Entero_Cero) = Par_SolicitudCreditoID
				  AND IFNULL(CreditoID, Entero_Cero) = Par_CreditoID;

				SET Var_NuevaBaseCalculo := Var_BaseCalculo;
				WHILE (Var_RegistroID <= Var_MaxRegistroID) DO

					-- Se obtiene el Monto de Desembolso de la Ministracion
					SELECT 	Capital
					INTO 	Var_Desembolso
					FROM MINISTRACREDAGRO
					WHERE TransaccionID = Par_TransaccionID
					  AND Numero = Var_RegistroID
					  AND IFNULL(SolicitudCreditoID, Entero_Cero) = Par_SolicitudCreditoID
					  AND IFNULL(CreditoID, Entero_Cero) = Par_CreditoID;

					-- Se obtiene el monto de la Amortizacion y sus fecha de Inicio y Termino
					SELECT	Tmp_Capital,	Tmp_FecIni,			Tmp_FecFin
					INTO 	Var_Capital,	Var_FechaInicio,	Var_FechaFin
					FROM TMPPAGAMORSIM
					WHERE Tmp_Consecutivo = Var_RegistroID
					  AND NumTransaccion = Par_TransaccionID;

					-- Se calcula el Monto Base para el Calculo de la Comision
					IF( Var_BaseCalculo > Var_Capital ) THEN
						SET Var_SaldoDescontar := CASE WHEN Var_Capital < Var_Desembolso
															THEN Var_Capital
															ELSE Var_Capital - Var_Desembolso
												  END;
					ELSE
						IF( Var_Desembolso > Var_Capital OR Var_Desembolso = Var_NuevaBaseCalculo) THEN
							SET Var_SaldoDescontar := Entero_Cero;
						ELSE
							SET Var_SaldoDescontar := Var_NuevaBaseCalculo;
						END IF;
					END IF;

					SET Var_BaseCalculo := Var_BaseCalculo - Var_SaldoDescontar;

					-- Se verifica si es la Primera Amortizacion para asignar como fecha de Inicio la Fecha de Desembolso de
					-- de la Ministracion
					IF( Var_RegistroID = Entero_Uno ) THEN
						SET Var_FechaInicio := Var_FechaDesembolso;
					END IF;

					-- Se verifica si la Fecha de Inicio es Menor al a Fecha de Desembolso, Se asigna como Fecha de Inicio la fecha de
					-- de Desembolso de la Ministracion
					IF( Var_FechaInicio < Var_FechaDesembolso ) THEN
						SET Var_FechaInicio := Var_FechaDesembolso;
					END IF;

					-- Se obtiene la Diferencia de Dias
					SET Var_Dias := DATEDIFF(Var_FechaFin, Var_FechaInicio);

					-- Si la Diferencia de los Dias es Cero, las variables de calculo seran cero
					IF( Var_Dias <= Entero_Cero ) THEN
						SET Var_Dias			 := Entero_Cero;
						SET Var_ComisionPago	 := Entero_Cero;
						SET Var_NuevaBaseCalculo := Entero_Cero;
					END IF;

					-- Se asgina la Amortizacion en donde se realizara en el cobro
					SET Var_AmortizacionID := Var_RegistroID;

					-- Se obtiene el Monto de Pago por Comision de Administración por Ministracion y por Amortizacion
					SET Var_ComisionPago  := ROUND((((Var_NuevaBaseCalculo/100)*Var_PorcentajeComGarantia/Var_DiasCredito)*Var_Dias),2);

					IF( Var_NuevaBaseCalculo > Entero_Cero ) THEN
						-- Se obtiene el ID de la tabla
						SET Var_LlavePrimaria := (SELECT COUNT(RegistroID) FROM TMPBASESERCOMGARANTIA WHERE TransaccionID = Aud_NumTransaccion) +1;

						-- Se inserta el registro
						INSERT INTO TMPBASESERCOMGARANTIA (
							RegistroID,			TransaccionID,			FechaInicio,				FechaFin,			Dias,
							Capital,			BaseCalculo,			PorcentajeComision,			ComisionPago,		AmortizacionID,
							EmpresaID,			Usuario,				FechaActual,				DireccionIP,		ProgramaID,
							Sucursal,			NumTransaccion)
						VALUES (
							Var_LlavePrimaria,	Aud_NumTransaccion,		Var_FechaInicio,			Var_FechaFin,		Var_Dias,
							Var_Capital,		Var_NuevaBaseCalculo,	Var_PorcentajeComGarantia,	Var_ComisionPago,	Var_AmortizacionID,
							Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,
							Aud_Sucursal,		Aud_NumTransaccion);
					END IF;

					-- Se ajusta el Iterador y el Nuevo Calculo de Base
					SET Var_RegistroID 	:= Var_RegistroID + Entero_Uno;
					SET Var_NuevaBaseCalculo := Var_BaseCalculo;

				END WHILE;

				SET Var_Numero := Var_Numero + Entero_Uno;
			END WHILE;

			SELECT	SUM(IFNULL( ComisionPago, Entero_Cero))
			INTO	Par_MontoComisionPago
			FROM TMPBASESERCOMGARANTIA
			WHERE TransaccionID = Aud_NumTransaccion;

			DELETE FROM TMPBASESERCOMGARANTIA WHERE TransaccionID = Aud_NumTransaccion;
			IF( Var_TransaccionID = Entero_Cero ) THEN
				DELETE FROM MINISTRACREDAGRO
				WHERE TransaccionID = Par_TransaccionID
				  AND IFNULL(SolicitudCreditoID, Entero_Cero) = Par_SolicitudCreditoID
				  AND IFNULL(CreditoID, Entero_Cero) = Par_CreditoID;
				DELETE FROM TMPPAGAMORSIM WHERE NumTransaccion = Aud_NumTransaccion;

			END IF;

			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen	:= CONCAT('Simulacion Realizada Correctamente.');
			SET Var_Control	:= Cadena_Vacia ;
			SET Par_MontoComisionPago := IFNULL(Par_MontoComisionPago, Entero_Cero);
			LEAVE ManejoErrores;
		END IF;

		IF( Par_MinistracionID > Entero_Cero ) THEN

			-- Validaciones del Credito y de Ministracion de Credito
			IF( Par_CreditoID = Entero_Cero) THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= 'El Numero de Credito esta Vacio.';
				SET Var_Control	:= 'creditoID';
                LEAVE ManejoErrores;
			END IF;

			-- Se obtiene el Porcentaje de Comision por Servicio de Garantia del Credito
			SELECT	Cre.CreditoID,	Cre.PorcentajeComGarantia,	Cre.ClienteID,		Cre.CuentaID,		Cre.MonedaID,
					Cre.SucursalID,	Cre.ProductoCreditoID,		Des.Clasificacion,	Des.SubClasifID,	Cli.SucursalOrigen
			INTO	Var_CreditoID,	Var_PorcentajeComGarantia,	Var_ClienteID,		Var_CuentaAhoID, 	Var_MonedaID,
					Var_SucursalID,	Var_ProdCreID,				Var_ClasifCre,		Var_SubClasifID,	Var_SucCliente
			FROM CREDITOS Cre
			INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
			INNER JOIN DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
			WHERE Cre.CreditoID = Par_CreditoID;

			SET Var_CreditoID				:= IFNULL(Var_CreditoID, Entero_Cero);
			SET Var_PorcentajeComGarantia	:= IFNULL(Var_PorcentajeComGarantia, Entero_Cero);
			SET Var_CuentaAhoStr 			:= CONVERT(Var_CuentaAhoID, CHAR);

			IF( Var_CreditoID = Entero_Cero) THEN
				SET Par_NumErr	:= 002;
				SET Par_ErrMen	:= CONCAT('El Numero de Credito: ',Par_CreditoID, 'no Existe.');
				SET Var_Control	:= 'creditoID';
                LEAVE ManejoErrores;
			END IF;

			SELECT PagaIVA
			INTO Var_PagaIVA
			FROM CLIENTES
			WHERE ClienteID = Var_ClienteID;

			SET Var_PagaIVA	:= IFNULL(Var_PagaIVA, Con_NO);
			IF( Var_PagaIVA = Con_SI ) THEN
				SELECT IVA
				INTO Var_IVASucursal
				FROM SUCURSALES
				WHERE SucursalID = Var_SucursalID;

				SET Var_IVASucursal := IFNULL(Var_IVASucursal, Entero_Cero);
			END IF;

			-- Se obtiene el Monto de Desembolso de la Ministracion
			-- Se obtiene la Base de Calculo (monto de la Ministracion) y la Fecha de Pago de la Ministracion(Fecha Desembolso)
			SET Var_FechaOper := (SELECT FechaSucursal FROM SUCURSALES WHERE SucursalID = Aud_Sucursal);

			SELECT	Numero,				Capital,			FechaPagoMinis,			Capital,
					ForPagComGarantia
			INTO	Var_MinistracionID,	Var_BaseCalculo,	Var_FechaDesembolso,	Var_Desembolso,
					Var_ForPagComGarantia
			FROM MINISTRACREDAGRO
			WHERE Numero = Par_MinistracionID
			  AND SolicitudCreditoID = Par_SolicitudCreditoID
			  AND CreditoID = Par_CreditoID;

			SET Var_ForPagComGarantia := IFNULL(Var_ForPagComGarantia, Cadena_Vacia);
			IF( Var_MinistracionID = Entero_Cero) THEN
				SET Par_NumErr	:= 003;
				SET Par_ErrMen	:= CONCAT('El Numero de Ministracion: ',Par_MinistracionID, 'no Existe.');
				SET Var_Control	:= 'ministracionID';
                LEAVE ManejoErrores;
			END IF;

			-- Si la forma de cobro es vacia o cobrada anticipadamente no se realiza el cargo a la amortizacion
			IF( Par_MinistracionID > Entero_Cero AND Var_ForPagComGarantia IN (Cadena_Vacia, Con_PagComLiqPrev)) THEN
				SET Par_NumErr	:= Entero_Cero;
				SET Par_ErrMen	:= CONCAT('Simulacion Realizada Correctamente.');
				SET Var_Control	:= 'creditoID';
				SET Par_MontoComisionPago := IFNULL(Par_MontoComisionPago, Entero_Cero);
                LEAVE ManejoErrores;
			END IF;

			SELECT	MIN(AmortizacionID),	MAX(AmortizacionID)
			INTO	Var_MinRegistroID,		Var_MaxRegistroID
			FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID
			  AND Estatus NOT IN ('P','I');

			SET Var_AmortizacionInicial = Var_MinRegistroID;
			SET Var_RegistroID := Var_MinRegistroID;
			SET Var_NuevaBaseCalculo := Var_BaseCalculo;

			WHILE (Var_RegistroID <= Var_MaxRegistroID) DO
			SECCIONCALCULOS:BEGIN 

				-- Se obtiene el monto de la Amortizacion y sus fecha de Inicio y Termino
				SELECT	Capital,		FechaInicio,		FechaVencim
				INTO 	Var_Capital,	Var_FechaInicio,	Var_FechaFin
				FROM AMORTICREDITO
				WHERE AmortizacionID = Var_RegistroID
				  AND CreditoID = Par_CreditoID;

				-- Se calcula el Monto Base para el Calculo de la Comision
				IF( Var_BaseCalculo > Var_Capital ) THEN
					SET Var_SaldoDescontar := CASE WHEN Var_Capital < Var_Desembolso
														THEN Var_Capital
														ELSE Var_Capital - Var_Desembolso
											  END;
				ELSE
					IF( Var_Desembolso > Var_Capital OR Var_Desembolso = Var_NuevaBaseCalculo) THEN
						SET Var_SaldoDescontar := Entero_Cero;
					ELSE
						SET Var_SaldoDescontar := Var_NuevaBaseCalculo;
					END IF;
				END IF;

				SET Var_BaseCalculo := Var_BaseCalculo - Var_SaldoDescontar;

				-- Se verifica si es la Primera Amortizacion para asignar como fecha de Inicio la Fecha de Desembolso de
				-- de la Ministracion
				IF( Var_RegistroID = Entero_Uno ) THEN
					SET Var_FechaInicio := Var_FechaDesembolso;
				END IF;

				-- Se verifica si la Fecha de Inicio es Menor al a Fecha de Desembolso, Se asigna como Fecha de Inicio la fecha de
				-- de Desembolso de la Ministracion
				IF( Var_FechaInicio < Var_FechaDesembolso ) THEN
					SET Var_FechaInicio := Var_FechaDesembolso;
				END IF;

				-- Se obtiene la Diferencia de Dias
				SET Var_Dias := DATEDIFF(Var_FechaFin, Var_FechaInicio);

				-- Si la Diferencia de los Dias es Cero, las variables de calculo seran cero
				IF( Var_Dias <= Entero_Cero ) THEN
					SET Var_Dias			 := Entero_Cero;
					SET Var_ComisionPago	 := Entero_Cero;
					SET Var_NuevaBaseCalculo := Entero_Cero;
                    LEAVE SECCIONCALCULOS;
				END IF;

				-- Se asgina la Amortizacion en donde se realizara en el cobro
				SET Var_AmortizacionID := Var_RegistroID;

				-- Se obtiene el Monto de Pago por Comision de Administración por Ministracion y por Amortizacion
				SET Var_ComisionPago  := ROUND((((Var_NuevaBaseCalculo/100)*Var_PorcentajeComGarantia/Var_DiasCredito)*Var_Dias),2);

				SET Var_IVAComisionPago := Entero_Cero;
				IF( Var_PagaIVA = Con_SI ) THEN
					SET Var_IVAComisionPago := ROUND((Var_ComisionPago * Var_IVASucursal), 2);
					SET Var_IVAComisionPago := IFNULL(Var_IVAComisionPago,Entero_Cero);
				END IF;

				-- Si es la primera ministracion y es la amortización se realiza el cobro de la comision
				-- al desembolso del credito

				IF( Par_MinistracionID = Entero_Uno AND Var_AmortizacionID = Entero_Uno AND Var_ComisionPago > Entero_Cero ) THEN
					CALL CONTACREDITOPRO (
						Par_CreditoID,		Entero_Cero,		Var_CuentaAhoID,	Var_ClienteID,		Var_FechaOper,
						Var_FechaApl,		Var_ComisionPago,	Var_MonedaID,		Var_ProdCreID,		Var_ClasifCre,
						Var_SubClasifID,	Var_SucCliente,		Con_DesForCobCom,	Var_CuentaAhoStr,	AltaPoliza_NO,
						Con_ContDesem,		Par_PolizaID,		AltaPolCre_SI,		AltaMovCre_NO,		Con_CarComGarDisLinCred,
						Entero_Cero,		Nat_Abono,			AltaMovAho_SI,		Tip_MovAhoDesem,	Nat_Cargo,
						Con_Origen, 		Par_NumErr,			Par_ErrMen,			Var_Consecutivo,
						Aud_EmpresaID,		Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

					IF( Var_PagaIVA = Con_SI AND Var_IVAComisionPago >  Entero_Cero) THEN

						CALL CONTACREDITOPRO (
							Par_CreditoID,		Entero_Cero,			Var_CuentaAhoID,		Var_ClienteID,		Var_FechaOper,
							Var_FechaApl,		Var_IVAComisionPago,	Var_MonedaID,			Var_ProdCreID,		Var_ClasifCre,
							Var_SubClasifID,	Var_SucCliente,			Con_DesIvaForCobCom,	Var_CuentaAhoStr,	AltaPoliza_NO,
							Con_ContDesem,		Par_PolizaID,			AltaPolCre_SI,			AltaMovCre_NO,		Con_CarIVAComGarDisLinCred,
							Entero_Cero,		Nat_Abono,				AltaMovAho_SI,			Tip_MovAhoDesem,	Nat_Cargo,
							Con_Origen,			Par_NumErr,				Par_ErrMen,				Var_Consecutivo,
							Aud_EmpresaID,		Cadena_Vacia,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

						IF (Par_NumErr <> Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;
					END IF;

					-- Actualizo el Monto Pagado en la solicitud y en el Credito
					UPDATE CREDITOS SET
						MontoPagComGarantia = MontoPagComGarantia + Var_ComisionPago,
						MontoCobComGarantia = MontoCobComGarantia + Var_ComisionPago
					WHERE CreditoID = Par_CreditoID;
				ELSE

					SET Var_AmortizacionAfecID := Var_AmortizacionID;
					-- Si la amortizacion es diferente de la primera se resta una amortizacion para realizar el
					-- cargo por servicio de garantia previo
					IF( Var_AmortizacionID > Var_AmortizacionInicial ) THEN
						SET Var_AmortizacionAfecID := Var_RegistroID - Entero_Uno;
					END IF;

					IF( Var_ForPagComGarantia = Con_PagComDeducida AND Var_AmortizacionID = Var_AmortizacionInicial AND Var_ComisionPago > Entero_Cero   ) THEN

						-- Al ser Deduccion se cobra la comision de la garantia a la primer amortizacion Vigente
						-- el cual se cobra de la Ministracion que se desembolsa
						CALL CONTACREDITOPRO (
							Par_CreditoID,		Entero_Cero,		Var_CuentaAhoID,	Var_ClienteID,		Var_FechaOper,
							Var_FechaApl,		Var_ComisionPago,	Var_MonedaID,		Var_ProdCreID,		Var_ClasifCre,
							Var_SubClasifID,	Var_SucCliente,		Con_DesForCobCom,	Var_CuentaAhoStr,	AltaPoliza_NO,
							Con_ContDesem,		Par_PolizaID,		AltaPolCre_SI,		AltaMovCre_NO,		Con_CarComGarDisLinCred,
							Entero_Cero,		Nat_Abono,			AltaMovAho_SI,		Tip_MovAhoDesem,	Nat_Cargo,
							Con_Origen, 		Par_NumErr,			Par_ErrMen,			Var_Consecutivo,
							Aud_EmpresaID,		Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

						IF (Par_NumErr <> Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;

						IF( Var_PagaIVA = Con_SI AND Var_IVAComisionPago > Entero_Cero ) THEN

							CALL CONTACREDITOPRO (
								Par_CreditoID,		Entero_Cero,			Var_CuentaAhoID,		Var_ClienteID,		Var_FechaOper,
								Var_FechaApl,		Var_IVAComisionPago,	Var_MonedaID,			Var_ProdCreID,		Var_ClasifCre,
								Var_SubClasifID,	Var_SucCliente,			Con_DesIvaForCobCom,	Var_CuentaAhoStr,	AltaPoliza_NO,
								Con_ContDesem,		Par_PolizaID,			AltaPolCre_SI,			AltaMovCre_NO,		Con_CarIVAComGarDisLinCred,
								Entero_Cero,		Nat_Abono,				AltaMovAho_SI,			Tip_MovAhoDesem,	Nat_Cargo,
								Con_Origen,			Par_NumErr,				Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,		Cadena_Vacia,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

							IF (Par_NumErr <> Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;
						END IF;

						-- Actualizo el Monto Pagado en la solicitud y en el Credito
						UPDATE CREDITOS SET
							MontoPagComGarantia = MontoPagComGarantia + Var_ComisionPago,
							MontoCobComGarantia = MontoCobComGarantia + Var_ComisionPago
						WHERE CreditoID = Par_CreditoID;

					ELSE

						-- Cargo de Movimiento Operativo de la comision
                        IF Var_ComisionPago > Entero_Cero THEN
							CALL CONTACREDITOPRO (
								Par_CreditoID,				Var_AmortizacionAfecID,	Var_CuentaAhoID,	Var_ClienteID,		Var_FechaOper,
								Var_FechaApl,				Var_ComisionPago,		Var_MonedaID,		Var_ProdCreID,		Var_ClasifCre,
								Var_SubClasifID,			Var_SucCliente,			Con_DesForCarCom,	Par_CreditoID,		AltaPoliza_NO,
								Con_ContDesem,				Par_PolizaID,			AltaPolCre_SI,		AltaMovCre_SI,		Con_CarComGarDisLinCred,
								Tip_MovComGarDisLinCred,	Nat_Cargo,				AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
								Con_Origen, 				Par_NumErr,				Par_ErrMen,			Var_Consecutivo,
								Aud_EmpresaID,				Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);

							IF (Par_NumErr <> Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;
							-- Abono de Movimiento Operativo de la comision
							CALL CONTACREDITOPRO (
								Par_CreditoID,		Var_AmortizacionAfecID,	Var_CuentaAhoID,	Var_ClienteID,		Var_FechaOper,
								Var_FechaApl,		Var_ComisionPago,		Var_MonedaID,		Var_ProdCreID,		Var_ClasifCre,
								Var_SubClasifID,	Var_SucCliente,			Con_DesForCarCom,	Par_CreditoID,		AltaPoliza_NO,
								Con_ContDesem,		Par_PolizaID,			AltaPolCre_SI,		AltaMovCre_NO,		Con_CarCtaOrdenDeuAgro,
								Entero_Cero,		Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
								Con_Origen, 		Par_NumErr,				Par_ErrMen,			Var_Consecutivo,
								Aud_EmpresaID,		Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

							IF (Par_NumErr <> Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;
						END IF;
                        
						IF( Var_PagaIVA = Con_SI ) THEN

							UPDATE AMORTICREDITO SET
								SaldoIVAComSerGar	= IFNULL(SaldoIVAComSerGar, Entero_Cero) + Var_IVAComisionPago,

								EmpresaID			= Aud_EmpresaID,
								Usuario				= Aud_Usuario,
								FechaActual			= Aud_FechaActual,
								DireccionIP			= Aud_DireccionIP,
								ProgramaID			= Aud_ProgramaID,
								Sucursal			= Aud_Sucursal,
								NumTransaccion		= Aud_NumTransaccion
							WHERE AmortizacionID = Var_AmortizacionAfecID
							  AND CreditoID = Par_CreditoID;

							UPDATE CREDITOS SET
								SaldoIVAComSerGar	= IFNULL(SaldoIVAComSerGar, Entero_Cero) + Var_IVAComisionPago,

								EmpresaID			= Aud_EmpresaID,
								Usuario				= Aud_Usuario,
								FechaActual			= Aud_FechaActual,
								DireccionIP			= Aud_DireccionIP,
								ProgramaID			= Aud_ProgramaID,
								Sucursal			= Aud_Sucursal,
								NumTransaccion		= Aud_NumTransaccion
							WHERE CreditoID = Par_CreditoID;
						END IF;
					END IF;
				END IF;

				IF( Var_NuevaBaseCalculo > Entero_Cero ) THEN
					-- Se obtiene el ID de la tabla
					SET Var_LlavePrimaria := (SELECT COUNT(RegistroID) FROM BASESERCOMGARANTIA WHERE CreditoID = Par_CreditoID) +1;
					SET Aud_FechaActual := NOW();

					-- Se inserta el registro
					INSERT INTO BASESERCOMGARANTIA (
						RegistroID,			TransaccionID,		AmortizacionID,		CreditoID,				FechaInicio,
						FechaFin,			Dias,				Capital,			BaseCalculo,			PorcentajeComision,
						ComisionPago,		MinistracionID,
						EmpresaID,			Usuario,			FechaActual,		DireccionIP,			ProgramaID,
						Sucursal,			NumTransaccion)
					VALUES (
						Var_LlavePrimaria,	Aud_NumTransaccion,	Var_AmortizacionID,	Par_CreditoID,			Var_FechaInicio,
						Var_FechaFin,		Var_Dias,			Var_Capital,		Var_NuevaBaseCalculo,	Var_PorcentajeComGarantia,
						Var_ComisionPago,	Par_MinistracionID,
						Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
						Aud_Sucursal,		Aud_NumTransaccion);
				END IF;
			
            END SECCIONCALCULOS;
				-- Se ajusta el Iterador y el Nuevo Calculo de Base
				SET Var_RegistroID 	:= Var_RegistroID + Entero_Uno;
				SET Var_NuevaBaseCalculo := Var_BaseCalculo;

			END WHILE;

			SELECT	SUM(IFNULL( ComisionPago, Entero_Cero))
			INTO	Par_MontoComisionPago
			FROM BASESERCOMGARANTIA
			WHERE TransaccionID = Aud_NumTransaccion
			  AND CreditoID = Par_CreditoID;

			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen	:= CONCAT('Simulacion Realizada Correctamente.');
			SET Var_Control	:= 'creditoID';
			SET Par_MontoComisionPago := IFNULL(Par_MontoComisionPago, Entero_Cero);
			LEAVE ManejoErrores;
		END IF;

	END ManejoErrores;
	-- END del Handler de Errores

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr			  AS NumErr,
				Par_ErrMen			  AS ErrMen,
				Var_Control			  AS control,
				Par_MontoComisionPago AS consecutivo;
	END IF;
END TerminaStore$$