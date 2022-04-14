-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESCANCELPAGPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESCANCELPAGPRO`;
DELIMITER $$

CREATE PROCEDURE `CLIENTESCANCELPAGPRO`(
	Par_CliCancelaEntregaID	INT(11),
	Par_ClienteCancelaID	INT(11),
	Par_AltaEncPoliza		CHAR(1),
	Par_NombreRecibePago	VARCHAR(200),
	Par_Salida				CHAR(1),

	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(300),
	INOUT Par_Poliza		BIGINT,
	Aud_EmpresaID			INT,
	Aud_Usuario				INT,

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore: BEGIN

DECLARE Var_EstatusCli			CHAR(1);
DECLARE Var_CCHaberesEx			VARCHAR(30);
DECLARE Var_CtaContaExHab		VARCHAR(50);
DECLARE varControl				VARCHAR(50);
DECLARE VarFechaSistema			DATE;
DECLARE Var_MonedaID			INT(11);
DECLARE VarInstrumento			INT(11);
DECLARE Var_DescripcionMov		VARCHAR(150);
DECLARE Var_CantEntregada		DECIMAL(14,2);
DECLARE varCantidadRecibir		DECIMAL(14,2);
DECLARE Var_CenCosto			INT(11);
DECLARE Var_SucCliente			INT(11);


DECLARE	Cadena_Vacia			CHAR(1);
DECLARE	Entero_Cero				INT;
DECLARE	Decimal_Cero			DECIMAL(14,2);
DECLARE	Salida_SI       		CHAR(1);
DECLARE	Salida_NO       		CHAR(1);
DECLARE	Var_SI       			CHAR(1);
DECLARE	Var_NO       			CHAR(1);
DECLARE	varAreaCancela			CHAR(3);
DECLARE	Var_AtencioSoc			CHAR(3);
DECLARE	Var_Proteccion			CHAR(3);
DECLARE	Var_Cobranza			CHAR(3);
DECLARE	varEstatusSolCan		CHAR(1);
DECLARE	Est_Autorizado			CHAR(1);
DECLARE	Est_Pagado				CHAR(1);
DECLARE	VarConcepConta			INT;
DECLARE	VarTipoInstrumentoID	INT;
DECLARE	For_SucOrigen			CHAR(3);
DECLARE	For_SucCliente			CHAR(3);
DECLARE VarSucursalOrigen	INT(11);
DECLARE Var_CentroCostosID		INT(11);
DECLARE Var_NumFolioID          INT(11);
DECLARE Var_FechaSistema		DATE;


SET	Cadena_Vacia			:= '';
SET	Entero_Cero				:= 0;
SET	Decimal_Cero			:= 0.0;
SET Salida_SI				:= 'S';
SET Salida_NO				:= 'N';
SET Var_SI					:= 'S';
SET Var_NO					:= 'N';
SET Var_AtencioSoc			:= 'Soc';
SET Var_Proteccion			:= 'Pro';
SET Var_Cobranza			:= 'Cob';
SET Est_Autorizado			:= 'A';
SET Est_Pagado				:= 'P';
SET	VarConcepConta			:= 805;
SET VarTipoInstrumentoID	:= 4;

SELECT	FechaSistema,		MonedaBaseID
 INTO	VarFechaSistema,	Var_MonedaID
	FROM PARAMETROSSIS;

SELECT	ServiFunFolioID	INTO Var_NumFolioID
FROM	CLICANCELAENTREGA C
INNER JOIN SERVIFUNENTREGADO S ON C.ClienteID = S.ClienteID
WHERE C.ClienteCancelaID= Par_ClienteCancelaID
LIMIT 1;


SET Var_DescripcionMov		:= 'PAGO POR CANCELACION DE SOCIO';
SET	For_SucOrigen		:= '&SO';
SET	For_SucCliente		:= '&SC';

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
		concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-CLIENTESCANCELPAGPRO');
		SET varControl = 'sqlException' ;
	END;

	SELECT		HaberExSocios,		CCHaberesEx
		INTO	Var_CtaContaExHab,	Var_CCHaberesEx
		FROM PARAMETROSCAJA;

	SELECT FechaSistema
		INTO Var_FechaSistema
		FROM PARAMETROSSIS LIMIT 1;


	SELECT	AreaCancela,	Estatus,			ClienteID
	 INTO	varAreaCancela,	varEstatusSolCan,	VarInstrumento
		FROM	CLIENTESCANCELA
		WHERE 	ClienteCancelaID = Par_ClienteCancelaID;

	SET VarSucursalOrigen	:= (SELECT SucursalOrigen FROM CLIENTES WHERE ClienteID = VarInstrumento );



	IF LOCATE(For_SucOrigen, Var_CCHaberesEx) > 0 THEN
		SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
	ELSE
		IF LOCATE(For_SucCliente, Var_CCHaberesEx) > 0 THEN
				IF (VarSucursalOrigen > 0) THEN
					SET Var_CentroCostosID := FNCENTROCOSTOS(VarSucursalOrigen);
				ELSE
					SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
				END IF;
		ELSE
			SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
		END IF;
	END IF;


	IF(varEstatusSolCan = Est_Autorizado)THEN

		SELECT	CantidadRecibir INTO varCantidadRecibir
			FROM	CLICANCELAENTREGA
			WHERE	CliCancelaEntregaID = Par_CliCancelaEntregaID
			 and 	Estatus 			= Est_Autorizado
             and ClienteCancelaID = Par_ClienteCancelaID ;

		SET varCantidadRecibir := ifnull(varCantidadRecibir,Decimal_Cero);


		IF(varCantidadRecibir >Decimal_Cero)THEN
			call CONTACLICANCELPRO(
				Entero_Cero,		Entero_Cero,				VarFechaSistema,	varCantidadRecibir,		Var_DescripcionMov,
				Var_MonedaID, 		Par_CliCancelaEntregaID,	Entero_Cero,		Par_AltaEncPoliza,		VarConcepConta,
				Cadena_Vacia,		Cadena_Vacia,				Cadena_Vacia,		Entero_Cero,			Var_NO,
				Var_SI,				VarTipoInstrumentoID, 		VarInstrumento,		Var_CtaContaExHab,		varCantidadRecibir,
				Decimal_Cero,		Var_CentroCostosID,			Var_NO,				Entero_Cero,			Entero_Cero,
				Entero_Cero,		Cadena_Vacia,				Entero_Cero,		Var_NO,					Var_NO,
				Entero_Cero,		Entero_Cero,				Cadena_Vacia,		Par_NumErr,				Par_ErrMen,
				Par_Poliza,			Aud_EmpresaID,				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,				Aud_NumTransaccion);


			CASE varAreaCancela
				WHEN Var_AtencioSoc	THEN

					UPDATE CLIENTESCANCELA SET
						Estatus 			= Est_Pagado
					WHERE	ClienteCancelaID = Par_ClienteCancelaID;

					UPDATE CLICANCELAENTREGA SET
						Estatus				= Est_Pagado,
						NombreRecibePago	= Par_NombreRecibePago
					WHERE	ClienteCancelaID	= Par_ClienteCancelaID
					 and	CliCancelaEntregaID	= Par_CliCancelaEntregaID;
				WHEN Var_Proteccion	THEN

					UPDATE CLICANCELAENTREGA SET
						Estatus 			= Est_Pagado,
						NombreRecibePago	= Par_NombreRecibePago
					WHERE	ClienteCancelaID	= Par_ClienteCancelaID
					 and	CliCancelaEntregaID	= Par_CliCancelaEntregaID;

					UPDATE SERVIFUNENTREGADO SET
						Estatus 			= Est_Pagado,
						FechaEntrega			= Var_FechaSistema
					WHERE	ServiFunFolioID	= Var_NumFolioID;

					UPDATE SERVIFUNFOLIOS SET
						Estatus 			= Est_Pagado
					WHERE	ServiFunFolioID	= Var_NumFolioID;

					SET Var_CantEntregada := (SELECT sum(CantidadRecibir)
												FROM CLICANCELAENTREGA
												WHERE	ClienteCancelaID= Par_ClienteCancelaID
												 and 	Estatus			= Est_Autorizado);
					SET Var_CantEntregada := ifnull(Var_CantEntregada, Decimal_Cero);
					IF(Var_CantEntregada =Decimal_Cero )THEN

						UPDATE CLIENTESCANCELA SET
							Estatus = Est_Pagado
						WHERE	ClienteCancelaID = Par_ClienteCancelaID;
					END IF;

				WHEN Var_Cobranza	THEN

					UPDATE CLIENTESCANCELA SET
						Estatus = Est_Pagado
					WHERE	ClienteCancelaID = Par_ClienteCancelaID;

					UPDATE CLICANCELAENTREGA SET
						Estatus 			= Est_Pagado,
						NombreRecibePago	= Par_NombreRecibePago
					WHERE	ClienteCancelaID	= Par_ClienteCancelaID
					 and	CliCancelaEntregaID	= Par_CliCancelaEntregaID;

				ELSE
					SET Par_NumErr  := 1;
					SET Par_ErrMen  := concat('El Area de la Solicitud de Cancelacion no esta Definida.');
					SET varControl	:= 'clienteCancelaID';
					leave ManejoErrores;
			END CASE;
		ELSE
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := concat('No existe un Monto Pendiente por Entregar.');
			SET varControl	:= 'clienteCancelaID';
			leave ManejoErrores;
		END IF;
	ELSE
		SET Par_NumErr  := 1;
		SET Par_ErrMen  := concat('La Solicitud de Cancelacion no esta Autorizada.');
		SET varControl	:= 'clienteCancelaID';
		leave ManejoErrores;
	END IF;

	SET Par_NumErr  := 000;
	SET Par_ErrMen  := concat('Proceso Realizado Exitosamente.');
	SET varControl	:= 'clienteID';

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen	 	AS ErrMen,
			varControl	 	AS control,
			Par_Poliza		AS consecutivo;
END IF;

END TerminaStore$$