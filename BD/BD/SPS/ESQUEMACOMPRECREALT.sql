-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMACOMPRECREALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMACOMPRECREALT`;
DELIMITER $$

CREATE PROCEDURE `ESQUEMACOMPRECREALT`(
	Par_ProductoCreditoID 	INT(11),
	Par_PermiteLiqAntici	CHAR(1),
	Par_CobraComLiqAntici	CHAR(1),
	Par_TipComLiqAntici		CHAR(1),
	Par_ComisionLiqAntici	DECIMAL(14,4),
	Par_DiasGraciaLiqAntici INT(11),

	Par_Salida    			CHAR(1),
	INOUT	Par_NumErr 		INT,
	INOUT	Par_ErrMen  	VARCHAR(350),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT(20)

	)
TerminaStore :BEGIN

	-- Declaracion de Variables
	DECLARE Var_Estatus			CHAR(2);		-- Almacena el estatus del producto de credito
	DECLARE Var_Descripcion		VARCHAR(100);	-- Almacena la descripcion del producto de credito

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia		    DATE;
	DECLARE	Decimal_Cero		DECIMAL;
	DECLARE Si_Permite			CHAR(1);
	DECLARE No_Permite			CHAR(1);
	DECLARE Salida_S			CHAR(1);
	DECLARE ProInt				CHAR(1);
	DECLARE PorSalida			CHAR(1);
	DECLARE MontoFijo			CHAR(1);
	DECLARE Estatus_Inactivo	CHAR(1);	-- Estatus Inactivo

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia			    := '1900-01-01';
	SET Decimal_Cero			:= 0.0;
	SET Si_Permite				:='S';
	SET No_Permite				:='N';
	SET Salida_S				:='S';
	SET ProInt			     	:='P';
	SET PorSalida		    	:='S';
	SET MontoFijo		    	:='M';
    SET Estatus_Inactivo		:= 'I';		 -- Estatus Inactivo

	SELECT 	Estatus,		Descripcion
	INTO 	Var_Estatus,	Var_Descripcion
	FROM PRODUCTOSCREDITO
	WHERE ProducCreditoID = Par_ProductoCreditoID;

	IF (Par_PermiteLiqAntici != Si_Permite AND Par_PermiteLiqAntici != No_Permite) THEN
			SELECT  '002' AS NumErr,
			'Valor Incorrecto para Par_PermiteLiqAntici ' AS control,
			Par_ProductoCreditoID AS consecutivo;
	LEAVE TerminaStore;

	END IF;
	IF (Par_CobraComLiqAntici != Si_Permite AND Par_CobraComLiqAntici != No_Permite) THEN
	SELECT  '003' AS NumErr,
			'Valor incorrecto Para Par_CobraComLiqAntici ' AS control,
			Par_ProductoCreditoID AS consecutivo;
	LEAVE TerminaStore;
	END IF;

	IF(NOT EXISTS(SELECT ProducCreditoID FROM PRODUCTOSCREDITO
				  WHERE ProducCreditoID = Par_ProductoCreditoID)) THEN
			SELECT '001' AS NumErr,
			 'El producto no Existe.' AS ErrMen,
			 'ProducCreditoID' AS control,
			 '0' AS consecutivo;
			LEAVE TerminaStore;
	END IF;

	IF(EXISTS(SELECT ProductoCreditoID FROM ESQUEMACOMPRECRE
				  WHERE ProductoCreditoID = Par_ProductoCreditoID)) THEN
			SELECT '005' AS NumErr,
			 'El producto ya Existe.' AS ErrMen,
			 'ProducCreditoID' AS control,
			 '0' AS consecutivo;
			LEAVE TerminaStore;
	END IF;

	IF(Var_Estatus = Estatus_Inactivo) THEN
			SELECT '006' AS NumErr,
			CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.') AS ErrMen,
			'producCreditoID' AS control,
			Par_ProductoCreditoID AS consecutivo;
			LEAVE TerminaStore;
	END IF;

	INSERT INTO ESQUEMACOMPRECRE (
		ProductoCreditoID,			PermiteLiqAntici,		CobraComLiqAntici,		TipComLiqAntici,		ComisionLiqAntici,
        DiasGraciaLiqAntici,		EmpresaID,		 		Usuario,    			FechaActual,			DireccionIP,
        ProgramaID,					Sucursal, 	       		NumTransaccion)

	VALUES (
        Par_ProductoCreditoID,	 	Par_PermiteLiqAntici,	Par_CobraComLiqAntici,	Par_TipComLiqAntici,	Par_ComisionLiqAntici,
        Par_DiasGraciaLiqAntici, 	Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
        Aud_ProgramaID,				Aud_Sucursal,		 	Aud_NumTransaccion);

	IF (Par_Salida = Salida_S) THEN
		SELECT  '000' AS NumErr,
		CONCAT('Esquema Agregado Correctamente: ') AS ErrMen,
		 'producCreditoID' AS control,
		Par_ProductoCreditoID AS consecutivo;
	ELSE
		SET	Par_NumErr := '000';
		SET	Par_ErrMen := 'producCreditoID Guardado.';
	END IF;
END TerminaStore$$