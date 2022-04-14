-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWREVERSAFONDEOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWREVERSAFONDEOALT`;

DELIMITER $$
CREATE PROCEDURE `CRWREVERSAFONDEOALT`(
/* ALTA DE REVERSAS DE FONDEO POR DESEMBOLSO. */
	Par_ClienteID       INT(11),			-- ID del Cliente.
	Par_CreditoID       BIGINT(12),			-- ID del Crédito.
	Par_CuentaAhoID     BIGINT(12),			-- ID de la cuenta de ahorro.
	Par_SoliciCredID    BIGINT,				-- ID de la Solicitud de créd.
	Par_SolFondeoID     BIGINT(20),			-- ID de la solicitud de fondeo.

	Par_ProductoCreID	INT(11),			-- ID del producto de crédito.
	Par_MontoFondeo     DECIMAL(12,2),		-- Monto de fondeo.
	Par_MonedaID        INT(11),			-- Id de la moneda.
	Par_SucCliente      INT(11),			-- Sucursal origen del cliente.
	Par_FechaOper       DATE,				-- Fecha de operación.

	Par_FechaApl        DATE,				-- Fecha de aplicación.
	Par_NumRetMes       INT(11),			-- Plazo
	Par_Poliza          BIGINT(20),			-- Número de la póliza.
	Par_TipoFondeo      CHAR(1),			-- S: Fondeo por Solicitud, C: Fondeo por Credito
	Par_Salida          CHAR(1),			-- Indica el tipo de salida S.- Si N.- No

	INOUT Par_NumErr	INT(11),			-- Número de validación.
	INOUT Par_ErrMen	VARCHAR(400),		-- Mensaje de validación.
	INOUT Par_ConsID	BIGINT,				-- Consecutivo.
	/* Parámetros de Auditoría. */
	Par_EmpresaID       INT(11),
	Aud_Usuario         INT(11),

	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),
	Aud_NumTransaccion  BIGINT(20)
)
TerminaStore:BEGIN

-- Declaracion de Constantes
DECLARE Fecha_Vacia     DATE;
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Entero_Cero     INT;
DECLARE Str_SI			CHAR(1);
DECLARE Str_NO			CHAR(1);
DECLARE Nat_Cargo       CHAR(1);
DECLARE Nat_Abono       CHAR(1);
DECLARE Estatus_EnProceso CHAR(1);
DECLARE Des_RevDes		VARCHAR(100);
DECLARE AltaPoliza_NO   CHAR(1);
DECLARE AltaPolKubo_SI  CHAR(1);
DECLARE AltaMovKubo_NO  CHAR(1);
DECLARE Con_KuboCapita  INT;
DECLARE AltaMovAho_SI   CHAR(1);
DECLARE Mov_AhoApeInv   CHAR(3);
DECLARE Tip_FonSolici   CHAR(1);
DECLARE Aplica_IVANO    CHAR(1);
DECLARE Par_FechaVen	DATE;
DECLARE Var_MontoCuota	DECIMAL(12,2);
DECLARE NO_PagaISR		CHAR(1);
DECLARE SalidaSI		CHAR(1);

-- Declaracion de Variables
DECLARE Var_Control		VARCHAR(200);
DECLARE Var_FondeoID	BIGINT;
DECLARE Var_Referencia	VARCHAR(50);

-- Asignacion de Constantes
SET Fecha_Vacia     := '1900-01-01';  -- Fecha Vacia
SET Cadena_Vacia    := '';			   -- String Vacio
SET Entero_Cero     := 0;			   -- Entero en Cero
SET Str_SI			:= 'S';			  -- Al ejecutar el Store SI pedir Salida
SET Str_NO			:= 'N';			  -- Al ejecutar el Store NO pedir Salida
SET Nat_Cargo       := 'C';			  -- Naturaleza de Cargo
SET Nat_Abono       := 'A';			  -- Naturaleza de Abono
SET Estatus_EnProceso := 'F';
SET Des_RevDes		:= 'REVERSA DESEMBOLSO DE CREDITO';
SET AltaPoliza_NO   := 'N';			  -- No dar de Alta la Poliza Contable
SET AltaPolKubo_SI  := 'S';			  -- Alta de la Poliza de Kubo: SI
SET AltaMovKubo_NO  := 'N';			  -- Alta de Movimiento de Kubo: NO
SET Con_KuboCapita  := 1;			  -- Concepto Contable de Kubo: Capital
SET AltaMovAho_SI   := 'S';			  -- Alta de Movimiento de Ahorro: SI
SET Mov_AhoApeInv   := '70';		  -- Tipo de Movimiento der Ahorro: Apertura de Inversion
SET Tip_FonSolici   := 'S';         -- Tipo de Fondeo en base a la Solicitud
SET Aplica_IVANO    := 'N';         -- No aplicar IVA en los Cotizadores
SET NO_PagaISR		:= 'N';
SET SalidaSI		:= 'S';

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWREVERSAFONDEOALT');
		SET Var_Control := 'SQLEXCEPTION' ;
	END;

	IF(IFNULL(Par_ClienteID, Entero_Cero))= Entero_Cero THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'El numero de Cliente esta Vacio.';
		SET Var_Control := 'ClienteID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_CreditoID, Entero_Cero))= Entero_Cero THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := 'El numero de Credito esta Vacio.';
		SET Var_Control := 'CreditoID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_SoliciCredID, Entero_Cero))= Entero_Cero THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'La Solicitud de Credito esta vacia.';
		SET Var_Control := 'SolicitudCreditoID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MontoFondeo, Entero_Cero)) <= Entero_Cero THEN
		SET Par_NumErr := 4;
		SET Par_ErrMen := 'El Monto de Fondeo esta vacio.';
		SET Var_Control := 'MontoFondeo';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MonedaID, Entero_Cero))= Entero_Cero THEN
		SET Par_NumErr := 5;
		SET Par_ErrMen := 'El numero de moneda esta vacio.';
		SET Var_Control := 'MonedaID';
		LEAVE ManejoErrores;
	END IF;

	SET Var_FondeoID := (SELECT SolFondeoID FROM CRWFONDEOSOLICITUD
						WHERE ClienteID = Par_ClienteID
							AND SolFondeoID = Par_SolFondeoID
							AND CuentaAhoID = Par_CuentaAhoID);

	SET Var_Referencia	:= CONVERT(Par_CreditoID, CHAR);

	-- 2) Se marca la solicitud de Fondeo como Registrada y ningun fondeador
	UPDATE CRWFONDEOSOLICITUD SET
		SolFondeoID	= Entero_Cero,
		Estatus		= Estatus_EnProceso
		WHERE SolFondeoID = Par_SolFondeoID;

	-- 1) Borrado de las amortizaciones del fondeador
	DELETE FROM AMORTICRWFONDEO WHERE SolFondeoID = Var_FondeoID;

	-- 1) Se elimina el registro del fondeador
	DELETE FROM CRWFONDEO
	WHERE ClienteID = Par_ClienteID
		AND CreditoID = Par_CreditoID
		AND CuentaAhoID = Par_CuentaAhoID
		AND SolFondeoID = Var_FondeoID;

	-- Contabilizacion de la Inversion (Cartera Pasiva)
	CALL CONTAINVKUBOPRO (
		Var_FondeoID,       Entero_Cero,        Par_CuentaAhoID,    Par_ClienteID,  Par_FechaOper,
		Par_FechaApl,       Par_MontoFondeo,    Par_MonedaID,       Par_NumRetMes,  Par_SucCliente,
		Des_RevDes,        Var_Referencia,     AltaPoliza_NO,      Entero_Cero,    Par_Poliza,
		AltaPolKubo_SI,     AltaMovKubo_NO,     Con_KuboCapita,     Entero_Cero,    Nat_Cargo,
		Cadena_Vacia,       AltaMovAho_SI,      Mov_AhoApeInv,      Nat_Abono,      Par_NumErr,
		Par_ErrMen,         Par_ConsID,			Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,
		Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	-- Borrado del Calendario de Amortizaciones del Inversionista
	DELETE FROM TMPPAGAMORSIM
		WHERE NumTransaccion = Aud_NumTransaccion;

	-- Borrado del Respaldo de las amortizaciones Originales
	DELETE FROM CRWPAGAREFONDEO
			WHERE SolFondeoID = Var_FondeoID;

	-- Borrado de los movimientos del Fondeo
	DELETE FROM CRWFONDEOMOVS
				WHERE SolFondeoID = Var_FondeoID ;

	SET	Par_NumErr := '000';
	SET	Par_ErrMen := 'La Reversa al Fondeo ha sido Agregada Exitosamente.';
	SET	Par_ConsID := Var_FondeoID;

END ManejoErrores;

IF (Par_Salida = Str_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$