-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCOMNORPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCOMNORPRO`;DELIMITER $$

CREATE PROCEDURE `TARDEBCOMNORPRO`(

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
	DECLARE Var_TipoTarjetaDeb      INT(11);
	DECLARE Val_Giro                CHAR(4);
	DECLARE Var_BloqueID            INT(11);

	DECLARE Var_BloqPOS             VARCHAR(5);
	DECLARE Var_MontoCompLibre		DECIMAL(12,2);
	DECLARE Var_MontoCompraMes		DECIMAL(12,2);
	DECLARE Var_LimiteCompraMes		DECIMAL(12,2);
	DECLARE Var_Saldo				DECIMAL(12,2);

	DECLARE Var_SaldoDispon			DECIMAL(12,2);
	DECLARE Var_NumTransaccion      BIGINT(20);


	DECLARE Cadena_Vacia    		CHAR(1);
	DECLARE Entero_Cero     		INT(11);
	DECLARE Salida_NO       		CHAR(1);
	DECLARE Salida_SI       		CHAR(1);
	DECLARE Decimal_Cero    		DECIMAL(12,2);

	DECLARE CompraEnLineaSI 		CHAR(1);
	DECLARE CompraEnLineaNO 		CHAR(1);
	DECLARE Nat_Cargo       		CHAR(1);
	DECLARE Aud_EmpresaID           INT(11);
	DECLARE Aud_Usuario             INT(11);

	DECLARE Aud_DireccionIP         VARCHAR(15);
	DECLARE Aud_ProgramaID          VARCHAR(50);
	DECLARE Aud_Sucursal            INT(11);
	DECLARE Aud_FechaActual			DATETIME;
	DECLARE Mov_AhoCompra           VARCHAR(50);

	DECLARE Error_Key               INT(11);
	DECLARE BloqPOS_SI              CHAR(1);
	DECLARE Var_MontoCompraDiario   DECIMAL(12,2);
	DECLARE Var_LimiteCompraDiario  DECIMAL(12,2);
	DECLARE Entero_MenosUno         INT(11);

	DECLARE Var_NatMovimiento       CHAR(1);
	DECLARE Var_TipoBloqID          INT(11);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Saldo_Cero				VARCHAR(13);
	DECLARE ProActualiza			INT(11);

	DECLARE Est_Procesado			CHAR(1);
	DECLARE Var_Continuar			INT(11);
	DECLARE Est_Registrado			CHAR(1);
	DECLARE Con_BloqPOS         	INT(11);
	DECLARE Con_CompraDiario    	INT(11);

	DECLARE Con_DispoDiario     	INT(11);
	DECLARE Con_CompraMes       	INT(11);
	DECLARE Con_DispoMes        	INT(11);
	DECLARE BloqueoSaldo			CHAR(1);
	DECLARE TipBloqTarjeta			INT(11);


	SET Con_BloqPOS     	:= 2;
	SET Con_CompraDiario    := 3;
	SET Con_DispoDiario     := 1;
	SET Con_CompraMes       := 4;
	SET Con_DispoMes        := 2;

	SET Cadena_Vacia    	:= '';
	SET Entero_Cero     	:= 0;
	SET Salida_NO       	:= 'N';
	SET Salida_SI       	:= 'S';
	SET Decimal_Cero    	:= 0.00;

	SET Saldo_Cero			:= 'C000000000000';
	SET CompraEnLineaSI 	:= 'S';
	SET Nat_Cargo       	:= 'C';
	SET Mov_AhoCompra   	:= '17';
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

	SET Var_Continuar 		:= Entero_Cero;
	SET Est_Registrado		:= 'R';
	SET BloqueoSaldo        := 'B';
	SET TipBloqTarjeta      := 3;


	SET Aud_FechaActual	:= NOW();


	SET FechaAplicacion	:=	(SELECT DATE_FORMAT(FechaSistema , '%m%d') FROM PARAMETROSSIS);


	  IF (IFNULL(Par_GiroNegocio, Cadena_Vacia) = Cadena_Vacia) THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "410";
			SET FechaAplicacion		:= FechaAplicacion;
			LEAVE TerminaStore;
		END IF;


        SELECT CuentaAhoID, TipoTarjetaDebID,
		  IFNULL(FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_BloqPOS), Cadena_Vacia),
		  IFNULL(tar.MontoCompraDiario, Entero_MenosUno ),
		  IFNULL(FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_CompraDiario), Decimal_Cero),
		  IFNULL(tar.MontoCompraMes, Decimal_Cero),
		  IFNULL(FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_CompraMes), Decimal_Cero)
		INTO Var_CuentaAhoID,      Var_TipoTarjetaDeb,    Var_BloqPOS,        Var_MontoCompraDiario, Var_LimiteCompraDiario,
      Var_MontoCompraMes, Var_LimiteCompraMes
		FROM TARJETADEBITO tar
		WHERE tar.TarjetaDebID = Par_NumeroTarjeta;


    SELECT ClienteID INTO Var_ClienteID
        FROM CUENTASAHO
        WHERE CuentaAhoID = Var_CuentaAhoID;

    SET Val_Giro :=  (SELECT FUNCIONGIRO (Par_NumeroTarjeta, Var_ClienteID, Var_TipoTarjetaDeb, Par_GiroNegocio));

    IF ( Val_Giro = Entero_Cero ) THEN

        IF (Var_BloqPOS != BloqPOS_SI) THEN

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
                SET Var_Referencia  := CONCAT("TAR **** ", SUBSTRING(Par_NumeroTarjeta,13, 4));
                SET Par_MontoAdicio := IFNULL(Par_MontoAdicio, Decimal_Cero);
                SET Var_DesAhorro   := CONCAT("COMPRA CON TARJETA DE DEBITO");


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



		    IF( Var_SaldoDisp - Par_MontoTransaccion < Entero_Cero) THEN
					    SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
					    SET SaldoContableAct	:= Saldo_Cero;
					    SET SaldoDisponibleAct	:= Saldo_Cero;
					    SET CodigoRespuesta   	:= "116";
					    SET FechaAplicacion		:= FechaAplicacion;
			LEAVE TerminaStore;
		    END IF;

                    CALL TARDEBTRANSACPRO(Var_NumTransaccion);
                    IF (Par_CompraPOSLinea = CompraEnLineaSI) THEN
                        UPDATE CUENTASAHO SET
                            CargosDia   =   CargosDia   +   Par_MontoTransaccion,
                            CargosMes   =   CargosMes   +   Par_MontoTransaccion,
                            Saldo       =   Saldo       -   Par_MontoTransaccion,
                            SaldoDispon =   SaldoDispon -   Par_MontoTransaccion
                        WHERE CuentaAhoID   =   Var_CuentaAhoID;
						SET Var_DesAhorro=CONCAT(Var_DesAhorro,' ',Par_NomUbicTerminal );

                        INSERT  INTO CUENTASAHOMOV(CuentaAhoID,	     	NumeroMov,	Fecha,		NatMovimiento,	CantidadMov,
                        			   DescripcionMov,	ReferenciaMov,	TipoMovAhoID,	MonedaID,	PolizaID,
                        			   EmpresaID,		Usuario,	FechaActual,	DireccionIP, 	ProgramaID,
                        			   Sucursal,		NumTransaccion)
					VALUES(Var_CuentaAhoID,	Var_NumTransaccion, Par_FechaActual,    Nat_Cargo,      Par_MontoTransaccion,
					      Var_DesAhorro,	Var_Referencia,     Mov_AhoCompra,      Par_MonedaID,   Entero_Cero,
					      Aud_EmpresaID,	Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
					      Aud_Sucursal,	Var_NumTransaccion  );
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
                        SET Var_NatMovimiento := BloqueoSaldo;
                        SET Var_TipoBloqID  := TipBloqTarjeta;
                        INSERT INTO BLOQUEOS (
                            BloqueoID,      CuentaAhoID,    NatMovimiento,  FechaMov,       MontoBloq,
                            FechaDesbloq,   TiposBloqID,    Descripcion,    Referencia,     FolioBloq,
                            EmpresaID,      Usuario,        FechaActual,    DireccionIP,    ProgramaID,
                            Sucursal,			NumTransaccion)
                        VALUES(
                            Var_BloqueID,   Var_CuentaAhoID,    Var_NatMovimiento,      Par_FechaActual,    Par_MontoTransaccion,
                            Fecha_Vacia,    Var_TipoBloqID,     UPPER(Var_DesAhorro),   Var_NumTransaccion, Entero_Cero,
                            Aud_EmpresaID,  Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                            Aud_Sucursal,   Var_NumTransaccion);
                    END IF;


                    UPDATE TARJETADEBITO SET
                        NoCompraDiario      =   IFNULL(NoCompraDiario,Entero_Cero) + 1,
                        NoCompraMes         =   IFNULL(NoCompraMes, Entero_Cero) + 1,
                        MontoCompraDiario   =   IFNULL(MontoCompraDiario, Decimal_Cero) + Par_MontoTransaccion,
                        MontoCompraMes      =   IFNULL(MontoCompraMes, Decimal_Cero) + Par_MontoTransaccion
                        WHERE TarjetaDebID  =   Par_NumeroTarjeta;

		    UPDATE TARDEBBITACORAMOVS SET
				    NumTransaccion 	= Var_NumTransaccion,
				    Estatus			= Est_Procesado
		    WHERE TipoOperacionID= Par_TipoOperacion
		      AND TarjetaDebID = Par_NumeroTarjeta
		      AND Referencia	 = Par_Referencia
		      AND TarDebMovID = Par_TardebMovID
		      AND Estatus = Est_Registrado;


                    SELECT IFNULL(SaldoDispon,Decimal_Cero), IFNULL(Saldo, Decimal_Cero)
							INTO Var_SaldoDispoAct, Var_SaldoContable
						FROM CUENTASAHO
                        WHERE CuentaAhoID = Var_CuentaAhoID;
                END IF;
            END IF;

			IF (Error_Key = Entero_Cero) THEN
				SET NumeroTransaccion	:= LPAD(CONVERT(Var_NumTransaccion, CHAR), 6, 0);
				SET SaldoContableAct	:= CONCAT('C' , LPAD(REPLACE(CONVERT(Var_SaldoContable,CHAR) , '.', ''), 12, 0));
				SET SaldoDisponibleAct	:= CONCAT('C' , LPAD(REPLACE(CONVERT(Var_SaldoDispoAct,CHAR) , '.', ''), 12, 0));
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