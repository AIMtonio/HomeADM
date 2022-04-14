-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBRETEFEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBRETEFEPRO`;DELIMITER $$

CREATE PROCEDURE `TARDEBRETEFEPRO`(

	Par_TipoOperacion			CHAR(2),
    Par_NumeroTarjeta       	CHAR(16),
	Par_Referencia				VARCHAR(12),
    Par_MontoTransaccion    	DECIMAL(12,2),
    Par_MontoAdicio         	DECIMAL(12,2),

    Par_Surcharge           	DECIMAL(12,2),
    Par_LoyaltyFee          	DECIMAL(12,2),
    Par_MonedaID            	INT(11),
    Par_NumTransaccion      	VARCHAR(10),
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


	DECLARE Var_LimiteNumRetiros	INT(11);
	DECLARE Var_DispoDiario			INT(11);
	DECLARE Var_MontoDispoMes		DECIMAL(12,2);
	DECLARE Var_LimiteDispoMes		DECIMAL(12,2);
	DECLARE Var_MontoDispoMesLibre	DECIMAL(12,2);

	DECLARE Var_Saldo				DECIMAL(12,2);
	DECLARE Var_SaldoDispon			DECIMAL(12,2);
	DECLARE Var_MontoDispoLibre		DECIMAL(12,2);
	DECLARE Var_MontoCom    		DECIMAL(12,2);
	DECLARE Var_MontoIVACom 		DECIMAL(12,2);

	DECLARE Var_MontoDisp   		DECIMAL(12,2);
	DECLARE Var_NumTransaccion  	BIGINT(20);
	DECLARE Var_CuentaAhoID 		BIGINT(12);
	DECLARE Var_Referencia  		VARCHAR(50);
	DECLARE Var_SaldoDisp   		DECIMAL(12,2);

	DECLARE Var_SaldoDispoAct    	DECIMAL(12,2);
	DECLARE Var_IVA         		DECIMAL(12,2);
	DECLARE Var_BloqATM     		VARCHAR(5);
	DECLARE Var_MontoDispoDiario    DECIMAL(12,2);
	DECLARE Var_LimiteDispoDiario   DECIMAL(12,2);

	DECLARE Var_SaldoContable		DECIMAL(12,2);


	DECLARE Cadena_Vacia   	 	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT(11);
	DECLARE Entero_Uno			INT(11);
	DECLARE Salida_NO       	CHAR(1);

	DECLARE Salida_SI       	CHAR(1);
	DECLARE Decimal_Cero    	DECIMAL(12,2);
	DECLARE Entero_MenosUno 	INT(11);
	DECLARE Nat_Cargo       	CHAR(1);
	DECLARE Par_ReferenciaMov  	VARCHAR(50);

	DECLARE Aud_EmpresaID   	INT(11);
	DECLARE Aud_FechaActual		DATETIME;
	DECLARE Aud_Usuario     	INT(11);
	DECLARE Aud_DireccionIP 	VARCHAR(15);
	DECLARE Aud_ProgramaID  	VARCHAR(25);

	DECLARE Aud_Sucursal    	INT(11);
	DECLARE Error_Key       	INT(11);
	DECLARE Mov_AhoRetiro   	VARCHAR(50);
	DECLARE Mov_AhoRetEfe  	 	CHAR(4);
	DECLARE Mov_AhoComRet   	CHAR(4);

	DECLARE Mov_AhoIVACom   	CHAR(4);
	DECLARE Des_ComRetiro   	VARCHAR(50);
	DECLARE Des_IVAComRet   	VARCHAR(50);
	DECLARE BloqATM_SI      	CHAR(1);
	DECLARE Saldo_Cero			VARCHAR(13);

	DECLARE ProActualiza		INT(11);
	DECLARE Var_Continuar		INT(11);
	DECLARE Est_Procesado		CHAR(1);
	DECLARE Est_Registrado		CHAR(1);
	DECLARE Con_BloqATM         INT(11);

	DECLARE Con_DispoDiario     INT(11);
	DECLARE Con_NumDispoDia     INT(11);
	DECLARE Con_DispoMes        INT(11);
	DECLARE Var_DesAhorro   	VARCHAR(150);


	SET Con_BloqATM     	:= 1;
	SET Con_DispoDiario     := 1;
	SET Con_NumDispoDia     := 1;
	SET Con_DispoMes        := 2;
	SET Cadena_Vacia    	:= '';

	SET Fecha_Vacia     	:= '1900-01-01';
	SET Entero_Cero     	:= 0;
	SET Entero_Uno			:= 1;
	SET Salida_NO       	:= 'N';
	SET Salida_SI        	:= 'S';

	SET Decimal_Cero    	:= 0.00;
	SET Aud_EmpresaID   	:= 1;
	SET Aud_Usuario     	:= 1;
	SET Aud_DireccionIP 	:= 'localhost';
	SET Aud_ProgramaID  	:= 'workbench';

	SET Aud_Sucursal    	:= 1;
	SET Error_Key       	:= Entero_Cero;
	SET Nat_Cargo       	:= 'C';
	SET Var_DesAhorro   	:= "RETIRO CON TARJETA DE DEBITO";
	SET Mov_AhoRetEfe   	:= '20';

	SET Mov_AhoComRet   	:= '21';
	SET Mov_AhoIVACom   	:= '22';
	SET Des_ComRetiro   	:= 'COMISION POR RETIRO';
	SET Des_IVAComRet   	:= 'IVA COMISION POR RETIRO';
	SET BloqATM_SI      	:= 'S';

	SET Entero_MenosUno 	:= -1;
	SET Saldo_Cero			:= 'C000000000000';
	SET ProActualiza		:= 2;
	SET Var_Continuar 		:= Entero_Cero;
	SET Est_Procesado		:= 'P';

	SET Est_Registrado		:= 'R';


	SET Aud_FechaActual	:= NOW();


    ManejoErrores: BEGIN
	SET FechaAplicacion	:=	(SELECT DATE_FORMAT(FechaSistema , '%m%d') FROM PARAMETROSSIS);

     SELECT IFNULL(FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_BloqATM), Cadena_Vacia),
            IFNULL(tar.MontoDispoDiario, Decimal_Cero),
            IFNULL(FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_DispoDiario), Decimal_Cero),
            IFNULL(FUNCIONLIMITENUM(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_NumDispoDia), Entero_Cero),
            IFNULL(tar.NoDispoDiario, Entero_Cero),
            IFNULL(tar.MontoDispoMes, Decimal_Cero),
            IFNULL(FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_DispoMes), Decimal_Cero),
            CuentaAhoID
       INTO Var_BloqATM, Var_MontoDispoDiario, Var_LimiteDispoDiario, Var_LimiteNumRetiros, Var_DispoDiario, Var_MontoDispoMes, Var_LimiteDispoMes, Var_CuentaAhoID
	  FROM TARJETADEBITO tar
	 WHERE tar.TarjetaDebID = Par_NumeroTarjeta;



	IF (Var_BloqATM != BloqATM_SI) THEN


		IF (Var_LimiteNumRetiros != Entero_Cero ) THEN
			SET Var_DispoDiario	:= Var_DispoDiario + Entero_Uno;
			IF (Var_DispoDiario > Var_LimiteNumRetiros ) THEN
				SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
				SET SaldoContableAct	:= Saldo_Cero;
				SET SaldoDisponibleAct	:= Saldo_Cero;
				SET CodigoRespuesta   	:= "121";
				SET FechaAplicacion		:= FechaAplicacion;
				LEAVE ManejoErrores;
			END IF;
		END IF;


		SET Par_Surcharge   := IFNULL(Par_Surcharge, Decimal_Cero);
		SET Par_LoyaltyFee  := IFNULL(Par_LoyaltyFee, Decimal_Cero);
		SET Var_MontoCom    := Decimal_Cero;
		SET Var_MontoIVACom := Decimal_Cero;
		SET Var_MontoDisp   := (Par_MontoTransaccion - Par_Surcharge);

		IF (Var_LimiteDispoDiario = Decimal_Cero) THEN
			SET Var_Continuar := Entero_Cero;
		ELSE

			IF (Var_MontoDispoDiario < Var_LimiteDispoDiario) THEN
				SET Var_MontoDispoLibre = Var_LimiteDispoDiario - Var_MontoDispoDiario;

				IF (Var_MontoDisp <= Var_MontoDispoLibre) THEN
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

			IF (Var_MontoDispoMes < Var_LimiteDispoMes) THEN
				SET Var_MontoDispoMesLibre := Var_LimiteDispoMes - Var_MontoDispoMes;
				IF (Var_MontoDisp <= Var_MontoDispoMesLibre) THEN
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

		IF ( Var_Continuar = Entero_Cero) THEN
			IF (IFNULL(Par_MontoTransaccion, Decimal_Cero) = Decimal_Cero )THEN
			    SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
			    SET SaldoContableAct	:= Saldo_Cero;
			    SET SaldoDisponibleAct	:= Saldo_Cero;
			    SET CodigoRespuesta   	:= "110";
			    SET FechaAplicacion		:= FechaAplicacion;
			    LEAVE ManejoErrores;
			END IF;



		      SET Par_ReferenciaMov  := CONCAT("TAR **** ", SUBSTRING(Par_NumeroTarjeta,13, 4));


		      SELECT IFNULL(SaldoDispon,Decimal_Cero)
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


		      IF (Var_SaldoDisp < Par_MontoTransaccion ) THEN
			  SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
			  SET SaldoContableAct	:= Saldo_Cero;
			  SET SaldoDisponibleAct	:= Saldo_Cero;
			  SET CodigoRespuesta   	:= "116";
			  SET FechaAplicacion		:= FechaAplicacion;
			  LEAVE ManejoErrores;
		      ELSE

		      IF (Var_SaldoDisp-Par_MontoTransaccion < 0 ) THEN
			  SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
			  SET SaldoContableAct	:= Saldo_Cero;
			  SET SaldoDisponibleAct	:= Saldo_Cero;
			  SET CodigoRespuesta   	:= "116";
			  SET FechaAplicacion		:= FechaAplicacion;
			  LEAVE ManejoErrores;
		     END IF;



			  CALL TARDEBTRANSACPRO(Var_NumTransaccion);
			  UPDATE CUENTASAHO SET
			      CargosDia   = CargosDia     + Par_MontoTransaccion,
			      CargosMes   = CargosMes     + Par_MontoTransaccion,
			      Saldo       = Saldo         - Par_MontoTransaccion,
			      SaldoDispon = SaldoDispon   - Par_MontoTransaccion
			  WHERE CuentaAhoID = Var_CuentaAhoID;

			  SET Var_DesAhorro=CONCAT(Var_DesAhorro,' ',Par_NomUbicTerminal);

			  INSERT  INTO CUENTASAHOMOV(
					CuentaAhoID,		NumeroMov,				Fecha,				NatMovimiento,		CantidadMov,
					DescripcionMov,		ReferenciaMov,			TipoMovAhoID,		MonedaID,			PolizaID,
					EmpresaID,			Usuario,				FechaActual,		DireccionIP, 		ProgramaID,
					Sucursal,			NumTransaccion)

			  VALUES(
					Var_CuentaAhoID,  	Var_NumTransaccion, 	Par_FechaActual,	Nat_Cargo,      	Var_MontoDisp,
					Var_DesAhorro,    	Par_ReferenciaMov,  	Mov_AhoRetEfe,		Par_MonedaID,   	Entero_Cero,
					Aud_EmpresaID,		Aud_Usuario,        	Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,		Var_NumTransaccion);


			      IF(Par_Surcharge > Decimal_Cero ) THEN

				  SELECT IVA INTO Var_IVA
				      FROM SUCURSALES
				      WHERE SucursalID = Aud_Sucursal;

				  SET Var_MontoIVACom := ROUND(Par_Surcharge / (1 + Var_IVA) * Var_IVA, 2);
				  SET Var_MontoCom    := Par_Surcharge - Var_MontoIVACom;

				  INSERT INTO CUENTASAHOMOV(
							CuentaAhoID,	     	NumeroMov,	            Fecha,				NatMovimiento,		CantidadMov,
							DescripcionMov,	 		ReferenciaMov,			TipoMovAhoID,		MonedaID,	  		PolizaID,
                            EmpresaID, 				Usuario,			 	FechaActual,		DireccionIP, 		ProgramaID,
                            Sucursal,             	NumTransaccion)
					VALUES(
							Var_CuentaAhoID,    	Var_NumTransaccion, 	Par_FechaActual,    Nat_Cargo,       	Var_MontoCom,
							Des_ComRetiro,      	Par_ReferenciaMov,  	Mov_AhoComRet,      Par_MonedaID,    	Entero_Cero,
							Aud_EmpresaID,      	Aud_Usuario,       	 	Aud_FechaActual,    Aud_DireccionIP, 	Aud_ProgramaID,
							Aud_Sucursal,       	Var_NumTransaccion);

				  INSERT INTO CUENTASAHOMOV(
							CuentaAhoID,			NumeroMov,				Fecha,				NatMovimiento,		CantidadMov,
							DescripcionMov,			ReferenciaMov,			TipoMovAhoID,		MonedaID,			PolizaID,
							EmpresaID,				Usuario,				FechaActual,		DireccionIP, 		ProgramaID,
							Sucursal,				NumTransaccion)
					VALUES(
							Var_CuentaAhoID,    	Var_NumTransaccion, 	Par_FechaActual,    Nat_Cargo,       	Var_MontoIVACom,
							Des_IVAComRet,      	Par_ReferenciaMov,  	Mov_AhoIVACom,      Par_MonedaID,    	Entero_Cero,
							Aud_EmpresaID,      	Aud_Usuario,        	Aud_FechaActual,    Aud_DireccionIP, 	Aud_ProgramaID,
							Aud_Sucursal,       	Var_NumTransaccion);

		      END IF;


		      UPDATE TARJETADEBITO SET
			  NoDispoDiario       =   IFNULL(NoDispoDiario, Entero_Cero)  + 1,
			  NoDispoMes          =   IFNULL(NoDispoMes, Entero_Cero)     + 1,
			  MontoDispoDiario    =   IFNULL(MontoDispoDiario, Decimal_Cero)  + Par_MontoTransaccion,
			  MontoDispoMes       =   IFNULL(MontoDispoMes, Decimal_Cero)     + Par_MontoTransaccion
			  WHERE TarjetaDebID  =   Par_NumeroTarjeta;

		      UPDATE TARDEBBITACORAMOVS SET
			      NumTransaccion	= Var_NumTransaccion,
			      Estatus 		= Est_Procesado
		      WHERE TipoOperacionID	= Par_TipoOperacion
			AND Referencia 		= Par_Referencia
			AND TarjetaDebID 	= Par_NumeroTarjeta
			AND TarDebMovID      = Par_TardebMovID
			AND Estatus             = Est_Registrado;

		      SELECT IFNULL(SaldoDispon,Decimal_Cero), IFNULL(Saldo, Decimal_Cero)
			INTO Var_SaldoDispoAct, Var_SaldoContable
			FROM CUENTASAHO
			WHERE CuentaAhoID = Var_CuentaAhoID;

		END IF;
	END IF;

	IF Error_Key = Entero_Cero THEN
		SET NumeroTransaccion	:= LPAD(CONVERT(Var_NumTransaccion, CHAR), 6, 0);
		SET SaldoContableAct	:= CONCAT('C' , LPAD(REPLACE(CONVERT(Var_SaldoContable,CHAR) , '.', ''), 12, 0));
		SET SaldoDisponibleAct	:= CONCAT('C' , LPAD(REPLACE(CONVERT(Var_SaldoDispoAct,CHAR) , '.', ''), 12, 0));
		SET CodigoRespuesta   	:= "000";
		SET FechaAplicacion		:= FechaAplicacion;
	ELSE
		SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
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
		SET CodigoRespuesta   	:= "414";
		SET FechaAplicacion		:= FechaAplicacion;
        LEAVE TerminaStore;
    END IF;

    END ManejoErrores;
END TerminaStore$$