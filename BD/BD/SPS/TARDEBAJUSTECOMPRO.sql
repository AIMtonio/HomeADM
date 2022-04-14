-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBAJUSTECOMPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBAJUSTECOMPRO`;DELIMITER $$

CREATE PROCEDURE `TARDEBAJUSTECOMPRO`(

	Par_TipoOperacion			CHAR(2),
    Par_NumeroTarjeta       	CHAR(16),
	Par_Referencia				VARCHAR(12),
    Par_MontoTransaccion   	 	DECIMAL(12,2),
    Par_MontoAdicio         	DECIMAL(12,2),

	Par_IdTerminal				VARCHAR(40),
    Par_GiroNegocio         	CHAR(4),
    Par_MonedaID            	INT(11),
    Par_NumTransaccion      	VARCHAR(10),
    Par_CompraPOSLinea      	CHAR(1),

    Par_FechaActual         	DATETIME,
	INOUT NumeroTransaccion		VARCHAR(6),
	INOUT SaldoContableAct		VARCHAR(13),
	INOUT SaldoDisponibleAct	VARCHAR(13),
	INOUT CodigoRespuesta 	  	VARCHAR(3),

    INOUT FechaAplicacion		VARCHAR(4),
	Par_TardebMovID				INT(11)

)
TerminaStore: BEGIN


	DECLARE Var_CuentaAhoID 		BIGINT(12);
	DECLARE Var_ClienteID   		INT(11);
	DECLARE Var_Referencia  		VARCHAR(50);
	DECLARE Var_DesAhorro   		VARCHAR(150);
	DECLARE Var_SaldoDisp   		DECIMAL(12,2);

	DECLARE Var_SaldoDispoAct    	DECIMAL(12,2);
	DECLARE Var_SaldoContable		DECIMAL(12,2);
	DECLARE Var_NumTransaccion      BIGINT(20);
	DECLARE Var_MontoCompraDiario   DECIMAL(12,2);
	DECLARE Var_LimiteCompraDiario  DECIMAL(12,2);

	DECLARE Var_MontoCompLibre		DECIMAL(12,2);
	DECLARE Var_MontoCompraMes		DECIMAL(12,2);
	DECLARE Var_LimiteCompraMes		DECIMAL(12,2);
	DECLARE Var_MontoOpeOriginal	DECIMAL(12,2);
	DECLARE Var_NumReferencia		VARCHAR(12);

	DECLARE Var_MontoDispensado		VARCHAR(12);
	DECLARE Var_TipoTarjetaDeb      INT(11);
	DECLARE Val_Giro                CHAR(4);
	DECLARE Var_BloqueID            INT(11);
	DECLARE HoraAplicacion			VARCHAR(8);

	DECLARE Var_Poliza          	BIGINT(20);


	DECLARE Cadena_Vacia    		CHAR(1);
	DECLARE Entero_Cero     		INT(11);
	DECLARE Salida_NO       		CHAR(1);
	DECLARE Salida_SI       		CHAR(1);
	DECLARE Decimal_Cero    		DECIMAL(12,2);

	DECLARE Monto_Cero				VARCHAR(12);
	DECLARE CompraEnLineaSI 		CHAR(1);
	DECLARE CompraEnLineaNO 		CHAR(1);
	DECLARE Nat_Cargo       		CHAR(1);
	DECLARE CompraNormal			CHAR(2);

	DECLARE TipoReversaOpe			CHAR(2);
	DECLARE Aud_EmpresaID           INT(11);
	DECLARE Aud_Usuario             INT(11);
	DECLARE Aud_DireccionIP         VARCHAR(15);
	DECLARE Aud_ProgramaID          VARCHAR(50);

	DECLARE Aud_Sucursal            INT(11);
	DECLARE Aud_FechaActual			DATETIME;
	DECLARE Mov_AhoCompra           VARCHAR(50);
	DECLARE Error_Key               INT(11);
	DECLARE Var_BloqPOS             VARCHAR(5);

	DECLARE BloqPOS_SI              CHAR(1);
	DECLARE Entero_MenosUno         INT(11);
	DECLARE Var_NatMovimiento       CHAR(1);
	DECLARE Var_TipoBloqID          INT(11);
	DECLARE Fecha_Vacia				DATE;

	DECLARE Saldo_Cero				VARCHAR(13);
	DECLARE ProActualiza			INT(11);
	DECLARE Est_Procesado			CHAR(1);
	DECLARE Var_Continuar			INT(11);
	DECLARE MonedaPesosSF			INT(11);

	DECLARE Pol_Automatica  		CHAR(1);
	DECLARE ConceptoTarDeb  		INT(11);
	DECLARE Con_DescriMov			VARCHAR(50);

	DECLARE Con_AhoCapital      	INT(11);
	DECLARE Con_OperacPOS       	INT(11);
	DECLARE Par_NumErr				INT(11);
	DECLARE Par_ErrMen          	VARCHAR(150);
	DECLARE Est_Registrado			CHAR(1);

	DECLARE Con_BloqPOS         	INT(11);
	DECLARE Con_CompraDiario    	INT(11);
	DECLARE Con_CompraMes       	INT(11);


	SET Con_BloqPOS     	:= 2;
	SET Con_CompraDiario    := 3;
	SET Con_CompraMes       := 4;
	SET Cadena_Vacia    	:= '';
	SET Entero_Cero     	:= 0;

	SET Salida_NO       	:= 'N';
	SET Salida_SI       	:= 'S';
	SET Decimal_Cero    	:= 0.00;
	SET Saldo_Cero			:= 'C000000000000';
	SET Monto_Cero			:= '000000000000';

	SET CompraEnLineaSI 	:= 'S';
	SET Nat_Cargo       	:= 'C';
	SET Mov_AhoCompra   	:= '106';
	SET MonedaPesosSF		:= 1;
	SET Aud_EmpresaID   	:= 1;

	SET Aud_Usuario     	:= 1;
	SET Aud_DireccionIP 	:= 'localhost';
	SET Aud_ProgramaID  	:= 'workbench';
	SET Aud_Sucursal    	:= 1;
	SET Error_Key       	:= Entero_Cero;

	SET BloqPOS_SI      	:= 'S';
	SET Entero_MenosUno 	:= -1;
	SET Fecha_Vacia			:= '1900-01-01';
	SET ProActualiza		:= 2;
	SET Est_Procesado		:= 'P';

	SET CompraNormal		:= '00';
	SET TipoReversaOpe		:= '1420';
	SET Var_Continuar 		:= Entero_Cero;
	SET Var_MontoDispensado	:= Decimal_Cero;
	SET Pol_Automatica  	:= 'A';

	SET ConceptoTarDeb  	:= 300;
	SET Con_AhoCapital  	:= 1;
	SET Con_OperacPOS   	:= 2;

	SET Est_Registrado		:='R';


	SET Aud_FechaActual		:= NOW();
	SET FechaAplicacion	:=	(SELECT DATE_FORMAT(FechaSistema , '%m%d') FROM PARAMETROSSIS);
    SET HoraAplicacion	:=	(SELECT DATE_FORMAT(NOW(), '%H%i%s') FROM PARAMETROSSIS);

    IF (IFNULL(Par_GiroNegocio, Cadena_Vacia) = Cadena_Vacia) THEN
		SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
		SET SaldoContableAct	:= Saldo_Cero;
		SET SaldoDisponibleAct	:= Saldo_Cero;
		SET CodigoRespuesta   	:= "410";
		SET FechaAplicacion		:= FechaAplicacion;
	    LEAVE TerminaStore;
    END IF;


       SELECT CuentaAhoID,
              TipoTarjetaDebID,
              IFNULL(FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_BloqPOS), Cadena_Vacia),
              IFNULL(tar.MontoCompraDiario, Entero_MenosUno ),
              IFNULL(FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_CompraDiario), Decimal_Cero),
              IFNULL(tar.MontoCompraMes, Decimal_Cero),
              IFNULL(FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_CompraMes), Decimal_Cero)
         INTO Var_CuentaAhoID, Var_TipoTarjetaDeb, Var_BloqPOS,Var_MontoCompraDiario, Var_LimiteCompraDiario, Var_MontoCompraMes, Var_LimiteCompraMes
		FROM TARJETADEBITO tar
		WHERE tar.TarjetaDebID = Par_NumeroTarjeta;


    SELECT ClienteID INTO Var_ClienteID
        FROM CUENTASAHO
        WHERE CuentaAhoID = Var_CuentaAhoID;


    SET Val_Giro :=  (SELECT FUNCIONGIRO (Par_NumeroTarjeta, Var_ClienteID, Var_TipoTarjetaDeb, Par_GiroNegocio));

    IF ( Val_Giro = Entero_Cero ) THEN

        IF (Var_BloqPOS != BloqPOS_SI) THEN

			SELECT	MontoOpe, Referencia
					INTO Var_MontoOpeOriginal, Var_NumReferencia
				FROM TARDEBBITACORAMOVS
				WHERE NumTransaccion = Par_Referencia AND TipoOperacionID = CompraNormal
					AND TarjetaDebID = Par_NumeroTarjeta AND Estatus = Est_Procesado;

			IF (IFNULL(Var_MontoOpeOriginal, Decimal_Cero) = Decimal_Cero) THEN
				SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
				SET SaldoContableAct	:= Saldo_Cero;
				SET SaldoDisponibleAct	:= Saldo_Cero;
				SET CodigoRespuesta   	:= "601";
				SET FechaAplicacion		:= FechaAplicacion;
				LEAVE TerminaStore;
			END IF;

			IF (Par_MontoTransaccion = Var_MontoOpeOriginal) THEN

				CALL TARDEBREVCOMNORPRO(
					Par_NumeroTarjeta,	Var_NumReferencia,	Var_MontoOpeOriginal,	Monto_Cero,			MonedaPesosSF,
					CompraEnLineaSI,	Par_FechaActual,	Par_NumTransaccion,		NumeroTransaccion,	SaldoContableAct,
					SaldoDisponibleAct,	CodigoRespuesta,	FechaAplicacion, Par_TardebMovID);

				IF (CodigoRespuesta = Entero_Cero) THEN
					SET NumeroTransaccion	:= NumeroTransaccion;
					SET SaldoContableAct	:= SaldoContableAct;
					SET SaldoDisponibleAct	:= SaldoDisponibleAct;
					SET CodigoRespuesta   	:= "000";
					SET FechaAplicacion		:= FechaAplicacion;
					COMMIT;
				ELSE
					SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
					SET SaldoContableAct	:= Saldo_Cero;
					SET SaldoDisponibleAct	:= Saldo_Cero;
					SET CodigoRespuesta   	:= CodigoRespuesta;
					SET FechaAplicacion		:= FechaAplicacion;
					ROLLBACK;
				END IF;

			ELSEIF (Par_MontoTransaccion < Var_MontoOpeOriginal) THEN


				CALL TARDEBREVCOMNORPRO(
					Par_NumeroTarjeta,	Var_NumReferencia,	Var_MontoOpeOriginal,	Par_MontoTransaccion,	MonedaPesosSF,
					CompraEnLineaSI,	Par_FechaActual,	Par_NumTransaccion,		NumeroTransaccion,		SaldoContableAct,
					SaldoDisponibleAct,	CodigoRespuesta,	FechaAplicacion, Par_TardebMovID);

				IF (CodigoRespuesta = Entero_Cero) THEN
					SET NumeroTransaccion	:= NumeroTransaccion;
					SET SaldoContableAct	:= SaldoContableAct;
					SET SaldoDisponibleAct	:= SaldoDisponibleAct;
					SET CodigoRespuesta   	:= "000";
					SET FechaAplicacion		:= FechaAplicacion;
					COMMIT;
				ELSE
					SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
					SET SaldoContableAct	:= Saldo_Cero;
					SET SaldoDisponibleAct	:= Saldo_Cero;
					SET CodigoRespuesta   	:= CodigoRespuesta;
					SET FechaAplicacion		:= FechaAplicacion;
					ROLLBACK;
				END IF;

			ELSEIF (Par_MontoTransaccion > Var_MontoOpeOriginal) THEN

				SET Par_MontoTransaccion := Par_MontoTransaccion  - Var_MontoOpeOriginal;

				IF (Var_LimiteCompraDiario = Decimal_Cero) THEN
					SET Var_Continuar := Entero_Cero;
				ELSE
					IF (Var_MontoCompraDiario < Var_LimiteCompraDiario) THEN
						SET Var_MontoCompLibre = Var_LimiteCompraDiario - Var_MontoCompraDiario ;
						IF (Par_MontoTransaccion <= Var_MontoCompLibre) THEN
							SET Var_Continuar := Entero_Cero;
						ELSE
							SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
							SET SaldoContableAct	:= Saldo_Cero;
							SET SaldoDisponibleAct	:= Saldo_Cero;
							SET CodigoRespuesta   	:= "126";
							SET FechaAplicacion		:= FechaAplicacion;
							LEAVE TerminaStore;
						END IF;
					ELSE

						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= "127";
						SET FechaAplicacion		:= FechaAplicacion;
						LEAVE TerminaStore;
					END IF;
				END IF;


				IF (Var_LimiteCompraMes = Decimal_Cero) THEN
					SET Var_Continuar := Entero_Cero;
				ELSE
					IF (Var_MontoCompraMes < Var_LimiteCompraMes) THEN
						SET Var_MontoCompLibre := Var_LimiteCompraMes - Var_MontoCompraMes;
						IF (Par_MontoTransaccion <= Var_MontoCompLibre) THEN
							SET Var_Continuar := Entero_Cero;
						ELSE
							SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
							SET SaldoContableAct	:= Saldo_Cero;
							SET SaldoDisponibleAct	:= Saldo_Cero;
							SET CodigoRespuesta   	:= "128";
							SET FechaAplicacion		:= FechaAplicacion;
							LEAVE TerminaStore;
						END IF;
					ELSE
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= "129";
						SET FechaAplicacion		:= FechaAplicacion;
						LEAVE TerminaStore;
					END IF;
				END IF;

				IF ( Var_Continuar = Entero_Cero) THEN
					IF (IFNULL(Par_MontoTransaccion, Cadena_Vacia) = Cadena_Vacia) THEN
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= "110";
						SET FechaAplicacion		:= FechaAplicacion;
						LEAVE TerminaStore;
					END IF;
					IF (Par_MontoTransaccion = Decimal_Cero )THEN
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= "110";
						SET FechaAplicacion		:= FechaAplicacion;
						LEAVE TerminaStore;
					END IF;

					IF (Par_MontoAdicio >=  Par_MontoTransaccion) THEN
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= "110";
						SET FechaAplicacion		:= FechaAplicacion;
						LEAVE TerminaStore;
					END IF;

					SET Var_CuentaAhoID := IFNULL(Var_CuentaAhoID, Entero_Cero);


					SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);
					SET Var_Referencia  := CONCAT('TAR **** ', SUBSTRING(Par_NumeroTarjeta,13, 4));
					SET Par_MontoAdicio := IFNULL(Par_MontoAdicio, Decimal_Cero);
					SET Var_DesAhorro   := CONCAT('AJUSTE DE COMPRA CON TDD');


					SELECT IFNULL(SaldoDispon, Decimal_Cero)
							INTO Var_SaldoDisp
						FROM CUENTASAHO
						WHERE CuentaAhoID = Var_CuentaAhoID;

					IF (Var_SaldoDisp = Decimal_Cero ) THEN
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= "116";
						SET FechaAplicacion		:= FechaAplicacion;
						LEAVE TerminaStore;
					END IF;


					IF( Var_SaldoDisp < Par_MontoTransaccion ) THEN
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= "116";
						SET FechaAplicacion		:= FechaAplicacion;
						LEAVE TerminaStore;
					ELSE

						CALL TARDEBTRANSACPRO(Var_NumTransaccion);
						IF (Par_CompraPOSLinea = CompraEnLineaSI) THEN
							UPDATE CUENTASAHO SET
									CargosDia   =   CargosDia   +   Par_MontoTransaccion,
									CargosMes   =   CargosMes   +   Par_MontoTransaccion,
									Saldo       =   Saldo       -   Par_MontoTransaccion,
									SaldoDispon =   SaldoDispon -   Par_MontoTransaccion
							WHERE CuentaAhoID   =   Var_CuentaAhoID;


							INSERT INTO CUENTASAHOMOV(
								CuentaAhoID,	    NumeroMov,	            Fecha,					NatMovimiento,			CantidadMov,
								DescripcionMov,	 	ReferenciaMov,			TipoMovAhoID,			MonedaID,	  			PolizaID,
								EmpresaID, 			Usuario,			 	FechaActual,			DireccionIP, 			ProgramaID,
								Sucursal,			NumTransaccion)
							VALUES(
								Var_CuentaAhoID,    Var_NumTransaccion, 	Par_FechaActual,    	Nat_Cargo,      		Par_MontoTransaccion,
								Var_DesAhorro,      Var_Referencia,     	Mov_AhoCompra,      	Par_MonedaID,   		Entero_Cero,
                                Aud_EmpresaID,		Aud_Usuario,        	Aud_FechaActual,    	Aud_DireccionIP,    	Aud_ProgramaID,
                                Aud_Sucursal,		Var_NumTransaccion);

							SET Con_DescriMov	:= 'AJUSTE DE COMPRA CON TDD';
							CALL MAESTROPOLIZAALT(
								Var_Poliza,         Aud_EmpresaID,  		Par_FechaActual, 		Pol_Automatica,     	ConceptoTarDeb,
								Con_DescriMov,      Salida_NO,      		Aud_Usuario,            Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,     Aud_Sucursal,   		Var_NumTransaccion);


							CALL POLIZAAHORROPRO(
								Var_Poliza,         Aud_EmpresaID,  		Par_FechaActual, 		Var_ClienteID,      	Con_AhoCapital,
								Var_CuentaAhoID,    Par_MonedaID,   		Par_MontoTransaccion,   Entero_Cero,        	Con_DescriMov,
								Par_Referencia,     Aud_Usuario,    		Aud_FechaActual, 		Aud_DireccionIP,    	Aud_ProgramaID,
								Aud_Sucursal,       Var_NumTransaccion);

							CALL POLIZATARJETAPRO(
								Var_Poliza,         Aud_EmpresaID,     	 	Par_FechaActual,		Par_NumeroTarjeta,      Var_ClienteID,
								Con_OperacPOS,      Par_MonedaID,       	Entero_Cero,        	Par_MontoTransaccion,   Con_DescriMov,
								Par_Referencia,     Entero_Cero,			Salida_NO,          	Par_NumErr,             Par_ErrMen,
                                Aud_Usuario,		Aud_FechaActual, 		Aud_DireccionIP,    	Aud_ProgramaID,         Aud_Sucursal,
                                Var_NumTransaccion );


						END IF;




						UPDATE TARDEBBITACORAMOVS SET
							    NumTransaccion 	= Var_NumTransaccion,
							    Estatus			= Est_Procesado
						  WHERE TarjetaDebID = Par_NumeroTarjeta
							AND NumTransaccion = Entero_Cero
							AND Estatus = Est_Registrado
                            AND TardebMovID = Par_TardebMovID;


						SELECT IFNULL(SaldoDispon,Decimal_Cero), IFNULL(Saldo, Decimal_Cero)
								INTO Var_SaldoDispoAct, Var_SaldoContable
							FROM CUENTASAHO
							WHERE CuentaAhoID = Var_CuentaAhoID;

							SET NumeroTransaccion	:= LPAD(CONVERT(Var_NumTransaccion, CHAR), 6, 0);
							SET SaldoContableAct	:= CONCAT('C' , LPAD(REPLACE(CONVERT(Var_SaldoContable,CHAR) , '.', ''), 12, 0));
							SET SaldoDisponibleAct	:= CONCAT('C' , LPAD(REPLACE(CONVERT(Var_SaldoDispoAct,CHAR) , '.', ''), 12, 0));
							SET FechaAplicacion		:= FechaAplicacion;

					END IF;
				END IF;
			END IF;
			IF (Error_Key = Entero_Cero) THEN
				SET NumeroTransaccion	:= LPAD(CONVERT(NumeroTransaccion, CHAR), 6, 0);
				SET SaldoContableAct	:= SaldoContableAct;
				SET SaldoDisponibleAct	:= SaldoDisponibleAct;
				SET CodigoRespuesta   	:= "000";
				SET FechaAplicacion		:= FechaAplicacion;
			ELSE
				SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
				SET SaldoContableAct	:= Saldo_Cero;
				SET SaldoDisponibleAct	:= Saldo_Cero;
				SET CodigoRespuesta   	:= "418";
				SET FechaAplicacion		:= FechaAplicacion;
				ROLLBACK;
			END IF;
        ELSE
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "415";
			SET FechaAplicacion		:= FechaAplicacion;
            LEAVE TerminaStore;
        END IF;
    ELSE
		SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
		SET SaldoContableAct	:= Saldo_Cero;
		SET SaldoDisponibleAct	:= Saldo_Cero;
		SET CodigoRespuesta   	:= "103";
		SET FechaAplicacion		:= FechaAplicacion;
        LEAVE TerminaStore;
    END IF;
END TerminaStore$$