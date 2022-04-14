-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRODCREDITOWSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRODCREDITOWSCON`;DELIMITER $$

CREATE PROCEDURE `PRODCREDITOWSCON`(

	Par_ProductoCreditoID	INT(11),
	Par_InstitNominaID		INT(11),
	Par_SucursalID			INT(11),
	Par_TipoConsulta		TINYINT UNSIGNED,

	Aud_EmpresaID			INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN


DECLARE	Var_CodigoResp		INT(11);
DECLARE	Var_MensajeResp		VARCHAR(100);
DECLARE Var_ProducCreditoID	INT(11);
DECLARE Var_TipoComXapert	CHAR(1);
DECLARE Var_MontoComXapert	DECIMAL(12,2);
DECLARE Var_TasaFija		DECIMAL(12,4);
DECLARE Var_MontoInferior	DECIMAL(12,2);
DECLARE Var_MontoSuperior	DECIMAL(12,2);
DECLARE Var_Frecuencias		VARCHAR(200);
DECLARE Var_PlazoID			VARCHAR(750);


DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Decimal_Cero	DECIMAL(12,2);
DECLARE	Con_Principal	INT;
DECLARE	MinimoCreditos	INT;


SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Decimal_Cero		:= 0.0;
SET	Con_Principal		:= 2;
SET	MinimoCreditos		:= 1;


SET Var_CodigoResp 		:= 0;
SET Var_MensajeResp		:= 'Consulta Exitosa.';

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Var_CodigoResp	:= 999;
			SET Var_MensajeResp := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PRODCREDITOWSCON');
		END;
	IF(IFNULL(Par_ProductoCreditoID,Entero_Cero)=Entero_Cero)THEN
		SET Var_CodigoResp	:= 01;
		SET Var_MensajeResp	:= 'El Producto de Credito esta vacio.';
		LEAVE ManejoErrores;
	END IF;

	IF(NOT EXISTS(SELECT P.ProducCreditoID FROM PRODUCTOSCREDITO P
			WHERE P.ProducCreditoID = IFNULL(Par_ProductoCreditoID,Entero_Cero)))THEN
		SET Var_CodigoResp	:= 02;
		SET Var_MensajeResp	:= 'El Producto de Credito No Existe.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_InstitNominaID,Entero_Cero)!=Entero_Cero AND IFNULL(Par_SucursalID,Entero_Cero)!=Entero_Cero)THEN
		SET Var_CodigoResp	:= 03;
		SET Var_MensajeResp	:= 'Especificar Empresa o Sucursal, No Ambos.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_InstitNominaID,Entero_Cero)=Entero_Cero AND IFNULL(Par_SucursalID,Entero_Cero)=Entero_Cero)THEN
		SET Var_CodigoResp	:= 04;
		SET Var_MensajeResp	:= 'Especificar Empresa o Sucursal, Ambos estan vacios.';
		LEAVE ManejoErrores;
	END IF;

	IF(NOT EXISTS(SELECT SucursalID FROM SUCURSALES
			WHERE SucursalID = IFNULL(Par_SucursalID,Entero_Cero))
	   AND (IFNULL(Par_InstitNominaID,Entero_Cero)=Entero_Cero))THEN
		SET Var_CodigoResp	:= 05;
		SET Var_MensajeResp	:= 'La Sucursal No Existe.';
		LEAVE ManejoErrores;
	END IF;

	IF(NOT EXISTS(SELECT InstitNominaID FROM INSTITNOMINA
			WHERE InstitNominaID = IFNULL(Par_InstitNominaID,Entero_Cero))
	   AND (IFNULL(Par_SucursalID,Entero_Cero)=Entero_Cero))THEN
		SET Var_CodigoResp	:= 06;
		SET Var_MensajeResp	:= 'La Empresa No Existe.';
		LEAVE ManejoErrores;
	END IF;

    IF(IFNULL(Par_SucursalID,Entero_Cero)>Entero_Cero)THEN
		IF(NOT EXISTS(SELECT ProductoCreditoID FROM ESQUEMATASAS
				WHERE ProductoCreditoID = IFNULL(Par_ProductoCreditoID,Entero_Cero)
				AND SucursalID = Par_SucursalID AND MinCredito = MinimoCreditos))THEN
			SET Var_CodigoResp	:= 07;
			SET Var_MensajeResp	:= 'No existe un Esquema de Tasas Parametrizado.';
			LEAVE ManejoErrores;
		END IF;
	END IF;

    IF(IFNULL(Par_InstitNominaID,Entero_Cero)>Entero_Cero)THEN
		IF(NOT EXISTS(SELECT ProductoCreditoID FROM ESQUEMATASAS
				WHERE ProductoCreditoID = IFNULL(Par_ProductoCreditoID,Entero_Cero)
				AND InstitNominaID = Par_InstitNominaID AND MinCredito = MinimoCreditos))THEN
			SET Var_CodigoResp	:= 07;
			SET Var_MensajeResp	:= 'No existe un Esquema de Tasas Parametrizado.';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(NOT EXISTS(SELECT ProductoCreditoID FROM CALENDARIOPROD
			WHERE ProductoCreditoID = IFNULL(Par_ProductoCreditoID,Entero_Cero)))THEN
		SET Var_CodigoResp	:= 08;
		SET Var_MensajeResp	:= 'No existe Calendario por Producto de Credito Parametrizado.';
		LEAVE ManejoErrores;
	END IF;


	IF(Par_TipoConsulta = Con_Principal AND IFNULL(Par_SucursalID,Entero_Cero)>Entero_Cero) THEN
		SELECT
			P.ProducCreditoID,		P.TipoComXapert,	P.MontoComXapert,	E.TasaFija,		E.MontoInferior,
			E.MontoSuperior,		C.Frecuencias,		C.PlazoID
            INTO
            Var_ProducCreditoID,	Var_TipoComXapert,	Var_MontoComXapert,	Var_TasaFija,	Var_MontoInferior,
            Var_MontoSuperior,		Var_Frecuencias,	Var_PlazoID
		FROM PRODUCTOSCREDITO P
			LEFT JOIN ESQUEMATASAS E
				ON (P.ProducCreditoID=E.ProductoCreditoID AND E.SucursalID = Par_SucursalID AND E.MinCredito = MinimoCreditos)
			LEFT JOIN CALENDARIOPROD C ON (P.ProducCreditoID = C.ProductoCreditoID)
		WHERE P.ProducCreditoID = Par_ProductoCreditoID
		LIMIT 1;

	ELSEIF(Par_TipoConsulta = Con_Principal AND IFNULL(Par_InstitNominaID,Entero_Cero)>Entero_Cero) THEN
		SELECT
			P.ProducCreditoID,		P.TipoComXapert,	P.MontoComXapert,	E.TasaFija,		E.MontoInferior,
			E.MontoSuperior,		C.Frecuencias,		C.PlazoID
            INTO
            Var_ProducCreditoID,	Var_TipoComXapert,	Var_MontoComXapert,	Var_TasaFija,	Var_MontoInferior,
            Var_MontoSuperior,		Var_Frecuencias,	Var_PlazoID
		FROM PRODUCTOSCREDITO P
			LEFT JOIN ESQUEMATASAS E
				ON (P.ProducCreditoID=E.ProductoCreditoID AND E.InstitNominaID = Par_InstitNominaID AND E.MinCredito = MinimoCreditos)
			LEFT JOIN CALENDARIOPROD C ON (P.ProducCreditoID = C.ProductoCreditoID)
		WHERE P.ProducCreditoID = Par_ProductoCreditoID
		LIMIT 1;
	END IF;
END ManejoErrores;

    SET Var_ProducCreditoID	:= IFNULL(Var_ProducCreditoID,Entero_Cero);
	SET Var_TipoComXapert	:= IFNULL(Var_TipoComXapert,Cadena_Vacia);
	SET Var_MontoComXapert	:= IFNULL(Var_MontoComXapert,Decimal_Cero);
	SET Var_TasaFija		:= IFNULL(Var_TasaFija,Decimal_Cero);
	SET Var_MontoInferior	:= IFNULL(Var_MontoInferior,Decimal_Cero);
	SET Var_MontoSuperior	:= IFNULL(Var_MontoSuperior,Decimal_Cero);
	SET Var_Frecuencias		:= IFNULL(Var_Frecuencias,Cadena_Vacia);
	SET Var_PlazoID			:= IFNULL(Var_PlazoID,Cadena_Vacia);


	SELECT
		Var_CodigoResp AS CodigoRespuesta,		Var_MensajeResp AS MensajeRespuesta,
		Var_ProducCreditoID AS ProducCreditoID,	Var_TipoComXapert AS TipoComXapert,
        Var_MontoComXapert AS MontoComXapert,	Var_TasaFija AS TasaFija,
        Var_MontoInferior AS MontoInferior,		Var_MontoSuperior AS MontoSuperior,
        Var_Frecuencias AS Frecuencias,			Var_PlazoID AS PlazoID;
END TerminaStore$$