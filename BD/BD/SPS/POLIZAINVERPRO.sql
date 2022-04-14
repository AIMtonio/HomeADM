-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZAINVERPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZAINVERPRO`;
DELIMITER $$

CREATE PROCEDURE `POLIZAINVERPRO`(
	Par_Poliza			BIGINT,
	Par_Empresa			INT,
	Par_Fecha			DATE,
	Par_Cliente			INT,
	Par_ConceptoOpera	INT,
	Par_InversionID		BIGINT,
	Par_Moneda			INT,
	Par_Cargos			DECIMAL(12,2),
	Par_Abonos			DECIMAL(12,2),
	Par_Descripcion		VARCHAR(100),
	Par_Referencia		VARCHAR(50),

	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN



	DECLARE	Var_TipoPersona		CHAR(1);
	DECLARE	Var_TipoInversion	INT;
	DECLARE	Var_NomComple		VARCHAR(100);
	DECLARE	Var_Instrumento		VARCHAR(20);
	DECLARE Var_Cuenta			VARCHAR(50);
	DECLARE Var_CentroCostosID	INT(11);
	DECLARE Var_CuentaComple	CHAR(25);
	DECLARE Var_Nomenclatura	VARCHAR(30);
	DECLARE Var_NomenclaturaCR	VARCHAR(3);
	DECLARE Var_CuentaMayor		VARCHAR(4);
	DECLARE	Var_SubCuentaTP		CHAR(2);
	DECLARE	Var_SubCuentaTC		CHAR(2);
	DECLARE	Var_SubCuentaTD		CHAR(2);
	DECLARE	Var_SubCuentaTM		CHAR(2);
	DECLARE	Var_NomenclaturaSO	INT;
	DECLARE	Var_NomenclaturaSC	INT;
	DECLARE	Var_Plazo			INT(11);
	DECLARE	Var_PlazoInferior	INT(11);
	DECLARE	Var_PlazoSuperior	INT(11);
	DECLARE	Par_NumErr 		    INT;
	DECLARE Par_ErrMen  	    VARCHAR(350);


	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE Decimal_cero		DECIMAL(14,2);
	DECLARE	Cuenta_Vacia		CHAR(25);
	DECLARE	Per_Fisica			CHAR(1);
	DECLARE	Per_Moral			CHAR(1);
	DECLARE	Procedimiento		VARCHAR(20);
	DECLARE	For_CueMayor		CHAR(3);
	DECLARE	For_TipProduc		CHAR(3);
	DECLARE	For_TipPlazo		CHAR(3);
	DECLARE	For_TipCliente		CHAR(3);
	DECLARE	For_Moneda			CHAR(3);
	DECLARE	For_SucOrigen		CHAR(3);
	DECLARE	For_SucCliente		CHAR(3);
	DECLARE	Salida_NO			CHAR(1);
	DECLARE TipoInversionID		INT(11);


	SET	Salida_NO		:= 'N';
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Cuenta_Vacia	:= '0000000000000000000000000';
	SET	Entero_Cero		:= 0;
	SET Decimal_cero	:= 0.00;
	SET	Per_Fisica		:= 'F';
	SET	Per_Moral		:= 'M';
	SET	For_CueMayor	:= '&CM';
	SET	For_TipProduc	:= '&TP';
	SET	For_TipPlazo	:= '&TD';
	SET	For_TipCliente	:= '&TC';
	SET	For_Moneda		:= '&TM';
	SET	For_SucOrigen		:= '&SO';
	SET	For_SucCliente	:= '&SC';

	SET	Procedimiento	:= 'POLIZAINVERPRO';
	SET TipoInversionID	:= 13;

	SET	Var_Cuenta	:= '000000000000000';
	SET Var_Instrumento := CONVERT(Par_InversionID, CHAR);

	SET Var_CentroCostosID	:= 0;


	SELECT	Nomenclatura,	 Cuenta, 	NomenclaturaCR  INTO 	Var_Nomenclatura, 	Var_CuentaMayor, 	Var_NomenclaturaCR
	FROM  CUENTASMAYORINV Ctm
	WHERE Ctm.ConceptoInvID	= Par_ConceptoOpera;

	SET Var_Nomenclatura 	:= IFNULL(Var_Nomenclatura, Cadena_Vacia);
	SET Var_NomenclaturaCR	:= IFNULL(Var_NomenclaturaCR, Cadena_Vacia);

	IF(Var_Nomenclatura = Cadena_Vacia) THEN
		SET Var_Cuenta := Cuenta_Vacia;
	ELSE
		SET Var_Cuenta	:= Var_Nomenclatura;

		SELECT	cat.TipoInversionID, inv.Plazo INTO Var_TipoInversion , Var_Plazo
		FROM  	INVERSIONES inv,
				CATINVERSION cat
		WHERE 	inv.InversionID = Par_InversionID
			AND cat.TipoInversionID  	= inv.TipoInversionID;

		IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0 THEN
			SET Var_NomenclaturaSC := ( SELECT	SucursalOrigen
										FROM 	CLIENTES
										WHERE	ClienteID 	=	Par_Cliente);
			SET Var_NomenclaturaSC := IFNULL(Var_NomenclaturaSC, Entero_Cero);
			IF (Var_NomenclaturaSC != Entero_Cero) THEN
				SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
			END IF;
		ELSE

			IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0 THEN
				SET Var_NomenclaturaSO := Aud_Sucursal;
				IF (Var_NomenclaturaSO != Entero_Cero) THEN
					SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
				END IF;

			ELSE
				SET Var_CentroCostosID:= FNCENTROCOSTOS(Aud_Sucursal);
			END IF;
		END IF;


		IF LOCATE(For_CueMayor, Var_Cuenta) > 0 THEN
			SET Var_Cuenta := REPLACE(Var_Cuenta, For_CueMayor, Var_CuentaMayor);
		END IF;


		IF LOCATE(For_TipProduc, Var_Cuenta) > 0 THEN
			SELECT	SubCuenta INTO Var_SubCuentaTP
			FROM  	SUBCTATIPROINV
			WHERE	TipoProductoID	= Var_TipoInversion
			AND		ConceptoInverId	= Par_ConceptoOpera;

			SET Var_SubCuentaTP := IFNULL(Var_SubCuentaTP, Cadena_Vacia);

			IF (Var_SubCuentaTP != Cadena_Vacia) THEN
				SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipProduc, Var_SubCuentaTP);
			END IF;

		END IF;


		IF LOCATE(For_Moneda, Var_Cuenta) > 0 THEN
			SELECT	SubCuenta INTO Var_SubCuentaTM
			FROM  	SUBCTAMONEDAINV Sub
			WHERE	Sub.MonedaID		= Par_Moneda
			AND		Sub.ConceptoInverID	= Par_ConceptoOpera;

			SET Var_SubCuentaTM := IFNULL(Var_SubCuentaTM, Cadena_Vacia);

			IF (Var_SubCuentaTM != Cadena_Vacia) THEN
				SET Var_Cuenta := REPLACE(Var_Cuenta, For_Moneda, Var_SubCuentaTM);
			END IF;

		END IF;


		IF LOCATE(For_TipPlazo, Var_Cuenta) > 0 THEN
			SELECT	Sub.PlazoInferior, Sub.PlazoSuperior, Sub.SubCuenta INTO Var_PlazoInferior, Var_PlazoSuperior, Var_SubCuentaTD
					FROM  SUBCTAPLAZOINV Sub
					WHERE Sub.ConceptoInverID	= Par_ConceptoOpera
						AND 	Sub.PlazoInferior<=Var_Plazo
						AND 	Sub.PlazoSuperior>=Var_Plazo;

			SET Var_SubCuentaTD := IFNULL(Var_SubCuentaTD, Cadena_Vacia);

			IF (Var_SubCuentaTD != Cadena_Vacia) THEN
				SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipPlazo, Var_SubCuentaTD);
			END IF;

		END IF;


		IF LOCATE(For_TipCliente, Var_Cuenta) > 0 THEN

			SELECT	TipoPersona INTO Var_TipoPersona
			FROM 	CLIENTES
			WHERE 	ClienteID = Par_Cliente;

			IF Var_TipoPersona = Per_Fisica THEN
				SELECT	Fisica INTO Var_SubCuentaTC
				FROM  	SUBCTATIPERINV Sub
				WHERE 	Sub.ConceptoInverID	= Par_ConceptoOpera;
			ELSE
				SELECT	Moral INTO Var_SubCuentaTC
				FROM  SUBCTATIPERINV Sub
				WHERE Sub.ConceptoInverID	= Par_ConceptoOpera;
			END IF;

			SET Var_SubCuentaTC := IFNULL(Var_SubCuentaTC, Cadena_Vacia);

			IF (Var_SubCuentaTC != Cadena_Vacia) THEN
				SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipCliente, Var_SubCuentaTC);
			END IF;

		END IF;


	END IF;

	SET Var_Cuenta := REPLACE(Var_Cuenta, '-', Cadena_Vacia);

	CALL DETALLEPOLIZAALT(
		Par_Empresa,			Par_Poliza,				Par_Fecha, 			Var_CentroCostosID,		Var_Cuenta,
		Var_Instrumento,		Par_Moneda,				Par_Cargos,			Par_Abonos,			Par_Descripcion,
		Par_Referencia,			Procedimiento,			TipoInversionID,	Cadena_Vacia,		Decimal_cero,
		Cadena_Vacia,			Salida_NO, 				Par_NumErr,			Par_ErrMen,			Aud_Usuario,
		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

END TerminaStore$$