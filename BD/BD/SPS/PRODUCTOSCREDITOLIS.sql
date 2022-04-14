-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRODUCTOSCREDITOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRODUCTOSCREDITOLIS`;
DELIMITER $$

CREATE PROCEDURE `PRODUCTOSCREDITOLIS`(
	/*SP para listar los Productos de Crédito*/
	Par_Descripcion				VARCHAR(100),		-- Descripcion del Producto
	Par_NumLis					TINYINT UNSIGNED,	-- Numero de Lista
	Par_EmpresaID				INT(11),			-- Numero de Empresa
	/*Parametros de Auditoria*/
	Aud_Usuario					INT(11),			-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de Auditoria

	Aud_DireccionIP				VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal				INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE	NumErr		 	INT(11);
	DECLARE	ErrMen			VARCHAR(40);

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena vacia
	DECLARE	Fecha_Vacia			DATE;			-- fecha vacia
	DECLARE	Entero_Cero			INT(11);		-- Entero Cero
	DECLARE	Lis_Principal 		INT(11);		-- Lista principal
	DECLARE Lis_Combo 			INT(11);		-- lista de combo
	DECLARE	Lis_AltCred	 		INT(11); 		-- Lista  para la pantalla de alta de credito
	DECLARE	Lis_AltaLinea		INT(11); 		-- Lista  para la pantalla de alta de linea
	DECLARE	Lis_Rees			INT(11); 		-- Lista  que filtra el producto de credito por los que permiten reestructura
	DECLARE	Lis_ProWS			INT(11);		-- Lista del producto ws
	DECLARE	NoManejaLinea		CHAR(1);		-- no maneja linea
	DECLARE	Var_SI				CHAR(1);		-- si maneja linea
	DECLARE	Cons_NO				CHAR(1);		-- Constante No
	DECLARE Estatus_Activo		CHAR(1);		-- Estatus Activo
	DECLARE Lis_Combo2			INT(11);		-- lista para combo
	DECLARE Lis_ProductosGrupal	INT(11);		-- Lista productos Grupales
	DECLARE Lis_ProductosInd	INT(11);		-- Lista productos Individuales
	DECLARE Lis_ProductosAgro	INT(11);		-- Lista productos Grupales
	DECLARE Lis_ComboGarLiquida	INT(11);		-- Lista Combo de Garantia Liquida
	DECLARE Lis_TodosCombo		INT(11);		-- Lista Combo de Garantia Liquida
    DECLARE Var_LisComboNom		INT(11);		-- Lista Combo de Productos Creditos Nomina
	DECLARE Lis_ProductoConsolidado	INT(11);	-- Lista Productos de creditos consolidados.
    DECLARE	Lis_ProductosActivos 	INT(11);	-- Lista de Productos de Creditos Activos
    DECLARE	Lis_ComboProducActivos	INT(11);	-- Lista Combo de Productos de Creditos Activos
	DECLARE Lis_ProductosIndActivos	INT(11);	-- Lista productos Individuales Activos

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Lis_Principal		:= 1;
	SET Lis_Combo 			:= 2;
	SET	Lis_AltCred 		:= 3;
	SET	Lis_AltaLinea 		:= 4;
	SET	Lis_Rees			:= 5;
	SET	Lis_ProWS			:= 6;
	SET	NoManejaLinea 		:= 'N';
	SET	Var_SI				:= 'S';
	SET Cons_NO				:= 'N';
	SET Estatus_Activo		:= 'A';
	SET Lis_Combo2			:= 7;
	SET Lis_ProductosGrupal	:= 8;
	SET Lis_ProductosInd	:= 9;
	SET Lis_ProductosAgro	:= 10;
	SET Lis_ComboGarLiquida	:= 11;
	SET Lis_TodosCombo		:= 13;
    SET Var_LisComboNom		:= 12;
	SET Lis_ProductoConsolidado	:= 14;
    SET Lis_ProductosActivos	:= 15;
	SET Lis_ComboProducActivos	:= 16;
    SET Lis_ProductosIndActivos	:= 17;

	IF(Par_NumLis = Lis_Principal) THEN 	 /* Lista Principal */
		SELECT	`ProducCreditoID`,		`Descripcion`
		FROM PRODUCTOSCREDITO
		WHERE  Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
			AND  EsAgropecuario = Cons_NO
		LIMIT 0, 15;
	END IF;

	/*  Lista para mostar en un combo */
	IF(Par_NumLis = Lis_Combo) THEN
		SELECT	ProducCreditoID,CONCAT(CONVERT(ProducCreditoID,CHAR),' ',Descripcion) AS Descripcion
		FROM PRODUCTOSCREDITO
		WHERE EsAgropecuario = Cons_NO;
	END IF;

	/*  Lista para mostar en un combo */
	IF(Par_NumLis = Lis_TodosCombo) THEN
		SELECT	ProducCreditoID,CONCAT(CONVERT(ProducCreditoID,CHAR),' ',Descripcion) AS Descripcion
		FROM PRODUCTOSCREDITO;
	END IF;


	/*  Lista para mostar en un combo (pero en la descripcion no lleva su ID) */
	IF(Par_NumLis = Lis_Combo2) THEN
			SELECT	`ProducCreditoID`,		Descripcion
			FROM PRODUCTOSCREDITO
			 ORDER BY Descripcion;
	END IF;


	 /* Lista para pantalla de alta de credito */
	IF(Par_NumLis = Lis_AltCred) THEN
		SELECT	`ProducCreditoID`,		`Descripcion`
		FROM PRODUCTOSCREDITO
		WHERE  Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
	 	AND	ManejaLinea = NoManejaLinea
		LIMIT 0, 15;
	END IF;


	 /* Lista para pantalla de alta de linea de credito */
	IF(Par_NumLis = Lis_AltaLinea) THEN
		SELECT	`ProducCreditoID`,		`Descripcion`
		FROM PRODUCTOSCREDITO
		WHERE  Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
	 	AND	ManejaLinea = Var_SI
		LIMIT 0, 15;
	END IF;

	/* Lista que filtra los productos de creditos que aceptan reestructua*/
	IF(Par_NumLis = Lis_Rees) THEN
		SELECT	`ProducCreditoID`,		`Descripcion`
		FROM PRODUCTOSCREDITO
		WHERE  Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		AND  EsReestructura = Var_SI
		LIMIT 0, 15;
	END IF;

	IF(Par_NumLis = Lis_ProWS) THEN 	 /* Lista Producto Credito WS */
	    IF(IFNULL(Par_Descripcion, Cadena_Vacia))= Cadena_Vacia THEN
			 SET 	NumErr := '001';
			 SET 	ErrMen := 'La Descripcion esta vacia.';
			 SELECT 	Entero_Cero,		Cadena_Vacia,   NumErr,  ErrMen;
		 ELSE
			 SET 	NumErr := '000';
			 SET 	ErrMen := 'Consulta Exitosa';
		    SELECT	`ProducCreditoID`,		`Descripcion` ,   NumErr,  ErrMen
		    FROM PRODUCTOSCREDITO
		    WHERE  Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		 LIMIT 0, 15;
	    END IF;
	END IF;

	/*8.- Lista Productos de Creditos Grupales */
	IF(Par_NumLis = Lis_ProductosGrupal) THEN
		SELECT	`ProducCreditoID`,		`Descripcion`
		FROM PRODUCTOSCREDITO
		WHERE  Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		AND  EsGrupal = Var_SI
		LIMIT 0, 15;
	END IF;

	/*9.- Lista Productos de Creditos Individuales */
	IF(Par_NumLis = Lis_ProductosInd) THEN
		SELECT	`ProducCreditoID`,		`Descripcion`
		FROM PRODUCTOSCREDITO
		WHERE  Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		AND  EsGrupal = Cons_NO
		LIMIT 0, 15;
	END IF;

	/*10.- Lista de Productos Agropecuarios*/
	IF(Par_NumLis = Lis_ProductosAgro) THEN
		SELECT	ProducCreditoID,CONCAT(CONVERT(ProducCreditoID,CHAR),' ',Descripcion) AS Descripcion
			FROM PRODUCTOSCREDITO
				WHERE  Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
					AND  EsAgropecuario = Var_SI
					LIMIT 0, 15;
	END IF;

	/*  Lista para mostar en garantia Liquida */
	IF(Par_NumLis = Lis_ComboGarLiquida) THEN
		SELECT	ProducCreditoID,CONCAT(CONVERT(ProducCreditoID,CHAR),' ',Descripcion) AS Descripcion
		FROM PRODUCTOSCREDITO;
	END IF;

    IF(Par_NumLis = Var_LisComboNom) THEN
		SELECT ProducCreditoID, 	Descripcion
			FROM PRODUCTOSCREDITO
			WHERE ProductoNomina = Var_SI;
	END IF;

	IF( Par_NumLis = Lis_ProductoConsolidado ) THEN
		SELECT	ProducCreditoID,		Descripcion
		FROM PRODUCTOSCREDITO
		WHERE Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		  AND EsAgropecuario = Var_SI
		  AND ReqConsolidacionAgro = Var_SI
		LIMIT 0, 15;

	END IF;

	-- 15.- Lista de Productos de Creditos Activos
    IF(Par_NumLis = Lis_ProductosActivos) THEN
		SELECT	`ProducCreditoID`,		`Descripcion`
		FROM PRODUCTOSCREDITO
		WHERE  Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
			AND  EsAgropecuario = Cons_NO
			AND Estatus = Estatus_Activo
		LIMIT 0, 15;
	END IF;

    -- 16.- Lista Combo de Productos de Creditos Activos
	IF(Par_NumLis = Lis_ComboProducActivos) THEN
		SELECT	ProducCreditoID,CONCAT(CONVERT(ProducCreditoID,CHAR),' ',Descripcion) AS Descripcion
		FROM PRODUCTOSCREDITO
        WHERE Estatus = Estatus_Activo;
	END IF;

    	/*17.- Lista Productos de Creditos Individuales Activos */
	IF(Par_NumLis = Lis_ProductosIndActivos) THEN
		SELECT	`ProducCreditoID`,		`Descripcion`
		FROM PRODUCTOSCREDITO
		WHERE  Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		AND  EsGrupal = Cons_NO
        AND Estatus = Estatus_Activo
		LIMIT 0, 15;
	END IF;

END TerminaStore$$