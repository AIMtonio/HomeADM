-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWREVERSAFONDEOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWREVERSAFONDEOPRO`;

DELIMITER $$
CREATE PROCEDURE `CRWREVERSAFONDEOPRO`(
/* SP DE PROCESO PARA LA REVERSA DE DESEMBOLSO. */
	Par_Transaccion			BIGINT(20),		-- Número de transacción.
	Par_SolicitudCredID     BIGINT,			-- Id de la solicitud de crédito.
	Par_CreditoID           BIGINT(12),		-- Id del Crédito.
	Par_ProductoCreID       INT(11),		-- ID del producto de crédito.
	Par_FechaOperacion      DATE,			-- Fecha de operacion.

	Par_FechaAplicacion     DATE,			-- Fecha de Aplicación.
	Par_FechaVencimiento    DATE,			-- Fecha de vencimiento.
	Par_Poliza              BIGINT(20),		-- Id de la Poliza contable.
	Par_NumRetMes			INT(11),		-- ID del plazo
	Par_TipoFondeo          CHAR(1),		-- S: Fondeo por Solicitud, C: Fondeo por Credito

	Par_Salida				CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),		-- Número de validación.
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de validación.
	INOUT Par_Consecutivo	BIGINT,			-- Consecutivo.
	/* Parámetros de Auditoría.*/
	Par_EmpresaID           INT(11),

	Aud_Usuario             INT(11),
	Aud_FechaActual         DATETIME,
	Aud_DireccionIP         VARCHAR(15),
	Aud_ProgramaID          VARCHAR(50), -- se aumento el tamaño de la variable (Ago 17)
	Aud_Sucursal            INT(11),

	Aud_NumTransaccion      BIGINT(20)
)
TerminaStore:BEGIN

-- Declaracion de Variables
DECLARE Var_FechaSistema		DATE;
DECLARE Var_Contador			BIGINT;
DECLARE Var_TotalReg			BIGINT;
DECLARE Var_CliInstit			BIGINT;
DECLARE Var_ClienteID           BIGINT;				-- Variables para el CURSOR
DECLARE Var_MontoFondeo         DECIMAL(12,4);
DECLARE Var_MonedaID            INT;
DECLARE Var_CuentaAhoID			BIGINT(12);
DECLARE Var_SucCliente			INT;
DECLARE Var_BloqueoID			INT(11);
DECLARE Var_SolFondeoID			BIGINT(20);
DECLARE Var_Control				VARCHAR(50);

-- Declaracion de Constantes
DECLARE Cadena_Vacia      		CHAR(1);
DECLARE Fecha_Vacia       		DATE;
DECLARE Entero_Cero       		INT;
DECLARE Estatus_Activo	  		CHAR(1);
DECLARE Str_NO         			CHAR(1);
DECLARE Str_SI         			CHAR(1);
DECLARE Nat_Bloqueo		  		CHAR(1);
DECLARE Mov_Bloq       	  		CHAR(1);
DECLARE Tip_FonSolici     		CHAR(1);
DECLARE Var_TipoBloqID    		INT;
DECLARE TipoInversionista 		INT;
DECLARE TipoInverKubo	  		INT;
DECLARE EstatusEnProceso  		CHAR(1);
DECLARE Var_DescripBlo	  		VARCHAR(150);

-- Asginacion de Constantes
SET Cadena_Vacia      := '';			-- Constante Cadena Vacia
SET Fecha_Vacia       := '1900-01-01';	-- Constante Fecha Vacia
SET Entero_Cero       := 0;				-- Constante Entero Cero
SET Str_NO			  := 'N';			-- Constante NO
SET Str_SI			  := 'S';			-- Constante SI
SET Nat_Bloqueo		  := 'B';			-- Constante Naturaleza Bloqueo
SET Mov_Bloq       	  := 'B';			-- Constante Movimiento de Bloqueo
SET Tip_FonSolici     := 'S';           -- Tipo de Fondeo en base a la Solicitud
SET Var_TipoBloqID    := 7;             -- Tipo de Bloqueo de la Cta de Ahorro: TIPOSBLOQUEOS
SET EstatusEnProceso  := 'F';			-- Estatus En Proceso
SET Estatus_Activo	  := 'N';			-- Estatus Activo
SET TipoInversionista := 1;				-- Tipo de Fondeador: Publico Inversionista.
SET TipoInverKubo 	  := 3;				-- Constante TipoInverKubo
SET Var_DescripBlo    := 'REVERSA DESEMBOLSO DE CREDITO';

ManejoErrores : BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWREVERSAFONDEOPRO');
		SET Var_Control := 'SQLEXCEPTION' ;
	END;

	SET Par_SolicitudCredID  := IFNULL(Par_SolicitudCredID,Entero_Cero);

	IF(Par_SolicitudCredID = Entero_Cero) THEN
		SET	Par_NumErr 	:= 1;
		SET	Par_ErrMen	:= "La Solicitud de Credito Viene Vacía.";
		LEAVE ManejoErrores;
	END IF;

	SELECT
		FechaSistema, ClienteInstitucion
	INTO
		Var_FechaSistema, Var_CliInstit
	FROM PARAMETROSSIS;

	DELETE FROM TMPCRWREVERSAFONDEO WHERE NumTransaccion = Par_Transaccion;

	SET @Var_TmpID := Entero_Cero;

	INSERT INTO TMPCRWREVERSAFONDEO (
		TmpID,
		ClienteID,			MontoFondeo,		MonedaID,		CuentaAhoID,		SucursalOrigen,
		SolFondeoID,		NumTransaccion)
	SELECT
		(@Var_TmpID := @Var_TmpID + 1),
		Sol.ClienteID,		Sol.MontoFondeo,	Sol.MonedaID,	Sol.CuentaAhoID,	Cli.SucursalOrigen,
		Sol.SolFondeoID,	Par_Transaccion
	FROM CRWFONDEOSOLICITUD Sol
		INNER JOIN CRWTIPOSFONDEADOR Tif ON Sol.TipoFondeadorID = Tif.TipoFondeadorID
		INNER JOIN CLIENTES Cli ON Sol.ClienteID = Cli.ClienteID
	WHERE Sol.SolicitudCreditoID 	= Par_SolicitudCredID
		AND Sol.Estatus				= Estatus_Activo
		AND Tif.TipoFondeadorID		= TipoInversionista;

	SET Var_TotalReg := (SELECT COUNT(*) FROM TMPCRWREVERSAFONDEO WHERE NumTransaccion = Par_Transaccion);
	SET Var_TotalReg := IFNULL(Var_TotalReg, Entero_Cero);

	SET Var_Contador := 1;

	WHILE(Var_Contador <= Var_TotalReg)DO
		SELECT
			ClienteID,		MontoFondeo,		MonedaID,		CuentaAhoID,		SucursalOrigen,
			SolFondeoID
		INTO
			Var_ClienteID,	Var_MontoFondeo,	Var_MonedaID,	Var_CuentaAhoID,	Var_SucCliente,
			Var_SolFondeoID
		FROM TMPCRWREVERSAFONDEO
		WHERE TmpID = Var_Contador
			AND NumTransaccion = Par_Transaccion;

	  -- Alta de las Amortizaciones Pasivas y proceso Contable
		CALL CRWREVERSAFONDEOALT (
			Var_ClienteID,			Par_CreditoID,		Var_CuentaAhoID,	Par_SolicitudCredID,	Var_SolFondeoID,
			Par_ProductoCreID,		Var_MontoFondeo,	Var_MonedaID,		Var_SucCliente,			Par_FechaOperacion,
			Par_FechaAplicacion,	Par_NumRetMes,		Par_Poliza,			Par_TipoFondeo,			Str_NO,
			Par_NumErr,				Par_ErrMen,			Par_Consecutivo,	Par_EmpresaID,			Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Var_BloqueoID := (SELECT MAX(Blo.BloqueoID)
									FROM CRWFONDEOSOLICITUD Sol,
									   BLOQUEOS Blo
									WHERE Sol.SolFondeoID	= Blo.Referencia
									AND Blo.TiposBloqID     = Var_TipoBloqID
									AND Blo.NatMovimiento   = Nat_Bloqueo
									AND Sol.CuentaAhoID     = Blo.CuentaAhoID
									AND Blo.Referencia		= Var_SolFondeoID);

		-- Bloqueo del Saldo de la Cta de ahorro del Inversionista
		CALL BLOQUEOSPRO(
			Var_BloqueoID,		Mov_Bloq,    		Var_CuentaAhoID,    Var_FechaSistema,	Var_MontoFondeo,
			Var_FechaSistema,	Var_TipoBloqID,		Var_DescripBlo,     Var_SolFondeoID,	Cadena_Vacia,
			Cadena_Vacia,		Str_NO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END WHILE;

	-- Se actualiza el estatus del fondeador kubo si es que hay
	SET Var_SolFondeoID := (SELECT Sol.SolFondeoID
							FROM CRWFONDEOSOLICITUD Sol
								INNER JOIN CRWTIPOSFONDEADOR Tif ON Sol.TipoFondeadorID = Tif.TipoFondeadorID
								INNER JOIN CLIENTES Cli ON Sol.ClienteID = Cli.ClienteID
							WHERE Sol.SolicitudCreditoID 	= Par_SolicitudCredID
							  AND Tif.TipoFondeadorID		= TipoInverKubo
							  AND Sol.Estatus				= Estatus_Activo);
	SET Var_SolFondeoID := IFNULL(Var_SolFondeoID, Entero_Cero);

	IF(Var_SolFondeoID > Entero_Cero) THEN
		UPDATE CRWFONDEOSOLICITUD
		SET
			Estatus = EstatusEnProceso
		WHERE SolFondeoID = Var_SolFondeoID;
	END IF;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Reversa Aplicada Exitosamente.';
	SET Var_Control:= 'solFondeoID' ;

END ManejoErrores;

IF (Par_Salida = Str_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			IFNULL(Var_SolFondeoID,Entero_Cero) AS Consecutivo;
END IF;

END TerminaStore$$