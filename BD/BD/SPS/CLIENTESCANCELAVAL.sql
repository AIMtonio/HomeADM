-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESCANCELAVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESCANCELAVAL`;DELIMITER $$

CREATE PROCEDURE `CLIENTESCANCELAVAL`(
# =================================================================
# --- SP QUE REALIZA LAS VALIDACIONES PARA CANCELACION DE CUENTA---
# =================================================================
    Par_ClienteID				INT(11),
    Par_AreaCancela				CHAR(3),
    Par_Salida					CHAR(1),
	INOUT	Par_Poliza			BIGINT(20),
    INOUT	Par_NumErr 			INT(11),
    INOUT	Par_ErrMen  		VARCHAR(400),

    Par_EmpresaID				INT(11),
    Aud_Usuario					INT(11),
    Aud_FechaActual  		   	DATETIME,
    Aud_DireccionIP				VARCHAR(15),
    Aud_ProgramaID				VARCHAR(50),
    Aud_Sucursal        		INT(11),
    Aud_NumTransaccion  		BIGINT(20)
)
TerminaStore: BEGIN

	/*declaracion de variables*/
	DECLARE VarControl				CHAR(15);
	DECLARE VarEstatusCli			CHAR(1);
	DECLARE VarCantPenAct			DECIMAL(14,2);
	DECLARE VarTotalDeudaCre		DECIMAL(14,2);
	DECLARE VarSaldoTotalCue		DECIMAL(14,2);
	DECLARE Var_MontoPendiente		DECIMAL(14,2);
	DECLARE VarSaldoInversion		DECIMAL(14,2);
	DECLARE VarNumCreditos			INT(11);
	DECLARE VarNumInversion			INT(11);
	DECLARE Var_ChequesSBC			INT(11);
	DECLARE Var_ClienteID			INT(11);
	DECLARE Var_ClienteCancel		INT(11);
	DECLARE VarClienteCancelaID		INT(11);
	DECLARE VarCuentasActivas		INT(11);
	DECLARE VarSaldoDispon			DECIMAL(14,2);
	DECLARE Var_AportacionSocial	DECIMAL(12,2);
	DECLARE Var_BloqPend			INT(11);


	/*declaracion de constantes*/
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT(11);
	DECLARE	Decimal_Cero			DECIMAL(12,2);
	DECLARE	Salida_SI       		CHAR(1);
	DECLARE	Est_Registrado			CHAR(1);
	DECLARE	Est_Activo				CHAR(1);
	DECLARE	Var_AtencioSoc			CHAR(3);
	DECLARE	Var_Proteccion			CHAR(3);
	DECLARE	Var_Cobranza			CHAR(3);
	DECLARE	Est_Vigente				CHAR(1);
	DECLARE	Est_VigenteIn			CHAR(1);
	DECLARE	Est_Vencido				CHAR(1);
	DECLARE	AltaEncPolizaSI			CHAR(1);
	DECLARE	AltaEncPolizaNO			CHAR(1);
	DECLARE Var_AltaEncPoliza		CHAR(1);
	DECLARE Salida_NO				CHAR(1);
	DECLARE Var_Fecha				DATE;
	DECLARE SBCPendientes			CHAR(1);
	DECLARE Var_NO					CHAR(1);
	DECLARE TarjetaActiva			INT(11);
	DECLARE Mov_Bloq				CHAR(1);
	DECLARE Bloq_Tarjeta			INT(11);

	/* asignacion de constantes*/
	SET	Cadena_Vacia				:= '';
	SET	Fecha_Vacia					:= '1900-01-01';
	SET	Entero_Cero					:= 0;
	SET	Decimal_Cero				:= 0.0;
	SET Est_Registrado				:= 'R';
	SET Est_Activo					:= 'A';
	SET Salida_SI					:= 'S';
	SET Var_AtencioSoc				:= 'Soc';
	SET Var_Proteccion				:= 'Pro';
	SET Var_Cobranza				:= 'Cob';
	SET Est_Vigente					:= 'V';
	SET Est_VigenteIn				:= 'N';
	SET Est_Vencido					:= 'B';
	SET AltaEncPolizaSI				:= 'S';
	SET AltaEncPolizaNO				:= 'N';
	SET SBCPendientes				:= 'R';
	SET Var_NO						:= 'N';
	SET TarjetaActiva				:= 7;
	SET Mov_Bloq					:= 'B';
	SET Bloq_Tarjeta				:= 3;

	/* asignacion de variables */
	SET Par_NumErr  				:= Entero_Cero;
	SET Par_ErrMen  				:= Cadena_Vacia;
	SET Aud_FechaActual 			:= NOW();
	SET Salida_NO					:= 'N';
	SET Var_Fecha					:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-CLIENTESCANCELAVAL');
		END;

		SET Var_ClienteID := (SELECT ClienteID FROM CLIENTES WHERE ClienteID = Par_ClienteID);
		IF(IFNULL(Var_ClienteID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr   := 001;
			SET Par_ErrMen   := 'El safilocale.cliente No Existe';
			SET VarControl   := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		SET VarEstatusCli := (SELECT Estatus FROM CLIENTES WHERE ClienteID = Par_ClienteID);
		IF(IFNULL(VarEstatusCli, '') = "I") THEN
			SET Par_NumErr   := 002;
			SET Par_ErrMen   := 'El safilocale.cliente esta Inactivo.';
			SET VarControl   := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		/*se valida que el cliente tenga al menos una cuenta Activa*/
		SET VarCuentasActivas:= (SELECT COUNT(CuentaAhoID)
									FROM 	CUENTASAHO
                                    WHERE 	ClienteID 	= Par_ClienteID
                                    AND 	Estatus 	= Est_Activo);

		SET VarCuentasActivas:= IFNULL(VarCuentasActivas, Entero_Cero);
		IF( VarCuentasActivas = 0)THEN
			SET Par_NumErr   := 003;
			SET Par_ErrMen   := CONCAT('El safilocale.cliente debe tener al menos una cuenta activa');
			SET VarControl   := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		/* Se valida que el cliente no tenga Chekouts pendientes */
		SET Var_BloqPend := (SELECT COUNT(BloqueoID)
								FROM 	BLOQUEOS  BLO,
										CUENTASAHO CUE
								WHERE	BLO.CuentaAhoID	= CUE.CuentaAhoID
								AND 	CUE.ClienteID 	= Par_ClienteID
								AND		NatMovimiento	= Mov_Bloq
								AND 	TiposBloqID 	= Bloq_Tarjeta
                                AND 	FolioBloq		= Entero_Cero);

		IF( IFNULL(Var_BloqPend,Entero_Cero) <> Entero_Cero)THEN
			SET Par_NumErr   := 004;
			SET Par_ErrMen   := CONCAT('El safilocale.cliente tiene CHECK OUT Pendientes');
			SET VarControl   := 'clienteID';
			LEAVE ManejoErrores;
		END IF;



		SET Var_ClienteCancel :=(SELECT ClienteCancelaID
									FROM 	CLIENTESCANCELA Can,
											MOTIVACTIVACION Mot
									WHERE	ClienteID 			= Par_ClienteID
									AND 	Can.MotivoActivaID 	= Mot.MotivoActivaID
									AND 	PermiteReactivacion	= Var_NO LIMIT 1);
		IF(IFNULL(Var_ClienteCancel,Entero_Cero) != Entero_Cero) THEN
			SET Par_NumErr   := 005;
			SET Par_ErrMen   := CONCAT('El safilocale.cliente ya Cuenta con una Solicitud de Cancelacion con folio: ', CONVERT(Var_ClienteCancel,CHAR));
			SET VarControl   := 'clienteID';
			LEAVE ManejoErrores;
		END IF;


		SET Var_MontoPendiente := (SELECT MontoPendiente FROM CLICOBROSPROFUN WHERE ClienteID = Par_ClienteID);
		SET Var_MontoPendiente := IFNULL(Var_MontoPendiente, Decimal_Cero);

		IF(Var_MontoPendiente > Decimal_Cero)THEN
			SET VarSaldoDispon   := (SELECT	SUM(CA.Saldo)
										FROM	CLICOBROSPROFUN OP,
												CLIENTESPROFUN	CP,
												CUENTASAHO		CA,
												CLIENTES		CL
										WHERE	OP.ClienteID 		= CP.ClienteID
										AND		OP.ClienteID 		= CA.ClienteID
										AND		CA.ClienteID 		= CL.ClienteID
										AND		(CP.Estatus			= Est_Registrado
										OR		CP.Estatus			= 'I')
										AND		OP.MontoPendiente 	> Decimal_Cero
										AND		CA.Saldo 			> Decimal_Cero
										AND		OP.ClienteID 		= Par_ClienteID);

			SET VarSaldoDispon	:= IFNULL(VarSaldoDispon, Decimal_Cero);

			SET VarSaldoInversion	:= (SELECT SUM(Monto + SaldoProvision)
											FROM 	INVERSIONES
											WHERE	Estatus		= Est_VigenteIn
											AND		ClienteID	= Par_ClienteID) ;
			SET VarSaldoInversion	:= IFNULL(VarSaldoInversion, Decimal_Cero);
			SET VarSaldoDispon		:= VarSaldoDispon + VarSaldoInversion;

			SET Var_AportacionSocial	:= (SELECT IFNULL(Saldo, Decimal_Cero) FROM APORTACIONSOCIO WHERE ClienteID = Par_ClienteID);
			SET Var_AportacionSocial	:= IFNULL(Var_AportacionSocial, Decimal_Cero);

			SET VarSaldoDispon	:= VarSaldoDispon + Var_AportacionSocial;
			IF(Var_MontoPendiente > VarSaldoDispon)THEN
				SET Par_NumErr	:= '006';
				SET Par_ErrMen	:= CONCAT('El safilocale.cliente Tiene Monto Pendiente de Pago por Mutuales, <br>favor de pasar a ventanilla a realizar un abono a cuenta por: $ ',
										   CONVERT(FORMAT(Var_MontoPendiente-VarSaldoDispon,2),CHAR),'.');
				LEAVE ManejoErrores;
			END IF;
		END IF;


		SET Var_ChequesSBC:=(SELECT csbc.ChequeSBCID
								FROM 	ABONOCHEQUESBC csbc
								WHERE 	csbc.ClienteID	= Par_ClienteID
								AND 	csbc.Estatus 	= SBCPendientes
                                LIMIT 	1);


		SET Var_ChequesSBC:= IFNULL(Var_ChequesSBC, Entero_Cero);

		IF( Var_ChequesSBC > Entero_Cero ) THEN
			SET Par_NumErr  := '007';
			SET Par_ErrMen  := CONCAT('El safilocale.cliente : ',CONVERT(Par_ClienteID,CHAR),' Tiene Cheques SBC Pendientes de Aplicar.');
			SET varControl	:= 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		CASE Par_AreaCancela
			WHEN Var_AtencioSoc	THEN


				SET VarCantPenAct := (SELECT SUM(CantPenAct)
										FROM 	COBROSPEND
										WHERE	ClienteID  = Par_ClienteID);

				SET VarCantPenAct := IFNULL(VarCantPenAct, Decimal_Cero);

				IF( VarCantPenAct > Decimal_Cero ) THEN
					SET Par_NumErr  := 008;
					SET Par_ErrMen  := CONCAT('El safilocale.cliente ',Par_ClienteID,' tiene Cargos Pendientes, es Necesario Liquidarlos');
					SET varControl	:= 'clienteID';
					LEAVE ManejoErrores;
				END IF;

				SET VarNumCreditos	:= (SELECT COUNT(CreditoID)
											FROM 	CREDITOS
											WHERE	(Estatus	= Est_Vigente
											OR 		Estatus		= Est_Vencido)
											AND 	ClienteID 	= Par_ClienteID);

				SET VarNumCreditos	:= IFNULL(VarNumCreditos, Decimal_Cero);

				IF( VarNumCreditos > Entero_Cero ) THEN
					SET Par_NumErr  := 009;
					SET Par_ErrMen  := CONCAT('El safilocale.cliente : ',Par_ClienteID,' Presenta Creditos Activos');
					SET varControl	:= 'clienteID';
					LEAVE ManejoErrores;
				END IF;

				SET VarNumInversion	:= (SELECT COUNT(Est_VigenteIn)
											FROM 	INVERSIONES
											WHERE 	Estatus		= Est_VigenteIn
											AND 	ClienteID 	= Par_ClienteID);

				SET VarNumInversion	:= IFNULL(VarNumInversion, Decimal_Cero);

				IF( VarNumInversion > Entero_Cero ) THEN
					SET Par_NumErr  := '010';
					SET Par_ErrMen  := CONCAT('El safilocale.cliente : ',Par_ClienteID,' Presenta Inversiones Activas');
					SET varControl	:= 'clienteID';
					LEAVE ManejoErrores;
				END IF;

				IF EXISTS (SELECT Estatus
							FROM 	CEDES
							WHERE	(ClienteID  = Par_ClienteID AND Estatus = Est_VigenteIn)
							OR 		(ClienteID  = Par_ClienteID AND Estatus = Est_Activo)
                            LIMIT 	1) THEN
					SET Par_NumErr 	:= 7;
					SET Par_ErrMen  := CONCAT('El safilocale.cliente : ',Par_ClienteID,'  Presenta CEDES Activos.');
					SET varControl	:= 'clienteID';
					LEAVE ManejoErrores;
				END IF;

				IF EXISTS (SELECT Estatus FROM APORTACIONES
							WHERE ClienteID = Par_ClienteID AND Estatus IN (Est_VigenteIn,Est_Activo)) THEN
					SET Par_NumErr 	:= 8;
					SET Par_ErrMen  := CONCAT('El safilocale.cliente : ',Par_ClienteID,'  Presenta Aportaciones Activas.');
					SET varControl	:= 'clienteID';
					LEAVE ManejoErrores;
				END IF;

				SET Par_NumErr  := 000;
				SET Par_ErrMen  := CONCAT('Validacion Realizada Exitosamente.');
				SET varControl	:= 'clienteID';
			WHEN Var_Proteccion	THEN

				SET Par_NumErr  := 000;
				SET Par_ErrMen  := CONCAT('Validacion Realizada Exitosamente.');
				SET varControl	:= 'clienteID';
			WHEN Var_Cobranza	THEN

				SET VarCantPenAct := (SELECT SUM(CantPenAct)
										FROM 	COBROSPEND
										WHERE	ClienteID  = Par_ClienteID);

				SET VarCantPenAct := IFNULL(VarCantPenAct, Decimal_Cero);

				IF( VarCantPenAct > Decimal_Cero ) THEN
					SET Par_NumErr  := 1;
					SET Par_ErrMen  := CONCAT('El safilocale.cliente ',Par_ClienteID,' tiene Cargos Pendientes, es Necesario Liquidarlos');
					SET varControl	:= 'clienteID';
					LEAVE ManejoErrores;
				END IF;



				SET VarTotalDeudaCre := (SELECT SUM(FUNCIONTOTDEUDACRE(CreditoID))
											FROM 	CREDITOS
											WHERE	ClienteID 	= Par_ClienteID
											AND		(Estatus	= Est_Vigente
											OR 		Estatus		= Est_Vencido));
				SET VarTotalDeudaCre := IFNULL(VarTotalDeudaCre, Decimal_Cero);

				IF(VarTotalDeudaCre > Decimal_Cero)THEN
					SET VarSaldoTotalCue	:= (SELECT SUM(Saldo)
													FROM 	CUENTASAHO
													WHERE 	ClienteID = Par_ClienteID);
					SET VarSaldoTotalCue	:= IFNULL(VarSaldoTotalCue, Decimal_Cero);

					SET VarSaldoInversion	:= (SELECT SUM(Monto + SaldoProvision)
													FROM 	INVERSIONES
													WHERE	Estatus		= Est_VigenteIn
													AND		ClienteID	= Par_ClienteID) ;
					SET VarSaldoInversion	:= IFNULL(VarSaldoInversion, Decimal_Cero);

					SET Var_MontoPendiente	:= (SELECT MontoPendiente FROM CLICOBROSPROFUN WHERE ClienteID = Par_ClienteID);
					SET Var_MontoPendiente	:= IFNULL(Var_MontoPendiente, Decimal_Cero);
					SET VarSaldoTotalCue	:= VarSaldoTotalCue - Var_MontoPendiente + VarSaldoInversion;
					SET VarSaldoTotalCue	:= IFNULL(VarSaldoTotalCue, Decimal_Cero);
					IF(VarSaldoTotalCue < VarTotalDeudaCre)THEN
						SET Par_NumErr  := 10;
						SET Par_ErrMen  := CONCAT('El safilocale.cliente ',Par_ClienteID,' no Alcanza Cubrir el Adeudo de sus Creditos con el Saldo de las Cuentas.');
						SET varControl	:= 'clienteID';
						LEAVE ManejoErrores;
					END IF;
				END IF;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := CONCAT('Validacion Realizada Exitosamente.');
			SET varControl	:= 'clienteID';
		ELSE

			SET Par_NumErr  := 011;
			SET Par_ErrMen  := CONCAT('El Area Que Cancela no es Valida.');
			SET varControl	:= 'areaCancela';
		END CASE ;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				varControl		AS control,
				Par_ClienteID	AS consecutivo;
	END IF;
END TerminaStore$$