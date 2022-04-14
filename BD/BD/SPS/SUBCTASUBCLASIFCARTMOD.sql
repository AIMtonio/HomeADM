-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTASUBCLASIFCARTMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTASUBCLASIFCARTMOD`;DELIMITER $$

CREATE PROCEDURE `SUBCTASUBCLASIFCARTMOD`(



	Par_ConceptoCarID	INT(11),
	Par_ProducCreditoID	INT(11),
	Par_SubCuenta	 	CHAR(6),

	Aud_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT;
	DECLARE	Float_Cero			DECIMAL(4,2);

	SET	Cadena_Vacia		:= '';
	SET	Entero_Cero			:= 0;
	SET	Float_Cero			:= 0.0;


	IF(IFNULL(Par_ConceptoCarID, Entero_Cero))= Entero_Cero THEN
		SELECT '001' AS NumErr,
			 'El Concepto esta Vacio.' AS ErrMen,
			 'conceptoCarID' AS control;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_ProducCreditoID, Entero_Cero))= Entero_Cero THEN
		SELECT '002' AS NumErr,
			 'El Producto esta Vacio.' AS ErrMen,
			 'producCreditoID5' AS control;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Aud_EmpresaID, Entero_Cero))= Entero_Cero THEN
		SELECT '003' AS NumErr,
			 'El Numero de Empresa esta Vacio.' AS ErrMen,
			 'empresaID' AS control;
		LEAVE TerminaStore;
	END IF;

	SET Par_SubCuenta	:= IFNULL(Par_SubCuenta,Cadena_Vacia);
	IF(Par_SubCuenta = Cadena_Vacia) THEN
		SELECT '005' AS NumErr,
			 'La SubCuenta esta Vacia.' AS ErrMen,
			 'subCuenta5' AS control;
		LEAVE TerminaStore;
	END IF;

	IF NOT EXISTS (SELECT ConceptoCarID,ClasificacionID FROM SUBCTASUBCLACART
					WHERE ConceptoCarID=Par_ConceptoCarID
						AND  ClasificacionID = Par_ProducCreditoID) THEN
				SELECT '004' AS NumErr,
					'La SubCuenta no se ha Agregado.' AS ErrMen,
					'ProductoCreditoID5' AS control;
				LEAVE TerminaStore;
	END IF;

	Set Aud_FechaActual := NOW();

	UPDATE SUBCTASUBCLACART SET
			ConceptoCarID	= Par_ConceptoCarID,
			ClasificacionID	= Par_ProducCreditoID,
			SubCuenta		= Par_SubCuenta	,

			EmpresaID		= Aud_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE  ConceptoCarID = Par_ConceptoCarID
			AND ClasificacionID	= Par_ProducCreditoID;

	SELECT '000' AS NumErr ,
		  CONCAT("Subcuenta Modificada Exitosamente: ",
				CONVERT(Par_ConceptoCarID, CHAR))  AS ErrMen,
		  'subCuenta5' AS control;
END TerminaStore$$