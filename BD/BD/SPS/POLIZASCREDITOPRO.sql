-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZASCREDITOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZASCREDITOPRO`;
DELIMITER $$

CREATE PROCEDURE `POLIZASCREDITOPRO`(
/*SP para dar de alta la poliza contable de los creditos*/
    Par_Poliza				BIGINT(20),
    Par_Empresa				INT(11),
    Par_Fecha				DATE,
    Par_CreditoID			BIGINT(20),
    Par_ProdCreditoID		INT(11),

    Par_SucCliente			INT(11),
    Par_ConceptoOpera   	INT(11),
    Par_Clasificacion   	CHAR(1),
    Par_SubClasifica    	INT(11),
	Par_Cargos				DECIMAL(14,4),

	Par_Abonos				DECIMAL(14,4),
	Par_Moneda				INT(11),
	Par_Descripcion			VARCHAR(100),
	Par_Referencia			VARCHAR(50),
	Par_Salida				CHAR(1),

	OUT	Par_NumErr			INT(11),
	OUT Par_ErrMen			VARCHAR(400),
	INOUT Par_Consecutivo	BIGINT(20),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
    Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Cuenta			VARCHAR(50);
	DECLARE Var_Instrumento		VARCHAR(20);
	DECLARE Var_CentroCostosID	INT(11);
	DECLARE Var_Nomenclatura	VARCHAR(30);
	DECLARE Var_NomenclaturaCR	VARCHAR(3);

	DECLARE Var_CuentaMayor		VARCHAR(4);
	DECLARE Var_NomenclaturaSO	INT(11);
	DECLARE Var_NomenclaturaSC	INT(11);
	DECLARE Var_SubCuentaTP		VARCHAR(5);
	DECLARE Var_SubCuentaTM		VARCHAR(5);

	DECLARE Var_SubCuentaFD		VARCHAR(5); 	-- Sub cuenta fondeador
	DECLARE Var_SubCuentaSC		VARCHAR(6);
	DECLARE Var_SubCuentaCL		VARCHAR(5);
	DECLARE Var_Control			VARCHAR(100);	-- Variable de control
	DECLARE	Var_Consecutivo		VARCHAR(20);	-- Variable consecutivo

	DECLARE Var_InstitFondeoID	INT(11);
	DECLARE Var_Porcentaje 		DECIMAL(12,4); 	-- Variable para el porcentaje asignado
	DECLARE Var_SubCuentaIA		CHAR(2);		-- Variable SubCuenta IVA Asignado

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Decimal_Cero		DECIMAL(12,2);
	DECLARE	Cuenta_Vacia		CHAR(25);

	DECLARE For_CueMayor    	CHAR(3);
	DECLARE For_TipProduc   	CHAR(3);
	DECLARE For_TipCartera  	CHAR(3);
	DECLARE For_Clasifica   	CHAR(3);
	DECLARE For_SubClasif   	CHAR(3);

	DECLARE For_Moneda      	CHAR(3);
    DECLARE For_Fondeador		CHAR(3);
	DECLARE	For_SucOrigen		CHAR(3);
	DECLARE	For_SucCliente		CHAR(3);
	DECLARE	Cla_Comercial		CHAR(1);

	DECLARE	Cla_Consumo			CHAR(1);
	DECLARE	Cla_Vivienda		CHAR(1);
	DECLARE	Tip_Capital			CHAR(1);
	DECLARE	Tip_Interes			CHAR(1);
	DECLARE	Salida_NO			CHAR(1);

	DECLARE	Procedimiento		VARCHAR(30);
	DECLARE TipoInstrumentoID	INT(11);
	DECLARE	Salida_SI			CHAR(1);
	DECLARE For_IVAAsignado		CHAR(3);		-- Constante Nomenclatura SubCuenta IVA Asignado
	DECLARE Mensaje				VARCHAR(100);
	DECLARE Mensaje_lugar       VARCHAR(100);

	-- Asignacion de constantes
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Cuenta_Vacia		:= '0000000000000000000000000';
	SET Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.0;

	SET For_CueMayor    	:= '&CM';
	SET For_TipProduc   	:= '&TP';
	SET For_Clasifica   	:= '&CL';
	SET For_SubClasif   	:= '&SC';
	SET For_Moneda      	:= '&TM';

    SET	For_Fondeador		:= '&FD';
	SET For_SucOrigen		:= '&SO';
	SET For_SucCliente		:= '&SC';
	SET For_IVAAsignado		:= '&IA'; -- Nomenclatura IVA Asignado
	SET Cla_Comercial		:= 'C';
	SET Cla_Consumo			:= 'O';

	SET Cla_Vivienda		:= 'H';
	SET Salida_NO			:= 'N';
	SET	Procedimiento		:= 'POLIZACREDITOPRO';
	SET TipoInstrumentoID	:= 11;
	SET	Var_Cuenta			:= '0000000000000000000000000';

	SET Var_Instrumento 	:= CONVERT(Par_CreditoID, CHAR);
	SET Var_CentroCostosID	:= 0;
	SET Salida_SI			:= 'S';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
				'Disculpe las molestias que esto le ocasiona. Ref: SP-POLIZASCREDITOPRO');
			SET Var_Control := 'sqlException' ;
			SET Var_Consecutivo := Cadena_Vacia;
		END;

		SELECT	Nomenclatura, Cuenta, NomenclaturaCR  INTO
				Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			FROM  CUENTASMAYORCAR Ctm
				WHERE Ctm.ConceptoCarID	= Par_ConceptoOpera;

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
		            SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
		        END IF;

		    ELSE

		        IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0 THEN
		            SET Var_NomenclaturaSO := Aud_Sucursal;
		            IF (Var_NomenclaturaSO != Entero_Cero) THEN
		                SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
		            END IF;
				ELSE
		            SET Var_CentroCostosID:=FNCENTROCOSTOS(Aud_Sucursal);
		        END IF;
	    	END IF;

		    IF LOCATE(For_CueMayor, Var_Cuenta) > 0 THEN
		        SET Var_Cuenta := REPLACE(Var_Cuenta, For_CueMayor, Var_CuentaMayor);
		    END IF;

			IF LOCATE(For_TipProduc, Var_Cuenta) > 0 THEN
				SELECT SubCuenta INTO Var_SubCuentaTP
					FROM SUBCTAPRODUCCART
						WHERE ProducCreditoID	= Par_ProdCreditoID
						  AND ConceptoCarID		= Par_ConceptoOpera;
				SET Var_SubCuentaTP := IFNULL(Var_SubCuentaTP, Cadena_Vacia);

				IF (Var_SubCuentaTP != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipProduc, Var_SubCuentaTP);
				END IF;
			END IF;

			IF LOCATE(For_Moneda, Var_Cuenta) > 0 THEN
				SELECT	SubCuenta INTO Var_SubCuentaTM
					FROM  SUBCTAMONEDACART Sub
						WHERE Sub.MonedaID		= Par_Moneda
						  AND Sub.ConceptoCarID	= Par_ConceptoOpera;

				SET Var_SubCuentaTM := IFNULL(Var_SubCuentaTM, Cadena_Vacia);

				IF (Var_SubCuentaTM != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_Moneda, Var_SubCuentaTM);
				END IF;
			END IF;

			-- --------------------------SUBCUENTA POR FONDEADOR
			IF LOCATE(For_Fondeador, Var_Cuenta) > 0 THEN
				#Consulta para obtener  el id de la institucion de fondeo.
				SELECT InstitFondeoID INTO Var_InstitFondeoID FROM CREDITOS WHERE CreditoID	= Par_CreditoID;
				SET Var_InstitFondeoID := IFNULL(Var_InstitFondeoID,Entero_Cero);				# Termina consulta de institucion de fondeo
				SELECT	SubCuenta INTO Var_SubCuentaFD
					FROM  SUBCTAFONDEADORCART Sub
						WHERE Sub.InstitutFondID	=  Var_InstitFondeoID -- obtener id de inst de fondeo
						  AND Sub.ConceptoCarID		= Par_ConceptoOpera;

				SET Var_SubCuentaFD := IFNULL(Var_SubCuentaFD, Cadena_Vacia);

				IF (Var_SubCuentaFD != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_Fondeador, Var_SubCuentaFD);
				END IF;
			END IF;

			IF LOCATE(For_Clasifica, Var_Cuenta) > 0 THEN

		        IF Par_Clasificacion = Cla_Comercial THEN

		            SELECT	Comercial INTO Var_SubCuentaCL
		                FROM  SUBCTACLASIFCART Sub
		                    WHERE Sub.ConceptoCarID	= Par_ConceptoOpera;

		        ELSEIF Par_Clasificacion = Cla_Consumo  THEN

		           SET Var_SubCuentaCL :=(SELECT	Consumo
							                FROM  SUBCTACLASIFCART Sub
							                    WHERE Sub.ConceptoCarID	= Par_ConceptoOpera);
		           SET Var_SubCuentaCL := IFNULL(Var_SubCuentaCL, Cadena_Vacia);

		        ELSEIF Par_Clasificacion = Cla_Vivienda  THEN
		            SET Var_SubCuentaCL := (SELECT	Vivienda
								                FROM  SUBCTACLASIFCART Sub
								               		WHERE Sub.ConceptoCarID	= Par_ConceptoOpera);
		        END IF;

		        SET Var_SubCuentaCL := IFNULL(Var_SubCuentaCL, Cadena_Vacia);

		        IF (Var_SubCuentaCL != Cadena_Vacia) THEN
		            SET Var_Cuenta := REPLACE(Var_Cuenta, For_Clasifica, Var_SubCuentaCL);
		        END IF;
		    END IF;

		    IF LOCATE(For_SubClasif, Var_Cuenta) > 0 THEN
		        SELECT	SubCuenta INTO Var_SubCuentaSC
					FROM  SUBCTASUBCLACART Sub
						WHERE Sub.ClasificacionID   = Par_SubClasifica
						  AND Sub.ConceptoCarID     = Par_ConceptoOpera;

		        SET Var_SubCuentaSC := IFNULL(Var_SubCuentaSC, Cadena_Vacia);

		        IF (Var_SubCuentaSC != Cadena_Vacia) THEN
		            SET Var_Cuenta := REPLACE(Var_Cuenta, For_SubClasif, Var_SubCuentaSC);
		        END IF;
		    END IF;

		   	-- SECCIÓN NOMENCLARUTA IVA CREDITO
			IF(LOCATE(For_IVAAsignado,Var_Cuenta)>0)THEN

				SET Var_Porcentaje := (SELECT IVA FROM SUCURSALES WHERE SucursalID=Par_SucCliente)*100;

				SELECT SubCuenta INTO Var_SubCuentaIA
				FROM SUBCUENTAIVACART Sub
				WHERE Sub.ConceptoCartID = Par_ConceptoOpera
				AND Sub.Porcentaje = Var_Porcentaje;

				SET Var_SubCuentaIA := IFNULL(Var_SubCuentaIA, Cadena_Vacia);

				IF(Var_SubCuentaIA!=Cadena_Vacia)THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta,For_IVAAsignado,Var_SubCuentaIA);
				END IF;
			END IF;
		END IF;

		SET Var_Cuenta := REPLACE(Var_Cuenta, '-', Cadena_Vacia);
			SET Mensaje :='Error al guardar el en DETALLEPOLIZA';
		    SET Mensaje_lugar :='DETALLEESPECIFICOPOLIZAALT';
		CALL DETALLEESPECIFICOPOLIZAALT(
			Par_Empresa,			Par_Poliza,				Par_Fecha, 				Var_CentroCostosID,	Var_Cuenta,
			Var_Instrumento,		Par_Moneda,				Par_Cargos,				Par_Abonos,			Par_Descripcion,
			Par_Referencia,			Procedimiento,			TipoInstrumentoID,		Cadena_Vacia,		Decimal_Cero,
			Cadena_Vacia,			Salida_NO, 				Par_NumErr,				Par_ErrMen,			Aud_Usuario	,
			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr > Entero_Cero)THEN
                 CALL POLIZASCANCELADASALT(
					Par_Poliza,			Aud_NumTransaccion, 	Mensaje_lugar,			Par_NumErr,				Mensaje,
					Salida_NO,			Par_NumErr,				Par_ErrMen,			Par_Empresa,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion
				);

                IF(Par_NumErr>Entero_Cero) THEN
						LEAVE ManejoErrores;
				END IF;
				DELETE FROM POLIZACONTABLE
					  WHERE	PolizaID	= Par_Poliza;
				LEAVE ManejoErrores;
			END IF;

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT('Informacion Procesada Exitosamente.');
		SET Var_Control	:= 'creditoID' ;
		SET Par_Consecutivo := Entero_Cero; /*Lo seteo en 0 por que no se setea en ningun momento*/
		SET Var_Consecutivo := CONCAT(Par_Consecutivo);

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo	AS consecutivo;
	END IF;

END TerminaStore$$
