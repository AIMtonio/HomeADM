-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBREVPREAUTORIZA
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBREVPREAUTORIZA`;DELIMITER $$

CREATE PROCEDURE `TARDEBREVPREAUTORIZA`(

	Par_TipoOperacion			CHAR(2),
    Par_NumeroTarjeta      	 	CHAR(16),
	Par_Referencia				VARCHAR(12),
    Par_MontoTransaccion    	DECIMAL(12,2),
    Par_MontoAdicio         	DECIMAL(12,2),

    Par_GiroNegocio         	CHAR(4),
    Par_MonedaID            	INT(11),
    Par_NumTransaccion      	VARCHAR(10),
    Par_CompraPOSLinea      	CHAR(1),
	Par_CodigoAprobacion		VARCHAR(6),

    Par_FechaActual         	DATETIME,
	INOUT NumeroTransaccion		VARCHAR(6),
	INOUT SaldoContableAct		VARCHAR(13),
	INOUT SaldoDisponibleAct	VARCHAR(13),
	INOUT CodigoRespuesta 	  	VARCHAR(3),

    INOUT FechaAplicacion		VARCHAR(4),
	Par_TardebMovID				INT(11)

)
TerminaStore:BEGIN


	DECLARE Var_CuentaAhoID 		BIGINT(12);
	DECLARE Var_ClienteID   		INT(11);
	DECLARE Var_SaldoDispoAct    	DECIMAL(12,2);
	DECLARE Var_SaldoContable		DECIMAL(12,2);
	DECLARE Var_NumTransaccion      BIGINT(20);

	DECLARE Var_BloqPOS             VARCHAR(5);
	DECLARE Var_TipoTarjetaDeb      INT(11);
	DECLARE Val_Giro                CHAR(4);
	DECLARE Var_BloqueID            INT(11);
	DECLARE Var_MontoOpeOriginal	DECIMAL(12,2);


	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Entero_Cero     	INT(11);
	DECLARE Salida_NO       	CHAR(1);
	DECLARE Salida_SI       	CHAR(1);
	DECLARE Decimal_Cero    	DECIMAL(12,2);

	DECLARE Saldo_Cero			VARCHAR(13);
	DECLARE CompraEnLineaSI 	CHAR(1);
	DECLARE Nat_Cargo			CHAR(1);
	DECLARE Error_Key           INT(11);
	DECLARE BloqPOS_SI          CHAR(1);

	DECLARE Fecha_Vacia			DATE;
	DECLARE ProActualiza		INT(11);
	DECLARE Est_Procesado		CHAR(1);
	DECLARE CompraNormal		CHAR(2);
	DECLARE Aud_EmpresaID       INT(11);

	DECLARE Aud_Usuario         INT(11);
	DECLARE Aud_DireccionIP     VARCHAR(15);
	DECLARE Aud_ProgramaID      VARCHAR(50);
	DECLARE Aud_Sucursal        INT(11);
	DECLARE Aud_FechaActual		DATETIME;

	DECLARE Con_BloqPOS         INT(11);
	DECLARE Est_Registrado		CHAR(1);
	DECLARE Var_DesBloq			VARCHAR(40);
	DECLARE Var_TipoBloqID      INT(11);
	DECLARE Var_NatMovimiento   CHAR(1);

	DECLARE DesbloqueoSaldo     CHAR(1);
	DECLARE TipBloqTarjeta      INT(11);


	SET Con_BloqPOS     	:= 2;
	SET Est_Registrado		:= 'R';
	SET Cadena_Vacia    	:= '';
	SET Entero_Cero     	:= 0;
	SET Salida_NO       	:= 'N';

	SET Salida_SI       	:= 'S';
	SET Decimal_Cero    	:= 0.00;
	SET Saldo_Cero			:= 'C000000000000';
	SET CompraEnLineaSI 	:= 'S';
	SET Nat_Cargo       	:= 'C';

	SET Error_Key       	:= Entero_Cero;
	SET BloqPOS_SI      	:= 'S';
	SET Fecha_Vacia			:= '1900-01-01';
	SET ProActualiza		:= 2;
	SET CompraNormal 		:= '00';

	SET Est_Procesado		:= 'P';
	SET Aud_EmpresaID   	:= 1;
	SET Aud_Usuario     	:= 1;
	SET Aud_DireccionIP 	:= 'localhost';
	SET Aud_ProgramaID  	:= 'workbench';

    SET Aud_Sucursal    	:= 1;
	SET DesbloqueoSaldo     := 'D';
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

    SELECT tar.CuentaAhoID, tar.TipoTarjetaDebID, IFNULL(FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_BloqPOS), Cadena_Vacia)
      INTO Var_CuentaAhoID, Var_TipoTarjetaDeb, Var_BloqPOS
      FROM TARJETADEBITO tar
     WHERE tar.TarjetaDebID = Par_NumeroTarjeta;


    SELECT ClienteID INTO Var_ClienteID
        FROM CUENTASAHO
        WHERE CuentaAhoID = Var_CuentaAhoID;

    SET Val_Giro :=  (SELECT FUNCIONGIRO (Par_NumeroTarjeta, Var_ClienteID, Var_TipoTarjetaDeb, Par_GiroNegocio));

    IF ( Val_Giro = Entero_Cero ) THEN

		IF (Var_BloqPOS != BloqPOS_SI) THEN

			SET Var_CuentaAhoID := IFNULL(Var_CuentaAhoID, Entero_Cero);


			SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);
			SET Par_MontoAdicio := IFNULL(Par_MontoAdicio, Decimal_Cero);

			IF (Par_CompraPOSLinea = CompraEnLineaSI) THEN

				CALL TARDEBTRANSACPRO(Var_NumTransaccion);

				SELECT	MontoOpe
					INTO Var_MontoOpeOriginal
				FROM TARDEBBITACORAMOVS
				WHERE NumTransaccion = Par_CodigoAprobacion AND TipoOperacionID = CompraNormal
				AND TarjetaDebID = Par_NumeroTarjeta AND Estatus = Est_Procesado;

				IF (IFNULL(Var_MontoOpeOriginal, Decimal_Cero) = Decimal_Cero) THEN
					SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
					SET SaldoContableAct	:= Saldo_Cero;
					SET SaldoDisponibleAct	:= Saldo_Cero;
					SET CodigoRespuesta   	:= "116";
					SET FechaAplicacion		:= FechaAplicacion;
					LEAVE TerminaStore;
				END IF;

				UPDATE CUENTASAHO SET
					SaldoDispon =   SaldoDispon +   Var_MontoOpeOriginal,
					SaldoBloq	= 	SaldoBloq	- 	Var_MontoOpeOriginal
				WHERE CuentaAhoID   =   Var_CuentaAhoID;


				SET Var_BloqueID := (SELECT IFNULL(MAX(BloqueoID),Entero_Cero) + 1 FROM BLOQUEOS);
				SET Var_NatMovimiento	:= DesbloqueoSaldo;
				SET Var_TipoBloqID  	:= TipBloqTarjeta;
				SET Var_DesBloq			:= 'DESBLOQUEO POR REVERSO PRE-AUTORIZA:CHECK-IN';

				INSERT INTO BLOQUEOS (
					BloqueoID,      CuentaAhoID,    NatMovimiento,  FechaMov,       MontoBloq,
					FechaDesbloq,   TiposBloqID,    Descripcion,    Referencia,     FolioBloq,
					EmpresaID,      Usuario,        FechaActual,    DireccionIP,    ProgramaID,
					Sucursal,		NumTransaccion)
				VALUES(
					Var_BloqueID,   Var_CuentaAhoID,    Var_NatMovimiento,		Par_FechaActual,    	Var_MontoOpeOriginal,
					Fecha_Vacia,    Var_TipoBloqID,     UPPER(Var_DesBloq),		Var_NumTransaccion, 	Entero_Cero,
					Aud_EmpresaID,  Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    	Aud_ProgramaID,
					Aud_Sucursal,   Var_NumTransaccion);

				UPDATE BLOQUEOS SET
					FolioBloq =  Var_BloqueID
				WHERE Referencia = Par_CodigoAprobacion;

				UPDATE TARDEBBITACORAMOVS SET
					NumTransaccion 	= Var_NumTransaccion,
					Estatus			= Est_Procesado
				WHERE TipoOperacionID= Par_TipoOperacion
					AND Referencia	 = Par_Referencia
					AND TarjetaDebID = Par_NumeroTarjeta;
			END IF;

			UPDATE TARDEBBITACORAMOVS SET
				   NumTransaccion 	= Var_NumTransaccion,
			       Estatus			= Est_Procesado
			 WHERE Referencia	 = Par_Referencia
			   AND TarjetaDebID = Par_NumeroTarjeta
		  	   AND NumTransaccion = Entero_Cero
			   AND Estatus = Est_Registrado
			   AND TardebMovID = Par_TardebMovID;


			SELECT IFNULL(SaldoDispon,Decimal_Cero), IFNULL(Saldo, Decimal_Cero)
					INTO Var_SaldoDispoAct, Var_SaldoContable
			FROM CUENTASAHO
			WHERE CuentaAhoID = Var_CuentaAhoID;

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