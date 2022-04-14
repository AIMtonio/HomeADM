DELIMITER ;
DROP PROCEDURE IF EXISTS ISOTRXEXPORTMOVTARCUENTAREP;

DELIMITER $$
CREATE PROCEDURE ISOTRXEXPORTMOVTARCUENTAREP(
	-- Modulo		= ISOTRX
	Par_FechaInicio				DATE,						-- Fecha de Inicio del Reporte
	Par_FechaFin				DATE,						-- Fecha de Fin del Reporte
    Par_CuentaAhoID             BIGINT(12),                 -- Numero de cuenta
	Par_NumTarjeta              VARCHAR(16),                 -- Numero de tarjeta

	Par_EmpresaID				INT(11),					-- Parametros de Auditoria
	Aud_Usuario					INT(11), 					-- Parametros de Auditoria
	Aud_FechaActual				DATETIME, 					-- Parametros de Auditoria
	Aud_DireccionIP				VARCHAR(15), 				-- Parametros de Auditoria
	Aud_ProgramaID				VARCHAR(50), 				-- Parametros de Auditoria
	Aud_Sucursal				INT(11), 					-- Parametros de Auditoria
	Aud_NumTransaccion			BIGINT(20) 					-- Parametros de Auditoria++
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Sentencia				VARCHAR(9000); 		-- Sentencia a Ejecutar
	DECLARE Var_FechaCorte				DATE;				-- Fecha corte de saldos creditos
	DECLARE Var_MotDevol                VARCHAR(500);       -- Motivos de devolucion de la sol. credito

	-- Declaracion de Constantes
	DECLARE Entero_Cero					INT(11);			-- Constante de entero cero
	DECLARE Fecha_Vacia					DATE;				-- Constante de fecha vacia
	DECLARE Hora_Vacia					TIME;				-- Constante Hora Vacia
	DECLARE	Cadena_Vacia				CHAR(1);			-- Constante cadena vacia
	DECLARE Entero_Dieciseis            INT(11);

	DECLARE	Decimal_Cero				DECIMAL(12,2);		-- Valor para el Decimal Cero
	DECLARE Entero_Treinta				INT(11);			-- Entero treinta
	DECLARE Con_ProAutomatico			VARCHAR(20);		-- Constante de proceso automatico
	DECLARE Con_No						CHAR(1);			-- Constante no
	DECLARE Con_Si						CHAR(1);			-- Constante si
	DECLARE Con_NA						CHAR(2);			-- Constante no disponible

	-- Asignacion de Constantes
	SET Var_Sentencia					:= '';
	SET	Entero_Cero						:= 0;
	SET	Fecha_Vacia						:= '1900-01-01';
	SET Hora_Vacia						:= '00:00:00';
	SET	Cadena_Vacia					:= '';

	SET	Decimal_Cero					:= 0.00;
	SET Entero_Treinta					:= 30;
	SET Con_No							:= 'N';
	SET Con_Si							:= 'S';
	SET Con_NA							:= 'NA';
	SET Entero_Dieciseis                := 16;
	-- ============================= Reporte de ISOTR para cuentas =============================
	DROP TABLE IF EXISTS TMPISOTRXMOVTARCUENTA;
	CREATE TEMPORARY TABLE TMPISOTRXMOVTARCUENTA(
        CuentaAhoID        BIGINT(12),    -- Numero de cuenta
		NumeroMov          BIGINT(20),    -- Numero de Movimiento
		NumeroTarjeta      VARCHAR(16),   -- Número de Tarjeta del SAFI
        FechaRegistroOPer  DATE,          -- Fecha de registro de la operacion
        Descripcion        VARCHAR(250),  -- Descripcion del movimiento
        Naturaleza         CHAR(1),       -- Naturaleza del movimiento cargo/abono
        RereferenciaCta    VARCHAR(50),   -- Referencia de la Cta
        MontoAplicado      DECIMAL(12,2), -- Monto aplicado
		NumTransaccion     BIGINT(20));

	SET Var_Sentencia :=('INSERT INTO TMPISOTRXMOVTARCUENTA (NumeroMov,       CuentaAhoID,   FechaRegistroOPer, Descripcion,  Naturaleza,');
    SET Var_Sentencia:= CONCAT(Var_Sentencia,'               RereferenciaCta, MontoAplicado, NumTransaccion,    NumeroTarjeta ) ');
    SET Var_Sentencia:= CONCAT(Var_Sentencia,'(  SELECT      Cue.NumeroMov,  MAX(Cue.CuentaAhoID), MAX(Cue.Fecha),MAX(Cue.DescripcionMov),MAX(Cue.NatMovimiento),');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,'               MAX(Cue.ReferenciaMov),MAX(Cue.CantidadMov),MAX(Cue.NumTransaccion),MAX(Tb.TarjetaDebID)');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,'   FROM          CUENTASAHOMOV Cue ');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,'   LEFT OUTER JOIN   TARJETADEBITO Tb ON Cue.CuentaAhoID=Tb.CuentaAhoID GROUP BY Cue.NumeroMov ) ');
    SET Var_Sentencia:= CONCAT(Var_Sentencia,' UNION ');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,'(  SELECT      His.NumeroMov,MAX(His.CuentaAhoID) , MAX(His.Fecha),MAX(His.DescripcionMov),MAX(His.NatMovimiento), ');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,'               MAX(His.ReferenciaMov),MAX(His.CantidadMov),MAX(His.NumTransaccion), MAX(Tb.TarjetaDebID) ');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,'   FROM        `HIS-CUENAHOMOV` His ');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,'   LEFT OUTER JOIN   TARJETADEBITO Tb ON His.CuentaAhoID=Tb.CuentaAhoID  GROUP BY His.NumeroMov) ');



		-- Se ejecuta la sentencia dinamica
	SET @Sentencia	= (Var_Sentencia);
	PREPARE ISOTRXCTAREP FROM @Sentencia;
	EXECUTE ISOTRXCTAREP;
	DEALLOCATE PREPARE ISOTRXCTAREP;

	-- Tabla auxiliar para el reporte
	DROP TABLE IF EXISTS TMPMOVTARCUENTA;
	CREATE TEMPORARY TABLE TMPMOVTARCUENTA(
        CuentaAhoID        BIGINT(12),    -- Numero de cuenta
		NumeroMov          BIGINT(20),    -- Numero de Movimiento
        NumeroTarjeta      VARCHAR(16),   -- Número de Tarjeta del SAFI
        FechaRegistroOPer  DATE,          -- Fecha de registro de la operacion
        Descripcion        VARCHAR(250),  -- Descripcion del movimiento
        Naturaleza         CHAR(1),       -- Naturaleza del movimiento cargo/abono
        RereferenciaCta    VARCHAR(50),   -- Referencia de la Cta
        MontoAplicado      DECIMAL(12,2), -- Monto aplicado
        CodAutorizacion    VARCHAR(6),    -- Codigo de autorizacion mientras sea por Tarjeta
        FechaTransaccion   DATE,          -- Fecha Transaccion mientras sea por Tajeta
        HoraTrasaccion     TIME,          -- Hora transaccion mientras sea por Tarjeta
		NumTransaccion     BIGINT(20));

