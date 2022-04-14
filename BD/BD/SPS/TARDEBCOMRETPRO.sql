-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCOMRETPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCOMRETPRO`;DELIMITER $$

CREATE PROCEDURE `TARDEBCOMRETPRO`(

	Par_TipoOperacion			CHAR(2),
	Par_NumeroTarjeta       	CHAR(16),
	Par_Referencia				VARCHAR(12),
	Par_MontoTransaccion    	DECIMAL(12,2),
	Par_MontoAdicio         	DECIMAL(12,2),

	Par_GiroNegocio         	CHAR(4),
	Par_MonedaID            	INT(11),
	Par_NumTransaccion      	VARCHAR(10),
	Par_CompraPOSLinea      	CHAR(1),
	Par_FechaActual         	DATETIME,

    Par_NomUbicTerminal			VARCHAR(150),
	INOUT NumeroTransaccion		VARCHAR(20),
	INOUT SaldoContableAct		VARCHAR(13),
	INOUT SaldoDisponibleAct	VARCHAR(13),
	INOUT CodigoRespuesta   	VARCHAR(3),

    INOUT FechaAplicacion		VARCHAR(4),
	Par_TardebMovID				INT(11)
)
TerminaStore: BEGIN


	DECLARE Var_CuentaAhoID         BIGINT(12);
	DECLARE Var_ClienteID           INT(11);
	DECLARE Par_ReferenciaMov		VARCHAR(50);
	DECLARE Var_MontoCompra         DECIMAL(12,2);
	DECLARE Var_DesAhorro           VARCHAR(150);

	DECLARE Var_SaldoDisp           DECIMAL(12,2);
	DECLARE Var_SaldoDispoAct    	DECIMAL(12,2);
	DECLARE Var_BloqPOS             VARCHAR(5);
	DECLARE Var_MontoCompraDiario   DECIMAL(12,2);
	DECLARE Var_LimiteCompraDiario  DECIMAL(12,2);

	DECLARE Var_MontoDispoDiario    DECIMAL(12,2);
	DECLARE Var_LimiteDispoDiario   DECIMAL(12,2);
	DECLARE Var_TipoTarjetaDeb      INT(11);
	DECLARE Val_Giro                CHAR(4);
	DECLARE Var_BloqueID            INT(11);

	DECLARE Var_NatMovimiento       CHAR(1);
	DECLARE Var_TipoBloqID          INT(11);
	DECLARE Var_MontoComLibre		DECIMAL(12,2);
	DECLARE Var_MontoDispoLibre		DECIMAL(12,2);
	DECLARE Var_MontoCompraMes		DECIMAL(12,2);

	DECLARE Var_LimiteCompraMes		DECIMAL(12,2);
	DECLARE	Var_MontoDispoMes		DECIMAL(12,2);
	DECLARE	Var_LimiteDispoMes		DECIMAL(12,2);
	DECLARE Var_MontoCompLibre		DECIMAL(12,2);
	DECLARE Var_MontoDispoMesLibre	DECIMAL(12,2);

	DECLARE Var_NumTransaccion  	BIGINT(20);
	DECLARE Var_SaldoContable		DECIMAL(12,2);


	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Entero_Cero     	INT(11);
	DECLARE Decimal_Cero    	DECIMAL(12,2);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Salida_SI       	CHAR(1);

	DECLARE Salida_NO       	CHAR(1);
	DECLARE CompraEnLineaSI 	CHAR(1);
	DECLARE Nat_Cargo       	CHAR(1);
	DECLARE Aud_EmpresaID   	INT(11);
	DECLARE Aud_Usuario     	INT(11);

	DECLARE Aud_FechaActual		DATETIME;
	DECLARE Aud_DireccionIP 	VARCHAR(15);
	DECLARE Aud_ProgramaID  	VARCHAR(50);
	DECLARE Aud_Sucursal    	INT(11);
	DECLARE Error_Key       	INT(11);

	DECLARE Mov_AhoCompraRet	CHAR(4);
	DECLARE BloqPOS_SI          CHAR(1);
	DECLARE Entero_MenosUno     INT(11);
	DECLARE Saldo_Cero			VARCHAR(13);
	DECLARE ProActualiza		INT(11);

	DECLARE Est_Procesado		CHAR(1);
	DECLARE Var_Continuar		INT(11);
	DECLARE Est_Registrado		CHAR(1);
	DECLARE Con_BloqPOS         INT(11);
	DECLARE Con_CompraDiario    INT(11);

	DECLARE Con_DispoDiario     INT(11);
	DECLARE Con_CompraMes       INT(11);
	DECLARE Con_DispoMes        INT(11);
	DECLARE BloqueoSaldo		CHAR(1);
	DECLARE TipBloqTarjeta		INT(11);


	SET Con_BloqPOS     	:= 2;
	SET Con_CompraDiario    := 3;
	SET Con_DispoDiario     := 1;
	SET Con_CompraMes       := 4;
	SET Con_DispoMes        := 2;

	SET Cadena_Vacia    	:= '';
	SET Entero_Cero     	:= 0;
	SET Decimal_Cero    	:= '0.00';
	SET Saldo_Cero			:= 'C000000000000';
	SET Fecha_Vacia     	:= '1900-01-01';

	SET Salida_SI       	:= 'S';
	SET Salida_NO       	:= 'N';
	SET CompraEnLineaSI 	:= 'S';
	SET Nat_Cargo       	:= 'C';
	SET Aud_EmpresaID   	:= 1;

	SET Aud_Usuario     	:= 1;
	SET Aud_DireccionIP 	:= 'localhost';
	SET Aud_ProgramaID  	:= 'workbench';
	SET Aud_Sucursal    	:= 1;
	SET Error_Key       	:= Entero_Cero;

	SET Mov_AhoCompraRet	:= '87';
	SET BloqPOS_SI      	:= 'S';
	SET Entero_MenosUno 	:= -1;
	SET ProActualiza		:= 2;
	SET Est_Procesado		:= 'P';

	SET Var_Continuar		:= Entero_Cero;
	SET BloqueoSaldo		:= 'B';
	SET TipBloqTarjeta      := 3;
	SET Est_Registrado		:= 'R';


	SET Aud_FechaActual	:= NOW();
	SET FechaAplicacion	:=	(SELECT DATE_FORMAT(FechaSistema , '%m%d') FROM PARAMETROSSIS);

	IF (IFNULL(Par_MontoTransaccion, Decimal_Cero) = Decimal_Cero) THEN
		SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
		SET SaldoContableAct	:= Saldo_Cero;
		SET SaldoDisponibleAct	:= Saldo_Cero;
		SET CodigoRespuesta   	:= "110";
		SET FechaAplicacion		:= FechaAplicacion;
        LEAVE TerminaStore;
    END IF;

	IF (IFNULL(Par_MontoAdicio, Decimal_Cero) = Decimal_Cero) THEN
		SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
		SET SaldoContableAct	:= Saldo_Cero;
		SET SaldoDisponibleAct	:= Saldo_Cero;
		SET CodigoRespuesta   	:= "110";
		SET FechaAplicacion		:= FechaAplicacion;
		LEAVE TerminaStore;
	END IF;

    IF (IFNULL(Par_GiroNegocio, Cadena_Vacia) = Cadena_Vacia) THEN
		SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
		SET SaldoContableAct	:= Saldo_Cero;
		SET SaldoDisponibleAct	:= Saldo_Cero;
		SET CodigoRespuesta   	:= "110";
		SET FechaAplicacion		:= FechaAplicacion;
        LEAVE TerminaStore;
    END IF;


    SELECT CuentaAhoID,
	  TipoTarjetaDebID,
	  IFNULL(FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_BloqPOS), Cadena_Vacia),
	  IFNULL(tar.MontoCompraDiario, Entero_MenosUno ),
	  IFNULL(FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_CompraDiario), Decimal_Cero),
	  IFNULL(tar.MontoDispoDiario, Entero_MenosUno ),
	  IFNULL(FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_DispoDiario), Decimal_Cero),
	  IFNULL(tar.MontoCompraMes, Decimal_Cero),
	  IFNULL(FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_CompraMes), Decimal_Cero),
	  IFNULL(tar.MontoDispoMes, Decimal_Cero),
	  IFNULL(FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_DispoMes), Decimal_Cero)
 INTO Var_CuentaAhoID,      Var_TipoTarjetaDeb,    Var_BloqPOS,        Var_MontoCompraDiario, Var_LimiteCompraDiario,
      Var_MontoDispoDiario, Var_LimiteDispoDiario, Var_MontoCompraMes, Var_LimiteCompraMes,   Var_MontoDispoMes,
      Var_LimiteDispoMes
  FROM TARJETADEBITO tar
 WHERE tar.TarjetaDebID = Par_NumeroTarjeta;

    SELECT ClienteID    INTO Var_ClienteID
        FROM CUENTASAHO
        WHERE CuentaAhoID = Var_CuentaAhoID;

    SET Val_Giro :=  (SELECT FUNCIONGIRO (Par_NumeroTarjeta, Var_ClienteID, Var_TipoTarjetaDeb, Par_GiroNegocio));

    IF ( Val_Giro = Entero_Cero ) THEN

        IF (Var_BloqPOS != BloqPOS_SI) THEN


			SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);
            SET Par_ReferenciaMov  := CONCAT("TAR **** ", SUBSTRING(Par_NumeroTarjeta,13, 4));
            SET Par_MontoAdicio := IFNULL(Par_MontoAdicio, Decimal_Cero);
            SET Var_MontoCompra := (Par_MontoTransaccion - Par_MontoAdicio);


            IF (Var_LimiteCompraDiario = Decimal_Cero AND Var_LimiteDispoDiario = Decimal_Cero) THEN

				SET Var_Continuar := Entero_Cero;
			ELSE
				IF (Var_LimiteCompraDiario = Decimal_Cero)THEN
					SET Var_Continuar := Entero_Cero;
				ELSE

					IF (Var_MontoCompraDiario < Var_LimiteCompraDiario) THEN
						SET Var_MontoComLibre = Var_LimiteCompraDiario - Var_MontoCompraDiario;
						IF (Var_MontoCompra <= Var_MontoComLibre) THEN
							SET Var_Continuar := Entero_Cero;
						ELSE
							SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
							SET SaldoContableAct	:= Saldo_Cero;
							SET SaldoDisponibleAct	:= Saldo_Cero;
							SET CodigoRespuesta   	:= "121";
							SET FechaAplicacion		:= FechaAplicacion;
							LEAVE TerminaStore;
						END IF;
					ELSE
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= "121";
						SET FechaAplicacion		:= FechaAplicacion;
						LEAVE TerminaStore;
					END IF;
				END IF;


				IF (Var_MontoCompraMes < Var_LimiteCompraMes) THEN
					SET Var_MontoCompLibre := Var_LimiteCompraMes - Var_MontoCompraMes;
					IF (Var_MontoCompra <= Var_MontoCompLibre) THEN
						SET Var_Continuar := Entero_Cero;
					ELSE
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= "121";
						SET FechaAplicacion		:= FechaAplicacion;
						LEAVE TerminaStore;
					END IF;
				ELSE
					SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
					SET SaldoContableAct	:= Saldo_Cero;
					SET SaldoDisponibleAct	:= Saldo_Cero;
					SET CodigoRespuesta   	:= "121";
					SET FechaAplicacion		:= FechaAplicacion;
					LEAVE TerminaStore;
				END IF;


				IF (Var_LimiteDispoDiario = Decimal_Cero)THEN
					SET Var_Continuar := Entero_Cero;
				ELSE

					IF (Var_MontoDispoDiario < Var_LimiteDispoDiario) THEN
						SET Var_MontoDispoLibre = Var_LimiteDispoDiario - Var_MontoDispoDiario;
						IF (Par_MontoAdicio <= Var_MontoDispoLibre)THEN
							SET Var_Continuar := Entero_Cero;
						ELSE
							SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
							SET SaldoContableAct	:= Saldo_Cero;
							SET SaldoDisponibleAct	:= Saldo_Cero;
							SET CodigoRespuesta   	:= "121";
							SET FechaAplicacion		:= FechaAplicacion;
							LEAVE TerminaStore;
						END IF;
					ELSE
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= "121";
						SET FechaAplicacion		:= FechaAplicacion;
						LEAVE TerminaStore;
					END IF;
				END IF;


				IF (Var_MontoDispoMes < Var_LimiteDispoMes) THEN
					SET Var_MontoDispoMesLibre := Var_LimiteDispoMes - Var_MontoDispoMes;
					IF (Par_MontoAdicio <= Var_MontoDispoMesLibre) THEN
						SET Var_Continuar := Entero_Cero;
					ELSE
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= "121";
						SET FechaAplicacion		:= FechaAplicacion;
						LEAVE TerminaStore;
					END IF;
				ELSE
					SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
					SET SaldoContableAct	:= Saldo_Cero;
					SET SaldoDisponibleAct	:= Saldo_Cero;
					SET CodigoRespuesta   	:= "121";
					SET FechaAplicacion		:= FechaAplicacion;
					LEAVE TerminaStore;
				END IF;
			END IF;

            IF (Var_Continuar  = Entero_Cero ) THEN
                SET Var_CuentaAhoID := IFNULL(Var_CuentaAhoID, Entero_Cero);

                SELECT IFNULL(SaldoDispon,Entero_Cero)  INTO Var_SaldoDisp
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

			IF( Var_SaldoDisp - Par_MontoTransaccion < Entero_Cero) THEN
					SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
					SET SaldoContableAct	:= Saldo_Cero;
					SET SaldoDisponibleAct	:= Saldo_Cero;
					SET CodigoRespuesta   	:= "116";
					SET FechaAplicacion		:= FechaAplicacion;
			    LEAVE TerminaStore;
			END IF;


                        CALL TARDEBTRANSACPRO(Var_NumTransaccion);

                        IF ( Par_CompraPOSLinea = CompraEnLineaSI ) THEN

                            UPDATE CUENTASAHO SET
                                CargosDia   = CargosDia + Par_MontoTransaccion,
                                CargosMes   = CargosMes + Par_MontoTransaccion,
                                Saldo       = Saldo     - Par_MontoTransaccion,
                                SaldoDispon = SaldoDispon - Par_MontoTransaccion
                            WHERE CuentaAhoID = Var_CuentaAhoID;

                            IF (Var_MontoCompra <> Decimal_Cero ) THEN

								SET Var_DesAhorro := CONCAT("COMPRA CON TARJETA DE DEBITO",' ',Par_NomUbicTerminal);
                                INSERT INTO CUENTASAHOMOV(
										CuentaAhoID,	    	NumeroMov,	            Fecha,				NatMovimiento,		CantidadMov,
										DescripcionMov,	 		ReferenciaMov,			TipoMovAhoID,		MonedaID,	  		PolizaID,
                                        EmpresaID, 				Usuario,			 	FechaActual,		DireccionIP, 		ProgramaID,
                                        Sucursal,             	NumTransaccion)
								VALUES(
										Var_CuentaAhoID,    	Var_NumTransaccion, 	Par_FechaActual,	Nat_Cargo,      	Var_MontoCompra,
										Var_DesAhorro,      	Par_ReferenciaMov,		Mov_AhoCompraRet,	Par_MonedaID,   	Entero_Cero,
                                        Aud_EmpresaID,			Aud_Usuario,        	Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,
                                        Aud_Sucursal,			Var_NumTransaccion);
                            END IF;

								SET Var_DesAhorro := CONCAT("RETIRO EN COMPRA CON TARJETA DE DEBITO",' ',Par_NomUbicTerminal);
								INSERT INTO CUENTASAHOMOV(
										CuentaAhoID,	     	NumeroMov,	            Fecha,				NatMovimiento,		CantidadMov,
										DescripcionMov,	 		ReferenciaMov,			TipoMovAhoID,		MonedaID,	  		PolizaID,
										EmpresaID, 				Usuario,			 	FechaActual,		DireccionIP, 		ProgramaID,
										Sucursal,             	NumTransaccion)
								VALUES(
										Var_CuentaAhoID,    	Var_NumTransaccion, 	Par_FechaActual,    Nat_Cargo,      	Par_MontoAdicio,
										Var_DesAhorro,      	Par_ReferenciaMov,     	Mov_AhoCompraRet,   Par_MonedaID,   	Entero_Cero,
										Aud_EmpresaID,			Aud_Usuario,        	Aud_FechaActual,   	Aud_DireccionIP,	Aud_ProgramaID,
										Aud_Sucursal,			Var_NumTransaccion);

                        ELSE

					IF( Var_SaldoDisp - Par_MontoTransaccion < Entero_Cero) THEN
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= "116";
						SET FechaAplicacion		:= FechaAplicacion;
						LEAVE TerminaStore;
					END IF;

                            UPDATE  CUENTASAHO  SET
                                SaldoDispon     =   SaldoDispon - Par_MontoTransaccion,
                                SaldoBloq       =   SaldoBloq   + Par_MontoTransaccion
                            WHERE   CuentaAhoID =   Var_CuentaAhoID;


                            SET Var_BloqueID := (SELECT IFNULL(MAX(BloqueoID),Entero_Cero) + 1 FROM BLOQUEOS);
                            SET Var_NatMovimiento   := BloqueoSaldo;
                            SET Var_TipoBloqID      := TipBloqTarjeta;
                            SET Var_DesAhorro := CONCAT("COMPRA + RETIRO CON TARJETA DE DEBITO");
                            INSERT INTO BLOQUEOS (
                                BloqueoID,      CuentaAhoID,    	NatMovimiento,  	FechaMov,       MontoBloq,
                                FechaDesbloq,   TiposBloqID,    	Descripcion,    	Referencia,     FolioBloq,
                                EmpresaID,      Usuario,        	FechaActual,    	DireccionIP,    ProgramaID,
                                Sucursal,       NumTransaccion)
                            VALUES(
                                Var_BloqueID,   Var_CuentaAhoID,    Var_NatMovimiento,      Par_FechaActual,    Par_MontoTransaccion,
                                Fecha_Vacia,    Var_TipoBloqID,     UPPER(Var_DesAhorro),   Var_NumTransaccion, Entero_Cero,
                                Aud_EmpresaID,  Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                                Aud_Sucursal,   Var_NumTransaccion);
                        END IF;


                        UPDATE TARJETADEBITO SET
                            NoDispoDiario       =   IFNULL(NoDispoDiario, Entero_Cero)  + 1,
                            NoDispoMes          =   IFNULL(NoDispoMes, Entero_Cero)     + 1,
                            MontoDispoDiario    =   IFNULL(MontoDispoDiario, Decimal_Cero)  + Par_MontoAdicio,
                            MontoDispoMes       =   IFNULL(MontoDispoMes, Decimal_Cero)     + Par_MontoAdicio,
                            NoCompraDiario      =   IFNULL(NoCompraDiario,Entero_Cero)  + 1,
                            NoCompraMes         =   IFNULL(NoCompraMes, Entero_Cero)    + 1,
                            MontoCompraDiario   =   IFNULL(MontoCompraDiario, Decimal_Cero) + Var_MontoCompra,
                            MontoCompraMes      =   IFNULL(MontoCompraMes, Decimal_Cero)    + Var_MontoCompra
                        WHERE TarjetaDebID      =   Par_NumeroTarjeta;

			UPDATE TARDEBBITACORAMOVS SET
				NumTransaccion 	= Var_NumTransaccion,
				Estatus			= Est_Procesado
			WHERE TipoOperacionID= Par_TipoOperacion
			AND Referencia	 = Par_Referencia
			AND TarjetaDebID = Par_NumeroTarjeta
			AND NumTransaccion = Entero_Cero
			AND TarDebMovID = Par_TardebMovID
			AND Estatus = Est_Registrado;

			SELECT IFNULL(SaldoDispon,Decimal_Cero), IFNULL(Saldo, Decimal_Cero)
				INTO Var_SaldoDispoAct, Var_SaldoContable
				FROM CUENTASAHO
				WHERE CuentaAhoID = Var_CuentaAhoID;

                END IF;
            END IF;
			IF ( Error_Key = Entero_Cero ) THEN
				SET NumeroTransaccion	:= LPAD(CONVERT(Var_NumTransaccion,CHAR), 6, 0);
				SET SaldoContableAct	:= CONCAT('C' , LPAD(REPLACE(CONVERT(Var_SaldoContable,CHAR) , '.', ''), 12, 0));
				SET SaldoDisponibleAct	:= CONCAT('C' , LPAD(REPLACE(CONVERT(Var_SaldoDispoAct,CHAR) , '.', ''), 12, 0));
				SET CodigoRespuesta   	:= "000";
				SET FechaAplicacion		:= FechaAplicacion;
			ELSE
				SET NumeroTransaccion	:= 	LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
				SET SaldoContableAct	:= Saldo_Cero;
				SET SaldoDisponibleAct	:= Saldo_Cero;
				SET CodigoRespuesta   	:= "412";
				SET FechaAplicacion		:= FechaAplicacion;
				ROLLBACK;
			END IF;
        ELSE
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "412";
			SET FechaAplicacion		:= FechaAplicacion;
            LEAVE TerminaStore;
        END IF;
    ELSE
		SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
		SET SaldoContableAct	:= Saldo_Cero;
		SET SaldoDisponibleAct	:= Saldo_Cero;
		SET CodigoRespuesta   	:= "412";
		SET FechaAplicacion		:= FechaAplicacion;
        LEAVE TerminaStore;
    END IF;
END TerminaStore$$