-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONSALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCONSALPRO`;
DELIMITER $$


CREATE PROCEDURE `TARDEBCONSALPRO`(
	-- SP creado para el registro de movimientos de la cuenta por consulta de saldos
	Par_TipoOperacion			CHAR(2),
    Par_NumeroTarjeta       	CHAR(16),
	Par_Referencia				VARCHAR(12),
    Par_MontoTransaccion    	DECIMAL(12,2),
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

TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE Var_CuentaAhoID 	BIGINT(12);			-- Valor del numero de la cuenta
	DECLARE Var_SaldoDisp   	DECIMAL(12,2);		-- Valor del saldo disponible
	DECLARE Var_SaldoDispoAct	DECIMAL(12,2);		-- Valor del saldo disponible actual
	DECLARE Var_SaldoContable	DECIMAL(12,2);		-- Valor del saldo contable de la cuenta

	DECLARE Var_NumTransaccion  BIGINT(20);			-- Se obtiene el numero de transaccion
	DECLARE Var_MontoCom    	DECIMAL(12,2);		-- Valor del monto de la comision
	DECLARE Var_MontoIVACom 	DECIMAL(12,2);		-- Valor del IVA del monto de la comision
	DECLARE Var_IVA         	DECIMAL(12,2);		-- Valor del IVA
	DECLARE Var_BloqATM     	VARCHAR(5);			-- Valor del limite para bloqueo ATM

	DECLARE Var_LimiteNumConMes	INT(11);			-- Valor del liminte de numero de consultas con tarjetas
	DECLARE Var_NumConSalMes	INT(11);			-- Valor de numero de consulta de salos al mes con tarjetas

	-- Declaracion de constantes
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Entero_Cero     	INT(11);
	DECLARE Entero_Uno			INT(11);
	DECLARE Salida_NO       	CHAR(1);
	DECLARE Salida_SI       	CHAR(1);

	DECLARE Decimal_Cero    	DECIMAL(12,2);
	DECLARE CompraEnLineaSI 	CHAR(1);
	DECLARE Nat_Cargo       	CHAR(1);
	DECLARE Aud_EmpresaID   	INT(11);
	DECLARE Aud_Usuario     	INT(11);

	DECLARE Aud_FechaActual		DATETIME;
	DECLARE Aud_DireccionIP 	VARCHAR(15);
	DECLARE Aud_ProgramaID  	VARCHAR(50);
	DECLARE Aud_Sucursal    	INT(11);
	DECLARE Error_Key       	INT(11);

	DECLARE Par_ReferenciaMov   VARCHAR(50);
	DECLARE Mov_AhoComRet   	CHAR(4);
	DECLARE Mov_AhoIVACom   	CHAR(4);
	DECLARE Des_ComCons     	VARCHAR(500);
	DECLARE Des_IVAComCon   	VARCHAR(500);

	DECLARE BloqATM_SI      	CHAR(1);
	DECLARE Saldo_Cero			VARCHAR(13);
	DECLARE ProActualiza		INT(11);
	DECLARE Est_Procesado		CHAR(1);
	DECLARE Est_Registrado		CHAR(1);

	DECLARE Con_BloqATM         INT(11);

	-- Asignacion de constantes
	SET Con_BloqATM     	:= 1;   				-- Consulta para obtener si se bloquea ATM
	SET Cadena_Vacia    	:= '';					-- Cadena vacia
	SET Entero_Cero     	:= 0;					-- Entero cero
	SET	Entero_Uno			:= 1;					-- Entero uno
	SET Salida_NO       	:= 'N';					-- El Store NO genera una Salida
	SET Salida_SI       	:= 'S';					-- El Store SI genera una Salida

	SET Decimal_Cero    	:= 0.00;				-- DECIMAL cero
	SET Saldo_Cero			:= 'C000000000000';		-- Saldo cero
	SET CompraEnLineaSI 	:= 'S';					-- Compra en linea: SI
	SET Aud_EmpresaID   	:= 1;					-- Campo de Auditoria
	SET Aud_Usuario     	:= 1;					-- Campo de Auditoria

	SET Aud_DireccionIP 	:= 'localhost';			-- Campo de Auditoria
	SET Aud_ProgramaID  	:= 'workbench';			-- Campo de Auditoria
	SET Aud_Sucursal    	:= 1;					-- Campo de Auditoria
	SET Error_Key       	:= Entero_Cero;         -- Numero de error: Cero
	SET Nat_Cargo       	:= 'C';					-- Naturaleza de movimiento: Cargo

	SET Par_ReferenciaMov  	:= CONCAT("TAR **** ", SUBSTRING(Par_NumeroTarjeta,13, 4));
	SET Mov_AhoComRet   	:= '86';        		-- Numero de movimiento correspondiente a comision
	SET Mov_AhoIVACom   	:= '88';      			-- Numero de movimiento correspondiente a IVA de comision
	SET Des_ComCons     	:= 'COMISION POR CONSULTA SALDO TD';		-- Descripcion: Comision por consulta de saldo
	SET Des_IVAComCon   	:= 'IVA COMISION POR CONSULTA SALDO TD';	-- Descripcion:  IVA comision consulta de saldo

	SET BloqATM_SI      	:= 'S';					-- Bloquero ATM: SI
	SET ProActualiza		:= 2;					-- Proceso de actualizacion
	SET Est_Procesado		:= 'P';					-- Estatus Procesado
	SET Est_Registrado		:= 'R';      			-- Estatus de Ristrado TARDEBBITACORAMOVS

	-- Se obtiene la fecha actual
	SET Aud_FechaActual		:= NOW();

	-- Se obtiene la fecha del sistema
	SET FechaAplicacion	:=	(SELECT DATE_FORMAT(FechaSistema , '%m%d') FROM PARAMETROSSIS);

    		SELECT tar.CuentaAhoID, IFNULL(FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_BloqATM), Cadena_Vacia)
 		  INTO Var_CuentaAhoID, Var_BloqATM
                  FROM TARJETADEBITO tar
                 WHERE tar.TarjetaDebID = Par_NumeroTarjeta;

    IF (Var_BloqATM != BloqATM_SI) THEN

        IF ( Par_MontoTransaccion > Decimal_Cero ) THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "412";
			SET FechaAplicacion		:= FechaAplicacion;
            LEAVE TerminaStore;
        END IF;

            CALL TARDEBTRANSACPRO(Var_NumTransaccion);

            IF (Par_Surcharge > Decimal_Cero ) THEN

                SET Par_Surcharge   := IFNULL(Par_Surcharge, Entero_Cero);
                SET Par_LoyaltyFee  := IFNULL(Par_LoyaltyFee, Entero_Cero);
                SET Var_MontoCom    := Decimal_Cero;
                SET Var_MontoIVACom := Decimal_Cero;


                SELECT IFNULL(SaldoDispon,Decimal_Cero)      INTO Var_SaldoDisp
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

                IF ( Var_SaldoDisp < Par_Surcharge ) THEN
					SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
					SET SaldoContableAct	:= Saldo_Cero;
					SET SaldoDisponibleAct	:= Saldo_Cero;
					SET CodigoRespuesta   	:= "116";
					SET FechaAplicacion		:= FechaAplicacion;
                    LEAVE TerminaStore;
                ELSE
                    UPDATE CUENTASAHO SET
                        CargosDia   = CargosDia + Par_Surcharge,
                        CargosMes   = CargosMes + Par_Surcharge,
                        Saldo       = Saldo     - Par_Surcharge,
                        SaldoDispon = SaldoDispon - Par_Surcharge
                    WHERE CuentaAhoID = Var_CuentaAhoID;

                    SELECT IVA INTO Var_IVA
                        FROM SUCURSALES
                        WHERE SucursalID = Aud_Sucursal;

                    SET Var_MontoIVACom := ROUND(Par_Surcharge / (1 + Var_IVA) * Var_IVA, 2);
                    SET Var_MontoCom    := Par_Surcharge - Var_MontoIVACom;

					SET Des_ComCons = CONCAT(Des_ComCons,' ',Par_NomUbicTerminal);


					INSERT INTO CUENTASAHOMOV	(
					CuentaAhoID,					NumeroMov,					Fecha,					NatMovimiento,					CantidadMov,
					DescripcionMov,					ReferenciaMov,				TipoMovAhoID,			MonedaID,						PolizaID,
					EmpresaID,						Usuario,					FechaActual,			DireccionIP,					ProgramaID,
					Sucursal,						NumTransaccion)
					VALUES	(
                        Var_CuentaAhoID, 	Var_NumTransaccion, 	Par_FechaActual, 	Nat_Cargo,       Var_MontoCom,
                        Des_ComCons,     	Par_ReferenciaMov,  	Mov_AhoComRet,   	Par_MonedaID,    Entero_Cero,
                        Aud_EmpresaID,   	Aud_Usuario,        	Aud_FechaActual, 	Aud_DireccionIP, Aud_ProgramaID,
                        Aud_Sucursal,    	Var_NumTransaccion);

					SET Des_IVAComCon = CONCAT(Des_IVAComCon,' ',Par_NomUbicTerminal);
					INSERT INTO CUENTASAHOMOV	(
					CuentaAhoID,					NumeroMov,					Fecha,					NatMovimiento,					CantidadMov,
					DescripcionMov,					ReferenciaMov,				TipoMovAhoID,			MonedaID,						PolizaID,
					EmpresaID,						Usuario,					FechaActual,			DireccionIP,					ProgramaID,
					Sucursal,						NumTransaccion)
					VALUES	(
                        Var_CuentaAhoID, 	Var_NumTransaccion, 	Par_FechaActual,    Nat_Cargo,       Var_MontoIVACom,
						Des_IVAComCon,   	Par_ReferenciaMov,  	Mov_AhoIVACom,      Par_MonedaID,    Entero_Cero,
						Aud_EmpresaID,   	Aud_Usuario,        	Aud_FechaActual,    Aud_DireccionIP, Aud_ProgramaID,
						Aud_Sucursal,    	Var_NumTransaccion);
                END IF;
            END IF;


            UPDATE TARJETADEBITO SET
                NoConsultaSaldoMes  =   IFNULL(NoConsultaSaldoMes, Entero_Cero)  + 1,
                MontoDispoDiario    =   IFNULL(MontoDispoDiario, Decimal_Cero)  + Par_Surcharge,
                MontoDispoMes       =   IFNULL(MontoDispoMes, Decimal_Cero)     + Par_Surcharge
                WHERE TarjetaDebID  =   Par_NumeroTarjeta;

			UPDATE TARDEBBITACORAMOVS SET
				NumTransaccion	= Var_NumTransaccion,
				Estatus			= Est_Procesado
				WHERE TipoOperacionID	= Par_TipoOperacion
					AND Referencia 		= Par_Referencia
					AND TarjetaDebID 	= Par_NumeroTarjeta
					AND TarDebMovID = Par_TardebMovID
		            AND Estatus = Est_Registrado;


			SELECT IFNULL(SaldoDispon,Decimal_Cero), IFNULL(Saldo, Decimal_Cero)
					INTO Var_SaldoDispoAct, Var_SaldoContable
				FROM CUENTASAHO
				WHERE CuentaAhoID = Var_CuentaAhoID;

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

END TerminaStore$$