SET Var_Sentencia := Cadena_Vacia;
	SET Var_Sentencia := ('INSERT INTO TMPMOVTARCUENTA (CuentaAhoID, FechaRegistroOPer,	Descripcion, Naturaleza,RereferenciaCta, ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,'		MontoAplicado, NumTransaccion,NumeroTarjeta,NumeroMov)');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,' SELECT	Cue.CuentaAhoID , Cue.FechaRegistroOPer, Cue.Descripcion,Cue.Naturaleza,Cue.RereferenciaCta,');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,' Cue.MontoAplicado,Cue.NumTransaccion,Cue.NumeroTarjeta,Cue.NumeroMov ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,' FROM TMPISOTRXMOVTARCUENTA Cue ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,' WHERE Cue.FechaRegistroOPer >= "',Par_FechaInicio,'" ');
	SET Var_Sentencia := CONCAT(Var_Sentencia ,' AND Cue.FechaRegistroOPer <= "',Par_FechaFin,'" ');


	-- Validacion para cuenta ahorro especifico
	IF(Par_CuentaAhoID <> Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND	Cue.CuentaAhoID = ', Par_CuentaAhoID,' ');
	END IF;

		-- Se ejecuta la sentencia dinamica
	SET @Sentencia	= (Var_Sentencia);
	PREPARE BSASIGNACIONREP FROM @Sentencia;
	EXECUTE BSASIGNACIONREP;
	DEALLOCATE PREPARE BSASIGNACIONREP;


    -- Se actualizan los datos en caso de tener movimientos en la tabla de Bitacoras de Tarjetas
	UPDATE TMPMOVTARCUENTA Tmp
	INNER JOIN TARDEBBITACORAMOVS Tar ON Tmp.NumeroTarjeta=Tar.TarjetaDebID
		SET
			Tmp.CodAutorizacion=Tar.OriCodigoAutorizacion,
			Tmp.FechaTransaccion=Tar.OriFechaTransaccion,
			Tmp.HoraTrasaccion=Tar.OriHoraTransaccion;

	IF( LENGTH(Par_NumTarjeta) = Entero_Dieciseis) THEN
		SELECT  CuentaAhoID,	  NumeroTarjeta,     FechaRegistroOPer,	Descripcion,	    Naturaleza,
			RereferenciaCta,  MontoAplicado,	 CodAutorizacion,	FechaTransaccion,	HoraTrasaccion,NumeroMov
			FROM TMPMOVTARCUENTA WHERE  NumeroTarjeta=Par_NumTarjeta;
	ELSE
	  	SELECT  CuentaAhoID,	  NumeroTarjeta,     FechaRegistroOPer,	Descripcion,	    Naturaleza,
			RereferenciaCta,  MontoAplicado,	 CodAutorizacion,	FechaTransaccion,	HoraTrasaccion,NumeroMov
			FROM TMPMOVTARCUENTA ;
	END IF;


END TerminaStore$$