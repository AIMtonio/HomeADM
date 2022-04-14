-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWFONDEOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWFONDEOPRO`;

DELIMITER $$
CREATE PROCEDURE `CRWFONDEOPRO`(
	Par_SolicitudCredID     BIGINT(20),
	Par_CreditoID           BIGINT(12),
	Par_FechaOperacion      DATE,
	Par_FechaAplicacion     DATE,
	Par_FechaInicio         DATE,

	Par_FechaVencimiento    DATE,
	Par_NumCuotas           INT(11),
	Par_Frecuencia          CHAR(1),
	Par_NumRetMes           INT(11),
	Par_DiaPagoCap          CHAR(1),

	Par_DiaMesCap           INT(11),
	Par_Poliza              BIGINT,
	Par_ProductoCreID       INT(11),
	Par_FechaInhabil        CHAR(1),
	Par_AjFecUlVenAmo       CHAR(1),

	Par_AjFecExiVen         CHAR(1),
	Par_TipoFondeo          CHAR(1),            -- S: Fondeo por Solicitud, C: Fondeo por Credito
	Par_Salida				CHAR(1),			-- Tipo De Salida.
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	INOUT Par_Consecutivo	BIGINT,
	/* Ṕarámetros Auditoría. */
	Aud_EmpresaID           INT(11),
	Aud_Usuario             INT(11),
	Aud_FechaActual         DATETIME,
	Aud_DireccionIP         VARCHAR(15),

	Aud_ProgramaID          VARCHAR(50),
	Aud_Sucursal            INT(11),
	Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN

/* Declaraciond e Variables */
DECLARE Var_BloqueoID			INT(11);
DECLARE Var_ClienteID			BIGINT;				-- Variables para el CURSOR
DECLARE Var_CliInstit			BIGINT;
DECLARE Var_Consecutivo			INT;
DECLARE Var_Contador			INT;
DECLARE Var_CuentaAhoID			BIGINT(12);
DECLARE Var_DescripBlo			VARCHAR(50) ;
DECLARE Var_FechaSis			DATE;
DECLARE Var_FolioCRW			VARCHAR(20);
DECLARE Var_Gat					DECIMAL(12,2);
DECLARE Var_MonedaID			INT;
DECLARE Var_MontoFondeo			DECIMAL(12,4);
DECLARE Var_PorcentajeComisi	DECIMAL(12,4);
DECLARE Var_PorcentajeFondeo	DECIMAL(10,6);
DECLARE Var_PorcentajeMora		DECIMAL(12,4);
DECLARE Var_Referencia			VARCHAR(50);
DECLARE Var_Control				VARCHAR(80);
DECLARE Var_SolFondeoID			BIGINT(20);
DECLARE Var_SucCliente			INT;
DECLARE Var_TasaPasiva			DECIMAL(12,4);
DECLARE Var_TipoBloqID			INT;
DECLARE Var_TipoFondeadorID		INT;
DECLARE Var_TotalRegs			INT;

/* Declaracion de Constantes */
DECLARE Cadena_Vacia			CHAR(1);
DECLARE Fecha_Vacia				DATE;
DECLARE Entero_Cero				INT;
DECLARE EstatusVigente			CHAR(1);
DECLARE Fon_PubInv				INT;
DECLARE For_TasaFija			INT;
DECLARE Mov_Desbloq				CHAR(1);
DECLARE Nat_Bloqueo				CHAR(1);
DECLARE Pol_Automatica			CHAR(1);
DECLARE Sta_ProFondeo			CHAR(1);
DECLARE Str_NO					CHAR(1);
DECLARE Str_SI					CHAR(1);
DECLARE Tas_BaseVacia			INT;
DECLARE Tas_PisoCero			DECIMAL(8,4);
DECLARE Tas_SobTasCero			DECIMAL(8,4);
DECLARE Tas_TechoCero			DECIMAL(8,4);
DECLARE Tip_FonCredito			CHAR(1);
DECLARE Tip_FonSolici			CHAR(1);

/* Asignacion de Constantes */
SET Cadena_Vacia				:= '';				-- Cadena vacía.
SET Fecha_Vacia					:= '1990-01-01';	-- Fecha vacía.
SET Entero_Cero					:= 0;				-- Entero cero
SET Sta_ProFondeo				:= 'F';				-- Estatus: En Proceso de Fondeo
SET Str_NO						:= 'N';				-- Constante NO.
SET Str_SI						:= 'S';				-- Constante SI.
SET For_TasaFija				:= 1;				-- Formula de Calculo de Interes: Tasa Fija
SET Fon_PubInv					:= 1;				-- Tipo de Fondeador: Publico Inversionista
SET Pol_Automatica				:= 'A';				-- Poliza Automatica
SET EstatusVigente				:= 'N';				-- Estatus Vigente
SET Var_TipoBloqID				:= 7;				-- Tipo de Bloqueo de la Cta de Ahorro: TIPOSBLOQUEOS
SET Tip_FonSolici				:= 'S';				-- Tipo de Fondeo en base a la Solicitud
SET Tip_FonCredito				:= 'C';				-- Tipo de Fondeo en base al Credito
SET Nat_Bloqueo					:= 'B';
SET Tas_BaseVacia				:= 0;
SET Tas_SobTasCero				:= 0.00;
SET Tas_PisoCero				:= 0.00;
SET Tas_TechoCero				:= 0.00;
SET Mov_Desbloq					:= 'D';


ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWFONDEOPRO');
			SET Var_Control:= 'sqlException' ;
		END;

	DELETE FROM TMPFONDEOCRW WHERE NumTransaccion = Aud_NumTransaccion;

	SET @Var_ConsID := Entero_Cero;

	INSERT INTO TMPFONDEOCRW (
		TmpID,
		SolFondeoID, 		SolicitudCreditoID, 	Estatus, 			TipoFondeadorID, 		ClienteID,
		Consecutivo, 		TasaPasiva, 			MontoFondeo, 		PorcentajeFondeo, 		MonedaID,
		PorcentajeMora, 	PorcentajeComisi, 		CuentaAhoID,  		SucursalOrigen, 		Gat,
		EmpresaID,			Usuario, 				FechaActual, 		DireccionIP, 			ProgramaID,
		Sucursal,			NumTransaccion)
	SELECT
		(@Var_ConsID := @Var_ConsID + 1),
		Sol.SolFondeoID,	Sol.SolicitudCreditoID,	Sol.Estatus,		Sol.TipoFondeadorID,	Sol.ClienteID,
		Sol.Consecutivo,	Sol.TasaPasiva,			Sol.MontoFondeo, 	Sol.PorcentajeFondeo,	Sol.MonedaID,
		Tif.PorcentajeMora,	Tif.PorcentajeComisi,	Sol.CuentaAhoID,	Cli.SucursalOrigen,		Sol.Gat,
		Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion
	FROM CRWFONDEOSOLICITUD Sol
		INNER JOIN CRWTIPOSFONDEADOR Tif ON Sol.TipoFondeadorID = Tif.TipoFondeadorID
		INNER JOIN CLIENTES Cli ON Sol.ClienteID = Cli.ClienteID
	WHERE Sol.SolicitudCreditoID = Par_SolicitudCredID
		AND Sol.Estatus = 'F'			-- En estatus de Fondeo
		AND Tif.TipoFondeadorID	= 1	;	-- Tipo de Fondeador: Publico Inversionista

	SET Var_DescripBlo := (SELECT Descripcion FROM TIPOSBLOQUEOS WHERE TiposBloqID = Var_TipoBloqID);
	SET Var_DescripBlo := IFNULL(Var_DescripBlo, Cadena_Vacia);

	SELECT
		FechaSistema,	ClienteInstitucion
	INTO
		Var_FechaSis,	Var_CliInstit
	FROM PARAMETROSSIS;

	SET Var_TotalRegs := (SELECT COUNT(*) FROM TMPFONDEOCRW WHERE NumTransaccion = Aud_NumTransaccion);
	SET Var_TotalRegs := IFNULL(Var_TotalRegs, Entero_Cero);

	SET Var_Contador := 1;

	WHILE(Var_Contador <= Var_TotalRegs)DO
		SELECT
			ClienteID,				Consecutivo,			TasaPasiva,         TipoFondeadorID,
			MontoFondeo,			PorcentajeFondeo,		MonedaID,           PorcentajeMora,
			PorcentajeComisi,		CuentaAhoID,			SucursalOrigen,		SolFondeoID,
			Gat
		INTO
			Var_ClienteID,			Var_Consecutivo,        Var_TasaPasiva,		Var_TipoFondeadorID,
			Var_MontoFondeo,		Var_PorcentajeFondeo,	Var_MonedaID,		Var_PorcentajeMora,
			Var_PorcentajeComisi,	Var_CuentaAhoID,        Var_SucCliente,		Var_SolFondeoID,
			Var_Gat
		FROM TMPFONDEOCRW
		WHERE SolicitudCreditoID = Par_SolicitudCredID
			AND TmpID = Var_Contador
			AND NumTransaccion = Aud_NumTransaccion;

		SET Var_FolioCRW	:= Cadena_Vacia;
		SET Var_FolioCRW	:= CONCAT(lpad(CONVERT(Par_CreditoID, CHAR), 11, '0'), '-', lpad(CONVERT(Var_Consecutivo, CHAR), 3, '0'));

		SET	Var_Referencia	:= CONVERT(Par_CreditoID, CHAR);

	   -- Si la Solicitud de Fondeo es de un Credito todavia no Maduro o Desembolsado
		IF (Par_TipoFondeo = Tip_FonSolici) THEN
			SET Var_BloqueoID := (SELECT Blo.BloqueoID
										FROM CRWFONDEOSOLICITUD Sol,
										   BLOQUEOS Blo
										WHERE Sol.CuentaAhoID		= Blo.CuentaAhoID
											AND Sol.SolFondeoID		= Blo.Referencia
											AND Blo.TiposBloqID		= Var_TipoBloqID
											AND Blo.NatMovimiento	= Nat_Bloqueo
											AND Blo.FolioBloq		= 0
											AND Blo.Referencia		= Var_SolFondeoID );

			-- Desbloqueo del Saldo de la Cta de ahorro del Inversionista
			CALL BLOQUEOSPRO(
				Var_BloqueoID,		Mov_Desbloq,		Var_CuentaAhoID,	Var_FechaSis,		Var_MontoFondeo,
				Var_FechaSis,		Var_TipoBloqID,		Var_DescripBlo,		Var_SolFondeoID,	Cadena_Vacia,
				Cadena_Vacia,		Str_NO,				Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

	  -- Alta de las Amortizaciones Pasivas y proceso Contable
		CALL CRWFONDEOALT (
			Var_ClienteID,		Par_CreditoID,		Var_CuentaAhoID,		Par_SolicitudCredID,	Var_SolFondeoID,
			Var_Consecutivo,	Var_FolioCRW,		For_TasaFija,			Tas_BaseVacia,			Tas_SobTasCero,
			Var_TasaPasiva,		Tas_PisoCero,		Tas_TechoCero,			Var_MontoFondeo,		Var_PorcentajeFondeo,
			Var_MonedaID,		Par_FechaInicio,	Par_FechaVencimiento,	Var_TipoFondeadorID,	Par_NumCuotas,
			Par_Frecuencia,		Par_DiaPagoCap,		Par_DiaMesCap,			Var_PorcentajeMora,		Var_PorcentajeComisi,
			Par_ProductoCreID,	Var_SucCliente,		Par_FechaOperacion,		Par_FechaAplicacion,	Var_Referencia,
			Par_NumRetMes,		Par_FechaInhabil,	Par_AjFecUlVenAmo,		Par_AjFecExiVen,		Par_Poliza,
			Par_TipoFondeo,		Var_Gat,			Str_NO,					Par_NumErr,				Par_ErrMen,
			Par_Consecutivo,	Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Var_Contador := Var_Contador + 1;
	END WHILE;

	-- Actualizacion de la Solicitud de Fondeo Propia (La de la Institucion)
	UPDATE CRWFONDEOSOLICITUD SET
		Estatus			= EstatusVigente,

		EmpresaID		= Aud_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual		= Aud_FechaActual,
		DireccionIP		= Aud_DireccionIP,
		ProgramaID		= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	WHERE SolicitudCreditoID = Par_SolicitudCredID
		AND ClienteID = Var_CliInstit;

	DELETE FROM TMPFONDEOCRW WHERE SolicitudCreditoID = Par_SolicitudCredID AND NumTransaccion = Aud_NumTransaccion;

	SET Par_NumErr := 000;
	SET Par_ErrMen := 'Proceso de Fondeo Exitoso.';
	SET Par_Consecutivo := Par_CreditoID;

END ManejoErrores;

IF (Par_Salida = Str_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Cadena_Vacia AS Control,
			Par_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$
