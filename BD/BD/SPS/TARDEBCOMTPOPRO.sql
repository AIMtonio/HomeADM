-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCOMTPOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCOMTPOPRO`;DELIMITER $$

CREATE PROCEDURE `TARDEBCOMTPOPRO`(
	-- SP que registra los movimientos de las cuentas por compra de tiempo aire
	Par_TipoOperacion			CHAR(2),
    Par_NumeroTarjeta       	CHAR(16),
	Par_Referencia				VARCHAR(12),
    Par_MontoTransaccion    	DECIMAL(12,2),
    Par_MontoAdicio         	DECIMAL(12,2),

    Par_Surcharge           	DECIMAL(12,2),
    Par_IdTerminal          	CHAR(40),
	Par_DatosTiempoAire			VARCHAR(90),
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

	-- Declaracion de variables
	DECLARE Var_CuentaAhoID 		BIGINT(12);			-- Valor del numero de la cuenta
	DECLARE Var_Referencia  		VARCHAR(50);		-- Referencia de movimiento
	DECLARE Var_DesAhorro   		VARCHAR(150);		-- Descripcion del movimiento
	DECLARE Var_SaldoDisp   		DECIMAL(12,2);		-- Saldo disponible
	DECLARE Var_SaldoDispoAct    	DECIMAL(12,2);		-- Saldo disponible actual

	DECLARE Var_MontoCom    		DECIMAL(12,2);		-- Monto de la compra
	DECLARE Var_MontoIVACom 		DECIMAL(12,2);		-- Monto del IVA de la comision
	DECLARE Var_MontoDisp   		DECIMAL(12,2);		-- Monto disponible
	DECLARE Var_NumTransaccion  	BIGINT(20);			-- Se obtiene el numero de transaccion
	DECLARE Var_BloqATM     		VARCHAR(5);			-- Valor del bloqueo por ATM

	DECLARE Var_IVA         		DECIMAL(12,2);		-- Valor del IVA de la sucursal
	DECLARE Var_MontoDispoDiario    DECIMAL(12,2); 		-- Valor del monto de disposicion diario
	DECLARE Var_LimiteDispoDiario   DECIMAL(12,2); 		-- Valor monto limite de disponibilidad diario
	DECLARE Var_MontoDispoLibre		DECIMAL(12,2);		-- Valor monto de disponibilidad libre
	DECLARE Var_Compania			CHAR(4);			-- Se obtiene el nombre la compañia

	DECLARE Var_NumCel				CHAR(10);			-- Almacena el numero de celular
	DECLARE Par_ReferenciaMov  		VARCHAR(50);		-- Referencia del movimiento
	DECLARE Var_SaldoContable		DECIMAL(12,2);		-- Saldo contable de la cuenta

	-- Declaracion de constantes
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT(11);
	DECLARE Salida_NO       	CHAR(1);
	DECLARE Salida_SI       	CHAR(1);

	DECLARE Decimal_Cero    	DECIMAL(12,2);
	DECLARE Entero_MenosUno 	INT(11);
	DECLARE Nat_Cargo       	CHAR(1);
	DECLARE Aud_EmpresaID   	INT(11);
	DECLARE Aud_Usuario     	INT(11);

	DECLARE Aud_FechaActual		DATETIME;
	DECLARE Aud_DireccionIP 	VARCHAR(15);
	DECLARE Aud_ProgramaID  	VARCHAR(50);
	DECLARE Aud_Sucursal    	INT(11);
	DECLARE Error_Key       	INT(11);

	DECLARE Mov_AhoRetEfe   	CHAR(4);
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

	-- Asignacion de constantes
	SET Con_BloqATM     	:= 1;   			-- Consulta para obtener si se bloquea ATM
	SET Con_DispoDiario     := 1;   			-- Consulta para obtener el limite de monto diario para disposicion
	SET Cadena_Vacia    	:= '';				-- Cadena vacia
	SET Fecha_Vacia     	:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero     	:= 0;				-- Entero cero

	SET Salida_NO       	:= 'N';				-- El Store NO genera una Salida
	SET Salida_SI        	:= 'S';             -- El Store SI genera una Salida
	SET Decimal_Cero    	:= 0.00;            -- DECIMAL cero
	SET Aud_EmpresaID   	:= 1;				-- Campo de Auditoria
	SET Aud_Usuario     	:= 1;				-- Campo de Auditoria

	SET Aud_DireccionIP 	:= 'localhost';			-- Campo de Auditoria
	SET Aud_ProgramaID  	:= 'workbench';			-- Campo de Auditoria
	SET Aud_Sucursal    	:= 1;					-- Campo de Auditoria
	SET Error_Key       	:= Entero_Cero;			-- Numero de error: Cero
	SET Nat_Cargo       	:= 'C';					-- Naturaleza de movimiento: Cargo

	SET Var_DesAhorro   	:= "COMPRA DE TIEMPO AIRE ATM";		-- Descripcion: Compra tiempo aire
	SET Mov_AhoRetEfe   	:= '96';        		-- Tipo de Movimiento Ahorro: Compra de Tiempo Aire
	SET Mov_AhoComRet   	:= '97';        		-- Tipo de Movimiento Ahorro: Comision Compra de Tiempo Aire
	SET Mov_AhoIVACom   	:= '98';       			-- Tipo de Movimiento Ahorro: IVA Comision de Compra de Tiempo Aire
	SET Des_ComRetiro   	:= 'COMISION COMPRA TIEMPO AIRE ATM';		-- Descripcion: Comision compra de tiempo aire

	SET Des_IVAComRet   	:= 'IVA COMISION COMPRA TIEMPO AIRE';		-- Descripcion: IVA comision compra de tiempo aire
	SET BloqATM_SI      	:= 'S';					-- Bloqueo Automatico: SI
	SET Entero_MenosUno 	:= -1;					-- Valor entero menos uno
	SET Saldo_Cero			:= 'C000000000000';		-- Saldo cero
	SET ProActualiza		:= 2;					-- Numero de actualizacion

	SET Var_Continuar 		:= Entero_Cero;			-- Valor proceso continuar
	SET Est_Procesado		:= 'P';					-- Estatus de la tarjeta: Procesado
	SET Est_Registrado		:= 'R';      			-- Estatus de Ristrado TARDEBBITACORAMOVS

	-- Se obtiene la fecha actual
	SET Aud_FechaActual	:= NOW();

    ManejoErrores: BEGIN
	SET FechaAplicacion	:=	(SELECT DATE_FORMAT(FechaSistema , '%m%d') FROM PARAMETROSSIS);

	IF (IFNULL(Par_DatosTiempoAire, Cadena_Vacia) = Cadena_Vacia ) THEN
		SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
		SET SaldoContableAct	:= Saldo_Cero;
		SET SaldoDisponibleAct	:= Saldo_Cero;
		SET CodigoRespuesta   	:= "125";
		SET FechaAplicacion		:= FechaAplicacion;
		LEAVE TerminaStore;
	END IF;


       SELECT IFNULL(FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_BloqATM), Cadena_Vacia),
              IFNULL(tar.MontoDispoDiario, Entero_MenosUno ),
              IFNULL(FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_DispoDiario), Decimal_Cero),
              tar.CuentaAhoID
	 INTO Var_BloqATM, Var_MontoDispoDiario, Var_LimiteDispoDiario, Var_CuentaAhoID
	 FROM TARJETADEBITO tar
	WHERE tar.TarjetaDebID = Par_NumeroTarjeta;

	IF (Var_BloqATM != BloqATM_SI) THEN




		SET Par_Surcharge   := IFNULL(Par_Surcharge, Decimal_Cero);
		SET Var_MontoCom    := Decimal_Cero;
		SET Var_MontoIVACom := Decimal_Cero;
		SET Var_MontoDisp   := (Par_MontoTransaccion - Par_Surcharge);



		IF (Var_LimiteDispoDiario = Decimal_Cero) THEN
			SET Var_Continuar := Entero_Cero;
		ELSE
			IF (Var_MontoDispoDiario < Var_LimiteDispoDiario) THEN
				SET Var_MontoDispoLibre = Var_LimiteDispoDiario - Var_MontoDispoDiario;
				IF (Var_MontoDisp < Var_MontoDispoLibre) THEN
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



            -- Se  asigna el valor del saldo disponible actual antes de realizar la operacion
            SELECT IFNULL(SaldoDispon,Decimal_Cero)
                    INTO Var_SaldoDisp
                FROM CUENTASAHO
				WHERE CuentaAhoID = Var_CuentaAhoID;

            -- Se efectua un cargo  a la cuenta, si la naturaleza lo indica
            IF (Var_SaldoDisp < Par_MontoTransaccion ) THEN
				SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
				SET SaldoContableAct	:= Saldo_Cero;
				SET SaldoDisponibleAct	:= Saldo_Cero;
				SET CodigoRespuesta   	:= "116";
				SET FechaAplicacion		:= FechaAplicacion;
                LEAVE ManejoErrores;
            ELSE
					SELECT IVA INTO Var_IVA
                            FROM SUCURSALES
                            WHERE SucursalID = Aud_Sucursal;

					SET Var_Compania		:= SUBSTRING(TRIM(Par_DatosTiempoAire),1, 4);
					SET Var_NumCel			:= SUBSTRING(TRIM(Par_DatosTiempoAire),5, 10);
					SET Par_ReferenciaMov	:= CONCAT("COM TPO AIRE", Var_NumCel);


		IF (Var_SaldoDisp - Par_MontoTransaccion < 0 ) THEN
				SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
				SET SaldoContableAct	:= Saldo_Cero;
				SET SaldoDisponibleAct	:= Saldo_Cero;
				SET CodigoRespuesta   	:= "116";
				SET FechaAplicacion		:= FechaAplicacion;
                LEAVE ManejoErrores;
                END IF;

                    -- Se genera un numero de transaccion
                    CALL TARDEBTRANSACPRO(Var_NumTransaccion);
                    UPDATE CUENTASAHO SET
                        CargosDia   = CargosDia     + Par_MontoTransaccion,
                        CargosMes   = CargosMes     + Par_MontoTransaccion,
                        Saldo       = Saldo         - Par_MontoTransaccion,
                        SaldoDispon = SaldoDispon   - Par_MontoTransaccion
                    WHERE CuentaAhoID = Var_CuentaAhoID;
					SET Var_DesAhorro=CONCAT(Var_DesAhorro,' ',Par_NomUbicTerminal);

                    INSERT INTO CUENTASAHOMOV(
					CuentaAhoID,	NumeroMov,	Fecha,		NatMovimiento,	CantidadMov,
					DescripcionMov,	ReferenciaMov,	TipoMovAhoID,	MonedaID,	PolizaID,
					EmpresaID, 	Usuario,	FechaActual,	DireccionIP, 	ProgramaID,
					Sucursal,	NumTransaccion)
				VALUES(	Var_CuentaAhoID,Var_NumTransaccion,	Par_FechaActual,	Nat_Cargo,	Par_MontoTransaccion,
					Var_DesAhorro,	Par_ReferenciaMov,	Mov_AhoRetEfe,		Par_MonedaID,	Entero_Cero,
					Aud_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,
					Aud_Sucursal,	Var_NumTransaccion);

                    -- Actualiza Numero de Disposiciones por Dia, por Mes, y Montos de Disposicion
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
						  AND TarDebMovID = Par_TardebMovID
			                          AND Estatus = Est_Registrado;



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
		SET CodigoRespuesta   	:= "412";
		SET FechaAplicacion		:= FechaAplicacion;
        LEAVE TerminaStore;
    END IF;

    END ManejoErrores;  -- END del Handler de Errores
END TerminaStore$$