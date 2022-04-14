-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBPREAUTORIZAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBPREAUTORIZAPRO`;DELIMITER $$

CREATE PROCEDURE `TARDEBPREAUTORIZAPRO`(
	-- Se preautoriza las compras realizadas con tarjetas
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

	INOUT NumeroTransaccion		VARCHAR(6),
	INOUT SaldoContableAct		VARCHAR(13),
	INOUT SaldoDisponibleAct	VARCHAR(13),
	INOUT CodigoRespuesta 	  	VARCHAR(3),
	INOUT FechaAplicacion		VARCHAR(4),

	Par_TardebMovID				INT(11)  -- Id llave de la tabla TARDEBBITACORAMOVS con la cual se esta realizando la
                                         -- preautorizacion de la transaccion.
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_CuentaAhoID 		BIGINT(12);			-- Numero de cuenta del cliente
	DECLARE Var_ClienteID   		INT(11);			-- Numero del cliente
	DECLARE Var_Referencia  		VARCHAR(50);		-- Referencia del movimiento
	DECLARE Var_DesAhorro   		VARCHAR(50);		-- Descripcion del movimientos
	DECLARE Var_SaldoDisp   		DECIMAL(12,2);		-- Saldo disponible de la cuenta

	DECLARE Var_SaldoDispoAct		DECIMAL(12,2);		-- Saldo disponible actual de la cuenta
	DECLARE Var_SaldoContable		DECIMAL(12,2);		-- Saldo contable
	DECLARE Var_NumTransaccion      BIGINT(20);			-- Numero de transaccion
	DECLARE Var_MontoCompraDiario   DECIMAL(12,2);		-- Monto de compra diario con tarjetas
	DECLARE Var_LimiteCompraDiario  DECIMAL(12,2);		-- Monto de limite de compra diario con tarjetas

	DECLARE Var_BloqueID            INT(11);			-- Valor del bloqueo por compra POS
	DECLARE Var_NatMovimiento       CHAR(1);			-- Naturaleza del movimiento: Bloqueo
	DECLARE Var_TipoBloqID          INT(11);			-- Tipo Bloqueo: Compra con tarjeta
	DECLARE Var_Continuar			INT(11);            -- Indica el proceso a jecutar
	DECLARE Var_MontoCompLibre		DECIMAL(12,2);      -- Valor del monto de compra libre

	DECLARE Var_MontoCompraMes		DECIMAL(12,2);		-- Valor del monto de compras al mes
	DECLARE Var_LimiteCompraMes		DECIMAL(12,2);		-- Valor del monto limite de compras al mes
	DECLARE Var_DesBloq				VARCHAR(40);        -- Descripcion de bloqueo por compras
	DECLARE Var_TipoTarjetaDeb      INT(11);			-- valor del tipo de tarjeta de debito

	-- Declaracion de constantes
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Entero_Cero     	INT(11);
	DECLARE Salida_NO       	CHAR(1);
	DECLARE Salida_SI       	CHAR(1);
	DECLARE Decimal_Cero    	DECIMAL(12,2);

	DECLARE CompraEnLineaSI 	CHAR(1);
	DECLARE CompraEnLineaNO 	CHAR(1);
	DECLARE Nat_Cargo			CHAR(1);
	DECLARE Aud_EmpresaID       INT(11);
	DECLARE Aud_Usuario         INT(11);

	DECLARE Aud_DireccionIP     VARCHAR(15);
	DECLARE Aud_ProgramaID      VARCHAR(50);
	DECLARE Aud_Sucursal        INT(11);
	DECLARE Aud_FechaActual		DATETIME;
	DECLARE Mov_AhoCompra       VARCHAR(50);

	DECLARE Error_Key           INT(11);
	DECLARE Var_BloqPOS         VARCHAR(5);
	DECLARE BloqPOS_SI          CHAR(1);
	DECLARE Entero_MenosUno     INT(11);
	DECLARE Val_Giro            CHAR(4);

	DECLARE Fecha_Vacia			DATE;
	DECLARE Saldo_Cero			VARCHAR(13);
	DECLARE ProActualiza		INT(11);
	DECLARE Est_Procesado		CHAR(1);
	DECLARE Est_Registrado		CHAR(1);

	DECLARE Con_BloqPOS         INT(11);
	DECLARE Con_CompraDiario    INT(11);
	DECLARE Con_DispoDiario     INT(11);
	DECLARE Con_CompraMes       INT(11);
	DECLARE Con_DispoMes        INT(11);

	DECLARE BloqueoSaldo		CHAR(1);
	DECLARE TipBloqTarjeta		INT(11);

	-- Declaracion de constantes
	SET Con_BloqPOS     	:= 2;   			-- Consulta para obtener si se bloquea POS
	SET Con_CompraDiario	:= 3;   			-- Consulta para obtener el limite de monto diario para compra
	SET Con_DispoDiario     := 1;   			-- Consulta para obtener el limite de monto diario para disposicion
	SET Con_CompraMes       := 4;   			-- Consulta para obtener el limite de monto mensual para compra
	SET Con_DispoMes        := 2;   			-- Consulta para obtener el limite de monto mensual para disposicion

	SET Cadena_Vacia    	:= '';  			-- Cadena vacia
	SET Entero_Cero     	:= 0;				-- Entero cero
	SET Salida_NO       	:= 'N';				-- Tipo de salida: NO
	SET Salida_SI       	:= 'S';				-- Tipo de salida: SI
	SET Decimal_Cero    	:= 0.00;   			-- DECIMAL cero

	SET Saldo_Cero			:= 'C000000000000';	-- Saldo cero
	SET CompraEnLineaSI 	:= 'S';				-- Compra en linea: SI
	SET Nat_Cargo       	:= 'C';				-- Naturaleza de movimiento: Cargo
	SET Mov_AhoCompra   	:= '17';   			-- Numero de Movimiento de compras
	SET Aud_EmpresaID   	:= 1;       		-- Numero de empresa que realiza la transaccion

	SET Aud_Usuario     	:= 1;			  	-- Numero de usuario que realiza la transaccion
	SET Aud_DireccionIP 	:= 'localhost';   	-- Numero de direccion que realiza la transaccion
	SET Aud_ProgramaID  	:= 'workbench';   	-- Nombre del recurso que realiza la transaccion
	SET Aud_Sucursal    	:= 1;			  	-- Numero de sucursal que realiza la transaccion
	SET Error_Key       	:= Entero_Cero;   	-- Clave erroneo: Entero cero

	SET BloqPOS_SI      	:= 'S';       		-- Bloqueo POS: SI
	SET Entero_MenosUno 	:= -1;				-- Valor entero menos 1
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
	SET ProActualiza		:= 2;				-- Proceso de actualizacion
	SET Est_Procesado		:= 'P';       		-- Estatus: Procesado

	SET Est_Registrado		:= 'R';		  		-- Estatus de Ristrado TARDEBBITACORAMOVS
	SET BloqueoSaldo        := 'B';				-- Bloqueo de Saldo
	SET TipBloqTarjeta      := 3;				-- Tipo Bloqueo :Tarjeta Debito

	-- Asignacion de variables
	SET Var_Continuar 	:= Entero_Cero;
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


           SELECT CuentaAhoID,
	  TipoTarjetaDebID,
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

                    CALL TARDEBTRANSACPRO(Var_NumTransaccion);


                    IF (Par_CompraPOSLinea = CompraEnLineaSI) THEN
                        UPDATE  CUENTASAHO  SET
                            SaldoDispon     =   SaldoDispon - Par_MontoTransaccion,
                            SaldoBloq       =   SaldoBloq   + Par_MontoTransaccion
                        WHERE   CuentaAhoID =   Var_CuentaAhoID;


                        SET Var_BloqueID := (SELECT IFNULL(MAX(BloqueoID),Entero_Cero) + 1 FROM BLOQUEOS);
                        SET Var_NatMovimiento := BloqueoSaldo;
                        SET Var_TipoBloqID  := TipBloqTarjeta;
						SET Var_DesBloq		:= 'BLOQUEO POR COMPRA POS: CHECKIN';

                        INSERT INTO BLOQUEOS (
                            BloqueoID,      CuentaAhoID,    NatMovimiento,  FechaMov,       MontoBloq,
                            FechaDesbloq,   TiposBloqID,    Descripcion,    Referencia,     FolioBloq,
                            EmpresaID,      Usuario,        FechaActual,    DireccionIP,    ProgramaID,
							Sucursal,		NumTransaccion )
                        VALUES(
                            Var_BloqueID,   Var_CuentaAhoID,    Var_NatMovimiento,      Par_FechaActual,    Par_MontoTransaccion,
                            Fecha_Vacia,    Var_TipoBloqID,     UPPER(Var_DesBloq),   Var_NumTransaccion, Entero_Cero,
                            Aud_EmpresaID,  Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                            Aud_Sucursal,   Var_NumTransaccion);



                    ELSE

                        SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= "501";
						SET FechaAplicacion		:= FechaAplicacion;
						LEAVE TerminaStore;
                    END IF;

					UPDATE TARDEBBITACORAMOVS SET
						   NumTransaccion 	= Var_NumTransaccion,
						   Estatus			= Est_Procesado
					 WHERE TipoOperacionID	= Par_TipoOperacion
					   AND Referencia	 	= Par_Referencia
					   AND TarjetaDebID 	= Par_NumeroTarjeta
					   AND NumTransaccion 	= Entero_Cero
					   AND Estatus = Est_Registrado
                       AND TardebMovID = Par_TardebMovID;

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