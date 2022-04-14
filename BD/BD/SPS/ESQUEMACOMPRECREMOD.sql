-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMACOMPRECREMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMACOMPRECREMOD`;
DELIMITER $$

CREATE PROCEDURE `ESQUEMACOMPRECREMOD`(
	Par_ProductoCreditoID 	INT(11),
	Par_PermiteLiqAntici	CHAR(1),
	Par_CobraComLiqAntici	CHAR(1),
	Par_TipComLiqAntici		CHAR(1),
	Par_ComisionLiqAntici	DECIMAL(14,4),
	Par_DiasGraciaLiqAntici INT(11),

	Par_Salida    		    CHAR(1),
    INOUT	Par_NumErr 	    INT,
    INOUT	Par_ErrMen  	VARCHAR(350),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT(20)

	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Estatus			CHAR(2);		-- Almacena el estatus del producto de credito
	DECLARE Var_Descripcion		VARCHAR(100);	-- Almacena la descripcion del producto de credito

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE Si_Permite		CHAR(1);
	DECLARE No_Permite		CHAR(1);
	DECLARE Salida_S		CHAR(1);
	DECLARE	Decimal_Cero	DECIMAL;
	DECLARE ProInt			CHAR(1);
	DECLARE PorSalida		CHAR(1);
	DECLARE MontoFijo		CHAR(1);
	DECLARE Estatus_Inactivo	CHAR(1);	-- Estatus Inactivo

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';			-- Cadena vaci­a
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero			:= 0;			-- Entero Cero
	SET	Si_Permite 			:= 'S';			-- Si permite
	SET No_Permite			:= 'N';         -- no permite
	SET Salida_S			:='S';
	SET Decimal_Cero		:=0.0;
	SET ProInt			     	:='P';
	SET PorSalida		    	:='S';
	SET MontoFijo		    	:='M';
	SET Estatus_Inactivo		:= 'I';		 -- Estatus Inactivo

	SELECT 	Estatus,		Descripcion
	INTO 	Var_Estatus,	Var_Descripcion
	FROM PRODUCTOSCREDITO
	WHERE ProducCreditoID = Par_ProductoCreditoID;

	IF (Par_PermiteLiqAntici != Si_Permite AND Par_PermiteLiqAntici != No_Permite) THEN
		SELECT  '001' AS NumErr,
		'Valor Incorrecto para Par_PermiteLiqAntici ' AS control,
		Par_ProductoCreditoID AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	IF (Par_CobraComLiqAntici != Si_Permite AND Par_CobraComLiqAntici != No_Permite ) THEN
		SELECT  '002' AS NumErr,
		'Valor incorrecto Para Par_CobraComLiqAntici ' AS control,
		Par_ProductoCreditoID AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	IF(NOT EXISTS(SELECT ProducCreditoID FROM PRODUCTOSCREDITO
				  WHERE ProducCreditoID = Par_ProductoCreditoID)) THEN
		SELECT '003' AS NumErr,
		 'El producto no Existe.' AS ErrMen,
		 'ProducCreditoID' AS control,
		 '0' AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	IF(Var_Estatus = Estatus_Inactivo) THEN
		SELECT '004' AS NumErr,
		CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.') AS ErrMen,
		'producCreditoID' AS control,
		Par_ProductoCreditoID AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	SET Par_CobraComLiqAntici	:= IFNULL(Par_CobraComLiqAntici, Cadena_Vacia);
	SET Par_TipComLiqAntici		:= IFNULL(Par_TipComLiqAntici, Cadena_Vacia);

	SET Aud_FechaActual := NOW();

	UPDATE ESQUEMACOMPRECRE SET
		PermiteLiqAntici  = Par_PermiteLiqAntici,
		CobraComLiqAntici = Par_CobraComLiqAntici,
		TipComLiqAntici	  = Par_TipComLiqAntici,
		ComisionLiqAntici = Par_ComisionLiqAntici,
		DiasGraciaLiqAntici =Par_DiasGraciaLiqAntici,

		EmpresaID   = Par_EmpresaID,
		Usuario     = Aud_Usuario,
		FechaActual =Aud_FechaActual,
		DireccionIP =Aud_DireccionIP,
		ProgramaID  =Aud_ProgramaID,
		Sucursal    = Aud_Sucursal,
		NumTransaccion=Aud_NumTransaccion

	WHERE ProductoCreditoID = 	Par_ProductoCreditoID;

	IF (Par_Salida = Salida_S) THEN
	SELECT '000' AS NumErr ,
		  CONCAT('Esquema  Modificado Correctamente') AS ErrMen,
		  'producCreditoID' AS control,
		   Par_ProductoCreditoID AS consecutivo;
	ELSE
		SET	Par_NumErr := '000';
		SET	Par_ErrMen := 'producCreditoID Guardado.';
	END IF;
END TerminaStore$$