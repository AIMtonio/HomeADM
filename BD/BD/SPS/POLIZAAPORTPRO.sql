-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZAAPORTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZAAPORTPRO`;
DELIMITER $$


CREATE PROCEDURE `POLIZAAPORTPRO`(
# ===========================================================
#  SP PARA REGISTRAR DETALLE DE POLIZA DE LAS APORTACIONES --
# ===========================================================
	INOUT Par_Poliza	BIGINT(20),
	Par_Fecha			DATE,
	Par_Cliente			INT(11),
	Par_ConceptoOpera	INT(11),
	Par_AportacionID	BIGINT(11),

	Par_MonedaID		INT(11),
	Par_Cargos			DECIMAL(12,2),
	Par_Abonos			DECIMAL(12,2),
	Par_Descripcion		VARCHAR(100),
	Par_Referencia		VARCHAR(50),

    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),
	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),

	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	Var_TipoPersona			CHAR(1);
	DECLARE	Var_TipoAportacionID			INT(11);
	DECLARE	Var_NomComple			VARCHAR(100);
	DECLARE	Var_Instrumento			VARCHAR(20);
	DECLARE Var_Cuenta				VARCHAR(50);
	DECLARE Var_CenCosto			INT(11);
	DECLARE Var_CuentaComple		CHAR(25);
	DECLARE Var_Nomenclatura		VARCHAR(30);
	DECLARE Var_NomenclaturaCR		VARCHAR(5);
	DECLARE Var_CuentaMayor			VARCHAR(4);
	DECLARE	Var_SubCuentaTP			CHAR(2);
	DECLARE	Var_SubCuentaTC			CHAR(2);
	DECLARE	Var_SubCuentaTD			CHAR(2);
	DECLARE	Var_SubCuentaTM			CHAR(2);
	DECLARE	Var_NomenclaturaSO		INT(11);
	DECLARE	Var_NomenclaturaSC		INT(11);
	DECLARE	Var_Plazo				INT(11);
	DECLARE	Var_PlazoInferior		INT(11);
	DECLARE	Var_PlazoSuperior		INT(11);
	DECLARE Var_CentroCostoID		INT(11);
	DECLARE Var_Control	    		VARCHAR(100);

	-- Declaracion  de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT(11);
	DECLARE	Cuenta_Vacia			CHAR(25);
	DECLARE	Per_Fisica				CHAR(1);
	DECLARE	Per_Moral				CHAR(1);
	DECLARE	Procedimiento			VARCHAR(20);
	DECLARE	For_CueMayor			CHAR(3);
	DECLARE	For_TipProduc			CHAR(3);
	DECLARE	For_TipPlazo			CHAR(3);
	DECLARE	For_TipCliente			CHAR(3);
	DECLARE	For_Moneda				CHAR(3);
	DECLARE	For_SucOrigen			CHAR(3);
	DECLARE	For_SucCliente			CHAR(3);
	DECLARE	Salida_NO				CHAR(1);
	DECLARE TipoInstrumentoID		INT(11);
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE	Salida_SI				CHAR(1);

	-- Asignacion de constantes
	SET	Salida_NO					:= 'N';							-- Salida en Pantalla NO
	SET	Cadena_Vacia				:= '';							-- Cadena Vacia
	SET	Fecha_Vacia					:= '1900-01-01';				-- Fecha Vacia
	SET	Cuenta_Vacia				:= '0000000000000000000000000';	-- Cuenta contable Vacia
	SET	Entero_Cero					:= 0;							-- Entero Cero
	SET	Per_Fisica					:= 'F';							-- Tipo de Persona Fisica
	SET	Per_Moral					:= 'M';							-- Tipo de Persona Moral
	SET	For_CueMayor				:= '&CM';						-- Nomenclatura subclasificacion Cuenta del Mayor
	SET	For_TipProduc				:= '&TP';						-- Nomenclatura Subclasificacion por tipo de Producto
	SET	For_TipPlazo				:= '&TD';						-- Nomenclatura sublasificacion por tipo de Plazo
	SET	For_TipCliente				:= '&TC';						-- nomenclatura Subclasificacion por Tipo de cliente
	SET	For_Moneda					:= '&TM';						-- Nomenclatura Subclasificacion por tipo deMoneda
	SET	For_SucOrigen				:= '&SO';						-- Nomenclatura Centro de costos Sucursal Origen
	SET	For_SucCliente				:= '&SC';						-- Nomenclatura Centro de costos Sucursal del Cliente
	SET Decimal_Cero				:= 0.0;							-- DECIMAL Cero
	SET	Procedimiento				:= 'POLIZAAPORTPRO';			-- Nombre del Procedimiento Contable
	SET TipoInstrumentoID			:= 31;							-- Tipo Instrumento APORTACIONES corresponde con TIPOINSTRUMENTOS
	SET	Var_Cuenta					:= '0000000000000000000000000';	-- Cuenta Contable Vacia
	SET Var_Instrumento 			:= CONVERT(Par_AportacionID, CHAR);
	SET Salida_SI       			:= 'S';     					-- Salida si


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									    'Disculpe las molestias que esto le ocasiona. Ref: SP-POLIZAAPORTPRO');
				SET Var_Control := 'SQLEXCEPTION';
			END;

		SET Var_CenCosto	:= Entero_Cero;
		SET Aud_FechaActual	:= NOW();

		SELECT	Nomenclatura, Cuenta, NomenclaturaCR  INTO Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			FROM  CUENTASMAYORAPORT Ctm
			WHERE Ctm.ConceptoAportID	= Par_ConceptoOpera;

		SET Var_Nomenclatura	:= IFNULL(Var_Nomenclatura, Cadena_Vacia);
		SET Var_NomenclaturaCR	:= IFNULL(Var_NomenclaturaCR, Cadena_Vacia);

		IF(Var_Nomenclatura = Cadena_Vacia) THEN
			SET Var_Cuenta := Cuenta_Vacia;
		ELSE

			SET Var_Cuenta	:= Var_Nomenclatura;

			SELECT	tip.TipoAportacionID, ced.Plazo INTO Var_TipoAportacionID , Var_Plazo
				FROM	APORTACIONES		ced,
						TIPOSAPORTACIONES	tip
				WHERE	ced.AportacionID 		= Par_AportacionID
				AND 	tip.TipoAportacionID	= ced.TipoAportacionID;

			IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
				SET Var_NomenclaturaSC := (SELECT	SucursalOrigen
												FROM  	CLIENTES
												WHERE	ClienteID 	= Par_Cliente);
				SET Var_NomenclaturaSC = IFNULL(Var_NomenclaturaSC, Entero_Cero);
				IF (Var_NomenclaturaSC != Entero_Cero) THEN
					SET Var_CenCosto := Var_NomenclaturaSC;
				END IF;
			ELSE

				IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
					SET Var_NomenclaturaSO := Aud_Sucursal;
					IF (Var_NomenclaturaSO != Entero_Cero) THEN
						SET Var_CenCosto := Var_NomenclaturaSO;
					END IF;

				ELSE
					SET Var_CenCosto:=Entero_Cero;
				END IF;
			END IF;

			SELECT 		CentroCostoID
					INTO Var_CentroCostoID
				FROM 	SUCURSALES
				WHERE 	SucursalID = Var_CenCosto;

			SET Var_CentroCostoID	:= IFNULL(Var_CentroCostoID, Entero_Cero);

			IF LOCATE(For_CueMayor, Var_Cuenta) > Entero_Cero THEN
				SET Var_Cuenta := REPLACE(Var_Cuenta, For_CueMayor, Var_CuentaMayor);
			END IF;


			IF LOCATE(For_TipProduc, Var_Cuenta) > Entero_Cero THEN
				SELECT	SubCuenta INTO Var_SubCuentaTP
					FROM  	SUBCTATIPROAPORTACION
					WHERE	TipoAportacionID		= Var_TipoAportacionID
					AND		ConceptoAportID	= Par_ConceptoOpera;

				SET Var_SubCuentaTP := IFNULL(Var_SubCuentaTP, Cadena_Vacia);

				IF (Var_SubCuentaTP != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipProduc, Var_SubCuentaTP);
				END IF;

			END IF;


			IF LOCATE(For_Moneda, Var_Cuenta) > Entero_Cero THEN
				SELECT	SubCuenta INTO Var_SubCuentaTM
					FROM  	SUBCTAMONEDAAPORT Sub
					WHERE	Sub.MonedaID		= Par_MonedaID
					AND		Sub.ConceptoAportID	= Par_ConceptoOpera;
				SET Var_SubCuentaTM := IFNULL(Var_SubCuentaTM, Cadena_Vacia);
				IF (Var_SubCuentaTM != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_Moneda, Var_SubCuentaTM);
				END IF;
			END IF;


			IF LOCATE(For_TipPlazo, Var_Cuenta) > Entero_Cero THEN
				SELECT	Sub.PlazoInferior, Sub.PlazoSuperior, Sub.SubCuenta
						INTO Var_PlazoInferior, Var_PlazoSuperior, Var_SubCuentaTD
							FROM  	SUBCTAPLAZOAPORTACION Sub
							WHERE	Sub.ConceptoAportID	= Par_ConceptoOpera
							AND 	Sub.PlazoInferior	<=Var_Plazo
							AND 	Sub.PlazoSuperior	>=Var_Plazo;

				SET Var_SubCuentaTD := IFNULL(Var_SubCuentaTD, Cadena_Vacia);

				IF (Var_SubCuentaTD != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipPlazo, Var_SubCuentaTD);
				END IF;

			END IF;


			IF LOCATE(For_TipCliente, Var_Cuenta) > Entero_Cero THEN
				SELECT	TipoPersona INTO Var_TipoPersona
					FROM 	CLIENTES
					WHERE 	ClienteID = Par_Cliente;

				IF Var_TipoPersona = Per_Fisica THEN
					SELECT	Fisica INTO Var_SubCuentaTC
						FROM  SUBCTATIPERAPORTACION Sub
						WHERE Sub.ConceptoAportID	= Par_ConceptoOpera;
				ELSE
					SELECT	Moral INTO Var_SubCuentaTC
						FROM  SUBCTATIPERAPORTACION Sub
						WHERE Sub.ConceptoAportID	= Par_ConceptoOpera;
				END IF;

				SET Var_SubCuentaTC := IFNULL(Var_SubCuentaTC, Cadena_Vacia);

				IF (Var_SubCuentaTC != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipCliente, Var_SubCuentaTC);
				END IF;

			END IF;


		END IF;

		SET Var_Cuenta := REPLACE(Var_Cuenta, '-', Cadena_Vacia);
		SET Var_CentroCostoID	:= IFNULL(Var_CentroCostoID, Entero_Cero);


		CALL DETALLEPOLIZASALT (
			Aud_EmpresaID,		Par_Poliza,			Par_Fecha, 			Var_CentroCostoID,	Var_Cuenta,
			Var_Instrumento,	Par_MonedaID,		Par_Cargos,			Par_Abonos,			Par_Descripcion,
			Par_Referencia,		Procedimiento,		TipoInstrumentoID,	Cadena_Vacia,		Decimal_Cero,
			Cadena_Vacia,		Salida_NO, 			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT('Transaccion Realizada Exitosamente: ', CONVERT(Par_Poliza, CHAR));
		SET Var_Control	:= 'aportacionID' ;


	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$
