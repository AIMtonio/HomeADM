-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOXREFERENCIAACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOXREFERENCIAACT`;DELIMITER $$

CREATE PROCEDURE `PAGOXREFERENCIAACT`(
/*SP que actualiza el Pago x Referencia y realiza el bloqueo y desbloqueo del saldo de la cuenta*/
	Par_Transaccion					BIGINT(20),
	Par_CreditoID					BIGINT(12),
	Par_CuentaAhoID					BIGINT(12),
	Par_ClienteID					INT(11),
	Par_Referencia					VARCHAR(20),

	Par_MontoPago					DECIMAL(18,2),				# Monto a Pagar
	Par_SaldoCta					DECIMAL(18,2),
	Par_Fecha						DATE,
	Par_TipoAct						TINYINT,					# Número de Actualización
	Par_Proceso						CHAR,						# C. Pantalla Cargo a Cuenta A: Masivo
	Par_Salida						CHAR(1),					# Indica el tipo de salida S.- SI N.- No

	INOUT Par_NumErr				INT,						# Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),				# Mensaje de Error
	/*Parametros de Auditoria*/
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,

	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(12)
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(50);				-- ID del Control en pantalla
	DECLARE Var_AdjuntoID			INT(11);					-- ID Max de PLDADJUNTOS
	DECLARE Var_RutaArchivosPLD		VARCHAR(200);				-- Ruta del Archivo PLD
	DECLARE Var_Consecutivo 		VARCHAR(200);					-- Numero consecutivo para la imagen a digitalizar
	DECLARE Var_FechaRegistro 		DATE;						-- Fecha en la que se digitalizo el Archivo
	DECLARE Var_TotalDesbloq		DECIMAL(18,2);
	DECLARE Var_NumRegistros		INT(11);
	DECLARE Var_Contador			INT(11);
	DECLARE Var_ClienteID			INT(11);
	DECLARE Var_CuentaAhoID			INT(11);
	DECLARE Var_BloqueoID			INT(11);
	DECLARE Var_PagoRefID			INT(11);
	DECLARE Var_MontoBloq			DECIMAL(18,2);
	DECLARE Var_RestoBloquea		DECIMAL(18,2);
	DECLARE Var_SaldoBloqRef		DECIMAL(18,2);
	DECLARE Var_Referencia			VARCHAR(20);

	-- Declaracion de constantes
	DECLARE Estatus_Activo			CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Cons_NO					CHAR(1);
	DECLARE SalidaSi				CHAR(1);
	DECLARE Salida_NO				CHAR(1);
	DECLARE DesbloqueoSaldo			INT(1);
	DECLARE ActualizaDatos			INT(1);
	DECLARE Des_Desbloqueo			VARCHAR(50);
	DECLARE Error_Key				INT(11);		# Numero de Error
	DECLARE TipoBloq_PagoRefe		INT(11);
	DECLARE Descrip_Bloq			VARCHAR(200);
	DECLARE Naturaleza_Bloq			CHAR(1);


	-- Asignacion de constantes
	SET Entero_Cero				:=0;								-- Entero Cero
	SET Cadena_Vacia			:= '';								-- Cadena Vacia
	SET Cons_NO					:= 'N';								-- Constante No
	SET SalidaSi				:= 'S';								-- Salida Si
	SET Salida_NO				:= 'N';								-- Salida Si
	SET DesbloqueoSaldo			:= 1;
	SET ActualizaDatos			:= 2;
	SET Des_Desbloqueo			:= 'DESBLOQUEO PAGO POR REFERENCIA';
	SET Descrip_Bloq		:= 'BLOQUEO DE PAGO POR REFERENCIA';
	SET Naturaleza_Bloq		:= 'B';


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr		:= 999;
			SET Par_ErrMen		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOXREFERENCIAACT');
			SET Var_Control		:= 'sqlException' ;
		END;

		/*
		 * 1 - Desbloqueo del Saldo
		 * */
		IF(Par_TipoAct = DesbloqueoSaldo) THEN
			SET @Contador := 0;
			DELETE FROM TMPBLOQUEOSREF WHERE TransaccionID = Aud_NumTransaccion;
			INSERT INTO TMPBLOQUEOSREF
			SELECT
				Aud_NumTransaccion,	@Contador:= @Contador+1 AS NReg,	BLOQ.BloqueoID,		BLOQ.MontoBloq,
				CRED.ClienteID,						CRED.CuentaID,	CRED.ReferenciaPago
				FROM
					BLOQUEOS AS BLOQ
					INNER JOIN CREDITOS AS CRED ON BLOQ.Referencia = CRED.CreditoID
					WHERE BLOQ.NatMovimiento = 'B'
						AND BLOQ.TiposBloqID = 18
						AND CRED.Estatus IN('V','B')
						AND BLOQ.Referencia = Par_CreditoID
						AND BLOQ.FolioBloq = 0
						ORDER BY BLOQ.FechaMov;

			SET Var_SaldoBloqRef := (SELECT SUM(BLOQ.MontoBloq) FROM BLOQUEOS AS BLOQ WHERE
										BLOQ.NatMovimiento = 'B'
										AND BLOQ.TiposBloqID = 18
										AND BLOQ.Referencia = Par_CreditoID
										AND BLOQ.FolioBloq = 0
										GROUP BY BLOQ.Referencia);
			SET Var_SaldoBloqRef := IFNULL(Var_SaldoBloqRef,Entero_Cero);
			SET Var_NumRegistros := (SELECT MAX(NReg) FROM TMPBLOQUEOSREF WHERE TransaccionID = Aud_NumTransaccion);
			SET Var_NumRegistros	:= IFNULL(Var_NumRegistros, Entero_Cero);
			SET Var_TotalDesbloq	:= IFNULL(Var_TotalDesbloq,Entero_Cero);
			SET Var_Contador := 1;


			IF(Var_NumRegistros=Entero_Cero AND Par_Proceso = 'A') THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := CONCAT('No Se Puede Realizar el Pago del Crédito ',Par_CreditoID,' ya que la Cuenta del Crédito no Cuenta con Saldo por Concepto de Pago por Referencia');
				LEAVE ManejoErrores;
			END IF;

			# CICLO PARA RECORRER LA TABLA Y REALIZAR EL DESBLOQUEO
			IF(Var_NumRegistros>0) THEN
				DesbloqueoCiclo:WHILE(Var_Contador <= Var_NumRegistros AND Var_TotalDesbloq<Par_MontoPago) DO
					SET Error_Key		:= Entero_Cero;
					SET Var_BloqueoID	:= 0;
					SET Var_MontoBloq	:= 0;
					SET Var_ClienteID	:= 0;
					SET Var_CuentaAhoID := 0;

					ProcesoPago:BEGIN
						DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
							SET Error_Key := 999;
							SET Var_Contador := Var_Contador + 1;
						END;
						SELECT
							TMP.BloqueoID,			TMP.MontoBloq
							INTO
							Var_BloqueoID,			Var_MontoBloq
							FROM
								TMPBLOQUEOSREF AS TMP
								WHERE TMP.NReg = Var_Contador
								AND TMP.TransaccionID = Aud_NumTransaccion;

						CALL BLOQUEOSPRO(
							Var_BloqueoID,		'D',				Par_CuentaAhoID,		Par_Fecha,				Var_MontoBloq,
							Par_Fecha,			18,					Des_Desbloqueo,			Par_CreditoID,			Cadena_Vacia,
							Cadena_Vacia,		Salida_NO,			Par_NumErr,				Par_ErrMen,				Aud_EmpresaID,
							Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
							Aud_NumTransaccion);


						IF(Par_NumErr!=Entero_Cero) THEN
							SET Error_Key := 999;
							LEAVE ProcesoPago;
						END IF;
						SET Var_TotalDesbloq := Var_TotalDesbloq + Var_MontoBloq;
					END ProcesoPago;
					IF(Par_NumErr!=Entero_Cero) THEN
						LEAVE DesbloqueoCiclo;
					END IF;
					SET Var_Contador := Var_Contador + 1; -- Incrementa el contador

				END WHILE DesbloqueoCiclo;-- Fin de WHILE
			END IF;
			# FIN CICLO PARA RECORRER LA TABLA Y REALIZAR EL DESBLOQUEO

			IF(Par_NumErr!=Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
			/*Bloqueamos el resto que se desbloqueo si se sobre paso el monto del exigible*/
			IF(Var_TotalDesbloq>Par_MontoPago) THEN
				SET Var_RestoBloquea := (Var_TotalDesbloq-Par_MontoPago);
				SET Var_RestoBloquea := IFNULL(Var_RestoBloquea,Entero_Cero);
				SET Var_TotalDesbloq := Var_TotalDesbloq - Var_RestoBloquea;
				IF(Var_RestoBloquea>Entero_Cero) THEN
					CALL BLOQUEOSPRO(
					Entero_Cero,		'B',					Par_CuentaAhoID, 		Par_Fecha,				Var_RestoBloquea,
					Aud_FechaActual,	18,						Descrip_Bloq,	 		Par_CreditoID,			Cadena_Vacia,
					Cadena_Vacia,		'N',					Par_NumErr,    			Par_ErrMen,				Aud_EmpresaID,
					Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,     	Aud_Sucursal,
					Aud_NumTransaccion);
					 -- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
					IF (Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			SET Var_PagoRefID := (SELECT MAX(PagoRefID) FROM PAGOXREFERENCIA);
			SET Var_PagoRefID	:= IFNULL(Var_PagoRefID,Entero_Cero)+1;

			INSERT INTO PAGOXREFERENCIA(
				PagoRefID,			TransaccionID,			ClienteID,			CreditoID,			CuentaAhoID,
				Referencia,			Monto,					FechaApli,			Hora,				Estatus,
				SaldoBloqRefere,	SaldoCtaAntesPag,
				EmpresaID,			Usuario,				FechaActual,		DireccionIP,		ProgramaID,
				Sucursal,			NumTransaccion)
			VALUES(
				Var_PagoRefID,		Aud_NumTransaccion,		Par_ClienteID,		Par_CreditoID,		Par_CuentaAhoID,
				Par_Referencia,		Var_TotalDesbloq,		Par_Fecha,			NOW(),				'P',
				Var_SaldoBloqRef,	Par_SaldoCta,
				Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion
			);
			DELETE FROM TMPBLOQUEOSREF WHERE TransaccionID = Aud_NumTransaccion;
			SET	Par_NumErr		:= 000;
			SET	Par_ErrMen		:= CONCAT('Saldo Desbloqueado Exitosamente para el Credito: ',Par_CreditoID,'.');
			SET Var_Control 	:= '' ;
			SET Var_Consecutivo	:= '';
		END IF;

		IF(Par_TipoAct = DesbloqueoSaldo) THEN
			UPDATE PAGOXREFERENCIA AS PAG
			SET
			PAG.Estatus = 'A'
			WHERE PAG.CreditoID =Par_CreditoID AND PAG.TransaccionID=Par_Transaccion;
			SET	Par_NumErr		:= 000;
			SET	Par_ErrMen		:= CONCAT('Actualizado el Pago Realizado por Referencia Exitosamente para el Credito: ',Par_CreditoID,'.');
			SET Var_Control 	:= '' ;
			SET Var_Consecutivo	:= '';
		END IF;


	END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT 	Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
		Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$