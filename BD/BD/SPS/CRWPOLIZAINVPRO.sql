-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWPOLIZAINVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWPOLIZAINVPRO`;
DELIMITER $$

CREATE PROCEDURE `CRWPOLIZAINVPRO`(
/* SP CONTABLE PARA INVERSIONES CROWDFUNDING. */
	Par_Poliza				BIGINT,			-- ID de la Poliza.
	Par_Empresa				INT(11),		-- ID de la empresa.
	Par_Fecha				DATE,			-- fecha de operacion.
	Par_SolFondeoID			BIGINT,			-- Número de la solicitud de Fondeo CRW.
	Par_NumRetMes			INT(11),		-- Plazo

	Par_SucCliente			INT(11),		-- Sucursal del orige cte.
	Par_ConceptoOpera		INT(11),		-- Concepto de operación.
	Par_Cargos				DECIMAL(14,4),	-- Monto Cargo.
	Par_Abonos				DECIMAL(14,4),	-- Monto Abono.
	Par_Moneda				INT(11),		-- Id de la Moneda.

	Par_Descripcion			VARCHAR(100),	-- Descripción.
	Par_Referencia			VARCHAR(50),	-- Referencia.
	Par_Salida				CHAR(1),		-- Parametro De Salida
	INOUT Par_NumErr		INT(11),		-- Numero de validación.
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de validación.

	INOUT Par_Consecutivo	BIGINT,			-- Numero consecutivo.
	/* Parámetros de Auditoría.*/
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_Cuenta			VARCHAR(50);
DECLARE Var_Instrumento		VARCHAR(20);
DECLARE Var_CenCosto		INT;
DECLARE Var_Nomenclatura	VARCHAR(30);
DECLARE Var_NomenclaturaCR	VARCHAR(3);
DECLARE Var_CuentaMayor		VARCHAR(4);
DECLARE Var_NomenclaturaSO	INT;
DECLARE Var_NomenclaturaSC	INT;
DECLARE Var_SubCuentaTM		CHAR(2);
DECLARE Var_SubCuentaTD		CHAR(2);
DECLARE Var_Control			VARCHAR(20);


-- Declaracion de constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE Decimal_Cero		DECIMAL(12,2);
DECLARE	Cuenta_Vacia		CHAR(12);
DECLARE	For_CueMayor		CHAR(3);
DECLARE	For_NumRetMes		CHAR(3);
DECLARE	For_Moneda			CHAR(3);
DECLARE	For_SucOrigen		CHAR(3);
DECLARE	For_SucCliente		CHAR(3);
DECLARE	Str_NO				CHAR(1);
DECLARE	Str_SI				CHAR(1);
DECLARE	Procedimiento		VARCHAR(20);
DECLARE TipoInstrumentoID	INT(11);

-- Asginacion de constantes
SET	Cadena_Vacia		:= '';					-- Cadena Vacia
SET	Fecha_Vacia			:= '1900-01-01';		-- Fecha Vacia
SET	Cuenta_Vacia		:= '000000000000';		-- Cuenta contable vacia
SET	Entero_Cero			:= 0;					-- Entero Cero
SET Decimal_Cero		:=	0.00;				-- DECIMAL Cero
SET	For_CueMayor		:= '&CM';				-- nomenclatura cuenta del Mayor
SET	For_NumRetMes		:= '&TD';				-- Nomenclatura numero de Retiros  en el Mes
SET	For_Moneda			:= '&TM';				-- Nomenclatura Tipo de Moneda
SET	For_SucOrigen		:= '&SO';				-- Nomenclatura centro de costos sucursal Origen
SET	For_SucCliente		:= '&SC';				-- Nomenclatura Centro de Costos sucursal del Cliente
SET	Str_NO				:= 'N';					-- Constante NO
SET	Str_SI				:= 'S';					-- Constante SI
SET	Procedimiento		:= 'CRWPOLIZAINVPRO';	-- Nombre del Programa
SET	Var_Cuenta			:= '000000000000';		-- Cuenta Vacia
SET	Var_Instrumento 	:= CONVERT(Par_SolFondeoID	, CHAR);
SET Var_CenCosto		:= 0;					-- Centro de costsos Cero
SET TipoInstrumentoID	:= 13;					-- Tipo Instrumento Inversion corresponde con TIPOINSTRUMENTOS

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWPOLIZAINVPRO');
			SET Var_Control := 'SQLEXCEPTION';
		END;

	SELECT
		Nomenclatura,		Cuenta,				NomenclaturaCR
	INTO
		Var_Nomenclatura,	Var_CuentaMayor,	Var_NomenclaturaCR
	FROM  CUENTASMAYORCRW Ctm
	WHERE Ctm.ConceptoCRWID	= Par_ConceptoOpera;

	SET Var_Nomenclatura := IFNULL(Var_Nomenclatura, Cadena_Vacia);
	SET Var_NomenclaturaCR := IFNULL(Var_NomenclaturaCR, Cadena_Vacia);

	IF(Var_Nomenclatura = Cadena_Vacia) THEN
		SET Var_Cuenta := Cuenta_Vacia;
	ELSE

		SET Var_Cuenta	:= Var_Nomenclatura;


		IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0 THEN

			SET Var_NomenclaturaSC := Par_SucCliente;
			SET Var_NomenclaturaSC = IFNULL(Var_NomenclaturaSC, Entero_Cero);

			IF (Var_NomenclaturaSC != Entero_Cero) THEN
				SET Var_CenCosto := Var_NomenclaturaSC;
			END IF;
		ELSE

			IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0 THEN
				SET Var_NomenclaturaSO := Aud_Sucursal;
				IF (Var_NomenclaturaSO != Entero_Cero) THEN
					SET Var_CenCosto := Var_NomenclaturaSO;
				END IF;

			ELSE
				SET Var_CenCosto:=Var_NomenclaturaCR;
			END IF;
		END IF;



		IF LOCATE(For_CueMayor, Var_Cuenta) > 0 THEN
			SET Var_Cuenta := REPLACE(Var_Cuenta, For_CueMayor, Var_CuentaMayor);
		END IF;


		IF LOCATE(For_NumRetMes, Var_Cuenta) > 0 THEN
			SELECT SubCuenta INTO Var_SubCuentaTD
				FROM SUBCTAPLAZOCRW
				WHERE NumRetiros		= Par_NumRetMes
				  AND ConceptoCRWID		= Par_ConceptoOpera;

			SET Var_SubCuentaTD := IFNULL(Var_SubCuentaTD, Cadena_Vacia);

			IF (Var_SubCuentaTD != Cadena_Vacia) THEN
				SET Var_Cuenta := REPLACE(Var_Cuenta, For_NumRetMes, Var_SubCuentaTD);
			END IF;

		END IF;


		IF LOCATE(For_Moneda, Var_Cuenta) > 0 THEN
			SELECT	SubCuenta INTO Var_SubCuentaTM
				FROM  SUBCTAMONEDACRW Sub
				WHERE Sub.MonedaID		= Par_Moneda
				  AND Sub.ConceptoCRWID	= Par_ConceptoOpera;

			SET Var_SubCuentaTM := IFNULL(Var_SubCuentaTM, Cadena_Vacia);

			IF (Var_SubCuentaTM != Cadena_Vacia) THEN
				SET Var_Cuenta := REPLACE(Var_Cuenta, For_Moneda, Var_SubCuentaTM);
			END IF;

		END IF;

	END IF;

	SET Var_Cuenta := REPLACE(Var_Cuenta, '-', Cadena_Vacia);

	CALL DETALLEPOLIZASALT(
		Par_Empresa,			Par_Poliza,			Par_Fecha, 			Var_CenCosto,		Var_Cuenta,
		Var_Instrumento,		Par_Moneda,			Par_Cargos,			Par_Abonos,			Par_Descripcion,
		Par_Referencia,			Procedimiento,		TipoInstrumentoID,	Cadena_Vacia,		Decimal_Cero,
		Cadena_Vacia,			Str_NO,				Par_NumErr,			Par_ErrMen,	  		Aud_Usuario	,
		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	SET Par_NumErr  := Entero_Cero;
	SET Par_ErrMen  := 'Proceso Terminado Exitosamente';

END ManejoErrores;  -- END del Handler de Errores

IF (Par_Salida = Str_SI) THEN
	SELECT  Par_NumErr 		AS NumErr,
			Par_ErrMen		AS ErrMen,
			'creditoID' 	AS control;
	END IF;

END TerminaStore$$
