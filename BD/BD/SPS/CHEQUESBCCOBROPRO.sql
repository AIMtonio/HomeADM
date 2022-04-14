-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CHEQUESBCCOBROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CHEQUESBCCOBROPRO`;
DELIMITER $$

CREATE PROCEDURE `CHEQUESBCCOBROPRO`(
# ==================================================================================
# ----------- SP PARA REALIZAR EL COBRO DE CHEQUES DE VENTANILLA--------------------
# ==================================================================================
	Par_CuentaAhoID			BIGINT(12),			-- Cuenta de Ahorro a la cual se va a depositar
	Par_ClienteID			INT(11), 			-- Numero de Cte de la Cuenta a la Cual se va a depositar
	Par_NombreReceptor		VARCHAR(200),		-- Nombre del Cliente que Cobra el el cheque(Corresponde con cliente de la cta)
	Par_Monto				DECIMAL(14,2),
	Par_BancoEmisor			INT(11),			-- Banco que emite el cheque

	Par_CuentaEmisor		VARCHAR(12),		-- Numero de Cta(del Cheque)
	Par_NumCheque			BIGINT(10),			-- Numero de Cheque
	Par_NombreEmisor		VARCHAR(200),		-- Nombre del emisor del Cheque
	Par_SucursalID			INT(11),			-- Sucursal en la que se realiza la operacion
	Par_CajaID				INT(11),			-- Caja en la que se realiza la operacion

	Par_UsuarioID			INT(11),			-- Usuario que realiza la operacion
	Par_TipoCuentaCheque	CHAR(1),			-- Tipo de Cuenta del Cheque (Interna,Externa)
	Par_FormaCobro			CHAR(1),			-- Forma de Cobro(Efectivo, Deposito a Cta)
	Par_PolizaID			BIGINT(20),			-- PolizaID
    Par_TipoChequera		CHAR(2),			-- Tipo Chequera P- PROFORMA, E-ESTANDAR

	Par_Salida				CHAR(1),
	INOUT	Par_NumErr 		INT(11),
	INOUT	Par_ErrMen  	VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario         	INT(11),
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP     	VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal        	INT(11),
	Aud_NumTransaccion  	BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaOper			DATE;
	DECLARE Var_FechaApl			DATE;
	DECLARE Var_EsHabil				CHAR(1);
	DECLARE Var_CtaContaDocSBCD		VARCHAR(25);
	DECLARE Var_CtaContaDocSBCA		VARCHAR(25);
	DECLARE Var_Poliza				BIGINT(20);
	DECLARE Var_MonedaBaseID		INT(11);
	DECLARE Var_NumErrChar			CHAR(4);
	DECLARE Var_NumErrInt			INT(11);
	DECLARE Var_EstatusCheque		CHAR(1);
	DECLARE Var_CuentaAhoTeso		INT(12);
	DECLARE Var_CentroCostos		VARCHAR(30);
	DECLARE Var_SucCliente			INT(11);
    DECLARE VarControl 				VARCHAR(15);

	-- Declaracion de Constantes
	DECLARE SalidaNO				CHAR(1);
	DECLARE SalidaSI				CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;

	DECLARE Est_Activa				CHAR(1);
	DECLARE CuentaInterna			CHAR(1);
	DECLARE CuentaExterna			CHAR(1);
	DECLARE CobroDepositoCta		CHAR(1);
	DECLARE CobroEfectivo			CHAR(1);

	DECLARE Pol_Automatica			CHAR(1);
	DECLARE ConceptoCon				INT(11);
	DECLARE DescripcionMov			VARCHAR(100);
	DECLARE DescripconCargo			VARCHAR(100);
	DECLARE DescripconAbono			VARCHAR(100);

	DECLARE Procedimiento			VARCHAR(100);
	DECLARE NatMovAbono				CHAR(1);
	DECLARE ActAplicado				INT(1);
	DECLARE DescripcionMovFirme		VARCHAR(100);
	DECLARE AltaEncPolizaSI			CHAR(1);

	DECLARE AltaEncPolizaNO			CHAR(1);
	DECLARE AltaDetPolizaSI			CHAR(1);
	DECLARE ConceptoConFirme		INT(11);
	DECLARE ConTesoreria			INT(11);
	DECLARE NatContaCargo			CHAR(1);

	DECLARE NatContaAbono			CHAR(1);
	DECLARE NatAhorroAbono			CHAR(1);
	DECLARE AltaMovAhoSI			CHAR(1);
	DECLARE AltaMovAhoNO			CHAR(1);
	DECLARE TipoMovAho				CHAR(4);

	DECLARE ConceptoAhorro			INT(11);
	DECLARE NoConciliado			CHAR(1);
	DECLARE NatMovTesoCargo			CHAR(1);
	DECLARE RegistroPantalla		CHAR(1);
	DECLARE TipoMovTeso				CHAR(4);

	DECLARE NatOpeTesoCargo			CHAR(1);
	DECLARE Consecutivo				INT(11);
	DECLARE TipoInstrumentoID		INT(11);
	DECLARE For_SucOrigen			CHAR(3);
	DECLARE For_SucCliente			CHAR(3);

	DECLARE Var_AfectaContaRecSBC	CHAR(1);
	DECLARE SI						CHAR(1);
	DECLARE Est_Cancelado			CHAR(1);
	DECLARE Decimal_Cero			DECIMAL(14,2);
    DECLARE ActPagado				INT(1);
    DECLARE Est_Pagado				CHAR(1);
    DECLARE Est_Reemplazado			CHAR(1);
    DECLARE Est_Conciliado  		CHAR(1);
    DECLARE Var_CentroCostosID		INT(11);

	-- Asignacion de Constantes
	SET SalidaNO					:= 'N';									-- Salida NO.
	SET SalidaSI					:= 'S';									-- Salida SI
	SET Entero_Cero					:= 0;									-- Entero Cero
	SET Cadena_Vacia				:= '';									-- Cadena Vacia
	SET Fecha_Vacia					:= '1900-01-01'; 						-- Fecha Vacia

	SET Est_Activa					:= 'A';									-- Cuenta Activa
	SET CuentaInterna				:= 'I';									-- Cuenta Interna del Cliente
	SET	CuentaExterna				:= 'E';									-- Cuenta Externa
	SET CobroDepositoCta			:= 'D';									-- Se deposita el cheque a una Cuenta de ahorro
	SET	CobroEfectivo				:= 'E';									-- El Cliente se lleva el Dinero en Efectivo

	SET Pol_Automatica				:= 'A';									-- Poliza Automatica
	SET ConceptoCon					:= 42;									-- Concepto Contable Corresponde con CONCEPTOSCONTA
	SET DescripcionMov				:= 'DCTOS SALVO BUEN COBRO SBC'; 		-- Descripcion del movimiento
	SET DescripconCargo				:= 'DCTOS  DE COBRO INMEDIATO SALVO BUEN COBRO COD';
	SET DescripconAbono				:= 'DCTOS  DE COBRO INMEDIATO SALVO BUEN COBRO COA';
	SET Procedimiento				:= 'CHEQUESBCCOBROPRO';
	SET NatMovAbono					:= 'A';									-- Naturaleza del Movimiento de Ahorro(ABONO)

	SET ActAplicado					:= 1;									-- Numero de Actualizacion para aplicar el Cheque interno
	SET DescripcionMovFirme			:= 'COBRO CHEQUE SBC EN FIRME';			-- Descripcion del movimiento
	SET AltaEncPolizaSI				:= 'S';									-- Agregar el encabezado de la poliza
	SET AltaEncPolizaNO				:= 'N';									-- Alta en encabezado de la poliza
	SET AltaDetPolizaSI				:= 'S';									-- Alta en detalle de la poliza SI
	SET ConceptoConFirme			:= 43;									-- Concepto Contable(COBRO CHEQUE SBC EN FIRME)
	SET ConTesoreria				:= 1;									-- Concepto de Tesoreria
	SET NatContaCargo				:= 'C';									-- Naturaleza Contable Cargo
	SET NatContaAbono				:= 'A';									-- Naturaleza Contable Abono

	SET NatAhorroAbono				:= 'A';									-- Naturaleza del Ahorro (ABONO)
	SET AltaMovAhoSI				:= 'S';									-- Alta de movimiento de Ahorro SI
	SET AltaMovAhoNO				:= 'N';									-- Alta de Movimiento de Ahorro NO
	SET TipoMovAho					:= '27';									-- Tipo de Movimiento de Ahorro(DEPOSITO CHEQUE SBC EN FIRME)
	SET ConceptoAhorro				:= 1;									-- Concepto Ahorro(1 PASIVO)
	SET NoConciliado				:= 'N';									-- Estatus no Conciliado
	SET NatMovTesoCargo				:= 'A';									-- Movimiento de Abono de Tesoreria
	SET RegistroPantalla			:= 'P';									-- Registro por pantalla
	SET TipoMovTeso					:= '500';								-- Tipo de corresponde con la tablas TIPOSMOVSTESO
	SET NatOpeTesoCargo				:= 'A';									-- Naturaleza de Tesoreria Abono
	SET	Consecutivo					:= 0;									-- Consecutivo
	SET TipoInstrumentoID			:= 9;									-- Tipo de Instrumento CHEQUE SBC (BANCO)
	SET For_SucOrigen				:= '&SO';								-- Sucursal Origen --
	SET For_SucCliente				:= '&SC';								-- Sucursal Cliente --
	SET SI							:= "S";
	SET Est_Cancelado				:= 'C';									-- Estatus Cancelado (cheque) --
	SET Decimal_Cero				:= 0.00;
    SET ActPagado					:= 2;
    SET Est_Pagado					:= 'P';
    SET Est_Reemplazado				:= 'R';
    SET Est_Conciliado  			:= 'O';
    SET Var_CentroCostosID			:= 0;

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										 'Disculpe las molestias que esto le ocasiona. Ref: SP-CHEQUESBCCOBROPRO');
				SET VarControl = 'sqlException';
			END;

		SET Aud_FechaActual := NOW();
		SET Var_NumErrChar	:='';

		SELECT	 CtaContaDocSBCD, 		CtaContaDocSBCA, 		MonedaBaseID,		FechaSistema, CenCostosChequeSBC
			INTO Var_CtaContaDocSBCD, 	Var_CtaContaDocSBCA, 	Var_MonedaBaseID,	Var_FechaOper, Var_CentroCostos
			FROM 	PARAMETROSSIS
			WHERE	EmpresaID = Par_EmpresaID
			LIMIT 1;


		CALL DIASFESTIVOSCAL(
			Var_FechaOper,		Entero_Cero,		 Var_FechaApl,		Var_EsHabil,		Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);


		IF EXISTS(SELECT ChequeSBCID
					FROM	ABONOCHEQUESBC
					WHERE	BancoEmisor		= Par_BancoEmisor
					AND 	CuentaEmisor	= Par_CuentaEmisor
					AND 	NumCheque 	 	= Par_NumCheque)THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := CONCAT('El Cheque SBC ya se encuentra Registrado en el Sistema');
			LEAVE ManejoErrores;
		END IF;

		IF (Par_TipoCuentaCheque = CuentaInterna)THEN
			SET	Var_EstatusCheque	:='A';
			SET Par_NombreEmisor	:= (SELECT   Ins.NombreCorto
											FROM PARAMETROSSIS Par
											INNER JOIN INSTITUCIONES AS Ins ON Par.InstitucionID = Ins.InstitucionID
											WHERE Par.EmpresaID = Par_EmpresaID);
		ELSE
			SET Var_EstatusCheque	:='R';
		END IF;

		-- Damos de alta los movimientos de cheques SBC
		CALL ABONOCHEQUESBCALT(
			Par_CuentaAhoID,Par_ClienteID,		Par_NombreReceptor,		Var_EstatusCheque,	Par_Monto,
			Par_BancoEmisor,Par_CuentaEmisor,	Par_NumCheque,			Par_NombreEmisor,	Par_SucursalID,
			Par_CajaID,		Var_FechaOper,		Fecha_Vacia,			Par_UsuarioID,		Entero_Cero,
			Cadena_Vacia,	Entero_Cero,		Par_TipoCuentaCheque,	Par_FormaCobro,		SalidaNO,
			Par_NumErr,		Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		IF (Par_TipoCuentaCheque = CuentaInterna)THEN -- Cuenta Interna(Se recibe el Cheque en Firme)
				-- Se hace el Cargo a la Cuenta de Bancos independientemente de la forma de Cobro (Alata en encabezado de la poliza)
			IF NOT EXISTS(SELECT  InstitucionID FROM INSTITUCIONES
							WHERE InstitucionID = Par_BancoEmisor)THEN
				SET	Par_NumErr 	:= 2;
				SET	Par_ErrMen	:= "La Institucion Indicada no Existe";
				LEAVE ManejoErrores;
			END IF;

			SELECT  CuentaAhoID INTO Var_CuentaAhoTeso
				FROM 	CUENTASAHOTESO
				WHERE 	InstitucionID	= Par_BancoEmisor
				AND 	NumCtaInstit	= Par_CuentaEmisor;

			IF(IFNULL(Var_CuentaAhoTeso,Entero_Cero ) = Entero_Cero)THEN
				SET	Par_NumErr 	:= 3;
				SET	Par_ErrMen	:= "La Cuenta del Banco Emisor no Existe ";
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS(SELECT  NumeroCheque
						    FROM 	CHEQUESEMITIDOS
						   	WHERE 	InstitucionID 		= Par_BancoEmisor
							AND 	CuentaInstitucion	= Par_CuentaEmisor
							AND 	NumeroCheque 		= Par_NumCheque
                            AND		TipoChequera		= Par_TipoChequera)THEN
				SET	Par_NumErr 	:= 4;
				SET	Par_ErrMen	:= "El Numero de Cheque para el Banco y Numero de Cuenta Indicados no Existe ";
				LEAVE ManejoErrores;
			END IF;

			IF EXISTS(SELECT  NumeroCheque
						FROM 	CHEQUESEMITIDOS
					   	WHERE 	InstitucionID 		= Par_BancoEmisor
						AND 	CuentaInstitucion 	= Par_CuentaEmisor
                        AND		TipoChequera		= Par_TipoChequera
						AND 	NumeroCheque 		= Par_NumCheque
						AND 	Estatus 			= Est_Pagado)THEN
				SET	Par_NumErr 	:= 5;
				SET	Par_ErrMen	:= "El Cheque Indicado se Encuentra Pagado ";
				LEAVE ManejoErrores;
			END IF;

			IF EXISTS(SELECT  NumeroCheque
						FROM  	CHEQUESEMITIDOS
						WHERE 	InstitucionID 		= Par_BancoEmisor
						AND 	CuentaInstitucion 	= Par_CuentaEmisor
                        AND 	TipoChequera		= Par_TipoChequera
						AND 	NumeroCheque		= Par_NumCheque
						AND 	Estatus 			= Est_Cancelado)THEN
				SET	Par_NumErr 	:= 6;
				SET	Par_ErrMen	:= "El Cheque Indicado se Encuentra Cancelado ";
				LEAVE ManejoErrores;
			END IF;

			IF EXISTS(SELECT  NumeroCheque
						FROM  	CHEQUESEMITIDOS
						WHERE 	InstitucionID 		= Par_BancoEmisor
						AND 	CuentaInstitucion 	= Par_CuentaEmisor
                        AND 	TipoChequera		= Par_TipoChequera
						AND 	NumeroCheque		= Par_NumCheque
						AND 	Estatus 			= Est_Reemplazado)THEN
				SET	Par_NumErr 	:= 7;
				SET	Par_ErrMen	:= "El Cheque Indicado se Encuentra Reemplazado ";
				LEAVE ManejoErrores;
			END IF;

			IF EXISTS(SELECT  NumeroCheque
						FROM  	CHEQUESEMITIDOS
						WHERE 	InstitucionID 		= Par_BancoEmisor
						AND 	CuentaInstitucion 	= Par_CuentaEmisor
                        AND 	TipoChequera		= Par_TipoChequera
						AND 	NumeroCheque		= Par_NumCheque
						AND 	Estatus 			= Est_Conciliado)THEN
				SET	Par_NumErr 	:= 8;
				SET	Par_ErrMen	:= "El Cheque Indicado se Encuentra Conciliado ";
				LEAVE ManejoErrores;
			END IF;

			CALL CONTATESOREPRO(
				Aud_Sucursal,     	Var_MonedaBaseID,   Par_BancoEmisor,  	Par_CuentaEmisor,	Entero_Cero,
				Entero_Cero,    	Entero_Cero,        Var_FechaOper,		Var_FechaApl,       Par_Monto,
				DescripcionMovFirme,Par_CuentaEmisor,	Par_NumCheque, 		AltaEncPolizaNO,    Par_PolizaID,
				ConceptoConFirme,	Entero_Cero,        NatContaCargo,      AltaMovAhoNO,     	Par_CuentaAhoID,
				Par_ClienteID,      TipoMovAho,       	Cadena_Vacia,       SalidaNO,			Par_NumErr,
				Par_ErrMen, 		Consecutivo,    	Par_EmpresaID,      Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;


			CALL TESORERIAMOVALT(--  se insertan los movimientos operativos de tesoreria
				Var_CuentaAhoTeso,	Var_FechaOper, 		Par_Monto,       	DescripcionMovFirme, 	CONCAT("CHEQUE:",Par_NumCheque),
				NoConciliado,      	NatMovTesoCargo,	RegistroPantalla,   TipoMovTeso,     		Aud_NumTransaccion,
				SalidaNO,          	Par_NumErr,     	Par_ErrMen,         Consecutivo,    		Par_EmpresaID,
				Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     	Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr <>  Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;


			CALL SALDOSCUENTATESOACT( --  se actualiza el saldo de la cuenta bancaria
				Par_CuentaEmisor,	Par_BancoEmisor,		Par_Monto,			NatOpeTesoCargo,	Entero_Cero,
				SalidaNO,			Par_NumErr,       		Par_ErrMen,     	Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,   		Aud_ProgramaID, 	Aud_Sucursal,     	Aud_NumTransaccion);

			IF(Par_NumErr <>  Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			IF(Par_FormaCobro = CobroDepositoCta)THEN
				IF(Par_CuentaAhoID = Entero_Cero)THEN
					SET	Par_NumErr 	:= 5;
					SET	Par_ErrMen	:= 'El Numero de Cuenta esta Vacio';
					LEAVE ManejoErrores;
				END IF;

				IF NOT EXISTS(SELECT CuentaAhoID
								FROM 	CUENTASAHO
								WHERE 	CuentaAhoID	= Par_CuentaAhoID)THEN
					SET Par_NumErr :=6;
					SET Par_ErrMen := CONCAT('La Cuenta de Ahorro Indicada no Existe');
					LEAVE ManejoErrores;
				END IF;

				IF EXISTS(SELECT Estatus
							FROM 	CUENTASAHO
							WHERE 	Estatus 		!= Est_Activa
							AND 	CuentaAhoID	 	= Par_CuentaAhoID)THEN
					SET Par_NumErr :=7;
					SET Par_ErrMen := CONCAT('La Cuenta ',Par_CuentaAhoID, ' no se encuentra Activa');
					LEAVE ManejoErrores;
				END IF;

				IF (IFNULL(Par_ClienteID,Entero_Cero) = Entero_Cero)THEN

					SET Par_ClienteID	:= (SELECT ClienteID FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID);
					SET Par_ClienteID	:= IFNULL(Par_ClienteID, Entero_Cero);

				END IF;

				-- Se realiza el abono a la cuenta Cundo el cobro es deposito a Cta. se abona a Cajas.
				-- el sp CONTAAHORROPRO genera los movimientos operativos y contables
				CALL CONTAAHOPRO(
						Par_CuentaAhoID,	Par_ClienteID,		Aud_NumTransaccion,		Var_FechaOper,		Var_FechaApl,
						NatMovAbono,		Par_Monto,  		DescripcionMovFirme,	Par_NumCheque,		TipoMovAho,
						Var_MonedaBaseID,	Entero_Cero,		AltaEncPolizaNO, 		ConceptoConFirme,	Par_PolizaID,
						AltaDetPolizaSI,	ConceptoAhorro,		NatContaAbono,			Entero_Cero,		SalidaNO,
						Par_NumErr,			Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

				IF(Par_NumErr <>  Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			END IF; -- Forma de Cobro Deposito a Cuenta
			-- Actualizamos el status del Cheque a Aplicado

			CALL CHEQUESEMITIDOSACT(
				Par_BancoEmisor,	Par_CuentaEmisor,	Par_NumCheque,	Par_TipoChequera,	ActPagado,
                SalidaNO,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,
                Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_ErrMen <>  Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;-- If cuenta interna


		IF (Par_TipoCuentaCheque = CuentaExterna)THEN -- Cuenta Externa(Se recibe el Cheque como SBC)
			IF(Par_CuentaAhoID = Entero_Cero)THEN
				SET	Par_NumErr 	:= 8;
				SET	Par_ErrMen	:= 'El Numero de Cuenta esta Vacio';
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS(SELECT CuentaAhoID
							FROM 	CUENTASAHO
							WHERE	CuentaAhoID	= Par_CuentaAhoID)THEN
				SET Par_NumErr :=9;
				SET Par_ErrMen := CONCAT('La Cuenta de Ahorro Indicada no Existe');
				LEAVE ManejoErrores;
			END IF;

			IF EXISTS(SELECT Estatus
						FROM 	CUENTASAHO
						WHERE 	Estatus 	!= Est_Activa
						AND 	CuentaAhoID	= Par_CuentaAhoID)THEN
				SET Par_NumErr :=10;
				SET Par_ErrMen := CONCAT('La Cuenta ',Par_CuentaAhoID, ' no se encuentra Activa');
				LEAVE ManejoErrores;
			END IF;

			IF(Par_ClienteID = Entero_Cero)THEN
				SET	Par_NumErr 	:= 11;
				SET	Par_ErrMen	:= 'El Numero de Cliente esta Vacio';
				LEAVE ManejoErrores;
			END IF;

		-- Actualizamos el Campo  del Saldo SBC en la Cuenta de Ahorro
			UPDATE CUENTASAHO SET
				SaldoSBC 			= SaldoSBC + Par_Monto,

				Usuario         	= Aud_Usuario,
				FechaActual     	= Aud_FechaActual,
				DireccionIP     	= Aud_DireccionIP,
				ProgramaID      	= Aud_ProgramaID,
				Sucursal        	= Aud_Sucursal,
				NumTransaccion  	= Aud_NumTransaccion
				WHERE CuentaAhoID	= Par_CuentaAhoID;

			SET Par_CajaID  := CONVERT(Par_CajaID, CHAR);

			SELECT 	SucursalOrigen INTO Var_SucCliente
				FROM CLIENTES
				WHERE ClienteID	= Par_ClienteID
				LIMIT 1;

			IF LOCATE(For_SucOrigen, Var_CentroCostos) > 0 THEN
				SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
			ELSE
				IF LOCATE(For_SucCliente, Var_CentroCostos) > 0 THEN
					IF (Var_SucCliente > 0) THEN
						SET Var_CentroCostosID := FNCENTROCOSTOS(Var_SucCliente);
					ELSE
						SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
					END IF;
				END IF;
			END IF;

			SELECT   AfectaContaRecSBC	INTO Var_AfectaContaRecSBC
				FROM PARAMETROSSIS
				WHERE EmpresaID =Par_EmpresaID
				LIMIT 1;

			IF IFNULL(Var_AfectaContaRecSBC,"N")=SI THEN
			/*  se Realiza el detalle de abono */
                CALL DETALLEPOLIZASALT(
					Par_EmpresaID,			Par_PolizaID,		Var_FechaOper, 		Var_CentroCostosID,	Var_CtaContaDocSBCD,
					Par_NumCheque,			Var_MonedaBaseID,	Par_Monto,			Decimal_Cero,		DescripconCargo,
					Par_CuentaEmisor,		Procedimiento,		TipoInstrumentoID,	Cadena_Vacia,		Decimal_Cero,
					Cadena_Vacia,			SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr <>  Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

		/*  se Realiza el detalle de Cargo */
            	CALL DETALLEPOLIZASALT (
					Par_EmpresaID,			Par_PolizaID,		Var_FechaOper, 		Var_CentroCostosID,	Var_CtaContaDocSBCA,
					Par_NumCheque,			Var_MonedaBaseID,	Decimal_Cero,		Par_Monto,			DescripconAbono,
					Par_CuentaEmisor,		Procedimiento,		TipoInstrumentoID,	Cadena_Vacia,		Decimal_Cero,
					Cadena_Vacia,			SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr <>  Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;-- If Cuenta Externa

		SET Par_NumErr	:= 0;
		SET Par_ErrMen 	:= 'Cheque Cobrado Exitosamente';


	END ManejoErrores;  -- End del Handler de Errores

	 IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'tipoOperacion' AS control,
				Par_PolizaID AS consecutivo;
	END IF;

END TerminaStore$$