
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANCSOCMENORCTAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CANCSOCMENORCTAPRO`;

DELIMITER $$
CREATE PROCEDURE `CANCSOCMENORCTAPRO`(
	Par_FechaOperacion		DATE,
	Par_Operacion			CHAR(1),
	Par_ClienteID			INT(11),
	Par_SucursalID			INT(11),
	Par_CajaID				INT(11),

	Par_Identidad			INT(11),
	Par_FolioIdenti			VARCHAR(30),
	Par_Monto				DECIMAL(14,2),
	Par_ConceptoConta		INT(11),
	Par_DescripcionMov		VARCHAR(150),
	Par_PolizaID			BIGINT(20),

	Par_Salida				CHAR(1),
	INOUT	Par_NumErr		INT,
	INOUT	Par_ErrMen		VARCHAR(350),
	Par_EmpresaID			INT,
	Aud_Usuario				INT,

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT

		)
TerminaStore: BEGIN
DECLARE Var_CuentaConta		VARCHAR(50);
DECLARE Var_Descripcion		VARCHAR(50);
DECLARE Var_Contador		INT(11);
DECLARE Var_Poliza			BIGINT;
DECLARE Var_SucursalOrigen	INT(11);
DECLARE Var_ClienteID		INT(11);
DECLARE Var_SaldoAhorro		DECIMAL(14,2);
DECLARE Var_CuentaAhoID		BIGINT(12);
DECLARE Var_MonedaBase		INT(11);
DECLARE Var_Aplicado		CHAR(1);
DECLARE Var_FechaSistema	DATE;


DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Entero_Cero			INT;
DECLARE	Decimal_Cero		DECIMAL(12,2);
DECLARE Fecha_Vacia			DATE;
DECLARE Inactivo			CHAR(1);
DECLARE Tipo_Inactivacion	INT(11);
DECLARE Desc_Inactiva		VARCHAR(100);
DECLARE EsMenor				CHAR(1);
DECLARE Activo				CHAR(1);
DECLARE Cancelada			CHAR(1);
DECLARE Desbloqueo			CHAR(1);
DECLARE Procedimiento		VARCHAR(50);
DECLARE ConceptoConta		INT(11);
DECLARE Pol_Automatica		CHAR(1);
DECLARE TipoInstumentoCTE	INT(11);
DECLARE CancelacionAut		CHAR(1);
DECLARE RetiroHaberes		CHAR(1);
DECLARE Salida_SI			CHAR(1);
DECLARE Salida_NO			CHAR(1);
DECLARE Retirado			CHAR(1);
DECLARE AltaEncPolizaSI		CHAR(1);
DECLARE AltaEncPolizaNo		CHAR(1);
DECLARE AltaDetPolSI		CHAR(1);
DECLARE NatContableCargo	CHAR(1);
DECLARE ConceptoCaja		INT;
DECLARE NoAplicado			CHAR(1);
DECLARE DesCanAutMenor		VARCHAR(50);
DECLARE DesBloqueoMenor		VARCHAR(50);
DECLARE EstatusBloqueada	CHAR(1);

DECLARE CANCSOCMENORCTA CURSOR FOR
	SELECT  CuentaAhoID,Aplicado
			FROM CANCSOCMENORCTA
					WHERE ClienteID=Par_ClienteID;



SET	Cadena_Vacia			:= '';
SET	Fecha_Vacia				:= '1900-01-01';
SET	Entero_Cero				:= 0;
SET	Decimal_Cero			:= 0.0;
SET Inactivo				:= 'I';
SET Tipo_Inactivacion		:= 11;
SET EsMenor					:= "S";
SET Activo					:= "A";
SET Cancelada				:= "C";
SET Desbloqueo				:= "D";
SET Procedimiento			:= "CANCSOCMENORCTAPRO";
SET TipoInstumentoCTE		:= 4;
SET ConceptoConta			:= 805;
SET	Pol_Automatica			:= 'A';
SET Desc_Inactiva			:= (SELECT  IFNULL(Descripcion,Cadena_Vacia) FROM  MOTIVACTIVACION WHERE MotivoActivaID=Tipo_Inactivacion);
SET CancelacionAut			:= "C";
SET RetiroHaberes			:= "R";
SET Salida_SI				:= "S";
SET Salida_NO				:= "N";
SET Retirado				:= "R";
SET AltaEncPolizaSI			:= 'S';
SET AltaEncPolizaNo			:= 'N';
SET AltaDetPolSI			:= 'S';
SET NatContableCargo		:= 'C';
SET ConceptoCaja			:= 8;
SET @Var_ConsecutivoID 		:= (SELECT MAX(IFNULL(ConsecutivoID,0)) FROM CANCSOCMENORCTA);
SET NoAplicado				:= 'N';
SET DesCanAutMenor			:= "CANCELACION AUTOMATICA DEL MENOR";
SET DesBloqueoMenor			:= "DESBLOQUEO POR CANCELACION AUT. SOCIO MENOR";
SET EstatusBloqueada		:='B';

IF Par_Operacion=CancelacionAut THEN
	SET @Var_ConsecutivoID := IFNULL(@Var_ConsecutivoID, Entero_Cero );

	INSERT INTO CANCSOCMENORCTA (
		ConsecutivoID,
		ClienteID,				CuentaAhoID,		SaldoAhorro,	EstatusCta,
		FechaCancela,			Aplicado,			FechaRetiro,	EmpresaID,			Usuario,
		FechaActual,			DireccionIP,		ProgramaID,		Sucursal,			NumTransaccion)
	SELECT
		(@Var_ConsecutivoID  :=  @Var_ConsecutivoID +1),
		Cli.ClienteID,			Cue.CuentaAhoID,	IFNULL(Cue.Saldo,0),Cue.Estatus,
		Par_FechaOperacion, 	NoAplicado,			Fecha_Vacia,	Par_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,		Aud_DireccionIP	,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
	FROM CLIENTES Cli
		LEFT JOIN TMPCUENTASAHOCI Cue ON Cue.ClienteID=Cli.ClienteID AND Cue.Estatus !=Cancelada
	WHERE Cli.EsMenorEdad=EsMenor
		AND Cli.Estatus =Activo
		AND YEAR(Cli.FechaNacimiento)+18 = YEAR(Par_FechaOperacion)
		AND MONTH(Cli.FechaNacimiento) = MONTH(Par_FechaOperacion);

	# REGISTRO DE INACTIVACIONES ANTES DE LA ACTUALIZACIÓN DE ESTATUS DE LOS CLIENTES.
	INSERT INTO BITACTIVACIONESCTES(
		ClienteID,				Estatus,		TipoInactiva,		MotivoInactiva,		FechaBaja,
		FechaReactivacion,		EmpresaID,		Usuario,			FechaActual,		DireccionIP,
		ProgramaID,				Sucursal,		NumTransaccion)
	SELECT
		Cli.ClienteID,			Cli.Estatus,	Cli.TipoInactiva,	Cli.MotivoInactiva,	Cli.FechaBaja,
		Cli.FechaReactivacion,	Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Procedimiento,			Aud_Sucursal,	Aud_NumTransaccion
	FROM CLIENTES Cli
		LEFT JOIN CANCSOCMENORCTA Cta ON Cta.ClienteID=Cli.ClienteID
	WHERE Cli.ClienteID = Cta.ClienteID
		AND Cta.FechaCancela = Par_FechaOperacion
		AND Cta.Aplicado = NoAplicado;

	UPDATE CLIENTES Cli
		LEFT JOIN CANCSOCMENORCTA Cta ON Cta.ClienteID=Cli.ClienteID
	SET Cli.Estatus			= Inactivo,
		Cli.TipoInactiva	= Tipo_Inactivacion,
		Cli.MotivoInactiva	= Desc_Inactiva,
		Cli.FechaBaja		= Par_FechaOperacion,
		Cli.Observaciones	= DesCanAutMenor,
		Cli.Usuario			= Aud_Usuario,
		Cli.FechaActual 	= Aud_FechaActual,
		Cli.DireccionIP 	= Aud_DireccionIP,
		Cli.ProgramaID  	= Procedimiento,
		Cli.Sucursal		= Aud_Sucursal,
		Cli.NumTransaccion	= Aud_NumTransaccion
	WHERE Cli.ClienteID		= Cta.ClienteID
		AND Cta.FechaCancela=Par_FechaOperacion
		AND Cta.Aplicado =NoAplicado;


	UPDATE CUENTASAHO CUE
		INNER JOIN CANCSOCMENORCTA CTA ON CTA.CuentaAhoID=CUE.CuentaAhoID
	SET
	   CUE.UsuarioDesbID 	= Aud_Usuario,
	   CUE.FechaDesbloq	 	= Par_FechaOperacion,
	   CUE.MotivoDesbloq 	= DesBloqueoMenor,
	   CUE.Estatus		 	= Activo,

	   CUE.EmpresaID		= Par_EmpresaID,
	   CUE.Usuario			= Aud_Usuario,
	   CUE.FechaActual 		= Aud_FechaActual,
	   CUE.DireccionIP 		= Aud_DireccionIP,
	   CUE.ProgramaID  		= Aud_ProgramaID,
	   CUE.Sucursal			= Aud_Sucursal,
	   CUE.NumTransaccion	= Aud_NumTransaccion
	WHERE CTA.EstatusCta=EstatusBloqueada
		AND CTA.FechaCancela=Par_FechaOperacion
		AND CTA.Aplicado =NoAplicado;

	CALL DESBCTASOCMENORPRO(
		Desbloqueo,		Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);


END IF;

	IF Par_Operacion=RetiroHaberes THEN
		SELECT MonedaBaseID, FechaSistema INTO Var_MonedaBase, Var_FechaSistema
				FROM	PARAMETROSSIS;

		OPEN CANCSOCMENORCTA;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP
			FETCH CANCSOCMENORCTA INTO
				Var_CuentaAhoID,Var_Aplicado;
				 IF (Var_Aplicado = Retirado) THEN
					SELECT '001' AS NumErr,
						'El Monto ya fue Retirado' AS ErrMen,
						'clienteIDMenor' AS control,
						Par_ClienteID AS consecutivo;
					LEAVE TerminaStore;
				END IF;
				UPDATE CANCSOCMENORCTA
					SET Aplicado		 	=RetiroHaberes,
						FechaRetiro		 	=CONVERT(CONCAT(Var_FechaSistema,' ',CURTIME()), DATETIME),
						SucursalID		 	=Par_SucursalID,
						CajaID			 	=Par_CajaID,
						Identidad	 	 	=Par_Identidad,
						NumIdentific	 	=Par_FolioIdenti
						WHERE CuentaAhoID	=Var_CuentaAhoID;

			END LOOP;
		END;
		CLOSE CANCSOCMENORCTA;
		SELECT  Cli.SucursalOrigen INTO Var_SucursalOrigen
				FROM CANCSOCMENORCTA Cta
				INNER JOIN CLIENTES Cli ON Cli.ClienteID=Cta.ClienteID
				WHERE Cta.ClienteID=Par_ClienteID LIMIT 1;
		SET Var_Descripcion:="PAGO HABERES EXMENOR";


		CALL CONTACAJAPRO(
				Aud_NumTransaccion,		Var_FechaSistema,	Par_Monto, 				Par_DescripcionMov,	Var_MonedaBase,
				Var_SucursalOrigen,  	AltaEncPolizaNO, 	Par_ConceptoConta,		Par_PolizaID,		AltaDetPolSI,
				ConceptoCaja, 			NatContableCargo, 	CONVERT(Par_CajaID,CHAR),Par_ClienteID,		Entero_cero,
				TipoInstumentoCTE, 		Par_Salida,			Par_NumErr, 			Par_ErrMen,			Par_EmpresaID, 			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
	END IF;

	SET Par_NumErr	:=Entero_cero;
	SET Par_ErrMen	:='Cancelacion del Socio Menor Realizada Exitosamente';

	IF (Par_Salida = Salida_SI) THEN
		SELECT 	CONVERT(Par_NumErr, CHAR) AS NumErr,
			Par_ErrMen AS ErrMen,
			'polizaID' AS control,
			Par_PolizaID AS consecutivo;
	END IF;


END TerminaStore$$

