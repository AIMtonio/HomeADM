-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FN_CARCONTAVAR
DELIMITER ;
DROP FUNCTION IF EXISTS `FN_CARCONTAVAR`;
DELIMITER $$
-- FN función para generar la cuenta contable con fondeador
CREATE FUNCTION `FN_CARCONTAVAR`(
	Par_CreditoID 				BIGINT(12),
	Par_ConceptoOpera 			INT(11),
	Par_TipoSubCta				CHAR(3),
	Par_ValSubCta				VARCHAR(100),
	SucursalOrigenID			INT(11)
) RETURNS VARCHAR(50) CHARSET latin1 DETERMINISTIC
BEGIN
	/* Declaracion de Variables */
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
	DECLARE Var_SubCuentaSC		VARCHAR(6);
	DECLARE Var_SubCuentaCL		VARCHAR(5);
	DECLARE Var_Porcentaje 		DECIMAL(12,4); 	-- Variable para el porcentaje asignado
	DECLARE Var_SubCuentaIA		CHAR(2);		-- Variable SubCuenta IVA Asignado
	DECLARE Var_SucCliente		INT(11);		-- Sucursal origen del Cliente
	DECLARE Var_ProdCreditoID	INT(11);		-- ID del Producto de Credito
	DECLARE Var_MonedaID		INT(11);		-- ID de la Moneda
	DECLARE Var_Clasificacion	CHAR(1);		-- Clasificacion del Destino de Credito
	DECLARE Var_SubClasifica 	INT(11);		-- SubClasificacion del Destino de Credito

	/* Declaracion de Constantes */
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Decimal_Cero		DECIMAL(12,2);
	DECLARE	Cuenta_Vacia		CHAR(25);
	DECLARE For_CueMayor 		CHAR(3);
	DECLARE For_TipProduc 		CHAR(3);
	DECLARE For_TipCartera 		CHAR(3);
	DECLARE For_Clasifica 		CHAR(3);
	DECLARE For_SubClasif 		CHAR(3);
	DECLARE For_Moneda 			CHAR(3);
	DECLARE For_Fondeador		CHAR(3);
	DECLARE Var_SubCuentaFD		VARCHAR(5); -- Sub cuenta fondeador
	DECLARE	For_SucOrigen		CHAR(3);
	DECLARE	For_SucCliente		CHAR(3);
	DECLARE	Cla_Comercial		CHAR(1);
	DECLARE	Cla_Consumo			CHAR(1);
	DECLARE	Cla_Vivienda		CHAR(1);
	DECLARE	Tip_Capital			CHAR(1);
	DECLARE	Tip_Interes			CHAR(1);
	DECLARE	Salida_NO			CHAR(1);
	DECLARE	Procedimiento		VARCHAR(20);
	DECLARE TipoInstrumentoID	INT(11);
	DECLARE Var_InstitFondeoID	INT(11);
	DECLARE	Var_Consecutivo		VARCHAR(20);
	DECLARE Var_Control			VARCHAR(100);	-- Variable de control
    DECLARE Salida_SI			CHAR(1);
    DECLARE For_IVAAsignado		CHAR(3);		-- Constante Nomenclatura SubCuenta IVA Asignado

 	/* Asignacion de Constantes */
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Cuenta_Vacia		:= '0000000000000000000000000';
	SET Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.0;
	SET For_CueMayor 		:= '&CM'; -- Nomenclatura por Cuenta de Mayor
	SET For_TipProduc 		:= '&TP'; -- Nomenclatura por Tipo de Credito
	SET For_Clasifica 		:= '&CL'; -- Nomenclatura por Clasificacion
	SET For_SubClasif 		:= '&SC'; -- Nomenclatura por SubClasificacion
	SET For_Moneda 			:= '&TM'; -- Nomenclatura por Moneda
	SET	For_Fondeador		:= '&FD';
	SET For_SucOrigen		:= '&SO';
	SET For_SucCliente		:= '&SC';
	SET For_IVAAsignado		:= '&IA'; -- Nomenclatura IVA Asignado
	SET Cla_Comercial		:= 'C';
	SET Cla_Consumo			:= 'O';
	SET Cla_Vivienda		:= 'H';
	SET Salida_NO			:= 'N';
	SET	Procedimiento		:= 'POLIZACREDITOPRO';
	SET TipoInstrumentoID	:= 11;	-- Tipo de Instrumento CREDITO

	-- Inicializacion
	SET	Var_Cuenta			:= '0000000000000000000000000';
	SET Var_Instrumento 	:= CONVERT(Par_CreditoID, CHAR);
	SET Var_CentroCostosID	:= 0;
	SET Salida_SI			:= 'S';


	SELECT		Nomenclatura, 		Cuenta, 			NomenclaturaCR 
		INTO 	Var_Nomenclatura, 	Var_CuentaMayor, 	Var_NomenclaturaCR
		FROM CUENTASMAYORCAR Ctm
		WHERE Ctm.ConceptoCarID	= Par_ConceptoOpera;

	SET Var_Nomenclatura := IFNULL(Var_Nomenclatura, Cadena_Vacia);
	SET Var_NomenclaturaCR := IFNULL(Var_NomenclaturaCR, Cadena_Vacia);

	SELECT 		CRE.InstitFondeoID,		CLI.SucursalOrigen,		CRE.ProductoCreditoID,	CRE.MonedaID,		CRE.ClasiDestinCred,
				DES.SubClasifID
		INTO 	Var_InstitFondeoID,		Var_SucCliente,			Var_ProdCreditoID,		Var_MonedaID,		Var_Clasificacion,
				Var_SubClasifica
		FROM CREDITOS CRE
		INNER JOIN CLIENTES CLI ON CLI.ClienteID = CRE.ClienteID
		INNER JOIN DESTINOSCREDITO DES ON CRE.DestinoCreID = DES.DestinoCreID
		WHERE CreditoID	= Par_CreditoID;

	SET Var_InstitFondeoID := IFNULL(Var_InstitFondeoID,Entero_Cero);

		
	

	IF(Var_Nomenclatura = Cadena_Vacia) THEN
		SET Var_Cuenta := Cuenta_Vacia;
	ELSE
		SET Var_Cuenta	:= Var_Nomenclatura;
		IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0 THEN
			SET Var_NomenclaturaSC := Var_SucCliente;
			SET Var_NomenclaturaSC = IFNULL(Var_NomenclaturaSC, Entero_Cero);

			IF (Var_NomenclaturaSC != Entero_Cero) THEN
				SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
			END IF;
		ELSE
			IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0 THEN
				SET Var_NomenclaturaSO := SucursalOrigenID;

				IF (Var_NomenclaturaSO != Entero_Cero) THEN
					SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
				END IF;
			ELSE
            	SET Var_CentroCostosID:=FNCENTROCOSTOS(SucursalOrigenID);
			END IF;
		END IF;

		IF LOCATE(For_CueMayor, Var_Cuenta) > 0 THEN
			SET Var_Cuenta := REPLACE(Var_Cuenta, For_CueMayor, Var_CuentaMayor);
		END IF;

		IF LOCATE(For_TipProduc, Var_Cuenta) > 0 THEN
			SELECT SubCuenta INTO Var_SubCuentaTP
				FROM SUBCTAPRODUCCART
				WHERE ProducCreditoID	= Var_ProdCreditoID
				 AND ConceptoCarID		= Par_ConceptoOpera;
			SET Var_SubCuentaTP := IFNULL(Var_SubCuentaTP, Cadena_Vacia);

			IF (Var_SubCuentaTP != Cadena_Vacia) THEN
				SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipProduc, Var_SubCuentaTP);
			END IF;
		END IF;

		IF LOCATE(For_Moneda, Var_Cuenta) > 0 THEN
			SELECT	SubCuenta INTO Var_SubCuentaTM
				FROM SUBCTAMONEDACART Sub
				WHERE Sub.MonedaID		= Var_Moneda
				 AND Sub.ConceptoCarID	= Par_ConceptoOpera;

			SET Var_SubCuentaTM := IFNULL(Var_SubCuentaTM, Cadena_Vacia);

			IF (Var_SubCuentaTM != Cadena_Vacia) THEN
				SET Var_Cuenta := REPLACE(Var_Cuenta, For_Moneda, Var_SubCuentaTM);
			END IF;
		END IF;
		-- --------------------------SUBCUENTA POR FONDEADOR
		IF LOCATE(For_Fondeador, Var_Cuenta) > 0 THEN
			-- Reemplazamos el valor para subcuenta fondeador
			IF(Par_TipoSubCta = For_Fondeador AND Par_ValSubCta IS NOT NULL) THEN
				SET Var_InstitFondeoID := CONVERT(Par_ValSubCta, SIGNED INTEGER);
			END IF;

			SELECT		SubCuenta 
				INTO 	Var_SubCuentaFD
				FROM SUBCTAFONDEADORCART Sub
				WHERE Sub.InstitutFondID= Var_InstitFondeoID
				AND Sub.ConceptoCarID	= Par_ConceptoOpera;

			SET Var_SubCuentaFD := IFNULL(Var_SubCuentaFD, Cadena_Vacia);
			IF (Var_SubCuentaFD != Cadena_Vacia) THEN
				SET Var_Cuenta := REPLACE(Var_Cuenta, For_Fondeador, Var_SubCuentaFD);
			END IF;
		END IF;


		IF LOCATE(For_Clasifica, Var_Cuenta) > 0 THEN
			IF Var_Clasificacion = Cla_Comercial THEN
				SELECT	Comercial INTO Var_SubCuentaCL
					FROM SUBCTACLASIFCART Sub
						WHERE Sub.ConceptoCarID	= Par_ConceptoOpera;

			ELSEIF Var_Clasificacion = Cla_Consumo THEN
				SELECT	Consumo INTO Var_SubCuentaCL
					FROM SUBCTACLASIFCART Sub
						WHERE Sub.ConceptoCarID	= Par_ConceptoOpera;

			ELSEIF Var_Clasificacion = Cla_Vivienda THEN
				SELECT	Vivienda INTO Var_SubCuentaCL
					FROM SUBCTACLASIFCART Sub
					WHERE Sub.ConceptoCarID	= Par_ConceptoOpera;

			END IF;

			SET Var_SubCuentaCL := IFNULL(Var_SubCuentaCL, Cadena_Vacia);

			IF (Var_SubCuentaCL != Cadena_Vacia) THEN
				SET Var_Cuenta := REPLACE(Var_Cuenta, For_Clasifica, Var_SubCuentaCL);
			END IF;
		END IF;

		-- Nomenclatura por SubClasificacion (Quirografario, Refaccionario, Credito Puente, etc)
		IF LOCATE(For_SubClasif, Var_Cuenta) > 0 THEN
			SELECT	SubCuenta INTO Var_SubCuentaSC
				FROM SUBCTASUBCLACART Sub
				WHERE Sub.ClasificacionID = Var_SubClasifica
				 AND Sub.ConceptoCarID = Par_ConceptoOpera;

			SET Var_SubCuentaSC := IFNULL(Var_SubCuentaSC, Cadena_Vacia);

			IF (Var_SubCuentaSC != Cadena_Vacia) THEN
				SET Var_Cuenta := REPLACE(Var_Cuenta, For_SubClasif, Var_SubCuentaSC);
			END IF;
		END IF;

		-- SECCIÓN NOMENCLARUTA IVA CREDITO
		IF(LOCATE(For_IVAAsignado,Var_Cuenta)>0)THEN

			SET Var_Porcentaje := (SELECT IVA FROM SUCURSALES WHERE SucursalID=Var_SucCliente)*100;

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

	RETURN Var_Cuenta;
END$$